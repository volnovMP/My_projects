unit MainLoop;
//------------------------------------------------------------------------------
//
//          ���� ������� ������������ ��-���, ���-��, �������� ������
//
//    ������     1
//    ��������   5
//
//    ��������� ��������� �� 21 ������� 2006 ����
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
  DiagUVK : SmallInt      = 1; //5120 ����� ��������� � ������������� ���
  DateTimeSync : SmallInt = 1; //6144 ����� ��������� ��� ������������� ������� �������
{$IFDEF RMSHN}
  StatStP                 = 5; // ���������� ��������� ��� ���������� ������� ������������ �������� �������
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
      AddFixMessage(GetShortMsg(1,507,'') + '������� ��������� ������� '+ IntToStr(Hr)+':'+ IntToStr(Mn)+':'+ IntToStr(Sc),4,1);
    end;
    if not TryEncodeDate(Yr,Mt,Dy,nd) then
    begin
      err := true; InsArcNewMsg(0,507);
      AddFixMessage(GetShortMsg(1,507,'') + '������� ��������� ���� '+ IntToStr(Yr)+'-'+ IntToStr(Mt)+'-'+ IntToStr(Dy),4,1);
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

      for i := 1 to high(FR3s) do // ��������� ������� ������� � FR3
        if FR3s[i] > 0.00000001 then FR3s[i] := FR3s[i] - delta;
      for i := 1 to high(FR4s) do // ��������� ������� ������� � FR4
        if FR4s[i] > 0.00000001 then FR4s[i] := FR4s[i] - delta;

      for i := 1 to high(ObjZav) do
      begin // ��������� ������� ������� � �������� ������������
        if ObjZav[i].Timers[1].Active then ObjZav[i].Timers[1].First := ObjZav[i].Timers[1].First - delta;
        if ObjZav[i].Timers[2].Active then ObjZav[i].Timers[2].First := ObjZav[i].Timers[2].First - delta;
        if ObjZav[i].Timers[3].Active then ObjZav[i].Timers[3].First := ObjZav[i].Timers[3].First - delta;
        if ObjZav[i].Timers[4].Active then ObjZav[i].Timers[4].First := ObjZav[i].Timers[4].First - delta;
        if ObjZav[i].Timers[5].Active then ObjZav[i].Timers[5].First := ObjZav[i].Timers[5].First - delta;
      end;
      LastSync := ndt;
      LastTime := ndt;
    end;
    // �������� ��������
    FR8[index] := 0;
  end;
except
  FR8[index] := 0; reportf('������ [MainLoop.SetDateTimeARM]'); Application.Terminate;
end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// ���������� �������� ������������ ��� ����������
procedure PrepareOZ;
  var c,Ptr : integer;
  {$IFNDEF RMARC} st : byte; {$ENDIF}
  {$IFDEF RMSHN} i,j,k,cfp : integer; fix,fp,fn : Boolean; {$ENDIF}
begin
try
  // ���������� ������� ������������� �������
  SetDateTimeARM(DateTimeSync);

  // ���������� ��������������� ��������� � �������������� ���
  if DiagnozON then DiagnozUVK(DiagUVK);
  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;

{$IFNDEF RMARC}
  // ���������� ������ FR3,FR4
  if DiagnozON and WorkMode.FixedMsg then
  begin // ��������� �������� �������������� ������� �����������
    for Ptr := 1 to FR_LIMIT do
    begin
      if (Ptr <> WorkMode.DirectStateSoob) and (Ptr <> WorkMode.ServerStateSoob) then
      begin
        st := byte(FR3inp[Ptr]);
        if (st and $20) <> (FR3[Ptr] and $20) then // ��������� ��������� �������� �������������� �������� �������� ����������
        begin
          if (Ptr <> MYT[1]) and (Ptr <> MYT[2]) and (Ptr <> MYT[3]) and (Ptr <> MYT[4]) and (Ptr <> MYT[5]) and (Ptr <> MYT[6]) and (Ptr <> MYT[7]) and (Ptr <> MYT[8]) and (Ptr <> MYT[9]) then
          begin // ���� ������� ������ �� ��������� � ����� - �����������
            if ((st and $20) = $20) then InsArcNewMsg(Ptr,$3001) else InsArcNewMsg(Ptr,$3002);
          end;
        end;
        FR3[Ptr] := st;
      end;
      if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4[Ptr] := byte(FR4inp[Ptr]) else FR4[Ptr] := 0;
    end;
  end else
  begin // ������ ���������� ������� �����
{$ENDIF}
    for Ptr := 1 to FR_LIMIT do
    begin
{$IFNDEF RMARC} FR3[Ptr] := byte(FR3inp[Ptr]); {$ENDIF}
      if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4[Ptr] := byte(FR4inp[Ptr]) else FR4[Ptr] := 0;
    end;
{$IFNDEF RMARC}
  end;
  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;

  // �������� ���������� FR5
  if LastTime > LastDiagD then begin LastDiagN := 0; LastDiagI := 0; end;
{$ENDIF}

  // ���������� ��������� ����� ������
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

  // ���������� ����������� �� �����
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
      //28 -�� ������� ��������������� ���������
      //29 -�� ������� ��������������� ���������
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
      // 53 -�� ������� ��������������� ���������
    end;
//    inc(c); if c > 500 then begin SyncReady; WaitForSingleObject(hWaitKanal,ChTO); c := 0; end;
    if LiveCounter > MaxLiveCtr then begin WaitForSingleObject(hWaitKanal,ChTO); {SyncReady;} LiveCounter := 0; end;
  end;
  // ��������� ��������� ���������
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      1  : PrepXStrelki(Ptr);
      5  : PrepSvetofor(Ptr);
    end;
    if LiveCounter > MaxLiveCtr then begin WaitForSingleObject(hWaitKanal,ChTO); {SyncReady;} LiveCounter := 0; end;
  end;
//  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;
  // ����� �� ����� ����������� ������� � ��.
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

// ��������� ������ �����������
  c := 0;
  for Ptr := 1 to 2000 do OVBuffer[Ptr].StepOver := false;
  for Ptr := 1 to 2000 do
  begin
    if OVBuffer[Ptr].Steps > 0 then GoOVBuffer(Ptr,OVBuffer[Ptr].Steps);
    inc(c); if c > 999 then begin WaitForSingleObject(hWaitKanal,ChTO); {SyncReady;} c := 0; end;
  end;

// ��������� ��������� �������
  WaitForSingleObject(hWaitKanal,ChTO); //SyncReady;


{$IFDEF RMARC}
  SrvState := FR3[WorkMode.ServerStateSoob];
{$ENDIF}

// ���������� ������� ��������, ����������� ������ ������ ����������
  if Config.configKRU = 1 then
  begin // � �������
    if (SrvState and $7) = 0 then
    begin // ������������� ������ ������ ����������
      SrvCount := 1; WorkMode.RUError := true;
    end else
    begin // ����������� ������ ������ ����������
      SrvCount := 2; WorkMode.RUError := false;
    end;
    // ����� �������� �����
    if SrvState and $30 = $10 then SrvActive := 1 else
    if SrvState and $30 = $20 then SrvActive := 2 else
    if SrvState and $30 = $30 then SrvActive := 3 else
      SrvActive := 0;
  end else
  begin // �� �������
    // ���������� ��������
    if ((SrvState and $7) = 1) or ((SrvState and $7) = 2) or ((SrvState and $7) = 4) or ((SrvState and $7) = 0) then SrvCount := 1 else
    if (SrvState and $7) = 7 then SrvCount := 3 else SrvCount := 2;
    // ����� ��������� �������
    if ((LastRcv + MaxTimeOutRecave) > LastTime) then
    begin
      if (SrvState and $30) = $10 then SrvActive := 1 else
      if (SrvState and $30) = $20 then SrvActive := 2 else
      if (SrvState and $30) = $30 then SrvActive := 3 else
        SrvActive := 0;
    end else
      SrvActive := 0;
  end;


// ��������� ������� ����� � ���������
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
  // ���������� �������
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
          fp := GetFR3(LinkFR3[FixNotify[i].Datchik[j]].FR3,fn,fn); // �������� ��������� �������
          fix := (FixNotify[i].State[j] = fp) and not fn;
          if fix then inc(cfp);
        end;
    if cfp > 0 then
    begin // ������ ������� �� �������
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
  begin // ����� ���-���2 �������
    if DspToDspConnected then
    begin
      if DspToDspAdresatEn then
        ArmAsuCh[1] := 2 // ������ ����������
      else
        ArmAsuCh[1] := 1; // �������� ����������� ��������
    end else
      ArmAsuCh[1] := 0; // ��� ����������
  end else
  begin // ����� ���-���2 ��������
    ArmAsuCh[1] := 255;
  end;
{$ENDIF}
except
  reportf('������ [MainLoop.PrepareOZ]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// ������� ��� �� ������ �����������
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
  var oPtr : integer;
begin
try
  oPtr := Ptr;
  case OVBuffer[Ptr].TypeRec of
    0 : begin // ��������� � ����������� ����
      Ptr := OVBuffer[Ptr].Jmp1;
    end;
    1 : begin // ���������� ����� �����������
      OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param;
      Ptr := OVBuffer[Ptr].Jmp1;
    end;
    2 : begin // ����������� ����� �����������
      if OVBuffer[Ptr].StepOver then
      begin
        OVBuffer[OVBuffer[Ptr].Jmp2].Param := OVBuffer[Ptr].Param; Ptr := OVBuffer[Ptr].Jmp2
      end else
      begin
        OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param; Ptr := OVBuffer[Ptr].Jmp1;
      end;
    end;
    3 : begin // �������
      if OVBuffer[Ptr].StepOver then
      begin
        Ptr := OVBuffer[Ptr].Jmp2;
        OVBuffer[Ptr].Param[1] := OVBuffer[oPtr].Param[1];
        OVBuffer[Ptr].Param[11] := OVBuffer[oPtr].Param[11];
        OVBuffer[Ptr].Param[16] := OVBuffer[oPtr].Param[16];
        if not ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then
        begin // �� ���
          if ObjZav[OVBuffer[oPtr].DZ1].bParam[1] then
          begin // �� ����
            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] else OVBuffer[Ptr].Param[2] := false;
            OVBuffer[Ptr].Param[4] := true;
            OVBuffer[Ptr].Param[8] := true;
          end else
          begin // ��,�� ���
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2];
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4];
            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];
          end;
          if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3] else OVBuffer[Ptr].Param[3] := true;
          OVBuffer[Ptr].Param[5] := true;
          OVBuffer[Ptr].Param[7] := false;
          OVBuffer[Ptr].Param[10] := false;
        end else
        begin // �� ����
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
        begin // �� ���
          if ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then
          begin // �� ����
            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] else OVBuffer[Ptr].Param[2] := false;
            OVBuffer[Ptr].Param[4] := true;
            OVBuffer[Ptr].Param[8] := true;
          end else
          begin // ��,�� ���
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2];
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4];
            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];
          end;
          if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3] else OVBuffer[Ptr].Param[3] := true;
          OVBuffer[Ptr].Param[5] := true;
          OVBuffer[Ptr].Param[7] := false;
          OVBuffer[Ptr].Param[10] := false;
        end else
        begin // �� ����
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
  reportf('������ [MainLoop.StepOVBuffer]'); result := false; Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ������ �� ������ �����������
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
  reportf('������ [MainLoop.GoOVBuffer]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// ��������� � ����� ������� �������� ������������ ��������� (����� ��� ���������)
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
begin
try
  if ObjZav[ptr].bParam[14] then
  begin // ���� ��������������� ��������� - ���������� �������� � �����
    ObjZav[ObjZav[ptr].BaseObject].bParam[14] := true;
  end else
  begin // ���� ��������� ��������� - ��������� ������� ��� ���������
    if ObjZav[ObjZav[ptr].BaseObject].ObjConstI[9] = 0 then
    begin // ���������
      ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
    end else
    begin // ���������
      if ObjZav[ObjZav[ptr].BaseObject].ObjConstI[8] = ptr then
      begin // ������� ������� �������� ���������
        if not ObjZav[ObjZav[ObjZav[ptr].BaseObject].ObjConstI[9]].bParam[14] then
          ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
      end else
      begin // ������� ������� �������� ���������
        if not ObjZav[ObjZav[ObjZav[ptr].BaseObject].ObjConstI[8]].bParam[14] then
          ObjZav[ObjZav[ptr].BaseObject].bParam[14] := false;
      end;
    end;
  end;
except
  reportf('������ [MainLoop.SetPrgZamykFromXStrelka]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ��������� ����������� � �������������� ���������� ���
procedure DiagnozUVK(Index : SmallInt);
  var u,m,p,o,z,c : cardinal; t : boolean; msg : Integer;
begin
try
  c := FR7[Index];
  if c > 0 then
  begin
    // �������� ����� ������
    u := c and $f0000000; u := u shr 28;
    // �������� ����� �����������
    m := c and $0c000000; m := m shr 26;
    // �������� ��� �����
    p := c and $03c00000; p := p shr 22;
    t := (c and $02000000) = $02000000; // ��� ����� (�201-true/�203-false)
    // �������� �������� ������
    o := c and $003f0000; o := o shr 16;
    // �������� ��������
    z := c and $0000ffff;
    if (u > 0) and (p > 0) and (o > 0) then
    begin
      s := '���'+ IntToStr(u)+
           ' ����'+ IntToStr(m);
      if t then s := s + ' �201' else s := s + ' �203';
      s := s + '.' + IntToStr(p and $7);
      case o of
        1 : begin s := s + ' ����������� ����� '; msg := 3003; end;
        2 : begin s := s + ' ����� ����� '; msg := 3004; end;
        3 : begin s := s + ' ���������� "0" '; msg := 3005; end;
        4 : begin s := s + ' ���������� "1" '; msg := 3006; end;
      else
        s := s + ' ��� ������: '; msg := 3007;
      end;
      s := s + '['+ IntToHEX(z,4)+']';
      AddFixMessage('��������� ����������� '+ s,4,4);

      DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
      s := dt + ' > '+ s;
      ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
      NewNeisprav := true; SingleBeep4 := true;
      InsArcNewMsg(z{0},msg);
    end else
    begin // �������������� ���������
      InsArcNewMsg(0,508); AddFixMessage(GetShortMsg(1,508,''),4,4);
    end;
    FR7[Index] := 0; // �������� ������������ ���������
  end;
except
  reportf('������ [MainLoop.DiagnozUVK]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// �������� �� �� ���������� �������
function GetState_Manevry_D(Ptr : SmallInt) : Boolean;
begin
try
  // ���������� ��������� ��&��
  // ������� ���������� �������� (��� ����� ������� ������ ���������� �������� �� �������)
  result := ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[4];
except
  reportf('������ [MainLoop.GetState_Manevry_D]'); result := false; Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������ ������� #1
procedure PrepXStrelki(Ptr : Integer);
  var i,o,p : integer; pk,mk,pks,nps,d,bl : boolean; {$IFDEF RMSHN} dvps : Double; {$ENDIF}
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  pk := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  mk := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  nps := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ������������ �������
  pks := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ������ �������� �������

  if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then // �������������� ��� ���������� ����������
  begin
{$IFDEF RMSHN}
    if not (pk or mk or pks or ObjZav[Ptr].Timers[1].Active or ObjZav[Ptr].Timers[2].Active) then
    begin
      if ObjZav[Ptr].sbParam[2] then
      begin // ��������� ����� ������ �������� ���������� ���������
        ObjZav[Ptr].Timers[2].Active := true; ObjZav[Ptr].Timers[2].First := LastTime;
      end;
      if ObjZav[Ptr].sbParam[1] then
      begin // ��������� ����� ������ �������� ��������� ���������
        ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime;
      end;
    end;
{$ENDIF}
    if pk and mk then begin pk := false; mk := false; end; // �������� �� � �� ���� ��� ����������
    if ObjZav[Ptr].bParam[25] <> nps then
    begin // ������� ��������� �������
      if nps then
      begin
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,270+$1000); SingleBeep := true; ObjZav[Ptr].dtParam[2] := LastTime;
          inc(ObjZav[Ptr].siParam[3]); // ������� �����������
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
    begin // ��������� �������� �� ���������� � ���������� ����� 1
      case ObjZav[o].TypeObj of
        25 : d := GetState_Manevry_D(o); // ��&�
        44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); // ��&�
      end;
    end;
    if not d then
    begin
      o := ObjZav[Ptr].ObjConstI[7];
      if o > 0 then
      begin // ��������� �������� �� ���������� � ���������� ����� 2
      case ObjZav[o].TypeObj of
        25 : d := GetState_Manevry_D(o); // ��&�
        44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); // ��&�
      end;
      end;
    end;
    if d then ObjZav[Ptr].bParam[24] := true else ObjZav[Ptr].bParam[24] := false;

    if ObjZav[Ptr].bParam[26] <> pks then
    begin // �������� ������ �������� �������
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
              inc(ObjZav[Ptr].siParam[1]) // ������� ������ �������� � �����
            else
              inc(ObjZav[Ptr].siParam[6]); // ������� ������ �������� � ����� ��� ��������� ������
          end;
          if ObjZav[Ptr].sbParam[2] then
          begin
            if ObjZav[Ptr].bParam[22] then
              inc(ObjZav[Ptr].siParam[2]) // ������� ������ �������� � ������
            else
              inc(ObjZav[Ptr].siParam[7]); // ������� ������ �������� � ������ ��� ��������� ������
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
    ObjZav[Ptr].bParam[1] := pk; // ��
    ObjZav[Ptr].bParam[2] := mk; // ��

