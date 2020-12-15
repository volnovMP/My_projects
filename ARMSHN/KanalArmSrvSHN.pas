unit KanalArmSrvSHN;
//****************************************************************************
//       Процедуры работы с каналом Сервер - АРМ ШН
//****************************************************************************
{$INCLUDE d:\sapr_new\CfgProject}

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
  comport,
  SyncObjs;


type TKanalErrors = (keOk,keErrCRC,keErrSrc,keErrDst);

const

PIPE_READING_SUCCESS = 1;
PIPE_WRITING_SUCCESS = 2;
PIPE_ERROR_STATE     = 3;
PIPE_EXIT            = 4;

  LnSoobSrv  : integer = 70;    //----------------------------- длина сообщения от сервера
{
var
//  trmkvit : string; // квитанции по передаче в сервер
//  rcvkvit : string; // квитанции по приему


const
  FR_LIMIT = 4096;

//------------------------------------------------------------------------------
//                  Массив датчиков из канала Сервер - АРМ
//------------------------------------------------------------------------------
var
  FR3    : array[1..FR_LIMIT] of Byte;      // буфер обсчета состояний
  FR3inp : array[1..FR_LIMIT] of Char;      // буфер приема FR3
  FR3s   : array[1..FR_LIMIT] of TDateTime; // регистрация приема FR3

//------------------------------------------------------------------------------
//                 Массив ограничений, полученных из Сервера
//------------------------------------------------------------------------------
var
  FR4    : array[1..FR_LIMIT] of Byte;      // буфер обсчета состояний
  FR4inp : array[1..FR_LIMIT] of Char;      // буфер приема FR4
  FR4s   : array[1..FR_LIMIT] of TDateTime; // регистрация приема FR4

//------------------------------------------------------------------------------
//                         Массив признаков диагностики
//------------------------------------------------------------------------------
var
  FR5    : array[1..FR_LIMIT] of Byte;      // буфер диагностики

//------------------------------------------------------------------------------
//                        Массив двухбайтных параметров
//------------------------------------------------------------------------------
var
  FR6 : array[1..1024] of Word;

//------------------------------------------------------------------------------
//                      Массив четырехбайтных параметров
//------------------------------------------------------------------------------
var
  FR7 : array[1..1024] of Cardinal;

//------------------------------------------------------------------------------
//                      Массив восьмибайтных параметров
//------------------------------------------------------------------------------
var
  FR8 : array[1..1024] of int64;

var
  ArchName  : string;   // Имя файла архива (без пути)
  ArcIndex  : cardinal; // Индекс строки в архиве
  KanalSrv  : array[1..2] of TKanal;
  KanalType : Byte; // 0 - RS-422, 1- Pipes

  savearc  : boolean; // разрешение записи принимаемых данных в авхив
  chnl1    : string;  // прием данных из 1 канала
  chnl2    : string;  // прием данных из 2 канала

  LastDiagN : Byte; // Параметры последнего принятого диагностического сообщения
  LastDiagI : Word;
  LastDiagD : Double;
}
function CreateKanalSrv : Boolean;                // Создать экземпляры класса TComPort
function DestroyKanalSrv : Boolean;               // Деструктор структур канала
function GetKanalSrvStatus(kanal : Byte) : Byte;  // Получить состояние канала
function InitKanalSrv(kanal : Byte) : Byte;       // Инициализация канала
function ConnectKanalSrv(kanal : Byte) : Byte;    // Установить связь по каналу
function DisconnectKanalSrv(kanal : Byte) : Byte; // Разрыв связи по каналу

function SyncReady : Boolean;
function GetFR5(param : Word) : Byte;
function GetFR4State(param : Word) : Boolean;
function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
function ReadSoobCom(kanal: Byte; var rcv: string) : Integer; // Процедура цикла чтения канала COM-ports
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;     // Процедура потока чтения канала PIPEs
procedure WriteSoobCom(kanal: Byte);                   // Процедура передачи в канал COM-ports
procedure WriteSoobPipe;                               // Процедура передачи в канал PIPEs
function SaveArch(const c: byte) : Boolean;            // сохранить в архиве принятое сообщение
function AddCheck(kanal : Byte; crc : Word) : Boolean; // Добавить новую квитанцию
function SendCheck(kanal : Byte; var crc : Word) : Boolean; // Получить очередную квитанцию
procedure ExtractSoobSrv(kanal : Byte); // распаковка сообщений из сервера
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte); // обработка квитанции из сервера
procedure SaveDUMP(buf,fname : string); // сохранение НЕХ - данных на диск
procedure SaveKanal;

implementation

uses
  TypeAll,
  TabloSHN,
  crccalc,
  commands,
  commons,
  mainloop,
  marshrut;

 // VarStruct;

var
  OLS : TOverlapped;
  lpNBWri     : Cardinal;
  Buffer      : array[0..4097] of char;
  sz          : string;
  stime       : string;
  tbuf        : string;
  stmp : string;
  errch : array[1..2] of integer;
  errfix : array[1..2] of Boolean;
//========================================================================================
//----------------------------------------------------- Создать экземпляры класса TComPort
function CreateKanalSrv : Boolean;
begin
  try
    if KanalSrv[1].Index > 0 then
    begin // последовательный порт
      if KanalSrv[1].nPipe = '' then KanalSrv[1].port := TComPort.Create(nil);
    end else
    begin // труба
      if KanalSrv[1].nPipe <> '' then
      begin
        RcvOLS.hEvent := CreateEvent(nil,true,true,nil);
        TrmOLS.hEvent := CreateEvent(nil,true,true,nil);
      end;
    end;
    if KanalSrv[2].Index > 0 then
    begin
      if KanalSrv[2].nPipe = '' then KanalSrv[2].port := TComPort.Create(nil);
    end;
    result := true;
  except
    result := false;
  end;
end;

//========================================================================================
//------------------------------------------------------------- Деструктор структур канала
function DestroyKanalSrv : Boolean;
var
  clos : Boolean;
begin
  try
    if Assigned(KanalSrv[1].port) then KanalSrv[1].port.Destroy else
    begin
      ResetEvent(RcvOLS.hEvent);
      clos := CloseHandle(RcvOLS.hEvent);
      if clos then RcvOLS.hEvent := INVALID_HANDLE_VALUE;
      clos := CloseHandle(TrmOLS.hEvent);
      if clos then TrmOLS.hEvent := INVALID_HANDLE_VALUE;
    end;
    result := true;
  except
    result := false;
  end;
end;

//----------------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Сохранение данных на диск в НЕХ - формате
procedure SaveDUMP(buf,fname : string);
  var i,hfile, hnbw, len: cardinal; fp: longword;
