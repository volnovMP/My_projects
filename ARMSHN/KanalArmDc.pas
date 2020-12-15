unit KanalArmDc;
{$INCLUDE d:\sapr_new\CfgProject}
//****************************************************************************
//       Процедуры работы с каналом ДЦ - РМ ДСП
//****************************************************************************


interface

uses
  Windows,
  Dialogs,
  SysUtils,
  Controls,
  Classes,
  Messages,
  Graphics,
  Forms,
  StdCtrls,
  Registry,
  SyncObjs,
  comport,
  KanalArmSrvSHN;

type TKanalDC = record
    State   : Byte;
    config  : string;
    Index   : Byte;
    port    : TComPort;
    active  : Boolean;
    hPipe   : THandle;
    rcvsoob : string;   // массив полученых данных
    RcvBuf  : array[0..4095] of char;
    RcvPtr  : word;     // указатель на конец принятой строки
    isrcv   : boolean;
    issync  : boolean;
    iserror : boolean;
    cnterr  : integer;
    rcvcnt  : integer; // счетчик количества принятых символов
    trmcnt  : integer; // счетчик количества переданых символов
    pktcnt  : integer; // счетчик количества принятых пакетов
    tpkcnt  : integer; // счетчик количества передаых пакетов
    lastcnt : integer; // счетчик количества принятых байт при последнем чтении канала
    lostcnt : integer; // счетчик количества перебоев приема данных из канала
  end;

const
  LnSoobDC     = 11;    // длина сообщения для ЛП-ДЦ
  LnSoobKvitDC = 6;     // длина квитанции из ЛП-ДЦ
  LIMIT_DC  = 80;

var
  CurrDCSoob : integer; // последнее циклически переданное сообщение в канал ДЦ
  LastDC     : array[1..2] of Byte; // Номер запрашивающего ЛП-ДЦ

//------------------------------------------------------------------------------
//                  Массив датчиков из канала ЛП-ДЦ - АРМ
//------------------------------------------------------------------------------
var
  FR3dc  : array[1..LIMIT_DC,1..5] of Byte; // буфер состояний датчиков для ЛП-ДЦ
  FR3dcn : array[1..LIMIT_DC] of boolean;   // буфер новизны состояний объектов в канале ЛП-ДЦ


var
  KanalDC  : array[1..2] of TKanalDC;

function CreateKanalDC : Boolean;                // Создать экземпляры класса TComPort
function DestroyKanalDC : Boolean;               // Деструктор структур канала
function GetKanalDCStatus(kanal : Byte) : Byte;  // Получить состояние канала
function InitKanalDC(kanal : Byte) : Byte;       // Инициализация канала
function ConnectKanalDC(kanal : Byte) : Byte;    // Установить связь по каналу
function DisconnectKanalDC(kanal : Byte) : Byte; // Разрыв связи по каналу

function SyncDCReady : Boolean;
function GetFR3dc(const param : Word) : Boolean;
function ReadSoobDC(kanal: Byte; var rcv: string) : Integer; // Процедура цикла чтения канала COM-ports
procedure WriteSoobDC(kanal: Byte);                   // Процедура передачи в канал COM-ports
procedure ExtractSoobDC(kanal : Byte); // распаковка сообщений из сервера
procedure FixStatKanalDC(kanal : byte); // Сохранить в файле протокола статистику работы канала

implementation

uses
  TabloSHN,
  crccalc,
  commands,
  commons,
  mainloop,
  marshrut,
  TypeALL;

var
WrBuffer    : array[0..10] of char; // буфер записи
sz          : string;
stime       : string;


