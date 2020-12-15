unit MainLoop;
//------------------------------------------------------------------------------
//
//          Цикл обсчета зависимостей РМ-ДСП, АРМ-ШН, просмотр архива
//
//    Версия     1
//    редакция   5
//
//    Последнее изменение от 21 августа 2006 года
//------------------------------------------------------------------------------

{$INCLUDE CfgProject}

interface

uses
  SysUtils,
  Windows,
  Dialogs,
  Forms,
  DateUtils;

procedure SetDateTimeARM(index : SmallInt);

procedure PrepareOZ;
procedure GoOVBuffer(Ptr,Steps : Integer);

procedure DiagnozUVK(Index : SmallInt);
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
function GetState_Manevry_D(Ptr : SmallInt) : Boolean;

procedure PrepXStrelki(Ptr : Integer);
procedure PrepDZStrelki(Ptr : Integer);
procedure PrepStrelka(Ptr : Integer);
procedure PrepOxranStrelka(Ptr : Integer);
procedure PrepSekciya(Ptr : Integer);
procedure PrepPuti(Ptr : Integer);
procedure PrepSvetofor(Ptr : Integer);
procedure PrepRZS(Ptr : Integer);
procedure PrepMagStr(Ptr : Integer);
procedure PrepMagMakS(Ptr : Integer);
procedure PrepAPStr(Ptr : Integer);
procedure PrepPTO(Ptr : Integer);
procedure PrepUTS(Ptr : Integer);
procedure PrepUPer(Ptr : Integer);
procedure PrepKPer(Ptr : Integer);
procedure PrepK2Per(Ptr : Integer);
procedure PrepOM(Ptr : Integer);
procedure PrepUKSPS(Ptr : Integer);
procedure PrepMaket(Ptr : Integer);
procedure PrepOtmen(Ptr : Integer);
procedure PrepGRI(Ptr : Integer);
procedure PrepAB(Ptr : Integer);
procedure PrepVSNAB(Ptr : Integer);
procedure PrepPAB(Ptr : Integer);
procedure PrepDSPP(Ptr : Integer);
procedure PrepPSvetofor(Ptr : Integer);
procedure PrepPriglasit(Ptr : Integer);
procedure PrepNadvig(Ptr : Integer);
procedure PrepMarhNadvig(Ptr : Integer);
procedure PrepMEC(Ptr : Integer);
procedure PrepZapros(Ptr : Integer);
procedure PrepManevry(Ptr : Integer);
procedure PrepSingle(Ptr : Integer);
procedure PrepInside(Ptr : Integer);
procedure PrepPitanie(Ptr : Integer);
procedure PrepSwitch(Ptr : Integer);
procedure PrepIKTUMS(Ptr : Integer);
procedure PrepKRU(Ptr : Integer);
procedure PrepIzvPoezd(Ptr : Integer);
procedure PrepVP(Ptr : Integer);
procedure PrepVPStrelki(Ptr : Integer);
procedure PrepOPI(Ptr : Integer);
procedure PrepSOPI(Ptr : Integer);
procedure PrepSMI(Ptr : Integer);
procedure PrepKNM(Ptr : Integer);
procedure PrepRPO(Ptr : Integer);
procedure PrepAutoSvetofor(Ptr : Integer);
procedure PrepAutoMarshrut(Ptr : Integer);
procedure PrepABTC(Ptr : Integer);
procedure PrepDCSU(Ptr : Integer);
procedure PrepDopDat(Ptr : Integer);
procedure PrepSVMUS(Ptr : Integer);


const
  DiagUVK : SmallInt      = 1; //5120 адрес сообщения о неисправности УВК
  DateTimeSync : SmallInt = 1; //6144 адрес сообщения для синхронизации времени системы
{$IFDEF RMSHN}
  StatStP                 = 5; // количество переводов для вычисления средней длительности перевода стрелки
{$ENDIF}


implementation

uses
  TypeRpc,
  VarStruct,
{$IFDEF RMDSP}
  PipeProc,
{$ENDIF}
{$IFNDEF RMARC}
  KanalArmSrv,
{$ELSE}
  PackArmSrv,
{$ENDIF}
  Marshrut,
{$IFNDEF RMSHN}
  Commands,
{$ENDIF}
{$IFDEF RMSHN}
  ValueList,
  KanalArmDC,
{$ENDIF}

  TabloForm,

  Commons;

var
  s  : string;
  dt : string;
  LiveCounter : integer;

procedure SetDateTimeARM(index : SmallInt);
{$IFNDEF RMARC}
  var uts,lt : TSystemTime; nd,nt : TDateTime; ndt,cdt,delta : Double; time64 : int64; Hr,Mn,Sc,Yr,Mt,Dy : Word; err : boolean; i : integer;
{$ENDIF}
begin
{$IFNDEF RMARC}
try
  if FR8[index] > 0 then
  begin
    time64 := FR8[index];
    err := false;
    Sc := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Mn := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Hr := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Dy := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Mt := time64 and $00000000000000ff;
    time64 := time64 shr 8;
    Yr := (time64 and $00000000000000ff) + 2000;

    if not TryEncodeTime(Hr,Mn,Sc,0,nt) then
    begin
      err := true; InsArcNewMsg(0,507);
      AddFixMessage(GetShortMsg(1,507,'') + 'Попытка установки времени '+ IntToStr(Hr)+':'+ IntToStr(Mn)+':'+ IntToStr(Sc),4,1);
    end;
    if not TryEncodeDate(Yr,Mt,Dy,nd) then
    begin
      err := true; InsArcNewMsg(0,507);
      AddFixMessage(GetShortMsg(1,507,'') + 'Попытка установки даты '+ IntToStr(Yr)+'-'+ IntToStr(Mt)+'-'+ IntToStr(Dy),4,1);
    end;
    if not err then
    begin
      ndt := nd+nt; delta := ndt - LastTime;
      DateTimeToSystemTime(ndt,uts);
      SystemTimeToTzSpecificLocalTime(nil,uts,lt);
      cdt := SystemTimeToDateTime(lt) - ndt;
      ndt := ndt - cdt;
      DateTimeToSystemTime(ndt,uts);
      SetSystemTime(uts);

      for i := 1 to high(FR3s) do // коррекция отметок времени в FR3
        if FR3s[i] > 0.00000001 then FR3s[i] := FR3s[i] - delta;
      for i := 1 to high(FR4s) do // коррекция отметок времени в FR4
        if FR4s[i] > 0.00000001 then FR4s[i] := FR4s[i] - delta;

      for i := 1 to high(ObjZav) do
      begin // коррекция отметок времени в объектах зависимостей
        if ObjZav[i].Timers[1].Active then ObjZav[i].Timers[1].First := ObjZav[i].Timers[1].First - delta;
        if ObjZav[i].Timers[2].Active then ObjZav[i].Timers[2].First := ObjZav[i].Timers[2].First - delta;
        if ObjZav[i].Timers[3].Active then ObjZav[i].Timers[3].First := ObjZav[i].Timers[3].First - delta;
        if ObjZav[i].Timers[4].Active then ObjZav[i].Timers[4].First := ObjZav[i].Timers[4].First - delta;
        if ObjZav[i].Timers[5].Active then ObjZav[i].Timers[5].First := ObjZav[i].Timers[5].First - delta;
      end;
      LastSync := ndt;
      LastTime := ndt;
    end;
    // сбросить параметр
    FR8[index] := 0;
  end;
except
  FR8[index] := 0; reportf('Ошибка [MainLoop.SetDateTimeARM]'); Application.Terminate;
end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// подготовка объектов зависимостей для прорисовки
procedure PrepareOZ;
  var c,Ptr : integer;
  {$IFNDEF RMARC} st : byte; {$ENDIF}
  {$IFDEF RMSHN} i,j,k,cfp : integer; fix,fp,fn : Boolean; {$ENDIF}
begin
try
  // Отработать команду синхронизации времени
  SetDateTimeARM(DateTimeSync);

  // Обработать диагностические сообщения о неисправностях УВК
  if DiagnozON then DiagnozUVK(DiagUVK);
  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;

{$IFNDEF RMARC}
  // копировать буфера FR3,FR4
  if DiagnozON and WorkMode.FixedMsg then
  begin // выполнить проверку непарафазности входных интерфейсов
    for Ptr := 1 to FR_LIMIT do
    begin
      if (Ptr <> WorkMode.DirectStateSoob) and (Ptr <> WorkMode.ServerStateSoob) then
      begin
        st := byte(FR3inp[Ptr]);
        if (st and $20) <> (FR3[Ptr] and $20) then // Проверить изменение признака непарафазности датчиков входного интерфейса
        begin
          if (Ptr <> MYT[1]) and (Ptr <> MYT[2]) and (Ptr <> MYT[3]) and (Ptr <> MYT[4]) and (Ptr <> MYT[5]) and (Ptr <> MYT[6]) and (Ptr <> MYT[7]) and (Ptr <> MYT[8]) and (Ptr <> MYT[9]) then
          begin // если объекты канала не относятся к мифам - фиксировать
            if ((st and $20) = $20) then InsArcNewMsg(Ptr,$3001) else InsArcNewMsg(Ptr,$3002);
          end;
        end;
        FR3[Ptr] := st;
      end;
      if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4[Ptr] := byte(FR4inp[Ptr]) else FR4[Ptr] := 0;
    end;
  end else
  begin // просто переписать входной буфер
{$ENDIF}
    for Ptr := 1 to FR_LIMIT do
    begin
{$IFNDEF RMARC} FR3[Ptr] := byte(FR3inp[Ptr]); {$ENDIF}
      if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4[Ptr] := byte(FR4inp[Ptr]) else FR4[Ptr] := 0;
    end;
{$IFNDEF RMARC}
  end;
  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;

  // сбросить блокировку FR5
  if LastTime > LastDiagD then begin LastDiagN := 0; LastDiagI := 0; end;
{$ENDIF}

  // подготовка состояний перед циклом
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      1  : begin
        ObjZav[Ptr].bParam[5] := false; ObjZav[Ptr].bParam[8] := false;
        ObjZav[Ptr].bParam[10] := false; ObjZav[Ptr].bParam[11] := false;
      end;
      27 : begin
        ObjZav[Ptr].bParam[5] := false; ObjZav[Ptr].bParam[8] := false;
      end;
      41 : begin
        ObjZav[Ptr].bParam[1] := false; ObjZav[Ptr].bParam[8] := false;
        ObjZav[Ptr].bParam[2] := false; ObjZav[Ptr].bParam[9] := false;
        ObjZav[Ptr].bParam[3] := false; ObjZav[Ptr].bParam[10] := false;
        ObjZav[Ptr].bParam[4] := false; ObjZav[Ptr].bParam[11] := false;
      end;
      44 : begin
        ObjZav[Ptr].bParam[1] := false; ObjZav[Ptr].bParam[2] := false;
        ObjZav[Ptr].bParam[5] := false; ObjZav[Ptr].bParam[8] := true;
      end;
      48 : ObjZav[Ptr].bParam[1] := false;
    end;
  end;
  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;

  // подготовка отображения на табло
//  c := 0;
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      3  : PrepSekciya(Ptr);
      4  : PrepPuti(Ptr);
      6  : PrepPTO(Ptr);
      7  : PrepPriglasit(Ptr);
      8  : PrepUTS(Ptr);
      9  : PrepRZS(Ptr);
      10 : PrepUPer(Ptr);
      11 : PrepKPer(Ptr);
      12 : PrepK2Per(Ptr);
      13 : PrepOM(Ptr);
      14 : PrepUKSPS(Ptr);
      15 : PrepAB(Ptr);
      16 : PrepVSNAB(Ptr);
      17 : PrepMagStr(Ptr);
      18 : PrepMagMakS(Ptr);
      19 : PrepAPStr(Ptr);
      20 : PrepMaket(Ptr);
      21 : PrepOtmen(Ptr);
      22 : PrepGRI(Ptr);
      23 : PrepMEC(Ptr);
      24 : PrepZapros(Ptr);
      25 : PrepManevry(Ptr);
      26 : PrepPAB(Ptr);
      //28 -не требует предварительной обработки
      //29 -не требует предварительной обработки
      30 : PrepDSPP(Ptr);
      31 : PrepPSvetofor(Ptr);
      32 : PrepNadvig(Ptr);
      33 : PrepSingle(Ptr);
      34 : PrepPitanie(Ptr);
      35 : PrepInside(Ptr);
      36 : PrepSwitch(Ptr);
      37 : PrepIKTUMS(Ptr);
      38 : PrepMarhNadvig(Ptr);
      39 : PrepKRU(Ptr);
      40 : PrepIzvPoezd(Ptr);
      42 : PrepVP(Ptr);
      43 : PrepOPI(Ptr);
      45 : PrepKNM(Ptr);
      46 : PrepAutoSvetofor(Ptr);
      48 : PrepRPO(Ptr);
      49 : PrepABTC(Ptr);
      50 : PrepDCSU(Ptr);
      51 : PrepDopDat(Ptr);
      52 : PrepSVMUS(Ptr);
      // 53 -не требует предварительной обработки
    end;
//    inc(c); if c > 500 then begin SyncReady; WaitForSingleObject(hWaitKanal,ChTO); c := 0; end;
    if LiveCounter > MaxLiveCtr then begin WaitForSingleObject(hWaitKanal,ChTO); {SyncReady;} LiveCounter := 0; end;
  end;
  // обработка вторичных состояний
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      1  : PrepXStrelki(Ptr);
      5  : PrepSvetofor(Ptr);
    end;
    if LiveCounter > MaxLiveCtr then begin WaitForSingleObject(hWaitKanal,ChTO); {SyncReady;} LiveCounter := 0; end;
  end;
//  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;
  // Вывод на табло охранностей стрелки и др.
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      2  : PrepStrelka(Ptr);
      27 : PrepDZStrelki(Ptr);
      41 : PrepVPStrelki(Ptr);
      43 : PrepSOPI(Ptr);
      47 : PrepAutoMarshrut(Ptr);
    end;
    if LiveCounter > MaxLiveCtr then begin WaitForSingleObject(hWaitKanal,ChTO); {SyncReady;} LiveCounter := 0; end;
  end;
//  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      2  : PrepOxranStrelka(Ptr);
    end;
  end;
//  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;

// Обработка буфера отображения
  c := 0;
  for Ptr := 1 to 2000 do OVBuffer[Ptr].StepOver := false;
  for Ptr := 1 to 2000 do
  begin
    if OVBuffer[Ptr].Steps > 0 then GoOVBuffer(Ptr,OVBuffer[Ptr].Steps);
    inc(c); if c > 999 then begin WaitForSingleObject(hWaitKanal,ChTO); {SyncReady;} c := 0; end;
  end;

// Обработка состояний системы
  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;


{$IFDEF RMARC}
  SrvState := FR3[WorkMode.ServerStateSoob];
{$ENDIF}

// количество рабочих серверов, исправность кнопки выбора управления
  if Config.configKRU = 1 then
  begin // с кнопкой
    if (SrvState and $7) = 0 then
    begin // неисправность кнопки выбора управления
      SrvCount := 1; WorkMode.RUError := true;
    end else
    begin // исправность кнопки выбора управления
      SrvCount := 2; WorkMode.RUError := false;
    end;
    // номер рабочего места
    if SrvState and $30 = $10 then SrvActive := 1 else
    if SrvState and $30 = $20 then SrvActive := 2 else
    if SrvState and $30 = $30 then SrvActive := 3 else
      SrvActive := 0;
  end else
  begin // на сервере
    // количество серверов
    if ((SrvState and $7) = 1) or ((SrvState and $7) = 2) or ((SrvState and $7) = 4) or ((SrvState and $7) = 0) then SrvCount := 1 else
    if (SrvState and $7) = 7 then SrvCount := 3 else SrvCount := 2;
    // номер активного сервера
    if ((LastRcv + MaxTimeOutRecave) > LastTime) then
    begin
      if (SrvState and $30) = $10 then SrvActive := 1 else
      if (SrvState and $30) = $20 then SrvActive := 2 else
      if (SrvState and $30) = $30 then SrvActive := 3 else
        SrvActive := 0;
    end else
      SrvActive := 0;
  end;


// Состояние каналов связи с серверами
  if (KanalSrv[1].Index > 0) or (KanalSrv[1].nPipe <> 'null') then
  begin
    if KanalSrv[1].iserror then ArmSrvCh[1] := 1 else
    if KanalSrv[1].cnterr > 2 then ArmSrvCh[1] := 2 else
    if MySync[1] then ArmSrvCh[1] := 4 else ArmSrvCh[1] := 8;
  end;
  if (KanalSrv[2].Index > 0) or (KanalSrv[2].nPipe <> 'null') then
  begin
    if KanalSrv[2].iserror then ArmSrvCh[2] := 1 else
    if KanalSrv[2].cnterr > 2 then ArmSrvCh[2] := 2 else
    if MySync[2] then ArmSrvCh[2] := 4 else ArmSrvCh[2] := 8;
  end;
{$IFDEF RMSHN}
  if KanalDC[1].Index > 0 then
  begin
    if KanalDC[1].iserror then ArmDCCh[1] := 1 else
    if KanalDC[1].cnterr > 2 then ArmDCCh[1] := 2 else
    if KanalDC[1].active then ArmDCCh[1] := 4 else ArmDCCh[1] := 8;
  end;
  if KanalDC[2].Index > 0 then
  begin
    if KanalDC[2].iserror then ArmDCCh[2] := 1 else
    if KanalDC[2].cnterr > 2 then ArmDCCh[2] := 2 else
    if KanalDC[2].active then ArmDCCh[2] := 4 else ArmDCCh[2] := 8;
  end;
  // обработать события
  for i := 1 to 10 do
  begin
//    SyncReady;
    cfp := 0;
    if FixNotify[i].Enable and (
       (FixNotify[i].Datchik[1] > 0) or
       (FixNotify[i].Datchik[2] > 0) or
       (FixNotify[i].Datchik[3] > 0) or
       (FixNotify[i].Datchik[4] > 0) or
       (FixNotify[i].Datchik[5] > 0) or
       (FixNotify[i].Datchik[6] > 0)
       ) then
      for j := 1 to 6 do
        if FixNotify[i].Datchik[j] > 0 then
        begin
          fp := GetFR3(LinkFR3[FixNotify[i].Datchik[j]].FR3,fn,fn); // получить состояние датчика
          fix := (FixNotify[i].State[j] = fp) and not fn;
          if fix then inc(cfp);
        end;
    if cfp > 0 then
    begin // выдать реакцию на событие
      for k := 1 to 6 do
        if FixNotify[i].Datchik[k] > 0 then dec(cfp);
      if cfp = 0 then
      begin
        if not FixNotify[i].fix then
        begin
          FixNotify[i].beep := true;
          if FixNotify[i].Obj > 0 then
          begin
            ID_ViewObj := FixNotify[i].Obj;
            ValueListDlg.Show;
          end;
        end;
        FixNotify[i].fix := true;
      end else
        FixNotify[i].fix := false;
    end else
      FixNotify[i].fix := false;
  end;
{$ENDIF}
{$IFDEF RMDSP}
  if DspToDspEnabled then
  begin // канал ДСП-ДСП2 включен
    if DspToDspConnected then
    begin
      if DspToDspAdresatEn then
        ArmAsuCh[1] := 2 // полное соединение
      else
        ArmAsuCh[1] := 1; // ожидание подключения дальнего
    end else
      ArmAsuCh[1] := 0; // нет соединения
  end else
  begin // канал ДСП-ДСП2 отключен
    ArmAsuCh[1] := 255;
  end;
{$ENDIF}
except
  reportf('Ошибка [MainLoop.PrepareOZ]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// Сделать шаг по буферу отображения
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
  var oPtr : integer;
begin
try
  oPtr := Ptr;
  case OVBuffer[Ptr].TypeRec of
    0 : begin // вернуться к предидущему узлу
      Ptr := OVBuffer[Ptr].Jmp1;
    end;
    1 : begin // копировать буфер отображения
      OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param;
      Ptr := OVBuffer[Ptr].Jmp1;
    end;
    2 : begin // дублировать буфер отображения
      if OVBuffer[Ptr].StepOver then
      begin
        OVBuffer[OVBuffer[Ptr].Jmp2].Param := OVBuffer[Ptr].Param; Ptr := OVBuffer[Ptr].Jmp2
      end else
      begin
        OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param; Ptr := OVBuffer[Ptr].Jmp1;
      end;
    end;
    3 : begin // Стрелка
      if OVBuffer[Ptr].StepOver then
      begin
        Ptr := OVBuffer[Ptr].Jmp2;
        OVBuffer[Ptr].Param[1] := OVBuffer[oPtr].Param[1];
        OVBuffer[Ptr].Param[11] := OVBuffer[oPtr].Param[11];
        OVBuffer[Ptr].Param[16] := OVBuffer[oPtr].Param[16];
        if not ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then
        begin // ПК нет
          if ObjZav[OVBuffer[oPtr].DZ1].bParam[1] then
          begin // МК есть
            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] else OVBuffer[Ptr].Param[2] := false;
            OVBuffer[Ptr].Param[4] := true;
            OVBuffer[Ptr].Param[8] := true;
          end else
          begin // ПК,МК нет
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2];
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4];
            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];
          end;
          if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3] else OVBuffer[Ptr].Param[3] := true;
          OVBuffer[Ptr].Param[5] := true;
          OVBuffer[Ptr].Param[7] := false;
          OVBuffer[Ptr].Param[10] := false;
        end else
        begin // ПК есть
          OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2];
          OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3];
          OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4];
          if ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then
          begin
            OVBuffer[Ptr].Param[5] := OVBuffer[oPtr].Param[5];
            OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7];
          end else
          begin
            OVBuffer[Ptr].Param[5] := true;
            OVBuffer[Ptr].Param[7] := false;
          end;
          OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];
          OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10];
        end;

        if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then
          OVBuffer[Ptr].Param[10] := false;

        if ObjZav[OVBuffer[oPtr].DZ1].bParam[7] or
          (ObjZav[OVBuffer[oPtr].DZ1].bParam[10] and ObjZav[OVBuffer[oPtr].DZ1].bParam[11]) or ObjZav[OVBuffer[oPtr].DZ1].bParam[13] then
        begin
          OVBuffer[Ptr].Param[6] := OVBuffer[oPtr].Param[6];
        end else
        begin
          OVBuffer[Ptr].Param[6] := true; OVBuffer[Ptr].Param[14] := false;
        end;
      end else
      begin
        Ptr := OVBuffer[Ptr].Jmp1;
        OVBuffer[Ptr].Param[1] := OVBuffer[oPtr].Param[1];
        OVBuffer[Ptr].Param[11] := OVBuffer[oPtr].Param[11];
        OVBuffer[Ptr].Param[16] := OVBuffer[oPtr].Param[16];
        if not ObjZav[OVBuffer[oPtr].DZ1].bParam[1] then
        begin // ПК нет
          if ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then
          begin // МК есть
            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] else OVBuffer[Ptr].Param[2] := false;
            OVBuffer[Ptr].Param[4] := true;
            OVBuffer[Ptr].Param[8] := true;
          end else
          begin // ПК,МК нет
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2];
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4];
            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];
          end;
          if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3] else OVBuffer[Ptr].Param[3] := true;
          OVBuffer[Ptr].Param[5] := true;
          OVBuffer[Ptr].Param[7] := false;
          OVBuffer[Ptr].Param[10] := false;
        end else
        begin // ПК есть
          OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2];
          OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3];
          OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4];
          if ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then
          begin
            OVBuffer[Ptr].Param[5] := OVBuffer[oPtr].Param[5];
            OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7];
          end else
          begin
            OVBuffer[Ptr].Param[5] := true;
            OVBuffer[Ptr].Param[7] := false;
          end;
          OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];
          OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10];
        end;

        if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then
          OVBuffer[Ptr].Param[10] := false;

        if ObjZav[OVBuffer[oPtr].DZ1].bParam[6] or
          (ObjZav[OVBuffer[oPtr].DZ1].bParam[10] and not ObjZav[OVBuffer[oPtr].DZ1].bParam[11]) or ObjZav[OVBuffer[oPtr].DZ1].bParam[12] then
        begin
          OVBuffer[Ptr].Param[6] := OVBuffer[oPtr].Param[6];
        end else
        begin
          OVBuffer[Ptr].Param[6] := true; OVBuffer[Ptr].Param[14] := false;
        end;
      end;
    end;
  end;

  if Ptr = 0 then Step := 0 else dec(Step);
  OVBuffer[oPtr].StepOver := true;
  result := true;