begin
  DateTimeToString(stime, 'hh:nn:ss.zzz', Date+Time);
  tbuf := '['+ stime+ '] ';
  for i := 1 to Length(buf) do tbuf := tbuf + IntToHex(byte(buf[i]),2) + ' ';
  tbuf := tbuf + #13#10;
  len := Length(tbuf);
  for i := 1 to len do buffarc[i] := byte(tbuf[i]);
  hfile := CreateFile(PChar(fname), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile <> INVALID_HANDLE_VALUE then
  begin
    fp := SetFilePointer(hfile, 0, nil, FILE_END);
    if fp < $ffffffff then begin OLS.Offset := fp; WriteFile(hfile, buffarc[1], len, hnbw, nil); end;
    CloseHandle(hfile);
  end;
end;
//-----------------------------------------------------------------------------
// Получить состояние канала
function GetKanalSrvStatus(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or
     ((KanalSrv[kanal].port = nil) and (KanalSrv[kanal].nPipe = '')) then
  begin
    result := 255; exit;
  end;

  result := 0;
end;

//-----------------------------------------------------------------------------
// Инициализация канала
function InitKanalSrv(kanal : Byte) : Byte;
begin
  if (kanal < 1) or (kanal > 2) or
     ((KanalSrv[kanal].port = nil) and (KanalSrv[kanal].nPipe = '')) then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('Ошибка 255 инициализации канала'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  if KanalSrv[kanal].nPipe = '' then
  begin // СОМ-порт
    if KanalSrv[kanal].port.InitPort(IntToStr(KanalSrv[kanal].Index)+ ','+ KanalSrv[kanal].config) then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Выполнена инициализация канала'+ IntToStr(kanal)+ ' '+ stime);
      result := 0;
    end else
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Ошибка 254 инициализации канала'+ IntToStr(kanal)+ ' '+ stime);
      result := 254;
    end;
  end else
  begin // труба
    if kanal = 1 then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Выполнена инициализация трубы'+ IntToStr(kanal)+ ' '+ stime);
    end;
    result := 0;
  end;
end;

//-----------------------------------------------------------------------------
// Установить связь по каналу
function ConnectKanalSrv(kanal : Byte) : Byte;
  var Dummy : ULONG;
begin
  if (kanal < 1) or (kanal > 2) or
     ((KanalSrv[kanal].port = nil) and (KanalSrv[kanal].nPipe = '')) then
  begin
    DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
    reportf('Ошибка при открытии коммуникационного порта канала'+ IntToStr(kanal)+ ' '+ stime);
    result := 255; exit;
  end;
  KanalSrv[kanal].RcvPtr := 0;
  if KanalSrv[kanal].nPipe = '' then
  begin // СОМ-порт
    if KanalSrv[kanal].port.PortIsOpen then
    begin
      KanalSrv[kanal].active := true; result := 0;
    end else
    if KanalSrv[kanal].port.OpenPort then
    begin
      PurgeComm(KanalSrv[kanal].port.PortHandle,PURGE_TXABORT+PURGE_RXABORT+PURGE_TXCLEAR+PURGE_RXCLEAR);
      KanalSrv[kanal].active := true;
      KanalSrv[kanal].hPipe := KanalSrv[kanal].port.PortHandle;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Выполнено открытие коммуникационного порта канала'+ IntToStr(kanal)+ ' '+ stime);
      result := 0;
    end else
    begin
      result := 254;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Не удается открыть коммуникационный порт канала'+ IntToStr(kanal)+ ' '+ stime);
    end;
  end else
  begin // труба
    if kanal = 1 then
    begin
      KanalSrv[1].hPipe := INVALID_HANDLE_VALUE;
      KanalSrv[1].State := 0; // разрешить чтение из трубы, запретить обработку в программе
      KanalSrv[kanal].active := false;
      KanalSrv[1].hPipe := CreateFile(
      pchar(KanalSrv[1].nPipe),
      GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE,
      nil,                    // вставить атрибуты секретности
      OPEN_EXISTING,
      FILE_FLAG_OVERLAPPED,
      0);
      if KanalSrv[1].hPipe = INVALID_HANDLE_VALUE then
      begin
        result := 254;
        DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
        reportf('Не удается открыть трубу канала'+ IntToStr(kanal)+ ' (код ошибки '+IntToStr(GetLastError()) +') '+ stime);
      end else
      begin
        KanalSrv[1].State := 0; // разрешить чтение из трубы, запретить обработку в программе
        CreateThread(nil,0,@ReadSoobPipe,nil,0,Dummy); // начать обслуживание потока трубы
        DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
        reportf('Выполнено подключение к серверу по каналу '+ KanalSrv[kanal].nPipe + ' '+ stime);
        KanalSrv[kanal].active := true;
        result := 0;
      end;
    end else
      result := 0;
  end;
end;

//========================================================================================
//----------------------------------------------------------------- Разрыв связи по каналу
function DisconnectKanalSrv(kanal : Byte) : Byte;
begin
  try
    if (kanal < 1) or (kanal > 2) or
    (not Assigned(KanalSrv[kanal].port) and (KanalSrv[kanal].nPipe = '')) then
    begin
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Ошибка при закрытии коммуникационного порта канала'+ IntToStr(kanal)+ ' '+ stime);
      result := 255;
      exit;
    end;

    if Assigned(KanalSrv[kanal].port) then
    begin // COM-порт
      if KanalSrv[kanal].port.PortIsOpen then
      begin
        if KanalSrv[kanal].port.ClosePort then
        begin
          KanalSrv[kanal].active := false;
          DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
          reportf('Коммуникационный порт канала'+ IntToStr(kanal)+ ' '+ stime+ ' закрыт');
          result := 0;
        end
        else result := 253;
      end
      else result := 0;
    end else
    if (KanalSrv[kanal].nPipe <> '') and (KanalSrv[kanal].nPipe <> 'null') then
    begin // труба
      if KanalSrv[kanal].hPipe = INVALID_HANDLE_VALUE then begin result := 0; exit; end
      else
      if CloseHandle(KanalSrv[kanal].hPipe) then
      begin result := 0; KanalSrv[kanal].hPipe := INVALID_HANDLE_VALUE; end
      else result := 253;
      DateTimeToString(stime, 'dd/mm/yy h:nn:ss.zzz', Date+Time);
      reportf('Отключен канал обмена с сервером '+ KanalSrv[kanal].nPipe+ ' '+ stime);
      KanalSrv[kanal].State := PIPE_EXIT;
      KanalSrv[kanal].active := false;
    end
    else result := 0;
  except
    reportf('Ошибка в DisconnectKanalSrv');
    Application.Terminate; result := 252;
  end;
end;

//----------------------------------------------------------------------------------------
var
  FixedDisconnect,FixedConnect : Boolean;
  FDT : double;

//========================================================================================
//------------------ Обработка данных канального уровня, ожидание синхронизации от сервера
function SyncReady : Boolean;
var
  i,j : integer;
begin
  result := false;
  if AppStart then exit; //--- до окончания инициализации не обрабатывать канал АРМ-Сервер

  if KanalSrv[1].active then
  begin
    case KanalSrv[1].State of
      PIPE_READING_SUCCESS :
      begin //------------------------------------------- прочитать данные из буфера трубы
        if not FixedConnect then
        begin //---------------------------- зафиксировать восстановление связи с сервером
          AddFixMessage(GetShortMsg(1,434,''),5,0);
          InsArcNewMsg(0,434+$2000);
        end;
        FixedConnect := true;
        KanalSrv[1].iserror := false;
        KanalSrv[1].rcvcnt := KanalSrv[1].RcvPtr;
        if KanalSrv[1].rcvcnt > 0 then //----------------------- прочитать данные из трубы
        begin
          if KanalSrv[1].rcvcnt > 70 then  inc(KanalSrv[1].cnterr)
          else KanalSrv[1].cnterr := 0;
          KanalSrv[1].isrcv := true;
          MySync[1] := true;

          if KanalSrv[1].RcvPtr > LnSoobSrv * 3 then
          begin
            inc(KanalSrv[1].cnterr); //------------------- увеличить счетчик ошибок канала
            reportf('Переполнен буфер канала 1 ('+IntToStr(KanalSrv[1].RcvPtr)+' байт )'
            + DateTimeToStr(LastTime));
            KanalSrv[1].RcvPtr := 0;
          end
          else ExtractSoobSrv(1); //------------------------- распаковка данных из сервера
        end;
        KanalSrv[1].State := 0; //----------- разрешить продолжение набора буфера из трубы
        MySync[1] := true;
        MyMarker[1] := false;
        KanalSrv[1].issync := true;
      end;

      PIPE_ERROR_STATE : KanalSrv[1].active := false; //--------- перерыв связи с сервером

      PIPE_EXIT :
      begin //--------------------------------------------------- завершение работы канала
        result := true;
        exit;
      end;
    end;
    WriteSoobPipe;
  end else
  begin
    if KanalSrv[1].State <> PIPE_EXIT then
    begin //-------- если не было завершения обслуживания канала - фиксировать обрыв связи
      //------------------------------- с попыткой восстановления соединения через 10 сек.
      KanalSrv[1].iserror := true;
      if FixedDisconnect then
      begin
        if FDT < LastTime then
        begin
          DisconnectKanalSrv(1);
          if (ConnectKanalSrv(1) > 0) and FixedConnect then
          begin
            AddFixMessage(GetShortMsg(1,433,'1'),4,4);
            InsArcNewMsg(0,433+$1000);  //------------------- Восстановление связи с УВК $
          end;
          FixedDisconnect := false;
          FixedConnect := false;
        end;
      end else
      begin
        FixedDisconnect := true;
        FDT := LastTime + 10/86400;
      end;
    end;
  end;
end;



function GetFR5(param : Word) : Byte;
begin
  result := FR5[param];
  FR5[param] := 0; // очистить признаки
end;

function GetFR3(const param : Word; var nep, ready : Boolean) : Boolean;
  var p,d : integer;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7; // номер запрашиваемого бита
  p := param shr 3; // номер запрашиваемого байта
  if p > 4096 then exit;

  // Проверить превышение времени жизни данных
  if ready then ready := (LastTime - FR3s[p]) < MaxTimeOutRecave;

  // Проверить признак парафазности сообщения
  if not nep then nep := (FR3[p] and $20) = $20;

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

function GetFR4State(param : Word) : Boolean;
  var p,d : integer;
begin
  result := false;
  if param < 8 then exit;
  d := param and 7;
  p := param shr 3;
  if p > 4096 then exit;

  // Проверить превышение времени жизни данных
  if (LastTime - FR4s[p]) < MaxTimeOutRecave then
  begin
    case d of
      1 : result := (FR4[p] and 2) = 2;
      2 : result := (FR4[p] and 4) = 4;
      3 : result := (FR4[p] and 8) = 8;
      4 : result := (FR4[p] and $10) = $10;
      5 : result := (FR4[p] and $20) = $20;
      6 : result := (FR4[p] and $40) = $40;
      7 : result := (FR4[p] and $80) = $80;
    else
      result := (FR4[p] and 1) = 1;
    end;
  end else
    result := false;
end;

//-----------------------------------------------------------------------------
// Процедура передачи в канал

// для СОМ-портов
procedure WriteSoobCom(kanal : Byte);
  var next : boolean; crc : crc8_t; i,j,k : integer; a,b,bl,bh : byte;
  w,wyr,wmt,wdy,whr,wmn,wsc,wmsc : word; uts : TDateTime;
begin
  if KanalSrv[kanal].port <> nil then
  begin
    next := false;
    a := config.RMID; a := a shl 4; a := a + LastSrv[kanal]; // адресовать сообщение
    // формирование кода состояния
    b := config.ru; // район управления
    if WorkMode.PushOK then b := b + $20;
    if not WorkMode.OKError then b := b + $40;
    if WorkMode.PushRU then b := b + $80;

    j := 0;
    WrBuffer[j] := #$AA; inc(j);
    WrBuffer[j] := char(a); inc(j);
    WrBuffer[j] := char(b); inc(j);

    if SyncCmd then
    begin // выдать команду синхронизации времени на серверах
      DoubleCnt := 0; SyncCmd := false; SyncTime := false;
      uts := Date + Time; DecodeTime(uts,whr,wmn,wsc,wmsc); DecodeDate(uts,wyr,wmt,wdy);
      WrBuffer[j] := char(cmdfr3_autodatetime); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(cmdfr3_autodatetime);
      w := wSc and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wMn and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wHr and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wDy and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wMt and $ff; WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      w := wYr - 2000;  WrBuffer[j] := char(w); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(w);
      WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
      WrBuffer[j] := char(0); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(0);
    end else
    if (DoubleCnt > 0) and (ParamDouble.Cmd = cmdfr3_newdatetime) then
    begin // Упаковка времени
      DoubleCnt := 0;
      WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[1] := NewCmd[1] + char(ParamDouble.Cmd);
      WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[1]);
      WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[2]);
      WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[3]);
      WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[4]);
      WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[5]);
      WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[6]);
      WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[7]);
      WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[1] := NewCmd[kanal] + char(ParamDouble.Index[8]);
    end;


    if not WorkMode.LockCmd then
    begin // передать команды в сервер если нет запрета ТУ

      if WorkMode.MarhRdy then
      begin // Маршрутная команда от ДСП готова к передаче на сервер
        WorkMode.MarhRdy := false;
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[10]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[1]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[2]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[3]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[4]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[5]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[6]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[7]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[8]); inc(j);
        WrBuffer[j] := char(MarhTracert[1].MarhCmd[9]); inc(j);
        NewCmd[kanal] := NewCmd[kanal] + char(MarhTracert[1].MarhCmd[10]) + char(MarhTracert[1].MarhCmd[1])
          + char(MarhTracert[1].MarhCmd[2]) + char(MarhTracert[1].MarhCmd[3]) + char(MarhTracert[1].MarhCmd[4]) + char(MarhTracert[1].MarhCmd[5])
          + char(MarhTracert[1].MarhCmd[6]) + char(MarhTracert[1].MarhCmd[7]) + char(MarhTracert[1].MarhCmd[8]) + char(MarhTracert[1].MarhCmd[9]);
      end;

      if CmdCnt > 0 then
      begin // Упаковка готовых команд
        WrBuffer[j] := char(CmdBuff.Cmd); inc(j);
        NewCmd[kanal] := NewCmd[kanal] + char(CmdBuff.Cmd);
        bh := CmdBuff.Index div $100; bl := CmdBuff.Index - bh * $100;
        WrBuffer[j] := char(bl); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bl);
        WrBuffer[j] := char(bh); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(bh);
        CmdCnt := 0;
      end;

      if DoubleCnt > 0 then
      begin // Упаковка параметров Double
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j); NewCmd[kanal] := NewCmd[kanal] + char(ParamDouble.Index[8]);
      end;

    end else
    begin // сбросить все накопленные команды если есть блокировка ТУ
      DoubleCnt := 0; Cmdcnt := 0; WorkMode.MarhRdy := false;
    end;

    if LastCRC[kanal] > 0 then
    begin // Упаковка квитанций
      if j < 25 then
      begin
        k := LastCRC[kanal];
        if (2 * k) > (25 - j) then
        begin
          k := (25 - j) div 2; // определить кол-во отсылаемых квитанций
          next := true;        // поставить признак продолжения ТУ
        end;
        WrBuffer[j] := char(k + cmdfr3_kvitancija); inc(j);
        while k > 0 do
        begin
          SendCheck(kanal,w);

