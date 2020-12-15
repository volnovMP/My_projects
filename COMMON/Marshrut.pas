unit Marshrut;
{$INCLUDE d:\Sapr2012\CfgProject}
//------------------------------------------------------------------------------
//             Процедуры и структуры установки маршрутов РМ-ДСП
//------------------------------------------------------------------------------

interface

uses
  Windows,
  SysUtils,
  TypeAll;
var

  MarhRdy      : Boolean; //----------------- признак готовности маршрута к выдаче в канал
  LastMsgToDSP : string;
  LastJmp : TOZNeighbour;

function ResetTrace : Boolean;
function ResetMarhrutSrv(fr : word) : Boolean;
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
function EndTracertMarshrut : Boolean;
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function GetSoglOtmeny(Uslovie : SmallInt) : string;

{$IFDEF RMDSP}
function OtmenaMarshruta(Svetofor : SmallInt; Marh : Byte) : Boolean;
{$ENDIF}

function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
function SetProgramZamykanie(Group : Byte; Auto : Boolean) : Boolean;
function SendMarshrutCommand(Group : Byte) : Boolean;
function SendTraceCommand(Group : Byte) : Boolean;
function RestorePrevTrace : Boolean;
{$IFNDEF RMARC}
function AddToTracertMarshrut(index : SmallInt) : Boolean;
function NextToTracertMarshrut(index : SmallInt) : Boolean;
{$ENDIF}
function StepTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte) : TTracertResult;

//------------------------------------------------------ ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ СТРЕЛКУ
function StepTraceStrelka(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepStrelFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelZamykTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelFindIzvStrel(var Con :TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepStrelPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

//---------------------------------------------------- ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ УП ИЛИ СП
function StepTraceSP(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepSPforFindTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforContTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforZavTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforCheckTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPforZamykTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSPPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;


//--------------------------------------------------------- ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ ПУТЬ
function StepTracePut(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepPutFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutZamykTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutFindIzvStrel(var Con :TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepPutPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;


//---------------------------------------------------- ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ СВЕТОФОРЫ
function StepTraceSvetofor(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;

function StepSvetoforFindTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod:Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforContTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforZavTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforCheckTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSvetoforZamykTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigAutoPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepSigFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;


function StepTraceAB(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePriglas(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceUKSPS(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceVSN(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceUvazManRn(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceZaprosPoezdOtpr(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePAB(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceDZOhr(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceIzvPer(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceDZSP(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePoezdSogl(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceUvazGor(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceMarNadvig(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceMarshOtpr(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTracePerezamStrInPut(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceOPI(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceZonaOpov(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function StepTraceProchee(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
function SoglasieOG(Index : SmallInt) : Boolean;
function CheckOgrad(ptr : SmallInt; Group : Byte) : Boolean;
function CheckOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
function NegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
function SignCircOgrad(ptr : SmallInt; Group : Byte) : Boolean;
function SignCircOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
function VytajkaRM(ptr : SmallInt) : Boolean;
function VytajkaZM(ptr : SmallInt) : Boolean;
function VytajkaOZM(ptr : SmallInt) : Boolean;
function VytajkaCOT(ptr : SmallInt) : string;
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
procedure SetNadvigParam(Ptr : SmallInt);
function AutoMarsh(Ptr : SmallInt; mode : Boolean) : Boolean;
function CheckAutoMarsh(Ptr : SmallInt; Group : Byte) : Boolean;
function AutoMarshReset(Ptr : SmallInt) : Boolean;
function AutoMarshON(Ptr : SmallInt; Napr : Boolean) : Boolean;
function AutoMarshOFF(Ptr : SmallInt; Napr : Boolean  ) : Boolean;

const
  MarshM = 3;   //----------------------------------------------------- Маневровый маршрут
  MarshP = 12;  //------------------------------------------------------- Поездной маршрут
  MarshL = 19;  //--------------------------------------------------- Логическое замыкание


  TryMarhLimit = 6962;//----------------------- счетчик объектов при трассировке маршрута.
                      //----------------  кол-во пройденых объектов превысит это значение,
                      //-------- то сообщение 231 ("превышен счетчик попыток трассировки")

implementation

uses
  Commands,
  CMenu,
  MainLoop,

{$IFDEF RMDSP}
  TabloForm,
{$ENDIF}

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

{$IFDEF RMSHN}
  TabloSHN,
{$ENDIF}

{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}
  Commons;

var
  tm : string;

//========================================================================================
function ResetTrace : Boolean;
//----------------------------------------------------- Сбросить структуры набора маршрута
var
  i,k,o : integer;
begin
try
  WorkMode.GoTracert        :=false; //-------------- сбросить признак "идет трассировка"
  MarhTracert[1].SvetBrdr   :=0;//сброс индекса светофора,ограждающ. элементарный участок
  MarhTracert[1].AutoMarh   :=false;//сброс признака трассир.маршрута автодействия сигнала
  MarhTracert[1].Povtor     :=false;//сброс признака повторной проверки трассы маршрута
                                    //  (для снятия контроля предварит. замыкания на АРМе)
  MarhTracert[1].GonkaStrel :=false;//--- сброс признака допустимости выдачи команды гонки
                                    //  стрелок (для трассы маршрута без замыкания трассы)
  MarhTracert[1].GonkaList  :=0; //------------сброс количества стрелок для выдачи команды
                                 // гонки стрелок для трассы маршрута без замыкания трассы
  Marhtracert[1].LockPovtor :=false;//сброс признака блокировки выдачи повторной установки
                                    //            маршрута после обнаружения враждебностей
  MarhTracert[1].Finish     :=false; //---- сбросить разрешение нажать кнопку конца набора
  MarhTracert[1].TailMsg    := '';  //--------------- сбросить сообщение в хвосте маршрута
  MarhTracert[1].FindTail   := false;//---------- сбросить признак набора строки сообщения
                                     //                            о конце трассы маршрута
  MarhTracert[1].WarCount   := 0; //сбросить счетчик предупреждений при установке маршрута
  MarhTracert[1].MsgCount   := 0; //--------------- сбросить счетчик сообщений трассировки
  k := 0;
  MarhTracert[1].VP         := 0; //--- сбросить объект ВП для трассировки маршрута приема
  MarhTracert[1].TraceRazdel := false;//сброс признака трассировки в раздельном управлении
  if MarhTracert[1].ObjStart > 0 then //----------------- если есть объект начала маршрута
  begin //------------------------------------------------ сброс признака ППР на светофоре
    k := MarhTracert[1].ObjStart;
    if not ObjZav[k].bParam[14] then
    begin
      ObjZav[k].bParam[7] := false; //----------------------- сброс маневровой трассировки
      ObjZav[k].bParam[9] := false; //------------------------- сброс поездной трассировки
    end;
  end;
  MarhTracert[1].ObjStart := 0;
  for i := 1 to WorkMode.LimitObjZav do
  begin // Сборос признаков трассировки на всех объектах станции
    case ObjZav[i].TypeObj of

      1 : begin // хвост стрелки
        ObjZav[i].bParam[27] := false;
        ObjZav[i].iParam[3] := 0;
      end;

      2 : begin // стрелка
        ObjZav[i].bParam[10] := false;
        ObjZav[i].bParam[11] := false;
        ObjZav[i].bParam[12] := false;
        ObjZav[i].bParam[13] := false;
      end;

      3 : begin // секция
        if not ObjZav[i].bParam[14] then
        begin
          ObjZav[i].bParam[8] := true;
        end;
      end;

      4 : begin // путь
        if not ObjZav[i].bParam[14] then
        begin
          ObjZav[i].bParam[8] := true;
        end;
      end;

      5 : begin // светофор
        if not ObjZav[i].bParam[14] and // нет предварительного замыкания
           ObjZav[i].bParam[11] then    // нет исполнительного замыкания
        begin
          ObjZav[i].bParam[7] := false;
          ObjZav[i].bParam[9] := false;
        end;
      end;

      8 : begin // УТС
        ObjZav[i].bParam[27] := false;
      end;

      15 : begin // АБ
        if not ObjZav[i].bParam[14] and // нет предварительного замыкания
           ObjZav[ObjZav[i].BaseObject].bParam[2] then // нет исполнительного замыкания
        begin
          ObjZav[i].bParam[15] := false;
        end;
      end;

      25 : begin // Колонка
        if not ObjZav[i].bParam[14] then // нет предварительного замыкания
        begin
          ObjZav[i].bParam[8] := false;
        end;
      end;

      41 : begin // Контроль маршрута отправления
        o := ObjZav[i].UpdateObject;
        if not ObjZav[o].bParam[14] and ObjZav[o].bParam[2] and // нет предварительного или исполнительного замыкания
           not ObjZav[ObjZav[i].BaseObject].bParam[3] and not ObjZav[ObjZav[i].BaseObject].bParam[4] then // выходной сигнал не открыт поездным
        begin
          ObjZav[i].bParam[20] := false;
          ObjZav[i].bParam[21] := false;
        end;
      end;

      42 :
      begin //-------------------------------------- перезамыкание поездного на маневровый
        o := ObjZav[i].UpdateObject;      //------------------------ контролируемая секция
        if not ObjZav[o].bParam[14] and //------- если нет программного замыкания секции и
        ObjZav[o].bParam[2] then //------------------------------- нет релейного замыкания
        begin
          ObjZav[i].bParam[1] := false;  //------  признак поездного маршрута приема снять
          ObjZav[i].bParam[2] := false; //--------- признак разрешения перезамыкания снять
        end;
      end;
    end;
  end;

  //--------------------------------------------------------------- очистить все сообщения
  for i := 1 to High(MarhTracert[1].Msg) do
  begin
    MarhTracert[1].Msg[i] := '';
    MarhTracert[1].MsgIndex[i] := 0;
    MarhTracert[1].MsgObject[i] := 0;
  end;
  MarhTracert[1].MsgCount := 0;
  //---------------------------------------------------------- очистить все предупреждения
  for i := 1 to High(MarhTracert[1].Warning) do
  begin
    MarhTracert[1].Warning[i]  := '';
    MarhTracert[1].WarIndex[i] := 0;
    MarhTracert[1].WarObject[i] := 0;
  end;
  MarhTracert[1].WarCount := 0;

  //------------------------------------------------------------ очистить все точки трассы
  for i := 1 to High(MarhTracert[1].ObjTrace) do MarhTracert[1].ObjTrace[i] := 0;
  MarhTracert[1].Counter := 0;

  //---------------------------------------------------------- очистить все стрелки трассы
  for i := 1 to High(MarhTracert[1].StrTrace) do
  begin
    MarhTracert[1].StrTrace[i] := 0;
    MarhTracert[1].PolTrace[i,1] := false;
    MarhTracert[1].PolTrace[i,2] := false;
  end;
  MarhTracert[1].StrCount := 0;

  MarhTracert[1].ObjEnd := 0;
  MarhTracert[1].ObjLast := 0;
  MarhTracert[1].ObjStart := 0;

  MarhTracert[1].PinLast := 0;
  MarhTracert[1].Rod := 0;

  WorkMode.GoTracert := false;

  if (k > 0) and not ObjZav[k].bParam[14] then
  begin
    InsArcNewMsg(k,2,1);
    ShowShortMsg(2,LastX,LastY,'от '+ ObjZav[k].Liter);
  end;
  ResetTrace := true;
  ZeroMemory(@MarhTracert[1],sizeof(MarhTracert[1]));
except
  reportf('Ошибка [Marshrut.ResetTrace]'); ResetTrace := false;
end;
end;
//========================================================================================
function ResetMarhrutSrv(fr : word) : Boolean;
//---------------------------------------------------- Реакция на сброс маршрута в сервере
var
  i,im : integer;
begin
try
  im := 0;
  // поиск индекса маршрута по номеру FR3
  for i := 1 to WorkMode.LimitObjZav do
    if ObjZav[i].TypeObj = 5 then
    begin
      if ObjZav[i].ObjConstI[3] > 0 then
        if fr = (ObjZav[i].ObjConstI[3] div 8) then begin im := i; break; end;
      if ObjZav[i].ObjConstI[5] > 0 then
        if fr = (ObjZav[i].ObjConstI[5] div 8) then begin im := i; break; end;
    end;
  if im > 0 then
  begin // установить признак сброса маршрута на сервере для всех светофоров данного маршрута
    for i := 1 to WorkMode.LimitObjZav do
      if ObjZav[i].TypeObj = 5 then
        if ObjZav[i].iParam[1] = im then ObjZav[i].bParam[34] := true; // установить на светофоры в составном маршруте
    if ObjZav[im].RU = config.ru then
    begin // вывести сообщение о неисполнении маршрута
      MsgStateRM := GetShortMsg(2,7,ObjZav[im].Liter,1);
      MsgStateClr := 1;
    end;
    InsArcNewMsg(im,7+$400,1);
    ResetMarhrutSrv := true;
  end else
  begin // индекс маршрута не определен
    ResetMarhrutSrv := false;
  end;
except
  reportf('Ошибка [Marshrut.ResetMarhrutSrv]'); ResetMarhrutSrv := false;
end;
end;
//========================================================================================
procedure InsWar(Group,Obj,Index : SmallInt);
//---------------------------------------------------------- добавить новое предупреждение
begin
  MarhTracert[Group].WarObject[MarhTracert[Group].WarCount] := Obj;
  MarhTracert[Group].WarIndex[MarhTracert[Group].WarCount] := Index;
end;
//========================================================================================
procedure InsMsg(Group,Obj,Index : SmallInt);
//----------------------------------------------------- добавить обнаруженную враждебность
begin
  MarhTracert[Group].MsgObject[MarhTracert[Group].MsgCount] := Obj;
  MarhTracert[Group].MsgIndex[MarhTracert[Group].MsgCount] := Index;
end;
//========================================================================================
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//------------------------------------------ открыть сигнал в раздельном режиме управления
var
  i : Integer;
  jmp : TOZNeighbour;
begin
try
  ResetTrace;
  if Marh = MarshM then
  begin
    ObjZav[Svetofor].bParam[7] := true;
    ObjZav[Svetofor].bParam[9] := false;
  end else
  begin
    ObjZav[Svetofor].bParam[7] := false;
    ObjZav[Svetofor].bParam[9] := true;
  end;

  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].WarCount := 0;
  MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;

  // Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTracert[Group].Level := tlRazdelSign; //---------- режим открыть сигнал в раздельном
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd : break;

      trEndTrace : break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    result := false;
    InsArcNewMsg(Svetofor,228,1);
    ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
    Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  //--------------------------------------------------------- отказ по враждебности
    MarhTracert[1].TraceRazdel := true;//---- Закончить трассировку если есть враждебности
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki (Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1); //
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- вывод сообщений

    CreateDspMenu(CmdMarsh_Razdel,LastX,LastY);
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
except
  reportf('Ошибка [Marshrut.OtkrytRazdel]'); result := false;
end;
end;

//========================================================================================
function CheckAutoMarsh(Ptr : SmallInt; Group : Byte) : Boolean;
//-------------------- Проверка возможности выдачи команды установки маршрута автодействия
//-------------------------------- Ptr - объект автодействия для светофора с автодействием
//--------------------------------------------------------------------- Group - группа КРУ
var
  i : Integer;
  jmp : TOZNeighbour;
  tr : boolean;
begin
  try
    result := false;
    //------------------------- проверить наличие противоповторности маршрута автодействия
    if ObjZav[Ptr].bParam[2] then   //---------------------- если противоповторка взведена
    begin
      //----------------------------------------- ожидать готовность маршрута автодействия
      MarhTracert[Group].Rod := MarshP;
      MarhTracert[Group].Finish := false;
      MarhTracert[Group].WarCount := 0;
      MarhTracert[Group].MsgCount := 0;
      MarhTracert[Group].ObjStart := ObjZav[Ptr].BaseObject; //-- светофор с автодействием
      MarhTracert[Group].Counter := 0;

      //- Выдать команду открытия сигнала автодействия в виде раздельного открытия сигнала
      i := 1000;
      jmp := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2]; //- сосед светофора со стороны 2
      MarhTracert[Group].FindTail := true;
      //--------------------------------- проверить замыкание перекрывной секции светофора
      if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].BaseObject].bParam[2] then //если снято "З"
      begin
        //------- снять признак занятия перекрывной секции при отсутствии замыкания секции
        ObjZav[Ptr].bParam[3] := false; //- сброс признака фикс.занятия СП маршрута автод.
        ObjZav[Ptr].bParam[4] := false;// сброс признака фикс.занятия при открытом сигнале
        ObjZav[Ptr].bParam[5] := false;  //- сброс признака фикс.выдачи сообщ.о неоткрытии
        tr := true;
      end else
      begin
        //----- проверить занятие перекрывной секции после замыкания маршрута автодействия
        tr := false;
        if ObjZav[Ptr].bParam[3] then
        begin //------------ зафиксировано занятие перекрывной секции в замкнутом маршруте
          if not ObjZav[Ptr].bParam[4] then
          begin
            if not ObjZav[Ptr].bParam[5] then
            begin
              InsArcNewMsg(ObjZav[Ptr].BaseObject,475,1);//Сигнал  не открыт командой АвДт
              AddFixMessage(GetShortMsg(1,475,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,5);
              ObjZav[Ptr].bParam[5] := true;
            end;
          end;
          MarhTracert[Group].ObjStart := 0;
          exit;
        end else
        if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].BaseObject].bParam[1] then
        begin //---------------------------------------------------------- секция свободна

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[Group].Level := tlSignalCirc;  //----------- режим сигнальная струна
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        end else
        begin
          ObjZav[Ptr].bParam[3] := true; //--------- фиксировать занятие секции в маршруте
          if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
          //-------- фиксация открытого состояния сигнала на момент занятия перекрывной СП
          ObjZav[Ptr].bParam[4] := true;
          MarhTracert[Group].ObjStart := 0;
          exit;
        end;
      end;

      if tr then
      begin // выбрать условия проверки для незамкнутого от реле "З" маршрута автодействия

        if ObjZav[ObjZav[Ptr].BaseObject].bParam[9] or  //признак поездной трассировки или
        ObjZav[ObjZav[Ptr].BaseObject].bParam[14] then //-- признак программного замыкания

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[Group].Level := tlPovtorRazdel //- режим повтор открытия по замкнутому
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        else

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[Group].Level := tlRazdelSign;//----- режим открыть сигнал в раздельном
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      end;

      MarhTracert[Group].AutoMarh := true;
      MarhTracert[Group].SvetBrdr := ObjZav[Ptr].BaseObject;
      ObjZav[ObjZav[Ptr].BaseObject].bParam[9] := true;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
          trStop, trEnd, trEndTrace :  break;
        end;
        dec(i);
      end;

      if i < 1 then exit; //------------------------------------ трасса маршрута разрушена

      if MarhTracert[Group].MsgCount > 0 then
      begin
        MarhTracert[Group].ObjStart := 0;
        exit; //---------------------------------------------------- отказ по враждебности
      end;
      result := true;
    end else
    begin //------------------ проверить враждебности по всей трассе маршрута автодействия
      ObjZav[ObjZav[Ptr].BaseObject].bParam[7] := false; //-- сброс маневровой трассировки
      ObjZav[ObjZav[Ptr].BaseObject].bParam[9] := false; //---- сброс поездной трассировки
      MarhTracert[Group].Rod := MarshP;
      MarhTracert[Group].Finish := false;
      MarhTracert[Group].WarCount := 0;
      MarhTracert[Group].MsgCount := 0;
      MarhTracert[Group].ObjStart := ObjZav[Ptr].BaseObject;
      MarhTracert[Group].Counter := 0;
      i := 1000;
      jmp := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2];

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      MarhTracert[Group].Level := tlAutoTrace; //--- режим  открыть сигнал в маршр. автод.
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      MarhTracert[Group].FindTail := true;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
          trStop, trEnd, trEndTrace : break;
        end;
        dec(i);
      end;

      if i < 1 then exit; //------------------------------------ трасса маршрута разрушена
      if MarhTracert[Group].MsgCount > 0 then
      begin
{
        if not ObjZav[Ptr].bParam[4] then
        begin
          AddFixMessage(GetShortMsg(1,475,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,5);
        end;
}
        MarhTracert[Group].ObjStart := 0;
        MarhTracert[Group].MsgCount := 0;
        exit; //---------------------------------------------------- отказ по враждебности
      end;
      //--------------------------------------------------------- защитный участок занят ?
      case ObjZav[ObjZav[Ptr].UpdateObject].TypeObj of
        4 :
        begin //--------------------------------------------------------------------- путь
          if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] or
          not ObjZav[ObjZav[Ptr].UpdateObject].bParam[16] then
          begin
            MarhTracert[Group].ObjStart := 0;
            exit;
          end;
        end;

        15 :
        begin //----------------------------------------------------------------------- АБ
          if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] then
          begin
            MarhTracert[Group].ObjStart := 0;
            exit;
          end;
        end;

        else //--------------------------------------------------------------------- СП,УП
          if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] then
          begin
            MarhTracert[Group].ObjStart := 0;
            exit;
          end;
      end;

      ObjZav[Ptr].bParam[2] := true;
    end;
  except
    reportf('Ошибка [Marshrut.CheckAutoMarsh]'); result := false;
  end;
end;
//========================================================================================
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//----------------------------------------- Сделать проверки повторного открытия светофора
var
  i : Integer;
  jmp : TOZNeighbour;
begin
  try
    ResetTrace;
    MarhTracert[Group].SvetBrdr := Svetofor;
    MarhTracert[Group].Finish := false;
    MarhTracert[Group].Rod := Marh;
    MarhTracert[Group].TailMsg := '';
    MarhTracert[Group].WarCount := 0;
    MarhTracert[Group].MsgCount := 0;
    MarhTracert[Group].ObjStart := Svetofor;
    //---------------------------------------------- Проверить враждебности по всей трассе
    i := 1000;
    jmp := ObjZav[Svetofor].Neighbour[2];
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlSignalCirc;  //----------------- режим сигнальная струна
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTracert[Group].FindTail := true;
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd :  break;
        trEndTrace :  break;
      end;
      dec(i);
    end;

    if i < 1 then
    begin //---------------------------------------------------- трасса маршрута разрушена
      InsArcNewMsg(Svetofor,228,1); //---------------------- Трасса маршрута от $ нарушена
      result := false;
      ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
      Marhtracert[Group].LockPovtor := true;
      MarhTracert[Group].ObjStart := 0;
      exit;
    end;

    if MarhTracert[Group].MsgCount > 0 then
    begin  //------------------------------------------------------- отказ по враждебности
    // Закончить трассировку и сбросить трассу если есть враждебности
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;
  //-------- Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- вывод сообщений
    CreateDspMenu(CmdMarsh_Povtor,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;
{$ENDIF}  
  result := true;
except
  reportf('Ошибка [Marshrut.PovtorSvetofora]'); result := false;
end;
end;
//========================================================================================
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//проверки повторного открытия сигнала (в раздельном) по предварительному замыканию трассы
var
  i : Integer;
  jmp : TOZNeighbour;
begin
try
  ResetTrace;
  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].TailMsg := '';
  MarhTracert[Group].WarCount := 0;
  MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;
  //------------------------------------------------ Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTracert[Group].Level := tlPovtorRazdel;  //----- режим повтор открытия по замкнутому
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd :
        break;

      trEndTrace :
        break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    InsArcNewMsg(Svetofor,228,1);
    result := false;
    ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  //--------------------------------------------------------- отказ по враждебности
    //--------------------- Закончить трассировку и сбросить трассу если есть враждебности
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  //-------- Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
  
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- вывод сообщений
    CreateDspMenu(CmdMarsh_PovtorOtkryt,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;
{$ENDIF}
  result := true;
except
  reportf('Ошибка [Marshrut.PovtorOtkrytSvetofora]');
  result := false;
end;
end;
//========================================================================================
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
//-------------------------------------------------- Выполнить повторную устаноку маршрута
var
  i,j : Integer;
  jmp : TOZNeighbour;
begin
  try
    ResetTrace;
    MarhTracert[Group].SvetBrdr := Svetofor;
    MarhTracert[Group].Finish := false;
    MarhTracert[Group].Rod := Marh;
    MarhTracert[Group].TailMsg := '';
    MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
    MarhTracert[Group].ObjStart := Svetofor;
    //---------------------------------------------- Проверить враждебности по всей трассе
    i := 1000;
    jmp := ObjZav[Svetofor].Neighbour[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlPovtorMarh; //------- режим повторная установка маршрута
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTracert[Group].FindTail := true;

    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd : break;
        trEndTrace : break;
      end;
      dec(i);
    end;

    if i < 1 then
    begin //---------------------------------------------------- трасса маршрута разрушена
      InsArcNewMsg(Svetofor,228,1); //-------------------- "Трасса маршрута от $ нарушена"
      result := false;
      ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter);
      Marhtracert[Group].LockPovtor := true;
      MarhTracert[Group].ObjStart := 0;
      exit;
    end;

    if MarhTracert[Group].MsgCount > 0 then
    begin  //------------------------------------------------------- отказ по враждебности
      //------------------- Закончить трассировку и сбросить трассу если есть враждебности
      InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
      PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]);
      result := false;
      Marhtracert[Group].LockPovtor := true;
      MarhTracert[Group].ObjStart := 0;
      exit;
    end;

    //---------------------------------------------- Проверить враждебности по всей трассе
    i := 1000;
    MarhTracert[Group].SvetBrdr := Svetofor;
    MarhTracert[Group].Povtor := true;
    MarhTracert[Group].MsgCount := 0;
    //----------- "хвостом" навязывается объект, расположенный следом за сигналом маршрута
    MarhTracert[Group].HTail := MarhTracert[Group].ObjTrace[1];
    jmp := ObjZav[MarhTracert[Group].ObjStart].Neighbour[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlCheckTrace;//---- режим проверка враждебностей по трассе 
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    if MarhTracert[Group].ObjEnd < 1 then
    begin
        j := MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter];
        MarhTracert[Group].ObjEnd := j;
    end
    else  j := MarhTracert[Group].ObjEnd;

    while MarhTracert[Group].ObjEnd < 1 do
    begin
      j := MarhTracert[Group].ObjTrace[j];
      MarhTracert[Group].ObjEnd := j;
      dec(j);
    end;


    MarhTracert[Group].CIndex := 1;
    while i > 0 do
    begin
      if jmp.Obj = j then
      begin // Обнаружен объект конца трассы
        // Враждебности в хвосте
      StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);
      break;
    end;

    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
      trStop : begin
        break;
      end;
    end;
    dec(i);
    inc(MarhTracert[Group].CIndex);
  end;

  if i < 1 then
  begin // отказ по превышению счетчика
    InsArcNewMsg(Svetofor,231,1);
    RestorePrevTrace; result := false;
    ShowShortMsg(231, LastX, LastY, '');
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  //--------------------------------------------------------- отказ по враждебности
    //--------------------- Закончить трассировку и сбросить трассу если есть враждебности
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1],1);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[Group]);
    result := false;
    Marhtracert[Group].LockPovtor := true;
    MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  //-------- Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount);
    MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
    GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTracert[Group].WarCount > 0 then
  begin //---------------------------------------------------------------- вывод сообщений
    CreateDspMenu(CmdMarsh_PovtorMarh,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
except
  reportf('Ошибка [Marshrut.PovtorMarsh]'); result := false;
end;
end;
//========================================================================================
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
// Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках (для ДСП)
//--------------------------------- Svetofor - индекс проверяемого сигнала начала маршрута
//------------------------------------------ Marh - тип маршрута (поездной или маневровый)
//---------------------- возвращает  признак незамкнутых стрелок &  признак занятых секций
var
  i : integer;
  jmp : TOZNeighbour;
begin
  try
    result := false;
    if Svetofor < 1 then exit;
    i := 1000; //--------------------------------------- установить предельное число шагов
    MarhTracert[1].IzvStrNZ := false;//- сброс наличия незамкнутых стрелок перед маршрутом
    MarhTracert[1].IzvStrFUZ := false; // сброс признака занятости участка первым составом
    MarhTracert[1].IzvStrUZ := false;//сброс признака наличия занятых секций на предмаршр.

    MarhTracert[1].ObjStart := Svetofor; //----- начинаем смотреть от открываемого сигнала

    jmp := ObjZav[Svetofor].Neighbour[1]; //------------------------- сосед перед сигналом

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[1].Level := tlFindIzvStrel;//-- режим "проверка незамк. предмарш. стрелок"
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    while i > 0 do //--------------------------------------------- выполнить цикл проверки
    begin
      //------------------------------------------------ переключатель по результатам шага
      case StepTrace(jmp, MarhTracert[1].Level, MarhTracert[1].Rod, 1) of
        trStop, //----- результат шага = конец трассировки из-за обнаружения враждебностей
        trEnd,  //-------------------------------------- или - конец трассировки фрагмента
        trBreak : //-------------------------- или - приостановить продвижение по объектам
        begin
          //------------ результат = признак незамкнутых стрелок и  признак занятых секций
          result := MarhTracert[1].IzvStrNZ and MarhTracert[1].IzvStrUZ;
          if result then //----------------------------------------- если есть то и другое
          begin //-------------------------------------------------- выдать предупреждение
            SingleBeep := true;
{$IFNDEF TABLO}
            TimeLockCmdDsp := LastTime;
{$ENDIF}
            LockCommandDsp := true;
            ShowWarning := true;
          end;
          break;
        end;
      end;
      dec(i);
    end;
  except
    reportf('Ошибка [Marshrut.FindIzvStrelki]'); result := false;
  end;
end;
//========================================================================================
function GetSoglOtmeny(Uslovie : SmallInt) : string;
//------------------------------------------ получение признака разрешения отмены маршрута
begin
  try
    result := '';
    if Uslovie > 0 then
    begin //-------------------------------------- проверить разрешение на отмену маршрута
      case ObjZav[Uslovie].TypeObj of //---------------------------- если условие типа ...
        30 :
        begin //------------------------------------------- дача согласия поездного приема
          if ObjZav[Uslovie].bParam[2] then  //--- если "И"
          //------------------------------------- замкнут маршрут до (светофора увязки)...
          result := GetShortMsg(1,254,ObjZav[ObjZav[Uslovie].BaseObject].Liter,1);
        end;

      33 :
      begin //---------------------------------------------------------- дискретный датчик
        if ObjZav[Uslovie].ObjConstB[1] then  //-------------------- если датчик инверсный
        begin
          if ObjZav[Uslovie].bParam[1] then   //------------------- если датчик установлен
          result := MsgList[ObjZav[Uslovie].ObjConstI[3]]; //------ сообщить об отключении
        end else
        begin
          if ObjZav[Uslovie].bParam[1] then
          result := MsgList[ObjZav[Uslovie].ObjConstI[2]]; //-------- сообщить о включении
        end;
      end;

      38 :
      begin //------------------------------------------------------------ маршрут надвига
        if ObjZav[Uslovie].bParam[1] then    //-------------------------------- если В ???
        //----------------------------------------------- установлен маршрут надвига с ...
        result := GetShortMsg(1,346,ObjZav[ObjZav[Uslovie].BaseObject].Liter,1);
      end;
    end;
  end;
  except
    reportf('Ошибка [Marshrut.GetSoglOtmeny]'); result := '';
  end;
end;
//========================================================================================
function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
//------------------------ Получить состояние известителя при отмене маршрута (Только ДСП)
//-------------------------------------  Svetofor - индекс светофораt; Marh - тип маршрута

var
  i : integer;
  jmp : TOZNeighbour;
begin
  try
    result := 0;
    if Svetofor < 1 then exit; //------------------------------ не указан светофор - выйти
    MarhTracert[1].Rod := Marh;
    case Marh of
      MarshP :  //------------------------------------------------------- поездной маршрут
      begin
        //------------------------------------------ проверить схему поездного известителя
        if ObjZav[Svetofor].ObjConstI[27] > 0 then //------ если есть поездной известитель
        begin
          if ObjZav[ObjZav[Svetofor].ObjConstI[27]].bParam[1] then//если известитель занят
          begin result := 1; exit; end;//--------- Поезд на предмаршрутном участке - выйти
        end;
        //---------------------------------------------- пройти по предмаршрутному участку
        if ObjZav[Svetofor].ObjConstB[19] //---- если предмаршрутный короткий для поездных
        then MarhTracert[1].IzvCount := 0   //----------------------- то блок-участков нет
        else MarhTracert[1].IzvCount := 1; //------ если не короткий, то блок-участок один
      end;

      MarshM : //------------------------------------------------------ маневровый маршрут
      begin
        if ObjZav[Svetofor].ObjConstB[20]  //- если предмаршрутный короткий для маневровых
        then MarhTracert[1].IzvCount := 0 //------------------------- то блок-участков нет
        else MarhTracert[1].IzvCount := 1; //------ если не короткий, то блок-участок один
      end;

      else MarhTracert[1].IzvCount := 1; //---- для прочих маршрутов блок-участок один ???
    end;

    if not ObjZav[Svetofor].bParam[2] and  //------------ если нет МС2 и нет С2 , то выйти
    not ObjZav[Svetofor].bParam[4]
    then exit; //----------------------------------------------------------- сигнал закрыт

    i := 1000;
    jmp := ObjZav[Svetofor].Neighbour[1]; //--------------------- начальная точка маршрута

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[1].Level := tlFindIzvest;//- режим сбор известителя перед отменой маршрута
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
      trStop, trEnd : break;

      trBreak :
      begin
        //------------------------------------- проверить местонахождение занятого участка
        if MarhTracert[1].IzvCount < 2 then
        begin //--------------------------------------------------- предмаршрутный участок
          if ObjZav[jmp.Obj].TypeObj = 26 then result := 3
          else

          if ObjZav[jmp.Obj].TypeObj = 15 then result := 3
          else result := 1;
        end
        else  result := 2; //------------------------------------------- поезд на маршруте
        SingleBeep := true;
{$IFNDEF TABLO}
        TimeLockCmdDsp := LastTime;
{$ENDIF}
        LockCommandDsp := true;
        ShowWarning := true;
        break;
      end;
    end;
    dec(i);
  end;
  except
    reportf('Ошибка [Marshrut.GetIzvestitel]'); result := 0;
  end;
end;
{$IFDEF RMDSP}
//========================================================================================
function OtmenaMarshruta(Svetofor : SmallInt; Marh : Byte) : Boolean;
var
  index,i : integer;
  jmp : TOZNeighbour;
//----------------------------------- Выдать команду отмены маршрута в сервер (Только ДСП)
begin
  result := false;
  try
    //--------------------------- маршрут замкнут исполнительными устройствами или сервером}
    index := Svetofor;
    MarhTracert[1].TailMsg := '';
    MarhTracert[1].ObjStart := Svetofor;
    MarhTracert[1].Rod := Marh;
    MarhTracert[1].Finish := false;
    if ObjZav[ObjZav[MarhTracert[1].ObjStart].BaseObject].bParam[2] then
    begin
      //--------------------------------------------- снять блокировки головного светофора
      ObjZav[MarhTracert[1].ObjStart].bParam[14] := false;
      ObjZav[MarhTracert[1].ObjStart].bParam[7] := false;
      ObjZav[MarhTracert[1].ObjStart].bParam[9] := false;
    end;
    i := 1000;
    jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2]; // начальная точка

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[1].Level := tlOtmenaMarh;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    //------------------------------------------------ снять блокировки элементов маршрута
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
        trStop, trEnd : break;
      end;
      dec(i);
    end;

    //----------------------------------------------------- Выдать команду отмены маршрута
    case Marh of
      MarshM :
      begin
        if SendCommandToSrv(ObjZav[index].ObjConstI[3] div 8, cmdfr3_svzakrmanevr, index)
        then
        begin
          InsArcNewMsg(Index,24,7);
          ShowShortMsg(24, LastX, LastY, ObjZav[index].Liter);
          result := true;
        end;
      end;

      MarshP :
      begin
        if SendCommandToSrv(ObjZav[index].ObjConstI[5] div 8, cmdfr3_svzakrpoezd, index)
        then
        begin
          InsArcNewMsg(Index,25,7);
          ShowShortMsg(25, LastX, LastY, ObjZav[index].Liter);
          result := true;
        end;
      end;
    end;
    MarhTracert[1].ObjStart := 0;
  except
   reportf('Ошибка [Marshrut.OtmenaMarshruta]');
   result := false;
  end;   
end;
{$ENDIF}
//========================================================================================
function SetProgramZamykanie(Group : Byte; Auto : Boolean) : Boolean;
//--------------------------------------------------------------- Замкнуть трассу маршрута
var
  jmp : TOZNeighbour;
  i,j,k,obj_tras,Sig_End : integer;
begin
  try
    k := 0;
    //-------------------------------- Установить программное замыкание элементов маршрута
    MarhTracert[Group].SvetBrdr := MarhTracert[Group].ObjStart;//запомнить светофор начала
    MarhTracert[Group].Finish := false;    //------------- конец набора пока нажать нельзя
    MarhTracert[Group].TailMsg := '';      //------ сообщения о "хвосте" маршрута пока нет
    ObjZav[MarhTracert[Group].ObjStart].bParam[14] := true; //- программно замкнуть сигнал

    ObjZav[MarhTracert[Group].ObjStart].iParam[1] :=
    MarhTracert[Group].ObjStart; //----------------------------- запомнить начало маршрута

    i := MarhTracert[Group].Counter; //---------------- запомнить число элементов маршрута

    jmp := ObjZav[MarhTracert[Group].ObjStart].Neighbour[2]; //----------- сосед в точке 2

    //############## К О М П Ь Ю Т Е Р Н О Е  З А М Ы К А Н И Е ##########################
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTracert[Group].Level := tlZamykTrace; // этап трассировки = компьютерное замыкание
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTracert[Group].FindTail := true; //--------------- признак набора для конца трассы
    j := MarhTracert[Group].ObjEnd;

    if ObjZav[j].TypeObj <> 5 then
    begin
      k := 1;
      obj_tras := MarhTracert[Group].ObjTrace[i];
      while ((ObjZav[obj_tras].TypeObj <> 5) and (k <> i)) do
      begin
        obj_tras := MarhTracert[Group].ObjTrace[i-k];
        inc(k);
      end;
    end
    else obj_tras := j;

    if (k > 0) and (i <> k) then MarhTracert[Group].ObjEnd := obj_tras;
    Sig_End := obj_tras;
    if ObjZav[Sig_End].TypeObj = 5 then
    begin
      if ((MarhTracert[Group].Rod = MarshP) and not ObjZav[Sig_End].ObjConstB[5])
      or((MarhTracert[Group].Rod = MarshM) and
      not(ObjZav[Sig_End].ObjConstB[7] or ObjZav[Sig_End].ObjConstB[8])) then
      begin
        obj_tras := MarhTracert[Group].ObjStart;
        ObjZav[obj_tras].bParam[9] := false;
        ObjZav[obj_tras].bParam[7] := false;
        ObjZav[obj_tras].bParam[14] := false;
        ResetTrace;
        InsArcNewMsg(obj_tras,77,1);
        ShowShortMsg(77, LastX, LastY, ObjZav[obj_tras].Liter);
        result := false;
        exit;
      end;
    end;
    

    MarhTracert[Group].CIndex := 1; //----------------- проверяемый объект первый в трассе
    if j < 1 then j := MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter];
    while i > 0 do
    begin
      if jmp.Obj = j then //-------------------------------- Обнаружен объект конца трассы
      begin
        case ObjZav[jmp.Obj].TypeObj of
          //-------------------------- стрелка в конце трассы маршрута необходимо замкнуть
          2 : StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);

          5 : //-------------------------------------------------- светофор в конце трассы
          begin
            //попали в тчк 2,значит встречный в конце трассы маршрута, необходимо замкнуть
            if jmp.Pin = 2 then
            StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group)
            else //------------------------ если не точка 2, то попутный светофор в хвосте
            if MarhTracert[Group].FindTail //-------------- если хвост маршрута ещё пустой
            then MarhTracert[Group].TailMsg:=' до '+ObjZav[jmp.Obj].Liter;//хвост маршрута
          end;

          //------------------------------- АБ в конце трассы маршрута необходимо замкнуть
          15 : StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);

          30 : //------------------------------------------ объект дачи поездного согласия
          begin
            if MarhTracert[Group].FindTail// если нужно искать хвост, то это сигнал увязки
            then MarhTracert[Group].TailMsg:=' до '+ObjZav[ObjZav[jmp.Obj].BaseObject].Liter;
          end;

          //------------------------------------------------------- объект увязки с горкой
          32 : MarhTracert[Group].TailMsg:=' до '+ ObjZav[jmp.Obj].Liter;//Надвиг на горку
        end;
        break; //---------------------------- выход из цикла при достижении конца маршрута
      end;
      //----- если конец трассы еще не достигнут то делаем очередной шаг и анализируем его
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd : //если вышли на враждебность или конец фрагмента, то прервать цикл
        begin i := -1; break; end;
      end;
      dec(i); //---------------------------- уменьшаем число оставшихся элементов маршрута
      inc(MarhTracert[Group].CIndex); //------------------- переходим на следующий элемент
    end;

    if (i < 1) and not Auto then
    begin // отказ по разрушению трассы
      ResetTrace;
      result := false;
      InsArcNewMsg(MarhTracert[Group].ObjStart,228,1);
      ShowShortMsg(228, LastX, LastY, ObjZav[MarhTracert[Group].ObjStart].Liter);
      exit;
    end;
    result := true;
  except
    reportf('Ошибка [Marshrut.SetProgramZamykanie]');
    result := false;
  end;
end;
//========================================================================================
function SendMarshrutCommand(Group : Byte) : Boolean;
var
  i,j : integer;
  os,oe : SmallInt;
begin
  try
     MarhTracert[Group].Finish := false;
     //--------------------------------------------------- сформировать маршрутную команду
     for i := 1 to 10 do MarhTracert[Group].MarhCmd[i] := 0;

     if ObjZav[MarhTracert[Group].ObjStart].TypeObj = 30 then
     os := ObjZav[ObjZav[MarhTracert[Group].ObjStart].BaseObject].ObjConstI[5] div 8
     else
     if ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] > 0 then
     os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] div 8
     else os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[5] div 8;

     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 30 then
     oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[5] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 24 then
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[13] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 26 then
     oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[4] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 32 then
     oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[2] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] > 0 then
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] div 8
     else
     if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] > 0 then
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] div 8
     else
     oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[7] div 8;

     MarhTracert[Group].MarhCmd[1] := os;
     MarhTracert[Group].MarhCmd[2] := os div 256;
     MarhTracert[Group].MarhCmd[3] := oe;
     MarhTracert[Group].MarhCmd[4] := oe div 256;
     MarhTracert[Group].MarhCmd[5] := MarhTracert[Group].StrCount;

     case MarhTracert[Group].Rod of // установить категорию маршрута
      MarshM :
      begin
        if MarhTracert[Group].Povtor then
        MarhTracert[Group].MarhCmd[10] := cmdfr3_povtormarhmanevr
        else MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutmanevr;
        tm := 'маневрового';
      end;

      MarshP :
      begin
        if MarhTracert[Group].Povtor then
        MarhTracert[Group].MarhCmd[10] := cmdfr3_povtormarhpoezd
        else MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutpoezd;
        tm := 'поездного';
      end;

      MarshL :
      begin
        MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutlogic;
        tm := 'логического';
      end;
    end;

    if MarhTracert[Group].StrCount > 0 then
    begin
      for i := 1 to MarhTracert[Group].StrCount do
      begin
        if MarhTracert[Group].PolTrace[i,2] then
        begin
          case i of
            1 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 1;
            2 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 2;
            3 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 4;
            4 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 8;
            5 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 16;
            6 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 32;
            7 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 64;
            8 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 128;
            9 :  MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 1;
            10 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 2;
            11 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 4;
            12 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 8;
            13 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 16;
            14 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 32;
            15 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 64;
            16 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 128;
            17 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 1;
            18 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 2;
            19 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 4;
            20 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 8;
            21 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 16;
            22 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 32;
            23 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 64;
            24 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 128;
          end;
        end;
      end;
    end;

    CmdSendT := LastTime;
    WorkMode.MarhRdy := true;
    InsArcNewMsg(MarhTracert[Group].ObjStart,5,7);

    ShowShortMsg(5, LastX, LastY, tm + ' маршрута от '+
    ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg);

    LastMsgToDSP := ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg;

    CmdBuff.LastObj := MarhTracert[Group].ObjStart;

    //-------------------------------------------------------- сброс структуры трассировки

    MarhTracert[Group].ObjStart := 0;
    MarhTracert[Group].PutPriem := 0;
    for i := MarhTracert[Group].Counter downto 1 do
    begin
      j := MarhTracert[Group].ObjTrace[i];
      if (ObjZav[j].TypeObj = 4)then
      begin
        MarhTracert[Group].PutPriem := j;
        break;
      end;
    end;

    for i := 1 to High(MarhTracert[Group].ObjTrace) do MarhTracert[Group].ObjTrace[i] := 0;
    MarhTracert[Group].Counter := 0;
    for i := 1 to High(MarhTracert[Group].StrTrace) do
    begin
      MarhTracert[Group].StrTrace[i] := 0;
      MarhTracert[Group].PolTrace[i,1] := false;
      MarhTracert[Group].PolTrace[i,2] := false;
    end;
    MarhTracert[Group].StrCount := 0;
    MarhTracert[Group].ObjEnd := 0;
    MarhTracert[Group].ObjLast := 0;
    MarhTracert[Group].PinLast := 0;
    MarhTracert[Group].ObjPrev := 0;
    MarhTracert[Group].PinPrev := 0;
    MarhTracert[Group].Rod := 0;
    MarhTracert[Group].Povtor := false;
    WorkMode.GoTracert := false;
    WorkMode.CmdReady  := true; //-------- Запрет маршрутных команд до получения квитанции
    result := true;
  except
    reportf('Ошибка [Marshrut.SendMarshrutCommand]'); result := false;
  end;
end;
//========================================================================================
function SendTraceCommand(Group : Byte) : Boolean;
//--------------------------------------------- Выдать команду установки маршрута в сервер
var
  i,baza : integer;
  os,oe : SmallInt;
begin
  try
    if (MarhTracert[Group].GonkaList = 0) or //если все стрелки трассы установлены или ...
    not MarhTracert[Group].GonkaStrel then //------ или перевод стрелок трассы не допустим
    begin
      ResetTrace;
      result := false;
      exit;
    end;
    MarhTracert[Group].Finish     := false;  //Разрешение нажать кнопку конца набора снять
    MarhTracert[Group].GonkaStrel := false;
    MarhTracert[Group].GonkaList  := 0;

    //--------------------------------------------------------------- сформировать команду
    for i := 1 to 10 do MarhTracert[Group].MarhCmd[i] := 0; //---- очистить массив команды

    baza := ObjZav[MarhTracert[Group].ObjStart].BaseObject; //--- взять базовый для начала

    if ObjZav[MarhTracert[Group].ObjStart].TypeObj = 30 then //если начало "дача согласия"
    os := ObjZav[baza].ObjConstI[5] div 8 //----- индекс датчика С2 светофора увязки в FR3
    else

    if ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] > 0 then  //-------- если есть МС2
    os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] div 8 //------ индекс МС2 в FR3

    else
    os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[5] div 8; //------ индекс С2 в FR3

    baza := ObjZav[MarhTracert[Group].ObjEnd].BaseObject;  //--------- взять базовый конца

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 30 then // если конец - "дача согласия"
    oe := ObjZav[baza].ObjConstI[5] div 8 //------- индекс датчика C2 сигнала увязки в FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 24 then//если конец - увязка с запросом
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[13] div 8//- МС сигнала парка соседа
    else

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 26 then//---- если конец - увязка с ПАБ
    oe := ObjZav[baza].ObjConstI[4] div 8 //--- индекс датчика C1 входного светофора в FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 32 then // если конец - увязка с горкой
    oe := ObjZav[baza].ObjConstI[2] div 8 // индекс для МC1 маневр.светофора с горки в FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] > 0 then  //-- если у конца есть МС2
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] div 8 //-------- индекс МС2 в FR3
    else

    if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] > 0 then //---- если у конца есть С2
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] div 8  //-------- индекс С2 в FR3
    else

    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[7] div 8; //--- иначе что это ??????

    MarhTracert[Group].MarhCmd[1] := os;
    MarhTracert[Group].MarhCmd[2] := os div 256;
    MarhTracert[Group].MarhCmd[3] := oe;
    MarhTracert[Group].MarhCmd[4] := oe div 256;
    MarhTracert[Group].MarhCmd[5] := MarhTracert[Group].StrCount;
    MarhTracert[Group].MarhCmd[10] := cmdfr3_ustanovkastrelok;

    if MarhTracert[Group].StrCount > 0 then //если есть стрелки, то упаковать их положение
    begin
      for i := 1 to MarhTracert[Group].StrCount do
      begin
        if MarhTracert[Group].PolTrace[i,2] then
        begin
          case i of
            1 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 1;
            2 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 2;
            3 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 4;
            4 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 8;
            5 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 16;
            6 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 32;
            7 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 64;
            8 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 128;
            9 :  MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 1;
            10 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 2;
            11 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 4;
            12 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 8;
            13 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 16;
            14 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 32;
            15 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 64;
            16 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 128;
            17 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 1;
            18 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 2;
            19 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 4;
            20 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 8;
            21 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 16;
            22 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 32;
            23 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 64;
            24 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 128;
          end;
        end;
      end;
    end;

    CmdSendT := LastTime;

    WorkMode.MarhRdy := true;

    InsArcNewMsg(MarhTracert[Group].ObjStart,5,7);
    tm := GetShortMsg(1,5, ' стрелок по трассе маршрута от '+ //- Выдана команда установки
    ObjZav[MarhTracert[Group].ObjStart].Liter + MarhTracert[Group].TailMsg,7);

    LastMsgToDSP := ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg;

    CmdBuff.LastObj := MarhTracert[Group].ObjStart;

    //-------------------------------------------------------- сброс структуры трассировки
    ResetTrace;
    PutShortMsg(2,LastX,LastY,tm); //----------------------------------- Трасса $ сброшена
    WorkMode.CmdReady  := true; //-------- Запрет маршрутных команд до получения квитанции
    result := true;
  except
    reportf('Ошибка [Marshrut.SendTraceCommand]');
    result := false;
  end;
end;
//========================================================================================
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
var
  cvet : integer;
//----------------------------------------------- инициировать начало трассировки маршрута
begin
  try
    ResetTrace; //------------------------------------- сброс любой ранее набранной трассы
    case command of
      CmdMenu_BeginMarshManevr :  //---------------------------- начать маневровый маршрут
      begin
        MarhTracert[1].Rod := MarshM;
        ObjZav[index].bParam[7] := true; //------------------------- установить признак НМ
        cvet := 7;
      end;

      CmdMenu_BeginMarshPoezd :  //------------------------------- начать поездной маршрут
      begin
        MarhTracert[1].Rod := MarshP;
        ObjZav[index].bParam[9] := true; //-------------------------- установить признак Н
        cvet := 2;
      end;

      else
        InsArcNewMsg(MarhTracert[1].ObjStart,32,1); //"Обнаружен неизвестный тип маршрута"
        result := false;
        ShowShortMsg(32,LastX,LastY,ObjZav[MarhTracert[1].ObjStart].Liter);
        exit;
    end;
    WorkMode.GoTracert := true; //-------------------------- объявить трассировку активной
    MarhTracert[1].AutoMarh := false; //---------------- сбросить трассировку автодействия
    MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
    MarhTracert[1].ObjStart := index; //---------- начинаем трассировку с первого нажатого
    MarhTracert[1].ObjLast := index; //--------------- считаем, что этот объект и последий
    MarhTracert[1].PinLast := 2; //--------------------------- начало поиска за светофором
    MarhTracert[1].ObjPrev := MarhTracert[1].ObjLast;
    MarhTracert[1].PinPrev := MarhTracert[1].PinLast;
    InsArcNewMsg(MarhTracert[1].ObjStart,78,cvet); //---------- введите трассу маршрута от
    ShowShortMsg(78,LastX,LastY,ObjZav[MarhTracert[1].ObjStart].Liter);
    result := true;
  except
    reportf('Ошибка [Marshrut.BeginTracertMarshrut]');
    result := false;
  end;
end;
//========================================================================================
function RestorePrevTrace : Boolean;
//----------------------------- Восстановить трассу до последней существующей конфигурации
var
  i : integer;
begin
  try
    i := MarhTracert[1].Counter; //------------------------------- число объектов в трассе

    while i > 0 do
    begin
      if MarhTracert[1].ObjTrace[i] = MarhTracert[1].ObjPrev then break //- если вернулись
      else //------------------------------ пока не найдена последняя удачная точка трассы
      begin
        if ObjZav[MarhTracert[1].ObjTrace[i]].TypeObj = 2 then //--- если вышли на стрелку
        begin //----------------------------------- сбросить параметры трассировки стрелки
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[10] := false;
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[11] := false;
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[12] := false;
          ObjZav[MarhTracert[1].ObjTrace[i]].bParam[13] := false;
        end;
        MarhTracert[1].ObjTrace[i] := 0; //----------------------- убрать объект из трассы
      end;
      dec(i);
    end;

    MarhTracert[1].Counter := i; //---------------- теперь в трассе меньшее число объектов
    MarhTracert[1].ObjLast := MarhTracert[1].ObjPrev; //---- восстановим индекс последнего
    MarhTracert[1].PinLast := MarhTracert[1].PinPrev; //----- восстановим точку последнего
    MarhTracert[1].MsgCount := 0;
    RestorePrevTrace := true;
  except
    reportf('Ошибка [Marshrut.RestorePrevTrace]'); result := false;
  end;
end;
//========================================================================================
function EndTracertMarshrut : Boolean;
//------------------------------------------------------- функция завершения набора трассы
begin
  try
    if Marhtracert[1].Counter < 1 then //------------------- если в маршруте нет элементов
    begin result := false; exit; end
    else
    if MarhTracert[1].ObjEnd < 1 then //------------------ если нет объекта конца маршрута
    begin //-------------------- переключатель по типу последнего элемента трассы маршрута
      case ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].TypeObj of

        5,15,26,30 :// если это сигнал,АБ,ПАБ или "согласие", то это и есть конец маршрута
        MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

        else  result := false; exit; //---------------------------- иначе выход с неудачей
      end;
    end;

    //-------------------------------------------------------- если сигнал попутный и ....
    if (ObjZav[MarhTracert[1].ObjLast].TypeObj = 5) and (MarhTracert[1].PinLast = 2) and
    //--- не открыты ни маневровый 1-го или 2-го каскада ни поездной 1-го или 2-го каскада
    not (ObjZav[MarhTracert[1].ObjLast].bParam[1] or ObjZav[MarhTracert[1].ObjLast].bParam[2] or
    ObjZav[MarhTracert[1].ObjLast].bParam[3] or ObjZav[MarhTracert[1].ObjLast].bParam[4]) then
    begin
      if ObjZav[MarhTracert[1].ObjLast].bParam[5] then //---------- если не норма огневого
      begin //----------------------------- Маршрут не прикрыт запрещающим огнем попутного
        inc(MarhTracert[1].WarCount);
        MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
        //---------------------------- "Маршрут не огражден.Неисправен запрещающий огонь."
        GetShortMsg(1,115, ObjZav[MarhTracert[1].ObjLast].Liter,1);
        InsWar(1,MarhTracert[1].ObjLast,115);
      end;

      //----------- Проверить открытие впереди стоящего сигнала если короткий блок-участок
      case MarhTracert[1].Rod of
        MarshP :    //----------------------------------------------------- маршрут поездной
        begin
          //-------------------------- если короткий предмаршрутный участок поездной и ...
          if ObjZav[MarhTracert[1].ObjLast].ObjConstB[19] and
          not ObjZav[MarhTracert[1].ObjLast].bParam[4] then //--- нет 2-го каскада поездного
          begin
            InsArcNewMsg(MarhTracert[1].ObjLast,391,1);//----------------- "сигнал закрыт"
            ShowShortMsg(391,LastX,LastY, ObjZav[MarhTracert[1].ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        MarshM :  //---------------------------------------------------- маршрут маневровый
        begin
          //------------------------ если короткий предмаршрутный участок маневровый и ...
          if ObjZav[MarhTracert[1].ObjLast].ObjConstB[20] and
          not ObjZav[MarhTracert[1].ObjLast].bParam[2] then //- нет 2-го каскада маневрового
          begin
            InsArcNewMsg(MarhTracert[1].ObjLast,391,1);//----------------- "сигнал закрыт"
            ShowShortMsg(391,LastX,LastY, ObjZav[MarhTracert[1].ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        else  result := false; exit; //---------------------- других маршрутов быть не может
      end;
    end;

    //------ Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
    if FindIzvStrelki(MarhTracert[1].ObjStart, MarhTracert[1].Rod) then //-------- если есть
    begin
      inc(MarhTracert[1].WarCount);
      MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
      //- предупреждение "Внимание есть незамкнутые стрелки предмаршрутного участка сигнала"
      GetShortMsg(1,333, ObjZav[MarhTracert[1].ObjStart].Liter,1);
      InsWar(1,MarhTracert[1].ObjStart,333);
    end;
    MarhTracert[1].Finish := true;
    result := true;
  except
    reportf('Ошибка [Marshrut.EndTracertMarshrut]'); result := false;
  end;
end;
{$IFNDEF RMARC}
//========================================================================================
function AddToTracertMarshrut(index : SmallInt) : Boolean;
//--------------------------- Сделать трассировку до следующей точки, указанной оператором
var i,j,nextptr : integer;
begin
  try
    if (index = MarhTracert[1].ObjStart) or (index = MarhTracert[1].ObjEnd) then
    begin
      InsArcNewMsg(MarhTracert[1].ObjStart,1,7); //------- "продолжайте набор маршрута от"
      ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
      result := false;
      exit;
    end;
    for i := 1 to MarhTracert[1].Counter do
    if Marhtracert[1].ObjTrace[i] = index then
    begin //------------------------- если объект уже в трассе - запросить следующую точку
      InsArcNewMsg(MarhTracert[1].ObjStart,1,7);
      ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
      result := false;
      exit;
    end;

    //--------------------------------------------------------- найти запись в списке АКНР
    for i := 1 to High(AKNR) do
    begin
      if (AKNR[i].ObjStart = 0) or (AKNR[i].ObjEnd = 0) then break
      else
      begin
        if (AKNR[i].ObjStart = MarhTracert[1].ObjLast) and (AKNR[i].ObjEnd = index) then
        for j := 1 to High(AKNR[i].ObjAuto) do
        begin
          if AKNR[i].ObjAuto[j] = 0 then break
          else
          begin
            nextptr := AKNR[i].ObjAuto[j];
            result := NextToTracertMarshrut(nextptr);
            if not result then exit;
          end;
        end;
      end;
    end;
    result := NextToTracertMarshrut(index);
  except
    reportf('Ошибка [Marshrut.AddToTracertMarshrut]'); result := false;
  end;
end;
//========================================================================================
function NextToTracertMarshrut(index : SmallInt) : Boolean;
//----------------------------------------------------- Продлить трассу до следующей точки
//------------------- index - индекс объекта, заданного нажатием следующего объекта экрана

var
  i,j,c,k,wc,oe,strelka,signal : Integer;
  jmp : TOZNeighbour;
  TST_TRAS : TTracertResult;
  b,res : boolean;
begin
  try
    signal := 0;
    MarhTracert[1].FindNext := false;//Признак-требование проверки возможности продолжения
    MarhTracert[1].LvlFNext := false;//Признак процедур поиска трассы для следующего марш.
    MarhTracert[1].Dobor    := false;//---- Признак проверки возможности "добора" маршрута
    MarhTracert[1].HTail    := index; //------------- "хвост" трассы, указанный оператором
    Marhtracert[1].FullTail := false; //----------  Признак полноты добора хвоста маршрута
    Marhtracert[1].VP := 0; //------------------------- объект маршрута для стрелки в пути
    MarhTracert[1].TailMsg  := ''; //--- сообщение о конце маршрута ("за" сигнал или "до")
    MarhTracert[1].FindTail := true; //----------- признак проверки продолжения, если "за"
    LastJmp.TypeJmp := 0; LastJmp.Obj := 0; LastJmp.Pin := 0;

    if WorkMode.GoTracert and not WorkMode.MarhRdy then //идет трассировка,маршр. не готов
    begin
      result := true;
      if index = MarhTracert[1].ObjLast then //------- если вышли на заданный конец трассы
      begin
        InsArcNewMsg(MarhTracert[1].ObjStart,1,7);//------ "продолжайте набор маршрута от"
        ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
        result := true;
        exit;
      end;
      //------------------------------------------ Сохранить параметры начатой трассировки
      MarhTracert[1].ObjPrev := MarhTracert[1].ObjLast; //-- объект в конце начатой трассы
      MarhTracert[1].PinPrev := MarhTracert[1].PinLast; // завершающая точка этого объекта

      if MarhTracert[1].Counter < High(MarhTracert[1].ObjTrace) then //если свободно место
      begin //---------------- трассировка - первичная фаза, поиск между заданными точками
        i := TryMarhLimit; //------------------------- установить ограничитель трассировки
        jmp :=ObjZav[MarhTracert[1].ObjLast].Neighbour[MarhTracert[1].PinLast];//коннектор

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[1].Level := tlFindTrace; //- назначаем уровень проверки наличия трассы
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        //-------------------------------------------- здесь начинается цикл поиска трассы
        while i > 0 do //-------- цикл до нахождения трассы, либо превышения числа попыток
        begin //------------------------------------------ трассировать до указанной точки

          if jmp.Obj = index then break; //-------- Обнаружен объект, указанный оператором

          case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of //- сделать шаг
            trRepeat : //---------- конец не найден, продолжаем поиск от последней стрелки
            begin
              if MarhTracert[1].Counter > 0 then
              begin //------------------------- Возврат к последней непереведенной стрелке
                j := MarhTracert[1].Counter; //------- начинаем от текущего объекта трассы

                while j > 0 do
                begin
                  case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of //--- переход по типу
                    2 :
                    begin //------------------------------------------------------ стрелка
                      strelka := MarhTracert[1].ObjTrace[j];// берем индекс стр. из трассы

                      if ObjZav[strelka].ObjConstB[3] then //- основные маршруты по минусу
                      begin
                        if (ObjZav[strelka].bParam[10] and //----- был проход первый и ...
                        not ObjZav[strelka].bParam[11]) or //--- не было пока 2-го или ...
                        ObjZav[strelka].bParam[12] or  // пошерстная нужна в плюсе или ...
                        ObjZav[strelka].bParam[13] then //------ пошерстная нужна в минусе
                        begin
                          ObjZav[strelka].bParam[10] :=false;//сброс фиксации 1-го прохода
                          ObjZav[strelka].bParam[11] :=false;//сброс фиксации 2-го прохода
                          ObjZav[strelka].bParam[12] :=false; //-- сброс пошерстного плюса
                          ObjZav[strelka].bParam[13] :=false; //- сброс пошерстного минуса
                          MarhTracert[1].ObjTrace[j] :=0; //----- убрать из трассы стрелку
                          dec(MarhTracert[1].Counter);  //------ уменьшить число элементов
                        end else
                        begin
                          ObjZav[strelka].bParam[11] := false; // сброс признака 2-го хода
                          jmp := ObjZav[strelka].Neighbour[2]; //--- переход на плюс-ветку
                          break;
                        end;
                      end else //------------------------------ основные маршруты по плюсу
                      begin
                        if ObjZav[strelka].bParam[11] or //- второй ход по стрелке или ...
                        ObjZav[strelka].bParam[12] or //------- пошерстная в плюсе или ...
                        ObjZav[strelka].bParam[13] then //------------ пошерстная в минусе
                        begin
                          ObjZav[strelka].bParam[10] :=false;//сброс фиксации 1-го прохода
                          ObjZav[strelka].bParam[11] :=false;//сброс фиксации 2-го прохода
                          ObjZav[strelka].bParam[12] :=false; //-- сброс пошерстного плюса
                          ObjZav[strelka].bParam[13] :=false; //- сброс пошерстного минуса
                          MarhTracert[1].ObjTrace[j] := 0;
                          dec(MarhTracert[1].Counter);
                        end else
                        begin
                          ObjZav[strelka].bParam[11] := true;
                          jmp := ObjZav[strelka].Neighbour[3]; //-- Переход на минус-ветвь
                          break;
                        end;
                      end;
                    end;

                    else //------------------------------ любой объект отличный от стрелки
                      if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                      begin j := 0; break; end //------ вернулись в самое начало, прервать
                      else
                      begin //--------------------------- откатить на один объект к началу
                        MarhTracert[1].ObjTrace[j] := 0;
                        dec(MarhTracert[1].Counter);
                      end;
                  end; //------------------------------------------------------ конец case
                  dec(j);
                end; //------------------------------------------ граница while для отката

                if j < 1 then //----------------------- неудачный откат, трасса не найдена
                begin //------------------------ Конец трассировки - точка указана неверно
                  InsArcNewMsg(MarhTracert[1].ObjStart,86,1);
                  RestorePrevTrace;
                  result := false;
                  ShowShortMsg(86, LastX, LastY, '');
//                  SingleBeep := true;
                  exit;
                end;
              end else //-------------------------- в трассе нет элементов (пустая трасса)
              begin //-------------------------- Конец трассировки - точка указана неверно
                InsArcNewMsg(MarhTracert[1].ObjStart,86,1);
                RestorePrevTrace; //------- восстановить трассу до последней удачной точки
                result := false;
                ShowShortMsg(86, LastX, LastY, ''); //--- "Точка трассы $ указана неверно"
                exit;
              end;
            end;

            trStop : //------------ при попытке пройти через объект - топология не пускает
            begin
              InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
              RestorePrevTrace; //-------------- восстановиться до последней удачной точки
              result := false;
              ShowShortMsg(77, LastX, LastY, '');  //--------------- Маршрут не существует
              exit;
            end;

            trEnd :
            begin //---------------------------- Конец трассировки - маршрут не существует
              InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
              RestorePrevTrace;
              result := false;
              ShowShortMsg(77, LastX, LastY, ''); exit;
            end;
          end; //------------------------------------------------- конец щага через объект
          dec(i); //------ перейти к следующему шагу, уменьшив число допустимых оставшихся
        end; //------------------------------ конец цикла попыток шагания по объектам базы

        if i < 1 then //--------------------------- вышли за пределы установленного лимита
        begin //------------------------------------------------- превышен счетчик попыток
          InsArcNewMsg(MarhTracert[1].ObjStart,231,1);// Превышен счет попыток трассировки
          RestorePrevTrace;
          result := false;
          ShowShortMsg(231, LastX, LastY, '');
          exit;
        end;

        MarhTracert[1].ObjLast := index; //------------------------ обновляем конец трассы

        if ObjZav[index].TypeObj = 5 then MarhTracert[1].ObjEnd := index;

        case jmp.Pin of
          1 : MarhTracert[1].PinLast := 2; // запоминаем точку выхода из конечного объекта
          else MarhTracert[1].PinLast := 1;
        end;

        //------------------- Проверить необходимость поиска предполагаемой конечной точки
        b := true;
        MarhTracert[1].PutPO := false; //--------------- сброс признака трассировки в пути

        if ObjZav[MarhTracert[1].ObjLast].TypeObj = 5 then
        begin //------------------ Для светофора проверить условия продолжения трассировки
          signal := MarhTracert[1].ObjLast;
          if ObjZav[signal].ObjConstB[1] then  //-- есть конец трассировки в точке сигнала
          begin//Точка разрыва маршрутов Ч/Н (смена направления движения на станции, тупик)
            b := false;
            MarhTracert[1].ObjEnd := signal;
          end
          else
          case MarhTracert[1].PinLast of
            1 :  //----------------------- выход из сигнала в точке 1 (выезд за встречный)
            begin
              case MarhTracert[1].Rod of
                MarshP :
                begin
                  if ObjZav[signal].ObjConstB[6] then //---- есть конец поездных в точке 2
                  begin //------------------ Завершить трассировку если поездной из тупика
                    b := false;
                    MarhTracert[1].ObjEnd := signal;
                  end else //-------------- нет конца П в точке 2 ( за встречным сигналом)
                  if ((ObjZav[signal].Neighbour[1].TypeJmp = 0) or
                  (ObjZav[signal].Neighbour[1].TypeJmp = LnkNecentr))
                  then begin b := false; i := 0; end; //Отказ если нет поездного из тупика
                end;

                MarshM :
                begin
                  if ObjZav[signal].ObjConstB[8] then //-- есть конец маневровых в точке 2
                  begin //----- Завершить трассировку за встречным, но проверить куда едем
                    b := true;
                    MarhTracert[1].ObjEnd := signal;
                  end;
                end;

                else b := true; //---------------------------- неопределенный тип маршрута
              end;
            end;

            else //--- выход из сигнала конца в точке 2 (за попутным, значит маршрут "до")

            //-------------- если маневровый и есть конец маневровых в точке 1 ("до")  или
            if(((MarhTracert[1].Rod=MarshM) and ObjZav[signal].ObjConstB[7]) or
            //--------------------------- если поездной и есть конец поездных в точке 1 и
            ((MarhTracert[1].Rod = MarshP) and ObjZav[signal].ObjConstB[5])) and
            //---------------- если блокировка FR4 или блокировка в РМ ДСП или РМ/МИ или
            (ObjZav[signal].bParam[12] or
            ObjZav[signal].bParam[13] or
            ObjZav[jmp.Obj].bParam[18] or
            //-----------------------------------------------есть начало поездных и С1 или
            (ObjZav[signal].ObjConstB[2] and
            (ObjZav[signal].bParam[3] or
            //----------------------------------------------- С2 или Начало из сервера или
            ObjZav[signal].bParam[4] or
            ObjZav[signal].bParam[8] or
            //--------------------------------- ППР трассировки или есть начало маневровых
            ObjZav[signal].bParam[9])) or
            (ObjZav[signal].ObjConstB[3]
            //-------------------------------------------------------------- и МС1 или МС2
            and (ObjZav[signal].bParam[1]
            or ObjZav[signal].bParam[2]
            //--------------------------------- или есть НМ из сервера или МПР трассировки
            or ObjZav[signal].bParam[6]
            or ObjZav[signal].bParam[7]
            //или МУС
            or ObjZav[signal].bParam[21]))) then
            begin //--------------- Завершить трассировку если попутный впереди уже открыт
              b := false;
              MarhTracert[1].ObjEnd := signal;
            end else //----------------------------------------------------- сигнал закрыт
            begin
              case MarhTracert[1].Rod of
                MarshP :      //-------------------------------------------- если поездной
                begin //------------------------------- если есть конец поездных в точке 1
                  if ObjZav[signal].ObjConstB[5] then
                  begin //---------------------- есть конец поездного маршрута у светофора
                    MarhTracert[1].FullTail := true;
                    MarhTracert[1].FindNext := true;
                  end;
                  //------------------- если нет сквозного пропуска и есть начало поездных
                  if ObjZav[signal].ObjConstB[16] and
                  ObjZav[signal].ObjConstB[2] then //-------------- Нет сквозного пропуска
                  begin //-------------- Завершить трассировку если нет сквозного пропуска
                    b := false;
                    MarhTracert[1].ObjEnd := signal;
                    MarhTracert[1].FullTail := true //------------- закончить набор трассы
                  end else
                  begin
                    if ObjZav[signal].ObjConstB[5] then b := false // есть конец "П" в т.1
                    else b := true;

                    if ObjZav[signal].ObjConstB[5] and //------ есть конец "П" в т.1 и ...
                    not ObjZav[signal].ObjConstB[2] then //---------- нет поездного начала
                    begin
                      MarhTracert[1].ObjEnd := signal; //-- конец, нет поездных от сигнала
                    end;
                  end;
                end;

                MarshM :
                begin
                  if ObjZav[signal].ObjConstB[7] then //-- есть конец маневровых в точке 1
                  begin
                    MarhTracert[1].FullTail := true;
                    MarhTracert[1].FindNext := true;
                  end;

                  if ObjZav[signal].ObjConstB[7]
                  then b := false
                  else b := true;

                  if ObjZav[signal].ObjConstB[7] and //------ есть конец М в точке 1 и ...
                  not ObjZav[signal].ObjConstB[3] then //- у сигнала нет начала маневровых
                  begin
                    MarhTracert[1].ObjEnd := signal;//- Завершить, нет маневров от сигнала
                  end;
                end;

                else  b := true; //--------------- неопределенный маршрут следует прервать
              end;
            end;
          end;
        end else //--------------------------------- объекты типа "путь" или "УП с концом"
        if ((ObjZav[MarhTracert[1].ObjLast].TypeObj = 4) or //---------- если путь или ...

        ((ObjZav[MarhTracert[1].ObjLast].TypeObj = 3) and //--------------------- УП и ...
        (MarhTracert[1].Rod = MarshP) and //----------------------- поездной маршрут и ...
        (MarhTracert[1].PinLast = 1) and  //-------------- выход из УП через точку 1 и ...
        (ObjZav[MarhTracert[1].ObjLast].ObjConstB[10] = true)) or //есть конец в тчк 1 или

        ((ObjZav[MarhTracert[1].ObjLast].TypeObj = 3) and //--------------------- УП и ...
        (MarhTracert[1].Rod = MarshP) and //----------------------- поездной маршрут и ...
        (MarhTracert[1].PinLast = 2) and  //-------------- выход из УП через точку 2 и ...
        (ObjZav[MarhTracert[1].ObjLast].ObjConstB[11] = true)))  //---- есть конец в тчк 2
        then  MarhTracert[1].PutPO := true
        //---------------- Для пути или УП с концом установить признак конца набора трассы
        else
        if ObjZav[MarhTracert[1].ObjLast].TypeObj = 24 then
        begin //-------------------------- Для межпостовой увязки завершить набор маршрута
          b := false;
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
        end else
        if ObjZav[MarhTracert[1].ObjLast].TypeObj = 32 then
        begin //------------------------------------- Для надвига завершить набор маршрута
          b := false;
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++ продление трассы маршрута за сигнал
        if b then  //-------------------------------- нет завершения маршрута, нужен добор
        begin //--- Добить до конечной точки или отклоняющей стрелки, перешагнуть конечный
          MarhTracert[1].FullTail := false;

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[1].Level := tlContTrace; //------------------ режим продления трассы
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //---------------------- Д О Б О Р   Т Р А С С Ы  ------------------------------
          i := 1000;

          while i > 0 do
          begin
            TST_TRAS := StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1);//шагнуть
            case TST_TRAS of
              trStop :
              begin //-------------------------- конец трассировки - маршрут не существует
                InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
                RestorePrevTrace;
                result := false;
                ShowShortMsg(77, LastX, LastY, '');
                exit;
              end;

              trBreak :
              begin //------------------------- сделать откат до предыдущей точки маршрута
                b := false;
                break;
              end;

              trEnd :
                      break; //------------------------- достигнута делящая точка маршрута

              trEndTrace :
              begin  //-------------------------------- достигнута конечная точка маршрута
                MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
                MarhTracert[1].ObjLast := ObjZav[signal].Neighbour[1].Obj;//проход за сиг.
                break;
              end;
            end;
            dec(i);
          end;

          if i < 1 then
          begin //----------------------------------------------- превышен счетчик попыток
            InsArcNewMsg(MarhTracert[1].ObjStart,231,1);
            RestorePrevTrace;
            result := false;
            ShowShortMsg(231, LastX, LastY, ''); exit;
          end;

          if b then
          begin //------------------------------------------------------------- нет отката
            jmp.Obj := MarhTracert[1].ObjLast;
            case jmp.Pin of
              1 : MarhTracert[1].PinLast := 2;
              else  MarhTracert[1].PinLast := 1;
            end;
          end else
          begin //-------------------------------------------------- был откат на один шаг
            //------------------------------------------------------ пропустить ДЗ стрелок

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTracert[1].Level := tlStepBack; //----- режим шаг назад по трассе маршрута
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            i := MarhTracert[1].Counter;
            while i > 0 do
            begin
              case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
                trStop : break;
              end;
              dec(i);
            end;
            MarhTracert[1].ObjLast := jmp.Obj;
            MarhTracert[1].PinLast := jmp.Pin;
          end;
        end else
        begin //------------------------------------------ Если нет добора хвоста маршрута
          if MarhTracert[1].Counter < High(MarhTracert[1].ObjTrace) then
          begin //---------------------------------------- поместить хвост в список трассы
            inc(MarhTracert[1].Counter);
            MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj;
          end;
        end;

        LastJmp := jmp; //-------------------- Сохранить последний переход между объектами

        if i < 1 then
        begin //----------------------------------- отказ по несоответствию конечной точки
          InsArcNewMsg(index,86,1);   //------------------- Точка трассы $ указана неверно
          RestorePrevTrace; result := false;
          ShowShortMsg(86, LastX, LastY, ObjZav[index].Liter);
          exit;
        end;

        //-------------------------------------------- Проверить охранности по всей трассе
        i := 1000;
        Marhtracert[1].VP := 0;
        jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[1].Level := tlVZavTrace; //----- режим проверка зависимостей по трассе
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        j := MarhTracert[1].ObjEnd; //------------------ найденный конец продленной трассы

        MarhTracert[1].CIndex := 1;
        if j < 1 then j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

        res := false;
        while i > 0 do
        begin
          case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
            trStop :  begin i := 0; break; end;
            trBreak : break;
            trEnd :   break;
          end;
          dec(i);
          if res then break;         
          if jmp.Obj = j then res := true; //--------------- Обнаружен объект конца трассы
          inc(MarhTracert[1].CIndex);
        end;

        if MarhTracert[1].MsgCount > 0 then //-- есть запрещающие сообщения (враждебность)
        begin
          InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1],1);
          RestorePrevTrace;
          result := false;
          PutShortMsg(1, LastX, LastY, MarhTracert[1].Msg[1]);
          exit;
        end;

        if i < 0 then //--------------------- отказ по охранностям - маршрут не существует
        begin
          InsArcNewMsg(MarhTracert[1].ObjStart,77,1);
          RestorePrevTrace;
          result := false;
          ShowShortMsg(77, LastX, LastY, '');
          exit;
        end;

        //------------------------------ Раскидать признаки трассировки по объектам трассы
        for i := 1 to MarhTracert[1].Counter do
        begin
          case ObjZav[MarhTracert[1].ObjTrace[i]].TypeObj of
            3 :   //--------------------------------------------------------------- секция
            begin
              if  not ObjZav[MarhTracert[1].ObjTrace[i]].bParam[14] then
              ObjZav[MarhTracert[1].ObjTrace[i]].bParam[8] := false;
            end;

            4 :  //------------------------------------------------------------------ путь
            begin
              if  not ObjZav[MarhTracert[1].ObjTrace[i]].bParam[14] then
              ObjZav[MarhTracert[1].ObjTrace[i]].bParam[8] := false;
            end;
          end;
        end;

        //------------------------------------------ Проверить враждебности по всей трассе
        i := 1000;
        MarhTracert[1].MsgCount := 0;
        MarhTracert[1].WarCount := 0;
        MarhTracert[1].GonkaStrel := false; //----- убрать признак гонки стрелок по трассе
        MarhTracert[1].GonkaList  := 0;    // сбросить счетчик стрелок, требующих перевода
        jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTracert[1].Level := tlCheckTrace;//---- режим проверка враждебностей по трассе
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        Marhtracert[1].VP := 0;
        j := MarhTracert[1].ObjEnd;
        if j < 1 then j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
        MarhTracert[1].CIndex := 1;

        while i > 0 do
        begin
          if jmp.Obj = j then
          begin //------------------------------------------ Обнаружен объект конца трассы
            //----------------------------------------------- поиск враждебностей в хвосте
            StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1);
            break;
          end;

          case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
            trStop : break;
          end;
          dec(i);
          inc(MarhTracert[1].CIndex);
        end;

        if i < 1 then
        begin //--------------------------------------------- отказ по превышению счетчика
          InsArcNewMsg(MarhTracert[1].ObjStart,231,1);
          RestorePrevTrace;
          result := false;
          ShowShortMsg(231, LastX, LastY, '');
          exit;
        end;
        tm := MarhTracert[1].TailMsg; //------------ сохранить сообщение в хвосте маршрута

        if MarhTracert[1].MsgCount > 0 then
        begin  //--------------------------------------------------- отказ по враждебности
          MarhTracert[1].MsgCount := 1; //------------------------ оставить одно сообщение
          //--------------- Закончить трассировку и сбросить трассу если есть враждебности
          CreateDspMenu(KeyMenu_ReadyResetTrace,LastX,LastY);
          result := false;
          exit;
        end else
        begin
          if MarhTracert[1].PutPO then //---------------- Завершить набор если указан путь
           MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

          if (MarhTracert[1].WarCount > 0) and
          MarhTracert[1].FullTail then //--------  При наличии сообщений и хвосте маршрута
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

          //------------------------------ Проверка возможности набора следующего маршрута
          c := MarhTracert[1].Counter; //-------- сохранить текущее число элементов трассы
          wc := MarhTracert[1].WarCount;  //--------------- сохранить число предупреждений
          oe := MarhTracert[1].ObjEnd; //--------------------------------- конечный объект

          MarhTracert[1].VP := 0;
          MarhTracert[1].LvlFNext := true;

          if (MarhTracert[1].ObjEnd = 0) and (MarhTracert[1].FindNext) then
          begin //------------------------ Проверка возможности набора следующего маршрута
            i := TryMarhLimit * 2;
            jmp := ObjZav[MarhTracert[1].ObjLast].Neighbour[MarhTracert[1].PinLast];

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTracert[1].Level := tlFindTrace;
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            while i > 0 do
            begin //------------------------------------------------ трассировать по шагам

              case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

                trRepeat :  //--------------------- если нужен возврат к последней стрелке
                begin

                  if MarhTracert[1].Counter > c then //-- если был хотя бы один шаг вперед
                  begin   //------------------- Возврат к последней непереведенной стрелке
                    j := MarhTracert[1].Counter; // начинаем с конца (сначала здесь j > c)
                    while j > 0 do
                    begin

                      case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of

                        2 :
                        begin //-------------------------------------------------- стрелка
                          strelka := MarhTracert[1].ObjTrace[j];

                          if ObjZav[strelka].ObjConstB[3] then//главные маршруты по минусу
                          begin
                            if (ObjZav[strelka].bParam[10] and  //-- был 1-ый проход и ...
                            not ObjZav[strelka].bParam[11]) or //- был 2-ой проход или ...
                            ObjZav[strelka].bParam[12] or //  пошерстная нужна в плюсе или
                            ObjZav[strelka].bParam[13] then //-- пошерстная нужна в минусе
                            begin
                              ObjZav[strelka].bParam[10] := false;//сбросить первый проход
                              ObjZav[strelka].bParam[11] := false;//сбросить второй проход
                              ObjZav[strelka].bParam[12] := false; // сброс пошерстная в +
                              ObjZav[strelka].bParam[13] := false; // сброс пошерстная в -
                              MarhTracert[1].ObjTrace[j] := 0; // убрать стрелку из трассы
                              dec(MarhTracert[1].Counter); //------------ сократить трассу
                            end else
                            begin
                              ObjZav[strelka].bParam[11] := false;//установить 2-ой проход
                              jmp := ObjZav[strelka].Neighbour[2]; //Переход на плюс-ветвь
                              break;
                            end;
                          end else
                          begin //----------------------------- основные маршруты по плюсу
                            if ObjZav[strelka].bParam[11] or//если был 2-ой проход или ...
                            ObjZav[strelka].bParam[12] or //--- пошерстная в плюсе или ...
                            ObjZav[strelka].bParam[13] then //-------- пошерстная в минусе
                            begin
                              ObjZav[strelka].bParam[10] := false;
                              ObjZav[strelka].bParam[11] := false;
                              ObjZav[strelka].bParam[12] := false;
                              ObjZav[strelka].bParam[13] := false;
                              MarhTracert[1].ObjTrace[j] := 0;
                              dec(MarhTracert[1].Counter);
                            end else
                            begin
                              ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := true;//2-ой
                              jmp:= ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[3];//на -
                              break;
                            end;
                          end;
                        end;

                        else //---------------- любой другой объект (не является стрелкой)
                          if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                          begin  //- конец, заданный опрератором на экране для трассировки
                            j := 0; break;
                          end else
                          begin //---------------- откатить на один объект к началу трассы
                            MarhTracert[1].ObjTrace[j] := 0;
                            dec(MarhTracert[1].Counter);
                          end;

                      end; //-------------------------------- конец case по типам объектов
                      dec(j);
                    end; //--------- конец while j > 0 по числу объектов вошедших в трассу

                    if j <= c then //------------------------- если выполнен возврат назад
                    begin //-------------------------------------------- Конец трассировки
                      oe := MarhTracert[1].ObjLast;
                      break;
                    end;
                  end else //------------ если на очередном объекте нет продвижения вперед
                  begin //---------------------------------------------- Конец трассировки
                    MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
                    break;
                  end;
                end; //-------------------------- конец case по результату шага = trRepeat

                trStop, trEnd : break; //------------------------------- Конец трассировки
              end; //------------------------------------------------------ case steptrace

              //-------------------------------------- Проверить достижение конечной точки
              b := false;

              if ObjZav[jmp.Obj].TypeObj = 5 then //-------------------------- если сигнал
              begin //------------ Для светофора проверить условия продолжения трассировки
                if ObjZav[jmp.Obj].ObjConstB[1] then b := true //- Точка разрыва маршрутов
                else
                case jmp.Pin of
                  2 :
                  begin //--------------------------- подошли к точке 2 (сигнал встречный)
                    case MarhTracert[1].Rod of
                      MarshP : if ObjZav[jmp.Obj].ObjConstB[6] then b := true;//П конец т2

                      MarshM : if ObjZav[jmp.Obj].ObjConstB[8] then b := true;//М конец т2

                      else  b := false;
                    end;
                  end;
                  else //---------------------------- подошли к точке 1, (сигнал попутный)
                    if ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2]//МС1 или МС2
                    or //------------------------------------------------------------- или
                    ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4] //--- С1 или С2
                    or //------------------------------------------------------------- или
                    ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7]//НМ_FR3 или МПР
                    or //------------------------------------------------------------- или
                    ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9] //Н_FR3 или ППР
                    or //------------------------------------------------------------- или
                    ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13]//блокSTAN_DSP
                    or //------------------------------------------------------------- или
                    ObjZav[jmp.Obj].bParam[18] or ObjZav[jmp.Obj].bParam[21] //- РМ_МИ_МУС
                    then b := true //попутный уже открыт, на выдержке, в трассе,блокирован
                    else
                    begin
                      case MarhTracert[1].Rod of
                        MarshP :
                        begin
                          if ObjZav[jmp.Obj].ObjConstB[16] and // Нет сквозного пропуска и
                          ObjZav[jmp.Obj].ObjConstB[2] then b := true // есть начало для П
                          else
                          begin
                            b := ObjZav[jmp.Obj].ObjConstB[5]; //наличие П конца в точке 1
                          end;
                        end;

                        MarshM : b := ObjZav[jmp.Obj].ObjConstB[7];   // М конец в точке 1

                        else  b := true;  //------------------- неясный маршрут остановить
                      end;
                    end;
                end;
              end else
              if ObjZav[jmp.Obj].TypeObj = 15 then
              begin //-------------------- Для увязки с перегоном завершить набор маршрута
                inc(MarhTracert[1].Counter);
                MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZav[jmp.Obj].TypeObj = 24 then
              begin //-------------------- Для межпостовой увязки завершить набор маршрута
                b := true;
              end else
              if ObjZav[jmp.Obj].TypeObj = 26 then
              begin //-------------------------- Для увязки с ПАБ завершить набор маршрута
                inc(MarhTracert[1].Counter);
                MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZav[jmp.Obj].TypeObj = 32 then
              begin //------------------------------- Для надвига завершить набор маршрута
                b := true;
              end;

              if b then //- маршрут завершен на этапе трассировки, то проверить охранности
              begin
                k := 15000;
                jmp.Obj := MarhTracert[1].ObjLast;
                if MarhTracert[1].PinLast = 1 then jmp.Pin := 2 else
                jmp.Pin := 1;

                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                MarhTracert[1].Level := tlVZavTrace;//режим проверка зависимостей в трассе
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
                MarhTracert[1].CIndex := c;
                b := true;

                while k > 0 do
                begin
                  if jmp.Obj = j then break; //------------- Обнаружен объект конца трассы
                  case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
                    trStop :         begin  b := false; break; end;
                    trBreak, trEnd : begin   break;            end;
                  end;
                  dec(k);
                  inc(MarhTracert[1].CIndex);
                end;

                if (k > 1000) and b then
                begin
                  //----------------------------------------------- Проверить враждебности
                  jmp.Obj := MarhTracert[1].ObjLast;
                  if MarhTracert[1].PinLast = 1 then jmp.Pin := 2
                  else jmp.Pin := 1;

                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  MarhTracert[1].Level := tlCheckTrace;//- режим проверка вражд. по трассе
                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                  MarhTracert[1].Dobor := true;
                  MarhTracert[1].MsgCount := 0;
                  j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
                  MarhTracert[1].CIndex := c;
                  while k > 0 do
                  begin
                    if jmp.Obj = j then
                    begin //-------------------------------- Обнаружен объект конца трассы
                      // Враждебности в хвосте
                      StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1); break;
                    end;

                    case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
                      trStop,trBreak :  break;
                    end;

                    dec(i);
                    inc(MarhTracert[1].CIndex);
                  end;
                end;

                if MarhTracert[1].MsgCount > 0 then b := false;

                if (k < 1) or not b then
                begin //--------------------------- отказ по охранностям или враждебностям
                  if MarhTracert[1].Counter > c then
                  begin
                    //------------------------- Возврат к последней непереведенной стрелке
                    j := MarhTracert[1].Counter;
                    while j > 0 do
                    begin
                      case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of
                        2 :
                        begin //-------------------------------------------------- стрелка
                          strelka := MarhTracert[1].ObjTrace[j];
                          if ObjZav[strelka].ObjConstB[3] then
                          begin //---------------------------- основные маршруты по минусу
                            if (ObjZav[strelka].bParam[10] and
                            not ObjZav[strelka].bParam[11]) or
                            ObjZav[strelka].bParam[12] or
                            ObjZav[strelka].bParam[13] then
                            begin
                              ObjZav[strelka].bParam[10] := false;
                              ObjZav[strelka].bParam[11] := false;
                              ObjZav[strelka].bParam[12] := false;
                              ObjZav[strelka].bParam[13] := false;
                              MarhTracert[1].ObjTrace[j] := 0;
                              dec(MarhTracert[1].Counter);
                            end else
                            begin
                              ObjZav[strelka].bParam[11] := false;
                              jmp := ObjZav[strelka].Neighbour[2]; //Переход на плюс-ветвь
                              break;
                            end;
                          end else
                          begin //----------------------------- основные маршруты по плюсу
                            if ObjZav[strelka].bParam[11] or
                            ObjZav[strelka].bParam[12] or
                            ObjZav[strelka].bParam[13] then
                            begin
                              ObjZav[strelka].bParam[10] := false;
                              ObjZav[strelka].bParam[11] := false;
                              ObjZav[strelka].bParam[12] := false;
                              ObjZav[strelka].bParam[13] := false;
                              MarhTracert[1].ObjTrace[j] := 0;
                              dec(MarhTracert[1].Counter);
                            end else
                            begin
                              ObjZav[strelka].bParam[11] := true;
                              jmp := ObjZav[strelka].Neighbour[3];//Переход на минус-ветвь
                              break;
                            end;
                          end;
                        end;
                        else
                          if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                          begin
                            oe := MarhTracert[1].ObjLast;
                            break;
                          end else
                          begin //----------------------- откатить на один объект к началу
                            MarhTracert[1].ObjTrace[j] := 0;
                            dec(MarhTracert[1].Counter);
                          end;
                      end;
                      dec(j);
                    end;
                    if j <= c then
                    begin //-------------------------------------------- Конец трассировки
                      oe := MarhTracert[1].ObjLast;
                      break;
                    end;
                  end else
                  begin //---------------------------------------------- Конец трассировки
                    oe := MarhTracert[1].ObjLast;
                    break;
                  end;
                end
                else break;
              end;

              //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              MarhTracert[1].Level := tlFindTrace; //
              //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

              dec(i);
            end;

            if i < 1 then oe := MarhTracert[1].ObjLast; //------- превышен счетчик попыток

          end;

          while MarhTracert[1].Counter > c do
          begin //------------------ убрать признаки трассировки перед продолжением набора
            if ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].TypeObj = 2 then // стрелка
            begin
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[10] := false;
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[11] := false;
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[12] := false;
              ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[13] := false;
            end;
            MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := 0;
            dec(MarhTracert[1].Counter);
          end;
          MarhTracert[1].MsgCount := 0;
          MarhTracert[1].WarCount := wc;
          MarhTracert[1].ObjEnd   := oe;

          if MarhTracert[1].ObjEnd > 0 then
          begin //-------------------------- Завершить набор если нельзя продолжить трассу
            if (ObjZav[MarhTracert[1].ObjLast].TypeObj = 5) and  //- если это сигнал и ...
            (MarhTracert[1].PinLast = 2) and  //------------ трассируется из точки 2 и ...
            not (ObjZav[MarhTracert[1].ObjLast].bParam[1] or // нет ни маневрового ВС, ...
            ObjZav[MarhTracert[1].ObjLast].bParam[2] or //ни открытого маневрового сигнала
            ObjZav[MarhTracert[1].ObjLast].bParam[3] or //------------ ни поездного ВС ...
            ObjZav[MarhTracert[1].ObjLast].bParam[4]) then  //---- нет открытого поездного
            begin
              if ObjZav[MarhTracert[1].ObjLast].bParam[5] then //----------------------- о
              begin //--------------------- Маршрут не прикрыт запрещающим огнем попутного
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,115, ObjZav[MarhTracert[1].ObjLast].Liter,1);
                InsWar(1,MarhTracert[1].ObjLast,115);
              end;

              case MarhTracert[1].Rod of // проверка открытия впереди стоящего сигнала если короткий блок-участок
                MarshP :
                begin
                  if ObjZav[MarhTracert[1].ObjLast].ObjConstB[19] and
                  not ObjZav[MarhTracert[1].ObjLast].bParam[4] then
                  begin
                    InsArcNewMsg(MarhTracert[1].ObjLast,391,1);
                    ShowShortMsg(391,LastX,LastY,ObjZav[MarhTracert[1].ObjLast].Liter);
                    exit;
                  end;
                end;

                MarshM :
                begin
                  if ObjZav[MarhTracert[1].ObjLast].ObjConstB[20] and
                  not ObjZav[MarhTracert[1].ObjLast].bParam[2] then
                  begin
                    InsArcNewMsg(MarhTracert[1].ObjLast,391,1);
                    ShowShortMsg(391,LastX,LastY,ObjZav[MarhTracert[1].ObjLast].Liter);
                    exit;
                  end;
                end;
                else result := false; exit;
              end;
            end;

            // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
            if FindIzvStrelki(MarhTracert[1].ObjStart, MarhTracert[1].Rod) then
            begin
              inc(MarhTracert[1].WarCount);
              MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
              GetShortMsg(1,333, ObjZav[MarhTracert[1].ObjStart].Liter,7);
              InsWar(1,MarhTracert[1].ObjStart,333);
            end;

            MarhTracert[1].TailMsg := tm; //----- восстановить сообщение в хвосте маршрута

            if MarhTracert[1].WarCount > 0 then
            begin //------------------------------------------------- Вывод предупреждений
             SingleBeep := true;
{$IFNDEF TABLO}
              TimeLockCmdDsp := LastTime;
{$ENDIF}
              LockCommandDsp := true;
              CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
            end
            else CreateDspMenu(CmdMarsh_Ready,LastX,LastY);

            MarhTracert[1].Finish := true;
          end else
          begin
            MarhTracert[1].TailMsg := tm; // восстановить сообщение в хвосте маршрута
            InsArcNewMsg(MarhTracert[1].ObjStart,1,7); //- "продолжайте набор маршрута от"
            ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
          end;
        end;
      end else
      begin
        InsArcNewMsg(MarhTracert[1].ObjStart,180,7);
        RestorePrevTrace;
        result := false;
        ShowShortMsg(180, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
      end;
    end
    else result := false;
  except
    reportf('Ошибка [Marshrut.NextToTracertMarshrut]'); result := false;
  end;
end;
{$ENDIF}
//========================================================================================
function StepTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte) : TTracertResult;
//----------------------------------------------------------------- Обработка шага по базе
//-------------------------------- Con:TOZNeighbour -  связь с соседом, от которого пришли
//--------------------------------------- Lvl:TTracertLevel ---- этап трассировки маршрута
//------------------------------------------------------------ Rod:Byte ----- тип маршрута
//------------------------------------------ Group:Byte номер маршрута в списке задаваемых

var
  //o,j,k,m : integer;
  //tr,p : boolean;
  jmp : TOZNeighbour;
begin
try
  result := trStop;
  case Lvl of
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace, //----------- Проверка взаимозависимостей по трассе (охранности и прочее)
    tlCheckTrace,//----------------------------- проверка враждебностей по трассе маршрута
    tlZamykTrace : // замыкание трассы маршрута, сбор положения отклоняющих стрелок трассы
    begin //-------------------------------------------------- проверка целостности трассы
      if MarhTracert[Group].CIndex <= MarhTracert[Group].Counter then  //--- если не конец
      begin
         //-------------------- объект не относится к трассе
        if Con.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].CIndex]
        then exit; //---------------------------------------------- остановить трассировку
      end else
      if MarhTracert[Group].CIndex = MarhTracert[Group].Counter+1 then //--- если за конец
      if Con.Obj <> MarhTracert[Group].ObjEnd //------------------- объект не хвост трассы
      then exit; //------------------------------------------------ остановить трассировку
    end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    tlStepBack : //------------------------------------------------- откат назад по трассе
    begin
      jmp := Con; //------------------------------------ При откате перешагнуть объекты Дз
      case ObjZav[jmp.Obj].TypeObj of
        27,29 :
        begin
          if jmp.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop; //---------------------------------- конец района
              LnkEnd : result := trStop; //---------------------------------- конец строки
              else  result := trNextStep;  //------------------------- иначе шагать дальше
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
              else  result := trNextStep;
            end;
          end;
        end;
        else result := trStop; exit; //---------- для других объектов остановиться и выйти
      end;

      if MarhTracert[Group].Counter > 0 then
      begin
        MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]:=0;//обнулить трасс-ячейку
        dec(MarhTracert[Group].Counter); //-------------- уменьшить число элементов трассы
      end
      else result := trStop;
      exit;
    end;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  jmp := Con; //------------------------- в последующие функции передается коннектор входа

  case ObjZav[jmp.Obj].TypeObj of
  //////////////////////////////////////////////////////////////////////////////////////
    2 : result := StepTraceStrelka(Con,Lvl,Rod,Group,jmp);
    3 : result := StepTraceSP(Con,Lvl,Rod,Group,jmp);
    4 : result := StepTracePut(Con,Lvl,Rod,Group,jmp);
    5 : result := StepTraceSvetofor(Con,Lvl,Rod,Group,jmp);
    7 : result := StepTracePriglas(Con,Lvl,Rod,Group,jmp);
   14 : result := StepTraceUKSPS(Con,Lvl,Rod,Group,jmp);
   15 : result := StepTraceAB(Con,Lvl,Rod,Group,jmp);
   16 : result := StepTraceVSN(Con,Lvl,Rod,Group,jmp);
   23 : result := StepTraceUvazManRn(Con,Lvl,Rod,Group,jmp);
   24 : result := StepTraceZaprosPoezdOtpr(Con,Lvl,Rod,Group,jmp);
   26 : result := StepTracePAB(Con,Lvl,Rod,Group,jmp);
   27 : result := StepTraceDZOhr(Con,Lvl,Rod,Group,jmp);
   28 : result := StepTraceIzvPer(Con,Lvl,Rod,Group,jmp);
   29 : result := StepTraceDZSP(Con,Lvl,Rod,Group,jmp);
   30 : result := StepTracePoezdSogl(Con,Lvl,Rod,Group,jmp);
   32 : result := StepTraceUvazGor(Con,Lvl,Rod,Group,jmp);
   38 : result := StepTraceMarNadvig(Con,Lvl,Rod,Group,jmp);
   41 : result := StepTraceMarshOtpr(Con,Lvl,Rod,Group,jmp);
   42 : result := StepTracePerezamStrInPut(Con,Lvl,Rod,Group,jmp);
   43 : result := StepTraceOPI(Con,Lvl,Rod,Group,jmp);
   45 : result := StepTraceZonaOpov(Con,Lvl,Rod,Group,jmp);
   else result := StepTraceProchee(Con,Lvl,Rod,Group,jmp);
  end;

  if (result = trBreak) or (lvl = tlVZavTrace) or (lvl = tlCheckTrace) or
  (lvl = tlFindIzvest) or (lvl = tlFindIzvStrel) or (lvl = tlZamykTrace)
  or (lvl = tlOtmenaMarh) then exit;

  //-- Продвинуть текущий объект при поиске трассы, её продлении, откате,повторе маршрута,
  //-------------------------------------------- раздельном открытии,  повторе раздельного
  if MarhTracert[Group].Counter < High(MarhTracert[Group].ObjTrace) then
  begin
    inc(MarhTracert[Group].Counter);
    MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] := jmp.Obj;
  end
  else result := trStop;
except
  reportf('Ошибка [Marshrut.TraceStep]');
  result := trStop;
end;
end;
//========================================================================================
function SoglasieOG(Index : SmallInt) : Boolean;
//------------------------------- Проверить возможность выдачи согласия на ограждение пути
var
  i,o,p,j : integer;
begin
try
  j := ObjZav[Index].UpdateObject; // индекс объекта ограждения пути
  if j > 0 then
  begin
    result := ObjZav[j].bParam[1]; // Есть запрос на ограждение
    // проверить ограждение по 1-ой точке
    o := ObjZav[Index].Neighbour[1].Obj; p := ObjZav[Index].Neighbour[1].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin // Вход по плюсу
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
            end;
            3 : begin // Вход по минусу
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break; // стрелка в отводе по плюсу
            end;
          else
            result := false; break; // ошибка в описании зависимостей - отсутствует СП в общей точке
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;

        3 : begin // участок
          result := ObjZav[o].bParam[2]; // замыкание участка
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;
    if not result then exit;
    // проверить ограждение по 2-ой точке
    o := ObjZav[Index].Neighbour[2].Obj; p := ObjZav[Index].Neighbour[2].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin // Вход по плюсу
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
            end;
            3 : begin // Вход по минусу
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break; // стрелка в отводе по плюсу
            end;
          else
            result := false; break; // ошибка в описании зависимостей - отсутствует СП в общей точке
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;

        3 : begin // участок
          result := ObjZav[o].bParam[2]; // замыкание участка
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;

    // запретить выдачу ограждения при местном управлении
    o := ObjZav[j].ObjConstI[18];
    if result and (o > 0) then
    begin
      if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
      begin
        result := false;
      end;
    end;
    o := ObjZav[j].ObjConstI[19];
    if result and (o > 0) then
    begin
      if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
      begin
        result := false;
      end;
    end;
  end else
  begin
    result := false;
  end;
except
  reportf('Ошибка [Marshrut.SoglasieOG]');
  result := false;
end;
end;
//========================================================================================
function CheckOgrad(ptr : SmallInt; Group : Byte) : Boolean;
//------ проверить ограждение пути через Вз стрелки при проверке враждебностей трассировки
var
  i,o,p : integer;
begin
try
  result := true;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
        6 : begin // Ограждение пути
          for p := 14 to 17 do
          begin
            if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[p] = Ptr then
            begin
              o := ObjZav[Ptr].ObjConstI[i];
              if ObjZav[o].bParam[2] then
              begin // Установлено ограждение пути
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[12]) or
                   (MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].bParam[7])) then
                begin // Стрелка нужна в плюсе
                  if not ObjZav[o].ObjConstB[p*2-27] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end else
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[13]) or
                   (MarhTracert[Group].Povtor and (not ObjZav[Ptr].bParam[6] and ObjZav[Ptr].bParam[7])) then
                begin // Стрелка нужна в минусе
                  if not ObjZav[o].ObjConstB[p*2-26] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
except
  reportf('Ошибка [Marshrut.CheckOgrad]');
  result := false;
end;
end;
//========================================================================================
function CheckOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
//----------------- проверить установку маршрута отправления с пути с примыкающей стрелкой
//-------------------- через хвост стрелки при проверке враждебностей трассировки маршрута
var
  i,j,o,p : integer;
begin
try
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[i];
    if p > 0 then
    begin
      case ObjZav[p].TypeObj of
        41 : begin //---------------------- Контроль поездного маршрута отправления с пути
          if ObjZav[p].bParam[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZav[p].ObjConstI[j];
              if o = ptr then
              begin //---------- проверить требуемое положение стрелки для обоих маршрутов
                if (not MarhTracert[Group].Povtor and
                (ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[11])
                or ObjZav[Ptr].bParam[12]) or
                (MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[6]
                and not ObjZav[Ptr].bParam[7])) then
                begin //-------------------------------------------- Стрелка нужна в плюсе
                  if not ObjZav[p].ObjConstB[(j-1)*3+3] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end else
                if (not MarhTracert[Group].Povtor and
                (ObjZav[Ptr].bParam[10] and ObjZav[Ptr].bParam[11])
                or ObjZav[Ptr].bParam[13]) or
                (MarhTracert[Group].Povtor and (not ObjZav[Ptr].bParam[6]
                and ObjZav[Ptr].bParam[7])) then
                begin //------------------------------------------- Стрелка нужна в минусе
                  if not ObjZav[p].ObjConstB[(j-1)*3+4] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //41
      end; //case
    end; // for
  end;
except
  reportf('Ошибка [Marshrut.CheckOtpravlVP]');
  result := false;
end;
end;
//========================================================================================
function SignCircOgrad(ptr : SmallInt; Group : Byte) : Boolean;
// проверить ограждение пути через Вз стрелки при проверке враждебностей сигнальной струны
var
  i,o,p : integer;
begin
try
  result := true;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
        6 : begin //------------------------------------------------------ Ограждение пути
          for p := 14 to 17 do
          begin
            if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[p] = Ptr then
            begin
              o := ObjZav[Ptr].ObjConstI[i];
              if ObjZav[o].bParam[2] then
              begin //---------------------------------------- Установлено ограждение пути
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
                begin //-------------------------------------------- Стрелка нужна в плюсе
                  if not ObjZav[o].ObjConstB[p*2-27] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end else
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                begin // Стрелка нужна в минусе
                  if not ObjZav[o].ObjConstB[p*2-26] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
except
  reportf('Ошибка [Marshrut.SignCircOgrad]');
  result := false;
end;
end;
//========================================================================================
function SignCircOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
//----------------- проверить установку маршрута отправления с пути с примыкающей стрелкой
//----------------------- через хвост стрелки при проверке враждебностей сигнальной струны
var
  i,j,o,p : integer;
begin
try
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[i];
    if p > 0 then
    begin
      case ObjZav[p].TypeObj of
        41 :
        begin //--------------------------- Контроль поездного маршрута отправления с пути
          if ObjZav[p].bParam[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZav[p].ObjConstI[j];
              if o = ptr then
              begin //---------- проверить требуемое положение стрелки для обоих маршрутов
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
                begin //-------------------------------------------- Стрелка нужна в плюсе
                  if not ObjZav[p].ObjConstB[(j-1)*3+3] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end else
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                begin //------------------------------------------- Стрелка нужна в минусе
                  if not ObjZav[p].ObjConstB[(j-1)*3+4] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //41
      end; //case
    end; // for
  end;
except
  reportf('Ошибка [Marshrut.SignCircOtpravlVP]');
  result := false;
end;
end;
//========================================================================================
function NegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
//---------------------------------------------------------------- Проверка негабаритности
//-------------------------------------------------------------------------  ptr - стрелка
//------------------------------------------------------- pk - значение датчика ПК стрелки
//----------------------------------------- Group - комплект управления для данной стрелки
var
  i,o,p : integer;
begin
  try
    result := true;
    //-------------------- Искать негабаритность через стык и отведенное положение стрелок
    if pk then
    begin //-------------------------------------------------------------- стрелка в плюсе
      if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or //-------------- негабаритный стык
      (ObjZav[Ptr].ObjConstB[8]) then //-------- или проверка отводящего положения стрелок
      begin //--------------------------------------------------- по минусовому примыканию
        o := ObjZav[Ptr].Neighbour[3].Obj; //----------------------- объект за отклонением
        p := ObjZav[Ptr].Neighbour[3].Pin; //--------------------------- точка подключения
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 :   //-------------------------------------------------------------- стрелка
            begin
              case p of
                2 :   //--------------------------------------------------- Вход по прямой
                if ObjZav[o].bParam[2] then break; //---------- стрелка в отводе по минусу

                3 : //------------------------------------------------  Вход по отклонению
                if ObjZav[o].bParam[1] then break; //----------- стрелка в отводе по плюсу

                else  ObjZav[Ptr].bParam[3] := false; break; //------ ошибка в базе данных
              end;
              p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
            end;

            3,4 :  //-------------------------------------------------------- участок,путь
            begin
              if not ObjZav[o].bParam[1] then //--------------- занятость путевого датчика
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,146, ObjZav[o].Liter,1);
                InsMsg(Group,o,146);
                result := false;
              end;
              break;
            end;

            else
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end else
  begin  //-------------------------------------------------------------- стрелка в минусе
    if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or //---------------- негабаритный стык
    (ObjZav[Ptr].ObjConstB[7]) then    //------- или проверка отводящего положения стрелок
    begin //------------------------------------------------------ по плюсовому примыканию
      o := ObjZav[Ptr].Neighbour[2].Obj;
      p := ObjZav[Ptr].Neighbour[2].Pin;
      i := 100;
      while i > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 :
          begin //---------------------------------------------------------------- стрелка
            case p of
              2 :
              begin //------------------------------------------------------ Вход по плюсу
                if ObjZav[o].bParam[2] then break; //---------- стрелка в отводе по минусу
              end;
              3 :
              begin //----------------------------------------------------- Вход по минусу
                if ObjZav[o].bParam[1] then break; //----------- стрелка в отводе по плюсу
              end;
              else ObjZav[Ptr].bParam[3] := false; break; //--------- ошибка в базе данных
            end;
            p := ObjZav[o].Neighbour[1].Pin;
            o := ObjZav[o].Neighbour[1].Obj;
          end;

          3,4 :
          begin //----------------------------------------------------------- участок,путь
            if not ObjZav[o].bParam[1] then //----------------- занятость путевого датчика
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,146, ObjZav[o].Liter,1);
              InsMsg(Group,o,146);
              result := false;
            end;
            break;
          end;

          else
          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin;
            o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin
            p := ObjZav[o].Neighbour[1].Pin;
            o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end;
except
  reportf('Ошибка [Marshrut.NegStrelki]');
  result := false;
end;
end;
//========================================================================================
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
//------------------------------------------ Проверка негабаритности для сигнальной струны
var
  i,o,p : integer;
begin
  try
    result := true;
    //-------------------- Искать негабаритность через стык и отведенное положение стрелок
    if pk then
    begin //---------------------------------------------------------------- стрелка в плюсе
      if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or //---------------- негабаритный стык
      (ObjZav[Ptr].ObjConstB[8]) then //---------- или проверка отводящего положения стрелок
      begin //по минусовому примыканию
        o := ObjZav[Ptr].Neighbour[3].Obj;
        p := ObjZav[Ptr].Neighbour[3].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 :
            begin // стрелка
              case p of
                2 :
                begin // Вход по плюсу
                  if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                end;

                3 :
                begin // Вход по минусу
                  if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                end;

                else  ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
              end;
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;

            3,4 :
            begin // участок,путь
              if not ObjZav[o].bParam[1] then // занятость путевого датчика
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,146, ObjZav[o].Liter,1); InsMsg(Group,o,146);
                result := false;
              end;
              break;
            end;
            else
              if p = 1 then
              begin
                p := ObjZav[o].Neighbour[2].Pin;
                o := ObjZav[o].Neighbour[2].Obj;
              end else
              begin
                p := ObjZav[o].Neighbour[1].Pin;
                o := ObjZav[o].Neighbour[1].Obj;
              end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(i);
        end;
      end;
    end else
    begin // стрелка в минусе
      if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or // негабаритный стык
      (ObjZav[Ptr].ObjConstB[7]) then         // или проверка отводящего положения стрелок
      begin //по плюсовому примыканию
        o := ObjZav[Ptr].Neighbour[2].Obj;
        p := ObjZav[Ptr].Neighbour[2].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 :
            begin // стрелка
              case p of
                2 :
                begin // Вход по плюсу
                  if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                end;
                3 :
                begin // Вход по минусу
                  if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                end;
                else ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
              end;
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;

            3,4 :
            begin // участок,путь
              if not ObjZav[o].bParam[1] then // занятость путевого датчика
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,146, ObjZav[o].Liter,1);
                InsMsg(Group,o,146);
                result := false;
              end;
              break;
            end;

            else
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(i);
        end;
      end;
    end;
  except
    reportf('Ошибка [Marshrut.SigCircNegStrelki]');
    result := false;
  end;
end;
//========================================================================================
function VytajkaRM(ptr : SmallInt) : Boolean;
//------------------------------------------ Проверка условий передачи на маневровый район
var
  i,j,g,o,p,q : Integer;
  b,opi : boolean;
begin
try
  result := false;
  MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
  if ptr < 1 then exit;

  // подсветить пути
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4  : ObjZav[o].bParam[8] := false;
          43 : begin // объект оПИ
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // путь разрешен для маневров
              ObjZav[ObjZav[o].UpdateObject].bParam[8] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить секции
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : ObjZav[o].bParam[8] := false;
          44 : begin // объект СМИ
            if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] then ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] := false;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false;
              ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := true;
            end;
          44 : begin // СМИ
            if ObjZav[o].bParam[2] and
               ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] and
               not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] then
            begin
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false;
              ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false;
              ObjZav[o].bParam[12] := true; ObjZav[o].bParam[13] := false;
            end;
          44 : begin // СМИ
            if ObjZav[o].bParam[1] and
               ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] and
               not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] then
            begin
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false;
              ObjZav[ObjZav[o].UpdateObject].bParam[12] := true; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[12] := true; ObjZav[o].bParam[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить объекты СМИ для данной колонки
  for i := 1 to WorkMode.LimitObjZav do
  begin
    if (ObjZav[i].TypeObj = 44) and (ObjZav[i].BaseObject = ptr) then
    begin
      if ObjZav[ObjZav[ObjZav[i].UpdateObject].UpdateObject].bParam[7] and
         not ObjZav[ObjZav[ObjZav[i].UpdateObject].UpdateObject].bParam[8] then
      begin
        ObjZav[ObjZav[i].UpdateObject].bParam[12] := ObjZav[i].bParam[1];
        ObjZav[ObjZav[i].UpdateObject].bParam[13] := ObjZav[i].bParam[2];
      end;
    end;
  end;

  // проверить условия на колонке
  if ObjZav[ptr].bParam[6] then
  begin // ЭГС
    inc(MarhTracert[1].MsgCount);
    MarhTracert[1].Msg[MarhTracert[1].MsgCount] :=
    GetShortMsg(1,105,ObjZav[ptr].Liter,1);
    InsMsg(1,ptr,105);
    exit;
  end;
  if ObjZav[ptr].bParam[1] then
  begin // РМ
    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ptr].Liter,1); InsMsg(1,ptr,258); exit;
  end;
  if ObjZav[Ptr].bParam[4] then
  begin // если первичная передача на маневры - проверить:
  // проверить восприятие маневров на колонке
    if not ObjZav[Ptr].bParam[5] then
    begin
      if ObjZav[ptr].bParam[3] then
      begin // маневры еще не замкнуты
        inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,445,ObjZav[Ptr].Liter,1); InsWar(1,ptr,445);
      end;
    end;
  // исключения путей из маневров (разрешение приема или ограждения)
    b := false; opi := false;
    for i := 1 to WorkMode.LimitObjZav do
    begin
      if (ObjZav[i].TypeObj = 48) and (ObjZav[i].BaseObject = ptr) then
      begin
        if not ObjZav[i].ObjConstB[3] then
        begin // контролировать возможность выхода на пути приема из маневрового района
          opi := true;
          if ObjZav[i].bParam[1] then b := true;
        end;
      end;
    end;
    if opi and not b then
    begin // все пути исключены из маневрового района
      inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,427,ObjZav[Ptr].Liter,1); InsMsg(1,ptr,427); exit;
    end;
  end;

  // проверить дополнительные условия передачи на маневры
  g := ObjZav[ptr].ObjConstI[17];
  if g > 0 then
  begin
    for i := 1 to 5 do
    begin // проверка дополнительных условий по списку
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4 : begin // путь
            if not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3] then
            begin // установлен маршрут на путь (исключаются любые маршруты на путь)
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,341,ObjZav[o].Liter,1); InsMsg(1,o,341); exit;
            end;
          end;

          6 : begin // ограждение пути
            if ObjZav[o].bParam[2] then
            begin // ограждение установлено
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,145,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,145); exit;
            end;
          end;

          23 : begin // увязка с маневровым районом
            if ObjZav[o].bParam[1] then
            begin // есть УМП
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,256,ObjZav[o].Liter,1); InsMsg(1,o,256); exit;
            end else
            if ObjZav[o].bParam[2] then
            begin // есть УМО
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,257,ObjZav[o].Liter,1); InsMsg(1,o,257); exit;
            end;
          end;

          25 : begin // маневровая колонка
            if not ObjZav[o].bParam[1] then
            begin // нет разрешения маневров на проверяемой колонке
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,426,ObjZav[o].Liter,1); InsMsg(1,o,426); exit;
            end;
          end;

          33 : begin // дискретный датчик
            if ObjZav[o].bParam[1] then
            begin
              inc(MarhTracert[1].MsgCount);
              if ObjZav[o].ObjConstB[1] then
              begin
                MarhTracert[1].Msg[MarhTracert[1].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]]; InsMsg(1,o,3);
              end else
              begin
                MarhTracert[1].Msg[MarhTracert[1].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]]; InsMsg(1,o,2);
              end;
              exit;
            end;
          end;

          45 :
          begin //-------------------------------------------------------- зона оповещения
            if ObjZav[o].bParam[1] then
            begin //----------------------- Включено оповещение в зоне местного управления
              inc(MarhTracert[1].MsgCount);
              MarhTracert[1].Msg[MarhTracert[1].MsgCount] :=
              GetShortMsg(1,444,ObjZav[o].Liter,1);
              InsMsg(1,o,444);
              exit;
            end;
          end;

        end;
      end;
    end;
  end;

  // проверить секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            if not ObjZav[o].bParam[2] then
            begin // Участок замкнут
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,82,ObjZav[o].Liter,1); InsMsg(1,o,82); exit;
            end;
            if not ObjZav[o].bParam[5] then
            begin // Участок на маневрах
              for p := 20 to 24 do // найти колонку с замкнутыми маневрами
                if (ObjZav[o].ObjConstI[p] > 0) and (ObjZav[o].ObjConstI[p] <> ptr) then
                begin
                  if not ObjZav[ObjZav[o].ObjConstI[p]].bParam[3] then
                  begin
                    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ObjZav[o].ObjConstI[p]].Liter,1); InsMsg(1,ObjZav[o].ObjConstI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZav[o].bParam[7] then
            begin // Участок замкнут на сервере
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,110,ObjZav[o].Liter,1); InsMsg(1,o,110); exit;
            end;
          end;
          44 : begin // СМИ
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[2] then
            begin // Участок замкнут
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,82,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].UpdateObject,82); exit;
            end;
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[5] then
            begin // Участок на маневрах
              for p := 20 to 24 do // найти колонку с замкнутыми маневрами
                if (ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p] > 0) and (ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p] <> ptr) then
                begin
                  if not ObjZav[ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p]].bParam[3] then
                  begin
                    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p]].Liter,1); InsMsg(1,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] then
            begin // Участок замкнут на сервере
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,110,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].UpdateObject,110); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  // проверить светофоры вытяжки
  g := ObjZav[ptr].ObjConstI[20];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] or ObjZav[o].bParam[3] or ObjZav[o].bParam[4] then
        begin // сигнал открыт
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,114,ObjZav[o].Liter,1); InsMsg(1,o,114); exit;
        end;
      end;
    end;
  end;

  // проверить наличие контроля охранных стрелок в минусе
  g := ObjZav[ptr].ObjConstI[21];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
        begin // стрелка не имеет контроля
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
        end;
      end;
    end;
  end;
  // проверить наличие контроля охранных стрелок в плюсе
  g := ObjZav[ptr].ObjConstI[22];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
        begin // стрелка не имеет контроля
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
        end;
      end;
    end;
  end;
  // проверить наличие контроля ходовых стрелок в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить наличие контроля ходовых стрелок в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить наличие контроля стрелок на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not (ObjZav[o].bParam[1] xor ObjZav[o].bParam[2]) then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not (ObjZav[ObjZav[o].UpdateObject].bParam[1] xor ObjZav[ObjZav[o].UpdateObject].bParam[2]) then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить пути района
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4 : begin // путь
            if not ObjZav[o].bParam[4] and (not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3]) then
            begin // установлен поездной маршрут на путь
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,341,ObjZav[o].Liter,1); InsMsg(1,o,341); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  if WorkMode.RazdUpr then
  begin // в режиме раздельного управления проверить положение ходовых и охранных стрелок вытяжки

  // проверить объекты оПИ
    g := ObjZav[ptr].ObjConstI[15];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        q := ObjZav[g].ObjConstI[i];
        if q > 0 then
        begin
          case ObjZav[q].TypeObj of
            43 : begin // объект оПИ
              if ObjZav[q].bParam[1] then
              begin // проверить отводящее положение стрелок
              // протрассировать выезд на пути из маневрового района
                opi := false;
                if ObjZav[q].ObjConstB[1] then p := 2 else p := 1;
                o := ObjZav[q].Neighbour[p].Obj; p := ObjZav[q].Neighbour[p].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // стрелка
                      case p of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // есть возможность отвода стрелки
                            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break;
                            opi := true; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // есть возможность отвода стрелки
                            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break;
                            opi := true; break;
                          end;
                        end;
                      end;
                      p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // РПо
                      opi := true; break;
                    end;
                  else
                    if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (p < 1) then break;
                  dec(j);
                end;

              // стрелки не установлены в отвод для пути, исключенного из маневров
                if opi then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,425,ObjZav[ObjZav[q].UpdateObject].Liter,1); InsMsg(1,ObjZav[q].UpdateObject,425); exit;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить ходовые стрелки в минусе
    g := ObjZav[ptr].ObjConstI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
              begin // стрелка не имеет контроля в -
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
              end;
              if not SigCircNegStrelki(o,false,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZav[o].UpdateObject,false,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin //-------------------------------------------------- стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить ходовые стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
              begin // стрелка не имеет контроля в +
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
              end;
              if not SigCircNegStrelki(o,true,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZav[o].UpdateObject,true,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить охранные стрелки в минусе
    g := ObjZav[ptr].ObjConstI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в -
            inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;
  // проверить охранные стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в +
            inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;

  end else
  if WorkMode.MarhUpr then
  begin // в режиме маршрутного управления проверить возможность трассировки с проверкой маневровых враждебностей

    // проверить ходовые стрелки в минусе
    g := ObjZav[ptr].ObjConstI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[2] and not ObjZav[o].bParam[12] and ObjZav[o].bParam[13] then
              begin // стрелка не имеет контроля минусового положения
                if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[o].BaseObject].bParam[22] or
                   ObjZav[ObjZav[o].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
                end;
                if ObjZav[ObjZav[o].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,80); exit;
                end;
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // выключена из управления
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,159,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,159); exit;
                end;
              end;
              if not NegStrelki(o,false,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZav[ObjZav[o].UpdateObject].bParam[2] and
                 not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[12] and
                 ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[13] then
              begin // стрелка не имеет контроля минусового положения
                if not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[22] or
                   ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,267); exit;
                end;
                if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,80); exit;
                end;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[18] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[18] then
              begin // выключена из управления
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,151); exit;
              end;
              if not NegStrelki(ObjZav[o].UpdateObject,false,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // проверить ходовые стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if ObjZav[o].bParam[12] and ObjZav[o].bParam[13] then
              begin // есть езда по + и - сделано для Орска стрелка 202
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // выключена из управления
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,151); exit;
                end;
              end else
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[12] and not ObjZav[o].bParam[13] then
              begin // стрелка не имеет контроля в плюсе
                if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[o].BaseObject].bParam[22] or
                   ObjZav[ObjZav[o].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
                end;
                if ObjZav[ObjZav[o].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,80); exit;
                end;
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // выключена из управления
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,121,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,121); exit;
                end;
              end;
              if not NegStrelki(o,true,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter,1); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter,1); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and
                 ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[12] and
                 not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[13] then
              begin // стрелка не имеет контроля в плюсе
                if not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[22] or
                   ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,268); exit;
                end;
                if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,80); exit;
                end;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[18] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[18] then
              begin // выключена из управления
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,151); exit;
              end;
              if not NegStrelki(ObjZav[o].UpdateObject,true,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter,1); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount);
                MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
                GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter,1)+ '. Продолжать?';
                InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // проверить охранные стрелки в минусе
    g := ObjZav[ptr].ObjConstI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в -
            if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
               not ObjZav[ObjZav[o].BaseObject].bParam[22] or
               ObjZav[ObjZav[o].BaseObject].bParam[24] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,267); exit;
            end;
            if ObjZav[ObjZav[o].BaseObject].bParam[4] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,80); exit;
            end;
            if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
            begin // выключена из управления
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,235,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,235); exit;
            end;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;

    // проверить охранные стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в +
            if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
               not ObjZav[ObjZav[o].BaseObject].bParam[22] or
               ObjZav[ObjZav[o].BaseObject].bParam[24] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,268); exit;
            end;
            if ObjZav[ObjZav[o].BaseObject].bParam[4] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,8); exit;
            end;
            if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
            begin // выключена из управления
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,236,ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(1,ObjZav[o].BaseObject,236); exit;
            end;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount);
            MarhTracert[1].Warning[MarhTracert[1].WarCount] :=
            GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter,1)+ '. Продолжать?';
            InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;
  end;

  if MarhTracert[1].MsgCount > 0 then
  begin
    ResetTrace; exit;
  end;

  ObjZav[ptr].bParam[8] := true; // признак выдачи команды РМ
  result := true;
except
  reportf('Ошибка [Marshrut.VytajkaRM]');
  result := false;
end;
end;
//========================================================================================
function VytajkaZM(ptr : SmallInt) : Boolean;
//----------------------------------------------- Программное замыкание маневрового района
var
  i,g,o : Integer;
begin
try
  result := false;
  if ptr < 1 then exit;

  // замкнуть колонку
  ObjZav[ptr].bParam[14] := true;

  // замыкание секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            ObjZav[o].bParam[14] := true;
          end;
          44 : begin
            if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] then
              ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // погасить пути
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4  : ObjZav[o].bParam[8] := true;
          43 : ObjZav[ObjZav[o].UpdateObject].bParam[8] := true;
        end;
      end;
    end;
  end;

  //--------------------------------------------------- замыкание ходовые стрелки в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
          begin
            ObjZav[o].bParam[13] := false;
            ObjZav[o].bParam[7]  := true;
            ObjZav[o].bParam[14] := true;
          end;
          44 :
          begin
            ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[11] then
            ObjZav[ObjZav[o].UpdateObject].bParam[7] := true;
           ObjZav[ObjZav[o].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // замыкание ходовые стрелки в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := true;
            ObjZav[o].bParam[14] := true;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false;
            if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[10] then
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := true;
            ObjZav[ObjZav[o].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // замыкание ходовых стрелок на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := true;
            ObjZav[o].bParam[13] := false; ObjZav[o].bParam[7] := true;
            ObjZav[o].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

except
  reportf('Ошибка [Marshrut.VytajkaZM]');
  result := false;
end;
end;
//========================================================================================
function VytajkaOZM(ptr : SmallInt) : Boolean;
//---------------------------------------------- Программное размыкание маневрового района
var
  i,g,o : Integer;
begin
try
  result := false;
  if ptr < 1 then exit;

  // разомкнуть колонку
  ObjZav[ptr].bParam[14] := false;
  ObjZav[ptr].bParam[8]  := false; // сбросить признак выдачи команды РМ

  // разомкнуть секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            ObjZav[o].bParam[8] := true; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] := true; ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовые стрелки в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := false; ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false; ObjZav[ObjZav[o].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовые стрелки в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := false; ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false; ObjZav[ObjZav[o].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовых стрелок на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := false;
            ObjZav[o].bParam[13] := false; ObjZav[o].bParam[7] := false;
            ObjZav[o].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

except
  reportf('Ошибка [Marshrut.VytajkaOZM]');
  result := false;
end;
end;
//========================================================================================
function VytajkaCOT(ptr : SmallInt) : string;
//------------------------------------------------------- Проверка условий отмены маневров
var
  i,g,o : Integer;
begin
try
  result := '';
  MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
  if ptr < 1 then exit;
  // проверить условия на колонке
  if ObjZav[ptr].bParam[2] then
  begin // оТ
    result := GetShortMsg(1,259,ObjZav[ptr].Liter,1); exit;
  end;

  // проверить секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            if not ObjZav[o].bParam[1] then
            begin
              result := GetShortMsg(1,83,ObjZav[o].Liter,1); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[1] then
            begin
              result := GetShortMsg(1,83,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter,1); exit;
            end;
          end;
        end;
      end;
    end;
  end;
except
  reportf('Ошибка [Marshrut.VytajkaCOT]'); result := '';
end;
end;
//========================================================================================
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
//--------------------------------- Получить индекс СП, имеющего враждебность для маршрута
var
  sp1,sp2 : integer;
begin
try
  sp1 := ObjZav[ObjZav[ObjZav[Obj].BaseObject].ObjConstI[8]].UpdateObject;
  sp2 := ObjZav[ObjZav[ObjZav[Obj].BaseObject].ObjConstI[9]].UpdateObject;
  case mode of
    1 : begin // замыкание СП
      if (sp1 > 0) and not ObjZav[sp1].bParam[2] then result := sp1 else
      if (sp2 > 0) and not ObjZav[sp2].bParam[2] then result := sp2 else
        result := ObjZav[Obj].UpdateObject;
    end;
    2 : begin // занятость СП
      if (sp1 > 0) and not ObjZav[sp1].bParam[1] then result := sp1 else
      if (sp2 > 0) and not ObjZav[sp2].bParam[1] then result := sp2 else
        result := ObjZav[Obj].UpdateObject;
    end;
  else
    result := Obj;
  end;
except
  reportf('Ошибка [Marshrut.GetStateSP]'); result := Obj;
end;
end;
//========================================================================================
procedure SetNadvigParam(Ptr : SmallInt);
//------------------------------------ установить признак ГВ на светофоры маршрута надвига
var
  max,o,p,nadv : integer;
begin
try
  //------------------------------------- найти трассу маршрута надвига и определить горку
  max := 1000; nadv := 0;
  o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin;
  while max > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 : begin // стрелка
        case p of
          2 : begin
            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
          end;
          3 : begin
            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
            begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
          end;
        else
          if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
          begin
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin
            p := ObjZav[o].Neighbour[3].Pin; o := ObjZav[o].Neighbour[3].Obj;
          end else
            break;
        end;
      end;
      32 : begin // надвиг
        nadv := o; break;
      end;
    else
      if p = 1 then
      begin
        p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
      end else
      begin
        p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
      end;
    end;
    dec(max);
  end;
  if nadv > 0 then
  begin // раскидать признак ГВ по светофорам маршрута
    ObjZav[Ptr].iParam[2] := nadv;
    max := 1000;
    o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin;
    while max > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
              begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
            end;
            3 : begin
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
              begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
            end;
          else
            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin
              p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
            end else
            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
            begin
              p := ObjZav[o].Neighbour[3].Pin; o := ObjZav[o].Neighbour[3].Obj;
            end else
              break;
          end;
        end;
        32 : begin // надвиг
          break;
        end;

        3 : begin // СП,УП
          ObjZav[o].iParam[3] := nadv; // пометить признаком ГВ
          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
        5 : begin // светофор
          if p = 1 then
          begin // попутный светофор пометить признаком ГВ
            ObjZav[o].iParam[2] := nadv;
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin // встречный светофор пометить признаком УН
            ObjZav[o].iParam[3] := nadv;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
      else
        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;
      dec(max);
    end;
  end;
except
  reportf('Ошибка [Marshrut.SetNadvigParam]');
end;
end;
//========================================================================================
//----------------------------------------------- Установить / снять автодействие сигналов
function AutoMarsh(Ptr : SmallInt; mode : Boolean) : Boolean;
var
  i,j,o,p,g,signal,hvost : integer;
  vkl : boolean;
  jmp : TOZNeighbour;
begin
  try
    vkl := true;

    if mode then //----------------------------- признак включения/отключения автодействия
    begin //-------------------------------------------------------- включить автодействие
      for i := 10 to 12 do //--- пройти по цепочке описаний автодействий сигналов маршрута
      begin           //--------- попытаться установить автодействие всех сигналов цепочки
        o := ObjZav[Ptr].ObjConstI[i]; //------------------------------ очередное описание
        if o > 0 then
        begin
          signal := ObjZav[o].BaseObject;
          if not ObjZav[signal].bParam[4] and WorkMode.Upravlenie then //- поездной закрыт
          begin //----------------------------------------------------- не открыт светофор
            result := false;
            ShowShortMsg(429,LastX,LastY,ObjZav[signal].Liter);
            InsArcNewMsg(signal,429+$4000,1); //----------------------- Не открыт сигнал $
            exit;
          end;

          for j := 1 to 10 do //--------- пройти по стрелкам описания автодействия сигнала
          begin //-------------------------------------------- проверить положение стрелок
            p := ObjZav[o].ObjConstI[j];
            if p > 0 then
            begin
              if not ObjZav[p].bParam[1] and WorkMode.Upravlenie then
              begin //----------------------------------- нет контроля плюсового положения
                result := false;
                ShowShortMsg(268,LastX,LastY,ObjZav[ObjZav[p].BaseObject].Liter);
                InsArcNewMsg(ObjZav[o].BaseObject,268+$4000,1); // Стрелка без контроля ПК
                exit;
              end;
              hvost:= ObjZav[p].BaseObject;
              if (ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19])and //признак макет
              WorkMode.Upravlenie then
              begin //-------------------------------------------------- стрелка на макете
                result := false;
                ShowShortMsg(120,LastX,LastY,ObjZav[ObjZav[p].BaseObject].Liter);
                InsArcNewMsg(ObjZav[o].BaseObject,120+$4000,1);
                exit;
              end;
            end;
          end;
        end;
      end;

      //------------------------------------------ проверить враждебности для автодействия
      for i := 10 to 12 do
      begin
        o := ObjZav[Ptr].ObjConstI[i];
        if o > 0 then
        begin
          g := ObjZav[o].ObjConstI[25]; //-------------------------------------- взять КРУ
          MarhTracert[g].Rod := MarshP;
          MarhTracert[g].Finish := false;
          MarhTracert[g].WarCount := 0;
          MarhTracert[g].MsgCount := 0;
          MarhTracert[g].ObjStart := ObjZav[o].BaseObject;
          MarhTracert[g].Counter := 0;
          j := 1000;

          jmp := ObjZav[ObjZav[o].BaseObject].Neighbour[2];

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //MarhTracert[g].Level := tlSignalCirc;//--------------- режим сигнальная струна
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[g].Level := tlSetAuto; //-------------- режим установки автодействия
           //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTracert[g].FindTail := true;

          while j > 0 do
          begin
            case StepTrace(jmp,MarhTracert[g].Level,MarhTracert[g].Rod,g) of
              trStop, trEnd, trEndTrace : break;
            end;
            dec(j);
          end;
          if j < 1 then vkl := false; //------------------------ трасса маршрута разрушена
          if MarhTracert[g].MsgCount > 0 then vkl := false;
        end;
      end;

      if not vkl and WorkMode.Upravlenie then
      begin //--------------------------------------- отказано в установке на автодействие
        InsArcNewMsg(Ptr,476+$4000,1);
        ShowShortMsg(476,LastX,LastY,ObjZav[Ptr].Liter); //Автодействие не может быть вкл.
        SingleBeep4 := true;
        result := false;
        exit;
      end;

      //------------------------------------------------- расставить признаки автодействия
      for i := 10 to 12 do
      begin
        o := ObjZav[Ptr].ObjConstI[i];
        if o > 0 then
        begin
          ObjZav[o].bParam[1] := vkl;
          AutoMarshON(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].ObjConstB[1]);
        end;
      end;
      ObjZav[Ptr].bParam[1] := vkl;
      result := vkl;
    end else
    begin //------------------------------------------------------- отключить автодействие
      for i := 10 to 12 do
      if ObjZav[Ptr].ObjConstI[i] > 0 then
      begin //--------------------------------- сбросить автодействие всех сигналов группы
        ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] := false;
        AutoMarshOFF(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].ObjConstB[1]);
      end;
      ObjZav[Ptr].bParam[1] := false;
      result := true;
    end;
  except
    reportf('Ошибка [Marshrut.AutoMarsh]');
    result := false;
  end;
end;
//========================================================================================
function AutoMarshReset(Ptr : SmallInt) : Boolean;
//------------------------ Сброс автодействия при выдаче команды отмены поездного маршрута
var
  i : integer;
begin
try
  if (Ptr > 0) and (ObjZav[Ptr].TypeObj = 47) then
  begin
    if ObjZav[Ptr].bParam[1] then
    begin
      for i := 10 to 12 do
      begin
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin //------------------------------- сбросить автодействие всех сигналов группы
          ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] := false;
          AutoMarshOFF(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].ObjConstB[1]);
        end;
      end;
      ObjZav[Ptr].bParam[1] := false;
      InsArcNewMsg(Ptr,422+$4000,1);
      AddFixMessage(GetShortMsg(1,422, ObjZav[Ptr].Liter,1),4,3);
    end;
    result := true;
  end else
    result := false;
except
  reportf('Ошибка [Marshrut.AutoMarshReset]'); result := false;
end;
end;
//========================================================================================
//---------------- Разнести признаки автодействия по объектам трассы маршрута автодействия
function AutoMarshON(Ptr : SmallInt; Napr : Boolean) : Boolean;
var
  o,p,j,vid : integer;
begin
  result := false;
  if ObjZav[Ptr].BaseObject = 0 then exit;

  for j := 1 to 10 do
  if ObjZav[Ptr].ObjConstI[j] > 0 then
  begin
    o := ObjZav[Ptr].ObjConstI[j];
    if Napr then ObjZav[o].bParam[33] := true
    else ObjZav[o].bParam[25] := true;
    ObjZav[o].bParam[4] := ObjZav[o].bParam[33] or ObjZav[o].bParam[25];
  end;

  j := 100;
  o := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Obj;
  p := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Pin;
  ObjZav[ObjZav[Ptr].BaseObject].bParam[33] := true;
  while j > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 :  //--------------------------------------------------------------------- стрелка
      begin
        vid := ObjZav[o].VBufferIndex;
        OVBuffer[vid].Param[28] := ObjZav[o].bParam[4];
        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      3 :  //----------------------------------------------- ставим автодействие на секцию
      begin
        ObjZav[o].bParam[33] := true;

        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end  else
        begin
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      4 : //------------------------------------------------------------------------- путь
      begin
        ObjZav[o].bParam[33] := true;

        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      5 :  //-------------------------------------------------------------------- светофор
      begin
        if p = 1 then
        begin
          if ObjZav[o].ObjConstB[5] then break;
          ObjZav[o].bParam[33] := true;
          p := ObjZav[o].Neighbour[2].Pin;
          o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          if ObjZav[o].ObjConstB[6] then break;
          ObjZav[o].bParam[33] := true;
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- АБ
        ObjZav[o].bParam[33] := true; break;
      end;

      else //--------------------------------------------------------------- все остальные
      if p = 1 then
      begin
        p := ObjZav[o].Neighbour[2].Pin;
        o := ObjZav[o].Neighbour[2].Obj;
      end else
      begin
        p := ObjZav[o].Neighbour[1].Pin;
        o := ObjZav[o].Neighbour[1].Obj;
      end;
    end;

    if o < 1 then break;
    dec(j);
  end;
  result := true;
end;
//========================================================================================
//-------------------- Снять признаки автодействия с объектов трассы маршрута автодействия
function AutoMarshOFF(Ptr : SmallInt; Napr : Boolean) : Boolean;
var
  o,p,j,vid : integer;
begin
  result := false;
  if ObjZav[Ptr].BaseObject = 0 then exit;
  for j := 1 to 10 do
  if ObjZav[Ptr].ObjConstI[j] > 0 then
  begin
    o := ObjZav[Ptr].ObjConstI[j];
    if Napr then ObjZav[o].bParam[33] := false
    else ObjZav[o].bParam[25] := false;
    ObjZav[o].bParam[4] := ObjZav[o].bParam[25] or ObjZav[o].bParam[33];
  end;
  j := 100;
  o := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Obj;
  p := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Pin;
  ObjZav[ObjZav[Ptr].BaseObject].bParam[33] := false;
  while j > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 :
      begin //-------------------------------------------------------------------- стрелка
        //--------------------- пока считаем что все стрелки в автодействии стоят по плюсу
        vid := ObjZav[o].VBufferIndex;
        OvBuffer[vid].Param[28] := ObjZav[o].bParam[4];
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      3 :
      begin //--------------------------------------------------------------------- секция
        ObjZav[o].bParam[33] := false;
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      4 :
      begin //----------------------------------------------------------------------- путь
        ObjZav[o].bParam[33] := false;
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      5 :
      begin //------------------------------------------------------------------- светофор
        if p = 1 then
        begin
          if ObjZav[o].ObjConstB[5] then break;
          ObjZav[o].bParam[33] := false;
          p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          if ObjZav[o].ObjConstB[6] then break;
          ObjZav[o].bParam[33] := false;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- АБ
        ObjZav[o].bParam[33] := false;
        break;
      end;
      else //--------------------------------------------------------------- все остальные
        if p = 1 then
        begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else
        begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
    end;
    if o < 1 then break;
    dec(j);
  end;
  result := true;
end;
//========================================================================================
function StepTraceStrelka(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------ процедура прохода в маршруте через объект базы "стрелка"
begin
  case Lvl of //-------------------------------------------- переключатель по типу прохода
    tlFindTrace    :  result := StepStrelFindTrassa(Con,Lvl,Rod,Group,jmp);
    tlContTrace    :  result := StepStrelContTrassa(Con,Lvl,Rod,Group,jmp);
    tlVZavTrace    :  result := StepStrelZavTrassa(Con,Lvl,Rod,Group,jmp);
    tlCheckTrace   :  result := StepStrelCheckTrassa(Con,Lvl,Rod,Group,jmp);
    tlZamykTrace   :  result := StepStrelZamykTrassa(Con,Lvl,Rod,Group,jmp);

    tlSetAuto, tlSignalCirc : result := StepStrelSignalCirc(Con,Lvl,Rod,Group,jmp);

    tlOtmenaMarh   :  result := StepStrelOtmenaMarh(Con,Lvl,Rod,Group,jmp);
    tlRazdelSign   :  result := StepStrelRazdelSign(Con,Lvl,Rod,Group,jmp);
    tlFindIzvest   :  result := StepStrelFindIzvest(Con,Lvl,Rod,Group,jmp);
    tlFindIzvStrel :  result := StepStrelFindIzvStrel(Con,Lvl,Rod,Group,jmp);
    tlPovtorMarh   :  result := StepStrelPovtorMarh(Con,Lvl,Rod,Group,jmp);
    tlAutoTrace    :  result := StepStrelAutoTrace(Con,Lvl,Rod,Group,jmp);
    else              result := trEnd;
  end;
end;
//========================================================================================
function StepTraceSP(var Con:TOZNeighbour; const Lvl:TTracertLevel;
Rod:Byte;Group:Byte;jmp:TOZNeighbour):TTracertResult;
//----------------------------------------------------------------------- шаг через секцию
var
  k : integer;
  tail : boolean;
begin
  case Lvl of
    tlFindTrace    : result := StepSPforFindTrace (Con, Lvl, Rod, Group, jmp);
    tlContTrace    : result := StepSPforContTrace (Con, Lvl, Rod, Group, jmp);
    tlVZavTrace    : result := StepSPforZavTrace  (Con, Lvl, Rod, Group, jmp);
    tlCheckTrace   : result := StepSPforCheckTrace(Con, Lvl, Rod, Group, jmp);
    tlZamykTrace   : result := StepSPforZamykTrace(Con, Lvl, Rod, Group, jmp);

    tlSetAuto,  tlSignalCirc   : result := StepSPSignalCirc   (Con, Lvl, Rod, Group, jmp);

    tlOtmenaMarh   : result := StepSPOtmenaMarh   (Con, Lvl, Rod, Group, jmp);
    tlRazdelSign   : result := StepSPRazdelSign   (Con, Lvl, Rod, Group, jmp);
    tlPovtorRazdel : result := StepSPPovtorRazdel (Con, Lvl, Rod, Group, jmp);
    tlAutoTrace    : result := StepSPAutoTrace    (Con, Lvl, Rod, Group, jmp);
    tlFindIzvest   : result := StepSPFindIzvest   (Con, Lvl, Rod, Group, jmp);
    tlFindIzvStrel : result := StepSPFindIzvStrel (Con, Lvl, Rod, Group, jmp);
    tlPovtorMarh   : result := StepSPPovtorMarh   (Con, Lvl, Rod, Group, jmp);
    else             result := trNextStep;
  end;
end;
//========================================================================================
function StepTracePut (var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------- (4) процедура выполнения шага трассировки через путь
//---------- Con - соединитель с соседним объектом, с которого трасса вышла на данный путь
//---------- Lvl -------------------------------------------- уровень трассировки маршрута
//---------- Rod ------------------------------------------------------------ тип маршрута
//---------- Group ------------------------------------ номер маршрута в списке задаваемых
//---------- jmp ---------------------------------------- объект зависимостей данного пути

var
  k : integer;
  tail : boolean;
begin
  case Lvl of

    tlFindTrace    : result := StepPutFindTrassa  (Con, Lvl, Rod, Group, jmp);
    tlContTrace    : result := StepPutContTrassa  (Con, Lvl, Rod, Group, jmp);
    tlVZavTrace    : result := StepPutZavTrassa   (Con, Lvl, Rod, Group, jmp);
    tlCheckTrace   : result := StepPutCheckTrassa (Con, Lvl, Rod, Group, jmp);
    tlZamykTrace   : result := StepPutZamykTrassa (Con, Lvl, Rod, Group, jmp);

    tlSetAuto,  tlSignalCirc : result := StepPutSignalCirc  (Con, Lvl, Rod, Group, jmp);

    tlOtmenaMarh   : result := StepPutOtmenaMarh  (Con, Lvl, Rod, Group, jmp);
    tlRazdelSign   : result := StepPutRazdelSign  (Con, Lvl, Rod, Group, jmp);
    tlAutoTrace    : result := StepPutAutoTrace   (Con, Lvl, Rod, Group, jmp);
    tlFindIzvest   : result := StepPutFindIzvest  (Con, Lvl, Rod, Group, jmp);
    tlFindIzvStrel : result := StepPutFindIzvStrel(Con, Lvl, Rod, Group, jmp);
    tlPovtorRazdel,
    tlPovtorMarh   : result := StepPutPovtorMarh  (Con, Lvl, Rod, Group, jmp);
         else        result := trEnd;
  end;
end;
//========================================================================================
function StepTraceSvetofor(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod :Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------ пройти шаг через светофор по базе
//- Con : TOZNeighbour - при входе Con = jmp (откуда пришли), при выходе Con - куда уходим
//--------------------------------------- Lvl : TTracertLevel ---- этап работы с маршрутом
//------------------------------------------------------------ Rod:Byte ----- тип маршрута
//------------------------------------------ Group:Byte номер маршрута в списке задаваемых
//------------------------- jmp : TOZNeighbour ------  связь с соседом, от которого пришли
//------- таким образом jmp.Obj - это светофор, через который функция проводит шаг по базе
begin
  case Lvl of
    tlFindTrace    :  result := StepSvetoforFindTrace  (Con, Lvl, Rod, Group, jmp);
    tlContTrace    :  result := StepSvetoforContTrace  (Con, Lvl, Rod, Group, jmp);
    tlVZavTrace    :  result := StepSvetoforZavTrace   (Con, Lvl, Rod, Group, jmp);
    tlCheckTrace   :  result := StepSvetoforCheckTrace (Con, Lvl, Rod, Group, jmp);
    tlZamykTrace   :  result := StepSvetoforZamykTrace (Con, Lvl, Rod, Group, jmp);

    tlSetAuto, tlSignalCirc : result := StepSignalCirc (Con, Lvl, Rod, Group, jmp);

    tlOtmenaMarh   :  result := StepSigOtmenaMarh      (Con, Lvl, Rod, Group, jmp);
    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign   :  result := StepSigAutoPovtorRazdel(Con, Lvl, Rod, Group, jmp);
    tlFindIzvest   :  result := StepSigFindIzvest      (Con, Lvl, Rod, Group, jmp);
    tlFindIzvStrel :  result := StepSigFindIzvStrel    (Con, Lvl, Rod, Group, jmp);
    tlPovtorMarh   :  result := StepSigPovtorMarh      (Con, Lvl, Rod, Group, jmp);
    else              result := trEnd;
  end;
end;
//========================================================================================
function StepTraceAB(var Con:TOZNeighbour; const Lvl:TTracertLevel;
Rod : Byte;Group:Byte;jmp:TOZNeighbour):TTracertResult;
//---------------------------------------- (15) процедура трассировки через АвтоБлокировку
//--------------------------------------------------- трассируется объект  ObjZav[jmp.Obj]
begin
  case Lvl of
    tlFindTrace : //--------------------------------------------------------- поиск трассы
    begin
      result := trNextStep;
      if not MarhTracert[Group].LvlFNext then
      begin
        if Con.Pin = 1 then  //--------------------------- если подошли со стороны точки 1
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2]; //--------- то коннектор со стороны точки 2
          case Con.TypeJmp of
            LnkRgn : result := trRepeat; //----------- конец района управления - вернуться
            LnkEnd : result := trRepeat; //---------------------- конец строки - вернуться
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1]; //если пришли на точку 2, то коннектор от 1
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end;
    end;

    tlContTrace :  //----- Довести трассу до предполагаемого конца или отклоняющей стрелки
    begin
      case Rod of
        MarshP :
          if ObjZav[jmp.Obj].ObjConstB[1]     //--------- если есть отправление на перегон
          then result := trEndTrace
          else result := trStop;
        MarshM : result := trStop;
        else
          MarhTracert[Group].FullTail := true;
          result := trEndTrace;
      end;
    end;

    tlVZavTrace :  //---------------- проверить охранности по трассе (концы района и базы)
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace : //-------------- проверить трассу на возможность осуществления маршрута
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[6] then //-------------------------- если изъят КЖ
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] and //- подключаемый комплект капремонта и ...
            (ObjZav[jmp.Obj].bParam[7] or //------------ есть подключение к пути 1 или ...
            ObjZav[jmp.Obj].bParam[8]) then //------------------ есть подключение к пути 2
            begin //-  Подключаен комплект СН капремонта - запрещено отправление хозпоезда
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,363, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,363); //---------------------- Капремонт пути перегона!
                                         //--- Запрещено отправление хозпоезда на перегон!
              MarhTracert[Group].GonkaStrel := false;
            end else
            begin //-------------------------------------- Выдать предупреждение хозпоезду
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,133, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,133); // Установить маршрут отправления
                                         // хозяйственного поезда на перегон $?
            end;
          end;

          if ObjZav[jmp.Obj].ObjConstB[1] then //------------- есть отправление на перегон
          begin
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin //--------------------- если есть смена направления - проверить комплект
              if ObjZav[jmp.Obj].ObjConstB[3] then
              begin //----------------------------------------- есть подключение комплекта
                if ObjZav[jmp.Obj].ObjConstB[4] then
                begin //------------------------------------------------ перегон по приему
                  if (not ObjZav[jmp.Obj].bParam[7]) or
                  (ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8]) then
                  begin //---------------- Комплект не подключен или подключен неправильно
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);//Не подключен комплект смены направления...
                    MarhTracert[Group].GonkaStrel := false;
                  end else
                  if not ObjZav[jmp.Obj].ObjConstB[10] then  //--------- если не однопутка
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] then //------------ СН не отправление
                    begin
                      result := trBreak;
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,128);//- Не установлено направл. по отправлению
                    end;
                  end else //---------------------------------------------- если однопутка
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] and //------------ СН не отправление
                    not ObjZav[jmp.Obj].bParam[5]//------------------------- занят перегон
                    then
                    begin
                      result := trBreak;
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,262, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,262);//-------------------------- занят перегон
                    end;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[5] then //------------ перегон по отправлению
                begin
                  if ObjZav[jmp.Obj].bParam[7] then
                  begin //--------------------------------- Комплект подключен неправильно
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);//Не подключен комплект смены направления...
                    MarhTracert[Group].GonkaStrel := false;
                  end else
                  if ObjZav[jmp.Obj].bParam[8] then
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] then //--------------------------- СН
                    begin
                      result := trBreak;
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,128);//Не установлено направление по отправлению
                    end;
                  end;
                end;
              end else
              begin //--------------------- комплект смены направления подключен постоянно
                if not ObjZav[jmp.Obj].ObjConstB[10] then  //----- если не однопутка и ...
                begin
                  if not ObjZav[jmp.Obj].bParam[4] then //----------------- не отправление
                  begin
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,128);// Не установлено направление по отправлению
                  end;
                end else //------------------------------------------------ если однопутка
                begin
                  if not ObjZav[jmp.Obj].bParam[4] and //--------------- СН не отправление
                  not ObjZav[jmp.Obj].bParam[5]//--------------------------- занят перегон
                  then
                  begin
                    result := trBreak;
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,262, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,262);//---------------------------- занят перегон
                  end;
                end;
              end;
            end;
          end else
          begin //--------------------------------------------- нет отправления на перегон
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,131, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,131);//----------------------- Нет отправления на перегон
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[3] then  //------------- если подключаемый комплект
          begin
            if ObjZav[jmp.Obj].ObjConstB[4] then //------------ если без комплекта - прием
            begin //------------------- а с комплектом - отправление по неправильному пути
              if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] then // ИП
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129);//----------------------- Занят участок удаления
              end;
            end else
            begin //-------------------------------------- Отправление по правильному пути
              if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- ИП
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129);//----------------------- Занят участок удаления
              end;
            end;
          end else //--------------------------------- если нет подключаемого комплекта СН
          begin
            if not ObjZav[jmp.Obj].bParam[2] then //----------------------------------- ИП
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,129);//------------------------- Занят участок удаления
            end;
          end;

          if ObjZav[jmp.Obj].bParam[9] then //------------------------ отправлен хоз.поезд
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130);  //------- Отправлен хозяйственный поезд на перегон
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //- перегон заблокирован программно ("колпачок")
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------  Перегон $ закрыт
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462);//------------- Закрыто движение на электротяге по
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467);//Закрыто движение на электротяге пост.тока по $
              end;
              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------- Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472);
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1); // Участок $ не электрифицированный
            InsWar(Group,jmp.Obj,474);
          end;
        end;

        MarshM :
        begin
          //
        end;
        else   result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        if result = trBreak then exit;
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        if result = trBreak then exit;
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[6] then //------------------------------------- КЖ
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] and
            (ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[8]) then
            begin //-------------- Подключаемый комплект - запрещено отправление хозпоезда
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,363, ObjZav[jmp.Obj].Liter,1);
              //------ Капремонт пути перегона! Запрещено отправление хозпоезда на перегон
              InsMsg(Group,jmp.Obj,363);
            end else
            begin //-------------------------------------- Выдать предупреждение хозпоезду
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,133, ObjZav[jmp.Obj].Liter,1);
              //---------- Установить маршрут отправления хозяйственного поезда на перегон
              InsWar(Group,jmp.Obj,133);
            end;
          end;

          if ObjZav[jmp.Obj].ObjConstB[1] then
          begin //-------------------------------------------- есть отправление на перегон
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin //--------------------- если есть смена направления - проверить комплект
              if ObjZav[jmp.Obj].ObjConstB[3] then
              begin //----------------------------------------- есть подключение комплекта
                if ObjZav[jmp.Obj].ObjConstB[4] then
                begin //------------------------------------------------ перегон по приему
                  if (not ObjZav[jmp.Obj].bParam[7]) or
                  (ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8]) then
                  begin //---------------- Комплект не подключен или подключен неправильно
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);
                  end else
                  if not ObjZav[jmp.Obj].ObjConstB[10] and //---------- не однопутка и ...
                  not ObjZav[jmp.Obj].bParam[4] then //-------------------- не отправление
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,128);
                  end;
                end else //---------------------------------------- перегон по отправлению
                if ObjZav[jmp.Obj].ObjConstB[5] then
                begin //------------------------------------------- перегон по отправлению
                  if ObjZav[jmp.Obj].bParam[7] then
                  begin //--------------------------------- Комплект подключен неправильно
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,132, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,132);//Не подключен комплект смены направления по
                  end else
                  if ObjZav[jmp.Obj].bParam[8] then
                  begin
                    if not ObjZav[jmp.Obj].bParam[4] then //--------------------------- СН
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                      InsMsg(Group,jmp.Obj,128);
                    end;
                  end;
                end;
              end else
              begin //--------------------- комплект смены направления подключен постоянно
                if not ObjZav[jmp.Obj].bParam[4] then //------------------------------- СН
                begin
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,128, ObjZav[jmp.Obj].Liter,1);
                  InsMsg(Group,jmp.Obj,128);
                end;
              end;
            end;
          end else
          begin //--------------------------------------------- нет отправления на перегон
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,131, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,131);
          end;

          if ObjZav[jmp.Obj].ObjConstB[3] then
          begin
            if ObjZav[jmp.Obj].ObjConstB[4] then
            begin //------------------------------------ Отправление по неправильному пути
              if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] then // ИП
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129); //---------------------- Занят участок удаления
              end;
            end else
            begin //-------------------------------------- Отправление по правильному пути
              if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- ИП
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,129);  //--------------------- Занят участок удаления
              end;
            end;
          end else
          begin
            if not ObjZav[jmp.Obj].bParam[2] then //----------------------------------- ИП
            begin
              if Lvl= tlAutoTrace then exit;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,129, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,129);//------------------------- Занят участок удаления
            end;
          end;

          if ObjZav[jmp.Obj].bParam[9] then //------------------------ отправлен хоз.поезд
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130); //------ Отправлен хозяйственный поезд на перегон $
          end;

          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------- Перегон $ закрыт
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            //----------------------------------------------- Закрыт для движения на эл.т.
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462); //---------- Закрыто движение на электротяге по $
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and
            ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467); //------ Закрыто движение на ЭТ пост. тока по $
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472); //----- Закрыто движение на ЭТ перем. тока по $
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,474); //---------------- Участок $ не электрифицированный
          end;
        end;

        MarshM :
        begin
         //
        end;
        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end;
        end;

        tlPovtorMarh :
        begin
          MarhTracert[Group].ObjEnd := jmp.Obj; // зафиксировать конец маршрута отправления
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlZamykTrace :
        begin
          ObjZav[jmp.Obj].bParam[14] := true;
          ObjZav[jmp.Obj].bParam[15] := true;
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          ObjZav[jmp.Obj].bParam[14] := false;
          ObjZav[jmp.Obj].bParam[15] := false;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlFindIzvest :
        begin
          if ObjZav[jmp.Obj].ObjConstB[2] then
          begin // есть смена направления
            if ObjZav[jmp.Obj].ObjConstB[3] then
            begin // есть подключение комплекта
              if ObjZav[jmp.Obj].ObjConstB[4] then
              begin // перегон специализован по приему
                if ObjZav[jmp.Obj].bParam[7] and not ObjZav[jmp.Obj].bParam[8] then
                begin
                  if ObjZav[jmp.Obj].bParam[4] then
                  begin // перегон по приему
                    if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                    begin // Занято приближение
                      result := trBreak;
                    end else
                      result := trStop;
                  end else
                    result := trStop;
                end else
                if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                begin // Занято приближение
                  result := trBreak;
                end else
                  result := trStop;
              end else
              if ObjZav[jmp.Obj].ObjConstB[5] then
              begin // перегон специализован по отправлению
                if not ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8] then
                begin
                  if not ObjZav[jmp.Obj].bParam[4] then
                  begin // перегон по приему
                    if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                    begin // Занято приближение
                      result := trBreak;
                    end else
                      result := trStop;
                  end else
                  if not ObjZav[jmp.Obj].bParam[2] then result := trBreak else result := trStop;
                end else
                  result := trStop;
              end else
                result := trStop;
            end else
            begin // комплект подключен постоянно
              if not ObjZav[jmp.Obj].bParam[4] then
              begin // перегон по приему
                if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                begin // Занято приближение
                  result := trBreak;
                end else
                  result := trStop;
              end else
              if not ObjZav[jmp.Obj].bParam[2] then result := trBreak else result := trStop;
            end;
          end else
          if ObjZav[jmp.Obj].ObjConstB[4] then
          begin // перегон специализован по приему
            if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
            begin // Занято приближение
              result := trBreak;
            end else
              result := trStop;
          end else
            result := trStop;
        end;

        tlFindIzvStrel :    result := trStop;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTracePriglas(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------- Пригласительный сигнал (7)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlCheckTrace :
    begin
      result := trNextStep;
      if ObjZav[jmp.Obj].bParam[1] then //--------------------------------------------- ПС
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,116, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,116); //------------ Открыт враждебный пригласительный сигнал
        MarhTracert[Group].GonkaStrel := false;
      end;

      if Con.Pin = 1 then   //---------------------------------- встречный пригласительный
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else  //----------------------------------------------- попутный пригласительный
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      if ObjZav[jmp.Obj].bParam[1] then //--------------------------------------------- ПС
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,116, ObjZav[jmp.Obj].Liter,1);//---- Открыт враждебный пригласительный
        InsMsg(Group,jmp.Obj,116);
      end;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceUKSPS(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------------------------------------------------- УКСПС (14)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].BaseObject = MarhTracert[Group].ObjStart then
          begin
            if ObjZav[jmp.Obj].bParam[1] then //-------------------------------------- ИКС
            begin
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,124, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,124);
            end else
            begin
              if ObjZav[jmp.Obj].bParam[3] then //------------------------------------ 1КС
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,125, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,125);
                MarhTracert[Group].GonkaStrel := false;
              end;

              if ObjZav[jmp.Obj].bParam[4] then //------------------------------------ 2КС
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,126, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,126);
                MarhTracert[Group].GonkaStrel := false;
              end;

              if ObjZav[jmp.Obj].bParam[5] then //------------------------------------ КзК
              begin
                result := trBreak;
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,127, ObjZav[jmp.Obj].Liter,1);
                InsMsg(Group,jmp.Obj,127);
                MarhTracert[Group].GonkaStrel := false;
              end;
            end;
          end;
        end;

        MarshM,MarshL :
        begin
        end;

        else result := trStop;  exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].BaseObject = MarhTracert[Group].ObjStart then
          begin
            if ObjZav[jmp.Obj].bParam[1] then //-------------------------------------- ИКС
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,124, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,124);
            end else
            begin
              if ObjZav[jmp.Obj].bParam[3] then //------------------------------------ 1КС
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,125, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,125);
              end;

              if ObjZav[jmp.Obj].bParam[4] then //------------------------------------ 2КС
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,126, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,126);
              end;

              if ObjZav[jmp.Obj].bParam[5] then //------------------------------------ КзК
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,127, ObjZav[jmp.Obj].Liter,0);
                InsMsg(Group,jmp.Obj,127);
              end;
            end;
          end;
        end;

        MarshM,MarshL :
        begin
        end;

        else result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceVSN(var Con:TOZNeighbour; const Lvl:TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------- Вспомогательная смена направления АБ (16)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else     result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else     result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else     result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc,
    tlCheckTrace :
    begin
      case Rod of
        MarshP : begin      end;
        MarshM : begin      end;
        else  result := trStop;  exit;
      end;

      result := trNextStep;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    else
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else  result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end;
  end;
end;
//========================================================================================
function StepTraceUvazManRn(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------- Увязка с маневровым районом (23)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,244, '',1);
          InsMsg(Group,jmp.Obj,244);    //----------------------- "Нет поездных маршрутов"
          MarhTracert[Group].GonkaStrel := false;
        end;

        MarshM :
        begin
         case Con.Pin of
          1 :
          begin
            if not ObjZav[jmp.Obj].bParam[1] then //---------------------------------- УМП
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,245);
              MarhTracert[Group].GonkaStrel := false;
            end;
          end;

          else
            if not ObjZav[jmp.Obj].bParam[2] then //---------------------------------- УМО
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,245);
              MarhTracert[Group].GonkaStrel := false;
            end;
         end;
        end;
        else
          result := trStop;
          exit;
        end;

        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
          end;
        end;
      end;

      tlAutoTrace,
      tlPovtorRazdel,
      tlRazdelSign,
      tlSignalCirc :
      begin
        result := trNextStep;
        case Rod of
          MarshP :
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,244, '',1);
            InsMsg(Group,jmp.Obj,244);
          end;

          MarshM :
          begin
              case Con.Pin of
                1 :
                begin
                  if not ObjZav[jmp.Obj].bParam[1] then //---------------------------- УМП
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
                    InsMsg(Group,jmp.Obj,245);
                  end;
                end;
              else
                if not ObjZav[jmp.Obj].bParam[2] then //------------------------------ УМО
                begin
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,245, ObjZav[jmp.Obj].Liter,1);
                  InsMsg(Group,jmp.Obj,245);
                end;
              end;
            end;
          else
            result := trStop;
            exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceZaprosPoezdOtpr(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------------------- Запрос согласия поездного отправления (24)
begin
  case Lvl of
    tlFindTrace : result := trRepeat;

    tlContTrace :
    begin
      MarhTracert[Group].FullTail := true;
      result := trEndTrace;
    end;

    tlVZavTrace : result := trStop;

    tlCheckTrace :
    begin
      result := trEndTrace;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[13] then //------------------------------------ ФС
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,246, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,246); //------------------- Нет согласия поездного приема
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].bParam[3] then //--------------------------------------- НЭГС
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,105);//-------- Нажата кнопка экстренного гашения сигнала
            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[jmp.Obj].bParam[8] then //------------------------------------- чи
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,248, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,248); //---------- Установлен враждебный поездной маршрут
          end;

          if ObjZav[jmp.Obj].bParam[9] then //---------------------------------------- чкм
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,249, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,249); //-------- Установлен враждебный маневровый маршрут
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //-------------------------------------- п
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,250, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,250); //------------------------- Занят участок по увязке
          end;

          if ObjZav[jmp.Obj].bParam[14] or
          ObjZav[jmp.Obj].bParam[15] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,432);  //------------------------------ Перегон $ закрыт#
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Title,1);
              InsWar(Group,jmp.Obj,462); //--------------- Закрыто движение на электротяге
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,467); // Закрыто движение на ЭТ постоянного тока по $
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,472); //-- Закрыто движение на ЭТ переменного тока по
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Title,1);
            InsWar(Group,jmp.Obj,474);
          end;
        end;

        MarshM : begin        end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trEndTrace;
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[13] then //------------------------------------ ФС
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,246, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,246);   //----------------- Нет согласия поездного приема
          end;

          if ObjZav[jmp.Obj].bParam[3] then //--------------------------------------- НЭГС
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,105);
          end;

          if not ObjZav[jmp.Obj].bParam[8] then //------------------------------------- чи
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,248, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,248);  //--------- Установлен враждебный поездной маршрут
          end;

          if ObjZav[jmp.Obj].bParam[9] then //---------------------------------------- чкм
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,249, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,249); //-------- Установлен враждебный маневровый маршрут
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //-------------------------------------- п
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,250, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,250); //------------------------- Занят участок по увязке
          end;

          if ObjZav[jmp.Obj].bParam[14] or
          ObjZav[jmp.Obj].bParam[15] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Title,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------- Перегон $ закрыт
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Title,1);
              InsWar(Group,jmp.Obj,462); //------------ Закрыто движение на электротяге по
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,467); //-- Закрыто движение на ЭТ постоянного тока по
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Title,1);
                InsWar(Group,jmp.Obj,472); //----------------- Конец контактной подвески $
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Title,1);
            InsWar(Group,jmp.Obj,474);   //-------------- Участок $ не электрифицированный
          end;
        end;

        MarshM : begin      end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlFindIzvest :
    begin
      if (not ObjZav[jmp.Obj].bParam[5] and
      not ObjZav[jmp.Obj].bParam[8]) or
      not ObjZav[jmp.Obj].bParam[7] then //---------------------------- Занято приближение
      result := trBreak
      else result := trStop;
    end;

    tlFindIzvStrel : result := trStop;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTracePAB(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//-------------------------------------------------------------------------------- ПАБ(26)
begin
  case Lvl of
    tlFindTrace :
    begin
      result := trNextStep;
      if not MarhTracert[Group].LvlFNext then
      begin
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end;
    end;

    tlPovtorMarh,
    tlContTrace :
    begin
      case Rod of
        MarshP :
          if ObjZav[jmp.Obj].ObjConstB[1] then result := trEndTrace
          else result := trStop;

        MarshM : result := trStop;

        else result := trEndTrace;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432);  //------------------------------ Перегон $ закрыт#
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //------------------ Закрыт для движения на ЭТ
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462); //------------ Закрыто движение на электротяге по
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467); // Закрыто движение на ЭТ постоянного тока по $
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472); // Закрыто движение на ЭТ переменного тока по $
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,474); //---------------- Участок $ не электрифицированный
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //------------------- Хозпоезд на перегоне
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130); //-------- Отправлен хозяйственный поезд на перегон
            MarhTracert[Group].GonkaStrel := false;
          end else
          if not ObjZav[jmp.Obj].bParam[1] then //---------------- Перегон занят по приему
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,318, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,318); //----------------------- Перегон $ занят по приему
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[2] then //------------------- Получено прибытие поезда
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,319, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,319); //------------ Получено прибытие поезда на перегоне
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[4] then //-------- Выдано согласие на соседнюю станцию
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,320, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,320); // Выдано согласие отправления поезда на перегоне $
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[6] then //----------------------- согласие отправления
          begin
            if not ObjZav[jmp.Obj].bParam[5] then //есть занятость перегона по отправлению
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,299, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,299); //---------------- Перегон $ занят по отправлению
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,237, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,237); //------------- Нет согласия отправления на перегон
          end;

          if not ObjZav[jmp.Obj].bParam[9] then //---------------------- Занят известитель
          begin
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);  //--------------------------------- Участок $ занят
          end;
        end;

        MarshM :  begin  end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if ObjZav[jmp.Obj].bParam[12] or
          ObjZav[jmp.Obj].bParam[13] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,432, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,432); //-------------------------------- Перегон $ закрыт
          end;

          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or
            ObjZav[jmp.Obj].bParam[27] then //--------------- Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,462); //---------- Закрыто движение на электротяге по $
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or
              ObjZav[jmp.Obj].bParam[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,467);
              end;

              if ObjZav[jmp.Obj].bParam[26] or
              ObjZav[jmp.Obj].bParam[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
                InsWar(Group,jmp.Obj,472); //-- Закрыто движение на ЭТ переменного тока по
              end;
            end;
          end else
          begin //-------------------------------------- конец подвески контакного провода
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,474, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,474);
          end;

          if not ObjZav[jmp.Obj].bParam[7] then //------------------- Хозпоезд на перегоне
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,130, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,130); //------ Отправлен хозяйственный поезд на перегон $
          end else
          if not ObjZav[jmp.Obj].bParam[1] then //---------------- Перегон занят по приему
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,318, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,318); //----------------------- Перегон $ занят по приему
          end else
          if ObjZav[jmp.Obj].bParam[2] then //------------------- Получено прибытие поезда
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,319, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,319); //---------- Получено прибытие поезда на перегоне $
          end else
          if ObjZav[jmp.Obj].bParam[4] then //-------- Выдано согласие на соседнюю станцию
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,320, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,320); // Выдано согласие отправления поезда на перегоне $
          end else
          if ObjZav[jmp.Obj].bParam[6] then //----------------------- согласие отправления
          begin
            if not ObjZav[jmp.Obj].bParam[5] then //есть занятость перегона по отправлению
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,299, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,299); //---------------- Перегон $ занят по отправлению
            end;
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,237, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,237);  //------------ Нет согласия отправления на перегон
          end;

          if not ObjZav[jmp.Obj].bParam[9] then //---------------------- Занят известитель
          begin
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- Участок $ занят
          end;
        end;

        MarshM : begin  end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlFindIzvest :
      if not ObjZav[jmp.Obj].bParam[9] then  result := trBreak  //----- Занято приближение
      else result := trStop;


    tlFindIzvStrel : result := trStop;

    else
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end;
  end;
end;
//========================================================================================
function StepTraceDZOhr(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------------------------- Охранности стрелок (27)
var
  o,k,m : integer;
  tr : boolean;
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace : //------------------------- проверка охранного положения при трассировке
    begin
      o := ObjZav[jmp.Obj].ObjConstI[1]; //------------------------ контролируемая стрелка
      k := ObjZav[jmp.Obj].ObjConstI[3]; //------------------------------ охранная стрелка
      if (o > 0) and (k > 0) then
      begin
        tr := ObjZav[k].bParam[6] or ObjZav[k].bParam[7] or
        ObjZav[k].bParam[10] or ObjZav[k].bParam[11] or
        ObjZav[k].bParam[12] or ObjZav[k].bParam[13];

        m := ObjZav[k].BaseObject;

        if (ObjZav[m].ObjConstI[8] = k) and (ObjZav[m].ObjConstI[9] > 0) then
        m := ObjZav[m].ObjConstI[9]
        else
        if ObjZav[m].ObjConstI[8] > 0
        then m := ObjZav[m].ObjConstI[8] else m := 0;

        if m > 0 then
        tr := tr or ObjZav[k].bParam[6] or ObjZav[k].bParam[7] or
        ObjZav[m].bParam[10] or ObjZav[m].bParam[11] or
        ObjZav[m].bParam[12] or ObjZav[m].bParam[13];

        if ObjZav[jmp.Obj].ObjConstB[5] or tr then
        begin //---------------------------- выполняется гонка охранной стрелки в маршруте
          if ObjZav[jmp.Obj].ObjConstB[1] then //Контролируемая стрелка охраняется в плюсе
          begin
            if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11])
            or ObjZav[o].bParam[12]) then
            begin
              if ObjZav[jmp.Obj].ObjConstB[3] then //-------- охранная должна быть в плюсе
              begin
                if (ObjZav[k].bParam[10] and ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[7]) or
                ObjZav[k].bParam[13] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- разные СП
                  not ObjZav[k].bParam[14] then //-- не выдана маршрутная команда в сервер
                  begin
                    result := trStop;
                    exit; //----------------------- охранная трассируется в минусе - отказ
                  end;
                end;
              end else
              if ObjZav[jmp.Obj].ObjConstB[4] then //------- охранная должна быть в минусе
              begin
                if (ObjZav[k].bParam[10] and not ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[6]) or
                ObjZav[k].bParam[12] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- разные СП
                  not ObjZav[k].bParam[14] then //-- не выдана маршрутная команда в сервер
                  begin
                    result := trStop; exit; //------ охранная трассируется в плюсе - отказ
                  end;
                end;
              end;
            end;
          end else
          if ObjZav[jmp.Obj].ObjConstB[2] then//Контролируемая стрелка охраняется в минусе
          begin
            if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
            ObjZav[o].bParam[13]) then
            begin
              if ObjZav[jmp.Obj].ObjConstB[3] then //-------- охранная должна быть в плюсе
              begin
                if (ObjZav[k].bParam[10] and ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[7]) or
                ObjZav[k].bParam[13] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- разные СП
                  not ObjZav[k].bParam[14] then //-- не выдана маршрутная команда в сервер
                  begin
                    result := trStop; exit; //----- охранная трассируется в минусе - отказ
                  end;
                end;
              end else
              if ObjZav[jmp.Obj].ObjConstB[4] then //------- охранная должна быть в минусе
              begin
                if (ObjZav[k].bParam[10] and not ObjZav[k].bParam[11]) or
                ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[6]) or
                ObjZav[k].bParam[12] then
                begin
                  if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and //-- разные СП
                  not ObjZav[k].bParam[14] then //-- не выдана маршрутная команда в сервер
                  begin
                    result := trStop; exit; //------ охранная трассируется в плюсе - отказ
                  end;
                end;
              end;
            end;
          end;
        end else
        begin //------------------------- не выполняется гонка охранной стрелки в маршруте
          if ((jmp.Pin = 1) and not ObjZav[jmp.Obj].ObjConstB[6]) or
          ((jmp.Pin = 2) and not ObjZav[jmp.Obj].ObjConstB[7]) then
          begin
            if ObjZav[jmp.Obj].ObjConstB[1] then //- Контролируемая стрелка охраняется в +
            begin
              if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or
              ObjZav[o].bParam[12]) then
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then //------ охранная должна быть в плюсе
                begin
                  if not (ObjZav[k].bParam[1] and not ObjZav[k].bParam[2]) then
                  begin //--------------------- охранная не имеет контроля в плюсе - отказ
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,268); //- Нет контроля плюса стрелки
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then //----- охранная должна быть в минусе
                begin
                  if not (not ObjZav[k].bParam[1] and ObjZav[k].bParam[2]) then
                  begin //-------------------- охранная не имеет контроля в минусе - отказ
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,267); // Нет контроля минуса стрелки
                    result := trStop;
                    exit;
                  end;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[2] then //- Контролируемая стрелка охраняется в -
            begin
              if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
              ObjZav[o].bParam[13]) then
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then //------ охранная должна быть в плюсе
                begin
                  if not (ObjZav[k].bParam[1] and not ObjZav[k].bParam[2]) then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,268); //- Нет контроля плюса стрелки
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then //----- охранная должна быть в минусе
                begin
                  if not (not ObjZav[k].bParam[1] and ObjZav[k].bParam[2]) then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267,ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,267); // Нет контроля минуса стрелки
                    result := trStop; exit;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      //--------------------------------------------------- Найти следующий элемент трассы
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      //------------ проверка возможности установки охранной стрелки в требуемое положение
      o := ObjZav[jmp.Obj].ObjConstI[1]; //------------------------ контролируемая стрелка
      k := ObjZav[jmp.Obj].ObjConstI[3]; //------------------------------ охранная стрелка

      if (o > 0) and (k > 0) then
      begin
        if ObjZav[jmp.Obj].ObjConstB[1] then
        begin
          if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or
          ObjZav[o].bParam[12]) then //----------Контролируемая стрелка охраняется в плюсе
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- Охранная стрелка должна быть в плюсе
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZav[ObjZav[k].BaseObject].bParam[7] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);// СП замкнута(стр. в маршруте +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if not ObjZav[k].bParam[1] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); // увеличить число стрелок, с переводом

                if not ObjZav[k].bParam[2] then //----------------- нет контроля положения
                begin
                  if not ObjZav[k].bParam[6] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81); //------ Стрелка $ без контроля
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);// СП замкнута(стр. в маршруте +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- надо проверять МСП и
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... идет выдержка МСП
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80); //------------ Стрелка $ замкнута
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,118, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,118);//СП занята стр $ в маршруте по +
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,136, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,136);// Стр на макете(должна быть по+)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,121, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,121);//Стр выключена (в маршруте по +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZav[ObjZav[k].BaseObject].bParam[6] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- надо проверять МСП и
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... идет выдержка МСП
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTracert[Group].GonkaStrel := false;
                end;

              if not ObjZav[k].bParam[2] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); // увеличить число перевоодимых стрелок
                if not ObjZav[k].bParam[1] then
                begin //------------------------------------------- нет контроля положения
                  if not ObjZav[k].bParam[7] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81);
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,157, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,157);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,158, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,158);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,137, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,137);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,159, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,159);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end;
          end;
        end else
        if ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
          ObjZav[o].bParam[13]) then //-------- Контролируемая стрелка охраняется в минусе
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- Охранная стрелка должна быть в плюсе
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZav[ObjZav[k].BaseObject].bParam[7] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);//СП замкнута (стрелка нужна в +)
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- надо проверять МСП и
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... идет выдержка МСП
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTracert[Group].GonkaStrel := false;
                end;

              if not ObjZav[k].bParam[1] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); // увеличить число перевоодимых стрелок

                if not ObjZav[k].bParam[2] then
                begin //------------------------------------------- нет контроля положения
                  if not ObjZav[k].bParam[6] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81);
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- надо проверять МСП и
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... идет выдержка МСП
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,118, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,118);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,136, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,136);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,121, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,121);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZav[o].ObjConstI[20] = k then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZav[ObjZav[k].BaseObject].bParam[6] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,117);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if ObjZav[ObjZav[k].BaseObject].ObjConstB[3] and//--- надо проверять МСП и
                not ObjZav[ObjZav[k].BaseObject].bParam[20] then //..... идет выдержка МСП
                begin
                  InsArcNewMsg(ObjZav[k].BaseObject,392+$4000,1);
                  ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[k].BaseObject].Liter);
                  result := trBreak;
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,392, ObjZav[k].Liter,1);
                  InsMsg(Group,k,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTracert[Group].GonkaStrel := false;
                end;
                
              if not ObjZav[k].bParam[2] then
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
                inc(MarhTracert[Group].GonkaList); //- увеличить число переводимых стрелок

                if not ObjZav[k].bParam[1] then
                begin //------------------------------------------- нет контроля положения
                  if not ObjZav[k].bParam[7] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[k].BaseObject,81);
                    result := trBreak;
                    MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,157, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,157);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,158, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,158);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,137, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,137);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;

                if ObjZav[k].bParam[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,159, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,159);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end;
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      //------------ проверка возможности установки охранной стрелки в требуемое положение
      o := ObjZav[jmp.Obj].ObjConstI[1]; //------------------------ контролируемая стрелка
      k := ObjZav[jmp.Obj].ObjConstI[3]; //------------------------------ охранная стрелка

      if (o > 0) and (k > 0) then
      begin
        if ObjZav[jmp.Obj].ObjConstB[1] then
        begin
          if ObjZav[o].bParam[1] then //-------- Контролируемая стрелка охраняется в плюсе
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- Охранная стрелка должна быть в плюсе
            begin
              if ObjZav[k].bParam[1] then
              begin //------------------------------------ проверить наличие гонки в минус
                if ObjZav[k].bParam[7] then
                begin //----------------------------- охранная стрелка гонится в минус
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);
                end;
              end else
              begin
                if not ObjZav[k].bParam[2] then
                begin //------------------------------------------- нет контроля положения
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81);
                end else
                begin //---------------------------------------- охранная стрелка в минусе
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZav[k].bParam[2] then
              begin //------------------------------------- проверить наличие гонки в плюс
                if ObjZav[k].bParam[6] then
                begin //---------------------------------- охранная стрелка гонится в плюс
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235);
                end;
              end else
              begin
                if not ObjZav[k].bParam[1] then
                begin //------------------------------------------- нет контроля положения
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81); //--- Стрелка $ не имеет контроля
                end else
                begin //----------------------------------------- охранная стрелка в плюсе
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235); //-- Охранная стр. в + (нужен -)
                end;
              end;
            end;
          end;
        end else
        if ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          if ObjZav[o].bParam[2] then //------- Контролируемая стрелка охраняется в минусе
          begin
            if ObjZav[jmp.Obj].ObjConstB[3] then //-- Охранная стрелка должна быть в плюсе
            begin
              if ObjZav[k].bParam[1] then
              begin //------------------------------------ проверить наличие гонки в минус
                if ObjZav[k].bParam[7] then
                begin //--------------------------------- охранная стрелка гонится в минус
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);//--- Охранная стр. в - (нужен +)
                end;
              end else
              begin
                if not ObjZav[k].bParam[2] then
                begin //------------------------------------------- нет контроля положения
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81); //--- Стрелка $ не имеет контроля
                end else
                begin //---------------------------------------- охранная стрелка в минусе
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,236);//--- Охранная стр. в - (нужен +)
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZav[k].bParam[2] then
              begin //----------------------------00------- проверить наличие гонки в плюс
                if ObjZav[k].bParam[6] then
                begin //-------------------------00------- охранная стрелка гонится в плюс
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235); //00 Охранная стр. в + (нужен -)
                end;
              end else
              begin
                if not ObjZav[k].bParam[1] then
                begin //-----------------------00------------------ нет контроля положения
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,81); //--- Стрелка $ не имеет контроля
                end else
                begin //----------------------------------------- охранная стрелка в плюсе
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[k].BaseObject,235); //-- Охранная стр. в + (нужен -)
                end;
              end;
            end;
          end;
        end;
      end;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceIzvPer(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp:TOZNeighbour) : TTracertResult;
//-------------------------------------------------------------- Извещение на переезд (28)
var
  o : integer;
begin
  case Lvl of
    tlFindTrace :  //-------------------------------------------------------- поиск трассы
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      o := ObjZav[jmp.Obj].BaseObject; //--------------------------------- объект переезда
      if ObjZav[o].bParam[4] then //--------------------------------------- зГ на переезде
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,107, ObjZav[o].Liter,1);
        result := trBreak;
        InsMsg(Group,o,107);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if ObjZav[o].bParam[1] then //----------------------------------- авария на переезде
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,143, ObjZav[o].Liter,1);
        result := trBreak;
        InsWar(Group,o,143);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then // неисправность на переезде
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,144, ObjZav[o].Liter,1);
        result := trBreak;
        InsWar(Group,o,144);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign,
    tlSignalCirc :
    begin
      result := trNextStep;
      o := ObjZav[jmp.Obj].BaseObject;
      if ObjZav[o].bParam[4] then //--------------------------------------- зГ на переезде
      begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,107, ObjZav[o].Liter,1);
            InsMsg(Group,o,107);
          end;
          if ObjZav[o].bParam[1] then
          begin // авария на переезде
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,143, ObjZav[o].Liter,1);
            InsWar(Group,o,143);
          end;
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin // неисправность на переезде
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,144, ObjZav[o].Liter,1); InsWar(Group,o,144);
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceDZSP(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------------------- ДЗ секции (29)
var
  o,k : integer;
  p : boolean;
begin
      case Lvl of
        tlFindTrace :
        begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
              else     result := trNextStep;
            end;
          end
          else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
              else     result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace :
        begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
              else     result := trNextStep;
            end;
          end
          else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
              else     result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace :
        begin
          result := trNextStep;
          if ((Con.Pin = 1) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[1]) or
          ((Con.Pin = 1) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2]) or
          ((Con.Pin = 2) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
          ((Con.Pin = 2) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZav[jmp.Obj].ObjConstI[k];
              if o > 0 then
              begin
                case ObjZav[o].TypeObj of
                  8 :
                  begin // УТС
                    if ((not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                    (ObjZav[o].bParam[1] and ObjZav[o].bParam[2])) and not ObjZav[o].bParam[3] then
                    begin // Упор включен в зависимости и не имеет контроля положения
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                      InsMsg(Group,o,109); result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end
                    else
                    if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] and
                    not ObjZav[o].bParam[3] and (Rod = MarshP) then
                    begin //--- Упор установлен и включен в зависимости и поездной маршрут
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                      InsMsg(Group,o,108); result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end else
                    if not ObjZav[o].bParam[27] then
                    begin //------------------------- не зарегистрировано сообщение по УТС
                      if ObjZav[o].bParam[3] then
                      begin //------------------------------ Упор выключен из зависимостей
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,253, ObjZav[o].Liter,1);
                        InsWar(Group,o,253); result := trBreak;
                      end;
                      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
                      begin // Упор установлен
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                        InsWar(Group,o,108); result := trBreak;
                      end else
                      if (not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                      (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
                      begin //--------------------------- Упор не имеет контроля положения
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                        InsWar(Group,o,109);
                        result := trBreak;
                      end;
                    end;
                    if result = trBreak then ObjZav[o].bParam[27] := true;
                  end;

                  33 : begin // одиночный датчик
                    if ObjZav[o].bParam[1] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[o].ObjConstB[1] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]];
                        InsMsg(Group,o,3);
                      end else
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]];
                        InsMsg(Group,o,2);
                      end;
                      MarhTracert[Group].GonkaStrel := false;
                      result := trBreak;
                    end;
                  end;
                  // другие объекты зависимостей
                  else
                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc :
        begin
          result := trNextStep;
          if ((Con.Pin = 1) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[1]) or
          ((Con.Pin = 1) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2]) or
          ((Con.Pin = 2) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
          ((Con.Pin = 2) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZav[jmp.Obj].ObjConstI[k];
              if o > 0 then
              begin
                case ObjZav[o].TypeObj of
                  8 :
                  begin // УТС
                    if ((not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                    (ObjZav[o].bParam[1] and ObjZav[o].bParam[2])) and not ObjZav[o].bParam[3] then
                    begin // Упор включен в зависимости и не имеет контроля положения
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                      InsMsg(Group,o,109);
                    end else
                    if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] and
                    not ObjZav[o].bParam[3] and (Rod = MarshP) then
                    begin // Упор установлен и включен в зависимости и поездной маршрут
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                      InsMsg(Group,o,108);
                    end else
                    if not ObjZav[o].bParam[27] then
                    begin
                      p := false;
                      if ObjZav[o].bParam[3] then
                      begin // Упор выключен из зависимостей
                        p := true;
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,253, ObjZav[o].Liter,1);
                        InsWar(Group,o,253);
                      end;
                      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
                      begin // Упор установлен
                        p := true;
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[o].Liter,1);
                        InsWar(Group,o,108);
                      end else
                      if (not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                      (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
                      begin // Упор не имеет контроля положения
                        p := true;
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,109, ObjZav[o].Liter,1);
                        InsWar(Group,o,109);
                      end;
                      if p then ObjZav[o].bParam[27] := true;
                    end;
                  end;

                  33 : begin // одиночный датчик
                    if ObjZav[o].bParam[1] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[o].ObjConstB[1] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]];
                        InsMsg(Group,o,3);
                      end
                      else
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]];
                        InsMsg(Group,o,2);
                      end;
                    end;
                  end;
                  // другие объекты зависимостей
                else

                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        else
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
            else     result := trNextStep;
          end;
        end
        else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
            else     result := trNextStep;
          end;
        end;
      end;
    end;
//========================================================================================
function StepTracePoezdSogl(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------------------------------- Выдача поездного согласия (30)
var
  sig_uvaz,uch_uvaz,start_tras : integer;
begin
  start_tras := MarhTracert[Group].ObjStart;
  sig_uvaz := ObjZav[jmp.Obj].BaseObject;
  uch_uvaz := ObjZav[jmp.Obj].UpdateObject;
  case Lvl of
    tlFindTrace :
    begin
      if ObjZav[Con.Obj].RU = ObjZav[start_tras].RU then
      begin //-------------------------- Продолжить трассировку если свой район управления
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
            else result := trNextStep;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
            else result := trNextStep;
          end;
        end;
      end
      else result := trRepeat;
    end;

    tlContTrace :
    begin
      if ObjZav[Con.Obj].RU = ObjZav[start_tras].RU then
      begin //-------------------------- Продолжить трассировку если свой район управления
        result := trNextStep;
        if Con.Pin = 1 then
        begin
          Con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
          end;
        end else
        begin
          Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
          end;
        end;
      end
      else result := trEndTrace; //Завершить трассировку маршрута, другой район управления
    end;

    tlVZavTrace :
    begin
      result := trNextStep;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if jmp.Obj = MarhTracert[Group].ObjLast then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin //-------------------------------------------------- нажата кнопка ЭГС
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,105, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,105);//- "Нажата кнопка экстренного гашения сигнала"
                result := trBreak;
              end;

              if not ObjZav[sig_uvaz].bParam[4] then
              begin //--------------------------------------------- нет поездного согласия
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,246, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,246);  //----------- "Нет согласия поездного приема"
                result := trBreak;
              end;
            end;
          end;
        end;
      end;

      if jmp.Obj <> MarhTracert[Group].ObjLast then
      begin
        if uch_uvaz > 0 then
        begin //------------------------------------ проверить враждебности участка увязки
          if not ObjZav[uch_uvaz].bParam[2] or not ObjZav[uch_uvaz].bParam[3] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[uch_uvaz].Liter,1);
            InsMsg(Group,uch_uvaz,113); //-------- "На путь установлен враждебный маршрут"
            result := trBreak;
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;

      MarhTracert[Group].TailMsg := ' до '+ ObjZav[ObjZav[jmp.Obj].BaseObject].Liter;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlSignalCirc :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] <>
          ObjZav[jmp.Obj].BaseObject then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin //-------------------------------------------------- нажата кнопка ЭГС
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,105, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,105);
              end;

              if not ObjZav[sig_uvaz].bParam[4] then
              begin //--------------------------------------------- нет поездного согласия
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,246, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,246);
              end;
            end;
          end;
        end;
      end;

      if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] = sig_uvaz  then
      begin
        if uch_uvaz > 0 then
        begin //------------------------------------ проверить враждебности участка увязки
          if ObjZav[uch_uvaz].bParam[2] and ObjZav[uch_uvaz].bParam[3] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,163, ObjZav[uch_uvaz].Liter,1);
            InsMsg(Group,uch_uvaz,163);
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      result := trNextStep;
      case Rod of
        MarshP :
        begin
          if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] <>  sig_uvaz then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin //-------------------------------------------------- нажата кнопка ЭГС
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,105, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,105);
              end;

              if not ObjZav[sig_uvaz].bParam[4] then
              begin //--------------------------------------------- нет поездного согласия
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,246, ObjZav[sig_uvaz].Liter,1);
                InsMsg(Group,sig_uvaz,246);
              end;
            end;
          end;
        end;
      end;

      if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] = sig_uvaz then
      begin
        if uch_uvaz  > 0 then
        begin //------------------------------------ проверить враждебности участка увязки
          if not ObjZav[uch_uvaz].bParam[2] or not ObjZav[uch_uvaz].bParam[3] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[uch_uvaz].Liter,1);
            InsMsg(Group,uch_uvaz,113);
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlZamykTrace :
    begin
      MarhTracert[Group].TailMsg := ' до '+ ObjZav[sig_uvaz].Liter;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNextStep;
        end;
      end;
    end;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepTraceUvazGor(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------------------- Увязка с горкой (надвиг) (32)
var
  o : integer;
begin
      case Lvl of
        tlFindTrace : begin
          result := trRepeat;
        end;

        tlPovtorMarh,
        tlContTrace :
        begin
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlVZavTrace : begin
          result := trStop;
        end;

        tlCheckTrace : begin
          result := trBreak;
          MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;
          if ObjZav[jmp.Obj].bParam[10] then
          begin // уже есть маршрут надвига на горку
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,355, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,355); MarhTracert[Group].GonkaStrel := false; exit;
          end;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter,1); InsMsg(Group,MarhTracert[Group].ObjStart,106); MarhTracert[Group].GonkaStrel := false; exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // блокировка кнопки горочного светофора
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,123); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ГП
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,83); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ЭГС
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,105); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // нет согласия надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,103); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                 not (ObjZav[ObjZav[o].BaseObject].bParam[2] and ObjZav[ObjZav[o].BaseObject].bParam[3]) then
              begin // установлен поездной маршрут на путь надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); MarhTracert[Group].GonkaStrel := false; exit;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // нет согласия маневров
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,104); MarhTracert[Group].GonkaStrel := false; exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign :
        begin
          result := trStop;
          if ObjZav[jmp.Obj].bParam[10] then
          begin // уже есть маршрут надвига на горку
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,355, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,355); exit;
          end;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter,1); InsMsg(Group,MarhTracert[Group].ObjStart,106); exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // блокировка кнопки горочного светофора
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,123); exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ГП
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,83); exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ЭГС
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,105); exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // нет согласия надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,103); exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if Con.Pin = 1 then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[2] then
                begin // установлен четный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end else
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // установлен нечетный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // нет согласия маневров
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,104); exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlSignalCirc :
        begin
          result := trStop;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter,1); InsMsg(Group,MarhTracert[Group].ObjStart,106); exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // блокировка кнопки горочного светофора
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,123); exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ГП
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,83); exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ЭГС
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,105); exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // нет согласия надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,103); exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if Con.Pin = 1 then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[2] then
                begin // установлен четный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end else
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // установлен нечетный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter,1); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // нет согласия маневров
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,104); exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlFindIzvest : begin
          if ObjZav[jmp.Obj].bParam[11] then
          begin // Занято приближение
            result := trBreak;
          end else
            result := trStop;
        end;

        tlFindIzvStrel : result := trStop;

        else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceMarNadvig(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//-------------------------------------------------------- Контроль маршрута надвига  (38)
begin
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          MarhTracert[Group].PutNadviga := jmp.Obj; // сохранить индекс объекта согласия надвига с пути
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc : begin
          MarhTracert[Group].PutNadviga := jmp.Obj; // сохранить индекс объекта согласия надвига с пути
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceMarshOtpr(var Con : TOZNeighbour;
const Lvl : TTracertLevel; Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------------------------- Контроль маршрута отправления (41)
var
  k,o,hvost,s_v_put : integer;
begin
  result := trNextStep;
  s_v_put := jmp.Obj;
  case Lvl of
    tlFindTrace : //--------------------------------------------------------- поиск трассы
    begin
      result := trNextStep;
      if Con.Pin = 1 then Con := ObjZav[s_v_put].Neighbour[2]
      else Con := ObjZav[s_v_put].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlPovtorMarh,
    tlContTrace,
    tlVZavTrace,
    tlFindIzvest,
    tlFindIzvStrel :
    begin
      result := trNextStep;
      if Con.Pin = 1 then  Con := ObjZav[s_v_put].Neighbour[2]
      else  Con := ObjZav[s_v_put].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNextStep;

      if Con.Pin = 1 then //--------------------- вход в объект со  стороны тчк 1 (нечетн)
      begin
        Con := ObjZav[s_v_put].Neighbour[2];
        if (Rod = MarshP) and ObjZav[s_v_put].ObjConstB[1] then //поездной и проверять неч
        begin
          ObjZav[s_v_put].bParam[21] := true; //-------- трассировка поездного отправления
          for k := 1 to 4 do //----------------------- пройти по возможным стрелкам в пути
          begin
            o := ObjZav[s_v_put].ObjConstI[k]; //------------- взять индекс стрелки в пути
            if o > 0 then
            begin
              hvost := ObjZav[o].BaseObject;

              if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
              begin //------------------------- стрелка в пути не имеет контроля положения
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,81, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,81);//----------- Стрелка $ не имеет контроля положения
                MarhTracert[Group].GonkaStrel := false;
                exit;
              end else
              if (ObjZav[hvost].bParam[4] or //------ если у стрелки доп.замыкание или ...
              ObjZav[hvost].bParam[14]) and //----------------- программное замыкание и...
              ObjZav[hvost].bParam[21] then //------------------------ нет замыкания из СП
              begin //--------------------------- охранная стрелка трассируется в маршруте
                if (ObjZav[s_v_put].ObjConstB[k*3+1] and //охранность по "-" стрелки и ...
                ObjZav[hvost].bParam[6]) or //-------------------- есть признак ПУ или ...
                (ObjZav[s_v_put].ObjConstB[k*3] and //---- охранность по "+" стрелки и ...
                ObjZav[hvost].bParam[7]) then //-------------------------- есть признак МУ
                begin //------------------------ трассировка в разрез маршрута отправления
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[hvost].Liter,1); //----------- Стрелка $ замкнута
                  InsMsg(Group,hvost,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if (not ObjZav[o].bParam[1] or ObjZav[o].bParam[2]) and //- не в плюсе и ...
              (not ObjZav[hvost].bParam[21]) and (Rod = MarshP) then //-- стрелка замкнута
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,80, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,80);//----------- Стрелка $ не имеет контроля положения
                MarhTracert[Group].GonkaStrel := false;
                exit;
              end;

              if ObjZav[s_v_put].ObjConstB[k*3+2] then // если предусмотрена гонка стрелки
              begin
                if ObjZav[s_v_put].ObjConstB[k*3] and //---------- охранность по "+" и ...
                not ObjZav[o].bParam[1] then  //----------------------- стрелка не в плюсе
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then //--- нет индекса сигнала ...
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZav[hvost].bParam[21] then //-если охранная стрелка замкнута
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117); //-------------- Стрелочная секция замкнута
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then //------- охранная стрелка занята
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118); //--------------- Стрелочная секция занята
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or   //-------- если стрелка на макети или
                    ObjZav[hvost].bParam[19] then   //-------------------- на общем макете
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,136, ObjZav[hvost].Liter,1);//----- Стрелка $ на макете.
                      InsMsg(Group,hvost,136);//Перед маршрутом должна быть переведена в +
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then //------------ охранная стрелка выключена
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,121);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZav[hvost].bParam[21] and //----- если нет замыкания из СП и ...
                    ObjZav[hvost].bParam[22] then  //----------------- нет занятости из СП
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZav[hvost].bParam[15] or //------------- стрелка на макете или
                      ObjZav[hvost].bParam[19] then //-------------------- на общем макете
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,136); //"стрелка на макете, сначала установи +"
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,121); //------- стрелка выключена из управления
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or
                      ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,136); //----- стрелка на макете, сначала в плюс
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and
                not ObjZav[o].bParam[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZav[hvost].bParam[21] then
                    begin //------------------------------------ охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117); //---------------------- секция СП замкнута
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then
                    begin //-------------------------------------- охранная стрелка занята
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or
                    ObjZav[hvost].bParam[19] then
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,137);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then
                    begin //----------------------------------- охранная стрелка выключена
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,159);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZav[hvost].bParam[21] and
                    ObjZav[hvost].bParam[22] then
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZav[hvost].bParam[15] or
                      ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,159);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;
              end else
              begin //--------------------- маршрутная гонка стрелки в пути не выполняется
                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //- нет сигн.прикр. для стрелки в пути или нет занятости,замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[o].Liter,1);
                    InsMsg(Group,hvost,268);
                    MarhTracert[Group].GonkaStrel := false;
                    exit;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //-- нет сигн.прикр.для стрелки в пути или нет занятости,замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267, ObjZav[o].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,267);
                    MarhTracert[Group].GonkaStrel := false;
                    exit;
                  end;
                end;
              end;
            end;
          end;
        end
        else ObjZav[s_v_put].bParam[21] := false;
      end else
      begin
        Con := ObjZav[s_v_put].Neighbour[1];

        if (Rod = MarshP) and ObjZav[s_v_put].ObjConstB[2] then
        begin
          ObjZav[s_v_put].bParam[21] := true;
          for k := 1 to 4 do
          begin
            o := ObjZav[s_v_put].ObjConstI[k];
            if o > 0 then
            begin
              hvost := ObjZav[o].BaseObject;
              if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
              begin //------------------------- стрелка в пути не имеет контроля положения
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,81, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,81);
                MarhTracert[Group].GonkaStrel := false; exit;
              end else

              if (ObjZav[hvost].bParam[4] or ObjZav[hvost].bParam[14]) and
              ObjZav[hvost].bParam[21] then
              begin //--------------------------- охранная стрелка трассируется в маршруте
                if (ObjZav[s_v_put].ObjConstB[k*3+1] and ObjZav[hvost].bParam[6]) or
                (ObjZav[s_v_put].ObjConstB[k*3] and ObjZav[hvost].bParam[7]) then
                begin //------------------------ трассировка в разрез маршрута отправления
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,80, ObjZav[hvost].Liter,1);
                  InsMsg(Group,hvost,80);
                  result := trBreak;
                  MarhTracert[Group].GonkaStrel := false;
                end;
              end;

              if (not ObjZav[o].bParam[1] or ObjZav[o].bParam[2]) and //- не в плюсе и ...
              (not ObjZav[hvost].bParam[21]) and (Rod = MarshP) then //-- стрелка замкнута
              begin
                inc(MarhTracert[Group].MsgCount);
                MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                GetShortMsg(1,80, ObjZav[hvost].Liter,1);
                InsMsg(Group,hvost,80);//------------------------------ Стрелка $ замкнута
                MarhTracert[Group].GonkaStrel := false;
                exit;
              end;

              if ObjZav[s_v_put].ObjConstB[k*3+2] then
              begin //------------------------ маршрутная гонка стрелки в пути выполняется
                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZav[hvost].bParam[21] then
                    begin //------------------------------------ охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then
                    begin //-------------------------------------- охранная стрелка занята
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,136);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then
                    begin //----------------------------------- охранная стрелка выключена
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,121);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22] then
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,136);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,121, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,121);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,136, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,136);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZav[ObjZav[o].BaseObject].bParam[21] then
                    begin //------------------------------------ охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,117, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,117);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if not ObjZav[hvost].bParam[22] then
                    begin //-------------------------------------- охранная стрелка занята
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,118, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,118);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,137);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;

                    if ObjZav[o].bParam[18] then
                    begin //----------------------------------- охранная стрелка выключена
                      inc(MarhTracert[Group].MsgCount);
                      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                      GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                      InsMsg(Group,hvost,159);
                      result := trBreak;
                      MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22] then
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;

                      if ObjZav[o].bParam[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTracert[Group].MsgCount);
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,159, ObjZav[hvost].Liter,1);
                        InsMsg(Group,hvost,159);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZav[hvost].bParam[15] or ObjZav[hvost].bParam[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTracert[Group].WarCount);
                        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                        GetShortMsg(1,137, ObjZav[hvost].Liter,1);
                        InsWar(Group,hvost,137);
                        result := trBreak;
                        MarhTracert[Group].GonkaStrel := false;
                      end;
                    end;
                  end;
                end;
              end else
              begin //--------------------- маршрутная гонка стрелки в пути не выполняется
                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //- нет сигн.прикр. для стрелки в пути или нет занятости,замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[o].Liter,1);
                    InsMsg(Group,hvost,268);
                    MarhTracert[Group].GonkaStrel := false; exit;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if (ObjZav[s_v_put].ObjConstI[k+4] = 0) or
                  (ObjZav[hvost].bParam[21] and ObjZav[hvost].bParam[22]) then
                  begin //- нет сигн.прикр. для стрелки в пути или нет занятости,замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,267, ObjZav[o].Liter,1);
                    InsMsg(Group,hvost,267);
                    MarhTracert[Group].GonkaStrel := false; exit;
                  end;
                end;
              end;
            end;
          end;
        end
        else ObjZav[s_v_put].bParam[21] := false;
      end;

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
      end;
    end;

    //----------------------- компьютерное замыкание трассы маршрута ---------------------
    tlZamykTrace :
    begin
      ObjZav[s_v_put].bParam[21] := false;//---- признак трассировки поездного отправления

      if Con.Pin = 1 then
      begin
        Con := ObjZav[s_v_put].Neighbour[2];

        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if ObjZav[s_v_put].ObjConstB[1] then //--------------------- если проверять 1->2
        begin
          if Rod = MarshP then ObjZav[s_v_put].bParam[20] := true //поездное отправление
          else ObjZav[s_v_put].bParam[20] := false;
        end;
      end else
      if Con.Pin = 2 then
      begin
        Con := ObjZav[s_v_put].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if ObjZav[s_v_put].ObjConstB[2] then //--------------------- если проверять 2->1
        begin
          if Rod = MarshP then ObjZav[s_v_put].bParam[20] := true //поездное отправление
          else ObjZav[s_v_put].bParam[20] := false;
        end;
      end
      else  ObjZav[s_v_put].bParam[20] := false; //------------ другие точки недопустимы
    end;

    tlAutoTrace,
    tlSignalCirc,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      result := trNextStep;
      if Con.Pin = 1 then
      begin
        if ObjZav[s_v_put].ObjConstB[1] then
        begin
          if Rod = MarshP then
          begin
            ObjZav[s_v_put].bParam[20] := true;
            ObjZav[s_v_put].bParam[21] := true;
            for k := 1 to 4 do
            begin
              o := ObjZav[s_v_put].ObjConstI[k];
              if o > 0 then
              begin
                if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                begin //----------------------- стрелка в пути не имеет контроля положения
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[o].BaseObject,81);
                end;

                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //неиспр.сигнал прикрытия стрелки в пути при замыкания выходной СП
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin //-------------------------------- неисправен сигнал прикрытия
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else //------------------------------------- неисправен светофор
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //-- неиспр.сигнал прикрытия стр. в пути при замкнутой выходной СП
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else // неисправен светофор

                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end else
          begin
            ObjZav[s_v_put].bParam[20] := false;
            ObjZav[s_v_put].bParam[21] := false;
          end;
        end else
        begin
          ObjZav[s_v_put].bParam[20] := false;
          ObjZav[s_v_put].bParam[21] := false;
        end;

        if result = trNextStep then
        begin
          Con := ObjZav[s_v_put].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end else
      begin
        if ObjZav[s_v_put].ObjConstB[2] then
        begin
          if Rod = MarshP then
          begin
            ObjZav[s_v_put].bParam[20] := true;
            ObjZav[s_v_put].bParam[21] := true;
            for k := 1 to 4 do
            begin
              o := ObjZav[s_v_put].ObjConstI[k];
              if o > 0 then
              begin
                if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                begin //----------------------- стрелка в пути не имеет контроля положения
                  inc(MarhTracert[Group].MsgCount);
                  MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                  GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter,1);
                  InsMsg(Group,ObjZav[o].BaseObject,81);
                end;

                if ObjZav[s_v_put].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //-- неиспр.сигнал прикрытия стр в пути при замыкнутой выходной СП
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      //-------------------------------------- неисправен сигнал прикрытия
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else //------------------------------------- неисправен светофор
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZav[s_v_put].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZav[s_v_put].ObjConstI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else
                  if ObjZav[ObjZav[o].BaseObject].bParam[21] and
                  ObjZav[ObjZav[o].BaseObject].bParam[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                    GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter,1);
                    InsMsg(Group,ObjZav[o].BaseObject,268);
                  end else

                  if not ObjZav[ObjZav[s_v_put].UpdateObject].bParam[2] then
                  begin //-- неиспр.сигнал прикрытия стр. в пути при замкнутой выходной СП
                    if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[5] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].bParam[10] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,481, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],481);
                      end else // неисправен светофор
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
                        GetShortMsg(1,272, ObjZav[ObjZav[s_v_put].ObjConstI[k+4]].Liter,1);
                        InsMsg(Group,ObjZav[s_v_put].ObjConstI[k+4],272);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end else
          begin
            ObjZav[s_v_put].bParam[20] := false;
            ObjZav[s_v_put].bParam[21] := false;
          end;
        end else
        begin
          ObjZav[s_v_put].bParam[20] := false;
          ObjZav[s_v_put].bParam[21] := false;
        end;
        if result = trNextStep then
        begin
          Con := ObjZav[s_v_put].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end;
    end;

    tlOtmenaMarh :
    begin
      if ObjZav[s_v_put].bParam[5] then ObjZav[s_v_put].bParam[20] := false;
      ObjZav[s_v_put].bParam[21] := false;
      if Con.Pin = 1 then
      begin
        Con := ObjZav[s_v_put].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[s_v_put].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    else result := trNextStep;
   end;
end;
//========================================================================================
function StepTracePerezamStrInPut(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------ Контроль перезамыкания маршрутов приема для стрелки в пути (42)
var
  k,o : integer;
begin
  case Lvl of
    //----------------------------- П О И С К   Т Р А С С Ы ------------------------------
    tlFindTrace :
    begin
      result := trNextStep;
      //------------- при поиске трассы поездного маршрута сохранить объект стрелки в пути
      if Rod = MarshP then
      MarhTracert[Group].VP := jmp.Obj;

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlVZavTrace,   //--------- Проверка взаимозависимостей по трассе (охранности и прочее)
    tlContTrace :  //----- Довести трассу до предполагаемого конца или отклоняющей стрелки
    begin
      result := trNextStep;

      if Rod = MarshP then MarhTracert[Group].VP := jmp.Obj; //сохранить объект для поезда

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    //--------------------------- П Р О В Е Р К А   Т Р А С С Ы  -------------------------
    tlCheckTrace :
    begin
      if Rod = MarshP then
      begin
        for k := 1 to 4 do //--------------------- пройти по 4-м возможным стрелкам в пути
        begin
          o := ObjZav[jmp.Obj].ObjConstI[k];
          if o > 0 then
          begin //-------------------- проверить наличие трассировки по "-" стрелки в пути
            if ObjZav[o].bParam[13] then
            begin// завершить трассировку если была езда по "-" стрелки в пути
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,482, ObjZav[ObjZav[o].BaseObject].Liter,1);
              InsWar(Group,ObjZav[o].BaseObject,482);
              break;
            end;
          end;
        end;
      end;
      result := trNextStep;

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else  Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlPovtorMarh,
    tlFindIzvest,
    tlFindIzvStrel :
    begin
      result := trNextStep;

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlZamykTrace :
    begin
      result := trNextStep;
      if Rod = MarshP then ObjZav[jmp.Obj].bParam[1] := true; //- признак поездного приема

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlAutoTrace,
    tlSignalCirc,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      if Rod = MarshP then MarhTracert[Group].VP:= jmp.Obj;//хранить объект стрелки в пути
      result := trNextStep;

      if Rod = MarshP then ObjZav[jmp.Obj].bParam[1] := true; //- признак поездного приема

      if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
      else Con := ObjZav[jmp.Obj].Neighbour[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlOtmenaMarh :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end;
    end;

    else result := trNextStep;
  end;
end;
//========================================================================================
function StepTraceOPI(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------------------------- оПИ (43)
var
  j,k,o : integer;
  tr : boolean;
begin
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          tr := true;
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              o := ObjZav[jmp.Obj].BaseObject;
              if o > 0 then
              begin // протрассировать выезд на пути из маневрового района
                k := 2;
                o := ObjZav[jmp.Obj].Neighbour[k].Obj; k := ObjZav[jmp.Obj].Neighbour[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // стрелка
                      case k of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // стрелку можно поставить в отвод по минусу
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // стрелку можно поставить в отвод по плюсу
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // РПо
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then // нет отводящих стрелок по трассе до общей точки пучка
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end else
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              o := ObjZav[jmp.Obj].BaseObject;
              if o > 0 then
              begin // протрассировать выезд на пути из маневрового района
                k := 1;
                o := ObjZav[jmp.Obj].Neighbour[k].Obj; k := ObjZav[jmp.Obj].Neighbour[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // стрелка
                      case k of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // стрелку можно поставить в отвод по минусу
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // стрелку можно поставить в отвод по плюсу
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // РПо
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then // нет отводящих стрелок по трассе до общей точки пучка
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end else
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258);
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258);
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
//========================================================================================
function StepTraceZonaOpov(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------------------------------------- Зона оповещения (45)
begin
      case Lvl of
        tlFindTrace :
        begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;

        tlVZavTrace,
        tlFindIzvest,
        tlZamykTrace,
        tlOtmenaMarh,
        tlFindIzvStrel,
        tlPovtorMarh,
        tlContTrace :
        begin
          result := trNextStep;
          if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
          else Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlSetAuto,  
        tlSignalCirc,
        tlPovtorRazdel,
        tlRazdelSign,
        tlCheckTrace :
        begin
          result := trNextStep;
          if ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------- Включено оповещение монтеров
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,456, ObjZav[jmp.Obj].Liter,1); //-- $ оповещение монтеров включено
            InsWar(Group,jmp.Obj,456);
          end;
          if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
          else Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlAutoTrace :
        begin
          result := trNextStep;
          if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
          else Con := ObjZav[jmp.Obj].Neighbour[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        else result := trNextStep;
      end;
    end;
//========================================================================================
function StepTraceProchee(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------------- прочие объекты (транзит через себя без проверок)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end else
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNextStep;
        end;
      end;
    end;
    else
    if Con.Pin = 1 then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end else
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  Strelka : integer;
//---------------------------------------------------- проход по стрелке при поиске трассы
begin
  Strelka :=  jmp.Obj;
  result := trNextStep;
  case Con.Pin of //--------------- переключатель по точке входа через коннектор с соседом
    1 : //------------------------------------------------------------------ Против шерсти
    begin
      if ObjZav[Strelka].ObjConstB[1] then //--------------------------- если сбрасывающая
      begin //------------------------- Сбрасывающая стрелка трассируется только по минусу
        Con := ObjZav[Strelka].Neighbour[3]; //------------------ точка выхода - по минусу
        ObjZav[Strelka].bParam[10] := true; //--------------------- Пометить первый проход
        ObjZav[Strelka].bParam[11] := true; //--------------------- Пометить первый проход
      end
      else
      begin //------------------------------------------------------------ Ходовая стрелка
        if ObjZav[Strelka].ObjConstB[3] then //---------- если основные маршруты по минусу
        begin
          if not ObjZav[Strelka].bParam[10] then //---------- если не было первого прохода
          begin //----------------------------------------- Вначале идти по минусу стрелки
            Con := ObjZav[Strelka].Neighbour[3]; //----------- коннектор со стороны минуса
            ObjZav[Strelka].bParam[10] := true; //----------------- Пометить первый проход
            ObjZav[Strelka].bParam[11] := true; //----------------- Пометить первый проход
          end else
          begin //----------------------------- при втором проходе пройти по плюсу стрелки
            Con := ObjZav[Strelka].Neighbour[2]; //------ выйти на коннектор стороны плюса
            ObjZav[Strelka].bParam[11] := false; //---------------- Пометить второй проход
          end;
        end else//---------------------------------------- если основные маршруты по плюсу
        begin
          if ObjZav[Strelka].bParam[10] then //-------- если первый проход трассировки был
          begin //-------------------------------- то второй проход идти по минусу стрелки
            Con := ObjZav[Strelka].Neighbour[3];
            ObjZav[Strelka].bParam[11] := true; //-------------- Пометить вторичный проход
          end else
          begin //---------------------------------------- Вначале пройти по плюсу стрелки
            Con := ObjZav[Strelka].Neighbour[2];
            ObjZav[Strelka].bParam[10] := true; //-------------- Пометить первичный проход
          end;
        end;
      end;

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;

    2 ://--------------------------------------------------------------- По шерсти с плюса
    begin
      ObjZav[Strelka].bParam[12] := true; //------------ Пометить проход по шерсти с плюса
      Con := ObjZav[Strelka].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;

    3 ://-------------------------------------------------------------- По шерсти с минуса
    begin
      ObjZav[Strelka].bParam[13] := true; //----------- Пометить проход по шерсти с минуса
      Con := ObjZav[Strelka].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------------------- проход через стрелку при продлении трассы
var
  p : boolean;
  k : integer;
begin
  result := trNextStep;
  p := false;

  case Con.Pin of
    1 ://------------------------------------------------- противошерстный вход на стрелку
    begin
      if MarhTracert[Group].VP >0 then //--------- есть ВП для трассировки маршрута приема
      begin //-------------------------------------------- пройти по списку стрелок в пути
        //--- получить очередную стрелку в пути, если это она  и через неё проходит трасса
        for k := 1 to 4 do //---------------------------- может быть до 4-х стрелок в пути
        if(ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and //-- если эта стрелка
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then //-------- признак добора трассы
        begin //-------------------------------------------- трассировать стрелку по плюсу
          Con := ObjZav[jmp.Obj].Neighbour[2]; //------------- получить коннектор по плюсу
          ObjZav[jmp.Obj].bParam[10] := true;  //------------------ установить 1-ый проход
          ObjZav[jmp.Obj].bParam[11] := false; //----------------------- снять 2-ой проход
          ObjZav[jmp.Obj].bParam[12] := false; //---------------- снять пошерстная в плюсе
          ObjZav[jmp.Obj].bParam[13] := false; //--------------- снять пошерстная в минусе
          result := trNextStep;
          p := true;
          break;
        end;

        if not p then
        begin //----------------------- стрелка не описана в текущем списке стрелок в пути
          con := ObjZav[jmp.Obj].Neighbour[1]; //-------------- коннектор со стороны входа
          result := trBreak; //--------------------------------------- откатить от стрелки
        end;
      end else //------------------------------------------------------ нет стрелок в пути

      if ObjZav[jmp.Obj].ObjConstB[1] then //------------------- если сбрасывающая стрелка
      begin //------------------ сбрасывающая стрелка всегда трассируется только по минусу
        Con := ObjZav[jmp.Obj].Neighbour[3]; //---------------- берем коннектор за минусом
        ObjZav[jmp.Obj].bParam[10] := true; //------------- есть первый проход трассировки
        ObjZav[jmp.Obj].bParam[11] := true; //------------- есть второй проход трассировки
        ObjZav[jmp.Obj].bParam[12] := false; //--------------------- пошерстная не в плюсе
        ObjZav[jmp.Obj].bParam[13] := false; //-------------------- пошерстная не в минусе
        result := trNextStep;
      end else
      begin //------------------------------------------ нет стрелок в пути и сбрасывающих
        con := ObjZav[jmp.Obj].Neighbour[1]; //-------------------- коннектор перед входом
        result := trBreak; //----------------------------------------- откатить от стрелки
      end;
    end;

    2 :
    begin //---------------------------------- пошерстный проход по стрелке со стороны "+"
      ObjZav[jmp.Obj].bParam[12] := true; //------------ Пометить проход по шерсти с плюса
      Con := ObjZav[jmp.Obj].Neighbour[1]; //----------- коннектор со стороны входа на ось
      case Con.TypeJmp of  //--------------------------------------------- типы коннектора
        LnkRgn : result := trStop; //--------------------------- конечный коннектор района
        LnkEnd : result := trStop; //--------------------------- конечный коннектор строки
        else result := trNextStep;
      end;
    end;

    3 :
    begin //--------------------------------------------- пошерстный проход со стороны "-"
      ObjZav[jmp.Obj].bParam[13] := true; //----------- Пометить проход по шерсти с минуса
      Con := ObjZav[jmp.Obj].Neighbour[1];//------------ коннектор со стороны входа на ось
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else  result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------------- проход через стрелку при проверке зависимостей
var
  k : integer;
begin
  result := trNextStep;
  case Con.Pin of
    1 :
    begin //-------------------------противошерстный вход, проверить по мунусу стрелки
      if MarhTracert[Group].VP > 0 then //если есть стрелка в пути в поездном маршруте
      begin //--------------------------------------------- есть список стрелок в пути
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and//если стр.в пути
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then //признак добора трассы по +
        begin //------------------------------ проверить трассировку стрелки по минусу
          if ObjZav[jmp.Obj].bParam[10] and ObjZav[jmp.Obj].bParam[11]
          then exit;
        end;
      end;

      if ObjZav[jmp.Obj].bParam[10] and not ObjZav[jmp.Obj].bParam[11] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end else
      if ObjZav[jmp.Obj].bParam[10] and ObjZav[jmp.Obj].bParam[11] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[12]  then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[13] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------ шаг через стрелку при проверке враждебностей по трассе маршрута
var
  zak : boolean;
  o : integer;
begin
  result := trNextStep;
  //------------------ сначала проверить замыкание маршрута отправления со стрелкой в пути
  if not CheckOtpravlVP(jmp.Obj,Group) then result := trBreak;

  //------------------------------------ теперь проверить ограждение пути через Вз стрелки
  if not CheckOgrad(jmp.Obj,Group) then result := trBreak;

  if ObjZav[jmp.Obj].ObjConstB[6] then //------------------ если стрелка "дальняя" из пары
  zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16] //-------- признак закрытия для нее
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17]; //------ иначе признак отсюда

  if ObjZav[jmp.Obj].bParam[16] or zak then //----------- если по стрелке закрыто движение
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);  //------- Стрелка $ закрыта для движения
    InsMsg(Group,jmp.Obj,119);
    MarhTracert[Group].GonkaStrel := false;
  end;

  case Con.Pin of
    1 : //-------------------------------------------------- вход на стрелку через точку 1
    begin
      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin //-------------------------- стрелка не сбрасывающая или остряки не развернуты
        if ObjZav[jmp.Obj].ObjConstB[6] then    //------------------- если стрелка дальняя
        zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------------- стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);//---- Стрелка $ закрыта для противошерстного движения
          MarhTracert[Group].GonkaStrel := false;
        end;
      end;

      if (not MarhTracert[Group].Povtor and //------------ не повторное задание маршрута и
      (ObjZav[jmp.Obj].bParam[10] and //---------------------- первый проход трассировки и
      not ObjZav[jmp.Obj].bParam[11])) or //------------- не второй проход трассировки или

      (MarhTracert[Group].Povtor and  //--------------------- повторное задание маршрута и
      (ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and //---------------------- есть ПУ и
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7])) then//---- нет МУ (стр. идет в +)
      begin
        if not NegStrelki(jmp.Obj,true,Group)
        then result := trBreak;//------------------------------------------ негабаритность

        if ObjZav[jmp.Obj].bParam[1] then //--------------------------------- если есть ПК
        begin
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then //--------- если на макете
          begin //------------------------------ стрелка на макете - выдать предупреждение
            if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then //---- если сообщ. опер.
            begin //---------------------- Повторить предупреждение для лидирующей стрелки
              if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3]=jmp.Obj then //от макета
              begin
                result := trBreak;
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
                InsWar(Group,jmp.Obj,120); //------------------------- Стрелка $ на макете
              end;
            end else
            begin
              if not MarhTracert[Group].Dobor then
              begin
                ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj;
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
              end;
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);//--------- Стрелка $ на макете
            end;
          end;
        end else
        begin
          if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then
          inc(MarhTracert[Group].GonkaList);//-- увеличить счет переводимых стрелок трассы
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
          begin //--------------------------------------= стрелка на макете - враждебность
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,136, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,136);
            //Стрелка $ на макете. Перед установкой маршрута должна быть переведена в плюс

            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then //----замыкание секции
          begin
            o := GetStateSP(1,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,82, ObjZav[o].Liter,1);
            InsMsg(Group,o,82); //-------------------------------------  Участок $ замкнут
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//если надо проверять МСП и
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... идет выдержка МСП
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
            ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,392);// Идет выдержка времени дополнит. замыкания стрелки
            MarhTracert[Group].GonkaStrel := false;
          end;



          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then //------ замыкание в хвосте
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); //------------ Стрелка $ замкнута
            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then //------ занятие из СП
          begin
            o := GetStateSP(2,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[o].Liter,1);
            InsMsg(Group,o,83); //---------------------------------------- Участок $ занят
            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[jmp.Obj].bParam[18] then
          begin //---------------------------------------- стрелка выключена из управления
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,121, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            //-------------------- Стрелка $ выключена из управления (в маршруте по плюсу)
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,121);

            MarhTracert[Group].GonkaStrel := false;
          end;

          if MarhTracert[Group].Povtor then
          begin //---------------------------------- проверка повторной установки маршрута
            if not ObjZav[jmp.Obj].bParam[2] then //------------------------------- нет МК
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------ Стрелка $ без контроля
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- проверка первичной трассировки маршрута
            if not ObjZav[jmp.Obj].bParam[2] and  //----------------------------- нет МК и
            not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then  //-------------- нет ПУ
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------ Стрелка $ без контроля
              MarhTracert[Group].GonkaStrel := false;
            end;
          end;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end
        else  con := ObjZav[jmp.Obj].Neighbour[2];

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end else //-------------------------------------------------- стрелка не идет в плюс
      if (not MarhTracert[Group].Povtor and //------------------- не повтор маршрута и ...
      (ObjZav[jmp.Obj].bParam[10] and //------------------------------ первый проход и ...
      ObjZav[jmp.Obj].bParam[11])) or //---------------------------- второй проход или ...
      (MarhTracert[Group].Povtor and  //------------------------------------- повтор и ...
      (not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and  //-------------- нет ПУ и ...
      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7])) then //---------------------- есть МУ
      begin
        if  not NegStrelki(jmp.Obj,false,Group) then result := trBreak; //------ негабарит

        if ObjZav[jmp.Obj].bParam[2] then //-------------------------------------- если МК
        begin
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then //----- есть стр.на макете
          begin //------------------------------ стрелка на макете - выдать предупреждение
            if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then  //-------- сообщить ДСП
            begin //---------------------- Повторить предупреждение для лидирующей стрелки
              if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then //--- эта стр
              begin
                result := trBreak;
                inc(MarhTracert[Group].WarCount);
                MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
                GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
                InsWar(Group,ObjZav[jmp.Obj].BaseObject,120); //------ Стрелка $ на макете
              end;
            end else //---------------------------------------------- не надо сообщать ДСП
            begin
              if not MarhTracert[Group].Dobor then  //------------------- не нужен "добор"
              begin
                ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj; //----- запомнить
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true; //-----  есть макет
              end;
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
            end;
          end;
        end else //---------------------------------------------------------------- нет МК
        begin
          if not MarhTracert[Group].Povtor and //--------------- не повтрор маршрута и ...
          not MarhTracert[Group].Dobor //-------------------------------------- не "добор"
          then inc(MarhTracert[Group].GonkaList);//--- увеличить число переводимых стрелок

          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
          begin //--------------------------------------- стрелка на макете - враждебность
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,137, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,137);
            //Стрелка $ на макете.Перед установкой маршрута должна быть переведена в минус

            MarhTracert[Group].GonkaStrel := false;
          end;

          if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//если надо проверять МСП и
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... идет выдержка МСП
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
            ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,392);// Идет выдержка времени дополнит. замыкания стрелки
            MarhTracert[Group].GonkaStrel := false;
          end;

          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then //---- замыкание из СП
          begin
            o := GetStateSP(1,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,82, ObjZav[o].Liter,1); InsMsg(Group,o,82);//--- Участок $ замкнут
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] or ObjZav[jmp.Obj].bParam[4] then
          begin //---------------------------------------------------- дополнит. замыкание
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); //------------ Стрелка $ замкнута
            MarhTracert[Group].GonkaStrel := false;
          end else
          if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then //------- занятость СП
          begin
            o := GetStateSP(2,jmp.Obj);
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[o].Liter,1);
            InsMsg(Group,o,83); //---------------------------------------- Участок $ занят
            MarhTracert[Group].GonkaStrel := false;
          end else
          if ObjZav[jmp.Obj].bParam[18] then
          begin //---------------------------------------- стрелка выключена из управления
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,159, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);

            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,159);
            //------------------- Стрелка $ выключена из управления (в маршруте по минусу)

            MarhTracert[Group].GonkaStrel := false;
          end;

          if MarhTracert[Group].Povtor then
          begin //---------------------------------- проверка повторной установки маршрута
            if not ObjZav[jmp.Obj].bParam[1] then //------------------------------- нет ПК
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------ Стрелка $ без контроля
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- проверка первичной трассировки маршрута
            if not ObjZav[jmp.Obj].bParam[1] and  //------------------------------- нет ПК
            not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
            begin
              result := trBreak;
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
              MarhTracert[Group].GonkaStrel := false;
            end;
          end;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //------------------- есть ПУ
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);  //------------- Стрелка $ замкнута
          MarhTracert[Group].GonkaStrel := false;
        end;

        con := ObjZav[jmp.Obj].Neighbour[3]; //------------ выход из стрелки по отклонению
        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 : //------------------------------------------------ вход через прямую ветку стрелки
    begin
      if  not NegStrelki(jmp.Obj,true,Group) then result := trBreak; //--------- негабарит

      if ObjZav[jmp.Obj].bParam[1] then //----------------------------------- если есть ПК
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //-------------------------------- стрелка на макете - выдать предупреждение
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
          begin //------------------------ Повторить предупреждение для лидирующей стрелки
            if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
            begin
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
            end;
          end else
          begin
            if not MarhTracert[Group].Dobor then
            begin
              ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj;
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
            end;
            result := trBreak;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
          end;
        end;
      end else
      begin
        if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor
        then inc(MarhTracert[Group].GonkaList); //---- увеличить число переводимых стрелок

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //----------------------------------------- стрелка на макете - враждебность
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,136, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,136);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then  //----- замыкание из СП
        begin
          o := GetStateSP(1,jmp.Obj);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,82, ObjZav[o].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,82);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//если надо проверять МСП и
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... идет выдержка МСП
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,392);//-- Идет выдержка времени дополнит. замыкания стрелки
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then  //----------- доп. замыкание
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then  //-------- занятость СП
        begin
          o := GetStateSP(2,jmp.Obj);
          result := trBreak; inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[o].Liter,1); InsMsg(Group,o,83);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[jmp.Obj].bParam[18] then
        begin //------------------------------------------ стрелка выключена из управления
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,121, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,121);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if MarhTracert[Group].Povtor then
        begin //------------------------------------ проверка повторной установки маршрута
          if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- нет МК
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
            MarhTracert[Group].GonkaStrel := false;
          end;
        end else
        begin //---------------------------------- проверка первичной трассировки маршрута
          if not ObjZav[jmp.Obj].bParam[2] and
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;

      if (not MarhTracert[Group].Povtor and //---------------------------- не повтор и ...
      ObjZav[jmp.Obj].bParam[12]) or //----------------- активизирован автовозврат или ...

      (MarhTracert[Group].Povtor and //-------------------------------------- повтор и ...
      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and  //----------------------- ПУ и ...
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7]) then  //------------------ нет МУ
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then //-------------------- нет МУ
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); //-------------- Стрелка $ замкнута
          MarhTracert[Group].GonkaStrel := false;
        end else
        if not ObjZav[jmp.Obj].bParam[1] and //------------------------- если нет ПК и ...
        not ObjZav[jmp.Obj].bParam[2] and //--------------------------------- нет МК и ...
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //---------------- нет ПУ...
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);//----------- Стрелка $ без контроля
          MarhTracert[Group].GonkaStrel := false;
        end;

        con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- выход через вход (точку 1)

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 : //----------------------------------------------- вход на стрелку через отклонение
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then//----стрелка сбрасывающая и остряки развернуты
      begin
        if ObjZav[jmp.Obj].ObjConstB[6] //-------------------------------- стрелка дальняя
        //----------------------- тогда взять закрытие из FR4 ближней для противошерстного
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        //----------------------- иначе взять закрытие из FR4 дальней для противошерстного
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------------- стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);//------- Стрелка $ закрыта для противошерстного движ.
          MarhTracert[Group].GonkaStrel := false;
        end;
      end;

      if  not NegStrelki(jmp.Obj,false,Group)
      then result := trBreak; //------------------------------------------- негабаритность

      if ObjZav[jmp.Obj].bParam[2] then //----------------------------------- если есть МК
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //-------------------------------- стрелка на макете - выдать предупреждение
          if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
          begin //------------------------ Повторить предупреждение для лидирующей стрелки
            if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
            begin
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
              InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
            end;
          end else
          begin
            if not MarhTracert[Group].Dobor then
            begin
              ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj;
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
            end;
            result := trBreak;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);//----------- Стрелка $ на макете
          end;
        end;
      end else //------------------------------------------------------------- если нет МК
      begin
        if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor
        then inc(MarhTracert[Group].GonkaList);//------увеличить число переводимых стрелок

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
        begin //----------------------------------------- стрелка на макете - враждебность
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,137, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,137);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then //--------- замыкание СП
        begin
          o := GetStateSP(1,jmp.Obj);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,82, ObjZav[o].Liter,1);
          InsMsg(Group,o,82);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstB[3] and//если надо проверять МСП и
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[20] then //..... идет выдержка МСП
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,392, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,392); //- Идет выдержка времени дополнит. замыкания стрелки
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] or  ObjZav[jmp.Obj].bParam[4] then
        begin  //---------------------------------------------------------- доп. замыкание
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then //--------- занятость СП
        begin
          o := GetStateSP(2,jmp.Obj);
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[o].Liter,1);
          InsMsg(Group,o,83);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if ObjZav[jmp.Obj].bParam[18] then //------------- стрелка выключена из управления
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,159, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,159);
          MarhTracert[Group].GonkaStrel := false;
        end;

        if MarhTracert[Group].Povtor then //-------- проверка повторной установки маршрута
        begin
          if not ObjZav[jmp.Obj].bParam[1] then
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
            MarhTracert[Group].GonkaStrel := false;
          end;
        end else
        begin //---------------------------------- проверка первичной трассировки маршрута
          if not ObjZav[jmp.Obj].bParam[1] and //---------------------------- нет ПК и ...
          not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then //----------------- нет МУ
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //-------- Стрелка $ без контроля
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;

      if (not MarhTracert[Group].Povtor and //------------------- не повтор маршрута и ...
      ObjZav[jmp.Obj].bParam[13]) or //------------ пошерстная в маршруте в минусе или ...

      (MarhTracert[Group].Povtor and //----------------------------- повтор маршрута и ...
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and //------- нет ПУ в хвосте и ...
      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7]) then  //------------- есть МУ в хвосте
      begin
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //---------- если в хвосте ПУ
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80);
          MarhTracert[Group].GonkaStrel := false;
        end else  //------------------------------------------------- если в хвосте нет ПУ
        if not ObjZav[jmp.Obj].bParam[1] and  //----------------------------- нет ПК и ...
        not ObjZav[jmp.Obj].bParam[2] and  //-------------------------------- нет МК и ...
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then //---------- нет ПУ в хвосте
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); //------------ стрелка без контроля
          MarhTracert[Group].GonkaStrel := false;
        end;

        con := ObjZav[jmp.Obj].Neighbour[1]; //------------ выходим из стрелки через тчк 1

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelZamykTrassa(var Con : TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//--------------------------------пройти через стрелку во время замыкания элементов трассы
var
  p,mk : boolean;
begin
  result := trNextStep;
  case Con.Pin of
    1 :
    begin
      p := false; mk := false;
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
      begin //--------------------------------------------------------- нет замыкания и РМ
        if ObjZav[jmp.Obj].bParam[10] then
        begin
          if ObjZav[jmp.Obj].bParam[11] then
          begin //-------------------------------------------------- трассировка по минусу
            mk := true;
            p := false;
          end else
          begin //--------------------------------------------------- трассировка по плюсу
            p := true;
            mk := false;
          end;
        end;
      end else //--------------------------------------------------- есть замыкание или РМ
      begin
        if ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] then
        begin //--------------------------------------------------- есть контроль по плюсу
          p := true;
          mk := false;
        end else
        if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
        begin //-------------------------------------------------- есть контроль по минусу
          mk := true;
          p := false;
        end;
      end;

      if p and //--------------------------------------------------------- если плюс и ...
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then //--------------------- нет МУ
      begin
        con := ObjZav[jmp.Obj].Neighbour[2]; //------------------ выходим из стрелки прямо

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if result = trNextStep then
        begin
          if not ObjZav[jmp.Obj].ObjConstB[1] then //--------------------- не сбрасывающая
          begin
            inc(MarhTracert[Group].StrCount);
            MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount] := jmp.Obj;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := true;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := false;
          end;
          ObjZav[jmp.Obj].bParam[6] := true;   //-------------------------------------- ПУ
          ObjZav[jmp.Obj].bParam[7] := false;  //-------------------------------------- МУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := true;   //------------------- ПУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false;  //------------------- МУ
          ObjZav[jmp.Obj].bParam[10] := false; //---------------- не 1-ый проход по трассе
          ObjZav[jmp.Obj].bParam[11] := false; //---------------- не 2-ой проход по трассе
          ObjZav[jmp.Obj].bParam[12] := false; //--------- пошерстая не в плюсе по  трассе
          ObjZav[jmp.Obj].bParam[13] := false; //-------- пошерстная не в минусе по трассе
          ObjZav[jmp.Obj].bParam[14] := true;  //------------------------- прог. замыкание

          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;//-------- прог. замыкание
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;//-------- помни индекс
        end;
        exit;
      end else
      if mk and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;

        if result = trNextStep then
        begin
          if not ObjZav[jmp.Obj].ObjConstB[1] then
          begin
            inc(MarhTracert[Group].StrCount);
            MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount] := jmp.Obj;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := false;
            MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := true;
          end;
          ObjZav[jmp.Obj].bParam[6] := false;  //-------------------------------------- ПУ
          ObjZav[jmp.Obj].bParam[7] := true;   //-------------------------------------- МУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; //-------------------- ПУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := true;  //-------------------- МУ

          ObjZav[jmp.Obj].bParam[10] := false; //-------------- не первый проход по трассе
          ObjZav[jmp.Obj].bParam[11] := false; //-------------- не второй проход по трассе
          ObjZav[jmp.Obj].bParam[12] := false; //----------- сброс активности автовозврата
          ObjZav[jmp.Obj].bParam[13] := false; //--------------- сброс пошерстной в минусе
          ObjZav[jmp.Obj].bParam[14] := true;  //------------------ выдать прог. замыкание
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;  //------ прог. замыкание
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //------помнить начало
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :   //------------------------------------------------------ вход через прямую ветку
    begin
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and  //------- СП не замкнут и ...
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then  //------------------ нет РМ
      begin
        if ObjZav[jmp.Obj].bParam[12] //-------------- нет пошерстной трассировки по плюсу
        then result := trNextStep; //----------------------------------------- идти дальше
      end
      else //------------------------------------------------------- есть замыкание или РМ
      if ObjZav[jmp.Obj].bParam[1] and //----------------------------------- есть ПК и ...
      not ObjZav[jmp.Obj].bParam[2] //--------------------------------------------- нет МК
      then result := trNextStep;  //------------------------------------------ идти дальше

      if result = trNextStep then //------------------------------------- если идти дальше
      begin
        con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- выход через вход (точка 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZav[jmp.Obj].bParam[6] := true;   //------------------------------ нужен ПУ
            ObjZav[jmp.Obj].bParam[7] := false;  //--------------------------- не нужен МУ
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := true;  //------------------ ПУ
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; //------------------ МУ
            ObjZav[jmp.Obj].bParam[10] := false; //------------ не первый проход по трассе
            ObjZav[jmp.Obj].bParam[11] := false; //------------ не второй проход по трассе
            ObjZav[jmp.Obj].bParam[12] := false; //------- нет пошерстной в плюсе в трассе
            ObjZav[jmp.Obj].bParam[13] := false; //------ нет пошерстной в минусе в трассе
            ObjZav[jmp.Obj].bParam[14] := true;  //----------------------- прог. замыкание
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true; //----- прог. замыкание
            ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //--- помнить начало
        end;
      end;
    end;

    3 : //----------------------------------------------------- вход со стороны отклонения
    begin
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and //------нет замыкания СП и ...
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then //------------------- нет РМ
      begin
        if ObjZav[jmp.Obj].bParam[13] then  //------------------ пошерстная нужна в минусе
        result := trNextStep; //---------------------------------------------- идти дальше
      end
      else //------------------------------------------------------- есть замыкание или РМ
      if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then//нет ПК, есть МК
      result := trNextStep;  //--------------------------- стрелка по минусу - идти дальше

      if result = trNextStep then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- выход через вход (точка 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZav[jmp.Obj].bParam[6] := false; //---------------------------- не нужен ПУ
            ObjZav[jmp.Obj].bParam[7] := true;  //------------------------------- МУ нужен
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; //------------------ ПУ
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := true;  //------------------ МУ
            ObjZav[jmp.Obj].bParam[10] := false; //------------ не первый проход по трассе
            ObjZav[jmp.Obj].bParam[11] := false; //------------ не второй проход по трассе
            ObjZav[jmp.Obj].bParam[12] := false; //------- нет пошерстной в плюсе в трассе
            ObjZav[jmp.Obj].bParam[13] := false; //------ нет пошерстной в минусе в трассе
            ObjZav[jmp.Obj].bParam[14] := true;  //----------------------- прог. замыкание
            ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;//------ прог. замыкание
            ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------- шаг через стрелку при проверке "сигнальной струны"
var
  k : integer;
  zak : boolean;
begin
  result := trNextStep;
  //------------------ Проверить замыкание маршрута отправления со стрелкой в пути
  if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;
  //----------------------------------- Проверить ограждение пути через Вз стрелки

  if not SignCircOgrad(jmp.Obj,Group) then result := trStop; //--- Ограждение пути

  if ObjZav[jmp.Obj].ObjConstB[6]
  then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin //------------------------------------------- стрелка закрыта для движения
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin //------------------------------------------------- нет контроля положения
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; //---------------------------------------- негабаритность

  case Con.Pin of
    1 :
    begin
      //------- проверить трассировку по мунусу стрелки в пути в поездном маршруте
      if MarhTracert[Group].VP > 0 then
      begin //----------------------------------------- есть список стрелок в пути
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
        begin // проверить трассировку стрелки по минусу
          if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
          begin
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,482, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,482);
          end;
        end;
      end;

      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin //-------------------- стрелка не сбрасывающая или остряки не развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------- стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin //-------------------------- стрелка на макете - выдать предупреждение
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      //---------------------------------------------- отклоняющая стрелка в плюсе
      if ObjZav[jmp.Obj].bParam[1] then con := ObjZav[jmp.Obj].Neighbour[2]
      else //------------------------------------------ отклоняющая стрелка в минусе
      if ObjZav[jmp.Obj].bParam[2] then con := ObjZav[jmp.Obj].Neighbour[3]
      else result := trStop; //------------------------------ нет контроля положения

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin //------------------------------------------ отклоняющая стрелка в плюсе
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin //-------------------------- стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin //----------------------------------------- отклоняющая стрелка в минусе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);//---- Стрелка $ не по маршруту
      end
      else result := trStop; //------------------------------ нет контроля положения
      Con := ObjZav[jmp.Obj].Neighbour[1];

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242); //Нет маршрутов по + стрелки $
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin //------------------------------ стрелка сбрасывающая и остряки развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //------------------------ стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453); //Стрелка $ закрыта для противошерстного движения
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin //-------------------------------------------- отклоняющая стрелка в плюсе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160); //----- Стрелка $ не по маршруту
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin //------------------------------------------- отклоняющая стрелка в минусе
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin //---------------------------- стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else result := trStop; //-------------------------------- нет контроля положения

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//---------------------------------- проход через стрелку при проверке для отмены маршрута
var
  o : integer;
begin
  result := trNextStep;
  case Con.Pin of
    1 :
    begin
      if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and
      not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
      begin //----------------------------------------------------- нет замыкания и РМ
        if ObjZav[jmp.Obj].bParam[6] then
        begin
          con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNextStep;
          end;
          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; //------------------------------------- ПУ
            ObjZav[jmp.Obj].bParam[7] := false; //------------------------------------- МУ
            o := 0;

            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0)
            and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
            o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
            o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin //--------------------- пороверить наличие гонки для спаренной стрелки
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
            end else
            begin //-------------------------------- сбросить гонку стрелок в объекте ХС
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
            end;

            ObjZav[jmp.Obj].bParam[10] := false; //--------------- трасса
            ObjZav[jmp.Obj].bParam[11] := false; // трасса
            ObjZav[jmp.Obj].bParam[12] := false; // трасса
            ObjZav[jmp.Obj].bParam[13] := false; // трасса
            ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end else
        if ObjZav[jmp.Obj].bParam[7] then
        begin
          con := ObjZav[jmp.Obj].Neighbour[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNextStep;
          end;

          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; // ПУ
            ObjZav[jmp.Obj].bParam[7] := false; // МУ
            o := 0;

            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
            then o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin // пороверить наличие гонки для спаренной стрелки
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
            end else
            begin // сбросить гонку стрелок в объекте ХС
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
            end;
            ObjZav[jmp.Obj].bParam[10] := false; // трасса
            ObjZav[jmp.Obj].bParam[11] := false; // трасса
            ObjZav[jmp.Obj].bParam[12] := false; // трасса
            ObjZav[jmp.Obj].bParam[13] := false; // трасса
            ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end
        else result := trStop;
      end else
      begin // Есть замыкание или РМ - пройти по имеющемуся положению стрелки
        if ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] then
        begin // пройти по плюсу стрелки
          con := ObjZav[jmp.Obj].Neighbour[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNextStep;
          end;

          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; // ПУ
            ObjZav[jmp.Obj].bParam[7] := false; // МУ
            o := 0;
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin // пороверить наличие гонки для спаренной стрелки
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
            end else
            begin // сбросить гонку стрелок в объекте ХС
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
            end;
            ObjZav[jmp.Obj].bParam[10] := false; // трасса
            ObjZav[jmp.Obj].bParam[11] := false; // трасса
            ObjZav[jmp.Obj].bParam[12] := false; // трасса
            ObjZav[jmp.Obj].bParam[13] := false; // трасса
            ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end else
        if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
        begin // пройти по минусу стрелки
          con := ObjZav[jmp.Obj].Neighbour[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNextStep;
          end;

          if result = trNextStep then
          begin
            ObjZav[jmp.Obj].bParam[6] := false; // ПУ
            ObjZav[jmp.Obj].bParam[7] := false; // МУ
            o := 0;

            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
            else
            if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
            (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
            then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

            if (o > 0) then
            begin // пороверить наличие гонки для спаренной стрелки
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
            end else
            begin // сбросить гонку стрелок в объекте ХС
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
              ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
            end;
            ObjZav[jmp.Obj].bParam[10] := false; // трасса
            ObjZav[jmp.Obj].bParam[11] := false; // трасса
            ObjZav[jmp.Obj].bParam[12] := false; // трасса
            ObjZav[jmp.Obj].bParam[13] := false; // трасса
            ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
            SetPrgZamykFromXStrelka(jmp.Obj);
            ObjZav[jmp.Obj].iParam[1]  := 0;
          end;
          exit;
        end
        else result := trStop; // стрелка не имеет контроля положения - дальше не ходить
      end;
    end;

    2 :
    begin
      con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else result := trNextStep;
      end;

      if result = trNextStep then
      begin
        ObjZav[jmp.Obj].bParam[6] := false; // ПУ
        ObjZav[jmp.Obj].bParam[7] := false; // МУ
        o := 0;

        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
        then o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
        else
        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
        then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

        if (o > 0) then
        begin // пороверить наличие гонки для спаренной стрелки
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
        end else
        begin // сбросить гонку стрелок в объекте ХС
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
        end;

        ObjZav[jmp.Obj].bParam[10] := false; // трасса
        ObjZav[jmp.Obj].bParam[11] := false; // трасса
        ObjZav[jmp.Obj].bParam[12] := false; // трасса
        ObjZav[jmp.Obj].bParam[13] := false; // трасса
        ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
        SetPrgZamykFromXStrelka(jmp.Obj);
        ObjZav[jmp.Obj].iParam[1]  := 0;
      end;
    end;

    3 :
    begin
      con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else result := trNextStep;
      end;

      if result = trNextStep then
      begin
        ObjZav[jmp.Obj].bParam[6] := false; // ПУ
        ObjZav[jmp.Obj].bParam[7] := false; // МУ
        o := 0;
        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj)
        then  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
        else
        if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and
        (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj)
        then o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];

        if (o > 0) then
        begin // пороверить наличие гонки для спаренной стрелки
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
        end else
        begin // сбросить гонку стрелок в объекте ХС
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
        end;

        ObjZav[jmp.Obj].bParam[10] := false; // трасса
        ObjZav[jmp.Obj].bParam[11] := false; // трасса
        ObjZav[jmp.Obj].bParam[12] := false; // трасса
        ObjZav[jmp.Obj].bParam[13] := false; // трасса
        ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
        SetPrgZamykFromXStrelka(jmp.Obj);
        ObjZav[jmp.Obj].iParam[1]  := 0;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------- проход через стрелку при раздельном открытии сигнала
var
  zak : boolean;
  k : integer;
begin
  result := trNextStep;
  // Проверить замыкание маршрута отправления со стрелкой в пути
  if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;

  // Проверить ограждение пути через Вз стрелки
  if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути

  if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin // стрелка закрыта для движения
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // нет контроля положения
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; // негабаритность

  case Con.Pin of
    1 :
    begin
      // проверить трассировку по мунусу стрелки в пути в поездном маршруте
      if MarhTracert[Group].VP > 0 then
      begin // есть список стрелок в пути
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
        begin // проверить трассировку стрелки по минусу
          if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,482, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,ObjZav[jmp.Obj].BaseObject,482);
          end;
        end;
      end;

      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin // стрелка не сбрасывающая или остряки не развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin // стрелка на макете - выдать предупреждение
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // отклоняющая стрелка в плюсе
        ObjZav[jmp.Obj].bParam[10] := true;
        ObjZav[jmp.Obj].bParam[11] := false;// +
        con := ObjZav[jmp.Obj].Neighbour[2];
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // отклоняющая стрелка в минусе
        ObjZav[jmp.Obj].bParam[10] := true;
        ObjZav[jmp.Obj].bParam[11] := true; // -
        con := ObjZav[jmp.Obj].Neighbour[3];
      end
      else  result := trStop; // нет контроля положения

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // стрелка в плюсе
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // стрелка в минусе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end
      else  result := trStop; // нет контроля положения

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then ObjZav[jmp.Obj].bParam[12] := true; // +

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin // стрелка сбрасывающая и остряки развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // стрелка в плюсе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // стрелка в минусе
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else result := trStop;// нет контроля положения

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then ObjZav[jmp.Obj].bParam[13] := true; // -
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------ проход через стрелку при открытии сигнала на автодействие
var
  zak : boolean;
begin
  result := trNextStep;
  //-------------------------- Проверить замыкание маршрута отправления со стрелкой в пути
  if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;

  // Проверить ограждение пути через Вз стрелки
  if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути

  if ObjZav[jmp.Obj].ObjConstB[6]
  then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin //--------------------------------------------------- стрелка закрыта для движения
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin //--------------------------------------------------------- нет контроля положения
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; //------------------------------------------------ негабаритность

  case Con.Pin of
    1 :
    begin
      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin //-------------------------- стрелка не сбрасывающая или остряки не развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin //---------------------------- стрелка закрыта для противошерстного движения
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin //---------------------------------- стрелка на макете - выдать предупреждение
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      if ObjZav[jmp.Obj].bParam[1]
      then con := ObjZav[jmp.Obj].Neighbour[2]  //------------ отклоняющая стрелка в плюсе
      else
      if ObjZav[jmp.Obj].bParam[2]
      then  con := ObjZav[jmp.Obj].Neighbour[3]//------------ отклоняющая стрелка в минусе
      else result := trStop; //------------------------------------ нет контроля положения

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // отклоняющая стрелка в плюсе
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // отклоняющая стрелка в минусе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end
      else result := trStop; // нет контроля положения

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin // стрелка сбрасывающая и остряки развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // отклоняющая стрелка в плюсе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // отклоняющая стрелка в минусе
        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else  result := trStop;// нет контроля положения

      Con := ObjZav[jmp.Obj].Neighbour[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelPovtorRazdel(var Con : TOZNeighbour;const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------------------------------- проверка для повторного открытия в раздельном режиме
var
  k : integer;
  zak : boolean;
begin
  result := trNextStep;
  if ObjZav[jmp.Obj].ObjConstB[6]
  then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16]
  else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];

  if ObjZav[jmp.Obj].bParam[16] or zak then
  begin // стрелка закрыта для движения
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,119, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,119);
  end;

  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // нет контроля положения
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
    InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
  end else
  if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group)
  then result := trStop; // негабаритность

  case Con.Pin of
    1 :
    begin
      // проверить трассировку по мунусу стрелки в пути в поездном маршруте
      if MarhTracert[Group].VP > 0 then
      begin // есть список стрелок в пути
        for k := 1 to 4 do
        if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
        ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
        begin // проверить трассировку стрелки по минусу
          if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,482, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,482);
          end;
        end;
      end;

      if not ObjZav[jmp.Obj].ObjConstB[11] then
      begin // стрелка не сбрасывающая или остряки не развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];

        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
      not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
      begin // стрелка на макете - выдать предупреждение
        ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // отклоняющая стрелка в плюсе
        if not ObjZav[jmp.Obj].bParam[6] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end else
        begin
          ObjZav[jmp.Obj].bParam[10] := true;
          ObjZav[jmp.Obj].bParam[11] := false;// +
          con := ObjZav[jmp.Obj].Neighbour[2];
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // отклоняющая стрелка в минусе
        if not ObjZav[jmp.Obj].bParam[7] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end else
        begin
          ObjZav[jmp.Obj].bParam[10] := true;
          ObjZav[jmp.Obj].bParam[11] := true; // -
                  con := ObjZav[jmp.Obj].Neighbour[3];
        end;
      end
      else result := trStop;// нет контроля положения

      // Проверить ограждение пути через Вз стрелки
      if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // отклоняющая стрелка в плюсе
        if not ObjZav[jmp.Obj].bParam[6] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // отклоняющая стрелка в минусе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end
      else  result := trStop; // нет контроля положения

      Con := ObjZav[jmp.Obj].Neighbour[1];
      // Проверить ограждение пути через Вз стрелки
      if not SignCircOgrad(jmp.Obj,Group)
      then result := trStop; // Ограждение пути

      if result <> trStop then  ObjZav[jmp.Obj].bParam[12] := true; // +

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].ObjConstB[11] then
      begin // стрелка сбрасывающая и остряки развернуты
        if ObjZav[jmp.Obj].ObjConstB[6]
        then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33]
        else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
        if ObjZav[jmp.Obj].bParam[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,453, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,453);
        end;
      end;

      if ObjZav[jmp.Obj].bParam[1] then
      begin // отклоняющая стрелка в плюсе
        result := trStop;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
        InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // отклоняющая стрелка в минусе
        if not ObjZav[jmp.Obj].bParam[7] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
        end;

        if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and
        not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
        end;
      end
      else  result := trStop; // нет контроля положения

      Con := ObjZav[jmp.Obj].Neighbour[1];
      // Проверить ограждение пути через Вз стрелки
      if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути

      if result <> trStop then ObjZav[jmp.Obj].bParam[13] := true; // -

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter,1);
          InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepStrelFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//-------------------------------------------- проход через стрелку при сборке известителя
begin
  result := trNextStep;
  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // Если стрелка не имеет контроля положения - прервать сборку известителя
    result := trStop;
    exit;
  end;
  case Con.Pin of
    1 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // по плюсу
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
        exit;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // по минусу
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end
      else  result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1]  then
      begin // по плюсу
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else  result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[2] then
      begin // по минусу
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelFindIzvStrel(var Con : TOZNeighbour; const Lvl :TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------- проход через стрелку при проверке незамкнутых предмаршрутных стрелок
var
  zak : boolean;
  o,j,k : integer;
begin
  result := trNextStep;
  if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
  begin // Если стрелка не имеет контроля положения - прервать сборку известителя
    result := trStop;
    exit;
  end;

  o := ObjZav[jmp.Obj].BaseObject;
  zak := false;

  if Rod = MarshP then
  begin // проверить замыкание стрелки (в пути) в маршруте отправления с пути
    for j := 14 to 19 do
    begin
      if ObjZav[ObjZav[o].ObjConstI[j]].TypeObj = 41 then
      begin // контроль маршрута отправления с пути со стрелкой в пути
        if ObjZav[ObjZav[o].ObjConstI[j]].BaseObject = Marhtracert[Group].ObjStart then
        begin // стрелка замыкается в поездном маршруте как охранная
          zak := true;
          break;
        end;
      end;
    end;
  end;

  if not zak then
  begin // проверить исключение перевода стрелки
    k := ObjZav[jmp.Obj].UpdateObject;
    if not (ObjZav[ObjZav[o].ObjConstI[12]].bParam[1] or // РзС
    ObjZav[jmp.Obj].bParam[5] or     // признак перевода охранной
    not ObjZav[k].bParam[2] or       // замыкание из СП
    ObjZav[o].bParam[18] or          // выключена из управления FR4
    ObjZav[jmp.Obj].bParam[18]) then // выключена из управления РМ-ДСП
    Marhtracert[Group].IzvStrNZ := true;
  end;

  case Con.Pin of
    1 :
    begin
      if ObjZav[jmp.Obj].bParam[1] then
      begin // по плюсу
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end else
      if ObjZav[jmp.Obj].bParam[2] then
      begin // по минусу
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[1]  then
      begin // по плюсу
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[2] then
      begin // по минусу
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepStrelPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//------------------------------------ проход через стрелку при повторном задании маршрута
begin
  result := trNextStep;
  if not ObjZav[jmp.Obj].bParam[14] then
  begin //------------------------------------------------------ разрушена трасса маршрута
    if (MarhTracert[Group].MsgCount > 10) or (MarhTracert[Group].MsgCount = 0) then
    MarhTracert[Group].MsgCount := 1;
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    result := trStop;
    InsMsg(Group,MarhTracert[Group].ObjStart,228);
  end else
  case Con.Pin of
    1 :
    begin
      if ObjZav[jmp.Obj].bParam[6] and
      not ObjZav[jmp.Obj].bParam[7] then
      begin
        inc(MarhTracert[Group].StrCount);
        MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount]   := jmp.Obj;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := true;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := false;
        con := ObjZav[jmp.Obj].Neighbour[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNextStep;
        end;
      end else
      if not ObjZav[jmp.Obj].bParam[6] and ObjZav[jmp.Obj].bParam[7] then
      begin
        inc(MarhTracert[Group].StrCount);
        MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount]   := jmp.Obj;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := false;
        MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := true;
        con := ObjZav[jmp.Obj].Neighbour[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZav[jmp.Obj].bParam[6]  then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZav[jmp.Obj].bParam[7] then
      begin
        con := ObjZav[jmp.Obj].Neighbour[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNextStep;
        end;
      end
      else result := trStop;
    end;
  end;
end;
//========================================================================================
function StepSvetoforFindTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//----------------------------------------------------- шаг через сигнал при поиске трассы
begin
  if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
  begin //------------------------------ Продолжить трассировку если свой район управления
    if ObjZav[jmp.Obj].ObjConstB[1] then result := trRepeat //-----  конец трассировки
    else
    if Con.Pin = 1 then //------------------------ если вошли на сигнал со стороны точки 1
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2]; //------- выходной коннектор берется от точки 2
      case Con.TypeJmp of
        LnkRgn : result := trRepeat; //----------- наткнулись на конец района - откатиться
        LnkEnd : result := trRepeat; //----------- наткнулись на конец строки - откатиться
        else result := trNextStep;
      end;
    end else //-------------------------------------------------- вошли со стороны точки 2
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1]; //---------------- выходной коннектор в точке 1
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
        else result := trNextStep;
      end;
    end;
  end
  else result := trRepeat;
end;
//========================================================================================
function StepSvetoforContTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//---------------------------------------------------- продление трассы за указанный конец
var
  i,j,k : integer;
begin
  if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
  begin //------------------------------ Продолжить трассировку если свой район управления
    //----------------------------------- если нельзя дальше, смена направления Ч/Н, тупик
    if ObjZav[jmp.Obj].ObjConstB[1] then  result := trEndTrace
    else
    if Con.Pin = 1 then
    begin //-------------------------------------------------------------- Попутный сигнал
      if (((Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[7]) or//--- маневр и конец т.1 или
      ((Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[5])) and //--------- поезд и конец т.1
                                                                 //----------------- И ...
      (ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] or //--- блок STAN или DSP
      ObjZav[jmp.Obj].bParam[18] or //----------------------------------------  или РМ(МИ)
                                        //---------------------------------------  или ...
      (ObjZav[jmp.Obj].ObjConstB[2] and //----------------- возможно начало поездных и ...
      (ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4] or //----- С1 или С2 или ...
      ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9])) or //---- Н от STAN или ППР
                                            //------------------------------------ или ...
      (ObjZav[jmp.Obj].ObjConstB[3] and  //-------------- возможно начало маневровых и ...
      (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or //--- МС1 или МС2 или ...
      ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7]))) then //--- НМ STAN или МПР
      result := trEndTrace //------ Завершить трассировку если попутный впереди уже открыт
      else
      case Rod of
        MarshP : //----------------------------------------------------- ПОЕЗДНЫЕ ПОПУТНЫЕ
        begin
          if ObjZav[jmp.Obj].ObjConstB[16] and //------------ нет сквозных маршрутов и ...
          ObjZav[jmp.Obj].ObjConstB[2] then //------------------- возможно начало поездных
          result := trEndTrace //-------------------------------- обнаружен конец маршрута
          else
          if ObjZav[jmp.Obj].ObjConstB[5] then
          begin //----------- есть конец поездного маршрута в точке 1 светофора ( у входа)
            MarhTracert[Group].FullTail := true; //-------- полнота добора хвоста маршрута
            MarhTracert[Group].FindNext := true; //------ проверка возможности продолжения
            if ObjZav[jmp.Obj].ObjConstB[2] //------------------- возможно начало поездных
            then
            begin
              result := trEnd;     //------------------------- Конец трассировки фрагмента
              MarhTracert[Group].ObjEnd := jmp.Obj; // перенос конца поездного на попутный
            end
            else result := trEndTrace; //------------------------ обнаружен конец маршрута
          end
          else result := trNextStep; //----- нет конца поездного маршрута у светофора,идти
        end;

        MarshM : //--------------------------------------------------- МАНЕВРОВЫЕ ПОПУТНЫЕ
        begin
          if ObjZav[jmp.Obj].ObjConstB[7] then //----- есть конец маневровых в т.1 сигнала
          begin
            MarhTracert[Group].FullTail := true; //------------------------ полнота добора
            MarhTracert[Group].FindNext := true; //----- проверить возможность продолжения
            if ObjZav[jmp.Obj].ObjConstB[3] //----------------- возможно начало маневровых
            then
            begin
              result := trEnd;  //---------------------------- Конец трассировки фрагмента
              MarhTracert[Group].ObjEnd := jmp.Obj;
            end
            else result := trEndTrace;
          end
          else result := trNextStep; //---- нет конца маневровых в т.1 - шагать дальше
        end;

        else result := trEnd; //------ ошибочный тип маршрута - закончить поиск трассы
      end;

      if result = trNextStep then //-------------------------- если надо шагать дальше
      begin
        Con := ObjZav[jmp.Obj].Neighbour[2]; //- рассмотрим коннектор за сигналом (т2)
        case Con.TypeJmp of
          LnkRgn : result := trStop; //----------------------- конец района управления
          LnkEnd : result := trStop; //----------------------------- конец трассировки
        end;
      end;
    end else
    begin //------------------------ Встречный сигнал (вошли на сигнал со стороны т.2)
      case Rod of
        MarshP : //-------------------------- ВСТРЕЧНЫЕ сигналы при поездных -------------
        begin
          if ObjZav[jmp.Obj].ObjConstB[5] //---- Поездной конец есть в т.1 за сигналом
          then result := {trEndPlus} trNextStep //- есть конец маршрута, за сигналом надо проверить
          else //-------------------------------------- если поездного конца нет в т.1
          begin
            if ObjZav[jmp.Obj].Neighbour[1].TypeJmp = 0 then //------------ соседа нет
            result := trStop //-------------------- Отказ если нет поездного из тупика
            else result := trNextStep; //-------------------------------- иначе шагать
          end;
        end;

        MarshM : //------------------------- ВСТРЕЧНЫЕ СИГНАЛЫ при маневрах---------------
        begin
          if ObjZav[jmp.Obj].ObjConstB[8] //если маневры окончены перед сигналом то конец
          then
          begin
            result := trEndTrace;
            if jmp.Pin = 1  then jmp := ObjZav[jmp.Obj].Neighbour[2]
            else jmp := ObjZav[jmp.Obj].Neighbour[1];
          end
          else
            if ObjZav[jmp.Obj].ObjConstB[7]//если конец маневров в т.1 (за встречным сигн.)
            then result := trNextStep //----------------------------  то продолжаем дальше
            else
            begin
              j :=  MarhTracert[Group].Counter;
              for i := 0 to j do
              begin
                k := MarhTracert[Group].ObjTrace[j-1];
                if (ObjZav[k].TypeObj = 3) or (ObjZav[k].TypeObj = 4) then
                begin
                  MarhTracert[Group].ObjEnd := k;
                  break;
                end else
                begin
                  MarhTracert[Group].ObjTrace[j] := 0;
                  dec(MarhTracert[Group].Counter);
                end;
              end;
              result := trEnd; //------------------------------------------- иначе стоп
            end;

        end;

        else result := trEnd; //------------------ маршрут непонятный, не трассировать
      end;

      if result = trNextStep then //------------------------- если нужно шагать дальше
      begin
        Con := ObjZav[jmp.Obj].Neighbour[1]; //----- рассматривается коннектор точки 1
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          LnkFull : result := trNextStep;
          LnkNecentr : result := trEndTrace;
        end;
      end;

      if result = trEndPlus then  result := trEndTrace; //--- новая вставка @@@@@@@@@@@@

    end;
  end
  else result := trEndTrace;//Завершить трассировку маршрута если другой район управления
end;
//========================================================================================
function StepSvetoforZavTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//-------------------------------------------------------- проверка зависимостей по трассе
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trEndTrace;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trEndTrace;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSvetoforCheckTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//---------------------------------------------- проверка враждебностей по трассе маршрута
begin
  result := trNextStep;
  if (ObjZav[jmp.Obj].bParam[12] or  //--------------------- блокировка в STAN или ...
  ObjZav[jmp.Obj].bParam[13]) and //--------------------------- блокировка в DSP и ...
  (jmp.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]) // не последний
  then
  begin //------------------------------------ заблокирован светофор в середине трассы
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,123); //----------------------------- Светофор $ заблокирован
    MarhTracert[Group].GonkaStrel := false;
  end;

  if ObjZav[jmp.Obj].bParam[18] and //------------------------------- если РМ (или МИ)
  (jmp.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]) then //- внутри
  begin //--------------------------- светофор на местном управлении в середине трассы
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,232, ObjZav[jmp.Obj].Liter,1);//------- Сигнал $ на местном управлении
    InsMsg(Group,jmp.Obj,232);
    MarhTracert[Group].GonkaStrel := false;
  end;

  if Con.Pin = 1 then //-------------------------------------- вошли в попутный сигнал
  begin //----------------------------------------------------- Враждебности попутного
    if ((not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP)) or//нет П-конца в т1 или
    (not ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM))) and //нет М-конца в т1 и
    (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or  //---- МС1 или МС2 или
    ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then //--------- С1 или С2
    begin
      result := trBreak;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114);  //----------------------- Открыт враждебный сигнал $
      MarhTracert[Group].GonkaStrel := false;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTracert[Group].FindTail //----------- если создано сообщение о конце трассы
    then MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;
  end else
  begin //------- если вошли во встречный сигнал, то просмотр враждебностей встречного
    if ObjZav[jmp.Obj].bParam[1] or   //---------------------------------- МС1 или ...
    ObjZav[jmp.Obj].bParam[2] or   //------------------------------------- МС2 или ...
    ObjZav[jmp.Obj].bParam[3] or   //-------------------------------------- С1 или ...
    ObjZav[jmp.Obj].bParam[4] then //---------------------------------------------- С2
    begin
      result := trBreak;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114);  //----------------------- Открыт враждебный сигнал $
      MarhTracert[Group].GonkaStrel := false;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTracert[Group].FindTail then //----------------------- если найден хвост трассы
    begin
      if (ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 5) and (jmp.Pin = 1)
      then //---------------------------------------------- если конец на попутном сигнале
       MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter
      else
        if ObjZav[MarhTracert[Group].ObjEnd].ObjConstB[3] and (Rod = MarshM) then
        MarhTracert[Group].TailMsg := ' за '+ ObjZav[jmp.Obj].Liter
        else
        if ObjZav[MarhTracert[Group].ObjEnd].ObjConstB[2] and (Rod = MarshP) then
        MarhTracert[Group].TailMsg := ' за '+ ObjZav[jmp.Obj].Liter
        else
        begin
          result := trBreak;
        end;
//        MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;
    end;
  end;
end;
//========================================================================================
function StepSvetoforZamykTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//------------------- замыкание трассы маршрута, сбор положений отклоняющих стрелок трассы
begin
  if Con.Pin = 1 then  //--------------------------------------------- попутный сигнал
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      if MarhTracert[Group].FindTail //---------------------- если найден конец трассы
      then MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;

      //---------------------------------- разнести признаки начала в попутные сигналы
      if ObjZav[MarhTracert[Group].ObjStart].bParam[7] then //маневровый признак трасс
      begin
        if ObjZav[jmp.Obj].ObjConstB[3] then //---------------- есть маневровое начало
        begin
          MarhTracert[Group].SvetBrdr := jmp.Obj;//сменить индекс границы блок-участка
          ObjZav[jmp.Obj].bParam[7] := true;  //----------------------------------- НМ
          ObjZav[jmp.Obj].bParam[14] := true; //---------------------- прог. замыкание
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; // индекс маршрута
        end;
      end else

      if ObjZav[MarhTracert[Group].ObjStart].bParam[9] then //- поездной признак трасс
      begin
        if ObjZav[jmp.Obj].ObjConstB[2] then //------------------ есть поездное начало
        begin
          MarhTracert[Group].SvetBrdr := jmp.Obj;//сменить индекс границы блок-участка
          ObjZav[jmp.Obj].bParam[8] := true;  //------------------------------------ Н
          ObjZav[jmp.Obj].bParam[14] := true; //----------- установить прог. замыкание
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; // индекс маршрута
        end;
      end;
    end;
  end else //--------------------------------- вошли во встречный сигнал (от точки Т2)
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trEndTrace;
      else  result := trNextStep;
    end;

    if MarhTracert[Group].FindTail then
    begin
      if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 5 then //-- если конец на сигнале
      MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter
      else MarhTracert[Group].TailMsg := ' за '+ ObjZav[jmp.Obj].Liter;
    end;

    ObjZav[jmp.Obj].bParam[14] := true;  //--------------------------- прог. замыкание
    ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //------ индекс маршрута
  end;
end;
//========================================================================================
function StepSignalCirc(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//------------------------ Сигнальная струна (повторное открытие сигнала, отмена маршрута)
begin
  result := trNextStep;
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
  begin //------------------------------------------------------ заблокирован светофор
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,123);   //------------------------- Светофор $ заблокирован
    end;
  end else
  if ObjZav[jmp.Obj].bParam[18] then
  begin //--------------------------------------------- светофор на местном управлении
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,232, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,232); //-------------------- Сигнал $ на местном управлении
    end;
  end
  else result := trNextStep;

  if Con.Pin = 1 then
  begin //----------------------------------------------------- Враждебности попутного
    case Rod of
      MarshP :
      begin
        if ObjZav[jmp.Obj].ObjConstB[5] then //------------------------------- если С2
        begin
          if ObjZav[jmp.Obj].bParam[5] and //----------------------- огневое и нет ...
          not (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or// МС1 или МС2
          ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then //или С1 или С2
          begin //--------------------- Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115); //- Маршрут не огражден! Неисправен запрещающий
          end;
          result := trEndTrace;
        end;

        if ObjZav[jmp.Obj].ObjConstB[19] then
        begin //--------------- Короткий предмаршрутный участок для поездного маршрута
          if not ObjZav[jmp.Obj].bParam[4] then
          begin //------------------------------------------------------ закрыт сигнал
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391); //----------------------------- Сигнал $ закрыт
          end;
        end;
      end;

      MarshM :
      begin
        if ObjZav[jmp.Obj].ObjConstB[7] then   //- возможен маневровый конец в точке 1
        begin
          if ObjZav[jmp.Obj].bParam[5] and not //----------------------- огневое и нет
          (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or //МС1 или МС2 или
          ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then //--- С1 или С2
          begin //--------------------- Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115); //- Маршрут не огражден! Неисправен запрещающий
          end;
          result := trEndTrace;
        end;

        if ObjZav[jmp.Obj].ObjConstB[20] then
        begin //------------- Короткий предмаршрутный участок для маневрового маршрута
          if not ObjZav[jmp.Obj].bParam[2] then //---------------------------- нет МС2
          begin //------------------------------------------------------ закрыт сигнал
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391);
          end;
        end;
      end;

      else result := trEnd;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2]; //-------------- коннектор со стороны точки 2
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin //---------------------------------------- Враждебности встречного вошли в т.2
    if ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) //возможен конец поездных в т.2
    then result := trStop
    else
    if ObjZav[jmp.Obj].ObjConstB[8] and (Rod =MarshM)//возможен конец маневровых в т.2
    then result := trStop
    else
    if ObjZav[jmp.Obj].bParam[1] or   //------------------------------------------ МС1
    ObjZav[jmp.Obj].bParam[2] or   //--------------------------------------------- МС2
    ObjZav[jmp.Obj].bParam[3] or   //---------------------------------------------- С1
    ObjZav[jmp.Obj].bParam[4] then //---------------------------------------------- С2
    begin
      result := trStop;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114); //------------------------ Открыт враждебный сигнал $
    end;

    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepSigOtmenaMarh(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//-------------------------------------- Отмена маршрута, замкнутого Реле "З" или сервером
begin
  result := trNextStep;
  if Con.Pin = 1 then
  begin //------------------------------------------------------------ попутный сигнал
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn :
      begin
        ObjZav[jmp.Obj].bParam[14] := false;
        result := trEnd;
      end;

      LnkEnd :
      begin
        ObjZav[jmp.Obj].bParam[14] := false;
        result := trStop;
      end;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin     //----------------------- найти хвост данной категории маршрута
      if Rod = MarshM then
      begin // маневровый
        if ObjZav[jmp.Obj].ObjConstB[7] then result := trStop
        else ObjZav[jmp.Obj].bParam[14] := false;
      end else
      if Rod = MarshP then
      begin // поездной
        if ObjZav[jmp.Obj].ObjConstB[5] then result := trStop
        else ObjZav[jmp.Obj].bParam[14] := false;
      end;
    end;
  end else
  begin // встречный сигнал
    ObjZav[jmp.Obj].bParam[14] := false;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;      // найти хвост данной категории маршрута
      else   // найти хвост данной категории маршрута
      if Rod = MarshM then
      begin // маневровый
        if ObjZav[jmp.Obj].ObjConstB[8]
        then result := trStop
        else result := trNextStep;
      end else
      if Rod = MarshP then
      begin // поездной
        if ObjZav[jmp.Obj].ObjConstB[6]
        then result := trStop
        else result := trNextStep;
      end;
    end;
  end;
end;
//========================================================================================
function StepSigAutoPovtorRazdel(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//------------------ проход при автодействии, раздельном открытии или повторе в раздельном
begin
  result := trNextStep;
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
  begin // заблокирован светофор
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,123, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,123);
    end;
  end else
  if ObjZav[jmp.Obj].bParam[18] then
  begin // светофор на местном управлении
    if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,232, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,232);
    end;
  end
  else result := trNextStep;

  if Con.Pin = 1 then
  begin // Враждебности попутного
    case Rod of
      MarshP :
      begin
        if ObjZav[jmp.Obj].ObjConstB[5] then
        begin
          if ObjZav[jmp.Obj].bParam[5] and not
          (ObjZav[jmp.Obj].bParam[1] or
          ObjZav[jmp.Obj].bParam[2] or
          ObjZav[jmp.Obj].bParam[3] or
          ObjZav[jmp.Obj].bParam[4]) then // o
          begin // Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115);
          end;
          result := trEndTrace;
        end else
        begin
          if ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[21] then
          begin // открыт враждебный сигнал
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,114);
          end;
        end;

        if ObjZav[jmp.Obj].ObjConstB[19] then
        begin // Короткий предмаршрутный участок для поездного маршрута
          if not ObjZav[jmp.Obj].bParam[4] then
          begin // закрыт сигнал
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391);
          end;
        end;
      end;

      MarshM :
      begin
        if ObjZav[jmp.Obj].ObjConstB[7] then
        begin
          if ObjZav[jmp.Obj].bParam[5] and
          not (ObjZav[jmp.Obj].bParam[1] or
          ObjZav[jmp.Obj].bParam[2] or
          ObjZav[jmp.Obj].bParam[3] or
          ObjZav[jmp.Obj].bParam[4]) then // o
          begin // Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,115, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,115);
          end;
          result := trEndTrace;
        end else
        begin
          if ObjZav[jmp.Obj].bParam[3] or
          ObjZav[jmp.Obj].bParam[4] or
          ObjZav[jmp.Obj].bParam[8] or
          ObjZav[jmp.Obj].bParam[9] or
          ObjZav[jmp.Obj].bParam[21] then
          begin // открыт враждебный сигнал
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,114);
          end;
        end;

        if ObjZav[jmp.Obj].ObjConstB[20] then
        begin // Короткий предмаршрутный участок для маневрового маршрута
          if not ObjZav[jmp.Obj].bParam[2] then
          begin // закрыт сигнал
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,391, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,391);
          end;
        end;
      end;
      else result := trEnd;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
      end;
    end;
  end else
  begin // Враждебности встречного
    if ObjZav[jmp.Obj].bParam[1] or   // МС1
    ObjZav[jmp.Obj].bParam[2] or   // МС2
    ObjZav[jmp.Obj].bParam[3] or   // С1
    ObjZav[jmp.Obj].bParam[4] then // С2
    begin
      result := trStop;
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,114, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,114);
    end;

    case Rod of
      MarshP : if ObjZav[jmp.Obj].ObjConstB[6] then result := trEndTrace;
      MarshM : if ObjZav[jmp.Obj].ObjConstB[8] then result := trEndTrace;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          // Маршрут не существует
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          result := trEnd;
          InsMsg(Group,jmp.Obj,77);
        end;
      end;
    end;
  end;
end;
//========================================================================================
function StepSigFindIzvest(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//--------------------------------------------- проход через сигнал при поиске известителя
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else  result := trNextStep;
    end;
  end else
  begin //---------------------------------------- проверить условия для попутного сигнала
    if ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[4] then  //---- светофор открыт
    inc(MarhTracert[Group].IzvCount)
    else
    if ObjZav[jmp.Obj].bParam[6] or
    ObjZav[jmp.Obj].bParam[7] or
    ObjZav[jmp.Obj].bParam[1] then
    begin //---------- возбужден признак маневрового начала или сигнал на выдержке времени
      if not ObjZav[jmp.Obj].bParam[2] then
      begin //------------------------------------------------------------ светофор закрыт
        result := trStop;
        exit;
      end;
      inc(MarhTracert[Group].IzvCount);
    end else
    if ObjZav[jmp.Obj].bParam[8] or
    ObjZav[jmp.Obj].bParam[9] or
    ObjZav[jmp.Obj].bParam[3] then
    begin //------------ возбужден признак поездного начала или сигнал на выдержке времени
      if not ObjZav[jmp.Obj].bParam[4] then
      begin //------------------------------------------------------------ светофор закрыт
        result := trStop;
        exit;
      end;
      inc(MarhTracert[Group].IzvCount);
    end;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSigFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
//----------- проход через сигнал при поиске незамкнутых стрелок на предмаршрутном участке
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin // проверить условия для попутного сигнала
    if ((Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
    ((Rod = MarshP) and (ObjZav[jmp.Obj].ObjConstB[2] or ObjZav[jmp.Obj].bParam[2])) then
    begin // светофор ограничивает предмаршрутный участок
      result := trStop;
      exit;
    end
    else Con := ObjZav[jmp.Obj].Neighbour[1];

    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSigPovtorMarh(var Con :TOZNeighbour; const Lvl :TTracertLevel; Rod :Byte;
Group :Byte; jmp :TOZNeighbour) : TTracertResult;
//--------------------- Функция прохода через сигнал при команде повторной выдачи маршрута
//------------------------------------ Con - коннектор, с которого трасса пришла на сигнал
//----------------------------------------------------- Lvl - исполняемый этап трассировки
//------------------------------------------------------- Rod - вид трассируемого маршрута
//-------------------------------------------------------- Group - номер набираемой трассы
//------------------------------------- jmp - сосед, от которого трассы пришла на светофор
//--- ФУНКЦИЯ ВОЗВРАЩАЕТ РЕЗУЛЬТАТ ПРОХОЖДЕНИЯ ЧЕРЕЗ СИГНАЛ ИЗ ВОЗМОЖНОГО НАБОРА ВАРИАНТОВ
var
  old_con : TOZNeighbour;
begin
  result := trNextStep; //------------ изначально считается, что трасса должна идти дальше
  old_con := Con;
  //------------------------------------ проверяем наличие концов маршрутов перед сигналом
  if Con.Pin = 1 then //-------------- если вошли на сигнал в точке 1 (проверка попутного)
  begin
    case Rod of
      MarshP : //-------------------------------------------------- для поездного маршрута
        if ObjZav[jmp.Obj].ObjConstB[5] //------------- если в точке 1 есть конец поездных
        then result := trEndTrace; //---------------------- тогда результат = конец трассы
      MarshM : //------------------------------------------------ для маневрового маршрута
        if ObjZav[jmp.Obj].ObjConstB[7] //----------- если в точке 1 есть конец маневровых
        then result := trEndTrace; //---------------------- тогда результат = конец трассы
      else  result := trEnd;    //---------------- для нопределенных маршрутов сразу конец
    end;

    if result = trNextStep then //- если в точке 1 не было останова, и трасса продолжается
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2]; //- получить новый коннектор со стороны точки 2
      case Con.TypeJmp of
        LnkRgn : result := trStop; //----------------- если проход в другой район, то стоп
        LnkEnd : result := trStop; //---------------------- если коннектор тупика, то стоп
      end;
    end;
  end else //--------- если вошли на сигнал в точке 2 проверяем наличие концов за сигналом
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[5] or ObjZav[jmp.Obj].ObjConstB[6]
        then result := trEndTrace;//------------------------------ М конец в точке 1 или 2

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[7] or ObjZav[jmp.Obj].ObjConstB[8]
        then result := trEndTrace;//------------------------------ П конец в точке 1 или 2
    end;
  end;
  Con := old_con;
  if result = trNextStep then //---------------------------- если продолжается трассировка
  begin
    if Con.Pin = 1 then Con := ObjZav[jmp.Obj].Neighbour[2]
    else Con := ObjZav[jmp.Obj].Neighbour[1];

    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd :
      begin  //---------------------------------------------------- Маршрут не существует
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,77);
        result := trEnd;
      end;
    end;
  end;

end;
//========================================================================================
function StepSPforFindTrace(var Con:TOZNeighbour; const Lvl:TTracertLevel; Rod:Byte;
Group:Byte;jmp:TOZNeighbour):TTracertResult;
//--------------------------------------------- проход через СП при поиске трассы маршрута
begin
  if Con.Pin = 1 then  //------------------------------ вышли на секцию со стороны точки 1
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[1]   //---- если есть поездные в направлении 1->2
        then result := trNextStep
        else result := trRepeat;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[3]   //-- если есть маневровые в направлении 1->2
        then result := trNextStep
        else result := trRepeat;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[2]  //--------- если есть поездные в направлении 2->1
        then result := trNextStep
        else result := trRepeat;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4]   //------ если есть маневровые в направлении 2->1
        then result := trNextStep
        else result := trRepeat;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPforContTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[1]  //--------- если есть поездные в направлении 1->2
        then result := trNextStep
        else result := trStop;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[3] //-------- если есть маневровые в направлении 1->2
        then result := trNextStep
        else result := trEnd;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;
    if result = trEnd then  MarhTracert[Group].ObjLast := jmp.Obj;
  end else
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[2]then //-------если есть поездные в направлении 2->1
        result := trNextStep
        else result := trStop;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4]//--------- если есть маневровые в направлении 2->1
        then result := trNextStep
        else result := trEnd;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    if result = trEnd then  MarhTracert[Group].ObjLast := jmp.Obj;

  end;
end;
//========================================================================================
function StepSPforZavTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSPforCheckTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  tail : boolean;
  k : integer;
begin
  result := trNextStep;

  if not ObjZav[jmp.Obj].bParam[2] or //--------------------------------- если "З" или ...
  (not MarhTracert[Group].Povtor and //------------- нет признака повторной проверки и ...
  (ObjZav[jmp.Obj].bParam[14] or //-------------------- есть программное замыкание или ...
  not ObjZav[jmp.Obj].bParam[7])) then //------ предварительное замыкание STAN установлено
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,82); //---------------------------------------- Участок $ замкнут
    MarhTracert[Group].GonkaStrel := false;
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //- Закрыт для движения
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134); //--------------------------- Участок $ закрыт для движения
    MarhTracert[Group].GonkaStrel := false;
  end;

  //""""""""""""""""""""""""""""""" ПРОВЕРИТЬ ВВЕДЕННЫЕ ОГРАНИЧЕНИЯ """"""""""""""""""""""

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then //--- если Эл. тяга
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //----- Закрыт для ЭТ
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then//Закрыт для ЭТ=
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);//------ Закрыто движение на электротяге пост. тока по $
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then//--- Закрыт для ЭТ~
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //---- Закрыто движение на электротяге перем. тока по $
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- РИ
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84); //----------- Выполняется искусственное размыкание участка $
    MarhTracert[Group].GonkaStrel := false;
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- МИ
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85);  //---------------------------- Участок $ замкнут в маневрах
    MarhTracert[Group].GonkaStrel := false;
  end;

  case Rod of
    MarshP :
    begin
      if not ObjZav[jmp.Obj].bParam[1] then //-------------------------- занятость участка
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,83);   //------------------------------------ Участок $ занят
        MarhTracert[Group].GonkaStrel := false;
      end;
    end;

    MarshM :
    begin
      if not ObjZav[jmp.Obj].bParam[1] then //----------------------- занятость участка СП
      begin
        if ObjZav[jmp.Obj].ObjConstB[5] then  //---------------------------------- если СП
        begin
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83); //------------------------------------ Участок $ занят
          MarhTracert[Group].GonkaStrel := false;
        end else
        begin
          tail := false;

          for k := 1 to MarhTracert[Group].CIndex do
          if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
          begin
            tail := true;
            break;
          end;

          if tail then  //-------------------------------------------- если конец маршрута
          begin
            MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- Участок $ занят
            result := trEnd;
          end else  //--------------------------------------- если не в конце маршрута
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83); //---------------------------------- Участок $ занят
            result := trBreak;
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;
    end;

    else
      result := trStop;
      exit; //------------------------------------ если не понятный маршрут, то прекратить
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepSPforZamykTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[1] and    //--------------------- если занят участок и ...
  not ObjZav[jmp.Obj].ObjConstB[5] and    //------------------------ этот участок УП и ...
  (Rod = MarshM) then //----------------------------------------------- маневровый маршрут
  begin //---------------- выдать предупреждение в маневровом маршруте о занятости участка
    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter;
    MarhTracert[Group].FindTail := false;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      if ObjZav[jmp.Obj].bParam[2]
      then ObjZav[jmp.Obj].bParam[14] := true; //------------------------- прог. замыкание

      ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //---------- индекс начала
      ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr; //------- индекс светофора

      if not ObjZav[jmp.Obj].ObjConstB[5] and //---------------------------- если УП и ...
      (Rod = MarshM) then //------------------------------------------- маневровый маршрут
      begin //-------------------------------------------- для УП в маневрах возбудить 1КМ
        ObjZav[jmp.Obj].bParam[15] := true;  //--------------------------------------- 1КМ
        ObjZav[jmp.Obj].bParam[16] := false; //--------------------------------------- 2КМ
      end else
      begin //----------------------------------------------------------- иначе сброс КМов
        ObjZav[jmp.Obj].bParam[15] := false; //--------------------------------------- 1КМ
        ObjZav[jmp.Obj].bParam[16] := false; //--------------------------------------- 2КМ
      end;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      if ObjZav[jmp.Obj].bParam[2] //--------------------- если нет "З" из релейных данных
      then ObjZav[jmp.Obj].bParam[14] := true;  //---- то установить программное замыкание

      ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart; //---------- индекс начала
      ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr; //------- индекс светофора

      if not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshM) then
      begin //-------------------------------------------- для УП в маневрах возбудить 2КМ
        ObjZav[jmp.Obj].bParam[15] := false; //--------------------------------------- 1КМ
        ObjZav[jmp.Obj].bParam[16] := true;  //--------------------------------------- 2КМ
      end else
      begin //----------------------------------------------------------------- сброс КМов
        ObjZav[jmp.Obj].bParam[15] := false; //--------------------------------------- 1КМ
        ObjZav[jmp.Obj].bParam[16] := false; //--------------------------------------- 2КМ
      end;
    end;
  end;
end;
//========================================================================================
function StepSPSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;

  //""""""""""""""""""""""" ОБРАБОТКА ВВЕДЕННЫХ ОГРАНИЧЕНИЙ """"""""""""""""""""""""""""""
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //-- Закрыт для движен.
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134); //--------------------------- Участок $ закрыт для движения
    result :=  trBreak;
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or  //----------------- если ЭТ переменного тока или ...
  ObjZav[jmp.Obj].ObjConstB[9] then   //------------------------------ ЭТ постоянного тока
  begin
    if ObjZav[jmp.Obj].bParam[24] or //--- если закрыт для движения на эл.т. в АРМ ДСП или
    ObjZav[jmp.Obj].bParam[27] then //---------------- закрыт для движения на эл.т. в STAN
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and //------------------------- для станции стыкования
    ObjZav[jmp.Obj].ObjConstB[9] then //--- если ЭТ переменного тока и ЭТ постоянного тока
    begin
      if ObjZav[jmp.Obj].bParam[25] or //-------- Закрыт для движения на пост.т. в АРМ ДСП
      ObjZav[jmp.Obj].bParam[28] then //------------ Закрыт для движения на пост.т. в STAN
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467); //-------- Закрыто движение на ЭТ постоянного тока по $
      end;
      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //-------- Закрыто движение на ЭТ переменного тока по $
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84); //----------- Выполняется искусственное размыкание участка $
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- МИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85); //----------------------------- Участок $ замкнут в маневрах
  end;

  if Rod = MarshP then
  begin
    if not ObjZav[jmp.Obj].bParam[1] then //---------------------------- занятость участка
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,83); //---------------------------------------- Участок $ занят
    end;
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then   //----- нет поездных в направлении 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //----------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then  //---- нет маневровых в направлении 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162);  //-------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ занятость участка
        begin
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- 1КМ
          begin
            MarhTracert[Group].TailMsg :=' на занятый участок '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- Участок $ занят
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

  end else //-------------------------------------------------------- если вошли в точку 2
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then //-------- если нет поездных в напр. 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161);  //---------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin

        if not ObjZav[jmp.Obj].ObjConstB[4] then    //если нет маневровых в направл. 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //--------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZav[jmp.Obj].bParam[16] then //--------------------------------------- 2КМ
          begin
            MarhTracert[Group].TailMsg :=' на занятый участок '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;

      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then  sosed := 2
  else sosed := 1;

  Con := ObjZav[jmp.Obj].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else  result := trNextStep;
  end;

  if result = trNextStep then
  begin
    ObjZav[jmp.Obj].bParam[14] := false; //------------------------------- прог. замыкание
    ObjZav[jmp.Obj].bParam[8]  := true;  //---------------------------------------- трасса
    ObjZav[jmp.Obj].iParam[1]  := 0;
    ObjZav[jmp.Obj].iParam[2]  := 0;
    ObjZav[jmp.Obj].bParam[15] := false; //------------------------------------------- 1КМ
    ObjZav[jmp.Obj].bParam[16] := false; //------------------------------------------- 2КМ
  end;
end;
//========================================================================================
function StepSPRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;
  if not ObjZav[jmp.Obj].bParam[2] then //--------------------------------- замыкание есть
  begin
    if ObjZav[jmp.Obj].ObjConstB[5] then //----------------------------------- если это СП
    begin //--------------------------------------------------- СП - выдать предупреждение
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,82);   //------------------------------------ Участок $ замкнут
    end else
    begin //--------------------------------------------------------------------------- УП
      case Rod of
        MarshP :
        begin
          if not ObjZav[jmp.Obj].bParam[15] and
          not ObjZav[jmp.Obj].ObjConstB[16] then //------------------------------ нет КМов
          begin //-------------------------------------------------- выдать предупреждение
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,82); //-------------------------------- Участок $ замкнут
          end else
          begin //----------------------------------------------------------- враждебность
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,82); //-------------------------------- Участок $ замкнут
          end;
        end;

        MarshM :
        begin
          if Con.Pin = 1 then
          begin
            if ObjZav[jmp.Obj].bParam[15] and
            not ObjZav[jmp.Obj].ObjConstB[16] then //-------------------- есть 1КМ нет 2КМ
            begin //------------------------------------------------ выдать предупреждение
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,82); //------------------------------ Участок $ замкнут
            end else
            begin //--------------------------------------------------------- враждебность
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,82); //------------------------------ Участок $ замкнут
            end;
          end else
          begin
            if not ObjZav[jmp.Obj].bParam[15] and
            ObjZav[jmp.Obj].ObjConstB[16] then //------------------------ есть 2КМ нет 1КМ
            begin //------------------------------------------------ выдать предупреждение
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,82); //------------------------------ Участок $ замкнут
            end else
            begin //--------------------------------------------------------- враждебность
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
              InsMsg(Group,jmp.Obj,82); //------------------------------ Участок $ замкнут
            end;
          end;
        end;

        else
          inc(MarhTracert[Group].MsgCount); //------------------------------- враждебность
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,82); //---------------------------------- Участок $ замкнут
      end;
    end;
  end;

  if not ObjZav[jmp.Obj].bParam[7] or
  ObjZav[jmp.Obj].bParam[14] then //-------------------------------- программное замыкание
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,82); //---------------------------------------- Участок $ замкнут
  end;

  if ObjZav[jmp.Obj].bParam[12] or
  ObjZav[jmp.Obj].bParam[13] then //------------- Закрыт для движения в АРМ ДСП или в STAN
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134);
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or
  ObjZav[jmp.Obj].ObjConstB[9] then //---------------------- если участок электрифицирован
  begin
    if ObjZav[jmp.Obj].bParam[24] or
    ObjZav[jmp.Obj].bParam[27] then //----------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTracert[Group].WarCount);         //------------------------- предупреждение
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462);  //----------------- Закрыто движение на электротяге по $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then //----- обе тяги
    begin
      if ObjZav[jmp.Obj].bParam[25] or
      ObjZav[jmp.Obj].bParam[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTracert[Group].WarCount);       //------------------------- предупреждение
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);//--------- Закрыто движение на ЭТ постоянного тока по $
      end;

      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTracert[Group].WarCount);       //------------------------- предупреждение
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //-------- Закрыто движение на ЭТ переменного тока по $
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84);
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- МИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85); //----------------------------- Участок $ замкнут в маневрах
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ занятость участка
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);  //----------------------------------- Участок $ занят
        end;

        if not ObjZav[jmp.Obj].ObjConstB[1] then //------- нет поездных в направлении 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //----------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //--------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- занятость участка
          if not ObjZav[jmp.Obj].ObjConstB[5] then //---------------------------------- УП
          begin
            MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //---------------------------------- Участок $ занят
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ занятость участка
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);
        end;

        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161);   //--------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //----------------- Нет маневровых маршрутов по $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- занятость участка
          if not ObjZav[jmp.Obj].ObjConstB[5] then //---------------------------------- УП
          begin
            MarhTracert[Group].TailMsg :=' на занятый участок '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPPovtorRazdel(var Con : TOZNeighbour; const Lvl : TTracertLevel;
Rod : Byte; Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;
  if not ObjZav[jmp.Obj].bParam[2] then //-------------------------------------- замыкание
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,82);
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then//- Закрыт для движения.
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,134);  //-------------------------- Участок $ закрыт для движения
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then  //-------- если ЭТ
  begin
    if ObjZav[jmp.Obj].bParam[24] or
    ObjZav[jmp.Obj].bParam[27] then //----------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or
      ObjZav[jmp.Obj].bParam[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);
      end;

      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472);
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84);  //---------- Выполняется искусственное размыкание участка $
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //----------------------------------------- МИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85);  //---------------------------- Участок $ замкнут в маневрах
  end;

  if Con.Pin = 1 then //--------------------------------------------- если вошли в точку 1
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ занятость участка
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);  //----------------------------------- Участок $ занят
        end;

        if not ObjZav[jmp.Obj].ObjConstB[1] then //------- нет поездных в направлении 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //--------------------- "Нет поездных маршрутов по $"
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5] //-------------------------------- если это УП
        then ObjZav[jmp.Obj].bParam[15] := true; //----------------------------------- 1км

        if not ObjZav[jmp.Obj].ObjConstB[3] then  //---- нет маневровых в направлении 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //--------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- 1КМ
          begin
            MarhTracert[Group].TailMsg :=' на занятый участок '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else //-------------------------------------------------------- если вошли в точку 2
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ занятость участка
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);
        end;

        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //--------------------- "Нет поездных маршрутов по $"
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5]
        then ObjZav[jmp.Obj].bParam[16] := true;

        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //------------------- "Нет маневровых маршрутов по $"
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZav[jmp.Obj].bParam[16] then //--------------------------------------- 1КМ
          begin
            MarhTracert[Group].TailMsg :=' на занятый участок '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      ObjZav[jmp.Obj].bParam[8] := false;
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
//----------------------------------------------------------- трассировка при автодействии
function StepSPAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  result := trNextStep;

  if not ObjZav[jmp.Obj].bParam[2] {or not ObjZav[jmp.Obj].bParam[7]} then //--- замыкание
  exit;
  {
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,82, ObjZav[jmp.Obj].Liter,1); //---------------------- "Участок $ замкнут"
    InsMsg(Group,jmp.Obj,82);
  end;
  }
  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //---- Закрыт для движ.
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,134, ObjZav[jmp.Obj].Liter,1); //------- "Участок $ закрыт для движения"
    InsMsg(Group,jmp.Obj,134);
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
  begin
    if ObjZav[jmp.Obj].bParam[24] or
    ObjZav[jmp.Obj].bParam[27] then //----------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462);//------------------- Закрыто движение на электротяге по $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or
      ObjZav[jmp.Obj].bParam[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);
      end;

      if ObjZav[jmp.Obj].bParam[26] or
      ObjZav[jmp.Obj].bParam[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472);
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,84, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,84);//---------- "Выполняется искусственное размыкание участка $"
  end;

  if not ObjZav[jmp.Obj].bParam[5] then //--------------------------------------------- МИ
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,85, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,85);
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ занятость участка
        begin
          exit;
          {
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);  //--------------- "Участок $ занят"
          InsMsg(Group,jmp.Obj,83);
          }
        end;

        if not ObjZav[jmp.Obj].ObjConstB[1] then   //------------------- нет поездных 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161); //--------------------- "Нет поездных маршрутов по $"
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[15] := true;

        if not ObjZav[jmp.Obj].ObjConstB[3] then  //------------------ нет маневровых 1->2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,162); //------------------- "Нет маневровых маршрутов по $"
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- 1КМ
          begin
            MarhTracert[Group].TailMsg :=' на занятый участок '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83);    //----------------------------- "Участок $ занят"
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);    //----------------------------- "Участок $ занят"
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].bParam[1] then //------------------------ занятость участка
        begin
          exit;
          {
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,83);       //---------------------------- "Участок $ занят"
          }
        end;
        if not ObjZav[jmp.Obj].ObjConstB[2] then    //---------------- нет поездных 1 <- 2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,161, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,161);
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[16] := true;

        if not ObjZav[jmp.Obj].ObjConstB[4] then   //--------------- нет маневровых 1 <- 2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,162, ObjZav[jmp.Obj].Liter,1); InsMsg(Group,jmp.Obj,162);
        end;

        if not ObjZav[jmp.Obj].bParam[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZav[jmp.Obj].bParam[16] then //--------------------------------------- 1КМ
          begin
            MarhTracert[Group].TailMsg :=' на занятый участок '+ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,83); //-------------------------------- "Участок $ занят"
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,83, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,83);  //------------------------------- "Участок $ занят"
          end;
        end;
      end;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepSPFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[1] then
  begin //------------------------------------------------------------------ участок занят
    result := trBreak;
    exit;
  end else
  if ObjZav[jmp.Obj].bParam[2] then
  begin //-------------------------------------------------- участок не замкнут в маршруте
    if not((MarhTracert[Group].IzvCount = 0) and (MarhTracert[Group].Rod = MarshM)) then
    begin
      result := trStop;
      exit;
    end;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSPFindIzvStrel(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[1] then
  begin //------------------------------------------------------------------ участок занят
    MarhTracert[Group].IzvStrFUZ := true;
    if ObjZav[jmp.Obj].ObjConstB[5] then
    begin //-------------------------------------------------- если СП - проверить стрелки
      if ObjZav[jmp.Obj].bParam[2] or
      MarhTracert[Group].IzvStrNZ then //------------------------------ участок не замкнут
      MarhTracert[Group].IzvStrUZ := true;

      if MarhTracert[Group].IzvStrNZ then //------------------------ есть стрелки в трассе
      begin //------------------- сообщить оператору о незамкнутых стрелках перед сигналом
        result := trStop;
        exit;
      end;
    end else
    begin //-------------------------------- если УП - проверить наличие стрелок по трассе
      if MarhTracert[Group].IzvStrNZ then
      begin //---- есть стрелки - сообщить оператору о незамкнутых стрелках перед сигналом
        MarhTracert[Group].IzvStrUZ := true;
        result := trStop;
        exit;
      end;
    end;
  end else
  if MarhTracert[Group].IzvStrFUZ then
  begin//-- участок свободен и была занятость участка перед ним-не выдавать предупреждение
    MarhTracert[Group].IzvStrUZ := false;
    result := trStop;
    exit;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepSPPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin

  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  if not ObjZav[jmp.Obj].bParam[14] and //--------------- нет программного замыкания и ...
  ObjZav[jmp.Obj].bParam[7] then //------------------------ нет предварительного замыкания
  begin //------------------------------------------------------ разрушена трасса маршрута
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsMsg(Group,jmp.Obj,228);
    result := trStop;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[sosed];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepPutFindTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then //------------------------------------ если вошли со стороны точки 1
  begin
    case Rod of
      MarshP :  //--------------------------------------------------------------- поездной
        if ObjZav[jmp.Obj].ObjConstB[1] //------------------------ если есть поездные 1->2
        then result := trNextStep //--------------------------- перейти на следущий объект
        else result := trRepeat; //--------------- нет 1->2,  возврат к предыдущей стрелке

      MarshM ://--------------------------------------------------------------- маневровый
        if ObjZav[jmp.Obj].ObjConstB[3]//----------------------- если есть маневровые 1->2
        then result := trNextStep //--------------------------- перейти на следущий объект
        else result := trRepeat; //--------------- нет 1->2,  возврат к предыдущей стрелке

      else  result := trNextStep; //----------------------- маршрута нет продолжить дальше
    end;

    if result = trNextStep then  //------------------------------- если продолжение дальше
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2]; //----------------------- коннектор за точкой 2
      case Con.TypeJmp of
        LnkRgn : result := trRepeat; //-------- конец района, возврат к предыдущей стрелке
        LnkEnd : result := trRepeat;
      end;
    end;
  end else
  begin //---------------------------------------------- если вошли со стороны точки 2
    case Rod of
      MarshP : //------------------------------------------------------- если поездной
        if ObjZav[jmp.Obj].ObjConstB[2]
        then result := trNextStep
        else result := trRepeat;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4]
        then result := trNextStep
        else result := trRepeat;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;
//========================================================================================
function StepPutContTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if Con.Pin = 1 then //--------------------------------- вышли на путь со стороны точки 1
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[1] then result := trNextStep
        else result := trStop;
      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[3] then result := trNextStep
        else result := trStop;
      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;
  end else   //------------------------------------------ вышли на путь со стороны точки 2
  begin
    case Rod of
      MarshP :
        if ObjZav[jmp.Obj].ObjConstB[2] then result := trNextStep
        else result := trStop;

      MarshM :
        if ObjZav[jmp.Obj].ObjConstB[4] then result := trNextStep
        else result := trStop;

      else result := trNextStep;
    end;

    if result = trNextStep then
    begin
      Con := ObjZav[jmp.Obj].Neighbour[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
        LnkNecentr : result := trEndTrace;
      end;
    end;
  end;
end;
//========================================================================================
function StepPutZavTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;
  Con := ObjZav[jmp.Obj].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else result := trNextStep;
  end;
end;
//========================================================================================
function StepPutCheckTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  tail,Chi,Ni,ChKM,NKM : boolean;
  k,UTS,sosed,Put : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;
  Put := jmp.Obj;
  Chi := not ObjZav[Put].bParam[2];
  Ni :=  not ObjZav[Put].bParam[3];
  ChKM := ObjZav[Put].bParam[4];
  NKM :=  ObjZav[Put].bParam[15];
  UTS := ObjZav[Put].BaseObject;
  result := trNextStep;
  //--------------------------------------------------------------- если для пути есть УТС
  if UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- упор установлен
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[Put].Liter,1);
          InsMsg(Group,Put,108);  //---------------------- "Установлен тормозной упор"
          MarhTracert[Group].GonkaStrel := false;
        end else
        if not ObjZav[UTS].bParam[1] and not ObjZav[UTS].bParam[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          result := trBreak;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[Put].Liter,1);
          InsMsg(Group,Put,109);//------- "Тормозной упор не имеет контроля положения"
          MarhTracert[Group].GonkaStrel := false;
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZav[Put].bParam[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZav[UTS].bParam[27] then
            begin //------------------------------------------- сообщение не зафиксировано
              ObjZav[ObjZav[Put].BaseObject].bParam[27] := true;
              result := trBreak;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[Put].Liter,1);
              InsWar(Group,Put,108);  //------------------ "Установлен тормозной упор"
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            result := trBreak;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[Put].Liter,1);
            InsMsg(Group,Put,108);  //-------------------- "Установлен тормозной упор"
            MarhTracert[Group].GonkaStrel := false;
          end;
        end;
      end;
    end;
  end;

  if ObjZav[Put].bParam[12] or ObjZav[Put].bParam[13] then //- Закрыт для движения
  begin
    result := trBreak;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[Put].Liter,1);
    InsMsg(Group,Put,135); //------------------------------ Путь $ закрыт для движения
    MarhTracert[Group].GonkaStrel := false;
  end;

  if ObjZav[Put].ObjConstB[8] or ObjZav[Put].ObjConstB[9] then //--------- если ЭТ
  begin
    if ObjZav[Put].bParam[24]
    or ObjZav[Put].bParam[27] then //-------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[Put].Liter,1);
      InsWar(Group,Put,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZav[Put].ObjConstB[8] and ObjZav[Put].ObjConstB[9] then
    begin
      if ObjZav[Put].bParam[25] or
      ObjZav[Put].bParam[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[Put].Liter,1); InsWar(Group,Put,467);
      end;

      if ObjZav[Put].bParam[26] or
      ObjZav[Put].bParam[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[Put].Liter,1);
        InsWar(Group,Put,472); //------------------------- Конец контактной подвески $
      end;
    end;
  end;

  case Rod of
    MarshP : //---------------------------------------------------- для поездного маршрута
    begin
      if not MarhTracert[Group].Povtor and   //---------- если не повторная проверка и ...
      (ObjZav[Put].bParam[14] or  //--------------- программное замыкание или ...
      not ObjZav[Put].bParam[7] or //-------- предварительное замыкание четное или ...
      not ObjZav[Put].bParam[11]) then //---------- предварительное замыкание нечетное
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,110, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,110);
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not (ObjZav[Put].bParam[1] and ObjZav[Put].bParam[16]) then //- занятость Ч или Н
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,112); //-------------------------------------------- Путь $ занят
        MarhTracert[Group].GonkaStrel := false;
      end;

      if Chi or Ni then //------------------------------------------------------ ЧИ или НИ
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,113, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,113);//------------------ На путь $ установлен враждебный маршрут
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not (ObjZav[Put].bParam[5] and ObjZav[Put].bParam[6]) then //----------- ~МИ(ч&н)
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,111); //--------------------------- Путь $ замкнут в маневрах
        MarhTracert[Group].GonkaStrel := false;
      end;

      //---------------------------------------------------------- четный  маршрут на путь
      //----------------------------------------------------------------------------------
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin //-----------  проверить конец подвески контакной сети для четного направления
        if ObjZav[Put].ObjConstB[11] then  //-------------------- Конец контакт.подвески Ч
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[Put].Liter,1);
          InsWar(Group,Put,473); //----------------------- Конец контактной подвески $
        end;
      end else //------------------------------------------------ нечетный маршрут на путь
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZav[Put].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[Put].Liter,1);
          InsWar(Group,Put,473);
        end;
      end;
    end;

    //--------------------------------------------------- для маневрового маршрута на путь
    MarshM :
    begin
      if not MarhTracert[Group].Povtor and
      (ObjZav[Put].bParam[14] or //----------- программное замыкание на РМ-ДСП или ...
      not ObjZav[Put].bParam[7] or //-------- Предварительное замыкание FR3(ч) или ...
      not ObjZav[Put].bParam[11]) then //-----------  Предварительное замыкание FR3(н)
      begin
        result := trBreak;
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,110, ObjZav[Put].Liter,1);
        InsMsg(Group,Put,110); //----------------------- Установлено замыкание $ в УВК
        MarhTracert[Group].GonkaStrel := false;
      end;

      if not (ObjZav[Put].bParam[5] and ObjZav[Put].bParam[6]) then //--------- ~МИ(ч & н)
      begin
        result := trBreak;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[Put].Liter,1);
        InsWar(Group,Put,111);   //----------------------------- Путь $ замкнут в маневрах
      end;

      //----------------------------------------------------------  четный маршрут на путь
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin
        if (not NKM and Ni) or Chi then//------------------------- НИ без НКМ или любой ЧИ
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[Put].Liter,1);
          result := trBreak;
          InsMsg(Group,Put,113); //----------- На путь $ установлен враждебный маршрут
          MarhTracert[Group].GonkaStrel := false;
        end else
        if Ni then //------------------------------------------------------------------ НИ
        begin
          if NKM then //--------------------------------------------------------- есть НКМ
          begin
            tail := false;
            for k := 1 to MarhTracert[Group].CIndex do
            if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
            begin
              tail := true;
              break;
            end;

            if tail then
            begin
              MarhTracert[Group].TailMsg := ' на замкнутый путь '+ ObjZav[Put].Liter;
              MarhTracert[Group].FindTail := false;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,441, ObjZav[Put].Liter,1);
              InsWar(Group,Put,441);// На путь установлен встречный маневровый маршрут
            end else
            begin //--------сли конечная точка трассы лежит позади замкнутого пути - выход
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,113, ObjZav[Put].Liter,1);
              InsMsg(Group,Put,113);//-------- На путь $ установлен враждебный маршрут
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[Put].Liter,1);
            InsMsg(Group,Put,113);//---------- На путь $ установлен враждебный маршрут
            MarhTracert[Group].GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end else //-------------------------------------------------------- нечетный маршрут
      begin
        if (not ChKM and Chi) or Ni then //------ стоит четный поездной или любой нечетный
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[Put].Liter,1);
          result := trBreak;
          InsMsg(Group,Put,113);//------------ На путь $ установлен враждебный маршрут
          MarhTracert[Group].GonkaStrel := false;
        end else
        if Chi then //----------------------------------------------------------------- ЧИ
        begin
          if ChKM then //------------------------------------------------------------- чкм
          begin
            tail := false;

            for k := 1 to MarhTracert[Group].CIndex do
            if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
            begin
              tail := true;
              break;
            end;

            if tail then
            begin
              MarhTracert[Group].TailMsg :=  ' на замкнутый путь '+ ObjZav[Put].Liter;
              MarhTracert[Group].FindTail := false;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,441, ObjZav[Put].Liter,1);
              InsWar(Group,Put,441);// На путь установлен встречный маневровый маршрут
            end else
            begin //------ если конечная точка трассы лежит позади замкнутого пути - выход
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
              GetShortMsg(1,113, ObjZav[Put].Liter,1);
              InsMsg(Group,Put,113);//-------- На путь $ установлен враждебный маршрут
              MarhTracert[Group].GonkaStrel := false;
            end;
          end else //------------------------------------------------------------- нет ЧКМ
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[Put].Liter,1);
            InsMsg(Group,Put,113);//---------- На путь $ установлен враждебный маршрут
            MarhTracert[Group].GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end;

      if not (ObjZav[Put].bParam[1] and ObjZav[Put].bParam[16]) //- занят(ч или н)
      then
      begin
        tail := false;

        for k := 1 to MarhTracert[Group].CIndex do
        if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then
        begin
          tail := true;
          break;
        end;

        if tail then
        begin
          MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[Put].Liter;
          MarhTracert[Group].FindTail := false;
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,112, ObjZav[Put].Liter,1);
          InsWar(Group,Put,112);
        end else
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,112, ObjZav[Put].Liter,1);
          InsMsg(Group,Put,112);
          MarhTracert[Group].GonkaStrel := false;
        end;
        result := trBreak;
      end;
    end;

    else begin result := trStop; exit; end;  //------------------- для отсутствия маршрута
  end;

  Con := ObjZav[Put].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trStop;
    LnkEnd : result := trStop;
    LnkNecentr : result := trEndTrace;
  end;
end;
//========================================================================================
function StepPutZamykTrassa(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod :Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  if not ObjZav[jmp.Obj].bParam[1] then //------------------------------------- путь занят
  begin
    MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter;
    MarhTracert[Group].FindTail := false;
  end;

  Con := ObjZav[jmp.Obj].Neighbour[sosed]; //---------------------- коннектор точки выхода
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else  result := trNextStep;
  end;

  if result = trNextStep then  //--------------------------- если продолжается замыкание
  begin
    ObjZav[jmp.Obj].bParam[8] := true;  //------------------------ сброс прог. замыкание
    ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
    ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr;
  end;
end;
//========================================================================================
function StepPutSignalCirc(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  UTS : integer;
  Signal : integer;
begin
  result := trNextStep;
  UTS := ObjZav[jmp.Obj].BaseObject;
  if MarhTracert[Group].ObjStart >0 then 
  Signal := MarhTracert[Group].ObjStart;

  if UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- упор установлен
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1); //------- Установлен тормозной упор $
          InsMsg(Group,jmp.Obj,108);
        end else
        if not ObjZav[UTS].bParam[1] and
        not ObjZav[UTS].bParam[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[jmp.Obj].Liter,1);//------ упор $ без контроля положения
          InsMsg(Group,jmp.Obj,109);
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and  ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZav[UTS].bParam[27] then//--------------- сообщение не зафиксировано
            begin
              ObjZav[UTS].bParam[27] := true;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,108); //------------------- "Установлен тормозной упор"
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,108);
          end;
        end;
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //---- Движение закрыто
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,135); //------------------------------ Путь $ закрыт для движения
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //-- Закрыто ЭТ движ.
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1); //-- Закрыто движение на электротяге по $
      InsWar(Group,jmp.Obj,462);
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then //---- нет движ. -Т
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1); //--- Закрыто движение на ЭТ пост. тока
        InsWar(Group,jmp.Obj,467);
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then //---- нет движ. ~Т
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);//--- Закрыто движение на ЭТ пер.тока по
        InsWar(Group,jmp.Obj,472);
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not(ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then //- занят(ч&н)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1); //------------------------ Путь $ занят
        InsMsg(Group,jmp.Obj,112);
      end;

      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //--- ~МИ(ч&н)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1); //----------- Путь $ замкнут в маневрах
        InsMsg(Group,jmp.Obj,111);
      end;

      if Con.Pin = 1 then //----------------------------- вошли на путь со стороны точки 1
      begin //------------ проверить конец подвески контакной сети для четного направления
        if ObjZav[jmp.Obj].ObjConstB[11] then //------- есть признак конца контактной сети
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);//-------- Конец контактной подвески $
          InsWar(Group,jmp.Obj,473);
        end;
      end else //---------------------------------------- вышли на путь со стороны точки 2
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZav[jmp.Obj].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473);
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //--- ~МИ(ч&н)
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1); //----------- Путь $ замкнут в маневрах
        InsWar(Group,jmp.Obj,111);
      end;

      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then //----- занят
      begin
        MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter;
        MarhTracert[Group].FindTail := false;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,112);
      end;
    end;

    else result := trStop;
  end;

  if (((Con.Pin = 1) and (not OddRight))
  or ((Con.Pin = 2) and OddRight)) then //-------------- вышли на путь со стороны нечетной
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then
        begin //-------------------------------------------- нет нечетных поездных на путь
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);  //----------------------------- Маршрут не существует
        end else
        if ObjZav[jmp.Obj].bParam[3] or   //------------------------------- нет НИ или ...
        (not ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[4]) then //---- ЧИ и ЧКМ
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //----------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then      //-------------- нет маневровых 1->2
        begin //----------------------- не могут быть нечетные маневровые маршруты на путь
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);  //----------------------------- Маршрут не существует
        end;

        if (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4])//- ЧИ без ЧКМ
        or  //-------------------------------------------------------------------- или ...
        (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) //-- НИ без НКМ
        then
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //-------------------------- Открыт враждебный сигнал
        end;
      end;
    end;

    if ObjZav[jmp.Obj].bParam[3] and (ObjZav[jmp.Obj].ObjConstI[4]<>0)
    then //------------------------------------------------ нет НИ, а датчик НИ существует
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,457, ObjZav[jmp.Obj].Liter,1); //------------------------- Нет замыкания
      InsMsg(Group,jmp.Obj,457);
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin//-------------------------------------------------- вышли на путь с четной стороны
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then  //-------------------- нет поездных 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ Маршрут не существует
        end else
        if(ObjZav[jmp.Obj].bParam[2]) or //---------- если ЧИ или ...
        (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then //--- НИ и НКМ
        begin
          if not ObjZav[Signal].bParam[8] then
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,113); //-------------------- установлен враждебный маршрут
          end;
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then  //-------------------- нет маневров 1<-2
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ Маршрут не существует
        end;

        if (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15])// НИ без НКМ
        or  //-------------------------------------------------------------------- или ...
        (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) then//ЧИ без ЧКМ
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //-------------------------- Открыт враждебный сигнал
        end;
      end;
    end;

    if ObjZav[jmp.Obj].bParam[2] and (ObjZav[jmp.Obj].ObjConstI[3]<>0)
    then //--------------------------------------------------------- нет ЧИ, а датчик есть
    begin
      inc(MarhTracert[Group].MsgCount);
      MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
      GetShortMsg(1,457, ObjZav[jmp.Obj].Liter,1);
      InsMsg(Group,jmp.Obj,457);
    end;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepPutOtmenaMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  Con := ObjZav[jmp.Obj].Neighbour[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else result := trNextStep;
  end;

  if result = trNextStep then
  begin
    ObjZav[jmp.Obj].bParam[14] := false;  //------------------------------ прог. замыкание
    ObjZav[jmp.Obj].bParam[8]  := true;  //---------------------------------------- трасса
    ObjZav[jmp.Obj].iParam[sosed+1] := 0; //------------------------------ сигнал маршрута
  end;
end;
//========================================================================================
function StepPutRazdelSign(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  UTS : integer;
begin
  result := trNextStep;
  UTS := ObjZav[jmp.Obj].BaseObject;
  if  UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- упор установлен
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,108); //------------------------- Установлен тормозной упор
        end else
        if not ObjZav[UTS].bParam[1] and not ObjZav[UTS].bParam[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,109);//------- Тормозной упор $ не имеет контроля положения
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZav[UTS].bParam[27] then
            begin //------------------------------------------- сообщение не зафиксировано
              ObjZav[UTS].bParam[27] := true;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,108); //--------------------- Установлен тормозной упор
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,108); //----------------------- Установлен тормозной упор
          end;
        end;
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[14] or
  not ObjZav[jmp.Obj].bParam[7] or
  not ObjZav[jmp.Obj].bParam[11] then //----------- если программное замыкание установлено
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,110, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,110); //--------------------------- Установлено замыкание $ в УВК
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //- Закрыт для движения
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,135);  //----------------------------- Путь $ закрыт для движения
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then //--- если любая ЭТ
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //----- Закрыт для ЭТ
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462);  //----------------- Закрыто движение на электротяге по $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then //Закрыт на пост.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467);// Закрыто движение на электротяге постоянного тока по $
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then //Закрыт для пер.т.
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //Закрыто движение на электротяге переменного тока по $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занят(ч|н)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,112); //--------------------------------------- Путь $ занят#
      end;

      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //--- ~МИ(ч&н)
      begin
        inc(MarhTracert[Group].MsgCount);  //-------------------------------- враждебность
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,111);     //----------------------- Путь $ замкнут в маневрах
      end;

      if Con.Pin = 1 then
      begin //------------ проверить конец подвески контакной сети для четного направления
        if ObjZav[jmp.Obj].ObjConstB[11] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473);//------------------------ Конец контактной подвески $
        end;
      end else
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZav[jmp.Obj].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473); //----------------------- Конец контактной подвески $
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
      begin
        inc(MarhTracert[Group].WarCount); //------------------------------- предупреждение
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,111); //--------------------------- Путь $ замкнут в маневрах
      end;

      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занят(ч|н)
      begin
        MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter;
        MarhTracert[Group].FindTail := false;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,112);  //--------------------------------------- Путь $ занят
      end;
    end;

    else  result := trStop;
  end;

  if Con.Pin = 1 then    //------------------- вход на путь в точке 1 (с нечетной стороны)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then
        begin //-------------------------------------------- нет нечетных поездных на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);
        end else
        if not ObjZav[jmp.Obj].bParam[3] or //------------------------------------- НИ или
        (not ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[4]) then //---- ЧИ и ЧКМ
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //----------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then
        begin //------------------------------------------ нет нечетных маневровых на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ Маршрут не существует
        end;

        if not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4] then//ЧИ без ЧКМ
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113); //----------- На путь $ установлен враждебный маршрут
        end;

        if not ObjZav[jmp.Obj].bParam[3] then // -------------------------------------- НИ
        begin
          if ObjZav[jmp.Obj].bParam[15] then //--------------------------------------- НКМ
          begin
            MarhTracert[Group].TailMsg := ' на замкнутый путь '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,441, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,441); //На путь $ установлен встречный маневровый маршрут
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,113); //--------- На путь $ установлен враждебный маршрут
          end;
        end;
      end;
    end;

    ObjZav[jmp.Obj].bParam[8] := false;
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else    //-------------------------------- вход на путь в точке 2 (с четной стороны)
  begin
    case Rod of
      MarshP : begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin //---------------------------------------------- нет четных поездных на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //----------------------------- Маршрут не существует
        end else
        if not ObjZav[jmp.Obj].bParam[2] or  //------------------------------------ ЧИ или
        (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then //--  НИ и НКМ
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin //-------------------------------------------- нет четных маневровых на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ Маршрут не существует
        end;

        if not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15] then//НИ без НКМ
        begin
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;

        if not ObjZav[jmp.Obj].bParam[2] then //---------------------------------- если ЧИ
        begin
          if ObjZav[jmp.Obj].bParam[4] then //----------------------------------- если ЧКМ
          begin
            MarhTracert[Group].TailMsg := ' на замкнутый путь '+ ObjZav[jmp.Obj].Liter;
            MarhTracert[Group].FindTail := false;
            inc(MarhTracert[Group].WarCount);
            MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
            GetShortMsg(1,441, ObjZav[jmp.Obj].Liter,1);
            InsWar(Group,jmp.Obj,441); //На путь $ установлен встречный маневровый маршрут
          end else
          begin
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,113);//---------- На путь $ установлен враждебный маршрут
          end;
        end;
      end;
    end;

    ObjZav[jmp.Obj].bParam[8] := false;
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepPutAutoTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
var
  UTS : integer;
begin
  result := trNextStep;
  UTS := ObjZav[jmp.Obj].BaseObject;
  if  UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZav[UTS].bParam[2] then
        begin //---------------------------------------------------------- упор установлен
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,108); //------------------------- Установлен тормозной упор
        end else
        if not ObjZav[UTS].bParam[1] and not ObjZav[UTS].bParam[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,109, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,109);//------- Тормозной упор $ не имеет контроля положения
        end;
      end;

      MarshM :
      begin
        if not ObjZav[UTS].bParam[1] and ObjZav[UTS].bParam[2] and
        not ObjZav[UTS].bParam[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZav[jmp.Obj].bParam[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZav[UTS].bParam[27] then
            begin //------------------------------------------- сообщение не зафиксировано
              ObjZav[UTS].bParam[27] := true;
              result := trStop;
              inc(MarhTracert[Group].WarCount);
              MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
              GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
              InsWar(Group,jmp.Obj,108); //--------------------- Установлен тормозной упор
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            result := trStop;
            inc(MarhTracert[Group].MsgCount);
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
            GetShortMsg(1,108, ObjZav[jmp.Obj].Liter,1);
            InsMsg(Group,jmp.Obj,108); //----------------------- Установлен тормозной упор
          end;
        end;
      end;
    end;
  end;

  if ObjZav[jmp.Obj].bParam[14] then //----------------- программное замыкание установлено
  begin
    result := trStop;
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,110, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,110);  //-------------------------- Установлено замыкание $ в УВК
  end;

  if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then //- Закрыт для движения
  begin
    inc(MarhTracert[Group].MsgCount);
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,135, ObjZav[jmp.Obj].Liter,1);
    InsMsg(Group,jmp.Obj,135); //------------------------------ Путь $ закрыт для движения
  end;

  if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
  begin
    if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then //----- Закрыт для ЭТ
    begin
      inc(MarhTracert[Group].WarCount);
      MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
      GetShortMsg(1,462, ObjZav[jmp.Obj].Liter,1);
      InsWar(Group,jmp.Obj,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
    begin
      if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then //- Закрыт пост. ЭТ
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,467, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,467); //Закрыто движение на электротяге постоянного тока по $
      end;

      if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then //-- Закрыт пер. ЭТ
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,472, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,472); //Закрыто движение на электротяге переменного тока по $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занят(ч|н)
      begin
        exit;
        {
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,112); //---------------------------------------- Путь $ занят
        }
      end;

      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //---- МИ(ч|н)
      begin
        inc(MarhTracert[Group].MsgCount);
        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsMsg(Group,jmp.Obj,111); //--------------------------- Путь $ замкнут в маневрах
      end;

      if Con.Pin = 1 then
      begin //------------ проверить конец подвески контакной сети для четного направления
        if ObjZav[jmp.Obj].ObjConstB[11] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473); //----------------------- Конец контактной подвески $
        end;
      end else
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZav[jmp.Obj].ObjConstB[10] then
        begin
          inc(MarhTracert[Group].WarCount);
          MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
          GetShortMsg(1,473, ObjZav[jmp.Obj].Liter,1);
          InsWar(Group,jmp.Obj,473);
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then //---- МИ(ч|н)
      begin
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,111, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,111);
      end;

      if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занят(ч|н)
      begin
        MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter;
        MarhTracert[Group].FindTail := false;
        inc(MarhTracert[Group].WarCount);
        MarhTracert[Group].Warning[MarhTracert[Group].WarCount] :=
        GetShortMsg(1,112, ObjZav[jmp.Obj].Liter,1);
        InsWar(Group,jmp.Obj,112); //---------------------------------------- Путь $ занят
      end;
    end;

    else result := trStop;
  end;

  if (((Con.Pin = 1) and (not OddRight))
  or ((Con.Pin = 2) and OddRight)) then //------------------ вошли со стороны 1 (нечетное)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[1] then
        begin //-------------------------------------------- нет нечетных поездных на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77);
        end else
        if not ObjZav[jmp.Obj].bParam[3] or (not ObjZav[jmp.Obj].bParam[2]
        and ObjZav[jmp.Obj].bParam[4]) then //---------------------------- НИ или ЧИ с ЧКМ
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[3] then
        begin //------------------------------------------ нет нечетных маневровых на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ Маршрут не существует
        end;

        if (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15])// НИ без НКМ
        or//-------------------------------------------------------------------------- или
        (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) //--- ЧИ без ЧКМ
        then
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else  //------------------------------------------------ вошли со стороны 2 (четное)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[2] then
        begin //---------------------------------------------- нет четных поездных на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ Маршрут не существует
        end else
        if not ObjZav[jmp.Obj].bParam[2] or //--------------------------------- ЧИ или ...
        (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then //--- НИ и НКМ
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if not ObjZav[jmp.Obj].ObjConstB[4] then
        begin //-------------------------------------------- нет четных маневровых на путь
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,77, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,77); //------------------------------ Маршрут не существует
        end;

        if (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) // ЧИ без ЧКМ
        or  //------------------------------------------------------------------------ или
        (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) //-- НИ без НКМ
        then
        begin
          result := trStop;
          inc(MarhTracert[Group].MsgCount);
          MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
          GetShortMsg(1,113, ObjZav[jmp.Obj].Liter,1);
          InsMsg(Group,jmp.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;
    end;

    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;
//========================================================================================
function StepPutFindIzvest(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then
  begin //--------------------------------------------------------------------- путь занят
    result := trBreak;
    exit;
  end else
  if ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[3] then
  begin //----------------------------------------------------- путь не замкнут в маршруте
    if not((MarhTracert[Group].IzvCount = 0) and (MarhTracert[Group].Rod = MarshM)) then
    begin
      result := trStop;
      exit;
    end;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepPutFindIzvStrel(var Con :TOZNeighbour; const Lvl :TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then
  begin //------------------------------------------------------------------ участок занят
    MarhTracert[Group].IzvStrFUZ := true;
    if MarhTracert[Group].IzvStrNZ then
    begin //------ есть стрелки - сообщить оператору о незамкнутых стрелках перед сигналом
      MarhTracert[Group].IzvStrUZ := true;
      result := trStop;
      exit;
    end;
  end else
  if MarhTracert[Group].IzvStrFUZ then
  begin //участок свободен и была занятость участка перед ним - не выдавать предупреждение
    MarhTracert[Group].IzvStrUZ := false;
    result := trStop;
    exit;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;
//========================================================================================
function StepPutPovtorMarh(var Con : TOZNeighbour; const Lvl : TTracertLevel;Rod : Byte;
Group : Byte; jmp : TOZNeighbour) : TTracertResult;
begin
  if not ObjZav[jmp.Obj].bParam[14] and not ObjZav[jmp.Obj].bParam[7] then
  begin //------------------------------------------------------ разрушена трасса маршрута
    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] :=
    GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter,1);
    InsMsg(Group,jmp.Obj,228); //--------------------------- Трасса маршрута от $ нарушена
    result := trStop;
  end else
  if Con.Pin = 1 then
  begin
    Con := ObjZav[jmp.Obj].Neighbour[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end else
  begin
    Con := ObjZav[jmp.Obj].Neighbour[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNextStep;
    end;
  end;
end;

end.