except
  reportf('Ошибка [MainLoop.StepOVBuffer]'); result := false; Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// проход по буферу отображения
procedure GoOVBuffer(Ptr,Steps : Integer);
  var LastStep, cPtr : integer;
begin
try
  LastStep := Steps; cPtr := Ptr;
  while LastStep > 0 do
  begin
    StepOVBuffer(cPtr,LastStep);
  end;
except
  reportf('Ошибка [MainLoop.GoOVBuffer]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// перенести в хвост стрелки признаки программного замыкания (нужно для спаренной)
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
begin
try
  if ObjZav[ptr].bParam[14] then
  begin // если устанавливается замыкание - безусловно записать в хвост
    ObjZav[ObjZav[ptr].BaseObject].bParam[14] := true;
  end else
  begin // если снимается замыкание - проверить условия для спаренной
    if ObjZav[ObjZav[ptr].BaseObject].ObjConstI[9] = 0 then
    begin // одиночная
      ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
    end else
    begin // спаренная
      if ObjZav[ObjZav[ptr].BaseObject].ObjConstI[8] = ptr then
      begin // ближняя стрелка изменила замыкание
        if not ObjZav[ObjZav[ObjZav[ptr].BaseObject].ObjConstI[9]].bParam[14] then
          ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
      end else
      begin // дальняя стрелка изменила замыкание
        if not ObjZav[ObjZav[ObjZav[ptr].BaseObject].ObjConstI[8]].bParam[14] then
          ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.SetPrgZamykFromXStrelka]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Обработка диагностики о неисправностях аппаратуры УВК
procedure DiagnozUVK(Index : SmallInt);
  var u,m,p,o,z,c : cardinal; t : boolean; msg : Integer;
begin
try
  c := FR7[Index];
  if c > 0 then
  begin
    // получить номер стойки
    u := c and $f0000000; u := u shr 28;
    // получить номер контроллера
    m := c and $0c000000; m := m shr 26;
    // получить код платы
    p := c and $03c00000; p := p shr 22;
    t := (c and $02000000) = $02000000; // тип платы (М201-true/М203-false)
    // получить характер отказа
    o := c and $003f0000; o := o shr 16;
    // получить параметр
    z := c and $0000ffff;
    if (u > 0) and (p > 0) and (o > 0) then
    begin
      s := 'УВК'+ IntToStr(u)+
           ' МПСУ'+ IntToStr(m);
      if t then s := s + ' М201' else s := s + ' М203';
      s := s + '.' + IntToStr(p and $7);
      case o of
        1 : begin s := s + ' объединение групп '; msg := 3003; end;
        2 : begin s := s + ' обрыв групп '; msg := 3004; end;
        3 : begin s := s + ' отсутствие "0" '; msg := 3005; end;
        4 : begin s := s + ' отсутствие "1" '; msg := 3006; end;
      else
        s := s + ' код отказа: '; msg := 3007;
      end;
      s := s + '['+ IntToHEX(z,4)+']';
      AddFixMessage('Сообщение диагностики '+ s,4,4);

      DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
      s := dt + ' > '+ s;
      ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
      NewNeisprav := true; SingleBeep4 := true;
      InsArcNewMsg(z{0},msg);
    end else
    begin // Неопределенное сообщение
      InsArcNewMsg(0,508); AddFixMessage(GetShortMsg(1,508,''),4,4);
    end;
    FR7[Index] := 0; // Сбросить обработанное сообщение
  end;
except
  reportf('Ошибка [MainLoop.DiagnozUVK]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Получить РМ из маневровой колонки
function GetState_Manevry_D(Ptr : SmallInt) : Boolean;
begin
try
  // Возвращает состояние РМ&ОИ
  // признак разрешения маневров (без учета нажатия кнопки восприятия маневров на колонке)
  result := ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[4];
except
  reportf('Ошибка [MainLoop.GetState_Manevry_D]'); result := false; Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта хвоста стрелки #1
procedure PrepXStrelki(Ptr : Integer);
  var i,o,p : integer; pk,mk,pks,nps,d,bl : boolean; {$IFDEF RMSHN} dvps : Double; {$ENDIF}
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  pk := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ПК
  mk := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // МК
  nps := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // непостановка стрелки
  pks := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // потеря контроля стрелки

  if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then // непарафазность или отсутствие информации
  begin
{$IFDEF RMSHN}
    if not (pk or mk or pks or ObjZav[Ptr].Timers[1].Active or ObjZav[Ptr].Timers[2].Active) then
    begin
      if ObjZav[Ptr].sbParam[2] then
      begin // фиксируем время потери контроля минусового положения
        ObjZav[Ptr].Timers[2].Active := true; ObjZav[Ptr].Timers[2].First := LastTime;
      end;
      if ObjZav[Ptr].sbParam[1] then
      begin // фиксируем время потери контроля плюсового положения
        ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime;
      end;
    end;
{$ENDIF}
    if pk and mk then begin pk := false; mk := false; end; // сбросить ПК и МК если оба возбуждены
    if ObjZav[Ptr].bParam[25] <> nps then
    begin // получен неперевод стрелки
      if nps then
      begin
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,270+$1000); SingleBeep := true; ObjZav[Ptr].dtParam[2] := LastTime;
          inc(ObjZav[Ptr].siParam[3]); // счетчик непереводов
{$ELSE}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,270+$1000); AddFixMessage(GetShortMsg(1,270,ObjZav[ptr].Liter),4,1);
          end;
{$ENDIF}
        end;
      end;
    end;
    ObjZav[Ptr].bParam[25] := nps;

    d := false;
    o := ObjZav[Ptr].ObjConstI[6];
    if o > 0 then
    begin // проверить передачу на управление в маневровый район 1
      case ObjZav[o].TypeObj of
        25 : d := GetState_Manevry_D(o); // РМ&Д
        44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); // РМ&Д
      end;
    end;
    if not d then
    begin
      o := ObjZav[Ptr].ObjConstI[7];
      if o > 0 then
      begin // проверить передачу на управление в маневровый район 2
      case ObjZav[o].TypeObj of
        25 : d := GetState_Manevry_D(o); // РМ&Д
        44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); // РМ&Д
      end;
      end;
    end;
    if d then ObjZav[Ptr].bParam[24] := true else ObjZav[Ptr].bParam[24] := false;

    if ObjZav[Ptr].bParam[26] <> pks then
    begin // получена потеря контроля стрелки
      if pks then
      begin
{$IFDEF RMSHN}
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].Timers[2].Active := false;
        if WorkMode.FixedMsg and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group] and not d then
        begin
          InsArcNewMsg(Ptr,271+$1000); SingleBeep3 := true; ObjZav[Ptr].dtParam[1] := LastTime;
          if ObjZav[Ptr].sbParam[1] then
          begin
            if ObjZav[Ptr].bParam[22] then
              inc(ObjZav[Ptr].siParam[1]) // счетчик потерь контроля в плюсе
            else
              inc(ObjZav[Ptr].siParam[6]); // счетчик потерь контроля в плюсе при занятости секции
          end;
          if ObjZav[Ptr].sbParam[2] then
          begin
            if ObjZav[Ptr].bParam[22] then
              inc(ObjZav[Ptr].siParam[2]) // счетчик потерь контроля в минусе
            else
              inc(ObjZav[Ptr].siParam[7]); // счетчик потерь контроля в минусе при занятости секции
          end;
        end;
{$ELSE}
        if WorkMode.FixedMsg and not d then
        begin
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,271+$1000); AddFixMessage(GetShortMsg(1,271,ObjZav[ptr].Liter),4,3);
          end;
        end;
{$ENDIF}
      end else
      begin
        if WorkMode.FixedMsg and not d then begin
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,345+$1000); SingleBeep2 := true;
{$ELSE}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,345+$1000); AddFixMessage(GetShortMsg(1,345,ObjZav[ptr].Liter),5,2);
          end;
{$ENDIF}
        end;
      end;
    end;
    ObjZav[Ptr].bParam[26] := pks;
    ObjZav[Ptr].bParam[1] := pk; // ПК
    ObjZav[Ptr].bParam[2] := mk; // МК

{$IFDEF RMSHN}
    if pk then
    begin
      ObjZav[Ptr].Timers[1].Active := false;
      if ObjZav[Ptr].Timers[2].Active then
      begin // фиксируем длительность перевода в плюс
        ObjZav[Ptr].Timers[2].Active := false;
        dvps := LastTime - ObjZav[Ptr].Timers[2].First;
        if dvps > 1/86400 then
        begin
          if ObjZav[Ptr].siParam[4] > StatStP then
          begin
            dvps := (ObjZav[Ptr].dtParam[3] * StatStP + dvps)/(StatStP+1);
          end else
          begin
            dvps := (ObjZav[Ptr].dtParam[3] * ObjZav[Ptr].siParam[4] + dvps)/(ObjZav[Ptr].siParam[4]+1);
          end;
          ObjZav[Ptr].dtParam[3] := dvps;
        end;
      end;
      if not ObjZav[Ptr].sbParam[1] then
      begin // история ПК
        ObjZav[Ptr].sbParam[1] := pk; ObjZav[Ptr].sbParam[2] := mk; if not StartRM then inc(ObjZav[Ptr].siParam[4]);
      end;
    end;
    if mk then
    begin
      ObjZav[Ptr].Timers[2].Active := false;
      if ObjZav[Ptr].Timers[1].Active then
      begin // фиксируем длительность перевода в минус
        ObjZav[Ptr].Timers[1].Active := false;
        dvps := LastTime - ObjZav[Ptr].Timers[1].First;
        if dvps > 1/86400 then
        begin
          if ObjZav[Ptr].siParam[5] > StatStP then
          begin
            dvps := (ObjZav[Ptr].dtParam[4] * StatStP + dvps)/(StatStP+1);
          end else
          begin
            dvps := (ObjZav[Ptr].dtParam[4] * ObjZav[Ptr].siParam[5] + dvps)/(ObjZav[Ptr].siParam[5]+1);
          end;
          ObjZav[Ptr].dtParam[4] := dvps;
        end;
      end;
      if not ObjZav[Ptr].sbParam[2] then
      begin // история МК
        ObjZav[Ptr].sbParam[1] := pk; ObjZav[Ptr].sbParam[2] := mk; if not StartRM then inc(ObjZav[Ptr].siParam[5]);
      end;
    end;
{$ENDIF}

    if ObjZav[Ptr].ObjConstB[3] then
    begin // сбор МСП из СП
      o := ObjZav[Ptr].ObjConstI[8];
      p := ObjZav[Ptr].ObjConstI[9];
      if ObjZav[o].ObjConstB[9] then ObjZav[Ptr].bParam[20] := ObjZav[ObjZav[o].UpdateObject].bParam[4];
      if (p > 0) and ObjZav[p].ObjConstB[9] then
        if ObjZav[Ptr].bParam[20] then ObjZav[Ptr].bParam[20] := ObjZav[ObjZav[p].UpdateObject].bParam[4];
    end else ObjZav[Ptr].bParam[20] := true;
    // сбор замыканий из СП
    d := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[8]].UpdateObject].bParam[2];
    if ObjZav[Ptr].ObjConstI[9] > 0 then if d then d := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[9]].UpdateObject].bParam[2];
    if d <> ObjZav[Ptr].bParam[21] then
    begin // изменилось замыкание секций
      ObjZav[Ptr].bParam[6] := false; ObjZav[Ptr].bParam[7] := false; // сброс признаков ПУ и МУ
    // перенести в признак активизации автовозврата
      bl := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[8]].UpdateObject].bParam[20]; // блокировка ближней
      if ObjZav[Ptr].ObjConstI[9] > 0 then if not bl then bl := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[9]].UpdateObject].bParam[20]; // блокировка дальней
      ObjZav[Ptr].bParam[3] := d and not bl and ObjZav[Ptr].ObjConstB[2] and (not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2]);
    end;
    ObjZav[Ptr].bParam[21] := d;
    // сбор занятости из СП
    ObjZav[Ptr].bParam[22] := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[8]].UpdateObject].bParam[1];
    if ObjZav[Ptr].ObjConstI[9] > 0 then
      if ObjZav[Ptr].bParam[22] then ObjZav[Ptr].bParam[22] := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[9]].UpdateObject].bParam[1];

    // Сброс признаков трассировки
    ObjZav[Ptr].bParam[23] := false;
    inc(LiveCounter);

    // проверка передачи на местное управление
    ObjZav[Ptr].bParam[9] := false;
    for i := 20 to 24 do
      if ObjZav[Ptr].ObjConstI[i] > 0 then
      begin
        case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
          25 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);
          44 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
        end;
      end;
    // Проверка ручного замыкания
    ObjZav[Ptr].bParam[4] := false;
    if ObjZav[Ptr].ObjConstI[12] > 0 then
    begin
      if ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[1] or ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[2] or ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[3] then
        ObjZav[Ptr].bParam[4] := true;
    end;

    if ObjZav[Ptr].bParam[21] then
    begin
      if not ObjZav[Ptr].bParam[4] then
      // проверки двойного управления
        for i := 6 to 7 do
        begin
          o := ObjZav[Ptr].ObjConstI[i];
          if o > 0 then
          begin
            case ObjZav[o].TypeObj of
              25 : begin
                if not ObjZav[o].bParam[3] then
                begin // МИ
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
              44 : begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // МИ
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
            end;
          end;
        end;

      // проверки маневров
        for i := 20 to 24 do
        begin
          o := ObjZav[Ptr].ObjConstI[i];
          if o > 0 then
          begin
            case ObjZav[o].TypeObj of
              25 : begin
                if not ObjZav[o].bParam[3] then
                begin // МИ
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
              44 : begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // МИ
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
            end;
          end;
        end;

      if not ObjZav[Ptr].bParam[4] then
      // проверки хвоста стрелки
        for i := 14 to 19 do
        begin
          o := ObjZav[Ptr].ObjConstI[i];
          if o > 0 then
          begin
            case ObjZav[O].TypeObj of

              3 : begin // секция
                if not ObjZav[o].bParam[2] then
                begin
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //3

              25 : begin // маневровая колонка
                if not ObjZav[o].bParam[3] then
                begin // МИ
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //25

              27 : begin // охранная стрелка
                if not ObjZav[ObjZav[o].ObjConstI[2]].bParam[2] then
                begin
                  if ObjZav[o].ObjConstB[1] then
                  begin
                    if not ObjZav[ObjZav[o].ObjConstI[1]].bParam[2] then
                    begin
                      ObjZav[Ptr].bParam[4] := true; break;
                    end;
                  end else
                  if ObjZav[o].ObjConstB[2] then
                  begin
                    if not ObjZav[ObjZav[o].ObjConstI[1]].bParam[1] then
                    begin
                      ObjZav[Ptr].bParam[4] := true; break;
                    end;
                  end;
                end else
              end; //27

              41 : begin // охранность стрелки в пути для маршрутов отправления
                if ObjZav[o].bParam[20] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
                begin
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //41

              46 : begin // автодействие сигналов
                if ObjZav[o].bParam[1] then
                begin // включено автодействие
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //46

            end; //case
          end;
        end; // for

      if not ObjZav[Ptr].bParam[4] and (ObjZav[Ptr].ObjConstI[8] > 0) then // проверки замыкания через стык
      // ближняя стрелка
        if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[7]) then // проверка отводящего положения стрелок
        begin //по плюсовому примыканию
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // стрелка
                case p of
                  2 : begin // Вход по плюсу
                    if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                  end;
                  3 : begin // Вход по минусу
                    if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ошибка в базе данных
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                end;
              3,4 : begin // участок,путь
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // состояние замыкающего реле
                break;
              end;
            else
              if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
              else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
            end;
            if (o = 0) or (p < 1) then break;
            dec(i);
          end;
        end;

      if not ObjZav[Ptr].bParam[4] and (ObjZav[Ptr].ObjConstI[8] > 0) then
        if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[8]) then // проверка отводящего положения стрелок
        begin //по минусовому примыканию
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // стрелка
                case p of
                  2 : begin // Вход по плюсу
                    if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                  end;
                  3 : begin // Вход по минусу
                    if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ошибка в базе данных
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
              end;
              3,4 : begin // участок,путь
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // состояние замыкающего реле
                break;
              end;
            else
              if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
              else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
            end;
            if (o = 0) or (p < 1) then break;
            dec(i);
          end;
        end;


      if not ObjZav[Ptr].bParam[4] and (ObjZav[Ptr].ObjConstI[9] > 0) then
      // дальняя стрелка
        if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[7]) then // проверка отводящего положения стрелок
        begin //по плюсовому примыканию
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // стрелка
                case p of
                  2 : begin // Вход по плюсу
                    if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                  end;
                  3 : begin // Вход по минусу
                    if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ошибка в базе данных
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
              end;
              3,4 : begin // участок,путь
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // состояние замыкающего реле
                break;
              end;
            else
              if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
              else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
            end;
            if (o = 0) or (p < 1) then break;
            dec(i);
          end;
        end;

      if not ObjZav[Ptr].bParam[4] and (ObjZav[Ptr].ObjConstI[9] > 0) then
        if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[8]) then // проверка отводящего положения стрелок
        begin //по минусовому примыканию
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // стрелка
                case p of
                  2 : begin // Вход по плюсу
                    if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                  end;
                  3 : begin // Вход по минусу
                    if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ошибка в базе данных
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
              end;
              3,4 : begin // участок,путь
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // состояние замыкающего реле
                break;
              end;
            else
              if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
              else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
            end;
            if (o = 0) or (p < 1) then break;
            dec(i);
          end;
       end;
     end;
{$IFDEF RMDSP}
    // проверка условий автовозврата
    if ObjZav[Ptr].ObjConstB[2] then
    begin
      inc(LiveCounter);
      if ObjZav[Ptr].bParam[3] then
      begin
        ObjZav[Ptr].bParam[3] := false;
        if StartRM then
        begin // блокировать автовозврат при запуске АРМа
           ObjZav[Ptr].Timers[1].Active := false;
        end else
      // проверить наличие контроля минусового положения стрелки
        if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] and WorkMode.Upravlenie and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group] then
        begin // возбудить признак активизации проверки автовозврата
          ObjZav[Ptr].bParam[12] := true; ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
        end;
      end else

      // проверить допустимость выдачи команды автовозврата
      if ObjZav[Ptr].bParam[12] and
         not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] and // стрелка имеет контроль минусового положения
         not ObjZav[Ptr].bParam[4] and not ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[14] and // стрелка охранная или трассируется
         not ObjZav[Ptr].bParam[18] and not ObjZav[Ptr].bParam[19] and // стрелка выключена или макет
         ObjZav[Ptr].bParam[20] and ObjZav[Ptr].bParam[21] and ObjZav[Ptr].bParam[22] and not ObjZav[Ptr].bParam[23] and // нет замыкания, занятости и МСП
         not ObjZav[Ptr].bParam[9] and not ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[24] then // нет местного управления
      begin
        if ObjZav[ObjZav[Ptr].ObjConstI[10]].bParam[3] then
        begin // зафиксирована авария питания рельсовых цепей - сбросить признак активизации автовозврата
          ObjZav[Ptr].bParam[12] := false; ObjZav[Ptr].Timers[1].Active := false;
        end else
        begin // исправно питание рельсовых цепей
          d := not ObjZav[Ptr].bParam[19]; // макет
          if d then d := not ObjZav[Ptr].bParam[15]; // макет FR4
          if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[18]; // выключение из "С"
          if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[10] and
                         not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[12] and // нет трассировки маршрута через стрелку
                         not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[13];
          if ObjZav[Ptr].ObjConstI[9] > 0 then
          begin
            if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[18]; // выключение из "С"
            if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[10] and
                           not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[12] and // нет трассировки маршрута через стрелку
                           not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[13];
          end;
          if d and ObjZav[Ptr].Timers[1].Active and (ObjZav[Ptr].Timers[1].First < LastTime) then
          begin
            if (CmdCnt = 0) and not WorkMode.OtvKom and not WorkMode.VspStr and not WorkMode.GoMaketSt and
               WorkMode.Upravlenie and not WorkMode.LockCmd and not WorkMode.CmdReady and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group] then
            begin // есть признак активизации автовозврата и нет ожидающих команд в буфере
              ObjZav[Ptr].bParam[12] := false; ObjZav[Ptr].Timers[1].Active := false;
              if SendCommandToSrv(ObjZav[Ptr].ObjConstI[2] div 8, cmdfr3_strautorun,Ptr) then
                AddFixMessage(GetShortMsg(1,418, ObjZav[Ptr].Liter),5,5);
            end;
          end;
        end;
      end;
    end else
    begin // не фиксируется размыкание стрелочной секции если нет признака автовозврата стрелки
      ObjZav[Ptr].bParam[3] := false; ObjZav[Ptr].bParam[12] := false; ObjZav[Ptr].Timers[1].Active := false;
    end;
{$ENDIF}
  end else
  begin // потерять контроль при отсутствии информации
    ObjZav[Ptr].bParam[1] := false; ObjZav[Ptr].bParam[2] := false; ObjZav[Ptr].bParam[3] := false;
{$IFDEF RMSHN}
    ObjZav[Ptr].bParam[19] := false;
{$ENDIF}
  end;

  {FR4}
  // выключено управление
  ObjZav[Ptr].bParam[18] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-5);
  // макет
  ObjZav[Ptr].bParam[15] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-4);
  // закрыта для движения
  ObjZav[Ptr].bParam[17] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-3);
  ObjZav[Ptr].bParam[16] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-2);
  // закрыта для противошерстного движения
  ObjZav[Ptr].bParam[34] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-1);
  ObjZav[Ptr].bParam[33] := GetFR4State(ObjZav[Ptr].ObjConstI[1]);