//          trmkvit := trmkvit + ',' + IntToStr(w)+ ':'+ IntToStr(kanal);

          b := w div $100;
          WrBuffer[j] := char(w - (b * $100)); inc(j);
          WrBuffer[j] := char(b); inc(j);
          dec(k);
        end;
      end;
    end;

    while j < 26 do
    begin
      WrBuffer[j] := #0; inc(j);
    end; // дополнить сообщение до заданной длины

    crc := CalculateCRC8(@WrBuffer[1],25);
    WrBuffer[j] := char(crc); inc(j);
    WrBuffer[j] := #$55; inc(j);

    i := 0;
    while next do
    begin // дослать оставшиеся квитанции отдельным кадром
      i := i+28; j := 0;
      WrBuffer[i+j] := #$AA; inc(j);
      WrBuffer[i+j] := char(a); inc(j);
      WrBuffer[i+j] := char(b); inc(j);
      if LastCRC[kanal] > 0 then
      begin // Упаковка квитанций
        if j < 25 then
        begin
          k := LastCRC[kanal];
          if (2 * k) > (25 - j) then
          begin
            k := (25 - j) div 2; // определить кол-во отсылаемых квитанций
            next := true;        // поставить признак продолжения ТУ
          end else
            next := false;
          WrBuffer[i+j] := char(k + 224);
          while k > 0 do
          begin
            SendCheck(kanal,w);
            b := w div $100;
            WrBuffer[i+j] := char(w - (b * $100)); inc(j);
            WrBuffer[i+j] := char(b); inc(j);
            dec(k);
          end;
        end;
      end;
      while j < 26 do
      begin
        WrBuffer[i+j] := #0; inc(j);
      end; // дополнить сообщение до заданной длины
      crc := CalculateCRC8(@WrBuffer[i+1],25);
      WrBuffer[i+j] := char(crc); inc(j);
      WrBuffer[i+j] := #$55; inc(j);
    end;

    KanalSrv[kanal].port.BufToComm(@WrBuffer[0],j);
  end;