{$IFDEF RMSHN}
    if pk then
    begin
      ObjZav[Ptr].Timers[1].Active := false;
      if ObjZav[Ptr].Timers[2].Active then
      begin // ��������� ������������ �������� � ����
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
      begin // ������� ��
        ObjZav[Ptr].sbParam[1] := pk; ObjZav[Ptr].sbParam[2] := mk; if not StartRM then inc(ObjZav[Ptr].siParam[4]);
      end;
    end;
    if mk then
    begin
      ObjZav[Ptr].Timers[2].Active := false;
      if ObjZav[Ptr].Timers[1].Active then
      begin // ��������� ������������ �������� � �����
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
      begin // ������� ��
        ObjZav[Ptr].sbParam[1] := pk; ObjZav[Ptr].sbParam[2] := mk; if not StartRM then inc(ObjZav[Ptr].siParam[5]);
      end;
    end;
{$ENDIF}

    if ObjZav[Ptr].ObjConstB[3] then
    begin // ���� ��� �� ��
      o := ObjZav[Ptr].ObjConstI[8];
      p := ObjZav[Ptr].ObjConstI[9];
      if ObjZav[o].ObjConstB[9] then ObjZav[Ptr].bParam[20] := ObjZav[ObjZav[o].UpdateObject].bParam[4];
      if (p > 0) and ObjZav[p].ObjConstB[9] then
        if ObjZav[Ptr].bParam[20] then ObjZav[Ptr].bParam[20] := ObjZav[ObjZav[p].UpdateObject].bParam[4];
    end else ObjZav[Ptr].bParam[20] := true;
    // ���� ��������� �� ��
    d := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[8]].UpdateObject].bParam[2];
    if ObjZav[Ptr].ObjConstI[9] > 0 then if d then d := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[9]].UpdateObject].bParam[2];
    if d <> ObjZav[Ptr].bParam[21] then
    begin // ���������� ��������� ������
      ObjZav[Ptr].bParam[6] := false; ObjZav[Ptr].bParam[7] := false; // ����� ��������� �� � ��
    // ��������� � ������� ����������� ������������
      bl := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[8]].UpdateObject].bParam[20]; // ���������� �������
      if ObjZav[Ptr].ObjConstI[9] > 0 then if not bl then bl := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[9]].UpdateObject].bParam[20]; // ���������� �������
      ObjZav[Ptr].bParam[3] := d and not bl and ObjZav[Ptr].ObjConstB[2] and (not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2]);
    end;
    ObjZav[Ptr].bParam[21] := d;
    // ���� ��������� �� ��
    ObjZav[Ptr].bParam[22] := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[8]].UpdateObject].bParam[1];
    if ObjZav[Ptr].ObjConstI[9] > 0 then
      if ObjZav[Ptr].bParam[22] then ObjZav[Ptr].bParam[22] := ObjZav[ObjZav[ObjZav[Ptr].ObjConstI[9]].UpdateObject].bParam[1];

    // ����� ��������� �����������
    ObjZav[Ptr].bParam[23] := false;
    inc(LiveCounter);

    // �������� �������� �� ������� ����������
    ObjZav[Ptr].bParam[9] := false;
    for i := 20 to 24 do
      if ObjZav[Ptr].ObjConstI[i] > 0 then
      begin
        case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
          25 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);
          44 : if not ObjZav[Ptr].bParam[9] then ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
        end;
      end;
    // �������� ������� ���������
    ObjZav[Ptr].bParam[4] := false;
    if ObjZav[Ptr].ObjConstI[12] > 0 then
    begin
      if ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[1] or ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[2] or ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[3] then
        ObjZav[Ptr].bParam[4] := true;
    end;

    if ObjZav[Ptr].bParam[21] then
    begin
      if not ObjZav[Ptr].bParam[4] then
      // �������� �������� ����������
        for i := 6 to 7 do
        begin
          o := ObjZav[Ptr].ObjConstI[i];
          if o > 0 then
          begin
            case ObjZav[o].TypeObj of
              25 : begin
                if not ObjZav[o].bParam[3] then
                begin // ��
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
              44 : begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // ��
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
            end;
          end;
        end;

      // �������� ��������
        for i := 20 to 24 do
        begin
          o := ObjZav[Ptr].ObjConstI[i];
          if o > 0 then
          begin
            case ObjZav[o].TypeObj of
              25 : begin
                if not ObjZav[o].bParam[3] then
                begin // ��
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
              44 : begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // ��
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end;
            end;
          end;
        end;

      if not ObjZav[Ptr].bParam[4] then
      // �������� ������ �������
        for i := 14 to 19 do
        begin
          o := ObjZav[Ptr].ObjConstI[i];
          if o > 0 then
          begin
            case ObjZav[O].TypeObj of

              3 : begin // ������
                if not ObjZav[o].bParam[2] then
                begin
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //3

              25 : begin // ���������� �������
                if not ObjZav[o].bParam[3] then
                begin // ��
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //25

              27 : begin // �������� �������
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

              41 : begin // ���������� ������� � ���� ��� ��������� �����������
                if ObjZav[o].bParam[20] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
                begin
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //41

              46 : begin // ������������ ��������
                if ObjZav[o].bParam[1] then
                begin // �������� ������������
                  ObjZav[Ptr].bParam[4] := true; break;
                end;
              end; //46

            end; //case
          end;
        end; // for

      if not ObjZav[Ptr].bParam[4] and (ObjZav[Ptr].ObjConstI[8] > 0) then // �������� ��������� ����� ����
      // ������� �������
        if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[7]) then // �������� ���������� ��������� �������
        begin //�� ��������� ����������
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // �������
                case p of
                  2 : begin // ���� �� �����
                    if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                  end;
                  3 : begin // ���� �� ������
                    if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ������ � ���� ������
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                end;
              3,4 : begin // �������,����
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // ��������� ����������� ����
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
        if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[8]) then // �������� ���������� ��������� �������
        begin //�� ���������� ����������
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // �������
                case p of
                  2 : begin // ���� �� �����
                    if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                  end;
                  3 : begin // ���� �� ������
                    if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ������ � ���� ������
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
              end;
              3,4 : begin // �������,����
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // ��������� ����������� ����
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
      // ������� �������
        if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[7]) then // �������� ���������� ��������� �������
        begin //�� ��������� ����������
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // �������
                case p of
                  2 : begin // ���� �� �����
                    if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                  end;
                  3 : begin // ���� �� ������
                    if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ������ � ���� ������
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
              end;
              3,4 : begin // �������,����
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // ��������� ����������� ����
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
        if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[8]) then // �������� ���������� ��������� �������
        begin //�� ���������� ����������
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Obj; p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Pin; i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : begin // �������
                case p of
                  2 : begin // ���� �� �����
                    if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                  end;
                  3 : begin // ���� �� ������
                    if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                  end;
                else
                  ObjZav[Ptr].bParam[4] := true; break; // ������ � ���� ������
                end;
                p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
              end;
              3,4 : begin // �������,����
                ObjZav[Ptr].bParam[4] := not ObjZav[o].bParam[2]; // ��������� ����������� ����
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
    // �������� ������� ������������
    if ObjZav[Ptr].ObjConstB[2] then
    begin
      inc(LiveCounter);
      if ObjZav[Ptr].bParam[3] then
      begin
        ObjZav[Ptr].bParam[3] := false;
        if StartRM then
        begin // ����������� ����������� ��� ������� ����
           ObjZav[Ptr].Timers[1].Active := false;
        end else
      // ��������� ������� �������� ���������� ��������� �������
        if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] and WorkMode.Upravlenie and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group] then
        begin // ��������� ������� ����������� �������� ������������
          ObjZav[Ptr].bParam[12] := true; ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
        end;
      end else

      // ��������� ������������ ������ ������� ������������
      if ObjZav[Ptr].bParam[12] and
         not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] and // ������� ����� �������� ���������� ���������
         not ObjZav[Ptr].bParam[4] and not ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[14] and // ������� �������� ��� ������������
         not ObjZav[Ptr].bParam[18] and not ObjZav[Ptr].bParam[19] and // ������� ��������� ��� �����
         ObjZav[Ptr].bParam[20] and ObjZav[Ptr].bParam[21] and ObjZav[Ptr].bParam[22] and not ObjZav[Ptr].bParam[23] and // ��� ���������, ��������� � ���
         not ObjZav[Ptr].bParam[9] and not ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[24] then // ��� �������� ����������
      begin
        if ObjZav[ObjZav[Ptr].ObjConstI[10]].bParam[3] then
        begin // ������������� ������ ������� ��������� ����� - �������� ������� ����������� ������������
          ObjZav[Ptr].bParam[12] := false; ObjZav[Ptr].Timers[1].Active := false;
        end else
        begin // �������� ������� ��������� �����
          d := not ObjZav[Ptr].bParam[19]; // �����
          if d then d := not ObjZav[Ptr].bParam[15]; // ����� FR4
          if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[18]; // ���������� �� "�"
          if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[10] and
                         not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[12] and // ��� ����������� �������� ����� �������
                         not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[13];
          if ObjZav[Ptr].ObjConstI[9] > 0 then
          begin
            if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[18]; // ���������� �� "�"
            if d then d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[10] and
                           not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[12] and // ��� ����������� �������� ����� �������
                           not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[13];
          end;
          if d and ObjZav[Ptr].Timers[1].Active and (ObjZav[Ptr].Timers[1].First < LastTime) then
          begin
            if (CmdCnt = 0) and not WorkMode.OtvKom and not WorkMode.VspStr and not WorkMode.GoMaketSt and
               WorkMode.Upravlenie and not WorkMode.LockCmd and not WorkMode.CmdReady and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group] then
            begin // ���� ������� ����������� ������������ � ��� ��������� ������ � ������
              ObjZav[Ptr].bParam[12] := false; ObjZav[Ptr].Timers[1].Active := false;
              if SendCommandToSrv(ObjZav[Ptr].ObjConstI[2] div 8, cmdfr3_strautorun,Ptr) then
                AddFixMessage(GetShortMsg(1,418, ObjZav[Ptr].Liter),5,5);
            end;
          end;
        end;
      end;
    end else
    begin // �� ����������� ���������� ���������� ������ ���� ��� �������� ������������ �������
      ObjZav[Ptr].bParam[3] := false; ObjZav[Ptr].bParam[12] := false; ObjZav[Ptr].Timers[1].Active := false;
    end;
{$ENDIF}
  end else
  begin // �������� �������� ��� ���������� ����������
    ObjZav[Ptr].bParam[1] := false; ObjZav[Ptr].bParam[2] := false; ObjZav[Ptr].bParam[3] := false;
{$IFDEF RMSHN}
    ObjZav[Ptr].bParam[19] := false;
{$ENDIF}
  end;

  {FR4}
  // ��������� ����������
  ObjZav[Ptr].bParam[18] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-5);
  // �����
  ObjZav[Ptr].bParam[15] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-4);
  // ������� ��� ��������
  ObjZav[Ptr].bParam[17] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-3);
  ObjZav[Ptr].bParam[16] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-2);
  // ������� ��� ���������������� ��������
  ObjZav[Ptr].bParam[34] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-1);
  ObjZav[Ptr].bParam[33] := GetFR4State(ObjZav[Ptr].ObjConstI[1]);
except
  reportf('������ [MainLoop.PrepXStrelki]'); Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// ���������� ������� ���������� ������� ��� ������ �� �����
procedure PrepDZStrelki(Ptr : Integer);
  var o : integer;