except
  reportf('Ошибка [MainLoop.PrepXStrelki]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// Подготовка объекта охранности стрелок для вывода на табло
procedure PrepDZStrelki(Ptr : Integer);
  var o : integer;
begin
try
  inc(LiveCounter);
  if ObjZav[Ptr].ObjConstI[3] > 0 then
  begin // Обработать состояние охранной стрелки
    o := ObjZav[Ptr].ObjConstI[1]; // Индекс стрелки, нажодящейся на трассировке
    if o > 0 then
    begin
    // Трассировка маршрута через описание охранности
      if ObjZav[o].bParam[14] then
      begin
        ObjZav[Ptr].bParam[23] := true; // установить предварительное замыкание охранной стрелки
        if ObjZav[Ptr].ObjConstB[1] then // контролируемая трассируется в плюсе
        begin
          if ObjZav[o].bParam[6] then // ПУ
          begin
            if  (not ObjZav[o].bParam[11] or ObjZav[o].bParam[12]) then
            begin
              if ObjZav[Ptr].ObjConstB[3] then // Охранная должна быть в плюсе
              begin
                if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[1] then ObjZav[Ptr].bParam[8] := true;
              end else
              if ObjZav[Ptr].ObjConstB[4] then // Охранная должна быть в минусе
              begin
                if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[2] then ObjZav[Ptr].bParam[8] := true;
              end;
            end;
          end;
        end else
        if ObjZav[Ptr].ObjConstB[2] then // контролируемая трассируется в минусе
        begin
          if ObjZav[o].bParam[7] then // МУ
          begin
            if ObjZav[Ptr].ObjConstB[3] then // Охранная должна быть в плюсе
            begin
              if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[1] then ObjZav[Ptr].bParam[8] := true;
            end else
            if ObjZav[Ptr].ObjConstB[4] then // Охранная должна быть в минусе
            begin
              if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[2] then ObjZav[Ptr].bParam[8] := true;
            end;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[23] := false; // нет предварительного замыкания охранной стрелки

      if not ObjZav[Ptr].bParam[8] then
      begin
      // Трассировка маршрута черех описание охранности
        if ObjZav[Ptr].ObjConstB[1] then // контролируемая трассируется в плюсе
        begin
          if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or ObjZav[o].bParam[12]) then
            ObjZav[Ptr].bParam[5] := true;
        end else
        if ObjZav[Ptr].ObjConstB[2] then // контролируемая трассируется в минусе
        begin
          if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or ObjZav[o].bParam[13]) then
            ObjZav[Ptr].bParam[5] := true;
        end;
      end;
    end;

    o := ObjZav[Ptr].ObjConstI[3]; // Индекс охранной стрелки
    if not ObjZav[ObjZav[o].BaseObject].bParam[5] then
      ObjZav[ObjZav[o].BaseObject].bParam[5] := ObjZav[Ptr].bParam[5];
    if not ObjZav[ObjZav[o].BaseObject].bParam[8] then
      ObjZav[ObjZav[o].BaseObject].bParam[8] := ObjZav[Ptr].bParam[8];
    if not ObjZav[ObjZav[o].BaseObject].bParam[23] then
      ObjZav[ObjZav[o].BaseObject].bParam[23] := ObjZav[Ptr].bParam[23];
  end;
except
  reportf('Ошибка [MainLoop.PrepDZStrelki]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта стрелки для вывода на табло
procedure PrepOxranStrelka(Ptr : Integer);
  var o,p : Integer;
begin
try
  inc(LiveCounter);
  // Проверка принадлежности стрелки к трассе маршрута
  if ObjZav[Ptr].bParam[10] or ObjZav[Ptr].bParam[11] or ObjZav[Ptr].bParam[12] or ObjZav[Ptr].bParam[13] then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := false;
    exit;
  end else
  begin
    if ObjZav[ObjZav[Ptr].BaseObject].bParam[5] = false then
    begin
      o := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[8];
      p := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[9];
      if (p > 0) and (p <> Ptr) then
      begin
        if (ObjZav[p].bParam[10] or ObjZav[p].bParam[11] or ObjZav[p].bParam[12] or ObjZav[p].bParam[13]) then
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
        else
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
      end else
      if (o > 0) and (o <> Ptr) then
      begin
        if (ObjZav[o].bParam[10] or ObjZav[o].bParam[11] or ObjZav[o].bParam[12] or ObjZav[o].bParam[13]) then
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
        else
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
      end else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false; // требование перевода охранной
    end else
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true;
  end;

  // Подсветка ожидания перевода стрелок, не входящих в трассу маршрута
  if ObjZav[ObjZav[Ptr].BaseObject].bParam[14] then
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := false
  else
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[ObjZav[Ptr].BaseObject].bParam[8];
except
  reportf('Ошибка [MainLoop.PrepOxranStrelka]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта стрелки для вывода на табло #2
procedure PrepStrelka(Ptr : Integer);
  var i,o,p : integer;
begin
try
  inc(LiveCounter);
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[ObjZav[Ptr].BaseObject].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[32];
    ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[1]; // ПК
    ObjZav[Ptr].bParam[2] := ObjZav[ObjZav[Ptr].BaseObject].bParam[2]; // МК
    ObjZav[Ptr].bParam[4] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4]; // Замыкание хвоста
    if ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] then // Отображение замыкания хвоста стрелки
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := false;

    if not ObjZav[ObjZav[Ptr].BaseObject].bParam[31] or ObjZav[ObjZav[Ptr].BaseObject].bParam[32] then
    begin // При отсутствии информации или непарафазности сбросить признаки охранного положения
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
    end else
    begin
    // скопировать признак разрешения маневров из хвоста стрелки
      ObjZav[Ptr].bParam[9] := ObjZav[ObjZav[Ptr].BaseObject].bParam[9];

      if ({$IFDEF RMDSP}(ObjZav[Ptr].BaseObject = maket_strelki_index) or {$ENDIF} ObjZav[ObjZav[Ptr].BaseObject].bParam[24]) and not WorkMode.Podsvet then
      begin // включен макет стрелки или местное управление - не рисовать остряки стрелки
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
      end else
      begin
        if ObjZav[Ptr].bParam[1] then
        begin
          if ObjZav[Ptr].bParam[2] then
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin // есть плюс
            ObjZav[Ptr].bParam[20] := true; ObjZav[Ptr].bParam[21] := false; ObjZav[Ptr].bParam[22] := false; ObjZav[Ptr].bParam[23] := false; // установить признак последнего контроля в плюсе
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end;
        end else
        if ObjZav[Ptr].bParam[2] then
        begin // есть минус
          ObjZav[Ptr].bParam[20] := false; ObjZav[Ptr].bParam[21] := true; ObjZav[Ptr].bParam[22] := false; ObjZav[Ptr].bParam[23] := false; // установить признак последнего контроля в минусе
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
        end else
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
        end;
      end;

      // проверить выдержку времени МСП(Д)
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].ObjConstB[9] and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[4] and ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] and ObjZav[ObjZav[Ptr].UpdateObject].bParam[2];

      // собрать Вз стрелки
      ObjZav[Ptr].bParam[3] := ObjZav[ObjZav[Ptr].UpdateObject].bParam[5]; // МИ из секции
      inc(LiveCounter);
      // проверить охранности для стрелки
      for i := 1 to 10 do
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
            27 : begin // охранное положение стрелки
              if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstB[1] then
              begin
                if ObjZav[Ptr].bParam[1] then
                begin
                  o := ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[3];
                  if o > 0 then
                  begin
                    if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstB[3] then
                    begin
                      if ObjZav[o].bParam[1] = false then
                      begin
                        ObjZav[Ptr].bParam[3] := false; break;
                      end;
                    end else
                    if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstB[4] then
                    begin
                      if ObjZav[o].bParam[2] = false then
                      begin
                        ObjZav[Ptr].bParam[3] := false; break;
                      end;
                    end;
                  end;
                end;
              end else
              if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstB[2] then
              begin
                if ObjZav[Ptr].bParam[2] then
                begin
                  o := ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[3];
                  if o > 0 then
                  begin
                    if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstB[3] then
                    begin
                      if ObjZav[o].bParam[1] = false then
                      begin
                        ObjZav[Ptr].bParam[3] := false; break;
                      end;
                    end else
                    if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstB[4] then
                    begin
                      if ObjZav[o].bParam[2] = false then
                      begin
                        ObjZav[Ptr].bParam[3] := false; break;
                      end;
                    end;
                  end;
                end;
              end;
            end; // 27

            6 : begin // Ограждение пути
              for p := 14 to 17 do
              begin
                if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[p] = Ptr then
                begin
                  o := ObjZav[Ptr].ObjConstI[i];
                  if ObjZav[o].bParam[2] then
                  begin
                    if ObjZav[Ptr].bParam[1] then
                    begin
                      if not ObjZav[o].ObjConstB[p*2-27] then
                      begin
                        ObjZav[Ptr].bParam[3] := false; break;
                      end;
                    end else
                    if ObjZav[Ptr].bParam[2] then
                    begin
                      if not ObjZav[o].ObjConstB[p*2-26] then
                      begin
                        ObjZav[Ptr].bParam[3] := false; break;
                      end;
                    end;
                  end;
                end;
              end;
            end; //6

          end; //case
        end;

      // Проверка негабаритности
      if ObjZav[Ptr].bParam[3] then
      begin
        inc(LiveCounter);
      // Искать негабаритность через стык и отведенное положение стрелок
        if ObjZav[Ptr].bParam[1] then
        begin
          if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or // негабаритный стык
             (ObjZav[Ptr].ObjConstB[8]) then                // или проверка отводящего положения стрелок
          begin //по минусовому примыканию
            o := ObjZav[Ptr].Neighbour[3].Obj; p := ObjZav[Ptr].Neighbour[3].Pin; i := 100;
            while i > 0 do
            begin
              case ObjZav[o].TypeObj of
                2 : begin // стрелка
                  case p of
                    2 : begin // Вход по плюсу
                      if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                    end;
                    3 : begin // Вход по минусу
                      if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                    end;
                  else
                    ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
                  end;
                  p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                end;
                3,4 : begin // участок,путь
                  if ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg then
                    ObjZav[Ptr].bParam[3] := ObjZav[o].bParam[1] // состояние путевого датчика
                  else
                    ObjZav[Ptr].bParam[3] := false;
                  break;
                end;
              else
                if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
              end;
              if (o = 0) or (p < 1) then break;
              dec(i);
            end;
          end;
        end else
        if ObjZav[Ptr].bParam[2] then
        begin
          if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or // негабаритный стык
             (ObjZav[Ptr].ObjConstB[7]) then                // или проверка отводящего положения стрелок
          begin //по плюсовому примыканию
            o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin; i := 100;
            while i > 0 do
            begin
              case ObjZav[o].TypeObj of
                2 : begin // стрелка
                  case p of
                    2 : begin // Вход по плюсу
                      if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
                    end;
                    3 : begin // Вход по минусу
                      if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
                    end;
                  else
                    ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
                  end;
                  p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                end;
                3,4 : begin // участок,путь
                  if ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg then
                    ObjZav[Ptr].bParam[3] := ObjZav[o].bParam[1] // состояние путевого датчика
                  else
                    ObjZav[Ptr].bParam[3] := false;
                  break;
                end;
              else
                if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
              end;
              if (o = 0) or (p < 1) then break;
              dec(i);
            end;
          end;
        end;
      end;

      // проверка охранного положения сбрасывающей
      if ObjZav[ObjZav[Ptr].BaseObject].ObjConstB[1] then
      begin
        inc(LiveCounter);
        if ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[2] then
        begin // есть контроль охранного положения
          ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false; // сбросить фиксацию времени вывода стрелки из охранного положения
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := true;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
        end else
        begin
          if not ObjZav[ObjZav[Ptr].BaseObject].bParam[21] then
          begin // стрелка замкнута в маршруте
            ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false; // сбросить фиксацию времени вывода стрелки из охранного положения
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
          end else
          if not ObjZav[ObjZav[Ptr].BaseObject].bParam[20] or
             not ObjZav[ObjZav[Ptr].BaseObject].bParam[22] then
          begin // выдержка времени МСП или занятость стрелки
            ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false; // сбросить фиксацию времени вывода стрелки из охранного положения
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true;
          end else
          begin // выведена из охранного положения
            if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
            begin
              if ObjZav[Ptr].Timers[1].Active then
              begin // вывести признак отсутствия охранного положения длительное время
                if LastTime >= ObjZav[Ptr].Timers[1].First then
                begin
                  if (ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[8] = Ptr) and not ObjZav[Ptr].bParam[19] and
                     not ObjZav[Ptr].bParam[18] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[18] and // Колпачек
                     not ObjZav[ObjZav[Ptr].BaseObject].bParam[15] then // макет
                  begin
{$IFDEF RMDSP}
                    if WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group] and (ObjZav[Ptr].RU = config.ru) then // выдать сообщение если включено управление стрелкой с АРМа
                    begin
                      AddFixMessage(GetShortMsg(1,477,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,3); InsArcNewMsg(ObjZav[Ptr].BaseObject,477);
                    end;
{$ELSE}
                    InsArcNewMsg(ObjZav[Ptr].BaseObject,477);
{$ENDIF}
                  end;
                  ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[19] := true;
                end;
              end else
              begin // зафиксировать время вывода стрелки из охранного положения
                ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime + 0.000694;// 1 минута
              end;
            end else // нет контроля - сброс мигалки
            begin
              ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false;
            end;

            if ObjZav[Ptr].bParam[19] and
               not ObjZav[Ptr].bParam[18] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[18] and // Колпачек
               not ObjZav[ObjZav[Ptr].BaseObject].bParam[15] and // макет
               WorkMode.Upravlenie then
            begin // мигать
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := tab_page;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
            end else
            begin // не мигать
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := true;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
            end;
          end;
        end;
      end;

      // Аварийный перевод стрелки
      if ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[13] > 0 then
      begin
        if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[13]].bParam[1] then
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := true
        else
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false;
      end;

      // Снять предварительное замыкание по исполнительному замыканию стрелочной секции или PM или МИ
      if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] or ObjZav[ObjZav[Ptr].UpdateObject].bParam[9] or not ObjZav[ObjZav[Ptr].UpdateObject].bParam[5] then
      begin
        ObjZav[Ptr].bParam[14] := false;
        ObjZav[Ptr].bParam[6]  := false;
        ObjZav[Ptr].bParam[7]  := false;
        ObjZav[Ptr].bParam[10] := false;
        ObjZav[Ptr].bParam[11] := false;
        ObjZav[Ptr].bParam[12] := false;
        ObjZav[Ptr].bParam[13] := false;
        SetPrgZamykFromXStrelka(Ptr);
      end;

      if not WorkMode.Podsvet and
         (ObjZav[ObjZav[Ptr].BaseObject].bParam[15] or  // Макет из Fr4
{$IFDEF RMSHN} ObjZav[ObjZav[Ptr].BaseObject].bParam[19] or {$ENDIF} // Макет из объекта
          ObjZav[ObjZav[Ptr].BaseObject].bParam[24]) then // стрелка двойного управления передана в маневровый район
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := true
      else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := false;
    end;

    //FR4
    if ObjZav[Ptr].ObjConstB[6] then
    begin // ближняя
      // закрыт для движения
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[16] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[16];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[16];
      // закрыт для противошерстного движения
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[17] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[ObjZav[Ptr].BaseObject].bParam[33];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[ObjZav[Ptr].BaseObject].bParam[33];
    end else
    begin // дальняя
      // закрыт для движения
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[16] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[17];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[17];
      // закрыт для противошерстного движения
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[17] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[ObjZav[Ptr].BaseObject].bParam[34];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[ObjZav[Ptr].BaseObject].bParam[34];
    end;
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // макет
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[ObjZav[Ptr].BaseObject].bParam[19] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[ObjZav[Ptr].BaseObject].bParam[15];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[ObjZav[Ptr].BaseObject].bParam[15];
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // выключено управление
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[18] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[ObjZav[Ptr].BaseObject].bParam[18];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[ObjZav[Ptr].BaseObject].bParam[18];
  end;
except
  reportf('Ошибка [MainLoop.PrepStrelka]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта секции для вывода на табло #3
procedure PrepSekciya(Ptr : Integer);
  var p,msp,z,mi,ri : boolean; i : integer; sost : byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  p := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // П
  z := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // замыкание
  ri := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // РИ
  msp := not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // МСП
  mi := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // МИ
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // предв РИ
  ObjZav[Ptr].bParam[7] := not GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // предв замык

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if (ObjZav[Ptr].ObjConstI[8] > 0) and (ObjZav[Ptr].ObjConstI[9] > 0) then
      begin // вести счет времени если есть таймер МСП(Д)
        if p <> ObjZav[Ptr].bParam[1] then
        begin // Зафиксировать изменение путевого реле
          if p then
          begin // освобождение участка
            if msp then
            begin // возбужден МСП(Д)
              ObjZav[Ptr].Timers[1].Active := false; // сброс счетчика МСП(Д)
            end else
            begin // обесточен МСП(Д)
              if not ObjZav[Ptr].Timers[1].Active then
              begin // начать отсчет времени
                ObjZav[Ptr].Timers[1].First := LastTime; ObjZav[Ptr].Timers[1].Active := true;
              end;
            end;
          end else
          begin // занятие участка
            ObjZav[Ptr].Timers[1].Active := false; // сброс счетчика МСП(Д)
          end;
        end;
        if msp <> ObjZav[Ptr].bParam[4] then
        begin // Зафиксировать изменение МСП
          if msp then
          begin // возбужден МСП(Д)
{$IFDEF RMSHN}
            if ObjZav[Ptr].Timers[1].Active then ObjZav[Ptr].dtParam[3] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
            ObjZav[Ptr].Timers[1].Active := false; // сброс счетчика МСП(Д)
          end;
        end;
      end;

      ObjZav[Ptr].bParam[1] := p; ObjZav[Ptr].bParam[4] := msp;

      if ObjZav[Ptr].ObjConstI[9] > 0 then
      begin
        if ObjZav[Ptr].Timers[1].Active then
        begin // выдать значение временного интервала
          Timer[ObjZav[Ptr].ObjConstI[9]] := 1 + Round((LastTime - ObjZav[Ptr].Timers[1].First) * 86400);
        end else
        begin // скрыть таймер
          Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
        end;
      end;

      if ObjZav[Ptr].bParam[21] then
      begin
        ObjZav[Ptr].bParam[20] := true; // установить ловушку восстановления достоверных данных (блокировка действий, связанных с размыканием секции)
        ObjZav[Ptr].bParam[21] := false;
      end else
      begin
        ObjZav[Ptr].bParam[20] := false; // снять ловушку восстановления достоверных данных (разблокирование действий, связанных с размыканием секций)
      end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU) and WorkMode.Upravlenie; // район управления активизирован
      if ObjZav[Ptr].bParam[2] <> z then
      begin
        ObjZav[Ptr].bParam[8]  := true;  // снять трассировку
        ObjZav[Ptr].bParam[14] := false; // снять предварительное замыкание
        if z then
        begin // при размыкании секции
          ObjZav[Ptr].iParam[2] := 0; // сбросить индекс светофора, ограждающего элементарный маршрут
          ObjZav[Ptr].iParam[3] := 0; // Сбросить индекс горы
          ObjZav[Ptr].bParam[15] := false; // снять 1КМ
          ObjZav[Ptr].bParam[16] := false; // снять 2КМ
        end;
      end;
      ObjZav[Ptr].bParam[2] := z;  // з
      if ObjZav[Ptr].bParam[5] <> mi then
      begin
        ObjZav[Ptr].bParam[8]  := true;  // снять трассировку
        ObjZav[Ptr].bParam[14] := false; // снять предварительное замыкание
        if mi then
        begin // при размыкании секции
          ObjZav[Ptr].bParam[15] := false; // снять 1КМ
          ObjZav[Ptr].bParam[16] := false; // снять 2КМ
        end;
      end;
      ObjZav[Ptr].bParam[5] := mi;  // МИ

    // проверка передачи на местное управление
      ObjZav[Ptr].bParam[9] := false;
      for i := 20 to 24 do
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
            25 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);
            44 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
          end;
        end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[2];
{$IFDEF RMDSP}
      inc(LiveCounter);
      if WorkMode.Upravlenie then
      begin
        if not ObjZav[Ptr].bParam[14] then
        begin // при трассировке
          if not ObjZav[Ptr].bParam[7] then
          begin // из FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin // светить немигающую тонкую белую полосу
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // из объекта
          end;
        end else
        begin
          if not ObjZav[Ptr].bParam[7] then
          begin // из FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            if tab_page then // проверка выдачи команды установки маршрута
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
            else
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // из объекта
          end;
        end;
      end else
      begin // из FR3
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[7];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := not ObjZav[Ptr].bParam[7];
{$IFDEF RMDSP}
      end;
{$ENDIF}

      if ObjZav[Ptr].bParam[3] <> ri then
      begin
        if ri and not StartRM then
        begin // фиксируем выбор секции для ИР
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,84+$2000); AddFixMessage(GetShortMsg(1,84,ObjZav[Ptr].Liter),0,2);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,84+$2000);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[3] := ri;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[6];

      sost := GetFR5(ObjZav[Ptr].ObjConstI[1]);
      if ObjZav[Ptr].bParam[5] and (ObjZav[Ptr].iParam[3] = 0) then
      begin // проверить диагностику если нет маневров, надвига
        if ((sost and 1) = 1) then
        begin // фиксируем лoжную занятость секции
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,394+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[1] := LastTime; inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,394+$1000); AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // Фиксировать неисправность если включено управление
{$ENDIF}
        end;
        if ((sost and 2) = 2) and not ObjZav[Ptr].bParam[9] then
        begin // фиксируем лoжную свободность секции
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,395+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[2] := LastTime; inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,395+$1000); AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // Фиксировать неисправность если включено управление
{$ENDIF}
        end;
      end;

      if WorkMode.Podsvet and ObjZav[Ptr].ObjConstB[6] then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;

    end else
    begin // переход в недостоверное состояние данных
      if ObjZav[Ptr].ObjConstI[9] > 0 then Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
      ObjZav[Ptr].bParam[21] := true; // установить ловушку недостоверности данных
    end;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[19];

    //FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
    begin
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepSekciya]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта пути для вывода на табло #4
procedure PrepPuti(Ptr : Integer);
  var z1,z2,mic,min : boolean; i : integer; sost,sost1,sost2 : Byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // П(ч)
  z1 := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                     // ЧИ
  z2 := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                     // НИ
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);      // ЧКМ
  if ObjZav[Ptr].ObjConstI[6] > 0 then
    mic := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]) else mic := true; // МИ(ч)
  ObjZav[Ptr].bParam[15] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // НКМ
  if ObjZav[Ptr].ObjConstI[8] > 0 then
    min := not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]) else min := true; // МИ(н)
  ObjZav[Ptr].bParam[16] := not GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // П(н)
  ObjZav[Ptr].bParam[7] := not GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // предв замык чет
  ObjZav[Ptr].bParam[11] := not GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // предв замык неч

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU) and WorkMode.Upravlenie; // район управления активизирован
      if ObjZav[Ptr].bParam[2] <> z1 then
      begin
        if ObjZav[Ptr].bParam[2] then
        begin
          ObjZav[Ptr].iParam[2] := 0;
          ObjZav[Ptr].bParam[8] := true; // снять трассировку
          ObjZav[Ptr].bParam[14] := false; // снять предварительное замыкание
        end;
      end;
      ObjZav[Ptr].bParam[2] := z1;  // ЧИ
      if ObjZav[Ptr].bParam[3] <> z2 then
      begin
        if ObjZav[Ptr].bParam[3] then
        begin
          ObjZav[Ptr].iParam[3] := 0;
          ObjZav[Ptr].bParam[8] := true; // снять трассировку
          ObjZav[Ptr].bParam[14] := false; // снять предварительное замыкание
        end;
      end;
      ObjZav[Ptr].bParam[3] := z2;  // НИ
      if ObjZav[Ptr].bParam[5] <> mic then
      begin
        if ObjZav[Ptr].bParam[5] then
        begin
          ObjZav[Ptr].bParam[8] := true; // снять трассировку
          ObjZav[Ptr].bParam[14] := false; // снять предварительное замыкание
        end;
      end;
      ObjZav[Ptr].bParam[5] := mic;  // МИ(ч)
      if ObjZav[Ptr].bParam[6] <> min then
      begin
        if ObjZav[Ptr].bParam[6] then
        begin
          ObjZav[Ptr].bParam[8] := true; // снять трассировку
          ObjZav[Ptr].bParam[14] := false; // снять предварительное замыкание
        end;
      end;
      ObjZav[Ptr].bParam[6] := min;  // МИ(н)

    // проверка передачи на местное управление
      ObjZav[Ptr].bParam[9] := false;
      inc(LiveCounter);
      for i := 20 to 24 do
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
            25 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);
            43 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
          end;
        end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];                            // чи
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];                            // ни
{$IFDEF RMDSP}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[16]; // п
{$ELSE}
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[16];
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];                            // чкм
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[15];                           // нкм
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[9];                            // рм
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[5] and ObjZav[Ptr].bParam[6]; // ми