end;
//========================================================================================
//------------------------------------------------------------------------------ для трубы
procedure WriteSoobPipe;
var
  next : boolean;
  crc : crc8_t;
  i,j,k : integer;
  a,b,bl,bh : byte;
  w: word;
  cErr : cardinal;
begin
  try
    if (KanalSrv[1].nPipe <> '') and KanalSrv[1].active then
    begin
      KanalSrv[1].iserror := false;
      KanalSrv[1].cnterr := 0;
      MySync[1] := false;
      if not (SyncCmd or (DoubleCnt > 0)
      or WorkMode.MarhRdy or (Cmdcnt > 0)
      or (DoubleCnt > 0) or (LastCRC[1] > 0)) then  exit;
      MySync[1] := true;
      next := false;
      a := config.RMID; a := a shl 4; a := a + LastSrv[1]; //-------- адресовать сообщение

      //------------------------------------------------------ формирование кода состояния
      b := config.ru; //------------------------------------------------- район управления
      if WorkMode.PushOK then b := b + $20;
      if not WorkMode.OKError then b := b + $40;
      if WorkMode.PushRU then b := b + $80;

      j := 0;
      WrBuffer[j] := #$AA; inc(j);
      WrBuffer[j] := char(a); inc(j);
      WrBuffer[j] := char(b); inc(j);
      //----------------------------------------------------------------------------------
      if (DoubleCnt > 0) and (ParamDouble.Cmd = cmdfr3_newdatetime) then
      begin //----------------------------------------------------------- Упаковка времени
        DoubleCnt := 0;
        WrBuffer[j] := char(ParamDouble.Cmd); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Cmd);
        WrBuffer[j] := char(ParamDouble.Index[1]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[1]);
        WrBuffer[j] := char(ParamDouble.Index[2]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[2]);
        WrBuffer[j] := char(ParamDouble.Index[3]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[3]);
        WrBuffer[j] := char(ParamDouble.Index[4]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[4]);
        WrBuffer[j] := char(ParamDouble.Index[5]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[5]);
        WrBuffer[j] := char(ParamDouble.Index[6]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[6]);
        WrBuffer[j] := char(ParamDouble.Index[7]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[7]);
        WrBuffer[j] := char(ParamDouble.Index[8]); inc(j);
        NewCmd[1] := NewCmd[1] + char(ParamDouble.Index[8]);
      end;

      //------------------------------------ передать команды в сервер если нет запрета ТУ
      if (not WorkMode.LockCmd) or (CmdBuff.Cmd = cmdfr3_logoff) then
      begin
        if CmdCnt > 0 then
        begin //-------------------------------------------------- Упаковка готовых команд
          WrBuffer[j] := char(CmdBuff.Cmd); inc(j);
          NewCmd[1] := NewCmd[1] + char(CmdBuff.Cmd);
          bh := CmdBuff.Index div $100; bl := CmdBuff.Index - bh * $100;
          WrBuffer[j] := char(bl); inc(j); NewCmd[1] := NewCmd[1] + char(bl);
          WrBuffer[j] := char(bh); inc(j); NewCmd[1] := NewCmd[1] + char(bh);
          CmdCnt := 0;
//          if SendToSrvCloseRMDSP then SendToSrvCloseRMDSP := false;
        end;
      end else
      begin //------------------- сбросить все накопленные команды если есть блокировка ТУ
        DoubleCnt := 0;
        Cmdcnt := 0;
        WorkMode.MarhRdy := false;
      end;

      if LastCRC[1] > 0 then
      begin //--------------------------------------------------------- Упаковка квитанций
        if j < 25 then
        begin
          k := LastCRC[1];
          if (2 * k) > (25 - j) then
          begin
            k := (25 - j) div 2; //---------------- определить кол-во отсылаемых квитанций
            next := true;        //--------------- поставить признак продолжения квитанций
          end;
          WrBuffer[j] := char(k + cmdfr3_kvitancija); inc(j);
          while k > 0 do
          begin
            SendCheck(1,w);
            b := w div $100;
            WrBuffer[j] := char(w - (b * $100)); inc(j);
            WrBuffer[j] := char(b); inc(j);
            dec(k);
          end;
        end;
      end;

      while j < 26 do begin WrBuffer[j] := #0; inc(j); end; // дополнить до заданной длины

      crc := CalculateCRC8(@WrBuffer[1],25);
      WrBuffer[j] := char(crc); inc(j);
      WrBuffer[j] := #$55; inc(j);

      i := 0;
      while next do
      begin //------------------------------ дослать оставшиеся квитанции отдельным кадром
        i := i+28; j := 0;
        WrBuffer[i+j] := #$AA; inc(j);
        WrBuffer[i+j] := char(a); inc(j);
        WrBuffer[i+j] := char(b); inc(j);
        if LastCRC[1] > 0 then
        begin //------------------------------------------------------- Упаковка квитанций
          if j < 25 then
          begin
            k := LastCRC[1];
            if (2 * k) > (25 - j) then
            begin
              k := (25 - j) div 2; //-------------- определить кол-во отсылаемых квитанций
              next := true;        //-------------------- поставить признак продолжения ТУ
            end
            else  next := false;
            WrBuffer[i+j] := char(k + 224);
            while k > 0 do
            begin
              SendCheck(1,w);
              b := w div $100;
              WrBuffer[i+j] := char(w - (b * $100)); inc(j);
              WrBuffer[i+j] := char(b); inc(j);
              dec(k);
            end;
          end;
        end;
        while j < 26 do begin WrBuffer[i+j] := #0;inc(j);end;//дополнить до заданной длины
        crc := CalculateCRC8(@WrBuffer[i+1],25);
        WrBuffer[i+j] := char(crc); inc(j);
        WrBuffer[i+j] := #$55; inc(j);
      end;

      if j > 0 then
      begin //-------------------------------------------------- Копировать данные в буфер
        if not WriteFile(KanalSrv[1].hPipe, WrBuffer, j, lpNBWri, @TrmOLS) then
        begin
          cErr := GetLastError;
          case cErr of
            ERROR_PIPE_NOT_CONNECTED : KanalSrv[1].iserror := true;
            ERROR_IO_PENDING :  KanalSrv[1].iserror := false;
          end;
          MySync[1] := true;
          KanalSrv[1].issync := true;
        end
        else KanalSrv[2].iserror := false;
      end;
    end;
  except
    reportf('Ошибка [KanalArmSrvSHN.WriteSoobPipe]');
    Application.Terminate;
  end;