begin
try
  inc(LiveCounter);
  if ObjZav[Ptr].ObjConstI[3] > 0 then
  begin // ���������� ��������� �������� �������
    o := ObjZav[Ptr].ObjConstI[1]; // ������ �������, ����������� �� �����������
    if o > 0 then
    begin
    // ����������� �������� ����� �������� ����������
      if ObjZav[o].bParam[14] then
      begin
        ObjZav[Ptr].bParam[23] := true; // ���������� ��������������� ��������� �������� �������
        if ObjZav[Ptr].ObjConstB[1] then // �������������� ������������ � �����
        begin
          if ObjZav[o].bParam[6] then // ��
          begin
            if  (not ObjZav[o].bParam[11] or ObjZav[o].bParam[12]) then
            begin
              if ObjZav[Ptr].ObjConstB[3] then // �������� ������ ���� � �����
              begin
                if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[1] then ObjZav[Ptr].bParam[8] := true;
              end else
              if ObjZav[Ptr].ObjConstB[4] then // �������� ������ ���� � ������
              begin
                if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[2] then ObjZav[Ptr].bParam[8] := true;
              end;
            end;
          end;
        end else
        if ObjZav[Ptr].ObjConstB[2] then // �������������� ������������ � ������
        begin
          if ObjZav[o].bParam[7] then // ��
          begin
            if ObjZav[Ptr].ObjConstB[3] then // �������� ������ ���� � �����
            begin
              if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[1] then ObjZav[Ptr].bParam[8] := true;
            end else
            if ObjZav[Ptr].ObjConstB[4] then // �������� ������ ���� � ������
            begin
              if not ObjZav[ObjZav[Ptr].ObjConstI[3]].bParam[2] then ObjZav[Ptr].bParam[8] := true;
            end;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[23] := false; // ��� ���������������� ��������� �������� �������

      if not ObjZav[Ptr].bParam[8] then
      begin
      // ����������� �������� ����� �������� ����������
        if ObjZav[Ptr].ObjConstB[1] then // �������������� ������������ � �����
        begin
          if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or ObjZav[o].bParam[12]) then
            ObjZav[Ptr].bParam[5] := true;
        end else
        if ObjZav[Ptr].ObjConstB[2] then // �������������� ������������ � ������
        begin
          if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or ObjZav[o].bParam[13]) then
            ObjZav[Ptr].bParam[5] := true;
        end;
      end;
    end;

    o := ObjZav[Ptr].ObjConstI[3]; // ������ �������� �������
    if not ObjZav[ObjZav[o].BaseObject].bParam[5] then
      ObjZav[ObjZav[o].BaseObject].bParam[5] := ObjZav[Ptr].bParam[5];
    if not ObjZav[ObjZav[o].BaseObject].bParam[8] then
      ObjZav[ObjZav[o].BaseObject].bParam[8] := ObjZav[Ptr].bParam[8];
    if not ObjZav[ObjZav[o].BaseObject].bParam[23] then
      ObjZav[ObjZav[o].BaseObject].bParam[23] := ObjZav[Ptr].bParam[23];
  end;
except
  reportf('������ [MainLoop.PrepDZStrelki]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������� ��� ������ �� �����
procedure PrepOxranStrelka(Ptr : Integer);
  var o,p : Integer;
begin
try
  inc(LiveCounter);
  // �������� �������������� ������� � ������ ��������
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
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false; // ���������� �������� ��������
    end else
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true;
  end;

  // ��������� �������� �������� �������, �� �������� � ������ ��������
  if ObjZav[ObjZav[Ptr].BaseObject].bParam[14] then
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := false
  else
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[ObjZav[Ptr].BaseObject].bParam[8];
except
  reportf('������ [MainLoop.PrepOxranStrelka]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������� ��� ������ �� ����� #2
procedure PrepStrelka(Ptr : Integer);
  var i,o,p : integer;
begin
try
  inc(LiveCounter);
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[ObjZav[Ptr].BaseObject].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[32];
    ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[1]; // ��
    ObjZav[Ptr].bParam[2] := ObjZav[ObjZav[Ptr].BaseObject].bParam[2]; // ��
    ObjZav[Ptr].bParam[4] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4]; // ��������� ������
    if ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] then // ����������� ��������� ������ �������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := false;

    if not ObjZav[ObjZav[Ptr].BaseObject].bParam[31] or ObjZav[ObjZav[Ptr].BaseObject].bParam[32] then
    begin // ��� ���������� ���������� ��� �������������� �������� �������� ��������� ���������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
    end else
    begin
    // ����������� ������� ���������� �������� �� ������ �������
      ObjZav[Ptr].bParam[9] := ObjZav[ObjZav[Ptr].BaseObject].bParam[9];

      if ({$IFDEF RMDSP}(ObjZav[Ptr].BaseObject = maket_strelki_index) or {$ENDIF} ObjZav[ObjZav[Ptr].BaseObject].bParam[24]) and not WorkMode.Podsvet then
      begin // ������� ����� ������� ��� ������� ���������� - �� �������� ������� �������
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
      end else
      begin
        if ObjZav[Ptr].bParam[1] then
        begin
          if ObjZav[Ptr].bParam[2] then
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin // ���� ����
            ObjZav[Ptr].bParam[20] := true; ObjZav[Ptr].bParam[21] := false; ObjZav[Ptr].bParam[22] := false; ObjZav[Ptr].bParam[23] := false; // ���������� ������� ���������� �������� � �����
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end;
        end else
        if ObjZav[Ptr].bParam[2] then
        begin // ���� �����
          ObjZav[Ptr].bParam[20] := false; ObjZav[Ptr].bParam[21] := true; ObjZav[Ptr].bParam[22] := false; ObjZav[Ptr].bParam[23] := false; // ���������� ������� ���������� �������� � ������
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
        end else
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false; OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
        end;
      end;

      // ��������� �������� ������� ���(�)
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].ObjConstB[9] and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[4] and ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] and ObjZav[ObjZav[Ptr].UpdateObject].bParam[2];

      // ������� �� �������
      ObjZav[Ptr].bParam[3] := ObjZav[ObjZav[Ptr].UpdateObject].bParam[5]; // �� �� ������
      inc(LiveCounter);
      // ��������� ���������� ��� �������
      for i := 1 to 10 do
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
            27 : begin // �������� ��������� �������
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

            6 : begin // ���������� ����
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

      // �������� ��������������
      if ObjZav[Ptr].bParam[3] then
      begin
        inc(LiveCounter);
      // ������ �������������� ����� ���� � ���������� ��������� �������
        if ObjZav[Ptr].bParam[1] then
        begin
          if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or // ������������ ����
             (ObjZav[Ptr].ObjConstB[8]) then                // ��� �������� ���������� ��������� �������
          begin //�� ���������� ����������
            o := ObjZav[Ptr].Neighbour[3].Obj; p := ObjZav[Ptr].Neighbour[3].Pin; i := 100;
            while i > 0 do
            begin
              case ObjZav[o].TypeObj of
                2 : begin // �������
                  case p of
                    2 : begin // ���� �� �����
                      if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                    end;
                    3 : begin // ���� �� ������
                      if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                    end;
                  else
                    ObjZav[Ptr].bParam[3] := false; break; // ������ � ���� ������
                  end;
                  p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                end;
                3,4 : begin // �������,����
                  if ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg then
                    ObjZav[Ptr].bParam[3] := ObjZav[o].bParam[1] // ��������� �������� �������
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
          if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or // ������������ ����
             (ObjZav[Ptr].ObjConstB[7]) then                // ��� �������� ���������� ��������� �������
          begin //�� ��������� ����������
            o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin; i := 100;
            while i > 0 do
            begin
              case ObjZav[o].TypeObj of
                2 : begin // �������
                  case p of
                    2 : begin // ���� �� �����
                      if ObjZav[o].bParam[2] then break; // ������� � ������ �� ������
                    end;
                    3 : begin // ���� �� ������
                      if ObjZav[o].bParam[1] then break; // ������� � ������ �� �����
                    end;
                  else
                    ObjZav[Ptr].bParam[3] := false; break; // ������ � ���� ������
                  end;
                  p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                end;
                3,4 : begin // �������,����
                  if ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg then
                    ObjZav[Ptr].bParam[3] := ObjZav[o].bParam[1] // ��������� �������� �������
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

      // �������� ��������� ��������� ������������
      if ObjZav[ObjZav[Ptr].BaseObject].ObjConstB[1] then
      begin
        inc(LiveCounter);
        if ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[2] then
        begin // ���� �������� ��������� ���������
          ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false; // �������� �������� ������� ������ ������� �� ��������� ���������
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := true;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
        end else
        begin
          if not ObjZav[ObjZav[Ptr].BaseObject].bParam[21] then
          begin // ������� �������� � ��������
            ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false; // �������� �������� ������� ������ ������� �� ��������� ���������
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
          end else
          if not ObjZav[ObjZav[Ptr].BaseObject].bParam[20] or
             not ObjZav[ObjZav[Ptr].BaseObject].bParam[22] then
          begin // �������� ������� ��� ��� ��������� �������
            ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false; // �������� �������� ������� ������ ������� �� ��������� ���������
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true;
          end else
          begin // �������� �� ��������� ���������
            if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
            begin
              if ObjZav[Ptr].Timers[1].Active then
              begin // ������� ������� ���������� ��������� ��������� ���������� �����
                if LastTime >= ObjZav[Ptr].Timers[1].First then
                begin
                  if (ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[8] = Ptr) and not ObjZav[Ptr].bParam[19] and
                     not ObjZav[Ptr].bParam[18] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[18] and // ��������
                     not ObjZav[ObjZav[Ptr].BaseObject].bParam[15] then // �����
                  begin
{$IFDEF RMDSP}
                    if WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group] and (ObjZav[Ptr].RU = config.ru) then // ������ ��������� ���� �������� ���������� �������� � ����
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
              begin // ������������� ����� ������ ������� �� ��������� ���������
                ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime + 0.000694;// 1 ������
              end;
            end else // ��� �������� - ����� �������
            begin
              ObjZav[Ptr].bParam[19] := false; ObjZav[Ptr].Timers[1].Active := false;
            end;

            if ObjZav[Ptr].bParam[19] and
               not ObjZav[Ptr].bParam[18] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[18] and // ��������
               not ObjZav[ObjZav[Ptr].BaseObject].bParam[15] and // �����
               WorkMode.Upravlenie then
            begin // ������
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := tab_page;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
            end else
            begin // �� ������
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := false;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := true;
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
            end;
          end;
        end;
      end;

      // ��������� ������� �������
      if ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[13] > 0 then
      begin
        if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[13]].bParam[1] then
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := true
        else
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false;
      end;

      // ����� ��������������� ��������� �� ��������������� ��������� ���������� ������ ��� PM ��� ��
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
         (ObjZav[ObjZav[Ptr].BaseObject].bParam[15] or  // ����� �� Fr4
{$IFDEF RMSHN} ObjZav[ObjZav[Ptr].BaseObject].bParam[19] or {$ENDIF} // ����� �� �������
          ObjZav[ObjZav[Ptr].BaseObject].bParam[24]) then // ������� �������� ���������� �������� � ���������� �����
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := true
      else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := false;
    end;

    //FR4
    if ObjZav[Ptr].ObjConstB[6] then
    begin // �������
      // ������ ��� ��������
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[16] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[16];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[16];
      // ������ ��� ���������������� ��������
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[17] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[ObjZav[Ptr].BaseObject].bParam[33];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[ObjZav[Ptr].BaseObject].bParam[33];
    end else
    begin // �������
      // ������ ��� ��������
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[16] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[17];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[ObjZav[Ptr].BaseObject].bParam[17];
      // ������ ��� ���������������� ��������
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
    begin // �����
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[ObjZav[Ptr].BaseObject].bParam[19] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[ObjZav[Ptr].BaseObject].bParam[15];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[ObjZav[Ptr].BaseObject].bParam[15];
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // ��������� ����������
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[18] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[ObjZav[Ptr].BaseObject].bParam[18];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[ObjZav[Ptr].BaseObject].bParam[18];
  end;
except
  reportf('������ [MainLoop.PrepStrelka]'); Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������ ��� ������ �� ����� #3