{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if not ObjZav[Ptr].bParam[14] then
        begin // при трассировке светить немигающую тонкую белую полосу
          if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then
          begin // из FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin // светить немигающую тонкую белую полосу
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // из объекта
          end;
        end else
        begin
          if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then
          begin // из FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            if tab_page then // проверка выдачи команды установки маршрута
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
            else
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // из объекта
          end;
        end;
      end else
      begin // из FR3
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[11];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := not (ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[11]);
{$IFDEF RMDSP}
      end;
{$ENDIF}

      sost1 := GetFR5(ObjZav[Ptr].ObjConstI[2] div 8);
      if (ObjZav[Ptr].ObjConstI[9] > 0) and (ObjZav[Ptr].ObjConstI[2] <> ObjZav[Ptr].ObjConstI[9]) then
      begin // если описан составной путь - проверить диагностику из другой половинки
        sost2 := GetFR5(ObjZav[Ptr].ObjConstI[9] div 8);
      end else
        sost2 := 0;

      sost := sost1 or sost2;

      ObjZav[Ptr].Timers[1].Active := ObjZav[Ptr].Timers[1].First < LastTime; // проверить наличие блокировки повторяющейся диагностики от разных контроллеров за 1 сек.
      if (sost > 0) and ((sost <> byte(ObjZav[Ptr].iParam[4])) or ObjZav[Ptr].Timers[1].Active) then
      begin
        ObjZav[Ptr].iParam[4] := SmallInt(sost); // запомнить код диагностического сообщения

{$IFDEF RMSHN}
        ObjZav[Ptr].Timers[1].First := LastTime + 1 / 86400; // зафиксировать время блокировки диагностики ШН
{$ELSE}
        ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400; // зафиксировать время блокировки диагностики ДСП
{$ENDIF}
        if (sost and 4) = 4 then
        begin // фиксируем отсутствие теста пути
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,397+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[3] := LastTime; inc(ObjZav[Ptr].siParam[3]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,397+$1000); AddFixMessage(GetShortMsg(1,397,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // Фиксировать неисправность если включено управление
{$ENDIF}
        end;
        if (sost and 1) = 1 then
        begin // фиксируем лoжную занятость пути
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,394+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[1] := LastTime; inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,394+$1000);  AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // Фиксировать неисправность если включено управление
{$ENDIF}
        end;
        if (sost and 2) = 2 then
        begin // фиксируем ложную свободность пути
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,395+$1000); SingleBeep := true; //ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[2] := LastTime; inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,395+$1000); AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // Фиксировать неисправность если включено управление
{$ENDIF}
        end;
      end;
    end;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[19];

    //FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[2] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
    begin
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[2] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[2] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[1] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPuti]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта светофора для вывода на табло #5
procedure PrepSvetofor(Ptr : Integer);
  var i,j : integer; n,o,zso,vnp,kz : boolean; sost : Byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МС1
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МС2
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // С1
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // С2
  o  := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // О
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // НМ
  ObjZav[Ptr].bParam[8] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // Н
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // Ко - включение сигнала прикрытия

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU); // район управления активизирован

      inc(LiveCounter);
      if o <> ObjZav[Ptr].bParam[5] then
      begin // огневое реле изменило состояние
        if o then
        begin // неисправность огневушки появилась
         if not ObjZav[Ptr].bParam[2] and not ObjZav[Ptr].bParam[4] then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then begin
                if ObjZav[Ptr].bParam[10] then
                begin
                  InsArcNewMsg(Ptr,481+$1000); AddFixMessage(GetShortMsg(1,481, ObjZav[ptr].Liter),4,4);
                end else
                begin
                  InsArcNewMsg(Ptr,272+$1000); AddFixMessage(GetShortMsg(1,272, ObjZav[ptr].Liter),4,4);
                end;
              end;
{$ELSE}
              if ObjZav[Ptr].bParam[10] then
                InsArcNewMsg(Ptr,482+$1000) // Неисправен сигнал прикрытия
              else
                InsArcNewMsg(Ptr,272+$1000); // Неисправен запрещающий огонь
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[1] := LastTime; inc(ObjZav[Ptr].siParam[1]);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[20] := false; // сброс восприятия неисправности
      end;
      ObjZav[Ptr].bParam[5] := o;  // О

      if ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[3] or
         ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[4] then
      begin // открыт или выдержка времени
        ObjZav[Ptr].iParam[1] := 0; // сбросить индекс маршрута
        ObjZav[Ptr].bParam[34] := false;
        if not ObjZav[Ptr].bParam[19] and
           ((ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[3]) or
            (ObjZav[Ptr].bParam[2] and ObjZav[Ptr].bParam[4])) then
        begin // неисправность по С&МС ^ ВС&МВС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,300+$1000); AddFixMessage(GetShortMsg(1,300, ObjZav[ptr].Liter),4,4)
            end;
{$ELSE}
            InsArcNewMsg(Ptr,300+$1000); SingleBeep := true;
{$ENDIF}
          end;
          ObjZav[Ptr].bParam[19] := true;
        end;
      end else
      begin
        ObjZav[Ptr].bParam[19] := false;
      end;

      // сброс Н и НМ по размыканию перекрывной секции
      if ObjZav[Ptr].BaseObject > 0 then
      begin
        if ObjZav[Ptr].bParam[11] <> ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
        begin
          if ObjZav[Ptr].bParam[11] then
          begin // Замыкание перекрывной секции
            ObjZav[Ptr].iParam[1] := 0;
            ObjZav[Ptr].bParam[34] := false;
          end else
          begin // Размыкание перекрывной секции
            ObjZav[Ptr].bParam[14] := false; // снять программное замыкание
            ObjZav[Ptr].bParam[7] := false;  // Сброс Н
            ObjZav[Ptr].bParam[9] := false;  // Сброс НМ
            ObjZav[Ptr].iParam[2] := 0;      // Сброс ГВ
            ObjZav[Ptr].iParam[3] := 0;      // Сброс УН
          end;
          ObjZav[Ptr].bParam[11] := ObjZav[ObjZav[Ptr].BaseObject].bParam[2];
        end;
      end;

    // проверка передачи на местное управление
      ObjZav[Ptr].bParam[18] := false;
      ObjZav[Ptr].bParam[21] := false; // МУС
      for i := 20 to 24 do
      begin
        j := ObjZav[Ptr].ObjConstI[i];
        if j > 0 then
        begin
          case ObjZav[j].TypeObj of
            25 : begin // МК
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(j);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // Собрать МУС
                ObjZav[Ptr].bParam[21] := ObjZav[j].bParam[1] and     // РМ
                                          not ObjZav[j].bParam[4] and // оИ
                                          ObjZav[j].bParam[5];        // В
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[j].bParam[3]; // РМ&ОИ или МИ
            end;
            43 : begin //оПИ
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // Собрать МУС
                ObjZav[Ptr].bParam[21] := ObjZav[ObjZav[j].BaseObject].bParam[1] and     // РМ
                                          not ObjZav[ObjZav[j].BaseObject].bParam[4] and // оИ
                                          ObjZav[ObjZav[j].BaseObject].bParam[5] and     // В
                                          not ObjZav[j].bParam[2]; // РПо
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[ObjZav[j].BaseObject].bParam[3]; // РМ&ОИ или МИ
            end;
            48 : begin //РПо
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // Собрать МУС
                ObjZav[Ptr].bParam[21] := ObjZav[ObjZav[j].BaseObject].bParam[1] and     // РМ
                                          not ObjZav[ObjZav[j].BaseObject].bParam[4] and // оИ
                                          ObjZav[ObjZav[j].BaseObject].bParam[5] and     // В
                                          ObjZav[j].bParam[1]; // есть проход на пути
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[ObjZav[j].BaseObject].bParam[3]; // РМ&ОИ или МИ
            end;
            52 : begin //СВМУС
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // Собрать МУС
                ObjZav[Ptr].bParam[21] := ObjZav[ObjZav[j].BaseObject].bParam[1] and     // РМ
                                          not ObjZav[ObjZav[j].BaseObject].bParam[4] and // оИ
                                          ObjZav[ObjZav[j].BaseObject].bParam[5] and     // В
                                          ObjZav[j].bParam[1]; // есть проход по пошерстным стрелкам
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[ObjZav[j].BaseObject].bParam[3]; // РМ&ОИ или МИ
            end;
          end;
        end;
      end;

      if (ObjZav[Ptr].iParam[2] = 0) and // признак ГВ
         (ObjZav[Ptr].iParam[3] = 0) and // признак УН
         not ObjZav[Ptr].bParam[18] then // признак РМ
      begin // контролировать замедление сигнального реле
        if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
        begin // сброс таймера при свободности перекрывной секции
          ObjZav[Ptr].Timers[1].Active := false;
        end else
        // перекрывная секция занята
        if ObjZav[Ptr].bParam[4] then
        begin // сигнал открыт
          if not ObjZav[Ptr].Timers[1].Active then
          begin // фиксируем начало отсчета
            ObjZav[Ptr].Timers[1].Active := true;
            ObjZav[Ptr].Timers[1].First := LastTime;
          end;
        end else
        begin // сигнал перекрылся
          if ObjZav[Ptr].Timers[1].Active then
          begin
            ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].dtParam[6] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
          end;
        end;
      end;

      if (ObjZav[Ptr].iParam[2] = 0) and // признак ГВ
         (ObjZav[Ptr].iParam[3] = 0) and // признак УН
         not ObjZav[Ptr].bParam[18]      // признак РМ
{$IFDEF RMDSP} and (ObjZav[Ptr].RU = config.ru) and WorkMode.Upravlenie {$ENDIF} then // РМ-ДСП - проверить соответствие района и наличие управления
      begin // контроль работы сигнала
        if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
        begin // нет замыкания перекрывной секции
          if not ObjZav[Ptr].Timers[1].Active and not ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[9] then
          begin // нет ожидания обестачивания поездного сигнального реле
            if ObjZav[Ptr].bParam[4] then
            begin // есть С
              if not ObjZav[Ptr].bParam[19] then
              begin // нет фиксации неисправности светофора
                if WorkMode.FixedMsg then
                begin
                  InsArcNewMsg(Ptr,510+$1000); AddFixMessage(GetShortMsg(1,510,ObjZav[Ptr].Liter),4,1);
                end;
              end;
              ObjZav[Ptr].bParam[19] := true;
            end;
          end;

          if ObjZav[Ptr].bParam[2] then
          begin
            if not ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].bParam[7] then
            begin // есть МС без начала маршрута
              if ObjZav[Ptr].Timers[2].Active then
              begin // ожидание обестачивания маневрового сигнального реле
                if LastTime > ObjZav[Ptr].Timers[2].First then
                begin
                  if not ObjZav[Ptr].bParam[19] then
                  begin // нет фиксации неисправности светофора
                    if WorkMode.FixedMsg then
                    begin
                      InsArcNewMsg(Ptr,510+$1000); AddFixMessage(GetShortMsg(1,510,ObjZav[Ptr].Liter),4,1);
                    end;
                  end;
                  ObjZav[Ptr].bParam[19] := true;
                end;
              end else
              begin // нет ожидания обестачивания маневрового сигнального реле
                ObjZav[Ptr].Timers[2].First := LastTime + 5 / 86400; ObjZav[Ptr].Timers[2].Active := true;
              end;
            end;
          end else // сбросить таймер если маневровый закрыт
            ObjZav[Ptr].Timers[2].Active := false;

        end else
        if ObjZav[Ptr].bParam[6] or ObjZav[Ptr].bParam[8] then
        begin // есть замыкание перекрывной секции и признак Н или НМ
          if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
          begin // есть занятость перекрывной секции
            if not ObjZav[Ptr].bParam[27] then
            begin
              if not (ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[4]) then
              begin // сигнал закрыт
                if WorkMode.FixedMsg then
                begin
                  InsArcNewMsg(Ptr,509+$1000); AddFixMessage(GetShortMsg(1,509,ObjZav[Ptr].Liter),4,1); ObjZav[Ptr].bParam[19] := true;
                end;
              end;
              ObjZav[Ptr].bParam[27] := true; // фиксируем занятие перекрывной секции
            end;
          end;
        end;
      end;
      if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then ObjZav[Ptr].bParam[27] := false; // сбросить признак фиксации занятия перекрывной секции

      if ObjZav[Ptr].ObjConstI[28] > 0 then
      begin // отобразить состояние автодействия сигнала
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[ObjZav[Ptr].ObjConstI[28]].bParam[1];
      end else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := false;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[21];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5];
      if not ObjZav[Ptr].bParam[2] and not ObjZav[Ptr].bParam[4] and not ObjZav[Ptr].bParam[21] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];
        if not ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[3] then
        begin
          if WorkMode.Upravlenie then
          begin
            if not ObjZav[Ptr].bParam[14] and ObjZav[Ptr].bParam[7] then
            begin // при трассировке светить немигающую
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[7]; // из объекта
            end else
            if tab_page then // проверка выдачи команды установки маршрута
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].bParam[34] // из FR3 если нет сброса трассы
            end else
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[7]; // из объекта
            end;
          end else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[6]; // из FR3
          if WorkMode.Upravlenie then
          begin
            if not ObjZav[Ptr].bParam[14] and ObjZav[Ptr].bParam[9] then
            begin // при трассировке светить немигающую
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[9]; // из объекта
            end else
            if tab_page then // проверка выдачи команды установки маршрута
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[34] // из FR3 если нет сброса трассы
            end else
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[9]; // из объекта
            end;
          end else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[8]; // из FR3
        end else
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
        end;
      end else
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := false;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
      end;

      sost := GetFR5(ObjZav[Ptr].ObjConstI[1]);
      if (ObjZav[Ptr].iParam[2] = 0) and // признак ГВ
         (ObjZav[Ptr].iParam[3] = 0) and // признак УН
         not ObjZav[Ptr].bParam[18] then // признак РМ
      begin // контролировать перекрытие сигнала если не установлен маршрут надвига на горку
        if ((sost and 1) = 1) and not ObjZav[Ptr].bParam[18] then
        begin // фиксируем перекрытие светофора
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then
          begin
{$ENDIF}
            if WorkMode.OU[0] then
            begin // перекрытие в режиме управления с АРМа
              InsArcNewMsg(Ptr,396+$1000); AddFixMessage(GetShortMsg(1,396,ObjZav[Ptr].Liter),4,1);
            end else
            begin // перекрытие в режиме управления с пульта
              InsArcNewMsg(Ptr,403+$1000); AddFixMessage(GetShortMsg(1,403,ObjZav[Ptr].Liter),4,1);
            end;
{$IFDEF RMDSP}
          end;
          ObjZav[Ptr].bParam[23] := WorkMode.Upravlenie and WorkMode.OU[0]; // Фиксировать неисправность если включено управление
{$ENDIF}
{$IFNDEF RMDSP}
          ObjZav[Ptr].dtParam[2] := LastTime; inc(ObjZav[Ptr].siParam[2]);
          ObjZav[Ptr].bParam[23] := true; // Фиксировать неисправность
{$ENDIF}
        end;
      end else
        ObjZav[Ptr].bParam[23] := false;

      inc(LiveCounter);
      {FR4}
      ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12]
    end;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[23];

    ObjZav[Ptr].bParam[29] := true; // Активизация
    ObjZav[Ptr].bParam[30] := false; // Непарафазность
    o   := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // ЖСо(Co)
    zso := GetFR3(ObjZav[Ptr].ObjConstI[25],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // зCo
    vnp := GetFR3(ObjZav[Ptr].ObjConstI[26],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // ВНП
    ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // ЛС
    n := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // А
    kz := GetFR3(ObjZav[Ptr].ObjConstI[30],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // Кз
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[30];
    if not ObjZav[Ptr].bParam[30] then // непарафазность2
    begin
      if o <> ObjZav[Ptr].bParam[15] then
      begin // изменение ЖСо(Со)
      if o then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              if ObjZav[Ptr].ObjConstI[25] = 0 then
              begin
                if ObjZav[Ptr].bParam[4] then InsArcNewMsg(Ptr,300+$1000) else InsArcNewMsg(Ptr,497+$1000);
              end else
              begin
                if ObjZav[Ptr].bParam[4] then InsArcNewMsg(Ptr,485+$1000) else InsArcNewMsg(Ptr,498+$1000);
              end;
              if ObjZav[Ptr].ObjConstI[25] = 0 then AddFixMessage(GetShortMsg(1,300,ObjZav[Ptr].Liter),4,4) else AddFixMessage(GetShortMsg(1,485,ObjZav[Ptr].Liter),4,4);
            end;
{$ELSE}
            if ObjZav[Ptr].ObjConstI[25] = 0 then
            begin
              if ObjZav[Ptr].bParam[4] then InsArcNewMsg(Ptr,300+$1000) else InsArcNewMsg(Ptr,497+$1000);
            end else
            begin
              if ObjZav[Ptr].bParam[4] then InsArcNewMsg(Ptr,485+$1000) else InsArcNewMsg(Ptr,498+$1000);
            end;
            SingleBeep4 := true;
            ObjZav[Ptr].dtParam[3] := LastTime; inc(ObjZav[Ptr].siParam[3]);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[20] := false; // сброс восприятия неисправности
      end;
      ObjZav[Ptr].bParam[15] := o;
      if zso <> ObjZav[Ptr].bParam[24] then
      begin // изменение зСо
        if zso then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              if ObjZav[Ptr].bParam[4] then
              begin
                InsArcNewMsg(Ptr,486+$1000); AddFixMessage(GetShortMsg(1,486,ObjZav[Ptr].Liter),4,4);
              end else
              begin
                InsArcNewMsg(Ptr,499+$1000); AddFixMessage(GetShortMsg(1,499,ObjZav[Ptr].Liter),4,4);
              end;
            end;
{$ELSE}
            if ObjZav[Ptr].bParam[4] then InsArcNewMsg(Ptr,486+$1000) else InsArcNewMsg(Ptr,499+$1000);
            SingleBeep4 := true;
            ObjZav[Ptr].dtParam[3] := LastTime; inc(ObjZav[Ptr].siParam[3]);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[20] := false; // сброс восприятия неисправности
      end;
      ObjZav[Ptr].bParam[24] := zso;
      if vnp <> ObjZav[Ptr].bParam[25] then
      begin // изменение ВНП
        if vnp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              InsArcNewMsg(Ptr,300+$1000); AddFixMessage(GetShortMsg(1,300,ObjZav[Ptr].Liter),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,300+$1000); SingleBeep4 := true;
            ObjZav[Ptr].dtParam[3] := LastTime; inc(ObjZav[Ptr].siParam[3]);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[20] := false; // сброс восприятия неисправности
      end;
      ObjZav[Ptr].bParam[25] := vnp;

      if n <> ObjZav[Ptr].bParam[17] then
      begin // Изменение А
        if n then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              InsArcNewMsg(Ptr,338+$1000); AddFixMessage(GetShortMsg(1,338,ObjZav[Ptr].Liter),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,338+$1000); SingleBeep4 := true;
            ObjZav[Ptr].dtParam[4] := LastTime; inc(ObjZav[Ptr].siParam[4]);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[20] := false; // сброс восприятия неисправности
      end;
      ObjZav[Ptr].bParam[17] := n;

      if kz <> ObjZav[Ptr].bParam[26] then
      begin // Изменение Кз
        if kz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              if ObjZav[Ptr].bParam[4] then
              begin
                InsArcNewMsg(Ptr,487+$1000); AddFixMessage(GetShortMsg(1,487,ObjZav[Ptr].Liter),4,4);
              end else
              begin
                InsArcNewMsg(Ptr,497+$1000); AddFixMessage(GetShortMsg(1,497,ObjZav[Ptr].Liter),4,4);
              end;
            end;
{$ELSE}
            if ObjZav[Ptr].bParam[4] then InsArcNewMsg(Ptr,487+$1000) else InsArcNewMsg(Ptr,497+$1000);
            SingleBeep4 := true;
            ObjZav[Ptr].dtParam[5] := LastTime; inc(ObjZav[Ptr].siParam[5]);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[20] := false; // сброс восприятия неисправности
      end;
      ObjZav[Ptr].bParam[26] := kz;
      inc(LiveCounter);

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[20]; // восприятие неисправности
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[30];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[15] or ObjZav[Ptr].bParam[24] or ObjZav[Ptr].bParam[25]; // Co,ВНП
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] :=  ObjZav[Ptr].bParam[26]; // Кз
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[17]; // А
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepSvetofor]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта ручного замыкания стрелок для вывода на табло #9
procedure PrepRZS(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rz := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //Рз
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ДзС
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //оДзС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if rz <> ObjZav[Ptr].bParam[1] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,370+$2000); AddFixMessage(GetShortMsg(1,370,ObjZav[Ptr].Liter),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,370+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := rz;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // Рз
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // ДзС
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; // оДзС
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepRZS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта магистрали рабочего тока стрелок для вывода на табло #17
procedure PrepMagStr(Ptr : Integer);
  var lar : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //Сз
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ВНП
  lar := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ЛАР

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
      if lar <> ObjZav[Ptr].bParam[3] then
      begin // изменение состояния ЛАР
        if lar then
        begin // неисправность питания РЦ
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,484+$2000); AddFixMessage(GetShortMsg(1,484,ObjZav[Ptr].Liter),0,1);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,484+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := lar;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMagStr]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта магистрали макета стрелок для вывода на табло #18
procedure PrepMagMakS(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ВМ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if rz <> ObjZav[Ptr].bParam[1] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
           if (config.ru = ObjZav[ptr].RU) and (maket_strelki_index > 0) then
            begin
              InsArcNewMsg(maket_strelki_index,377+$2000); AddFixMessage(GetShortMsg(1,377,ObjZav[maket_strelki_index].Liter),0,2);
            end;
{$ELSE}
            InsArcNewMsg(maket_strelki_index,377+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := rz;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMagMakS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта аварийного перевода стрелок для вывода на табло #19
procedure PrepAPStr(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ГВК

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if rz <> ObjZav[Ptr].bParam[1] then
      begin
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then
          begin
            if rz then
            begin
              InsArcNewMsg(Ptr,378+$2000); AddFixMessage(GetShortMsg(1,378,ObjZav[Ptr].Liter),0,2);
            end else
            begin
              InsArcNewMsg(Ptr,379+$2000); AddFixMessage(GetShortMsg(1,379,ObjZav[Ptr].Liter),0,2);
            end;
          end;
{$ELSE}
          if rz then InsArcNewMsg(Ptr,378+$2000) else InsArcNewMsg(Ptr,379+$2000);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[1] := rz;
    end else
    begin // Сбросить признак вспомогательного перевода при неисправности
      ObjZav[Ptr].bParam[1] := false;
    end;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
  end;
except
  reportf('Ошибка [MainLoop.PrepAPStr]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// подготовка объекта ограждения пути к выводу на табло #6
procedure PrepPTO(Ptr : Integer);
  var zo,og : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  zo := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // Оз
  og := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // оГ
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // СоГ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU); // район управления активизирован
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := false;

      if og <> ObjZav[Ptr].bParam[2] then
      begin
        if og then
        begin // установлено
          if not zo then
          begin // если нет запроса на ограждение - запустить таймер
            ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
            ObjZav[Ptr].Timers[1].Active := true;
            ObjZav[Ptr].bParam[4] := false; // разблокировать ловушку неисправности ОГ
            ObjZav[Ptr].bParam[5] := false;
          end;
        end else
        begin // снято
          ObjZav[Ptr].Timers[1].Active := false;
        end;
      end;
      ObjZav[Ptr].bParam[2] := og;

      if zo <> ObjZav[Ptr].bParam[1] then
      begin
        if zo then
        begin // получен запрос ограждения
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (config.ru = ObjZav[ptr].RU) then begin
              InsArcNewMsg(Ptr,295); if WorkMode.Upravlenie then AddFixMessage(GetShortMsg(1,295,ObjZav[Ptr].Liter),4,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,295);
{$ENDIF}
          end;
        end else
        begin // снят запрос ограждения
          ObjZav[Ptr].bParam[4] := false; // разблокировать ловушку неисправности ОГ
          ObjZav[Ptr].bParam[5] := false;
          ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
          ObjZav[Ptr].Timers[1].Active := true;
        end;
      end;
      ObjZav[Ptr].bParam[1] := zo;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[4];
      if ObjZav[Ptr].bParam[2] and not ObjZav[Ptr].bParam[1] then
      begin // ограждение без запроса
        if ObjZav[Ptr].Timers[1].Active then
        begin
          if (ObjZav[Ptr].Timers[1].First > LastTime) or ObjZav[Ptr].bParam[4] then
          begin // ожидаем установленную выдержку времени
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[2];
          end else
          begin
            if not ObjZav[Ptr].bParam[5] then
            begin // фиксируем неисправность ОГ
              ObjZav[Ptr].bParam[5] := true;
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if (config.ru = ObjZav[ptr].RU) then begin
                  InsArcNewMsg(Ptr,337+$1000); AddFixMessage(GetShortMsg(1,337,ObjZav[Ptr].Liter),4,3);
                end;
{$ELSE}
                InsArcNewMsg(Ptr,337+$1000); SingleBeep := true;
                ObjZav[Ptr].dtParam[1] := LastTime; inc(ObjZav[Ptr].siParam[1]);
{$ENDIF}
              end;
            end;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := true;
          end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
      end else
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[1];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[2];
        ObjZav[Ptr].Timers[1].Active := false;
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPTO]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// подготовка объекта УТС к выводу на экран #8
procedure PrepUTS(Ptr : Integer);
  var uu : Boolean; p : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // УС
  uu := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // УУ
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // СУС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

      if uu <> ObjZav[Ptr].bParam[2] then
      begin
        p := ObjZav[Ptr].BaseObject;
        if (p > 0) and not ObjZav[Ptr].bParam[3] and uu and not ObjZav[Ptr].bParam[4] then
        begin
          if (not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[4]) or
             (not ObjZav[ObjZav[Ptr].BaseObject].bParam[3] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[15]) then
          begin // фиксируем изменение положения упора в установленном маршруте приема на путь
            ObjZav[Ptr].bParam[4] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then begin
                InsArcNewMsg(Ptr,495+$2000); AddFixMessage(GetShortMsg(1,495,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,495+$2000);
{$ENDIF}
            end;
          end;
        end;
        if uu and not ObjZav[Ptr].bParam[1] then
        begin // Упор установлен
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[Ptr].RU then begin
              InsArcNewMsg(Ptr,108+$2000); AddFixMessage(GetShortMsg(1,108,ObjZav[ObjZav[Ptr].BaseObject].Liter),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,108+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := uu;
      if not (uu xor ObjZav[Ptr].bParam[1]) then
      begin // нет контроля положения
        p := ObjZav[Ptr].BaseObject;
        if (p > 0) and not ObjZav[Ptr].bParam[3] and not ObjZav[Ptr].bParam[4] then
        begin
          if (not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[4]) or
             (not ObjZav[ObjZav[Ptr].BaseObject].bParam[3] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[15]) then
          begin // фиксируем изменение положения упора в установленном маршруте приема на путь
            ObjZav[Ptr].bParam[4] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then begin
                InsArcNewMsg(Ptr,496+$2000); AddFixMessage(GetShortMsg(1,496,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,496+$2000);
{$ENDIF}
            end;
          end;
        end;
        if not WorkMode.FixedMsg then ObjZav[Ptr].bParam[4] := true; // блокировать на старте системы
        if not ObjZav[Ptr].bParam[4] then
        begin // не зафиксировано сообщение о потере контроля
          if ObjZav[Ptr].Timers[1].Active then
          begin
            if ObjZav[Ptr].Timers[1].First < LastTime then
            begin // Зафиксировать потерю контроля положения упора
              ObjZav[Ptr].bParam[4] := true;
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then begin
                InsArcNewMsg(Ptr,109+$1000); AddFixMessage(GetShortMsg(1,109,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,1);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,109+$1000); SingleBeep := true;
{$ENDIF}
            end;
          end else
          begin // начать отсчет времени
            ObjZav[Ptr].Timers[1].First := LastTime+ 15/86400;
            ObjZav[Ptr].Timers[1].Active := true;
          end;
        end;
      end else
      begin
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[4] := false;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepUTS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта управления переездом для вывода на табло #10
procedure PrepUPer(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rz := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // зП
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ПИВ
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // УзП
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // УзПД

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[3]; // УзП
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4]; // УзПД

      if rz <> ObjZav[Ptr].bParam[1] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,371+$2000); AddFixMessage(GetShortMsg(1,371,ObjZav[Ptr].Liter),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,371+$2000);
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,372+$2000); AddFixMessage(GetShortMsg(1,372,ObjZav[Ptr].Liter),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,372+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := rz;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[1];
{$IFDEF RMDSP}
      if config.ru = ObjZav[ptr].RU then
      begin
        if rz then
        begin // переезд закрыт
          if ObjZav[Ptr].Timers[1].Active then
          begin
            if ObjZav[Ptr].Timers[1].First < LastTime then
            begin // выдать сообщение о длительном закрытии переезда под кнопку зП
              InsArcNewMsg(Ptr,514+$2000);
              if ObjZav[Ptr].bParam[5] then AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter),0,4) else AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter),0,3);
              ObjZav[Ptr].bParam[5] := true; ObjZav[Ptr].Timers[1].First := LastTime + 60 / 86400; // ожидание выдачи повторного сообщения
            end;
          end else
          begin // задать ожидание первичного сообщения
            ObjZav[Ptr].Timers[1].First := LastTime + 600 / 86400; ObjZav[Ptr].Timers[1].Active := true;
          end;
        end else
        begin // переезд открыт
          ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[5] := false; // сбросить фиксацию длительного закрытия перезда под кнопку
        end;
      end;
{$ENDIF}

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[2];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepUPer]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта контроля(1) переезда для вывода на табло #11
procedure PrepKPer(Ptr : Integer);
  var knp,kap,zg : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  kap := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КПА
  knp := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КПН
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КзП
  zg := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // зГ
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КоП
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ПИ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if kap <> ObjZav[Ptr].bParam[1] then
      begin
        if kap then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,143+$1000); AddFixMessage(GetShortMsg(1,143,ObjZav[Ptr].Liter),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,143+$1000); SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := kap;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];
      if knp <> ObjZav[Ptr].bParam[2] then
      begin
        if knp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,144+$1000); AddFixMessage(GetShortMsg(1,144,ObjZav[Ptr].Liter),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,144+$1000); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := knp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
      if zg <> ObjZav[Ptr].bParam[4] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,107+$2000); AddFixMessage(GetShortMsg(1,107,ObjZav[Ptr].Liter),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,107+$2000); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[4] := zg;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[6];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepKPer]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта контроля(2) переезда для вывода на табло #12