end;

//========================================================================================
//-------------------------------------------- Процедура цикла чтения из канала СОМ портов
function ReadSoobCom(kanal: Byte; var rcv: string) : Integer;
var
  razmer : Integer;
begin
  result := 0;
  razmer := sizeof(KanalSrv[kanal].port.Buffer);
  if KanalSrv[kanal].port <> nil then //------------------ если у канала открытый Com-порт
  begin
    result := KanalSrv[kanal].port.BufFromComm(KanalSrv[kanal].port.Buffer,razmer);

    if savearc then
    begin //------------------------- сохранить данные из канала - технологическая функция

      if kanal = 1 then chnl1 := chnl1 + rcv else
      if kanal = 2 then chnl2 := chnl2 + rcv;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------------------------- Для трубы - чтение канала
function ReadSoobPipe(var RdBuf: Pointer) : DWORD;
var
  i : integer;
  cbRd,cbTRd : cardinal;
  LastError : DWORD;
begin
  try
    LastError := 0;
    while true do
    begin
      if KanalSrv[1].hPipe = INVALID_HANDLE_VALUE then
      begin
        KanalSrv[1].iserror := true;
        break;
      end;
      case KanalSrv[1].State of
        PIPE_ERROR_STATE : break; //-------------- выход если ошибка подключения к серверу
        PIPE_EXIT :
        begin
          ExitThread(0);
          result := 0;
          exit; //------------------------------------ завершить обслуживание потока трубы
        end;
      else //------------------------------------------------------------- чтение из трубы
      if GetNamedPipeHandleState(KanalSrv[1].hPipe,nil,nil,nil,nil,nil,0) then
      begin
        if not ReadFile( KanalSrv[1].hPipe, Buffer, 70, cbRd, @RcvOLS) then
        begin //----------------------------------------------------- Завершение с ошибкой
          LastError := GetLastError;
          if LastError = ERROR_IO_PENDING then
          begin
            //---------------------------------------------- ждать прием символов из трубы
            WaitForSingleObject(RcvOLS.hEvent, 31);
            CancelIO(KanalSrv[1].hPipe);
          end else
          begin //----------------------------------------------- выход из обработки трубы
            KanalSrv[1].iserror := true; 
            break;
          end;
        end;
        GetOverlappedResult(KanalSrv[1].hPipe,RcvOLS,cbTRd,false);
        if cbTRd > 0 then
        begin
          if (KanalSrv[1].RcvPtr + cbTRd) < RCV_LIMIT then
          begin //----------------------------------------------------- копировать в буфер
            for i := 0 to cbTRd-1 do
            begin
              KanalSrv[1].RcvBuf[KanalSrv[1].RcvPtr] := Buffer[i];
              inc(KanalSrv[1].RcvPtr);

              if savearc then //----- сохранить данные из канала - технологическая функция
                chnl1 := chnl1 + Buffer[i];
            end;
            KanalSrv[1].State := PIPE_READING_SUCCESS;
          end else
          begin //- перемещение указателя буфера на начало массива при переполнении буфера
            KanalSrv[1].iserror := true;
            KanalSrv[1].RcvPtr := 0;
          end;
        end;
      end else
      begin //--------------------- остановить канал если обнаружена ошибка статуса канала
        KanalSrv[1].iserror := true;
        break;
      end;
    end;
  end;
  reportf('Код ошибки трубы '+ IntToStr(LastError));
  KanalSrv[1].State := PIPE_ERROR_STATE;
  ExitThread(99); //------------------------ завершить обслуживание потока трубы по ошибке
  result := 0;
  except
    reportf('Ошибка [KanalArmSrv.ReadSoobPipe]');
    Application.Terminate;
    ExitThread(99);
    result := 0;
  end;
end;

//------------------------------------------------------------------------------
// Записать в архив
function SaveArch(const c: byte) : Boolean;
  var i,hfile, hnbw, len: cardinal; bll,blh,bhl,bhh : byte; fp: longword; dt : Double; idt,cidt : int64;
