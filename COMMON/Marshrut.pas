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

procedure InsMsg(Obj,Index : SmallInt);
procedure InsWar(Obj,Index : SmallInt);
function ResetTrace : Boolean;
function ResetMarhrutSrv(fr : word) : Boolean;
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
function EndTracertMarshrut : Boolean;
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
function GetSoglOtmeny(Uslovie : SmallInt) : string;
function OtmenaMarshruta(Svetofor: SmallInt; Marh: Byte) : Boolean;
function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
function SetProgramZamykanie(Grp : Byte; Auto : Boolean) : Boolean;
function SendMarshrutCommand(Grp : Byte) : Boolean;
function SendTraceCommand(Grp : Byte) : Boolean;
function RestorePrevTrace : Boolean;

{$IFNDEF RMARC}
function AddToTracertMarshrut(index : SmallInt) : Boolean;
function NextToTracertMarshrut(index : SmallInt) : Boolean;
{$ENDIF}

function StepTrace(var From:TSos; const Lvl:TTrLev; Rod:Byte; Grp:Byte) : TTrRes;

//================== ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ СТРЕЛКУ ===================================
function StepTrasStr    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrZavTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrZamTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrCirc    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrOtmen   (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrRazdel  (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrPovtRazd(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrFindIzv (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrFindStr (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;
function StepStrPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos): TTrRes;

//==================  ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ УП ИЛИ СП ================================
function StepTrasSP    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpPutFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpZavTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSрChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpZamTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpCirc    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpOtmen   (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpRazdel  (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpPovtRazd(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpFindIzv (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpFindStr (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSPPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;


//==================  ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ ПУТЬ  ====================================
function StepTrasPut    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutZavTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutZamTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutCirc    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutOtmena  (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutRazdel  (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutFindIzv (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutFindStr (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
function StepPutPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;

//==================   ФУНКЦИИ ТРАССИРОВКИ ЧЕРЕЗ СВЕТОФОРЫ ===============================
function StepTrasSig    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigZavTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigZamTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigCirc    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigOtmena  (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigFindIzv (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
function StepSigFindStr (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;

//==================== ФУНКЦИЯ ТРАССИРОВКИ ЧЕРЕЗ АВТОБЛОКИРОВКУ ==========================
function StepTrasAB(var Con:TSos; const Lvl:TTrLev; Rod:Byte; AB:TSos) : TTrRes;

//==================== ФУНКЦИЯ ТРАССИРОВКИ ЧЕРЕЗ ПРИГЛАСИТЕЛЬНЫЙ СИГНАЛ ==================
function StepTrasPrigl(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Prig:TSos) : TTrRes;

//==================== ФУНКЦИЯ ТРАССИРОВКИ ЧЕРЕЗ УКСПС ===================================
function StepTrasUksps(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Uksps:TSos) : TTrRes;

//==================== ФУНКЦИЯ ТРАССИРОВКИ ЧЕРЕЗ ВСПОМОГАТЕЛЬНУЮ СН ======================
function StepTrasVsn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Vsn:TSos) : TTrRes;

//==================== ФУНКЦИЯ ТРАССИРОВКИ ЧЕРЕЗ УВЯЗКУ С МАНЕВРОВЫМ Районом =============
function StepTrasManRn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; ManR:TSos) : TTrRes;

//==================== Запрос согласия поездного отправления =============================
function StepTrasZapPO(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Zapr:TSos) : TTrRes;

function StepTrasPAB(var Con:TSos; const Lvl:TTrLev; Rod:Byte; PAB:TSos) : TTrRes;

function StepTrasDZOhr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Dz:TSos) : TTrRes;

function StepTrasIzPer(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Per:TSos) : TTrRes;

function StepTrasDZSp (var Con:TSos; const Lvl:TTrLev; Rod:Byte; DZSp:TSos) : TTrRes;

function StepTrasPSogl(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sogl:TSos) : TTrRes;

function StepUvazGor(var Con:TSos; const Lvl:TTrLev;Rod:Byte; Uvaz:TSos):TTrRes;

function StepTrasNad(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Nad:TSos):TTrRes;

//======= Трассировка через контрроль маршрута отправления для стрелки в пути ============
function StepTrasOtpr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Otpr:TSos) : TTrRes;

//============= Контроль перезамыкания маршрутов приема для стрелки в пути (42) ==========
function StepTrasPrzPr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Prz:TSos) : TTrRes;

function StepTrasOPI  (var Con:TSos; const Lvl:TTrLev; Rod:Byte; OPI:TSos) : TTrRes;
function StepTrasZona (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Zon:TSos) : TTrRes;
function StepTrasRazn (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Raz:TSos) : TTrRes;

function SoglasieOG(Index : SmallInt) : Boolean;
function CheckOgrad(ptr : SmallInt) : Boolean;
function CheckOtpravlVP(ptr : SmallInt) : Boolean;
function NegStrelki(ptr : SmallInt; pk : Boolean) : Boolean;
function SignCircOgrad(ptr : SmallInt) : Boolean;
function SignCircOtpravlVP(ptr : SmallInt) : Boolean;
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean) : Boolean;
function VytajkaRM(ptr : SmallInt) : Boolean;
function VytajkaZM(ptr : SmallInt) : Boolean;
function VytajkaOZM(ptr : SmallInt) : Boolean;
function VytajkaCOT(ptr : SmallInt) : string;
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
procedure SetNadvigParam(Ptr : SmallInt);
function AutoMarsh(AvtoM : SmallInt; mode : Boolean) : Boolean; //вкл/откл автод. маршрута
function CheckAutoMarsh(AvtoS : SmallInt; Grp : Byte) : Boolean;
function AutoMarshON(AvtoS : SmallInt; Napr : Boolean): Boolean;//установить автод.сигнала
function AutoMarshOFF(AvtoS : SmallInt; Napr : Boolean  ) : Boolean; //снять автод.сигнала

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
  TabloDSP,
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
//----------------------------------------------------------------------------------------
function ResetTrace : Boolean;
//----------------------------------------------------- Сбросить структуры набора маршрута
var
  i,k,sp,sig : integer;
begin
  WorkMode.GoTracert  := false; //-------------------- сбросить признак "идет трассировка"
  MarhTrac.SvetBrdr   := 0;//----- сброс индекса светофора,ограждающ. элементарный участок
  MarhTrac.AutoMarh   := false; //--- сброс признака трассир.маршрута автодействия сигнала
  MarhTrac.Povtor     := false; //------ сброс признака повторной проверки трассы маршрута
                                    //- (для снятия контроля предварит. замыкания на АРМе)
  MarhTrac.GonkaStrel := false;//-------- сброс признака допустимости выдачи команды гонки
                                    //  стрелок (для трассы маршрута без замыкания трассы)
  MarhTrac.GonkaList  := 0; //-- сброс количества стрелок для выдачи команды гонки стрелок
  MarhTrac.LockPovtor := false;//---- сброс признака блокировки выдачи повторной установки
                                    //            маршрута после обнаружения враждебностей
  MarhTrac.Finish     := false; //--------- сброс разрешения нажатия кнопки "конца набора"
  MarhTrac.TailMsg    :=  '';  //-------------------- сбросить сообщение в хвосте маршрута
  MarhTrac.FindTail   := false; // сброс признака набора сообщения о конце трассы маршрута
  MarhTrac.WarN   := 0; //----------- сброс счетчика предупреждений при установке маршрута
  MarhTrac.MsgN   := 0; //--------------------------- сброс счетчика сообщений трассировки
  k := 0;
  MarhTrac.VP         := 0; //--------- сбросить объект ВП для трассировки маршрута приема
  MarhTrac.TraSRazdel := false;//----- сброс признака трассировки в раздельном управлении

  if MarhTrac.ObjStart > 0 then //----------------------- если есть объект начала маршрута
  begin //------------------------------------------------ сброс признака ППР на светофоре
    k := MarhTrac.ObjStart;
    if not ObjZv[k].bP[14] then //------------------------ если нет программного замыкания
    //-------------------------------------------- сброс маневровой и поездной трассировки
    begin ObjZv[k].bP[7] := false; ObjZv[k].bP[9] := false; end;
  end;

  MarhTrac.ObjStart := 0;

  for i := 1 to WorkMode.LimitObjZav do
  begin //-------------------------- Сборос признаков трассировки на всех объектах станции
    with ObjZv[i] do
    case TypeObj of
      1: begin bP[27] := false;  iP[3] := 0; end;//------------------------- хвост стрелки
      2: begin bP[10]:= false;bP[11]:= false;bP[12]:= false;bP[13]:= false; end;// стрелка
      3: begin if not bP[14] then bP[8] := true;  end; //-------------------------- секция
      4: begin if not bP[14] then bP[8] := true;  end; //---------------------------- путь
      5: if not bP[14] and bP[11]//светофор нет предварительно и исполнительного замыкания
         then begin bP[7] := false; bP[9] := false; end;
      8: bP[27] := false; //---------------------------------------------------------- УТС
      //- АБ нет предв. и исполнит. замыкания
      15:if not bP[14] and ObjZv[BasOb].bP[2] then bP[15] := false;
      25:if not bP[14] then bP[8] := false; //---- Колонка, нет предварительного замыкания
      //-----------------------------------Стрелка в пути - контроль маршрута отправления
      41 :
      begin
        sp := UpdOb; sig := BasOb; //----------------------------- СП и сигнал отправления
        if not ObjZv[sp].bP[14] and ObjZv[sp].bP[2] and //------------ нет замыканий и ...
        not ObjZv[sig].bP[3] and not ObjZv[sig].bP[4] then //--- сигнал не открыт поездным
        begin bP[20] := false; bP[21] := false; end; //сбросить признаки маршрута и трассы
      end;
      42 :
      begin //-------------------------------------- перезамыкание поездного на маневровый
        sp := UpdOb;     //---------------------------------- контролируемая секция
        if not ObjZv[sp].bP[14] and  ObjZv[sp].bP[2] then //------- нет никакого замыкания
        begin bP[1] := false; bP[2] := false; end; // снять поездной прием и перезамыкание
      end;
    end;
  end;

  with MarhTrac do
  begin
    //------------------------------------------------------------- очистить все сообщения
    for i:= 1 to High(Msg) do begin Msg[i]:= ''; MsgInd[i]:= 0; MsgObj[i]:= 0; end;
    MsgN:= 0;

    //-------------------------------------------------------- очистить все предупреждения
    for i:= 1 to High(War) do begin War[i]:= ''; WarInd[i]:= 0; WarObj[i]:= 0; end;
    WarN := 0;

    //---------------------------------------------------------- очистить все точки трассы
    for i:= 1 to High(ObjTRS) do ObjTRS[i]:= 0; MarhTrac.Counter := 0;

    //-------------------------------------------------------- очистить все стрелки трассы
    for i := 1 to High(StrOtkl) do
    begin StrOtkl[i]:=0; PolTras[i,1]:= false; PolTras[i,2]:= false; end;
    StrCount:= 0;

    ObjEnd := 0; ObjLast := 0; ObjStart := 0; PinLast := 0; Rod := 0;
  end;

  WorkMode.GoTracert := false;

  if (k > 0) and not ObjZv[k].bP[14] then
  begin InsNewMsg(k,2,1,''); ShowSMsg(2,LastX,LastY,'от '+ ObjZv[k].Liter); end;
  ResetTrace := true;
  ZeroMemory(@MarhTrac,sizeof(MarhTrac));
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function ResetMarhrutSrv(fr : word) : Boolean;
//---------------------------------------------------- Реакция на сброс маршрута в сервере
var
  i,im : integer;
begin
  im := 0;
  //------------------------------------------------- поиск индекса маршрута по номеру FR3
  for i := 1 to WorkMode.LimitObjZav do
  if ObjZv[i].TypeObj = 5 then
  begin
    if ObjZv[i].ObCI[3] > 0 then
    if fr = (ObjZv[i].ObCI[3] div 8) then begin im := i; break; end;

    if ObjZv[i].ObCI[5] > 0 then
    if fr = (ObjZv[i].ObCI[5] div 8) then begin im := i; break; end;
  end;

  if im > 0 then // установить сброс маршрута сервера для всех светофоров данного маршрута
  begin
    for i := 1 to WorkMode.LimitObjZav do
    if ObjZv[i].TypeObj = 5 then
    if ObjZv[i].iP[1] = im then ObjZv[i].bP[34] := true;//на светофоры составного маршрута

    if ObjZv[im].RU = config.ru then //--------- вывести сообщение о неисполнении маршрута
    begin MsgStateRM := GetSmsg(2,7,ObjZv[im].Liter,1);  MsgStateClr := 1; end;
    InsNewMsg(im,7+$400,1,'');
    ResetMarhrutSrv := true;
  end else ResetMarhrutSrv := false; //---------------------- индекс маршрута не определен
end;

//========================================================================================
//----------------------------------------------------------------------------------------
procedure InsWar(Obj,Index : SmallInt);
//---------------------------------------------------------- добавить новое предупреждение
begin
  MarhTrac.WarObj[MarhTrac.WarN] := Obj;
  MarhTrac.WarInd[MarhTrac.WarN] := Index;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
procedure InsMsg(Obj,Index : SmallInt);
//----------------------------------------------------- добавить обнаруженную враждебность
begin
  MarhTrac.MsgObj[MarhTrac.MsgN] := Obj;
  MarhTrac.MsgInd[MarhTrac.MsgN] := Index;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
//------------------------------------------ открыть сигнал в раздельном режиме управления
var
  i : Integer;
  jmp : TSos;
begin
  ResetTrace;
  if Marh = MarshM then
  begin
    ObjZv[Svetofor].bP[7] := true;
    ObjZv[Svetofor].bP[9] := false;
  end else
  begin
    ObjZv[Svetofor].bP[7] := false;
    ObjZv[Svetofor].bP[9] := true;
  end;

  MarhTrac.SvetBrdr := Svetofor;
  MarhTrac.Rod := Marh;
  MarhTrac.Finish := false;
  MarhTrac.WarN := 0;
  MarhTrac.MsgN := 0;
  MarhTrac.ObjStart := Svetofor;

  // Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZv[Svetofor].Sosed[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTrac.Level := tlRazdelSign; //---------- режим открыть сигнал в раздельном
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  MarhTrac.FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of

      trStop, trEnd : break;

      trKonec, trBreak : break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    result := false;
    InsNewMsg(Svetofor,228,1,'');
    ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
    MarhTrac.LockPovtor := true; MarhTrac.ObjStart := 0;
    exit;
  end;

  if MarhTrac.MsgN > 0 then
  begin  //--------------------------------------------------------- отказ по враждебности
    MarhTrac.TraSRazdel := true;//---- Закончить трассировку если есть враждебности
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
    result := false;
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  //-------- Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki (Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1); //
    InsWar(MarhTrac.ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- вывод сообщений

    NewMenu_(CmdMarsh_Razdel,LastX,LastY);
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
end;

//========================================================================================
//---------------------- Проверка возможности выдачи команды открытия сигнала автодействия
function CheckAutoMarsh(AvtoS : SmallInt; Grp : Byte) : Boolean;
//------------------------------ AvtoS - объект автодействия для светофора с автодействием
//--------------------------------------------------------------------- Grp - группа КРУ
var
  i, Sig, SP, ZUch : Integer;
  jmp : TSos;
  tr : boolean;
begin
    result := false;
    Sig := ObjZv[AvtoS].BasOb; //-------------------------------- сигнал автодействия
    ZUch := ObjZv[AvtoS].UpdOb; //------------------- защитный участок автодействия
    SP := ObjZv[Sig].BasOb; //--------------- перекрывная секция сигнала автодействия
    //------------------------- проверить наличие противоповторности маршрута автодействия
    if ObjZv[AvtoS].bP[2] then   //--- если противоповтор взведен, значит нет враждебности
    begin
      //----------------------------------------- ожидать готовность маршрута автодействия
      MarhTrac.Rod := MarshP;
      MarhTrac.Finish := false;
      MarhTrac.WarN := 0;
      MarhTrac.MsgN := 0;
      MarhTrac.ObjStart := Sig; //------------------------ светофор с автодействием
      MarhTrac.Counter := 0;

      //- Выдать команду открытия сигнала автодействия в виде раздельного открытия сигнала

      jmp := ObjZv[Sig].Sosed[2]; //----- сосед светофора со стороны 2
      MarhTrac.FindTail := true;
      //--------------------------------- проверить замыкание перекрывной секции светофора

      if ObjZv[SP].bP[2] then //------------------------------- если снято "З" перекрывной
      begin
        //------- снять признак занятия перекрывной секции при отсутствии замыкания секции
        ObjZv[AvtoS].bP[3] := false; //---- сброс признака фикс.занятия СП маршрута автод.
        ObjZv[AvtoS].bP[4] := false;//--- сброс признака фикс.занятия при открытом сигнале
        ObjZv[AvtoS].bP[5] := false;  //---- сброс признака фикс.выдачи сообщ.о неоткрытии
        tr := true;
      end else
      begin
        //----- проверить занятие перекрывной секции после замыкания маршрута автодействия
        tr := false;
        if ObjZv[AvtoS].bP[3] then
        begin //зафиксирована занятость перекрывной СП при установке маршрута автодействия
          if not ObjZv[AvtoS].bP[4] then  // не было фиксации занятия при открытом сигнале
          begin
            if not ObjZv[AvtoS].bP[5] then //--------- не было фиксации неоткрытия сигнала
            begin
              InsNewMsg(Sig,475,1,'');//----------- Сигнал не открыт командой автодействия
              AddFixMes(GetSmsg(1,475,ObjZv[Sig].Liter,1),4,5);
              ObjZv[AvtoS].bP[5] := true;  //------------------ запомнить выдачу сообщения
            end;
          end;
          MarhTrac.ObjStart := 0;
          exit;
        end else//--------------------------------------------------- если секция свободна
        if ObjZv[SP].bP[1] then MarhTrac.Level := tlSignalCirc//режим сигнал.струна
        else //-------------------------------------------------------- если секция занята
        begin
          ObjZv[AvtoS].bP[3] := true; //------------ фиксировать занятие секции в маршруте

          //- поездной сигнал открыт, фиксация занятия перекрывной СП при открытои сигнале
          if ObjZv[Sig].bP[4] then ObjZv[AvtoS].bP[4] := true;

          MarhTrac.ObjStart := 0;
          exit;
        end;
      end;

      if tr then //----------------------------------------- перекрывная секция разомкнута
      begin
        if ObjZv[Sig].bP[9] or ObjZv[Sig].bP[14] then//поездная трасса или прогр.замыкание
         MarhTrac.Level := tlPovtorRazdel //--- режим повтор открытия по замкнутому
         else  MarhTrac.Level := tlRazdelSign;//- режим открыть сигнал в раздельном
      end;

      MarhTrac.AutoMarh := true;
      MarhTrac.SvetBrdr := Sig;
      ObjZv[Sig].bP[9] := true;  //-------------------------- признак поездной трассировки

      i := 1000;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
          trStop, trEnd, trKonec :  break;
        end;
        dec(i);
      end;
      if i < 1 then exit; //------------------------------------ трасса маршрута разрушена

      if MarhTrac.MsgN > 0 then //--------------- есть сообщения о враждебности
      begin MarhTrac.ObjStart := 0; exit; end; //------------ отказ по враждебности
      result := true;
    end else //--------------------------------------------- нет активности противоповтора
    begin //------------------ проверить враждебности по всей трассе маршрута автодействия
      ObjZv[Sig].bP[7] := false; //--------- сброс маневровой трассировки с сигнала начала
      ObjZv[Sig].bP[9] := false; //----------- сброс поездной трассировки с сигнала начала
      MarhTrac.Rod := MarshP;
      MarhTrac.Finish := false;
      MarhTrac.WarN := 0;
      MarhTrac.MsgN := 0;
      MarhTrac.ObjStart := Sig;
      MarhTrac.Counter := 0;

      i := 1000;
      jmp := ObjZv[Sig].Sosed[2];
      MarhTrac.Level := tlAutoTrace; // режим  открыть сигнал в маршр. автодействия

      MarhTrac.FindTail := true;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
          trStop, trEnd, trKonec : break;
        end;
        dec(i);
      end;

      if i < 1 then exit; //------------------------------------ трасса маршрута разрушена

      if MarhTrac.MsgN > 0 then
      begin
        MarhTrac.ObjStart := 0;
        MarhTrac.MsgN := 0;
        exit; //---------------------------------------------------- отказ по враждебности
      end;

      case ObjZv[ZUch].TypeObj of //------------------------------- какой защитный участок
        4 :
        begin //--------------------------------------------------------------------- путь
          if not ObjZv[ZUch].bP[1] or not ObjZv[ZUch].bP[16] then  //- занят четный или НЧ
          begin  MarhTrac.ObjStart := 0;  exit; end; //------------- сброс маршрута
        end;

        15 :
        begin //----------------------------------------------------------------------- АБ
          if not ObjZv[ZUch].bP[2] then   //------------------------------------ занят 1ИП
          begin   MarhTrac.ObjStart := 0;  exit; end;//------------- сброс маршрута
        end;

        else //--------------------------------------------------------------------- СП,УП
          if not ObjZv[ZUch].bP[1] then  //----------------------------------- занят СП/УП
          begin MarhTrac.ObjStart := 0; exit; end; //--------------- сброс маршрута
      end;
      ObjZv[AvtoS].bP[2] := true;//нет вражды по трассе автодействия, ставим противоповтор
    end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
//----------------------------------------- Сделать проверки повторного открытия светофора
var
  i : Integer;
  jmp : TSos;
begin
    ResetTrace;
    MarhTrac.SvetBrdr := Svetofor;
    MarhTrac.Finish := false;
    MarhTrac.Rod := Marh;
    MarhTrac.TailMsg := '';
    MarhTrac.WarN := 0;
    MarhTrac.MsgN := 0;
    MarhTrac.ObjStart := Svetofor;
    //---------------------------------------------- Проверить враждебности по всей трассе
    i := 1000;
    jmp := ObjZv[Svetofor].Sosed[2];
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlSignalCirc;  //----------------- режим сигнальная струна
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTrac.FindTail := true;
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
        trStop, trEnd :  break;
        trKonec :  break;
      end;
      dec(i);
    end;

    if i < 1 then
    begin //---------------------------------------------------- трасса маршрута разрушена
      InsNewMsg(Svetofor,228,1,''); //---------------------- Трасса маршрута от $ нарушена
      result := false;
      ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
      MarhTrac.LockPovtor := true;
      MarhTrac.ObjStart := 0;
      exit;
    end;

    if MarhTrac.MsgN > 0 then
    begin  //------------------------------------------------------- отказ по враждебности
    // Закончить трассировку и сбросить трассу если есть враждебности
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
    result := false;
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;
  //-------- Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsWar(MarhTrac.ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- вывод сообщений
    NewMenu_(CmdMarsh_Povtor,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    MarhTrac.ObjStart := 0;
    exit;
  end;
{$ENDIF}  
  result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
//проверки повторного открытия сигнала (в раздельном) по предварительному замыканию трассы
var
  i : Integer;
  jmp : TSos;
begin
  ResetTrace;
  MarhTrac.SvetBrdr := Svetofor;
  MarhTrac.Finish := false;
  MarhTrac.Rod := Marh;
  MarhTrac.TailMsg := '';
  MarhTrac.WarN := 0;
  MarhTrac.MsgN := 0;
  MarhTrac.ObjStart := Svetofor;
  //------------------------------------------------ Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZv[Svetofor].Sosed[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTrac.Level := tlPovtorRazdel;  //----- режим повтор открытия по замкнутому
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  MarhTrac.FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of

      trStop, trEnd :
        break;

      trKonec :
        break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    InsNewMsg(Svetofor,228,1,'');
    result := false;
    ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  if MarhTrac.MsgN > 0 then
  begin  //--------------------------------------------------------- отказ по враждебности
    //--------------------- Закончить трассировку и сбросить трассу если есть враждебности
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
    result := false;
    MarhTrac.LockPovtor := true;
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    MarhTrac.ObjStart := 0;
    exit;
  end;

  //-------- Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsWar(MarhTrac.ObjStart,333);
  end;
  
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- вывод сообщений
    NewMenu_(CmdMarsh_PovtorOtkryt,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    MarhTrac.ObjStart := 0;
    exit;
  end;
{$ENDIF}
  result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
//-------------------------------------------------- Выполнить повторную устаноку маршрута
var
  i,j : Integer;
  jmp : TSos;
begin
    ResetTrace;
    MarhTrac.SvetBrdr := Svetofor;
    MarhTrac.Finish := false;
    MarhTrac.Rod := Marh;
    MarhTrac.TailMsg := '';
    MarhTrac.WarN := 0; MarhTrac.MsgN := 0;
    MarhTrac.ObjStart := Svetofor;
    //---------------------------------------------- Проверить враждебности по всей трассе
    i := 1000;
    jmp := ObjZv[Svetofor].Sosed[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlPovtorMarh; //------- режим повторная установка маршрута
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTrac.FindTail := true;

    while i > 0 do
    begin
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
        trStop, trEnd : break;
        trKonec : break;
      end;
      dec(i);
    end;

    if i < 1 then
    begin //---------------------------------------------------- трасса маршрута разрушена
      InsNewMsg(Svetofor,228,1,''); //-------------------- "Трасса маршрута от $ нарушена"
      result := false;
      ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
      MarhTrac.LockPovtor := true;
      MarhTrac.ObjStart := 0;
      exit;
    end;

    if MarhTrac.MsgN > 0 then
    begin  //------------------------------------------------------- отказ по враждебности
      //------------------- Закончить трассировку и сбросить трассу если есть враждебности
      InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
      PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
      result := false;
      MarhTrac.LockPovtor := true;
      MarhTrac.ObjStart := 0;
      exit;
    end;

    //---------------------------------------------- Проверить враждебности по всей трассе
    i := 1000;
    MarhTrac.SvetBrdr := Svetofor;
    MarhTrac.Povtor := true;
    MarhTrac.MsgN := 0;
    //----------- "хвостом" навязывается объект, расположенный следом за сигналом маршрута
    MarhTrac.HTail := MarhTrac.ObjTRS[1];
    jmp := ObjZv[MarhTrac.ObjStart].Sosed[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlCheckTrace;//---- режим проверка враждебностей по трассе 
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    if MarhTrac.ObjEnd < 1 then
    begin
        j := MarhTrac.ObjTRS[MarhTrac.Counter];
        MarhTrac.ObjEnd := j;
    end
    else  j := MarhTrac.ObjEnd;

    while MarhTrac.ObjEnd < 1 do
    begin
      j := MarhTrac.ObjTRS[j];
      MarhTrac.ObjEnd := j;
      dec(j);
    end;


    MarhTrac.CIndex := 1;
    while i > 0 do
    begin
      if jmp.Obj = j then
      begin // Обнаружен объект конца трассы
        // Враждебности в хвосте
      StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);
      break;
    end;

    case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
      trStop : begin
        break;
      end;
    end;
    dec(i);
    inc(MarhTrac.CIndex);
  end;

  if i < 1 then
  begin // отказ по превышению счетчика
    InsNewMsg(Svetofor,231,1,'');
    RestorePrevTrace; result := false;
    ShowSMsg(231, LastX, LastY, '');
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  if MarhTrac.MsgN > 0 then
  begin  //--------------------------------------------------------- отказ по враждебности
    //--------------------- Закончить трассировку и сбросить трассу если есть враждебности
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[Grp]);
    result := false;
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  //-------- Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsWar(MarhTrac.ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- вывод сообщений
    NewMenu_(CmdMarsh_PovtorMarh,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
end;

//========================================================================================
// Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках (для ДСП)
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
//--------------------------------- Svetofor - индекс проверяемого сигнала начала маршрута
//------------------------------------------ Marh - тип маршрута (поездной или маневровый)
//---------------------- возвращает  признак незамкнутых стрелок &  признак занятых секций
var
  i : integer;
  jmp : TSos;
begin
    result := false;
    if Svetofor < 1 then exit;
    i := 1000; //--------------------------------------- установить предельное число шагов
    MarhTrac.IzvStrNZ := false;//- сброс наличия незамкнутых стрелок перед маршрутом
    MarhTrac.IzvStrFUZ := false; // сброс признака занятости участка первым составом
    MarhTrac.IzvStrUZ := false;//сброс признака наличия занятых секций на предмаршр.

    MarhTrac.ObjStart := Svetofor; //----- начинаем смотреть от открываемого сигнала

    jmp := ObjZv[Svetofor].Sosed[1]; //------------------------- сосед перед сигналом

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlFindIzvStrel;//-- режим "проверка незамк. предмарш. стрелок"
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    while i > 0 do //--------------------------------------------- выполнить цикл проверки
    begin
      //------------------------------------------------ переключатель по результатам шага
      case StepTrace(jmp, MarhTrac.Level, MarhTrac.Rod,0) of
        trStop, //----- результат шага = конец трассировки из-за обнаружения враждебностей
        trEnd,  //-------------------------------------- или - конец трассировки фрагмента
        trBreak : //-------------------------- или - приостановить продвижение по объектам
        begin
          //------------ результат = признак незамкнутых стрелок и  признак занятых секций
          result := MarhTrac.IzvStrNZ and MarhTrac.IzvStrUZ;
          if result then //----------------------------------------- если есть то и другое
          begin //-------------------------------------------------- выдать предупреждение
            SBeep[1] := true;
{$IFNDEF TABLO}
            TimeLockCmdDsp := LastTime;
{$ENDIF}
            LockComDsp := true;
            ShowWarning := true;
          end;
          break;
        end;
      end;
      dec(i);
    end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function GetSoglOtmeny(Uslovie : SmallInt) : string;
//------------------------------------------ получение признака разрешения отмены маршрута
begin
    result := '';
    if Uslovie > 0 then
    begin //-------------------------------------- проверить разрешение на отмену маршрута
      case ObjZv[Uslovie].TypeObj of //---------------------------- если условие типа ...
        30 :
        begin //------------------------------------------- дача согласия поездного приема
          if ObjZv[Uslovie].bP[2] then  //--- если "И"
          //------------------------------------- замкнут маршрут до (светофора увязки)...
          result := GetSmsg(1,254,ObjZv[ObjZv[Uslovie].BasOb].Liter,1);
        end;

      33 :
      begin //---------------------------------------------------------- дискретный датчик
        if ObjZv[Uslovie].ObCB[1] then  //-------------------- если датчик инверсный
        begin
          if ObjZv[Uslovie].bP[1] then   //------------------- если датчик установлен
          result := MsgList[ObjZv[Uslovie].ObCI[3]]; //------ сообщить об отключении
        end else
        begin
          if ObjZv[Uslovie].bP[1] then
          result := MsgList[ObjZv[Uslovie].ObCI[2]]; //-------- сообщить о включении
        end;
      end;

      38 :
      begin //------------------------------------------------------------ маршрут надвига
        if ObjZv[Uslovie].bP[1] then    //-------------------------------- если В ???
        //----------------------------------------------- установлен маршрут надвига с ...
        result := GetSmsg(1,346,ObjZv[ObjZv[Uslovie].BasOb].Liter,1);
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
//------------------------ Получить состояние известителя при отмене маршрута (Только ДСП)
//-------------------------------------  Svetofor - индекс светофораt; Marh - тип маршрута

var
  i : integer;
  jmp : TSos;
begin
    result := 0;
    if Svetofor < 1 then exit; //------------------------------ не указан светофор - выйти
    MarhTrac.Rod := Marh;
    case Marh of
      MarshP :  //------------------------------------------------------- поездной маршрут
      begin
        //------------------------------------------ проверить схему поездного известителя
        if ObjZv[Svetofor].ObCI[27] > 0 then //------ если есть поездной известитель
        begin
          if ObjZv[ObjZv[Svetofor].ObCI[27]].bP[1] then//если известитель занят
          begin result := 1; exit; end;//--------- Поезд на предмаршрутном участке - выйти
        end;
        //---------------------------------------------- пройти по предмаршрутному участку
        if ObjZv[Svetofor].ObCB[19] //---- если предмаршрутный короткий для поездных
        then MarhTrac.IzvCount := 0   //----------------------- то блок-участков нет
        else MarhTrac.IzvCount := 1; //------ если не короткий, то блок-участок один
      end;

      MarshM : //------------------------------------------------------ маневровый маршрут
      begin
        if ObjZv[Svetofor].ObCB[20]  //- если предмаршрутный короткий для маневровых
        then MarhTrac.IzvCount := 0 //------------------------- то блок-участков нет
        else MarhTrac.IzvCount := 1; //------ если не короткий, то блок-участок один
      end;

      else MarhTrac.IzvCount := 1; //---- для прочих маршрутов блок-участок один ???
    end;

    if not ObjZv[Svetofor].bP[2] and  //------------ если нет МС2 и нет С2 , то выйти
    not ObjZv[Svetofor].bP[4]
    then exit; //----------------------------------------------------------- сигнал закрыт

    i := 1000;
    jmp := ObjZv[Svetofor].Sosed[1]; //--------------------- начальная точка маршрута

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlFindIzvest;//- режим сбор известителя перед отменой маршрута
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    while i > 0 do
    begin
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
      trStop, trEnd : break;

      trBreak :
      begin
        //------------------------------------- проверить местонахождение занятого участка
        if MarhTrac.IzvCount < 2 then
        begin //--------------------------------------------------- предмаршрутный участок
          if ObjZv[jmp.Obj].TypeObj = 26 then result := 3
          else

          if ObjZv[jmp.Obj].TypeObj = 15 then result := 3
          else result := 1;
        end
        else  result := 2; //------------------------------------------- поезд на маршруте
        SBeep[1] := true;
{$IFNDEF TABLO}
        TimeLockCmdDsp := LastTime;
{$ENDIF}
        LockComDsp := true;
        ShowWarning := true;
        break;
      end;
    end;
    dec(i);
  end;
end;

//========================================================================================
//----------------------------------- Выдать команду отмены маршрута в сервер (Только ДСП)
function OtmenaMarshruta(Svetofor:SmallInt; Marh:Byte) : Boolean;
var
  index,i : integer;
  jmp : TSos;
begin
{$ifndef TABLO}
  result := false;
    //--------------------------- маршрут замкнут исполнительными устройствами или сервером}
    index := Svetofor;
    MarhTrac.TailMsg := '';
    MarhTrac.ObjStart := Svetofor;
    MarhTrac.Rod := Marh;
    MarhTrac.Finish := false;
    if ObjZv[ObjZv[MarhTrac.ObjStart].BasOb].bP[2] then
    begin
      //--------------------------------------------- снять блокировки головного светофора
      ObjZv[MarhTrac.ObjStart].bP[14] := false;
      ObjZv[MarhTrac.ObjStart].bP[7] := false;
      ObjZv[MarhTrac.ObjStart].bP[9] := false;
    end;
    i := 1000;
    jmp := ObjZv[MarhTrac.ObjStart].Sosed[2]; // начальная точка

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlOtmenaMarh;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    //------------------------------------------------ снять блокировки элементов маршрута
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
        trStop, trEnd : break;
      end;
      dec(i);
    end;

    //----------------------------------------------------- Выдать команду отмены маршрута
    case Marh of
      MarshM :
      begin
        if SendCommandToSrv(ObjZv[index].ObCI[3] div 8, _svzakrmanevr, index)
        then
        begin
          InsNewMsg(Index,24,7,'');
          ShowSMsg(24, LastX, LastY, ObjZv[index].Liter);
          result := true;
        end;
      end;

      MarshP :
      begin
        if SendCommandToSrv(ObjZv[index].ObCI[5] div 8, _svzakrpoezd, index)
        then
        begin
          InsNewMsg(Index,25,7,'');
          ShowSMsg(25, LastX, LastY, ObjZv[index].Liter);
          result := true;
        end;
      end;
    end;
    MarhTrac.ObjStart := 0;
{$endif}
end;

//========================================================================================
//--------------------------------------------------------------- Замкнуть трассу маршрута
function SetProgramZamykanie(Grp : Byte; Auto : Boolean) : Boolean;
var
  jmp : TSos;
  i,j,k,obj_tras,Sig_End : integer;
begin
    k := 0;
    //-------------------------------- Установить программное замыкание элементов маршрута
    MarhTrac.SvetBrdr := MarhTrac.ObjStart;//запомнить светофор начала
    MarhTrac.Finish := false;    //------------- конец набора пока нажать нельзя
    MarhTrac.TailMsg := '';      //------ сообщения о "хвосте" маршрута пока нет
    ObjZv[MarhTrac.ObjStart].bP[14] := true; //- программно замкнуть сигнал

    ObjZv[MarhTrac.ObjStart].iP[1] :=
    MarhTrac.ObjStart; //----------------------------- запомнить начало маршрута

    i := MarhTrac.Counter; //---------------- запомнить число элементов маршрута

    jmp := ObjZv[MarhTrac.ObjStart].Sosed[2]; //----------- сосед в точке 2

    //############## К О М П Ь Ю Т Е Р Н О Е  З А М Ы К А Н И Е ##########################
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlZamykTrace; // этап трассировки = компьютерное замыкание
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTrac.FindTail := true; //--------------- признак набора для конца трассы
    j := MarhTrac.ObjEnd;

    if ObjZv[j].TypeObj <> 5 then
    begin
      k := 1;
      obj_tras := MarhTrac.ObjTRS[i];
      while ((ObjZv[obj_tras].TypeObj <> 5) and (k <> i)) do
      begin
        obj_tras := MarhTrac.ObjTRS[i-k];
        inc(k);
      end;
    end
    else obj_tras := j;

    if (k > 0) and (i <> k) then MarhTrac.ObjEnd := obj_tras;
    Sig_End := obj_tras;
    if ObjZv[Sig_End].TypeObj = 5 then
    begin
      if ((MarhTrac.Rod = MarshP) and not ObjZv[Sig_End].ObCB[5])
      or((MarhTrac.Rod = MarshM) and
      not(ObjZv[Sig_End].ObCB[7] or ObjZv[Sig_End].ObCB[8])) then
      begin
        obj_tras := MarhTrac.ObjStart;
        ObjZv[obj_tras].bP[9] := false;
        ObjZv[obj_tras].bP[7] := false;
        ObjZv[obj_tras].bP[14] := false;
        ResetTrace;
        InsNewMsg(obj_tras,77,1,'');
        ShowSMsg(77, LastX, LastY, ObjZv[obj_tras].Liter);
        result := false;
        exit;
      end;
    end;
    

    MarhTrac.CIndex := 1; //----------------- проверяемый объект первый в трассе
    if j < 1 then j := MarhTrac.ObjTRS[MarhTrac.Counter];
    while i > 0 do
    begin
      if jmp.Obj = j then //-------------------------------- Обнаружен объект конца трассы
      begin
        case ObjZv[jmp.Obj].TypeObj of
          //-------------------------- стрелка в конце трассы маршрута необходимо замкнуть
          2 : StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);

          5 : //-------------------------------------------------- светофор в конце трассы
          begin
            //попали в тчк 2,значит встречный в конце трассы маршрута, необходимо замкнуть
            if jmp.Pin = 2 then
            StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0)
            else //------------------------ если не точка 2, то попутный светофор в хвосте
            if MarhTrac.FindTail //-------------- если хвост маршрута ещё пустой
            then MarhTrac.TailMsg:=' до '+ObjZv[jmp.Obj].Liter;//хвост маршрута
          end;

          //------------------------------- АБ в конце трассы маршрута необходимо замкнуть
          15 : StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);

          30 : //------------------------------------------ объект дачи поездного согласия
          begin
            if MarhTrac.FindTail// если нужно искать хвост, то это сигнал увязки
            then MarhTrac.TailMsg:=' до '+ObjZv[ObjZv[jmp.Obj].BasOb].Liter;
          end;

          //------------------------------------------------------- объект увязки с горкой
          32 : MarhTrac.TailMsg:=' до '+ ObjZv[jmp.Obj].Liter;//Надвиг на горку
        end;
        break; //---------------------------- выход из цикла при достижении конца маршрута
      end;
      //----- если конец трассы еще не достигнут то делаем очередной шаг и анализируем его
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
        trStop, trEnd : //если вышли на враждебность или конец фрагмента, то прервать цикл
        begin i := -1; break; end;
      end;
      dec(i); //---------------------------- уменьшаем число оставшихся элементов маршрута
      inc(MarhTrac.CIndex); //------------------- переходим на следующий элемент
    end;

    if (i < 1) and not Auto then
    begin // отказ по разрушению трассы
      ResetTrace;
      result := false;
      InsNewMsg(MarhTrac.ObjStart,228,1,'');
      ShowSMsg(228, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
      exit;
    end;
    result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function SendMarshrutCommand(Grp : Byte) : Boolean;
var
  i,j : integer;
  os,oe : SmallInt;
begin
     MarhTrac.Finish := false;
     //--------------------------------------------------- сформировать маршрутную команду
     for i := 1 to 10 do MarhTrac.MarhCmd[i] := 0;

     if ObjZv[MarhTrac.ObjStart].TypeObj = 30 then
     os := ObjZv[ObjZv[MarhTrac.ObjStart].BasOb].ObCI[5] div 8
     else
     if ObjZv[MarhTrac.ObjStart].ObCI[3] > 0 then
     os := ObjZv[MarhTrac.ObjStart].ObCI[3] div 8
     else os := ObjZv[MarhTrac.ObjStart].ObCI[5] div 8;

     if ObjZv[MarhTrac.ObjEnd].TypeObj = 30 then
     oe := ObjZv[ObjZv[MarhTrac.ObjEnd].BasOb].ObCI[5] div 8
     else
     if ObjZv[MarhTrac.ObjEnd].TypeObj = 24 then
     oe := ObjZv[MarhTrac.ObjEnd].ObCI[13] div 8
     else
     if ObjZv[MarhTrac.ObjEnd].TypeObj = 26 then
     oe := ObjZv[ObjZv[MarhTrac.ObjEnd].BasOb].ObCI[4] div 8
     else
     if ObjZv[MarhTrac.ObjEnd].TypeObj = 32 then
     oe := ObjZv[ObjZv[MarhTrac.ObjEnd].BasOb].ObCI[2] div 8
     else
     if ObjZv[MarhTrac.ObjEnd].ObCI[3] > 0 then
     oe := ObjZv[MarhTrac.ObjEnd].ObCI[3] div 8
     else
     if ObjZv[MarhTrac.ObjEnd].ObCI[5] > 0 then
     oe := ObjZv[MarhTrac.ObjEnd].ObCI[5] div 8
     else
     oe := ObjZv[MarhTrac.ObjEnd].ObCI[7] div 8;

     MarhTrac.MarhCmd[1] := os;
     MarhTrac.MarhCmd[2] := os div 256;
     MarhTrac.MarhCmd[3] := oe;
     MarhTrac.MarhCmd[4] := oe div 256;
     MarhTrac.MarhCmd[5] := MarhTrac.StrCount;

     case MarhTrac.Rod of // установить категорию маршрута
      MarshM :
      begin
        if MarhTrac.Povtor then
        MarhTrac.MarhCmd[10] := _povtormarhmanevr
        else MarhTrac.MarhCmd[10] := _marshrutmanevr;
        tm := 'маневрового';
      end;

      MarshP :
      begin
        if MarhTrac.Povtor then
        MarhTrac.MarhCmd[10] := _povtormarhpoezd
        else MarhTrac.MarhCmd[10] := _marshrutpoezd;
        tm := 'поездного';
      end;

      MarshL :
      begin
        MarhTrac.MarhCmd[10] := _marshrutlogic;
        tm := 'логического';
      end;
    end;

    if MarhTrac.StrCount > 0 then
    begin
      for i := 1 to MarhTrac.StrCount do
      begin
        if MarhTrac.PolTras[i,2] then
        begin
          case i of
            1 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 1;
            2 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 2;
            3 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 4;
            4 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 8;
            5 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 16;
            6 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 32;
            7 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 64;
            8 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 128;
            9 :  MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 1;
            10 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 2;
            11 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 4;
            12 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 8;
            13 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 16;
            14 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 32;
            15 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 64;
            16 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 128;
            17 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 1;
            18 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 2;
            19 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 4;
            20 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 8;
            21 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 16;
            22 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 32;
            23 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 64;
            24 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 128;
          end;
        end;
      end;
    end;

    CmdSendT := LastTime;
    WorkMode.MarhRdy := true;
    InsNewMsg(MarhTrac.ObjStart,5,7,'');

    ShowSMsg(5, LastX, LastY, tm + ' маршрута от '+
    ObjZv[MarhTrac.ObjStart].Liter+ MarhTrac.TailMsg);

    LastMsgToDSP := ObjZv[MarhTrac.ObjStart].Liter+ MarhTrac.TailMsg;

    CmdBuff.LastObj := MarhTrac.ObjStart;

    //-------------------------------------------------------- сброс структуры трассировки

    MarhTrac.ObjStart := 0;
    MarhTrac.PutPriem := 0;
    for i := MarhTrac.Counter downto 1 do
    begin
      j := MarhTrac.ObjTRS[i];
      if (ObjZv[j].TypeObj = 4)then
      begin
        MarhTrac.PutPriem := j;
        break;
      end;
    end;

    for i := 1 to High(MarhTrac.ObjTRS) do MarhTrac.ObjTRS[i] := 0;
    MarhTrac.Counter := 0;
    for i := 1 to High(MarhTrac.StrOtkl) do
    begin
      MarhTrac.StrOtkl[i] := 0;
      MarhTrac.PolTras[i,1] := false;
      MarhTrac.PolTras[i,2] := false;
    end;
    MarhTrac.StrCount := 0;
    MarhTrac.ObjEnd := 0;
    MarhTrac.ObjLast := 0;
    MarhTrac.PinLast := 0;
    MarhTrac.ObjPrev := 0;
    MarhTrac.PinPrev := 0;
    MarhTrac.Rod := 0;
    MarhTrac.Povtor := false;
    WorkMode.GoTracert := false;
    WorkMode.CmdReady  := true; //-------- Запрет маршрутных команд до получения квитанции
    result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function SendTraceCommand(Grp : Byte) : Boolean;
//--------------------------------------------- Выдать команду установки маршрута в сервер
var
  i,baza : integer;
  os,oe : SmallInt;
begin
    if (MarhTrac.GonkaList = 0) or //если все стрелки трассы установлены или ...
    not MarhTrac.GonkaStrel then //------ или перевод стрелок трассы не допустим
    begin
      ResetTrace;
      result := false;
      exit;
    end;
    MarhTrac.Finish     := false;  //Разрешение нажать кнопку конца набора снять
    MarhTrac.GonkaStrel := false;
    MarhTrac.GonkaList  := 0;

    //--------------------------------------------------------------- сформировать команду
    for i := 1 to 10 do MarhTrac.MarhCmd[i] := 0; //---- очистить массив команды

    baza := ObjZv[MarhTrac.ObjStart].BasOb; //--- взять базовый для начала

    if ObjZv[MarhTrac.ObjStart].TypeObj = 30 then //если начало "дача согласия"
    os := ObjZv[baza].ObCI[5] div 8 //----- индекс датчика С2 светофора увязки в FR3
    else

    if ObjZv[MarhTrac.ObjStart].ObCI[3] > 0 then  //-------- если есть МС2
    os := ObjZv[MarhTrac.ObjStart].ObCI[3] div 8 //------ индекс МС2 в FR3

    else
    os := ObjZv[MarhTrac.ObjStart].ObCI[5] div 8; //------ индекс С2 в FR3

    baza := ObjZv[MarhTrac.ObjEnd].BasOb;  //--------- взять базовый конца

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 30 then // если конец - "дача согласия"
    oe := ObjZv[baza].ObCI[5] div 8 //------- индекс датчика C2 сигнала увязки в FR3
    else

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 24 then//если конец - увязка с запросом
    oe := ObjZv[MarhTrac.ObjEnd].ObCI[13] div 8//- МС сигнала парка соседа
    else

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 26 then//---- если конец - увязка с ПАБ
    oe := ObjZv[baza].ObCI[4] div 8 //--- индекс датчика C1 входного светофора в FR3
    else

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 32 then // если конец - увязка с горкой
    oe := ObjZv[baza].ObCI[2] div 8 // индекс для МC1 маневр.светофора с горки в FR3
    else

    if ObjZv[MarhTrac.ObjEnd].ObCI[3] > 0 then  //-- если у конца есть МС2
    oe := ObjZv[MarhTrac.ObjEnd].ObCI[3] div 8 //-------- индекс МС2 в FR3
    else

    if ObjZv[MarhTrac.ObjEnd].ObCI[5] > 0 then //---- если у конца есть С2
    oe := ObjZv[MarhTrac.ObjEnd].ObCI[5] div 8  //-------- индекс С2 в FR3
    else

    oe := ObjZv[MarhTrac.ObjEnd].ObCI[7] div 8; //--- иначе что это ??????

    MarhTrac.MarhCmd[1] := os;
    MarhTrac.MarhCmd[2] := os div 256;
    MarhTrac.MarhCmd[3] := oe;
    MarhTrac.MarhCmd[4] := oe div 256;
    MarhTrac.MarhCmd[5] := MarhTrac.StrCount;
    MarhTrac.MarhCmd[10] := _ustanovkastrelok;

    if MarhTrac.StrCount > 0 then //если есть стрелки, то упаковать их положение
    begin
      for i := 1 to MarhTrac.StrCount do
      begin
        if MarhTrac.PolTras[i,2] then
        begin
          case i of
            1 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 1;
            2 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 2;
            3 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 4;
            4 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 8;
            5 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 16;
            6 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 32;
            7 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 64;
            8 :  MarhTrac.MarhCmd[6] := MarhTrac.MarhCmd[6] + 128;
            9 :  MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 1;
            10 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 2;
            11 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 4;
            12 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 8;
            13 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 16;
            14 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 32;
            15 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 64;
            16 : MarhTrac.MarhCmd[7] := MarhTrac.MarhCmd[7] + 128;
            17 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 1;
            18 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 2;
            19 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 4;
            20 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 8;
            21 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 16;
            22 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 32;
            23 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 64;
            24 : MarhTrac.MarhCmd[8] := MarhTrac.MarhCmd[8] + 128;
          end;
        end;
      end;
    end;

    CmdSendT := LastTime;

    WorkMode.MarhRdy := true;

    InsNewMsg(MarhTrac.ObjStart,5,7,'');
    tm := GetSmsg(1,5, ' стрелок по трассе маршрута от '+ //- Выдана команда установки
    ObjZv[MarhTrac.ObjStart].Liter + MarhTrac.TailMsg,7);

    LastMsgToDSP := ObjZv[MarhTrac.ObjStart].Liter+ MarhTrac.TailMsg;

    CmdBuff.LastObj := MarhTrac.ObjStart;

    //-------------------------------------------------------- сброс структуры трассировки
    ResetTrace;
    PutSMsg(2,LastX,LastY,tm); //----------------------------------- Трасса $ сброшена
    WorkMode.CmdReady  := true; //-------- Запрет маршрутных команд до получения квитанции
    result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
var
  cvet : integer;
//----------------------------------------------- инициировать начало трассировки маршрута
begin
    ResetTrace; //------------------------------------- сброс любой ранее набранной трассы
    case command of
      M_BeginMarshManevr :  //---------------------------- начать маневровый маршрут
      begin
        MarhTrac.Rod := MarshM;
        ObjZv[index].bP[7] := true; //------------------------- установить признак НМ
        cvet := 7;
      end;

      M_BeginMarshPoezd :  //------------------------------- начать поездной маршрут
      begin
        MarhTrac.Rod := MarshP;
        ObjZv[index].bP[9] := true; //-------------------------- установить признак Н
        cvet := 2;
      end;

      else
        InsNewMsg(MarhTrac.ObjStart,32,1,''); //"Обнаружен неизвестный тип маршрута"
        result := false;
        ShowSMsg(32,LastX,LastY,ObjZv[MarhTrac.ObjStart].Liter);
        exit;
    end;
    WorkMode.GoTracert := true; //-------------------------- объявить трассировку активной
    MarhTrac.AutoMarh := false; //---------------- сбросить трассировку автодействия
    MarhTrac.MsgN := 0; MarhTrac.WarN := 0;
    MarhTrac.ObjStart := index; //---------- начинаем трассировку с первого нажатого
    MarhTrac.ObjLast := index; //--------------- считаем, что этот объект и последий
    MarhTrac.PinLast := 2; //--------------------------- начало поиска за светофором
    MarhTrac.ObjPrev := MarhTrac.ObjLast;
    MarhTrac.PinPrev := MarhTrac.PinLast;
    InsNewMsg(MarhTrac.ObjStart,78,cvet,''); //---------- введите трассу маршрута от
    ShowSMsg(78,LastX,LastY,ObjZv[MarhTrac.ObjStart].Liter);
    result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function RestorePrevTrace : Boolean;
//----------------------------- Восстановить трассу до последней существующей конфигурации
var
  i : integer;
begin
    i := MarhTrac.Counter; //------------------------------- число объектов в трассе

    while i > 0 do
    begin
      if MarhTrac.ObjTRS[i] = MarhTrac.ObjPrev then break //- если вернулись
      else //------------------------------ пока не найдена последняя удачная точка трассы
      begin
        if ObjZv[MarhTrac.ObjTRS[i]].TypeObj = 2 then //--- если вышли на стрелку
        begin //----------------------------------- сбросить параметры трассировки стрелки
          ObjZv[MarhTrac.ObjTRS[i]].bP[10] := false;
          ObjZv[MarhTrac.ObjTRS[i]].bP[11] := false;
          ObjZv[MarhTrac.ObjTRS[i]].bP[12] := false;
          ObjZv[MarhTrac.ObjTRS[i]].bP[13] := false;
        end;
        MarhTrac.ObjTRS[i] := 0; //----------------------- убрать объект из трассы
      end;
      dec(i);
    end;

    MarhTrac.Counter := i; //---------------- теперь в трассе меньшее число объектов
    MarhTrac.ObjLast := MarhTrac.ObjPrev; //---- восстановим индекс последнего
    MarhTrac.PinLast := MarhTrac.PinPrev; //----- восстановим точку последнего
    MarhTrac.MsgN := 0;
    RestorePrevTrace := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function EndTracertMarshrut : Boolean;
//------------------------------------------------------- функция завершения набора трассы
begin
    if MarhTrac.Counter < 1 then //------------------- если в маршруте нет элементов
    begin result := false; exit; end
    else
    if MarhTrac.ObjEnd < 1 then //------------------ если нет объекта конца маршрута
    begin //-------------------- переключатель по типу последнего элемента трассы маршрута
      case ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].TypeObj of

        5,15,26,30 :// если это сигнал,АБ,ПАБ или "согласие", то это и есть конец маршрута
        MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];

        else  result := false; exit; //---------------------------- иначе выход с неудачей
      end;
    end;

    //-------------------------------------------------------- если сигнал попутный и ....
    if (ObjZv[MarhTrac.ObjLast].TypeObj = 5) and (MarhTrac.PinLast = 2) and
    //--- не открыты ни маневровый 1-го или 2-го каскада ни поездной 1-го или 2-го каскада
    not (ObjZv[MarhTrac.ObjLast].bP[1] or ObjZv[MarhTrac.ObjLast].bP[2] or
    ObjZv[MarhTrac.ObjLast].bP[3] or ObjZv[MarhTrac.ObjLast].bP[4]) then
    begin
      if ObjZv[MarhTrac.ObjLast].bP[5] then //---------- если не норма огневого
      begin //----------------------------- Маршрут не прикрыт запрещающим огнем попутного
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        //---------------------------- "Маршрут не огражден.Неисправен запрещающий огонь."
        GetSmsg(1,115, ObjZv[MarhTrac.ObjLast].Liter,1);
        InsWar(MarhTrac.ObjLast,115);
      end;

      //----------- Проверить открытие впереди стоящего сигнала если короткий блок-участок
      case MarhTrac.Rod of
        MarshP :    //----------------------------------------------------- маршрут поездной
        begin
          //-------------------------- если короткий предмаршрутный участок поездной и ...
          if ObjZv[MarhTrac.ObjLast].ObCB[19] and
          not ObjZv[MarhTrac.ObjLast].bP[4] then //--- нет 2-го каскада поездного
          begin
            InsNewMsg(MarhTrac.ObjLast,391,1,'');//----------------- "сигнал закрыт"
            ShowSMsg(391,LastX,LastY, ObjZv[MarhTrac.ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        MarshM :  //---------------------------------------------------- маршрут маневровый
        begin
          //------------------------ если короткий предмаршрутный участок маневровый и ...
          if ObjZv[MarhTrac.ObjLast].ObCB[20] and
          not ObjZv[MarhTrac.ObjLast].bP[2] then //- нет 2-го каскада маневрового
          begin
            InsNewMsg(MarhTrac.ObjLast,391,1,'');//----------------- "сигнал закрыт"
            ShowSMsg(391,LastX,LastY, ObjZv[MarhTrac.ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        else  result := false; exit; //---------------------- других маршрутов быть не может
      end;
    end;

    //------ Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
    if FindIzvStrelki(MarhTrac.ObjStart, MarhTrac.Rod) then //-------- если есть
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      //- предупреждение "Внимание есть незамкнутые стрелки предмаршрутного участка сигнала"
      GetSmsg(1,333, ObjZv[MarhTrac.ObjStart].Liter,1);
      InsWar(MarhTrac.ObjStart,333);
    end;
    MarhTrac.Finish := true;
    result := true;
end;
{$IFNDEF RMARC}

//========================================================================================
//----------------------------------------------------------------------------------------
function AddToTracertMarshrut(index : SmallInt) : Boolean;
//--------------------------- Сделать трассировку до следующей точки, указанной оператором
var i,j,nextptr : integer;
begin
    if (index = MarhTrac.ObjStart) or (index = MarhTrac.ObjEnd)
    or (ObjZv[index].TypeObj = 3) then
    begin
      InsNewMsg(MarhTrac.ObjStart,1,7,''); //------- "продолжайте набор маршрута от"
      ShowSMsg(1, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
      if (ObjZv[index].TypeObj = 3) then result := NextToTracertMarshrut(index)
      else result := false;
      exit;
    end;

    for i := 1 to MarhTrac.Counter do
    if MarhTrac.ObjTRS[i] = index then
    begin //------------------------- если объект уже в трассе - запросить следующую точку
      InsNewMsg(MarhTrac.ObjStart,1,7,'');
      ShowSMsg(1, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
      result := false;
      exit;
    end;

    //--------------------------------------------------------- найти запись в списке АКНР
    for i := 1 to High(AKNR) do
    begin
      if (AKNR[i].ObjStart = 0) or (AKNR[i].ObjEnd = 0) then break
      else
      begin
        if (AKNR[i].ObjStart = MarhTrac.ObjLast) and (AKNR[i].ObjEnd = index) then
        for j := 1 to High(AKNR[i].ObjAuto) do
        begin
          if AKNR[i].ObjAuto[j] = 0 then break
          else
          begin
            nextptr := AKNR[i].ObjAuto[j]; result := NextToTracertMarshrut(nextptr);
            if not result then exit;
          end;
        end;
      end;
    end;
    result := NextToTracertMarshrut(index);
end;

//========================================================================================
//----------------------------------------------------- Продлить трассу до следующей точки
function NextToTracertMarshrut(index : SmallInt) : Boolean;
//------------------- index - индекс объекта, заданного нажатием следующего объекта экрана
var
  i,j,c,k,wc,oe,strelka,signal,Put,Nomer  : Integer;
  jmp : TSos;
  TST_TRAS : TTrRes;
  b,res : boolean;
begin
    signal := 0;
    MarhTrac.FindNext := false;//----- Признак-требование проверки возможности продолжения
    MarhTrac.LvlFNext := false;//----- Признак процедур поиска трассы для следующего марш.
    MarhTrac.Dobor    := false;//---------- Признак проверки возможности "добора" маршрута
    MarhTrac.HTail    := index; //------------------- "хвост" трассы, указанный оператором
    MarhTrac.FullTail := false; //----------------  Признак полноты добора хвоста маршрута
    MarhTrac.VP := 0; //------------------------------- объект маршрута для стрелки в пути
    MarhTrac.TailMsg  := ''; //--------- сообщение о конце маршрута ("за" сигнал или "до")
    MarhTrac.FindTail := true; //----------------- признак проверки продолжения, если "за"
    LastJmp.TypeJmp := 0; LastJmp.Obj := 0; LastJmp.Pin := 0;

    if WorkMode.GoTracert and not WorkMode.MarhRdy then //идет трассировка,маршр. не готов
    begin
      result := true;
      if (index = MarhTrac.ObjLast) then //----------- если вышли на заданный конец трассы
      begin
        InsNewMsg(MarhTrac.ObjStart,1,7,'');//------------ "продолжайте набор маршрута от"
        ShowSMsg(1, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
        result := true;
        exit;
      end;
      //------------------------------------------ Сохранить параметры начатой трассировки
      MarhTrac.ObjPrev := MarhTrac.ObjLast; //-------------- объект в конце начатой трассы
      MarhTrac.PinPrev := MarhTrac.PinLast; //------------ завершающая точка этого объекта

      if MarhTrac.Counter < High(MarhTrac.ObjTRS) then //------------- если свободно место
      begin //---------------- трассировка - первичная фаза, поиск между заданными точками
        i := TryMarhLimit; //------------------------- установить ограничитель трассировки
        jmp :=ObjZv[MarhTrac.ObjLast].Sosed[MarhTrac.PinLast];//---------------- коннектор

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTrac.Level := tlFindTrace; //------- назначаем уровень проверки наличия трассы
        //-------------------------------------------- здесь начинается цикл поиска трассы
        while i > 0 do //-------- цикл до нахождения трассы, либо превышения числа попыток
        begin //------------------------------------------ трассировать до указанной точки

          if jmp.Obj = index then break; //-------- Обнаружен объект, указанный оператором

          case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of //------------- сделать шаг
            trRepeat : //---------- конец не найден, продолжаем поиск от последней стрелки
            begin
              if MarhTrac.Counter > 0 then
              begin //------------------------- Возврат к последней непереведенной стрелке
                j := MarhTrac.Counter; //------------- начинаем от текущего объекта трассы
                while j > 0 do
                begin
                  case ObjZv[MarhTrac.ObjTRS[j]].TypeObj of //------------ переход по типу
                    2 :
                    begin //------------------------------------------------------ стрелка
                      strelka := MarhTrac.ObjTRS[j]; //---------- индекс стрелки из трассы
                      if ObjZv[strelka].ObCB[3] then //------- основные маршруты по минусу
                      begin
                        if (ObjZv[strelka].bP[10] and //---------- был проход первый и ...
                        not ObjZv[strelka].bP[11]) or //-------- не было пока 2-го или ...
                        ObjZv[strelka].bP[12] or  //----- пошерстная нужна в плюсе или ...
                        ObjZv[strelka].bP[13] then //----------- пошерстная нужна в минусе
                        begin
                          ObjZv[strelka].bP[10] := false; //-- сброс фиксации 1-го прохода
                          ObjZv[strelka].bP[11] := false; //-- сброс фиксации 2-го прохода
                          ObjZv[strelka].bP[12] := false; //------ сброс пошерстного плюса
                          ObjZv[strelka].bP[13] := false; //----- сброс пошерстного минуса
                          MarhTrac.ObjTRS[j] := 0; //------------ убрать из трассы стрелку
                          dec(MarhTrac.Counter);  //------------ уменьшить число элементов
                        end else
                        begin
                          ObjZv[strelka].bP[11] := false; //----- сброс признака 2-го хода
                          jmp := ObjZv[strelka].Sosed[2]; //-------- переход на плюс-ветку
                          break;
                        end;
                      end else //------------------------------ основные маршруты по плюсу
                      begin
                        if ObjZv[strelka].bP[11] or //------ второй ход по стрелке или ...
                        ObjZv[strelka].bP[12] or //------------ пошерстная в плюсе или ...
                        ObjZv[strelka].bP[13] then //----------------- пошерстная в минусе
                        begin
                          ObjZv[strelka].bP[10] :=false;//---- сброс фиксации 1-го прохода
                          ObjZv[strelka].bP[11] :=false;//---- сброс фиксации 2-го прохода
                          ObjZv[strelka].bP[12] :=false; //------- сброс пошерстного плюса
                          ObjZv[strelka].bP[13] :=false; //------ сброс пошерстного минуса
                          MarhTrac.ObjTRS[j] := 0;
                          dec(MarhTrac.Counter);
                        end else
                        begin
                          ObjZv[strelka].bP[11] := true;
                          jmp := ObjZv[strelka].Sosed[3]; //------- Переход на минус-ветвь
                          break;
                        end;
                      end;
                    end;

                    else //------------------------------ любой объект отличный от стрелки
                      if MarhTrac.ObjTRS[j] = MarhTrac.ObjLast then
                      begin j := 0; break; end //------ вернулись в самое начало, прервать
                      else
                      begin //--------------------------- откатить на один объект к началу
                        MarhTrac.ObjTRS[j] := 0;
                        dec(MarhTrac.Counter);
                      end;
                  end; //------------------------------------------------------ конец case
                  dec(j);
                end; //------------------------------------------ граница while для отката

                if j < 1 then //----------------------- неудачный откат, трасса не найдена
                begin //------------------------ Конец трассировки - точка указана неверно
                  InsNewMsg(MarhTrac.ObjStart,86,1,'');
                  RestorePrevTrace;
                  result := false;
                  ShowSMsg(86, LastX, LastY, '');
//                  SBeep[1] := true;
                  exit;
                end;
              end else //-------------------------- в трассе нет элементов (пустая трасса)
              begin //-------------------------- Конец трассировки - точка указана неверно
                InsNewMsg(MarhTrac.ObjStart,86,1,'');
                RestorePrevTrace; //------- восстановить трассу до последней удачной точки
                result := false;
                ShowSMsg(86, LastX, LastY, ''); //--- "Точка трассы $ указана неверно"
                exit;
              end;
            end;

            trStop : //------------ при попытке пройти через объект - топология не пускает
            begin
              InsNewMsg(MarhTrac.ObjStart,77,1,'');
              RestorePrevTrace; //-------------- восстановиться до последней удачной точки
              result := false;
              ShowSMsg(77, LastX, LastY, '');  //--------------- Маршрут не существует
              exit;
            end;

            trEnd :
            begin //---------------------------- Конец трассировки - маршрут не существует
              InsNewMsg(MarhTrac.ObjStart,77,1,'');
              RestorePrevTrace;
              result := false;
              ShowSMsg(77, LastX, LastY, ''); exit;
            end;
          end; //------------------------------------------------- конец щага через объект
          dec(i); //------ перейти к следующему шагу, уменьшив число допустимых оставшихся
        end; //------------------------------ конец цикла попыток шагания по объектам базы

        if i < 1 then //--------------------------- вышли за пределы установленного лимита
        begin //------------------------------------------------- превышен счетчик попыток
          InsNewMsg(MarhTrac.ObjStart,231,1,'');// Превышен счет попыток трассировки
          RestorePrevTrace;
          result := false;
          ShowSMsg(231, LastX, LastY, '');
          exit;
        end;

        MarhTrac.ObjLast := index; //------------------------ обновляем конец трассы

        if ObjZv[index].TypeObj = 5 then MarhTrac.ObjEnd := index;

        case jmp.Pin of
          1 : MarhTrac.PinLast := 2; // запоминаем точку выхода из конечного объекта
          else MarhTrac.PinLast := 1;
        end;

        //------------------- Проверить необходимость поиска предполагаемой конечной точки
        b := true;
        MarhTrac.PutPO := false; //--------------- сброс признака трассировки в пути

        if ObjZv[MarhTrac.ObjLast].TypeObj = 5 then
        begin //------------------ Для светофора проверить условия продолжения трассировки
          signal := MarhTrac.ObjLast;
          if ObjZv[signal].ObCB[1] then  //-- есть конец трассировки в точке сигнала
          begin//Точка разрыва маршрутов Ч/Н (смена направления движения на станции, тупик)
            b := false;
            MarhTrac.ObjEnd := signal;
          end
          else
          case MarhTrac.PinLast of
            1 :  //----------------------- выход из сигнала в точке 1 (выезд за встречный)
            begin
              case MarhTrac.Rod of
                MarshP :
                begin
                  if ObjZv[signal].ObCB[6] then //---- есть конец поездных в точке 2
                  begin //------------------ Завершить трассировку если поездной из тупика
                    b := false; MarhTrac.ObjEnd := signal;
                  end else //-------------- нет конца П в точке 2 ( за встречным сигналом)
                  if ((ObjZv[signal].Sosed[1].TypeJmp = 0) or
                  (ObjZv[signal].Sosed[1].TypeJmp = LnkNecentr))
                  then begin b := false; i := 0; end; //Отказ если нет поездного из тупика
                end;

                MarshM :
                begin
                  if ObjZv[signal].ObCB[7] and //есть конец маневровых в точке 1 и..
                  ObjZv[signal].ObCB[23] //------------- разрешен конец за встречным
                  then
                  begin //----- Завершить трассировку за встречным, но проверить куда едем
                    b := true;  MarhTrac.ObjEnd := signal;
                  end else
                  begin
                    InsNewMsg(index,86,1,'');   //---------- Точка трассы $ указана неверно
                    RestorePrevTrace; result := false;
                    ShowSMsg(86, LastX, LastY, ObjZv[index].Liter);
                    exit;
                  end;
                end;

                else b := true; //---------------------------- неопределенный тип маршрута
              end;
            end;

            else //--- выход из сигнала конца в точке 2 (за попутным, значит маршрут "до")

            //-------------- если маневровый и есть конец маневровых в точке 1 ("до")  или
            if(((MarhTrac.Rod=MarshM) and ObjZv[signal].ObCB[7]) or
            //--------------------------- если поездной и есть конец поездных в точке 1 и
            ((MarhTrac.Rod = MarshP) and ObjZv[signal].ObCB[5])) and
            //---------------- если блокировка FR4 или блокировка в РМ ДСП или РМ/МИ или
            (ObjZv[signal].bP[12] or
            ObjZv[signal].bP[13] or
            ObjZv[jmp.Obj].bP[18] or
            //-----------------------------------------------есть начало поездных и С1 или
            (ObjZv[signal].ObCB[2] and
            (ObjZv[signal].bP[3] or
            //----------------------------------------------- С2 или Начало из сервера или
            ObjZv[signal].bP[4] or
            ObjZv[signal].bP[8] or
            //--------------------------------- ППР трассировки или есть начало маневровых
            ObjZv[signal].bP[9])) or
            (ObjZv[signal].ObCB[3]
            //-------------------------------------------------------------- и МС1 или МС2
            and (ObjZv[signal].bP[1]
            or ObjZv[signal].bP[2]
            //--------------------------------- или есть НМ из сервера или МПР трассировки
            or ObjZv[signal].bP[6]
            or ObjZv[signal].bP[7]
            //или МУС
            or ObjZv[signal].bP[21]))) then
            begin //--------------- Завершить трассировку если попутный впереди уже открыт
              b := false;
              MarhTrac.ObjEnd := signal;
            end else //----------------------------------------------------- сигнал закрыт
            begin
              case MarhTrac.Rod of
                MarshP :      //-------------------------------------------- если поездной
                begin //------------------------------- если есть конец поездных в точке 1
                  if ObjZv[signal].ObCB[5] then
                  begin //---------------------- есть конец поездного маршрута у светофора
                    MarhTrac.FullTail := true;
                    MarhTrac.FindNext := true;
                  end;
                  //------------------- если нет сквозного пропуска и есть начало поездных
                  if ObjZv[signal].ObCB[16] and
                  ObjZv[signal].ObCB[2] then //-------------- Нет сквозного пропуска
                  begin //-------------- Завершить трассировку если нет сквозного пропуска
                    b := false;
                    MarhTrac.ObjEnd := signal;
                    MarhTrac.FullTail := true //------------- закончить набор трассы
                  end else
                  begin
                    if ObjZv[signal].ObCB[5] then b := false // есть конец "П" в т.1
                    else b := true;

                    if ObjZv[signal].ObCB[5] and //------ есть конец "П" в т.1 и ...
                    not ObjZv[signal].ObCB[2] then //---------- нет поездного начала
                    begin
                      MarhTrac.ObjEnd := signal; //-- конец, нет поездных от сигнала
                    end;
                  end;
                end;

                MarshM :
                begin
                  if ObjZv[signal].ObCB[7] then //-- есть конец маневровых в точке 1
                  begin
                    MarhTrac.FullTail := true;
                    MarhTrac.FindNext := true;
                  end;

                  if ObjZv[signal].ObCB[7]
                  then b := false
                  else b := true;

                  if ObjZv[signal].ObCB[7] and //------ есть конец М в точке 1 и ...
                  not ObjZv[signal].ObCB[3] then //- у сигнала нет начала маневровых
                  begin
                    MarhTrac.ObjEnd := signal;//- Завершить, нет маневров от сигнала
                  end;
                end;

                else  b := true; //--------------- неопределенный маршрут следует прервать
              end;
            end;
          end;
        end else //--------------------------------- объекты типа "путь" или "УП с концом"
        if ((ObjZv[MarhTrac.ObjLast].TypeObj = 4) or //---------- если путь или ...

        ((ObjZv[MarhTrac.ObjLast].TypeObj = 3) and //--------------------- УП и ...
        (MarhTrac.Rod = MarshP) and //----------------------- поездной маршрут и ...
        (MarhTrac.PinLast = 1) and  //-------------- выход из УП через точку 1 и ...
        (ObjZv[MarhTrac.ObjLast].ObCB[10] = true)) or //есть конец в тчк 1 или

        ((ObjZv[MarhTrac.ObjLast].TypeObj = 3) and //--------------------- УП и ...
        (MarhTrac.Rod = MarshP) and //----------------------- поездной маршрут и ...
        (MarhTrac.PinLast = 2) and  //-------------- выход из УП через точку 2 и ...
        (ObjZv[MarhTrac.ObjLast].ObCB[11] = true)))  //---- есть конец в тчк 2
        then  MarhTrac.PutPO := true
        //---------------- Для пути или УП с концом установить признак конца набора трассы
        else
        if ObjZv[MarhTrac.ObjLast].TypeObj = 24 then
        begin //-------------------------- Для межпостовой увязки завершить набор маршрута
          b := false;
          MarhTrac.ObjEnd := MarhTrac.ObjLast;
        end else
        if ObjZv[MarhTrac.ObjLast].TypeObj = 32 then
        begin //------------------------------------- Для надвига завершить набор маршрута
          b := false;
          MarhTrac.ObjEnd := MarhTrac.ObjLast;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++ продление трассы маршрута за сигнал
        if b then  //-------------------------------- нет завершения маршрута, нужен добор
        begin //--- Добить до конечной точки или отклоняющей стрелки, перешагнуть конечный
          MarhTrac.FullTail := false;

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTrac.Level := tlContTrace; //------------------ режим продления трассы
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //---------------------- Д О Б О Р   Т Р А С С Ы  ------------------------------
          i := 1000;

          while i > 0 do
          begin
            TST_TRAS := StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);//шагнуть
            case TST_TRAS of
              trStop :
              begin //-------------------------- конец трассировки - маршрут не существует
                InsNewMsg(MarhTrac.ObjStart,77,1,'');
                RestorePrevTrace;
                result := false;
                ShowSMsg(77, LastX, LastY, '');
                exit;
              end;

              trBreak :
              begin //------------------------- сделать откат до предыдущей точки маршрута
                b := false;
                break;
              end;

              trEnd :
                      break; //------------------------- достигнута делящая точка маршрута

              trKonec :
              begin  //-------------------------------- достигнута конечная точка маршрута
                MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];
                MarhTrac.ObjLast := ObjZv[signal].Sosed[1].Obj;//проход за сиг.
                break;
              end;
            end;
            dec(i);
          end;

          if i < 1 then
          begin //----------------------------------------------- превышен счетчик попыток
            InsNewMsg(MarhTrac.ObjStart,231,1,'');
            RestorePrevTrace;
            result := false;
            ShowSMsg(231, LastX, LastY, ''); exit;
          end;

          if ObjZv[MarhTrac.ObjLast].TypeObj = 3 then b := true;

          if b then
          begin //------------------------------------------------------------- нет отката
            jmp.Obj := MarhTrac.ObjLast;
            case jmp.Pin of
              1 : MarhTrac.PinLast := 2;
              else  MarhTrac.PinLast := 1;
            end;
          end else
          begin //-------------------------------------------------- был откат на один шаг
            //------------------------------------------------------ пропустить ДЗ стрелок

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTrac.Level := tlStepBack; //----- режим шаг назад по трассе маршрута
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            i := MarhTrac.Counter;
            while i > 0 do
            begin
              case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
                trStop : break;
              end;
              dec(i);
            end;
            MarhTrac.ObjLast := jmp.Obj;
            MarhTrac.PinLast := jmp.Pin;
          end;
        end else
        begin //------------------------------------------ Если нет добора хвоста маршрута
          if MarhTrac.Counter < High(MarhTrac.ObjTRS) then
          begin //---------------------------------------- поместить хвост в список трассы
            inc(MarhTrac.Counter);
            MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
          end;
        end;

        LastJmp := jmp; //-------------------- Сохранить последний переход между объектами

        if i < 1 then
        begin //----------------------------------- отказ по несоответствию конечной точки
          InsNewMsg(index,86,1,'');   //------------------- Точка трассы $ указана неверно
          RestorePrevTrace;
          result := false;
          ShowSMsg(86, LastX, LastY, ObjZv[index].Liter);
          exit;
        end;

        //-------------------------------------------- Проверить охранности по всей трассе
        i := 1000;
        MarhTrac.VP := 0;
        jmp := ObjZv[MarhTrac.ObjStart].Sosed[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTrac.Level := tlVZavTrace; //----- режим проверка зависимостей по трассе
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        j := MarhTrac.ObjEnd; //------------------ найденный конец продленной трассы

        MarhTrac.CIndex := 1;
        if j < 1 then j := MarhTrac.ObjTRS[MarhTrac.Counter];

        res := false;
        while i > 0 do
        begin
          case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
            trStop :  begin i := 1; break; end;
            trBreak : break;
            trEnd :   break;
          end;
          dec(i);
          if res then break;
          if jmp.Obj = j then res := true; //--------------- Обнаружен объект конца трассы
          inc(MarhTrac.CIndex);
        end;

        if MarhTrac.MsgN > 0 then //-- есть запрещающие сообщения (враждебность)
        begin
          InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
          RestorePrevTrace;
          result := false;
          PutSMsg(1, LastX, LastY, MarhTrac.Msg[1]);
          exit;
        end;

        if i < 0 then //--------------------- отказ по охранностям - маршрут не существует
        begin
          InsNewMsg(MarhTrac.ObjStart,77,1,'');
          RestorePrevTrace;
          result := false;
          ShowSMsg(77, LastX, LastY, '');
          exit;
        end;

        //------------------------------ Раскидать признаки трассировки по объектам трассы
        for i := 1 to MarhTrac.Counter do
        begin
          case ObjZv[MarhTrac.ObjTRS[i]].TypeObj of
            3 :   //--------------------------------------------------------------- секция
            begin
              if  not ObjZv[MarhTrac.ObjTRS[i]].bP[14] then
              ObjZv[MarhTrac.ObjTRS[i]].bP[8] := false;
            end;

            4 :  //------------------------------------------------------------------ путь
            begin
              Put := MarhTrac.ObjTRS[i];
              if (not ObjZv[Put].ObCB[10]) and (not ObjZv[Put].ObCB[11]) and
              (not ObjZv[Put].bP[14]) then ObjZv[Put].bP[8] := false;
            end;
          end;
        end;

        //------------------------------------------ Проверить враждебности по всей трассе
        i := 1000;
        MarhTrac.MsgN := 0;
        MarhTrac.WarN := 0;
        MarhTrac.GonkaStrel := false; //----- убрать признак гонки стрелок по трассе
        MarhTrac.GonkaList  := 0;    // сбросить счетчик стрелок, требующих перевода
        jmp := ObjZv[MarhTrac.ObjStart].Sosed[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTrac.Level := tlCheckTrace;//---- режим проверка враждебностей по трассе
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        MarhTrac.VP := 0;
        j := MarhTrac.ObjEnd;
        if j < 1 then j := MarhTrac.ObjTRS[MarhTrac.Counter];
        MarhTrac.CIndex := 1;

        while i > 0 do
        begin
          if jmp.Obj = j then
          begin //------------------------------------------ Обнаружен объект конца трассы
            //----------------------------------------------- поиск враждебностей в хвосте
            StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);
            break;
          end;

          case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
            trStop : break;
          end;
          dec(i);
          inc(MarhTrac.CIndex);
        end;

        if i < 1 then
        begin //--------------------------------------------- отказ по превышению счетчика
          InsNewMsg(MarhTrac.ObjStart,231,1,'');
          RestorePrevTrace;
          result := false;
          ShowSMsg(231, LastX, LastY, '');
          exit;
        end;
        tm := MarhTrac.TailMsg; //------------ сохранить сообщение в хвосте маршрута

        if MarhTrac.MsgN > 0 then
        begin  //--------------------------------------------------- отказ по враждебности
          MarhTrac.MsgN := 1; //------------------------ оставить одно сообщение
          //--------------- Закончить трассировку и сбросить трассу если есть враждебности
          NewMenu_(Key_ReadyResetTrace,LastX,LastY);
          result := false;
          exit;
        end else
        begin
          if MarhTrac.PutPO then //---------------- Завершить набор если указан путь
           MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];

          if (MarhTrac.WarN > 0) and
          MarhTrac.FullTail then //--------  При наличии сообщений и хвосте маршрута
          MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];

          //------------------------------ Проверка возможности набора следующего маршрута
          c := MarhTrac.Counter; //-------- сохранить текущее число элементов трассы
          wc := MarhTrac.WarN;  //--------------- сохранить число предупреждений
          oe := MarhTrac.ObjEnd; //--------------------------------- конечный объект

          MarhTrac.VP := 0;
          MarhTrac.LvlFNext := true;

          if (MarhTrac.ObjEnd = 0) and (MarhTrac.FindNext) then
          begin //------------------------ Проверка возможности набора следующего маршрута
            i := TryMarhLimit * 2;
            jmp := ObjZv[MarhTrac.ObjLast].Sosed[MarhTrac.PinLast];

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTrac.Level := tlFindTrace;
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            while i > 0 do
            begin //------------------------------------------------ трассировать по шагам

              case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of

                trRepeat :  //--------------------- если нужен возврат к последней стрелке
                begin

                  if MarhTrac.Counter > c then //-- если был хотя бы один шаг вперед
                  begin   //------------------- Возврат к последней непереведенной стрелке
                    j := MarhTrac.Counter; // начинаем с конца (сначала здесь j > c)
                    while j > 0 do
                    begin

                      case ObjZv[MarhTrac.ObjTRS[j]].TypeObj of

                        2 :
                        begin //-------------------------------------------------- стрелка
                          strelka := MarhTrac.ObjTRS[j];

                          if ObjZv[strelka].ObCB[3] then//главные маршруты по минусу
                          begin
                            if (ObjZv[strelka].bP[10] and  //-- был 1-ый проход и ...
                            not ObjZv[strelka].bP[11]) or //- был 2-ой проход или ...
                            ObjZv[strelka].bP[12] or //  пошерстная нужна в плюсе или
                            ObjZv[strelka].bP[13] then //-- пошерстная нужна в минусе
                            begin
                              ObjZv[strelka].bP[10] := false;//---- сбросить первый проход
                              ObjZv[strelka].bP[11] := false;//---- сбросить второй проход
                              ObjZv[strelka].bP[12] := false;//сброс трассы пошерстная в +
                              ObjZv[strelka].bP[13] := false;//сброс трассы пошерстная в -
                              MarhTrac.ObjTRS[j] := 0; //-------- убрать стрелку из трассы
                              dec(MarhTrac.Counter); //------------ сократить трассу
                            end else
                            begin
                              ObjZv[strelka].bP[11] := false;//установить 2-ой проход
                              jmp := ObjZv[strelka].Sosed[2]; //Переход на плюс-ветвь
                              break;
                            end;
                          end else
                          begin //----------------------------- основные маршруты по плюсу
                            if ObjZv[strelka].bP[11] or//если был 2-ой проход или ...
                            ObjZv[strelka].bP[12] or//трасса для пошерстной в плюсе или...
                            ObjZv[strelka].bP[13] then //-- трасса для пошерстной в минусе
                            begin
                              ObjZv[strelka].bP[10] := false;
                              ObjZv[strelka].bP[11] := false;
                              ObjZv[strelka].bP[12] := false;
                              ObjZv[strelka].bP[13] := false;
                              MarhTrac.ObjTRS[j] := 0;
                              dec(MarhTrac.Counter);
                            end else
                            begin
                              ObjZv[MarhTrac.ObjTRS[j]].bP[11] := true;//2-ой
                              jmp:= ObjZv[MarhTrac.ObjTRS[j]].Sosed[3];//на -
                              break;
                            end;
                          end;
                        end;

                        else //---------------- любой другой объект (не является стрелкой)
                          if MarhTrac.ObjTRS[j] = MarhTrac.ObjLast then
                          begin  //- конец, заданный опрератором на экране для трассировки
                            j := 0; break;
                          end else
                          begin //---------------- откатить на один объект к началу трассы
                            MarhTrac.ObjTRS[j] := 0;
                            dec(MarhTrac.Counter);
                          end;

                      end; //-------------------------------- конец case по типам объектов
                      dec(j);
                    end; //--------- конец while j > 0 по числу объектов вошедших в трассу

                    if j <= c then //------------------------- если выполнен возврат назад
                    begin //-------------------------------------------- Конец трассировки
                      oe := MarhTrac.ObjLast;
                      break;
                    end;
                  end else //------------ если на очередном объекте нет продвижения вперед
                  begin //---------------------------------------------- Конец трассировки
                    MarhTrac.ObjEnd := MarhTrac.ObjLast;
                    break;
                  end;
                end; //-------------------------- конец case по результату шага = trRepeat

                trStop, trEnd : break; //------------------------------- Конец трассировки
              end; //------------------------------------------------------ case steptrace

              //-------------------------------------- Проверить достижение конечной точки
              b := false;

              if ObjZv[jmp.Obj].TypeObj = 5 then //-------------------------- если сигнал
              begin //------------ Для светофора проверить условия продолжения трассировки
                if ObjZv[jmp.Obj].ObCB[1] then b := true //- Точка разрыва маршрутов
                else
                case jmp.Pin of
                  2 :
                  begin //--------------------------- подошли к точке 2 (сигнал встречный)
                    case MarhTrac.Rod of
                      MarshP : if ObjZv[jmp.Obj].ObCB[6] then b := true;//П конец т2

                      MarshM : if ObjZv[jmp.Obj].ObCB[8] then b := true;//М конец т2

                      else  b := false;
                    end;
                  end;
                  else //---------------------------- подошли к точке 1, (сигнал попутный)
                    if ObjZv[jmp.Obj].bP[1] or ObjZv[jmp.Obj].bP[2]//МС1 или МС2
                    or //------------------------------------------------------------- или
                    ObjZv[jmp.Obj].bP[3] or ObjZv[jmp.Obj].bP[4] //--- С1 или С2
                    or //------------------------------------------------------------- или
                    ObjZv[jmp.Obj].bP[6] or ObjZv[jmp.Obj].bP[7]//НМ_FR3 или МПР
                    or //------------------------------------------------------------- или
                    ObjZv[jmp.Obj].bP[8] or ObjZv[jmp.Obj].bP[9] //Н_FR3 или ППР
                    or //------------------------------------------------------------- или
                    ObjZv[jmp.Obj].bP[12] or ObjZv[jmp.Obj].bP[13]//блокSTAN_DSP
                    or //------------------------------------------------------------- или
                    ObjZv[jmp.Obj].bP[18] or ObjZv[jmp.Obj].bP[21] //- РМ_МИ_МУС
                    then b := true //попутный уже открыт, на выдержке, в трассе,блокирован
                    else
                    begin
                      case MarhTrac.Rod of
                        MarshP :
                        begin
                          if ObjZv[jmp.Obj].ObCB[16] and // Нет сквозного пропуска и
                          ObjZv[jmp.Obj].ObCB[2] then b := true // есть начало для П
                          else
                          begin
                            b := ObjZv[jmp.Obj].ObCB[5]; //наличие П конца в точке 1
                          end;
                        end;

                        MarshM : b := ObjZv[jmp.Obj].ObCB[7];   // М конец в точке 1

                        else  b := true;  //------------------- неясный маршрут остановить
                      end;
                    end;
                end;
              end else
              if ObjZv[jmp.Obj].TypeObj = 15 then
              begin //-------------------- Для увязки с перегоном завершить набор маршрута
                inc(MarhTrac.Counter);
                MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZv[jmp.Obj].TypeObj = 24 then
              begin //-------------------- Для межпостовой увязки завершить набор маршрута
                b := true;
              end else
              if ObjZv[jmp.Obj].TypeObj = 26 then
              begin //-------------------------- Для увязки с ПАБ завершить набор маршрута
                inc(MarhTrac.Counter);
                MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZv[jmp.Obj].TypeObj = 32 then
              begin //------------------------------- Для надвига завершить набор маршрута
                b := true;
              end;

              if b then //- маршрут завершен на этапе трассировки, то проверить охранности
              begin
                k := 15000;
                jmp.Obj := MarhTrac.ObjLast;
                if MarhTrac.PinLast = 1 then jmp.Pin := 2 else
                jmp.Pin := 1;

                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                MarhTrac.Level := tlVZavTrace;//режим проверка зависимостей в трассе
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                j := MarhTrac.ObjTRS[MarhTrac.Counter];
                MarhTrac.CIndex := c;
                b := true;

                while k > 0 do
                begin
                  if jmp.Obj = j then break; //------------- Обнаружен объект конца трассы
                  case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
                    trStop :         begin  b := false; break; end;
                    trBreak, trEnd : begin   break;            end;
                  end;
                  dec(k);
                  inc(MarhTrac.CIndex);
                end;

                if (k > 1000) and b then
                begin
                  //----------------------------------------------- Проверить враждебности
                  jmp.Obj := MarhTrac.ObjLast;
                  if MarhTrac.PinLast = 1 then jmp.Pin := 2
                  else jmp.Pin := 1;

                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  MarhTrac.Level := tlCheckTrace;//- режим проверка вражд. по трассе
                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                  MarhTrac.Dobor := true;
                  MarhTrac.MsgN := 0;
                  j := MarhTrac.ObjTRS[MarhTrac.Counter];
                  MarhTrac.CIndex := c;
                  while k > 0 do
                  begin
                    if jmp.Obj = j then
                    begin //-------------------------------- Обнаружен объект конца трассы
                      // Враждебности в хвосте
                      StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0); break;
                    end;

                    case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
                      trStop,trBreak :  break;
                    end;

                    dec(i);
                    inc(MarhTrac.CIndex);
                  end;
                end;

                if MarhTrac.MsgN > 0 then b := false;

                if (k < 1) or not b then
                begin //--------------------------- отказ по охранностям или враждебностям
                  if MarhTrac.Counter > c then
                  begin
                    //------------------------- Возврат к последней непереведенной стрелке
                    j := MarhTrac.Counter;
                    while j > 0 do
                    begin
                      case ObjZv[MarhTrac.ObjTRS[j]].TypeObj of
                        2 :
                        begin //-------------------------------------------------- стрелка
                          strelka := MarhTrac.ObjTRS[j];
                          if ObjZv[strelka].ObCB[3] then
                          begin //---------------------------- основные маршруты по минусу
                            if (ObjZv[strelka].bP[10] and
                            not ObjZv[strelka].bP[11]) or
                            ObjZv[strelka].bP[12] or
                            ObjZv[strelka].bP[13] then
                            begin
                              ObjZv[strelka].bP[10] := false;
                              ObjZv[strelka].bP[11] := false;
                              ObjZv[strelka].bP[12] := false;
                              ObjZv[strelka].bP[13] := false;
                              MarhTrac.ObjTRS[j] := 0;
                              dec(MarhTrac.Counter);
                            end else
                            begin
                              ObjZv[strelka].bP[11] := false;
                              jmp := ObjZv[strelka].Sosed[2]; //Переход на плюс-ветвь
                              break;
                            end;
                          end else
                          begin //----------------------------- основные маршруты по плюсу
                            if ObjZv[strelka].bP[11] or
                            ObjZv[strelka].bP[12] or
                            ObjZv[strelka].bP[13] then
                            begin
                              ObjZv[strelka].bP[10] := false;
                              ObjZv[strelka].bP[11] := false;
                              ObjZv[strelka].bP[12] := false;
                              ObjZv[strelka].bP[13] := false;
                              MarhTrac.ObjTRS[j] := 0;
                              dec(MarhTrac.Counter);
                            end else
                            begin
                              ObjZv[strelka].bP[11] := true;
                              jmp := ObjZv[strelka].Sosed[3];//Переход на минус-ветвь
                              break;
                            end;
                          end;
                        end;
                        else
                          if MarhTrac.ObjTRS[j] = MarhTrac.ObjLast then
                          begin
                            oe := MarhTrac.ObjLast;
                            break;
                          end else
                          begin //----------------------- откатить на один объект к началу
                            MarhTrac.ObjTRS[j] := 0;
                            dec(MarhTrac.Counter);
                          end;
                      end;
                      dec(j);
                    end;
                    if j <= c then
                    begin //-------------------------------------------- Конец трассировки
                      oe := MarhTrac.ObjLast;
                      break;
                    end;
                  end else
                  begin //---------------------------------------------- Конец трассировки
                    oe := MarhTrac.ObjLast;
                    break;
                  end;
                end
                else break;
              end;

              //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              MarhTrac.Level := tlFindTrace; //
              //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

              dec(i);
            end;

            if i < 1 then oe := MarhTrac.ObjLast; //------- превышен счетчик попыток
          end;

          while MarhTrac.Counter > c do
          begin //------------------ убрать признаки трассировки перед продолжением набора
            if ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].TypeObj = 2 then //------- стрелка
            begin
              ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].bP[10] := false;
              ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].bP[11] := false;
              ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].bP[12] := false;
              ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].bP[13] := false;
            end;
            MarhTrac.ObjTRS[MarhTrac.Counter] := 0;
            dec(MarhTrac.Counter);
          end;
          MarhTrac.MsgN := 0;
          MarhTrac.WarN := wc;
          MarhTrac.ObjEnd   := oe;

          if MarhTrac.ObjEnd > 0 then
          begin //-------------------------- Завершить набор если нельзя продолжить трассу
            if (ObjZv[MarhTrac.ObjLast].TypeObj = 5) and  //- если это сигнал и ...
            (MarhTrac.PinLast = 2) and  //------------ трассируется из точки 2 и ...
            not (ObjZv[MarhTrac.ObjLast].bP[1] or // нет ни маневрового ВС, ...
            ObjZv[MarhTrac.ObjLast].bP[2] or //ни открытого маневрового сигнала
            ObjZv[MarhTrac.ObjLast].bP[3] or //------------ ни поездного ВС ...
            ObjZv[MarhTrac.ObjLast].bP[4]) then  //---- нет открытого поездного
            begin
              if ObjZv[MarhTrac.ObjLast].bP[5] then //----------------------- о
              begin //--------------------- Маршрут не прикрыт запрещающим огнем попутного
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,115, ObjZv[MarhTrac.ObjLast].Liter,1);
                InsWar(MarhTrac.ObjLast,115);
              end;

              case MarhTrac.Rod of // проверка открытия впереди стоящего сигнала если короткий блок-участок
                MarshP :
                begin
                  if ObjZv[MarhTrac.ObjLast].ObCB[19] and
                  not ObjZv[MarhTrac.ObjLast].bP[4] then
                  begin
                    InsNewMsg(MarhTrac.ObjLast,391,1,'');
                    ShowSMsg(391,LastX,LastY,ObjZv[MarhTrac.ObjLast].Liter);
                    exit;
                  end;
                end;

                MarshM :
                begin
                  if ObjZv[MarhTrac.ObjLast].ObCB[20] and
                  not ObjZv[MarhTrac.ObjLast].bP[2] then
                  begin
                    InsNewMsg(MarhTrac.ObjLast,391,1,'');
                    ShowSMsg(391,LastX,LastY,ObjZv[MarhTrac.ObjLast].Liter);
                    exit;
                  end;
                end;
                else result := false; exit;
              end;
            end;

            // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
            if FindIzvStrelki(MarhTrac.ObjStart, MarhTrac.Rod) then
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,333, ObjZv[MarhTrac.ObjStart].Liter,7);
              InsWar(MarhTrac.ObjStart,333);
            end;

            MarhTrac.TailMsg := tm; //----- восстановить сообщение в хвосте маршрута

            if MarhTrac.WarN > 0 then
            begin //------------------------------------------------- Вывод предупреждений
             SBeep[1] := true;
{$IFNDEF TABLO}
              TimeLockCmdDsp := LastTime;
{$ENDIF}
              LockComDsp := true;
              NewMenu_(Key_ReadyWarningTrace,LastX,LastY);
            end
            else NewMenu_(CmdMarsh_Ready,LastX,LastY);

            MarhTrac.Finish := true;
          end else
          begin
            MarhTrac.TailMsg := tm; // восстановить сообщение в хвосте маршрута
            InsNewMsg(MarhTrac.ObjStart,1,7,''); //- "продолжайте набор маршрута от"
            ShowSMsg(1, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
          end;
        end;
      end else
      begin
        InsNewMsg(MarhTrac.ObjStart,180,7,'');
        RestorePrevTrace;
        result := false;
        ShowSMsg(180, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
      end;
    end
    else result := false;
end;
{$ENDIF}

//========================================================================================
//-------------------------------------- Обработка шага по базе, возвращает результат шага
function StepTrace(var From:TSos; const Lvl:TTrLev; Rod:Byte; Grp:Byte) : TTrRes;
//------------------------------- Con ---- связь с соседом, от которого пришли -----------
//------------------------------- Lvl ---- этап трассировки маршрута ---------------------
//------------------------------- Rod ---- тип маршрута ----------------------------------
//------------------------------- Grp -- номер маршрута в списке задаваемых ------------
var
  jmp1,jmp : TSos;
  tras,tras_end : integer;
begin
    if Grp <> 0 then MarhTrac := MarhTrac1[Grp];
    
    result := trStop;//- Конец трассировки из-за топологической несвязности точек маршрута

    case Lvl of
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      tlVZavTrace, //---------------------------------------------- Проверка зависимостей,
      tlCheckTrace,//--------------------------- проверка враждебностей по трассе маршрута
      tlZamykTrace ://замыкание трассы маршрута, сбор положения отклоняющих стрелок трассы
      begin //------------------------------------------------ проверка целостности трассы
        if MarhTrac.CIndex <= MarhTrac.Counter then  //--------------------- если не конец
        begin
          //----------------------------------- объект не в трассе, остановить трассировку
          if From.Obj <> MarhTrac.ObjTRS[MarhTrac.CIndex] then exit;
        end else
        if MarhTrac.CIndex = MarhTrac.Counter+1 then //--------------- если вышли за конец
        if From.Obj <> MarhTrac.ObjEnd  then exit;//------ объект не продолжение - останов
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      tlStepBack : //----------------------------------------------- откат назад по трассе
      begin
        jmp := From; //--------------------------------- При откате перешагнуть объекты Дз
        case ObjZv[jmp.Obj].TypeObj of
          27,29 :
          begin
            if jmp.Pin = 1 then
            begin
              From := ObjZv[jmp.Obj].Sosed[2];
              case From.TypeJmp of
                LnkRgn : result := trStop; //-------------------------------- конец района
                LnkEnd : result := trStop; //-------------------------------- конец строки
                else  result := trNext;  //----------------------- иначе шагать дальше
              end;
            end else
            begin
              From := ObjZv[jmp.Obj].Sosed[1];
              case From.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : result := trStop;
                else  result := trNext;
              end;
            end;
          end;
          else result := trStop; exit; //-------- для других объектов остановиться и выйти
        end;

        if MarhTrac.Counter > 0 then
        begin
          MarhTrac.ObjTRS[MarhTrac.Counter]:=0;// сброс трасс-ячейки
          dec(MarhTrac.Counter); //------------ уменьшить число элементов трассы
        end
        else result := trStop;
        exit;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    jmp := From; //---------------------- в последующие функции передается коннектор входа

    case ObjZv[jmp.Obj].TypeObj of
      2 : result := StepTrasStr  (From,Lvl,Rod,jmp);
      3 : result := StepTrasSP   (From,Lvl,Rod,jmp);
      4 : result := StepTrasPut  (From,Lvl,Rod,jmp);
      5 : result := StepTrasSig  (From,Lvl,Rod,jmp);
      7 : result := StepTrasPrigl(From,Lvl,Rod,jmp);
     14 : result := StepTrasUksps(From,Lvl,Rod,jmp);
     15 : result := StepTrasAB   (From,Lvl,Rod,jmp);
     16 : result := StepTrasVsn  (From,Lvl,Rod,jmp);
     23 : result := StepTrasManRn(From,Lvl,Rod,jmp);
     24 : result := StepTrasZapPO(From,Lvl,Rod,jmp);
     26 : result := StepTrasPAB  (From,Lvl,Rod,jmp);
     27 : result := StepTrasDZOhr(From,Lvl,Rod,jmp);
     28 : result := StepTrasIzPer(From,Lvl,Rod,jmp);
     29 : result := StepTrasDZSp (From,Lvl,Rod,jmp);
     30 : result := StepTrasPSogl(From,Lvl,Rod,jmp);
     32 : result := StepUvazGor  (From,Lvl,Rod,jmp);
     38 : result := StepTrasNad  (From,Lvl,Rod,jmp);
     41 : result := StepTrasOtpr (From,Lvl,Rod,jmp);
     42 : result := StepTrasPrzPr(From,Lvl,Rod,jmp);
     43 : result := StepTrasOPI  (From,Lvl,Rod,jmp);
     45 : result := StepTrasZona (From,Lvl,Rod,jmp);
     else result := StepTrasRazn (From,Lvl,Rod,jmp);
    end;

    if (Lvl=tlContTrace) and (result=trBreak) and (ObjZv[MarhTrac.ObjLast].TypeObj=3)
    then
    begin
      inc(MarhTrac.Counter); MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj; exit;
    end else
    if (result = trBreak) or (lvl = tlVZavTrace) or (lvl = tlCheckTrace) or
    (lvl = tlFindIzvest) or (lvl = tlFindIzvStrel) or (lvl = tlZamykTrace)
    or (lvl = tlOtmenaMarh) then exit;
    // Продвинуть текущий объект при поиске трассы, её продлении, откате,повторе маршрута,
    //------------------------------------------ раздельном открытии,  повторе раздельного
    if MarhTrac.Counter < High(MarhTrac.ObjTRS) then
    begin
      inc(MarhTrac.Counter);
      MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
    end
   else result := trStop;
end;
//========================================================================================
function SoglasieOG(Index : SmallInt) : Boolean;
//------------------------------- Проверить возможность выдачи согласия на ограждение пути
var
  i,o,p,j : integer;
begin
  j := ObjZv[Index].UpdOb; // индекс объекта ограждения пути
  if j > 0 then
  begin
    result := ObjZv[j].bP[1]; // Есть запрос на ограждение
    // проверить ограждение по 1-ой точке
    o := ObjZv[Index].Sosed[1].Obj; p := ObjZv[Index].Sosed[1].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZv[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin // Вход по плюсу
              if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then break; // стрелка в отводе по минусу
            end;
            3 : begin // Вход по минусу
              if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then break; // стрелка в отводе по плюсу
            end;
          else
            result := false; break; // ошибка в описании зависимостей - отсутствует СП в общей точке
          end;
          p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
        end;

        3 : begin // участок
          result := ObjZv[o].bP[2]; // замыкание участка
          break;
        end;
      else
        if p = 1 then begin p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj; end
        else begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;
    if not result then exit;
    // проверить ограждение по 2-ой точке
    o := ObjZv[Index].Sosed[2].Obj; p := ObjZv[Index].Sosed[2].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZv[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin // Вход по плюсу
              if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then break; // стрелка в отводе по минусу
            end;
            3 : begin // Вход по минусу
              if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then break; // стрелка в отводе по плюсу
            end;
          else
            result := false; break; // ошибка в описании зависимостей - отсутствует СП в общей точке
          end;
          p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
        end;

        3 : begin // участок
          result := ObjZv[o].bP[2]; // замыкание участка
          break;
        end;
      else
        if p = 1 then begin p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj; end
        else begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;

    // запретить выдачу ограждения при местном управлении
    o := ObjZv[j].ObCI[18];
    if result and (o > 0) then
    begin
      if not ObjZv[ObjZv[o].BasOb].bP[3] then
      begin
        result := false;
      end;
    end;
    o := ObjZv[j].ObCI[19];
    if result and (o > 0) then
    begin
      if not ObjZv[ObjZv[o].BasOb].bP[3] then
      begin
        result := false;
      end;
    end;
  end else
  begin
    result := false;
  end;
end;
//========================================================================================
function CheckOgrad(ptr : SmallInt) : Boolean;
//------ проверить ограждение пути через Вз стрелки при проверке враждебностей трассировки
var
  i,o,p : integer;
begin
  result := true;
  for i := 1 to 10 do
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      case ObjZv[ObjZv[Ptr].ObCI[i]].TypeObj of
        6 : //------------------------------------------------------------ Ограждение пути
        begin
          for p := 14 to 17 do
          begin
            if ObjZv[ObjZv[Ptr].ObCI[i]].ObCI[p] = Ptr then
            begin
              o := ObjZv[Ptr].ObCI[i];
              if ObjZv[o].bP[2] then
              begin //---------------------------------------- Установлено ограждение пути
                if (not MarhTrac.Povtor and (ObjZv[Ptr].bP[10] and not ObjZv[Ptr].bP[11])
                or ObjZv[Ptr].bP[12]) or
                (MarhTrac.Povtor and (ObjZv[Ptr].bP[6] and not ObjZv[Ptr].bP[7])) then
                begin //-------------------------------------------- Стрелка нужна в плюсе
                  if not ObjZv[o].ObCB[p*2-27] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,145, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,145);
                    result := false;
                  end;
                end else
                if (not MarhTrac.Povtor and (ObjZv[Ptr].bP[10] and ObjZv[Ptr].bP[11]) or ObjZv[Ptr].bP[13]) or
                   (MarhTrac.Povtor and (not ObjZv[Ptr].bP[6] and ObjZv[Ptr].bP[7])) then
                begin // Стрелка нужна в минусе
                  if not ObjZv[o].ObCB[p*2-26] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,145, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
end;
//========================================================================================
function CheckOtpravlVP(ptr : SmallInt) : Boolean;
//----------------- проверить установку маршрута отправления с пути с примыкающей стрелкой
//-------------------- через хвост стрелки при проверке враждебностей трассировки маршрута
var
  i,j,o,p : integer;
begin
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZv[ObjZv[Ptr].BasOb].ObCI[i];
    if p > 0 then
    begin
      case ObjZv[p].TypeObj of
        41 :
        begin //--------------------------- Контроль поездного маршрута отправления с пути
          if ObjZv[p].bP[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZv[p].ObCI[j];
              if o = ptr then
              begin //---------- проверить требуемое положение стрелки для обоих маршрутов
                if (not MarhTrac.Povtor and
                (ObjZv[Ptr].bP[10] and not ObjZv[Ptr].bP[11])
                or ObjZv[Ptr].bP[12]) or
                (MarhTrac.Povtor and (ObjZv[Ptr].bP[6]
                and not ObjZv[Ptr].bP[7])) then
                begin //-------------------------------------------- Стрелка нужна в плюсе
                  if not ObjZv[p].ObCB[(j-1)*3+3] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,478, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,478);
                    result := false;
                  end;
                end else
                if (not MarhTrac.Povtor and
                (ObjZv[Ptr].bP[10] and ObjZv[Ptr].bP[11])
                or ObjZv[Ptr].bP[13]) or
                (MarhTrac.Povtor and (not ObjZv[Ptr].bP[6]
                and ObjZv[Ptr].bP[7])) then
                begin //------------------------------------------- Стрелка нужна в минусе
                  if not ObjZv[p].ObCB[(j-1)*3+4] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,478, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,478);
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
end;
//========================================================================================
// проверить ограждение пути через Вз стрелки при проверке враждебностей сигнальной струны
function SignCircOgrad(ptr : SmallInt) : Boolean;
var
  i,o,p : integer;
begin
  result := true;
  for i := 1 to 10 do
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      case ObjZv[ObjZv[Ptr].ObCI[i]].TypeObj of
        6 : begin //------------------------------------------------------ Ограждение пути
          for p := 14 to 17 do
          begin
            if ObjZv[ObjZv[Ptr].ObCI[i]].ObCI[p] = Ptr then
            begin
              o := ObjZv[Ptr].ObCI[i];
              if ObjZv[o].bP[2] then
              begin //---------------------------------------- Установлено ограждение пути
                if ObjZv[ObjZv[Ptr].BasOb].bP[1] then
                begin //-------------------------------------------- Стрелка нужна в плюсе
                  if not ObjZv[o].ObCB[p*2-27] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,145, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,145);
                    result := false;
                  end;
                end else
                if ObjZv[ObjZv[Ptr].BasOb].bP[2] then
                begin // Стрелка нужна в минусе
                  if not ObjZv[o].ObCB[p*2-26] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,145, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
end;
//========================================================================================
function SignCircOtpravlVP(ptr : SmallInt) : Boolean;
//----------------- проверить установку маршрута отправления с пути с примыкающей стрелкой
//----------------------- через хвост стрелки при проверке враждебностей сигнальной струны
var
  i,j,o,p : integer;
begin
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZv[ObjZv[Ptr].BasOb].ObCI[i];
    if p > 0 then
    begin
      case ObjZv[p].TypeObj of
        41 :
        begin //--------------------------- Контроль поездного маршрута отправления с пути
          if ObjZv[p].bP[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZv[p].ObCI[j];
              if o = ptr then
              begin //---------- проверить требуемое положение стрелки для обоих маршрутов
                if ObjZv[ObjZv[Ptr].BasOb].bP[1] then
                begin //-------------------------------------------- Стрелка нужна в плюсе
                  if not ObjZv[p].ObCB[(j-1)*3+3] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,478, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,478);
                    result := false;
                  end;
                end else
                if ObjZv[ObjZv[Ptr].BasOb].bP[2] then
                begin //------------------------------------------- Стрелка нужна в минусе
                  if not ObjZv[p].ObCB[(j-1)*3+4] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,478, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,478);
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
end;
//========================================================================================
function NegStrelki(ptr : SmallInt; pk : Boolean) : Boolean;
//---------------------------------------------------------------- Проверка негабаритности
//-------------------------------------------------------------------------  ptr - стрелка
//------------------------------------------------------- pk - значение датчика ПК стрелки
var
  i,o,p : integer;
begin
    result := true;
    //-------------------- Искать негабаритность через стык и отведенное положение стрелок
    if pk then
    begin //-------------------------------------------------------------- стрелка в плюсе
      if (ObjZv[Ptr].Sosed[3].TypeJmp = LnkNeg) or //-------------- негабаритный стык
      (ObjZv[Ptr].ObCB[8]) then //-------- или проверка отводящего положения стрелок
      begin //--------------------------------------------------- по минусовому примыканию
        o := ObjZv[Ptr].Sosed[3].Obj; //----------------------- объект за отклонением
        p := ObjZv[Ptr].Sosed[3].Pin; //--------------------------- точка подключения
        i := 100;
        while i > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :   //-------------------------------------------------------------- стрелка
            begin
              case p of
                2 :   //--------------------------------------------------- Вход по прямой
                if ObjZv[o].bP[2] then break; //---------- стрелка в отводе по минусу

                3 : //------------------------------------------------  Вход по отклонению
                if ObjZv[o].bP[1] then break; //----------- стрелка в отводе по плюсу

                else  ObjZv[Ptr].bP[3] := false; break; //------ ошибка в базе данных
              end;
              p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
            end;

            3,4 :  //-------------------------------------------------------- участок,путь
            begin
              if not ObjZv[o].bP[1] then //--------------- занятость путевого датчика
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,146, ObjZv[o].Liter,1);
                InsMsg(o,146);
                result := false;
              end;
              break;
            end;

            else
            if p = 1 then
            begin
              p := ObjZv[o].Sosed[2].Pin;
              o := ObjZv[o].Sosed[2].Obj;
            end else
            begin
              p := ObjZv[o].Sosed[1].Pin;
              o := ObjZv[o].Sosed[1].Obj;
            end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end else
  begin  //-------------------------------------------------------------- стрелка в минусе
    if (ObjZv[Ptr].Sosed[2].TypeJmp = LnkNeg) or //---------------- негабаритный стык
    (ObjZv[Ptr].ObCB[7]) then    //------- или проверка отводящего положения стрелок
    begin //------------------------------------------------------ по плюсовому примыканию
      o := ObjZv[Ptr].Sosed[2].Obj;
      p := ObjZv[Ptr].Sosed[2].Pin;
      i := 100;
      while i > 0 do
      begin
        case ObjZv[o].TypeObj of
          2 :
          begin //---------------------------------------------------------------- стрелка
            case p of
              2 :
              begin //------------------------------------------------------ Вход по плюсу
                if ObjZv[o].bP[2] then break; //---------- стрелка в отводе по минусу
              end;
              3 :
              begin //----------------------------------------------------- Вход по минусу
                if ObjZv[o].bP[1] then break; //----------- стрелка в отводе по плюсу
              end;
              else ObjZv[Ptr].bP[3] := false; break; //--------- ошибка в базе данных
            end;
            p := ObjZv[o].Sosed[1].Pin;
            o := ObjZv[o].Sosed[1].Obj;
          end;

          3,4 :
          begin //----------------------------------------------------------- участок,путь
            if not ObjZv[o].bP[1] then //----------------- занятость путевого датчика
            begin
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,146, ObjZv[o].Liter,1);
              InsMsg(o,146);
              result := false;
            end;
            break;
          end;

          else
          if p = 1 then
          begin
            p := ObjZv[o].Sosed[2].Pin;
            o := ObjZv[o].Sosed[2].Obj;
          end else
          begin
            p := ObjZv[o].Sosed[1].Pin;
            o := ObjZv[o].Sosed[1].Obj;
          end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end;
end;
//========================================================================================
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean) : Boolean;
//------------------------------------------ Проверка негабаритности для сигнальной струны
var
  i,o,p : integer;
begin
    result := true;
    //-------------------- Искать негабаритность через стык и отведенное положение стрелок
    if pk then
    begin //---------------------------------------------------------------- стрелка в плюсе
      if (ObjZv[Ptr].Sosed[3].TypeJmp = LnkNeg) or //---------------- негабаритный стык
      (ObjZv[Ptr].ObCB[8]) then //---------- или проверка отводящего положения стрелок
      begin //по минусовому примыканию
        o := ObjZv[Ptr].Sosed[3].Obj;
        p := ObjZv[Ptr].Sosed[3].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin // стрелка
              case p of
                2 :
                begin // Вход по плюсу
                  if ObjZv[o].bP[2] then break; // стрелка в отводе по минусу
                end;

                3 :
                begin // Вход по минусу
                  if ObjZv[o].bP[1] then break; // стрелка в отводе по плюсу
                end;

                else  ObjZv[Ptr].bP[3] := false; break; // ошибка в базе данных
              end;
              p := ObjZv[o].Sosed[1].Pin;
              o := ObjZv[o].Sosed[1].Obj;
            end;

            3,4 :
            begin // участок,путь
              if not ObjZv[o].bP[1] then // занятость путевого датчика
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,146, ObjZv[o].Liter,1); InsMsg(o,146);
                result := false;
              end;
              break;
            end;
            else
              if p = 1 then
              begin
                p := ObjZv[o].Sosed[2].Pin;
                o := ObjZv[o].Sosed[2].Obj;
              end else
              begin
                p := ObjZv[o].Sosed[1].Pin;
                o := ObjZv[o].Sosed[1].Obj;
              end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(i);
        end;
      end;
    end else
    begin // стрелка в минусе
      if (ObjZv[Ptr].Sosed[2].TypeJmp = LnkNeg) or // негабаритный стык
      (ObjZv[Ptr].ObCB[7]) then         // или проверка отводящего положения стрелок
      begin //по плюсовому примыканию
        o := ObjZv[Ptr].Sosed[2].Obj;
        p := ObjZv[Ptr].Sosed[2].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin // стрелка
              case p of
                2 :
                begin // Вход по плюсу
                  if ObjZv[o].bP[2] then break; // стрелка в отводе по минусу
                end;
                3 :
                begin // Вход по минусу
                  if ObjZv[o].bP[1] then break; // стрелка в отводе по плюсу
                end;
                else ObjZv[Ptr].bP[3] := false; break; // ошибка в базе данных
              end;
              p := ObjZv[o].Sosed[1].Pin;
              o := ObjZv[o].Sosed[1].Obj;
            end;

            3,4 :
            begin // участок,путь
              if not ObjZv[o].bP[1] then // занятость путевого датчика
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,146, ObjZv[o].Liter,1);
                InsMsg(o,146);
                result := false;
              end;
              break;
            end;

            else
            if p = 1 then
            begin
              p := ObjZv[o].Sosed[2].Pin;
              o := ObjZv[o].Sosed[2].Obj;
            end else
            begin
              p := ObjZv[o].Sosed[1].Pin;
              o := ObjZv[o].Sosed[1].Obj;
            end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(i);
        end;
      end;
    end;
end;
//========================================================================================
function VytajkaRM(ptr : SmallInt) : Boolean;
//------------------------------------------ Проверка условий передачи на маневровый район
var
  i,j,g,o,p,q : Integer;
  b,opi : boolean;
begin
  result := false;
  MarhTrac.MsgN := 0; MarhTrac.WarN := 0;
  if ptr < 1 then exit;

  // подсветить пути
  g := ObjZv[ptr].ObCI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          4  : ObjZv[o].bP[8] := false;
          43 : begin // объект оПИ
            if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
            begin // путь разрешен для маневров
              ObjZv[ObjZv[o].UpdOb].bP[8] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить секции
  g := ObjZv[ptr].ObCI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          3 : ObjZv[o].bP[8] := false;
          44 : begin // объект СМИ
            if ObjZv[o].bP[1] or ObjZv[o].bP[2] then ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[8] := false;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки в минусе
  g := ObjZv[ptr].ObCI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 :
            if ObjZv[ObjZv[o].UpdOb].bP[7] and not ObjZv[ObjZv[o].UpdOb].bP[8] then
            begin
              ObjZv[o].bP[6] := false; ObjZv[o].bP[7] := false;
              ObjZv[o].bP[12] := false; ObjZv[o].bP[13] := true;
            end;
          44 : begin // СМИ
            if ObjZv[o].bP[2] and
               ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[7] and
               not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[8] then
            begin
              ObjZv[ObjZv[o].UpdOb].bP[6] := false; ObjZv[ObjZv[o].UpdOb].bP[7] := false;
              ObjZv[ObjZv[o].UpdOb].bP[12] := false; ObjZv[ObjZv[o].UpdOb].bP[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки в плюсе
  g := ObjZv[ptr].ObCI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 :
            if ObjZv[ObjZv[o].UpdOb].bP[7] and not ObjZv[ObjZv[o].UpdOb].bP[8] then
            begin
              ObjZv[o].bP[6] := false; ObjZv[o].bP[7] := false;
              ObjZv[o].bP[12] := true; ObjZv[o].bP[13] := false;
            end;
          44 : begin // СМИ
            if ObjZv[o].bP[1] and
               ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[7] and
               not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[8] then
            begin
              ObjZv[ObjZv[o].UpdOb].bP[6] := false; ObjZv[ObjZv[o].UpdOb].bP[7] := false;
              ObjZv[ObjZv[o].UpdOb].bP[12] := true; ObjZv[ObjZv[o].UpdOb].bP[13] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки на управлении
  g := ObjZv[ptr].ObCI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            if ObjZv[ObjZv[o].UpdOb].bP[7] and not ObjZv[ObjZv[o].UpdOb].bP[8] then
            begin
              ObjZv[o].bP[12] := true; ObjZv[o].bP[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;

  //--------------------------------------------- проверить объекты СМИ для данной колонки
  for i := 1 to WorkMode.LimitObjZav do
  begin
    if (ObjZv[i].TypeObj = 44) and (ObjZv[i].BasOb = ptr) then
    begin
      if ObjZv[ObjZv[ObjZv[i].UpdOb].UpdOb].bP[7] and
         not ObjZv[ObjZv[ObjZv[i].UpdOb].UpdOb].bP[8] then
      begin
        ObjZv[ObjZv[i].UpdOb].bP[12] := ObjZv[i].bP[1];
        ObjZv[ObjZv[i].UpdOb].bP[13] := ObjZv[i].bP[2];
      end;
    end;
  end;

  // проверить условия на колонке
  if ObjZv[ptr].bP[6] then
  begin // ЭГС
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,105,ObjZv[ptr].Liter,1);
    InsMsg(ptr,105);
    exit;
  end;
  if ObjZv[ptr].bP[1] then
  begin // РМ
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258,ObjZv[ptr].Liter,1);
    InsMsg(ptr,258);
    exit;
  end;
  if ObjZv[Ptr].bP[4] then
  begin // если первичная передача на маневры - проверить:
  // проверить восприятие маневров на колонке
    if not ObjZv[Ptr].bP[5] then
    begin
      if ObjZv[ptr].bP[3] then
      begin // маневры еще не замкнуты
        inc(MarhTrac.WarN); MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,445,ObjZv[Ptr].Liter,1); InsWar(ptr,445);
      end;
    end;
  // исключения путей из маневров (разрешение приема или ограждения)
    b := false; opi := false;
    for i := 1 to WorkMode.LimitObjZav do
    begin
      if (ObjZv[i].TypeObj = 48) and (ObjZv[i].BasOb = ptr) then
      begin
        if not ObjZv[i].ObCB[3] then
        begin // контролировать возможность выхода на пути приема из маневрового района
          opi := true;
          if ObjZv[i].bP[1] then b := true;
        end;
      end;
    end;
    if opi and not b then
    begin // все пути исключены из маневрового района
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,427,ObjZv[Ptr].Liter,1);
      InsMsg(ptr,427);
      exit;
    end;
  end;

  // проверить дополнительные условия передачи на маневры
  g := ObjZv[ptr].ObCI[17];
  if g > 0 then
  begin
    for i := 1 to 5 do
    begin // проверка дополнительных условий по списку
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          4 : begin // путь
            if not ObjZv[o].bP[2] or not ObjZv[o].bP[3] then
            begin // установлен маршрут на путь (исключаются любые маршруты на путь)
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,341,ObjZv[o].Liter,1);
              InsMsg(o,341);
              exit;
            end;
          end;

          6 : begin // ограждение пути
            if ObjZv[o].bP[2] then
            begin // ограждение установлено
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,145,ObjZv[ObjZv[o].BasOb].Liter,1);
              InsMsg(ObjZv[o].BasOb,145);
              exit;
            end;
          end;

          23 : begin // увязка с маневровым районом
            if ObjZv[o].bP[1] then
            begin // есть УМП
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,256,ObjZv[o].Liter,1);
              InsMsg(o,256);
              exit;
            end else
            if ObjZv[o].bP[2] then
            begin // есть УМО
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,257,ObjZv[o].Liter,1);
              InsMsg(o,257);
              exit;
            end;
          end;

          25 : begin // маневровая колонка
            if not ObjZv[o].bP[1] then
            begin // нет разрешения маневров на проверяемой колонке
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,426,ObjZv[o].Liter,1); InsMsg(o,426); exit;
            end;
          end;

          33 : begin // дискретный датчик
            if ObjZv[o].bP[1] then
            begin
              inc(MarhTrac.MsgN);
              if ObjZv[o].ObCB[1] then
              begin
                MarhTrac.Msg[MarhTrac.MsgN] := MsgList[ObjZv[o].ObCI[3]]; InsMsg(o,3);
              end else
              begin
                MarhTrac.Msg[MarhTrac.MsgN] := MsgList[ObjZv[o].ObCI[2]]; InsMsg(o,2);
              end;
              exit;
            end;
          end;

          45 :
          begin //-------------------------------------------------------- зона оповещения
            if ObjZv[o].bP[1] then
            begin //----------------------- Включено оповещение в зоне местного управления
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,444,ObjZv[o].Liter,1);
              InsMsg(o,444);
              exit;
            end;
          end;

        end;
      end;
    end;
  end;

  // проверить секции вытяжки
  g := ObjZv[ptr].ObCI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          3 : begin
            if not ObjZv[o].bP[2] then
            begin // Участок замкнут
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82,ObjZv[o].Liter,1);
              InsMsg(o,82);
              exit;
            end;
            if not ObjZv[o].bP[5] then
            begin // Участок на маневрах
              for p := 20 to 24 do // найти колонку с замкнутыми маневрами
                if (ObjZv[o].ObCI[p] > 0) and (ObjZv[o].ObCI[p] <> ptr) then
                begin
                  if not ObjZv[ObjZv[o].ObCI[p]].bP[3] then
                  begin
                    inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258,ObjZv[ObjZv[o].ObCI[p]].Liter,1); InsMsg(ObjZv[o].ObCI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZv[o].bP[7] then
            begin // Участок замкнут на сервере
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,110,ObjZv[o].Liter,1); InsMsg(o,110); exit;
            end;
          end;
          44 : begin // СМИ
            if not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[2] then
            begin // Участок замкнут
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,82,ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].UpdOb,82); exit;
            end;
            if not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[5] then
            begin // Участок на маневрах
              for p := 20 to 24 do // найти колонку с замкнутыми маневрами
                if (ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p] > 0) and (ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p] <> ptr) then
                begin
                  if not ObjZv[ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p]].bP[3] then
                  begin
                    inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258,ObjZv[ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p]].Liter,1); InsMsg(ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[7] then
            begin // Участок замкнут на сервере
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,110,ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].UpdOb,110); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  // проверить светофоры вытяжки
  g := ObjZv[ptr].ObCI[20];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        if ObjZv[o].bP[1] or ObjZv[o].bP[2] or ObjZv[o].bP[3] or ObjZv[o].bP[4] then
        begin // сигнал открыт
          inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,114,ObjZv[o].Liter,1); InsMsg(o,114); exit;
        end;
      end;
    end;
  end;

  // проверить наличие контроля охранных стрелок в минусе
  g := ObjZv[ptr].ObCI[21];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
        begin // стрелка не имеет контроля
          inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
        end;
      end;
    end;
  end;
  // проверить наличие контроля охранных стрелок в плюсе
  g := ObjZv[ptr].ObCI[22];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
        begin // стрелка не имеет контроля
          inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
        end;
      end;
    end;
  end;
  // проверить наличие контроля ходовых стрелок в минусе
  g := ObjZv[ptr].ObCI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
            begin // стрелка не имеет контроля
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
            end;
          end;
          44 : begin
            if not ObjZv[ObjZv[o].UpdOb].bP[1] and not ObjZv[ObjZv[o].UpdOb].bP[2] then
            begin // стрелка не имеет контроля
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить наличие контроля ходовых стрелок в плюсе
  g := ObjZv[ptr].ObCI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
            begin // стрелка не имеет контроля
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
            end;
          end;
          44 : begin
            if not ObjZv[ObjZv[o].UpdOb].bP[1] and not ObjZv[ObjZv[o].UpdOb].bP[2] then
            begin // стрелка не имеет контроля
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить наличие контроля стрелок на управлении
  g := ObjZv[ptr].ObCI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            if not (ObjZv[o].bP[1] xor ObjZv[o].bP[2]) then
            begin // стрелка не имеет контроля
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
            end;
          end;
          44 : begin
            if not (ObjZv[ObjZv[o].UpdOb].bP[1] xor ObjZv[ObjZv[o].UpdOb].bP[2]) then
            begin // стрелка не имеет контроля
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить пути района
  g := ObjZv[ptr].ObCI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          4 : begin // путь
            if not ObjZv[o].bP[4] and (not ObjZv[o].bP[2] or not ObjZv[o].bP[3]) then
            begin // установлен поездной маршрут на путь
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,341,ObjZv[o].Liter,1); InsMsg(o,341); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  if WorkMode.RazdUpr then
  begin // в режиме раздельного управления проверить положение ходовых и охранных стрелок вытяжки

  // проверить объекты оПИ
    g := ObjZv[ptr].ObCI[15];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        q := ObjZv[g].ObCI[i];
        if q > 0 then
        begin
          case ObjZv[q].TypeObj of
            43 : begin // объект оПИ
              if ObjZv[q].bP[1] then
              begin // проверить отводящее положение стрелок
              // протрассировать выезд на пути из маневрового района
                opi := false;
                if ObjZv[q].ObCB[1] then p := 2 else p := 1;
                o := ObjZv[q].Sosed[p].Obj; p := ObjZv[q].Sosed[p].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZv[o].TypeObj of
                    2 : begin // стрелка
                      case p of
                        2 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[11] then
                          begin // есть возможность отвода стрелки
                            if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then break;
                            opi := true; break;
                          end;
                        end;
                        3 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[10] then
                          begin // есть возможность отвода стрелки
                            if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then break;
                            opi := true; break;
                          end;
                        end;
                      end;
                      p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
                    end;
                    48 : begin // РПо
                      opi := true; break;
                    end;
                  else
                    if p = 1 then begin p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj; end
                    else begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end;
                  end;
                  if (o = 0) or (p < 1) then break;
                  dec(j);
                end;

              // стрелки не установлены в отвод для пути, исключенного из маневров
                if opi then
                begin
                  inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,425,ObjZv[ObjZv[q].UpdOb].Liter,1); InsMsg(ObjZv[q].UpdOb,425); exit;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить ходовые стрелки в минусе
    g := ObjZv[ptr].ObCI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          case ObjZv[o].TypeObj of
            2 : begin
              if not ObjZv[o].bP[2] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
              begin // стрелка не имеет контроля в -
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,267,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,267); exit;
              end;
              if not SigCircNegStrelki(o,false) then exit;
              if ObjZv[o].bP[16] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[16]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[17]) then
              begin //--------------------------------------- стрелка закрыта для движения
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,119,ObjZv[o].Liter,1);
                InsMsg(o,119);
                exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1); InsMsg(o,453); exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZv[o].UpdOb,false) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin //-------------------------------------------------- стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить ходовые стрелки в плюсе
    g := ObjZv[ptr].ObCI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          case ObjZv[o].TypeObj of
            2 : begin
              if not ObjZv[o].bP[1] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
              begin // стрелка не имеет контроля в +
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,268,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,268); exit;
              end;
              if not SigCircNegStrelki(o,true) then exit;
              if ObjZv[o].bP[16] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[16]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[o].Liter,1); InsMsg(o,119); exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1); InsMsg(o,453); exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZv[o].UpdOb,true) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin // стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить охранные стрелки в минусе
    g := ObjZv[ptr].ObCI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[2] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // стрелка не имеет контроля в -
            inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,267,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,267); exit;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // стрелка на макете
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
            InsWar(ObjZv[o].BasOb,120+$5000);
          end;
        end;
      end;
    end;
  // проверить охранные стрелки в плюсе
    g := ObjZv[ptr].ObCI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[1] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // стрелка не имеет контроля в +
            inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,268,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,268); exit;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // стрелка на макете
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
            InsWar(ObjZv[o].BasOb,120+$5000);
          end;
        end;
      end;
    end;

  end else
  if WorkMode.MarhUpr then
  begin // в режиме маршрутного управления проверить возможность трассировки с проверкой маневровых враждебностей

    // проверить ходовые стрелки в минусе
    g := ObjZv[ptr].ObCI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin
              if not ObjZv[o].bP[2] and not ObjZv[o].bP[12] and ObjZv[o].bP[13] then
              begin // стрелка не имеет контроля минусового положения
                if not ObjZv[ObjZv[o].BasOb].bP[21] or
                   not ObjZv[ObjZv[o].BasOb].bP[22] or
                   ObjZv[ObjZv[o].BasOb].bP[24] then
                begin
                  inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,267,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,267); exit;
                end;
                if ObjZv[ObjZv[o].BasOb].bP[4] then
                begin
                  inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,80); exit;
                end;
                if ObjZv[o].bP[18] or ObjZv[ObjZv[o].BasOb].bP[18] then
                begin // выключена из управления
                  inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,159,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,159); exit;
                end;
              end;
              if not NegStrelki(o,false) then exit;
              if ObjZv[o].bP[16] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[16]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[o].Liter,1); InsMsg(o,119); exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1); InsMsg(o,453); exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 :
            begin
              if not ObjZv[ObjZv[o].UpdOb].bP[2] and
                 not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[12] and
                 ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[13] then
              begin // стрелка не имеет контроля минусового положения
                if not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[21] or
                   not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[22] or
                   ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[24] then
                begin
                  inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,267,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,267); exit;
                end;
                if ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[4] then
                begin
                  inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,80); exit;
                end;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[18] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[18] then
              begin // выключена из управления
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,151,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,151); exit;
              end;
              if not NegStrelki(ObjZv[o].UpdOb,false) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin // стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // проверить ходовые стрелки в плюсе
    g := ObjZv[ptr].ObCI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin
              if ObjZv[o].bP[12] and ObjZv[o].bP[13] then
              begin // есть езда по + и - сделано для Орска стрелка 202
                if ObjZv[o].bP[18] or ObjZv[ObjZv[o].BasOb].bP[18] then
                begin //------------------------------------------ выключена из управления
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,151,ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,151);
                  exit;
                end;
              end else
              if not ObjZv[o].bP[1] and ObjZv[o].bP[12] and not ObjZv[o].bP[13] then
              begin // стрелка не имеет контроля в плюсе
                if not ObjZv[ObjZv[o].BasOb].bP[21] or
                   not ObjZv[ObjZv[o].BasOb].bP[22] or
                   ObjZv[ObjZv[o].BasOb].bP[24] then
                begin
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,268,ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,268);
                  exit;
                end;
                if ObjZv[ObjZv[o].BasOb].bP[4] then
                begin
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80,ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,80);
                  exit;
                end;
                if ObjZv[o].bP[18] or ObjZv[ObjZv[o].BasOb].bP[18] then
                begin // выключена из управления
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,121,ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,121);
                  exit;
                end;
              end;
              if not NegStrelki(o,true) then exit;
              if ObjZv[o].bP[16] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[16]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[o].Liter,1);
                InsMsg(o,119);
                exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1);
                InsMsg(o,453);
                exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZv[ObjZv[o].UpdOb].bP[1] and
                 ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[12] and
                 not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[13] then
              begin // стрелка не имеет контроля в плюсе
                if not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[21] or
                   not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[22] or
                   ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[24] then
                begin
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,268,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1);
                  InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,268);
                  exit;
                end;
                if ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[4] then
                begin
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1);
                  InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,80);
                  exit;
                end;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[18] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[18] then
              begin // выключена из управления
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,151,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,151); exit;
              end;
              if not NegStrelki(ObjZv[o].UpdOb,true) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin // стрелка на макете
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. Продолжать?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // проверить охранные стрелки в минусе
    g := ObjZv[ptr].ObCI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[2] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // стрелка не имеет контроля в -
            if not ObjZv[ObjZv[o].BasOb].bP[21] or
               not ObjZv[ObjZv[o].BasOb].bP[22] or
               ObjZv[ObjZv[o].BasOb].bP[24] then
            begin
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,267,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,267); exit;
            end;
            if ObjZv[ObjZv[o].BasOb].bP[4] then
            begin
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,80); exit;
            end;
            if ObjZv[o].bP[18] or ObjZv[ObjZv[o].BasOb].bP[18] then
            begin // выключена из управления
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,235,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,235); exit;
            end;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // стрелка на макете
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
            InsWar(ObjZv[o].BasOb,120+$5000);
          end;
        end;
      end;
    end;

    // проверить охранные стрелки в плюсе
    g := ObjZv[ptr].ObCI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[1] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // стрелка не имеет контроля в +
            if not ObjZv[ObjZv[o].BasOb].bP[21] or
               not ObjZv[ObjZv[o].BasOb].bP[22] or
               ObjZv[ObjZv[o].BasOb].bP[24] then
            begin
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,268,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,268); exit;
            end;
            if ObjZv[ObjZv[o].BasOb].bP[4] then
            begin
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,8); exit;
            end;
            if ObjZv[o].bP[18] or ObjZv[ObjZv[o].BasOb].bP[18] then
            begin // выключена из управления
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,236,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,236); exit;
            end;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // стрелка на макете
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. Продолжать?';
            InsWar(ObjZv[o].BasOb,120+$5000);
          end;
        end;
      end;
    end;
  end;

  if MarhTrac.MsgN > 0 then
  begin
    ResetTrace; exit;
  end;

  ObjZv[ptr].bP[8] := true; // признак выдачи команды РМ
  result := true;
end;
//========================================================================================
function VytajkaZM(ptr : SmallInt) : Boolean;
//----------------------------------------------- Программное замыкание маневрового района
var
  i,g,o : Integer;
begin
  result := false;
  if ptr < 1 then exit;

  // замкнуть колонку
  ObjZv[ptr].bP[14] := true;

  // замыкание секции вытяжки
  g := ObjZv[ptr].ObCI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          3 : begin
            ObjZv[o].bP[14] := true;
          end;
          44 : begin
            if ObjZv[o].bP[1] or ObjZv[o].bP[2] then
              ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[14] := true;
          end;
        end;
      end;
    end;
  end;

  // погасить пути
  g := ObjZv[ptr].ObCI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          4  : ObjZv[o].bP[8] := true;
          43 : ObjZv[ObjZv[o].UpdOb].bP[8] := true;
        end;
      end;
    end;
  end;

  //--------------------------------------------------- замыкание ходовые стрелки в минусе
  g := ObjZv[ptr].ObCI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 :
          begin
            ObjZv[o].bP[13] := false;
            ObjZv[o].bP[7]  := true;
            ObjZv[o].bP[14] := true;
          end;
          44 :
          begin
            ObjZv[ObjZv[o].UpdOb].bP[13] := false;
            if ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[11] then
            ObjZv[ObjZv[o].UpdOb].bP[7] := true;
           ObjZv[ObjZv[o].UpdOb].bP[14] := true;
          end;
        end;
      end;
    end;
  end;

  // замыкание ходовые стрелки в плюсе
  g := ObjZv[ptr].ObCI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            ObjZv[o].bP[12] := false; ObjZv[o].bP[6] := true;
            ObjZv[o].bP[14] := true;
          end;
          44 : begin
            ObjZv[ObjZv[o].UpdOb].bP[12] := false;
            if ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[10] then
              ObjZv[ObjZv[o].UpdOb].bP[6] := true;
            ObjZv[ObjZv[o].UpdOb].bP[14] := true;
          end;
        end;
      end;
    end;
  end;

  // замыкание ходовых стрелок на управлении
  g := ObjZv[ptr].ObCI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            ObjZv[o].bP[12] := false; ObjZv[o].bP[6] := true;
            ObjZv[o].bP[13] := false; ObjZv[o].bP[7] := true;
            ObjZv[o].bP[14] := true;
          end;
        end;
      end;
    end;
  end;

end;
//========================================================================================
function VytajkaOZM(ptr : SmallInt) : Boolean;
//---------------------------------------------- Программное размыкание маневрового района
var
  i,g,o : Integer;
begin
  result := false;
  if ptr < 1 then exit;

  // разомкнуть колонку
  ObjZv[ptr].bP[14] := false;
  ObjZv[ptr].bP[8]  := false; // сбросить признак выдачи команды РМ

  // разомкнуть секции вытяжки
  g := ObjZv[ptr].ObCI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          3 : begin
            ObjZv[o].bP[8] := true; ObjZv[o].bP[14] := false;
          end;
          44 : begin
            ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[8] := true; ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовые стрелки в минусе
  g := ObjZv[ptr].ObCI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            ObjZv[o].bP[12] := false; ObjZv[o].bP[13] := false; ObjZv[o].bP[6] := false; ObjZv[o].bP[7] := false; ObjZv[o].bP[14] := false;
          end;
          44 : begin
            ObjZv[ObjZv[o].UpdOb].bP[12] := false; ObjZv[ObjZv[o].UpdOb].bP[13] := false;
            ObjZv[ObjZv[o].UpdOb].bP[6] := false; ObjZv[ObjZv[o].UpdOb].bP[7] := false; ObjZv[ObjZv[o].UpdOb].bP[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовые стрелки в плюсе
  g := ObjZv[ptr].ObCI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            ObjZv[o].bP[12] := false;
            ObjZv[o].bP[13] := false;
            ObjZv[o].bP[6]  := false;
            ObjZv[o].bP[7]  := false;
            ObjZv[o].bP[14] := false;
          end;
          44 : begin
            ObjZv[ObjZv[o].UpdOb].bP[12] := false;
            ObjZv[ObjZv[o].UpdOb].bP[13] := false;
            ObjZv[ObjZv[o].UpdOb].bP[6]  := false;
            ObjZv[ObjZv[o].UpdOb].bP[7]  := false;
            ObjZv[ObjZv[o].UpdOb].bP[14] := false;
          end;
        end;
      end;
    end;
  end;

  //--------------------------------------------- разомкнуть ходовые стрелок на управлении
  g := ObjZv[ptr].ObCI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          2 : begin
            ObjZv[o].bP[12] := false; ObjZv[o].bP[6] := false;
            ObjZv[o].bP[13] := false; ObjZv[o].bP[7] := false;
            ObjZv[o].bP[14] := false;
          end;
        end;
      end;
    end;
  end;

end;
//========================================================================================
function VytajkaCOT(ptr : SmallInt) : string;
//------------------------------------------------------- Проверка условий отмены маневров
var
  i,g,o : Integer;
begin
  result := '';
  MarhTrac.MsgN := 0; MarhTrac.WarN := 0;
  if ptr < 1 then exit;
  // проверить условия на колонке
  if ObjZv[ptr].bP[2] then
  begin // оТ
    result := GetSmsg(1,259,ObjZv[ptr].Liter,1); exit;
  end;

  // проверить секции вытяжки
  g := ObjZv[ptr].ObCI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          3 : begin
            if not ObjZv[o].bP[1] then
            begin
              result :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,83,ObjZv[o].Liter,1);
              exit;
            end;
          end;
          44 : begin
            if not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[1] then
            begin
              result :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,83,ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].Liter,1);
              exit;
            end;
          end;
        end;
      end;
    end;
  end;
end;

//========================================================================================
//--------------------------------- Получить индекс СП, имеющего враждебность для маршрута
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
var
  sp1,sp2 : integer;
begin
  sp1 := ObjZv[ObjZv[ObjZv[Obj].BasOb].ObCI[8]].UpdOb;
  sp2 := ObjZv[ObjZv[ObjZv[Obj].BasOb].ObCI[9]].UpdOb;
  case mode of
    1 : begin // замыкание СП
      if (sp1 > 0) and not ObjZv[sp1].bP[2] then result := sp1 else
      if (sp2 > 0) and not ObjZv[sp2].bP[2] then result := sp2 else
      result := ObjZv[Obj].UpdOb;
    end;
    2 : begin // занятость СП
      if (sp1 > 0) and not ObjZv[sp1].bP[1] then result := sp1 else
      if (sp2 > 0) and not ObjZv[sp2].bP[1] then result := sp2 else
        result := ObjZv[Obj].UpdOb;
    end;
  else
    result := Obj;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
procedure SetNadvigParam(Ptr : SmallInt);
//------------------------------------ установить признак ГВ на светофоры маршрута надвига
var
  max,o,p,nadv : integer;
begin
  //------------------------------------- найти трассу маршрута надвига и определить горку
  max := 1000; nadv := 0;
  o := ObjZv[Ptr].Sosed[2].Obj; p := ObjZv[Ptr].Sosed[2].Pin;
  while max > 0 do
  begin
    case ObjZv[o].TypeObj of
      2 : begin // стрелка
        case p of
          2 : begin
            if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
            begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end else break;
          end;
          3 : begin
            if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
            begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end else break;
          end;
        else
          if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
          begin
            p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
          end else
          if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
          begin
            p := ObjZv[o].Sosed[3].Pin; o := ObjZv[o].Sosed[3].Obj;
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
        p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
      end else
      begin
        p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
      end;
    end;
    dec(max);
  end;
  if nadv > 0 then
  begin // раскидать признак ГВ по светофорам маршрута
    ObjZv[Ptr].iP[2] := nadv;
    max := 1000;
    o := ObjZv[Ptr].Sosed[2].Obj; p := ObjZv[Ptr].Sosed[2].Pin;
    while max > 0 do
    begin
      case ObjZv[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin
              if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
              begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end else break;
            end;
            3 : begin
              if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
              begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end else break;
            end;
          else
            if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
            begin
              p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
            end else
            if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
            begin
              p := ObjZv[o].Sosed[3].Pin; o := ObjZv[o].Sosed[3].Obj;
            end else
              break;
          end;
        end;
        32 : begin // надвиг
          break;
        end;

        3 : begin // СП,УП
          ObjZv[o].iP[3] := nadv; // пометить признаком ГВ
          if p = 1 then
          begin
            p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
          end else
          begin
            p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
          end;
        end;
        5 : begin // светофор
          if p = 1 then
          begin // попутный светофор пометить признаком ГВ
            ObjZv[o].iP[2] := nadv;
            p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
          end else
          begin // встречный светофор пометить признаком УН
            ObjZv[o].iP[3] := nadv;
            p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
          end;
        end;
      else
        if p = 1 then
        begin
          p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
        end else
        begin
          p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
        end;
      end;
      dec(max);
    end;
  end;
end;

//========================================================================================
//------------------------- Установить / снять автодействие маршрута на объекте AvtoM (47)
function AutoMarsh(AvtoM : SmallInt; mode : Boolean) : Boolean;
var
  i,j,AvtoS,Str,g,signal,hvost : integer;
  vkl : boolean;
  jmp : TSos;
begin
  vkl := true;
  if mode then //----------------------------- признак включения/отключения автодействия
  begin //-------------------------------------------------------- включить автодействие
    for i := 10 to 12 do //--- пройти по цепочке описаний автодействий сигналов маршрута
    begin           //--------- попытаться установить автодействие всех сигналов цепочки
      AvtoS :=ObjZv[AvtoM].ObCI[i]; //------------------------------ очередное описание
      if AvtoS > 0 then
      with ObjZv[AvtoS] do
      begin
        signal := BasOb;
        if not ObjZv[signal].bP[4] and WorkMode.Upravlenie then //------ поездной закрыт
        begin //----------------------------------------------------- не открыт светофор
          result := false;
          ShowSMsg(429,LastX,LastY,ObjZv[signal].Liter);
          InsNewMsg(signal,429+$4000,1,''); //----------------------- Не открыт сигнал $
          exit;
        end;

        for j := 1 to 10 do //--------- пройти по стрелкам описания автодействия сигнала
        begin //-------------------------------------------- проверить положение стрелок
          Str := ObCI[j];
          if Str > 0 then
          begin
            if not ObjZv[Str].bP[1] and WorkMode.Upravlenie then
            begin //----------------------------------- нет контроля плюсового положения
              result := false;
              ShowSMsg(268,LastX,LastY,ObjZv[ObjZv[Str].BasOb].Liter);
              InsNewMsg(ObjZv[Str].BasOb,268+$4000,1,''); //Стрелка без контроля ПК
              exit;
            end;
            hvost:= ObjZv[Str].BasOb;
            if (ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19])and //------- признаки макета
            WorkMode.Upravlenie then
            begin //-------------------------------------------------- стрелка на макете
              result := false;
              ShowSMsg(120,LastX,LastY,ObjZv[hvost].Liter);
              InsNewMsg(hvost,120+$4000,1,'');
              exit;
            end;
          end;
        end;
      end;
    end;

    //-------------------------------------------- проверить враждебности для автодействия
    for i := 10 to 12 do
    begin
      AvtoS := ObjZv[AvtoM].ObCI[i];
      if AvtoS > 0 then
      begin
        g := ObjZv[AvtoS].ObCI[25]; //----------------------------------- взять КРУ
        MarhTrac1[g].Rod := MarshP;
        MarhTrac1[g].Finish := false;
        MarhTrac1[g].WarN := 0;
        MarhTrac1[g].MsgN := 0;
        MarhTrac1[g].ObjStart := ObjZv[AvtoS].BasOb;
        MarhTrac1[g].Counter := 0;
        j := 1000;

        jmp := ObjZv[ObjZv[AvtoS].BasOb].Sosed[2];
        MarhTrac1[g].Level := tlSetAuto; //-------------- режим установки автодействия
        MarhTrac1[g].FindTail := true;

        while j > 0 do
        begin
          case StepTrace(jmp,MarhTrac1[g].Level,MarhTrac1[g].Rod,g) of
            trStop, trEnd, trKonec : break;
          end;
            dec(j);
        end;
        if j < 1 then vkl := false; //------------------------ трасса маршрута разрушена
        if MarhTrac1[g].MsgN > 0 then vkl := false;
      end;
    end;

    if not vkl and WorkMode.Upravlenie then
    begin //--------------------------------------- отказано в установке на автодействие
      InsNewMsg(AvtoM,476+$4000,1,'');
      ShowSMsg(476,LastX,LastY,ObjZv[AvtoM].Liter); //Автодействие не может быть вкл.
      SBeep[4] := true;
      result := false;
      exit;
    end;

    //------------------------------------------------- расставить признаки автодействия
    for i := 10 to 12 do
    begin
      AvtoS := ObjZv[AvtoM].ObCI[i];
      if AvtoS > 0 then
      begin
        ObjZv[AvtoS].bP[1] := vkl;
        AutoMarshON(AvtoS,ObjZv[AvtoM].ObCB[1]);
      end;
    end;
    ObjZv[AvtoM].bP[1] := vkl;
    result := vkl;
  end else
  begin //------------------------------------------------------- отключить автодействие
    for i := 10 to 12 do
    if ObjZv[AvtoM].ObCI[i] > 0 then
    begin //--------------------------------- сбросить автодействие всех сигналов группы
      AvtoS := ObjZv[AvtoM].ObCI[i];
      ObjZv[AvtoS].bP[1] := false;
      AutoMarshOFF(AvtoS,ObjZv[AvtoM].ObCB[1]);
    end;
    ObjZv[AvtoM].bP[1] := false;
    result := true;
  end;
end;

//========================================================================================
//---------------- Разнести признаки автодействия по объектам трассы маршрута автодействия
function AutoMarshON(AvtoS : SmallInt; Napr : Boolean) : Boolean;
var
  Str,Sig,ob,p,j,vid : integer;
begin
  result := false;

  if ObjZv[AvtoS].BasOb = 0 then exit
  else Sig := ObjZv[AvtoS].BasOb;

  for j := 1 to 10 do
  if ObjZv[AvtoS].ObCI[j] > 0 then
  begin
    Str := ObjZv[AvtoS].ObCI[j];
    if Napr then ObjZv[Str].bP[33] := true
    else ObjZv[Str].bP[25] := true;
    ObjZv[Str].bP[4] := ObjZv[Str].bP[33] or ObjZv[Str].bP[25];
  end;


  ob := ObjZv[Sig].Sosed[2].Obj;   p := ObjZv[Sig].Sosed[2].Pin;

  ObjZv[Sig].bP[33] := true;

  j := 100;
  while j > 0 do
  begin
    case ObjZv[ob].TypeObj of
      2 :  //--------------------------------------------------------------------- стрелка
      begin
        vid := ObjZv[ob].VBufInd;
        OVBuffer[vid].Param[28] := ObjZv[ob].bP[4];
        if p = 1 then
        begin  p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end else
        begin  p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
      end;

      3 :  //----------------------------------------------- ставим автодействие на секцию
      begin
        ObjZv[ob].bP[33] := true;
        if p = 1 then
        begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end  else
        begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
      end;

      4 : //------------------------------------------------------------------------- путь
      begin
        ObjZv[ob].bP[33] := true;
        if p = 1 then
        begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj;  end else
        begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;  end;
      end;

      5 :  //-------------------------------------------------------------------- светофор
      begin
        if p = 1 then
        begin
          if ObjZv[ob].ObCB[5] then break; //--- конец поездных в точке 1 - завершить
          ObjZv[ob].bP[33] := true;
          p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj;
        end else
        begin
          if ObjZv[ob].ObCB[6] then break; //--- конец поездных в точке 2 - завершить
          ObjZv[ob].bP[33] := true;
          p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- АБ
        ObjZv[ob].bP[33] := true; break;
      end;

      else //--------------------------------------------------------------- все остальные
      if p = 1 then
      begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end else
      begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;
      end;
    end;

    if ob < 1 then break;
    dec(j);
  end;
  result := true;
end;

//========================================================================================
//-------------- Снять автодействие сигнала в указанном направлении (объект AvtoS типа 46)
function AutoMarshOFF(AvtoS : SmallInt; Napr : Boolean) : Boolean;
var
  Str,Sig,p,ob,j,vid : integer;
begin
  result := false;
  with ObjZv[AvtoS] do
  begin
    if BasOb = 0 then exit;
    for j := 1 to 10 do
    if ObCI[j] > 0 then
    begin
      Str := ObCI[j];
      if Napr then ObjZv[Str].bP[33]:=false else ObjZv[Str].bP[25]:= false;//снять ЧАС/НАС
      ObjZv[Str].bP[4] := ObjZv[Str].bP[25] or ObjZv[Str].bP[33];
    end;

    Sig := BasOb;   //------------------------------ сигнал увязанный с автодействием
    ob := ObjZv[Sig].Sosed[2].Obj; //------------------------ объект следующий за сигналом
    p := ObjZv[Sig].Sosed[2].Pin;  //--------------------- точка связи объекта за сигналом
    ObjZv[Sig].bP[33] := false; //---------------------------- убрать автодействие сигнала

    j := 100;
    while j > 0 do
    begin
      case ObjZv[ob].TypeObj of
       2 :
       begin //------------------------------------------------------------------- стрелка
        if Napr then ObjZv[ob].bP[33] := false
        else ObjZv[ob].bP[25] := false;
        vid := ObjZv[ob].VBufInd;
        OvBuffer[vid].Param[28] := ObjZv[ob].bP[33] or ObjZv[ob].bP[25];// замыкание АВТОД
        //--------------------- пока считаем что все стрелки в автодействии стоят по плюсу
        if p = 1 then begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
        else  begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
       end;

        3 :
        begin //------------------------------------------------------------------- секция
          ObjZv[ob].bP[33] := false;  //-------------------------- снять автодействие с СП
          if p = 1 then begin p:=ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
          else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
        end;

        4 :
        begin //--------------------------------------------------------------------- путь
          ObjZv[ob].bP[33] := false;
          if p = 1 then begin p:= ObjZv[ob].Sosed[2].Pin; ob:= ObjZv[ob].Sosed[2].Obj; end
          else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
        end;

        5 :
        begin //----------------------------------------------------------------- светофор
          if p = 1 then
          begin
            if ObjZv[ob].ObCB[5] then break;//есть поездной конец перед сигналом-стоп
            ObjZv[ob].bP[33] := false; //------------------------------ снять автодействие
          p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj;
        end else
        begin
          if ObjZv[ob].ObCB[6] then break; //--------- вышли на поездной конец - стоп
          ObjZv[ob].bP[33] := false;
          p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- АБ
        ObjZv[ob].bP[33] := false;
        break;
      end;
      else //--------------------------------------------------------------- все остальные
        if p = 1 then begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
        else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
    end;
    if ob < 1 then break;
    dec(j);
  end;

  end;
end;

//========================================================================================
//------------------------------ процедура прохода в маршруте через объект базы "стрелка"
function StepTrasStr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
begin
  case Lvl of //-------------------------------------------- переключатель по типу прохода
    tlFindTrace    :  result := StepStrFindTras(Con,Lvl,Rod,Str);
    tlContTrace    :  result := StepStrContTras(Con,Lvl,Rod,Str);
    tlVZavTrace    :  result := StepStrZavTras (Con,Lvl,Rod,Str);
    tlCheckTrace   :  result := StepStrChckTras(Con,Lvl,Rod,Str);
    tlZamykTrace   :  result := StepStrZamTras (Con,Lvl,Rod,Str);

    tlSetAuto,
    tlSignalCirc   :  result := StepStrCirc(Con,Lvl,Rod,Str);

    tlOtmenaMarh   :  result := StepStrOtmen   (Con,Lvl,Rod,Str);
    tlRazdelSign   :  result := StepStrRazdel  (Con,Lvl,Rod,Str);
    tlFindIzvest   :  result := StepStrFindIzv (Con,Lvl,Rod,Str);
    tlFindIzvStrel :  result := StepStrFindStr (Con,Lvl,Rod,Str);
    tlPovtorMarh   :  result := StepStrPovtMarh(Con,Lvl,Rod,Str);
    tlAutoTrace    :  result := StepStrAutoTras(Con,Lvl,Rod,Str);
    else              result := trEnd;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------- шаг через секцию
function StepTrasSP(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  k : integer;
  tail : boolean;
begin
  case Lvl of
    tlFindTrace    : result := StepSpPutFindTras(Con, Lvl, Rod, Sp);
    tlContTrace    : result := StepSPContTras(Con, Lvl, Rod, Sp);
    tlVZavTrace    : result := StepSpZavTras (Con, Lvl, Rod, Sp);
    tlCheckTrace   : result := StepSрChckTras(Con, Lvl, Rod, Sp);
    tlZamykTrace   : result := StepSpZamTras (Con, Lvl, Rod, Sp);

    tlSetAuto,
    tlSignalCirc   : result := StepSpCirc     (Con, Lvl, Rod, Sp);

    tlOtmenaMarh   : result := StepSPOtmen    (Con, Lvl, Rod, Sp);
    tlRazdelSign   : result := StepSpRazdel   (Con, Lvl, Rod, Sp);
    tlPovtorRazdel : result := StepSpPovtRazd (Con, Lvl, Rod, Sp);
    tlAutoTrace    : result := StepSpAutoTras (Con, Lvl, Rod, Sp);
    tlFindIzvest   : result := StepSpFindIzv  (Con, Lvl, Rod, Sp);
    tlFindIzvStrel : result := StepSpFindStr  (Con, Lvl, Rod, Sp);
    tlPovtorMarh   : result := StepSPPovtMarh (Con, Lvl, Rod, Sp);
    else             result := trNext;
  end;
end;

//========================================================================================
function StepTrasPut(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
//----------------------------------- (4) процедура выполнения шага трассировки через путь
//---------- Con - соединитель с соседним объектом, с которого трасса вышла на данный путь
//---------- Lvl -------------------------------------------- уровень трассировки маршрута
//---------- Rod ------------------------------------------------------------ тип маршрута
//---------- Put ---------------------------------------- объект зависимостей данного пути

var
  k : integer;
  tail : boolean;
begin
  case Lvl of
    tlFindTrace    : result := StepSpPutFindTras(Con, Lvl, Rod, Put);
    tlContTrace    : result := StepPutContTras  (Con, Lvl, Rod, Put);
    tlVZavTrace    : result := StepPutZavTras   (Con, Lvl, Rod, Put);
    tlCheckTrace   : result := StepPutChckTras  (Con, Lvl, Rod, Put);
    tlZamykTrace   : result := StepPutZamTras (  Con, Lvl, Rod, Put);

    tlSetAuto,
    tlSignalCirc   : result := StepPutCirc    (Con, Lvl, Rod, Put);

    tlOtmenaMarh   : result := StepPutOtmena  (Con, Lvl, Rod, Put);
    tlRazdelSign   : result := StepPutRazdel  (Con, Lvl, Rod, Put);
    tlAutoTrace    : result := StepPutAutoTras(Con, Lvl, Rod, Put);
    tlFindIzvest   : result := StepPutFindIzv (Con, Lvl, Rod, Put);
    tlFindIzvStrel : result := StepPutFindStr (Con, Lvl, Rod, Put);

    tlPovtorRazdel,
    tlPovtorMarh   : result := StepPutPovtMarh(Con, Lvl, Rod, Put);
         else        result := trEnd;
  end;
end;

//========================================================================================
//------------------------------------------------------ пройти шаг через светофор по базе
function StepTrasSig (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//- Con : TSos - при входе Con = jmp (откуда пришли), при выходе Con - куда уходим
//--------------------------------------- Lvl : TTrLev ---- этап работы с маршрутом
//------------------------------------------------------------ Rod:Byte ----- тип маршрута
//------------------------- jmp : TSos ------  связь с соседом, от которого пришли
//------- таким образом jmp.Obj - это светофор, через который функция проводит шаг по базе
begin
  case Lvl of
    tlFindTrace    :  result := StepSigFindTras  (Con, Lvl, Rod, Sig);
    tlContTrace    :  result := StepSigContTras  (Con, Lvl, Rod, Sig);
    tlVZavTrace    :  result := StepSigZavTras   (Con, Lvl, Rod, Sig);
    tlCheckTrace   :  result := StepSigChckTras  (Con, Lvl, Rod, Sig);
    tlZamykTrace   :  result := StepSigZamTras   (Con, Lvl, Rod, Sig);

    tlSetAuto,
    tlSignalCirc   :  result := StepSigCirc      (Con, Lvl, Rod, Sig);

    tlOtmenaMarh   :  result := StepSigOtmena    (Con, Lvl, Rod, Sig);
    tlAutoTrace,
    tlPovtorRazdel,
    tlRazdelSign   :  result := StepSigAutoTras (Con, Lvl, Rod, Sig);
    tlFindIzvest   :  result := StepSigFindIzv  (Con, Lvl, Rod, Sig);
    tlFindIzvStrel :  result := StepSigFindStr  (Con, Lvl, Rod, Sig);
    tlPovtorMarh   :  result := StepSigPovtMarh (Con, Lvl, Rod, Sig);
    else              result := trEnd;
  end;
end;

//========================================================================================
//---------------------------------------- (15) процедура трассировки через АвтоБлокировку
function StepTrasAB(var Con:TSos; const Lvl:TTrLev; Rod:Byte; AB:TSos):TTrRes;
var
  NumTxt,WarTxt : integer;
begin
  NumTxt := 0;
  WarTxt := 0;
  with ObjZv[AB.Obj] do
  begin
    case Lvl of
      tlFindTrace : //------------------------------------------------------- поиск трассы
      begin
        result := trNext;
        if not MarhTrac.LvlFNext then  //----------------------- если не следующий маршрут
        if Con.Pin=1 then Con:= Sosed[2] else  Con := Sosed[1];
        if(Con.TypeJmp = LnkRgn) or(Con.TypeJmp = LnkEnd) then result := trRepeat;
      end;

      // Довести трассу до конца или отклоняющей стрелки, если есть отправление на перегон
      tlContTrace : if(Rod=MarshP) and ObCB[1] then result:= trKonec else result:= trStop;

      //----------------------------- проверить охранности по трассе (концы района и базы)
      tlVZavTrace :
      begin
        if Con.Pin = 1 then  Con := Sosed[2] else Con := Sosed[1];
        if(Con.TypeJmp = LnkRgn) then result := trEnd else
        if(Con.TypeJmp = LnkEnd) then result := trStop else
        result := trNext;
      end;

      tlCheckTrace : //------------ проверить трассу на возможность осуществления маршрута
      begin
        result := trNext;
        case Rod of
          MarshP :
          begin
            if not bP[6] then //-------------------------------------------- если изъят КЖ
            begin
              if ObCB[3] and (bP[7] or bP[8]) then // комплект капремонта подключен к пути
              begin result := trBreak; NumTxt := 363; end //----- запретить отправление ХП
              else begin result:= trBreak; WarTxt:= 133;end;//предупреждение для хозпоезда
            end;

            if ObCB[1] then //-------------------------------- есть отправление на перегон
            begin
              if ObCB[2] then//------------------------------- если есть смена направления
              begin
                if ObCB[3] then//------------------------------ если подключаемый комплект
                begin
                  if ObCB[4] then //---------------------- перегон по приему без комплекта
                  begin
                    //-------------------- Комплект не подключен или подключен неправильно
                    if not bP[7] or bP[8] then begin result := trBreak; NumTxt := 132; end
                    else
                    if not ObCB[10] then  //---------------------------- если не однопутка
                    begin//------------------------------ СН не установлено на отправление
                      if not bP[4] then begin result := trBreak; NumTxt := 128; end;
                    end else //-------------------------------------------- если однопутка
                    begin
                      if not bP[4] and not bP[5] then //- перегон по приему, занят перегон
                      begin result := trBreak; NumTxt := 262; end;
                    end;
                  end else
                  if ObCB[5] then //------------------------------- перегон по отправлению
                  begin //--------------------------------- Комплект подключен неправильно
                    if bP[7] then begin result := trBreak; NumTxt := 132; end else
                    //------------------- ПРИЕМ, Не установлено направление по отправлению
                    if bP[8] and not bP[4] then begin result:= trBreak; NumTxt:= 128; end;
                  end;
                end else
                begin //------------------- комплект смены направления подключен постоянно
                  if not ObCB[10] then  //------------------------ если не однопутка и ...
                  begin
                     //------------------ ПРИЕМ, Не установлено направление по отправлению
                    if not bP[4] then begin result := trBreak;NumTxt := 128; end;
                  end else //---------------------------------------------- если однопутка
                  //------------------------------------------------ прием и занят перегон
                  if not bP[4] and not bP[5] then begin result:= trBreak;NumTxt:= 262;end;
                end;
              end;
            end //--------------------------------------------- нет отправления на перегон
            else begin result := trBreak; NumTxt := 131; end;

            if ObCB[3] then  //-------------------------------- если подключаемый комплект
            begin
              if ObCB[4] then //------------------------------- если без комплекта - прием
              begin //----------------- а с комплектом - отправление по неправильному пути
                if not bP[2] or not bP[3] then //---- 1ип или 2ип = Занят участок удаления
                begin result := trBreak;  NumTxt := 129; end;
              end else
              // Отправление по правильному пути реагируем на 1ип = Занят участок удаления
              if not bP[2] then begin result := trBreak; NumTxt := 129; end;
            end else //------------------------------- если нет подключаемого комплекта СН
            //------------------------------------------------- 1ИП Занят участок удаления
            if not bP[2] then begin result := trBreak; NumTxt := 129; end;
            //-------------------------------------------------------- отправлен хоз.поезд
            if bP[9] then begin result := trBreak; NumTxt := 130; end;

            if bP[12] or  bP[13] then //----- перегон заблокирован программно ("колпачок")
            begin result := trBreak; NumTxt := 432; end;

            if ObCB[8] or ObCB[9] then  //---------------------------------------- если ЭТ
            begin
              //----------------------------------------------- Закрыт для движения на ЭТ.
              if bP[24] or bP[27] then WarTxt := 462
              else
              if ObCB[8] and ObCB[9] then //------------------------------------- любая ЭТ
              begin
                if bP[25] or bP[28] then WarTxt := 467;// Закрыт для движения на пост.токе
                if bP[26] or bP[29] then WarTxt := 472;//Закрыт для движения на перем.токе
              end;
            end else WarTxt := 474;//-------------------- конец подвески контакной провода
          end;

          MarshM :
          begin
            //
          end;
          else   result := trStop; exit;
        end;

        if (result = trBreak) and (NumTxt > 0) then
        begin
          inc(MarhTrac.MsgN);MarhTrac.Msg[MarhTrac.MsgN]:= GetSmsg(1,NumTxt, Liter,1);
          InsMsg(AB.Obj,NumTxt); MarhTrac.GonkaStrel := false; exit;
        end else
        if (WarTxt > 0) then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,WarTxt, Liter,1);
          InsWar(AB.Obj,WarTxt);
        end;


        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];
        if (Con.TypeJmp = LnkRgn) or (Con.TypeJmp = LnkEnd) then result := trEnd;
      end;

      tlAutoTrace,
      tlPovtorRazdel,
      tlRazdelSign,
      tlSignalCirc :
      begin
        result := trNext;

        if Rod = MarshP then
        begin
          if not bP[6] then //--------------------------------------------------------- КЖ
          begin
            if ObCB[3] and (bP[7] or bP[8]) then begin NumTxt:= 363; result:= trBreak;end
            // Подключаемый комплект-запрещено отправление хозпоезда, иначе предупреждение
            else WartXT := 133;
          end;

          if ObCB[1] then //---------------------------------- есть отправление на перегон
          begin
            if ObCB[2] then //------------------------------------- есть смена направления
            begin
              if ObCB[3] then //------------------------------ имеется комплект капремонта
              begin
                if ObCB[4] then //------------------------------------ без комплекта прием
                begin
                  if (not bP[7]) or (bP[7] and bP[8]) then //-- Не подключен или с ошибкой
                  begin  NumTxt := 132; result:= trBreak; end else

                  if not ObCB[10] and not bP[4] then //----  не однопутка и не отправление
                  begin NumTxt := 128; result:= trBreak; end;
                end else
                if ObCB[5] then //------------------------------ без комплекта отправление
                begin
                  //--------------------------------------------- Д1 подключен неправильно
                  if bP[7] then begin NumTxt := 132; result:= trBreak; end else
                  if bP[8] then //----------------------------------------------------- Д2
                  if not bP[4] then begin NumTxt := 128; result:= trBreak; end; //-- прием
                end;
              end
              //------------------------------------------- комплект СН  постоянно включен
              else if not bP[4] then begin NumTxt := 128; result:= trBreak; end;//-- прием
            end;
          end else
          begin NumTxt := 131; result:= trBreak; end; //------- нет отправления на перегон

          if ObCB[3] then //------------------------ существует комплект СН для капремонта
          begin
            if ObCB[4] then //------------------------- при отключении комплекта = прием
            begin //Отправление по неправильному,  1ип  или 2ип = Занят участок удаления
              if not bP[2] or not bP[3] then begin NumTxt := 129; result:= trBreak; end;
            end else
            begin //---- Отправление по правильному пути, 1ИП - Занят участок
              if not bP[2] then begin NumTxt := 129; result:= trBreak; end;
            end;
          end else //-------------------------------------------- постоянный комплект СН
          begin
            if not bP[2] then //---------------------------------------------------- 1ИП
            begin
              if Lvl= tlAutoTrace then exit;
              NumTxt := 129;
              result:= trBreak; //--------------------------------- Занят участок удаления
            end;
          end;

          if bP[9] then begin NumTxt := 130; result:= trBreak; end;//- отправлен хоз.поезд
          if bP[12] or bP[13] then begin NumTxt:=433;result:= trBreak;end;//Перегон закрыт

          if ObCB[8] or ObCB[9] then//-------------------------- оборудован электротягой
          begin
            if bP[24] or bP[27] then  WarTxt := 462 //----- Закрыт для движения на эл.т.
            else
            if ObCB[8] and ObCB[9] then //---------------------- два вида ЭТ на перегоне
            begin
              if bP[25] or bP[28] then WarTxt:=467;//---- Закрыт для движения на пост.т.
              if bP[26] or bP[29] then WarTxt:=472; //---- Закрыт для движения на пер.т.
            end;
          end else  WarTxt:=474;//--------------------- Участок $ не электрифицированный
        end else
        if Rod = MarshM then begin  end
        else  begin result := trStop; exit; end;

        if (result = trBreak) and (NumTxt > 0) then
        begin
          inc(MarhTrac.MsgN);MarhTrac.Msg[MarhTrac.MsgN]:= GetSmsg(1,NumTxt, Liter,1);
          InsMsg(AB.Obj,NumTxt); MarhTrac.GonkaStrel := false; exit;
        end else
        if (WarTxt > 0) then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,WarTxt, Liter,1);
          InsWar(AB.Obj,WarTxt);
        end;

        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];
        if(Con.TypeJmp = LnkRgn) or (Con.TypeJmp = LnkEnd) then result := trEnd;
      end;

      tlPovtorMarh :
      begin
        MarhTrac.ObjEnd := AB.Obj; //------------ зафиксировать конец маршрута отправления
        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];
        if Con.TypeJmp = LnkRgn then result := trEnd else
        if Con.TypeJmp = LnkEnd then result := trStop
        else result := trNext;
      end;

      tlZamykTrace :
      begin
        bP[14] := true;  bP[15] := true;   //--------------------------- замкнуть в трассе
        iP[1] := MarhTrac.ObjStart; //--------------------- записать индекс сигнала начала
        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];
        if Con.TypeJmp = LnkRgn then result := trEnd else
        if Con.TypeJmp = LnkEnd then result := trStop
        else result := trNext;
      end;

      tlOtmenaMarh :
      begin
        bP[14] := false; bP[15] := false; //----------------------------------- разомкнуть
        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];

        if Con.TypeJmp = LnkRgn then result := trEnd else
        if Con.TypeJmp = LnkEnd then result := trStop
        else result := trNext;
      end;

      tlFindIzvest :
      begin
        if ObCB[2] then  //--------------------------- для перегона есть смена направления
        begin
          if ObCB[3] then //---------------------------------- комплект СН капремонтовский
          begin
            if ObCB[4] then //-------------- без комплекта перегон специализован по приему
            begin
              if bP[7] and not bP[8] then   //----------------- подключен Д1 и отключен Д2
              begin
                if bP[4] then //------------------------------ перегон установлен на прием
                begin
                  if not bP[2] or not bP[3] then result := trBreak //-- занят 1ип или 2ип
                  else result := trStop;
                end else result := trStop;
              end else //-----------------------------------------  Д1 и Д2 включены иначе
              if not bP[2] or not bP[3] then result := trBreak      //-- занят 1ип или 2ип
              else result := trStop;
            end else
            if ObCB[5] then //----------------------- перегон специализован по отправлению
            begin
              if not bP[7] and bP[8] then   //----------------- подключен Д2 и отключен Д1
              begin
                if not bP[4] then //------------------------- на перегоне установлен прием
                begin
                  if not bP[2] or not bP[3] then result := trBreak  //-- занят 1ип или 2ип
                  else result := trStop;
                end else
                if not bP[2] then result := trBreak else result := trStop;
              end else result := trStop;
            end else result := trStop;
          end else
          begin //------------------------------------------- комплект подключен постоянно
            if not bP[4] then //------------------------------ перегон установлен на прием
            begin
              if not bP[2] or not bP[3] then result := trBreak //------ Занято приближение
              else result := trStop;
            end else
            if not bP[2] then result := trBreak else result := trStop;
          end;
        end else //-------------------------------------- у перегона нет смены направления
        if ObCB[4] then //-------------------------------- перегон специализован по приему
        begin
          if not bP[2] or not bP[3] then result := trBreak //---------- Занято приближение
          else result := trStop
        end else result := trStop;
      end;

      tlFindIzvStrel :    result := trStop;

      else
      if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];
      if (Con.TypeJmp = LnkRgn) or (Con.TypeJmp = LnkEnd) then result := trEnd
      else result := trNext;
    end;
  end;
end;

//========================================================================================
//------------------------------------------------------------- Пригласительный сигнал (7)
function StepTrasPrigl(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Prig:TSos) : TTrRes;
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Prig.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Prig.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Prig.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Prig.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlCheckTrace :
    begin
      result := trNext;
      if ObjZv[Prig.Obj].bP[1] then //--------------------------------------------- ПС
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,116, ObjZv[Prig.Obj].Liter,1);
        InsMsg(Prig.Obj,116); //------------ Открыт враждебный пригласительный сигнал
        MarhTrac.GonkaStrel := false;
      end;

      if Con.Pin = 1 then   //---------------------------------- встречный пригласительный
      begin
        Con := ObjZv[Prig.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else  //----------------------------------------------- попутный пригласительный
      begin
        Con := ObjZv[Prig.Obj].Sosed[1];
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
      result := trNext;
      if ObjZv[Prig.Obj].bP[1] then //--------------------------------------------- ПС
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,116, ObjZv[Prig.Obj].Liter,1);//---- Открыт враждебный пригласительный
        InsMsg(Prig.Obj,116);
      end;
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Prig.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Prig.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZv[Prig.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNext;
      end;
    end else
    begin
      Con := ObjZv[Prig.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNext;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------- УКСПС (14)
function StepTrasUksps(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Uksps:TSos) : TTrRes;
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Uksps.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Uksps.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Uksps.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Uksps.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tlCheckTrace :
    begin
      result := trNext;
      case Rod of
        MarshP :
        begin
          if ObjZv[Uksps.Obj].BasOb = MarhTrac.ObjStart then
          begin
            if ObjZv[Uksps.Obj].bP[1] then //----------------------------------------- ИКС
            begin
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,124, ObjZv[Uksps.Obj].Liter,1);
              InsWar(Uksps.Obj,124);
            end else
            begin
              if ObjZv[Uksps.Obj].bP[3] then //--------------------------------------- 1КС
              begin
                result := trBreak;
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                GetSmsg(1,125, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,125);
                MarhTrac.GonkaStrel := false;
              end;

              if ObjZv[Uksps.Obj].bP[4] then //--------------------------------------- 2КС
              begin
                result := trBreak;
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                GetSmsg(1,126, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,126);
                MarhTrac.GonkaStrel := false;
              end;

              if ObjZv[Uksps.Obj].bP[5] then //--------------------------------------- КзК
              begin
                result := trBreak;
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                GetSmsg(1,127, ObjZv[Uksps.Obj].Liter,1);
                InsMsg(Uksps.Obj,127);
                MarhTrac.GonkaStrel := false;
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
        Con := ObjZv[Uksps.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Uksps.Obj].Sosed[1];
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
      result := trNext;
      case Rod of
        MarshP :
        begin
          if ObjZv[Uksps.Obj].BasOb = MarhTrac.ObjStart then
          begin
            if ObjZv[Uksps.Obj].bP[1] then //-------------------------------------- ИКС
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,124, ObjZv[Uksps.Obj].Liter,1);
              InsWar(Uksps.Obj,124);
            end else
            begin
              if ObjZv[Uksps.Obj].bP[3] then //------------------------------------ 1КС
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,125, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,125);
              end;

              if ObjZv[Uksps.Obj].bP[4] then //------------------------------------ 2КС
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,126, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,126);
              end;

              if ObjZv[Uksps.Obj].bP[5] then //------------------------------------ КзК
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,127, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,127);
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
        Con := ObjZv[Uksps.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Uksps.Obj].Sosed[1];
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
      Con := ObjZv[Uksps.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNext;
      end;
    end else
    begin
      Con := ObjZv[Uksps.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNext;
      end;
    end;
  end;
end;

//========================================================================================
function StepTrasVsn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Vsn:TSos) : TTrRes;
//---------------------------------------------- Вспомогательная смена направления АБ (16)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Vsn.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else     result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Vsn.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else     result := trNext;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Vsn.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else     result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Vsn.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
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

      result := trNext;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[Vsn.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Vsn.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    else
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Vsn.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else  result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Vsn.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNext;
        end;
      end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepTrasManRn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; ManR:TSos) : TTrRes;
//------------------------------------------------------- Увязка с маневровым районом (23)
begin
  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[ManR.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[ManR.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[ManR.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[ManR.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNext;
      case Rod of
        MarshP :
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,244, '',1);
          InsMsg(ManR.Obj,244);    //----------------------- "Нет поездных маршрутов"
          MarhTrac.GonkaStrel := false;
        end;

        MarshM :
        begin
         case Con.Pin of
          1 :
          begin
            if not ObjZv[ManR.Obj].bP[1] then //---------------------------------- УМП
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,245, ObjZv[ManR.Obj].Liter,1);
              InsMsg(ManR.Obj,245);
              MarhTrac.GonkaStrel := false;
            end;
          end;

          else
            if not ObjZv[ManR.Obj].bP[2] then //---------------------------------- УМО
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,245, ObjZv[ManR.Obj].Liter,1);
              InsMsg(ManR.Obj,245);
              MarhTrac.GonkaStrel := false;
            end;
         end;
        end;
        else
          result := trStop;
          exit;
        end;

        if Con.Pin = 1 then
        begin
          Con := ObjZv[ManR.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
          end;
        end else
        begin
          Con := ObjZv[ManR.Obj].Sosed[1];
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
        result := trNext;
        case Rod of
          MarshP :
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,244, '',1);
            InsMsg(ManR.Obj,244);
          end;

          MarshM :
          begin
              case Con.Pin of
                1 :
                begin
                  if not ObjZv[ManR.Obj].bP[1] then //---------------------------- УМП
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,245, ObjZv[ManR.Obj].Liter,1);
                    InsMsg(ManR.Obj,245);
                  end;
                end;
              else
                if not ObjZv[ManR.Obj].bP[2] then //------------------------------ УМО
                begin
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,245, ObjZv[ManR.Obj].Liter,1);
                  InsMsg(ManR.Obj,245);
                end;
              end;
            end;
          else
            result := trStop;
            exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZv[ManR.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZv[ManR.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZv[ManR.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[ManR.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end;
      end;
    end;

//========================================================================================
//--------------------------------------------- Запрос согласия поездного отправления (24)
function StepTrasZapPO(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Zapr:TSos) : TTrRes;
begin
  case Lvl of
    tlFindTrace : result := trRepeat;

    tlContTrace :
    begin
      MarhTrac.FullTail := true;
      result := trKonec;
    end;

    tlVZavTrace : result := trStop;

    tlCheckTrace :
    begin
      result := trKonec;
      case Rod of
        MarshP :
        begin
          if not ObjZv[Zapr.Obj].bP[13] then //------------------------------------ ФС
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,246, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,246); //------------------- Нет согласия поездного приема
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Zapr.Obj].bP[3] then //--------------------------------------- НЭГС
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,105, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,105);//-------- Нажата кнопка экстренного гашения сигнала
            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Zapr.Obj].bP[8] then //------------------------------------- чи
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,248, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,248); //---------- Установлен враждебный поездной маршрут
          end;

          if ObjZv[Zapr.Obj].bP[9] then //---------------------------------------- чкм
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,249, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,249); //-------- Установлен враждебный маневровый маршрут
          end;

          if not ObjZv[Zapr.Obj].bP[7] then //-------------------------------------- п
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,250, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,250); //------------------------- Занят участок по увязке
          end;

          if ObjZv[Zapr.Obj].bP[14] or
          ObjZv[Zapr.Obj].bP[15] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,432);  //------------------------------ Перегон $ закрыт#
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Zapr.Obj].ObCB[8] or ObjZv[Zapr.Obj].ObCB[9] then
          begin
            if ObjZv[Zapr.Obj].bP[24] or
            ObjZv[Zapr.Obj].bP[27] then //--------------- Закрыт для движения на эл.т.
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[Zapr.Obj].Title,1);
              InsWar(Zapr.Obj,462); //--------------- Закрыто движение на электротяге
            end else
            if ObjZv[Zapr.Obj].ObCB[8] and ObjZv[Zapr.Obj].ObCB[9] then
            begin
              if ObjZv[Zapr.Obj].bP[25] or
              ObjZv[Zapr.Obj].bP[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,467); // Закрыто движение на ЭТ постоянного тока по $
              end;

              if ObjZv[Zapr.Obj].bP[26] or
              ObjZv[Zapr.Obj].bP[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,472); //-- Закрыто движение на ЭТ переменного тока по
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,474, ObjZv[Zapr.Obj].Title,1);
            InsWar(Zapr.Obj,474);
          end;
        end;

        MarshM : begin        end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[Zapr.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Zapr.Obj].Sosed[1];
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
      result := trKonec;
      case Rod of
        MarshP :
        begin
          if not ObjZv[Zapr.Obj].bP[13] then //------------------------------------ ФС
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,246, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,246);   //----------------- Нет согласия поездного приема
          end;

          if ObjZv[Zapr.Obj].bP[3] then //--------------------------------------- НЭГС
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,105, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,105);
          end;

          if not ObjZv[Zapr.Obj].bP[8] then //------------------------------------- чи
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,248, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,248);  //--------- Установлен враждебный поездной маршрут
          end;

          if ObjZv[Zapr.Obj].bP[9] then //---------------------------------------- чкм
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,249, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,249); //-------- Установлен враждебный маневровый маршрут
          end;

          if not ObjZv[Zapr.Obj].bP[7] then //-------------------------------------- п
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,250, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,250); //------------------------- Занят участок по увязке
          end;

          if ObjZv[Zapr.Obj].bP[14] or
          ObjZv[Zapr.Obj].bP[15] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,432); //-------------------------------- Перегон $ закрыт
          end;

          if ObjZv[Zapr.Obj].ObCB[8] or ObjZv[Zapr.Obj].ObCB[9] then
          begin
            if ObjZv[Zapr.Obj].bP[24] or
            ObjZv[Zapr.Obj].bP[27] then //--------------- Закрыт для движения на эл.т.
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[Zapr.Obj].Title,1);
              InsWar(Zapr.Obj,462); //------------ Закрыто движение на электротяге по
            end else
            if ObjZv[Zapr.Obj].ObCB[8] and ObjZv[Zapr.Obj].ObCB[9] then
            begin
              if ObjZv[Zapr.Obj].bP[25] or
              ObjZv[Zapr.Obj].bP[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,467); //-- Закрыто движение на ЭТ постоянного тока по
              end;

              if ObjZv[Zapr.Obj].bP[26] or
              ObjZv[Zapr.Obj].bP[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,472); //----------------- Конец контактной подвески $
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,474, ObjZv[Zapr.Obj].Title,1);
            InsWar(Zapr.Obj,474);   //-------------- Участок $ не электрифицированный
          end;
        end;

        MarshM : begin      end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[Zapr.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Zapr.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlFindIzvest :
    begin
      if (not ObjZv[Zapr.Obj].bP[5] and
      not ObjZv[Zapr.Obj].bP[8]) or
      not ObjZv[Zapr.Obj].bP[7] then //---------------------------- Занято приближение
      result := trBreak
      else result := trStop;
    end;

    tlFindIzvStrel : result := trStop;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZv[Zapr.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNext;
      end;
    end else
    begin
      Con := ObjZv[Zapr.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNext;
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------------------------------------------- ПАБ(26)
function StepTrasPAB(var Con:TSos; const Lvl:TTrLev; Rod:Byte; PAB:TSos) : TTrRes;
begin
  case Lvl of
    tlFindTrace :
    begin
      result := trNext;
      if not MarhTrac.LvlFNext then
      begin
        if Con.Pin = 1 then
        begin
          Con := ObjZv[PAB.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end else
        begin
          Con := ObjZv[PAB.Obj].Sosed[1];
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
          if ObjZv[PAB.Obj].ObCB[1] then result := trKonec
          else result := trStop;

        MarshM : result := trStop;

        else result := trKonec;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[PAB.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[PAB.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNext;
      case Rod of
        MarshP :
        begin
          if ObjZv[PAB.Obj].bP[12] or
          ObjZv[PAB.Obj].bP[13] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,432);  //------------------------------ Перегон $ закрыт#
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[PAB.Obj].ObCB[8] or ObjZv[PAB.Obj].ObCB[9] then
          begin
            if ObjZv[PAB.Obj].bP[24] or
            ObjZv[PAB.Obj].bP[27] then //------------------ Закрыт для движения на ЭТ
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[PAB.Obj].Liter,1);
              InsWar(PAB.Obj,462); //------------ Закрыто движение на электротяге по
            end else
            if ObjZv[PAB.Obj].ObCB[8] and ObjZv[PAB.Obj].ObCB[9] then
            begin
              if ObjZv[PAB.Obj].bP[25] or
              ObjZv[PAB.Obj].bP[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,467); // Закрыто движение на ЭТ постоянного тока по $
              end;

              if ObjZv[PAB.Obj].bP[26] or
              ObjZv[PAB.Obj].bP[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,472); // Закрыто движение на ЭТ переменного тока по $
              end;
            end;
          end else
          begin //--------------------------------------- конец подвески контакной провода
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,474, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,474); //---------------- Участок $ не электрифицированный
          end;

          if not ObjZv[PAB.Obj].bP[7] then //------------------- Хозпоезд на перегоне
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,130, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,130); //-------- Отправлен хозяйственный поезд на перегон
            MarhTrac.GonkaStrel := false;
          end else
          if not ObjZv[PAB.Obj].bP[1] then //---------------- Перегон занят по приему
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,318, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,318); //----------------------- Перегон $ занят по приему
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[PAB.Obj].bP[2] then //------------------- Получено прибытие поезда
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,319, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,319); //------------ Получено прибытие поезда на перегоне
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[PAB.Obj].bP[4] then //-------- Выдано согласие на соседнюю станцию
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,320, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,320); // Выдано согласие отправления поезда на перегоне $
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[PAB.Obj].bP[6] then //----------------------- согласие отправления
          begin
            if not ObjZv[PAB.Obj].bP[5] then //есть занятость перегона по отправлению
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,299, ObjZv[PAB.Obj].Liter,1);
              InsMsg(PAB.Obj,299); //---------------- Перегон $ занят по отправлению
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,237, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,237); //------------- Нет согласия отправления на перегон
          end;

          if not ObjZv[PAB.Obj].bP[9] then //---------------------- Занят известитель
          begin
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,83);  //--------------------------------- Участок $ занят
          end;
        end;

        MarshM :  begin  end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[PAB.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[PAB.Obj].Sosed[1];
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
      result := trNext;
      case Rod of
        MarshP :
        begin
          if ObjZv[PAB.Obj].bP[12] or
          ObjZv[PAB.Obj].bP[13] then //------------------------- перегон заблокирован
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,432); //-------------------------------- Перегон $ закрыт
          end;

          if ObjZv[PAB.Obj].ObCB[8] or ObjZv[PAB.Obj].ObCB[9] then
          begin
            if ObjZv[PAB.Obj].bP[24] or
            ObjZv[PAB.Obj].bP[27] then //--------------- Закрыт для движения на эл.т.
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[PAB.Obj].Liter,1);
              InsWar(PAB.Obj,462); //---------- Закрыто движение на электротяге по $
            end else
            if ObjZv[PAB.Obj].ObCB[8] and ObjZv[PAB.Obj].ObCB[9] then
            begin
              if ObjZv[PAB.Obj].bP[25] or
              ObjZv[PAB.Obj].bP[28] then //----------- Закрыт для движения на пост.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,467);
              end;

              if ObjZv[PAB.Obj].bP[26] or
              ObjZv[PAB.Obj].bP[29] then //------------ Закрыт для движения на пер.т.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,472); //-- Закрыто движение на ЭТ переменного тока по
              end;
            end;
          end else
          begin //-------------------------------------- конец подвески контакного провода
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,474, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,474);
          end;

          if not ObjZv[PAB.Obj].bP[7] then //------------------- Хозпоезд на перегоне
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,130, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,130); //------ Отправлен хозяйственный поезд на перегон $
          end else
          if not ObjZv[PAB.Obj].bP[1] then //---------------- Перегон занят по приему
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,318, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,318); //----------------------- Перегон $ занят по приему
          end else
          if ObjZv[PAB.Obj].bP[2] then //------------------- Получено прибытие поезда
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,319, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,319); //---------- Получено прибытие поезда на перегоне $
          end else
          if ObjZv[PAB.Obj].bP[4] then //-------- Выдано согласие на соседнюю станцию
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,320, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,320); // Выдано согласие отправления поезда на перегоне $
          end else
          if ObjZv[PAB.Obj].bP[6] then //----------------------- согласие отправления
          begin
            if not ObjZv[PAB.Obj].bP[5] then //есть занятость перегона по отправлению
            begin
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,299, ObjZv[PAB.Obj].Liter,1);
              InsMsg(PAB.Obj,299); //---------------- Перегон $ занят по отправлению
            end;
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,237, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,237);  //------------ Нет согласия отправления на перегон
          end;

          if not ObjZv[PAB.Obj].bP[9] then //---------------------- Занят известитель
          begin
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,83); //---------------------------------- Участок $ занят
          end;
        end;

        MarshM : begin  end;

        else  result := trStop; exit;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[PAB.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[PAB.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlFindIzvest :
      if not ObjZv[PAB.Obj].bP[9] then  result := trBreak  //----- Занято приближение
      else result := trStop;


    tlFindIzvStrel : result := trStop;

    else
      if Con.Pin = 1 then
      begin
        Con := ObjZv[PAB.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[PAB.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNext;
        end;
      end;
  end;
end;

//========================================================================================
//---------------------------------------------------------------- Охранности стрелок (27)
function StepTrasDZOhr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Dz:TSos) : TTrRes;
var
  StrO,StrK,HvostO,HvostK : integer;
  tr : boolean;
begin
  StrK := ObjZv[Dz.Obj].ObCI[1]; //-------------------------------- контролируемая стрелка
  StrO := ObjZv[Dz.Obj].ObCI[3]; //-------------------------------------- охранная стрелка
  HvostO := ObjZv[StrO].BasOb;
  HvostK := ObjZv[StrK].BasOb;

  case Lvl of
    tlFindTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Dz.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Dz.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end;
    end;

    tlVZavTrace : //------------------------- проверка охранного положения при трассировке
    begin
      if (StrK > 0) and (StrO > 0) then
      begin
        tr := ObjZv[StrO].bP[6] or ObjZv[StrO].bP[7] or //- ПУ,МУ или трассировка охранной
        ObjZv[StrO].bP[10] or ObjZv[StrO].bP[11] or
        ObjZv[StrO].bP[12] or ObjZv[StrO].bP[13];


        if(ObjZv[HvostO].ObCI[8] = StrO) and (ObjZv[HvostO].ObCI[9] > 0) then
        StrO := ObjZv[HvostO].ObCI[9]
        else
        if ObjZv[HvostO].ObCI[8] > 0 then StrO := ObjZv[HvostO].ObCI[8]
        else HvostO := 0;

        if HvostO > 0 then
        tr := tr or ObjZv[StrO].bP[6] or ObjZv[StrO].bP[7] or
        ObjZv[HvostO].bP[10] or ObjZv[HvostO].bP[11] or
        ObjZv[HvostO].bP[12] or ObjZv[HvostO].bP[13];

        if ObjZv[Dz.Obj].ObCB[5] or tr then
        begin //---------------------------- выполняется гонка охранной стрелки в маршруте
          if ObjZv[Dz.Obj].ObCB[1] then //------ Контролируемая стрелка охраняется в плюсе
          begin
            if((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or ObjZv[StrK].bP[12]) then
            begin
              if ObjZv[Dz.Obj].ObCB[3] then //--------------- охранная должна быть в плюсе
              begin
                if (ObjZv[StrO].bP[10] and ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20]=0) and ObjZv[StrO].bP[7])or ObjZv[StrO].bP[13] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //------ разные СП и ...
                  not ObjZv[StrO].bP[14] then //-------------------- нет замыкания из STAN
                  begin
                    result := trStop;
                    exit; //----------------------- охранная трассируется в минусе - отказ
                  end;
                end;
              end else
              if ObjZv[Dz.Obj].ObCB[4] then //------- охранная должна быть в минусе
              begin
                if (ObjZv[StrO].bP[10] and not ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20] = 0) and ObjZv[StrO].bP[6]) or
                ObjZv[StrO].bP[12] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //-- разные СП
                  not ObjZv[StrO].bP[14] then //-- не выдана маршрутная команда в сервер
                  begin
                    result := trStop; exit; //------ охранная трассируется в плюсе - отказ
                  end;
                end;
              end;
            end;
          end else
          if ObjZv[Dz.Obj].ObCB[2] then//Контролируемая стрелка охраняется в минусе
          begin
            if ((ObjZv[StrK].bP[10] and ObjZv[StrK].bP[11]) or
            ObjZv[StrK].bP[13]) then
            begin
              if ObjZv[Dz.Obj].ObCB[3] then //-------- охранная должна быть в плюсе
              begin
                if (ObjZv[StrO].bP[10] and ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20] = 0) and ObjZv[StrO].bP[7]) or
                ObjZv[StrO].bP[13] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //-- разные СП
                  not ObjZv[StrO].bP[14] then //-- не выдана маршрутная команда в сервер
                  begin
                    result := trStop; exit; //----- охранная трассируется в минусе - отказ
                  end;
                end;
              end else
              if ObjZv[Dz.Obj].ObCB[4] then //------- охранная должна быть в минусе
              begin
                if (ObjZv[StrO].bP[10] and not ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20] = 0) and ObjZv[StrO].bP[6]) or
                ObjZv[StrO].bP[12] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //-- разные СП
                  not ObjZv[StrO].bP[14] then //-- не выдана маршрутная команда в сервер
                  begin
                    result := trStop; exit; //------ охранная трассируется в плюсе - отказ
                  end;
                end;
              end;
            end;
          end;
        end else
        begin //------------------------- не выполняется гонка охранной стрелки в маршруте
          if ((Dz.Pin = 1) and not ObjZv[Dz.Obj].ObCB[6]) or
          ((Dz.Pin = 2) and not ObjZv[Dz.Obj].ObCB[7]) then
          begin
            if ObjZv[Dz.Obj].ObCB[1] then //- Контролируемая стрелка охраняется в +
            begin
              if ((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or
              ObjZv[StrK].bP[12]) then
              begin
                if ObjZv[Dz.Obj].ObCB[3] then //------ охранная должна быть в плюсе
                begin
                  if not (ObjZv[StrO].bP[1] and not ObjZv[StrO].bP[2]) then
                  begin //--------------------- охранная не имеет контроля в плюсе - отказ
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,268); //- Нет контроля плюса стрелки
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZv[Dz.Obj].ObCB[4] then //----- охранная должна быть в минусе
                begin
                  if not (not ObjZv[StrO].bP[1] and ObjZv[StrO].bP[2]) then
                  begin //-------------------- охранная не имеет контроля в минусе - отказ
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,267,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,267); // Нет контроля минуса стрелки
                    result := trStop;
                    exit;
                  end;
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[2] then //- Контролируемая стрелка охраняется в -
            begin
              if ((ObjZv[StrK].bP[10] and ObjZv[StrK].bP[11]) or
              ObjZv[StrK].bP[13]) then
              begin
                if ObjZv[Dz.Obj].ObCB[3] then //------ охранная должна быть в плюсе
                begin
                  if not (ObjZv[StrO].bP[1] and not ObjZv[StrO].bP[2]) then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,268); //- Нет контроля плюса стрелки
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZv[Dz.Obj].ObCB[4] then //----- охранная должна быть в минусе
                begin
                  if not (not ObjZv[StrO].bP[1] and ObjZv[StrO].bP[2]) then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,267,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,267); // Нет контроля минуса стрелки
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
        Con := ObjZv[Dz.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Dz.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNext;
      //------------ проверка возможности установки охранной стрелки в требуемое положение
      StrK := ObjZv[Dz.Obj].ObCI[1]; //---------------------------- контролируемая стрелка
      StrO := ObjZv[Dz.Obj].ObCI[3]; //---------------------------------- охранная стрелка

      if (StrK > 0) and (StrO > 0) then
      begin
        if ObjZv[Dz.Obj].ObCB[1] then
        begin
          if ((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or
          ObjZv[StrK].bP[12]) then //----------Контролируемая стрелка охраняется в плюсе
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //--------- Охранная стрелка должна быть в плюсе
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZv[HvostO].bP[7] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);// СП замкнута(стр. в маршруте +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if not ObjZv[StrO].bP[1] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); // увеличить число стрелок, с переводом

                if not ObjZv[StrO].bP[2] then //----------------- нет контроля положения
                begin
                  if not ObjZv[StrO].bP[6] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,81); //------ Стрелка $ без контроля
                    result := trBreak;
                    MarhTrac.GonkaStrel := false;
                  end;
                end else
                if not ObjZv[HvostO].bP[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);// СП замкнута(стр. в маршруте +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].ObCB[3] and//--- надо проверять МСП и
                not ObjZv[HvostO].bP[20] then //..... идет выдержка МСП
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80); //------------ Стрелка $ замкнута
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,118, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,118);//СП занята стр $ в маршруте по +
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,136, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,136);// Стр на макете(должна быть по+)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,121, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,121);//Стр выключена (в маршруте по +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZv[HvostO].bP[6] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if ObjZv[HvostO].ObCB[3] and//--- надо проверять МСП и
                not ObjZv[HvostO].bP[20] then //..... идет выдержка МСП
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTrac.GonkaStrel := false;
                end;

              if not ObjZv[StrO].bP[2] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); // увеличить число перевоодимых стрелок
                if not ObjZv[StrO].bP[1] then
                begin //------------------------------------------- нет контроля положения
                  if not ObjZv[StrO].bP[7] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,81);
                    result := trBreak;
                    MarhTrac.GonkaStrel := false;
                  end;
                end else
                if not ObjZv[HvostO].bP[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,157, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,157);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,158, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,158);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,137, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,137);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,159, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,159);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;
            end;
          end;
        end else
        if ObjZv[Dz.Obj].ObCB[2] then
        begin
          if ((ObjZv[StrK].bP[10] and ObjZv[StrK].bP[11]) or
          ObjZv[StrK].bP[13]) then //-------- Контролируемая стрелка охраняется в минусе
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //-- Охранная стрелка должна быть в плюсе
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZv[HvostO].bP[7] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);//СП замкнута (стрелка нужна в +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if ObjZv[HvostO].ObCB[3] and//--- надо проверять МСП и
                not ObjZv[HvostO].bP[20] then //..... идет выдержка МСП
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTrac.GonkaStrel := false;
                end;

              if not ObjZv[StrO].bP[1] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); // увеличить число перевоодимых стрелок

                if not ObjZv[StrO].bP[2] then
                begin //------------------------------------------- нет контроля положения
                  if not ObjZv[StrO].bP[6] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,81);
                    result := trBreak;
                    MarhTrac.GonkaStrel := false;
                  end;
                end else
                if not ObjZv[HvostO].bP[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].ObCB[3] and//--- надо проверять МСП и
                not ObjZv[HvostO].bP[20] then //..... идет выдержка МСП
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,118, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,118);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,136, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,136);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,121, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,121);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- сделать проверки трассировки секущего маршрута через крест
                if ObjZv[HvostO].bP[6] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if ObjZv[HvostO].ObCB[3] and//--- надо проверять МСП и
                not ObjZv[HvostO].bP[20] then //..... идет выдержка МСП
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //-- Идет выдержка времени дополнит. замыкания стрелки
                  MarhTrac.GonkaStrel := false;
                end;
                
              if not ObjZv[StrO].bP[2] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); //- увеличить число переводимых стрелок

                if not ObjZv[StrO].bP[1] then
                begin //------------------------------------------- нет контроля положения
                  if not ObjZv[StrO].bP[7] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,81);
                    result := trBreak;
                    MarhTrac.GonkaStrel := false;
                  end;
                end else
                if not ObjZv[HvostO].bP[21] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,157, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,157);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- охранная стрелка замкнута
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ охранная стрелка занята
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,158, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,158);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- охранная стрелка на макете
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,137, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,137);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- охранная стрелка выключена
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,159, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,159);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;
            end;
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[Dz.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Dz.Obj].Sosed[1];
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
      result := trNext;
      //------------ проверка возможности установки охранной стрелки в требуемое положение
      StrK := ObjZv[Dz.Obj].ObCI[1]; //---------------------------- контролируемая стрелка
      StrO := ObjZv[Dz.Obj].ObCI[3]; //---------------------------------- охранная стрелка

      if (StrK > 0) and (StrO > 0) then
      begin
        if ObjZv[Dz.Obj].ObCB[1] then
        begin
          if ObjZv[StrK].bP[1] then //---------- Контролируемая стрелка охраняется в плюсе
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //--------- Охранная стрелка должна быть в плюсе
            begin
              if ObjZv[StrO].bP[1] then
              begin //------------------------------------ проверить наличие гонки в минус
                if ObjZv[StrO].bP[7] then
                begin //--------------------------------- охранная стрелка гонится в минус
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);
                end;
              end else
              begin
                if not ObjZv[StrO].bP[2] then
                begin //------------------------------------------- нет контроля положения
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81);
                end else
                begin //---------------------------------------- охранная стрелка в минусе
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZv[StrO].bP[2] then
              begin //------------------------------------- проверить наличие гонки в плюс
                if ObjZv[StrO].bP[6] then
                begin //---------------------------------- охранная стрелка гонится в плюс
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235);
                end;
              end else
              begin
                if not ObjZv[StrO].bP[1] then
                begin //------------------------------------------- нет контроля положения
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81); //--- Стрелка $ не имеет контроля
                end else
                begin //----------------------------------------- охранная стрелка в плюсе
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235); //-- Охранная стр. в + (нужен -)
                end;
              end;
            end;
          end;
        end else
        if ObjZv[Dz.Obj].ObCB[2] then
        begin
          if ObjZv[StrK].bP[2] then //------- Контролируемая стрелка охраняется в минусе
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //-- Охранная стрелка должна быть в плюсе
            begin
              if ObjZv[StrO].bP[1] then
              begin //------------------------------------ проверить наличие гонки в минус
                if ObjZv[StrO].bP[7] then
                begin //--------------------------------- охранная стрелка гонится в минус
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);//--- Охранная стр. в - (нужен +)
                end;
              end else
              begin
                if not ObjZv[StrO].bP[2] then
                begin //------------------------------------------- нет контроля положения
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81); //--- Стрелка $ не имеет контроля
                end else
                begin //---------------------------------------- охранная стрелка в минусе
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);//--- Охранная стр. в - (нужен +)
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- Охранная стрелка должна быть в минусе
            begin
              if ObjZv[StrO].bP[2] then
              begin //----------------------------00------- проверить наличие гонки в плюс
                if ObjZv[StrO].bP[6] then
                begin //-------------------------00------- охранная стрелка гонится в плюс
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235); //00 Охранная стр. в + (нужен -)
                end;
              end else
              begin
                if not ObjZv[StrO].bP[1] then
                begin //-----------------------00------------------ нет контроля положения
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81); //----------------------- Стрелка $ не имеет контроля
                end else
                begin //----------------------------------------- охранная стрелка в плюсе
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235); //-- Охранная стр. в + (нужен -)
                end;
              end;
            end;
          end;
        end;
      end;
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Dz.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Dz.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;
    else
    if Con.Pin = 1 then
    begin
      Con := ObjZv[Dz.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNext;
      end;
    end else
    begin
      Con := ObjZv[Dz.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else  result := trNext;
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------------------------- Извещение на переезд (28)
function StepTrasIzPer(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Per:TSos) : TTrRes;
var
  o : integer;
begin
  case Lvl of
    tlFindTrace :  //-------------------------------------------------------- поиск трассы
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Per.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Per.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          else result := trNext;
        end;
      end;
    end;

    tlVZavTrace :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Per.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Per.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNext;
      o := ObjZv[Per.Obj].BasOb; //--------------------------------- объект переезда
      if ObjZv[o].bP[4] then //--------------------------------------- зГ на переезде
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,107, ObjZv[o].Liter,1);
        result := trBreak;
        InsMsg(o,107);
        MarhTrac.GonkaStrel := false;
      end;

      if ObjZv[o].bP[1] then //----------------------------------- авария на переезде
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,143, ObjZv[o].Liter,1);
        result := trBreak;
        InsWar(o,143);
        MarhTrac.GonkaStrel := false;
      end;

      if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then // неисправность на переезде
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,144, ObjZv[o].Liter,1);
        result := trBreak;
        InsWar(o,144);
        MarhTrac.GonkaStrel := false;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[Per.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Per.Obj].Sosed[1];
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
      result := trNext;
      o := ObjZv[Per.Obj].BasOb;
      if ObjZv[o].bP[4] then //--------------------------------------- зГ на переезде
      begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,107, ObjZv[o].Liter,1);
            InsMsg(o,107);
          end;
          if ObjZv[o].bP[1] then
          begin // авария на переезде
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,143, ObjZv[o].Liter,1);
            InsWar(o,143);
          end;
          if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
          begin // неисправность на переезде
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,144, ObjZv[o].Liter,1); InsWar(o,144);
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZv[Per.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZv[Per.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZv[Per.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[Per.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end;
      end;
    end;

//========================================================================================
//------------------------------------------------------------------------- ДЗ секции (29)
function StepTrasDZSp(var Con:TSos; const Lvl:TTrLev; Rod:Byte; DZSp:TSos) : TTrRes;
var
  o,k : integer;
  p : boolean;
begin
      case Lvl of
        tlFindTrace :
        begin
          if Con.Pin = 1 then
          begin
            Con := ObjZv[DZSp.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
              else     result := trNext;
            end;
          end
          else
          begin
            Con := ObjZv[DZSp.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
              else     result := trNext;
            end;
          end;
        end;

        tlVZavTrace :
        begin
          if Con.Pin = 1 then
          begin
            Con := ObjZv[DZSp.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
              else     result := trNext;
            end;
          end
          else
          begin
            Con := ObjZv[DZSp.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
              else     result := trNext;
            end;
          end;
        end;

        tlCheckTrace :
        begin
          result := trNext;
          if((Con.Pin=1) and (Rod=MarshM) and ObjZv[DZSp.Obj].ObCB[1]) or
          ((Con.Pin=1) and (Rod=MarshP) and ObjZv[DZSp.Obj].ObCB[2]) or
          ((Con.Pin=2) and (Rod=MarshM) and ObjZv[DZSp.Obj].ObCB[3]) or
          ((Con.Pin=2) and (Rod=MarshP) and ObjZv[DZSp.Obj].ObCB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZv[DZSp.Obj].ObCI[k];
              if o > 0 then
              begin
                case ObjZv[o].TypeObj of
                  8 :
                  begin //------------------------------------------------------------ УТС
                    if ((not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                    (ObjZv[o].bP[1] and ObjZv[o].bP[2])) and not ObjZv[o].bP[3] then
                    begin // Упор включен в зависимости и не имеет контроля положения
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                      InsMsg(o,109); result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end
                    else
                    if not ObjZv[o].bP[1] and ObjZv[o].bP[2] and
                    not ObjZv[o].bP[3] and (Rod = MarshP) then
                    begin //--- Упор установлен и включен в зависимости и поездной маршрут
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                      InsMsg(o,108); result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end else
                    if not ObjZv[o].bP[27] then
                    begin //------------------------- не зарегистрировано сообщение по УТС
                      if ObjZv[o].bP[3] then
                      begin //------------------------------ Упор выключен из зависимостей
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,253, ObjZv[o].Liter,1);
                        InsWar(o,253); result := trBreak;
                      end;
                      if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                      begin // Упор установлен
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                        InsWar(o,108); result := trBreak;
                      end else
                      if (not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                      (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
                      begin //--------------------------- Упор не имеет контроля положения
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                        InsWar(o,109);
                        result := trBreak;
                      end;
                    end;
                    if result = trBreak then ObjZv[o].bP[27] := true;
                  end;

                  33 :
                  begin //----------------------------------------------- одиночный датчик
                    if ObjZv[o].bP[1] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[o].ObCB[1] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] := MsgList[ObjZv[o].ObCI[3]];
                        InsMsg(o,3);
                      end else
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] := MsgList[ObjZv[o].ObCI[2]];
                        InsMsg(o,2);
                      end;
                      MarhTrac.GonkaStrel := false;
                      result := trBreak;
                    end;
                  end;
                  //------------------------------------------ другие объекты зависимостей
                  else
                end;
              end;
            end;
          end;

          if Con.Pin = 1 then
          begin
            Con := ObjZv[DZSp.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZv[DZSp.Obj].Sosed[1];
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
          result := trNext;
          if ((Con.Pin = 1) and (Rod = MarshM) and ObjZv[DZSp.Obj].ObCB[1]) or
          ((Con.Pin = 1) and (Rod = MarshP) and ObjZv[DZSp.Obj].ObCB[2]) or
          ((Con.Pin = 2) and (Rod = MarshM) and ObjZv[DZSp.Obj].ObCB[3]) or
          ((Con.Pin = 2) and (Rod = MarshP) and ObjZv[DZSp.Obj].ObCB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZv[DZSp.Obj].ObCI[k];
              if o > 0 then
              begin
                case ObjZv[o].TypeObj of
                  8 :
                  begin // УТС
                    if ((not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                    (ObjZv[o].bP[1] and ObjZv[o].bP[2])) and not ObjZv[o].bP[3] then
                    begin // Упор включен в зависимости и не имеет контроля положения
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                      InsMsg(o,109);
                    end else
                    if not ObjZv[o].bP[1] and ObjZv[o].bP[2] and
                    not ObjZv[o].bP[3] and (Rod = MarshP) then
                    begin // Упор установлен и включен в зависимости и поездной маршрут
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                      InsMsg(o,108);
                    end else
                    if not ObjZv[o].bP[27] then
                    begin
                      p := false;
                      if ObjZv[o].bP[3] then
                      begin // Упор выключен из зависимостей
                        p := true;
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,253, ObjZv[o].Liter,1);
                        InsWar(o,253);
                      end;
                      if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                      begin // Упор установлен
                        p := true;
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                        InsWar(o,108);
                      end else
                      if (not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                      (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
                      begin // Упор не имеет контроля положения
                        p := true;
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                        InsWar(o,109);
                      end;
                      if p then ObjZv[o].bP[27] := true;
                    end;
                  end;

                  33 : begin // одиночный датчик
                    if ObjZv[o].bP[1] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[o].ObCB[1] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] := MsgList[ObjZv[o].ObCI[3]];
                        InsMsg(o,3);
                      end
                      else
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] := MsgList[ObjZv[o].ObCI[2]];
                        InsMsg(o,2);
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
            Con := ObjZv[DZSp.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZv[DZSp.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        else
        if Con.Pin = 1 then
        begin
          Con := ObjZv[DZSp.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
            else     result := trNext;
          end;
        end
        else
        begin
          Con := ObjZv[DZSp.Obj].Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
            else     result := trNext;
          end;
        end;
      end;
    end;

//========================================================================================
//--------------------------------------------------------- Выдача поездного согласия (30)
function StepTrasPSogl(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sogl:TSos) : TTrRes;
var
  sig_uvaz,uch_uvaz,start_tras : integer;
begin
  start_tras := MarhTrac.ObjStart;
  sig_uvaz := ObjZv[Sogl.Obj].BasOb;
  uch_uvaz := ObjZv[Sogl.Obj].UpdOb;
  case Lvl of
    tlFindTrace :
    begin
      if ObjZv[Con.Obj].RU = ObjZv[start_tras].RU then
      begin //-------------------------- Продолжить трассировку если свой район управления
        if Con.Pin = 1 then
        begin
          Con := ObjZv[Sogl.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
            else result := trNext;
          end;
        end else
        begin
          Con := ObjZv[Sogl.Obj].Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
            else result := trNext;
          end;
        end;
      end
      else result := trRepeat;
    end;

    tlContTrace :
    begin
      if ObjZv[Con.Obj].RU = ObjZv[start_tras].RU then
      begin //-------------------------- Продолжить трассировку если свой район управления
        result := trNext;
        if Con.Pin = 1 then
        begin
          Con := ObjZv[Sogl.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
          end;
        end else
        begin
          Con := ObjZv[Sogl.Obj].Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trEnd;
          end;
        end;
      end
      else result := trKonec; //Завершить трассировку маршрута, другой район управления
    end;

    tlVZavTrace :
    begin
      result := trNext;
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Sogl.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Sogl.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNext;
      case Rod of
        MarshP :
        begin
          if Sogl.Obj = MarhTrac.ObjLast then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZv[Sogl.Obj].bP[1] then
              begin //-------------------------------------------------- нажата кнопка ЭГС
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,105, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,105);//- "Нажата кнопка экстренного гашения сигнала"
                result := trBreak;
              end;

              if not ObjZv[sig_uvaz].bP[4] then
              begin //--------------------------------------------- нет поездного согласия
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,246, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,246);  //----------- "Нет согласия поездного приема"
                result := trBreak;
              end;
            end;
          end;
        end;
      end;

      if Sogl.Obj <> MarhTrac.ObjLast then
      begin
        if uch_uvaz > 0 then
        begin //------------------------------------ проверить враждебности участка увязки
          if not ObjZv[uch_uvaz].bP[2] or not ObjZv[uch_uvaz].bP[3] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[uch_uvaz].Liter,1);
            InsMsg(uch_uvaz,113); //-------- "На путь установлен враждебный маршрут"
            result := trBreak;
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;

      MarhTrac.TailMsg := ' до '+ ObjZv[ObjZv[Sogl.Obj].BasOb].Liter;
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Sogl.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Sogl.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlSignalCirc :
    begin
      result := trNext;
      case Rod of
        MarshP :
        begin
          if MarhTrac.ObjTRS[MarhTrac.Counter] <>
          ObjZv[Sogl.Obj].BasOb then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZv[Sogl.Obj].bP[1] then
              begin //-------------------------------------------------- нажата кнопка ЭГС
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,105, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,105);
              end;

              if not ObjZv[sig_uvaz].bP[4] then
              begin //--------------------------------------------- нет поездного согласия
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,246, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,246);
              end;
            end;
          end;
        end;
      end;

      if MarhTrac.ObjTRS[MarhTrac.Counter] = sig_uvaz  then
      begin
        if uch_uvaz > 0 then
        begin //------------------------------------ проверить враждебности участка увязки
          if ObjZv[uch_uvaz].bP[2] and ObjZv[uch_uvaz].bP[3] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,163, ObjZv[uch_uvaz].Liter,1);
            InsMsg(uch_uvaz,163);
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[Sogl.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Sogl.Obj].Sosed[1];
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
      result := trNext;
      case Rod of
        MarshP :
        begin
          if MarhTrac.ObjTRS[MarhTrac.Counter] <>  sig_uvaz then
          begin
            if sig_uvaz > 0 then
            begin
              if ObjZv[Sogl.Obj].bP[1] then
              begin //-------------------------------------------------- нажата кнопка ЭГС
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,105, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,105);
              end;

              if not ObjZv[sig_uvaz].bP[4] then
              begin //--------------------------------------------- нет поездного согласия
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,246, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,246);
              end;
            end;
          end;
        end;
      end;

      if MarhTrac.ObjTRS[MarhTrac.Counter] = sig_uvaz then
      begin
        if uch_uvaz  > 0 then
        begin //------------------------------------ проверить враждебности участка увязки
          if not ObjZv[uch_uvaz].bP[2] or not ObjZv[uch_uvaz].bP[3] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[uch_uvaz].Liter,1);
            InsMsg(uch_uvaz,113);
          end;
        end;
      end;

      if Con.Pin = 1 then
      begin
        Con := ObjZv[Sogl.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else
      begin
        Con := ObjZv[Sogl.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end;
    end;

    tlZamykTrace :
    begin
      MarhTrac.TailMsg := ' до '+ ObjZv[sig_uvaz].Liter;
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Sogl.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Sogl.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trEnd;
          else result := trNext;
        end;
      end;
    end;

    else
    if Con.Pin = 1 then
    begin
      Con := ObjZv[Sogl.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNext;
      end;
    end else
    begin
      Con := ObjZv[Sogl.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trEnd;
        else result := trNext;
      end;
    end;
  end;
end;

//========================================================================================
//---------------------------------------------------------- Увязка с горкой (надвиг) (32)
function StepUvazGor(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Uvaz:TSos):TTrRes;
var
  o : integer;
begin
  with MarhTrac do
  begin
    case Lvl of
      tlFindTrace  : result := trRepeat;

      tlPovtorMarh,
      tlContTrace  :  begin FullTail := true; result := trKonec; end;

      tlVZavTrace  :  result := trStop;

      tlCheckTrace : begin
                      result := trBreak;  TailMsg := ' до '+ ObjZv[Uvaz.Obj].Liter;
                      if ObjZv[Uvaz.Obj].bP[10] then
                      begin //-------------------------  уже есть маршрут надвига на горку
                        inc(MsgN);
                        Msg[MsgN] := GetSmsg(1,355, ObjZv[Uvaz.Obj].Liter,1);
                        InsMsg(Uvaz.Obj,355); //------------- Замкнут маршрут надвига по
                        GonkaStrel := false;
                        exit;
                      end;

                      case Rod of
                        MarshP :
                        begin
                          o := 1;
                          while o < 13 do //- 12 светофоров надвига в объекте увязки горки
                          begin
                            if ObjStart = ObjZv[ObjZv[Uvaz.Obj].UpdOb].ObCI[o] then break;
                            inc(o);
                          end;

                          if o > 12 then
                          begin
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,106, ObjZv[ObjStart].Liter,1);
                            InsMsg(ObjStart,106); //- "Нет маршрутов надвига от ..."
                            GonkaStrel := false;
                            exit;
                          end else
                          if ObjZv[Uvaz.Obj].bP[12] or ObjZv[Uvaz.Obj].bP[13] then
                          begin //------------------ блокировка кнопки горочного светофора
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,123, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,123);  //------ "Светофор $ заблокирован"
                            GonkaStrel := false;
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[11] then
                          begin //----------------------------------------------------- ГП
                            inc(MsgN);
                            Msg[MsgN] :=
                            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                            GetSmsg(1,83, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,83); //---------------- "Участок $ занят"
                            GonkaStrel := false;
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[7] then
                          begin //---------------------------------------------------- ЭГС
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,105, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,105);
                            GonkaStrel := false;
                            exit;
                          end;

                          if not ObjZv[Uvaz.Obj].bP[8] then
                          begin //----------------------------------- нет согласия надвига
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,103, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,103);
                            GonkaStrel := false;
                            exit;
                          end;

                          o := PutNadviga;
                          if not ObjZv[ObjZv[o].BasOb].bP[4] and
                          not(ObjZv[ObjZv[o].BasOb].bP[2] and ObjZv[ObjZv[o].BasOb].bP[3])
                          then
                          begin //------------ установлен поездной маршрут на путь надвига
                            inc(MsgN);
                            Msg[MsgN]:=GetSmsg(1,356,ObjZv[ObjZv[o].BasOb].Liter,1);
                            InsMsg(ObjZv[o].BasOb,356);
                            GonkaStrel := false;
                            exit;
                          end;
                        end;

                        MarshM :
                        begin
                          if not ObjZv[Uvaz.Obj].bP[9] then
                          begin //---------------------------------- нет согласия маневров
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,104, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,104);
                            GonkaStrel := false;
                            exit;
                          end;
                        end;

                        else  result := trStop; exit;
                      end;
                      FullTail := true;
                      result := trKonec;
                    end;

   tlAutoTrace,
   tlPovtorRazdel,
   tlRazdelSign   : begin
                      result := trStop;
                      if ObjZv[Uvaz.Obj].bP[10] then
                      begin //-------------------------- уже есть маршрут надвига на горку
                        inc(MsgN);
                        Msg[MsgN] := GetSmsg(1,355, ObjZv[Uvaz.Obj].Liter,1);
                        InsMsg(Uvaz.Obj,355);
                        exit;
                      end;

                      case Rod of
                        MarshP :
                        begin
                          o := 1;
                          while o < 13 do
                          begin
                            if ObjStart = ObjZv[ObjZv[Uvaz.Obj].UpdOb].ObCI[o] then break;
                            inc(o);
                          end;

                          if o > 12 then
                          begin
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,106, ObjZv[ObjStart].Liter,1);
                            InsMsg(ObjStart,106);  //------- Нет маршрутов надвига от $
                            exit;
                          end else
                          if ObjZv[Uvaz.Obj].bP[12] or ObjZv[Uvaz.Obj].bP[13] then
                          begin //------------------ блокировка кнопки горочного светофора
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,123, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,123);
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[11] then
                          begin //----------------------------------------------------- ГП
                            inc(MsgN);
                            Msg[MsgN] :=
                            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                            GetSmsg(1,83, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,83);  //-------------------- Участок $ занят
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[7] then
                          begin //---------------------------------------------------- ЭГС
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,105, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,105);//----------------- "Нажата кнопка ЭГС"
                            exit;
                          end;

                          if not ObjZv[Uvaz.Obj].bP[8] then
                          begin //----------------------------------- нет согласия надвига
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,103, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,103); //------------ Нет согласия надвига по
                            exit;
                          end;

                          o := PutNadviga;
                          if Con.Pin = 1 then
                          begin
                            if not ObjZv[ObjZv[o].BasOb].bP[4] and
                            not ObjZv[ObjZv[o].BasOb].bP[2] then
                            begin //--- установлен четный поездной маршрут на путь надвига
                              inc(MsgN);
                              Msg[MsgN]:=GetSmsg(1,356,ObjZv[ObjZv[o].BasOb].Liter,1);
                              InsMsg(ObjZv[o].BasOb,356);
                              exit;
                            end;
                          end else
                          begin
                            if not ObjZv[ObjZv[o].BasOb].bP[4] and
                            not ObjZv[ObjZv[o].BasOb].bP[3] then
                            begin // установлен нечетный поездной маршрут на путь надвига
                              inc(MsgN);
                              Msg[MsgN]:=GetSmsg(1,356,ObjZv[ObjZv[o].BasOb].Liter,1);
                              InsMsg(ObjZv[o].BasOb,356);
                              exit;
                            end;
                          end;
                        end;

                        MarshM :
                        begin
                          if not ObjZv[Uvaz.Obj].bP[9] then
                          begin //---------------------------------- нет согласия маневров
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,104,ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,104);
                            exit;
                          end;
                        end;

                        else result := trStop; exit;
                      end;
                      FullTail := true; result := trKonec;
                    end;

     tlSignalCirc : begin
                      result := trStop;
                      case Rod of
                        MarshP :
                        begin
                          o := 1;
                          while o < 13 do
                          begin
                            if ObjStart = ObjZv[ObjZv[Uvaz.Obj].UpdOb].ObCI[o] then break;
                            inc(o);
                          end;

                          if o > 12 then
                          begin
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,106, ObjZv[ObjStart].Liter,1);
                            InsMsg(ObjStart,106);
                            exit;
                          end else
                          if ObjZv[Uvaz.Obj].bP[12] or ObjZv[Uvaz.Obj].bP[13] then
                          begin //------------------ блокировка кнопки горочного светофора
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,123, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,123);
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[11] then
                          begin //----------------------------------------------------- ГП
                            inc(MsgN);
                            Msg[MsgN] :=
                            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                            GetSmsg(1,83,ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,83);
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[7] then
                          begin //---------------------------------------------------- ЭГС
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,105, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,105);
                            exit;
                          end;

                          if not ObjZv[Uvaz.Obj].bP[8] then
                          begin //----------------------------------- нет согласия надвига
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,103, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,103);
                            exit;
                          end;

                          o := PutNadviga;

                          if Con.Pin = 1 then
                          begin
                            if not ObjZv[ObjZv[o].BasOb].bP[4] and
                            not ObjZv[ObjZv[o].BasOb].bP[2] then
                            begin //установлен враждебный поездной маршрут на путь надвига
                              inc(MsgN);
                              Msg[MsgN]:=GetSmsg(1,356,ObjZv[ObjZv[o].BasOb].Liter,1);
                              InsMsg(ObjZv[o].BasOb,356);
                              exit;
                            end;
                          end else
                          begin
                            if not ObjZv[ObjZv[o].BasOb].bP[4] and
                            not ObjZv[ObjZv[o].BasOb].bP[3] then
                            begin //- установлен нечетный поездной маршрут на путь надвига
                              inc(MsgN);
                              Msg[MsgN]:=GetSmsg(1,356,ObjZv[ObjZv[o].BasOb].Liter,1);
                              InsMsg(ObjZv[o].BasOb,356);
                              exit;
                            end;
                          end;
                        end;

                        MarshM :
                        begin
                          if not ObjZv[Uvaz.Obj].bP[9] then
                          begin //---------------------------------- нет согласия маневров
                            inc(MsgN);
                            Msg[MsgN]:=GetSmsg(1,104,ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,104);
                            exit;
                          end;
                        end;

                        else  result := trStop; exit;
                      end;
                      FullTail := true; result := trKonec;
                    end;

     tlFindIzvest : if ObjZv[Uvaz.Obj].bP[11] then result := trBreak //Занято приближение
                    else result := trStop;

   tlFindIzvStrel : result := trStop;

            else    if Con.Pin = 1 then
                    begin
                      Con := ObjZv[Uvaz.Obj].Sosed[2];
                      case Con.TypeJmp of
                        LnkRgn : result := trEnd;
                        LnkEnd : result := trEnd;
                        else     result := trNext;
                      end;
                    end else
                    begin
                      Con := ObjZv[Uvaz.Obj].Sosed[1];
                      case Con.TypeJmp of
                        LnkRgn : result := trEnd;
                        LnkEnd : result := trEnd;
                        else  result := trNext;
                      end;
                    end;
      end;
    end;
end;

//========================================================================================
//-------------------------------------------------------- Контроль маршрута надвига  (38)
function StepTrasNad(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Nad:TSos):TTrRes;
begin
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZv[Nad.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[Nad.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNext;
            end;
          end;
        end;

        tlCheckTrace : begin
          MarhTrac.PutNadviga := Nad.Obj; // сохранить индекс объекта согласия надвига с пути
          if Con.Pin = 1 then
          begin
            Con := ObjZv[Nad.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[Nad.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc : begin
          MarhTrac.PutNadviga := Nad.Obj; // сохранить индекс объекта согласия надвига с пути
          if Con.Pin = 1 then
          begin
            Con := ObjZv[Nad.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[Nad.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZv[Nad.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[Nad.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end;
      end;
    end;

//========================================================================================
//----------------------------------------------------- Контроль маршрута отправления (41)
function StepTrasOtpr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Otpr:TSos) : TTrRes;
var
  k,o,hvost,s_v_put : integer;
begin
  result := trNext;
  s_v_put := Otpr.Obj;
  case Lvl of
    tlFindTrace : //--------------------------------------------------------- поиск трассы
    begin
      result := trNext;
      if Con.Pin = 1 then Con := ObjZv[s_v_put].Sosed[2]
      else Con := ObjZv[s_v_put].Sosed[1];

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
      result := trNext;
      if Con.Pin = 1 then  Con := ObjZv[s_v_put].Sosed[2]
      else  Con := ObjZv[s_v_put].Sosed[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlCheckTrace :
    begin
      result := trNext;

      if Con.Pin = 1 then //--------------------- вход в объект со  стороны тчк 1 (нечетн)
      begin
        Con := ObjZv[s_v_put].Sosed[2];
        if (Rod = MarshP) and ObjZv[s_v_put].ObCB[1] then //поездной и проверять неч
        begin
          ObjZv[s_v_put].bP[21] := true; //-------- трассировка поездного отправления
          for k := 1 to 4 do //----------------------- пройти по возможным стрелкам в пути
          begin
            o := ObjZv[s_v_put].ObCI[k]; //------------- взять индекс стрелки в пути
            if o > 0 then
            begin
              hvost := ObjZv[o].BasOb;

              if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
              begin //------------------------- стрелка в пути не имеет контроля положения
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,81, ObjZv[hvost].Liter,1);
                InsMsg(hvost,81);//----------- Стрелка $ не имеет контроля положения
                MarhTrac.GonkaStrel := false;
                exit;
              end else
              if (ObjZv[hvost].bP[4] or //------ если у стрелки доп.замыкание или ...
              ObjZv[hvost].bP[14]) and //----------------- программное замыкание и...
              ObjZv[hvost].bP[21] then //------------------------ нет замыкания из СП
              begin //--------------------------- охранная стрелка трассируется в маршруте
                if (ObjZv[s_v_put].ObCB[k*3+1] and //охранность по "-" стрелки и ...
                ObjZv[hvost].bP[6]) or //-------------------- есть признак ПУ или ...
                (ObjZv[s_v_put].ObCB[k*3] and //---- охранность по "+" стрелки и ...
                ObjZv[hvost].bP[7]) then //-------------------------- есть признак МУ
                begin //------------------------ трассировка в разрез маршрута отправления
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[hvost].Liter,1); //----------- Стрелка $ замкнута
                  InsMsg(hvost,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if (not ObjZv[o].bP[1] or ObjZv[o].bP[2]) and //- не в плюсе и ...
              (not ObjZv[hvost].bP[21]) and (Rod = MarshP) then //-- стрелка замкнута
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,80, ObjZv[hvost].Liter,1);
                InsMsg(hvost,80);//----------- Стрелка $ не имеет контроля положения
                MarhTrac.GonkaStrel := false;
                exit;
              end;

              if ObjZv[s_v_put].ObCB[k*3+2] then // если предусмотрена гонка стрелки
              begin
                if ObjZv[s_v_put].ObCB[k*3] and //---------- охранность по "+" и ...
                not ObjZv[o].bP[1] then  //----------------------- стрелка не в плюсе
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then //--- нет индекса сигнала ...
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZv[hvost].bP[21] then //-если охранная стрелка замкнута
                    begin
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117); //-------------- Стрелочная секция замкнута
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then //------- охранная стрелка занята
                    begin
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118); //--------------- Стрелочная секция занята
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or   //-------- если стрелка на макети или
                    ObjZv[hvost].bP[19] then   //-------------------- на общем макете
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,136, ObjZv[hvost].Liter,1);//----- Стрелка $ на макете.
                      InsMsg(hvost,136);//Перед маршрутом должна быть переведена в +
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then //------------ охранная стрелка выключена
                    begin
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,121, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,121);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZv[hvost].bP[21] and //----- если нет замыкания из СП и ...
                    ObjZv[hvost].bP[22] then  //----------------- нет занятости из СП
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZv[hvost].bP[15] or //------------- стрелка на макете или
                      ObjZv[hvost].bP[19] then //-------------------- на общем макете
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,136, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,136); //"стрелка на макете, сначала установи +"
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,121, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,121); //------- стрелка выключена из управления
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZv[hvost].bP[15] or
                      ObjZv[hvost].bP[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] :=
                        GetSmsg(1,136, ObjZv[hvost].Liter,1);
                        InsWar(hvost,136); //----- стрелка на макете, сначала в плюс
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and
                not ObjZv[o].bP[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZv[hvost].bP[21] then
                    begin //------------------------------------ охранная стрелка замкнута
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117); //---------------------- секция СП замкнута
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then
                    begin //-------------------------------------- охранная стрелка занята
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or
                    ObjZv[hvost].bP[19] then
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,137, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,137);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then
                    begin //----------------------------------- охранная стрелка выключена
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,159, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,159);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZv[hvost].bP[21] and
                    ObjZv[hvost].bP[22] then
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZv[hvost].bP[15] or
                      ObjZv[hvost].bP[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,137, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,137);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,159, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,159);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] :=
                        GetSmsg(1,137, ObjZv[hvost].Liter,1);
                        InsWar(hvost,137);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end;
                  end;
                end;
              end else
              begin //--------------------- маршрутная гонка стрелки в пути не выполняется
                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //- нет сигн.прикр. для стрелки в пути или нет занятости,замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[o].Liter,1);
                    InsMsg(hvost,268);
                    MarhTrac.GonkaStrel := false;
                    exit;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //-- нет сигн.прикр.для стрелки в пути или нет занятости,замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,267, ObjZv[o].Liter,1);
                    InsMsg(ObjZv[o].BasOb,267);
                    MarhTrac.GonkaStrel := false;
                    exit;
                  end;
                end;
              end;
            end;
          end;
        end
        else ObjZv[s_v_put].bP[21] := false;
      end else
      begin
        Con := ObjZv[s_v_put].Sosed[1];

        if (Rod = MarshP) and ObjZv[s_v_put].ObCB[2] then
        begin
          ObjZv[s_v_put].bP[21] := true;
          for k := 1 to 4 do
          begin
            o := ObjZv[s_v_put].ObCI[k];
            if o > 0 then
            begin
              hvost := ObjZv[o].BasOb;
              if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
              begin //------------------------- стрелка в пути не имеет контроля положения
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,81, ObjZv[hvost].Liter,1);
                InsMsg(hvost,81);
                MarhTrac.GonkaStrel := false; exit;
              end else

              if (ObjZv[hvost].bP[4] or ObjZv[hvost].bP[14]) and
              ObjZv[hvost].bP[21] then
              begin //--------------------------- охранная стрелка трассируется в маршруте
                if (ObjZv[s_v_put].ObCB[k*3+1] and ObjZv[hvost].bP[6]) or
                (ObjZv[s_v_put].ObCB[k*3] and ObjZv[hvost].bP[7]) then
                begin //------------------------ трассировка в разрез маршрута отправления
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[hvost].Liter,1);
                  InsMsg(hvost,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if (not ObjZv[o].bP[1] or ObjZv[o].bP[2]) and //- не в плюсе и ...
              (not ObjZv[hvost].bP[21]) and (Rod = MarshP) then //-- стрелка замкнута
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,80, ObjZv[hvost].Liter,1);
                InsMsg(hvost,80);//------------------------------ Стрелка $ замкнута
                MarhTrac.GonkaStrel := false;
                exit;
              end;

              if ObjZv[s_v_put].ObCB[k*3+2] then
              begin //------------------------ маршрутная гонка стрелки в пути выполняется
                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZv[hvost].bP[21] then
                    begin //------------------------------------ охранная стрелка замкнута
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then
                    begin //-------------------------------------- охранная стрелка занята
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,136, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,136);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then
                    begin //----------------------------------- охранная стрелка выключена
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,121, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,121);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22] then
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,136, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,136);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,121, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,121);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] :=
                        GetSmsg(1,136, ObjZv[hvost].Liter,1);
                        InsWar(hvost,136);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    if not ObjZv[ObjZv[o].BasOb].bP[21] then
                    begin //------------------------------------ охранная стрелка замкнута
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then
                    begin //-------------------------------------- охранная стрелка занята
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                    begin //----------------------------------- охранная стрелка на макете
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,137, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,137);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then
                    begin //----------------------------------- охранная стрелка выключена
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,159, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,159);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- есть прикрытие стрелки в пути
                    if ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22] then
                    begin //------------------------------- стрелка свободна и не замкнута
                      if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,137, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,137);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- охранная стрелка выключена
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,159, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,159);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                      begin //--------------------------------- охранная стрелка на макете
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] :=
                        GetSmsg(1,137, ObjZv[hvost].Liter,1);
                        InsWar(hvost,137);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end;
                  end;
                end;
              end else
              begin //--------------------- маршрутная гонка стрелки в пути не выполняется
                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //- нет сигн.прикр. для стрелки в пути или нет занятости,замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[o].Liter,1);
                    InsMsg(hvost,268);
                    MarhTrac.GonkaStrel := false; exit;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //- нет сигн.прикр. для стрелки в пути или нет занятости,замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,267, ObjZv[o].Liter,1);
                    InsMsg(hvost,267);
                    MarhTrac.GonkaStrel := false; exit;
                  end;
                end;
              end;
            end;
          end;
        end
        else ObjZv[s_v_put].bP[21] := false;
      end;

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
      end;
    end;

    //----------------------- компьютерное замыкание трассы маршрута ---------------------
    tlZamykTrace :
    begin
      ObjZv[s_v_put].bP[21] := false;//---- признак трассировки поездного отправления

      if Con.Pin = 1 then
      begin
        Con := ObjZv[s_v_put].Sosed[2];

        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;

        if ObjZv[s_v_put].ObCB[1] then //--------------------- если проверять 1->2
        begin
          if Rod = MarshP then ObjZv[s_v_put].bP[20] := true //поездное отправление
          else ObjZv[s_v_put].bP[20] := false;
        end;
      end else
      if Con.Pin = 2 then
      begin
        Con := ObjZv[s_v_put].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;

        if ObjZv[s_v_put].ObCB[2] then //--------------------- если проверять 2->1
        begin
          if Rod = MarshP then ObjZv[s_v_put].bP[20] := true //поездное отправление
          else ObjZv[s_v_put].bP[20] := false;
        end;
      end
      else  ObjZv[s_v_put].bP[20] := false; //------------ другие точки недопустимы
    end;

    tlAutoTrace,
    tlSignalCirc,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      result := trNext;
      if Con.Pin = 1 then
      begin
        if ObjZv[s_v_put].ObCB[1] then  //-------- если проверяется в маршрутах 1->2
        begin
          if Rod = MarshP then
          begin
            ObjZv[s_v_put].bP[20] := true; //--------- фиксируем поездное отправление
            ObjZv[s_v_put].bP[21] := true; //фиксируем трассировку поездного отпр-ния
            for k := 1 to 4 do
            begin
              o := ObjZv[s_v_put].ObCI[k];
              if o > 0 then
              begin
                if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
                begin //----------------------- стрелка в пути не имеет контроля положения
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,81);
                end;

                if Lvl = tlRazdelSign then
                begin
                  if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                  begin //----------------------- стрелка в пути не в плюсовом положении
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end;
                end;


                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //неиспр.сигнал прикрытия стрелки в пути при замыкания выходной СП
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin //-------------------------------- неисправен сигнал прикрытия
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else //------------------------------------- неисправен светофор
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,272, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //-- неиспр.сигнал прикрытия стр. в пути при замкнутой выходной СП
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else // неисправен светофор

                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,272, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],272);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end else
          begin
            ObjZv[s_v_put].bP[20] := false;
            ObjZv[s_v_put].bP[21] := false;
          end;
        end else
        begin
          ObjZv[s_v_put].bP[20] := false;
          ObjZv[s_v_put].bP[21] := false;
        end;

        if result = trNext then
        begin
          Con := ObjZv[s_v_put].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end else
      begin
        if ObjZv[s_v_put].ObCB[2] then
        begin
          if Rod = MarshP then
          begin
            ObjZv[s_v_put].bP[20] := true;
            ObjZv[s_v_put].bP[21] := true;
            for k := 1 to 4 do
            begin
              o := ObjZv[s_v_put].ObCI[k];
              if o > 0 then
              begin
                if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
                begin //----------------------- стрелка в пути не имеет контроля положения
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,81);
                end;

                if Lvl = tlRazdelSign then
                begin
                  if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                  begin //----------------------- стрелка в пути не в плюсовом положении
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- стрелка в пути не имеет контроля в плюсе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //-- неиспр.сигнал прикрытия стр в пути при замыкнутой выходной СП
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      //-------------------------------------- неисправен сигнал прикрытия
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else //------------------------------------- неисправен светофор
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,272, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ стрелка в пути не имеет контроля в минусе
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- нет сигнала прикрытия для стрелки в пути
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- нет занятости, замыкания
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //-- неиспр.сигнал прикрытия стр. в пути при замкнутой выходной СП
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else // неисправен светофор
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,272, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],272);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end else
          begin
            ObjZv[s_v_put].bP[20] := false;
            ObjZv[s_v_put].bP[21] := false;
          end;
        end else
        begin
          ObjZv[s_v_put].bP[20] := false;
          ObjZv[s_v_put].bP[21] := false;
        end;
        if result = trNext then
        begin
          Con := ObjZv[s_v_put].Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;
      end;
    end;

    tlOtmenaMarh :
    begin
      if ObjZv[s_v_put].bP[5] then ObjZv[s_v_put].bP[20] := false;
      ObjZv[s_v_put].bP[21] := false;
      if Con.Pin = 1 then
      begin
        Con := ObjZv[s_v_put].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[s_v_put].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end;
    end;

    else result := trNext;
   end;
end;

//========================================================================================
//------------------------ Контроль перезамыкания маршрутов приема для стрелки в пути (42)
function StepTrasPrzPr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Prz:TSos) : TTrRes;
var
  k,o : integer;
begin
  case Lvl of
    //----------------------------- П О И С К   Т Р А С С Ы ------------------------------
    tlFindTrace :
    begin
      result := trNext;
      //------------- при поиске трассы поездного маршрута сохранить объект стрелки в пути
      if Rod = MarshP then
      MarhTrac.VP := Prz.Obj;

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else Con := ObjZv[Prz.Obj].Sosed[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlVZavTrace,   //--------- Проверка взаимозависимостей по трассе (охранности и прочее)
    tlContTrace :  //----- Довести трассу до предполагаемого конца или отклоняющей стрелки
    begin
      result := trNext;

      if Rod = MarshP then MarhTrac.VP := Prz.Obj; //сохранить объект для поезда

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else Con := ObjZv[Prz.Obj].Sosed[1];

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
          o := ObjZv[Prz.Obj].ObCI[k];
          if o > 0 then
          begin //-------------------- проверить наличие трассировки по "-" стрелки в пути
            if ObjZv[o].bP[13] then
            begin// завершить трассировку если была езда по "-" стрелки в пути
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,482, ObjZv[ObjZv[o].BasOb].Liter,1);
              InsWar(ObjZv[o].BasOb,482);
              break;
            end;
          end;
        end;
      end;
      result := trNext;

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else  Con := ObjZv[Prz.Obj].Sosed[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlPovtorMarh,
    tlFindIzvest,
    tlFindIzvStrel :
    begin
      result := trNext;

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else Con := ObjZv[Prz.Obj].Sosed[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    tlZamykTrace :
    begin
      result := trNext;
      if Rod = MarshP then ObjZv[Prz.Obj].bP[1] := true; //- признак поездного приема

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else Con := ObjZv[Prz.Obj].Sosed[1];

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
      if Rod = MarshP then MarhTrac.VP:= Prz.Obj;//хранить объект стрелки в пути
      result := trNext;

      if Rod = MarshP then ObjZv[Prz.Obj].bP[1] := true; //- признак поездного приема

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else Con := ObjZv[Prz.Obj].Sosed[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlOtmenaMarh :
    begin
      if Con.Pin = 1 then
      begin
        Con := ObjZv[Prz.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end else
      begin
        Con := ObjZv[Prz.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end;
    end;

    else result := trNext;
  end;
end;

//========================================================================================
//------------------------------------------------------------------------------- оПИ (43)
function StepTrasOPI(var Con:TSos; const Lvl:TTrLev; Rod:Byte; OPI:TSos) : TTrRes;
var
  j,k,o : integer;
  tr : boolean;
begin
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZv[OPI.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[OPI.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNext;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZv[OPI.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[OPI.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNext;
            end;
          end;
        end;

        tlCheckTrace : begin
          tr := true;
          result := trNext;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZv[OPI.Obj].ObCB[1] then
            begin
              o := ObjZv[OPI.Obj].BasOb;
              if o > 0 then
              begin // протрассировать выезд на пути из маневрового района
                k := 2;
                o := ObjZv[OPI.Obj].Sosed[k].Obj; k := ObjZv[OPI.Obj].Sosed[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZv[o].TypeObj of
                    2 : begin // стрелка
                      case k of
                        2 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[11] then
                          begin // стрелку можно поставить в отвод по минусу
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[10] then
                          begin // стрелку можно поставить в отвод по плюсу
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
                    end;
                    48 : begin // РПо
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj; end
                    else begin k := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then //---------- нет отводящих стрелок по трассе до общей точки пучка
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1);
                InsMsg(ObjZv[OPI.Obj].BasOb,258);
                MarhTrac.GonkaStrel := false;
              end else
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // МИ и оПИ
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1);
                InsWar(ObjZv[OPI.Obj].BasOb,258);
                MarhTrac.GonkaStrel := false;
              end;
            end;
            Con := ObjZv[OPI.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZv[OPI.Obj].ObCB[2] then
            begin
              o := ObjZv[OPI.Obj].BasOb;
              if o > 0 then
              begin //---------------- протрассировать выезд на пути из маневрового района
                k := 1;
                o := ObjZv[OPI.Obj].Sosed[k].Obj;
                k := ObjZv[OPI.Obj].Sosed[k].Pin;
                j := 50;
                while j > 0 do
                begin
                  case ObjZv[o].TypeObj of
                    2 : begin // стрелка
                      case k of
                        2 : begin// стрелку можно поставить в отвод по минусу
                          if ObjZv[ObjZv[o].BasOb].bP[11] then begin tr := false; break; end;
                        end;
                        3 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[10] then
                          begin // стрелку можно поставить в отвод по плюсу
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
                    end;
                    48 : begin // РПо
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj; end
                    else begin k := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then // нет отводящих стрелок по трассе до общей точки пучка
              begin
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1); InsMsg(ObjZv[OPI.Obj].BasOb,258); MarhTrac.GonkaStrel := false;
              end else
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // МИ и оПИ
              begin
                inc(MarhTrac.WarN); MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1); InsWar(ObjZv[OPI.Obj].BasOb,258); MarhTrac.GonkaStrel := false;
              end;
            end;
            Con := ObjZv[OPI.Obj].Sosed[1];
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
          result := trNext;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZv[OPI.Obj].ObCB[1] then
            begin
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // МИ и оПИ
              begin
                inc(MarhTrac.WarN); MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1); InsWar(ObjZv[OPI.Obj].BasOb,258);
              end;
            end;
            Con := ObjZv[OPI.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZv[OPI.Obj].ObCB[2] then
            begin
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // МИ и оПИ
              begin
                inc(MarhTrac.WarN); MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1); InsWar(ObjZv[OPI.Obj].BasOb,258);
              end;
            end;
            Con := ObjZv[OPI.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZv[OPI.Obj].Sosed[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end else
          begin
            Con := ObjZv[OPI.Obj].Sosed[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNext;
            end;
          end;
      end;
    end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepTrasZona(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Zon:TSos) : TTrRes;
//------------------------------------------------------------------- Зона оповещения (45)
begin
      case Lvl of
        tlFindTrace :
        begin
          result := trNext;
          if Con.Pin = 1 then
          begin
            Con := ObjZv[Zon.Obj].Sosed[2];
          end else
          begin
            Con := ObjZv[Zon.Obj].Sosed[1];
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
          result := trNext;
          if Con.Pin = 1 then Con := ObjZv[Zon.Obj].Sosed[2]
          else Con := ObjZv[Zon.Obj].Sosed[1];
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
          result := trNext;
          if ObjZv[Zon.Obj].bP[1] then
          begin //------------------------------------------- Включено оповещение монтеров
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,456, ObjZv[Zon.Obj].Liter,1); //-- $ оповещение монтеров включено
            InsWar(Zon.Obj,456);
          end;
          if Con.Pin = 1 then Con := ObjZv[Zon.Obj].Sosed[2]
          else Con := ObjZv[Zon.Obj].Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlAutoTrace :
        begin
          result := trNext;
          if Con.Pin = 1 then Con := ObjZv[Zon.Obj].Sosed[2]
          else Con := ObjZv[Zon.Obj].Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        else result := trNext;
      end;
    end;

//========================================================================================
//--------------------------------------- прочие объекты (транзит через себя без проверок)
function StepTrasRazn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Raz:TSos) : TTrRes;
begin
  if Con.Pin = 1 then Con := ObjZv[Raz.Obj].Sosed[2] else Con := ObjZv[Raz.Obj].Sosed[1];
  if (Con.TypeJmp <> LnkRgn) and (Con.TypeJmp <> LnkEnd) then result := trNext
  else
  if Lvl = tlFindTrace then result := trRepeat  //------ при поиске трассы неудача = откат
  else result := trEnd;
end;

//========================================================================================
//---------------------------------------------------- шаг через стрелку при поиске трассы
function StepStrFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
begin
  result := trNext;
  with ObjZv[Str.Obj] do
  begin
    case Con.Pin of //------------- переключатель по точке входа через коннектор с соседом
      //-------------------------------------------------------------------- Против шерсти
      1 :
      begin
        if ObCB[1] then //------------ если сбрасывающая, то трассируется только по минусу
        begin Con := Sosed[3]; BP[10] := true; BP[11] := true; end
        else //----------------------------------------------------------- Ходовая стрелка
        begin
          if OBCB[3] then //----------------------------- если основные маршруты по минусу
          begin
            //---------- не было первого прохода, сначала идти по минусу, метить 1й проход
            if not BP[10] then begin Con := Sosed[3]; BP[10] := true;  BP[11] := true; end
            //------------------- при втором проходе пройти по плюсу, метить второй проход
            else begin Con := Sosed[2]; BP[11] := false; end;
          end else//-------------------------------------- если основные маршруты по плюсу
          begin
            //--- 1й проход был, 2й проход идти по минусу стрелки, метить вторичный проход
            if BP[10] then begin Con := Sosed[3];BP[11] := true; end
            //------------------- Вначале пройти по плюсу стрелки, метить первичный проход
            else begin Con := Sosed[2]; BP[10] := true; end;
          end;
        end;
      end;

      2 : begin BP[12] := true; Con := Sosed[1]; end; // Пометить проход по шерсти с плюса
      3 : begin BP[13] := true; Con := Sosed[1]; end;// Пометить проход по шерсти с минуса
    end;
    if(Con.TypeJmp = LnkRgn) or  (Con.TypeJmp = LnkEnd) then result := trRepeat
    else result := trNext;
  end;
end;

//========================================================================================
//---------------------------------------------- проход через стрелку при продлении трассы
function StepStrContTras(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  p : boolean;
  k : integer;
begin
  result := trNext;
  p := false;
  with ObjZv[Str.obj] do
  begin
    case Con.Pin of
      1 ://----------------------------------------------- противошерстный вход на стрелку
      begin
        if MarhTrac.VP >0 then //----------------- есть ВП для трассировки маршрута приема
        begin //------------------------------------------ пройти по списку стрелок в пути
          //- получить очередную стрелку в пути, если это она  и через неё проходит трасса
          for k := 1 to 4 do //-------------------------- может быть до 4-х стрелок в пути
          //---------- если эта стрелкa указана в объекте ВП, и есть признак добора трассы
          if(ObjZv[MarhTrac.VP].ObCI[k] = Str.obj) and ObjZv[MarhTrac.VP].ObCB[k+1] then
          begin //------------------------------------------ трассировать стрелку по плюсу
            Con := Sosed[2]; //------------------------------- получить коннектор по плюсу
            bP[10] := true; bP[11] := false; //-- установить 1-ый проход снять 2-ой проход
            bP[12] := false; bP[13] := false;//------- снять пошерстная в плюсе и в минусе
            result := trNext;
            p := true;
            break;
          end;

          if not p then
          begin //--------------------- стрелка не описана в текущем списке стрелок в пути
            con := Sosed[1]; //-------------------------------- коннектор со стороны входа
            result := trBreak; //------------------------------------- откатить от стрелки
          end;
        end else //---------------------------------------------------- нет стрелок в пути
        if ObCB[1] then //-------------------------------------- если сбрасывающая стрелка
        begin //---------------- сбрасывающая стрелка всегда трассируется только по минусу
          Con := Sosed[3]; //---------------------------------- берем коннектор за минусом
          bP[10] := true; bP[11] := true; //--------- метим 1ый и 2ой проходы трассировки
          bP[12] := false; bP[13] := false; //---------- пошерстная не в плюсе,не в минусе
          result := trNext;
        end else
        begin //---------------------------------------- нет стрелок в пути и сбрасывающих
          con := Sosed[1];result := trBreak; //коннектор перед входом, откатить от стрелки
        end;
      end;

      2 :
      begin //-------------------------------- пошерстный проход по стрелке со стороны "+"
        bP[12] := true; Con := Sosed[1];//- метить проход по шерсти с плюса,коннект на ось
        case Con.TypeJmp of  //------------------------------------------- типы коннектора
          LnkRgn : result := trStop; //------------------------- конечный коннектор района
          LnkEnd : result := trStop; //------------------------- конечный коннектор строки
          else result := trNext;
        end;
      end;

      3 :
      begin //------------------------------------------- пошерстный проход со стороны "-"
        bP[13] := true; Con := Sosed[1];// метить проход по шерсти с минуса,коннект на ось
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------- проход через стрелку при проверке зависимостей
function StepStrZavTras(var Con:TSos; const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  k : integer;
begin
  result := trNext;
  with ObjZv[Str.Obj] do
    begin
    case Con.Pin of
      1 :
      begin //-----------------------------противошерстный вход, проверить по мунусу стрелки
        if MarhTrac.VP > 0 then //------------- если есть стрелка в пути в поездном маршруте
        begin
          for k := 1 to 4 do //-------------- проверить трассировку стрелки в пути по минусу
          if (ObjZv[MarhTrac.VP].ObCI[k] = Str.Obj) and  ObjZv[MarhTrac.VP].ObCB[k+1] then
          begin if bP[10] and bP[11] then exit; end;
        end;

        if bP[10] and not bP[11] then
        begin
          con := Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNext;
          end;
          exit;
        end else
        if bP[10] and bP[11] then
        begin
          con := Sosed[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNext;
          end;
          exit;
        end
        else result := trStop;
      end;

      2 :
      begin
        if bP[12]  then
        begin
          con := Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNext;
          end;
        end else result := trStop;
      end;

      3 :
      begin
        if bP[13] then
        begin
          con := Sosed[1];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNext;
          end;
        end else result := trStop;
      end;
    end;
  end;
end;

//========================================================================================
//------------------------ шаг через стрелку при проверке враждебностей по трассе маршрута
function StepStrChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
var
  zak : boolean;
  o,Xst : integer;
begin
  result := trNext;

  with ObjZv[Str.Obj] do
  begin
    Xst := BasOb;
    //---------------- сначала проверить замыкание маршрута отправления со стрелкой в пути
    if not CheckOtpravlVP(Str.Obj) then result := trBreak;

    //---------------------------------- теперь проверить ограждение пути через Вз стрелки
    if not CheckOgrad(Str.Obj) then result := trBreak;

  if ObCB[6] then zak:=ObjZv[Xst].bP[17]//закрытия дальней
  else zak := ObjZv[Xst].bP[16]; //------- иначе признак закрытия ближней

  if bP[16] or zak then //---------------- если по стрелке закрыто движение
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119, Liter,1);
    InsMsg(Str.Obj,119);  //------------------------- "Стрелка $ закрыта для движения"
    MarhTrac.GonkaStrel := false;
  end;

  case Con.Pin of
    1 : //-------------------------------------------------- вход на стрелку через точку 1
    begin
      if not ObCB[11] then
      begin //-------------------------- стрелка не сбрасывающая или остряки не развернуты
        //----------------------------------------------------------- если стрелка дальняя
        if ObCB[6] then zak := ObjZv[Xst].bP[34]
        else zak := ObjZv[Xst].bP[33];

        if bP[17] or zak then
        begin //---------------------------- стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,453, Liter,1);
          InsMsg(Str.Obj,453);//---- Стрелка $ закрыта для противошерстного движения
          MarhTrac.GonkaStrel := false;
        end;
      end;
       //не повтор задания маршрута, 1ый проход трассировки, не 2й проход трассировки или
      if(not MarhTrac.Povtor and (bP[10] and not bP[11])) or
      // повтор задания маршрута, есть ПУ и нет МУ (стр. идет в +)
      (MarhTrac.Povtor and (ObjZv[Xst].bP[6] and not ObjZv[Xst].bP[7]))
      then
      begin
        if not NegStrelki(Str.Obj,true)
        then result := trBreak;//------------------------------------------ негабаритность

        if bP[1] then //--------------------------------- если есть ПК
        begin
          if ObjZv[Xst].bP[19] then //--------- если на макете
          begin //------------------------------ стрелка на макете - выдать предупреждение
            if ObjZv[Xst].bP[27] then //---- если сообщ. опер.
            begin //---------------------- Повторить предупреждение для лидирующей стрелки
              if ObjZv[Xst].iP[3]=Str.Obj then //от макета
              begin
                result := trBreak;
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120, ObjZv[Xst].Liter,1);
                InsWar(Str.Obj,120); //------------------------- Стрелка $ на макете
              end;
            end else
            begin
              if not MarhTrac.Dobor then
              begin
                ObjZv[Xst].iP[3] := Str.Obj; 
                ObjZv[Xst].bP[27] := true;
              end;
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,120, ObjZv[Xst].Liter,1);
              InsWar(BasOb,120);//--------- Стрелка $ на макете
            end;
          end;
        end else
        begin
          if not MarhTrac.Povtor and not MarhTrac.Dobor then
          inc(MarhTrac.GonkaList);//-- увеличить счет переводимых стрелок трассы
          if ObjZv[Xst].bP[19] then
          begin //--------------------------------------= стрелка на макете - враждебность
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,136, ObjZv[Xst].Liter,1);

            InsMsg(BasOb,136);
            //Стрелка $ на макете. Перед установкой маршрута должна быть переведена в плюс

            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Xst].bP[21] then //--------------------------------замыкание секции
          begin
            o := GetStateSP(1,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[o].Liter,1);
            InsMsg(o,82); //-------------------------------------------  Участок $ замкнут
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Xst].ObCB[3] and//если надо проверять МСП и
          not ObjZv[Xst].bP[20] then //..... идет выдержка МСП
          begin
            InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
            ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,392, Liter,1);
            InsMsg(Str.Obj,392);// Идет выдержка времени дополнит. замыкания стрелки
            MarhTrac.GonkaStrel := false;
          end;



          if ObjZv[Xst].bP[4] then //------ замыкание в хвосте
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,80, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,80); //------------ Стрелка $ замкнута
            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Xst].bP[22] then //------ занятие из СП
          begin
            o := GetStateSP(2,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[o].Liter,1);
            InsMsg(o,83); //---------------------------------------- Участок $ занят
            MarhTrac.GonkaStrel := false;
          end;

          if bP[18] then
          begin //---------------------------------------- стрелка выключена из управления
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,121, ObjZv[Xst].Liter,1);

            //-------------------- Стрелка $ выключена из управления (в маршруте по плюсу)
            InsMsg(BasOb,121);

            MarhTrac.GonkaStrel := false;
          end;

          if MarhTrac.Povtor then
          begin //---------------------------------- проверка повторной установки маршрута
            if not bP[2] then //------------------------------- нет МК
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,81, ObjZv[Xst].Liter,1);
              InsMsg(BasOb,81); //------ Стрелка $ без контроля
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- проверка первичной трассировки маршрута
            if not bP[2] and  //----------------------------- нет МК и
            not ObjZv[Xst].bP[6] then  //-------------- нет ПУ
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,81, ObjZv[Xst].Liter,1);
              InsMsg(BasOb,81); //------ Стрелка $ без контроля
              MarhTrac.GonkaStrel := false;
            end;
          end;
        end;

        if ObjZv[Xst].bP[7] then
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);
          MarhTrac.GonkaStrel := false;
        end
        else  con := Sosed[2];

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
        exit;
      end else //-------------------------------------------------- стрелка не идет в плюс
      if (not MarhTrac.Povtor and //------------------- не повтор маршрута и ...
      (bP[10] and //------------------------------ первый проход и ...
      bP[11])) or //---------------------------- второй проход или ...
      (MarhTrac.Povtor and  //------------------------------------- повтор и ...
      (not ObjZv[Xst].bP[6] and  //-------------- нет ПУ и ...
      ObjZv[Xst].bP[7])) then //---------------------- есть МУ
      begin
        if  not NegStrelki(Str.Obj,false) then result := trBreak; //------ негабарит

        if bP[2] then //-------------------------------------- если МК
        begin
          if ObjZv[Xst].bP[19] then //----- есть стр.на макете
          begin //------------------------------ стрелка на макете - выдать предупреждение
            if ObjZv[Xst].bP[27] then  //-------- сообщить ДСП
            begin //---------------------- Повторить предупреждение для лидирующей стрелки
              if ObjZv[Xst].iP[3] = Str.Obj then //--- эта стр
              begin
                result := trBreak;
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120, ObjZv[Xst].Liter,1);
                InsWar(BasOb,120); //------ Стрелка $ на макете
              end;
            end else //---------------------------------------------- не надо сообщать ДСП
            begin
              if not MarhTrac.Dobor then  //------------------- не нужен "добор"
              begin
                ObjZv[Xst].iP[3] := Str.Obj;  //----- запомнить
                ObjZv[Xst].bP[27] := true; //-----  есть макет
              end;
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,120, ObjZv[Xst].Liter,1);
              InsWar(BasOb,120);
            end;
          end;
        end else //---------------------------------------------------------------- нет МК
        begin
          if not MarhTrac.Povtor and //--------------- не повтрор маршрута и ...
          not MarhTrac.Dobor //-------------------------------------- не "добор"
          then inc(MarhTrac.GonkaList);//--- увеличить число переводимых стрелок

          if ObjZv[Xst].bP[19] then
          begin //--------------------------------------- стрелка на макете - враждебность
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,137, ObjZv[Xst].Liter,1);

            InsMsg(BasOb,137);
            //Стрелка $ на макете.Перед установкой маршрута должна быть переведена в минус

            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Xst].ObCB[3] and//если надо проверять МСП и
          not ObjZv[Xst].bP[20] then //..... идет выдержка МСП
          begin
            InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
            ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,392, Liter,1);
            InsMsg(Str.Obj,392);// Идет выдержка времени дополнит. замыкания стрелки
            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Xst].bP[21] then //---- замыкание из СП
          begin
            o := GetStateSP(1,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[o].Liter,1);
            InsMsg(o,82);//--------------------------------------------- Участок $ замкнут
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[Xst].bP[4] or bP[4] then
          begin //---------------------------------------------------- дополнит. замыкание
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,80, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,80); //------------ Стрелка $ замкнута
            MarhTrac.GonkaStrel := false;
          end else
          if not ObjZv[Xst].bP[22] then //------- занятость СП
          begin
            o := GetStateSP(2,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[o].Liter,1);
            InsMsg(o,83); //---------------------------------------- Участок $ занят
            MarhTrac.GonkaStrel := false;
          end else
          if bP[18] then
          begin //---------------------------------------- стрелка выключена из управления
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,159, ObjZv[Xst].Liter,1);

            InsMsg(BasOb,159);
            //------------------- Стрелка $ выключена из управления (в маршруте по минусу)

            MarhTrac.GonkaStrel := false;
          end;

          if MarhTrac.Povtor then
          begin //---------------------------------- проверка повторной установки маршрута
            if not bP[1] then //------------------------------- нет ПК
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,81, ObjZv[Xst].Liter,1);
              InsMsg(BasOb,81); //------ Стрелка $ без контроля
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- проверка первичной трассировки маршрута
            if not bP[1] and  //------------------------------- нет ПК
            not ObjZv[Xst].bP[7] then
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,81, ObjZv[Xst].Liter,1);
              InsMsg(BasOb,81);
              MarhTrac.GonkaStrel := false;
            end;
          end;
        end;

        if ObjZv[Xst].bP[6] then //------------------- есть ПУ
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);  //------------- Стрелка $ замкнута
          MarhTrac.GonkaStrel := false;
        end;

        con := Sosed[3]; //------------ выход из стрелки по отклонению
        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 : //------------------------------------------------ вход через прямую ветку стрелки
    begin
      if  not NegStrelki(Str.Obj,true) then result := trBreak; //--------- негабарит

      if bP[1] then //----------------------------------- если есть ПК
      begin
        if ObjZv[Xst].bP[19] then
        begin //-------------------------------- стрелка на макете - выдать предупреждение
          if ObjZv[Xst].bP[27] then
          begin //------------------------ Повторить предупреждение для лидирующей стрелки
            if ObjZv[Xst].iP[3] = Str.Obj then
            begin
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,120, ObjZv[Xst].Liter,1);
              InsWar(BasOb,120);
            end;
          end else
          begin
            if not MarhTrac.Dobor then
            begin
              ObjZv[Xst].iP[3] := Str.Obj; 
              ObjZv[Xst].bP[27] := true;
            end;
            result := trBreak;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120, ObjZv[Xst].Liter,1);
            InsWar(BasOb,120);
          end;
        end;
      end else
      begin
        if not MarhTrac.Povtor and not MarhTrac.Dobor
        then inc(MarhTrac.GonkaList); //---- увеличить число переводимых стрелок

        if ObjZv[Xst].bP[19] then
        begin //----------------------------------------- стрелка на макете - враждебность
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,136, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,136);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[21] then  //--------------------------------- замыкание из СП
        begin
          o := GetStateSP(1,Str.Obj);
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,82, ObjZv[o].Liter,1);
          InsMsg(BasOb,82);
          MarhTrac.GonkaStrel := false;
        end;

        if ObjZv[Xst].ObCB[3] and//если надо проверять МСП и
        not ObjZv[Xst].bP[20] then //..... идет выдержка МСП
        begin
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,392, Liter,1);
          InsMsg(Str.Obj,392);//-- Идет выдержка времени дополнит. замыкания стрелки
          MarhTrac.GonkaStrel := false;
        end;

        if ObjZv[Xst].bP[4] then  //----------- доп. замыкание
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[22] then  //-------- занятость СП
        begin
          o := GetStateSP(2,Str.Obj);
          result := trBreak; inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,83, ObjZv[o].Liter,1);
          InsMsg(o,83);
          MarhTrac.GonkaStrel := false;
        end;

        if bP[18] then
        begin //------------------------------------------ стрелка выключена из управления
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,121, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,121);
          MarhTrac.GonkaStrel := false;
        end;

        if MarhTrac.Povtor then
        begin //------------------------------------ проверка повторной установки маршрута
          if not bP[2] then //--------------------------------- нет МК
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,81, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,81);
            MarhTrac.GonkaStrel := false;
          end;
        end else
        begin //---------------------------------- проверка первичной трассировки маршрута
          if not bP[2] and
          not ObjZv[Xst].bP[6] then
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,81, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,81);
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;

      if (not MarhTrac.Povtor and bP[12]) or//не повтор и активизирован автовозврат или...
      (MarhTrac.Povtor and //-------------------------------------- повтор и ...
      ObjZv[Xst].bP[6] and not ObjZv[Xst].bP[7]) then  //ПУ и нет МУ
      begin
        if ObjZv[Xst].bP[7] then //------------------------------------------------ нет МУ
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80); //----------------------------------------- Стрелка $ замкнута
          MarhTrac.GonkaStrel := false;
        end else
        if not bP[1] and not bP[2] and not ObjZv[Xst].bP[6] then//если нет ПК, МК и нет ПУ
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,81, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,81);//-------------------------------------- Стрелка $ без контроля
          MarhTrac.GonkaStrel := false;
        end;

        con := Sosed[1]; //------------------------------------ выход через вход (точку 1)

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
      end
      else result := trStop;
    end;

    3 : //----------------------------------------------- вход на стрелку через отклонение
    begin
      if ObCB[11] then//------------------------ стрелка сбрасывающая и остряки развернуты
      begin
        if ObCB[6] //----------------------------------------------------- стрелка дальняя
        //----------------------- тогда взять закрытие из FR4 ближней для противошерстного
        then zak := ObjZv[Xst].bP[33]
        //----------------------- иначе взять закрытие из FR4 дальней для противошерстного
        else zak := ObjZv[Xst].bP[34];

        if bP[17] or zak then
        begin //---------------------------- стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453, Liter,1);
          InsMsg(Str.Obj,453);//------------- Стрелка $ закрыта для противошерстного движ.
          MarhTrac.GonkaStrel := false;
        end;
      end;

      if  not NegStrelki(Str.Obj,false)  then result := trBreak; //-------- негабаритность

      if bP[2] then //------------------------------------------------------- если есть МК
      begin
        if ObjZv[Xst].bP[19] then
        begin //-------------------------------- стрелка на макете - выдать предупреждение
          if ObjZv[Xst].bP[27] then
          begin //------------------------ Повторить предупреждение для лидирующей стрелки
            if ObjZv[Xst].iP[3] = Str.Obj then
            begin
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,120, ObjZv[Xst].Liter,1);
              InsWar(BasOb,120);
            end;
          end else
          begin
            if not MarhTrac.Dobor then
            begin
              ObjZv[Xst].iP[3] := Str.Obj;
              ObjZv[Xst].bP[27] := true;
            end;
            result := trBreak;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120, ObjZv[Xst].Liter,1);
            InsWar(BasOb,120);//----------- Стрелка $ на макете
          end;
        end;
      end else //------------------------------------------------------------- если нет МК
      begin
        if not MarhTrac.Povtor and not MarhTrac.Dobor
        then inc(MarhTrac.GonkaList);//------увеличить число переводимых стрелок

        if ObjZv[Xst].bP[19] then
        begin //----------------------------------------- стрелка на макете - враждебность
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,137, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,137);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[21] then //------------------------------------- замыкание СП
        begin
          o := GetStateSP(1,Str.Obj);
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,82, ObjZv[o].Liter,1);
          InsMsg(o,82);
          MarhTrac.GonkaStrel := false;
        end;

        if ObjZv[Xst].ObCB[3] and//если надо проверять МСП и
        not ObjZv[Xst].bP[20] then //..... идет выдержка МСП
        begin
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,392, Liter,1);
          InsMsg(Str.Obj,392); //- Идет выдержка времени дополнит. замыкания стрелки
          MarhTrac.GonkaStrel := false;
        end;

        if ObjZv[Xst].bP[4] or  bP[4] then
        begin  //---------------------------------------------------------- доп. замыкание
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[22] then //--------- занятость СП
        begin
          o := GetStateSP(2,Str.Obj);
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,83, ObjZv[o].Liter,1);
          InsMsg(o,83);
          MarhTrac.GonkaStrel := false;
        end;

        if bP[18] then //------------- стрелка выключена из управления
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,159, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,159);
          MarhTrac.GonkaStrel := false;
        end;

        if MarhTrac.Povtor then //-------- проверка повторной установки маршрута
        begin
          if not bP[1] then
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,81, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,81);
            MarhTrac.GonkaStrel := false;
          end;
        end else
        begin //---------------------------------- проверка первичной трассировки маршрута
          if not bP[1] and //---------------------------- нет ПК и ...
          not ObjZv[Xst].bP[7] then //----------------- нет МУ
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,81, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,81); //-------- Стрелка $ без контроля
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;

      if (not MarhTrac.Povtor and //------------------- не повтор маршрута и ...
      bP[13]) or //------------ пошерстная в маршруте в минусе или ...

      (MarhTrac.Povtor and //----------------------------- повтор маршрута и ...
      not ObjZv[Xst].bP[6] and //------- нет ПУ в хвосте и ...
      ObjZv[Xst].bP[7]) then  //------------- есть МУ в хвосте
      begin
        if ObjZv[Xst].bP[6] then //---------- если в хвосте ПУ
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);
          MarhTrac.GonkaStrel := false;
        end else  //------------------------------------------------- если в хвосте нет ПУ
        if not bP[1] and  //----------------------------- нет ПК и ...
        not bP[2] and  //-------------------------------- нет МК и ...
        not ObjZv[Xst].bP[6] then //---------- нет ПУ в хвосте
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,81, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,81); //------------ стрелка без контроля
          MarhTrac.GonkaStrel := false;
        end;

        con := Sosed[1]; //------------ выходим из стрелки через тчк 1

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
      end
      else result := trStop;
    end;
  end;
end;

end;

//========================================================================================
//--------------------------------пройти через стрелку во время замыкания элементов трассы
function StepStrZamTras(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos) :TTrRes;
var
  p,mk : boolean;
begin
  result := trNext;
  case Con.Pin of
    1 :
    begin
      p := false; mk := false;
      if ObjZv[ObjZv[Str.Obj].UpdOb].bP[2] and
      not ObjZv[ObjZv[Str.Obj].UpdOb].bP[9] then
      begin //--------------------------------------------------------- нет замыкания и РМ
        if ObjZv[Str.Obj].bP[10] then
        begin
          if ObjZv[Str.Obj].bP[11] then
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
        if ObjZv[Str.Obj].bP[1] and not ObjZv[Str.Obj].bP[2] then
        begin //--------------------------------------------------- есть контроль по плюсу
          p := true;
          mk := false;
        end else
        if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then
        begin //-------------------------------------------------- есть контроль по минусу
          mk := true;
          p := false;
        end;
      end;

      if p and //--------------------------------------------------------- если плюс и ...
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[7] then //--------------------- нет МУ
      begin
        con := ObjZv[Str.Obj].Sosed[2]; //------------------ выходим из стрелки прямо

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;

        if result = trNext then
        begin
          if not ObjZv[Str.Obj].ObCB[1] then //--------------------- не сбрасывающая
          begin
            inc(MarhTrac.StrCount);
            MarhTrac.StrOtkl[MarhTrac.StrCount] := Str.Obj;
            MarhTrac.PolTras[MarhTrac.StrCount,1] := true;
            MarhTrac.PolTras[MarhTrac.StrCount,2] := false;
          end;
          ObjZv[Str.Obj].bP[6] := true;   //-------------------------------------- ПУ
          ObjZv[Str.Obj].bP[7] := false;  //-------------------------------------- МУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := true;   //------------------- ПУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false;  //------------------- МУ
          ObjZv[Str.Obj].bP[10] := false; //---------------- не 1-ый проход по трассе
          ObjZv[Str.Obj].bP[11] := false; //---------------- не 2-ой проход по трассе
          ObjZv[Str.Obj].bP[12] := false; //--------- пошерстая не в плюсе по  трассе
          ObjZv[Str.Obj].bP[13] := false; //-------- пошерстная не в минусе по трассе
          ObjZv[Str.Obj].bP[14] := true;  //------------------------- прог. замыкание

          ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true;//-------- прог. замыкание
          ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart;//-------- помни индекс
        end;
        exit;
      end else
      if mk and not ObjZv[ObjZv[Str.Obj].BasOb].bP[6] then
      begin
        con := ObjZv[Str.Obj].Sosed[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;

        if result = trNext then
        begin
          if not ObjZv[Str.Obj].ObCB[1] then
          begin
            inc(MarhTrac.StrCount);
            MarhTrac.StrOtkl[MarhTrac.StrCount] := Str.Obj;
            MarhTrac.PolTras[MarhTrac.StrCount,1] := false;
            MarhTrac.PolTras[MarhTrac.StrCount,2] := true;
          end;
          ObjZv[Str.Obj].bP[6] := false;  //-------------------------------------- ПУ
          ObjZv[Str.Obj].bP[7] := true;   //-------------------------------------- МУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //-------------------- ПУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := true;  //-------------------- МУ

          ObjZv[Str.Obj].bP[10] := false; //-------------- не первый проход по трассе
          ObjZv[Str.Obj].bP[11] := false; //-------------- не второй проход по трассе
          ObjZv[Str.Obj].bP[12] := false; //----------- сброс активности автовозврата
          ObjZv[Str.Obj].bP[13] := false; //--------------- сброс пошерстной в минусе
          ObjZv[Str.Obj].bP[14] := true;  //------------------ выдать прог. замыкание
          ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true;  //------ прог. замыкание
          ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart; //------помнить начало
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :   //------------------------------------------------------ вход через прямую ветку
    begin
      if ObjZv[ObjZv[Str.Obj].UpdOb].bP[2] and  //------- СП не замкнут и ...
      not ObjZv[ObjZv[Str.Obj].UpdOb].bP[9] then  //------------------ нет РМ
      begin
        if ObjZv[Str.Obj].bP[12] //-------------- нет пошерстной трассировки по плюсу
        then result := trNext; //----------------------------------------- идти дальше
      end
      else //------------------------------------------------------- есть замыкание или РМ
      if ObjZv[Str.Obj].bP[1] and //----------------------------------- есть ПК и ...
      not ObjZv[Str.Obj].bP[2] //--------------------------------------------- нет МК
      then result := trNext;  //------------------------------------------ идти дальше

      if result = trNext then //------------------------------------- если идти дальше
      begin
        con := ObjZv[Str.Obj].Sosed[1]; //---------------- выход через вход (точка 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZv[Str.Obj].bP[6] := true;   //------------------------------ нужен ПУ
            ObjZv[Str.Obj].bP[7] := false;  //--------------------------- не нужен МУ
            ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := true;  //------------------ ПУ
            ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //------------------ МУ
            ObjZv[Str.Obj].bP[10] := false; //------------ не первый проход по трассе
            ObjZv[Str.Obj].bP[11] := false; //------------ не второй проход по трассе
            ObjZv[Str.Obj].bP[12] := false; //------- нет пошерстной в плюсе в трассе
            ObjZv[Str.Obj].bP[13] := false; //------ нет пошерстной в минусе в трассе
            ObjZv[Str.Obj].bP[14] := true;  //----------------------- прог. замыкание
            ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true; //----- прог. замыкание
            ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart; //--- помнить начало
        end;
      end;
    end;

    3 : //----------------------------------------------------- вход со стороны отклонения
    begin
      if ObjZv[ObjZv[Str.Obj].UpdOb].bP[2] and //------нет замыкания СП и ...
      not ObjZv[ObjZv[Str.Obj].UpdOb].bP[9] then //------------------- нет РМ
      begin
        if ObjZv[Str.Obj].bP[13] then  //------------------ пошерстная нужна в минусе
        result := trNext; //---------------------------------------------- идти дальше
      end
      else //------------------------------------------------------- есть замыкание или РМ
      if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then//нет ПК, есть МК
      result := trNext;  //--------------------------- стрелка по минусу - идти дальше

      if result = trNext then
      begin
        con := ObjZv[Str.Obj].Sosed[1]; //---------------- выход через вход (точка 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZv[Str.Obj].bP[6] := false; //---------------------------- не нужен ПУ
            ObjZv[Str.Obj].bP[7] := true;  //------------------------------- МУ нужен
            ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //------------------ ПУ
            ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := true;  //------------------ МУ
            ObjZv[Str.Obj].bP[10] := false; //------------ не первый проход по трассе
            ObjZv[Str.Obj].bP[11] := false; //------------ не второй проход по трассе
            ObjZv[Str.Obj].bP[12] := false; //------- нет пошерстной в плюсе в трассе
            ObjZv[Str.Obj].bP[13] := false; //------ нет пошерстной в минусе в трассе
            ObjZv[Str.Obj].bP[14] := true;  //----------------------- прог. замыкание
            ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true;//------ прог. замыкание
            ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart;
        end;
      end;
    end;
  end;
end;

//========================================================================================
function StepStrCirc(var Con:TSos;  const Lvl:TTrLev;Rod:Byte;Str:TSos) : TTrRes;
//------------------------------------- шаг через стрелку при проверке "сигнальной струны"
var
  k : integer;
  zak : boolean;
begin
  result := trNext;
  //------------------ Проверить замыкание маршрута отправления со стрелкой в пути
  if not SignCircOtpravlVP(Str.Obj) then result := trStop;
  //----------------------------------- Проверить ограждение пути через Вз стрелки

  if not SignCircOgrad(Str.Obj) then result := trStop; //--- Ограждение пути

  if ObjZv[Str.Obj].ObCB[6]
  then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[16]
  else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[17];

  if ObjZv[Str.Obj].bP[16] or zak then
  begin //------------------------------------------- стрелка закрыта для движения
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1); InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin //------------------------------------------------- нет контроля положения
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; //---------------------------------------- негабаритность

  case Con.Pin of
    1 :
    begin
      //------- проверить трассировку по мунусу стрелки в пути в поездном маршруте
      if MarhTrac.VP > 0 then
      begin //----------------------------------------- есть список стрелок в пути
        for k := 1 to 4 do
        if (ObjZv[MarhTrac.VP].ObCI[k] = Str.Obj) and // индекс стрелки в пути
        ObjZv[MarhTrac.VP].ObCB[k+1] then          // признак добора трассы по плюсу
        begin // проверить трассировку стрелки по минусу
          if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,482, ObjZv[Str.Obj].Liter,1);
            InsMsg(ObjZv[Str.Obj].BasOb,482);
          end;
        end;
      end;

      if not ObjZv[Str.Obj].ObCB[11] then
      begin //-------------------- стрелка не сбрасывающая или остряки не развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin //---------------------- стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin //-------------------------- стрелка на макете - выдать предупреждение
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsWar(ObjZv[Str.Obj].BasOb,120);
      end;

      //---------------------------------------------- отклоняющая стрелка в плюсе
      if ObjZv[Str.Obj].bP[1] then con := ObjZv[Str.Obj].Sosed[2]
      else //------------------------------------------ отклоняющая стрелка в минусе
      if ObjZv[Str.Obj].bP[2] then con := ObjZv[Str.Obj].Sosed[3]
      else result := trStop; //------------------------------ нет контроля положения

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,241, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin //------------------------------------------ отклоняющая стрелка в плюсе
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin //-------------------------- стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin //----------------------------------------- отклоняющая стрелка в минусе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);//---- Стрелка $ не по маршруту
      end
      else result := trStop; //------------------------------ нет контроля положения
      Con := ObjZv[Str.Obj].Sosed[1];

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,242, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,242); //Нет маршрутов по + стрелки $
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].ObCB[11] then
      begin //------------------------------ стрелка сбрасывающая и остряки развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin //------------------------ стрелка закрыта для противошерстного движения
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453); //Стрелка $ закрыта для противошерстного движения
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin //-------------------------------------------- отклоняющая стрелка в плюсе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160); //----- Стрелка $ не по маршруту
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin //------------------------------------------- отклоняющая стрелка в минусе
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin //---------------------------- стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else result := trStop; //-------------------------------- нет контроля положения

      Con := ObjZv[Str.Obj].Sosed[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,243, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;

//========================================================================================
//---------------------------------- проход через стрелку при проверке для отмены маршрута
function StepStrOtmen(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  o : integer;
begin
  result := trNext;
  case Con.Pin of
    1 :
    begin
      if ObjZv[ObjZv[Str.Obj].UpdOb].bP[2] and
      not ObjZv[ObjZv[Str.Obj].UpdOb].bP[9] then
      begin //--------------------------------------------------------- нет замыкания и РМ
        if ObjZv[Str.Obj].bP[6] then
        begin
          con := ObjZv[Str.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNext;
          end;
          if result = trNext then
          begin
            ObjZv[Str.Obj].bP[6] := false; //------------------------------------------ ПУ
            ObjZv[Str.Obj].bP[7] := false; //------------------------------------------ МУ
            o := 0;

            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0)
            and (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj) then
            o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj) then
            o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- пороверить наличие гонки для спаренной стрелки
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ МУ
            end else
            begin //---------------------------------- сбросить гонку стрелок в объекте ХС
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- МУ
            end;

            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[11] := false;
            ObjZv[Str.Obj].bP[12] := false;
            ObjZv[Str.Obj].bP[13] := false;
            ObjZv[Str.Obj].bP[14] := false; //---------------------- программное замыкание
            SetPrgZamykFromXStrelka(Str.Obj);
            ObjZv[Str.Obj].iP[1]  := 0;
          end;
          exit;
        end else
        if ObjZv[Str.Obj].bP[7] then
        begin
          con := ObjZv[Str.Obj].Sosed[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNext;
          end;

          if result = trNext then
          begin
            ObjZv[Str.Obj].bP[6] := false; //------------------------------------------ ПУ
            ObjZv[Str.Obj].bP[7] := false; //------------------------------------------ МУ
            o := 0;

            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
            then o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- пороверить наличие гонки для спаренной стрелки
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ МУ
            end else
            begin //---------------------------------- сбросить гонку стрелок в объекте ХС
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- МУ
            end;
            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[11] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[12] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[13] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[14] := false; //---------------------------- прог. замыкание
            SetPrgZamykFromXStrelka(Str.Obj);
            ObjZv[Str.Obj].iP[1]  := 0;
          end;
          exit;
        end
        else result := trStop;
      end else
      begin //------------- Есть замыкание или РМ - пройти по имеющемуся положению стрелки
        if ObjZv[Str.Obj].bP[1] and not ObjZv[Str.Obj].bP[2] then
        begin //-------------------------------------------------  пройти по плюсу стрелки
          con := ObjZv[Str.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNext;
          end;

          if result = trNext then
          begin
            ObjZv[Str.Obj].bP[6] := false; // ПУ
            ObjZv[Str.Obj].bP[7] := false; // МУ
            o := 0;
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- пороверить наличие гонки для спаренной стрелки
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ МУ
            end else
            begin //---------------------------------- сбросить гонку стрелок в объекте ХС
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- МУ
            end;
            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[11] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[12] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[13] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[14] := false; //---------------------------- прог. замыкание
            SetPrgZamykFromXStrelka(Str.Obj);
            ObjZv[Str.Obj].iP[1]  := 0;
          end;
          exit;
        end else
        if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then
        begin //------------------------------------------------- пройти по минусу стрелки
          con := ObjZv[Str.Obj].Sosed[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNext;
          end;

          if result = trNext then
          begin
            ObjZv[Str.Obj].bP[6] := false; //------------------------------------------ ПУ
            ObjZv[Str.Obj].bP[7] := false; //------------------------------------------ МУ
            o := 0;

            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- пороверить наличие гонки для спаренной стрелки
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ МУ
            end else
            begin //---------------------------------- сбросить гонку стрелок в объекте ХС
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ПУ
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- МУ
            end;
            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[11] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[12] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[13] := false; //------------------------------------- трасса
            ObjZv[Str.Obj].bP[14] := false; //---------------------------- прог. замыкание
            SetPrgZamykFromXStrelka(Str.Obj);
            ObjZv[Str.Obj].iP[1]  := 0;
          end;
          exit;
        end
        else result := trStop; //-- стрелка не имеет контроля положения - дальше не ходить
      end;
    end;

    2 :
    begin
      con := ObjZv[Str.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else result := trNext;
      end;

      if result = trNext then
      begin
        ObjZv[Str.Obj].bP[6] := false; //---------------------------------------------- ПУ
        ObjZv[Str.Obj].bP[7] := false; //---------------------------------------------- МУ
        o := 0;

        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
        then o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
        else
        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
        then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

        if (o > 0) then
        begin //--------------------------- пороверить наличие гонки для спаренной стрелки
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; // ПУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; // МУ
        end else
        begin //-------------------------------------- сбросить гонку стрелок в объекте ХС
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //------------------------------- ПУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //------------------------------- МУ
        end;

        ObjZv[Str.Obj].bP[10] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[11] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[12] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[13] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[14] := false; //-------------------------------- прог. замыкание
        SetPrgZamykFromXStrelka(Str.Obj);
        ObjZv[Str.Obj].iP[1]  := 0;
      end;
    end;

    3 :
    begin
      con := ObjZv[Str.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
        else result := trNext;
      end;

      if result = trNext then
      begin
        ObjZv[Str.Obj].bP[6] := false; //---------------------------------------------- ПУ
        ObjZv[Str.Obj].bP[7] := false; //---------------------------------------------- МУ
        o := 0;
        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
        then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
        else
        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
        then o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

        if (o > 0) then
        begin //--------------------------- пороверить наличие гонки для спаренной стрелки
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //---------------------- ПУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //---------------------- МУ
        end else
        begin //-------------------------------------- сбросить гонку стрелок в объекте ХС
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //------------------------------- ПУ
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //------------------------------- МУ
        end;

        ObjZv[Str.Obj].bP[10] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[11] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[12] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[13] := false; //----------------------------------------- трасса
        ObjZv[Str.Obj].bP[14] := false; //-------------------------------- прог. замыкание
        SetPrgZamykFromXStrelka(Str.Obj);
        ObjZv[Str.Obj].iP[1]  := 0;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------- проход через стрелку при раздельном открытии сигнала
function StepStrRazdel(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  zak : boolean;
  k : integer;
begin
  result := trNext;
  // Проверить замыкание маршрута отправления со стрелкой в пути
  if not SignCircOtpravlVP(Str.Obj) then result := trStop;

  // Проверить ограждение пути через Вз стрелки
  if not SignCircOgrad(Str.Obj) then result := trStop; // Ограждение пути

  if ObjZv[Str.Obj].ObCB[6] then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[16]
  else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[17];

  if ObjZv[Str.Obj].bP[16] or zak then
  begin // стрелка закрыта для движения
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1);
    InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // нет контроля положения
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; // негабаритность

  case Con.Pin of
    1 :
    begin
      // проверить трассировку по мунусу стрелки в пути в поездном маршруте
      if MarhTrac.VP > 0 then
      begin // есть список стрелок в пути
        for k := 1 to 4 do
        if (ObjZv[MarhTrac.VP].ObCI[k] = Str.Obj) and // индекс стрелки в пути
        ObjZv[MarhTrac.VP].ObCB[k+1] then          // признак добора трассы по плюсу
        begin // проверить трассировку стрелки по минусу
          if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,482, ObjZv[Str.Obj].Liter,1);
            InsMsg(ObjZv[Str.Obj].BasOb,482);
          end;
        end;
      end;

      if not ObjZv[Str.Obj].ObCB[11] then
      begin // стрелка не сбрасывающая или остряки не развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin // стрелка на макете - выдать предупреждение
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsWar(ObjZv[Str.Obj].BasOb,120);
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // отклоняющая стрелка в плюсе
        ObjZv[Str.Obj].bP[10] := true;
        ObjZv[Str.Obj].bP[11] := false;// +
        con := ObjZv[Str.Obj].Sosed[2];
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // отклоняющая стрелка в минусе
        ObjZv[Str.Obj].bP[10] := true;
        ObjZv[Str.Obj].bP[11] := true; // -
        con := ObjZv[Str.Obj].Sosed[3];
      end
      else  result := trStop; // нет контроля положения

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,241, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin // стрелка в плюсе
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // стрелка в минусе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end
      else  result := trStop; // нет контроля положения

      Con := ObjZv[Str.Obj].Sosed[1];
      if result <> trStop then ObjZv[Str.Obj].bP[12] := true; // +

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,242, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].ObCB[11] then
      begin // стрелка сбрасывающая и остряки развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // стрелка в плюсе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // стрелка в минусе
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else result := trStop;// нет контроля положения

      Con := ObjZv[Str.Obj].Sosed[1];
      if result <> trStop then ObjZv[Str.Obj].bP[13] := true; // -
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,243, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;

//========================================================================================
//------------------------------ проход через стрелку при открытии сигнала на автодействие
function StepStrAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
var
  zak : boolean;
begin
  result := trNext;
  //-------------------------- Проверить замыкание маршрута отправления со стрелкой в пути
  if not SignCircOtpravlVP(Str.Obj) then result := trStop;

  // Проверить ограждение пути через Вз стрелки
  if not SignCircOgrad(Str.Obj) then result := trStop; // Ограждение пути

  if ObjZv[Str.Obj].ObCB[6]
  then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[16]
  else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[17];

  if ObjZv[Str.Obj].bP[16] or zak then
  begin //--------------------------------------------------- стрелка закрыта для движения
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1);
    InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin //--------------------------------------------------------- нет контроля положения
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; //------------------------------------------------ негабаритность

  case Con.Pin of
    1 :
    begin
      if not ObjZv[Str.Obj].ObCB[11] then
      begin //-------------------------- стрелка не сбрасывающая или остряки не развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin //---------------------------- стрелка закрыта для противошерстного движения
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin //---------------------------------- стрелка на макете - выдать предупреждение
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,120);
      end;

      if ObjZv[Str.Obj].bP[1]
      then con := ObjZv[Str.Obj].Sosed[2]  //------------ отклоняющая стрелка в плюсе
      else
      if ObjZv[Str.Obj].bP[2]
      then  con := ObjZv[Str.Obj].Sosed[3]//------------ отклоняющая стрелка в минусе
      else result := trStop; //------------------------------------ нет контроля положения

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,241, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin // отклоняющая стрелка в плюсе
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // отклоняющая стрелка в минусе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end
      else result := trStop; // нет контроля положения

      Con := ObjZv[Str.Obj].Sosed[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,242, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].ObCB[11] then
      begin // стрелка сбрасывающая и остряки развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // отклоняющая стрелка в плюсе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // отклоняющая стрелка в минусе
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else  result := trStop;// нет контроля положения

      Con := ObjZv[Str.Obj].Sosed[1];
      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,243, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;

//========================================================================================
//---------- проход через стрелку при проверке для повторного открытия в раздельном режиме
function StepStrPovtRazd(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  k : integer;
  zak : boolean;
begin
  result := trNext;
  if ObjZv[Str.Obj].ObCB[6]
  then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[16]
  else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[17];

  if ObjZv[Str.Obj].bP[16] or zak then
  begin // стрелка закрыта для движения
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1);
    InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // нет контроля положения
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; // негабаритность

  case Con.Pin of
    1 :
    begin
      // проверить трассировку по мунусу стрелки в пути в поездном маршруте
      if MarhTrac.VP > 0 then
      begin // есть список стрелок в пути
        for k := 1 to 4 do
        if (ObjZv[MarhTrac.VP].ObCI[k] = Str.Obj) and // индекс стрелки в пути
        ObjZv[MarhTrac.VP].ObCB[k+1] then          // признак добора трассы по плюсу
        begin // проверить трассировку стрелки по минусу
          if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,482, ObjZv[Str.Obj].Liter,1);
            InsMsg(Str.Obj,482);
          end;
        end;
      end;

      if not ObjZv[Str.Obj].ObCB[11] then
      begin // стрелка не сбрасывающая или остряки не развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin // стрелка на макете - выдать предупреждение
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,120);
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // отклоняющая стрелка в плюсе
        if not ObjZv[Str.Obj].bP[6] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,160);
        end else
        begin
          ObjZv[Str.Obj].bP[10] := true;
          ObjZv[Str.Obj].bP[11] := false;// +
          con := ObjZv[Str.Obj].Sosed[2];
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // отклоняющая стрелка в минусе
        if not ObjZv[Str.Obj].bP[7] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,160);
        end else
        begin
          ObjZv[Str.Obj].bP[10] := true;
          ObjZv[Str.Obj].bP[11] := true; // -
                  con := ObjZv[Str.Obj].Sosed[3];
        end;
      end
      else result := trStop;// нет контроля положения

      // Проверить ограждение пути через Вз стрелки
      if not SignCircOgrad(Str.Obj) then result := trStop; // Ограждение пути

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,241, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,241);
          result := trStop;
        end;
      end;
    end;

    2 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin // отклоняющая стрелка в плюсе
        if not ObjZv[Str.Obj].bP[6] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,160);
        end;

        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // отклоняющая стрелка в минусе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end
      else  result := trStop; // нет контроля положения

      Con := ObjZv[Str.Obj].Sosed[1];
      // Проверить ограждение пути через Вз стрелки
      if not SignCircOgrad(Str.Obj)
      then result := trStop; // Ограждение пути

      if result <> trStop then  ObjZv[Str.Obj].bP[12] := true; // +

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,242, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,242);
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].ObCB[11] then
      begin // стрелка сбрасывающая и остряки развернуты
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];
        if ObjZv[Str.Obj].bP[17] or zak then
        begin // стрелка закрыта для противошерстного движения
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // отклоняющая стрелка в плюсе
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // отклоняющая стрелка в минусе
        if not ObjZv[Str.Obj].bP[7] then
        begin // стрелка не по маршруту
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,160);
        end;

        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // стрелка на макете - выдать предупреждение
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else  result := trStop; // нет контроля положения

      Con := ObjZv[Str.Obj].Sosed[1];
      // Проверить ограждение пути через Вз стрелки
      if not SignCircOgrad(Str.Obj) then result := trStop; // Ограждение пути

      if result <> trStop then ObjZv[Str.Obj].bP[13] := true; // -

      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,243, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,243);
          result := trStop;
        end;
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------- проход через стрелку при сборке известителя
function StepStrFindIzv(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
begin
  result := trNext;
  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // Если стрелка не имеет контроля положения - прервать сборку известителя
    result := trStop;
    exit;
  end;
  case Con.Pin of
    1 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin // по плюсу
        con := ObjZv[Str.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
        exit;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // по минусу
        con := ObjZv[Str.Obj].Sosed[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
        exit;
      end
      else  result := trStop;
    end;

    2 :
    begin
      if ObjZv[Str.Obj].bP[1]  then
      begin // по плюсу
        con := ObjZv[Str.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end
      else  result := trStop;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].bP[2] then
      begin // по минусу
        con := ObjZv[Str.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end
      else result := trStop;
    end;
  end;
end;

//========================================================================================
//------------------- проход через стрелку при проверке незамкнутых предмаршрутных стрелок
function StepStrFindStr(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  zak : boolean;
  o,j,k : integer;
begin
  result := trNext;
  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // Если стрелка не имеет контроля положения - прервать сборку известителя
    result := trStop;
    exit;
  end;

  o := ObjZv[Str.Obj].BasOb;
  zak := false;

  if Rod = MarshP then
  begin // проверить замыкание стрелки (в пути) в маршруте отправления с пути
    for j := 14 to 19 do
    begin
      if ObjZv[ObjZv[o].ObCI[j]].TypeObj = 41 then
      begin // контроль маршрута отправления с пути со стрелкой в пути
        if ObjZv[ObjZv[o].ObCI[j]].BasOb = MarhTrac.ObjStart then
        begin // стрелка замыкается в поездном маршруте как охранная
          zak := true;
          break;
        end;
      end;
    end;
  end;

  if not zak then
  begin // проверить исключение перевода стрелки
    k := ObjZv[Str.Obj].UpdOb;
    if not (ObjZv[ObjZv[o].ObCI[12]].bP[1] or // РзС
    ObjZv[Str.Obj].bP[5] or     // признак перевода охранной
    not ObjZv[k].bP[2] or       // замыкание из СП
    ObjZv[o].bP[18] or          // выключена из управления FR4
    ObjZv[Str.Obj].bP[18]) then // выключена из управления РМ-ДСП
    MarhTrac.IzvStrNZ := true;
  end;

  case Con.Pin of
    1 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin // по плюсу
        con := ObjZv[Str.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
        exit;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // по минусу
        con := ObjZv[Str.Obj].Sosed[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZv[Str.Obj].bP[1]  then
      begin // по плюсу
        con := ObjZv[Str.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].bP[2] then
      begin // по минусу
        con := ObjZv[Str.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
      end
      else result := trStop;
    end;
  end;
end;

//========================================================================================
//------------------------------------ проход через стрелку при повторном задании маршрута
function StepStrPovtMarh(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
begin
  result := trNext;
  if not ObjZv[Str.Obj].bP[14] then
  begin //------------------------------------------------------ разрушена трасса маршрута
    if (MarhTrac.MsgN > 10) or (MarhTrac.MsgN = 0) then
    MarhTrac.MsgN := 1;
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,228, ObjZv[MarhTrac.ObjStart].Liter,1);
    result := trStop;
    InsMsg(MarhTrac.ObjStart,228);
  end else
  case Con.Pin of
    1 :
    begin
      if ObjZv[Str.Obj].bP[6] and
      not ObjZv[Str.Obj].bP[7] then
      begin
        inc(MarhTrac.StrCount);
        MarhTrac.StrOtkl[MarhTrac.StrCount]   := Str.Obj;
        MarhTrac.PolTras[MarhTrac.StrCount,1] := true;
        MarhTrac.PolTras[MarhTrac.StrCount,2] := false;
        con := ObjZv[Str.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
      end else
      if not ObjZv[Str.Obj].bP[6] and ObjZv[Str.Obj].bP[7] then
      begin
        inc(MarhTrac.StrCount);
        MarhTrac.StrOtkl[MarhTrac.StrCount]   := Str.Obj;
        MarhTrac.PolTras[MarhTrac.StrCount,1] := false;
        MarhTrac.PolTras[MarhTrac.StrCount,2] := true;
        con := ObjZv[Str.Obj].Sosed[3];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end
      else result := trStop;
    end;

    2 :
    begin
      if ObjZv[Str.Obj].bP[6]  then
      begin
        con := ObjZv[Str.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end
      else result := trStop;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].bP[7] then
      begin
        con := ObjZv[Str.Obj].Sosed[1];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
      end
      else result := trStop;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------- шаг через сигнал при поиске трассы
function StepSigFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
begin
  if ObjZv[Con.Obj].RU = ObjZv[MarhTrac.ObjStart].RU then //--- если свой район управления
  begin
    if ObjZv[Sig.Obj].ObCB[1] then result := trRepeat else //безусловный конец трассировки

    if Con.Pin = 1 then Con := ObjZv[Sig.Obj].Sosed[2] //вошли с точки 1, выход от точки 2
    else Con := ObjZv[Sig.Obj].Sosed[1]; //-------------- вошли с точки 2, выход в точке 1

    if(Con.TypeJmp>=LnkRgn) or (Con.TypeJmp=LnkEnd) then result := trRepeat
    else result := trNext;
  end
  else result := trRepeat; //------------------------------------------------- чужой район
end;

//========================================================================================
function StepSigContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//---------------------------------------------------- продление трассы за указанный конец
var
  i,j,k : integer;
begin
  if ObjZv[Con.Obj].RU = ObjZv[MarhTrac.ObjStart].RU then
  begin //------------------------------ Продолжить трассировку если свой район управления
    //----------------------------------- если нельзя дальше, смена направления Ч/Н, тупик
    if ObjZv[Sig.Obj].ObCB[1] then  result := trKonec
    else
    if Con.Pin = 1 then
    begin //-------------------------------------------------------------- Попутный сигнал
      if (((Rod = MarshM) and ObjZv[Sig.Obj].ObCB[7]) or//--- маневр и конец т.1 или
      ((Rod = MarshP) and ObjZv[Sig.Obj].ObCB[5])) and //--------- поезд и конец т.1
                                                                 //----------------- И ...
      (ObjZv[Sig.Obj].bP[12] or ObjZv[Sig.Obj].bP[13] or //--- блок STAN или DSP
      ObjZv[Sig.Obj].bP[18] or //----------------------------------------  или РМ(МИ)
                                        //---------------------------------------  или ...
      (ObjZv[Sig.Obj].ObCB[2] and //----------------- возможно начало поездных и ...
      (ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4] or //----- С1 или С2 или ...
      ObjZv[Sig.Obj].bP[8] or ObjZv[Sig.Obj].bP[9])) or //---- Н от STAN или ППР
                                            //------------------------------------ или ...
      (ObjZv[Sig.Obj].ObCB[3] and  //-------------- возможно начало маневровых и ...
      (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or //--- МС1 или МС2 или ...
      ObjZv[Sig.Obj].bP[6] or ObjZv[Sig.Obj].bP[7]))) then //--- НМ STAN или МПР
      result := trKonec //------ Завершить трассировку если попутный впереди уже открыт
      else
      case Rod of
        MarshP : //----------------------------------------------------- ПОЕЗДНЫЕ ПОПУТНЫЕ
        begin
          if ObjZv[Sig.Obj].ObCB[16] and //------------ нет сквозных маршрутов и ...
          ObjZv[Sig.Obj].ObCB[2] then //------------------- возможно начало поездных
          result := trKonec //-------------------------------- обнаружен конец маршрута
          else
          if ObjZv[Sig.Obj].ObCB[5] then
          begin //----------- есть конец поездного маршрута в точке 1 светофора ( у входа)
            MarhTrac.FullTail := true; //-------- полнота добора хвоста маршрута
            MarhTrac.FindNext := true; //------ проверка возможности продолжения
            if ObjZv[Sig.Obj].ObCB[2] //------------------- возможно начало поездных
            then
            begin
              result := trEnd;     //------------------------- Конец трассировки фрагмента
              MarhTrac.ObjEnd := Sig.Obj; // перенос конца поездного на попутный
            end
            else result := trKonec; //------------------------ обнаружен конец маршрута
          end
          else result := trNext; //----- нет конца поездного маршрута у светофора,идти
        end;

        MarshM : //--------------------------------------------------- МАНЕВРОВЫЕ ПОПУТНЫЕ
        begin
          if ObjZv[Sig.Obj].ObCB[7] then //----- есть конец маневровых в т.1 сигнала
          begin
            MarhTrac.FullTail := true; //------------------------ полнота добора
            MarhTrac.FindNext := true; //----- проверить возможность продолжения
            if ObjZv[Sig.Obj].ObCB[3] //----------------- возможно начало маневровых
            then
            begin
              result := trEnd;  //---------------------------- Конец трассировки фрагмента
              MarhTrac.ObjEnd := Sig.Obj;
            end
            else result := trKonec;
          end
          else result := trNext; //---- нет конца маневровых в т.1 - шагать дальше
        end;

        else result := trEnd; //------ ошибочный тип маршрута - закончить поиск трассы
      end;

      if result = trNext then //-------------------------- если надо шагать дальше
      begin
        Con := ObjZv[Sig.Obj].Sosed[2]; //- рассмотрим коннектор за сигналом (т2)
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
          if ObjZv[Sig.Obj].ObCB[5] //---- Поездной конец есть в т.1 за сигналом
          then result := {trPlus} trNext //- есть конец маршрута, за сигналом надо проверить
          else //-------------------------------------- если поездного конца нет в т.1
          begin
            if ObjZv[Sig.Obj].Sosed[1].TypeJmp = 0 then //------------ соседа нет
            result := trStop //-------------------- Отказ если нет поездного из тупика
            else result := trNext; //-------------------------------- иначе шагать
          end;
        end;

        MarshM : //------------------------- ВСТРЕЧНЫЕ СИГНАЛЫ при маневрах---------------
        begin
          if ObjZv[Sig.Obj].ObCB[8] //если маневры окончены перед сигналом то конец
          then
          begin
            result := trKonec;
            if Sig.Pin = 1  then Sig := ObjZv[Sig.Obj].Sosed[2]
            else Sig := ObjZv[Sig.Obj].Sosed[1];
          end
          else
            if ObjZv[Sig.Obj].ObCB[7]//если конец маневров в т.1 (за встречным сигн.)
            then result := trNext //----------------------------  то продолжаем дальше
            else
            begin
              j :=  MarhTrac.Counter;
              for i := 0 to j do
              begin
                k := MarhTrac.ObjTRS[j-1];
                if (ObjZv[k].TypeObj = 3) or (ObjZv[k].TypeObj = 4) then
                begin
                  MarhTrac.ObjEnd := k;
                  break;
                end else
                begin
                  MarhTrac.ObjTRS[j] := 0;
                  dec(MarhTrac.Counter);
                end;
              end;
              result := trEnd; //------------------------------------------- иначе стоп
            end;

        end;

        else result := trEnd; //------------------ маршрут непонятный, не трассировать
      end;

      if result = trNext then //------------------------- если нужно шагать дальше
      begin
        Con := ObjZv[Sig.Obj].Sosed[1]; //----- рассматривается коннектор точки 1
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          LnkFull : result := trNext;
          LnkNecentr : result := trKonec;
        end;
      end;

      if result = trPlus then  result := trKonec; //--- новая вставка @@@@@@@@@@@@

    end;
  end
  else result := trKonec;//Завершить трассировку маршрута если другой район управления
end;

//========================================================================================
function StepSigZavTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//-------------------------------------------------------- проверка зависимостей по трассе
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trKonec;
      else result := trNext;
    end;
  end else
  begin
    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trKonec;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
function StepSigChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//---------------------------------------------- проверка враждебностей по трассе маршрута
begin
  result := trNext;
  if (ObjZv[Sig.Obj].bP[12] or  //--------------------- блокировка в STAN или ...
  ObjZv[Sig.Obj].bP[13]) and //--------------------------- блокировка в DSP и ...
  (Sig.Obj <> MarhTrac.ObjTRS[MarhTrac.Counter]) // не последний
  then
  begin //------------------------------------ заблокирован светофор в середине трассы
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,123, ObjZv[Sig.Obj].Liter,1);
    InsMsg(Sig.Obj,123); //----------------------------- Светофор $ заблокирован
    MarhTrac.GonkaStrel := false;
  end;

  if ObjZv[Sig.Obj].bP[18] and //------------------------------- если РМ (или МИ)
  (Sig.Obj <> MarhTrac.ObjTRS[MarhTrac.Counter]) then //- внутри
  begin //--------------------------- светофор на местном управлении в середине трассы
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,232, ObjZv[Sig.Obj].Liter,1);//------- Сигнал $ на местном управлении
    InsMsg(Sig.Obj,232);
    MarhTrac.GonkaStrel := false;
  end;

  if Con.Pin = 1 then //-------------------------------------- вошли в попутный сигнал
  begin //----------------------------------------------------- Враждебности попутного
    if ((not ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP)) or//нет П-конца в т1 или
    (not ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM))) and //нет М-конца в т1 и
    (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or  //---- МС1 или МС2 или
    ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4]) then //--------- С1 или С2
    begin
      result := trBreak;
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,114);  //----------------------- Открыт враждебный сигнал $
      MarhTrac.GonkaStrel := false;
    end;

    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTrac.FindTail //----------- если создано сообщение о конце трассы
    then MarhTrac.TailMsg := ' до '+ ObjZv[Sig.Obj].Liter;
  end else
  begin //------- если вошли во встречный сигнал, то просмотр враждебностей встречного
    if ObjZv[Sig.Obj].bP[1] or   //---------------------------------- МС1 или ...
    ObjZv[Sig.Obj].bP[2] or   //------------------------------------- МС2 или ...
    ObjZv[Sig.Obj].bP[3] or   //-------------------------------------- С1 или ...
    ObjZv[Sig.Obj].bP[4] then //---------------------------------------------- С2
    begin
      result := trBreak;
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,114);  //----------------------- Открыт враждебный сигнал $
      MarhTrac.GonkaStrel := false;
    end;

    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTrac.FindTail then //----------------------- если найден хвост трассы
    begin
      if (ObjZv[MarhTrac.ObjEnd].TypeObj = 5) and (Sig.Pin = 1)
      then //---------------------------------------------- если конец на попутном сигнале
       MarhTrac.TailMsg := ' до '+ ObjZv[Sig.Obj].Liter
      else
        if ObjZv[MarhTrac.ObjEnd].ObCB[3] and (Rod = MarshM) then
        MarhTrac.TailMsg := ' за '+ ObjZv[Sig.Obj].Liter
        else
        if ObjZv[MarhTrac.ObjEnd].ObCB[2] and (Rod = MarshP) then
        MarhTrac.TailMsg := ' за '+ ObjZv[Sig.Obj].Liter
        else
        begin
          result := trBreak;
        end;
//        MarhTrac.TailMsg := ' до '+ ObjZv[Sig.Obj].Liter;
    end;
  end;
end;

//========================================================================================
function StepSigZamTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//------------------- замыкание трассы маршрута, сбор положений отклоняющих стрелок трассы
begin
  if Con.Pin = 1 then  //--------------------------------------------- попутный сигнал
  begin
    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;

    if result = trNext then
    begin
      if MarhTrac.FindTail //------------------------------------ если найден конец трассы
      then MarhTrac.TailMsg := ' до '+ ObjZv[Sig.Obj].Liter;

      //-------------------------------------- разнести признаки начала в попутные сигналы
      if ObjZv[MarhTrac.ObjStart].bP[7] then //------------------ маневровый признак трасс
      begin
        if ObjZv[Sig.Obj].ObCB[3] then //-------------------------- есть маневровое начало
        begin
          MarhTrac.SvetBrdr := Sig.Obj;//------------- сменить индекс границы блок-участка
          ObjZv[Sig.Obj].bP[7] := true;  //-------------------------------------------- НМ
//        ObjZv[Sig.Obj].bP[14] := true; //------------------------------- прог. замыкание
          ObjZv[Sig.Obj].iP[1] := MarhTrac.ObjStart; //------------------- индекс маршрута
        end;
      end else

      if ObjZv[MarhTrac.ObjStart].bP[9] then //-------------------- поездной признак трасс
      begin
        if ObjZv[Sig.Obj].ObCB[2] then //---------------------------- есть поездное начало
        begin
          MarhTrac.SvetBrdr := Sig.Obj;//------------- сменить индекс границы блок-участка
          ObjZv[Sig.Obj].bP[8] := true;  //--------------------------------------------- Н
//        ObjZv[Sig.Obj].bP[14] := true; //-------------------- установить прог. замыкание
          ObjZv[Sig.Obj].iP[1] := MarhTrac.ObjStart; //------------------- индекс маршрута
        end;
      end;
    end;
  end else //------------------------------------- вошли во встречный сигнал (от точки Т2)
  begin
    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      LnkNecentr : result := trKonec;
      else  result := trNext;
    end;

    if MarhTrac.FindTail then
    begin
      if ObjZv[MarhTrac.ObjEnd].TypeObj = 5 then //----------------- если конец на сигнале
      MarhTrac.TailMsg := ' до '+ ObjZv[Sig.Obj].Liter
      else MarhTrac.TailMsg := ' за '+ ObjZv[Sig.Obj].Liter;
    end;

    // ObjZv[Sig.Obj].bP[14] := true;  //--------------------------------- прог. замыкание
    ObjZv[Sig.Obj].iP[1] := MarhTrac.ObjStart; //------------------------- индекс маршрута
  end;
end;

//========================================================================================
function StepSigCirc(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//------------------------ Сигнальная струна (повторное открытие сигнала, отмена маршрута)
begin
  result := trNext;
  if ObjZv[Sig.Obj].bP[12] or ObjZv[Sig.Obj].bP[13] then
  begin //------------------------------------------------------ заблокирован светофор
    if not((ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,123, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,123);   //------------------------- Светофор $ заблокирован
    end;
  end else
  if ObjZv[Sig.Obj].bP[18] then
  begin //--------------------------------------------- светофор на местном управлении
    if not((ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,232, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,232); //-------------------- Сигнал $ на местном управлении
    end;
  end
  else result := trNext;

  if Con.Pin = 1 then
  begin //----------------------------------------------------- Враждебности попутного
    case Rod of
      MarshP :
      begin
        if ObjZv[Sig.Obj].ObCB[5] then //------------------------------- если С2
        begin
          if ObjZv[Sig.Obj].bP[5] and //----------------------- огневое и нет ...
          not (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or// МС1 или МС2
          ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4]) then //или С1 или С2
          begin //--------------------- Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,115, ObjZv[Sig.Obj].Liter,1);
            InsWar(Sig.Obj,115); //- Маршрут не огражден! Неисправен запрещающий
          end;
          result := trKonec;
        end;

        if ObjZv[Sig.Obj].ObCB[19] then
        begin //--------------- Короткий предмаршрутный участок для поездного маршрута
          if not ObjZv[Sig.Obj].bP[4] then
          begin //------------------------------------------------------ закрыт сигнал
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,391, ObjZv[Sig.Obj].Liter,1);
            InsMsg(Sig.Obj,391); //----------------------------- Сигнал $ закрыт
          end;
        end;
      end;

      MarshM :
      begin
        if ObjZv[Sig.Obj].ObCB[7] then   //- возможен маневровый конец в точке 1
        begin
          if ObjZv[Sig.Obj].bP[5] and not //----------------------- огневое и нет
          (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or //МС1 или МС2 или
          ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4]) then //--- С1 или С2
          begin //--------------------- Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,115, ObjZv[Sig.Obj].Liter,1);
            InsWar(Sig.Obj,115); //- Маршрут не огражден! Неисправен запрещающий
          end;
          result := trKonec;
        end;

        if ObjZv[Sig.Obj].ObCB[20] then
        begin //------------- Короткий предмаршрутный участок для маневрового маршрута
          if not ObjZv[Sig.Obj].bP[2] then //---------------------------- нет МС2
          begin //------------------------------------------------------ закрыт сигнал
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,391, ObjZv[Sig.Obj].Liter,1);
            InsMsg(Sig.Obj,391);
          end;
        end;
      end;

      else result := trEnd;
    end;

    Con := ObjZv[Sig.Obj].Sosed[2]; //-------------- коннектор со стороны точки 2
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin //---------------------------------------- Враждебности встречного вошли в т.2
    if ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) //возможен конец поездных в т.2
    then result := trStop
    else
    if ObjZv[Sig.Obj].ObCB[8] and (Rod =MarshM)//возможен конец маневровых в т.2
    then result := trStop
    else
    if ObjZv[Sig.Obj].bP[1] or   //------------------------------------------ МС1
    ObjZv[Sig.Obj].bP[2] or   //--------------------------------------------- МС2
    ObjZv[Sig.Obj].bP[3] or   //---------------------------------------------- С1
    ObjZv[Sig.Obj].bP[4] then //---------------------------------------------- С2
    begin
      result := trStop;
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,114); //------------------------ Открыт враждебный сигнал $
    end;

    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;

//========================================================================================
//-------------------------------------- Отмена маршрута, замкнутого Реле "З" или сервером
function StepSigOtmena(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
begin
  result := trNext;
  if Con.Pin = 1 then
  begin //------------------------------------------------------------ попутный сигнал
    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn :
      begin
        ObjZv[Sig.Obj].bP[14] := false;
        result := trEnd;
      end;

      LnkEnd :
      begin
        ObjZv[Sig.Obj].bP[14] := false;
        result := trStop;
      end;
      else result := trNext;
    end;

    if result = trNext then
    begin     //----------------------- найти хвост данной категории маршрута
      if Rod = MarshM then
      begin // маневровый
        if ObjZv[Sig.Obj].ObCB[7] then result := trStop
        else ObjZv[Sig.Obj].bP[14] := false;
      end else
      if Rod = MarshP then
      begin // поездной
        if ObjZv[Sig.Obj].ObCB[5] then result := trStop
        else ObjZv[Sig.Obj].bP[14] := false;
      end;
    end;
  end else
  begin // встречный сигнал
    ObjZv[Sig.Obj].bP[14] := false;
    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;      // найти хвост данной категории маршрута
      else   // найти хвост данной категории маршрута
      if Rod = MarshM then
      begin // маневровый
        if ObjZv[Sig.Obj].ObCB[8]
        then result := trStop
        else result := trNext;
      end else
      if Rod = MarshP then
      begin // поездной
        if ObjZv[Sig.Obj].ObCB[6]
        then result := trStop
        else result := trNext;
      end;
    end;
  end;
end;

//========================================================================================
//------------------ проход при автодействии, раздельном открытии или повторе в раздельном
function StepSigAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos):TTrRes;
begin
  result := trNext;
  if ObjZv[Sig.Obj].bP[12] or ObjZv[Sig.Obj].bP[13] then
  begin // заблокирован светофор
    if not((ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,123, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,123);
    end;
  end else
  if ObjZv[Sig.Obj].bP[18] then
  begin // светофор на местном управлении
    if not((ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,232, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,232);
    end;
  end
  else result := trNext;

  if Con.Pin = 1 then
  begin // Враждебности попутного
    case Rod of
      MarshP :
      begin
        if ObjZv[Sig.Obj].ObCB[5] then
        begin
          if ObjZv[Sig.Obj].bP[5] and not
          (ObjZv[Sig.Obj].bP[1] or
          ObjZv[Sig.Obj].bP[2] or
          ObjZv[Sig.Obj].bP[3] or
          ObjZv[Sig.Obj].bP[4]) then // o
          begin // Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,115, ObjZv[Sig.Obj].Liter,1);
            InsWar(Sig.Obj,115);
          end;
          result := trKonec;
        end else
        begin
          if ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or ObjZv[Sig.Obj].bP[6] or ObjZv[Sig.Obj].bP[7] or ObjZv[Sig.Obj].bP[21] then
          begin // открыт враждебный сигнал
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1); InsMsg(Sig.Obj,114);
          end;
        end;

        if ObjZv[Sig.Obj].ObCB[19] then
        begin // Короткий предмаршрутный участок для поездного маршрута
          if not ObjZv[Sig.Obj].bP[4] then
          begin // закрыт сигнал
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,391, ObjZv[Sig.Obj].Liter,1);
            InsMsg(Sig.Obj,391);
          end;
        end;
      end;

      MarshM :
      begin
        if ObjZv[Sig.Obj].ObCB[7] then
        begin
          if ObjZv[Sig.Obj].bP[5] and
          not (ObjZv[Sig.Obj].bP[1] or
          ObjZv[Sig.Obj].bP[2] or
          ObjZv[Sig.Obj].bP[3] or
          ObjZv[Sig.Obj].bP[4]) then // o
          begin // Маршрут не прикрыт запрещающим огнем попутного
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,115, ObjZv[Sig.Obj].Liter,1);
            InsWar(Sig.Obj,115);
          end;
          result := trKonec;
        end else
        begin
          if ObjZv[Sig.Obj].bP[3] or
          ObjZv[Sig.Obj].bP[4] or
          ObjZv[Sig.Obj].bP[8] or
          ObjZv[Sig.Obj].bP[9] or
          ObjZv[Sig.Obj].bP[21] then
          begin // открыт враждебный сигнал
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
            InsMsg(Sig.Obj,114);
          end;
        end;

        if ObjZv[Sig.Obj].ObCB[20] then
        begin // Короткий предмаршрутный участок для маневрового маршрута
          if not ObjZv[Sig.Obj].bP[2] then
          begin // закрыт сигнал
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,391, ObjZv[Sig.Obj].Liter,1);
            InsMsg(Sig.Obj,391);
          end;
        end;
      end;
      else result := trEnd;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sig.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd : result := trStop;
      end;
    end;
  end else
  begin // Враждебности встречного
    if ObjZv[Sig.Obj].bP[1] or   // МС1
    ObjZv[Sig.Obj].bP[2] or   // МС2
    ObjZv[Sig.Obj].bP[3] or   // С1
    ObjZv[Sig.Obj].bP[4] then // С2
    begin
      result := trStop;
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,114);
    end;

    case Rod of
      MarshP : if ObjZv[Sig.Obj].ObCB[6] then result := trKonec;
      MarshM : if (ObjZv[Sig.Obj].ObCB[8]) and(ObjZv[Sig.Obj].ObCB[23])
      then result := trKonec;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sig.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          // Маршрут не существует
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Sig.Obj].Liter,1);
          result := trEnd;
          InsMsg(Sig.Obj,77);
        end;
      end;
    end;
  end;
end;

//========================================================================================
//--------------------------------------------- проход через сигнал при поиске известителя
function StepSigFindIzv(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else  result := trNext;
    end;
  end else
  begin //---------------------------------------- проверить условия для попутного сигнала
    if ObjZv[Sig.Obj].bP[2] or ObjZv[Sig.Obj].bP[4] then  //---- светофор открыт
    inc(MarhTrac.IzvCount)
    else
    if ObjZv[Sig.Obj].bP[6] or
    ObjZv[Sig.Obj].bP[7] or
    ObjZv[Sig.Obj].bP[1] then
    begin //---------- возбужден признак маневрового начала или сигнал на выдержке времени
      if not ObjZv[Sig.Obj].bP[2] then
      begin //------------------------------------------------------------ светофор закрыт
        result := trStop;
        exit;
      end;
      inc(MarhTrac.IzvCount);
    end else
    if ObjZv[Sig.Obj].bP[8] or
    ObjZv[Sig.Obj].bP[9] or
    ObjZv[Sig.Obj].bP[3] then
    begin //------------ возбужден признак поездного начала или сигнал на выдержке времени
      if not ObjZv[Sig.Obj].bP[4] then
      begin //------------------------------------------------------------ светофор закрыт
        result := trStop;
        exit;
      end;
      inc(MarhTrac.IzvCount);
    end;
    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
//----------- проход через сигнал при поиске незамкнутых стрелок на предмаршрутном участке
function StepSigFindStr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end else
  begin // проверить условия для попутного сигнала
    if ((Rod = MarshM) and ObjZv[Sig.Obj].ObCB[3]) or
    ((Rod = MarshP) and (ObjZv[Sig.Obj].ObCB[2] or ObjZv[Sig.Obj].bP[2])) then
    begin // светофор ограничивает предмаршрутный участок
      result := trStop;
      exit;
    end
    else Con := ObjZv[Sig.Obj].Sosed[1];

    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
//----------------------------- Функция прохода через сигнал при повторной выдаче маршрута
function StepSigPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod :Byte; Sig:TSos) : TTrRes;
//------------------------------------ Con - коннектор, с которого трасса пришла на сигнал
//----------------------------------------------------- Lvl - исполняемый этап трассировки
//------------------------------------------------------- Rod - вид трассируемого маршрута
//------------------------------------- jmp - сосед, от которого трассы пришла на светофор
//--- ФУНКЦИЯ ВОЗВРАЩАЕТ РЕЗУЛЬТАТ ПРОХОЖДЕНИЯ ЧЕРЕЗ СИГНАЛ ИЗ ВОЗМОЖНОГО НАБОРА ВАРИАНТОВ
var
  old_con : TSos;
begin
  result := trNext; //------------ изначально считается, что трасса должна идти дальше
  old_con := Con;
  //------------------------------------ проверяем наличие концов маршрутов перед сигналом
  if Con.Pin = 1 then //-------------- если вошли на сигнал в точке 1 (проверка попутного)
  begin
    case Rod of
      MarshP : //-------------------------------------------------- для поездного маршрута
        if ObjZv[Sig.Obj].ObCB[5] //------------- если в точке 1 есть конец поездных
        then result := trKonec; //---------------------- тогда результат = конец трассы
      MarshM : //------------------------------------------------ для маневрового маршрута
        if ObjZv[Sig.Obj].ObCB[7] //----------- если в точке 1 есть конец маневровых
        then result := trKonec; //---------------------- тогда результат = конец трассы
      else  result := trEnd;    //---------------- для нопределенных маршрутов сразу конец
    end;

    if result = trNext then //- если в точке 1 не было останова, и трасса продолжается
    begin
      Con := ObjZv[Sig.Obj].Sosed[2]; //- получить новый коннектор со стороны точки 2
      case Con.TypeJmp of
        LnkRgn : result := trStop; //----------------- если проход в другой район, то стоп
        LnkEnd : result := trStop; //---------------------- если коннектор тупика, то стоп
      end;
    end;
  end else //--------- если вошли на сигнал в точке 2 проверяем наличие концов за сигналом
  begin
    case Rod of
      MarshP :
        if ObjZv[Sig.Obj].ObCB[5] or ObjZv[Sig.Obj].ObCB[6]
        then result := trKonec;//------------------------------ М конец в точке 1 или 2

      MarshM :
        if ObjZv[Sig.Obj].ObCB[7] or ObjZv[Sig.Obj].ObCB[8]
        then result := trKonec;//------------------------------ П конец в точке 1 или 2
    end;
  end;
  Con := old_con;
  if result = trNext then //---------------------------- если продолжается трассировка
  begin
    if Con.Pin = 1 then Con := ObjZv[Sig.Obj].Sosed[2]
    else Con := ObjZv[Sig.Obj].Sosed[1];

    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd :
      begin  //---------------------------------------------------- Маршрут не существует
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,77, ObjZv[Sig.Obj].Liter,1);
        InsMsg(Sig.Obj,77);
        result := trEnd;
      end;
    end;
  end;

end;

//========================================================================================
//--------------------------------------------- проход через СП при поиске трассы маршрута
function StepSpPutFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  PinX : integer;
begin
  if Con.Pin = 1 then  //------------------------------ вышли на секцию со стороны точки 1
  begin
    PinX := 2;
    case Rod of //------------------- если есть поездные или маневровые в направлении 1->2
      MarshP : if ObjZv[Sp.Obj].ObCB[1] then result := trNext  else result := trRepeat;
      MarshM : if ObjZv[Sp.Obj].ObCB[3] then result := trNext  else result := trRepeat;
      else result := trStop;
    end;
  end else  //----------------------------------------- вышли на секцию со стороны точки 2
  begin
    PinX := 1;
    case Rod of
      MarshP : if ObjZv[Sp.Obj].ObCB[2] then result := trNext else result := trRepeat;
      MarshM : if ObjZv[Sp.Obj].ObCB[4] then result := trNext else result := trRepeat;
      else result := trStop;
    end;
  end;
  if result = trNext then
  begin
    Con := ObjZv[Sp.Obj].Sosed[PinX];
    if (Con.TypeJmp=LnkRgn)or(Con.TypeJmp=LnkEnd) then result:= trRepeat;
  end;
end;

//========================================================================================
//---------------------- проход через СП при продлении трассы маршрута за встречный сигнал
function StepSPContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trBreak;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
        if ObjZv[Sp.Obj].ObCB[1]  //--------- если есть поездные в направлении 1->2
        then result := trNext
        else result := trStop;

      MarshM :
        if ObjZv[Sp.Obj].ObCB[3] //-------- если есть маневровые в направлении 1->2
        then result := trNext
        else result := trEnd;

      else result := trNext;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sp.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;
    if result = trEnd then  MarhTrac.ObjLast := Sp.Obj;
  end else
  begin
    case Rod of
      MarshP :
        if ObjZv[Sp.Obj].ObCB[2]then //-------если есть поездные в направлении 2->1
        result := trNext
        else result := trStop;

      MarshM :
        if ObjZv[Sp.Obj].ObCB[4]//--------- если есть маневровые в направлении 2->1
        then result := trNext
        else result := trEnd;

      else result := trNext;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sp.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    if result = trEnd then  MarhTrac.ObjLast := Sp.Obj;

  end;
end;

//========================================================================================
//---------------------------------------------- проход через СП при проверке зависимостей
function StepSpZavTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  if Con.Pin = 1 then
  begin
    Con := ObjZv[Sp.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end else
  begin
    Con := ObjZv[Sp.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
//----------------------------- шаг через СП при проверке враждебностей по трассе маршрута
function StepSрChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  tail : boolean;
  k : integer;
begin
  with ObjZv[Sp.Obj] do
  begin
    result := trNext;
    //------ если "З" или нет признака повторной проверки и есть программное замыкание или
    //----------------------------------------- предварительное замыкание STAN установлено
    if not bP[2] or (not MarhTrac.Povtor and (bP[14] or not bP[7])) then
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,82, Liter,1);
    InsMsg(Sp.Obj,82); //----------------------------------------------- Участок $ замкнут
    MarhTrac.GonkaStrel := false;
  end;

  if bP[12] or bP[13] then //----------------------------------------- Закрыт для движения
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,134, Liter,1);
    InsMsg(Sp.Obj,134); //---------------------------------- Участок $ закрыт для движения
    MarhTrac.GonkaStrel := false;
  end;

  //""""""""""""""""""""""""""""""" ПРОВЕРИТЬ ВВЕДЕННЫЕ ОГРАНИЧЕНИЯ """"""""""""""""""""""

  if ObCB[8] or ObCB[9] then //--------------------------------------------- если Эл. тяга
  begin
    if bP[24] or bP[27] then //--------------------------------------------- Закрыт для ЭТ
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, Liter,1);
      InsWar(Sp.Obj,462); //------------------------- Закрыто движение на электротяге по $
    end else
    if ObCB[8] and ObCB[9] then
    begin
      if bP[25] or bP[28] then//Закрыт для ЭТ=
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, Liter,1);
        InsWar(Sp.Obj,467);//------------- Закрыто движение на электротяге пост. тока по $
      end;

      if bP[26] or bP[29] then//------------------------------------------- Закрыт для ЭТ~
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, Liter,1);
        InsWar(Sp.Obj,472); //----------- Закрыто движение на электротяге перем. тока по $
      end;
    end;
  end;

  if bP[3] then //--------------------------------------------------------------------- РИ
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,84, Liter,1);
    InsMsg(Sp.Obj,84); //------------------ Выполняется искусственное размыкание участка $
    MarhTrac.GonkaStrel := false;
  end;

  if not bP[5] then //----------------------------------------------------------------- МИ
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,85, Liter,1);
    InsMsg(Sp.Obj,85);  //----------------------------------- Участок $ замкнут в маневрах
    MarhTrac.GonkaStrel := false;
  end;

  case Rod of
    MarshP :
    begin
      if not bP[1] then //---------------------------------------------- занятость участка
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
        GetSmsg(1,83, Liter,1);
        InsMsg(Sp.Obj,83);   //------------------------------------------- Участок $ занят
        MarhTrac.GonkaStrel := false;
      end;
    end;

    MarshM :
    begin
      if not bP[1] then //------------------------------------------- занятость участка СП
      begin
        if ObCB[5] then  //------------------------------------------------------- если СП
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,83, Liter,1);
          InsMsg(Sp.Obj,83); //------------------------------------------- Участок $ занят
          MarhTrac.GonkaStrel := false;
        end else
        begin
          tail := false;

          for k := 1 to MarhTrac.CIndex do
          if MarhTrac.hTail = MarhTrac.ObjTRS[k] then
          begin
            tail := true;
            break;
          end;

          if tail then  //-------------------------------------------- если конец маршрута
          begin
            MarhTrac.TailMsg := ' на занятый участок '+ Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, Liter,1);
            InsWar(Sp.Obj,83); //----------------------------------------- Участок $ занят
            result := trEnd;
          end else  //------------------------------------------- если не в конце маршрута
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, Liter,1);
            InsMsg(Sp.Obj,83); //----------------------------------------- Участок $ занят
            result := trBreak;
            MarhTrac.GonkaStrel := false;
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
    Con := Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin
    Con := Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSpZamTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  if not ObjZv[Sp.Obj].bP[1] and    //--------------------- если занят участок и ...
  not ObjZv[Sp.Obj].ObCB[5] and    //------------------------ этот участок УП и ...
  (Rod = MarshM) then //----------------------------------------------- маневровый маршрут
  begin //---------------- выдать предупреждение в маневровом маршруте о занятости участка
    MarhTrac.TailMsg := ' на занятый участок '+ ObjZv[Sp.Obj].Liter;
    MarhTrac.FindTail := false;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZv[Sp.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;

    if result = trNext then
    begin
      if ObjZv[Sp.Obj].bP[2]
      then ObjZv[Sp.Obj].bP[14] := true; //------------------------- прог. замыкание

      ObjZv[Sp.Obj].iP[1] := MarhTrac.ObjStart; //---------- индекс начала
      ObjZv[Sp.Obj].iP[2] := MarhTrac.SvetBrdr; //------- индекс светофора

      if not ObjZv[Sp.Obj].ObCB[5] and //---------------------------- если УП и ...
      (Rod = MarshM) then //------------------------------------------- маневровый маршрут
      begin //-------------------------------------------- для УП в маневрах возбудить 1КМ
        ObjZv[Sp.Obj].bP[15] := true;  //--------------------------------------- 1КМ
        ObjZv[Sp.Obj].bP[16] := false; //--------------------------------------- 2КМ
      end else
      begin //----------------------------------------------------------- иначе сброс КМов
        ObjZv[Sp.Obj].bP[15] := false; //--------------------------------------- 1КМ
        ObjZv[Sp.Obj].bP[16] := false; //--------------------------------------- 2КМ
      end;
    end;
  end else
  begin
    Con := ObjZv[Sp.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;

    if result = trNext then
    begin
      if ObjZv[Sp.Obj].bP[2] //--------------------- если нет "З" из релейных данных
      then ObjZv[Sp.Obj].bP[14] := true;  //---- то установить программное замыкание

      ObjZv[Sp.Obj].iP[1] := MarhTrac.ObjStart; //---------- индекс начала
      ObjZv[Sp.Obj].iP[2] := MarhTrac.SvetBrdr; //------- индекс светофора

      if not ObjZv[Sp.Obj].ObCB[5] and (Rod = MarshM) then
      begin //-------------------------------------------- для УП в маневрах возбудить 2КМ
        ObjZv[Sp.Obj].bP[15] := false; //--------------------------------------- 1КМ
        ObjZv[Sp.Obj].bP[16] := true;  //--------------------------------------- 2КМ
      end else
      begin //----------------------------------------------------------------- сброс КМов
        ObjZv[Sp.Obj].bP[15] := false; //--------------------------------------- 1КМ
        ObjZv[Sp.Obj].bP[16] := false; //--------------------------------------- 2КМ
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSpCirc(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trNext;

  //""""""""""""""""""""""" ОБРАБОТКА ВВЕДЕННЫХ ОГРАНИЧЕНИЙ """"""""""""""""""""""""""""""
  if ObjZv[Sp.Obj].bP[12] or ObjZv[Sp.Obj].bP[13] then //-- Закрыт для движен.
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,134); //--------------------------- Участок $ закрыт для движения
    result :=  trBreak;
  end;

  if ObjZv[Sp.Obj].ObCB[8] or  //----------------- если ЭТ переменного тока или ...
  ObjZv[Sp.Obj].ObCB[9] then   //------------------------------ ЭТ постоянного тока
  begin
    if ObjZv[Sp.Obj].bP[24] or //--- если закрыт для движения на эл.т. в АРМ ДСП или
    ObjZv[Sp.Obj].bP[27] then //---------------- закрыт для движения на эл.т. в STAN
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and //------------------------- для станции стыкования
    ObjZv[Sp.Obj].ObCB[9] then //--- если ЭТ переменного тока и ЭТ постоянного тока
    begin
      if ObjZv[Sp.Obj].bP[25] or //-------- Закрыт для движения на пост.т. в АРМ ДСП
      ObjZv[Sp.Obj].bP[28] then //------------ Закрыт для движения на пост.т. в STAN
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467); //-------- Закрыто движение на ЭТ постоянного тока по $
      end;
      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472); //-------- Закрыто движение на ЭТ переменного тока по $
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84); //----------- Выполняется искусственное размыкание участка $
  end;

  if not ObjZv[Sp.Obj].bP[5] then //--------------------------------------------- МИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,85, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,85); //----------------------------- Участок $ замкнут в маневрах
  end;

  if Rod = MarshP then
  begin
    if not ObjZv[Sp.Obj].bP[1] then //---------------------------- занятость участка
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
      GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
      InsMsg(Sp.Obj,83); //---------------------------------------- Участок $ занят
    end;
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].ObCB[1] then   //----- нет поездных в направлении 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //----------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[3] then  //---- нет маневровых в направлении 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162);  //-------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZv[Sp.Obj].bP[1] then //------------------------ занятость участка
        begin
          if ObjZv[Sp.Obj].bP[15] then //--------------------------------------------- 1КМ
          begin
            MarhTrac.TailMsg :=' на занятый участок '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83); //----------------------------------------- Участок $ занят
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sp.Obj].Sosed[2];
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
        if not ObjZv[Sp.Obj].ObCB[2] then //-------- если нет поездных в напр. 1<-2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161);  //---------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin

        if not ObjZv[Sp.Obj].ObCB[4] then    //если нет маневровых в направл. 1<-2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //--------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZv[Sp.Obj].bP[16] then //--------------------------------------- 2КМ
          begin
            MarhTrac.TailMsg :=' на занятый участок '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);
          end;
        end;

      end;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sp.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSPOtmen(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  sosed : integer;
begin
  if Con.Pin = 1 then  sosed := 2
  else sosed := 1;

  Con := ObjZv[Sp.Obj].Sosed[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else  result := trNext;
  end;

  if result = trNext then
  begin
    ObjZv[Sp.Obj].bP[14] := false; //------------------------------- прог. замыкание
    ObjZv[Sp.Obj].bP[8]  := true;  //---------------------------------------- трасса
    ObjZv[Sp.Obj].iP[1]  := 0;
    ObjZv[Sp.Obj].iP[2]  := 0;
    ObjZv[Sp.Obj].bP[15] := false; //------------------------------------------- 1КМ
    ObjZv[Sp.Obj].bP[16] := false; //------------------------------------------- 2КМ
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSpRazdel(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trNext;
  if not ObjZv[Sp.Obj].bP[2] then //--------------------------------------- замыкание есть
  begin
    if ObjZv[Sp.Obj].ObCB[5] then //----------------------------------------- если это СП
    begin //--------------------------------------------------- СП - выдать предупреждение
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
      GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,82);   //------------------------------------------- Участок $ замкнут
    end else
    begin //--------------------------------------------------------------------------- УП
      case Rod of
        MarshP :
        begin
          if not ObjZv[Sp.Obj].bP[15] and
          not ObjZv[Sp.Obj].ObCB[16] then //------------------------------ нет КМов
          begin //-------------------------------------------------- выдать предупреждение
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,82); //-------------------------------- Участок $ замкнут
          end else
          begin //----------------------------------------------------------- враждебность
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,82); //-------------------------------- Участок $ замкнут
          end;
        end;

        MarshM :
        begin
          if Con.Pin = 1 then
          begin
            if ObjZv[Sp.Obj].bP[15] and
            not ObjZv[Sp.Obj].ObCB[16] then //-------------------- есть 1КМ нет 2КМ
            begin //------------------------------------------------ выдать предупреждение
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsWar(Sp.Obj,82); //------------------------------ Участок $ замкнут
            end else
            begin //--------------------------------------------------------- враждебность
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsMsg(Sp.Obj,82); //------------------------------ Участок $ замкнут
            end;
          end else
          begin
            if not ObjZv[Sp.Obj].bP[15] and
            ObjZv[Sp.Obj].ObCB[16] then //------------------------ есть 2КМ нет 1КМ
            begin //------------------------------------------------ выдать предупреждение
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsWar(Sp.Obj,82); //------------------------------ Участок $ замкнут
            end else
            begin //--------------------------------------------------------- враждебность
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsMsg(Sp.Obj,82); //------------------------------ Участок $ замкнут
            end;
          end;
        end;

        else
          inc(MarhTrac.MsgN); //------------------------------- враждебность
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,82); //---------------------------------- Участок $ замкнут
      end;
    end;
  end;

  if not ObjZv[Sp.Obj].bP[7] or
  ObjZv[Sp.Obj].bP[14] then //-------------------------------- программное замыкание
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,82); //---------------------------------------- Участок $ замкнут
  end;

  if ObjZv[Sp.Obj].bP[12] or
  ObjZv[Sp.Obj].bP[13] then //------------- Закрыт для движения в АРМ ДСП или в STAN
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,134);
  end;

  if ObjZv[Sp.Obj].ObCB[8] or
  ObjZv[Sp.Obj].ObCB[9] then //---------------------- если участок электрифицирован
  begin
    if ObjZv[Sp.Obj].bP[24] or
    ObjZv[Sp.Obj].bP[27] then //----------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTrac.WarN);         //------------------------- предупреждение
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462);  //----------------- Закрыто движение на электротяге по $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and ObjZv[Sp.Obj].ObCB[9] then //----- обе тяги
    begin
      if ObjZv[Sp.Obj].bP[25] or
      ObjZv[Sp.Obj].bP[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTrac.WarN);       //------------------------- предупреждение
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467);//--------- Закрыто движение на ЭТ постоянного тока по $
      end;

      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTrac.WarN);       //------------------------- предупреждение
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472); //-------- Закрыто движение на ЭТ переменного тока по $
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84);
  end;

  if not ObjZv[Sp.Obj].bP[5] then //--------------------------------------------- МИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,85, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,85); //----------------------------- Участок $ замкнут в маневрах
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ занятость участка
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);  //----------------------------------- Участок $ занят
        end;

        if not ObjZv[Sp.Obj].ObCB[1] then //------- нет поездных в направлении 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //----------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[3] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //--------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- занятость участка
          if not ObjZv[Sp.Obj].ObCB[5] then //---------------------------------- УП
          begin
            MarhTrac.TailMsg := ' на занятый участок '+ ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83); //---------------------------------- Участок $ занят
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNext then
    begin
      ObjZv[Sp.Obj].bP[8] := false;
      Con := ObjZv[Sp.Obj].Sosed[2];
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
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ занятость участка
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);
        end;

        if not ObjZv[Sp.Obj].ObCB[2] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161);   //--------------------- Нет поездных маршрутов по $
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[4] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //----------------- Нет маневровых маршрутов по $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- занятость участка
          if not ObjZv[Sp.Obj].ObCB[5] then //---------------------------------- УП
          begin
            MarhTrac.TailMsg :=' на занятый участок '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83);
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNext then
    begin
      ObjZv[Sp.Obj].bP[8] := false;
      Con := ObjZv[Sp.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSpPovtRazd(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trNext;
  if not ObjZv[Sp.Obj].bP[2] then //-------------------------------------- замыкание
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,82);
  end;

  if ObjZv[Sp.Obj].bP[12] or ObjZv[Sp.Obj].bP[13] then//- Закрыт для движения.
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,134);  //-------------------------- Участок $ закрыт для движения
  end;

  if ObjZv[Sp.Obj].ObCB[8] or ObjZv[Sp.Obj].ObCB[9] then  //-------- если ЭТ
  begin
    if ObjZv[Sp.Obj].bP[24] or
    ObjZv[Sp.Obj].bP[27] then //----------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and ObjZv[Sp.Obj].ObCB[9] then
    begin
      if ObjZv[Sp.Obj].bP[25] or
      ObjZv[Sp.Obj].bP[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467);
      end;

      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472);
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84);  //---------- Выполняется искусственное размыкание участка $
  end;

  if not ObjZv[Sp.Obj].bP[5] then //----------------------------------------- МИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,85, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,85);  //---------------------------- Участок $ замкнут в маневрах
  end;

  if Con.Pin = 1 then //--------------------------------------------- если вошли в точку 1
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ занятость участка
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);  //----------------------------------- Участок $ занят
        end;

        if not ObjZv[Sp.Obj].ObCB[1] then //------- нет поездных в направлении 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //--------------------- "Нет поездных маршрутов по $"
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[5] //-------------------------------- если это УП
        then ObjZv[Sp.Obj].bP[15] := true; //----------------------------------- 1км

        if not ObjZv[Sp.Obj].ObCB[3] then  //---- нет маневровых в направлении 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //--------------------- Нет маневровых маршрутов по $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZv[Sp.Obj].bP[15] then //--------------------------------------- 1КМ
          begin
            MarhTrac.TailMsg :=' на занятый участок '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83);
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNext then
    begin
      ObjZv[Sp.Obj].bP[8] := false;
      Con := ObjZv[Sp.Obj].Sosed[2];
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
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ занятость участка
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);
        end;

        if not ObjZv[Sp.Obj].ObCB[2] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //--------------------- "Нет поездных маршрутов по $"
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[5]
        then ObjZv[Sp.Obj].bP[16] := true;

        if not ObjZv[Sp.Obj].ObCB[4] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //------------------- "Нет маневровых маршрутов по $"
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZv[Sp.Obj].bP[16] then //--------------------------------------- 1КМ
          begin
            MarhTrac.TailMsg :=' на занятый участок '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83);
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);
          end;
        end;
      end;
    end;

    if result = trNext then
    begin
      ObjZv[Sp.Obj].bP[8] := false;
      Con := ObjZv[Sp.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------- трассировка при автодействии
function StepSpAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trNext;

  if not ObjZv[Sp.Obj].bP[2] {or not ObjZv[Sp.Obj].bP[7]} then //--- замыкание
  exit;
  {
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1); //---------------------- "Участок $ замкнут"
    InsMsg(Sp.Obj,82);
  end;
  }
  if ObjZv[Sp.Obj].bP[12] or ObjZv[Sp.Obj].bP[13] then //---- Закрыт для движ.
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1); //------- "Участок $ закрыт для движения"
    InsMsg(Sp.Obj,134);
  end;

  if ObjZv[Sp.Obj].ObCB[8] or ObjZv[Sp.Obj].ObCB[9] then
  begin
    if ObjZv[Sp.Obj].bP[24] or
    ObjZv[Sp.Obj].bP[27] then //----------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462);//------------------- Закрыто движение на электротяге по $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and ObjZv[Sp.Obj].ObCB[9] then
    begin
      if ObjZv[Sp.Obj].bP[25] or
      ObjZv[Sp.Obj].bP[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467);
      end;

      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472);
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- РИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84);//---------- "Выполняется искусственное размыкание участка $"
  end;

  if not ObjZv[Sp.Obj].bP[5] then //--------------------------------------------- МИ
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,85, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,85);
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ занятость участка
        begin
          exit;
          {
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);  //--------------- "Участок $ занят"
          InsMsg(Sp.Obj,83);
          }
        end;

        if not ObjZv[Sp.Obj].ObCB[1] then   //------------------- нет поездных 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //--------------------- "Нет поездных маршрутов по $"
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[5] then ObjZv[Sp.Obj].bP[15] := true;

        if not ObjZv[Sp.Obj].ObCB[3] then  //------------------ нет маневровых 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //------------------- "Нет маневровых маршрутов по $"
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZv[Sp.Obj].bP[15] then //--------------------------------------- 1КМ
          begin
            MarhTrac.TailMsg :=' на занятый участок '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83);    //----------------------------- "Участок $ занят"
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);    //----------------------------- "Участок $ занят"
          end;
        end;
      end;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sp.Obj].Sosed[2];
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
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ занятость участка
        begin
          exit;
          {
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);       //---------------------------- "Участок $ занят"
          }
        end;
        if not ObjZv[Sp.Obj].ObCB[2] then    //---------------- нет поездных 1 <- 2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161);
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[5] then ObjZv[Sp.Obj].bP[16] := true;

        if not ObjZv[Sp.Obj].ObCB[4] then   //--------------- нет маневровых 1 <- 2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1); InsMsg(Sp.Obj,162);
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- занятость участка
          if ObjZv[Sp.Obj].bP[16] then //--------------------------------------- 1КМ
          begin
            MarhTrac.TailMsg :=' на занятый участок '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83); //-------------------------------- "Участок $ занят"
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);  //------------------------------- "Участок $ занят"
          end;
        end;
      end;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Sp.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSpFindIzv (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  if not ObjZv[Sp.Obj].bP[1] then
  begin //------------------------------------------------------------------ участок занят
    result := trBreak;
    exit;
  end else
  if ObjZv[Sp.Obj].bP[2] then
  begin //-------------------------------------------------- участок не замкнут в маршруте
    if not((MarhTrac.IzvCount = 0) and (MarhTrac.Rod = MarshM)) then
    begin
      result := trStop;
      exit;
    end;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZv[Sp.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end else
  begin
    Con := ObjZv[Sp.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
function StepSpFindStr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  if not ObjZv[Sp.Obj].bP[1] then
  begin //------------------------------------------------------------------ участок занят
    MarhTrac.IzvStrFUZ := true;
    if ObjZv[Sp.Obj].ObCB[5] then
    begin //-------------------------------------------------- если СП - проверить стрелки
      if ObjZv[Sp.Obj].bP[2] or
      MarhTrac.IzvStrNZ then //------------------------------ участок не замкнут
      MarhTrac.IzvStrUZ := true;

      if MarhTrac.IzvStrNZ then //------------------------ есть стрелки в трассе
      begin //------------------- сообщить оператору о незамкнутых стрелках перед сигналом
        result := trStop;
        exit;
      end;
    end else
    begin //-------------------------------- если УП - проверить наличие стрелок по трассе
      if MarhTrac.IzvStrNZ then
      begin //---- есть стрелки - сообщить оператору о незамкнутых стрелках перед сигналом
        MarhTrac.IzvStrUZ := true;
        result := trStop;
        exit;
      end;
    end;
  end else
  if MarhTrac.IzvStrFUZ then
  begin//-- участок свободен и была занятость участка перед ним-не выдавать предупреждение
    MarhTrac.IzvStrUZ := false;
    result := trStop;
    exit;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZv[Sp.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end else
  begin
    Con := ObjZv[Sp.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
function StepSPPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  sosed : integer;
begin

  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  if not ObjZv[Sp.Obj].bP[14] and //--------------- нет программного замыкания и ...
  ObjZv[Sp.Obj].bP[7] then //------------------------ нет предварительного замыкания
  begin //------------------------------------------------------ разрушена трасса маршрута
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,228, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsMsg(Sp.Obj,228);
    result := trStop;
  end else
  begin
    Con := ObjZv[Sp.Obj].Sosed[sosed];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
function StepPutContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
begin
  if Con.Pin = 1 then //--------------------------------- вышли на путь со стороны точки 1
  begin
    case Rod of
      MarshP :
        if ObjZv[Put.Obj].ObCB[1] then result := trNext
        else result := trStop;
      MarshM :
        if ObjZv[Put.Obj].ObCB[3] then result := trNext//если есть маневры 1->2
        else
          if ObjZv[Put.Obj].ObCB[11] then result :=  trKonec
          else result := trStop;
      else result := trNext;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Put.Obj].Sosed[2];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;
  end else   //------------------------------------------ вышли на путь со стороны точки 2
  begin
    case Rod of
      MarshP :
        if ObjZv[Put.Obj].ObCB[2] then result := trNext
        else result := trStop;

      MarshM :
        if ObjZv[Put.Obj].ObCB[4] then result := trNext//если есть маневры 1<-2
        else
        if ObjZv[Put.Obj].ObCB[10] then result :=  trKonec
        else result := trStop;

      else result := trNext;
    end;

    if result = trNext then
    begin
      Con := ObjZv[Put.Obj].Sosed[1];
      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
        LnkNecentr : result := trKonec;
      end;
    end;
  end;
end;

//========================================================================================
function StepPutZavTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;
  Con := ObjZv[Put.Obj].Sosed[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else result := trNext;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
var
  tail,Chi,Ni,ChKM,NKM : boolean;
  k,UTS,sosed,Pt : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;
  Pt := Put.Obj;
  Chi := not ObjZv[Pt].bP[2];
  Ni :=  not ObjZv[Pt].bP[3];
  ChKM := ObjZv[Pt].bP[4];
  NKM :=  ObjZv[Pt].bP[15];
  UTS := ObjZv[Pt].BasOb;
  result := trNext;
  //--------------------------------------------------------------- если для пути есть УТС
  if UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- упор установлен
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Pt].Liter,1);
          InsMsg(Pt,108);  //---------------------- "Установлен тормозной упор"
          MarhTrac.GonkaStrel := false;
        end else
        if not ObjZv[UTS].bP[1] and not ObjZv[UTS].bP[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Pt].Liter,1);
          InsMsg(Pt,109);//------- "Тормозной упор не имеет контроля положения"
          MarhTrac.GonkaStrel := false;
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZv[Pt].bP[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZv[UTS].bP[27] then
            begin //------------------------------------------- сообщение не зафиксировано
              ObjZv[ObjZv[Pt].BasOb].bP[27] := true;
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Pt].Liter,1);
              InsWar(Pt,108);  //------------------ "Установлен тормозной упор"
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Pt].Liter,1);
            InsMsg(Pt,108);  //-------------------- "Установлен тормозной упор"
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Pt].bP[12] or ObjZv[Pt].bP[13] then //- Закрыт для движения
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Pt].Liter,1);
    InsMsg(Pt,135); //------------------------------ Путь $ закрыт для движения
    MarhTrac.GonkaStrel := false;
  end;

  if ObjZv[Pt].ObCB[8] or ObjZv[Pt].ObCB[9] then //--------- если ЭТ
  begin
    if ObjZv[Pt].bP[24]
    or ObjZv[Pt].bP[27] then //-------------------- Закрыт для движения на эл.т.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Pt].Liter,1);
      InsWar(Pt,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZv[Pt].ObCB[8] and ObjZv[Pt].ObCB[9] then
    begin
      if ObjZv[Pt].bP[25] or
      ObjZv[Pt].bP[28] then //------------------- Закрыт для движения на пост.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Pt].Liter,1); InsWar(Pt,467);
      end;

      if ObjZv[Pt].bP[26] or
      ObjZv[Pt].bP[29] then //-------------------- Закрыт для движения на пер.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Pt].Liter,1);
        InsWar(Pt,472); //------------------------- Конец контактной подвески $
      end;
    end;
  end;

  case Rod of
    MarshP : //---------------------------------------------------- для поездного маршрута
    begin
      if not MarhTrac.Povtor and   //---------- если не повторная проверка и ...
      (ObjZv[Pt].bP[14] or  //--------------- программное замыкание или ...
      not ObjZv[Pt].bP[7] or //-------- предварительное замыкание четное или ...
      not ObjZv[Pt].bP[11]) then //---------- предварительное замыкание нечетное
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,110, ObjZv[Pt].Liter,1);
        InsMsg(Pt,110);
        MarhTrac.GonkaStrel := false;
      end;

      if not (ObjZv[Pt].bP[1] and ObjZv[Pt].bP[16]) then //- занятость Ч или Н
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Pt].Liter,1);
        InsMsg(Pt,112); //-------------------------------------------- Путь $ занят
        MarhTrac.GonkaStrel := false;
      end;

      if Chi or Ni then //------------------------------------------------------ ЧИ или НИ
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,113, ObjZv[Pt].Liter,1);
        InsMsg(Pt,113);//------------------ На путь $ установлен враждебный маршрут
        MarhTrac.GonkaStrel := false;
      end;

      if not (ObjZv[Pt].bP[5] and ObjZv[Pt].bP[6]) then //----------- ~МИ(ч&н)
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Pt].Liter,1);
        InsMsg(Pt,111); //--------------------------- Путь $ замкнут в маневрах
        MarhTrac.GonkaStrel := false;
      end;

      //---------------------------------------------------------- четный  маршрут на путь
      //----------------------------------------------------------------------------------
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin //-----------  проверить конец подвески контакной сети для четного направления
        if ObjZv[Pt].ObCB[11] then  //-------------------- Конец контакт.подвески Ч
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Pt].Liter,1);
          InsWar(Pt,473); //----------------------- Конец контактной подвески $
        end;
      end else //------------------------------------------------ нечетный маршрут на путь
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZv[Pt].ObCB[10] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Pt].Liter,1);
          InsWar(Pt,473);
        end;
      end;
    end;

    //--------------------------------------------------- для маневрового маршрута на путь
    MarshM :
    begin
      if not MarhTrac.Povtor and
      (ObjZv[Pt].bP[14] or //----------- программное замыкание на РМ-ДСП или ...
      not ObjZv[Pt].bP[7] or //-------- Предварительное замыкание FR3(ч) или ...
      not ObjZv[Pt].bP[11]) then //-----------  Предварительное замыкание FR3(н)
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,110, ObjZv[Pt].Liter,1);
        InsMsg(Pt,110); //----------------------- Установлено замыкание $ в УВК
        MarhTrac.GonkaStrel := false;
      end;

      if not (ObjZv[Pt].bP[5] and ObjZv[Pt].bP[6]) then //--------- ~МИ(ч & н)
      begin
        result := trBreak;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Pt].Liter,1);
        InsWar(Pt,111);   //----------------------------- Путь $ замкнут в маневрах
      end;

      //----------------------------------------------------------  четный маршрут на путь
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin
        if (not NKM and Ni) or Chi then//------------------------- НИ без НКМ или любой ЧИ
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Pt].Liter,1);
          result := trBreak;
          InsMsg(Pt,113); //----------- На путь $ установлен враждебный маршрут
          MarhTrac.GonkaStrel := false;
        end else
        if Ni then //------------------------------------------------------------------ НИ
        begin
          if NKM then //--------------------------------------------------------- есть НКМ
          begin
            tail := false;
            for k := 1 to MarhTrac.CIndex do
            if MarhTrac.hTail = MarhTrac.ObjTRS[k] then
            begin
              tail := true;
              break;
            end;

            if tail then
            begin
              MarhTrac.TailMsg := ' на замкнутый путь '+ ObjZv[Pt].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Pt].Liter,1);
              InsWar(Pt,441);// На путь установлен встречный маневровый маршрут
            end else
            begin //--------сли конечная точка трассы лежит позади замкнутого пути - выход
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Pt].Liter,1);
              InsMsg(Pt,113);//-------- На путь $ установлен враждебный маршрут
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Pt].Liter,1);
            InsMsg(Pt,113);//---------- На путь $ установлен враждебный маршрут
            MarhTrac.GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end else //-------------------------------------------------------- нечетный маршрут
      begin
        if (not ChKM and Chi) or Ni then //------ стоит четный поездной или любой нечетный
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Pt].Liter,1);
          result := trBreak;
          InsMsg(Pt,113);//------------ На путь $ установлен враждебный маршрут
          MarhTrac.GonkaStrel := false;
        end else
        if Chi then //----------------------------------------------------------------- ЧИ
        begin
          if ChKM then //------------------------------------------------------------- чкм
          begin
            tail := false;

            for k := 1 to MarhTrac.CIndex do
            if MarhTrac.hTail = MarhTrac.ObjTRS[k] then
            begin
              tail := true;
              break;
            end;

            if tail then
            begin
              MarhTrac.TailMsg :=  ' на замкнутый путь '+ ObjZv[Pt].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Pt].Liter,1);
              InsWar(Pt,441);// На путь установлен встречный маневровый маршрут
            end else
            begin //------ если конечная точка трассы лежит позади замкнутого пути - выход
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Pt].Liter,1);
              InsMsg(Pt,113);//-------- На путь $ установлен враждебный маршрут
              MarhTrac.GonkaStrel := false;
            end;
          end else //------------------------------------------------------------- нет ЧКМ
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Pt].Liter,1);
            InsMsg(Pt,113);//---------- На путь $ установлен враждебный маршрут
            MarhTrac.GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end;

      if not (ObjZv[Pt].bP[1] and ObjZv[Pt].bP[16]) //- занят(ч или н)
      then
      begin
        tail := false;

        for k := 1 to MarhTrac.CIndex do
        if MarhTrac.hTail = MarhTrac.ObjTRS[k] then
        begin
          tail := true;
          break;
        end;

        if tail then
        begin
          MarhTrac.TailMsg := ' на занятый путь '+ ObjZv[Pt].Liter;
          MarhTrac.FindTail := false;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,112, ObjZv[Pt].Liter,1);
          InsWar(Pt,112);
        end else
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,112, ObjZv[Pt].Liter,1);
          InsMsg(Pt,112);
          MarhTrac.GonkaStrel := false;
        end;
        result := trBreak;
      end;
    end;

    else begin result := trStop; exit; end;  //------------------- для отсутствия маршрута
  end;

  Con := ObjZv[Pt].Sosed[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trStop;
    LnkEnd : result := trStop;
    LnkNecentr : result := trKonec;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutZamTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  if not ObjZv[put.Obj].bP[1] then //------------------------------------- путь занят
  begin
    MarhTrac.TailMsg := ' на занятый путь '+ ObjZv[put.Obj].Liter;
    MarhTrac.FindTail := false;
  end;

  Con := ObjZv[put.Obj].Sosed[sosed]; //---------------------- коннектор точки выхода
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else  result := trNext;
  end;

  if result = trNext then  //--------------------------- если продолжается замыкание
  begin
    ObjZv[put.Obj].bP[8] := true;  //------------------------ сброс прог. замыкание
    ObjZv[put.Obj].iP[1] := MarhTrac.ObjStart;
    ObjZv[put.Obj].iP[2] := MarhTrac.SvetBrdr;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutCirc(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
var
  UTS : integer;
  Signal : integer;
begin
  result := trNext;
  UTS := ObjZv[Put.Obj].BasOb;
  if MarhTrac.ObjStart >0 then Signal := MarhTrac.ObjStart
  else Signal := 0;

  if UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- упор установлен
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Put.Obj].Liter,1); //------ Установлен тормозной упор $
          InsMsg(Put.Obj,108);
        end else
        if not ObjZv[UTS].bP[1] and
        not ObjZv[UTS].bP[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Put.Obj].Liter,1);//----- упор $ без контроля положения
          InsMsg(Put.Obj,109);
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and  ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZv[Put.Obj].bP[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZv[UTS].bP[27] then//--------------- сообщение не зафиксировано
            begin
              ObjZv[UTS].bP[27] := true;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,108); //------------------- "Установлен тормозной упор"
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,108);
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Put.Obj].bP[12] or ObjZv[Put.Obj].bP[13] then //-------------- Движение закрыто
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,135); //------------------------------ Путь $ закрыт для движения
  end;

  if ObjZv[Put.Obj].ObCB[8] or ObjZv[Put.Obj].ObCB[9] then
  begin
    if ObjZv[Put.Obj].bP[24] or ObjZv[Put.Obj].bP[27] then //------------ Закрыто ЭТ движ.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Put.Obj].Liter,1); //- Закрыто движение на электротяге по $
      InsWar(Put.Obj,462);
    end else
    if ObjZv[Put.Obj].ObCB[8] and ObjZv[Put.Obj].ObCB[9] then
    begin
      if ObjZv[Put.Obj].bP[25] or ObjZv[Put.Obj].bP[28] then //---- нет движ. -Т
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Put.Obj].Liter,1); //-- Закрыто движение на ЭТ пост. тока
        InsWar(Put.Obj,467);
      end;

      if ObjZv[Put.Obj].bP[26] or ObjZv[Put.Obj].bP[29] then //-------------- нет движ. ~Т
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Put.Obj].Liter,1);//-- Закрыто движение на ЭТ пер.тока по
        InsWar(Put.Obj,472);
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not(ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then //- занят(ч&н)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1); //------------------------ Путь $ занят
        InsMsg(Put.Obj,112);
      end;

      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //--- ~МИ(ч&н)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1); //----------- Путь $ замкнут в маневрах
        InsMsg(Put.Obj,111);
      end;

      if Con.Pin = 1 then //----------------------------- вошли на путь со стороны точки 1
      begin //------------ проверить конец подвески контакной сети для четного направления
        if ObjZv[Put.Obj].ObCB[11] then //------- есть признак конца контактной сети
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);//-------- Конец контактной подвески $
          InsWar(Put.Obj,473);
        end;
      end else //---------------------------------------- вышли на путь со стороны точки 2
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZv[Put.Obj].ObCB[10] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473);
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //--- ~МИ(ч&н)
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1); //----------- Путь $ замкнут в маневрах
        InsWar(Put.Obj,111);
      end;

      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then //----- занят
      begin
        MarhTrac.TailMsg := ' на занятый путь '+ ObjZv[Put.Obj].Liter;
        MarhTrac.FindTail := false;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,112);
      end;
    end;

    else result := trStop;
  end;

  if (((Con.Pin = 1) and not OddRight)//--------- вышли на точку 1, а  нечетные справа или ...
  or ((Con.Pin = 2) and OddRight)) then //--------- вышли на точку 2, а нечетные слева
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[1] then
        begin //-------------------------------------------- нет нечетных поездных на путь
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);  //----------------------------- Маршрут не существует
        end else
        if ObjZv[Put.Obj].bP[3] or   //------------------------------- нет НИ или ...
        (not ObjZv[Put.Obj].bP[2] and ObjZv[Put.Obj].bP[4]) then //---- ЧИ и ЧКМ
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //----------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
             //------------------------------ если нет маневровых 1->2 или конец в точке 1
        if not ObjZv[Put.Obj].ObCB[3] or ObjZv[Put.Obj].ObCB[10] then
        begin //----------------------- не могут быть нечетные маневровые маршруты на путь
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);  //----------------------------- Маршрут не существует
        end;

        if (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4])//- ЧИ без ЧКМ
        or  //-------------------------------------------------------------------- или ...
        (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15]) //-- НИ без НКМ
        then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //-------------------------- Открыт враждебный сигнал
        end;
      end;
    end;

    if ObjZv[Put.Obj].bP[3] and (ObjZv[Put.Obj].ObCI[4]<>0)
    then //------------------------------------------------ нет НИ, а датчик НИ существует
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,457, ObjZv[Put.Obj].Liter,1); //----------------------- Нет замыкания
      InsMsg(Put.Obj,457);
    end;

    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin //------------------------------------------------- вышли на путь с четной стороны
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[2] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ Маршрут не существует
        end else
        if(ObjZv[Put.Obj].bP[2]) or //---------- если ЧИ или ...
        (not ObjZv[Put.Obj].bP[3] and ObjZv[Put.Obj].bP[15]) then //------------- НИ и НКМ
        begin
          if not ObjZv[Signal].bP[8] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,113); //-------------------- установлен враждебный маршрут
          end;
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Put.Obj].ObCB[4] or ObjZv[Put.Obj].ObCB[11] then
        begin //------------------------------------ нет маневров 1<-2 или конец в точке 2
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ Маршрут не существует
        end;

        if (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15])// НИ без НКМ
        or  //-------------------------------------------------------------------- или ...
        (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4]) then//ЧИ без ЧКМ
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //-------------------------- Открыт враждебный сигнал
        end;
      end;
    end;

    if ObjZv[Put.Obj].bP[2] and (ObjZv[Put.Obj].ObCI[3]<>0)
    then //--------------------------------------------------------- нет ЧИ, а датчик есть
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,457, ObjZv[Put.Obj].Liter,1);
      InsMsg(Put.Obj,457);
    end;
    Con := ObjZv[Put.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutOtmena(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
var
  sosed : integer;
begin
  if Con.Pin = 1 then sosed := 2
  else sosed := 1;

  Con := ObjZv[Put.Obj].Sosed[sosed];
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else result := trNext;
  end;

  if result = trNext then
  begin
    ObjZv[Put.Obj].bP[14] := false;  //------------------------------ прог. замыкание
    ObjZv[Put.Obj].bP[8]  := true;  //---------------------------------------- трасса
    ObjZv[Put.Obj].iP[sosed+1] := 0; //------------------------------ сигнал маршрута
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutRazdel(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
var
  UTS : integer;
begin
  result := trNext;
  UTS := ObjZv[Put.Obj].BasOb;
  if  UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- упор установлен
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,108); //------------------------- Установлен тормозной упор
        end else
        if not ObjZv[UTS].bP[1] and not ObjZv[UTS].bP[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,109);//------- Тормозной упор $ не имеет контроля положения
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZv[Put.Obj].bP[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZv[UTS].bP[27] then
            begin //------------------------------------------- сообщение не зафиксировано
              ObjZv[UTS].bP[27] := true;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,108); //--------------------- Установлен тормозной упор
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,108); //----------------------- Установлен тормозной упор
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Put.Obj].bP[14] or
  not ObjZv[Put.Obj].bP[7] or
  not ObjZv[Put.Obj].bP[11] then //----------- если программное замыкание установлено
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,110, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,110); //--------------------------- Установлено замыкание $ в УВК
  end;

  if ObjZv[Put.Obj].bP[12] or ObjZv[Put.Obj].bP[13] then //- Закрыт для движения
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,135);  //----------------------------- Путь $ закрыт для движения
  end;

  if ObjZv[Put.Obj].ObCB[8] or ObjZv[Put.Obj].ObCB[9] then //--- если любая ЭТ
  begin
    if ObjZv[Put.Obj].bP[24] or ObjZv[Put.Obj].bP[27] then //----- Закрыт для ЭТ
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Put.Obj].Liter,1);
      InsWar(Put.Obj,462);  //----------------- Закрыто движение на электротяге по $
    end else
    if ObjZv[Put.Obj].ObCB[8] and ObjZv[Put.Obj].ObCB[9] then
    begin
      if ObjZv[Put.Obj].bP[25] or ObjZv[Put.Obj].bP[28] then //Закрыт на пост.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,467);// Закрыто движение на электротяге постоянного тока по $
      end;

      if ObjZv[Put.Obj].bP[26] or ObjZv[Put.Obj].bP[29] then //Закрыт для пер.т.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,472); //Закрыто движение на электротяге переменного тока по $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // занят(ч|н)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,112); //--------------------------------------- Путь $ занят#
      end;

      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //--- ~МИ(ч&н)
      begin
        inc(MarhTrac.MsgN);  //-------------------------------- враждебность
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,111);     //----------------------- Путь $ замкнут в маневрах
      end;

      if Con.Pin = 1 then
      begin //------------ проверить конец подвески контакной сети для четного направления
        if ObjZv[Put.Obj].ObCB[11] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473);//------------------------ Конец контактной подвески $
        end;
      end else
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZv[Put.Obj].ObCB[10] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473); //----------------------- Конец контактной подвески $
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then // ~МИ(ч&н)
      begin
        inc(MarhTrac.WarN); //------------------------------- предупреждение
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,111); //--------------------------- Путь $ замкнут в маневрах
      end;

      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // занят(ч|н)
      begin
        MarhTrac.TailMsg := ' на занятый путь '+ ObjZv[Put.Obj].Liter;
        MarhTrac.FindTail := false;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,112);  //--------------------------------------- Путь $ занят
      end;
    end;

    else  result := trStop;
  end;

  if Con.Pin = 1 then    //------------------- вход на путь в точке 1 (с нечетной стороны)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[1] then
        begin //-------------------------------------------- нет нечетных поездных на путь
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);
        end else
        if not(ObjZv[Put.Obj].bP[3] and ObjZv[Put.Obj].bP[2]) //--- НИ или ЧИ
        or  ObjZv[Put.Obj].bP[4] then //------------------------------------- или ЧКМ
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //----------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if (not ObjZv[Put.Obj].ObCB[10]) and (not ObjZv[Put.Obj].ObCB[11]) then
        begin
          if not ObjZv[Put.Obj].ObCB[3] then
          begin //---------------------------------------- нет нечетных маневровых на путь
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,77); //---------------------------- Маршрут не существует
          end;

          if not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4] then//ЧИ без ЧКМ
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,113); //----------- На путь $ установлен враждебный маршрут
          end;

          if not ObjZv[Put.Obj].bP[3] then // -------------------------------------- НИ
          begin
            if ObjZv[Put.Obj].bP[15] then //--------------------------------------- НКМ
            begin
              MarhTrac.TailMsg := ' на замкнутый путь '+ ObjZv[Put.Obj].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,441); //На путь $ установлен встречный маневровый маршрут
            end else
            begin
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
              InsMsg(Put.Obj,113); //--------- На путь $ установлен враждебный маршрут
            end;
          end;
        end;
      end;
    end;
    ObjZv[Put.Obj].bP[8] := false;
    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else    //-------------------------------- вход на путь в точке 2 (с четной стороны)
  begin
    case Rod of
      MarshP : begin
        if not ObjZv[Put.Obj].ObCB[2] then
        begin //---------------------------------------------- нет четных поездных на путь
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //----------------------------- Маршрут не существует
        end else
        if not ObjZv[Put.Obj].bP[2] or  //------------------------------------ ЧИ или
        (not ObjZv[Put.Obj].bP[3]) then //---------------------------------------  НИ
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if(not ObjZv[Put.Obj].ObCB[10]) and (not ObjZv[Put.Obj].ObCB[11]) then
        begin
          if not ObjZv[Put.Obj].ObCB[4] then
          begin //------------------------------------------ нет четных маневровых на путь
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,77); //---------------------------- Маршрут не существует
          end;

          if not ObjZv[Put.Obj].bP[3] and
          not (ObjZv[Put.Obj].bP[15] and ObjZv[Put.Obj].bP[2] and
          ObjZv[Put.Obj].bP[4]) then //---- ЧИ и ЧКМ и НКМ
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,113);  //-------- На путь $ установлен враждебный маршрут
          end;

          if not ObjZv[Put.Obj].bP[2] then //-------------------------------- если ЧИ
          begin
            if ObjZv[Put.Obj].bP[4] then //--------------------------------- если ЧКМ
            begin
              MarhTrac.TailMsg := ' на замкнутый путь '+ ObjZv[Put.Obj].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,441); //На путь установлен встречный маневровый маршрут
            end else
            begin
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
              InsMsg(Put.Obj,113);//-------- На путь $ установлен враждебный маршрут
            end;
          end;
        end;
      end;
    end;

    ObjZv[Put.Obj].bP[8] := false;
    Con := ObjZv[Put.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
var
  UTS : integer;
begin
  result := trNext;
  UTS := ObjZv[Put.Obj].BasOb;
  if  UTS > 0 then
  begin //------------------------------------------------------------------ Проверить УТС
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- упор установлен
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,108); //------------------------- Установлен тормозной упор
        end else
        if not ObjZv[UTS].bP[1] and not ObjZv[UTS].bP[3] then
        begin //--------------------------- упор не имеет контроля положения и не отключен
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,109);//------- Тормозной упор $ не имеет контроля положения
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- упор установлен и не выключен
          if not ObjZv[Put.Obj].bP[1] then
          begin //------------------------------------------------------------- путь занят
            if not ObjZv[UTS].bP[27] then
            begin //------------------------------------------- сообщение не зафиксировано
              ObjZv[UTS].bP[27] := true;
              result := trStop;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,108); //--------------------- Установлен тормозной упор
            end;
          end else
          begin //---------------------------------------------------------- путь свободен
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,108); //----------------------- Установлен тормозной упор
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Put.Obj].bP[14] then //----------------- программное замыкание установлено
  begin
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,110, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,110);  //-------------------------- Установлено замыкание $ в УВК
  end;

  if ObjZv[Put.Obj].bP[12] or ObjZv[Put.Obj].bP[13] then //- Закрыт для движения
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,135); //------------------------------ Путь $ закрыт для движения
  end;

  if ObjZv[Put.Obj].ObCB[8] or ObjZv[Put.Obj].ObCB[9] then
  begin
    if ObjZv[Put.Obj].bP[24] or ObjZv[Put.Obj].bP[27] then //----- Закрыт для ЭТ
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Put.Obj].Liter,1);
      InsWar(Put.Obj,462); //------------------ Закрыто движение на электротяге по $
    end else
    if ObjZv[Put.Obj].ObCB[8] and ObjZv[Put.Obj].ObCB[9] then
    begin
      if ObjZv[Put.Obj].bP[25] or ObjZv[Put.Obj].bP[28] then //- Закрыт пост. ЭТ
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,467); //Закрыто движение на электротяге постоянного тока по $
      end;

      if ObjZv[Put.Obj].bP[26] or ObjZv[Put.Obj].bP[29] then //-- Закрыт пер. ЭТ
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,472); //Закрыто движение на электротяге переменного тока по $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // занят(ч|н)
      begin
        exit;
        {
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,112); //---------------------------------------- Путь $ занят
        }
      end;

      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //---- МИ(ч|н)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,111); //--------------------------- Путь $ замкнут в маневрах
      end;

      if Con.Pin = 1 then
      begin //------------ проверить конец подвески контакной сети для четного направления
        if ObjZv[Put.Obj].ObCB[11] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473); //----------------------- Конец контактной подвески $
        end;
      end else
      begin //---------- проверить конец подвески контакной сети для нечетного направления
        if ObjZv[Put.Obj].ObCB[10] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473);
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //---- МИ(ч|н)
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,111);
      end;

      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // занят(ч|н)
      begin
        MarhTrac.TailMsg := ' на занятый путь '+ ObjZv[Put.Obj].Liter;
        MarhTrac.FindTail := false;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,112); //---------------------------------------- Путь $ занят
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
        if not ObjZv[Put.Obj].ObCB[1] then
        begin //-------------------------------------------- нет нечетных поездных на путь
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);
        end else
        if not ObjZv[Put.Obj].bP[3] or (not ObjZv[Put.Obj].bP[2]
        and ObjZv[Put.Obj].bP[4]) then //---------------------------- НИ или ЧИ с ЧКМ
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Put.Obj].ObCB[3] then
        begin //------------------------------------------ нет нечетных маневровых на путь
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ Маршрут не существует
        end;

        if (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15])// НИ без НКМ
        or//-------------------------------------------------------------------------- или
        (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4]) //--- ЧИ без ЧКМ
        then
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;
    end;

    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else  //------------------------------------------------ вошли со стороны 2 (четное)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[2] then
        begin //---------------------------------------------- нет четных поездных на путь
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ Маршрут не существует
        end else
        if not ObjZv[Put.Obj].bP[2] or //--------------------------------- ЧИ или ...
        (not ObjZv[Put.Obj].bP[3] and ObjZv[Put.Obj].bP[15]) then //--- НИ и НКМ
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Put.Obj].ObCB[4] then
        begin //-------------------------------------------- нет четных маневровых на путь
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ Маршрут не существует
        end;

        if (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4]) // ЧИ без ЧКМ
        or  //------------------------------------------------------------------------ или
        (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15]) //-- НИ без НКМ
        then
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- На путь $ установлен враждебный маршрут
        end;
      end;
    end;

    Con := ObjZv[Put.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutFindIzv(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
begin
  if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then
  begin //--------------------------------------------------------------------- путь занят
    result := trBreak;
    exit;
  end else
  if ObjZv[Put.Obj].bP[2] and ObjZv[Put.Obj].bP[3] then
  begin //----------------------------------------------------- путь не замкнут в маршруте
    if not((MarhTrac.IzvCount = 0) and (MarhTrac.Rod = MarshM)) then
    begin
      result := trStop;
      exit;
    end;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end else
  begin
    Con := ObjZv[Put.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutFindStr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
begin
  if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then
  begin //------------------------------------------------------------------ участок занят
    MarhTrac.IzvStrFUZ := true;
    if MarhTrac.IzvStrNZ then
    begin //------ есть стрелки - сообщить оператору о незамкнутых стрелках перед сигналом
      MarhTrac.IzvStrUZ := true;
      result := trStop;
      exit;
    end;
  end else
  if MarhTrac.IzvStrFUZ then
  begin //участок свободен и была занятость участка перед ним - не выдавать предупреждение
    MarhTrac.IzvStrUZ := false;
    result := trStop;
    exit;
  end;

  if Con.Pin = 1 then
  begin
    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end else
  begin
    Con := ObjZv[Put.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepPutPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Put:TSos) : TTrRes;
begin
  if not ObjZv[Put.Obj].bP[14] and not ObjZv[Put.Obj].bP[7] then
  begin //------------------------------------------------------ разрушена трасса маршрута
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,228, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsMsg(Put.Obj,228); //--------------------------- Трасса маршрута от $ нарушена
    result := trStop;
  end else
  if Con.Pin = 1 then
  begin
    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end else
  begin
    Con := ObjZv[Put.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;
  end;
end;

end.