procedure PrepK2Per(Ptr : Integer);
  var knp,knzp,kop,zg : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  knp := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КНП
  knzp := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КНзП
  zg := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // зГ
  kop := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КоП
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ПИ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if knp <> ObjZav[Ptr].bParam[12] then
      begin // изменение по датчику неисправности на переезде
        if knp then
        begin // зафиксировать изменение исправен->неисправен
          ObjZav[Ptr].Timers[2].First := LastTime+10/86400; ObjZav[Ptr].Timers[2].Active := true;
        end else
        begin // зафиксировать изменение неисправен->исправен
          ObjZav[Ptr].Timers[2].First := 0; ObjZav[Ptr].Timers[2].Active := false; ObjZav[Ptr].bParam[2] := false; // сбросить индикацию неисправности переезда
        end;
      end;
      ObjZav[Ptr].bParam[12] := knp;
      if not ObjZav[Ptr].bParam[2] and ObjZav[Ptr].Timers[2].Active then
      begin // ожидание 10 секунд по датчику неисправности на переезде
        if ObjZav[Ptr].Timers[2].First < LastTime then
        begin // отображаем неисправность на переезде
          ObjZav[Ptr].bParam[2] := true;
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,144+$1000); AddFixMessage(GetShortMsg(1,144,ObjZav[Ptr].Liter),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,144+$1000); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      if kop and not knzp then
      begin // получен контроль открытого переезда
        ObjZav[Ptr].bParam[3] := false; ObjZav[Ptr].bParam[5] := true; ObjZav[Ptr].bParam[1] := false;
        ObjZav[Ptr].Timers[1].First := 0; ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[11] := false;
      end else
      if knzp and not kop then
      begin // получен контроль закрытого переезда
        ObjZav[Ptr].bParam[3] := true; ObjZav[Ptr].bParam[5] := false; ObjZav[Ptr].bParam[1] := false;
        ObjZav[Ptr].Timers[1].First := 0; ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[11] := false;
      end else
      begin // авария на переезде
        if not ObjZav[Ptr].Timers[1].Active then
        begin // зафиксировать изменение исправен->авария
          ObjZav[Ptr].Timers[1].First := LastTime+10/86400; ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].bParam[11] := true;
        end else
        if not ObjZav[Ptr].bParam[1] then
        begin // ожидаем 10 секунд по датчику аварии на переезде
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin // отображаем аварию на переезде
            ObjZav[Ptr].bParam[1] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then begin
                InsArcNewMsg(Ptr,143+$1000); AddFixMessage(GetShortMsg(1,143,ObjZav[Ptr].Liter),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,143+$1000); SingleBeep3 := true;
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[3] := false; ObjZav[Ptr].bParam[5] := false;
      end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];
      if ObjZav[Ptr].bParam[1] then // авария на переезде
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1]
      else // неисправность на переезде
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
      if zg <> ObjZav[Ptr].bParam[4] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,107+$2000); AddFixMessage(GetShortMsg(1,107,ObjZav[Ptr].Liter),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,107+$2000); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[4] := zg;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[6];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepK2Per]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта оповещения монтеров для вывода на табло #13
procedure PrepOM(Ptr : Integer);
  var rz,rrm : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // Во (УРО)
  rrm := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // РРМ (ВО)
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ВКо (ОМП)
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ВВМ (ВСВ)

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if rz <> ObjZav[Ptr].bParam[1] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[ptr].ObjConstB[1] then
            begin // подключаемый УРО
              if ObjZav[Ptr].bParam[2] and (config.ru = ObjZav[ptr].RU) then begin
                InsArcNewMsg(Ptr,374+$2000); AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter),0,2);
              end;
            end else
            begin
              if config.ru = ObjZav[ptr].RU then begin
                InsArcNewMsg(Ptr,373+$2000); AddFixMessage(GetShortMsg(1,373,ObjZav[Ptr].Liter),0,2);
              end;
            end;
{$ELSE}
            if ObjZav[ptr].ObjConstB[1] then
              InsArcNewMsg(Ptr,374+$2000)
            else
              InsArcNewMsg(Ptr,373+$2000);
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[ptr].ObjConstB[1] then
            begin // подключаемый УРО
              if rrm and (config.ru = ObjZav[ptr].RU) then begin
                InsArcNewMsg(Ptr,373+$2000); AddFixMessage(GetShortMsg(1,373,ObjZav[Ptr].Liter),0,2);
              end;
            end else
            begin
              if config.ru = ObjZav[ptr].RU then begin
                InsArcNewMsg(Ptr,374+$2000); AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter),0,2);
              end;
            end;
{$ELSE}
            if ObjZav[ptr].ObjConstB[1] then
              InsArcNewMsg(Ptr,373+$2000)
            else
              InsArcNewMsg(Ptr,374+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := rz;
      if ObjZav[ptr].ObjConstB[1] then
      begin // для подключаемого УРО фиксировать общее выключение как отключение оповещения "ПОЕЗД"
        if rrm <> ObjZav[Ptr].bParam[2] then
        begin
          if not rrm and not rz and WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,374+$2000); AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,374+$2000)
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] :=  rrm;
      if ObjZav[ptr].ObjConstB[1] then
      begin // подключаемый УРО
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2];
      end else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[1]; // Во
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2]; // РРМ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[3]; // ВКо
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4]; // ВВМ
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepOM]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта УКСПС для вывода на табло #14
procedure PrepUKSPS(Ptr : Integer);
  var d1,d2,kzk : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ИКС
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // предварительная команда
  d1 := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // 1КС
  d2 := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // 2КС
  kzk := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // КзК

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if d1 <> ObjZav[Ptr].bParam[3] then
      begin
        if d1 then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,125+$1000); AddFixMessage(GetShortMsg(1,125,ObjZav[Ptr].Liter),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,125+$1000); SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := d1;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[3];

      if d2 <> ObjZav[Ptr].bParam[4] then
      begin
        if d2 then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,126+$1000); AddFixMessage(GetShortMsg(1,126,ObjZav[Ptr].Liter),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,126+$1000); SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[4] := d2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[4];

      if kzk <> ObjZav[Ptr].bParam[5] then
      begin
        if kzk then
        begin // неисправность линии УКСПС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,127+$1000); AddFixMessage(GetShortMsg(1,127,ObjZav[Ptr].Liter),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,127+$1000); SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[5] := kzk;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[2];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepUKSPS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта контроля макета для вывода на табло #20
procedure PrepMaket(Ptr : Integer);
  var km : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  km := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // КМ
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МПК
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ММК

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if km <> ObjZav[Ptr].bParam[1] then
      begin
        if km then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (ObjZav[Ptr].RU = config.ru) then
            begin
              InsArcNewMsg(Ptr,301+$2000); AddFixMessage(GetShortMsg(1,301,''),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,301+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := km;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[3];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMaket]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта выдержки времени отмены для вывода на табло #21
procedure PrepOtmen(Ptr : Integer);
  var om,op,os : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  os := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ГОТ
  om := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МВ1
  op := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ПВ1
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // оС
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МВ
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ПВ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if ObjZav[Ptr].ObjConstI[5] > 0 then
      begin // таймер отмены со свободного
        if os <> ObjZav[Ptr].bParam[1] then
        begin
          if ObjZav[Ptr].Timers[1].Active then
          begin // отключить счет времени
            ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[1] := Timer[ObjZav[Ptr].ObjConstI[5]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
          end else
          begin // начать счет времени
            ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime; Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := os;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];

      if ObjZav[Ptr].ObjConstI[6] > 0 then
      begin // таймер отмены маневровой
        if om <> ObjZav[Ptr].bParam[2] then
        begin
          if ObjZav[Ptr].Timers[2].Active then
          begin // отключить счет времени
            ObjZav[Ptr].Timers[2].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[2] := Timer[ObjZav[Ptr].ObjConstI[6]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[6]] := 0;
          end else
          begin // начать счет времени
            ObjZav[Ptr].Timers[2].Active := true; ObjZav[Ptr].Timers[2].First := LastTime; Timer[ObjZav[Ptr].ObjConstI[6]] := 0;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := om;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];

      if ObjZav[Ptr].ObjConstI[7] > 0 then
      begin // таймер отмены поездной
        if op <> ObjZav[Ptr].bParam[3] then
        begin
          if ObjZav[Ptr].Timers[3].Active then
          begin // отключить счет времени
            ObjZav[Ptr].Timers[3].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[3] := Timer[ObjZav[Ptr].ObjConstI[7]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[7]] := 0;
          end else
          begin // начать счет времени
            ObjZav[Ptr].Timers[3].Active := true; ObjZav[Ptr].Timers[3].First := LastTime; Timer[ObjZav[Ptr].ObjConstI[7]] := 0;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := op;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];

      if ObjZav[Ptr].Timers[1].Active then
      begin // обновить значение времени отмены со свободного
        Timer[ObjZav[Ptr].ObjConstI[5]] := Round((LastTime - ObjZav[Ptr].Timers[1].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[5]] > 300 then Timer[ObjZav[Ptr].ObjConstI[5]] := 300;
      end;
      if ObjZav[Ptr].Timers[2].Active then
      begin // обновить значение времени отмены маневровой
        Timer[ObjZav[Ptr].ObjConstI[6]] := Round((LastTime - ObjZav[Ptr].Timers[2].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[6]] > 300 then Timer[ObjZav[Ptr].ObjConstI[6]] := 300;
      end;
      if ObjZav[Ptr].Timers[3].Active then
      begin // обновить значение времени отмены поездной
        Timer[ObjZav[Ptr].ObjConstI[7]] := Round((LastTime - ObjZav[Ptr].Timers[3].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[7]] > 300 then Timer[ObjZav[Ptr].ObjConstI[7]] := 300;
      end;
    end else
    begin // сброс счетчиков при неисправности входного интерфейса или отсутсвии информации
      if ObjZav[Ptr].ObjConstI[5] > 0 then Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
      ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[1] := false;
      if ObjZav[Ptr].ObjConstI[6] > 0 then Timer[ObjZav[Ptr].ObjConstI[6]] := 0;
      ObjZav[Ptr].Timers[2].Active := false; ObjZav[Ptr].bParam[2] := false;
      if ObjZav[Ptr].ObjConstI[7] > 0 then Timer[ObjZav[Ptr].ObjConstI[7]] := 0;
      ObjZav[Ptr].Timers[3].Active := false; ObjZav[Ptr].bParam[3] := false;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepOtmen]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта ГРИ для вывода на табло #22
procedure PrepGRI(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ГРИ1
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ГРИ
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ИВ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if rz <> ObjZav[Ptr].bParam[1] then
      begin
        if ObjZav[Ptr].ObjConstI[5] > 0 then
        begin // таймер искусственного размыкания
          if ObjZav[Ptr].Timers[1].Active then
          begin // отключить счет времени
            ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[1] := Timer[ObjZav[Ptr].ObjConstI[5]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
          end else
          begin // начать счет времени
            ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime; Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
          end;
        end;
        if rz then
        begin
          if WorkMode.FixedMsg and (config.ru = ObjZav[ptr].RU) then
          begin
            InsArcNewMsg(Ptr,375+$2000); AddFixMessage(GetShortMsg(1,375,ObjZav[Ptr].Liter),0,6);
          end;
{        end else
        begin
          if WorkMode.FixedMsg and (config.ru = ObjZav[ptr].RU) then
          begin
            InsArcNewMsg(Ptr,376+$2000); AddFixMessage(GetShortMsg(1,376,ObjZav[Ptr].Liter),0,6);
          end;}
        end;
      end;
      ObjZav[Ptr].bParam[1] := rz;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];

      if ObjZav[Ptr].Timers[1].Active then
      begin // обновить значение времени РИ
        Timer[ObjZav[Ptr].ObjConstI[5]] := Round((LastTime - ObjZav[Ptr].Timers[1].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[5]] > 300 then Timer[ObjZav[Ptr].ObjConstI[5]] := 300;
      end;
    end else
    begin // сброс счетчиков при неисправности входного интерфейса или отсутсвии информации
      if ObjZav[Ptr].ObjConstI[5] > 0 then Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
      ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[1] := false;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepGRI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта смены направления на перегоне для вывода на табло #15
procedure PrepAB(Ptr : Integer);
  var kj,ip1,ip2,zs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // В
  ip1 := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // 1ИП
  ip2 := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // 2ИП
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // СН
  ObjZav[Ptr].bParam[5] := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // КП
  kj := not GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // КЖ
  ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // Д1
  zs := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                        // запрос смены направления
  ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // Л
  ObjZav[Ptr].bParam[8]  := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // Д2
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // 3ИП
  ObjZav[Ptr].bParam[17] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // согласие смены направления

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if zs <> ObjZav[Ptr].bParam[10] then
      begin // получен запрос на смену направления
        if ObjZav[Ptr].bParam[4] and WorkMode.FixedMsg then
        begin // перегон по отправлению
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then
          begin
{$ENDIF}
            if zs then begin // запрос установлен
              InsArcNewMsg(Ptr,439+$2000); AddFixMessage(GetShortMsg(1,439,ObjZav[Ptr].Liter),0,6);
            end else
            if ObjZav[Ptr].bParam[1] then // не начата смена (В под током)
            begin // запрос сброшен
              if ObjZav[Ptr].bParam[17] then // выдано согласие смены направления
                InsArcNewMsg(Ptr,56+$2000)
              else // Снят запрос
                InsArcNewMsg(Ptr,440+$2000); AddFixMessage(GetShortMsg(1,440,ObjZav[Ptr].Liter),0,6);
            end;
{$IFDEF RMDSP}
          end;
{$ENDIF}
        end;
      end;
      inc(LiveCounter);
      ObjZav[Ptr].bParam[10] := zs;
      if ObjZav[Ptr].bParam[17] then
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := tab_page // согласие смены направления - мигать
      else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := ObjZav[Ptr].bParam[10]; // запрос смены направления

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[16];    // Л
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := not ObjZav[Ptr].bParam[11]; // 3ип
      if kj <> ObjZav[Ptr].bParam[6] then
      begin
        if kj then
        begin // вставлен КЖ
          ObjZav[Ptr].bParam[9] := false; // сброс отправления хоз.поезда
        end else // Изъят КЖ
        begin
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,357+$2000); AddFixMessage(GetShortMsg(1,357,ObjZav[Ptr].Liter),0,6);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,357+$2000);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[6] := kj;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[6];
      if ip1 <> ObjZav[Ptr].bParam[2] then
      begin
        if ObjZav[Ptr].bParam[2] then
        begin // занятие 1 известителя
          if not ObjZav[Ptr].bParam[6] then ObjZav[Ptr].bParam[9] := true; // дать отправление хоз.поезда
          if ObjZav[Ptr].ObjConstB[2] then
          begin // есть смена направления
            if ObjZav[Ptr].ObjConstB[3] then
            begin // подключаемый комплект
              if ObjZav[Ptr].ObjConstB[4] then
             begin // по приему
                if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                begin // комплект подключен
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true;
                end else // комплект отключен
                if config.ru = ObjZav[ptr].RU then Ip1Beep := true;
              end else
              if ObjZav[Ptr].ObjConstB[5] then
              begin // по отправлению
                if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then
                begin // комплект подключен
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true;
                end;
              end;
            end else // комплект включен постоянно
            if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true;
          end else
          if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true; // по приему звонить
        end;
      end;
      ObjZav[Ptr].bParam[2] := ip1;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];
      if ip2 <> ObjZav[Ptr].bParam[3] then
      begin
        if ObjZav[Ptr].bParam[3] then
        begin // занятие 2 известителя
          if ObjZav[Ptr].ObjConstB[2] then
          begin // есть смена направления
            if ObjZav[Ptr].ObjConstB[3] then
            begin // подключаемый комплект
              if ObjZav[Ptr].ObjConstB[4] then
              begin // по приему
                if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                begin // комплект подключен
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true;
                end else // комплект отключен
                if config.ru = ObjZav[ptr].RU then Ip2Beep := true;
              end else
              if ObjZav[Ptr].ObjConstB[5] then
              begin // по отправлению
                if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then
                begin // комплект подключен
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true;
                end;
              end;
            end else // комплект включен постоянно
            if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true;
          end else
          if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true; // по приему звонить
        end;
      end;
      ObjZav[Ptr].bParam[3] := ip2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
      if ObjZav[Ptr].ObjConstB[2] then
      begin // есть смена направления
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[5];

        if ObjZav[Ptr].ObjConstB[3] then
        begin // Комплект смены направления подключается
          inc(LiveCounter);
          if ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[8] then
          begin // неверно подключен комплект
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
          end else
          begin
            if ObjZav[Ptr].ObjConstB[4] then
            begin // Путь приема
              if ObjZav[Ptr].bParam[7] then
              begin // Д1П
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[1];
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4];
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
              end else
              if ObjZav[Ptr].bParam[8] then
              begin // Д2У
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
              end else
              begin
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
              end;
            end else
            if ObjZav[Ptr].ObjConstB[5] then
            begin // Путь отправления
              if ObjZav[Ptr].bParam[7] then
              begin // Д1П
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
              end else
              if ObjZav[Ptr].bParam[8] then
              begin // Д2У
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[1];
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4];
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
              end else
              begin
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
              end;
            end;
          end;
        end else
        begin // Комплект смены направления включен постоянно
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[1];
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4];
        end;
      end;
    end;

    // FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // выключено управление
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[3]{ div 8 * 8});
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;


    if ObjZav[Ptr].BaseObject > 0 then
    begin // последняя секция маршрута отправления прописана
      if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
      begin // секция разомкнута
        ObjZav[Ptr].bParam[14] := false; // сброс программного замыкания
        ObjZav[Ptr].bParam[15] := false; // сброс замыкалки маршрута отправления на перегон
        // сюда добавить обработку ловушки КЖ при необходимости
      end else
      begin // секция замкнута

      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepAB]');
  Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// Подготовка объекта вспомогательной смены направления на перегону для вывода на табло #16