begin
  DateTimeToString(stime, 'yymmdd', Date);
  if stime = ArchName then inc(ArcIndex) else begin ArcIndex := 0; ArchName := stime; end;
  sz := config.arcpath+ '\'+ ArchName+ '.ard';

  hfile := CreateFile(PChar(sz), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile = INVALID_HANDLE_VALUE then begin reportf('Ошибка '+IntToStr(GetLastError)+' открытия файла архива'); result := false; exit; end;
  try
  result := true;
  fp := SetFilePointer(hfile, 0, nil, FILE_END);
  if fp < $ffffffff then
  begin
    OLS.Offset := fp;
    for i := 10 to Length(buffarc) do buffarc[i] := 0; // очистить буфер
    dt := LastTime * 86400;
    idt := Trunc(dt);
    cidt := idt div $1000000; bhh := byte(cidt); idt := idt - cidt * $1000000;
    cidt := idt div $10000; bhl := byte(cidt); idt := idt - cidt * $10000;
    cidt := idt div $100; blh := byte(cidt); idt := idt - cidt * $100;
    bll := byte(idt);
    len := 1;
    case c of
      1 : begin // новизна состояния из канала и текущее состояние диалога с оператором
        if (ArcIndex = 0) and not StartRM then
        begin // сохранить полный архив в начале нового файла
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 11; inc(len); // признак архива 1-125 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to 125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          if WorkMode.LimitFRI > 125 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 12; inc(len); // признак архива 126-250 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 126 to 250 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 250 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 13; inc(len); // признак архива 251-375 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 251 to 375 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 375 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 14; inc(len); // признак архива 376-500 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 376 to 500 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 500 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 15; inc(len); // признак архива 501-625 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 501 to 625 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 625 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 16; inc(len); // признак архива 626-750 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 626 to 750 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 750 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 17; inc(len); // признак архива 751-875 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 751 to 875 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 875 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 18; inc(len); // признак архива 876-1000 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 876 to 1000 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          if WorkMode.LimitFRI > 1000 then
          begin
            buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 19; inc(len); // признак архива 1001-1125 объектов
            buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
            for i := 1001 to 1125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
          end;
          LastReper := LastTime;
        end;
        if NewMenuC <> '' then
        begin // команды меню
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewMenuC) + 5; inc(len);
          buffarc[len] := 5; inc(len); // признак команд меню
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewMenuC) do begin buffarc[len] := byte(NewMenuC[i]); inc(len); end;
        end;
        if NewFR[1] <> '' then
        begin // новизна FR3 по основному каналу
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewFR[1]) + 5; inc(len);
          buffarc[len] := 1; inc(len); // признак новизны принятой из 1-го канала
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewFR[1]) do begin buffarc[len] := byte(NewFR[1,i]); inc(len); end;
        end;
        if NewFR[2] <> '' then
        begin // новизна FR3 по резервному каналу
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewFR[2]) + 5; inc(len);
          buffarc[len] := 2; inc(len); // признак новизны принятой из 2-го канала
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewFR[2]) do begin buffarc[len] := byte(NewFR[2,i]); inc(len); end;
        end;
        if NewCmd[1] <> '' then
        begin // команда управления по основному каналу
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewCmd[1]) + 5; inc(len);
          buffarc[len] := 3; inc(len); // признак команд выданых в 1-ый канал
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewCmd[1]) do begin buffarc[len] := byte(NewCmd[1,i]); inc(len); end;
        end;
        if NewCmd[2] <> '' then
        begin // команда управления по резервному каналу
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewCmd[2]) + 5; inc(len);
          buffarc[len] := 4; inc(len); // признак команд выданых в 2-ой канал
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewCmd[2]) do begin buffarc[len] := byte(NewCmd[2,i]); inc(len); end;
        end;
        if NewMsg <> '' then
        begin // Фиксация сообщения по новизне из FR3
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := Length(NewMsg) + 5; inc(len);
          buffarc[len] := 6; inc(len);
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1 to Length(NewMsg) do begin buffarc[len] := byte(NewMsg[i]); inc(len); end;
        end;
      end;

      2 : begin // сохранить 10-ти минутный архив состояний
        buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 11; inc(len); // признак архива 1-125 объектов
        buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
        for i := 1 to 125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        if WorkMode.LimitFRI > 125 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 12; inc(len); // признак архива 126-250 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 126 to 250 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 250 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 13; inc(len); // признак архива 251-375 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 251 to 375 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 375 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 14; inc(len); // признак архива 376-500 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 376 to 500 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 500 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 15; inc(len); // признак архива 501-625 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 501 to 625 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 625 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 16; inc(len); // признак архива 626-750 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 626 to 750 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 750 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 17; inc(len); // признак архива 751-875 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 751 to 875 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 875 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 18; inc(len); // признак архива 876-1000 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 876 to 1000 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        if WorkMode.LimitFRI > 1000 then
        begin
          buffarc[len] := $ff; inc(len); buffarc[len] := $00; inc(len); buffarc[len] := 255; inc(len); buffarc[len] := 19; inc(len); // признак архива 1001-1125 объектов
          buffarc[len] := bll; inc(len); buffarc[len] := blh; inc(len); buffarc[len] := bhl; inc(len); buffarc[len] := bhh; inc(len);
          for i := 1001 to 1125 do begin buffarc[len] := FR3[i]; inc(len); buffarc[len] := FR4[i]; inc(len); end;
        end;
        LastReper := LastTime;
      end;

      {другие данные}
    end;
    dec(len);
    // Запись в файл
    if not WriteFile(hfile, buffarc[1], len, hnbw, nil) then
    begin
      reportf('Ошибка '+IntToStr(GetLastError)+' записи в файл архива.'); result := false;
    end;
  end else
  begin
    reportf('Ошибка '+ IntToStr(GetLastError)+ ' при перемещении указателя в конец файла архива.'); result := false;
  end;
//  if not FlushFileBuffers(hfile) then begin ShowMessage('Ошибка '+ IntToStr(GetLastError)+ ' во время записи файла архива на жесткий диск.'); result := false; end;
  finally
    if not CloseHandle(hfile) then begin reportf('Ошибка '+ IntToStr(GetLastError)+' закрытия файла архива.'); result := false; end;
    case c of
      1 : begin
        NewFR[1] := ''; NewFR[2] := ''; NewCmd[1] := ''; NewCmd[2] := ''; // сброс вуферов архива
        NewMenuC := ''; // сброс буфера команд меню
        NewMsg := '';   // сброс буфера зафиксированных сообщений
      end;

    end;
  end;
end;

//========================================================================================
//------------------------------------------------------------ Добавить квитанцию в список
function AddCheck(kanal : Byte; crc : Word) : Boolean;
var
  i : integer;
begin
  if LastCRC[kanal] < High(BackCRC) then    //-------------- если для квитанций есть место
  begin
    inc(LastCRC[kanal]);
    BackCRC[LastCRC[kanal],kanal]  := crc;
    result := true;
  end else    //----------------------------------------------- если буфер квитанций полон
  begin
    for i := 1 to High(BackCRC)-1 do
    begin
      BackCRC[i,kanal] := BackCRC[i+1,kanal]; //------- теряем одну самую старую квитанцию
    end;
    BackCRC[LastCRC[kanal],kanal] := crc;
    result := false;
  end;
end;

//-----------------------------------------------------------------------------
// Получить очередную квитанцию
function SendCheck(kanal : Byte; var crc : Word) : Boolean;
  var i : integer;
begin
  result := false;
  if LastCRC[kanal] > 0 then
  begin
    crc := BackCRC[1,kanal];
    for i := 1 to LastCRC[kanal]-1 do BackCRC[i,kanal] := BackCRC[i+1,kanal];
    dec(LastCRC[kanal]);
    result := true;
  end;
end;

//========================================================================================
//-------------------------------------------------------- распаковка сообщений от сервера
procedure ExtractSoobSrv(kanal : Byte);
var
  pb : char;
  i,j,l : integer;
  dc : cardinal;
  i64 : int64;
  b,bl,bh,mm : byte;
  w,ww,dw : word;
  crc,pcrc : crc16_t;
  label  loop;
begin
  //  KanalSrv[kanal].RcvPtr := 80;

  if (kanal < 1) or (kanal > 2) then exit;