//-----------------------------------------------------------------------------
// Создать экземпляры класса TComPort
function CreateKanalDC : Boolean;
begin
  try
    if KanalDC[1].Index > 0 then KanalDC[1].port := TComPort.Create(nil);
    if KanalDC[2].Index > 0 then KanalDC[2].port := TComPort.Create(nil);
    result := true;
  except
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// Деструктор структур канала
function DestroyKanalDC : Boolean;
begin
  try
    if Assigned(KanalDC[1].port) then KanalDC[1].port.Destroy;
    if Assigned(KanalDC[2].port) then KanalDC[2].port.Destroy;
    result := true;
  except
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// Получить состояние канала
function GetKanalDCStatus(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then result := 255 else result := 0;
end;

//-----------------------------------------------------------------------------
// Инициализация канала
function InitKanalDC(kanal : Byte) : Byte;
begin
  result := 255;
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then exit;
  if Assigned(KanalDC[kanal].port) then
  begin // СОМ-порт
    if KanalDC[kanal].port.InitPort(IntToStr(KanalDC[kanal].Index)+ ','+ KanalDC[kanal].config) then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Выполнена инициализация канала'+ IntToStr(kanal)+ ' ДЦ '+ stime);
      result := 0;
    end else
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Ошибка 254 инициализации канала'+ IntToStr(kanal)+ ' ДЦ '+ stime);
      result := 254;
    end;
  end else
    result := 253;
end;

//-----------------------------------------------------------------------------
// Установить связь по каналу
function ConnectKanalDC(kanal : Byte) : Byte;
begin
  result := 255;
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then exit;
  KanalDC[kanal].RcvPtr := 0;
  if Assigned(KanalDC[kanal].port) then
  begin // СОМ-порт
    if KanalDC[kanal].port.PortIsOpen then
    begin
      KanalDC[kanal].active := true; result := 0;
    end else
    if KanalDC[kanal].port.OpenPort then
    begin
      PurgeComm(KanalDC[kanal].port.PortHandle,PURGE_TXABORT+PURGE_RXABORT+PURGE_TXCLEAR+PURGE_RXCLEAR);
      KanalDC[kanal].active := true;
      KanalDC[kanal].hPipe := KanalDC[kanal].port.PortHandle;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Выполнено открытие коммуникационного порта канала'+ IntToStr(kanal)+ ' ДЦ '+ stime);
      result := 0;
    end else
    begin
      result := 254;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Не удается открыть коммуникационный порт канала'+ IntToStr(kanal)+ ' ДЦ '+ stime);
    end;
  end else
    result := 1;
end;

//-----------------------------------------------------------------------------
// Разрыв связи по каналу
function DisconnectKanalDC(kanal : Byte) : Byte;
begin
  result := 255;
  if (kanal < 1) or (kanal > 2) or not Assigned(KanalDC[kanal].port) then exit;
  if Assigned(KanalDC[kanal].port) then
  begin // COM-порт
    if KanalDC[kanal].port.PortIsOpen then
    begin
      if KanalDC[kanal].port.ClosePort then
      begin
        KanalDC[kanal].active := false;
        DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
        reportf('Коммуникационный порт канала'+ IntToStr(kanal)+ ' ДЦ '+ stime+ ' закрыт');
        result := 0;
      end else
        result := 253;
    end else
      result := 0;
  end else
    result := 0;
end;


//-----------------------------------------------------------------------------
// Обработка данных канального уровня, ожидание синхронизации от сервера
//var
//  FixedDisconnect : array[1..2] of Boolean;
//  FixedConnect : array[1..2] of Boolean;
//  FDT : double;


function SyncDCReady : Boolean;
  var i,j : integer; b,c : boolean; d : byte;
begin
  result := false;
  if AppStart then exit; // до окончания инициализации не обрабатывать канал АРМ-Сервер

  //
  // Обновить состояние датчиков в буфере канала ДЦ
  //
  for i := 1 to WorkMode.LimitSoobDC do
  begin
    if LinkTCDC[i].Index[1] > 0  then
    begin
      b := GetFR3dc(LinkTCDC[i].Index[1]);
      c := ((FR3dc[i,1] and  $1) = $1);
      if b <> c then FR3dcn[i] := true;
      if b then d := (FR3dc[i,1] or $1)
      else d := (FR3dc[i,1] and ($ff-$1));
      FR3dc[i,1] := d;
    end;
    if LinkTCDC[i].Index[2] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[2]);  c := ((FR3dc[i,1] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $2)  else d := (FR3dc[i,1] and ($ff-$2));  FR3dc[i,1] := d; end;
    if LinkTCDC[i].Index[3] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[3]);  c := ((FR3dc[i,1] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $4)  else d := (FR3dc[i,1] and ($ff-$4));  FR3dc[i,1] := d; end;
    if LinkTCDC[i].Index[4] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[4]);  c := ((FR3dc[i,1] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $8)  else d := (FR3dc[i,1] and ($ff-$8));  FR3dc[i,1] := d; end;
    if LinkTCDC[i].Index[5] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[5]);  c := ((FR3dc[i,1] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,1] or $10) else d := (FR3dc[i,1] and ($ff-$10)); FR3dc[i,1] := d; end;

    if LinkTCDC[i].Index[6] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[6]);  c := ((FR3dc[i,2] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $1)  else d := (FR3dc[i,2] and ($ff-$1));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[7] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[7]);  c := ((FR3dc[i,2] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $2)  else d := (FR3dc[i,2] and ($ff-$2));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[8] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[8]);  c := ((FR3dc[i,2] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $4)  else d := (FR3dc[i,2] and ($ff-$4));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[9] > 0  then begin b := GetFR3dc(LinkTCDC[i].Index[9]);  c := ((FR3dc[i,2] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $8)  else d := (FR3dc[i,2] and ($ff-$8));  FR3dc[i,2] := d; end;
    if LinkTCDC[i].Index[10] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[10]); c := ((FR3dc[i,2] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,2] or $10) else d := (FR3dc[i,2] and ($ff-$10)); FR3dc[i,2] := d; end;

    if LinkTCDC[i].Index[11] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[11]); c := ((FR3dc[i,3] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $1)  else d := (FR3dc[i,3] and ($ff-$1));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[12] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[12]); c := ((FR3dc[i,3] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $2)  else d := (FR3dc[i,3] and ($ff-$2));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[13] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[13]); c := ((FR3dc[i,3] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $4)  else d := (FR3dc[i,3] and ($ff-$4));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[14] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[14]); c := ((FR3dc[i,3] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $8)  else d := (FR3dc[i,3] and ($ff-$8));  FR3dc[i,3] := d; end;
    if LinkTCDC[i].Index[15] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[15]); c := ((FR3dc[i,3] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,3] or $10) else d := (FR3dc[i,3] and ($ff-$10)); FR3dc[i,3] := d; end;

    if LinkTCDC[i].Index[16] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[16]); c := ((FR3dc[i,4] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $1)  else d := (FR3dc[i,4] and ($ff-$1));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[17] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[17]); c := ((FR3dc[i,4] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $2)  else d := (FR3dc[i,4] and ($ff-$2));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[18] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[18]); c := ((FR3dc[i,4] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $4)  else d := (FR3dc[i,4] and ($ff-$4));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[19] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[19]); c := ((FR3dc[i,4] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $8)  else d := (FR3dc[i,4] and ($ff-$8));  FR3dc[i,4] := d; end;
    if LinkTCDC[i].Index[20] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[20]); c := ((FR3dc[i,4] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,4] or $10) else d := (FR3dc[i,4] and ($ff-$10)); FR3dc[i,4] := d; end;

    if LinkTCDC[i].Index[21] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[21]); c := ((FR3dc[i,5] and  $1) = $1);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $1)  else d := (FR3dc[i,5] and ($ff-$1));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[22] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[22]); c := ((FR3dc[i,5] and  $2) = $2);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $2)  else d := (FR3dc[i,5] and ($ff-$2));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[23] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[23]); c := ((FR3dc[i,5] and  $4) = $4);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $4)  else d := (FR3dc[i,5] and ($ff-$4));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[24] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[24]); c := ((FR3dc[i,5] and  $8) = $8);  if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $8)  else d := (FR3dc[i,5] and ($ff-$8));  FR3dc[i,5] := d; end;
    if LinkTCDC[i].Index[25] > 0 then begin b := GetFR3dc(LinkTCDC[i].Index[25]); c := ((FR3dc[i,5] and $10) = $10); if b <> c then FR3dcn[i] := true; if b then d := (FR3dc[i,5] or $10) else d := (FR3dc[i,5] and ($ff-$10)); FR3dc[i,5] := d; end;
  end;