procedure PrepVSNAB(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ВП
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ДВП
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // Во
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ДВо

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := ObjZav[Ptr].bParam[1];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepVSNAB]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта дачи поездного приема для вывода на табло #30
procedure PrepDSPP(Ptr : Integer);
  var egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  egs := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ЭГС
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // И

  // ЭГС
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if egs <> ObjZav[Ptr].bParam[1] then
      begin
        if egs then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,105+$2000); AddFixMessage(GetShortMsg(1,105,ObjZav[ObjZav[Ptr].BaseObject].Liter),0,6);
{$ELSE}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,105+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := egs;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepDSPP]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта ПАБ для вывода на табло #26
procedure PrepPAB(Ptr : Integer);
  var fp,gp,kj,o : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // По
  fp := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                        // ФП
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // предварительная команда
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ДСо
  ObjZav[Ptr].bParam[5] := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // оП
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // Л
  kj := not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // КЖ
  o  := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                       // о
  gp := not GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // ИП

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if kj <> ObjZav[Ptr].bParam[7] then
      begin
        if not kj then// Изъят КЖ
        begin
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,357+$2000); AddFixMessage(GetShortMsg(1,357,ObjZav[Ptr].Liter),0,6);
          end;
{$ELSE}
           InsArcNewMsg(Ptr,357+$2000);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[7] := kj;  // КЖ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[7];

      if o <> ObjZav[Ptr].bParam[8] then
      begin
        if o then
        begin // неисправен предупредительный светофор
          if WorkMode.FixedMsg then begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              InsArcNewMsg(ObjZav[Ptr].BaseObject,405+$1000); AddFixMessage(GetShortMsg(1,405,'П'+ObjZav[ObjZav[Ptr].BaseObject].Liter),0,4);
            end;
{$ELSE}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,405+$1000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[8] := o;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3]  := o;

      if gp <> ObjZav[Ptr].bParam[9] then
      begin //
        if not gp and (config.ru = ObjZav[ptr].RU) then Ip1Beep := not ObjZav[Ptr].bParam[1] and WorkMode.Upravlenie;
      end;
      ObjZav[Ptr].bParam[9] := gp; // ИП
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2]  := gp;

      if ObjZav[Ptr].BaseObject > 0 then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4];
      end else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := false;

      if not ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[5] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
      end else
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[1];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[5];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[4];

        if fp <> ObjZav[Ptr].bParam[2] then
        begin // включить звонок прибытия поезда
          if fp and (config.ru = ObjZav[ptr].RU) then SingleBeep := WorkMode.Upravlenie; // Дать сообщение о прибытии поезда на станцию (контроль прибытия)
        end;
        ObjZav[Ptr].bParam[2] := fp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := fp;

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[3];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
      end;
    end;

    inc(LiveCounter);
    // FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // выключено управление
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPAB]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта повторительного светофора для вывода на табло #31
procedure PrepPSvetofor(Ptr : Integer);
  var o : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  o := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // неисправность повторителя

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
      begin // основной сигнал открыт
        if o <> ObjZav[Ptr].bParam[1] then
        begin
          if o then
          begin
            if not ObjZav[Ptr].Timers[1].Active then
            begin
              ObjZav[Ptr].Timers[1].Active := true;
              ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
            end;
          end else
          begin
            ObjZav[Ptr].Timers[1].Active := false;
            ObjZav[Ptr].bParam[2] := false;
          end;
          ObjZav[Ptr].bParam[1] := o;
        end;

        if ObjZav[Ptr].Timers[1].Active then
        begin // неисправность
          if ObjZav[Ptr].Timers[1].First > LastTime then
          begin // ожидаем 4 секунды - повторитель не горит
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin // отобразить состояние повторителя прямым отображением
            if not ObjZav[Ptr].bParam[2] then
            begin
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if config.ru = ObjZav[ptr].RU then begin
                  InsArcNewMsg(Ptr,339+$1000); AddFixMessage(GetShortMsg(1,339,ObjZav[Ptr].Liter),4,4);
                end;
{$ELSE}
                InsArcNewMsg(Ptr,339+$1000); SingleBeep4 := true;
{$ENDIF}
              end;
              ObjZav[Ptr].bParam[2] := true;
            end;
          end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := o;
      end else
      begin // основной сигнал закрыт
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[1] := false;
        ObjZav[Ptr].bParam[2] := false;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPSvetofor]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта пригласительного сигнала для вывода на табло #7
procedure PrepPriglasit(Ptr : Integer);
  var i : integer; ps : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ps := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ПС
  if ObjZav[Ptr].ObjConstI[3] > 0 then
    ObjZav[Ptr].bParam[2] := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ПСо

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if ps <> ObjZav[Ptr].bParam[1] then
      begin
        if ps then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[Ptr].RU then begin
            InsArcNewMsg(Ptr,380+$2000); AddFixMessage(GetShortMsg(1,380,ObjZav[Ptr].Liter),0,6);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,380+$2000);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[1] := ps;

      i := ObjZav[Ptr].ObjConstI[1] * 2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i] := ObjZav[Ptr].bParam[1];
      if ObjZav[Ptr].ObjConstI[3] > 0 then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i+1] := ObjZav[Ptr].bParam[2];
        if ObjZav[Ptr].bParam[1] then
        begin // если ПС открыт - проверить исправность
          if ObjZav[Ptr].bParam[2] then
          begin
            if not ObjZav[Ptr].bParam[19] then
            begin // подождать 3 секунд
              if ObjZav[Ptr].Timers[1].Active then
              begin
                if ObjZav[Ptr].Timers[1].First < LastTime then
                begin
                  if WorkMode.FixedMsg then
                  begin
{$IFDEF RMDSP}
                    if (config.ru = ObjZav[Ptr].RU) then
                    begin
                      InsArcNewMsg(Ptr,454+$1000); AddFixMessage(GetShortMsg(1,454,ObjZav[Ptr].Liter),4,4);
                    end;
{$ELSE}
                    InsArcNewMsg(Ptr,454+$1000); SingleBeep4 := true;
{$ENDIF}
                    ObjZav[Ptr].bParam[19] := true; // фиксация неисправности ПС
                  end;
                end;
              end else
              begin
                ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
              end;
            end;
          end else
          begin
            ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[19] := false; // сброс фиксации неисправности ПС
          end;
        end else
        begin
          ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[19] := false; // сброс фиксации неисправности ПС
        end;
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPriglasit]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта надвига на горку для вывода на табло #32
procedure PrepNadvig(Ptr : Integer);
  var egs,sn,sm : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // зо
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // Жо
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // Бо
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // УН
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // Соо
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // оо
  egs := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // ЭГС
  sn := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                     // СН
  sm := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // СМ
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// В
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// П

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];

      if egs <> ObjZav[Ptr].bParam[7] then
      begin
        if egs then
        begin // зафиксировать нажатие ЭГС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin InsArcNewMsg(Ptr,105+$2000); AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter),0,6); end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[7] := egs;
      if sn <> ObjZav[Ptr].bParam[8] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sn then
          begin // получено согласие надвига
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin InsArcNewMsg(Ptr,381+$2000); AddFixMessage(GetShortMsg(1,381,ObjZav[Ptr].Liter),0,6); end;
{$ELSE}
            InsArcNewMsg(Ptr,381+$2000); SingleBeep6 := true;
{$ENDIF}
          end else
          begin // снято согласие надвига
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin InsArcNewMsg(Ptr,382+$2000); AddFixMessage(GetShortMsg(1,382,ObjZav[Ptr].Liter),0,6); end;
{$ELSE}
            InsArcNewMsg(Ptr,382+$2000); SingleBeep6 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[8] := sn;

      if sm <> ObjZav[Ptr].bParam[9] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sm then
          begin // получено согласие маневров
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin InsArcNewMsg(Ptr,383+$2000); AddFixMessage(GetShortMsg(1,383,ObjZav[Ptr].Liter),0,6); end;
{$ELSE}
            InsArcNewMsg(Ptr,383+$2000); SingleBeep6 := true;
{$ENDIF}
          end else
          begin // снято согласие маневров
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin InsArcNewMsg(Ptr,384+$2000); AddFixMessage(GetShortMsg(1,384,ObjZav[Ptr].Liter),0,6); end;
{$ELSE}
            InsArcNewMsg(Ptr,384+$2000); SingleBeep6 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[9] := sm;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[11];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[10];

      {FR4}
      ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepNadvig]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта маршрута надвига для вывода на табло #38
procedure PrepMarhNadvig(Ptr : Integer);
  var v : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  v := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  if v <> ObjZav[Ptr].bParam[1] then
  begin
    if v then
    begin // зафиксировано восприятие маршрута надвига
      SetNadvigParam(ObjZav[Ptr].ObjConstI[10]); // установить признак ГВ на маршрут надвига
    end;
  end;
  ObjZav[Ptr].bParam[1] := v;  //

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMarhNadvig]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта увязки с МЭЦ для вывода на табло #23
procedure PrepMEC(Ptr : Integer);
  var mo,mp,egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  mp := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МП
  mo := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // МО
  egs := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ЭГС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if mp <> ObjZav[Ptr].bParam[1] then
      begin
        if WorkMode.FixedMsg then
        begin
          if mp then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,385); AddFixMessage(GetShortMsg(1,385,ObjZav[Ptr].Liter),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,385);
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,386); AddFixMessage(GetShortMsg(1,386,ObjZav[Ptr].Liter),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,386);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := mp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      if mo <> ObjZav[Ptr].bParam[2] then
      begin
        if WorkMode.FixedMsg then
        begin
          if mo then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,387); AddFixMessage(GetShortMsg(1,387,ObjZav[Ptr].Liter),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,387);
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,388); AddFixMessage(GetShortMsg(1,388,ObjZav[Ptr].Liter),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,388);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := mo;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
      if egs <> ObjZav[Ptr].bParam[3] then
      begin
        if egs then
        begin // зафиксировать нажатие ЭГС
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,105+$2000); AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := egs;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[3];  //эгс
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepMEC]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта увязки с запросом согласия для вывода на табло #24
procedure PrepZapros(Ptr : Integer);
  var zpp,egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // Запрос ПО
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // получен запрос отправления
  egs := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // ЭГС
  ObjZav[Ptr].bParam[5] := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ИП
  zpp := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                       // Запрос ПП
  ObjZav[Ptr].bParam[7] := not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // П
  ObjZav[Ptr].bParam[8] := not GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ЧИ
  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);    // ЧКМ
  ObjZav[Ptr].bParam[10] := not GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//НИ
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  НКМ
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  МС
  ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  ФС

  if ObjZav[Ptr].ObjConstI[20] > 0 then
  begin
    OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[1] := ObjZav[Ptr].bParam[32];
  end;
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[10]; //ни
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[8];  //чи
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[11]; //нкм
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[9];  //чкм
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[7];  //п
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[5];  //ип

      if egs <> ObjZav[Ptr].bParam[3] then
      begin
        if egs then
        begin // зафиксировать нажатие ЭГС для светофора по отправлению (приему в соседний парк)
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,105+$2000); AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[3] := egs;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[3];  //эгс

      if zpp <> ObjZav[Ptr].bParam[6] then
      begin
        if zpp then
        begin // зафиксировать получение запроса поездного приема
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(ObjZav[Ptr].BaseObject,292); AddFixMessage(GetShortMsg(1,292,ObjZav[ObjZav[Ptr].BaseObject].Liter),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,292+$2000);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[6] := zpp;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[6]; //зпч
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[2]; //зопч
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[1]; //зон
      // светофор увязки
      if ObjZav[Ptr].ObjConstI[20] > 0 then
      begin
        OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[3] := ObjZav[Ptr].bParam[12]; //мс
        OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[5] := ObjZav[Ptr].bParam[13]; //фс
      end;
    end;

    // FR4
    ObjZav[Ptr].bParam[14] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // выключено управление
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[15] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // есть электротяга
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 *8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // есть 2 вида электротяги
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepZapros]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта маневровой колонки (вытяжки) для вывода на табло #25
procedure PrepManevry(Ptr : Integer);
  var rm,v : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  rm := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                        // РМ
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // оТ
  ObjZav[Ptr].bParam[3] := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // МИ
  ObjZav[Ptr].bParam[4] := not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // оИ/Д
  v := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                         // B
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ЭГС
  ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // предв.иск.размыкание
  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // РМК

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if rm <> ObjZav[Ptr].bParam[1] then
      begin
        if rm then
        begin
          ObjZav[Ptr].bParam[14] := false; // сброс признака выдачи команды на сервер
          ObjZav[Ptr].bParam[8] := false; // сброс признака выдачи команды РМ
        end;
        ObjZav[Ptr].bParam[1] := rm;
      end;

      if v <> ObjZav[Ptr].bParam[5] then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = ObjZav[ptr].RU) {$ENDIF} then
        begin
          if v then
          begin // Получено восприятие маневров
            InsArcNewMsg(Ptr,389+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,389,ObjZav[Ptr].Liter),0,6); {$ENDIF}
          end else
          begin // Снято восприятие маневров
            InsArcNewMsg(Ptr,390+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,390,ObjZav[Ptr].Liter),0,6); {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[5] := v;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2]  := ObjZav[Ptr].bParam[5]; //В
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3]  := ObjZav[Ptr].bParam[1]; //РМ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4]  := ObjZav[Ptr].bParam[2]; //оТ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5]  := ObjZav[Ptr].bParam[4]; //оИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[3]; //МИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7]  := ObjZav[Ptr].bParam[7]; //предв МИ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9]  := ObjZav[Ptr].bParam[6]; //эгс
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[8]; //выдана команда РМ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[9]; //РМК
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepManevry]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка одиночного датчика для вывода на табло #33
procedure PrepSingle(Ptr : Integer);
  var b : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  if ObjZav[Ptr].ObjConstB[1] then // инверсия состояния
    b := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31])
  else // прямое состояние
    b := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  if not ObjZav[Ptr].bParam[31] or ObjZav[Ptr].bParam[32] then
  begin
    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    end;
  end else
  begin
    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    end;
    if ObjZav[Ptr].bParam[1] <> b then
    begin
      if ObjZav[Ptr].ObjConstB[2] then
      begin // регистрация изменения состояния датчика - вывод сообщения оператору
        if b then
        begin
          if ObjZav[Ptr].ObjConstI[2] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then begin
                if ObjZav[Ptr].ObjConstI[4] = 1 then InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[2]) else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2]);
                if ObjZav[Ptr].ObjConstI[4] = 1 then // сообщение фиксируемое
                  AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[2]],4,3)
                else
                begin // сообщение диалоговое
                  PutShortMsg(ObjZav[Ptr].ObjConstI[4],LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[2]]); SingleBeep := true;
                end;
              end;
{$ELSE}
              if ObjZav[Ptr].ObjConstI[4] = 1 then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[2]); SingleBeep3 := true;
              end else
              begin
                InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2]); SingleBeep := true;
              end;
{$ENDIF}
            end;
        end else
        begin
          if ObjZav[Ptr].ObjConstI[3] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then begin
                if ObjZav[Ptr].ObjConstI[5] = 1 then InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[3]) else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3]);
                if ObjZav[Ptr].ObjConstI[5] = 1 then // сообщение фиксируемое
                  AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[3]],4,3)
                else
                begin // сообщение диалоговое
                  PutShortMsg(ObjZav[Ptr].ObjConstI[5],LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[3]]); SingleBeep := true;
                end;
              end;
{$ELSE}
              if ObjZav[Ptr].ObjConstI[5] = 1 then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[3]); SingleBeep3 := true;
              end else
              begin
                InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3]); SingleBeep := true;
              end;
{$ENDIF}
            end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := b;
    end;
    if ObjZav[Ptr].VBufferIndex > 0 then
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
  end;
except
  reportf('Ошибка [MainLoop.PrepSingle]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Доступ к внутренним параметрам объекта зависимостей #35
procedure PrepInside(Ptr : Integer);
begin
try
  inc(LiveCounter);
  if ObjZav[Ptr].BaseObject > 0 then
  begin
    case ObjZav[Ptr].ObjConstI[1] of
      1 : begin // Н
        ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[8] or
          (ObjZav[ObjZav[Ptr].BaseObject].bParam[9] and ObjZav[ObjZav[Ptr].BaseObject].bParam[14]);
      end;
      2 : begin // НМ
        ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[6] or
          (ObjZav[ObjZav[Ptr].BaseObject].bParam[7] and ObjZav[ObjZav[Ptr].BaseObject].bParam[14]);
      end;
      3 : begin // Н&НМ
        ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[6] or ObjZav[ObjZav[Ptr].BaseObject].bParam[8] or
          ((ObjZav[ObjZav[Ptr].BaseObject].bParam[7] or ObjZav[ObjZav[Ptr].BaseObject].bParam[9]) and ObjZav[ObjZav[Ptr].BaseObject].bParam[14]);
      end;
    else
      ObjZav[Ptr].bParam[1] := false;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepInside]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта контроля электропитания для вывода на табло #34