loop:

  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; //---------------- мало данных в буфере
  i := 0;
  while i < KanalSrv[kanal].RcvPtr do
  begin
    if KanalSrv[kanal].RcvBuf[i] = #$AA then break;
    inc(i);
  end; //-------------------------------------------- найти байт с признаком начала пакета

  if (i > 0) and (i < KanalSrv[kanal].RcvPtr) then
  begin //--------------------------------- обрезать начало буфера до символа начала кадра
    l := 0;
    while i < KanalSrv[kanal].RcvPtr do
    begin
      KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; //- сдвинуть данные в начало
      inc(i);
      inc(l);
    end;
    KanalSrv[kanal].RcvPtr := l;
  end;

  if KanalSrv[kanal].RcvPtr < LnSoobSrv then exit; //--- длина строки мала - копить дальше

  if KanalSrv[kanal].RcvBuf[LnSoobSrv-1] = #$55 then //-------- если конец пакета на месте
  begin  //--------------------------------------------------- проверить контрольную сумму
    w := byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-3])+ //----- считываем из пакета слово с КС
    byte(KanalSrv[kanal].RcvBuf[LnSoobSrv-2]) * 256;
    pcrc := crc16_t(w); //------------------------------------------------ КС из сообщения

    crc := CalculateCRC16(@KanalSrv[kanal].RcvBuf[1],LnSoobSrv-4); //--- теперь подсчет КС

    if crc = pcrc then
    begin  // проверки достоверности выполнены - распаковать данные (t - содержимое кадра)
      KanalSrv[kanal].cnterr := 0; //------------------------------- сброс счетчика ошибок
      KanalSrv[kanal].iserror := false;
      // rcvkvit := rcvkvit + ',' + IntToStr(crc)+ ':'+ IntToStr(kanal);

      if not AddCheck(kanal,crc) then //----- добавляем квитанцию в буфер, и если он полон
      begin
        inc(KanalSrv[kanal].cnterr); //---------- увеличить число неотправленных квитанций
      end;

      j := 1; //--------------------------------------------------------- начало сообщения
      b := byte(KanalSrv[kanal].RcvBuf[j]); //------------------------- читаем первый байт
      mm := b and $0f; //------------------------------------------------- выделить маркер

      if (config.RMID = mm) and //---------------------------------- если наш маркер и ...
      (LastTime - LastRcv < AnsverTimeOut) then  //---- данные получены достаточно недавно
        MyMarker[kanal] := true //------------------- установка признака получения маркера
      else
      MyMarker[kanal] := false; //---- если данные старые запрет захвата канала дсп-сервер

      LastRcv := LastTime; //----------- фиксировать время приема последнего полного кадра

      //-------------------------------------------- выделить номер запрашивающего сервера
      SrvState := 0;
      b := b and $f0;
      SrvState := b;
      b := b shr 4;
      LastSrv[kanal] := b;

      inc(j); //--------------------------- перейти на байт состояния отправителя в пакете

      if config.RMID = mm then //---------------------------------------- если свой маркер
      StateRU := byte(KanalSrv[kanal].RcvBuf[j]); //---------- прочитать состояние сервера

      WorkMode.LockCmd := ((StateRU and $10) = 0);//выделить признак блокировки от сервера

      SrvState := SrvState or (StateRU and 7);//объединить номер и состояние актив.сервера

      if WorkMode.LockCmd then  //-------------------- если есть блокировка от сервера ...
      SrvState := SrvState or 8; //--------------- установим признак, что управляют 2 АРМа

      if char(SrvState) <> FR3inp[WorkMode.ServerStateSoob] then //--- если есть изменение
      begin //--------------------------- Сохранить новое значение байта состояния сервера
        bl := WorkMode.ServerStateSoob and $ff;
        bh := (WorkMode.ServerStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(SrvState);//---- новизна
        FR3inp[WorkMode.ServerStateSoob] := char(SrvState); //-------- зафиксировать новое
      end;

      if config.configKRU <> 0 then
      begin //-------- есть переключатель - дать ему преимущество над заголовком сообщения
        if not WorkMode.PushRU then
        StateRU := StateRU and $7f;
      end;

      DirState[1] := (StateRU and $f0)+(config.ru and $0f); //-- байт состояния управления
      FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);

      if WorkMode.Upravlenie <> ((StateRU and $80) = $80) then
      begin //--------------------------------------- Инициировать смену режима управления
        FR3inp[WorkMode.DirectStateSoob] := char(DirState[1]);
        bl := WorkMode.DirectStateSoob and $ff;
        bh := (WorkMode.DirectStateSoob and $ff00) shr 8;
        NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
        StDirect := (StateRU and $80) = $80;
        ChDirect := true;
      end;

      if config.configKRU = 0 then
      begin //--------------------------- вернуть в сервер режим управления для варианта 0
        WorkMode.PushRU := (StateRU and $80) = $80;
      end;
      inc(j);
      SVAZ := byte(KanalSrv[kanal].RcvBuf[j]); //обновить байт актуального состояния связи
      inc(j); //------------------------------------------------ пропустить резервный байт
      //--------------------------------------------------------------------- данные кадра
      while j < LnSoobSrv-3 do //------------------------------- идти до контрольной суммы
      begin
        bl := byte(KanalSrv[kanal].RcvBuf[j]);
        inc(j);
        if j > LnSoobSrv-4 then break;
        bh := byte(KanalSrv[kanal].RcvBuf[j]);
        w := bh * 256 + bl; //------------------------------------ читаем параметр (адрес)
        inc(j);
        if j > LnSoobSrv-4 then break;
        pb := KanalSrv[kanal].RcvBuf[j];  //-------------------- значение параметра (байт)
        inc(j);

        if w <> 0 then //------------------------------------------- если адрес не нулевой
        begin
          b := byte(pb);
          if w = WorkMode.DirectStateSoob then //--------- если это возврат состояния АРМа
          begin //------------------------------ подтверждение сервера на изменение района
            if config.RMID = mm then   //--------------------------------- если мой маркер
            begin
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + char(DirState[1]);
              if not WorkMode.Upravlenie then
              begin
                if (b and $0f) > 0 then
                begin //------------------------------------------- новый район управления
                  if config.ru <> (b and $0f) then
                  begin //----------------------------------------------- район управления
                    ChRegion := true;
                    NewRegion := (b and $0f);
                  end;
                end;
              end;
            end;
          end else

          if (w > 0) and (w < 4096) then //------------------------- состояние датчика FR3
          begin
            if pb <> FR3inp[w] then//--------------------------------------------- новизна
            begin
              FR3inp[w] := pb;
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
            end;
            FR3s[w] := LastTime;
          end else

          if (w >= 4096) and (w < 5120) then //------- 2-х байтные данные о непарафазности
          begin
            if j > LnSoobSrv-4 then break;
            ww := w - 4096;
            dw := byte(KanalSrv[kanal].RcvBuf[j]);
            dw := dw shl 8;
            dw := dw + b;
            if FR6[ww] <> dw then           
            NewFR[kanal] := NewFR[kanal]+char(bl)+char(bh)+pb+KanalSrv[kanal].RcvBuf[j];
            FR6[ww] := dw;
            inc(j);
          end else

          if (w >= 5120) and (w < 6144) then  //----------------------- 4-х байтные данные
          begin
            if j+2 > LnSoobSrv-4 then break;
            ww := w - 5119;
            NewFR[kanal] := NewFR[kanal]+char(bl)+char(bh)+pb+KanalSrv[kanal].RcvBuf[j]+
            KanalSrv[kanal].RcvBuf[j+1]+KanalSrv[kanal].RcvBuf[j+2];
            FR7[ww] := b;
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 8;
            FR7[ww] := FR7[ww]+dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]); dc := dc shl 16;
            FR7[ww] := FR7[ww]+dc; inc(j);
            dc := byte(KanalSrv[kanal].RcvBuf[j]);  dc := dc shl 24;
            FR7[ww] := FR7[ww]+dc; inc(j);
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w >= 6144) and (w < 7168) then //------------------------ 8-и байтные данные
          begin
            if j+6 > LnSoobSrv-4 then break;
            ww := w - 6143;
            NewFR[kanal] := NewFR[kanal]+char(bl)+char(bh)+pb+KanalSrv[kanal].RcvBuf[j]+
            KanalSrv[kanal].RcvBuf[j+1]+KanalSrv[kanal].RcvBuf[j+2]+
            KanalSrv[kanal].RcvBuf[j+3]+KanalSrv[kanal].RcvBuf[j+4]+
            KanalSrv[kanal].RcvBuf[j+5]+KanalSrv[kanal].RcvBuf[j+6];
            FR8[ww] := b;

            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 8;
            FR8[ww] := FR8[ww]+i64;  inc(j);

            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 16;
            FR8[ww] := FR8[ww]+i64;  inc(j);

            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 24;
            FR8[ww] := FR8[ww]+i64;  inc(j);

            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 32;
            FR8[ww] := FR8[ww]+i64;  inc(j);

            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 40;
            FR8[ww] := FR8[ww]+i64;  inc(j);

            i64 := byte(KanalSrv[kanal].RcvBuf[j]); i64 := i64 shl 48;
            FR8[ww] := FR8[ww]+i64;  inc(j);

            i64 := byte(KanalSrv[kanal].RcvBuf[j]);  i64 := i64 shl 56;
            FR8[ww] := FR8[ww]+i64;  inc(j);
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w >= 7168) and (w < 8191) then //----------------------------- строка ASCIIZ
          begin
            sz := pb;
            while ((KanalSrv[kanal].RcvBuf[j] > #0) and (j < LnSoobSrv-3)) do
            begin
              sz := sz + KanalSrv[kanal].RcvBuf[j];
              inc(j);
            end;
            NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + sz; //- sz - строка ASCII
            inc(j);
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w and $e000) = $8000 then //---------------------------------- состояние FR4
          begin
            ww := w and $1fff;
            if (ww > 0) and (ww < 4096) then
            begin
              if pb <> FR4inp[ww] then //----------------------------------------- новизна
              begin
                FR4inp[ww] := pb;
                NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              end;
              FR4s[ww] := LastTime;
            end;
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w and $e000) = $4000 then //----------- квитанция на команду, причина отказа
          begin
            ww := w and $1fff;
            if (ww > 0) and (ww < 4096) then
            begin
              NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              if (mm = config.RMID) and WorkMode.CmdReady then
              begin //------------------------------------- обработка квитанции на команду
                KvitancijaFromSrv(ww,b);
              end;
            end;
          end else
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (w and $e000) = $2000 then //------ коды диагностики состояния объектов (FR5)
          begin
            ww := w and $1fff;
            if (ww > 0) and (ww < 4096) then
            begin
              if not ((ww = LastDiagI) and (b = LastDiagN)) then
              begin
                FR5[ww] := FR5[ww] or b;
                LastDiagN := b;  LastDiagI := ww;  LastDiagD := LastTime + 2/80000;
                NewFR[kanal] := NewFR[kanal] + char(bl) + char(bh) + pb;
              end;
            end;
          end else
          begin
            //--- неизвестные данные - сбросить хвост буфера и установить признак ошибки
            LastTime := date+time;
            inc(KanalSrv[kanal].pktlost); //- увеличить счетчик искаженных данных в пакете
            inc(errch[kanal]); errfix[kanal] := true; stmp := '';
            for l := 0 to LnSoobSrv-1 do stmp := stmp + KanalSrv[kanal].RcvBuf[l];

             SaveDUMP(stmp,config.arcpath+ '\kanal'+IntToStr(kanal)+'.dmp');
             KanalSrv[kanal].iserror := true;
             MsgStateRM := 'Искажение данных в канале'+ IntToStr(kanal);
             MsgStateClr := 1;
             break;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if KanalSrv[kanal].RcvPtr > LnSoobSrv then //-- выкинуть из строки обработанный кадр
      begin
        l := 0; i := LnSoobSrv;
        while i < KanalSrv[kanal].RcvPtr do
        begin
          KanalSrv[kanal].RcvBuf[l] :=
          KanalSrv[kanal].RcvBuf[i];inc(i);inc(l);//----------------------- сдвиг к началу
        end;
        KanalSrv[kanal].RcvPtr := l;
      end else
      begin
        KanalSrv[kanal].RcvPtr := 0;  exit; // завершить если списан последний полный кадр
      end;
      goto loop;
    end else
    begin //--------------- контрольная сумма неверна - продолжить поиск в исходной строке
      l := 0; i := 1;
      while i < KanalSrv[kanal].RcvPtr do
      begin
        KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i]; inc(i); inc(l);
      end;
      KanalSrv[kanal].RcvPtr := l; goto loop;
    end;
  end else
  begin //------------- признак конца кадра не найден - продолжить поиск в исходной строке
    l := 0; i := 1;
    while i < KanalSrv[kanal].RcvPtr do
    begin
      KanalSrv[kanal].RcvBuf[l] := KanalSrv[kanal].RcvBuf[i];
      inc(i); inc(l);
    end;
    KanalSrv[kanal].RcvPtr := l; goto loop;
  end;