//
// Для проверки правильности упаковки данных в канале ТС ДЦ
{  for i := 1 to WorkMode.LimitSoobDC do
    if FR3dcn[i] then
    begin
      sz := DateTimeToStr(Date+Time)+ ' > '+ LinkTCDC[i].Group+ ' '+ LinkTCDC[i].SGroup + '  '+ IntToHex(FR3dc[i,1],2)+ ' '+ IntToHex(FR3dc[i,2],2)+ ' '+ IntToHex(FR3dc[i,3],2)+ ' '+ IntToHex(FR3dc[i,4],2)+ ' '+ IntToHex(FR3dc[i,5],2);
      reportf(sz);
      FR3dcn[i] := false;
    end;}


  WrBuffer[0] := '(';
  WrBuffer[1] := 'A';
  WrBuffer[2] := LinkTCDC[CurrDCSoob].Group;
  WrBuffer[3] := LinkTCDC[CurrDCSoob].SGroup;
  WrBuffer[4] := char(FR3dc[CurrDCSoob,1] or $40);
  WrBuffer[5] := char(FR3dc[CurrDCSoob,2] or $40);
  WrBuffer[6] := char(FR3dc[CurrDCSoob,3] or $40);
  WrBuffer[7] := char(FR3dc[CurrDCSoob,4] or $40);
  WrBuffer[8] := char(FR3dc[CurrDCSoob,5] or $40);
  d := (byte(WrBuffer[1]) xor byte(WrBuffer[2]) xor byte(WrBuffer[3]) xor byte(WrBuffer[4]) xor byte(WrBuffer[5]) xor byte(WrBuffer[6]) xor byte(WrBuffer[7]) xor byte(WrBuffer[8])) or $40;
  WrBuffer[9] := char(d);
  WrBuffer[10] := ')';


  // перевести указатель на следующее сообщение при циклической передаче
  if CurrDCSoob >= WorkMode.LimitSoobDC then CurrDCSoob := 1 else inc(CurrDCSoob);

  //
  // Для обмена с ЛП-ДЦ используются два канала RS-422 в дуплексном режиме.
  // Каналы не имеют приоритета, используются по готовности данных.
  //
  if KanalDC[1].active then
  begin
    WriteSoobDC(1); // выдать в 1-ый канал данные
    i := ReadSoobDC(1,sz);
    KanalDC[1].lastcnt := i;
    KanalDC[1].rcvcnt := KanalDC[1].rcvcnt + i;
    if i > 0 then // прочитать данные из канала1
    begin
{      if not FixedConnect[1] then
      begin // зафиксировать восстановление связи с сервером
        AddFixMessage(GetShortMsg(1,434,'1'),5,0); InsArcNewMsg(0,434+$2000);
      end;
      FixedConnect[1] := true;}
      if i >= 70 then begin inc(KanalDC[1].cnterr); KanalDC[1].lostcnt := 0; end;
      KanalDC[1].isrcv := true;  //???????????????????????????????????????????????????????
      if KanalDC[1].RcvPtr < 140 then KanalDC[1].iserror := false;
      if (i + KanalDC[1].RcvPtr) > sizeof(KanalDC[1].RcvBuf) then i := 0;
      for j := 0 to i-1 do begin KanalDC[1].RcvBuf[KanalDC[1].RcvPtr] := KanalDC[1].port.Buffer[j]; inc(KanalDC[1].RcvPtr); end;
      if KanalDC[1].RcvPtr > LnSoobSrv * 3 then
      begin
        inc(KanalDC[1].cnterr); // увеличить счетчик ошибок канала
        reportf('Переполнение входного буфера канала 1 ДЦ ('+ IntToStr(KanalDC[1].RcvPtr)+' байт) '+ DateTimeToStr(LastTime));
        KanalDC[1].RcvPtr := 0;
      end else
        ExtractSoobDC(1); // распаковка данных из 1-го канала
    end;
  end;

  if KanalDC[2].active then
  begin
    WriteSoobDC(2); // выдать во 2-ой канал данные
    i := ReadSoobDC(2,sz);
    KanalDC[2].lastcnt := i;
    KanalDC[2].rcvcnt := KanalDC[2].rcvcnt + i;
    if i > 0 then // прочитать данные из канала2
    begin
{      if not FixedConnect[2] then
      begin // зафиксировать восстановление связи с сервером
        AddFixMessage(GetShortMsg(1,434,'2'),5,0); InsArcNewMsg(0,434+$2000);
      end;
      FixedConnect[2] := true;}
      if i >= 70 then begin inc(KanalDC[2].cnterr); KanalDC[2].lostcnt := 0; end;
      KanalDC[2].isrcv := true;
      if KanalDC[2].RcvPtr < 140 then KanalDC[2].iserror := false;
      if (i + KanalDC[2].RcvPtr) > sizeof(KanalDC[2].RcvBuf) then i := 0;
      for j := 0 to i-1 do begin KanalDC[2].RcvBuf[KanalDC[2].RcvPtr] := KanalDC[2].port.Buffer[j]; inc(KanalDC[2].RcvPtr); end;
      if KanalDC[2].RcvPtr > LnSoobSrv * 3 then
      begin
        inc(KanalDC[2].cnterr); // увеличить счетчик ошибок канала
        reportf('Переполнение входного буфера канала 2 ДЦ ('+ IntToStr(KanalDC[2].RcvPtr)+' байт) '+ DateTimeToStr(LastTime));
        KanalDC[2].RcvPtr := 0;
      end else
        ExtractSoobDC(2); // распаковка данных из 2-го канала
    end;
  end;