procedure PrepPitanie(Ptr : Integer);
  var k1f,k2f,k3f,vf1,vf2,kpp,kpa,szk,ak,k1shvp,k2shvp,knz,knz2,dsn,dn,rsv : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  k1f    := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  k2f    := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  k3f    := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  vf1    := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // контроль включения нагрузки на 1 фидер
  vf2    := not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // контроль включения нагрузки на 2 фидер
  kpp    := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  kpa    := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  szk    := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  ak     := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  k1shvp := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //
  k2shvp := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //
  knz    := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //
  knz2   := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //
  dsn    := GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //
  dn     := GetFR3(ObjZav[Ptr].ObjConstI[15],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //
  rsv    := GetFR3(ObjZav[Ptr].ObjConstI[16],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if dsn <> ObjZav[Ptr].bParam[14] then
      begin
        if WorkMode.FixedMsg then
        begin
          if dsn then
          begin
            InsArcNewMsg(Ptr,358+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,358,''),4,4); {$ELSE} SingleBeep4 := true; {$ENDIF}
          end else
          begin
            InsArcNewMsg(Ptr,359+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,359,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[14] := dsn;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := dsn;
      if dn <> ObjZav[Ptr].bParam[15] then
      begin
        if WorkMode.FixedMsg then
        begin
          if dn then
          begin
            if not dsn then
            begin
              InsArcNewMsg(Ptr,360+$2000); {$IFDEF RMDSP} SingleBeep2 := WorkMode.Upravlenie; ShowShortMsg(360,LastX,LastY,''); {$ENDIF}
            end;
          end else
          begin
            if not dsn then
            begin
              InsArcNewMsg(Ptr,361+$2000); {$IFDEF RMDSP} SingleBeep2 := WorkMode.Upravlenie; ShowShortMsg(361,LastX,LastY,''); {$ENDIF}
            end;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[15] := dn;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := dn;
      if rsv <> ObjZav[Ptr].bParam[16] then
      begin
        if WorkMode.FixedMsg and not dsn and rsv then
        begin
          InsArcNewMsg(Ptr,362+$2000); {$IFDEF RMDSP} SingleBeep2 := WorkMode.Upravlenie; ShowShortMsg(362,LastX,LastY,''); {$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[16] := rsv;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := rsv;

      if ObjZav[Ptr].ObjConstB[1] then
      begin // Для малой станции (один контроль активных фидеров)
        if k1f <> ObjZav[Ptr].bParam[1] then
        begin
          if WorkMode.FixedMsg then
            if k1f then
            begin
              InsArcNewMsg(Ptr,303+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,303,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end else
            begin
              InsArcNewMsg(Ptr,302+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,302,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := k1f;
        if k2f <> ObjZav[Ptr].bParam[2] then
        begin
          if WorkMode.FixedMsg then
            if k2f then
            begin
              InsArcNewMsg(Ptr,305+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,305,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end else
            begin
              InsArcNewMsg(Ptr,304+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,304,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := k2f;
        if k3f <> ObjZav[Ptr].bParam[3] then
        begin
          if WorkMode.FixedMsg then
            if k3f then
            begin
              InsArcNewMsg(Ptr,308+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,308,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := k3f;
        if vf1 <> ObjZav[Ptr].bParam[4] then
        begin
          if WorkMode.FixedMsg then
            if vf1 then
            begin
              InsArcNewMsg(Ptr,306+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,306,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end else
            begin
              InsArcNewMsg(Ptr,307+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,307,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := vf1;
        ObjZav[Ptr].bParam[1] := k1f;
        ObjZav[Ptr].bParam[2] := k2f;
        ObjZav[Ptr].bParam[3] := k3f;
        ObjZav[Ptr].bParam[4] := vf1;
        ObjZav[Ptr].bParam[5] := false;
      end else
      begin // Для крупной станции (два контроля активных фидеров)
        if k1f <> ObjZav[Ptr].bParam[1] then
        begin
          if WorkMode.FixedMsg then
            if k1f then
            begin
              InsArcNewMsg(Ptr,303+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,303,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end else
            begin
              InsArcNewMsg(Ptr,302+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,302,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := k1f;
        if k2f <> ObjZav[Ptr].bParam[2] then
        begin
          if WorkMode.FixedMsg then
            if k2f then
            begin
              InsArcNewMsg(Ptr,305+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,305,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end else
            begin
              InsArcNewMsg(Ptr,304+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,304,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := k2f;
        if k3f <> ObjZav[Ptr].bParam[3] then
        begin
          if WorkMode.FixedMsg then
            if k3f then
            begin
              InsArcNewMsg(Ptr,308+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,308,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := k3f;
        if vf1 <> ObjZav[Ptr].bParam[4] then
        begin
          if WorkMode.FixedMsg then
            if vf1 then
            begin
              InsArcNewMsg(Ptr,306+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,306,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := vf1;
        if vf2 <> ObjZav[Ptr].bParam[5] then
        begin
          if WorkMode.FixedMsg then
            if vf2 then
            begin
              InsArcNewMsg(Ptr,307+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,307,''),5,2); {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
        end;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := vf2;
        ObjZav[Ptr].bParam[1] := k1f;
        ObjZav[Ptr].bParam[2] := k2f;
        ObjZav[Ptr].bParam[3] := k3f;
        ObjZav[Ptr].bParam[4] := vf1;
        ObjZav[Ptr].bParam[5] := vf2;
      end;

      if kpp <> ObjZav[Ptr].bParam[6] then
      begin
        if WorkMode.FixedMsg and kpp then begin InsArcNewMsg(Ptr,284+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,284,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF} end;
      end;
      if kpa <> ObjZav[Ptr].bParam[7] then
      begin
        if WorkMode.FixedMsg and kpa then begin InsArcNewMsg(Ptr,285+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,285,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF} end;
      end;
      ObjZav[Ptr].bParam[6] := kpp;
      ObjZav[Ptr].bParam[7] := kpa;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := kpa or kpp;
      if szk <> ObjZav[Ptr].bParam[8] then
      begin
        if WorkMode.FixedMsg then
        begin
          if szk then begin InsArcNewMsg(Ptr,286+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,286,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF} end
          else begin InsArcNewMsg(Ptr,404+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,404,''),0,2);  {$ELSE} SingleBeep2 := true; {$ENDIF}end;
        end;
      end;
      ObjZav[Ptr].bParam[8] := szk;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := szk;
      if ak <> ObjZav[Ptr].bParam[9] then
      begin
        if WorkMode.FixedMsg and ak then begin InsArcNewMsg(Ptr,287+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,287,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF} end;
      end;
      ObjZav[Ptr].bParam[9] := ak;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ak;
      if k1shvp <> ObjZav[Ptr].bParam[10] then
      begin
        if WorkMode.FixedMsg and k1shvp then begin InsArcNewMsg(Ptr,288+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,288,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF} end;
      end;
      ObjZav[Ptr].bParam[10] := k1shvp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := k1shvp;
      if k2shvp <> ObjZav[Ptr].bParam[11] then
      begin
        if WorkMode.FixedMsg and k2shvp then begin InsArcNewMsg(Ptr,289+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,289,''),4,3); {$ELSE} SingleBeep3 := true; {$ENDIF} end;
      end;
      ObjZav[Ptr].bParam[11] := k2shvp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := k2shvp;
      if knz <> ObjZav[Ptr].bParam[12] then
      begin
        if WorkMode.FixedMsg and knz then begin InsArcNewMsg(Ptr,290+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,290,''),4,1); {$ELSE} SingleBeep := true; {$ENDIF} end;
      end;
      ObjZav[Ptr].bParam[12] := knz;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := knz;
      if knz2 <> ObjZav[Ptr].bParam[13] then
      begin
        if WorkMode.FixedMsg and knz2 then begin InsArcNewMsg(Ptr,291+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,291,''),4,1); {$ELSE} SingleBeep := true; {$ENDIF} end;
      end;
      ObjZav[Ptr].bParam[13] := knz2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := knz2;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepPitanie]');
  Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// Подготовка кнопки(вкл/откл) для вывода на табло #36
procedure PrepSwitch(Ptr : Integer);
  var b : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  if ObjZav[Ptr].ObjConstB[1] then // инверсия состояния
    b := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31])
  else // прямое состояние
    b := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  if not ObjZav[Ptr].bParam[31] or ObjZav[Ptr].bParam[32] then
  begin
    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    end;
  end else
  begin
    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    end;
    if ObjZav[Ptr].bParam[1] <> b then
    begin
      if ObjZav[Ptr].ObjConstB[2] then
      begin // регистрация изменения состояния датчика - вывод сообщения оператору
        if b then
        begin
          if ObjZav[Ptr].ObjConstI[2] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then begin
                InsArcNewMsg(Ptr,2); SingleBeep2 := WorkMode.Upravlenie; PutShortMsg(5,LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[2]]);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2]);
{$ENDIF}
            end;
        end else
        begin
          if ObjZav[Ptr].ObjConstI[3] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then begin
                InsArcNewMsg(Ptr,3); SingleBeep2 := WorkMode.Upravlenie; PutShortMsg(5,LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[3]]);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3]);
{$ENDIF}
            end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := b;
    end;
    if ObjZav[Ptr].VBufferIndex > 0 then
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
  end;
except
  reportf('Ошибка [MainLoop.PrepSwitch]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка к выводу на табло контроллера ТУМС/МСТУ #37
procedure PrepIKTUMS(Ptr : Integer);
  var r,ao,ar,a,b,p,kp1,kp2,otu,rotu : Boolean; i : integer; myt : byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  r  := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //Р
  ao := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //Ао
  ar := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //Ар
  ObjZav[Ptr].bParam[4]  := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //мультивибратор
  kp1 := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //КП1
  kp2 := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //КП2
  ObjZav[Ptr].bParam[7]  := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //К
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //РУ
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //оУ
  otu := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //оТУ
  rotu := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //РоТУ

  // получить состояние занятости стойки в маршрутной команде
  i := ObjZav[Ptr].ObjConstI[8] div 8;
  if i > 0 then
  begin
    myt := FR3[i] and $38;
    if myt = $38 then
    begin // выполняется установка маршрута
      ObjZav[Ptr].bParam[8] := true; ObjZav[Ptr].bParam[9] := false; ObjZav[Ptr].bParam[10] := false;
    end else
    begin
      ObjZav[Ptr].bParam[8] := false;
      if myt = $28 then
      begin // успешное завершение устаноки маршрута
        ObjZav[Ptr].bParam[9] := true; ObjZav[Ptr].bParam[10] := false;
      end else
      begin // неудачное завершение установки маршрута
        ObjZav[Ptr].bParam[9] := false; ObjZav[Ptr].bParam[10] := true;
      end;
    end;
  end;

  a := false; b := false; p := false;

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if kp1 <> ObjZav[Ptr].bParam[5] then
      begin // неисправно основное питание стойки
        if WorkMode.FixedMsg then
        begin
          if kp1 then
          begin
            InsArcNewMsg(Ptr,493+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,493,ObjZav[Ptr].Liter),4,4); {$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[5] := kp1;

      if kp2 <> ObjZav[Ptr].bParam[6] then
      begin // неисправно резервное питание стойки
        if WorkMode.FixedMsg then
        begin
          if kp2 then
          begin
            InsArcNewMsg(Ptr,494+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,494,ObjZav[Ptr].Liter),4,4); {$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[6] := kp2;

      if ao <> ObjZav[Ptr].bParam[2] then
      begin // остановка 1 комплекта МПСУ
        if WorkMode.FixedMsg then
        begin
          a := true;
          if ao then
          begin // остановлен комплект
            InsArcNewMsg(Ptr,366+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,366,ObjZav[Ptr].Liter),4,4); {$ENDIF}
          end else
          begin // включен комплект
            InsArcNewMsg(Ptr,367+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,367,ObjZav[Ptr].Liter),5,0); {$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := ao;
      if ar <> ObjZav[Ptr].bParam[3] then
      begin // остановка 2 комплекта МПСУ
        if WorkMode.FixedMsg then
        begin
          b := true;
          if ar then
          begin // остановлен комплект
            InsArcNewMsg(Ptr,368+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,368,ObjZav[Ptr].Liter),4,4); {$ENDIF}
          end else
          begin // включен комплект
            InsArcNewMsg(Ptr,369+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,369,ObjZav[Ptr].Liter),5,0); {$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := ar;
      if ObjZav[Ptr].ObjConstB[1] then
      begin
        if otu <> ObjZav[Ptr].bParam[13] then
        begin // изменение состояния интерфейса ОТУ
          if WorkMode.FixedMsg then
          begin
            if otu then
            begin // остановлен интерфейс ОТУ комплекта
              InsArcNewMsg(Ptr,500+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,500,ObjZav[Ptr].Liter),4,4); {$ENDIF}
            end else
            begin // включен интерфейс ОТУ комплекта
              InsArcNewMsg(Ptr,501+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,501,ObjZav[Ptr].Liter),5,0); {$ENDIF}
            end;
          end;
        end;
        if rotu <> ObjZav[Ptr].bParam[14] then
        begin // изменение состояния интерфейса РОТУ
          if WorkMode.FixedMsg then
          begin
            if rotu then
            begin // остановлен интерфейс РОТУ комплекта
              InsArcNewMsg(Ptr,502+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,502,ObjZav[Ptr].Liter),4,4); {$ENDIF}
            end else
            begin // включен интерфейс РОТУ комплекта
              InsArcNewMsg(Ptr,503+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,503,ObjZav[Ptr].Liter),5,0); {$ENDIF}
            end;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[14] := rotu;

      if r <> ObjZav[Ptr].bParam[1] then
      begin // переключение комплектов МПСУ
        if WorkMode.FixedMsg then
        begin
          p := true;
        end;
        ObjZav[Ptr].bParam[1] := r;
      end;
      if p or a or b then
      begin // зафиксировать переключение комплектов МПСУ
        if r and not ar then
        begin // включен резервный комплект
          InsArcNewMsg(Ptr,365+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,365,ObjZav[Ptr].Liter),5,2); {$ENDIF}
        end else
        if not r and not ao then
        begin // включен основной комплект
          InsArcNewMsg(Ptr,364+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,364,ObjZav[Ptr].Liter),5,2); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[1] := r;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];   // Р
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];   // АО
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];   // АР
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];   // ввод (мультивибратор)
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5];   // КП1
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];   // КП2
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7];   // К
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[8];   // ИК занят установкой маршрута
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[9];  // ИК зарершил установку неудачей
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[10]; // ИК завершил установку удачей
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[13]; // ОТУ
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[14]; // РОТУ
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepIKTUMS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Контроль режима управления #39
var ops : array[1..3] of Integer;

procedure PrepKRU(Ptr : Integer);
  var group,i : integer; lock : boolean; ps : array[1..3] of Integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //РУ
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ОУ
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //СУ
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ВСУ
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ДУ
  if ObjZav[Ptr].ObjConstI[7] > 0 then
    ObjZav[Ptr].bParam[6] := not GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]) //КРУ
  else
    ObjZav[Ptr].bParam[6] := true;
  group := ObjZav[Ptr].ObjConstI[1];
  if ObjZav[Ptr].ObjConstI[1] < 1 then group := 0;
  if ObjZav[Ptr].ObjConstI[1] > 8 then group := 0;
  // Присвоить параметры управления
  WorkMode.BU[group] := not ObjZav[Ptr].bParam[31];
  WorkMode.NU[group] := ObjZav[Ptr].bParam[32];
  if ObjZav[Ptr].ObjConstI[2] > 0 then WorkMode.RU[group]  := ObjZav[Ptr].bParam[1];
  if ObjZav[Ptr].ObjConstI[3] > 0 then WorkMode.OU[group]  := ObjZav[Ptr].bParam[2];
  if ObjZav[Ptr].ObjConstI[4] > 0 then WorkMode.SU[group]  := ObjZav[Ptr].bParam[3];
  if ObjZav[Ptr].ObjConstI[5] > 0 then WorkMode.VSU[group] := ObjZav[Ptr].bParam[4];
  if ObjZav[Ptr].ObjConstI[6] > 0 then WorkMode.DU[group]  := ObjZav[Ptr].bParam[5];
  WorkMode.KRU[group] := ObjZav[Ptr].bParam[6];

  if group = 0 then
  begin // Определить признак фиксации сообщений
    lock := false;
    if WorkMode.BU[0] then
    begin
      ObjZav[Ptr].Timers[1].Active := false; lock := true;
    end else
    begin
      if ObjZav[Ptr].Timers[1].Active then
      begin
        if ObjZav[Ptr].Timers[1].First < LastTime then
        begin // завершена выдержка после включения обмена с серверами
          lock := false; ObjZav[Ptr].Timers[1].Active := false;
        end;
      end else
      begin // Начать отсчет задержки начала регистрации сообщений
        ObjZav[Ptr].Timers[1].First := LastTime + 15/80000; ObjZav[Ptr].Timers[1].Active := true;
      end;
    end;
    WorkMode.FixedMsg := not (StartRM or WorkMode.NU[0] or lock);
  end;
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := not ObjZav[Ptr].bParam[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[5];
    end;
  end;

  inc(LiveCounter);
  // проверить количество открытых пригласительных сигналов
  ps[1] := 0; ps[2] := 0; ps[3] := 0;
  for i := 1 to WorkMode.LimitObjZav do
    if ObjZav[i].TypeObj = 7 then
    begin
      if ObjZav[i].bParam[1] then inc(ps[ObjZav[i].RU]);
    end;
  // Район 1
  if ps[1] <> ops[1] then
  begin
    if (ps[1] > 1) and (ps[1] > ops[1]) then
    begin
      if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 1) {$ENDIF} then
      begin
        InsArcNewMsg(Ptr,455+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,''),4,3); {$ENDIF}
      end;
      ObjZav[Ptr].bParam[19] := true;
    end else
      ObjZav[Ptr].bParam[19] := false;
    ops[1] := ps[1];
  end;
  // Район 2
  if ps[2] <> ops[2] then
  begin
    if (ps[2] > 1) and (ps[2] > ops[2]) then
    begin
      if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 2) {$ENDIF} then
      begin
        InsArcNewMsg(Ptr,455+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,''),4,3); {$ENDIF}
      end;
      ObjZav[Ptr].bParam[20] := true;
    end else
      ObjZav[Ptr].bParam[20] := false;
    ops[2] := ps[2];
  end;
  // Район 3
  if ps[3] <> ops[3] then
  begin
    if (ps[3] > 1) and (ps[3] > ops[3]) then
    begin
      if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 3) {$ENDIF} then
      begin
        InsArcNewMsg(Ptr,455+$1000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,''),4,3); {$ENDIF}
      end;
      ObjZav[Ptr].bParam[21] := true;
    end else
      ObjZav[Ptr].bParam[21] := false;
    ops[3] := ps[3];
  end;
except
  reportf('Ошибка [MainLoop.PrepKRU]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Схема известителя #40
procedure PrepIzvPoezd(Ptr : Integer);
  var i : integer; z : boolean;
begin
try
  inc(LiveCounter);
  z := false;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      if not ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] then
      begin
        z := true;
        break;
      end;
    end;
  ObjZav[Ptr].bParam[1] := z;
except
  reportf('Ошибка [MainLoop.PrepIzvPoezd]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Схема перезамыкания поездного маршрута на маневроаый (ВП для стрелки в пути) #42
procedure PrepVP(Ptr : Integer);
  var i,o : integer; z : boolean;
begin
try
  inc(LiveCounter);
  z := ObjZav[ObjZav[Ptr].UpdateObject].bParam[2]; // Получить замыкалку секции в пути
  if ObjZav[Ptr].bParam[3] <> z then
    if z then
    begin // произошло размыкание секции в пути
      ObjZav[Ptr].bParam[1] := false; // Снять признак поездного приема на путь
      ObjZav[Ptr].bParam[2] := false; // Снять признак разрешения перезамыкания поездного маршрута
    end;
  ObjZav[Ptr].bParam[3] := z;
  if ObjZav[Ptr].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] and
     ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[3] then
  begin // есть признак поездного приема, замыкание, отсутствие РИ  и свободность стрелочной секции в пути, и маневровый сигнал закрыт
    z := true;
    for i := 1 to 4 do
    begin // проверить наличие плюсового контроля стрелок в пути
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] then z := false;
      end;
    end;
    if z then
    begin // все стрелки в пути имеют контроль по плюсу
      o := ObjZav[Ptr].ObjConstI[10];
      if o > 0 then
      begin // проверка враждебного маневрового светофора
        if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] or ObjZav[o].bParam[6] or ObjZav[o].bParam[7] then z := false;
      end;
    end;
    // установить признак разрешения перезамыкания поездного маршрута на маневровый по результатам проверки
    ObjZav[Ptr].bParam[2] := z;
  end else
    ObjZav[Ptr].bParam[2] := false; // снять разрешение перезамыкания поездного маршрута