end;
//========================================================================================
//--------------------------------------------------------- обработка квитанции из сервера
procedure KvitancijaFromSrv(Obj : Word; Kvit : Byte);
begin
  WorkMode.CmdReady := false; // разблокировать прием команды от оператора

  if Obj > High(ObjZav) then
  begin
    reportf('Получена квитанция на несуществующий объект с индексом '+ IntToStr(Obj)); exit;
  end;

  case Kvit of
    1 : begin // сообщение о выполнении маршрутной команды
      if Obj <> WorkMode.DirectStateSoob then
      begin
        MsgStateRM := GetShortMsg(2,Kvit,LastMsgToDSP); MsgStateClr := 2;
      end;
    end;
    2 : begin // Сообщение об отказе от выполнения команды раздельного управления
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
    end;
    3 : begin // отказ от выполнения маршрутной команды
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
    end;
    4 : begin // сообщение о выполнении команды передачи на маневры
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 2;
    end;
    5 : begin // отказ от выполнения команды передачи на маневры
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
      VytajkaOZM(Obj); // сбросить маневровый район, отправленный в сервер
    end;
    6..61 : begin
      MsgStateRM := GetShortMsg(2,Kvit,ObjZav[Obj].Liter); MsgStateClr := 1;
    end;
  end;
end;


//------------------------------------------------------------------------------
// Технологическая функция - сохранение данных из каналов на диск
procedure SaveKanal;
  var i,hfile, hnbw, len: cardinal; fp: longword;
begin
  DateTimeToString(stime, 'hh:nn:ss.zzz', LastTime);
  stime := #13#10+ '['+ stime+ ']'+ #13#10;

  tbuf := '';
  for i := 1 to Length(chnl1) do
  begin
    tbuf := tbuf + IntToHex(byte(chnl1[i]),2) + ' ';
  end;
  tbuf := stime + tbuf; len := Length(tbuf);
  for i := 1 to len do buffarc[i] := byte(tbuf[i]);

  hfile := CreateFile(PChar('c:\kanal1.txt'), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile <> INVALID_HANDLE_VALUE then
  begin
    fp := SetFilePointer(hfile, 0, nil, FILE_END);
    if fp < $ffffffff then
    begin
      OLS.Offset := fp; WriteFile(hfile, buffarc[1], len, hnbw, nil);
    end;
    CloseHandle(hfile);
  end;
  chnl1 := '';

  tbuf := '';
  for i := 1 to Length(chnl2) do
  begin
    tbuf := tbuf + IntToHex(byte(chnl2[i]),2) + ' ';
  end;
  tbuf := stime + tbuf; len := Length(tbuf);
  for i := 1 to len do buffarc[i] := byte(tbuf[i]);

  hfile := CreateFile(PChar('c:\kanal2.txt'), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if hfile <> INVALID_HANDLE_VALUE then
  begin
    fp := SetFilePointer(hfile, 0, nil, FILE_END);
    if fp < $ffffffff then
    begin
      OLS.Offset := fp; WriteFile(hfile, buffarc[1], len, hnbw, nil);
    end;
    CloseHandle(hfile);
  end;
  chnl2 := '';
end;

end.