procedure PrepSekciya(Ptr : Integer);
  var p,msp,z,mi,ri : boolean; i : integer; sost : byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  p := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // �
  z := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���������
  ri := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  msp := not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  mi := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ����� ��
  ObjZav[Ptr].bParam[7] := not GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ����� �����

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if (ObjZav[Ptr].ObjConstI[8] > 0) and (ObjZav[Ptr].ObjConstI[9] > 0) then
      begin // ����� ���� ������� ���� ���� ������ ���(�)
        if p <> ObjZav[Ptr].bParam[1] then
        begin // ������������� ��������� �������� ����
          if p then
          begin // ������������ �������
            if msp then
            begin // ��������� ���(�)
              ObjZav[Ptr].Timers[1].Active := false; // ����� �������� ���(�)
            end else
            begin // ��������� ���(�)
              if not ObjZav[Ptr].Timers[1].Active then
              begin // ������ ������ �������
                ObjZav[Ptr].Timers[1].First := LastTime; ObjZav[Ptr].Timers[1].Active := true;
              end;
            end;
          end else
          begin // ������� �������
            ObjZav[Ptr].Timers[1].Active := false; // ����� �������� ���(�)
          end;
        end;
        if msp <> ObjZav[Ptr].bParam[4] then
        begin // ������������� ��������� ���
          if msp then
          begin // ��������� ���(�)
{$IFDEF RMSHN}
            if ObjZav[Ptr].Timers[1].Active then ObjZav[Ptr].dtParam[3] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
            ObjZav[Ptr].Timers[1].Active := false; // ����� �������� ���(�)
          end;
        end;
      end;

      ObjZav[Ptr].bParam[1] := p; ObjZav[Ptr].bParam[4] := msp;

      if ObjZav[Ptr].ObjConstI[9] > 0 then
      begin
        if ObjZav[Ptr].Timers[1].Active then
        begin // ������ �������� ���������� ���������
          Timer[ObjZav[Ptr].ObjConstI[9]] := 1 + Round((LastTime - ObjZav[Ptr].Timers[1].First) * 86400);
        end else
        begin // ������ ������
          Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
        end;
      end;

      if ObjZav[Ptr].bParam[21] then
      begin
        ObjZav[Ptr].bParam[20] := true; // ���������� ������� �������������� ����������� ������ (���������� ��������, ��������� � ����������� ������)
        ObjZav[Ptr].bParam[21] := false;
      end else
      begin
        ObjZav[Ptr].bParam[20] := false; // ����� ������� �������������� ����������� ������ (��������������� ��������, ��������� � ����������� ������)
      end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU) and WorkMode.Upravlenie; // ����� ���������� �������������
      if ObjZav[Ptr].bParam[2] <> z then
      begin
        ObjZav[Ptr].bParam[8]  := true;  // ����� �����������
        ObjZav[Ptr].bParam[14] := false; // ����� ��������������� ���������
        if z then
        begin // ��� ���������� ������
          ObjZav[Ptr].iParam[2] := 0; // �������� ������ ���������, ������������ ������������ �������
          ObjZav[Ptr].iParam[3] := 0; // �������� ������ ����
          ObjZav[Ptr].bParam[15] := false; // ����� 1��
          ObjZav[Ptr].bParam[16] := false; // ����� 2��
        end;
      end;
      ObjZav[Ptr].bParam[2] := z;  // �
      if ObjZav[Ptr].bParam[5] <> mi then
      begin
        ObjZav[Ptr].bParam[8]  := true;  // ����� �����������
        ObjZav[Ptr].bParam[14] := false; // ����� ��������������� ���������
        if mi then
        begin // ��� ���������� ������
          ObjZav[Ptr].bParam[15] := false; // ����� 1��
          ObjZav[Ptr].bParam[16] := false; // ����� 2��
        end;
      end;
      ObjZav[Ptr].bParam[5] := mi;  // ��

    // �������� �������� �� ������� ����������
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
        begin // ��� �����������
          if not ObjZav[Ptr].bParam[7] then
          begin // �� FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin // ������� ���������� ������ ����� ������
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // �� �������
          end;
        end else
        begin
          if not ObjZav[Ptr].bParam[7] then
          begin // �� FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            if tab_page then // �������� ������ ������� ��������� ��������
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
            else
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // �� �������
          end;
        end;
      end else
      begin // �� FR3
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[7];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := not ObjZav[Ptr].bParam[7];
{$IFDEF RMDSP}
      end;
{$ENDIF}

      if ObjZav[Ptr].bParam[3] <> ri then
      begin
        if ri and not StartRM then
        begin // ��������� ����� ������ ��� ��
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
      begin // ��������� ����������� ���� ��� ��������, �������
        if ((sost and 1) = 1) then
        begin // ��������� �o���� ��������� ������
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,394+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[1] := LastTime; inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,394+$1000); AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // ����������� ������������� ���� �������� ����������
{$ENDIF}
        end;
        if ((sost and 2) = 2) and not ObjZav[Ptr].bParam[9] then
        begin // ��������� �o���� ����������� ������
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,395+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[2] := LastTime; inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,395+$1000); AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // ����������� ������������� ���� �������� ����������
{$ENDIF}
        end;
      end;

      if WorkMode.Podsvet and ObjZav[Ptr].ObjConstB[6] then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;

    end else
    begin // ������� � ������������� ��������� ������
      if ObjZav[Ptr].ObjConstI[9] > 0 then Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
      ObjZav[Ptr].bParam[21] := true; // ���������� ������� ��������������� ������
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
    begin // ���� �����������
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // ���� 2 ���� �����������
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
  reportf('������ [MainLoop.PrepSekciya]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���� ��� ������ �� ����� #4
procedure PrepPuti(Ptr : Integer);
  var z1,z2,mic,min : boolean; i : integer; sost,sost1,sost2 : Byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �(�)
  z1 := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                     // ��
  z2 := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                     // ��
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);      // ���
  if ObjZav[Ptr].ObjConstI[6] > 0 then
    mic := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]) else mic := true; // ��(�)
  ObjZav[Ptr].bParam[15] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ���
  if ObjZav[Ptr].ObjConstI[8] > 0 then
    min := not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]) else min := true; // ��(�)
  ObjZav[Ptr].bParam[16] := not GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // �(�)
  ObjZav[Ptr].bParam[7] := not GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ����� ����� ���
  ObjZav[Ptr].bParam[11] := not GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ����� ����� ���

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU) and WorkMode.Upravlenie; // ����� ���������� �������������
      if ObjZav[Ptr].bParam[2] <> z1 then
      begin
        if ObjZav[Ptr].bParam[2] then
        begin
          ObjZav[Ptr].iParam[2] := 0;
          ObjZav[Ptr].bParam[8] := true; // ����� �����������
          ObjZav[Ptr].bParam[14] := false; // ����� ��������������� ���������
        end;
      end;
      ObjZav[Ptr].bParam[2] := z1;  // ��
      if ObjZav[Ptr].bParam[3] <> z2 then
      begin
        if ObjZav[Ptr].bParam[3] then
        begin
          ObjZav[Ptr].iParam[3] := 0;
          ObjZav[Ptr].bParam[8] := true; // ����� �����������
          ObjZav[Ptr].bParam[14] := false; // ����� ��������������� ���������
        end;
      end;
      ObjZav[Ptr].bParam[3] := z2;  // ��
      if ObjZav[Ptr].bParam[5] <> mic then
      begin
        if ObjZav[Ptr].bParam[5] then
        begin
          ObjZav[Ptr].bParam[8] := true; // ����� �����������
          ObjZav[Ptr].bParam[14] := false; // ����� ��������������� ���������
        end;
      end;
      ObjZav[Ptr].bParam[5] := mic;  // ��(�)
      if ObjZav[Ptr].bParam[6] <> min then
      begin
        if ObjZav[Ptr].bParam[6] then
        begin
          ObjZav[Ptr].bParam[8] := true; // ����� �����������
          ObjZav[Ptr].bParam[14] := false; // ����� ��������������� ���������
        end;
      end;
      ObjZav[Ptr].bParam[6] := min;  // ��(�)

    // �������� �������� �� ������� ����������
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

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];                            // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];                            // ��
{$IFDEF RMDSP}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[16]; // �
{$ELSE}
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[16];
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];                            // ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[15];                           // ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[9];                            // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[5] and ObjZav[Ptr].bParam[6]; // ��

{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if not ObjZav[Ptr].bParam[14] then
        begin // ��� ����������� ������� ���������� ������ ����� ������
          if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then
          begin // �� FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin // ������� ���������� ������ ����� ������
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // �� �������
          end;
        end else
        begin
          if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then
          begin // �� FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            if tab_page then // �������� ������ ������� ��������� ��������
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
            else
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8]; // �� �������
          end;
        end;
      end else
      begin // �� FR3
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[11];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := not (ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[11]);
{$IFDEF RMDSP}
      end;
{$ENDIF}

      sost1 := GetFR5(ObjZav[Ptr].ObjConstI[2] div 8);
      if (ObjZav[Ptr].ObjConstI[9] > 0) and (ObjZav[Ptr].ObjConstI[2] <> ObjZav[Ptr].ObjConstI[9]) then
      begin // ���� ������ ��������� ���� - ��������� ����������� �� ������ ���������
        sost2 := GetFR5(ObjZav[Ptr].ObjConstI[9] div 8);
      end else
        sost2 := 0;

      sost := sost1 or sost2;

      ObjZav[Ptr].Timers[1].Active := ObjZav[Ptr].Timers[1].First < LastTime; // ��������� ������� ���������� ������������� ����������� �� ������ ������������ �� 1 ���.
      if (sost > 0) and ((sost <> byte(ObjZav[Ptr].iParam[4])) or ObjZav[Ptr].Timers[1].Active) then
      begin
        ObjZav[Ptr].iParam[4] := SmallInt(sost); // ��������� ��� ���������������� ���������

{$IFDEF RMSHN}
        ObjZav[Ptr].Timers[1].First := LastTime + 1 / 86400; // ������������� ����� ���������� ����������� ��
{$ELSE}
        ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400; // ������������� ����� ���������� ����������� ���
{$ENDIF}
        if (sost and 4) = 4 then
        begin // ��������� ���������� ����� ����
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,397+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[3] := LastTime; inc(ObjZav[Ptr].siParam[3]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,397+$1000); AddFixMessage(GetShortMsg(1,397,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // ����������� ������������� ���� �������� ����������
{$ENDIF}
        end;
        if (sost and 1) = 1 then
        begin // ��������� �o���� ��������� ����
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,394+$1000); SingleBeep := true; ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[1] := LastTime; inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,394+$1000);  AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // ����������� ������������� ���� �������� ����������
{$ENDIF}
        end;
        if (sost and 2) = 2 then
        begin // ��������� ������ ����������� ����
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,395+$1000); SingleBeep := true; //ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[2] := LastTime; inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,395+$1000); AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // ����������� ������������� ���� �������� ����������
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
    begin // ���� �����������
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[2] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // ���� 2 ���� �����������
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
  reportf('������ [MainLoop.PrepPuti]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��������� ��� ������ �� ����� #5
procedure PrepSvetofor(Ptr : Integer);
  var i,j : integer; n,o,zso,vnp,kz : boolean; sost : Byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��1
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��2
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �1
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �2
  o  := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[8] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // �
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // �� - ��������� ������� ���������

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU); // ����� ���������� �������������

      inc(LiveCounter);
      if o <> ObjZav[Ptr].bParam[5] then
      begin // ������� ���� �������� ���������
        if o then
        begin // ������������� ��������� ���������
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
                InsArcNewMsg(Ptr,482+$1000) // ���������� ������ ���������
              else
                InsArcNewMsg(Ptr,272+$1000); // ���������� ����������� �����
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[1] := LastTime; inc(ObjZav[Ptr].siParam[1]);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[20] := false; // ����� ���������� �������������
      end;
      ObjZav[Ptr].bParam[5] := o;  // �

      if ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[3] or
         ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[4] then
      begin // ������ ��� �������� �������
        ObjZav[Ptr].iParam[1] := 0; // �������� ������ ��������
        ObjZav[Ptr].bParam[34] := false;
        if not ObjZav[Ptr].bParam[19] and
           ((ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[3]) or
            (ObjZav[Ptr].bParam[2] and ObjZav[Ptr].bParam[4])) then
        begin // ������������� �� �&�� ^ ��&���
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

      // ����� � � �� �� ���������� ����������� ������
      if ObjZav[Ptr].BaseObject > 0 then
      begin
        if ObjZav[Ptr].bParam[11] <> ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
        begin
          if ObjZav[Ptr].bParam[11] then
          begin // ��������� ����������� ������
            ObjZav[Ptr].iParam[1] := 0;
            ObjZav[Ptr].bParam[34] := false;
          end else
          begin // ���������� ����������� ������
            ObjZav[Ptr].bParam[14] := false; // ����� ����������� ���������
            ObjZav[Ptr].bParam[7] := false;  // ����� �
            ObjZav[Ptr].bParam[9] := false;  // ����� ��
            ObjZav[Ptr].iParam[2] := 0;      // ����� ��
            ObjZav[Ptr].iParam[3] := 0;      // ����� ��
          end;
          ObjZav[Ptr].bParam[11] := ObjZav[ObjZav[Ptr].BaseObject].bParam[2];
        end;
      end;

    // �������� �������� �� ������� ����������
      ObjZav[Ptr].bParam[18] := false;
      ObjZav[Ptr].bParam[21] := false; // ���
      for i := 20 to 24 do
      begin
        j := ObjZav[Ptr].ObjConstI[i];
        if j > 0 then
        begin
          case ObjZav[j].TypeObj of
            25 : begin // ��
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(j);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // ������� ���
                ObjZav[Ptr].bParam[21] := ObjZav[j].bParam[1] and     // ��
                                          not ObjZav[j].bParam[4] and // ��
                                          ObjZav[j].bParam[5];        // �
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[j].bParam[3]; // ��&�� ��� ��
            end;
            43 : begin //���
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // ������� ���
                ObjZav[Ptr].bParam[21] := ObjZav[ObjZav[j].BaseObject].bParam[1] and     // ��
                                          not ObjZav[ObjZav[j].BaseObject].bParam[4] and // ��
                                          ObjZav[ObjZav[j].BaseObject].bParam[5] and     // �
                                          not ObjZav[j].bParam[2]; // ���
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[ObjZav[j].BaseObject].bParam[3]; // ��&�� ��� ��
            end;
            48 : begin //���
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // ������� ���
                ObjZav[Ptr].bParam[21] := ObjZav[ObjZav[j].BaseObject].bParam[1] and     // ��
                                          not ObjZav[ObjZav[j].BaseObject].bParam[4] and // ��
                                          ObjZav[ObjZav[j].BaseObject].bParam[5] and     // �
                                          ObjZav[j].bParam[1]; // ���� ������ �� ����
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[ObjZav[j].BaseObject].bParam[3]; // ��&�� ��� ��
            end;
            52 : begin //�����
              if not ObjZav[Ptr].bParam[18] then ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
              if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
              begin // ������� ���
                ObjZav[Ptr].bParam[21] := ObjZav[ObjZav[j].BaseObject].bParam[1] and     // ��
                                          not ObjZav[ObjZav[j].BaseObject].bParam[4] and // ��
                                          ObjZav[ObjZav[j].BaseObject].bParam[5] and     // �
                                          ObjZav[j].bParam[1]; // ���� ������ �� ���������� ��������
              end;
              ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or not ObjZav[ObjZav[j].BaseObject].bParam[3]; // ��&�� ��� ��
            end;
          end;
        end;
      end;

      if (ObjZav[Ptr].iParam[2] = 0) and // ������� ��
         (ObjZav[Ptr].iParam[3] = 0) and // ������� ��
         not ObjZav[Ptr].bParam[18] then // ������� ��
      begin // �������������� ���������� ����������� ����
        if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
        begin // ����� ������� ��� ����������� ����������� ������
          ObjZav[Ptr].Timers[1].Active := false;
        end else
        // ����������� ������ ������
        if ObjZav[Ptr].bParam[4] then
        begin // ������ ������
          if not ObjZav[Ptr].Timers[1].Active then
          begin // ��������� ������ �������
            ObjZav[Ptr].Timers[1].Active := true;
            ObjZav[Ptr].Timers[1].First := LastTime;
          end;
        end else
        begin // ������ ����������
          if ObjZav[Ptr].Timers[1].Active then
          begin
            ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].dtParam[6] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
          end;
        end;
      end;

      if (ObjZav[Ptr].iParam[2] = 0) and // ������� ��
         (ObjZav[Ptr].iParam[3] = 0) and // ������� ��
         not ObjZav[Ptr].bParam[18]      // ������� ��
{$IFDEF RMDSP} and (ObjZav[Ptr].RU = config.ru) and WorkMode.Upravlenie {$ENDIF} then // ��-��� - ��������� ������������ ������ � ������� ����������
      begin // �������� ������ �������
        if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
        begin // ��� ��������� ����������� ������
          if not ObjZav[Ptr].Timers[1].Active and not ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[9] then
          begin // ��� �������� ������������� ��������� ����������� ����
            if ObjZav[Ptr].bParam[4] then
            begin // ���� �
              if not ObjZav[Ptr].bParam[19] then
              begin // ��� �������� ������������� ���������
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
            begin // ���� �� ��� ������ ��������
              if ObjZav[Ptr].Timers[2].Active then
              begin // �������� ������������� ����������� ����������� ����
                if LastTime > ObjZav[Ptr].Timers[2].First then
                begin
                  if not ObjZav[Ptr].bParam[19] then
                  begin // ��� �������� ������������� ���������
                    if WorkMode.FixedMsg then
                    begin
                      InsArcNewMsg(Ptr,510+$1000); AddFixMessage(GetShortMsg(1,510,ObjZav[Ptr].Liter),4,1);
                    end;
                  end;
                  ObjZav[Ptr].bParam[19] := true;
                end;
              end else
              begin // ��� �������� ������������� ����������� ����������� ����
                ObjZav[Ptr].Timers[2].First := LastTime + 5 / 86400; ObjZav[Ptr].Timers[2].Active := true;
              end;
            end;
          end else // �������� ������ ���� ���������� ������
            ObjZav[Ptr].Timers[2].Active := false;

        end else
        if ObjZav[Ptr].bParam[6] or ObjZav[Ptr].bParam[8] then
        begin // ���� ��������� ����������� ������ � ������� � ��� ��
          if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
          begin // ���� ��������� ����������� ������
            if not ObjZav[Ptr].bParam[27] then
            begin
              if not (ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[4]) then
              begin // ������ ������
                if WorkMode.FixedMsg then
                begin
                  InsArcNewMsg(Ptr,509+$1000); AddFixMessage(GetShortMsg(1,509,ObjZav[Ptr].Liter),4,1); ObjZav[Ptr].bParam[19] := true;
                end;
              end;
              ObjZav[Ptr].bParam[27] := true; // ��������� ������� ����������� ������
            end;
          end;
        end;
      end;
      if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then ObjZav[Ptr].bParam[27] := false; // �������� ������� �������� ������� ����������� ������

      if ObjZav[Ptr].ObjConstI[28] > 0 then
      begin // ���������� ��������� ������������ �������
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
            begin // ��� ����������� ������� ����������
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[7]; // �� �������
            end else
            if tab_page then // �������� ������ ������� ��������� ��������
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].bParam[34] // �� FR3 ���� ��� ������ ������
            end else
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[7]; // �� �������
            end;
          end else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[6]; // �� FR3
          if WorkMode.Upravlenie then
          begin
            if not ObjZav[Ptr].bParam[14] and ObjZav[Ptr].bParam[9] then
            begin // ��� ����������� ������� ����������
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[9]; // �� �������
            end else
            if tab_page then // �������� ������ ������� ��������� ��������
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[34] // �� FR3 ���� ��� ������ ������
            end else
            begin
              if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[9]; // �� �������
            end;
          end else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[8]; // �� FR3
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
      if (ObjZav[Ptr].iParam[2] = 0) and // ������� ��
         (ObjZav[Ptr].iParam[3] = 0) and // ������� ��
         not ObjZav[Ptr].bParam[18] then // ������� ��
      begin // �������������� ���������� ������� ���� �� ���������� ������� ������� �� �����
        if ((sost and 1) = 1) and not ObjZav[Ptr].bParam[18] then
        begin // ��������� ���������� ���������
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then
          begin
{$ENDIF}
            if WorkMode.OU[0] then
            begin // ���������� � ������ ���������� � ����
              InsArcNewMsg(Ptr,396+$1000); AddFixMessage(GetShortMsg(1,396,ObjZav[Ptr].Liter),4,1);
            end else
            begin // ���������� � ������ ���������� � ������
              InsArcNewMsg(Ptr,403+$1000); AddFixMessage(GetShortMsg(1,403,ObjZav[Ptr].Liter),4,1);
            end;
{$IFDEF RMDSP}
          end;
          ObjZav[Ptr].bParam[23] := WorkMode.Upravlenie and WorkMode.OU[0]; // ����������� ������������� ���� �������� ����������
{$ENDIF}
{$IFNDEF RMDSP}
          ObjZav[Ptr].dtParam[2] := LastTime; inc(ObjZav[Ptr].siParam[2]);
          ObjZav[Ptr].bParam[23] := true; // ����������� �������������
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

    ObjZav[Ptr].bParam[29] := true; // �����������
    ObjZav[Ptr].bParam[30] := false; // ��������������
    o   := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // ���(Co)
    zso := GetFR3(ObjZav[Ptr].ObjConstI[25],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // �Co
    vnp := GetFR3(ObjZav[Ptr].ObjConstI[26],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // ���
    ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // ��
    n := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // �
    kz := GetFR3(ObjZav[Ptr].ObjConstI[30],ObjZav[Ptr].bParam[30],ObjZav[Ptr].bParam[29]); // ��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[30];
    if not ObjZav[Ptr].bParam[30] then // ��������������2
    begin
      if o <> ObjZav[Ptr].bParam[15] then
      begin // ��������� ���(��)
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
        ObjZav[Ptr].bParam[20] := false; // ����� ���������� �������������
      end;
      ObjZav[Ptr].bParam[15] := o;
      if zso <> ObjZav[Ptr].bParam[24] then
      begin // ��������� ���
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
        ObjZav[Ptr].bParam[20] := false; // ����� ���������� �������������
      end;
      ObjZav[Ptr].bParam[24] := zso;
      if vnp <> ObjZav[Ptr].bParam[25] then
      begin // ��������� ���
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
        ObjZav[Ptr].bParam[20] := false; // ����� ���������� �������������
      end;
      ObjZav[Ptr].bParam[25] := vnp;

      if n <> ObjZav[Ptr].bParam[17] then
      begin // ��������� �
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
        ObjZav[Ptr].bParam[20] := false; // ����� ���������� �������������
      end;
      ObjZav[Ptr].bParam[17] := n;

      if kz <> ObjZav[Ptr].bParam[26] then
      begin // ��������� ��
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
        ObjZav[Ptr].bParam[20] := false; // ����� ���������� �������������
      end;
      ObjZav[Ptr].bParam[26] := kz;
      inc(LiveCounter);

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[20]; // ���������� �������������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[30];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[15] or ObjZav[Ptr].bParam[24] or ObjZav[Ptr].bParam[25]; // Co,���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] :=  ObjZav[Ptr].bParam[26]; // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[17]; // �
    end;
  end;
except
  reportf('������ [MainLoop.PrepSvetofor]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������� ��������� ������� ��� ������ �� ����� #9
procedure PrepRZS(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  rz := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //����

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
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; // ����
    end;
  end;
except
  reportf('������ [MainLoop.PrepRZS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� �������� ���� ������� ��� ������ �� ����� #17
procedure PrepMagStr(Ptr : Integer);
  var lar : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  lar := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���

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
      begin // ��������� ��������� ���
        if lar then
        begin // ������������� ������� ��
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
  reportf('������ [MainLoop.PrepMagStr]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� ������ ������� ��� ������ �� ����� #18
procedure PrepMagMakS(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��

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
  reportf('������ [MainLoop.PrepMagMakS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� �������� ������� ��� ������ �� ����� #19
procedure PrepAPStr(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���

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
    begin // �������� ������� ���������������� �������� ��� �������������
      ObjZav[Ptr].bParam[1] := false;
    end;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
  end;
except
  reportf('������ [MainLoop.PrepAPStr]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� ���� � ������ �� ����� #6
procedure PrepPTO(Ptr : Integer);
  var zo,og : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  zo := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  og := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := (config.ru = ObjZav[ptr].RU); // ����� ���������� �������������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := false;

      if og <> ObjZav[Ptr].bParam[2] then
      begin
        if og then
        begin // �����������
          if not zo then
          begin // ���� ��� ������� �� ���������� - ��������� ������
            ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
            ObjZav[Ptr].Timers[1].Active := true;
            ObjZav[Ptr].bParam[4] := false; // �������������� ������� ������������� ��
            ObjZav[Ptr].bParam[5] := false;
          end;
        end else
        begin // �����
          ObjZav[Ptr].Timers[1].Active := false;
        end;
      end;
      ObjZav[Ptr].bParam[2] := og;

      if zo <> ObjZav[Ptr].bParam[1] then
      begin
        if zo then
        begin // ������� ������ ����������
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
        begin // ���� ������ ����������
          ObjZav[Ptr].bParam[4] := false; // �������������� ������� ������������� ��
          ObjZav[Ptr].bParam[5] := false;
          ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
          ObjZav[Ptr].Timers[1].Active := true;
        end;
      end;
      ObjZav[Ptr].bParam[1] := zo;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[4];
      if ObjZav[Ptr].bParam[2] and not ObjZav[Ptr].bParam[1] then
      begin // ���������� ��� �������
        if ObjZav[Ptr].Timers[1].Active then
        begin
          if (ObjZav[Ptr].Timers[1].First > LastTime) or ObjZav[Ptr].bParam[4] then
          begin // ������� ������������� �������� �������
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[2];
          end else
          begin
            if not ObjZav[Ptr].bParam[5] then
            begin // ��������� ������������� ��
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
  reportf('������ [MainLoop.PrepPTO]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��� � ������ �� ����� #8
procedure PrepUTS(Ptr : Integer);
  var uu : Boolean; p : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  uu := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���

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
          begin // ��������� ��������� ��������� ����� � ������������� �������� ������ �� ����
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
        begin // ���� ����������
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
      begin // ��� �������� ���������
        p := ObjZav[Ptr].BaseObject;
        if (p > 0) and not ObjZav[Ptr].bParam[3] and not ObjZav[Ptr].bParam[4] then
        begin
          if (not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[4]) or
             (not ObjZav[ObjZav[Ptr].BaseObject].bParam[3] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[15]) then
          begin // ��������� ��������� ��������� ����� � ������������� �������� ������ �� ����
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
        if not WorkMode.FixedMsg then ObjZav[Ptr].bParam[4] := true; // ����������� �� ������ �������
        if not ObjZav[Ptr].bParam[4] then
        begin // �� ������������� ��������� � ������ ��������
          if ObjZav[Ptr].Timers[1].Active then
          begin
            if ObjZav[Ptr].Timers[1].First < LastTime then
            begin // ������������� ������ �������� ��������� �����
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
          begin // ������ ������ �������
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
  reportf('������ [MainLoop.PrepUTS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� ��������� ��� ������ �� ����� #10
procedure PrepUPer(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  rz := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ����

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[3]; // ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4]; // ����

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
        begin // ������� ������
          if ObjZav[Ptr].Timers[1].Active then
          begin
            if ObjZav[Ptr].Timers[1].First < LastTime then
            begin // ������ ��������� � ���������� �������� �������� ��� ������ ��
              InsArcNewMsg(Ptr,514+$2000);
              if ObjZav[Ptr].bParam[5] then AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter),0,4) else AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter),0,3);
              ObjZav[Ptr].bParam[5] := true; ObjZav[Ptr].Timers[1].First := LastTime + 60 / 86400; // �������� ������ ���������� ���������
            end;
          end else
          begin // ������ �������� ���������� ���������
            ObjZav[Ptr].Timers[1].First := LastTime + 600 / 86400; ObjZav[Ptr].Timers[1].Active := true;
          end;
        end else
        begin // ������� ������
          ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[5] := false; // �������� �������� ����������� �������� ������� ��� ������
        end;
      end;
{$ENDIF}

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[2];
    end;
  end;
except
  reportf('������ [MainLoop.PrepUPer]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��������(1) �������� ��� ������ �� ����� #11
procedure PrepKPer(Ptr : Integer);
  var knp,kap,zg : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  kap := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  knp := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  zg := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��

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
  reportf('������ [MainLoop.PrepKPer]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��������(2) �������� ��� ������ �� ����� #12
procedure PrepK2Per(Ptr : Integer);
  var knp,knzp,kop,zg : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  knp := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  knzp := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ����
  zg := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  kop := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if knp <> ObjZav[Ptr].bParam[12] then
      begin // ��������� �� ������� ������������� �� ��������
        if knp then
        begin // ������������� ��������� ��������->����������
          ObjZav[Ptr].Timers[2].First := LastTime+10/86400; ObjZav[Ptr].Timers[2].Active := true;
        end else
        begin // ������������� ��������� ����������->��������
          ObjZav[Ptr].Timers[2].First := 0; ObjZav[Ptr].Timers[2].Active := false; ObjZav[Ptr].bParam[2] := false; // �������� ��������� ������������� ��������
        end;
      end;
      ObjZav[Ptr].bParam[12] := knp;
      if not ObjZav[Ptr].bParam[2] and ObjZav[Ptr].Timers[2].Active then
      begin // �������� 10 ������ �� ������� ������������� �� ��������
        if ObjZav[Ptr].Timers[2].First < LastTime then
        begin // ���������� ������������� �� ��������
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
      begin // ������� �������� ��������� ��������
        ObjZav[Ptr].bParam[3] := false; ObjZav[Ptr].bParam[5] := true; ObjZav[Ptr].bParam[1] := false;
        ObjZav[Ptr].Timers[1].First := 0; ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[11] := false;
      end else
      if knzp and not kop then
      begin // ������� �������� ��������� ��������
        ObjZav[Ptr].bParam[3] := true; ObjZav[Ptr].bParam[5] := false; ObjZav[Ptr].bParam[1] := false;
        ObjZav[Ptr].Timers[1].First := 0; ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[11] := false;
      end else
      begin // ������ �� ��������
        if not ObjZav[Ptr].Timers[1].Active then
        begin // ������������� ��������� ��������->������
          ObjZav[Ptr].Timers[1].First := LastTime+10/86400; ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].bParam[11] := true;
        end else
        if not ObjZav[Ptr].bParam[1] then
        begin // ������� 10 ������ �� ������� ������ �� ��������
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin // ���������� ������ �� ��������
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
      if ObjZav[Ptr].bParam[1] then // ������ �� ��������
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[1]
      else // ������������� �� ��������
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
  reportf('������ [MainLoop.PrepK2Per]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� �������� ��� ������ �� ����� #13
procedure PrepOM(Ptr : Integer);
  var rz,rrm : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // �� (���)
  rrm := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��� (��)
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��� (���)
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��� (���)

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
            begin // ������������ ���
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
            begin // ������������ ���
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
      begin // ��� ������������� ��� ����������� ����� ���������� ��� ���������� ���������� "�����"
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
      begin // ������������ ���
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2];
      end else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[1]; // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2]; // ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[3]; // ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4]; // ���
    end;
  end;
except
  reportf('������ [MainLoop.PrepOM]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ����� ��� ������ �� ����� #14
procedure PrepUKSPS(Ptr : Integer);
  var d1,d2,kzk : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��������������� �������
  d1 := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // 1��
  d2 := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // 2��
  kzk := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���

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
        begin // ������������� ����� �����
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
  reportf('������ [MainLoop.PrepUKSPS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� �������� ������ ��� ������ �� ����� #20
procedure PrepMaket(Ptr : Integer);
  var km : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  km := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���

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
  reportf('������ [MainLoop.PrepMaket]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� �������� ������� ������ ��� ������ �� ����� #21
procedure PrepOtmen(Ptr : Integer);
  var om,op,os : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  os := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���
  om := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��1
  op := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��1
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if ObjZav[Ptr].ObjConstI[5] > 0 then
      begin // ������ ������ �� ����������
        if os <> ObjZav[Ptr].bParam[1] then
        begin
          if ObjZav[Ptr].Timers[1].Active then
          begin // ��������� ���� �������
            ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[1] := Timer[ObjZav[Ptr].ObjConstI[5]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
          end else
          begin // ������ ���� �������
            ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime; Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[1] := os;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];

      if ObjZav[Ptr].ObjConstI[6] > 0 then
      begin // ������ ������ ����������
        if om <> ObjZav[Ptr].bParam[2] then
        begin
          if ObjZav[Ptr].Timers[2].Active then
          begin // ��������� ���� �������
            ObjZav[Ptr].Timers[2].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[2] := Timer[ObjZav[Ptr].ObjConstI[6]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[6]] := 0;
          end else
          begin // ������ ���� �������
            ObjZav[Ptr].Timers[2].Active := true; ObjZav[Ptr].Timers[2].First := LastTime; Timer[ObjZav[Ptr].ObjConstI[6]] := 0;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := om;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];

      if ObjZav[Ptr].ObjConstI[7] > 0 then
      begin // ������ ������ ��������
        if op <> ObjZav[Ptr].bParam[3] then
        begin
          if ObjZav[Ptr].Timers[3].Active then
          begin // ��������� ���� �������
            ObjZav[Ptr].Timers[3].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[3] := Timer[ObjZav[Ptr].ObjConstI[7]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[7]] := 0;
          end else
          begin // ������ ���� �������
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
      begin // �������� �������� ������� ������ �� ����������
        Timer[ObjZav[Ptr].ObjConstI[5]] := Round((LastTime - ObjZav[Ptr].Timers[1].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[5]] > 300 then Timer[ObjZav[Ptr].ObjConstI[5]] := 300;
      end;
      if ObjZav[Ptr].Timers[2].Active then
      begin // �������� �������� ������� ������ ����������
        Timer[ObjZav[Ptr].ObjConstI[6]] := Round((LastTime - ObjZav[Ptr].Timers[2].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[6]] > 300 then Timer[ObjZav[Ptr].ObjConstI[6]] := 300;
      end;
      if ObjZav[Ptr].Timers[3].Active then
      begin // �������� �������� ������� ������ ��������
        Timer[ObjZav[Ptr].ObjConstI[7]] := Round((LastTime - ObjZav[Ptr].Timers[3].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[7]] > 300 then Timer[ObjZav[Ptr].ObjConstI[7]] := 300;
      end;
    end else
    begin // ����� ��������� ��� ������������� �������� ���������� ��� ��������� ����������
      if ObjZav[Ptr].ObjConstI[5] > 0 then Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
      ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[1] := false;
      if ObjZav[Ptr].ObjConstI[6] > 0 then Timer[ObjZav[Ptr].ObjConstI[6]] := 0;
      ObjZav[Ptr].Timers[2].Active := false; ObjZav[Ptr].bParam[2] := false;
      if ObjZav[Ptr].ObjConstI[7] > 0 then Timer[ObjZav[Ptr].ObjConstI[7]] := 0;
      ObjZav[Ptr].Timers[3].Active := false; ObjZav[Ptr].bParam[3] := false;
    end;
  end;
except
  reportf('������ [MainLoop.PrepOtmen]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��� ��� ������ �� ����� #22
procedure PrepGRI(Ptr : Integer);
  var rz : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  rz := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���1
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if rz <> ObjZav[Ptr].bParam[1] then
      begin
        if ObjZav[Ptr].ObjConstI[5] > 0 then
        begin // ������ �������������� ����������
          if ObjZav[Ptr].Timers[1].Active then
          begin // ��������� ���� �������
            ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
            ObjZav[Ptr].siParam[1] := Timer[ObjZav[Ptr].ObjConstI[5]];
{$ENDIF}
            Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
          end else
          begin // ������ ���� �������
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
      begin // �������� �������� ������� ��
        Timer[ObjZav[Ptr].ObjConstI[5]] := Round((LastTime - ObjZav[Ptr].Timers[1].First)*86400);
        if Timer[ObjZav[Ptr].ObjConstI[5]] > 300 then Timer[ObjZav[Ptr].ObjConstI[5]] := 300;
      end;
    end else
    begin // ����� ��������� ��� ������������� �������� ���������� ��� ��������� ����������
      if ObjZav[Ptr].ObjConstI[5] > 0 then Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
      ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[1] := false;
    end;
  end;
except
  reportf('������ [MainLoop.PrepGRI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ����� ����������� �� �������� ��� ������ �� ����� #15
procedure PrepAB(Ptr : Integer);
  var kj,ip1,ip2,zs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // �
  ip1 := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // 1��
  ip2 := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // 2��
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ��
  ObjZav[Ptr].bParam[5] := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  kj := not GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // ��
  ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // �1
  zs := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                        // ������ ����� �����������
  ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // �
  ObjZav[Ptr].bParam[8]  := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // �2
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // 3��
  ObjZav[Ptr].bParam[17] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   // �������� ����� �����������

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if zs <> ObjZav[Ptr].bParam[10] then
      begin // ������� ������ �� ����� �����������
        if ObjZav[Ptr].bParam[4] and WorkMode.FixedMsg then
        begin // ������� �� �����������
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then
          begin
{$ENDIF}
            if zs then begin // ������ ����������
              InsArcNewMsg(Ptr,439+$2000); AddFixMessage(GetShortMsg(1,439,ObjZav[Ptr].Liter),0,6);
            end else
            if ObjZav[Ptr].bParam[1] then // �� ������ ����� (� ��� �����)
            begin // ������ �������
              if ObjZav[Ptr].bParam[17] then // ������ �������� ����� �����������
                InsArcNewMsg(Ptr,56+$2000)
              else // ���� ������
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
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := tab_page // �������� ����� ����������� - ������
      else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := ObjZav[Ptr].bParam[10]; // ������ ����� �����������

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[16];    // �
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := not ObjZav[Ptr].bParam[11]; // 3��
      if kj <> ObjZav[Ptr].bParam[6] then
      begin
        if kj then
        begin // �������� ��
          ObjZav[Ptr].bParam[9] := false; // ����� ����������� ���.������
        end else // ����� ��
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
        begin // ������� 1 �����������
          if not ObjZav[Ptr].bParam[6] then ObjZav[Ptr].bParam[9] := true; // ���� ����������� ���.������
          if ObjZav[Ptr].ObjConstB[2] then
          begin // ���� ����� �����������
            if ObjZav[Ptr].ObjConstB[3] then
            begin // ������������ ��������
              if ObjZav[Ptr].ObjConstB[4] then
             begin // �� ������
                if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                begin // �������� ���������
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true;
                end else // �������� ��������
                if config.ru = ObjZav[ptr].RU then Ip1Beep := true;
              end else
              if ObjZav[Ptr].ObjConstB[5] then
              begin // �� �����������
                if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then
                begin // �������� ���������
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true;
                end;
              end;
            end else // �������� ������� ���������
            if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true;
          end else
          if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU) then Ip1Beep := true; // �� ������ �������
        end;
      end;
      ObjZav[Ptr].bParam[2] := ip1;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];
      if ip2 <> ObjZav[Ptr].bParam[3] then
      begin
        if ObjZav[Ptr].bParam[3] then
        begin // ������� 2 �����������
          if ObjZav[Ptr].ObjConstB[2] then
          begin // ���� ����� �����������
            if ObjZav[Ptr].ObjConstB[3] then
            begin // ������������ ��������
              if ObjZav[Ptr].ObjConstB[4] then
              begin // �� ������
                if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                begin // �������� ���������
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true;
                end else // �������� ��������
                if config.ru = ObjZav[ptr].RU then Ip2Beep := true;
              end else
              if ObjZav[Ptr].ObjConstB[5] then
              begin // �� �����������
                if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then
                begin // �������� ���������
                  if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true;
                end;
              end;
            end else // �������� ������� ���������
            if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true;
          end else
          if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU) then Ip2Beep := true; // �� ������ �������
        end;
      end;
      ObjZav[Ptr].bParam[3] := ip2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
      if ObjZav[Ptr].ObjConstB[2] then
      begin // ���� ����� �����������
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[5];

        if ObjZav[Ptr].ObjConstB[3] then
        begin // �������� ����� ����������� ������������
          inc(LiveCounter);
          if ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[8] then
          begin // ������� ��������� ��������
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
          end else
          begin
            if ObjZav[Ptr].ObjConstB[4] then
            begin // ���� ������
              if ObjZav[Ptr].bParam[7] then
              begin // �1�
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[1];
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4];
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
              end else
              if ObjZav[Ptr].bParam[8] then
              begin // �2�
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
              end else
              begin
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := true;
              end;
            end else
            if ObjZav[Ptr].ObjConstB[5] then
            begin // ���� �����������
              if ObjZav[Ptr].bParam[7] then
              begin // �1�
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;
                OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := false;
              end else
              if ObjZav[Ptr].bParam[8] then
              begin // �2�
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
        begin // �������� ����� ����������� ������� ���������
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[1];
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[4];
        end;
      end;
    end;

    // FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // ��������� ����������
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // ���� �����������
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // ���� 2 ���� �����������
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
    begin // ��������� ������ �������� ����������� ���������
      if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
      begin // ������ ����������
        ObjZav[Ptr].bParam[14] := false; // ����� ������������ ���������
        ObjZav[Ptr].bParam[15] := false; // ����� ��������� �������� ����������� �� �������
        // ���� �������� ��������� ������� �� ��� �������������
      end else
      begin // ������ ��������

      end;
    end;
  end;
except
  reportf('������ [MainLoop.PrepAB]');
  Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// ���������� ������� ��������������� ����� ����������� �� �������� ��� ������ �� ����� #16
procedure PrepVSNAB(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���

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
  reportf('������ [MainLoop.PrepVSNAB]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���� ��������� ������ ��� ������ �� ����� #30
procedure PrepDSPP(Ptr : Integer);
  var egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  egs := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �

  // ���
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
  reportf('������ [MainLoop.PrepDSPP]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��� ��� ������ �� ����� #26
procedure PrepPAB(Ptr : Integer);
  var fp,gp,kj,o : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  fp := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                        // ��
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��������������� �������
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ���
  ObjZav[Ptr].bParam[5] := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // �
  kj := not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // ��
  o  := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                       // �
  gp := not GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // ��

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if kj <> ObjZav[Ptr].bParam[7] then
      begin
        if not kj then// ����� ��
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
      ObjZav[Ptr].bParam[7] := kj;  // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[7];

      if o <> ObjZav[Ptr].bParam[8] then
      begin
        if o then
        begin // ���������� ����������������� ��������
          if WorkMode.FixedMsg then begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then begin
              InsArcNewMsg(ObjZav[Ptr].BaseObject,405+$1000); AddFixMessage(GetShortMsg(1,405,'�'+ObjZav[ObjZav[Ptr].BaseObject].Liter),0,4);
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
      ObjZav[Ptr].bParam[9] := gp; // ��
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
        begin // �������� ������ �������� ������
          if fp and (config.ru = ObjZav[ptr].RU) then SingleBeep := WorkMode.Upravlenie; // ���� ��������� � �������� ������ �� ������� (�������� ��������)
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
    begin // ��������� ����������
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // ���� �����������
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // ���� 2 ���� �����������
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
  reportf('������ [MainLoop.PrepPAB]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��������������� ��������� ��� ������ �� ����� #31
procedure PrepPSvetofor(Ptr : Integer);
  var o : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  o := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ������������� �����������

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin

      if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
      begin // �������� ������ ������
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
        begin // �������������
          if ObjZav[Ptr].Timers[1].First > LastTime then
          begin // ������� 4 ������� - ����������� �� �����
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin // ���������� ��������� ����������� ������ ������������
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
      begin // �������� ������ ������
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[1] := false;
        ObjZav[Ptr].bParam[2] := false;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
      end;
    end;
  end;
except
  reportf('������ [MainLoop.PrepPSvetofor]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������������� ������� ��� ������ �� ����� #7
procedure PrepPriglasit(Ptr : Integer);
  var i : integer; ps : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ps := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  if ObjZav[Ptr].ObjConstI[3] > 0 then
    ObjZav[Ptr].bParam[2] := not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���

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
        begin // ���� �� ������ - ��������� �����������
          if ObjZav[Ptr].bParam[2] then
          begin
            if not ObjZav[Ptr].bParam[19] then
            begin // ��������� 3 ������
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
                    ObjZav[Ptr].bParam[19] := true; // �������� ������������� ��
                  end;
                end;
              end else
              begin
                ObjZav[Ptr].Timers[1].Active := true; ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
              end;
            end;
          end else
          begin
            ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[19] := false; // ����� �������� ������������� ��
          end;
        end else
        begin
          ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[19] := false; // ����� �������� ������������� ��
        end;
      end;
    end;
  end;
except
  reportf('������ [MainLoop.PrepPriglasit]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������� �� ����� ��� ������ �� ����� #32
procedure PrepNadvig(Ptr : Integer);
  var egs,sn,sm : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ���
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  egs := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // ���
  sn := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                     // ��
  sm := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                    // ��
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// �
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// �

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
        begin // ������������� ������� ���
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
          begin // �������� �������� �������
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin InsArcNewMsg(Ptr,381+$2000); AddFixMessage(GetShortMsg(1,381,ObjZav[Ptr].Liter),0,6); end;
{$ELSE}
            InsArcNewMsg(Ptr,381+$2000); SingleBeep6 := true;
{$ENDIF}
          end else
          begin // ����� �������� �������
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
          begin // �������� �������� ��������
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin InsArcNewMsg(Ptr,383+$2000); AddFixMessage(GetShortMsg(1,383,ObjZav[Ptr].Liter),0,6); end;
{$ELSE}
            InsArcNewMsg(Ptr,383+$2000); SingleBeep6 := true;
{$ENDIF}
          end else
          begin // ����� �������� ��������
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
  reportf('������ [MainLoop.PrepNadvig]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� �������� ������� ��� ������ �� ����� #38
procedure PrepMarhNadvig(Ptr : Integer);
  var v : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  v := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  if v <> ObjZav[Ptr].bParam[1] then
  begin
    if v then
    begin // ������������� ���������� �������� �������
      SetNadvigParam(ObjZav[Ptr].ObjConstI[10]); // ���������� ������� �� �� ������� �������
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
  reportf('������ [MainLoop.PrepMarhNadvig]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������ � ��� ��� ������ �� ����� #23
procedure PrepMEC(Ptr : Integer);
  var mo,mp,egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  mp := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  mo := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // ��
  egs := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���

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
        begin // ������������� ������� ���
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
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[3];  //���
    end;
  end;
except
  reportf('������ [MainLoop.PrepMEC]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������ � �������� �������� ��� ������ �� ����� #24
procedure PrepZapros(Ptr : Integer);
  var zpp,egs : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ������ ��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ������� ������ �����������
  egs := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                   // ���
  ObjZav[Ptr].bParam[5] := not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  zpp := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                       // ������ ��
  ObjZav[Ptr].bParam[7] := not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // �
  ObjZav[Ptr].bParam[8] := not GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);    // ���
  ObjZav[Ptr].bParam[10] := not GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//��
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  ���
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  ��
  ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //  ��

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

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[10]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[8];  //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[11]; //���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[9];  //���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[7];  //�
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[5];  //��

      if egs <> ObjZav[Ptr].bParam[3] then
      begin
        if egs then
        begin // ������������� ������� ��� ��� ��������� �� ����������� (������ � �������� ����)
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
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[3];  //���

      if zpp <> ObjZav[Ptr].bParam[6] then
      begin
        if zpp then
        begin // ������������� ��������� ������� ��������� ������
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
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[6]; //���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[2]; //����
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[1]; //���
      // �������� ������
      if ObjZav[Ptr].ObjConstI[20] > 0 then
      begin
        OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[3] := ObjZav[Ptr].bParam[12]; //��
        OVBuffer[ObjZav[Ptr].ObjConstI[20]].Param[5] := ObjZav[Ptr].bParam[13]; //��
      end;
    end;

    // FR4
    ObjZav[Ptr].bParam[14] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // ��������� ����������
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[15] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // ���� �����������
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 *8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24] else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // ���� 2 ���� �����������
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
  reportf('������ [MainLoop.PrepZapros]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� ������� (�������) ��� ������ �� ����� #25
procedure PrepManevry(Ptr : Integer);
  var rm,v : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  rm := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                        // ��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ��
  ObjZav[Ptr].bParam[3] := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��
  ObjZav[Ptr].bParam[4] := not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��/�
  v := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);                         // B
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ���
  ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // �����.���.����������
  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     // ���

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
          ObjZav[Ptr].bParam[14] := false; // ����� �������� ������ ������� �� ������
          ObjZav[Ptr].bParam[8] := false; // ����� �������� ������ ������� ��
        end;
        ObjZav[Ptr].bParam[1] := rm;
      end;

      if v <> ObjZav[Ptr].bParam[5] then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = ObjZav[ptr].RU) {$ENDIF} then
        begin
          if v then
          begin // �������� ���������� ��������
            InsArcNewMsg(Ptr,389+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,389,ObjZav[Ptr].Liter),0,6); {$ENDIF}
          end else
          begin // ����� ���������� ��������
            InsArcNewMsg(Ptr,390+$2000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,390,ObjZav[Ptr].Liter),0,6); {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[5] := v;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2]  := ObjZav[Ptr].bParam[5]; //�
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3]  := ObjZav[Ptr].bParam[1]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4]  := ObjZav[Ptr].bParam[2]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5]  := ObjZav[Ptr].bParam[4]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[3]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7]  := ObjZav[Ptr].bParam[7]; //����� ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9]  := ObjZav[Ptr].bParam[6]; //���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[8]; //������ ������� ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[9]; //���
    end;
  end;
except
  reportf('������ [MainLoop.PrepManevry]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ���������� ������� ��� ������ �� ����� #33
procedure PrepSingle(Ptr : Integer);
  var b : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  if ObjZav[Ptr].ObjConstB[1] then // �������� ���������
    b := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31])
  else // ������ ���������
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
      begin // ����������� ��������� ��������� ������� - ����� ��������� ���������
        if b then
        begin
          if ObjZav[Ptr].ObjConstI[2] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then begin
                if ObjZav[Ptr].ObjConstI[4] = 1 then InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[2]) else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2]);
                if ObjZav[Ptr].ObjConstI[4] = 1 then // ��������� �����������
                  AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[2]],4,3)
                else
                begin // ��������� ����������
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
                if ObjZav[Ptr].ObjConstI[5] = 1 then // ��������� �����������
                  AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[3]],4,3)
                else
                begin // ��������� ����������
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
  reportf('������ [MainLoop.PrepSingle]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ������ � ���������� ���������� ������� ������������ #35
procedure PrepInside(Ptr : Integer);
begin
try
  inc(LiveCounter);
  if ObjZav[Ptr].BaseObject > 0 then
  begin
    case ObjZav[Ptr].ObjConstI[1] of
      1 : begin // �
        ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[8] or
          (ObjZav[ObjZav[Ptr].BaseObject].bParam[9] and ObjZav[ObjZav[Ptr].BaseObject].bParam[14]);
      end;
      2 : begin // ��
        ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[6] or
          (ObjZav[ObjZav[Ptr].BaseObject].bParam[7] and ObjZav[ObjZav[Ptr].BaseObject].bParam[14]);
      end;
      3 : begin // �&��
        ObjZav[Ptr].bParam[1] := ObjZav[ObjZav[Ptr].BaseObject].bParam[6] or ObjZav[ObjZav[Ptr].BaseObject].bParam[8] or
          ((ObjZav[ObjZav[Ptr].BaseObject].bParam[7] or ObjZav[ObjZav[Ptr].BaseObject].bParam[9]) and ObjZav[ObjZav[Ptr].BaseObject].bParam[14]);
      end;
    else
      ObjZav[Ptr].bParam[1] := false;
    end;
  end;
except
  reportf('������ [MainLoop.PrepInside]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� �������� �������������� ��� ������ �� ����� #34
procedure PrepPitanie(Ptr : Integer);
  var k1f,k2f,k3f,vf1,vf2,kpp,kpa,szk,ak,k1shvp,k2shvp,knz,knz2,dsn,dn,rsv : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  k1f    := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  k2f    := not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  k3f    := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //
  vf1    := not GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �������� ��������� �������� �� 1 �����
  vf2    := not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �������� ��������� �������� �� 2 �����
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
      begin // ��� ����� ������� (���� �������� �������� �������)
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
      begin // ��� ������� ������� (��� �������� �������� �������)
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
  reportf('������ [MainLoop.PrepPitanie]');
  Application.Terminate;
end;
end;


//------------------------------------------------------------------------------
// ���������� ������(���/����) ��� ������ �� ����� #36
procedure PrepSwitch(Ptr : Integer);
  var b : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  if ObjZav[Ptr].ObjConstB[1] then // �������� ���������
    b := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31])
  else // ������ ���������
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
      begin // ����������� ��������� ��������� ������� - ����� ��������� ���������
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
  reportf('������ [MainLoop.PrepSwitch]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� � ������ �� ����� ����������� ����/���� #37
procedure PrepIKTUMS(Ptr : Integer);
  var r,ao,ar,a,b,p,kp1,kp2,otu,rotu : Boolean; i : integer; myt : byte;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  r  := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //�
  ao := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ar := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ObjZav[Ptr].bParam[4]  := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //��������������
  kp1 := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //��1
  kp2 := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //��2
  ObjZav[Ptr].bParam[7]  := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //�
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //��
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  otu := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  rotu := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //����

  // �������� ��������� ��������� ������ � ���������� �������
  i := ObjZav[Ptr].ObjConstI[8] div 8;
  if i > 0 then
  begin
    myt := FR3[i] and $38;
    if myt = $38 then
    begin // ����������� ��������� ��������
      ObjZav[Ptr].bParam[8] := true; ObjZav[Ptr].bParam[9] := false; ObjZav[Ptr].bParam[10] := false;
    end else
    begin
      ObjZav[Ptr].bParam[8] := false;
      if myt = $28 then
      begin // �������� ���������� �������� ��������
        ObjZav[Ptr].bParam[9] := true; ObjZav[Ptr].bParam[10] := false;
      end else
      begin // ��������� ���������� ��������� ��������
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
      begin // ���������� �������� ������� ������
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
      begin // ���������� ��������� ������� ������
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
      begin // ��������� 1 ��������� ����
        if WorkMode.FixedMsg then
        begin
          a := true;
          if ao then
          begin // ���������� ��������
            InsArcNewMsg(Ptr,366+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,366,ObjZav[Ptr].Liter),4,4); {$ENDIF}
          end else
          begin // ������� ��������
            InsArcNewMsg(Ptr,367+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,367,ObjZav[Ptr].Liter),5,0); {$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := ao;
      if ar <> ObjZav[Ptr].bParam[3] then
      begin // ��������� 2 ��������� ����
        if WorkMode.FixedMsg then
        begin
          b := true;
          if ar then
          begin // ���������� ��������
            InsArcNewMsg(Ptr,368+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,368,ObjZav[Ptr].Liter),4,4); {$ENDIF}
          end else
          begin // ������� ��������
            InsArcNewMsg(Ptr,369+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,369,ObjZav[Ptr].Liter),5,0); {$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := ar;
      if ObjZav[Ptr].ObjConstB[1] then
      begin
        if otu <> ObjZav[Ptr].bParam[13] then
        begin // ��������� ��������� ���������� ���
          if WorkMode.FixedMsg then
          begin
            if otu then
            begin // ���������� ��������� ��� ���������
              InsArcNewMsg(Ptr,500+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,500,ObjZav[Ptr].Liter),4,4); {$ENDIF}
            end else
            begin // ������� ��������� ��� ���������
              InsArcNewMsg(Ptr,501+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,501,ObjZav[Ptr].Liter),5,0); {$ENDIF}
            end;
          end;
        end;
        if rotu <> ObjZav[Ptr].bParam[14] then
        begin // ��������� ��������� ���������� ����
          if WorkMode.FixedMsg then
          begin
            if rotu then
            begin // ���������� ��������� ���� ���������
              InsArcNewMsg(Ptr,502+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,502,ObjZav[Ptr].Liter),4,4); {$ENDIF}
            end else
            begin // ������� ��������� ���� ���������
              InsArcNewMsg(Ptr,503+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,503,ObjZav[Ptr].Liter),5,0); {$ENDIF}
            end;
          end;
        end;
      end;
      ObjZav[Ptr].bParam[14] := rotu;

      if r <> ObjZav[Ptr].bParam[1] then
      begin // ������������ ���������� ����
        if WorkMode.FixedMsg then
        begin
          p := true;
        end;
        ObjZav[Ptr].bParam[1] := r;
      end;
      if p or a or b then
      begin // ������������� ������������ ���������� ����
        if r and not ar then
        begin // ������� ��������� ��������
          InsArcNewMsg(Ptr,365+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,365,ObjZav[Ptr].Liter),5,2); {$ENDIF}
        end else
        if not r and not ao then
        begin // ������� �������� ��������
          InsArcNewMsg(Ptr,364+$3000); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,364,ObjZav[Ptr].Liter),5,2); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[1] := r;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];   // �
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];   // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];   // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];   // ���� (��������������)
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5];   // ��1
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];   // ��2
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7];   // �
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[8];   // �� ����� ���������� ��������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[9];  // �� �������� ��������� ��������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[10]; // �� �������� ��������� ������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[13]; // ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[14]; // ����
    end;
  end;