except
  reportf('Ошибка [MainLoop.PrepVP]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта охранности стрелок в пути для маршрута отправления #41
procedure PrepVPStrelki(Ptr : Integer);
  var o,p : integer; z : boolean;
begin
try
  inc(LiveCounter);
  o := ObjZav[Ptr].BaseObject;
  if o > 0 then
  begin // если выходной сигнал с пути открыт поездным или на поездной выдержке времени - установить признак поездного отправления
    if ObjZav[o].bParam[3] or ObjZav[o].bParam[4] or ObjZav[o].bParam[8] then ObjZav[Ptr].bParam[20] := true;
  end;

  o := ObjZav[Ptr].UpdateObject; // Индекс секции маршрута отправления, находящейся на трассировке
  if o > 0 then
  begin

    z := ObjZav[o].bParam[2]; // Получить замыкалку перекрывной секции маршрута отправления
    if ObjZav[Ptr].bParam[5] <> z then
      if z then
      begin // произошло размыкание перекрывной секции маршрута отправления
        ObjZav[Ptr].bParam[20] := false; // Снять признак поездного маршрута отправления
      end;
    ObjZav[Ptr].bParam[5] := z;
    if not (ObjZav[Ptr].bParam[20] or ObjZav[Ptr].bParam[21]) then exit;

    p := ObjZav[Ptr].ObjConstI[1]; // Индекс охранной стрелки 1
    if p > 0 then
    begin // Обработать состояние охранной стрелки 1
      inc(LiveCounter);
      // Трассировка маршрута через описание охранности
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[5] = 0) or
           ((ObjZav[Ptr].ObjConstI[5] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[23] := true; // установить предварительное замыкание охранной стрелки 1
          if ObjZav[Ptr].ObjConstB[3] then // Охранная должна быть в плюсе
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[8] := true;
          end else
          if ObjZav[Ptr].ObjConstB[4] then // Охранная должна быть в минусе
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[8] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[23] := false; // нет предварительного замыкания охранной стрелки
      if not ObjZav[Ptr].bParam[8] then
      begin // Трассировка маршрута через описание охранности
        ObjZav[Ptr].bParam[1] := not ObjZav[o].bParam[8] and not ObjZav[o].bParam[14];
      end else
        ObjZav[Ptr].bParam[1] := false;
      if not ObjZav[ObjZav[p].BaseObject].bParam[5] then
        ObjZav[ObjZav[p].BaseObject].bParam[5] := ObjZav[Ptr].bParam[1];
      if not ObjZav[ObjZav[p].BaseObject].bParam[8] then
        ObjZav[ObjZav[p].BaseObject].bParam[8] := ObjZav[Ptr].bParam[8];
      if not ObjZav[ObjZav[p].BaseObject].bParam[23] then
        ObjZav[ObjZav[p].BaseObject].bParam[23] := ObjZav[Ptr].bParam[23];
    end;

    p := ObjZav[Ptr].ObjConstI[2]; // Индекс охранной стрелки 2
    if p > 0 then
    begin // Обработать состояние охранной стрелки 2
      inc(LiveCounter);
      // Трассировка маршрута через описание охранности
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[6] = 0) or
           ((ObjZav[Ptr].ObjConstI[6] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[24] := true; // установить предварительное замыкание охранной стрелки 2
          if ObjZav[Ptr].ObjConstB[6] then // Охранная должна быть в плюсе
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[9] := true;
          end else
          if ObjZav[Ptr].ObjConstB[7] then // Охранная должна быть в минусе
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[9] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[24] := false; // нет предварительного замыкания охранной стрелки
      if not ObjZav[Ptr].bParam[9] then
      begin // Трассировка маршрута через описание охранности
        ObjZav[Ptr].bParam[2] := not ObjZav[o].bParam[8] and not ObjZav[o].bParam[14];
      end else
        ObjZav[Ptr].bParam[2] := false;
      if not ObjZav[ObjZav[p].BaseObject].bParam[5] then
        ObjZav[ObjZav[p].BaseObject].bParam[5] := ObjZav[Ptr].bParam[2];
      if not ObjZav[ObjZav[p].BaseObject].bParam[8] then
        ObjZav[ObjZav[p].BaseObject].bParam[8] := ObjZav[Ptr].bParam[9];
      if not ObjZav[ObjZav[p].BaseObject].bParam[23] then
        ObjZav[ObjZav[p].BaseObject].bParam[23] := ObjZav[Ptr].bParam[24];
    end;

    p := ObjZav[Ptr].ObjConstI[3]; // Индекс охранной стрелки 3
    if p > 0 then
    begin // Обработать состояние охранной стрелки 3
      inc(LiveCounter);
      // Трассировка маршрута через описание охранности
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[7] = 0) or
           ((ObjZav[Ptr].ObjConstI[7] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[25] := true; // установить предварительное замыкание охранной стрелки 3
          if ObjZav[Ptr].ObjConstB[9] then // Охранная должна быть в плюсе
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[10] := true;
          end else
          if ObjZav[Ptr].ObjConstB[10] then // Охранная должна быть в минусе
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[10] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[25] := false; // нет предварительного замыкания охранной стрелки
      if not ObjZav[Ptr].bParam[10] then
      begin // Трассировка маршрута через описание охранности
        ObjZav[Ptr].bParam[3] := not ObjZav[o].bParam[8] and not ObjZav[o].bParam[14];
      end else
        ObjZav[Ptr].bParam[3] := false;
      if not ObjZav[ObjZav[p].BaseObject].bParam[5] then
        ObjZav[ObjZav[p].BaseObject].bParam[5] := ObjZav[Ptr].bParam[3];
      if not ObjZav[ObjZav[p].BaseObject].bParam[8] then
        ObjZav[ObjZav[p].BaseObject].bParam[8] := ObjZav[Ptr].bParam[10];
      if not ObjZav[ObjZav[p].BaseObject].bParam[23] then
        ObjZav[ObjZav[p].BaseObject].bParam[23] := ObjZav[Ptr].bParam[25];
    end;

    p := ObjZav[Ptr].ObjConstI[4]; // Индекс охранной стрелки 4
    if p > 0 then
    begin // Обработать состояние охранной стрелки 4
      inc(LiveCounter);
      // Трассировка маршрута через описание охранности
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[8] = 0) or
           ((ObjZav[Ptr].ObjConstI[8] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[26] := true; // установить предварительное замыкание охранной стрелки 4
          if ObjZav[Ptr].ObjConstB[12] then // Охранная должна быть в плюсе
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[11] := true;
          end else
          if ObjZav[Ptr].ObjConstB[13] then // Охранная должна быть в минусе
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[11] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[26] := false; // нет предварительного замыкания охранной стрелки
      if not ObjZav[Ptr].bParam[11] then
      begin // Трассировка маршрута черех описание охранности
        ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[8] and not ObjZav[o].bParam[14];
      end else
        ObjZav[Ptr].bParam[4] := false;
      if not ObjZav[ObjZav[p].BaseObject].bParam[5] then
        ObjZav[ObjZav[p].BaseObject].bParam[5] := ObjZav[Ptr].bParam[4];
      if not ObjZav[ObjZav[p].BaseObject].bParam[8] then
        ObjZav[ObjZav[p].BaseObject].bParam[8] := ObjZav[Ptr].bParam[11];
      if not ObjZav[ObjZav[p].BaseObject].bParam[23] then
        ObjZav[ObjZav[p].BaseObject].bParam[23] := ObjZav[Ptr].bParam[26];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepVPStrelki]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Подготовка объекта выбора зоны оповещения #45
procedure PrepKNM(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //КНМ
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ВС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepKNM]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Объект исключения пути из маневрового района #43
procedure PrepOPI(Ptr : Integer);
  var k,o,p,j : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // опи
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // рпо

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      inc(LiveCounter);
      k := ObjZav[Ptr].BaseObject;
      if k > 0 then
      begin
        if ObjZav[k].bParam[3] then
        begin // не замкнуты маневры
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2];
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
        end else
        begin // маневры замкнуты
          if ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin // есть ОПИ и РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[2] then
          begin // есть ОПИ нет РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin // есть ОПИ нет РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin // нет ОПИ и РПО
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end;
        end;
      end;
    end;
  end;
  o := ObjZav[Ptr].BaseObject;
  if (o > 0) and not (ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2]) then
  begin // протрассировать выезд на пути из маневрового района
    inc(LiveCounter);
    if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
    o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 50;
    while j > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin
              ObjZav[ObjZav[o].BaseObject].bParam[10] := true;
            end;
            3 : begin
              ObjZav[ObjZav[o].BaseObject].bParam[11] := true;
            end;
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
        44 : begin
          if not ObjZav[o].bParam[1] then ObjZav[o].bParam[1] := ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[10];
          if not ObjZav[o].bParam[2] then ObjZav[o].bParam[2] := ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[11];
          if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
          else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
        end;
        48 : begin // РПо
          ObjZav[o].bParam[1] := true; break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(j);
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepOPI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Объект подсветки охранности стрелок маневрового района
procedure PrepSOPI(Ptr : Integer);
  var o,p,j : integer;
begin
try
  if ObjZav[Ptr].UpdateObject = 0 then exit;
  inc(LiveCounter);

  o := ObjZav[Ptr].BaseObject;
  if (o > 0) and
     ObjZav[o].bParam[1] and not ObjZav[o].bParam[4] and ObjZav[o].bParam[5] and not ObjZav[Ptr].bParam[2] and // маневровый район замкнут
     (MarhTracert[1].Rod = MarshP) and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[8] then // путь трассируется в поездном маршруте
  begin
    // отобразить охранность стрелок маневрового района
    if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
    o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 100;
    while j > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin
              if ObjZav[ObjZav[o].BaseObject].bParam[11] then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[5] then ObjZav[ObjZav[o].BaseObject].bParam[5] := true; break;
              end;
            end;
            3 : begin
              if ObjZav[ObjZav[o].BaseObject].bParam[10] then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[5] then ObjZav[ObjZav[o].BaseObject].bParam[5] := true; break;
              end;
            end;
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
        48 : begin // РПо
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(j);
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepSOPI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// подготовка объекта СМИ #44
procedure PrepSMI(Ptr : Integer);
begin
try
{  o := ObjZav[Ptr].UpdateObject; // Индекс стрелки маневрового района
  if not ObjZav[ObjZav[o].BaseObject].bParam[5] then
    ObjZav[ObjZav[o].BaseObject].bParam[5] := ObjZav[Ptr].bParam[5];
  if not ObjZav[ObjZav[o].BaseObject].bParam[8] then
    ObjZav[ObjZav[o].BaseObject].bParam[8] := ObjZav[Ptr].bParam[8];}
except
  reportf('Ошибка [MainLoop.PrepSMI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// подготовка объекта РПО #48
procedure PrepRPO(Ptr : Integer);
begin
try
//  if ObjZav[Ptr].BaseObject > 0 then
//  begin
//
//  end;
except
  reportf('Ошибка [MainLoop.PrepRPO]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// подготовка объекта "Светофор с автодействием" #46
procedure PrepAutoSvetofor(Ptr : Integer);
{$IFDEF RMDSP}   var i,o : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
try
  inc(LiveCounter);
  if not ObjZav[Ptr].bParam[1] then exit; // выключено автодействие сигнала
  if not (WorkMode.Upravlenie and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group]) then
  begin // нет автодействия при  потере признаков управления с РМ-ДСП
    exit;
  end else
  if not WorkMode.CmdReady and not WorkMode.LockCmd then
  begin
    // сигнал открыт ?
    if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
    begin ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[2] := false; exit; end;
    // проверить наличие плюсового положения стрелок
    for i := 1 to 10 do
    begin
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] then begin  ObjZav[Ptr].bParam[2] := false; exit; end;
      end;
    end;
    // проверить таймаут между повторами команды
    if ObjZav[Ptr].Timers[1].Active then
    begin
      if ObjZav[Ptr].Timers[1].First > LastTime then exit;
    end;

    // Проверить возможность выдачи команды открытия сигнала
    if CheckAutoMarsh(Ptr,ObjZav[Ptr].ObjConstI[25]) then
    begin
      inc(LiveCounter);
      if SendCommandToSrv(ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[5] div 8,cmdfr3_svotkrauto,ObjZav[Ptr].BaseObject) then
      begin // выдана команда на исполнение
        if SetProgramZamykanie(ObjZav[Ptr].ObjConstI[25]) then
        begin
          if OperatorDirect > LastTime then // оператор что-то делает - подождать 15 секунд до очередной попытки выдачи команды открытия сигнала автодействием
            ObjZav[Ptr].Timers[1].First := LastTime + IntervalAutoMarsh / 86400
          else // оператор ничего не делает - подождать 5 секунд и выдать повторную команду
            ObjZav[Ptr].Timers[1].First := LastTime + 10 / 86400;
          ObjZav[Ptr].Timers[1].Active := true;
//          AddFixMessage(GetShortMsg(1,423,ObjZav[ObjZav[Ptr].BaseObject].Liter),5,1);
          SingleBeep5 := WorkMode.Upravlenie;
        end;
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepAutoSvetofor]');
  Application.Terminate;
end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// подготовка объекта "Включение автодействия сигналов" #47
procedure PrepAutoMarshrut(Ptr : Integer);
{$IFDEF RMDSP}   var i,j,o,p,q : integer; {$ENDIF}
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //АС

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // программное автодействие
    if not ObjZav[Ptr].bParam[1] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // релейное автодействие
      end;
    end;
  end;
{$IFDEF RMDSP}
  inc(LiveCounter);
  if not ObjZav[Ptr].bParam[1] then exit;
  if not (WorkMode.Upravlenie and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group]) then
  begin // сброс автодействия при  потере признаков управления с РМ-ДСП
    ObjZav[Ptr].bParam[1] := false;
    for q := 10 to 12 do
      if ObjZav[Ptr].ObjConstI[q] > 0 then
      begin
        ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
        AutoMarshOFF(ObjZav[Ptr].ObjConstI[q]);
      end;
  end else
  // проверить условия поддержки режима программного автодействия
  for i := 10 to 12 do
  begin
    o := ObjZav[Ptr].ObjConstI[i];
    if o > 0 then
    begin // просмотреть все сигналы автодействия
      if ObjZav[ObjZav[o].BaseObject].bParam[23] then
      begin // зафиксировано перекрытие сигнала
        AddFixMessage(GetShortMsg(1,430,ObjZav[Ptr].Liter),4,3);
        ObjZav[Ptr].bParam[1] := false;
        for q := 10 to 12 do
          if ObjZav[Ptr].ObjConstI[q] > 0 then
          begin
            ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
            AutoMarshOFF(ObjZav[Ptr].ObjConstI[q]);
          end;
        exit;
      end;
      for j := 1 to 10 do
      begin
        p := ObjZav[o].ObjConstI[j];
        if p > 0 then
        begin
          if ObjZav[ObjZav[p].BaseObject].bParam[26] or ObjZav[ObjZav[p].BaseObject].bParam[32] then
          begin // Зафиксирована потеря контроля стрелки или непарафазность
            AddFixMessage(GetShortMsg(1,430,ObjZav[Ptr].Liter),4,3);
            ObjZav[Ptr].bParam[1] := false;
            for q := 10 to 12 do
              if ObjZav[Ptr].ObjConstI[q] > 0 then
              begin
                ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
                AutoMarshOFF(ObjZav[Ptr].ObjConstI[q]);
              end;
            exit;
          end;
        end;
      end;
    end;
  end;
{$ENDIF}
except
  reportf('Ошибка [MainLoop.PrepAutoMarshrut]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// подготовка объекта АБТЦ #49
procedure PrepABTC(Ptr : Integer);
  var gpo,ak,kl,pkl,rkl : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  gpo := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ГПо
  ObjZav[Ptr].bParam[2]  := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //озП
  ObjZav[Ptr].bParam[3]  := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //УУ
  ak  := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //АК
  kl  := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //КЛ
  pkl := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //ПКЛ
  rkl := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //РКЛ

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

    if gpo <> ObjZav[Ptr].bParam[1] then
      if gpo then
      begin // неисправность светофоров
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,488+$1000); AddFixMessage(GetShortMsg(1,488,ObjZav[Ptr].Liter),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,488+$1000);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[1] := gpo;

    if ak <> ObjZav[Ptr].bParam[4] then
      if ak then
      begin // неисправность кодирования
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,489+$1000); AddFixMessage(GetShortMsg(1,489,ObjZav[Ptr].Liter),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,489+$1000);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[4] := ak;

    if kl <> ObjZav[Ptr].bParam[5] then
      if kl then
      begin // неисправность линии
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,490+$1000); AddFixMessage(GetShortMsg(1,490,ObjZav[Ptr].Liter),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,490+$1000);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[5] := kl;

    if pkl <> ObjZav[Ptr].bParam[6] then
      if pkl then
      begin // неисправность линии питающих концов
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,491+$1000); AddFixMessage(GetShortMsg(1,491,ObjZav[Ptr].Liter),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,491+$1000);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[6] := pkl;

    if rkl <> ObjZav[Ptr].bParam[7] then
      if rkl then
      begin // неисправность линии питающих концов
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then begin
            InsArcNewMsg(Ptr,492+$1000); AddFixMessage(GetShortMsg(1,492,ObjZav[Ptr].Liter),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,492+$1000);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[7] := rkl;

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // ГПо
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // озП
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; // УУ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; // АК
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5]; // КЛ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6]; // ПКЛ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7]; // РКЛ
  end;

except
  reportf('Ошибка [MainLoop.PrepABTC]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// подготовка объекта контроля сигнальных точек #50
procedure PrepDCSU(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // Активизация
  ObjZav[Ptr].bParam[32] := false; // Непарафазность
  ObjZav[Ptr].bParam[1]  := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //1ПЖ
  ObjZav[Ptr].bParam[2]  := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //1оЖ
  ObjZav[Ptr].bParam[3]  := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //2ПЖ
  ObjZav[Ptr].bParam[4]  := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //2оЖ
  ObjZav[Ptr].bParam[5]  := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //3ПЖ
  ObjZav[Ptr].bParam[6]  := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //3оЖ
  ObjZav[Ptr].bParam[7]  := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //4ПЖ
  ObjZav[Ptr].bParam[8]  := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //4оЖ
  ObjZav[Ptr].bParam[9]  := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //5ПЖ
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //5оЖ
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //6ПЖ
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //6оЖ
  ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //7ПЖ
  ObjZav[Ptr].bParam[14] := GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //7оЖ
  ObjZav[Ptr].bParam[15] := GetFR3(ObjZav[Ptr].ObjConstI[15],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //8ПЖ
  ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[16],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //8оЖ

  // заглянуть в смену направления
  if ObjZav[Ptr].BaseObject > 0 then
  begin
    if ObjZav[ObjZav[Ptr].BaseObject].bParam[31] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[32] then
    begin
      ObjZav[Ptr].bParam[17] := not ObjZav[ObjZav[Ptr].BaseObject].bParam[4];
      ObjZav[Ptr].bParam[18] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4];
    end else
    begin // неизвестно состояние направления на перегоне
      ObjZav[Ptr].bParam[17] := false;
      ObjZav[Ptr].bParam[18] := false;
    end;
  end;

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // 1ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // 1оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; // 2ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; // 2оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5]; // 3ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6]; // 3оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7]; // 4ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[8]; // 4оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[9]; // 5ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[10]; // 5оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[11]; // 6ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[12]; // 6оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[13]; // 7ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := ObjZav[Ptr].bParam[14]; // 7оЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[15]; // 8ПЖ
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := ObjZav[Ptr].bParam[16]; // 8оЖ

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[19] := ObjZav[Ptr].bParam[17]; // прием
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[20] := ObjZav[Ptr].bParam[18]; // отправление
  end;

except
  reportf('Ошибка [MainLoop.PrepDCSU]');
  Application.Terminate;
end;
end;

//-------------------------------------------------------------------------------
// Сборка дополнительных датчиков #51
procedure PrepDopDat(Ptr : Integer);
begin
try
  inc(LiveCounter);
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1]  := false;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := true;

    if ObjZav[Ptr].ObjConstI[1] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[2] := false;
      ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[1],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[2],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[2]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[2];
    end;
    if ObjZav[Ptr].ObjConstI[2] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[3] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[3] := false;
      ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[3],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[3]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[3];
    end;
    if ObjZav[Ptr].ObjConstI[3] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[4] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[4] := false;
      ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[3],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[4],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[4]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[4];
    end;
    if ObjZav[Ptr].ObjConstI[4] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[5] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[5] := false;
      ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[4],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[5],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[5]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[5];
    end;
    if ObjZav[Ptr].ObjConstI[5] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[6] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[6] := false;
      ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[5],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[6],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[6]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[6];
    end;
    if ObjZav[Ptr].ObjConstI[6] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[7] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[7] := false;
      ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[6],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[7],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[7]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[7];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[7];
    end;
    if ObjZav[Ptr].ObjConstI[7] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[8] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[8] := false;
      ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[7],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[8],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[8]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[8];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[8];
    end;
    if ObjZav[Ptr].ObjConstI[8] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[9] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[9] := false;
      ObjZav[Ptr].bParam[8] := GetFR3(ObjZav[Ptr].ObjConstI[8],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[9],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[9]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[8];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[9];
    end;
    if ObjZav[Ptr].ObjConstI[9] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[10] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[10] := false;
      ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[9],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[10],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[10]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[10];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[10];
    end;
    if ObjZav[Ptr].ObjConstI[10] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[11] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[11] := false;
      ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[10],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[11],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[11]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[10];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[11];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[11];
    end;
    if ObjZav[Ptr].ObjConstI[11] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[12] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[12] := false;
      ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[11],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[12],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[12]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[11];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[12];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[12];
    end;
    if ObjZav[Ptr].ObjConstI[12] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[13] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[13] := false;
      ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[12],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[13],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[13]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[12];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[13];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[13];
    end;
    if ObjZav[Ptr].ObjConstI[13] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[14] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[14] := false;
      ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[13],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[14],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[14]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[13];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[14];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[14];
    end;
    if ObjZav[Ptr].ObjConstI[14] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[15] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[15] := false;
      ObjZav[Ptr].bParam[14] := GetFR3(ObjZav[Ptr].ObjConstI[14],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[15],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[15]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := ObjZav[Ptr].bParam[14];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[15];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[15];
    end;
    if ObjZav[Ptr].ObjConstI[15] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[17] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[17] := false;
      ObjZav[Ptr].bParam[15] := GetFR3(ObjZav[Ptr].ObjConstI[15],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[17],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[17]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[15];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[17];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[17];
    end;
    if ObjZav[Ptr].ObjConstI[16] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[18] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[18] := false;
      ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[16],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[18],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[18]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := ObjZav[Ptr].bParam[16];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[18];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[18];
    end;
    if ObjZav[Ptr].ObjConstI[17] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[19] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[19] := false;
      ObjZav[Ptr].bParam[17] := GetFR3(ObjZav[Ptr].ObjConstI[17],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[19],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[19]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[19] := ObjZav[Ptr].bParam[17];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[19];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[19];
    end;
    if ObjZav[Ptr].ObjConstI[18] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[20] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[20] := false;
      ObjZav[Ptr].bParam[18] := GetFR3(ObjZav[Ptr].ObjConstI[18],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[20],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[20]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[20] := ObjZav[Ptr].bParam[18];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[20];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[20];
    end;
    if ObjZav[Ptr].ObjConstI[19] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[21] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[21] := false;
      ObjZav[Ptr].bParam[19] := GetFR3(ObjZav[Ptr].ObjConstI[19],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[21],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[21]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[21] := ObjZav[Ptr].bParam[19];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[21];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[21];
    end;
    if ObjZav[Ptr].ObjConstI[20] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[22] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[22] := false;
      ObjZav[Ptr].bParam[20] := GetFR3(ObjZav[Ptr].ObjConstI[20],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[22],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[22]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[22] := ObjZav[Ptr].bParam[20];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[22];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[22];
    end;
    if ObjZav[Ptr].ObjConstI[21] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[23] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[23] := false;
      ObjZav[Ptr].bParam[21] := GetFR3(ObjZav[Ptr].ObjConstI[21],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[23],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[23]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[23] := ObjZav[Ptr].bParam[21];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[23];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[23];
    end;
    if ObjZav[Ptr].ObjConstI[22] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[24] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[24] := false;
      ObjZav[Ptr].bParam[22] := GetFR3(ObjZav[Ptr].ObjConstI[22],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[24],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[24]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[24] := ObjZav[Ptr].bParam[22];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[24];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[24];
    end;
    if ObjZav[Ptr].ObjConstI[23] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[25] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[25] := false;
      ObjZav[Ptr].bParam[23] := GetFR3(ObjZav[Ptr].ObjConstI[23],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[25],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[25]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[25] := ObjZav[Ptr].bParam[23];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[25];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[25];
    end;
    if ObjZav[Ptr].ObjConstI[24] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[26] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[26] := false;
      ObjZav[Ptr].bParam[24] := GetFR3(ObjZav[Ptr].ObjConstI[24],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[26],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[26]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[26] := ObjZav[Ptr].bParam[24];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[26];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[26];
    end;
    if ObjZav[Ptr].ObjConstI[25] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[27] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[27] := false;
      ObjZav[Ptr].bParam[25] := GetFR3(ObjZav[Ptr].ObjConstI[25],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[27],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[27]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[27] := ObjZav[Ptr].bParam[25];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[27];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[27];
    end;
    if ObjZav[Ptr].ObjConstI[26] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[28] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[28] := false;
      ObjZav[Ptr].bParam[26] := GetFR3(ObjZav[Ptr].ObjConstI[26],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[28],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[28]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[28] := ObjZav[Ptr].bParam[26];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[28];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[28];
    end;
    if ObjZav[Ptr].ObjConstI[27] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[29] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[29] := false;
      ObjZav[Ptr].bParam[27] := GetFR3(ObjZav[Ptr].ObjConstI[27],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[29],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[29]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[29];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[29];
    end;
    if ObjZav[Ptr].ObjConstI[28] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[30] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[30] := false;
      ObjZav[Ptr].bParam[28]  := GetFR3(ObjZav[Ptr].ObjConstI[28],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[30],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[30]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[28];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[30];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[30];
    end;
    if ObjZav[Ptr].ObjConstI[29] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[31] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[31] := false;
      ObjZav[Ptr].bParam[29] := GetFR3(ObjZav[Ptr].ObjConstI[29],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[31],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[31]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[29];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[31];
    end;
    if ObjZav[Ptr].ObjConstI[30] > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[32] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[32] := false;
      ObjZav[Ptr].bParam[30] := GetFR3(ObjZav[Ptr].ObjConstI[30],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[32],OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[32]); OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[30];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] or OVBuffer[ObjZav[Ptr].VBufferIndex].ParamN[32];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] and not OVBuffer[ObjZav[Ptr].VBufferIndex].ParamA[32];
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepDopDat]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// Объект трассировки МУС для светофора по пошерстным стрелкам #52
procedure PrepSVMUS(Ptr : Integer);
  var k,o,p,j : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[1] := false;
  k := ObjZav[Ptr].BaseObject;
  if k > 0 then
  begin
    if not ObjZav[k].bParam[3] and ObjZav[k].bParam[1] and ObjZav[k].bParam[4] and ObjZav[k].bParam[5] then
    begin // замкнуты маневры, есть РМ, Д, В
    // проверить противошерстные стрелки для выезда на объект сборки трассы МУС
      if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
      o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 50;
      while j > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 : begin // стрелка
            case p of
              2 : begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[1] then break;
              end;
              3 : begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[2] then break;
              end;
            else
              break;
            end;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
          53 : begin // ТРМУС
            if (ObjZav[Ptr].UpdateObject = o) and (k = ObjZav[o].BaseObject) then
            begin
              ObjZav[Ptr].bParam[1] := true; break;
            end else
            begin
              if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
              else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
            end;
          end;
        else
          if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
          else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(j);
      end;
    end;
  end;
except
  reportf('Ошибка [MainLoop.PrepOPI]'); Application.Terminate;
end;
end;

end.