end;



function GetFR3dc(const param : Word) : Boolean;
  var p,d : integer;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7; // номер запрашиваемого бита
  p := param shr 3; // номер запрашиваемого байта
  if p > 4096 then exit;

  // Получить значение
  case d of
    1 : result := (FR3[p] and 2) = 2;
    2 : result := (FR3[p] and 4) = 4;
    3 : result := (FR3[p] and 8) = 8;
    4 : result := (FR3[p] and $10) = $10;
    5 : result := (FR3[p] and $20) = $20;
    6 : result := (FR3[p] and $40) = $40;
    7 : result := (FR3[p] and $80) = $80;
  else
    result := (FR3[p] and 1) = 1;
  end;
end;

//-----------------------------------------------------------------------------
// Процедура передачи в канал ДЦ
procedure WriteSoobDC(kanal : Byte);
begin
  if Assigned(KanalDC[kanal].port) then
  begin
    KanalDC[kanal].port.BufToComm(@WrBuffer[0],LnSoobDC);
    KanalDC[kanal].trmcnt := KanalDC[kanal].trmcnt + LnSoobDC; inc(KanalDC[kanal].tpkcnt);
  end;
end;

//-----------------------------------------------------------------------------
// Процедуры цикла чтения из канала
function ReadSoobDC(kanal: Byte; var rcv: string) : Integer;
begin
  result := 0;
  if Assigned(KanalDC[kanal].port) then result := KanalDC[kanal].port.BufFromComm(KanalDC[kanal].port.Buffer,sizeof(KanalDC[kanal].port.Buffer));