except
  reportf('������ [MainLoop.PrepIKTUMS]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// �������� ������ ���������� #39
var ops : array[1..3] of Integer;

procedure PrepKRU(Ptr : Integer);
  var group,i : integer; lock : boolean; ps : array[1..3] of Integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  if ObjZav[Ptr].ObjConstI[7] > 0 then
    ObjZav[Ptr].bParam[6] := not GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]) //���
  else
    ObjZav[Ptr].bParam[6] := true;
  group := ObjZav[Ptr].ObjConstI[1];
  if ObjZav[Ptr].ObjConstI[1] < 1 then group := 0;
  if ObjZav[Ptr].ObjConstI[1] > 8 then group := 0;
  // ��������� ��������� ����������
  WorkMode.BU[group] := not ObjZav[Ptr].bParam[31];
  WorkMode.NU[group] := ObjZav[Ptr].bParam[32];
  if ObjZav[Ptr].ObjConstI[2] > 0 then WorkMode.RU[group]  := ObjZav[Ptr].bParam[1];
  if ObjZav[Ptr].ObjConstI[3] > 0 then WorkMode.OU[group]  := ObjZav[Ptr].bParam[2];
  if ObjZav[Ptr].ObjConstI[4] > 0 then WorkMode.SU[group]  := ObjZav[Ptr].bParam[3];
  if ObjZav[Ptr].ObjConstI[5] > 0 then WorkMode.VSU[group] := ObjZav[Ptr].bParam[4];
  if ObjZav[Ptr].ObjConstI[6] > 0 then WorkMode.DU[group]  := ObjZav[Ptr].bParam[5];
  WorkMode.KRU[group] := ObjZav[Ptr].bParam[6];

  if group = 0 then
  begin // ���������� ������� �������� ���������
    lock := false;
    if WorkMode.BU[0] then
    begin
      ObjZav[Ptr].Timers[1].Active := false; lock := true;
    end else
    begin
      if ObjZav[Ptr].Timers[1].Active then
      begin
        if ObjZav[Ptr].Timers[1].First < LastTime then
        begin // ��������� �������� ����� ��������� ������ � ���������
          lock := false; ObjZav[Ptr].Timers[1].Active := false;
        end;
      end else
      begin // ������ ������ �������� ������ ����������� ���������
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
  // ��������� ���������� �������� ��������������� ��������
  ps[1] := 0; ps[2] := 0; ps[3] := 0;
  for i := 1 to WorkMode.LimitObjZav do
    if ObjZav[i].TypeObj = 7 then
    begin
      if ObjZav[i].bParam[1] then inc(ps[ObjZav[i].RU]);
    end;
  // ����� 1
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
  // ����� 2
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
  // ����� 3
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
  reportf('������ [MainLoop.PrepKRU]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ����� ����������� #40
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
  reportf('������ [MainLoop.PrepIzvPoezd]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ����� ������������� ��������� �������� �� ���������� (�� ��� ������� � ����) #42
procedure PrepVP(Ptr : Integer);
  var i,o : integer; z : boolean;
begin
try
  inc(LiveCounter);
  z := ObjZav[ObjZav[Ptr].UpdateObject].bParam[2]; // �������� ��������� ������ � ����
  if ObjZav[Ptr].bParam[3] <> z then
    if z then
    begin // ��������� ���������� ������ � ����
      ObjZav[Ptr].bParam[1] := false; // ����� ������� ��������� ������ �� ����
      ObjZav[Ptr].bParam[2] := false; // ����� ������� ���������� ������������� ��������� ��������
    end;
  ObjZav[Ptr].bParam[3] := z;
  if ObjZav[Ptr].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] and
     ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[3] then
  begin // ���� ������� ��������� ������, ���������, ���������� ��  � ����������� ���������� ������ � ����, � ���������� ������ ������
    z := true;
    for i := 1 to 4 do
    begin // ��������� ������� ��������� �������� ������� � ����
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] then z := false;
      end;
    end;
    if z then
    begin // ��� ������� � ���� ����� �������� �� �����
      o := ObjZav[Ptr].ObjConstI[10];
      if o > 0 then
      begin // �������� ����������� ����������� ���������
        if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] or ObjZav[o].bParam[6] or ObjZav[o].bParam[7] then z := false;
      end;
    end;
    // ���������� ������� ���������� ������������� ��������� �������� �� ���������� �� ����������� ��������
    ObjZav[Ptr].bParam[2] := z;
  end else
    ObjZav[Ptr].bParam[2] := false; // ����� ���������� ������������� ��������� ��������
except
  reportf('������ [MainLoop.PrepVP]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���������� ������� � ���� ��� �������� ����������� #41
procedure PrepVPStrelki(Ptr : Integer);
  var o,p : integer; z : boolean;
begin
try
  inc(LiveCounter);
  o := ObjZav[Ptr].BaseObject;
  if o > 0 then
  begin // ���� �������� ������ � ���� ������ �������� ��� �� �������� �������� ������� - ���������� ������� ��������� �����������
    if ObjZav[o].bParam[3] or ObjZav[o].bParam[4] or ObjZav[o].bParam[8] then ObjZav[Ptr].bParam[20] := true;
  end;

  o := ObjZav[Ptr].UpdateObject; // ������ ������ �������� �����������, ����������� �� �����������
  if o > 0 then
  begin

    z := ObjZav[o].bParam[2]; // �������� ��������� ����������� ������ �������� �����������
    if ObjZav[Ptr].bParam[5] <> z then
      if z then
      begin // ��������� ���������� ����������� ������ �������� �����������
        ObjZav[Ptr].bParam[20] := false; // ����� ������� ��������� �������� �����������
      end;
    ObjZav[Ptr].bParam[5] := z;
    if not (ObjZav[Ptr].bParam[20] or ObjZav[Ptr].bParam[21]) then exit;

    p := ObjZav[Ptr].ObjConstI[1]; // ������ �������� ������� 1
    if p > 0 then
    begin // ���������� ��������� �������� ������� 1
      inc(LiveCounter);
      // ����������� �������� ����� �������� ����������
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[5] = 0) or
           ((ObjZav[Ptr].ObjConstI[5] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[23] := true; // ���������� ��������������� ��������� �������� ������� 1
          if ObjZav[Ptr].ObjConstB[3] then // �������� ������ ���� � �����
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[8] := true;
          end else
          if ObjZav[Ptr].ObjConstB[4] then // �������� ������ ���� � ������
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[8] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[23] := false; // ��� ���������������� ��������� �������� �������
      if not ObjZav[Ptr].bParam[8] then
      begin // ����������� �������� ����� �������� ����������
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

    p := ObjZav[Ptr].ObjConstI[2]; // ������ �������� ������� 2
    if p > 0 then
    begin // ���������� ��������� �������� ������� 2
      inc(LiveCounter);
      // ����������� �������� ����� �������� ����������
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[6] = 0) or
           ((ObjZav[Ptr].ObjConstI[6] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[24] := true; // ���������� ��������������� ��������� �������� ������� 2
          if ObjZav[Ptr].ObjConstB[6] then // �������� ������ ���� � �����
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[9] := true;
          end else
          if ObjZav[Ptr].ObjConstB[7] then // �������� ������ ���� � ������
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[9] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[24] := false; // ��� ���������������� ��������� �������� �������
      if not ObjZav[Ptr].bParam[9] then
      begin // ����������� �������� ����� �������� ����������
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

    p := ObjZav[Ptr].ObjConstI[3]; // ������ �������� ������� 3
    if p > 0 then
    begin // ���������� ��������� �������� ������� 3
      inc(LiveCounter);
      // ����������� �������� ����� �������� ����������
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[7] = 0) or
           ((ObjZav[Ptr].ObjConstI[7] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[25] := true; // ���������� ��������������� ��������� �������� ������� 3
          if ObjZav[Ptr].ObjConstB[9] then // �������� ������ ���� � �����
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[10] := true;
          end else
          if ObjZav[Ptr].ObjConstB[10] then // �������� ������ ���� � ������
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[10] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[25] := false; // ��� ���������������� ��������� �������� �������
      if not ObjZav[Ptr].bParam[10] then
      begin // ����������� �������� ����� �������� ����������
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

    p := ObjZav[Ptr].ObjConstI[4]; // ������ �������� ������� 4
    if p > 0 then
    begin // ���������� ��������� �������� ������� 4
      inc(LiveCounter);
      // ����������� �������� ����� �������� ����������
      if ObjZav[o].bParam[14] then
      begin
        if (ObjZav[Ptr].ObjConstI[8] = 0) or
           ((ObjZav[Ptr].ObjConstI[8] > 0) and (ObjZav[ObjZav[p].BaseObject].bParam[21] and ObjZav[ObjZav[p].BaseObject].bParam[22])) then
        begin
          ObjZav[Ptr].bParam[26] := true; // ���������� ��������������� ��������� �������� ������� 4
          if ObjZav[Ptr].ObjConstB[12] then // �������� ������ ���� � �����
          begin
            if not ObjZav[p].bParam[1] then ObjZav[Ptr].bParam[11] := true;
          end else
          if ObjZav[Ptr].ObjConstB[13] then // �������� ������ ���� � ������
          begin
            if not ObjZav[p].bParam[2] then ObjZav[Ptr].bParam[11] := true;
          end;
        end;
      end else
        ObjZav[Ptr].bParam[26] := false; // ��� ���������������� ��������� �������� �������
      if not ObjZav[Ptr].bParam[11] then
      begin // ����������� �������� ����� �������� ����������
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
  reportf('������ [MainLoop.PrepVPStrelki]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ������ ���� ���������� #45
procedure PrepKNM(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��

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
  reportf('������ [MainLoop.PrepKNM]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ������ ���������� ���� �� ����������� ������ #43
procedure PrepOPI(Ptr : Integer);
  var k,o,p,j : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���

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
        begin // �� �������� �������
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2];
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
        end else
        begin // ������� ��������
          if ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin // ���� ��� � ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[2] then
          begin // ���� ��� ��� ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin // ���� ��� ��� ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin // ��� ��� � ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end;
        end;
      end;
    end;
  end;
  o := ObjZav[Ptr].BaseObject;
  if (o > 0) and not (ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2]) then
  begin // ��������������� ����� �� ���� �� ����������� ������
    inc(LiveCounter);
    if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
    o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 50;
    while j > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // �������
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
        48 : begin // ���
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
  reportf('������ [MainLoop.PrepOPI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ������ ��������� ���������� ������� ����������� ������
procedure PrepSOPI(Ptr : Integer);
  var o,p,j : integer;
begin
try
  if ObjZav[Ptr].UpdateObject = 0 then exit;
  inc(LiveCounter);

  o := ObjZav[Ptr].BaseObject;
  if (o > 0) and
     ObjZav[o].bParam[1] and not ObjZav[o].bParam[4] and ObjZav[o].bParam[5] and not ObjZav[Ptr].bParam[2] and // ���������� ����� �������
     (MarhTracert[1].Rod = MarshP) and not ObjZav[ObjZav[Ptr].UpdateObject].bParam[8] then // ���� ������������ � �������� ��������
  begin
    // ���������� ���������� ������� ����������� ������
    if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
    o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 100;
    while j > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // �������
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
        48 : begin // ���
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
  reportf('������ [MainLoop.PrepSOPI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��� #44
procedure PrepSMI(Ptr : Integer);
begin
try
{  o := ObjZav[Ptr].UpdateObject; // ������ ������� ����������� ������
  if not ObjZav[ObjZav[o].BaseObject].bParam[5] then
    ObjZav[ObjZav[o].BaseObject].bParam[5] := ObjZav[Ptr].bParam[5];
  if not ObjZav[ObjZav[o].BaseObject].bParam[8] then
    ObjZav[ObjZav[o].BaseObject].bParam[8] := ObjZav[Ptr].bParam[8];}
except
  reportf('������ [MainLoop.PrepSMI]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ��� #48
procedure PrepRPO(Ptr : Integer);
begin
try
//  if ObjZav[Ptr].BaseObject > 0 then
//  begin
//
//  end;
except
  reportf('������ [MainLoop.PrepRPO]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� "�������� � �������������" #46
procedure PrepAutoSvetofor(Ptr : Integer);
{$IFDEF RMDSP}   var i,o : integer; {$ENDIF}
begin
{$IFDEF RMDSP}
try
  inc(LiveCounter);
  if not ObjZav[Ptr].bParam[1] then exit; // ��������� ������������ �������
  if not (WorkMode.Upravlenie and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group]) then
  begin // ��� ������������ ���  ������ ��������� ���������� � ��-���
    exit;
  end else
  if not WorkMode.CmdReady and not WorkMode.LockCmd then
  begin
    // ������ ������ ?
    if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
    begin ObjZav[Ptr].Timers[1].Active := false; ObjZav[Ptr].bParam[2] := false; exit; end;
    // ��������� ������� ��������� ��������� �������
    for i := 1 to 10 do
    begin
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] then begin  ObjZav[Ptr].bParam[2] := false; exit; end;
      end;
    end;
    // ��������� ������� ����� ��������� �������
    if ObjZav[Ptr].Timers[1].Active then
    begin
      if ObjZav[Ptr].Timers[1].First > LastTime then exit;
    end;

    // ��������� ����������� ������ ������� �������� �������
    if CheckAutoMarsh(Ptr,ObjZav[Ptr].ObjConstI[25]) then
    begin
      inc(LiveCounter);
      if SendCommandToSrv(ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[5] div 8,cmdfr3_svotkrauto,ObjZav[Ptr].BaseObject) then
      begin // ������ ������� �� ����������
        if SetProgramZamykanie(ObjZav[Ptr].ObjConstI[25]) then
        begin
          if OperatorDirect > LastTime then // �������� ���-�� ������ - ��������� 15 ������ �� ��������� ������� ������ ������� �������� ������� �������������
            ObjZav[Ptr].Timers[1].First := LastTime + IntervalAutoMarsh / 86400
          else // �������� ������ �� ������ - ��������� 5 ������ � ������ ��������� �������
            ObjZav[Ptr].Timers[1].First := LastTime + 10 / 86400;
          ObjZav[Ptr].Timers[1].Active := true;
//          AddFixMessage(GetShortMsg(1,423,ObjZav[ObjZav[Ptr].BaseObject].Liter),5,1);
          SingleBeep5 := WorkMode.Upravlenie;
        end;
      end;
    end;
  end;
except
  reportf('������ [MainLoop.PrepAutoSvetofor]');
  Application.Terminate;
end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// ���������� ������� "��������� ������������ ��������" #47
procedure PrepAutoMarshrut(Ptr : Integer);
{$IFDEF RMDSP}   var i,j,o,p,q : integer; {$ENDIF}
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // ����������� ������������
    if not ObjZav[Ptr].bParam[1] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // �������� ������������
      end;
    end;
  end;
{$IFDEF RMDSP}
  inc(LiveCounter);
  if not ObjZav[Ptr].bParam[1] then exit;
  if not (WorkMode.Upravlenie and WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group]) then
  begin // ����� ������������ ���  ������ ��������� ���������� � ��-���
    ObjZav[Ptr].bParam[1] := false;
    for q := 10 to 12 do
      if ObjZav[Ptr].ObjConstI[q] > 0 then
      begin
        ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
        AutoMarshOFF(ObjZav[Ptr].ObjConstI[q]);
      end;
  end else
  // ��������� ������� ��������� ������ ������������ ������������
  for i := 10 to 12 do
  begin
    o := ObjZav[Ptr].ObjConstI[i];
    if o > 0 then
    begin // ����������� ��� ������� ������������
      if ObjZav[ObjZav[o].BaseObject].bParam[23] then
      begin // ������������� ���������� �������
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
          begin // ������������� ������ �������� ������� ��� ��������������
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
  reportf('������ [MainLoop.PrepAutoMarshrut]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� ���� #49
procedure PrepABTC(Ptr : Integer);
  var gpo,ak,kl,pkl,rkl : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  gpo := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  ObjZav[Ptr].bParam[2]  := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  ObjZav[Ptr].bParam[3]  := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ak  := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  kl  := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  pkl := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  rkl := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

    if gpo <> ObjZav[Ptr].bParam[1] then
      if gpo then
      begin // ������������� ����������
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
      begin // ������������� �����������
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
      begin // ������������� �����
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
      begin // ������������� ����� �������� ������
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
      begin // ������������� ����� �������� ������
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

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // ���
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // ���
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; // ��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; // ��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5]; // ��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6]; // ���
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7]; // ���
  end;

except
  reportf('������ [MainLoop.PrepABTC]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ���������� ������� �������� ���������� ����� #50
procedure PrepDCSU(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1]  := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //1��
  ObjZav[Ptr].bParam[2]  := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //1��
  ObjZav[Ptr].bParam[3]  := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //2��
  ObjZav[Ptr].bParam[4]  := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //2��
  ObjZav[Ptr].bParam[5]  := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //3��
  ObjZav[Ptr].bParam[6]  := GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //3��
  ObjZav[Ptr].bParam[7]  := GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //4��
  ObjZav[Ptr].bParam[8]  := GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //4��
  ObjZav[Ptr].bParam[9]  := GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //5��
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //5��
  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //6��
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //6��
  ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //7��
  ObjZav[Ptr].bParam[14] := GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //7��
  ObjZav[Ptr].bParam[15] := GetFR3(ObjZav[Ptr].ObjConstI[15],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //8��
  ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[16],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //8��

  // ��������� � ����� �����������
  if ObjZav[Ptr].BaseObject > 0 then
  begin
    if ObjZav[ObjZav[Ptr].BaseObject].bParam[31] and not ObjZav[ObjZav[Ptr].BaseObject].bParam[32] then
    begin
      ObjZav[Ptr].bParam[17] := not ObjZav[ObjZav[Ptr].BaseObject].bParam[4];
      ObjZav[Ptr].bParam[18] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4];
    end else
    begin // ���������� ��������� ����������� �� ��������
      ObjZav[Ptr].bParam[17] := false;
      ObjZav[Ptr].bParam[18] := false;
    end;
  end;

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; // 1��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; // 1��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; // 2��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; // 2��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5]; // 3��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6]; // 3��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7]; // 4��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[8]; // 4��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[9]; // 5��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[10]; // 5��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[11]; // 6��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[12]; // 6��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[13]; // 7��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := ObjZav[Ptr].bParam[14]; // 7��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[15]; // 8��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := ObjZav[Ptr].bParam[16]; // 8��

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[19] := ObjZav[Ptr].bParam[17]; // �����
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[20] := ObjZav[Ptr].bParam[18]; // �����������
  end;

except
  reportf('������ [MainLoop.PrepDCSU]');
  Application.Terminate;
end;
end;

//-------------------------------------------------------------------------------
// ������ �������������� �������� #51
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
  reportf('������ [MainLoop.PrepDopDat]');
  Application.Terminate;
end;
end;

//------------------------------------------------------------------------------
// ������ ����������� ��� ��� ��������� �� ���������� �������� #52
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
    begin // �������� �������, ���� ��, �, �
    // ��������� ��������������� ������� ��� ������ �� ������ ������ ������ ���
      if ObjZav[Ptr].ObjConstB[1] then p := 2 else p := 1;
      o := ObjZav[Ptr].Neighbour[p].Obj; p := ObjZav[Ptr].Neighbour[p].Pin; j := 50;
      while j > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 : begin // �������
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
          53 : begin // �����
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
  reportf('������ [MainLoop.PrepOPI]'); Application.Terminate;
end;
end;

end.