end;

//------------------------------------------------------------------------------
// распаковка сообщений от сервера
procedure ExtractSoobDC(kanal : Byte); // распаковка сообщений из ЛП-ДЦ
  var i,l : integer;
  label loop;

begin
  if (kanal < 1) or (kanal > 2) then exit;
loop:

  if KanalDC[kanal].RcvPtr < LnSoobKvitDC then exit; // мало данных в буфере
  i := 0;
  while i < KanalDC[kanal].RcvPtr do begin if KanalDC[kanal].RcvBuf[i] = '(' then break; inc(i); end; // найти байт с признаком начала пакета

  if (i > 0) and (i < KanalDC[kanal].RcvPtr) then
  begin // обрезать начало буфера до символа начала кадра
    l := 0;
    while i < KanalDC[kanal].RcvPtr do begin KanalDC[kanal].RcvBuf[l] := KanalDC[kanal].RcvBuf[i]; inc(i); inc(l); end;
    KanalDC[kanal].RcvPtr := l;
  end;
  if KanalDC[kanal].RcvPtr < LnSoobKvitDC then exit; // длина строки мала - копить дальше

  if KanalDC[kanal].RcvBuf[LnSoobKvitDC-1] = ')' then // если признак конца пакета на месте - вычислить контрольную сумму
  begin
    KanalDC[kanal].cnterr := 0; // сброс счетчика ошибок
    KanalDC[kanal].iserror := false;
    if KanalDC[kanal].RcvBuf[LnSoobKvitDC-2] = 'P' then // если признак квитанции
      inc(KanalDC[kanal].pktcnt); // увеличить счетчик принятых пакетов

    // выкинуть из строки обработанный кадр
    if KanalDC[kanal].RcvPtr > LnSoobKvitDC then
    begin
      l := 0; i := LnSoobKvitDC;
      while i < KanalDC[kanal].RcvPtr do
      begin
        KanalDC[kanal].RcvBuf[l] := KanalDC[kanal].RcvBuf[i]; inc(i); inc(l);
      end;
      KanalDC[kanal].RcvPtr := l;
    end else
    begin
      KanalDC[kanal].RcvPtr := 0; exit;
    end; // завершить если списан последний полный кадр
    goto loop;
  end else
  begin // признак конца кадра не найден - продолжить поиск в исходной строке
    l := 0; i := 1;
    while i < KanalDC[kanal].RcvPtr do
    begin
      KanalDC[kanal].RcvBuf[l] := KanalDC[kanal].RcvBuf[i]; inc(i); inc(l);
    end;
    KanalDC[kanal].RcvPtr := l; goto loop;
  end;
end;


//------------------------------------------------------------------------------
// Сохранить в файле протокола статистику работы канала
procedure FixStatKanalDC(kanal : byte);
begin
  if Assigned(KanalDC[kanal].port) then
  begin
    reportf('Канал '+IntToStr(kanal)+' ДЦ : Байт отправлено '+IntToStr(KanalDC[kanal].trmcnt));
    reportf('Канал '+IntToStr(kanal)+' ДЦ : Пакетов отправлено '+IntToStr(KanalDC[kanal].tpkcnt));
    reportf('Канал '+IntToStr(kanal)+' ДЦ : Байт принято '+IntToStr(KanalDC[kanal].rcvcnt));
    reportf('Канал '+IntToStr(kanal)+' ДЦ : Пакетов принято '+IntToStr(KanalDC[kanal].pktcnt));
  end;
end;

end.
