unit MainLoop;
//------------------------------------------------------------------------------
//          ���� ������� ������������ ��-���, ���-��, �������� ������
//------------------------------------------------------------------------------
{$INCLUDE d:\Sapr2012\CfgProject}

interface

uses
  SysUtils,
  Windows,
  Dialogs,
  Forms,
  DateUtils;

procedure SetDateTimeARM(index : SmallInt);
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
procedure PrepareOZ;
procedure PrepareOZ1(Ptr : Integer);
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
procedure PrepUKSPS(Ptr : Integer); //--------------- �������� ����� ���������� ������� 14 
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
procedure PrepVPStrelki(VPSTR : Integer);
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
procedure PrepST(Ptr : Integer);
procedure PrepDN(Ptr : Integer);
procedure PrepDopSvet(Ptr : Integer);
procedure PrepUKG(Ptr : Integer); //---------------------------------------------- ���(56)

const
  DiagUVK : SmallInt      = 1; //5120 ����� ��������� � ������������� ���
  DateTimeSync : Word = 1; //6144 ����� ��������� ��� ������������� ������� �������
{$IFDEF RMSHN}
  StatStP                 = 5; // ���������� ��������� ��� ���������� ������� ������������ �������� �������
{$ENDIF}


implementation

uses
  Marshrut,
  Commands,
{$IFDEF RMDSP}
  //PipeProc,
  KanalArmSrv,
{$ENDIF}

{$IFDEF RMSHN}
  KanalArmSrvSHN,
  ValueList,
  TabloSHN,
{$ENDIF}

{$IFDEF RMDSP}
  TabloForm,
{$ENDIF}

{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

  Commons,
  TypeALL;
var
  s  : string;
  dt : string;
  LiveCounter : integer;

procedure SetDateTimeARM(index : SmallInt);
{$IFNDEF RMARC}
  var
    uts,lt : TSystemTime;
    nd,nt : TDateTime;
    ndt,cdt,delta : Double;
    time64 : int64;
    Hr,Mn,Sc,Yr,Mt,Dy : Word;
    err : boolean;
    i : integer;
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
      err := true; InsArcNewMsg(0,507,1);
      AddFixMessage(GetShortMsg(1,507,'',1) + '������� ��������� ������� '+ IntToStr(Hr)+':'+ IntToStr(Mn)+':'+ IntToStr(Sc),4,1);
    end;
    if not TryEncodeDate(Yr,Mt,Dy,nd) then
    begin
      err := true; InsArcNewMsg(0,507,1);
      AddFixMessage(GetShortMsg(1,507,'',1) + '������� ��������� ���� '+ IntToStr(Yr)+'-'+ IntToStr(Mt)+'-'+ IntToStr(Dy),4,1);
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
        if ObjZav[i].Timers[1].Active then
        ObjZav[i].Timers[1].First := ObjZav[i].Timers[1].First - delta;

        if ObjZav[i].Timers[2].Active then
        ObjZav[i].Timers[2].First := ObjZav[i].Timers[2].First - delta;

        if ObjZav[i].Timers[3].Active then
        ObjZav[i].Timers[3].First := ObjZav[i].Timers[3].First - delta;

        if ObjZav[i].Timers[4].Active then
        ObjZav[i].Timers[4].First := ObjZav[i].Timers[4].First - delta;

        if ObjZav[i].Timers[5].Active then
        ObjZav[i].Timers[5].First := ObjZav[i].Timers[5].First - delta;
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
//========================================================================================
//----------------------------------------------------------- ������ �� ������ �����������
procedure GoOVBuffer(Ptr,Steps : Integer);
var
  LastStep, cPtr : integer;
begin
  try
    LastStep := Steps;
    cPtr := Ptr;
    while LastStep > 0 do  StepOVBuffer(cPtr,LastStep);
  except
    {$IFNDEF RMARC}
    reportf('������ [MainLoop.GoOVBuffer]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------------------ ������� ��� �� ������ �����������
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
var
  oPtr : integer;
begin
  try
    oPtr := Ptr;
    case OVBuffer[Ptr].TypeRec of
      0 : Ptr := OVBuffer[Ptr].Jmp1;//----------------------- ��������� � ����������� ����

      1 :
      begin //----------------------------------------------- ���������� ����� �����������
        OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param;
        Ptr := OVBuffer[Ptr].Jmp1;
      end;

      2 :
      begin //---------------------------------------------- ����������� ����� �����������
        if OVBuffer[Ptr].StepOver then
        begin
          OVBuffer[OVBuffer[Ptr].Jmp2].Param := OVBuffer[Ptr].Param;
          Ptr := OVBuffer[Ptr].Jmp2
        end else
        begin
          OVBuffer[OVBuffer[Ptr].Jmp1].Param := OVBuffer[Ptr].Param;
          Ptr := OVBuffer[Ptr].Jmp1;
        end;
      end;

      3 :
      begin //-------------------------------------------------------------------- �������
        if OVBuffer[Ptr].StepOver then //--------------- ������ ������ ����� ��� ������ BV
        begin
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //++++++++++++ ������ ������, ����������� ���������� ��� ��������� ����� �������
          Ptr := OVBuffer[Ptr].Jmp2;
          OVBuffer[Ptr].Param[1] := OVBuffer[oPtr].Param[1];  //------------- ������������
          OVBuffer[Ptr].Param[11] := OVBuffer[oPtr].Param[11]; //
          OVBuffer[Ptr].Param[16] := OVBuffer[oPtr].Param[16]; //-------------- ����������

          //+++++++++++ ��� ����� � ������ �����, ���� ������� � ����� +++++++++++++++++++
          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then   //------------- �� �� �������
          begin
            if ObjZav[OVBuffer[oPtr].DZ1].bParam[1] then  //-------------- ���� �� �������
            begin
              if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] //���� ����.���.
              then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] //����� ���������� ��
              else OVBuffer[Ptr].Param[2] := false; //--------- ����� ������ ���������� ��
              OVBuffer[Ptr].Param[4] := true; //------------------- ������ ��������� �����
              OVBuffer[Ptr].Param[8] := true; //----------------------- ������ ��� � �����
            end else
            begin  //---------------------------------- ��� �� � �� (������� ��� ��������)
              OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //------ ����� ������� ��
              OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //------- ����� ���������
              OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //------------- ����� ���
            end;

            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24]//--- ������� �� ��
            then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3]//���������� �������� ��
            else OVBuffer[Ptr].Param[3] := true; //--------------------- ����� �������� ��

            OVBuffer[Ptr].Param[5] := true; //------------- ����� ���������� ��������� "�"
            OVBuffer[Ptr].Param[7] := false; //-------------------------------- ����� "��"
            OVBuffer[Ptr].Param[10] := false; //------------------------- ������ ���������
          end else
          begin //------------------------- ��� ����� � ������ �����, ���� ���� �� �������
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //---------- ����������� ��
            OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3]; //---------- ����������� ��
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //--- ����������� ���������

//            if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then  //------------------ ���� ��
//            begin
            OVBuffer[Ptr].Param[5] :=OVBuffer[oPtr].Param[5];//���������� ���������� "�"
            OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7]; //------- ���������� "��"
//            end else
//            begin
//             OVBuffer[Ptr].Param[5] := true;   //----------------------------- ������ "�"
//              OVBuffer[Ptr].Param[7] := false; //----------------------------- ������ "��"
//            end;

            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //---------- ���������� ���
            OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //-- ���������� ���������
          end;

//          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then //------------------ ���� �� ��
//          OVBuffer[Ptr].Param[10] := false; //--------------------------- ������ ���������

          if ObjZav[OVBuffer[oPtr].DZ1].bParam[7] or //-���� ������� ���������� �� ��� ...
          (ObjZav[OVBuffer[oPtr].DZ1].bParam[10] and //----- ������ ������ �� ������ � ...
          ObjZav[OVBuffer[oPtr].DZ1].bParam[11]) or //---- ������ ������ �� ������ ��� ...
          ObjZav[OVBuffer[oPtr].DZ1].bParam[13] then //--------------- ���������� � ������
          begin
            OVBuffer[Ptr].Param[6] := OVBuffer[oPtr].Param[6]; //--����������� �����������
          end else
          begin
            OVBuffer[Ptr].Param[6] := true; //------------------- ����� ������ �����������
            OVBuffer[Ptr].Param[14] := false; //------------- ������ ����������� ���������
          end;
        end else //------------------ ������ ������, ����������� ���������� �������� �����
        begin
          Ptr := OVBuffer[Ptr].Jmp1;
          OVBuffer[Ptr].Param[1] := OVBuffer[oPtr].Param[1];   //---- ����� ��������������
          OVBuffer[Ptr].Param[11] := OVBuffer[oPtr].Param[11]; //---- ????????????????????
          OVBuffer[Ptr].Param[16] := OVBuffer[oPtr].Param[16]; //-------- ����� ����������

          //+++++++++++ ��� ����� � ������ �����, ���� ������� � ������ ++++++++++++++++++
          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[1] then //----------------- ���� ��� ��
          begin
            if ObjZav[OVBuffer[oPtr].DZ1].bParam[2] then //------------------ ���� ���� ��
            begin
              if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24] // ������� �� ��
              then OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2] //----- ���������� ��
              else OVBuffer[Ptr].Param[2] := false; //-------------------- ����� �� ������

              OVBuffer[Ptr].Param[4] := true; //------------------------- ������ ���������
              OVBuffer[Ptr].Param[8] := true; //------------------------------- ������ ���
            end else
            begin //------------------------------------- ��,�� ��� (������� ��� ��������)
              OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //-------------- ����� ��
              OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //------- ����� ���������
              OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //------------- ����� ���
            end;
            if ObjZav[ObjZav[OVBuffer[oPtr].DZ1].BaseObject].bParam[24]//--------- ���� ��
            then OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3] //------- ���������� ��
            else OVBuffer[Ptr].Param[3] := true; //------------------------- ���������� ��

            OVBuffer[Ptr].Param[5] := true; //--------------------------------- ������ "�"
            OVBuffer[Ptr].Param[7] := false; //------------------------------- ������ "��"
            OVBuffer[Ptr].Param[10] := false; //------------------------- ������ ���������
          end else
          begin //--------------------------------------------- ����� ����� ��� ������� ��
            OVBuffer[Ptr].Param[2] := OVBuffer[oPtr].Param[2]; //------------- �������� ��
            OVBuffer[Ptr].Param[3] := OVBuffer[oPtr].Param[3]; //------------- �������� ��
            OVBuffer[Ptr].Param[4] := OVBuffer[oPtr].Param[4]; //------ �������� ���������
//            if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then //------------------- ���� ��
//            begin
              OVBuffer[Ptr].Param[5] := OVBuffer[oPtr].Param[5];  //------------ ����� "�"
              OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7];  //----------- ����� "��"
//            end else
//            begin
//              OVBuffer[Ptr].Param[5] := true; //----------------------- ����� �������� "�"
//              OVBuffer[Ptr].Param[7] := false; //--------------------------- �������� "��"
//            end;
            OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];   //------------- ����� ���
            OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //------- ����� ���������
          end;

          //--------------------------------------------- �� �������� �� ��������� �������
//          if not ObjZav[OVBuffer[oPtr].DZ1].bParam[3] then //---------------- ���� �� "��"
//          OVBuffer[Ptr].Param[10] := false;

          if ObjZav[OVBuffer[oPtr].DZ1].bParam[6] or // ���� ������� ���������� �� ��� ...
          (ObjZav[OVBuffer[oPtr].DZ1].bParam[10] and //--- ������ ������ ����������� � ...
          not ObjZav[OVBuffer[oPtr].DZ1].bParam[11]) or //�� ������ ������ ����������� ���
          ObjZav[OVBuffer[oPtr].DZ1].bParam[12] then //---- ���������� � ����� �� ��������
          begin
            OVBuffer[Ptr].Param[6] := OVBuffer[oPtr].Param[6]; //----------- ���������� ��
          end else
          begin
            OVBuffer[Ptr].Param[6] := true;
            OVBuffer[Ptr].Param[14] := false; //----------- �������� ����������� ���������
          end;
        end;
      end;
    end;

    if Ptr = 0 then Step := 0 else dec(Step);
    OVBuffer[oPtr].StepOver := true;
    result := true;
  except
    {$IFNDEF RMARC}
    reportf('������ [MainLoop.StepOVBuffer]');
    {$ENDIF}
    result := false;
    Application.Terminate;
  end;
end;
//========================================================================================
//-------- ��������� � ����� ������� �������� ������������ ��������� (����� ��� ���������)
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
  {$IFNDEF RMARC}
  reportf('������ [MainLoop.SetPrgZamykFromXStrelka]');
  {$ENDIF}
  Application.Terminate;
end;
end;
//========================================================================================
//---------------------------------- ��������� ����������� � �������������� ���������� ���
procedure DiagnozUVK(Index : SmallInt);
var
  u,m,p,o,z,c : cardinal;
  t : boolean;
  msg,ii : Integer;
begin
  try
    c := FR7[Index];

    if NenormUVK[Index] <> c then
    begin
      if c > 0 then
      begin
        u := c and $f0000000; u := u shr 28;  //-------------------- �������� ����� ������
        m := c and $0c000000; m := m shr 26;  //--------------- �������� ����� �����������
        p := c and $03c00000; p := p shr 22;  //----------------------- �������� ��� �����
        t := (c and $02000000) = $02000000;   //--------- ��� ����� (�201-true/�203-false)
        o := c and $003f0000; o := o shr 16;  //----------------- �������� �������� ������
        z := c and $0000ffff;                 //------------------------ �������� ��������

        if (u > 0) and (p > 0) and (o > 0) then
        begin
          s := '���'+ IntToStr(u)+ ' ����'+ IntToStr(m);
          if t then s := s + ' �201'
          else s := s + ' �203';
          s := s + '.' + IntToStr(p and $7);
          case o of
            1 : begin s := s + ' ����������� ����� '; msg := 3003; end;
            2 : begin s := s + ' ����� ����� '; msg := 3004; end;
            3 : begin s := s + ' ���������� "0" '; msg := 3005; end;
            4 : begin s := s + ' ���������� "1" '; msg := 3006; end;
            else   s := s + ' ��� ������: '; msg := 3007;
          end;
          s := s + '['+ IntToHEX(z,4)+']';
          AddFixMessage('��������� ����������� '+ s,4,4);

          DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
          s := dt + ' > '+ s;
          ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
          NewNeisprav := true; SingleBeep4 := true;
          InsArcNewMsg(z,msg,1);
        end else
        begin //------------------------------------------------- �������������� ���������
          InsArcNewMsg(0,508,1);
          AddFixMessage(GetShortMsg(1,508,'',1),4,4);
        end;
        FR7[Index] := 0; // �������� ������������ ���������
      end;
    end else
    begin
      for ii := 2 to 21 do
      begin
        if NenormUVK[ii] = FR7[ii] then continue
        else NenormUVK[ii] := FR7[ii];
        c := FR7[ii];

        if c > 0 then
        begin
          s := '���������� ������ ';
          if ii < 10 then
          begin
            s := s + NameGrup[ii];
            if c = 1 then s := s +'1'
            else s := s + '2';
          end else
          begin
            if ii >= 21 then continue;
            if c = 1 then s := s + NameO1[ii-9]
            else s := s + NameO2[ii-9];
          end;
          AddFixMessage('��������� ����������� '+ s,4,4);
          DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
          s := dt + ' > '+ s;
          ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
          NewNeisprav := true; SingleBeep4 := true;
          z := ii shl 8;
          z := z or c;
          InsArcNewMsg(z,3008,1);
        end;
        
      end;
    end;
  except
    {$IFNDEF RMARC}
    reportf('������ [MainLoop.DiagnozUVK]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------------------ �������� �� �� ���������� �������
function GetState_Manevry_D(Ptr : SmallInt) : Boolean;
begin
try
  // ���������� ��������� ��&��
  // ������� ���������� �������� (��� ����� ������� ������ ���������� �������� �� �������)
  result := ObjZav[Ptr].bParam[1] and //-------------------- ��������� ����� �� � �� ��(�)
  not ObjZav[Ptr].bParam[4];
except
  {$IFNDEF RMARC}
  reportf('������ [MainLoop.GetState_Manevry_D]');
  {$ENDIF}
  result := false;
  Application.Terminate;
end;
end;
//========================================================================================
//---------------------------------------- ���������� �������� ������������ ��� ����������
procedure PrepareOZ;
var
  c,Ptr,ii,k,l,jj : integer;
  s : string;
  st : byte;
  i,j,cfp  : integer;
  fix,fp,fn : Boolean;

begin
  try
    c := 0; k := 1;
    SetDateTimeARM(DateTimeSync);  //------------ ���������� ������� ������������� �������

    if DiagnozON then DiagnozUVK(DiagUVK);//-- ���������� ����������� � �������������� ���
    if NewFr6 <> OldFr6 then
    begin
      if NewFr6 > 0 then
      begin
        s :=  '���������� ������ ';
        ii :=  NewFr6 and $FF;

        for l := 0 to 7 do
        begin
          k := 1 shl l;
          c :=  ii and k;
          case c of
            0 : k := 8;
            1 : k := 0;
            2 : k := 1;
            4 : k := 2;
            8 : k := 3;
            16 : k := 4;
            32 : k := 5;
            64 : k := 6;
            128 : k := 7;
          end;
          if k > 7 then continue;

          if NewFr6 > 0 then
          begin
            jj := (NewFr6 shr 8)*8 + k;
            s := s + LinkFr[jj].Name + ';';
            InsArcNewMsg(jj,$3010,1);
          end;
        end;

        OldFr6 := NewFr6;
        AddFixMessage('��������� ����������� '+ s,4,4);
        DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
        s := dt + ' > '+ s;
        ListDiagnoz := s + #13#10 + ListDiagnoz;
        NewNeisprav := true;
        SingleBeep4 := true;
        OldFr6 := NewFr6;
      end;
    end;

    // WaitForSingleObject(hWaitKanal,ChTO);

{$IFNDEF RMARC}
    //---------------------------------------------------------- ���������� ������ FR3,FR4
    if DiagnozON and WorkMode.FixedMsg then
    begin //------------------------ ��������� �������� �������������� ������� �����������
      for Ptr := 1 to FR_LIMIT do
      begin
        if (Ptr <> WorkMode.DirectStateSoob) and (Ptr <> WorkMode.ServerStateSoob) then
        begin
          st := byte(FR3inp[Ptr]);
          if (st and $20) <> (FR3[Ptr] and $20) then // ��������� ��������� ��������������
          begin
            if (Ptr <> MYT[1]) and (Ptr <> MYT[2]) and (Ptr <> MYT[3]) and (Ptr <> MYT[4])
            and (Ptr <> MYT[5]) and (Ptr <> MYT[6]) and (Ptr <> MYT[7]) and (Ptr<> MYT[8])
            and (Ptr <> MYT[9]) then
            begin //--------------- ���� ������� ������ �� ��������� � ����� - �����������
              if ((st and $20) <> $20)
              then
              begin
                InsArcNewMsg(Ptr,$3002,7); //"��������.�������������� �������� ����������"
                FR6[Ptr]:=0;
                NewFR6 :=0;
                OldFr6 := 0;
              end
              else InsArcNewMsg(Ptr,$3001,1);//"������.������������� �������� ����������"
            end;
          end;
          FR3[Ptr] := st;
        end;
        if FR4inp[Ptr] > char(0) then
        FR4s[Ptr] := LastTime;
        //if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4s[Ptr] := byte(FR4inp[Ptr])
        //else FR4s[Ptr] := 0;
      end;
    end else
    begin //---------- ���� ����������� �� �����������, �� ������ ���������� ������� �����
{$ENDIF}
      for Ptr := 1 to FR_LIMIT do
      begin
{$IFNDEF RMARC} FR3[Ptr] := byte(FR3inp[Ptr]); {$ENDIF}
        //if (LastTime - FR4s[Ptr]) < MaxTimeOutRecave then FR4s[Ptr] := byte(FR4inp[Ptr])
        //else FR4s[Ptr] := 0;
      end;
{$IFNDEF RMARC}
    end;
    //WaitForSingleObject(hWaitKanal,ChTO);//+++++++++++++++++++++++++++++++++++++++++++++
    //------------------------------------------------------------ �������� ���������� FR5
    if LastTime > LastDiagD then begin LastDiagN := 0; LastDiagI := 0; end;
{$ENDIF}

    //----------------------------------------- ���������� �������� ��������� ����� ������
    for Ptr := 1 to WorkMode.LimitObjZav do
    begin
      for ii := 1 to 32 do OVBuffer[ObjZav[ptr].VBufferIndex].Param[ii] := false;

      case ObjZav[Ptr].TypeObj of
        1 :  //--------------------------------------------------- � ������ ������ �������
        begin
          ObjZav[Ptr].bParam[5] := false; //---------- �����  ���������� �������� ��������
          ObjZav[Ptr].bParam[8] := false; //----- ����� ������� �������� �������� ��������
          ObjZav[Ptr].bParam[10] := false;//����� ����(��������� ������� � + ��� ��������)
          ObjZav[Ptr].bParam[11] := false;//����� ����(��������� ������� � - ��� ��������)
        end;

        27 : //----------------------------- ��������� ������� �������������� ������������
        begin
          ObjZav[Ptr].bParam[5] := false; //----------- ����� ���������� �������� ��������
          ObjZav[Ptr].bParam[8] := false; //----- ����� ������� �������� �������� ��������
        end;

        41 : //------------------------------------------ ������ ���������� ������� � ����
        begin
          ObjZav[Ptr].bParam[1] := false; //---------- ����� ������� �������� 1-�� �������
          ObjZav[Ptr].bParam[2] := false; //---------- ����� ������� �������� 2-�� �������
          ObjZav[Ptr].bParam[3] := false; //---------- ����� ������� �������� 3-�� �������
          ObjZav[Ptr].bParam[4] := false; //---------- ����� ������� �������� 4-�� �������
          ObjZav[Ptr].bParam[8] := false; //--------- ����� ������� �������� �������� 1-��
          ObjZav[Ptr].bParam[9] := false; //--------- ����� ������� �������� �������� 2-��
          ObjZav[Ptr].bParam[10] := false;//--------- ����� ������� �������� �������� 3-��
          ObjZav[Ptr].bParam[11] := false;//--------- ����� ������� �������� �������� 4-��
        end;

        44 : //------------------------------------------- ���������� ������� ��� ��������
        begin
          ObjZav[Ptr].bParam[1] := false; //------------  ����� ���������� �������� � ����
          ObjZav[Ptr].bParam[2] := false; //------------ ����� ���������� �������� � �����
          ObjZav[Ptr].bParam[5] := false; //----------- ����� ���������� �������� ��������
          ObjZav[Ptr].bParam[8] := true; //--------- ���������� �������� �������� ��������
        end;

        48 : ObjZav[Ptr].bParam[1] := false; //��� ---- ����� ���������� �������� � ������
      end;
    end;
    //WaitForSingleObject(hWaitKanal,ChTO);

    //---------------------------------------------------- ���������� ����������� �� �����
    for Ptr := 1 to WorkMode.LimitObjZav do
    begin
      case ObjZav[Ptr].TypeObj of
  //    1 : ------------------------------------------- ����� ������� �������������� �����
  //    2 : ------------------------------------------------- ������� �������������� �����
        3  : PrepSekciya(Ptr);//--------------------------------------------------- ������
        4  : PrepPuti(Ptr); //------------------------------------------------------- ����
        6  : PrepPTO(Ptr);       //--------------------------------------- ���������� ����
        7  : PrepPriglasit(Ptr); //-------------------------------- ��������������� ������
        8  : PrepUTS(Ptr);  //
        9  : PrepRZS(Ptr);  //----------------------------------- ������ ��������� �������
        10 : PrepUPer(Ptr); //--------------------------------------- ���������� ���������
        11 : PrepKPer(Ptr); //----------------------------------- �������� �������� (���1)
        12 : PrepK2Per(Ptr);//----------------------------------- �������� �������� (���2)
        13 : PrepOM(Ptr);
        14 : PrepUKSPS(Ptr); //------------------------- �������� ����� ���������� �������
        15 : PrepAB(Ptr);
        16 : PrepVSNAB(Ptr);
        17 : PrepMagStr(Ptr);//------------------------------------- ���������� ����������
        18 : PrepMagMakS(Ptr);
        19 : PrepAPStr(Ptr);
        20 : PrepMaket(Ptr);
        21 : PrepOtmen(Ptr);
        22 : PrepGRI(Ptr);
        23 : PrepMEC(Ptr);
        24 : PrepZapros(Ptr);
        25 : PrepManevry(Ptr);
        26 : PrepPAB(Ptr);
//      27 : ---------------------------------------- �� ��� ������� �������������� ������
//      28 : PrepPI(Ptr) ---------------------------- �� ������� ��������������� ���������
//      29 : ------------------------------ �� ��� �� �� ������� ��������������� ���������
        30 : PrepDSPP(Ptr); //------------------------------ ������� ���� ��������� ������
        31 : PrepPSvetofor(Ptr); //--------------------------------- ����������� ���������
        32 : PrepNadvig(Ptr);
        33 : PrepSingle(Ptr);     //---------------------------- ������ - ��������� ������
        34 : PrepPitanie(Ptr);
        35 : PrepInside(Ptr);
        36 : PrepSwitch(Ptr);      //------------------------ ������ - ������ + 5 ��������
        37 : PrepIKTUMS(Ptr);       //------------ ������ - �������������� ���������� ����
        38 : PrepMarhNadvig(Ptr);
        39 : PrepKRU(Ptr);
        40 : PrepIzvPoezd(Ptr);
//      41 : ----------------------------------------- ������� � ���� �������������� �����
        42 : PrepVP(Ptr);
        43 : PrepOPI(Ptr);
        45 : PrepKNM(Ptr); //------------------- ���������� ������� ������ ���� ����������
        46 : PrepAutoSvetofor(Ptr);
        48 : PrepRPO(Ptr);
        49 : PrepABTC(Ptr);
        50 : PrepDCSU(Ptr);
        51 : PrepDopDat(Ptr);
        52 : PrepSVMUS(Ptr);
//      53 : ---------------------- ������ ������ ��� �� ������� ��������������� ���������
        54 : PrepST(Ptr);
        55 : PrepDopSvet(Ptr);
        56 : PrepUKG(Ptr); //---------------------- ������ "���������� �������� ���������"
        92 :PrepDN(Ptr); //-------------------------------------------- ������ "����-����"
      end;

      inc(c);

      if c > 500 then c := 0;

      if LiveCounter > MaxLiveCtr then LiveCounter := 0;

  end;

  //-------------------------------------------------------- ��������� ��������� ���������
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      1  : PrepXStrelki(Ptr);
      5  : PrepSvetofor(Ptr);
    end;
    if LiveCounter > MaxLiveCtr then  LiveCounter := 0;
  end;


  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    if ObjZav[Ptr].TypeObj = 2 then PrepOxranStrelka(Ptr);
    if ObjZav[Ptr].TypeObj = 27 then PrepDZStrelki(Ptr);
  end;

  //--------------------------------------------- ����� �� ����� ����������� ������� � ��.
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZav[Ptr].TypeObj of
      2  : PrepStrelka(Ptr);
      41 : PrepVPStrelki(Ptr);
      43 : PrepSOPI(Ptr);
      47 : PrepAutoMarshrut(Ptr);
    end;
    if LiveCounter > MaxLiveCtr then LiveCounter := 0;
  end;

  //--------------------------------------------------------- ��������� ������ �����������
  c := 0;
  for Ptr := 1 to 2000 do OVBuffer[Ptr].StepOver := false;
  for Ptr := 1 to 2000 do
  begin
    if OVBuffer[Ptr].Steps > 0 then GoOVBuffer(Ptr,OVBuffer[Ptr].Steps);
    inc(c);
    if c > 999 then c := 0;
  end;

{$IFDEF RMARC}
    SrvState := FR3[WorkMode.ServerStateSoob];
{$ENDIF}

//---------------------- ���������� ������� ��������, ����������� ������ ������ ����������
    if Config.configKRU = 1 then
    begin //-------------------------------------------------------------------- � �������
      if (SrvState and $7) = 0 then
      begin //------------------------------------- ������������� ������ ������ ����������
        SrvCount := 1;
        WorkMode.RUError := WorkMode.RUError or $4;
      end else
      begin //--------------------------------------- ����������� ������ ������ ����������
        SrvCount := 2;
        WorkMode.RUError :=  WorkMode.RUError and $FB;
      end;
      //------------------------------------------------------------- ����� �������� �����
      if SrvState and $30 = $10 then SrvActive := 1 else
      if SrvState and $30 = $20 then SrvActive := 2 else
      if SrvState and $30 = $30 then SrvActive := 3 else
      SrvActive := 0;
    end else
    begin //------------------------------------------------------------------- �� �������
      //-------------------------------------------------------------- ���������� ��������
      if ((SrvState and $7) = 1) or ((SrvState and $7) = 2) or ((SrvState and $7) = 4) or
      ((SrvState and $7) = 0) then SrvCount := 1
      else
      if (SrvState and $7) = 7 then SrvCount := 3
      else SrvCount := 2;

      //---------------------------------------------------------- ����� ��������� �������
      if ((LastRcv + MaxTimeOutRecave) > LastTime) then
      begin
      if (SrvState and $30) = $10 then SrvActive := 1
      else
      if (SrvState and $30) = $20 then SrvActive := 2
      else
      if (SrvState and $30) = $30 then SrvActive := 3 else SrvActive := 0;
    end
    else SrvActive := 0;
  end;

{$IFNDEF RMARC}
  //-------------------------------------------------  ��������� ������� ����� � ���������
  if (KanalSrv[1].Index > 0) or (KanalSrv[1].nPipe <> 'null') then
  begin
    if KanalSrv[1].iserror then ArmSrvCh[1] := 1 //---- ���� � ������ 1 ����������� ������
    else
    if KanalSrv[1].cnterr > 2 then ArmSrvCh[1] := 2 //� ������ 1 ����� ������ �������� > 2
    else
    if MySync[1] then ArmSrvCh[1] := 4 //----- ���� �� ������ ������� ������ �������������
    else ArmSrvCh[1] := 8; //---------------------------------- ������� �������� ���������
  end;

  if (KanalSrv[2].Index > 0) or (KanalSrv[2].nPipe <> 'null') then
  begin
    if KanalSrv[2].iserror then ArmSrvCh[2] := 1
    else
    if KanalSrv[2].cnterr > 2 then ArmSrvCh[2] := 2
    else
    if MySync[2] then ArmSrvCh[2] := 4
    else ArmSrvCh[2] := 8;
  end;
{$ENDIF}

{$IFDEF RMSHN}
  //------------------------------------------------------------------- ���������� �������
  for i := 1 to 10 do
  begin
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
      fp := GetFR3(LinkFR[FixNotify[i].Datchik[j]].FR3,fn,fn);//-------- ��������� �������
      fix := (FixNotify[i].State[j] = fp) and not fn;
      if fix then inc(cfp);
    end;

    if cfp > 0 then
    begin //---------------------------------------------------- ������ ������� �� �������

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
      end
      else FixNotify[i].fix := false;
    end
    else  FixNotify[i].fix := false;
  end;
{$ENDIF}


{$IFDEF RMDSP}
{
  if DspT                                                                                                                                                                                                                                                                                                                                                                                                                      oDspEnabled then
  begin //--------------------------------------------------------- ����� ���-���2 �������
    if DspToDspConnected then
    begin
      if DspToDspAdresatEn then ArmAsuCh[1] := 2 //--------------------- ������ ����������
      else ArmAsuCh[1] := 1; //----------------------------- �������� ����������� ��������
    end
    else ArmAsuCh[1] := 0; //---------------------------------------------- ��� ����������
  end
  else ArmAsuCh[1] := 255; //------------------------------------- ����� ���-���2 ��������
}

{$ENDIF}
  except
    {$IFNDEF RMARC}
    reportf('������ [MainLoop.PrepareOZ]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
procedure PrepareOZ1(Ptr : Integer);
var
  jj : integer;
begin
    case ObjZav[Ptr].TypeObj of
    2  :
    begin
      for jj := 1 to 2000
      do if OVBuffer[jj].Steps > 0 then
      GoOVBuffer(jj,OVBuffer[jj].Steps);
     // PrepXStrelki(Ptr+1);
     // PrepStrelka(Ptr);
    end;
  end;
{
  case ObjZav[Ptr].TypeObj of
    1 :  //--------------------------------------------------- � ������ ������ �������
    begin
      ObjZav[Ptr].bParam[5] := false; //---------- �����  ���������� �������� ��������
      ObjZav[Ptr].bParam[8] := false; //----- ����� ������� �������� �������� ��������
      ObjZav[Ptr].bParam[10] := false;//����� ����(��������� ������� � + ��� ��������)
      ObjZav[Ptr].bParam[11] := false;//����� ����(��������� ������� � - ��� ��������)
    end;

    27 : //----------------------------- ��������� ������� �������������� ������������
    begin
      ObjZav[Ptr].bParam[5] := false; //----------- ����� ���������� �������� ��������
      ObjZav[Ptr].bParam[8] := false; //----- ����� ������� �������� �������� ��������
    end;

    41 : //------------------------------------------ ������ ���������� ������� � ����
    begin
      ObjZav[Ptr].bParam[1] := false; //---------- ����� ������� �������� 1-�� �������
      ObjZav[Ptr].bParam[2] := false; //---------- ����� ������� �������� 2-�� �������
      ObjZav[Ptr].bParam[3] := false; //---------- ����� ������� �������� 3-�� �������
      ObjZav[Ptr].bParam[4] := false; //---------- ����� ������� �������� 4-�� �������
      ObjZav[Ptr].bParam[8] := false; //--------- ����� ������� �������� �������� 1-��
      ObjZav[Ptr].bParam[9] := false; //--------- ����� ������� �������� �������� 2-��
      ObjZav[Ptr].bParam[10] := false;//--------- ����� ������� �������� �������� 3-��
      ObjZav[Ptr].bParam[11] := false;//--------- ����� ������� �������� �������� 4-��
    end;

    44 : //------------------------------------------- ���������� ������� ��� ��������
    begin
      ObjZav[Ptr].bParam[1] := false; //------------  ����� ���������� �������� � ����
      ObjZav[Ptr].bParam[2] := false; //------------ ����� ���������� �������� � �����
      ObjZav[Ptr].bParam[5] := false; //----------- ����� ���������� �������� ��������
      ObjZav[Ptr].bParam[8] := true; //--------- ���������� �������� �������� ��������
    end;

    48 : ObjZav[Ptr].bParam[1] := false; //��� ---- ����� ���������� �������� � ������
  end;
   //---------------------------------------------------- ���������� ����������� �� �����

  case ObjZav[Ptr].TypeObj of
    2  :
    begin
      for jj := 1 to 2000
      do if OVBuffer[jj].Steps > 0 then
      GoOVBuffer(jj,OVBuffer[jj].Steps);
      PrepXStrelki(Ptr+1);
      PrepStrelka(Ptr);
    end;
    3  : PrepSekciya(Ptr);//--------------------------------------------------- ������
    4  : PrepPuti(Ptr); //------------------------------------------------------- ����
    5  : PrepSvetofor(Ptr);
    6  : PrepPTO(Ptr);       //--------------------------------------- ���������� ����
    7  : PrepPriglasit(Ptr); //-------------------------------- ��������������� ������
    8  : PrepUTS(Ptr);  //
    9  : PrepRZS(Ptr);  //----------------------------------- ������ ��������� �������
    10 : PrepUPer(Ptr); //--------------------------------------- ���������� ���������
    11 : PrepKPer(Ptr); //----------------------------------- �������� �������� (���1)
    12 : PrepK2Per(Ptr);//----------------------------------- �������� �������� (���2)
    13 : PrepOM(Ptr);
    14 : PrepUKSPS(Ptr); //------------------------- �������� ����� ���������� �������
    15 : PrepAB(Ptr);
    16 : PrepVSNAB(Ptr);
    17 : PrepMagStr(Ptr);//------------------------------------- ���������� ����������
    18 : PrepMagMakS(Ptr);
    19 : PrepAPStr(Ptr);
    20 : PrepMaket(Ptr);
    21 : PrepOtmen(Ptr);
    22 : PrepGRI(Ptr);
    23 : PrepMEC(Ptr);
    24 : PrepZapros(Ptr);
    25 : PrepManevry(Ptr);
    26 : PrepPAB(Ptr);
    31 : PrepPSvetofor(Ptr); //--------------------------------- ����������� ���������
    32 : PrepNadvig(Ptr);
    33 : PrepSingle(Ptr);     //---------------------------- ������ - ��������� ������
    34 : PrepPitanie(Ptr);
    35 : PrepInside(Ptr);
    36 : PrepSwitch(Ptr);      //------------------------ ������ - ������ + 5 ��������
    37 : PrepIKTUMS(Ptr);       //------------ ������ - �������������� ���������� ����
    38 : PrepMarhNadvig(Ptr);
    39 : PrepKRU(Ptr);
    40 : PrepIzvPoezd(Ptr);
    42 : PrepVP(Ptr);
    43 : PrepOPI(Ptr);
    45 : PrepKNM(Ptr); //------------------- ���������� ������� ������ ���� ����������
    46 : PrepAutoSvetofor(Ptr);
    48 : PrepRPO(Ptr);
    49 : PrepABTC(Ptr);
    50 : PrepDCSU(Ptr);
    51 : PrepDopDat(Ptr);
    52 : PrepSVMUS(Ptr);
    54 : PrepST(Ptr);
    55 : PrepDopSvet(Ptr);
    56 : PrepUKG(Ptr); //---------------------- ������ "���������� �������� ���������"
    92 :PrepDN(Ptr); //-------------------------------------------- ������ "����-����"
  end;



  if ObjZav[Ptr].TypeObj = 2 then PrepOxranStrelka(Ptr);
  if ObjZav[Ptr].TypeObj = 27 then PrepDZStrelki(Ptr);

  case ObjZav[Ptr].TypeObj of

    41 : PrepVPStrelki(Ptr);
    43 : PrepSOPI(Ptr);
    47 : PrepAutoMarshrut(Ptr);
  end;

}
// if OVBuffer[Ptr].Steps > 0 then GoOVBuffer(Ptr,OVBuffer[Ptr].Steps);
 
end;
//========================================================================================
//--------------------------------------------------- ���������� ������� ������ ������� #1
procedure PrepXStrelki(Ptr : Integer);
var
  i, o, p, str_1, str_2, sp_1, sp_2 : integer;
  pk,mk,pks,nps,d,bl : boolean;
  {$IFDEF RMSHN} dvps : Double; {$ENDIF}
begin
  try
    inc(LiveCounter);
    str_1 := ObjZav[Ptr].ObjConstI[8]; //----------------- ������ ������� ������ (�������)
    str_2 := ObjZav[Ptr].ObjConstI[9]; //----------------- ������ ������� ������ (�������)
    sp_1 := ObjZav[str_1].UpdateObject;
    sp_2 := ObjZav[str_2].UpdateObject;
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false;//------------------------------------- ��������������

    pk :=
      GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
    mk :=
      GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  //----------------------------------------------------------------- ������������ �������
    nps:=
      GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);
  //-------------------------------------------------------------- ������ �������� �������
    pks :=
      GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  //------------------------------------------ ���� ������������ ��� ���������� ����������
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
{$IFDEF RMSHN}  //------------------------------------------------------------ ��� ���� ��
      //------------------------ ���� ��� �� ��, �� ��, �� ���, � �� ������� ������� 1 � 2
      if not(pk or mk or pks or ObjZav[Ptr].Timers[1].Active
      or ObjZav[Ptr].Timers[2].Active)
      then
      begin
        if ObjZav[Ptr].sbParam[2] then  //-------------- ���� ���������� ��������� "�����"
        begin //-------------- ��������� ����� ������ ������ �������� ���������� ���������
          ObjZav[Ptr].Timers[2].Active := true; //---------------- �������������� ������ 2
          ObjZav[Ptr].Timers[2].First := LastTime; //------------- ��������� ������� �����
        end;

        if ObjZav[Ptr].sbParam[1] then //---------------- ���� ���������� ��������� "����"
        begin //--------------- ��������� ����� ������ ������ �������� ��������� ���������
          ObjZav[Ptr].Timers[1].Active := true; //---------------- �������������� ������ 1
          ObjZav[Ptr].Timers[1].First := LastTime; //------------- ��������� ������� �����
        end;
      end;
{$ENDIF}

      if pk and mk then //------------------------------------ ���� � �� � �� ������������
      begin
        pk := false; //---------------- ������������� �������� �� � �� ���� ��� ����������
        mk := false;
      end;

      if ObjZav[Ptr].bParam[25] <> nps then //------ ���� ��������� ��� ���������� �������
      begin
        if nps then //------------------------------------- ���� ������� ��������� �������
        begin
          if WorkMode.FixedMsg then //---------------- ���� ����������� �������� ���������
          begin
{$IFDEF RMSHN}
            InsArcNewMsg(Ptr,270+$1000,1); //----------------- "������� <Ptr> �� ��������"
            ObjZav[Ptr].dtParam[2] := LastTime;//������� ����� ������� "��������� �������"
            inc(ObjZav[Ptr].siParam[3]); //----------------- ��������� ������� �����������
{$ELSE}
            if config.ru = ObjZav[ptr].RU then //----���� ������� � ������ ���������� ����
            begin
              InsArcNewMsg(Ptr,270+$1000,1); //--------------- "������� <Ptr> �� ��������"
              AddFixMessage(GetShortMsg(1,270,ObjZav[ptr].Liter,1),4,1);
            end;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[25] := nps;  //-------------- ��������� ��������� ���� ����������

      d := false;
      o := ObjZav[Ptr].ObjConstI[6]; //------------------ ����� ������ ��� ���������� ��-1

      if o > 0 then //---------------------- ���� ������� ������������� ����� ����� � ��-1
      begin //---------------------- ��������� �������� �� ���������� � ���������� ����� 1
        case ObjZav[o].TypeObj of //---------------------- ������������� �� ���� ������ ��
          25 : d := GetState_Manevry_D(o); //--- ���� ���������� �������, �� �������� ��&�
          44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); //������. �� �������� - ��&�
        end;
      end;

      if not d then //-------------------------------------------------------- ���� ��� ��
      begin
        o := ObjZav[Ptr].ObjConstI[7]; //------------- �������� ������ ��� ���������� ��-2
        if o > 0 then
        begin //-------------------- ��������� �������� �� ���������� � ���������� ����� 2
          case ObjZav[o].TypeObj of
            25 : d := GetState_Manevry_D(o); //-------------------------------------- ��&�
            44 : d := GetState_Manevry_D(ObjZav[o].BaseObject); //------------------- ��&�
          end;
        end;
      end;

      if d then ObjZav[Ptr].bParam[24] := true //���� ��, �� ������ ������� "�����.������"
      else ObjZav[Ptr].bParam[24] := false; //------  ���� ��� ��, �� ������� ������� "��"

      if ObjZav[Ptr].bParam[26] <> pks then //- ���� ��������� ��� ������ �������� �������
      begin
        if pks then //----------------------------------- �������� ������ �������� �������
        begin
{$IFDEF RMSHN}
          ObjZav[Ptr].Timers[1].Active := false; //---------- �������� ������ ������ �����
          ObjZav[Ptr].Timers[2].Active := false; //--------- �������� ������ ������ ������
          if WorkMode.FixedMsg and WorkMode.OU[0] //-- ���� �������� � ���������� �� ��� �
          and WorkMode.OU[ObjZav[Ptr].Group] and not d then //--------------- ��� � ��� ��
          begin
            InsArcNewMsg(Ptr,271+$1000,0); // ---------- "������� <Ptr> �������� ��������"
            SingleBeep3 := true;
            ObjZav[Ptr].dtParam[1] := LastTime;//��������� ����� ������� "������ ��������"
            if ObjZav[Ptr].sbParam[1] then //------------------- ���� ������� ���� � �����
            begin
              if ObjZav[Ptr].bParam[22] then //------------- ���� ������ ������� �� ������
              inc(ObjZav[Ptr].siParam[1]) //---- ��������� ������� ������ �������� � �����
            else
            inc(ObjZav[Ptr].siParam[6]);//���� ������ �������� "+"  ��� ��������� ������
          end;

          if ObjZav[Ptr].sbParam[2] then //-------------------- ���� ������� ���� � ������
          begin
            if ObjZav[Ptr].bParam[22] then //--------------- ���� ������ ������� �� ������
            inc(ObjZav[Ptr].siParam[2]) //--------------- ������� ������ �������� � ������
            else
              inc(ObjZav[Ptr].siParam[7]); //���� ������ �������� "-" ��� ��������� ������
          end;
        end;
{$ELSE}
        if WorkMode.FixedMsg and not d then //-- ���� ��������� � �� �� ������� ����������
        begin
          if config.ru = ObjZav[ptr].RU then //----- ���� ������� � ������ ���������� ����
          begin
            InsArcNewMsg(Ptr,271+$1000,0);//------------ "������� <Ptr> �������� ��������"
            AddFixMessage(GetShortMsg(1,271,ObjZav[ptr].Liter,0),4,3);
          end;
        end;
{$ENDIF}
      end else //--------------------------------------------- ���� �������� �������������
      begin
        if WorkMode.FixedMsg and not d then //---------- ���� �������� �������� � �� �� ��
        begin
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,345+$1000,0); //---"������������ �������� ��������� ������� <Ptr>
          SingleBeep2 := true;
{$ELSE}
          if config.ru = ObjZav[ptr].RU then
          begin
            InsArcNewMsg(Ptr,345+$1000,0);
            AddFixMessage(GetShortMsg(1,345,ObjZav[ptr].Liter,0),5,2);
          end;
{$ENDIF}
        end;
      end;
    end;

    ObjZav[Ptr].bParam[26] := pks; //--------------- ��������� �������� ���� ��� � �������

    ObjZav[Ptr].bParam[1] := pk; //---------------------------------------------------- ��
    ObjZav[Ptr].bParam[2] := mk; //---------------------------------------------------- ��
{$IFDEF RMSHN}
    if pk then //-----------------------------------------------------���� ������� � �����
    begin
      ObjZav[Ptr].Timers[1].Active := false;//-----------------------------����� ������� 1

      if ObjZav[Ptr].Timers[2].Active //----------------------------- ���� ������2 �������
      then
      begin //------------------------------------- ��������� ������������ �������� � ����
        ObjZav[Ptr].Timers[2].Active := false;//------------------------- ������� �������2
        dvps := LastTime - ObjZav[Ptr].Timers[2].First;//������� ������������ �������� � +
        if dvps > 1/86400 then
        begin
          if ObjZav[Ptr].siParam[4] > StatStP then //--���� ��������� ������ �����.�������
          begin
            dvps := (ObjZav[Ptr].dtParam[3] * StatStP + dvps)/(StatStP+1); //------�������
          end else //----------------------------- ���� ������� ���� ��� ������ ����������
          begin
            dvps := (ObjZav[Ptr].dtParam[3] * ObjZav[Ptr].siParam[4] +
            dvps)/(ObjZav[Ptr].siParam[4]+1);
          end;
          ObjZav[Ptr].dtParam[3] := dvps;
        end;
      end;

      if not ObjZav[Ptr].sbParam[1] then //----------- ���� ������ ������� ���� �� � �����
      begin //----------------------------- ������� �� -----------------------------------
        ObjZav[Ptr].sbParam[1] := pk;//---------------------------�������� �������� ��� ��
        ObjZav[Ptr].sbParam[2] := mk;//---------------------------�������� �������� ��� ��
        if not StartRM then //------------------------------���� �� ���� ������� ���������
        inc(ObjZav[Ptr].siParam[4]);//-------------------- ��������� ������� ��������� � +
      end;
    end;

    if mk then//-----------------------------------------------------���� ������� � ������
    begin
      ObjZav[Ptr].Timers[2].Active := false; //-------------------------���������� ������2
      if ObjZav[Ptr].Timers[1].Active then //------------------------���� �������� ������1
      begin //------------------------------------ ��������� ������������ �������� � �����
        ObjZav[Ptr].Timers[1].Active := false;//------------------------���������� ������1
        dvps := LastTime - ObjZav[Ptr].Timers[1].First;//-------������� ����� �������� � -
        if dvps > 1/86400 then
        begin
          if ObjZav[Ptr].siParam[5] > StatStP then//��������� � ����� ������ �����.�������
          begin
            dvps := (ObjZav[Ptr].dtParam[4] * StatStP + dvps)/(StatStP+1); //------�������
          end else
          begin
            dvps := (ObjZav[Ptr].dtParam[4] * ObjZav[Ptr].siParam[5] +
            dvps)/(ObjZav[Ptr].siParam[5]+1);
          end;
          ObjZav[Ptr].dtParam[4] := dvps;//-----------------��������� ����� �������� � "-"
        end;
      end;

      if not ObjZav[Ptr].sbParam[2] then   //-------- ���� ������ ������� ���� �� � ������
      begin //---------------------------- ������� �� ------------------------------------
        ObjZav[Ptr].sbParam[1] := pk;//---------------------------�������� �������� ��� ��
        ObjZav[Ptr].sbParam[2] := mk;//---------------------------�������� �������� ��� ��
        if not StartRM then //------------------------------���� �� ���� ������� ���������
        inc(ObjZav[Ptr].siParam[5]);//-------------------- ��������� ������� ��������� � -
      end;
    end;
{$ENDIF}

    if ObjZav[Ptr].ObjConstB[3] then  //-------------- ���� ��� ������� ���� ��������� ���
    begin //--------------------------------------------------------------- ���� ��� �� ��
      if ObjZav[str_1].ObjConstB[9] then //---------���� ������ ������� ����� � ������ ���
      ObjZav[Ptr].bParam[20] :=  ObjZav[sp_1].bParam[4];//-- �� �������� ��� �� ������� ��

      if (str_2 > 0) and ObjZav[str_2].ObjConstB[9] then//���� ������ ������� �  ����� ���
      if ObjZav[Ptr].bParam[20] then //-���� ��� ����� �� �����������, �� ����� �� �������
      ObjZav[Ptr].bParam[20] := ObjZav[SP_2].bParam[4];//�� 2-�� �������
    end
    else ObjZav[Ptr].bParam[20] := true; //--���� ��� ��������� �� ����, �� ���������� ���

    //----------------------------------------- ���� ��������� �� �� ---------------------
    d := ObjZav[sp_1].bParam[2];//----------------------- �������� ��������� �� �� �������
    if str_2 > 0 then//----------------------------------------- ���� ���� ������� �������
    if d then d := ObjZav[SP_2].bParam[2]; //------ ���� ������� �� �������� �� �� �������

    if d <> ObjZav[Ptr].bParam[21] then //------------ ���� ��������� ��������� ����������
    begin
      ObjZav[Ptr].bParam[6] := false;//--------------------------------- ����� �������� ��
      ObjZav[Ptr].bParam[7] := false; //-------------------------------- ����� �������� ��

      //------------------------------------- ��������� � ������� ����������� ������������
      bl :=  ObjZav[sp_1].bParam[20];// -------- ���������� �� ������� �� ������������� ��
      if (str_2 > 0) and (not bl) then //--- ���� ���� ������� � ��� ���������� �� �������
      bl :=  ObjZav[sp_2].bParam[20]; //---------------------------------- ���������� 2-��

      ObjZav[Ptr].bParam[3] := d and//������� ���������� ��� ������������ = ��������� �� �
      not bl and //----------------------------------------------- ���������� ���������� �
      ObjZav[Ptr].ObjConstB[2] and //--------------------- ������� �������� ������������ �
      (not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2]);//----------- ������� � ������
    end;

    ObjZav[Ptr].bParam[21] := d; //------------------------- ��������� ��������� ���������

    //--------------------------------------------------------------- ���� ��������� �� ��
    ObjZav[Ptr].bParam[22] := ObjZav[sp_1].bParam[1]; //---- ����� ��������� �� ������� ��

    if str_2 > 0 then //---------------------------------------- ���� ���� ������� �������
    if ObjZav[Ptr].bParam[22] then //---------------- ���� �� ���� ��������� �� �������,��
    ObjZav[Ptr].bParam[22] := ObjZav[sp_2].bParam[1]; //---------------- ��������� �������

    //-------------------------------------------------------- ����� ��������� �����������
    ObjZav[Ptr].bParam[23] := false;
    inc(LiveCounter);//---------------------------- ��������� ���� �������� ������� ������

    //-------------------------------------------- �������� �������� �� ������� ����������
    ObjZav[Ptr].bParam[9] := false; //-------------------------------- �������� ������� ��
    for i := 20 to 24 do //--------------------------- ������ �� 5-�� ��������� ������� ��
    if ObjZav[Ptr].ObjConstI[i] > 0 then //---- ���� ����� ����� �� ������� ����������, ��
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of //---- ������������� �� ���� ������
        25 :  //------------------------------------------------------- ���������� �������
          if not ObjZav[Ptr].bParam[9] then //---- ���� ��� �������� ------------------ ��
          ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]); //-- ��&�
        44 : //-------------------------------------------- ���������� ������� �� ��������
          if not ObjZav[Ptr].bParam[9] then //----------------------- ���� ��� �������� ��
          ObjZav[Ptr].bParam[9] :=
          GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
      end;
    end;

    //--------------------------------------------------------- �������� ������� ���������
    ObjZav[Ptr].bParam[4] := false; //-------------------- ����� ��������������� ���������
    ObjZav[Ptr].bParam[4] := ObjZav[Ptr].bParam[4] or
    ObjZav[Ptr-1].bParam[33] or ObjZav[Ptr-1].bParam[25]; //------------- ���� ��� ��� ���

    if ObjZav[Ptr].ObjConstI[12] > 0 then //----------- ���� ���� ������ ��������� �������
    begin
      if ObjZav[ObjZav[Ptr].ObjConstI[12]].bParam[1] then //-- ���� ������� ������� �� ���
      ObjZav[Ptr].bParam[4] := true;  //------------------------- ���������� ���.���������
    end;


    if ObjZav[Ptr].bParam[21] then //------------------- ���� ��� �������� ��������� �� ��
    begin
      if not ObjZav[Ptr].bParam[4] then //--------------------- ���� ��� ������. ���������
      //----------------------------------------------------- �������� �������� ����������
      for i := 6 to 7 do //------------------------- ������ �� 2-�� ��������� ������� ��
      begin
        o := ObjZav[Ptr].ObjConstI[i];//---------------------------- ����� ������ ������
        if o > 0 then //------------------------------------ ���� ��� ������� ���� �����
        begin

          case ObjZav[o].TypeObj of //--------------------- ������������� �� ���� ������
            25 : // ------------------------------------------------- ���������� �������
            begin
              if not ObjZav[o].bParam[3] then //--------------------------- ���� ���� ��
              begin
                ObjZav[Ptr].bParam[4] := true; //--------- ���������� ��������.���������
                break;
              end;
            end;
            44 ://--------------------------------------- ���������� ������� �� ��������
            begin
              if not ObjZav[ObjZav[o].BaseObject].bParam[3] then //-------- ���� ���� ��
              begin
                ObjZav[Ptr].bParam[4] := true; //--------- ���������� ��������.���������
                break;
              end;
            end;
          end;
        end;
      end;

      //---------------------------------------------------------------- �������� ��������
      for i := 20 to 24 do //---------------- ������ �� 5-�� ��������� �������� ������� ��
      begin
        o := ObjZav[Ptr].ObjConstI[i]; //----------------------- �������� ��������� ������
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            25 :
            begin
              if not ObjZav[o].bParam[3] then //---------------------------------- ���� ��
              begin
                ObjZav[Ptr].bParam[4] := true; //----------- ���������� ��������.���������
                break;
              end;
            end;
            44 :
            begin
              if not ObjZav[ObjZav[o].BaseObject].bParam[3] then //--------------- ���� ��
              begin
                ObjZav[Ptr].bParam[4] := true; //----------- ���������� ��������.���������
                break;
              end;
            end;
          end;
        end;
      end;

      if not ObjZav[Ptr].bParam[4] then//-------------- ���� ��� ��������������� ���������
      //---------------------------------------------------------- �������� ������ �������
      for i := 14 to 19 do //----------------- ������ �� 6-�� ��������� �������� ���������
      begin
        o := ObjZav[Ptr].ObjConstI[i];//--------------------------------- ��������� ������
        if o > 0 then //-------------------------------------------- ���� ���� ������ ����
        begin
          case ObjZav[O].TypeObj of //---------------------- ������������� �� ���� �������
            3 : //----------------------------------------------------------------- ������
            begin
              if not ObjZav[o].bParam[2] then //--------------------- ���� ������ ��������
              begin
                ObjZav[Ptr].bParam[4] := true; //---------------- ���������� ���.���������
                break;
              end;
            end;

            25 :  //--------------------------------------------------- ���������� �������
            begin
              if not ObjZav[o].bParam[3] then  //--------------------------------- ���� ��
              begin
                ObjZav[Ptr].bParam[4] := true; //-------------- ���������� ���.���������
                break;
              end;
            end;

            27 : //------------------------------------------------------ �������� �������
            begin
              if not ObjZav[ObjZav[o].ObjConstI[2]].bParam[2] then //---- ���� �� ��������
              begin
                if ObjZav[o].ObjConstB[1] then //------------------ ���� �������� �� �����
                begin
                  if not ObjZav[ObjZav[o].ObjConstI[1]].bParam[2] then //----- ���� ��� ��
                  begin
                    ObjZav[Ptr].bParam[4] := true; //------------ ���������� ���.���������
                    break;
                  end;
                end else//------------------------------------- ���� ��� �������� �� �����
                if ObjZav[o].ObjConstB[2] then //----------------- ���� �������� �� ������
                begin
                  if not ObjZav[ObjZav[o].ObjConstI[1]].bParam[1] then //-- ������� �� � +
                  begin
                    ObjZav[Ptr].bParam[4] := true; //------------ ���������� ���.���������
                    break;
                  end;
                end;
              end
              else
            end;

            41 :  //------------------ ���������� ������� � ���� ��� ��������� �����������
            begin
              if ObjZav[o].bParam[20] and//----- ���� ���� ������� ��������� ����������� �
              not ObjZav[ObjZav[o].UpdateObject].bParam[2] then//- ����������� �� ��������
              begin
                ObjZav[Ptr].bParam[4] := true; //---------------- ���������� ���.���������
                break;
              end;
            end;

            46 : //------------------------------------------------- ������������ ��������
            begin
              if ObjZav[o].bParam[1] then  //-------------------���� �������� ������������
              begin
                ObjZav[Ptr].bParam[4] := true;//----------------- ���������� ���.���������
                break;
              end;
            end;
          end;
        end;
      end;

      if not ObjZav[Ptr].bParam[4] and //------------ ���� ��� ��������������� ��������� �
      (ObjZav[Ptr].ObjConstI[8] > 0) then //------------------------- ���� ������� �������
      if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[7]) then //----���� �������� �� �����
      begin
        inc(LiveCounter);
        o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Obj;//---- ����� ������� �� "+"
        p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[2].Pin;//--- � ����� ������ �� "+"
        i := 100;//-------------- ���������� ���������� ����� �����(����� ��� �����������)
        while i > 0 do //------------------------ ���� �� ���������, ���� �� ������ ������
        begin
          case ObjZav[o].TypeObj of //--------- ������������� �� ���� ������������ �������
            2 : //---------------------------------------------------------------- �������
            begin
              case p of//----------------------- ������������� �� ������ ����� �����������
                2 :
                begin //--------------------------- ���� �� �������� ������� ����� � ����
                  if ObjZav[o].bParam[2] //---------- ���� �������� ������� ����� � ������
                  then break; //------------------------------- ������� � ������ �� ������
                end;

                3 :
                begin //-------------------------- ���� �� �������� ������� ����� � �����
                  if ObjZav[o].bParam[1] //----------------- ���� �������� ������� � �����
                  then break; //-------------------------------- ������� � ������ �� �����
                end;

                else//------------------------------���� ����� �� ����� 1 �������� �������
                  ObjZav[Ptr].bParam[4] := true;//------------------------------- ��������
                  break; //------------------------------------------ ������ � ���� ������
              end;
              p := ObjZav[o].Neighbour[1].Pin;//----- � ����� ���������� ������ �� ����� 1
              o := ObjZav[o].Neighbour[1].Obj;//---------- ����� ������ �� ����� 1 �������
            end;

            //----------------------------------------------------------------------------
            3,4 : //--------------------------------------------------------- �������,����
            begin
              ObjZav[Ptr].bParam[4] :=//-------------- ���������� �������������� ���������
              not ObjZav[o].bParam[2]; //--------------------�� ��������� ����������� ����
              break;
            end;

            else //--------------------------------------------------- ��� ������ ��������
              if p = 1 then //------------------------ ���� ������������ � ����� 1 �������
              begin
                p := ObjZav[o].Neighbour[2].Pin; //--- �������� � ����� ����������� ������
                o := ObjZav[o].Neighbour[2].Obj; //---- �������� ������ ����� �� ������ �2
              end
              else //---------------------- ���� ������������ � ������ ����� (��� ����� 2)
              begin
                p := ObjZav[o].Neighbour[1].Pin; //--- �������� � ����� ����������� ������
                o := ObjZav[o].Neighbour[1].Obj; //---- �������� ������ ����� �� ������ �1
              end;
            end;
            if (o = 0) or (p < 1) then break;  //------���� 0-������ ��� 0-�����, �� �����
            dec(i);
          end;
        end;

        if not ObjZav[Ptr].bParam[4] and //---------- ���� ��� ��������������� ��������� �
        (ObjZav[Ptr].ObjConstI[8] > 0) then //------------------ ���� ���� ������� �������
        if (ObjZav[ObjZav[Ptr].ObjConstI[8]].ObjConstB[8]) then//���� ���� �������� �� "-"
        begin //------------------------------------------------- �� ���������� ����������
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Obj;//-- ����� �� ������� "-"
          p := ObjZav[ObjZav[Ptr].ObjConstI[8]].Neighbour[3].Pin; //----� ����� ������ "-"
          i := 100;
          while i > 0 do
          begin
          case ObjZav[o].TypeObj of
            2 :   //-------------------------------------------------------------- �������
            begin
              case p of
                2 :   //-------------------------------------------- ���� �� ������� �����
                begin
                  if ObjZav[o].bParam[2] //--------------- ���� ������� � ������ �� ������
                  then break;
                end;

                3 :   //------------------------------------------- ���� �� ������� ������
                begin
                  if ObjZav[o].bParam[1] //---------------- ���� ������� � ������ �� �����
                  then break;
                end;
                else  ObjZav[Ptr].bParam[4] := true; break; //------- ������ � ���� ������
              end;
              p := ObjZav[o].Neighbour[1].Pin; //----- �������� � ����� ����������� ������
              o := ObjZav[o].Neighbour[1].Obj; //------ �������� ������ ����� �� ������ �1
            end;

            3,4 : //--------------------------------------------------------- �������,����
            begin
              ObjZav[Ptr].bParam[4] := //------------------------ �������������� ���������
              not ObjZav[o].bParam[2];//---------------------�� ��������� ����������� ����
              break;
            end;

            else //-------------------------------------------------------- ������ �������
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end
            else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
          end;
          if (o = 0) or (p < 1) then break; //---------���� 0-������ ��� 0-�����, �� �����
          dec(i);
        end;
      end;

      if not ObjZav[Ptr].bParam[4] and //------------ ���� ��� ��������������� ��������� �
      (ObjZav[Ptr].ObjConstI[9] > 0) then //------------------------- ���� ������� �������
      if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[7]) //--�����.�� ��������� ����������
      then //----------------------------------------�������� ���������� ��������� �������
      begin
        inc(LiveCounter);
        o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Obj; //-- ������ �� ������� "+"
        p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[2].Pin; //---- � ����� ������� "+"
        i := 100;
        while i > 0 do
        begin
          case ObjZav[o].TypeObj of
            2 : //-------------------------------------------------------- ����� = �������
            begin
              case p of
                2 :   //-------------------------------------------- ���� �� ������� �����
                begin
                  if ObjZav[o].bParam[2] //------------------- ���� �������-����� � ������
                  then break;
                end;

                3 :   //------------------------------------------- ���� �� ������� ������
                begin
                  if ObjZav[o].bParam[1] //-------------------- ���� �������-����� � �����
                  then break;
                end;

                else
                  ObjZav[Ptr].bParam[4] := true;
                  break; //------------------------------------------ ������ � ���� ������
              end;
              p := ObjZav[o].Neighbour[1].Pin;//------ �������� � ����� ����������� ������
              o := ObjZav[o].Neighbour[1].Obj; //- �������� ������,������������� � ����� 1
            end;

            3,4 : //--------------------------------------------------------- �������,����
            begin
              ObjZav[Ptr].bParam[4] := //-------- �������������� ��������� �� ��������� ..
              not ObjZav[o].bParam[2]; //------------------ ����������� ���� �������, ����
              break;
            end;
            else //---------------------------------------------- ��� ���� ������ ��������
              if p = 1 then //------------- ��� ����� 1 ����� ��, ��� ���������� � ����� 2
              begin
                p := ObjZav[o].Neighbour[2].Pin;
                o := ObjZav[o].Neighbour[2].Obj;
              end
              else//----------------------- ��� ����� 2 ����� ��, ��� ���������� � ����� 1
              begin
                p := ObjZav[o].Neighbour[1].Pin;
                o := ObjZav[o].Neighbour[1].Obj;
              end;
            end;
            if (o = 0) or (p < 1) then break; //-------��� 0-������� ��� 0-����� ���������
            dec(i);
          end;
        end;

        if not ObjZav[Ptr].bParam[4] and //---------- ���� ��� ��������������� ��������� �
        (ObjZav[Ptr].ObjConstI[9] > 0) then //----------------------- ���� ������� �������
        if (ObjZav[ObjZav[Ptr].ObjConstI[9]].ObjConstB[8]) then//���� ���� �������� �� "-"
        begin
          inc(LiveCounter);
          o := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Obj; //------����� �� �������
          p := ObjZav[ObjZav[Ptr].ObjConstI[9]].Neighbour[3].Pin;//����� ������ �� �������
          i := 100;
          while i > 0 do
          begin
            case ObjZav[o].TypeObj of
              2 : //-------------------------------------------------------------- �������
              begin
                case p of
                  2 :   //-------------------------------------------------- ���� �� �����
                  begin
                    if ObjZav[o].bParam[2] then break; //--���� ������� � ������ �� ������
                  end;
                  3 :   //------------------------------------------------- ���� �� ������
                  begin
                    if ObjZav[o].bParam[1] then break; //---���� ������� � ������ �� �����
                  end;
                  else
                    ObjZav[Ptr].bParam[4] := true;
                    break; //------ ������ � ���� ������
                end;
                p := ObjZav[o].Neighbour[1].Pin;
                o := ObjZav[o].Neighbour[1].Obj;
              end;

              3,4 : //------------------------------------------------------- �������,����
              begin
                ObjZav[Ptr].bParam[4] :=
                not ObjZav[o].bParam[2]; // ��������� ����������� ����
                break;
              end;

              else
                if p = 1 then
                begin
                  p := ObjZav[o].Neighbour[2].Pin;
                  o := ObjZav[o].Neighbour[2].Obj;
                end
                else
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
{$IFDEF RMDSP}
      //---------------------------------------------------- �������� ������� ������������
      if ObjZav[Ptr].ObjConstB[2] then //------------------------ ���� ������� �����������
      begin
        inc(LiveCounter);
        if ObjZav[Ptr].bParam[3] then //----------------------------- ���� ���� ����������
        begin
          ObjZav[Ptr].bParam[3] := false;
          if StartRM then
          begin // ����������� ����������� ��� ������� ����
            ObjZav[Ptr].Timers[1].Active := false;
          end else
          // ��������� ������� �������� ���������� ��������� �������
          if not ObjZav[Ptr].bParam[1] and //----------------------------------- ��� �����
          ObjZav[Ptr].bParam[2] and //----------------------------------------- ���� �����
          WorkMode.Upravlenie and //-------------------------------------- ���� ����������
          WorkMode.OU[0] and //--------------------------------------------------- ���� ��
          WorkMode.OU[ObjZav[Ptr].Group] then //--------------------------------- ���� ���
          begin //-------------------- ��������� ������� ����������� �������� ������������
            ObjZav[Ptr].bParam[12] := true;//---------- ������������� ������� ������������
            ObjZav[Ptr].Timers[1].Active := true; //--------- ������������ ������1 �������
            ObjZav[Ptr].Timers[1].First := LastTime + 3/80000; //------������������� �����
          end;
        end
        else //------------------------------------------------------ ���� ��� �����������
        // ��������� ������������ ������ ������� ������������
        if ObjZav[Ptr].bParam[12] and //------------- ���� ���� ����������� ������������ �
        not ObjZav[Ptr].bParam[1] and //----------------------------------------- ��� �� �
        ObjZav[Ptr].bParam[2] and //-------- ������� ����� �������� ���������� ��������� �
        not ObjZav[Ptr].bParam[4] and //------------------ ��� ��������������� ��������� �
        not ObjZav[Ptr].bParam[8] and //--------------- ��� �������� �������� � �������� �
        not ObjZav[Ptr].bParam[14] and //----------------------- ������� �� ������������ �
        not ObjZav[Ptr].bParam[18] and //------------ ������� �� ��������� �� ���������� �
        not ObjZav[Ptr].bParam[19] and //---------------- ������� �� ��������� ��� ����� �
        ObjZav[Ptr].bParam[20] and //------------------------------------------- ��� ��� �
        ObjZav[Ptr].bParam[21] and //---------------------------------- ��� ��������� �� �
        ObjZav[Ptr].bParam[22] and //---------------------------------- ��� ��������� �� �
        not ObjZav[Ptr].bParam[23] and //------------------------------- ��� ����������� �
        not ObjZav[Ptr].bParam[9] and //----------------------------------------- ��� �� �
        not ObjZav[Ptr].bParam[10] and //------------------- ��� ���������� ��� �������� �
        not ObjZav[Ptr].bParam[24] then //------------------------ ��� �������� ����������
        begin
          if ObjZav[ObjZav[Ptr].ObjConstI[10]].bParam[3] then//���� ��� ���������� �������
          begin //--- ���� ������ ������� ��������� ����� - ����� ����������� ������������
            ObjZav[Ptr].bParam[12] := false; //-------------------------- ����� ����������
            ObjZav[Ptr].Timers[1].Active := false; //----------------------- ����� �������
          end else
          begin //--------------------------------------- �������� ������� ��������� �����
            d := not ObjZav[Ptr].bParam[19]; //------------------------------------- �����

            if d then //----------------------------------------- ���� ����� �� ����������
            d := not ObjZav[Ptr].bParam[15]; //--------------------------- ����� ����� FR4

            if d then //----------------------------------------- ���� ����� �� ����������
            d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[18]; // ���������� �� �������

            if d then //------------------------------------ ���� ��� �������� ��� �������
            d := not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[10] and //�� 1-�� ��� ����� �
            not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[12] and // ���������� �� � ����� �
            not ObjZav[ObjZav[Ptr].ObjConstI[8]].bParam[13]; //---- ���������� �� � ������

          if ObjZav[Ptr].ObjConstI[9] > 0 then //--------------- ���� ���� ������� �������
          begin
            if d then //------------------------------------ ���� ��� �������� ��� �������
            d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[18]; // ��� ���������� ���-��
            if d then //------------------------------------------------ ���� ��� ��������
            d := not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[10] and //�� 1-� ��� ������ �
            not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[12] and // ���������� �� � ����� �
            not ObjZav[ObjZav[Ptr].ObjConstI[9]].bParam[13]; //-----���������� �� � ������
          end;
          if d and //------------------------------------- ���� ��� �������� ��� ������� �
          ObjZav[Ptr].Timers[1].Active and //------------------------ ������� ������ ��1 �
          (ObjZav[Ptr].Timers[1].First < LastTime) then   //------- ������ ��������� �����
          begin
            if (CmdCnt = 0) and //-------------- ���� ��� ���������� ������ ��� �������� �
            not WorkMode.OtvKom and //------------------------------ �� ������ ������ �� �
            not WorkMode.VspStr and //------------ ��� ���������������� �������� ������� �
            not WorkMode.GoMaketSt and //------------ �� ���� ��������� ������� �� ����� �
            WorkMode.Upravlenie and   //------------------------- ���������� �� ���� ��� �
            not WorkMode.LockCmd and //--------------------------- ��� ���������� ������ �
            not WorkMode.CmdReady and  //----------- ��� �������� ������������� �������� �
            WorkMode.OU[0] and        //-------------------------------- ���� ������� �� �
            WorkMode.OU[ObjZav[Ptr].Group] then //----------------------- ���� ������� ���
            begin // ���� ������� ����������� ������������ � ��� ��������� ������ � ������
              ObjZav[Ptr].bParam[12] := false; //------------����� ���������� ������������
              ObjZav[Ptr].Timers[1].Active := false; //-------------- ���������� ������ �1
              //---------------------------- ������� ������� ������������ ������� � ������
              if  SendCommandToSrv(ObjZav[Ptr].ObjConstI[2] div 8, cmdfr3_strautorun,Ptr)
              then
                //------------------"������ ������� �������� ������� � �������� ���������"
              AddFixMessage(GetShortMsg(1,418, ObjZav[Ptr].Liter,7),5,5);
            end;
          end;
        end;
      end;
    end else //------------------------------ ���� ��� ������� �� ������������ �����������
    begin //--------------------------------- �� ����������� ���������� ���������� ������,
          //--------------------------------------- ���� ��� �������� ������������ �������
      ObjZav[Ptr].bParam[3] := false;
      ObjZav[Ptr].bParam[12] := false;
      ObjZav[Ptr].Timers[1].Active := false;
    end;
{$ENDIF}
  end else
  begin //------------------------------------ �������� �������� ��� ���������� ����������
    ObjZav[Ptr].bParam[1] := false;
    ObjZav[Ptr].bParam[2] := false;
    ObjZav[Ptr].bParam[3] := false;
{$IFDEF RMSHN}
    ObjZav[Ptr].bParam[19] := false;
{$ENDIF}
  end;

  {FR4}

  ObjZav[Ptr].bParam[18] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-5);//��������� ����������

  ObjZav[Ptr].bParam[15] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-4);//-------------- �����

  ObjZav[Ptr].bParam[16] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-3);//������� ����.�������

  ObjZav[Ptr].bParam[17] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-2);//������� ����.�������

  ObjZav[Ptr].bParam[33] := GetFR4State(ObjZav[Ptr].ObjConstI[1]-1); // ������� �� �������

  ObjZav[Ptr].bParam[34] := GetFR4State(ObjZav[Ptr].ObjConstI[1]); //-- ������� �� �������
except
  {$IFNDEF RMARC}
    reportf('������ [MainLoop.PrepXStrelki]');
  {$ENDIF}
  Application.Terminate;
end;
end;
//========================================================================================
//------------------- ���������� ������� ������� � �������� �������� ��� ������ �� ����� 2
procedure PrepOxranStrelka(Ptr : Integer);
var
  o,p,VideoBufStr,Xstr,Strelka : Integer;
begin
  try
    Strelka := Ptr;
    inc(LiveCounter);
    VideoBufStr := ObjZav[Strelka].VBufferIndex;
    Xstr := ObjZav[Strelka].BaseObject;
    //---------------------------------- �������� �������������� ������� � ������ ��������
    if ObjZav[Strelka].bParam[10] or //---------------- ���� ������ ������ ����������� ���
    ObjZav[Strelka].bParam[11] or //------------------------ ������ ������ ����������� ���
    ObjZav[Strelka].bParam[12] or //------------------------------- ���������� � ����� ���
    ObjZav[Strelka].bParam[13] then //-------------------------------- ���������� � ������
    begin
      OVBuffer[VideoBufStr].Param[6] := false; //-------------- ���������� �� ������ �����
      OVBuffer[VideoBufStr].Param[5] := false; //------------------ ������� �������� �����
      exit;
    end else
    begin
      if ObjZav[Xstr].bParam[5] = false then //----- ���� ��� ���������� �������� ��������
      begin
        o := ObjZav[Xstr].ObjConstI[8]; //----- �������� ������ "�" 1-�� ������� (�������)
        p := ObjZav[Xstr].ObjConstI[9]; //----- �������� ������ "�" 2-�� ������� (�������)
        if (p > 0) and (p <> Strelka) then  //----- ���� ���� ������� ������� � ��� ������
        begin
          if (ObjZav[p].bParam[10] or //--------------- ���� ������ ������ ����������� ���
          ObjZav[p].bParam[11] or //------------------------ ������ ������ ����������� ���
          ObjZav[p].bParam[12] or //------------------------------- ���������� � ����� ���
          ObjZav[p].bParam[13]) then //------------------------------- ���������� � ������
          OVBuffer[VideoBufStr].Param[6] := true //------- ���������� �� ������ ����������
        else
          OVBuffer[VideoBufStr].Param[6] := false; //---- ����� ���������� �� ������ �����
        end else
        if (o > 0) and (o <> Strelka) then  //----- ���� ���� ������� ������� � ��� ������
        begin
          if (ObjZav[o].bParam[10] or
          ObjZav[o].bParam[11] or
          ObjZav[o].bParam[12] or
          ObjZav[o].bParam[13]) then
          OVBuffer[VideoBufStr].Param[6] := true
          else OVBuffer[VideoBufStr].Param[6] := false;
        end
        else  OVBuffer[VideoBufStr].Param[6] := false; // ����� ���������� �� ������ �����
      end
      else  OVBuffer[VideoBufStr].Param[6] := true;
    end;
    //----------------- ��������� �������� �������� �������, �� �������� � ������ ��������
    if ObjZav[Xstr].bParam[14] then  //---------------- ���� ����������� ��������� �������
    OVBuffer[VideoBufStr].Param[5] := false //-------- ����� �� ������ ���������� ��������
    else OVBuffer[VideoBufStr].Param[5]:=ObjZav[Xstr].bParam[8];//����.�������� �� ������
  except
    {$IFNDEF RMARC}
    reportf('������ [MainLoop.PrepOxranStrelka]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//---------------------- ���������� ������� "������� ����� �������" ��� ������ �� ����� #2
procedure PrepStrelka(Ptr : Integer);
var
  i,o,p,DZ,SPohr,SPstr,Strelka,VideoBufStr,Xstr,rzs,Maket_str,Mag_str : integer;
  text : string;
begin
  try
    Strelka := Ptr;
    VideoBufStr := ObjZav[Strelka].VBufferIndex;
    Xstr := ObjZav[Strelka].BaseObject;
    SPstr := ObjZav[Strelka].UpdateObject;
    Mag_str := ObjZav[Xstr].ObjConstI[11]; //--------------------------- ���������� ������
    Maket_str := ObjZav[Mag_str].BaseObject; //----------------------------- ����� �������


    inc(LiveCounter);
    if VideoBufStr > 0 then
    begin
      OVBuffer[VideoBufStr].Param[16] := ObjZav[Xstr].bParam[31]; //----------- ����������

      OVBuffer[VideoBufStr].Param[1] := ObjZav[Xstr].bParam[32];//----------- ������������

      ObjZav[Strelka].bParam[1] := ObjZav[Xstr].bParam[1]; //-------------------------- ��
      ObjZav[Strelka].bParam[2] := ObjZav[Xstr].bParam[2]; //-------------------------- ��

      rzs := ObjZav[Xstr].ObjConstI[12];//--------------- ������ ������� ��������� �������

      ObjZav[Strelka].bParam[4] := false;

      if ObjZav[Xstr].bParam[4] then
      ObjZav[Strelka].bParam[4] := ObjZav[Xstr].bParam[4];//------------- ��������� ������

      ObjZav[Strelka].bParam[4] := ObjZav[Strelka].bParam[4] or
      ObjZav[Strelka].bParam[33] or ObjZav[Strelka].bParam[25]; //------------ ��� ��� ���

      if ObjZav[rzs].bParam[1] or
      ObjZav[Strelka].bParam[33] or ObjZav[Strelka].bParam[25] then
      OVBuffer[VideoBufStr].Param[7] := true   //----------------- ���� ���� ��� ��� �����
      else
        if ObjZav[SPstr].bParam[2] then//---------------- ���� o����� �� ������� ���������
        OVBuffer[VideoBufStr].Param[7] := ObjZav[Strelka].bParam[4]//���������� ����.�����.
        else OVBuffer[VideoBufStr].Param[7] := false; // ����� �� ���������� �����.�������

      if not ObjZav[Xstr].bParam[31] or //------------------ ��� ���������� ���������� ���
      ObjZav[Xstr].bParam[32] then //------------------------------  �������������� ������
      begin  //-------------------------------------- ��������  ��������������� �� �������
        OVBuffer[VideoBufStr].Param[2] := false; //-------------------------------- ��� ��
        OVBuffer[VideoBufStr].Param[3] := false; //-------------------------------- ��� ��
        OVBuffer[VideoBufStr].Param[8] := false; //-------- ��� ���������� � �������������
        OVBuffer[VideoBufStr].Param[9] := false; //-------- ��� ���������� � �������������
        OVBuffer[VideoBufStr].Param[10] := false;//-------- ��� ���������� � �������������
        OVBuffer[VideoBufStr].Param[12] := false;//------------------- ��� �������� ���(�)
      end else
      begin
        //---------------------- ����������� ������� ���������� �������� �� ������ �������
        ObjZav[Strelka].bParam[9] := ObjZav[XStr].bParam[9];

        if not WorkMode.Upravlenie then
        begin
          ObjZav[XStr].Timers[3].Active := false;
          ObjZav[XStr].Timers[3].First := 0;
        end;
//---------------------- � � � � � �  �  � � � � � � � -----------------------------------
        if ({$IFDEF RMDSP}(XStr = maket_strelki_index) or {$ENDIF}  //----- ���� �� ������
        ObjZav[XStr].bParam[24]) and not WorkMode.Podsvet then
        begin //������� ����� ������� ��� ������� ���������� - �� �������� ������� �������
          if not WorkMode.Upravlenie or //---------------- ���� �� ����������� ��� ��� ...
          (ObjZav[XStr].Timers[3].First <> 0) then //--- ���� ���� ������ ������ �� ������
          begin
            if not WorkMode.Upravlenie or //-------------- ���� �� ����������� ��� ��� ...
            (LastTime > ObjZav[XStr].Timers[3].First) then //------- ������ ���� ���������
            begin
              if not WorkMode.Upravlenie or   //---------- ���� �� ����������� ��� ��� ...
              (ObjZav[XStr].iParam[5] = cmdfr3_strmakplus) then //----- ���������� � ����
              begin
                if not ObjZav[Maket_str].bParam[4] and //--------------- ���� ��� ��� �...
                ObjZav[Maket_str].bParam[3] and  //------------------------ ���� ��� � ...
                (not ObjZav[XStr].bParam[2] and ObjZav[XStr].bParam[1]) then //-------- ��
                begin
                  ObjZav[XStr].Timers[3].Active := false;
                  ObjZav[XStr].Timers[3].First := 0;
                  ObjZav[XStr].iParam[4] := ObjZav[XStr].iParam[5];
                end else
                begin
                  if ObjZav[XStr].Timers[3].Active then
                  begin
                    InsArcNewMsg(XStr,577+$2000,0);//--- ������ �������� ������� �� ������
                    AddFixMessage(GetShortMsg(1,577,ObjZav[XStr].Liter,0),4,4);
                    ObjZav[XStr].Timers[3].Active := false;
                  end;
                end;
              end;

              if not WorkMode.Upravlenie or
              (ObjZav[XStr].iParam[5] = cmdfr3_strmakminus) then //--- ���������� � �����
              begin
                if ObjZav[Maket_str].bParam[4] and //------------------ ���� ���� ��� �...
                not ObjZav[Maket_str].bParam[3] and  //--------------------- ��� ��� � ...
                (ObjZav[XStr].bParam[2] and not ObjZav[XStr].bParam[1]) then //-------- ��
                begin
                  ObjZav[XStr].Timers[3].Active := false;
                  ObjZav[XStr].Timers[3].First := 0;
                  ObjZav[XStr].iParam[4] := ObjZav[XStr].iParam[5];
                end else
                begin
                  if ObjZav[XStr].Timers[3].Active then
                  begin
                    InsArcNewMsg(XStr,577+$2000,0);//������ ��� �������� ������� �� ������
                    AddFixMessage(GetShortMsg(1,577,ObjZav[XStr].Liter,0),4,4);
                    ObjZav[XStr].Timers[3].Active := false;
                  end;
                end;
              end;
            end;
          end;

          //------------- ������ - ���� ����������� ���  �� ���� ������ ������� ��� ������
          if ObjZav[Maket_str].bParam[2] then //----------------- ���� ���� ������ �������
          begin
            if WorkMode.Upravlenie and //------------------------- ���� ��� �������� � ...
            (ObjZav[XStr].iParam[4] <> ObjZav[XStr].iParam[5]) then //������� �� ���������
            begin
              OVBuffer[VideoBufStr].Param[2] := false; //-------------------------- ��� ��
              OVBuffer[VideoBufStr].Param[3] := false; //-------------------------- ��� ��
            end else  //------------------------ ���� ������� ���������  ��� ��������� ���
            if ObjZav[Maket_str].bParam[2] then
            begin
              OVBuffer[VideoBufStr].Param[2] :=
              ObjZav[XStr].bParam[1] and ObjZav[Maket_str].bParam[3]; //--------------  ��

              OVBuffer[VideoBufStr].Param[3] :=
              ObjZav[XStr].bParam[2] and ObjZav[Maket_str].bParam[4]; //--------------  ��

              if ObjZav[XStr].bParam[1] and ObjZav[Maket_str].bParam[3] then
              begin
                ObjZav[XStr].iParam[4] := cmdfr3_strmakplus;
                ObjZav[XStr].iParam[5] := cmdfr3_strmakplus;
              end;

              if ObjZav[XStr].bParam[2] and ObjZav[Maket_str].bParam[4] then
              begin
                ObjZav[XStr].iParam[4] := cmdfr3_strmakminus;
                ObjZav[XStr].iParam[5] := cmdfr3_strmakminus;
              end;
            end;

            if WorkMode.Upravlenie then
            begin
              if (ObjZav[XStr].iParam[4] = cmdfr3_strmakminus) or//-- ���� ������� "�����"
              (ObjZav[XStr].iParam[4] = 0) then //--------------------- ��� �� ���� ������
              begin
                if not ObjZav[Maket_str].bParam[4] or //------------- ���� ��� ��� ��� ...
                ObjZav[Maket_str].bParam[3] or   //---------------------- ���� ��� ��� ...
                not ObjZav[XStr].bParam[2]  or    //----------------------- ��� �� ��� ...
                ObjZav[XStr].bParam[1] then //------------------------------------ ���� ��
                begin
                  OVBuffer[ObjZav[Strelka].VBufferIndex].Param[2] := false; //--- ����� ��
                  OVBuffer[ObjZav[Strelka].VBufferIndex].Param[3] := false;//---- ����� ��
                  if not ObjZav[XStr].bParam[27] then
                  begin
                    InsArcNewMsg(XStr,271+$1000,0);//--------- "������� �������� ��������"
                    AddFixMessage(GetShortMsg(1,271,ObjZav[XStr].Liter,0),4,3);
                    ObjZav[XStr].bParam[27] := true;
                  end;
                end;
              end else

              if (ObjZav[XStr].iParam[4] =  cmdfr3_strmakplus) or // ���� ���� ������� "+"
              (ObjZav[XStr].iParam[4] = 0) then //--------------------- ��� �� ���� ������
              begin
                if ObjZav[Maket_str].bParam[4] or //-------------------- ����  ��� ��� ...
                not ObjZav[Maket_str].bParam[3] or //--------------------- ��� ��� ��� ...
                ObjZav[XStr].bParam[2]  or    //------------------------------- �� ��� ...
                not ObjZav[XStr].bParam[1]  then //-------------------------------- ��� ��
                begin
                  OVBuffer[VideoBufStr].Param[2] := false; //-------------------- ����� ��
                  OVBuffer[VideoBufStr].Param[3] := false;//--------------------- ����� ��
                  if not ObjZav[XStr].bParam[27] then
                  begin
                    InsArcNewMsg(XStr,271+$1000,0);//--- "������� <Ptr> �������� ��������"
                    AddFixMessage(GetShortMsg(1,271,ObjZav[XStr].Liter,0),4,3);
                    ObjZav[XStr].bParam[27] := true;
                  end;
                end;
              end;
            end;
          end;

         if OVBuffer[VideoBufStr].Param[2] <> OVBuffer[VideoBufStr].Param[3] then
          ObjZav[XStr].bParam[27] := false;//---- �������� ������������, �������� ��������
        end else //---------------------------------------------------------- �� �� ������
        begin
          if ObjZav[Strelka].bParam[1] then // ------------------------------ ���� ���� ��
          begin
            if ObjZav[Strelka].bParam[2] then //--------------------- ������������ ���� ��
            begin
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[2] := false; //------- ����� ��
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[3] := false;//-------- ����� ��
            end else
            begin //------------------------------------------------------------ ���� ����
              //--------------------------- ���������� ������� ���������� �������� � �����
              ObjZav[Strelka].bParam[20] := true;
              ObjZav[Strelka].bParam[21] := false;
              ObjZav[Strelka].bParam[22] := false;
              ObjZav[Strelka].bParam[23] := false;
              OVBuffer[VideoBufStr].Param[2] := true;  //-- ��� ������ ��
              OVBuffer[VideoBufStr].Param[3] := false;//��� ������ ��� ��
            end;
          end else
          if ObjZav[Strelka].bParam[2] then //--------------------------------- ���� �����
          begin
            //---------------------------- ���������� ������� ���������� �������� � ������
            ObjZav[Strelka].bParam[20] := false;
            ObjZav[Strelka].bParam[21] := true;
            ObjZav[Strelka].bParam[22] := false;
            ObjZav[Strelka].bParam[23] := false;
            OVBuffer[VideoBufStr].Param[2] := false; //----------------- ��� ������ ��� ��
            OVBuffer[VideoBufStr].Param[3] := true; //----------------- ��� ������ ���� ��
          end else
          begin
            OVBuffer[VideoBufStr].Param[2] := false;
            OVBuffer[VideoBufStr].Param[3] := false;
          end;
        end;

        //---------------------------------------------- ��������� �������� ������� ���(�)
        OVBuffer[VideoBufStr].Param[12] := ObjZav[Strelka].ObjConstB[9] and
        not ObjZav[ObjZav[Strelka].UpdateObject].bParam[4] and
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[1] and
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[2];

        //------------------------------------------------------------- ������� �� �������
        ObjZav[Strelka].bParam[3] :=
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[5];//�� �� ������

        inc(LiveCounter);
        o := 0;

        //----------------------------------------------- ��������� ���������� ��� �������
        for i := 1 to 10 do
        if ObjZav[Strelka].ObjConstI[i] > 0 then
        begin
          o := 0;
          case ObjZav[ObjZav[Strelka].ObjConstI[i]].TypeObj of
            27 :
            begin //------------------------------------------- �������� ��������� �������
              DZ := ObjZav[Strelka].ObjConstI[i]; //-- ������ �������� ��������� ���������
              SPohr := ObjZav[DZ].ObjConstI[2];//------ ������ �� ��� ��������� ���������
              if ObjZav[DZ].ObjConstB[1] then //---- ���� ����������� ��� �������  � �����
              begin
                if ObjZav[Strelka].bParam[1] then //--------- ���� ������� ������� � �����
                begin
                  o := ObjZav[DZ].ObjConstI[3]; //----------------------- �������� �������
                  if o > 0 then
                  begin
                    if ObjZav[DZ].ObjConstB[3] then //---- ���� �������� ������ ���� � "+"
                    begin
                      if ObjZav[o].bParam[1] = false then //----- ���� �������� �� � �����
                      begin
                        ObjZav[o].bParam[3] := false; //---------------�������� � ��������
                        break;
                      end else
                      begin
                        ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6];
                      end;
                    end else
                    if ObjZav[DZ].ObjConstB[4] then //--------------------- ���� ���. �� -
                    begin
                      if ObjZav[o].bParam[2] = false then //------------- ���� �� � ������
                      begin
                        ObjZav[Strelka].bParam[3] := false;
                        break;
                      end else
                      begin
                       ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6]; //- ���������� ����
                      end;
                    end;
                  end;
                end;
              end else
              if ObjZav[DZ].ObjConstB[2] then //------- ���� ������� ������ ���� �� ������
              begin
                if ObjZav[Strelka].bParam[2] then //---------------- ���� ������� � ������
                begin
                  o := ObjZav[ObjZav[Strelka].ObjConstI[i]].ObjConstI[3];//�������� �������
                  if o > 0 then
                  begin
                    if ObjZav[DZ].ObjConstB[3] then//--- ���� �������� ������ ���� � �����
                    begin
                      if ObjZav[o].bParam[1] = false then //----------- ������� �� � �����
                      begin
                        ObjZav[Strelka].bParam[3] := false;
                        break;
                      end else
                      begin
                       ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6]; //- ���������� ����
                      end;
                    end else //---------------------- ���� �������� ������ ���� �� � �����
                    if ObjZav[DZ].ObjConstB[4] then //- ���� �������� ������ ���� � ������
                    begin
                      if ObjZav[o].bParam[2] = false then //- �������� ������� �� � ������
                      begin
                        ObjZav[Strelka].bParam[3] := false;
                        break;
                      end else
                      begin
                       ObjZav[o].bParam[3] := ObjZav[SPohr].bParam[6]; //- ���������� ����
                      end;
                    end;
                  end;
                end;
              end;

              if o > 0 then
              begin
                ObjZav[o].bParam[4] := //--------------- ��������� �������� ������� �� ...
                ObjZav[o].bParam[4] or //--------- ����������� ��������� ��������� ��� ...
                (not ObjZav[SPohr].bParam[2]) or //------------------ ������������� �� ���
                ObjZav[o].bParam[33] or //------------------- ������� ������������ ��� ...
                ObjZav[o].bParam[25]; //--------------------------- ��������� ������������

                OVBuffer[ObjZav[o].VBufferIndex].Param[7] := ObjZav[o].bParam[4];
                OVBuffer[ObjZav[o].VBufferIndex].Param[6] := ObjZav[o].bParam[14];
              end;
            end; //-------------------------------------------------------------- ����� 27

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            6 : //-------------------------------------------------------- ���������� ����
            begin
              for p := 14 to 17 do
              begin
                if ObjZav[ObjZav[Strelka].ObjConstI[i]].ObjConstI[p] = Strelka then
                begin
                  o := ObjZav[Strelka].ObjConstI[i];
                  if ObjZav[o].bParam[2] then
                  begin
                    if ObjZav[Strelka].bParam[1] then
                    begin
                      if not ObjZav[o].ObjConstB[p*2-27] then
                      begin
                        ObjZav[Strelka].bParam[3] := false; break;
                      end;
                    end else
                    if ObjZav[Strelka].bParam[2] then
                    begin
                      if not ObjZav[o].ObjConstB[p*2-26] then
                      begin
                        ObjZav[Strelka].bParam[3] := false; break;
                      end;
                    end;
                  end;
                end;
              end;
            end; //6
          end; //case
        end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
        o := 0;
        //-------------------------------------------------------- �������� ��������������
        if ObjZav[Strelka].bParam[3] then
        begin
          inc(LiveCounter);
          //-------------- ������ �������������� ����� ���� � ���������� ��������� �������
          if ObjZav[Strelka].bParam[1] then
          begin
            if (ObjZav[Strelka].Neighbour[3].TypeJmp = LnkNeg) or //---- ������������ ����
            (ObjZav[Strelka].ObjConstB[8]) then//��� �������� ���������� ��������� �������
            begin //--------------------------------------------- �� ���������� ����������
              o := ObjZav[Strelka].Neighbour[3].Obj;
              p := ObjZav[Strelka].Neighbour[3].Pin;
              i := 100;
              while i > 0 do
              begin
                case ObjZav[o].TypeObj of
                  2 :
                  begin //-------------------------------------------------------- �������
                    case p of
                      2 :
                      begin //---------------------------------------------- ���� �� �����
                        if ObjZav[o].bParam[2] then break; //-- ������� � ������ �� ������
                      end;

                      3 :
                      begin // ���� �� ������
                        if ObjZav[o].bParam[1] then break; //--- ������� � ������ �� �����
                      end;

                      else
                        ObjZav[Strelka].bParam[3] := false;
                        break; //------------------------------------ ������ � ���� ������
                    end;
                    p := ObjZav[o].Neighbour[1].Pin;
                    o := ObjZav[o].Neighbour[1].Obj;
                  end;

                  3,4 :
                  begin //--------------------------------------------------- �������,����
                    if ObjZav[Strelka].Neighbour[3].TypeJmp = LnkNeg then
                    ObjZav[Strelka].bParam[3]:=ObjZav[o].bParam[1]//��������� �������� �������
                    else  ObjZav[Strelka].bParam[3] := false;
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
          if ObjZav[Strelka].bParam[2] then //----------------------------------- ���� ���� ��
          begin
            if (ObjZav[Strelka].Neighbour[2].TypeJmp = LnkNeg) or //-------- ������������ ����
            (ObjZav[Strelka].ObjConstB[7]) then  //- ��� �������� ���������� ��������� �������
            begin //---------------------------------------------- �� ��������� ����������
              o := ObjZav[Strelka].Neighbour[2].Obj;
              p := ObjZav[Strelka].Neighbour[2].Pin;
              i := 100;
              while i > 0 do
              begin
                case ObjZav[o].TypeObj of
                  2 :
                  begin //-------------------------------------------------------- �������
                    case p of
                      2 :
                      begin //---------------------------------------------- ���� �� �����
                        if ObjZav[o].bParam[2] then break; //-- ������� � ������ �� ������
                      end;

                      3 :
                      begin //--------------------------------------------- ���� �� ������
                        if ObjZav[o].bParam[1] then break; //--- ������� � ������ �� �����
                      end;

                      else
                        ObjZav[Strelka].bParam[3] := false;
                        break; //------------------------------------ ������ � ���� ������
                    end;
                    p := ObjZav[o].Neighbour[1].Pin;
                    o := ObjZav[o].Neighbour[1].Obj;
                  end;

                  3,4 :
                  begin //--------------------------------------------------- �������,����
                    if ObjZav[Strelka].Neighbour[2].TypeJmp = LnkNeg then
                    ObjZav[Strelka].bParam[3]:=ObjZav[o].bParam[1]//��������� �������� �������
                    else  ObjZav[Strelka].bParam[3] := false;
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
        end;

        //-------------------------------------- �������� ��������� ��������� ������������
        if ObjZav[XStr].ObjConstB[1] then //----------------------------- ���� ������� ���
        begin
          inc(LiveCounter);
          if ObjZav[Strelka].bParam[1] and not ObjZav[Strelka].bParam[2] then//������� � +
          begin //-------------------------------------- ���� �������� ��������� ���������
            ObjZav[Strelka].bParam[19] := false;
            ObjZav[Strelka].Timers[1].Active := false;//����� ����.������� ������� �� � ��
            OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := true;
            OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := false;
            OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
          end else
          begin
            if not ObjZav[XStr].bParam[21] then //�� �������� � ��������
            begin
              ObjZav[Strelka].bParam[19] := false;
              ObjZav[Strelka].Timers[1].Active := false;//����� ����.����. ������� �� � ��
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false; //-- ��� ���������
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := false; //������ ���������
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
            end else
            if not ObjZav[XStr].bParam[20] or
            not ObjZav[XStr].bParam[22] then
            begin //--------------------------- �������� ������� ��� ��� ��������� �������
              ObjZav[Strelka].bParam[19] := false;
              ObjZav[Strelka].Timers[1].Active := false;//����� �������� ����.������ �� ��
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false;
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := false;
              OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := true;
            end else
            begin //-------------------------------------- �������� �� ��������� ���������
              if not ObjZav[Strelka].bParam[1] and ObjZav[Strelka].bParam[2] then
              begin
                if ObjZav[Strelka].Timers[1].Active then
                begin //-- ������� ������� ���������� ��������� ��������� ���������� �����
                  if LastTime >= ObjZav[Strelka].Timers[1].First then
                  begin
                    if (ObjZav[XStr].ObjConstI[8] = Strelka) and
                    not ObjZav[Strelka].bParam[19] and
                    not ObjZav[Strelka].bParam[18] and
                    not ObjZav[XStr].bParam[18] and //--------------------------- ��������
                    not ObjZav[XStr].bParam[15] then //----------------------------- �����
                    begin
{$IFDEF RMDSP}
                      if WorkMode.OU[0] and
                      WorkMode.OU[ObjZav[Strelka].Group] and
                      (ObjZav[Strelka].RU = config.ru) then//���������, ��� ���-����������
                      begin
                        InsArcNewMsg(XStr,477,1);
                        text := GetShortMsg(1,477,ObjZav[XStr].Liter,7);
                        AddFixMessage(text,4,3); //------- ������� �� � �������� ���������
                        ShowShortMsg(477,LastX,LastY,ObjZav[XStr].Liter);
                      end;
{$ELSE}
                      InsArcNewMsg(XStr,477,2);
{$ENDIF}
                    end;
                    ObjZav[Strelka].Timers[1].Active := false;
                    ObjZav[Strelka].bParam[19] := true;
                  end;
                end else
                begin //-------- ������������� ����� ������ ������� �� ��������� ���������
                  ObjZav[Strelka].Timers[1].Active := true;
                  ObjZav[Strelka].Timers[1].First := LastTime + 0.000694;//------ 1 ������
                end;
              end else //------------------------------------ ��� �������� - ����� �������
              begin
                ObjZav[Strelka].bParam[19] := false;
                ObjZav[Strelka].Timers[1].Active := false;
              end;

              if ObjZav[Strelka].bParam[19] and
              not ObjZav[Strelka].bParam[18] and
              not ObjZav[XStr].bParam[18] and //----------- ��������
              not ObjZav[XStr].bParam[15] and //-------------- �����
              WorkMode.Upravlenie then
              begin //------------------------------------------------------------- ������
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := tab_page;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
              end else
              begin //---------------------------------------------------------- �� ������
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[8] := false;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[9] := true;
                OVBuffer[ObjZav[Strelka].VBufferIndex].Param[10] := false;
              end;
            end;
          end;
        end;

        //------------------------------------------------------ ��������� ������� �������
        if ObjZav[XStr].ObjConstI[13] > 0 then
        begin
          if ObjZav[ObjZav[XStr].ObjConstI[13]].bParam[1] then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[11] := true
          else  OVBuffer[ObjZav[Strelka].VBufferIndex].Param[11] := false;
        end;

        // ����� ��������������� ��������� �� ��������� ���������� ������ ��� �� PM ��� ��
        if not ObjZav[ObjZav[Strelka].UpdateObject].bParam[2] or
        ObjZav[ObjZav[Strelka].UpdateObject].bParam[9] or
        not ObjZav[ObjZav[Strelka].UpdateObject].bParam[5] then
        begin
          ObjZav[Strelka].bParam[14] := false;
          ObjZav[Strelka].bParam[6] := false;
          ObjZav[Strelka].bParam[7] := false;
          ObjZav[Strelka].bParam[10] := false;
          ObjZav[Strelka].bParam[11] := false;
          ObjZav[Strelka].bParam[12] := false;
          ObjZav[Strelka].bParam[13] := false;
          SetPrgZamykFromXStrelka(Strelka);
        end;

        OVBuffer[VideoBufStr].Param[7] :=
        OVBuffer[VideoBufStr].Param[7] or ObjZav[Strelka].bParam[33];

        if o <> 0 then OVBuffer[VideoBufStr].Param[7] :=
        OVBuffer[VideoBufStr].Param[7] or ObjZav[o].bParam[25];


        if not WorkMode.Podsvet and //----------------------- ���� ��� ��������� ������� �
        (ObjZav[XStr].iParam[4] <> ObjZav[XStr].iParam[5]) and //----- ������� ������ � ..
       (ObjZav[XStr].bParam[15] or  //------------------------------ ���� ����� �� Fr4 ���
{$IFDEF RMSHN} ObjZav[XStr].bParam[19] or {$ENDIF}//--------------------- ����� �� �������
        ObjZav[Xstr].bParam[24]) then //--------------------- ���.��-�� ���.� ������.�����
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[4] := true //-- ��������� ���� ������
        else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[4] := false;
      end;

      //--------------------------------------- FR4 --------------------------------------
      if ObjZav[Strelka].ObjConstB[6] then //----------- ���� ��������� � ��� ���� �������
      begin
            //-------------------------- ��������  ��� �������� --------------------------
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Strelka].bParam[16]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[17];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[17];
        //------------------------------------------- ������ ��� ���������������� ��������
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Strelka].bParam[17]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] :=  ObjZav[Xstr].bParam[34];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] :=  ObjZav[Xstr].bParam[34];
      end else
      begin //------------------------------------------------------ ��������� ��� �������
        //----------------------------------------------------------- ������� ��� ��������
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Strelka].bParam[16]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[16];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[30] := ObjZav[Xstr].bParam[16];
        //------------------------------------------- ������ ��� ���������������� ��������
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if tab_page then
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Strelka].bParam[17]
          else
          OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Xstr].bParam[33];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Strelka].VBufferIndex].Param[29] := ObjZav[Xstr].bParam[33];
      end;
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //---------------------------------------------------------------------- �����
        if tab_page then OVBuffer[VideoBufStr].Param[31] :=  ObjZav[Xstr].bParam[19]
        else
        OVBuffer[VideoBufStr].Param[31] := ObjZav[Xstr].bParam[15];
      end else
{$ENDIF}
      OVBuffer[VideoBufStr].Param[31] := ObjZav[Xstr].bParam[15];
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //------------------------------------------------------- ��������� ����������
        if tab_page then  OVBuffer[VideoBufStr].Param[32] := ObjZav[Strelka].bParam[18]
        else OVBuffer[VideoBufStr].Param[32] := ObjZav[Xstr].bParam[18];
      end else
{$ENDIF}
      OVBuffer[VideoBufStr].Param[32] := ObjZav[Xstr].bParam[18];
      {
      OVBuffer[ObjZav[Strelka].VBufferIndex].Param[7] :=
      ObjZav[Xstr].bParam[4] or ObjZav[Strelka].bParam[4]
      }
    end;
  except
    {$IFNDEF RMARC}
    reportf('������ [MainLoop.PrepStrelka]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------- ���������� ������� ������ ��� ������ �� ����� #3
procedure PrepSekciya(Ptr : Integer);
var
  p,msp,z,mi,ri : boolean;
  i : integer;
  sost : byte;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    p := //------------------------------------------------------------------ ������� ����
    not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    z := //--------------------------------------------------------------------- ���������
    not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ri := //--------------------------------------------------------------------------- ��
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    msp := //------------------------------------------------------------------------- ���
    not GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    mi := //--------------------------------------------------------------------------- ��
    not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[6] := //-------------------------------------------------- ����� ��
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[7] := //----------------------------------------------- ����� �����
    not GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31]; //����������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];//������������

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if (ObjZav[Ptr].ObjConstI[8] > 0) and(ObjZav[Ptr].ObjConstI[9] > 0) then
        begin //------------------------------- ����� ���� ������� ���� ���� ������ ���(�)
          if p <> ObjZav[Ptr].bParam[1] then
          begin //---------------------------------- ������������� ��������� �������� ����
            if p then
            begin //------------------------------------------------- ������������ �������
              if msp then
              begin //--------------------------------------------------- ��������� ���(�)
                ObjZav[Ptr].Timers[1].Active := false; //----------- ����� �������� ���(�)
              end else
              begin //--------------------------------------------------- ��������� ���(�)
                if not ObjZav[Ptr].Timers[1].Active then
                begin //-------------------------------------------- ������ ������ �������
                  ObjZav[Ptr].Timers[1].First := LastTime;
                  ObjZav[Ptr].Timers[1].Active := true;
                end;
              end;
            end else
            begin //------------------------------------------------------ ������� �������
              ObjZav[Ptr].Timers[1].Active := false; //------------- ����� �������� ���(�)
            end;
          end;

          if msp <> ObjZav[Ptr].bParam[4] then
          begin //-------------------------------------------- ������������� ��������� ���
            if msp then
            begin //----------------------------------------------------- ��������� ���(�)
{$IFDEF RMSHN}
              if ObjZav[Ptr].Timers[1].Active
              then ObjZav[Ptr].dtParam[3] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
              ObjZav[Ptr].Timers[1].Active := false; //------------- ����� �������� ���(�)
            end;
          end;
        end;

        ObjZav[Ptr].bParam[1] := p;
        ObjZav[Ptr].bParam[4] := msp;

        if ObjZav[Ptr].ObjConstI[9] > 0 then
        begin
          if ObjZav[Ptr].Timers[1].Active then
          begin //----------------------------------- ������ �������� ���������� ���������
            Timer[ObjZav[Ptr].ObjConstI[9]] :=
            1 + Round((LastTime - ObjZav[Ptr].Timers[1].First) * 86400);
          end else
          begin //---------------------------------------------------------- ������ ������
            Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
          end;
        end;

      if ObjZav[Ptr].bParam[21] then //���� ���� �������� ��������������� ���������� �� ��
      begin
        ObjZav[Ptr].bParam[20] := true; //------------------ ���������� ������� ����������
        ObjZav[Ptr].bParam[21] := false; //----------------------- ����� �������� ��������
      end else
      begin //---------------- ���� ��� �������� �������� ��������������� ���������� �� ��
        ObjZav[Ptr].bParam[20] := false; //------------------- �������� ������� ����������
      end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] :=
      (config.ru = ObjZav[ptr].RU) and WorkMode.Upravlenie; //���������� ������ ����������

      if ObjZav[Ptr].bParam[2] <> z then //-------------------------- ���������� ���������
      begin
        ObjZav[Ptr].bParam[8] := true;  //----------------------------- ����� �����������
        ObjZav[Ptr].bParam[14] := false; //--------------- ����� ��������������� ���������

        if z then //------------------------------------------------ ��� ���������� ������
        begin
          ObjZav[Ptr].iParam[2] := 0; //----- ����� ������� ���������, ���������� ��������
          ObjZav[Ptr].iParam[3] := 0; //------------------------------- ����� ������� ����
          ObjZav[Ptr].bParam[15] := false; //----------------------------------- ����� 1��
          ObjZav[Ptr].bParam[16] := false; //----------------------------------- ����� 2��
        end;
      end;
      ObjZav[Ptr].bParam[2] := z;  //----------------- ���������� ������� �������� ��� "�"

      if ObjZav[Ptr].bParam[5] <> mi then //-------------------------------- ���������� ��
      begin
        ObjZav[Ptr].bParam[8] := true;  //------------------------------ ����� �����������
        ObjZav[Ptr].bParam[14] := false; //--------------- ����� ��������������� ���������
        if mi then
        begin //---------------------------------------------------- ��� ���������� ������
          ObjZav[Ptr].bParam[15] := false; //----------------------------------- ����� 1��
          ObjZav[Ptr].bParam[16] := false; //----------------------------------- ����� 2��
        end;
      end;
      ObjZav[Ptr].bParam[5] := mi;  //------------------------------------------------- ��

      //------------------------------------------ �������� �������� �� ������� ����������
      ObjZav[Ptr].bParam[9] := false; //----------------------------------------------- ��
      for i := 20 to 24 do
        if ObjZav[Ptr].ObjConstI[i] > 0 then //---------------------- ���� ���� ���� �����
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
            25 :
            if not ObjZav[Ptr].bParam[9] then
            ObjZav[Ptr].bParam[9] := GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);

            44 :
            if not ObjZav[Ptr].bParam[9] then
            ObjZav[Ptr].bParam[9] :=
            GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
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
        begin //---------------------------------------------------------- ��� �����������
          if not ObjZav[Ptr].bParam[7] then
          begin //----------------------------------------------------------------- �� FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin //--------------------------------- ������� ���������� ������ ����� ������
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[8];//�� �������
          end;
        end else
        begin
          if not ObjZav[Ptr].bParam[7] then
          begin //----------------------------------------------------------------- �� FR3
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := true;
          end else
          begin
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := false;
            if tab_page then //---------------- �������� ������ ������� ��������� ��������
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := true
            else
              OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] :=
              ObjZav[Ptr].bParam[8]; //----------------------------------- �� ������� ����
          end;
        end;
      end else
      begin //--------------------------------------------------------------------- �� FR3
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[7];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := not ObjZav[Ptr].bParam[7];
{$IFDEF RMDSP}
      end;
{$ENDIF}

      if ObjZav[Ptr].bParam[3] <> ri then
      begin
        if ri and not StartRM then
        begin //-------------------------------------------- ��������� ����� ������ ��� ��
{$IFDEF RMDSP}
          if ObjZav[Ptr].RU = config.ru then begin
            InsArcNewMsg(Ptr,84+$2000,7);
            AddFixMessage(GetShortMsg(1,84,ObjZav[Ptr].Liter,7),0,2);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,84+$2000,7);
{$ENDIF}
        end;
      end;
      ObjZav[Ptr].bParam[3] := ri;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[3]; //--------- ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[6];

      sost := GetFR5(ObjZav[Ptr].ObjConstI[1]);
      if ObjZav[Ptr].bParam[5] and (ObjZav[Ptr].iParam[3] = 0) then
      begin //--------------------------- ��������� ����������� ���� ��� ��������, �������
        if ((sost and 1) = 1) then
        begin //---------------------------------------- ��������� �o���� ��������� ������
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,394+$1000,0);
          ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[1] := LastTime;
          inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then
          begin
            InsArcNewMsg(Ptr,394+$1000,0); //----------------------- ������������� �������
            AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter,0),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; //----- ����������� �������������
{$ENDIF}
        end;
        if ((sost and 2) = 2) and not ObjZav[Ptr].bParam[9] then
        begin //-------------------------------------- ��������� �o���� ����������� ������
{$IFDEF RMSHN}
          InsArcNewMsg(Ptr,395+$1000,0);  //------------------- ������������� ������������
          ObjZav[Ptr].bParam[19] := true;
          ObjZav[Ptr].dtParam[2] := LastTime;
          inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
          if ObjZav[Ptr].RU = config.ru then
          begin //--------------------- ����������� ������������� ���� �������� ����������
            InsArcNewMsg(Ptr,395+$1000,0);
            AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter,0),4,1);
          end;
          ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie;
{$ENDIF}
        end;
      end;

      if WorkMode.Podsvet and ObjZav[Ptr].ObjConstB[6] then
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := true
      else
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := false;

    end else
    begin //------------------------------------- ������� � ������������� ��������� ������
      if ObjZav[Ptr].ObjConstI[9] > 0 then Timer[ObjZav[Ptr].ObjConstI[9]] := 0;
      ObjZav[Ptr].bParam[21] := true; //-------- ���������� ������� ��������������� ������
    end;

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[19];

    //-------------------------------------------------------------------------------- FR4
    ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
    begin
      if tab_page
      then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13]
      else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin //------------------------------------------------------------- ���� �����������
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page then
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin //---------------------------------------------------- ���� 2 ���� �����������
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25]
          else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26]
          else
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
      end;
    end;
  end;
except
  {$IFNDEF RMARC}
  reportf('������ [MainLoop.PrepSekciya]');
  {$ENDIF}
  Application.Terminate;
end;
end;
//========================================================================================
//----------------------------------------- ���������� ������� ���� ��� ������ �� ����� #4
procedure PrepPuti(Ptr : Integer);
var
  z1,z2,mic,min,Nepar,Activ : boolean;
  i,PutCH,PutN,Ni,CHi,CHkm,Nkm,MI_CH,MI_N,PrZC,PrZN,VidB : integer;
  sost,sost1,sost2 : Byte;
begin
  try
    inc(LiveCounter);

    Nepar := false;
    Activ := true;

    PutCH := ObjZav[Ptr].ObjConstI[2];
    Ni    := ObjZav[Ptr].ObjConstI[4];
    CHi   := ObjZav[Ptr].ObjConstI[3];
    CHkm  := ObjZav[Ptr].ObjConstI[5];
    MI_CH := ObjZav[Ptr].ObjConstI[6];
    Nkm   := ObjZav[Ptr].ObjConstI[7];
    MI_N  := ObjZav[Ptr].ObjConstI[8];
    PutN  := ObjZav[Ptr].ObjConstI[9];
    PrZC  := ObjZav[Ptr].ObjConstI[11];
    PrZN  := ObjZav[Ptr].ObjConstI[12];
    VidB :=  ObjZav[Ptr].VBufferIndex;


    //--------------------------------------- ��������� ���� � ������ � � �������� �������
    ObjZav[Ptr].bParam[1] := not GetFR3(PutCH,Nepar,Activ);//------------------------ �(�)
    ObjZav[Ptr].bParam[16] := not GetFR3(PutN,Nepar,Activ);//------------------------ �(�)

    z1 :=  not GetFR3(Ni,Nepar,Activ);//----------------------------------------------- ��

    z2 :=  not GetFR3(CHi,Nepar,Activ);//---------------------------------------------- ��

    ObjZav[Ptr].bParam[4] := GetFR3(CHkm,Nepar,Activ); //---------------------------- ���

    if MI_CH > 0 then  mic := not GetFR3(MI_CH,Nepar,Activ)//���� ���� ������ ��,���������
    else mic := true; //------------------------------------------------------ ����� ��(�)

    ObjZav[Ptr].bParam[15] := GetFR3(Nkm,Nepar,Activ); //----------------------------- ���

    if MI_N > 0 then min := not GetFR3(MI_N,Nepar,Activ) //------------------------- ��(�)
    else min := true;



    ObjZav[Ptr].bParam[7] := not GetFR3(PrZC,Nepar,Activ);//-------------- - ���� ��� STAN

    ObjZav[Ptr].bParam[11] := not GetFR3(PrZN,Nepar,Activ); //---- ����� ����� ��� �� STAN

    ObjZav[Ptr].bParam[31] := Activ; //--------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := Nepar; //------------------------------------ ��������������


    if  VidB > 0 then
    begin
      OVBuffer[VidB].Param[16] := Activ;
      OVBuffer[VidB].Param[1] := Nepar;
      if Activ and not Nepar then
      begin
        OVBuffer[VidB].Param[18] := (config.ru = ObjZav[ptr].RU) and  WorkMode.Upravlenie;
        if ObjZav[Ptr].bParam[3] <> z1 then //-------------------------- ���� �� ���������
        begin
          if ObjZav[Ptr].bParam[3] then
          begin
            ObjZav[Ptr].iParam[2] := 0;
            ObjZav[Ptr].bParam[8] := true; //--------------------------- ����� �����������
            ObjZav[Ptr].bParam[14] := false; //----------- ����� ��������������� ���������
          end;
        end;
        ObjZav[Ptr].bParam[3] := z1;  //----------------------------------------------- ��

        if ObjZav[Ptr].bParam[2] <> z2 then //-------------------------- ���� �� ���������
        begin
          if ObjZav[Ptr].bParam[2] then
          begin
            ObjZav[Ptr].iParam[3] := 0;
            ObjZav[Ptr].bParam[8] := true; //--------------------------- ����� �����������
            ObjZav[Ptr].bParam[14] := false; //----------- ����� ��������������� ���������
          end;
        end;
        ObjZav[Ptr].bParam[2] := z2;  //----------------------------------------------- ��

        if ObjZav[Ptr].bParam[5] <> mic then
        begin
          if ObjZav[Ptr].bParam[5] then
          begin
            ObjZav[Ptr].bParam[8] := true; //--------------------------- ����� �����������
            ObjZav[Ptr].bParam[14] := false; //----------- ����� ��������������� ���������
          end;
        end;
        ObjZav[Ptr].bParam[5] := mic;  //------------------------------------------- ��(�)

        if ObjZav[Ptr].bParam[6] <> min then
        begin
          if ObjZav[Ptr].bParam[6] then
          begin
            ObjZav[Ptr].bParam[8] := true; //--------------------------- ����� �����������
            ObjZav[Ptr].bParam[14] := false; //----------- ����� ��������������� ���������
          end;
        end;
        ObjZav[Ptr].bParam[6] := min;  //------------------------------------------- ��(�)

        //---------------------------------------- �������� �������� �� ������� ����������
        ObjZav[Ptr].bParam[9] := false;

        for i := 20 to 24 do //------------------------- �������� �� ������� ��������� ���
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin
          case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of //----------------- �� ���� ���
            25 : //---------------------------------------------------- ���������� �������
            if not ObjZav[Ptr].bParam[9] //----------------------------------- ���� ��� ��
            then ObjZav[Ptr].bParam[9] :=
            GetState_Manevry_D(ObjZav[Ptr].ObjConstI[i]);

            43 : //------------------------------------- ��� - ���������� ���� �� ��������
            if not ObjZav[Ptr].bParam[9] //----------------------------------- ���� ��� ��
            then ObjZav[Ptr].bParam[9] :=
            GetState_Manevry_D(ObjZav[ObjZav[Ptr].ObjConstI[i]].BaseObject);
          end;
        end;

        OVBuffer[VidB].Param[2] := ObjZav[Ptr].bParam[3]; //--------------------------- ��
        OVBuffer[VidB].Param[3] := ObjZav[Ptr].bParam[2]; //--------------------------- ��
{$IFDEF RMDSP}
        //------------------------------------------- �������� ��������� �� �������� �����
        OVBuffer[VidB].Param[4] := ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[16];
{$ELSE}
        if tab_page  then OVBuffer[VidB].Param[4]:=ObjZav[Ptr].bParam[1] //--- ��������� �
        else OVBuffer[VidB].Param[4] := ObjZav[Ptr].bParam[16]; //------------ ��������� �
{$ENDIF}
        OVBuffer[VidB].Param[5] := ObjZav[Ptr].bParam[4];   //------------------------ ���
        OVBuffer[VidB].Param[7] := ObjZav[Ptr].bParam[15];  //------------------------ ���
        OVBuffer[VidB].Param[9] := ObjZav[Ptr].bParam[9];   //------------------------- ��
        OVBuffer[VidB].Param[10] := ObjZav[Ptr].bParam[5]  and ObjZav[Ptr].bParam[6];// ��
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if not ObjZav[Ptr].bParam[14] then //--- ���� ��� ����������� ��������� � �� ���
          begin
            if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then //��, �� � FR3
            begin
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin //--------------------------------- ������� ���������� ������ ����� ������
              OVBuffer[VidB].Param[14] := false;
              OVBuffer[VidB].Param[6] := ObjZav[Ptr].bParam[8];
            end;
          end else
          begin
            if not ObjZav[Ptr].bParam[7] or not ObjZav[Ptr].bParam[11] then
            begin //--------------------------------------------------------------- �� FR3
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin
              OVBuffer[VidB].Param[14] := false;
              if tab_page then  OVBuffer[VidB].Param[6] := true//
              else OVBuffer[VidB].Param[6] :=  ObjZav[Ptr].bParam[8]; //------- �� �������
            end;
          end;
        end else
        begin //------------------------------------------------------------------- �� FR3
{$ENDIF}
          OVBuffer[VidB].Param[6] := ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[11];
          OVBuffer[VidB].Param[14]:= not OVBuffer[VidB].Param[6];
{$IFDEF RMDSP}
        end;
{$ENDIF}

        sost1 := GetFR5(PutCH  div 8);

        if (PutN > 0) and (PutCH <> PutN) then sost2 := GetFR5(PutN div 8)//��������� ����
        else sost2 := 0;

        sost := sost1 or sost2;

        //�������� ������� ���������� ������� ����������� �� ������ ������������ �� 1 ���.
        ObjZav[Ptr].Timers[1].Active := ObjZav[Ptr].Timers[1].First < LastTime;

        if (sost > 0) and
        ((sost <> byte(ObjZav[Ptr].iParam[4])) or ObjZav[Ptr].Timers[1].Active) then
        begin
          ObjZav[Ptr].iParam[4] := SmallInt(sost);
{$IFDEF RMSHN}
          //-------------------------------- ������������� ����� ���������� ����������� ��
          ObjZav[Ptr].Timers[1].First := LastTime + 1 / 86400;
{$ELSE}
          //------------------------------- ������������� ����� ���������� ����������� ���
          ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400;
{$ENDIF}
          if (sost and 4) = 4 then
          begin //---------------------------------------- ��������� ���������� ����� ����
{$IFDEF RMSHN}
              InsArcNewMsg(Ptr,397+$1000,0);
//            SingleBeep := true;
              ObjZav[Ptr].bParam[19] := true;
              ObjZav[Ptr].dtParam[3] := LastTime;
              inc(ObjZav[Ptr].siParam[3]);
{$ELSE}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,397+$1000,0);
                AddFixMessage(GetShortMsg(1,397,ObjZav[Ptr].Liter,0),4,1);
              end;
              //----------------------- ����������� ������������� ���� �������� ����������
              ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie;
{$ENDIF}
            end;

            if (sost and 1) = 1 then
            begin //--------------------------------------- ��������� �o���� ��������� ����
{$IFDEF RMSHN}
              InsArcNewMsg(Ptr,394+$1000,0);
              ObjZav[Ptr].bParam[19] := true;
              ObjZav[Ptr].dtParam[1] := LastTime;
              inc(ObjZav[Ptr].siParam[1]);
{$ELSE}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,394+$1000,0);
                AddFixMessage(GetShortMsg(1,394,ObjZav[Ptr].Liter,0),4,1);
              end;
              ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; // ����������� ��� ����������
{$ENDIF}
            end;
            if (sost and 2) = 2 then
            begin //------------------------------------ ��������� ������ ����������� ����
{$IFDEF RMSHN}
              InsArcNewMsg(Ptr,395+$1000,0);
              ObjZav[Ptr].dtParam[2] := LastTime;
              inc(ObjZav[Ptr].siParam[2]);
{$ELSE}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,395+$1000,0);
                AddFixMessage(GetShortMsg(1,395,ObjZav[Ptr].Liter,0),4,1);
              end;
              ObjZav[Ptr].bParam[19] := WorkMode.Upravlenie; //- ����������� �������������
{$ENDIF}
            end;
          end;
        end;

        OVBuffer[VidB].Param[13] := ObjZav[Ptr].bParam[19];

        //---------------------------------------------------------------------------- FR4
        ObjZav[Ptr].bParam[12] := GetFR4State(PutCH div 8 * 8 + 2);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VidB].Param[32] := ObjZav[Ptr].bParam[13]
          else OVBuffer[VidB].Param[32] := ObjZav[Ptr].bParam[12];
        end else
{$ENDIF}
        OVBuffer[VidB].Param[32] := ObjZav[Ptr].bParam[12];

        if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
        begin //--------------------------------------------------------- ���� �����������
          ObjZav[Ptr].bParam[27] := GetFR4State(PutCH div 8 * 8 + 3);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
          begin
            if tab_page then OVBuffer[VidB].Param[29] := ObjZav[Ptr].bParam[24]
            else OVBuffer[VidB].Param[29] := ObjZav[Ptr].bParam[27];
          end else
{$ENDIF}
          OVBuffer[VidB].Param[29] := ObjZav[Ptr].bParam[27];

          if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
          begin //------------------------------------------------ ���� 2 ���� �����������
            ObjZav[Ptr].bParam[28] := GetFR4State(PutCH div 8 * 8);
{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
            begin
              if tab_page
              then OVBuffer[VidB].Param[31] := ObjZav[Ptr].bParam[25]
              else OVBuffer[VidB].Param[31] := ObjZav[Ptr].bParam[28];
            end else
{$ENDIF}
            OVBuffer[VidB].Param[31] := ObjZav[Ptr].bParam[28];
            ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[1] div 8 * 8 + 1);

{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
            begin
              if tab_page then OVBuffer[VidB].Param[30] := ObjZav[Ptr].bParam[26]
              else OVBuffer[VidB].Param[30] := ObjZav[Ptr].bParam[29];
            end else
{$ENDIF}
              OVBuffer[VidB].Param[30] := ObjZav[Ptr].bParam[29];
          end;
        end;
      end;
    except
{$IFNDEF RMARC}
      reportf('������ [MainLoop.PrepPuti]');
{$ENDIF}
      Application.Terminate;
    end;
end;
 //========================================================================================
//------------------------------------ ���������� ������� ��������� ��� ������ �� ����� #5
procedure PrepSvetofor(Ptr : Integer);
var
  i,j,VidBuf : integer;
  n,o,zso,so,jso,vnp,kz,Nepar,Aktiv : boolean;
  sost : Byte;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    ObjZav[Ptr].bParam[1] :=  //-------------------------------------- ��1 (�� ����������)
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[2] := //------------------------------------------------------- ��2
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[3] := //------------------------------------------ �1 (�� ��������)
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[4] := //-------------------------------------------------------- �2
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    o :=   //-------------------------------------------------------------------- �������
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[6] := //---------------------------- ������� "���������� ������ ��"
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[8] := //------------------------------- ������� "�������� ������ �"
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[10] := // �� -------------------------- ��������� ������� ���������
    GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

    if ObjZav[Ptr].bParam[4] and //---------------------- ���� ������� �2 - �������� � ...
    (ObjZav[Ptr].BaseObject = 0) then  //-------------------------- ��� ����������� ������
    begin
      ObjZav[Ptr].bParam[9] := false;
      ObjZav[Ptr].bParam[14] := false;
    end;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      VidBuf := ObjZav[Ptr].VBufferIndex;

      OVBuffer[VidBuf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[VidBuf].Param[1] := ObjZav[Ptr].bParam[32];

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then // ������� � ���������
      begin
        OVBuffer[VidBuf].Param[18] := (config.ru = ObjZav[ptr].RU);//����� ���-��� �������

        inc(LiveCounter);

//---------------------------------------------------------------- ��������� �������� ����
        if o <> ObjZav[Ptr].bParam[5] then //------------- ������� ���� �������� ���������
        begin
          if o then //---------------------------------- ������������� ��������� ���������
          begin
            if ObjZav[Ptr].Timers[3].Active = false then  //------- ���� ������ �� �������
            begin
              ObjZav[Ptr].Timers[3].Active := true;
              ObjZav[Ptr].Timers[3].First := LastTime;
            end else //------------------------------- ���� ������ ��� ����� �������������
            begin
              if (LastTime - ObjZav[Ptr].Timers[3].First) > 5/80000 then//������ 2 �������
              begin
                if not ObjZav[Ptr].bParam[2] and //---------------------- ������ ��2 � ...
                not ObjZav[Ptr].bParam[4] then//-------------------------------- ������ �2
                begin
                  if WorkMode.FixedMsg then //------------- ���� ������ � ��������� ������
                  begin
{$IFDEF RMDSP}
                    if config.ru = ObjZav[ptr].RU then //------- ���� ��� ����� ����������
                    begin
                      if ObjZav[Ptr].bParam[10] then //----- ���� ������� ������ ���������
                      begin
                        //-------------"������������� �������� ���� ��������� ��������� $"
                        InsArcNewMsg(Ptr,481+$1000,1);
                        AddFixMessage(GetShortMsg(1,481, ObjZav[ptr].Liter,1),4,4);
                      end else
                      begin
                        InsArcNewMsg(Ptr,272+$1000,0);//---------- "���������� �������� $"
                        AddFixMessage(GetShortMsg(1,272, ObjZav[ptr].Liter,0),4,4);
                      end;
                    end;
{$ELSE}
                    if ObjZav[Ptr].bParam[10] then
                    InsArcNewMsg(Ptr,481+$1000,0) //---------- "���������� ������ ���������"
                    else   InsArcNewMsg(Ptr,272+$1000,0); //--- ���������� ����������� �����
                    SingleBeep4 := true;
                    ObjZav[Ptr].dtParam[1] := LastTime;
                    inc(ObjZav[Ptr].siParam[1]);
{$ENDIF}
                    ObjZav[Ptr].bParam[5] := o;  //----- �������� �������� �������� ���� �
                  end;   //----------------------------------------------- ����� ��������
                end;//-------------------------------------------- ����� ��������� �������

                ObjZav[Ptr].bParam[20] := false; //-------- ����� ���������� �������������
                ObjZav[Ptr].Timers[3].Active := false;
                ObjZav[Ptr].Timers[3].First := 0;

              end;//-------------------------------------------------- ����� ������� 2 ���
            end; //----------------------------------------------- ����� ������� ���������
          end else //---------------------------------------------- ����� ��������� = true
          begin
            ObjZav[Ptr].Timers[3].Active := false;
            ObjZav[Ptr].Timers[3].First :=0;
            ObjZav[Ptr].bParam[5] := o;  //------------- �������� �������� �������� ���� �
          end;
        end;
//------------------------------------------------------------ ����� ������ � ������� ����

        if ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[3] or //-------- ��1 ��� �1 ��� ...
        ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[4] then //----------------- ��2 ��� �2
        begin //---------------------------------------------- ������ ��� �������� �������
          for i := 1 to 10 do //---------------------------- �������� ���� ��������� �����
          begin
            if MarhTracert[i].SvetBrdr = Ptr then //------ ������ ������ �������� � ������
            begin
              for j := 1 to 10 do MarhTracert[i].MarhCmd[j] := 0;
              ObjZav[Ptr].bParam[14] := false; //-- �������� ����������� ��������� �������
              ObjZav[Ptr].bParam[7] := false;//--- �������� ���������� ����������� �������
              ObjZav[Ptr].bParam[9] := false;//----- �������� �������� ����������� �������
              j := MarhTracert[i].HTail; //------------------------- �������� ����� ������
              ObjZav[j].bParam[14] := false; //-------- ����� ����������� ��������� ������
              ObjZav[j].bParam[7] := false;//------ �������� ���������� ����������� ������
              ObjZav[j].bParam[9] := false;//-------- �������� �������� ����������� ������
              j := MarhTracert[i].PutPriem;
              ObjZav[j].bParam[14] := false; //---------- ����� ����������� ��������� ����
              ObjZav[j].bParam[7] := false;//-------- �������� ���������� ����������� ����
              ObjZav[j].bParam[9] := false;//---------- �������� �������� ����������� ����
            end;
          end;

          ObjZav[Ptr].iParam[1] := 0; //------------------------- �������� ������ ��������
          ObjZav[Ptr].bParam[34] := false; //---------- �������� ������� ������ �� �������



          if(((ObjZav[Ptr].iParam[10] and $4) = 0) and //���� ��� �������� ������������� �
          (((ObjZav[Ptr].bParam[1] and //--------------------------------------- ��1 � ...
          ObjZav[Ptr].bParam[3]) and // ----------------------------------------- �1 � ...
          not ObjZav[Ptr].ObjConstB[22]) //--------------------------------- ��� ������ ��
          or //------------------------------------------------------------------- ��� ...
          (ObjZav[Ptr].bParam[2] and ObjZav[Ptr].bParam[4]))) then //------------ ��2 � �2
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,300+$1000,1);//"���������� ����������� ����� ��������� $"
                AddFixMessage(GetShortMsg(1,300, ObjZav[ptr].Liter,1),4,4)
              end;
{$ELSE}
              InsArcNewMsg(Ptr,300+$1000,1);
{$ENDIF}
            end;
            ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $4;//--- �������� �������
          end;
        end
        else ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FFFB;//- ����� ��������

//----------------------------------------------------------------------------------------
        if ObjZav[Ptr].BaseObject > 0 then //---------------- ���� ���� ����������� ������
        begin
          if ObjZav[Ptr].bParam[11] <> ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
          begin //------------------------------------------ ��������� � ������ ����������
            if ObjZav[Ptr].bParam[11] then  //-------------- ���� ������ ��������� �� ����
            begin
              ObjZav[Ptr].iParam[1] := 0;  //-------------------- �������� ������ ��������
              ObjZav[Ptr].bParam[34] := false; //------ �������� ������� ������ �� �������
            end else
            begin //------------------------ ���� ������ ���� ��������� ����������� ������
              ObjZav[Ptr].bParam[14] := false; //------------- ����� ����������� ���������
              ObjZav[Ptr].bParam[7] := false;  //------------ ����� ���������� �����������
              ObjZav[Ptr].bParam[9] := false;  //-------------- ����� �������� �����������
              ObjZav[Ptr].iParam[2] := 0;      //-------------------------------- ����� ��
              ObjZav[Ptr].iParam[3] := 0;      //-------------------------------- ����� ��
            end;
            ObjZav[Ptr].bParam[11] := ObjZav[ObjZav[Ptr].BaseObject].bParam[2];//- ����� �
          end;
        end;

//========================================================================================
//------------------------------------------------ �������� �������� �� ������� ����������
        ObjZav[Ptr].bParam[18] := false;  //---------------- �������� �������� "�� ��� ��"
        ObjZav[Ptr].bParam[21] := false; //---------------------------------- �������� ���

        for i := 20 to 24 do //---------------------------- ������ �� ��������� ������� ��
        begin
          j := ObjZav[Ptr].ObjConstI[i];

          if j > 0 then //------------------------------ ���� ���� �������������� � ������
          begin
            case ObjZav[j].TypeObj of //--------------------- ������������� �� ���� ������
              25 :
              begin //-------------------------------------------- �� (���������� �������)
                if not ObjZav[Ptr].bParam[18] then //------------------ ���� ��� "�� | ��"
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(j); //---- �������� "�� | ��"

                if ObjZav[Ptr].ObjConstB[18] and //------------- ���� ���������� ��� � ...
                not ObjZav[Ptr].bParam[21] then //------------------------ � ��� �� ������
                begin //------------------------------------------------------ ������� ���
                  ObjZav[Ptr].bParam[21] := ObjZav[j].bParam[1] and     //------- �� � ...
                                          not ObjZav[j].bParam[4] and //--------------- ��
                                          ObjZav[j].bParam[5];        //--- � (����������)
                end;

                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[j].bParam[3]; //---------------------------------- ��&�� ��� ��
              end;

              43 :
              begin //---------------------------------------------------------------- ���
                if not ObjZav[Ptr].bParam[18] then
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);

                if ObjZav[Ptr].ObjConstB[18] and //------------- ���� ���������� ��� � ...
                not ObjZav[Ptr].bParam[21] then //---------------------------- ��� = false
                begin //------------------------------------------------------ ������� ���
                  ObjZav[Ptr].bParam[21] :=
                  ObjZav[ObjZav[j].BaseObject].bParam[1] and //------------------------ ��
                  not ObjZav[ObjZav[j].BaseObject].bParam[4] and //-------------------- ��
                  ObjZav[ObjZav[j].BaseObject].bParam[5] and     //--------------------- �
                  not ObjZav[j].bParam[2]; //----------------------------------------- ���
                end;
                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[ObjZav[j].BaseObject].bParam[3]; //--------------- ��&�� ��� ��
              end;

              48 :
              begin //---------------------------------------------------------------- ���
                if not ObjZav[Ptr].bParam[18] then
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
                if ObjZav[Ptr].ObjConstB[18] and //------------- ���� ���������� ��� � ...
                not ObjZav[Ptr].bParam[21] then //---------------------------- ��� = false
                begin //------------------------------------------------------ ������� ���
                  ObjZav[Ptr].bParam[21] :=
                  ObjZav[ObjZav[j].BaseObject].bParam[1] and //------------------------ ��
                  not ObjZav[ObjZav[j].BaseObject].bParam[4] and //-------------------- ��
                  ObjZav[ObjZav[j].BaseObject].bParam[5] and     //--------------------- �
                  ObjZav[j].bParam[1]; //----------------------------- ���� ������ �� ����
                end;
                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[ObjZav[j].BaseObject].bParam[3]; //--------------- ��&�� ��� ��
              end;

              52 :
              begin //-------------------------------------------------------------- �����
                if not ObjZav[Ptr].bParam[18] then
                ObjZav[Ptr].bParam[18] := GetState_Manevry_D(ObjZav[j].BaseObject);
                if ObjZav[Ptr].ObjConstB[18] and not ObjZav[Ptr].bParam[21] then
                begin //------------------------------------------------------ ������� ���
                  ObjZav[Ptr].bParam[21] :=
                  ObjZav[ObjZav[j].BaseObject].bParam[1] and //------------------------ ��
                  not ObjZav[ObjZav[j].BaseObject].bParam[4] and //-------------------- ��
                  ObjZav[ObjZav[j].BaseObject].bParam[5] and //------------------------- �
                  ObjZav[j].bParam[1]; //-------------- ���� ������ �� ���������� ��������
                end;
                ObjZav[Ptr].bParam[18] := ObjZav[Ptr].bParam[18] or
                not ObjZav[ObjZav[j].BaseObject].bParam[3]; //--------------- ��&�� ��� ��
              end;
            end; //--------------------------------- ����� ������������� �� ���� ������ ��
          end; //---------------------------------------- ����� �������������� � ������ ��
        end; //------------------------------------- ����� ������� �� ��������� ������� ��

        if (ObjZav[Ptr].iParam[2] = 0) and //---------------------------------- ������� ��
        (ObjZav[Ptr].iParam[3] = 0) and //------------------------------------ ������� ��
        not ObjZav[Ptr].bParam[18] then //------------------------------------ ������� ��
        begin //------------------------------- �������������� ���������� ����������� ����
          if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then // ���� ����������� �� ��������
          begin //----------------------- ����� ������� ��� ����������� ����������� ������
            ObjZav[Ptr].Timers[1].Active := false;
          end else  //------------------------------------------ ����������� ������ ������
          if ObjZav[Ptr].bParam[4] then //-------------------------- ���� ������ ������ �2
          begin //---------------------------------------------------------- ������ ������
            if not ObjZav[Ptr].Timers[1].Active then //----------------- ������ �� �������
            begin //--------------------------------------------- ��������� ������ �������
              ObjZav[Ptr].Timers[1].Active := true;
              ObjZav[Ptr].Timers[1].First := LastTime;
            end;
          end else
          begin //------------------------------------------------------ ������ ����������
            if ObjZav[Ptr].Timers[1].Active then
            begin
              ObjZav[Ptr].Timers[1].Active := false;
{$IFDEF RMSHN}
              ObjZav[Ptr].dtParam[6] := LastTime - ObjZav[Ptr].Timers[1].First;
{$ENDIF}
            end;
          end;
        end;

        if (ObjZav[Ptr].iParam[2] = 0) and //---------------------------------- ������� ��
        (ObjZav[Ptr].iParam[3] = 0) and //------------------------------------- ������� ��
        not ObjZav[Ptr].bParam[18]      //------------------------------------- ������� ��
{$IFDEF RMDSP}
        and (ObjZav[Ptr].RU = config.ru) //------ � ��-��� - ��������� ������������ ������
        and WorkMode.Upravlenie          //-------------------------- � ������� ����������
{$ENDIF}
        then
        begin //-------------------------------------------------- �������� ������ �������
          if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
          begin //--------------------------------------- ��� ��������� ����������� ������
            if not ObjZav[Ptr].Timers[1].Active and
            not ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[9] then
            begin //---------------- ��� �������� ������������� ��������� ����������� ����
              if ObjZav[Ptr].bParam[4] then
              begin //------------------------------------------------------------- ���� �
                if((ObjZav[Ptr].iParam[10] and $2) = 0) then
                begin //----------------------------- ��� �������� ������������� ���������
                  if WorkMode.FixedMsg then
                  begin
                    InsArcNewMsg(Ptr,510+$1000,0);
                    //---------- "������������� �������� ������� $ ��� ��������� ��������"
                    AddFixMessage(GetShortMsg(1,510,ObjZav[Ptr].Liter,0),4,1);
                  end;
                end;
                ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $2;
              end
              else ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FFD;
            end;

            if ObjZav[Ptr].bParam[2] then //------------------------------ ���� ������ ��2
            begin
              if not ObjZav[Ptr].bParam[6] and //---- ��� ������ �������� �� ������� � ...
              not ObjZav[Ptr].bParam[7] then //---------------- ��� ���������� �����������
              begin //---------------------------------------- ���� �� ��� ������ ��������
                if ObjZav[Ptr].Timers[2].Active then //--------------- ���� ������� ������
                begin //-------------- �������� ������������� ����������� ����������� ����
                  if LastTime > ObjZav[Ptr].Timers[2].First then //-- ����� �������� �����
                  begin
                    if ((ObjZav[Ptr].iParam[10] and $1) = 0) then //--------- ��� ��������
                    begin
                      if WorkMode.FixedMsg then
                      begin
                        //-------- ������������� �������� ������� $ ��� ��������� ��������
                        InsArcNewMsg(Ptr,510+$1000,0);
                        AddFixMessage(GetShortMsg(1,510,ObjZav[Ptr].Liter,0),4,1);
                        ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $1;
                      end;
                    end;
                  end;
                end else
                begin //---------- ��� �������� ������������� ����������� ����������� ����
                  ObjZav[Ptr].Timers[2].First := LastTime + 5 / 86400;
                  ObjZav[Ptr].Timers[2].Active := true;
                end;
              end;
            end  else
            begin
              ObjZav[Ptr].Timers[2].Active := false;//---- ����� �������,���������� ������
              ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FFFE;
            end;
          end else //------------------------------------------ ���� ��������� �����������
          if ObjZav[Ptr].bParam[6] or//-------------------- ���� ������� �� �� ������� ���
          ObjZav[Ptr].bParam[8] then //------------------------- ���� ������� � �� �������
          begin
            if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then //- ������ ����������� ��
            begin
              if not ObjZav[Ptr].bParam[27] then //--- �� ����������� ������� �� � �������
              begin
                if not (ObjZav[Ptr].bParam[2] //-------------------- ��� ��������� ��2 ...
                or ObjZav[Ptr].bParam[4]) then //-------------------- ��� ��� ��������� �2
                begin //---------------------------------------------------- ������ ������
                  if WorkMode.FixedMsg then
                  begin
                    InsArcNewMsg(Ptr,509+$1000,0);//------ ������� ��  �� �������� �������
                    AddFixMessage(GetShortMsg(1,509,ObjZav[Ptr].Liter,0),4,1);
                    ObjZav[Ptr].bParam[19] := true; //--------- ��������� ������� ��������
                  end;
                end;
                ObjZav[Ptr].bParam[27] := true; //--- ��������� ������� ����������� ������
              end;
            end;
          end;
        end;

        if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then //--- �������� ����������� ������
        ObjZav[Ptr].bParam[27] := false;//- ����� �������� �������� ������� ����������� ��

        if ObjZav[Ptr].ObjConstI[28] > 0 then
        begin //-------------------------------- ���������� ��������� ������������ �������
          OVBuffer[VidBuf].Param[31] := ObjZav[ObjZav[Ptr].ObjConstI[28]].bParam[1];
        end else OVBuffer[VidBuf].Param[31] := false;

        OVBuffer[VidBuf].Param[3] :=  //-------------------------  ���������� ������ �����
        ObjZav[Ptr].bParam[2] or ObjZav[Ptr].bParam[21]; //- ���������� ��� ��� ������� OZ

        OVBuffer[VidBuf].Param[5] := ObjZav[Ptr].bParam[4];//-------------------- ��������
        OVBuffer[VidBuf].Param[6] := ObjZav[Ptr].bParam[5];//------------------- ���������

        if not ObjZav[Ptr].bParam[2] and  //-------------------- ������ ���������� � ...
        not ObjZav[Ptr].bParam[4] and //-------------------------- ������ �������� � ...
        not ObjZav[Ptr].bParam[21] then //-------------------------------------- ��� ���
        begin
          OVBuffer[VidBuf].Param[2] := ObjZav[Ptr].bParam[1]; //- ������� � ���������� ���

          OVBuffer[VidBuf].Param[4] := ObjZav[Ptr].bParam[3]; //- � ���������� �������� ��

          if not ObjZav[Ptr].bParam[1] and
          not ObjZav[Ptr].bParam[3] then //-------------------------- ���� ��� �������� ��
          begin
            if WorkMode.Upravlenie then //----------------------------- ���� ��� ���������
            begin
              if not ObjZav[Ptr].bParam[14] and //----------- ��� ������������ ��������� �
              ObjZav[Ptr].bParam[7] then    //------------------------- ���� �����������
              begin //--------------------------------- ��� ����������� ������� ����������
                OVBuffer[VidBuf].Param[11] := ObjZav[Ptr].bParam[7]; //-------- �� �������
              end else

              //-------- ����� ������������ ������� ������ �������� ��� �������� �� "STAN"
              if tab_page then //-------------- �������� ������ ������� ��������� ��������
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //����������� ������ �
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then //- ����������� ��������
                OVBuffer[VidBuf].Param[11]:=false //--- ����� ������. ������ � �����������
                else
                OVBuffer[VidBuf].Param[11]:=//--- ����� ���������� ������ ����� ������� ��
                ObjZav[Ptr].bParam[6] and   //--------------------- �� �� FR3 (stan) � ...
                not ObjZav[Ptr].bParam[34] //------------------  ��� ������ ������ �������
              end else
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //����������� ������ �
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then //- ����������� ��������
                OVBuffer[VidBuf].Param[11] := false //---- ����� ���������� ������ � �����
                else OVBuffer[VidBuf].Param[11] := //-- ���������� ������ ����� ������� ��
                ObjZav[Ptr].bParam[7]; //---------------------------------- ��� �� �������
              end;
            end
            else //------------------------------------------ ���� ��� ���������� �� ����
            OVBuffer[VidBuf].Param[11] := ObjZav[Ptr].bParam[6];//���������� ������ �� FR3

            if WorkMode.Upravlenie then //----------------------------- ���� ��� ���������
            begin
              if not ObjZav[Ptr].bParam[14] and //------- ��� ������������ ��������� � ...
              ObjZav[Ptr].bParam[9] then //------------------ ���� ����������� ��� �� ����
              begin // ��� ����������� ������� ����������
                OVBuffer[VidBuf].Param[12] := //--------- �������� ������ ����� ������� ��
                ObjZav[Ptr].bParam[9]; //------------ �� �������� ����������� ������� ����
              end else //------------------------------ ��� ������� ������������ ���������

              //-------- ����� ������������ ������� ������ �������� ��� �������� �� "STAN"
              if tab_page then //-------------- �������� ������ ������� ��������� ��������
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //����������� ������ �
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then  // ����������� ��������
                OVBuffer[VidBuf].Param[12] := false //------ ����� �������� ������ � �����
                else
                OVBuffer[VidBuf].Param[12] := //---- ����� ������� ������ ����� ������� ��
                ObjZav[Ptr].bParam[8] and //------------------- ������ � �� FR3 ("stan") �
                not ObjZav[Ptr].bParam[34] //---------------------- ���� ��� ������ ������
              end else
              begin
                if not ObjZav[ObjZav[Ptr].BaseObject].bParam[1] and //����������� ������ �
                not ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then  // ����������� ��������
                OVBuffer[VidBuf].Param[12]:=false //-------- ����� �������� ������ � �����
                else
                OVBuffer[VidBuf].Param[12] := ObjZav[Ptr].bParam[9]; //�� ��� ������� ����
              end;
            end else //------------------------------------------- ���� ��� ����������, ��
            OVBuffer[VidBuf].Param[12] := ObjZav[Ptr].bParam[8]; //------- ������ � �� FR3
          end else //------------------------------------------------------- ���� ����� ��
          begin
            OVBuffer[VidBuf].Param[11] := false;//---------- ����� ���������� ������ �����
            OVBuffer[VidBuf].Param[12] := false;//------------ ����� �������� ������ �����
          end;
        end else //-------------------------------------- ������ �����-���� ������ ��� ���
        begin
          OVBuffer[VidBuf].Param[2] := false; //------------------------- ������ ��� �����
          OVBuffer[VidBuf].Param[4] := false;//-------------------------- ������ ��� �����
          OVBuffer[VidBuf].Param[11] := false;//-------------------- ������ � ������ �����
          OVBuffer[VidBuf].Param[12] := false;//-------------------- ������ � ������ �����
        end;

        sost := GetFR5(ObjZav[Ptr].ObjConstI[1]);
        if (ObjZav[Ptr].iParam[2] = 0) and //������ ���� ��� �������� ������� (������� ��)
        (ObjZav[Ptr].iParam[3] = 0) and //---- ������ ���� ��� �������� ������� ������� ��
        not ObjZav[Ptr].bParam[18] then //------------------------------------- ������� ��
        begin //- �������� ���������� �������, ���� �� ���������� ������� ������� �� �����
          if ((sost and 1) = 1) and not ObjZav[Ptr].bParam[18] then
          begin //----------------------------------------- ��������� ���������� ���������
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then
            begin
{$ENDIF}
              if WorkMode.OU[0] then
              begin //------------------------------ ���������� � ������ ���������� � ����
                InsArcNewMsg(Ptr,396+$1000,0); //------------ "������������� ���������� $"
                AddFixMessage(GetShortMsg(1,396,ObjZav[Ptr].Liter,0),4,1);
              end else
              begin //---------------------------- ���������� � ������ ���������� � ������
                InsArcNewMsg(Ptr,403+$1000,0); //------- "������������� ���������� $ (��)"
                AddFixMessage(GetShortMsg(1,403,ObjZav[Ptr].Liter,0),4,1);
              end;
{$IFDEF RMDSP}
            end;
            ObjZav[Ptr].bParam[23] :=
            WorkMode.Upravlenie and WorkMode.OU[0]; //�����������,���� �������� ����������
{$ENDIF}
{$IFNDEF RMDSP}
            ObjZav[Ptr].dtParam[2] := LastTime;
            inc(ObjZav[Ptr].siParam[2]);
            ObjZav[Ptr].bParam[23] := true; //------------------ ����������� �������������
{$ENDIF}
          end;
        end
        else  ObjZav[Ptr].bParam[23] := false; //���� ���� ��� �� - ����� �������� �������
        inc(LiveCounter);
        //--------------------------------------------------------{FR4}-------------------
        ObjZav[Ptr].bParam[12] := //-------------- ���������� ��� ����� ���������� �������
        GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
  {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU=config.ru) then//���������� � �����  ��
        begin
          if tab_page
          then OVBuffer[VidBuf].Param[32] := ObjZav[Ptr].bParam[13] //------- ���� �� ����
          else OVBuffer[VidBuf].Param[32] :=  ObjZav[Ptr].bParam[12]; //----- ���� �� STAN
        end else
{$ENDIF}
        OVBuffer[VidBuf].Param[32] := ObjZav[Ptr].bParam[12]//----------------- ����� STAN
      end;

      //------------------------ � ����� ������ ------------------------------------------
      OVBuffer[VidBuf].Param[13] := ObjZav[Ptr].bParam[23]; //----------------- ����������

      Aktiv := true; // �����������2
      Nepar:= false; // ��������������2
      ObjZav[Ptr].bParam[30] := false;

      jso := GetFR3(ObjZav[Ptr].ObjConstI[9],Nepar,Aktiv);//-------------------------- ���
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      zso :=  GetFR3(ObjZav[Ptr].ObjConstI[10],Nepar,Aktiv);//------------------------ ���
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      so :=  GetFR3(ObjZav[Ptr].ObjConstI[25],Nepar,Aktiv);//-------------------------- Co
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      vnp := GetFR3(ObjZav[Ptr].ObjConstI[26],Nepar,Aktiv);//------------------------- ���
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      n :=   GetFR3(ObjZav[Ptr].ObjConstI[11],Nepar,Aktiv);//--------------------------- �
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      kz := GetFR3(ObjZav[Ptr].ObjConstI[30],Nepar,Aktiv);//--------------------------- ��
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] :=  Nepar;
      ObjZav[Ptr].bParam[30] := ObjZav[Ptr].bParam[30] or Nepar; //----- �������������� 2

      if not ObjZav[Ptr].bParam[30] then //---------------------------- ���� ������������2
      begin
        if jso <> ObjZav[Ptr].bParam[15] then
        begin //-------------------------------------------------------- ��������� ���(��)
          if jso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                if ObjZav[Ptr].ObjConstI[10] = 0 then //--- ���� � ������� ��� ������� ���
                begin
                  if ObjZav[Ptr].bParam[4] then //------------------- ���� ������ ��������
                  InsArcNewMsg(Ptr,300+$1000,1)// "������������� ������. ���� ��������� $"
                end
                else //---------------------------------------------- ���� ���� ������ ���
                begin
                  if ObjZav[Ptr].bParam[4] then //------------------- ���� ������ ��������
                  InsArcNewMsg(Ptr,485+$1000,0)// ������. ���.���� ����� ����� ��������� $
                end;
              end;
{$ELSE}       //----------------------------- ����� ��� ��� �� ---------------------------
              if ObjZav[Ptr].ObjConstI[10] = 0 then  //---- ���� � ������� ��� ������� ���
              begin
                if ObjZav[Ptr].bParam[4]
                then InsArcNewMsg(Ptr,300+$1000,0); //������������� ������. ���� ��������� $
              end else
              begin
                if ObjZav[Ptr].bParam[4]
                then InsArcNewMsg(Ptr,485+$1000,0);
                //----------- "������������� �������� ���� ����� ������� ���� ��������� $"
              end;
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[3] := LastTime;
              inc(ObjZav[Ptr].siParam[3]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- ����� ���������� �������������
        end;
        ObjZav[Ptr].bParam[15] := jso; //---------------------------- ��������� ������� ��

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if zso <> ObjZav[Ptr].bParam[24] then
        begin //------------------------------------------------------------ ��������� ���
          if zso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                if ObjZav[Ptr].bParam[4] then //-------------------------- ������ ��������
                begin
                  InsArcNewMsg(Ptr,486+$1000,0);//"���������� �������� ���� ������� �����"
                  AddFixMessage(GetShortMsg(1,486,ObjZav[Ptr].Liter,0),4,4);
                  SingleBeep4 := true;
                end;
              end;
{$ELSE}       //--------------------------------------------------------- ����� ��� ��� ��
              if ObjZav[Ptr].bParam[4] then
              InsArcNewMsg(Ptr,486+$1000,0);
              //-------------- ������������� �������� ���� ����� �������� ���� ��������� $
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[3] := LastTime;
              inc(ObjZav[Ptr].siParam[3]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- ����� ���������� �������������
        end;
        ObjZav[Ptr].bParam[24] := zso; //--------------------------------------------- ���

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if vnp  and ObjZav[Ptr].bParam[4] then //------------------- ��� � ������ ��������
        begin
          if ObjZav[Ptr].Timers[4].Active = false then  //----- ���� ������ �� ��� �������
          begin
            ObjZav[Ptr].Timers[4].Active := true; //--------------------- ��������� ������
            ObjZav[Ptr].Timers[4].First := LastTime; //-------------- ������������� ������
            ObjZav[Ptr].Timers[4].Second := LastTime + 2/86400; //-------- ��������� �����
          end else
          begin //---------------------------------------------- ���� ������ �������������
            if vnp and (ObjZav[Ptr].Timers[4].Second < LastTime) then   //---- ����� �����
            begin
              ObjZav[Ptr].Timers[4].Active := false;
              ObjZav[Ptr].Timers[4].First := 0;
              ObjZav[Ptr].Timers[4].Second := 0;
              if vnp then
              begin
                if ( WorkMode.FixedMsg and ((ObjZav[Ptr].iParam[10] and $80) = 0)) then
                begin
{$IFDEF RMDSP}
                  if ObjZav[Ptr].RU = config.ru then
                  begin
                    InsArcNewMsg(Ptr,300+$1000,1);//- "���������� ����������� ��������� $"
                    AddFixMessage(GetShortMsg(1,300,ObjZav[Ptr].Liter,1),4,4);
                    ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $80; //�������� NN
                  end;
                end;
{$ELSE}
                  InsArcNewMsg(Ptr,300+$1000,1);
                  SingleBeep4 := true;
                  ObjZav[Ptr].dtParam[3] := LastTime;
                  inc(ObjZav[Ptr].siParam[3]);
                  ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $80; //- �������� NN
                end;
{$ENDIF}
                ObjZav[Ptr].bParam[25] := vnp;
              end;
            end else
            begin
              ObjZav[Ptr].bParam[25] := vnp;
              ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FF7F; //����� ��������
            end;
          end;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if so and ObjZav[Ptr].bParam[4] then //---------------------- �� � ������ ��������
        begin
          if ObjZav[Ptr].Timers[3].Active = false then  //----- ���� ������ �� ��� �������
          begin
            ObjZav[Ptr].Timers[3].Active := true; //--------------------- ��������� ������
            ObjZav[Ptr].Timers[3].First := LastTime; //-------------- ������������� ������
            ObjZav[Ptr].Timers[3].Second := LastTime + 2/86400; //-------- ��������� �����
          end else
          begin //---------------------------------------------- ���� ������ �������������
            if so and (ObjZav[Ptr].Timers[3].Second < LastTime) then   //----- ����� �����
            begin
              ObjZav[Ptr].Timers[3].Active := false;
              ObjZav[Ptr].Timers[3].First := 0;
              ObjZav[Ptr].Timers[3].Second := 0;
              if WorkMode.FixedMsg and ((ObjZav[Ptr].iParam[10] and $100) = 0) then
              begin
{$IFDEF RMDSP}
                if ObjZav[Ptr].RU = config.ru then
                begin
                  InsArcNewMsg(Ptr,544+$1000,0);// "���������� ���� ������. ����� ���������"
                  AddFixMessage(GetShortMsg(1,544,ObjZav[Ptr].Liter,0),4,4);
                  ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $100;
                end;
              end;
{$ELSE}
                InsArcNewMsg(Ptr,544+$1000,0);//���������� �������� ���������.���� ���������
                SingleBeep4 := true;
                ObjZav[Ptr].dtParam[3] := LastTime;
                inc(ObjZav[Ptr].siParam[3]);
                ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] or $100;
              end;
{$ENDIF}
              ObjZav[Ptr].bParam[26] := so;
            end;
          end;
        end else
        begin
          ObjZav[Ptr].bParam[26] := so;
          ObjZav[Ptr].iParam[10] := ObjZav[Ptr].iParam[10] and $FF; //----- ����� ��������
        end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if n <> ObjZav[Ptr].bParam[17] then
        begin //-------------------------------------------------------------- ��������� �
          if n then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                InsArcNewMsg(Ptr,338+$1000,0); //----- "������ ����� �������� ��������� $"
                AddFixMessage(GetShortMsg(1,338,ObjZav[Ptr].Liter,0),4,4);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,338+$1000,0);
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[4] := LastTime;
              inc(ObjZav[Ptr].siParam[4]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- ����� ���������� �������������
        end;
        ObjZav[Ptr].bParam[17] := n;


        if kz <> ObjZav[Ptr].bParam[16] then
        begin //-------------------------------------------------------- ��������� �� (��)
          if kz then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZav[Ptr].RU = config.ru then
              begin
                if ObjZav[Ptr].bParam[4] then //-------------- ���� ������ �������� ������
                begin
                  InsArcNewMsg(Ptr,497+$1000,1); //���������� �������� ����������� ����� $
                  AddFixMessage(GetShortMsg(1,497,ObjZav[Ptr].Liter,1),4,4);
                end else
                begin
                  InsArcNewMsg(Ptr,497+$1000,1);
                  AddFixMessage(GetShortMsg(1,497,ObjZav[Ptr].Liter,1),4,4);
                end;
              end;
{$ELSE}       //------------------ ��� ��� �� --------------------------------------------
              if ObjZav[Ptr].bParam[4]
              then InsArcNewMsg(Ptr,487+$1000,1)// ������������ �������� ������� �� ������
              else InsArcNewMsg(Ptr,497+$1000,1);
              SingleBeep4 := true;
              ObjZav[Ptr].dtParam[5] := LastTime;
              inc(ObjZav[Ptr].siParam[5]);
{$ENDIF}
            end;
          end;
          ObjZav[Ptr].bParam[20] := false; //-------------- ����� ���������� �������������
        end;
        ObjZav[Ptr].bParam[16] := kz;
        inc(LiveCounter);

        OVBuffer[VidBuf].Param[17] := ObjZav[Ptr].bParam[20]; //- ���������� �������������
        OVBuffer[VidBuf].Param[7] := ObjZav[Ptr].bParam[30];//----------- �������������� 2
        if ObjZav[Ptr].bParam[4] then
        begin
          OVBuffer[VidBuf].Param[8] := ObjZav[Ptr].bParam[26];//--------------- �� � �����
          OVBuffer[VidBuf].Param[15] := ObjZav[Ptr].bParam[24];//--------------------- ���
          OVBuffer[VidBuf].Param[29] := ObjZav[Ptr].bParam[15];//--------------------- ���
          OVBuffer[VidBuf].Param[19] := ObjZav[Ptr].bParam[25]; //-------------------- ���
        end;
        OVBuffer[VidBuf].Param[9] :=  ObjZav[Ptr].bParam[16]; //----------------------- ��
        OVBuffer[VidBuf].Param[10] := ObjZav[Ptr].bParam[17]; //------------------------ �
        OVBuffer[VidBuf].Param[14] := ObjZav[Ptr].bParam[14];//----------------- ��� �����
      end;
    end;
  except
  {$IFNDEF RMARC}
    reportf('������ [MainLoop.PrepSvetofor]');
   {$ENDIF}   
    Application.Terminate;
  end;
end;
//------------------------------------------------------------------------------
//-------------------------------- ���������� ������� ���������� ���� � ������ �� ����� #6
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
            if (config.ru = ObjZav[ptr].RU) then
            begin
              InsArcNewMsg(Ptr,295,7);
              if WorkMode.Upravlenie
              then AddFixMessage(GetShortMsg(1,295,ObjZav[Ptr].Liter,7),4,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,295,7);
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
                if (config.ru = ObjZav[ptr].RU) then
                begin
                  InsArcNewMsg(Ptr,337+$1000,1);
                  AddFixMessage(GetShortMsg(1,337,ObjZav[Ptr].Liter,1),4,3);
                end;
{$ELSE}
                InsArcNewMsg(Ptr,337+$1000,1);
//                SingleBeep := true;
                ObjZav[Ptr].dtParam[1] := LastTime;
                inc(ObjZav[Ptr].siParam[1]);
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
//========================================================================================
//--------------------- ���������� ������� ���������������� ������� ��� ������ �� ����� #7
procedure PrepPriglasit(Ptr : Integer);
  var i : integer; ps : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ �����������
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- ��������������
  ps:=GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// ��

  if ObjZav[Ptr].ObjConstI[3] > 0 then
  ObjZav[Ptr].bParam[2] :=
  not GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//���

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
{$IFDEF RMDSP or $IFDEF RMSHN}
          if config.ru = ObjZav[Ptr].RU then begin
            InsArcNewMsg(Ptr,380+$2000,0);
            AddFixMessage(GetShortMsg(1,380,ObjZav[Ptr].Liter,0),0,6);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,380+$2000,0);
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
        begin //----------------------------------- ���� �� ������ - ��������� �����������
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
                      InsArcNewMsg(Ptr,454+$1000,1);
                      AddFixMessage(GetShortMsg(1,454,ObjZav[Ptr].Liter,1),4,4);
                    end;
{$ELSE}
                    InsArcNewMsg(Ptr,454+$1000,1); SingleBeep4 := true;
{$ENDIF}
                    ObjZav[Ptr].bParam[19] := true; // �������� ������������� ��
                  end;
                end;
              end else
              begin
                ObjZav[Ptr].Timers[1].Active := true;
                ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
              end;
            end;
          end else
          begin
            ObjZav[Ptr].Timers[1].Active := false;
            ObjZav[Ptr].bParam[19] := false; // ����� �������� ������������� ��
          end;
        end else
        begin
          ObjZav[Ptr].Timers[1].Active := false;
          ObjZav[Ptr].bParam[19] := false; // ����� �������� ������������� ��
        end;
      end;
    end;
  end;
except
  reportf('������ [MainLoop.PrepPriglasit]');
  Application.Terminate;
end;
end;
//========================================================================================
//-------------------------------------------- ���������� ������� ��� � ������ �� ����� #8
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
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,495+$2000,1);
                AddFixMessage(GetShortMsg(1,495,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,495+$2000,1);
{$ENDIF}
            end;
          end;
        end;
        if uu and not ObjZav[Ptr].bParam[1] then
        begin // ���� ����������
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[Ptr].RU then
            begin
              InsArcNewMsg(Ptr,108+$2000,1);
              AddFixMessage(GetShortMsg(1,108,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,108+$2000,1);
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
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,496+$2000,1);
                AddFixMessage(GetShortMsg(1,496,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,496+$2000,1);
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
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,109+$1000,1);
                AddFixMessage(GetShortMsg(1,109,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),4,1);
              end;
{$ELSE}
//              InsArcNewMsg(Ptr,109+$1000);
              SingleBeep := true;
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
//========================================================================================
//-------------------- ���������� ������� ������� ��������� ������� ��� ������ �� ����� #9
procedure PrepRZS(Ptr : Integer);
var
  rz,dzs,odzs : boolean;
  ii,cod,Vbufer,DatRZ,DatDZS,DatODZS: integer;
  TXT : string;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    DatRZ  := ObjZav[Ptr].ObjConstI[6];
    DatDZS := ObjZav[Ptr].ObjConstI[2];
    DatODZS := ObjZav[Ptr].ObjConstI[4];

    for ii := 1 to 32 do ObjZav[Ptr].NParam[ii] := false; //--------------- ��������������

    rz :=  GetFR3(DatRZ,ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);

    if DatDZS > 0 then
    dzs := GetFR3(DatDZS,ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31])
    else dzs := rz;

    if DatODZS > 0 then
    odzs := GetFR3(DatODZS,ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31])
    else odzs := rz;

    cod := 0;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      Vbufer := ObjZav[Ptr].VBufferIndex;
      OVBuffer[Vbufer].Param[16] := ObjZav[Ptr].bParam[31];

      if ObjZav[Ptr].bParam[31] then
      begin
        if rz then cod := cod + 1;
        if dzs then cod := cod + 2;
        if odzs then cod := cod + 4;

        ObjZav[Ptr].bParam[1] := rz;
        OVBuffer[Vbufer].Param[2] := rz;
        OVBuffer[VBufer].NParam[2] := ObjZav[Ptr].NParam[1]; //------------------------ ��

        ObjZav[Ptr].bParam[2] := dzs;
        OVBuffer[VBufer].Param[3] := dzs;
        OVBuffer[VBufer].NParam[3] := ObjZav[Ptr].NParam[2]; //----------------------- ���

        ObjZav[Ptr].bParam[3] := odzs;
        OVBuffer[VBufer].Param[4] := odzs;
        OVBuffer[VBufer].NParam[4] := ObjZav[Ptr].NParam[3]; //---------------------- ����

        if cod <> ObjZav[Ptr].iParam[1] then //---------- ���� ��������� ��� ��������� ���
        begin
          if not ObjZav[Ptr].Timers[1].Active then
          begin
            ObjZav[Ptr].Timers[1].Active := true;
            ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400;
          end;
        end;

        if ObjZav[Ptr].Timers[1].Active and
        (LastTime > ObjZav[Ptr].Timers[1].First) then
        begin
{$IFDEF RMDSP}
          if WorkMode.FixedMsg and (config.ru=ObjZav[ptr].RU) and not WorkMode.RU[0] then
          case cod of
            0:  //---------------------------------------------------------- ��� ���������
            begin
              InsArcNewMsg(Ptr,559+$2000,7);  //------- ��������� ������ ��������� �������
              TXT := GetShortMsg(1,559,ObjZav[Ptr].Liter,7);
              AddFixMessage(TXT,0,2);
              PutShortMsg(7,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            1:  //----------------------------------------------- ��� �������� ��� �������
            begin
              InsArcNewMsg(Ptr,560+$2000,1);//------------ �� ������� �������� ��� �������
              TXT := GetShortMsg(1,560,ObjZav[Ptr].Liter,1);
              AddFixMessage(TXT,4,3);
              PutShortMsg(1,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            2,4,6: //---------------------------- ��� ����������� �������� ��� �� ��������
            begin
              InsArcNewMsg(Ptr,561+$2000,1); // ������� ��������� ������� ��� ���  �������
              TXT := GetShortMsg(1,561,ObjZav[Ptr].Liter,1);
              AddFixMessage(TXT,4,3);
              PutShortMsg(1,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            5: //------------------------ ��������� ��������������� ������� ���������� ���
            begin
              InsArcNewMsg(Ptr,562+$2000,1); // ������� ��������� ������� ��� ���  �������
              TXT := GetShortMsg(1,562,ObjZav[Ptr].Liter,1);
              AddFixMessage(TXT,0,2);
              PutShortMsg(7,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            3,7: //----------------------------------------------- ��������� ��������� ���
            begin
              InsArcNewMsg(Ptr,558+$2000,7);  //-------  �������� ������ ��������� �������
              TXT := GetShortMsg(1,558,ObjZav[Ptr].Liter,7);
              AddFixMessage(TXT,0,2);
              PutShortMsg(7,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
            end;
          end;
{$ELSE}
          case cod of
            0:  //---------------------------------------------------------- ��� ���������
            begin
              InsArcNewMsg(Ptr,559+$2000,7);  //------- ��������� ������ ��������� �������
              SingleBeep3 := true;
            end;

            1:  //----------------------------------------------- ��� �������� ��� �������
            begin
              InsArcNewMsg(Ptr,560+$2000,1); // ������ �����. ������� �������� ��� �������
              SingleBeep3 := true;
            end;

            2,3,4,6: //-------------------------- ��� ����������� �������� ��� �� ��������
            begin
              InsArcNewMsg(Ptr,561+$2000,1); // ������� ��������� ������� ��� ���  �������
              SingleBeep3 := true;
            end;

            5: //------------------------ ��������� ��������������� ������� ���������� ���
            begin
              InsArcNewMsg(Ptr,562+$2000,1); // ������� ��������� ������� ��� ���  �������
              SingleBeep3 := true;
            end;

            7: //------------------------------------------------- ��������� ��������� ���
            begin
              InsArcNewMsg(Ptr,558+$2000,7);  //-------  �������� ������ ��������� �������
              SingleBeep3 := true;
            end;
          end;
{$ENDIF}
          ObjZav[Ptr].Timers[1].Active := false;
          ObjZav[Ptr].Timers[1].First := 0;
        end;
        ObjZav[Ptr].iParam[1] := cod;
      end;
    end;
  except
    ReportF('������ [MainLoop.PrepRZS]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------ ���������� ������� ���������� ��������� ��� ������ �� ����� #10
procedure PrepUPer(Ptr : Integer);
var
  rz : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    for ii := 1 to 32  do ObjZav[Ptr].NParam[ii] := false;//--------------- ��������������

    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������

    rz :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]); // ��

    ObjZav[Ptr].bParam[11] :=
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]); //���

    ObjZav[Ptr].bParam[12] :=
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].NParam[12],ObjZav[Ptr].bParam[31]); //���

    ObjZav[Ptr].bParam[13] :=
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].NParam[13],ObjZav[Ptr].bParam[31]);//����


    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      if ObjZav[Ptr].bParam[31] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[12]; //---- ���
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[12] := ObjZav[Ptr].NParam[12]; //--- ���

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[13]; //----����
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[13] := ObjZav[Ptr].NParam[13]; //-- ����

        if rz <> ObjZav[Ptr].bParam[10] then
        begin
          if rz then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,575+$2000,0); //------------------------------- ������ ��
                AddFixMessage(GetShortMsg(1,575,ObjZav[Ptr].Liter,0),0,2);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,575+$2000,0);
{$ENDIF}
            end;
          end else
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,576+$2000,0);  //------------------ ����������� ������ ��
                AddFixMessage(GetShortMsg(1,576,ObjZav[Ptr].Liter,0),0,2);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,576+$2000,0);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[10] := rz;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[10];
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[10] := ObjZav[Ptr].NParam[10];

{$IFDEF RMDSP}
        if config.ru = ObjZav[ptr].RU then
        begin
          if rz then
          begin //--------------------------------------------------------- ������� ������
            if ObjZav[Ptr].Timers[1].Active then
            begin
              if ObjZav[Ptr].Timers[1].First < LastTime then
              begin //------ ������ ��������� � ���������� �������� �������� ��� ������ ��
                InsArcNewMsg(Ptr,514+$2000,0);
                if ObjZav[Ptr].bParam[5] then
                AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter,0),4,4)
                else AddFixMessage(GetShortMsg(1,514,ObjZav[Ptr].Liter,0),4,3);
                ObjZav[Ptr].bParam[5] := true;
                ObjZav[Ptr].Timers[1].First := LastTime + 60 / 86400;//�������� ����������
              end;
            end else
            begin //--------------------------------- ������ �������� ���������� ���������
              ObjZav[Ptr].Timers[1].First := LastTime + 600 / 86400;
              ObjZav[Ptr].Timers[1].Active := true;
            end;
          end else
          begin //--------------------------------------------------------- ������� ������
            ObjZav[Ptr].Timers[1].Active := false;
            ObjZav[Ptr].bParam[5] := false;//- ����� �������� ����������� �������� �������
          end;
        end;
{$ENDIF}

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[11]; //----- ��
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[11] := ObjZav[Ptr].NParam[11]; //---- ��
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    end;
  except
    reportf('������ [MainLoop.PrepUPer]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------ ���������� ������� ��������(1) �������� ��� ������ �� ����� #11
procedure PrepKPer(Ptr : Integer);
var
  Npi,Cpi,kop,knp,kap,zg,kzp,Nepar : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    Nepar := false;  //---------------------------------------------------- ��������������

    kap :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],Nepar,ObjZav[Ptr].bParam[31]); //----------------- ���
    ObjZav[Ptr].NParam[2] := Nepar;

    Nepar := false;  //---------------------------------------------------- ��������������
    knp := GetFR3(ObjZav[Ptr].ObjConstI[3],Nepar,ObjZav[Ptr].bParam[31]); //---------- ���
    ObjZav[Ptr].NParam[3] := Nepar;

    Nepar := false;  //---------------------------------------------------- ��������������
    kzp :=  GetFR3(ObjZav[Ptr].ObjConstI[4],Nepar,ObjZav[Ptr].bParam[31]); //--------- ���
    ObjZav[Ptr].NParam[4] := Nepar;

    Nepar := false;  //---------------------------------------------------- ��������������
    zg := GetFR3(ObjZav[Ptr].ObjConstI[14],Nepar,ObjZav[Ptr].bParam[31]);//------------ ��
    ObjZav[Ptr].NParam[14] := Nepar;

    Nepar := false;  //---------------------------------------------------- ��������������
    kop := GetFR3(ObjZav[Ptr].ObjConstI[9],Nepar,ObjZav[Ptr].bParam[31]); //---------- ���
    ObjZav[Ptr].NParam[9] := Nepar;

    Nepar := false;  //---------------------------------------------------- ��������������
    Npi := GetFR3(ObjZav[Ptr].ObjConstI[8],Nepar,ObjZav[Ptr].bParam[31]); //---------- ���
    ObjZav[Ptr].NParam[8] := Nepar;

    Nepar := false;  //---------------------------------------------------- ��������������
    Cpi := GetFR3(ObjZav[Ptr].ObjConstI[10],Nepar,ObjZav[Ptr].bParam[31]); //--------- ���
    ObjZav[Ptr].NParam[10] := Nepar;

    ObjZav[Ptr].bParam[8] := Npi or Cpi;
    ObjZav[Ptr].bParam[9] := kop;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      if ObjZav[Ptr].bParam[31] then
      begin
        if kap <> ObjZav[Ptr].bParam[2] then
        begin
          if kap then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,143+$1000,0);  //---------------------- "������ ��������"
                AddFixMessage(GetShortMsg(1,143,ObjZav[Ptr].Liter,0),4,3);
                SingleBeep3 := true;
              end;
{$ELSE}
              InsArcNewMsg(Ptr,143+$1000,0);
{$ENDIF}
          end;
        end;
      end;

      ObjZav[Ptr].bParam[2] := kap;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2]; //-------- ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[2] := ObjZav[Ptr].NParam[2]; //------- ���
      if knp <> ObjZav[Ptr].bParam[3] then
      begin
        if knp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,144+$1000,0); //------------------ "������������� ��������"
              AddFixMessage(GetShortMsg(1,144,ObjZav[Ptr].Liter,0),4,4);
              SingleBeep4 := true;
            end;
{$ELSE}
            InsArcNewMsg(Ptr,144+$1000,0);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := knp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3]; //-------- ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[3] := ObjZav[Ptr].NParam[3]; //------- ���

      if kzp <> ObjZav[Ptr].bParam[4] then
      begin
        if kzp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,371+$2000,0); //-------------------------- "������ �������"
              AddFixMessage(GetShortMsg(1,371,ObjZav[Ptr].Liter,0),4,4);
              SingleBeep4 := true;
            end;
{$ELSE}
            InsArcNewMsg(Ptr,371+$2000,0);
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,372+$2000,0); //-------------------------- "������ �������"
              AddFixMessage(GetShortMsg(1,372,ObjZav[Ptr].Liter,0),0,4);
              SingleBeep4 := true;
            end;
{$ELSE}
            InsArcNewMsg(Ptr,372+$2000,0);
{$ENDIF}
          end;
        end
      end;
      ObjZav[Ptr].bParam[4] := kzp;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4]; //-------- ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4]; //------- ���


      if zg <> ObjZav[Ptr].bParam[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,107+$2000,0); //"�������� ������. ������������ �� ��������"
              AddFixMessage(GetShortMsg(1,107,ObjZav[Ptr].Liter,0),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,107+$2000,0); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[14] := zg;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[14]; //--------��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];  //------- ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[9];  //------- ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[8];  //-------- ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[14] := ObjZav[Ptr].NParam[14]; //-------��
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4];  //------ ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[9] := ObjZav[Ptr].NParam[9];  //------ ���
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[8] := ObjZav[Ptr].NParam[8];  //------- ��

    end;
  end;
except
  reportf('������ [MainLoop.PrepKPer]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------------ ���������� ������� ��������(2) �������� ��� ������ �� ����� #12
procedure PrepK2Per(Ptr : Integer);
var
  knp,knzp,kop,zg : Boolean;
  ii : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //--------------- ����������� �������������� �����������

  for ii := 2 to 14 do  ObjZav[Ptr].NParam[ii] := false; //--- �������������� ������ �����

  knp :=   //------------------------------------------------------ ������������� ��������
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);// ���/���

  knzp :=  //--------------------------------------------------------- ���������� ��������
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);//����/���

  zg :=  //--------------------------------------------------------- �������������� ������
  GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].NParam[14],ObjZav[Ptr].bParam[31]); //-- ��

  if ObjZav[Ptr].ObjConstI[9] >0  then //---------------------- ���� ���������� ������ ���
  kop := //----------------------------------------------------------- ���������� ��������
  GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[9],ObjZav[Ptr].bParam[31]) //--- ���
  else kop := not knzp; //------------------------- ���� ������� ��� ���, �� �������� ����

  ObjZav[Ptr].bParam[8] := //------------------------------------------ �������� ���������
  GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].NParam[8],ObjZav[Ptr].bParam[31]); //--- ���

  ObjZav[Ptr].bParam[10] := //------------------------------------------- ������ ���������
  GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]);//-- ���

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

    if ObjZav[Ptr].bParam[31] then
    begin
      if knp <> ObjZav[Ptr].bParam[3] then
      begin //----------------------------- ��������� �� ������� ������������� �� ��������
        if knp then
        begin //----------------------------- ������������� ������� �������� -> ����������
          ObjZav[Ptr].Timers[2].First := LastTime + 10/86400; //�������� ������ �� 10 ���.
          ObjZav[Ptr].Timers[2].Active := true;  //---------------------- ��������� ������
        end else
        begin //----------------------------- ������������� ������� ���������� -> ��������
          ObjZav[Ptr].Timers[2].First := 0;
          ObjZav[Ptr].Timers[2].Active := false;
          ObjZav[Ptr].bParam[3] := false; //---- �������� ��������� ������������� ��������
          ObjZav[Ptr].bParam[3] := knp;
        end;
      end;


      if not ObjZav[Ptr].bParam[3] and ObjZav[Ptr].Timers[2].Active then
      begin //-------------------- �������� 10 ������ �� ������� ������������� �� ��������
        if ObjZav[Ptr].Timers[2].First < LastTime then
        begin //------------------------------------- ���������� ������������� �� ��������
          ObjZav[Ptr].bParam[3] := true;
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,144+$1000,0); //"������������� �� ��������"
              AddFixMessage(GetShortMsg(1,144,ObjZav[Ptr].Liter,0),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,144+$1000,0); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;

      if knzp and not kop then //--------------------- ������� �������� ��������� ��������
      begin
        ObjZav[Ptr].bParam[4] := true; //--------------------------------------------- ���
        ObjZav[Ptr].bParam[9] := false; //-------------------------------------------- ���
        ObjZav[Ptr].bParam[2] := false;  //------------------------------------------- ���
        ObjZav[Ptr].Timers[1].First := 0;
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[6] := false;  //---------------------------------- �������� ���
      end else
      if kop and not knzp then //--------------------- ������� �������� ��������� ��������
      begin
        ObjZav[Ptr].bParam[4] := false; //-------------------------------------------- ���
        ObjZav[Ptr].bParam[9] := true; //--------------------------------------------- ���
        ObjZav[Ptr].bParam[2] := false; //-------------------------------------------- ���
        ObjZav[Ptr].Timers[1].First := 0;
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[6] := false; //----------------------------------- �������� ���
      end else
      begin //--------------------------------------------------------- ������ �� ��������
        if not ObjZav[Ptr].Timers[1].Active then
        begin //------------------------------- ������������� ��������� �������� -> ������
          ObjZav[Ptr].Timers[1].First := LastTime+10/86400;
          ObjZav[Ptr].Timers[1].Active := true;
          ObjZav[Ptr].bParam[6] := true;     //�������� ���
        end else
        if not ObjZav[Ptr].bParam[2] then   // ���
        begin // ������� 10 ������ �� ������� ������ �� ��������
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin // ���������� ������ �� ��������
            ObjZav[Ptr].bParam[1] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
               begin
                InsArcNewMsg(Ptr,143+$1000,0);      // "������ ��������"
                AddFixMessage(GetShortMsg(1,143,ObjZav[Ptr].Liter,0),4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,143+$1000,0);
              SingleBeep3 := true;
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[4] := false;    //���
        ObjZav[Ptr].bParam[9] := false;    //���
      end;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      for ii := 1 to 30 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2]; //���

      if ObjZav[Ptr].bParam[3] then // ������ �� ��������
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]
      else // ������������� �� ��������
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];  //���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];    //���
      if zg <> ObjZav[Ptr].bParam[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,107+$2000,0); //"�������� ������. ������������ �� ��������"
              AddFixMessage(GetShortMsg(1,107,ObjZav[Ptr].Liter,0),4,4);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,107+$2000,0); SingleBeep4 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[14] := zg;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[14];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[8];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[10];
    end;
  end;
except
  reportf('������ [MainLoop.PrepK2Per]');
  Application.Terminate;
end;
end;
 //========================================================================================
//------------------------- ���������� ������� ���������� �������� ��� ������ �� ����� #13
procedure PrepOM(Ptr : Integer);
var
  nepar,rz,rrm,vo,vod : boolean;
  i,VidBufer : integer;
begin
try
  inc(LiveCounter);

  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ �����������
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- ��������������

  for i := 0 to 32 do ObjZav[Ptr].NParam[i] := false;
  nepar := false;
  rz :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],nepar,ObjZav[Ptr].bParam[31]);//---------------- ��(���)
  ObjZav[Ptr].NParam[2] := nepar;

  nepar := false;
  rrm :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],nepar,ObjZav[Ptr].bParam[31]);//-------------------- ���
  ObjZav[Ptr].NParam[3] := nepar;

  nepar := false;
  ObjZav[Ptr].bParam[4] :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],nepar,ObjZav[Ptr].bParam[31]);//--------------- ���(���)
  ObjZav[Ptr].NParam[4] := nepar;

  nepar := false;
  ObjZav[Ptr].bParam[5] :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],nepar,ObjZav[Ptr].bParam[31]);//--------------- ���(���)
  ObjZav[Ptr].NParam[5] := nepar;

  nepar := false;
  vo:=
  GetFR3(ObjZav[Ptr].ObjConstI[6],nepar,ObjZav[Ptr].bParam[31]);//--------------------- �o
  ObjZav[Ptr].NParam[6] := nepar;

  nepar := false;
  vod:=
  GetFR3(ObjZav[Ptr].ObjConstI[7],nepar,ObjZav[Ptr].bParam[31]);//--- ���
  ObjZav[Ptr].NParam[7] := nepar;

  VidBufer := ObjZav[Ptr].VBufferIndex;
  if VidBufer > 0 then
  begin
    for i := 1 to 32 do OVBuffer[VidBufer].NParam[i] := ObjZav[Ptr].NParam[i];
    nepar := false;
    for i := 1 to 32 do nepar := nepar or OVBuffer[VidBufer].NParam[i];


    OVBuffer[VidBufer].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[VidBufer].Param[1] := ObjZav[Ptr].bParam[32];

    if ObjZav[Ptr].bParam[31] and not nepar then
    begin
      if rz <> ObjZav[Ptr].bParam[2] then //--------------------------- ���� ���������� ��
      begin
        if rz then //------------------------------------------------------------- ���� ��
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[ptr].ObjConstB[1] then
            begin //----------------------------------------------------- ������������ ���
              if ObjZav[Ptr].bParam[3] and (config.ru = ObjZav[ptr].RU) then
              begin
                InsArcNewMsg(Ptr,374+$2000,7);    //--------- ��������� ���������� "�����"
                AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter,7),0,2);
              end;
            end else
            begin
              if config.ru = ObjZav[ptr].RU then begin
                InsArcNewMsg(Ptr,373+$2000,7); //------------- �������� ���������� "�����"
                AddFixMessage(GetShortMsg(1,373,ObjZav[Ptr].Liter,7),0,2);
              end;
            end;
{$ELSE}     //----------------------------------------------------------------- ��� ��� ��
            if ObjZav[ptr].ObjConstB[1] then InsArcNewMsg(Ptr,374+$2000,7)
            else InsArcNewMsg(Ptr,373+$2000,7);
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if ObjZav[ptr].ObjConstB[1] then
            begin //----------------------------------------------------- ������������ ���
              if rrm and (config.ru = ObjZav[ptr].RU) then
              begin
                InsArcNewMsg(Ptr,373+$2000,1);
                AddFixMessage(GetShortMsg(1,373,ObjZav[Ptr].Liter,1),0,2);
              end;
            end else
            begin
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,374+$2000,1);
                AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter,1),0,2);
              end;
            end;
{$ELSE}
            if ObjZav[ptr].ObjConstB[1] then InsArcNewMsg(Ptr,373+$2000,1)
            else InsArcNewMsg(Ptr,374+$2000,1);
{$ENDIF}
          end;
        end;
      end;

      ObjZav[Ptr].bParam[2] := rz;

      if ObjZav[ptr].ObjConstB[1] then
      // ��� ������������� ��� ����������� ����� ���������� ��� ������. ���������� "�����"
      begin
        if rrm <> ObjZav[Ptr].bParam[3] then
        begin
          if not rrm and not rz and WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,374+$2000,1);
              AddFixMessage(GetShortMsg(1,374,ObjZav[Ptr].Liter,1),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,374+$2000,1)
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] :=  rrm;

      if ObjZav[ptr].ObjConstB[1] then
      begin //----------------------------------------------------------- ������������ ���
        OVBuffer[VidBufer].Param[3] :=
        not ObjZav[Ptr].bParam[2] and ObjZav[Ptr].bParam[3];
      end
      else  OVBuffer[VidBufer].Param[3] := ObjZav[Ptr].bParam[2]; //--- ��

      if (vo <> ObjZav[Ptr].bParam[6]) or (vod <> ObjZav[Ptr].bParam[7]) then //�� ��� ���
      begin
        if WorkMode.FixedMsg then
        begin
          if (not vo  and not vod) then
          begin
            InsArcNewMsg(Ptr,534+$2000,7);    //-------------- "�������� ������ �������� "
            AddFixMessage(GetShortMsg(1,534,ObjZav[Ptr].Liter,7),0,2);
          end;
          end else
          if(vo and vod) then
          begin
            InsArcNewMsg(Ptr,518+$2000,7); //------------------- "������� ������ ��������"
            AddFixMessage(GetShortMsg(1,518,ObjZav[Ptr].Liter,1),0,2);
          end;
        end;
      end;

      ObjZav[Ptr].bParam[6] := vo;
      ObjZav[Ptr].bParam[7] := vod;
      OVBuffer[VidBufer].Param[6] := ObjZav[Ptr].bParam[6];
      OVBuffer[VidBufer].Param[7] := ObjZav[Ptr].bParam[7];

      OVBuffer[VidBufer].Param[2] := ObjZav[Ptr].bParam[2]; //------------------------ ���
      OVBuffer[VidBufer].Param[4] := ObjZav[Ptr].bParam[4]; //------------------------ ���
      OVBuffer[VidBufer].Param[5] := ObjZav[Ptr].bParam[5]; //------------------------ ���
    end;
  except
    reportf('������ [MainLoop.PrepOM]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------- ���������� ������� ����� ��� ������ �� ����� #14
procedure PrepUKSPS(Ptr : Integer);
var
  d1,d2,kzk1,kzk2,dvks : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ �����������
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- ��������������

  ObjZav[Ptr].bParam[1] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ���

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //����.�

  d1 :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//--- 1��

  d2 :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//--- 2��

  kzk1 :=
  GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- ���1

  kzk2 :=
  GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- ���2

  ObjZav[Ptr].bParam[7]  :=
  GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- ����

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      if d1 <> ObjZav[Ptr].bParam[3] then //----------------- ������ 1�� ������� ���������
      begin
        if d1 then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,125+$1000,0); //-------------------- �������� ������1 �����
              AddFixMessage(GetShortMsg(1,125,ObjZav[Ptr].Liter,0),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,125+$1000,0);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[3] := d1;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[3];

      if d2 <> ObjZav[Ptr].bParam[4] then  //---------------- ������ 2�� ������� ���������
      begin
        if d2 then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,126+$1000,0); //---------------- �������� ������2 ����� $
              AddFixMessage(GetShortMsg(1,126,ObjZav[Ptr].Liter,0),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,126+$1000,0);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[4] := d2;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[4];

      if kzk1 <> ObjZav[Ptr].bParam[5] then
      begin
        if kzk1 then
        begin //---------------------------------------------- ������������� �����-1 �����
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,127+$1000,1); //--------------------- ������������� �����-1
              AddFixMessage(GetShortMsg(1,127,ObjZav[Ptr].Liter,1),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,127+$1000,1);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[5] := kzk1;

      if kzk2 <> ObjZav[Ptr].bParam[6] then
      begin
        if kzk2 then
        begin //---------------------------------------------- ������������� �����-2 �����
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,525+$1000,1); //--------------------- ������������� �����-2 $
              AddFixMessage(GetShortMsg(1,525,ObjZav[Ptr].Liter,1),4,3);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,525+$1000,1);
            SingleBeep3 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[6] := kzk2;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[7];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[2];
    end;
  end;
except
  reportf('������ [MainLoop.PrepUKSPS]');
  Application.Terminate;
end;
end;
//========================================================================================
//--------------- ���������� ������� ����� ����������� �� �������� ��� ������ �� ����� #15
procedure PrepAB(Ptr : Integer);
var
  kj,ip1,ip2,zs : boolean;
  uch_1ip,uch_2ip,dat_V,dat_SN,dat_KP,dat_KJ,dat_D1,dat_D2,dat_ZS,Video_Buf : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������
    //----------------------------------------------------- ����� �� ���� ������� ��������
    dat_V := ObjZav[Ptr].ObjConstI[2];
    uch_1ip := ObjZav[Ptr].ObjConstI[3];
    uch_2ip := ObjZav[Ptr].ObjConstI[4];
    dat_SN := ObjZav[Ptr].ObjConstI[5];
    dat_KP := ObjZav[Ptr].ObjConstI[6];
    dat_KJ := ObjZav[Ptr].ObjConstI[7];
    dat_D1 := ObjZav[Ptr].ObjConstI[8];
    dat_ZS := ObjZav[Ptr].ObjConstI[9];
    dat_D2 := ObjZav[Ptr].ObjConstI[11];
    Video_Buf := ObjZav[Ptr].VBufferIndex;

    ObjZav[Ptr].bParam[1] :=
    GetFR3(dat_V,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//---------------------- �

    ip1 :=  not GetFR3(uch_1ip,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//------ 1��

    ip2 := not GetFR3(uch_2ip,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //------ 2��

    ObjZav[Ptr].bParam[4] :=
    GetFR3(dat_SN,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);     //--------------- ��

    ObjZav[Ptr].bParam[5] :=
    not GetFR3(dat_KP,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--------------- ��
    OVBuffer[Video_Buf].Param[5] := ObjZav[Ptr].bParam[5]; //------------- �� � ����������

    kj := not GetFR3(dat_KJ,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-------- ��

    ObjZav[Ptr].bParam[7] :=
    GetFR3(dat_D1,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-------------------- �1

    zs := GetFR3(dat_ZS,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //------ ������ ��

    ObjZav[Ptr].bParam[16] :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  // �

    ObjZav[Ptr].bParam[8] :=
    GetFR3(dat_D2,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);   //----------------- �2

    ObjZav[Ptr].bParam[11] :=
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// 3��

    ObjZav[Ptr].bParam[17] :=
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//�������� ����� �����������

    if Video_Buf > 0 then
    begin
      OVBuffer[Video_Buf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[Video_Buf].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if zs <> ObjZav[Ptr].bParam[10] then
        begin //-------------------------------------- ������� ������ �� ����� �����������
          if ObjZav[Ptr].bParam[4] and WorkMode.FixedMsg then
          begin //------------------------------------------------- ������� �� �����������
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then
            begin
{$ENDIF}
              if zs then
              begin //-------------------------------------------------- ������ ����������
                InsArcNewMsg(Ptr,439+$2000,0);//������� ������ ����� ���������.�� ��������
                AddFixMessage(GetShortMsg(1,439,ObjZav[Ptr].Liter,0),0,6);
              end else
              if ObjZav[Ptr].bParam[1] then //-------------- �� ������ ����� (� ��� �����)
              begin //----------------------------------------------------- ������ �������
                if ObjZav[Ptr].bParam[17] then //------- ������ �������� ����� �����������
                InsArcNewMsg(Ptr,56+$2000,7)//-- ������ ������� �������� �� �� �� ��������
              else //--------------------------------------------------------- ���� ������
                InsArcNewMsg(Ptr,440+$2000,0); //���� ������ ����� ����������� �� ��������
                AddFixMessage(GetShortMsg(1,440,ObjZav[Ptr].Liter,0),0,6);
              end;
{$IFDEF RMDSP}
            end;
{$ENDIF}
          end;
        end;
        inc(LiveCounter);
        ObjZav[Ptr].bParam[10] := zs;
        if ObjZav[Ptr].bParam[17] then //---------------------- ���� ������ �������� �� ��
        OVBuffer[Video_Buf].Param[18] := tab_page //-- �������� ����� ����������� - ������
        else
        OVBuffer[Video_Buf].Param[18] := ObjZav[Ptr].bParam[10];//������ ����� �����������

        OVBuffer[Video_Buf].Param[17] := ObjZav[Ptr].bParam[16];    //------------------ �
        OVBuffer[Video_Buf].Param[4] := not ObjZav[Ptr].bParam[11]; //---------------- 3��

        if kj <> ObjZav[Ptr].bParam[6] then
        begin
          if kj then
          begin //------------------------------------------------------------ �������� ��
            ObjZav[Ptr].bParam[9] := false; //--------------- ����� ����������� ���.������
          end else //------------------------------------------------------------ ����� ��
          begin
{$IFDEF RMDSP}
            if ObjZav[Ptr].RU = config.ru then
            begin
              InsArcNewMsg(Ptr,357+$2000,0);   //----------- ����-���� $ ����� �� ��������
              AddFixMessage(GetShortMsg(1,357,ObjZav[Ptr].Liter,0),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,357+$2000,0);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[6] := kj;
        OVBuffer[Video_Buf].Param[11] := ObjZav[Ptr].bParam[6];

        if ip1 <> ObjZav[Ptr].bParam[2] then
        begin
          if ObjZav[Ptr].bParam[2] then  //------------------------- ������� 1 �����������
          begin
            if not ObjZav[Ptr].bParam[6] //-------------------------- ���� ����� ����-����
            then ObjZav[Ptr].bParam[9] := true; //------------ ���� ����������� ���.������

            if ObjZav[Ptr].ObjConstB[2] then //-------------------- ���� ����� �����������
            begin
              if ObjZav[Ptr].ObjConstB[3] then  //------------------ ������������ ��������
              begin
                if ObjZav[Ptr].ObjConstB[4] then  //- �� ������ ���� �� ��������� ��������
                begin
                  if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                  begin //---------------------------------------- ���� �������� ���������
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
                    then Ip1Beep := true;
                  end else //------------------------------------------- �������� ��������
                  if config.ru = ObjZav[ptr].RU then Ip1Beep := true;
                end else
                if ObjZav[Ptr].ObjConstB[5] then //----- �� �����������, ���� �� ���������
                begin
                  if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then// �2 � !�1
                  begin
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)//- �����
                    then Ip1Beep := true;
                  end;
                end;
              end else //-------------------------------------- �������� ������� ���������
              if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
              then Ip1Beep := true;
            end else
            if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU)
            then Ip1Beep := true; //------------------------------------ �� ������ �������
          end;
        end;
        ObjZav[Ptr].bParam[2] := ip1;
        OVBuffer[Video_Buf].Param[2] := ObjZav[Ptr].bParam[2];

        if ip2 <> ObjZav[Ptr].bParam[3] then  //----------------------- ���� ��������� ��2
        begin
          if ObjZav[Ptr].bParam[3] then  //---------------------------------- ���� �������
          begin //-------------------------------------------------- ������� 2 �����������
            if ObjZav[Ptr].ObjConstB[2] then  //-------------- ���� ���� ����� �����������
            begin //----------------------------------------------- ���� ����� �����������
              if ObjZav[Ptr].ObjConstB[3] then //-------------- ���� �������� �� ���������
              begin //---------------------------------------------- ������������ ��������
                if ObjZav[Ptr].ObjConstB[4] then  //--------------------------- ���� �����
                begin //-------------------------------------------------------- �� ������
                  if ObjZav[Ptr].bParam[7] and not ObjZav[Ptr].bParam[8] then
                  begin //--------------------------------------------- �������� ���������
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
                    then Ip2Beep := true;
                  end else //------------------------------------------- �������� ��������
                  if config.ru = ObjZav[ptr].RU then Ip2Beep := true;
                end else
                if ObjZav[Ptr].ObjConstB[5] then
                begin //--------------------------------------------------- �� �����������
                  if ObjZav[Ptr].bParam[8] and not ObjZav[Ptr].bParam[7] then
                  begin //--------------------------------------------- �������� ���������
                    if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
                    then Ip2Beep := true;
                  end;
                end;
              end else //-------------------------------------- �������� ������� ���������
              if not ObjZav[Ptr].bParam[4] and (config.ru = ObjZav[ptr].RU)
              then Ip2Beep := true;
            end else
            if ObjZav[Ptr].ObjConstB[4] and (config.ru = ObjZav[ptr].RU) //---- ���� �����
            then Ip2Beep := true; //------------------------------------ �� ������ �������
          end;
        end;
        ObjZav[Ptr].bParam[3] := ip2;
        OVBuffer[Video_Buf].Param[3] := ObjZav[Ptr].bParam[3];

        if ObjZav[Ptr].ObjConstB[2] then
        begin //--------------------------------------------------- ���� ����� �����������
          OVBuffer[Video_Buf].Param[5] := ObjZav[Ptr].bParam[5];
          if ObjZav[Ptr].ObjConstB[3] then
          begin //-------------------------------- �������� ����� ����������� ������������
            inc(LiveCounter);
            if ObjZav[Ptr].bParam[7] and ObjZav[Ptr].bParam[8] then
            begin //------------------------------------------- ������� ��������� ��������
              OVBuffer[Video_Buf].Param[10] := false;
              OVBuffer[Video_Buf].Param[12] := false;
            end else
            begin
              if ObjZav[Ptr].ObjConstB[4] then
              begin //-------------------------------------------------------- ���� ������
                if ObjZav[Ptr].bParam[7] then
                begin //-------------------------------------------------------------- �1�
                  OVBuffer[Video_Buf].Param[6] := ObjZav[Ptr].bParam[1];
                  OVBuffer[Video_Buf].Param[7] := ObjZav[Ptr].bParam[4];
                  OVBuffer[Video_Buf].Param[10] := true;
                  OVBuffer[Video_Buf].Param[12] := true;
                end else
                if ObjZav[Ptr].bParam[8] then
                begin //-------------------------------------------------------------- �2�
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := false;
                end else
                begin
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := true;
                end;
              end else
              if ObjZav[Ptr].ObjConstB[5] then
              begin //--------------------------------------------------- ���� �����������
                if ObjZav[Ptr].bParam[7] then
                begin //-------------------------------------------------------------- �1�
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := false;
                end else
                if ObjZav[Ptr].bParam[8] then
                begin //-------------------------------------------------------------- �2�
                  OVBuffer[Video_Buf].Param[6] :=ObjZav[Ptr].bParam[1];
                  OVBuffer[Video_Buf].Param[7] := ObjZav[Ptr].bParam[4];
                  OVBuffer[Video_Buf].Param[10] := true;
                  OVBuffer[Video_Buf].Param[12] := true;
                end else
                begin
                  OVBuffer[Video_Buf].Param[10] := false;
                  OVBuffer[Video_Buf].Param[12] := true;
                end;
              end;
            end;
          end else
          begin //--------------------------- �������� ����� ����������� ������� ���������
            OVBuffer[Video_Buf].Param[6] := ObjZav[Ptr].bParam[1];
            OVBuffer[Video_Buf].Param[7] := ObjZav[Ptr].bParam[4];
          end;
        end;
      end;
      //------------------------------------------------------------------------------ FR4
      ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //------------------------------------------------------- ��������� ����������
        if tab_page
        then OVBuffer[Video_Buf].Param[32] := ObjZav[Ptr].bParam[13]
        else OVBuffer[Video_Buf].Param[32] := ObjZav[Ptr].bParam[12];
      end else
{$ENDIF}
      OVBuffer[Video_Buf].Param[32] := ObjZav[Ptr].bParam[12];
      if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
      begin //----------------------------------------------------------- ���� �����������
        ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 * 8 + 3);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[Video_Buf].Param[29] := ObjZav[Ptr].bParam[24]
          else OVBuffer[Video_Buf].Param[29] := ObjZav[Ptr].bParam[27];
        end else
{$ENDIF}
        OVBuffer[Video_Buf].Param[29] := ObjZav[Ptr].bParam[27];
        if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
        begin //-------------------------------------------------- ���� 2 ���� �����������
          ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[3]{ div 8 * 8});
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
          begin
            if tab_page
            then OVBuffer[Video_Buf].Param[31] := ObjZav[Ptr].bParam[25]
            else OVBuffer[Video_Buf].Param[31] := ObjZav[Ptr].bParam[28];
          end else
{$ENDIF}
          OVBuffer[Video_Buf].Param[31] := ObjZav[Ptr].bParam[28];
          ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[3] div 8 *8 +1);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
          begin
            if tab_page
            then OVBuffer[Video_Buf].Param[30] := ObjZav[Ptr].bParam[26]
            else OVBuffer[Video_Buf].Param[30] := ObjZav[Ptr].bParam[29];
          end else
{$ENDIF}
          OVBuffer[Video_Buf].Param[30] := ObjZav[Ptr].bParam[29];
        end;
      end;

      if ObjZav[Ptr].BaseObject > 0 then
      begin //---------------------------- ��������� ������ �������� ����������� ���������
        if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
        begin //-------------------------------------------------------- ������ ����������
          ObjZav[Ptr].bParam[14] := false; //---------------- ����� ������������ ���������
          ObjZav[Ptr].bParam[15] := false; // ����� ��������� �������� �������. �� �������
          //------------------------- ���� �������� ��������� ������� �� ��� �������������
        end else
        begin //---------------------------------------------------------- ������ ��������
        end;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepAB]');
    Application.Terminate;
  end;
end;
//========================================================================================
// ���������� ������� ��������������� ����� ����������� �� ������� ��� ������ �� ����� #16
procedure PrepVSNAB(Ptr : Integer);
var
  ind_VP,ind_DVP,ind_VO,ind_DVO,VideoBuf : integer;
begin
  ind_VP := ObjZav[Ptr].ObjConstI[3];
  ind_DVP := ObjZav[Ptr].ObjConstI[5];
  ind_VO := ObjZav[Ptr].ObjConstI[2];
  ind_DVO := ObjZav[Ptr].ObjConstI[4];
  VideoBuf := ObjZav[Ptr].VBufferIndex;
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    ObjZav[Ptr].bParam[1] :=
    GetFR3(ind_VP,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //------------------ ��

    ObjZav[Ptr].bParam[2] :=
    GetFR3(ind_DVP,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //---------------- ���

    ObjZav[Ptr].bParam[3] :=
    GetFR3(ind_VO,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //------------------ ��

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ind_DVO,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //---------------- ���

    if  VideoBuf > 0 then
    begin
      OVBuffer[VideoBuf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[VideoBuf].Param[1] := ObjZav[Ptr].bParam[32];
      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        OVBuffer[VideoBuf].Param[12] := ObjZav[Ptr].bParam[3];
        OVBuffer[VideoBuf].Param[13] := ObjZav[Ptr].bParam[4];
        OVBuffer[VideoBuf].Param[14] := ObjZav[Ptr].bParam[1];
        OVBuffer[VideoBuf].Param[15] := ObjZav[Ptr].bParam[2];
      end;
    end;
  except
    reportf('������ [MainLoop.PrepVSNAB]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------ ���������� ������� ���������� �������� ���� ������� ��� ������ �� ����� #17
procedure PrepMagStr(Ptr : Integer);
var
  lar : boolean;
  i,Videobuf : integer;
begin
  try
    Videobuf := ObjZav[Ptr].VBufferIndex;
    for i := 1 to 32 do
    ObjZav[Ptr].NParam[i] := false;

    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    ObjZav[Ptr].bParam[1] :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);//--- ��

    ObjZav[Ptr].bParam[2] :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);//-- ���

    lar :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]); //- ���

    if Videobuf > 0 then
    begin
      OVBuffer[Videobuf].Param[16] := ObjZav[Ptr].bParam[31];

      for i := 2 to 30 do OVBuffer[Videobuf].NParam[i-1]:=ObjZav[Ptr].NParam[i];

      if ObjZav[Ptr].bParam[31] then
      begin
        OVBuffer[Videobuf].Param[16] := ObjZav[Ptr].bParam[31];
        OVBuffer[Videobuf].Param[1] := ObjZav[Ptr].bParam[1]; //------- ��
        OVBuffer[Videobuf].NParam[1] :=ObjZav[Ptr].NParam[1]; //������� ��
        OVBuffer[Videobuf].Param[2] := ObjZav[Ptr].bParam[2]; //------ ���
        OVBuffer[Videobuf].NParam[2]:= ObjZav[Ptr].NParam[2];//������� ���

        if lar <> ObjZav[Ptr].bParam[3] then
        begin //-------------------------------------------------- ��������� ��������� ���
          if lar then
          begin //----------------------------------------------- ������������� ������� ��
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,484+$1000,1);
                AddFixMessage(GetShortMsg(1,484,ObjZav[Ptr].Liter,1),0,1);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,484+$1000,1);//------ ������������� ������� ��������� �����
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[3] := lar;
        OVBuffer[Videobuf].Param[3] := ObjZav[Ptr].bParam[3];
      end;
    end;
  except
    Reportf('������ [MainLoop.PrepMagStr]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------- ���������� ������� ���������� ������ ������� ��� ������ �� ����� #18
procedure PrepMagMakS(Ptr : Integer);
var
  rz : boolean;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; // �����������
    ObjZav[Ptr].bParam[32] := false; // ��������������
    rz :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //- ��

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
                InsArcNewMsg(maket_strelki_index,377+$2000,1);
                AddFixMessage(GetShortMsg(1,377,ObjZav[maket_strelki_index].Liter,1),0,2);
              end;
{$ELSE}
              InsArcNewMsg(maket_strelki_index,377+$2000,1); //������� ������� $ �� ������
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
//========================================================================================
//----------------- ���������� ������� ���������� �������� ������� ��� ������ �� ����� #19
procedure PrepAPStr(Ptr : Integer);
var
  rz : boolean;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������
    rz :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ���

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
                InsArcNewMsg(Ptr,378+$2000,0); //- ������ ������ ���������������� ��������
                AddFixMessage(GetShortMsg(1,378,ObjZav[Ptr].Liter,0),0,2);
              end else
              begin
                InsArcNewMsg(Ptr,379+$2000,0);// �������� ������ ���������������� ��������
                AddFixMessage(GetShortMsg(1,379,ObjZav[Ptr].Liter,0),0,2);
              end;
            end;
{$ELSE}
            if rz then InsArcNewMsg(Ptr,378+$2000,0)
            else InsArcNewMsg(Ptr,379+$2000,0);
{$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[1] := rz;
      end else
      begin //--------------- �������� ������� ���������������� �������� ��� �������������
        ObjZav[Ptr].bParam[1] := false;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];
    end;
  except
    reportf('������ [MainLoop.PrepAPStr]');
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------------- ���������� ������� �������� ������ ��� ������ �� ����� #20
procedure PrepMaket(Ptr : Integer);
var
  km : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    for ii := 1 to 34 do  ObjZav[Ptr].NParam[ii] := false; //-------------- ��������������

    km :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);  // ��

    ObjZav[Ptr].bParam[3] :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);  // ���

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);  // ���

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

    for ii := 1 to 30 do
    OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];

    if ObjZav[Ptr].bParam[31] then
    begin
      if km <> ObjZav[Ptr].bParam[2] then
      begin
        if km then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (ObjZav[Ptr].RU = config.ru) then
            begin
              InsArcNewMsg(Ptr,301+$1000,0);
              AddFixMessage(GetShortMsg(1,301,'',0),0,2);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,301+$2000,0); //--------------------- ��������� ����� �������
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[2] := km;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];
    end;
  end;
except
  reportf('������ [MainLoop.PrepMaket]');
  Application.Terminate;
end;
end;
//========================================================================================
//--------------------- ���������� ������� �������� ������� ������ ��� ������ �� ����� #21
procedure PrepOtmen(Ptr : Integer);
var
  om,op,os,vv : boolean;
  i,t_os,t_om,t_op : integer;  //----------------- ������� ���������, ����������, ��������
begin
  try
    inc(LiveCounter);
    t_os := ObjZav[Ptr].ObjConstI[5];
    t_om := ObjZav[Ptr].ObjConstI[6];
    t_op := ObjZav[Ptr].ObjConstI[7];

    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    ObjZav[Ptr].NParam[2] := false;

    os:=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]); //- ���
    if (ObjZav[Ptr].ObjConstI[32] and $8) = 8 then  os := not os;


    ObjZav[Ptr].NParam[3] := false;
    om:=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]); //- ��1

    if (ObjZav[Ptr].ObjConstI[32] and $4) = 4 then  om := not om;


    ObjZav[Ptr].NParam[4] := false;
    op:=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]); //- ��1
    if (ObjZav[Ptr].ObjConstI[32] and $2) = 2 then  op := not op;

    ObjZav[Ptr].NParam[11] := false;

    vv:=
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]);//- ��

    if (t_os = t_om) and not vv then
    begin
      Timer[t_os] := 0;
      ObjZav[Ptr].Timers[t_os].Active := false;
      ObjZav[Ptr].Timers[t_os].First := 0;
      ObjZav[Ptr].Timers[t_os].Second := 0;
    end;

    ObjZav[Ptr].NParam[8] := false;

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].NParam[8],ObjZav[Ptr].bParam[31]); //-- ��

    ObjZav[Ptr].NParam[9] := false;
    ObjZav[Ptr].bParam[5] :=
    GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[9],ObjZav[Ptr].bParam[31]); //-- ��

    ObjZav[Ptr].NParam[10] := false;
    ObjZav[Ptr].bParam[6] :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]); // ��

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      for i := 1 to 30 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] :=  ObjZav[Ptr].NParam[i];

      if ObjZav[Ptr].bParam[31] then
      begin
        //----------------------------------------------------------- ������ �� ����������
        if ObjZav[Ptr].ObjConstI[11] = 0 then //---------------------- ���� ��� ������� ��
        begin
          if t_os > 0 then
          begin //---------------------------- ���� ������ ������ �� ���������� ����������
            if os <> ObjZav[Ptr].bParam[1] then //------------------ ���� ��������� ��� ��
            begin
              if ObjZav[Ptr].Timers[t_os].Active then //------- ���� ������ �� ��� �������
              begin //--------------------------------------------- ��������� ���� �������
                if t_om <> t_os then  ObjZav[Ptr].Timers[t_os].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[1] := Timer[t_os];
{$ENDIF}
                if t_om <> t_os then Timer[t_os] := 0;
              end;
            end;
          end;
        end else //------------------------------------------------ ���� ������ �� �������
        begin
          if t_os > 0 then //----------------------------------  ���� ���������� ������ ��
          begin
            if vv <>  ObjZav[Ptr].bParam[7] then //----------------- ���� ��������� ��� ��
            begin
              if ObjZav[Ptr].Timers[t_os].Active then //------- ���� ������ �� ��� �������
              begin //--------------------------------------------- ��������� ���� �������
                if t_os <> t_om then ObjZav[Ptr].Timers[t_os].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[1] := Timer[t_os];
{$ENDIF}
                if t_os <> t_om then Timer[t_os] := 0;
              end else
              begin //------------ ���� ������ ��� ��������, �� ������ ���� ������� � ����
                ObjZav[Ptr].Timers[t_os].Active := true;
                ObjZav[Ptr].Timers[t_os].First := LastTime;
                Timer[t_os] := 0;
              end;
            end;
          end;
          ObjZav[Ptr].bParam[7] := vv;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7];
        end;
        ObjZav[Ptr].bParam[1] := os;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1];

        //------------------------------------------------------------ ������ ����������
        if ObjZav[Ptr].ObjConstI[11] = 0 then //--------- ���� ��� ������� �� (�� 12-90)
        begin
          if ObjZav[Ptr].ObjConstI[6] > 0 then
          begin //----------------------------- ���� ������ ���������� ������ ����������
            if om <> ObjZav[Ptr].bParam[2] then //---------------- ���� ��������� ��� ��
            begin
              if ObjZav[Ptr].Timers[t_om].Active then //----- ���� ������ �� ��� �������
              begin //------------------------------------------- ��������� ���� �������
                ObjZav[Ptr].Timers[t_om].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[2] := Timer[t_om];
{$ENDIF}
                Timer[t_om] := 0;
              end else
              begin //----------------- ���� ������ ��� ��������, �� ������ ���� �������
                ObjZav[Ptr].Timers[t_om].Active := true;
                ObjZav[Ptr].Timers[t_om].First := LastTime;
                Timer[t_om] := 0;
              end;
            end;
          end;
        end else //------------------------------------------------ ���� ������ �� �������
        begin
          if t_om > 0 then
          begin //----------------------------------------------- ������ ������ ����������
            if om <> ObjZav[Ptr].bParam[2] then
            begin
              if (t_om <> t_os) and ObjZav[Ptr].Timers[t_om].Active then
              begin //--------------------------------------------- ��������� ���� �������
                ObjZav[Ptr].Timers[t_om].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[2] := Timer[t_om];
{$ENDIF}
                Timer[t_om] := 0;
              end else
              begin //------------------------------------------------ ������ ���� �������
                ObjZav[Ptr].Timers[t_om].Active := true;
                if t_om <> t_os then
                begin
                  ObjZav[Ptr].Timers[t_om].First := LastTime;
                  Timer[t_om] := 0;
                end;
              end;
            end;
          end;

          ObjZav[Ptr].bParam[2] := om;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2];

          if t_op > 0 then
          begin //------------------------------------------------- ������ ������ ��������
            if op <> ObjZav[Ptr].bParam[3] then
            begin
              if ObjZav[Ptr].Timers[t_op].Active then
              begin //--------------------------------------------- ��������� ���� �������
                ObjZav[Ptr].Timers[t_op].Active := false;
{$IFDEF RMSHN}
                ObjZav[Ptr].siParam[3] := Timer[t_op];
{$ENDIF}
                if t_op <> t_om then Timer[t_op] := 0;
              end else
              begin //---------------------------------------------- ������ ���� �������
                ObjZav[Ptr].Timers[t_op].Active := true;
                ObjZav[Ptr].Timers[t_op].First := LastTime;
                Timer[t_op] := 0;
              end;
            end;
          end;
        end;

        ObjZav[Ptr].bParam[3] := op;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6];

        if ObjZav[Ptr].Timers[t_os].Active then
        begin //------------------------- �������� �������� ������� ������ �� ����������
          Timer[t_os] := Round((LastTime - ObjZav[Ptr].Timers[t_os].First)*86400);
          if Timer[t_os] > 300 then Timer[t_os] := 300;
        end;

        if (t_om <> t_os) and ObjZav[Ptr].Timers[t_om].Active then
        begin //---------------------------- �������� �������� ������� ������ ����������
          Timer[t_om] := Round((LastTime - ObjZav[Ptr].Timers[t_om].First)*86400);
          if Timer[t_om] > 300  then Timer[t_om] := 300;
        end;

        if (t_op <> t_om) and ObjZav[Ptr].Timers[t_op].Active then
        begin //------------------------------ �������� �������� ������� ������ ��������
          Timer[t_op] := Round((LastTime - ObjZav[Ptr].Timers[t_op].First)*86400);
          if Timer[t_op] > 300 then Timer[t_op] := 300;
        end;
      end else
      begin // ����� ��������� ��� ����������� ������� ���������� ��� ��������� ����������
        if t_os > 0 then  Timer[t_os] := 0;
        ObjZav[Ptr].Timers[t_os].Active := false;
        ObjZav[Ptr].bParam[1] := false;

        if t_om > 0 then  Timer[t_om] := 0;
        ObjZav[Ptr].Timers[t_om].Active := false;
        ObjZav[Ptr].bParam[2] := false;

        if t_op > 0 then  Timer[t_op] := 0;
        ObjZav[Ptr].Timers[t_op].Active := false;
        ObjZav[Ptr].bParam[3] := false;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepOtmen]');
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------------------------- ���������� ������� ��� ��� ������ �� ����� #22
procedure PrepGRI(Ptr : Integer);
var
  rz : boolean;
  ii : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //------------------------------------------ �����������
    for ii := 1 to 34 do ObjZav[Ptr].NParam[ii] := false; //----------------- ��������������

    rz:=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);//- ���1

    ObjZav[Ptr].bParam[3]:=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]); //- ���

    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]); //-- ��

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      for ii:=1 to 32 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii]:=ObjZav[Ptr].NParam[ii];

      if ObjZav[Ptr].bParam[31] then
      begin
        if rz <> ObjZav[Ptr].bParam[2] then //------------- ���� ���������� ��������� ���1
        begin
          if ObjZav[Ptr].ObjConstI[5] > 0 then //���� ���� ������ �������������� ����������
          begin
            if ObjZav[Ptr].Timers[1].Active then //------------------- ���� ������ �������
            begin
              ObjZav[Ptr].Timers[1].Active := false; //------------ ��������� ���� �������
{$IFDEF RMSHN}
              ObjZav[Ptr].siParam[1] := Timer[ObjZav[Ptr].ObjConstI[5]]; // ������ �������
{$ENDIF}
              Timer[ObjZav[Ptr].ObjConstI[5]] := 0; //------------- �������� ������ � ����
            end else  //--------------------------------------------- ���� ������ ��������
            begin
              ObjZav[Ptr].Timers[1].Active := true;  //--------------- ������ ���� �������
              ObjZav[Ptr].Timers[1].First := LastTime;
              Timer[ObjZav[Ptr].ObjConstI[5]] := 0;  //--------------------- ������ � ����
            end;
          end;

          if rz then
          begin
            if WorkMode.FixedMsg and (config.ru = ObjZav[ptr].RU) then
            begin
              InsArcNewMsg(Ptr,375+$2000,0); //------------------- "������ �������� �������"
              AddFixMessage(GetShortMsg(1,375,ObjZav[Ptr].Liter,0),0,6);
            end;
          end;
        end;

        ObjZav[Ptr].bParam[2] := rz;      //------------ ��������� ������� ��������� ��� 1
        //--------------------------------------------------  ��������� ���������� �������
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[5];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[6];

        if ObjZav[Ptr].Timers[1].Active then
        begin //--------------------------------------------- �������� �������� ������� ��
          Timer[ObjZav[Ptr].ObjConstI[5]] :=
          Round((LastTime - ObjZav[Ptr].Timers[1].First)*86400);
          if Timer[ObjZav[Ptr].ObjConstI[5]] > 300
          then Timer[ObjZav[Ptr].ObjConstI[5]] := 300;
        end;
      end else
      begin //����� ��������� ��� ������������� �������� ���������� ��� ��������� ����������
        if ObjZav[Ptr].ObjConstI[5] > 0 then Timer[ObjZav[Ptr].ObjConstI[5]] := 0;
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[1] := false;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepGRI]');
    Application.Terminate;
  end;
end;
//========================================================================================
//-------------------------------- ���������� ������� ������ � ��� ��� ������ �� ����� #23
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
              InsArcNewMsg(Ptr,385,1);
              AddFixMessage(GetShortMsg(1,385,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,385,1);
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,386,1);
              AddFixMessage(GetShortMsg(1,386,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,386,1);
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
              InsArcNewMsg(Ptr,387,1);
              AddFixMessage(GetShortMsg(1,387,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,387,1);
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then begin
              InsArcNewMsg(Ptr,388,1);
              AddFixMessage(GetShortMsg(1,388,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,388,1);
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
              InsArcNewMsg(Ptr,105+$2000,1);
              AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000,1);
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
//========================================================================================
//------------------ ���������� ������� ������ � �������� �������� ��� ������ �� ����� #24
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
              InsArcNewMsg(Ptr,105+$2000,1);
              AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000,1);
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
              InsArcNewMsg(ObjZav[Ptr].BaseObject,292,0);
              AddFixMessage(GetShortMsg(1,292,ObjZav[ObjZav[Ptr].BaseObject].Liter,0),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,292+$2000,0);
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
      if tab_page then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[15]
      else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    end else
{$ENDIF}
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[14];
    if ObjZav[Ptr].ObjConstB[8] or ObjZav[Ptr].ObjConstB[9] then
    begin // ���� �����������
      ObjZav[Ptr].bParam[27] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 *8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
      begin
        if tab_page
        then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // ���� 2 ���� �����������
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25]
          else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        end else
{$ENDIF}
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
        ObjZav[Ptr].bParam[29] := GetFR4State(ObjZav[Ptr].ObjConstI[8] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[26]
          else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[30] := ObjZav[Ptr].bParam[29];
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
//========================================================================================
//---------------- ���������� ������� ���������� ������� (�������) ��� ������ �� ����� #25
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
            InsArcNewMsg(Ptr,389+$2000,7); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,389,ObjZav[Ptr].Liter,7),0,6); {$ENDIF}
          end else
          begin // ����� ���������� ��������
            InsArcNewMsg(Ptr,390+$2000,7); {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,390,ObjZav[Ptr].Liter,7),0,6); {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[5] := v;
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[5]; //�
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[1]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[2]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[3]; //��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[7]; //����� ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[6]; //���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[8]; //������ ������� ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[9]; //���
    end;
  end;
except
  reportf('������ [MainLoop.PrepManevry]');
  Application.Terminate;
end;
end;
//========================================================================================
//----------------------------------------- ���������� ������� ��� ��� ������ �� ����� #26
procedure PrepPAB(Ptr : Integer);
  var fp,gp,kj,o : Boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  ObjZav[Ptr].bParam[1] :=
  not GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// ��

  fp :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- ��

  ObjZav[Ptr].bParam[3] :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); // ��������������� �������

  ObjZav[Ptr].bParam[4] :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ���

  ObjZav[Ptr].bParam[5] :=
  not GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// ��

  ObjZav[Ptr].bParam[6] :=
  GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //---- �

  kj :=
  not GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);// ��

  o :=
  GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //-- �

  gp :=
  not GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//��

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
          if ObjZav[Ptr].RU = config.ru then
          begin
            InsArcNewMsg(Ptr,357+$2000,0);
            AddFixMessage(GetShortMsg(1,357,ObjZav[Ptr].Liter,0),0,6);
          end;
{$ELSE}
           InsArcNewMsg(Ptr,357+$2000,0);
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
              InsArcNewMsg(ObjZav[Ptr].BaseObject,405+$1000,1); AddFixMessage(GetShortMsg(1,405,'�'+ObjZav[ObjZav[Ptr].BaseObject].Liter,1),0,4);
            end;
{$ELSE}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,405+$1000,1);
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[8] := o;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := o;

      if gp <> ObjZav[Ptr].bParam[9] then
      begin //
        if not gp and (config.ru = ObjZav[ptr].RU) then Ip1Beep := not ObjZav[Ptr].bParam[1] and WorkMode.Upravlenie;
      end;
      ObjZav[Ptr].bParam[9] := gp; // ��
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := gp;

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
          if fp and (config.ru = ObjZav[ptr].RU)
          then SingleBeep := WorkMode.Upravlenie; // ���� ��������� � �������� ������ �� ������� (�������� ��������)
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
        if tab_page
        then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[24]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      end else
{$ENDIF}
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[29] := ObjZav[Ptr].bParam[27];
      if ObjZav[Ptr].ObjConstB[8] and ObjZav[Ptr].ObjConstB[9] then
      begin // ���� 2 ���� �����������
        ObjZav[Ptr].bParam[28] := GetFR4State(ObjZav[Ptr].ObjConstI[13] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZav[Ptr].RU = config.ru) then
        begin
          if tab_page
          then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[25]
          else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[31] := ObjZav[Ptr].bParam[28];
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
//========================================================================================
//-------------------------- ���������� ������� ���������� ������� ��� ������ �� ����� #27
procedure PrepDZStrelki(Ptr : Integer);
var
  ohr,
  videobuf,
  kontr,
  sp_kont,
  hvost_ohr,
  rzs : integer;
begin
  try
    inc(LiveCounter);
    if ObjZav[Ptr].ObjConstI[3] > 0 then  //------------------- ���� ���� �������� �������
    begin //---------------------------------------- ���������� ��������� �������� �������
      kontr := ObjZav[Ptr].ObjConstI[1]; //---- ������ �������, ����������� �� �����������
      sp_kont := ObjZav[Ptr].ObjConstI[2]; //---- ������ �� ����������� ������� (� ������)
      ohr := ObjZav[Ptr].ObjConstI[3]; //----------------- ������ ������� �������� �������
      videobuf := ObjZav[ohr].VBufferIndex; //---------------- ���������� �������� �������
      hvost_ohr := ObjZav[ohr].BaseObject; //----- ������ ������� "����� �������� �������"
      rzs := ObjZav[hvost_ohr].ObjConstI[12];//---------- ������ ������� ��������� �������

      if kontr > 0 then //---------------------------------- ���� ���� ����������� �������
      begin
        if not ObjZav[rzs].bParam[1] and //----------- ��� ������� ��������� ������� � ...
        ObjZav[hvost_ohr].bParam[21] then //--- �������� ������� �� �������� ����� ���� ��
        begin
          if (ObjZav[Ptr].ObjConstB[1] and //-- ���� ������� �������������� �� ����� � ...
          ObjZav[kontr].bParam[1]) or //- ����������� ������� ����������� �� ����� ��� ...

          (ObjZav[Ptr].ObjConstB[2] and //---- ���� ������� �������������� �� ������ � ...
          ObjZav[kontr].bParam[2]) //----------- ����������� ������� ����������� �� ������
          then
          begin

            ObjZav[ohr].bParam[4] := //�������������� ��������� �������� ������� ����� ...
            ObjZav[ohr].bParam[25] or ObjZav[ohr].bParam[33] or //---- ��� ��� ��� ��� ...
            (not ObjZav[sp_kont].bParam[2]); //---------- ��������� �� ����������� �������

            ObjZav[hvost_ohr].bParam[4] := // ���. ��������� ������ �������� ������� �����
            not ObjZav[sp_kont].bParam[2]; //------------ ��������� �� ����������� �������

            OVBuffer[videobuf].Param[7] := ObjZav[hvost_ohr].bParam[4];

          end;
        end;

        if not ObjZav[hvost_ohr].bParam[21] and not ObjZav[rzs].bParam[1]
        then //------------------------------- ����� �������� ������� ������� �� ������ ��
        begin
          ObjZav[ohr].bParam[4] := false; //--- �������� �������������� ��������� ��������
          ObjZav[ohr].bParam[4] := ObjZav[ohr].bParam[4] or
          ObjZav[ohr].bParam[26] or ObjZav[ohr].bParam[27];

          ObjZav[hvost_ohr].bParam[4] := false; //�������� �������������� ��������� ������
          ObjZav[ohr].bParam[14] := false; //----- �������� ����������� ��������� ��������
          ObjZav[hvost_ohr].bParam[14] := false; //- �������� ����������� ��������� ������
        end;

        //--------------------------------- ����������� �������� ����� �������� ����������
        if ObjZav[kontr].bParam[14] then //--- ���� ���� ����������� ��������� �����������
        begin
          ObjZav[Ptr].bParam[23] := true; //--- �������� �����. ��������� �������� �������
          if ObjZav[Ptr].ObjConstB[1] then //--------- �������������� ������������ � �����
          begin
            if ObjZav[kontr].bParam[6] then //----------------------------- ���� ������ ��
            begin
              if  (not ObjZav[kontr].bParam[11] or//���� ��� ������� ������� �� ������ ���
              ObjZav[kontr].bParam[12]) then //- ����������� ������� -  ���������� � �����
              begin
                if ObjZav[Ptr].ObjConstB[3] then //---------- �������� ������ ���� � �����
                begin
                  if not ObjZav[ohr].bParam[1] //---------------- �������� ���� �� � �����
                  then ObjZav[Ptr].bParam[8] := true; //- ������� �������� �������� � ����
                end else
                if ObjZav[Ptr].ObjConstB[4] then //--------- �������� ������ ���� � ������
                begin
                  if not ObjZav[ohr].bParam[2] //--------------- �������� ���� �� � ������
                  then ObjZav[Ptr].bParam[8] := true; // ������� �������� �������� � �����
                end;
              end;
            end;
          end else
          if ObjZav[Ptr].ObjConstB[2] then //-------- �������������� ������������ � ������
          begin
            if ObjZav[kontr].bParam[7] then //----------------------------------------- ��
            begin
              if ObjZav[Ptr].ObjConstB[3] then //------------ �������� ������ ���� � �����
              begin
                if not ObjZav[ohr].bParam[1]
                then ObjZav[Ptr].bParam[8] := true;
              end else
              if ObjZav[Ptr].ObjConstB[4] then //----------- �������� ������ ���� � ������
              begin
                if not ObjZav[ohr].bParam[2]
                then ObjZav[Ptr].bParam[8] := true;
              end;
            end;
          end;
        end else

        ObjZav[Ptr].bParam[23] := false;//------ ����� ���������������� ��������� ��������

        if not ObjZav[Ptr].bParam[8] then //-- ���� ��� �������� �������� �������� �������
        begin //--------------------------- ����������� �������� ����� �������� ����������
          if ObjZav[Ptr].ObjConstB[1] then //- �������������� ������� ������������ � �����
          begin
            if ((ObjZav[kontr].bParam[10] and
            not ObjZav[kontr].bParam[11]) or
            ObjZav[kontr].bParam[12])
            then ObjZav[Ptr].bParam[5] := true; //------------- ��������� ������� ��������
          end else
          if ObjZav[Ptr].ObjConstB[2] then // �������������� ������� ������������ � ������
          begin
            if ((ObjZav[kontr].bParam[10] and
            ObjZav[kontr].bParam[11]) or
            ObjZav[kontr].bParam[13])
            then  ObjZav[Ptr].bParam[5] := true;//------------- ��������� ������� ��������
          end;
        end;
      end;

      //---------------------------- ���� � ������ �����. ��� �������� ���������� ��������
      if not ObjZav[hvost_ohr].bParam[5] then
      ObjZav[hvost_ohr].bParam[5] := ObjZav[Ptr].bParam[5]; // ���������� ���������� �� ��

      //------------------------------ ���� � ������ �����. ��� �������� �������� ��������
      if not ObjZav[hvost_ohr].bParam[8] then
      ObjZav[hvost_ohr].bParam[8] := ObjZav[Ptr].bParam[8]; //-- ���������� �������� �� ��

      if not ObjZav[hvost_ohr].bParam[23] then //���� ��� �������� ���������� ��� ��������
      ObjZav[hvost_ohr].bParam[23] := ObjZav[Ptr].bParam[23]; // ������� ����������� �� ��
    end;
  except
    {$IFNDEF RMARC}
    reportf('������ [MainLoop.PrepDZStrelki]');
    {$ENDIF}
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------- ���������� ������� ���� ��������� ������ ��� ������ �� ����� #30
procedure PrepDSPP(Ptr : Integer);
var
  egs : boolean;
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
            InsArcNewMsg(ObjZav[Ptr].BaseObject,105+$2000,1); AddFixMessage(GetShortMsg(1,105,ObjZav[ObjZav[Ptr].BaseObject].Liter,1),0,6);
{$ELSE}
            InsArcNewMsg(ObjZav[Ptr].BaseObject,105+$2000,1);
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
//========================================================================================
//------------------- ���������� ������� ��������������� ��������� ��� ������ �� ����� #31
procedure PrepPSvetofor(Ptr : Integer);
var
  o,sign : boolean;
  VidBuf,IndPovt,Sig,Cod : Integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������
    VidBuf := ObjZav[Ptr].VBufferIndex;
    IndPovt := ObjZav[Ptr].ObjConstI[2];
    Sig := ObjZav[Ptr].BaseObject;
    //-------------------------------------------------------------- ��������� �����������
    o :=  GetFR3(IndPovt,ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);
    sign := ObjZav[Sig].bParam[4];

    Cod := 0;
    if sign then Cod := Cod + 2;
    if o then Cod := Cod + 1;

    if VidBuf > 0 then //--------------------------------- ���� ���� ����������� �� ������
    begin
      OVBuffer[VidBuf].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[VidBuf].Param[1] := ObjZav[Ptr].bParam[32];

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if Cod <> ObjZav[Ptr].iParam[1] then
        if not ObjZav[Ptr].Timers[1].Active then
        begin
          ObjZav[Ptr].Timers[1].Active := true;
          ObjZav[Ptr].Timers[1].First := LastTime + 3/80000;
        end;

        if ObjZav[Ptr].Timers[1].Active then
        begin //------------------------------------------------------ ���� ��������� ����
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin //---------------------------------------------------- ������� 3-4 �������
            //------ ������� �������, ��� ������ ������, ��� = 0 (��������� ��� ���������)
            ObjZav[Ptr].bParam[1] := false; //---------------- ����� ������� �������������
            ObjZav[Ptr].bParam[2] := false; //-------- ����� ������� ��������� �����������
            ObjZav[Ptr].bParam[3] := false; //------------- ����� ������� ��������� ������

            case Cod of
              1:
              begin
                ObjZav[Ptr].bParam[2] := true;
                ObjZav[Ptr].bParam[3] := true; //---- ������ ������, ��� = 1(������������)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZav[ptr].RU then
                  begin
                    InsArcNewMsg(Ptr,579+$1000,0); //--- ������������� ������� �����������
                    AddFixMessage(GetShortMsg(1,579,ObjZav[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsArcNewMsg(Ptr,579+$1000,1); SingleBeep4 := true;
{$ENDIF}
                end;
              end;

              2:
              begin
                ObjZav[Ptr].bParam[1] := true; //--- ������ ������, ��� = 0(�������������)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZav[ptr].RU then
                  begin
                    InsArcNewMsg(Ptr,339+$1000,0);//---- ������������� ������� �����������
                    AddFixMessage(GetShortMsg(1,339,ObjZav[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsArcNewMsg(Ptr,339+$1000,1); SingleBeep4 := true;
{$ENDIF}
                end;
              end;

              3:  ObjZav[Ptr].bParam[2] := true; //������ ������, ��� = 1(����� ���������)
            end;
            ObjZav[Ptr].iParam[1]:= Cod;
            ObjZav[Ptr].Timers[1].Active := false;
            ObjZav[Ptr].Timers[1].First := 0;
          end;
        end;
        OVBuffer[VidBuf].Param[3] := ObjZav[Ptr].bParam[1];
        OVBuffer[VidBuf].Param[4] := ObjZav[Ptr].bParam[3];
      end;
      OVBuffer[VidBuf].Param[2] := ObjZav[Ptr].bParam[2];
    end;
  except
    reportf('������ [MainLoop.PrepPSvetofor]');
    Application.Terminate;
  end;
end;
//========================================================================================
//---------------------------- ���������� ������� ������� �� ����� ��� ������ �� ����� #32
procedure PrepNadvig(Ptr : Integer);
  var egs,sn,sm : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ �����������
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- ��������������
  ObjZav[Ptr].bParam[1] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);  //-- ��

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- ��

  ObjZav[Ptr].bParam[3] :=
  GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- ��

  ObjZav[Ptr].bParam[4] :=
  GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- ��

  ObjZav[Ptr].bParam[5] :=
  GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ���

  ObjZav[Ptr].bParam[6] :=
  GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- ��

  egs :=
  GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ���

  sn :=
  GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- ��

  sm :=
  GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ��

  ObjZav[Ptr].bParam[10] :=
  GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//---- �

  ObjZav[Ptr].bParam[11] :=
  GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//---- �

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
        begin //------------------------------------------------ ������������� ������� ���
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,105+$2000,1);
              AddFixMessage(GetShortMsg(1,105,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,105+$2000,1);
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
          begin //---------------------------------------------- �������� �������� �������
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,381+$2000,1);
              AddFixMessage(GetShortMsg(1,381,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,381+$2000,1);
            SingleBeep6 := true;
{$ENDIF}
          end else
          begin //------------------------------------------------- ����� �������� �������
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,382+$2000,1);
              AddFixMessage(GetShortMsg(1,382,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,382+$2000,1);
            SingleBeep6 := true;
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
          begin //--------------------------------------------- �������� �������� ��������
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,383+$2000,1);
              AddFixMessage(GetShortMsg(1,383,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,383+$2000,1);
            SingleBeep6 := true;
{$ENDIF}
          end else
          begin //------------------------------------------------ ����� �������� ��������
{$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,384+$2000,1);
              AddFixMessage(GetShortMsg(1,384,ObjZav[Ptr].Liter,1),0,6);
            end;
{$ELSE}
            InsArcNewMsg(Ptr,384+$2000,1);
            SingleBeep6 := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZav[Ptr].bParam[9] := sm;

      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6]  := ObjZav[Ptr].bParam[8];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7]  := ObjZav[Ptr].bParam[9];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8]  := ObjZav[Ptr].bParam[7];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9]  := ObjZav[Ptr].bParam[5];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[6];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[11];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[10];

      {FR4}
      ObjZav[Ptr].bParam[12] := GetFR4State(ObjZav[Ptr].ObjConstI[1]*8+2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page
        then OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[13]
        else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[32] := ObjZav[Ptr].bParam[12];
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
//========================================================================================
//---------------------------------- ���������� ���������� ������� ��� ������ �� ����� #33
procedure PrepSingle(Ptr : Integer);
var
  b : boolean;
  i : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    for i := 0 to 34 do ObjZav[Ptr].NParam[i] := false;

    if ObjZav[Ptr].ObjConstB[1] then //--------------------------- ���� �������� ���������
    b := not GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31])
    else //--------------------------------------------------------- ���� ������ ���������
    b := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);

    if not ObjZav[Ptr].bParam[31] then //---------------------------------- ��� ����������
    begin
      if ObjZav[Ptr].VBufferIndex > 0 then //---------------------------- ���� �����������
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      end;
    end else
    begin
      if ObjZav[Ptr].VBufferIndex > 0 then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      end;
      if ObjZav[Ptr].bParam[1] <> b then
      begin
        if ObjZav[Ptr].ObjConstB[2] then
        begin //------ ����������� ��������� ��������� ������� - ����� ��������� ���������
          if b then
          begin
            if ObjZav[Ptr].ObjConstI[2] > 0 then //------- ���� ���� ��������� � ���������
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                if ObjZav[Ptr].ObjConstI[4] = 1   //------------- ���� ���� ������ �������
                then InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[2],0)
                else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);

                if ObjZav[Ptr].ObjConstI[4] = 1 then
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[2]],4,3)
                else
                begin //--------------------------------------------- ��������� ����������
                  PutShortMsg(ObjZav[Ptr].ObjConstI[4],LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[2]]);
                  SingleBeep := true;
                end;
              end;
{$ELSE}
              if ObjZav[Ptr].ObjConstI[4] = 1 then
              begin
                InsArcNewMsg(Ptr,$1000 + ObjZav[Ptr].ObjConstI[2],0);
                SingleBeep3 := true;
              end
              else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);

{$ENDIF}
            end;
          end else
          begin
            if ObjZav[Ptr].ObjConstI[3] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                if ObjZav[Ptr].ObjConstI[5] = 1
                then InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[3],0)
                else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],0);
                if ObjZav[Ptr].ObjConstI[5] = 1 then // ��������� �����������
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[3]],4,3)
                else
                begin //--------------------------------------------- ��������� ����������
                  PutShortMsg(ObjZav[Ptr].ObjConstI[5],LastX,LastY,MsgList[ObjZav[Ptr].ObjConstI[3]]);
//                  SingleBeep := true;
                end;
              end;
{$ELSE}
              if ObjZav[Ptr].ObjConstI[5] = 1 then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[3],0);
                SingleBeep3 := true;
              end
              else InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],0);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[1] := b;
      end;
      if ObjZav[Ptr].VBufferIndex > 0 then
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[1];
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[1] := ObjZav[Ptr].NParam[1];
    end;
  except
    reportf('������ [MainLoop.PrepSingle]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------- ���������� ������� �������� �������������� ��� ������ �� ����� #34
procedure PrepPitanie(Ptr : Integer);
var
  k1f,k2f,k3f,vf1,vf2,kpp,kpa,szk,ak,k1shvp,k2shvp,knb,knz,dsn,saut,vmg : Boolean;
  fk1,fk2,fu1,fu2,vf,pf1,la,at,kmgt : Boolean;
  i : Integer;
begin
  try

    for i := 1 to 34 do ObjZav[Ptr].NParam[i] := false;

    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    k1f:=
    GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);//-- �1�

    k2f :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);//-- �2�

    k3f :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);//-- ���

    vf1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);//-- 1��

    vf2 :=
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].NParam[5],ObjZav[Ptr].bParam[31]);//-- 2��

    kpp :=
    GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].NParam[6],ObjZav[Ptr].bParam[31]); //- ���

    kpa :=
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].NParam[7],ObjZav[Ptr].bParam[31]);//-- ���

    szk :=
    GetFR3(ObjZav[Ptr].ObjConstI[8],ObjZav[Ptr].NParam[8],ObjZav[Ptr].bParam[31]); //- ���

    ak :=
    GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[9],ObjZav[Ptr].bParam[31]); //-- ��

    k1shvp :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[10],ObjZav[Ptr].bParam[31]);//�1��

    k2shvp :=
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]);//�2��

    knz :=
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].NParam[12],ObjZav[Ptr].bParam[31]);// ���

    knb :=
    GetFR3(ObjZav[Ptr].ObjConstI[13],ObjZav[Ptr].NParam[13],ObjZav[Ptr].bParam[31]);// ���

    dsn :=
    GetFR3(ObjZav[Ptr].ObjConstI[14],ObjZav[Ptr].NParam[14],ObjZav[Ptr].bParam[31]);// ���

    saut :=
    GetFR3(ObjZav[Ptr].ObjConstI[15],ObjZav[Ptr].NParam[15],ObjZav[Ptr].bParam[31]);//����

    vmg :=
    GetFR3(ObjZav[Ptr].ObjConstI[18],ObjZav[Ptr].NParam[18],ObjZav[Ptr].bParam[31]); //���

    fk1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[19],ObjZav[Ptr].NParam[19],ObjZav[Ptr].bParam[31]); //1��

    fk2 :=
    GetFR3(ObjZav[Ptr].ObjConstI[20],ObjZav[Ptr].NParam[20],ObjZav[Ptr].bParam[31]); //2��

    fu1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[21],ObjZav[Ptr].NParam[21],ObjZav[Ptr].bParam[31]); //1��

    fu2 :=
    GetFR3(ObjZav[Ptr].ObjConstI[22],ObjZav[Ptr].NParam[22],ObjZav[Ptr].bParam[31]); //2��

    vf :=
    GetFR3(ObjZav[Ptr].ObjConstI[23],ObjZav[Ptr].NParam[23],ObjZav[Ptr].bParam[31]); // ��

    pf1 :=
    GetFR3(ObjZav[Ptr].ObjConstI[24],ObjZav[Ptr].NParam[24],ObjZav[Ptr].bParam[31]); //��1

    la :=
    GetFR3(ObjZav[Ptr].ObjConstI[25],ObjZav[Ptr].NParam[25],ObjZav[Ptr].bParam[31]); // ��

    at :=
    GetFR3(ObjZav[Ptr].ObjConstI[26],ObjZav[Ptr].NParam[26],ObjZav[Ptr].bParam[31]); // ��

    kmgt :=
    GetFR3(ObjZav[Ptr].ObjConstI[27],ObjZav[Ptr].NParam[27],ObjZav[Ptr].bParam[31]); //���

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      for i := 1 to 32 do //------------------------ ���������� ��� �������������� �������
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] := ObjZav[Ptr].NParam[i];

      if ObjZav[Ptr].bParam[31] then
      begin
        if dsn <> ObjZav[Ptr].bParam[14] then //-------------------------------------- ���
        begin
          if WorkMode.FixedMsg then
          begin
            if dsn then
            begin
              InsArcNewMsg(Ptr,358+$2000,0); //------------- ������� ����� ���������������
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,358,'',7),4,4);
              {$ELSE}  SingleBeep4 := true; {$ENDIF}
            end  else
            begin
              InsArcNewMsg(Ptr,359+$2000,0); //------------ �������� ����� ���������������
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,359,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[14] := dsn;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := dsn;

        if saut <> ObjZav[Ptr].bParam[15] then//------------------------------------- ����
        begin
         if saut then
         begin
           InsArcNewMsg(Ptr,524+$1000,1); //------------------------- "������������� ����"
           {$IFDEF RMDSP}  AddFixMessage(GetShortMsg(1,524,'',0),4,3);
           {$ELSE} SingleBeep2 := true; {$ENDIF}
         end;
         ObjZav[Ptr].bParam[15] := saut;
         OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := saut;
        end;

        if ObjZav[Ptr].ObjConstB[1] then//----------------------------------------- ������
        begin //----------------------- ��� ����� ������� (���� �������� �������� �������)
          if k1f <> ObjZav[Ptr].bParam[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsArcNewMsg(Ptr,303+$2000,0); //-------------- "�������������� 1-�� ������"
              {$IFDEF RMDSP}  AddFixMessage(GetShortMsg(1,303,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,302+$1000,0); //------------------ "���������� 1-�� ������"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,302,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := k1f;

          if k2f <> ObjZav[Ptr].bParam[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsArcNewMsg(Ptr,305+$2000,0); //-------------- "�������������� 2-�� ������"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,305,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,304+$1000,0);//------------------- "���������� 2-�� ������"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,304,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := k2f;

          if k3f <> ObjZav[Ptr].bParam[3] then
          begin
            if WorkMode.FixedMsg then
            if not k3f then
            begin
              InsArcNewMsg(Ptr,308+$2000,0); //-------------- "����������� ������� �� ���"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,308,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := k3f;

          if vf1 <> ObjZav[Ptr].bParam[4] then  //------ ���������� ���������� 1-�� ������
          begin
            if WorkMode.FixedMsg then
            if not vf1 then
            begin
              InsArcNewMsg(Ptr,306+$2000,7); //------- "����������� ������� �� 1-�� �����"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,306,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,307+$2000,0); //------- "����������� ������� �� 2-�� �����"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,307,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := vf1;

          ObjZav[Ptr].bParam[1] := k1f;
          ObjZav[Ptr].bParam[2] := k2f;
          ObjZav[Ptr].bParam[3] := k3f;
          ObjZav[Ptr].bParam[4] := vf1;
          ObjZav[Ptr].bParam[5] := vf2;
        end
        else
        begin //---------------------- ��� ������� ������� (��� �������� �������� �������)
          if k1f <> ObjZav[Ptr].bParam[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsArcNewMsg(Ptr,303+$2000,0); //----------------- "�������������� ������ 1"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,303,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,302+$1000,0);  //-------------------- "���������� ������ 1"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,302,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := k1f;

          if k2f <> ObjZav[Ptr].bParam[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsArcNewMsg(Ptr,305+$2000,0); //----------------- "�������������� ������ 2"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,305,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,304+$1000,0); //--------------------- "���������� ������ 2"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,304,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := k2f;

          if k3f <> ObjZav[Ptr].bParam[3] then
          begin
            if WorkMode.FixedMsg then
            if k3f then //------------------------------------- ����������� ������� �� ���
            begin
              InsArcNewMsg(Ptr,308+$2000,0);
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,308,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := k3f;

          if vf1 <> ObjZav[Ptr].bParam[4] then
          begin
            if WorkMode. FixedMsg then
            if not vf1 then
            begin
              InsArcNewMsg(Ptr,306+$2000,0);  //----------- ����������� ������� �� 1 �����
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,306,'',0),5,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := vf1;

          if vf2 <> ObjZav[Ptr].bParam[5] then
          begin
            if WorkMode.FixedMsg then
            if not vf2 then
            begin
              InsArcNewMsg(Ptr,307+$2000,0);
              {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,307,'',0),5,2);
              {$ELSE}
              SingleBeep2 := true;
              {$ENDIF}
            end;
          end;
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := vf2;
          ObjZav[Ptr].bParam[1] := k1f;
          ObjZav[Ptr].bParam[2] := k2f;
          ObjZav[Ptr].bParam[3] := k3f;
          ObjZav[Ptr].bParam[4] := vf1;
          ObjZav[Ptr].bParam[5] := vf2;
        end;
//------------------------------------------------------------------------------------ ���
        if kpp <> ObjZav[Ptr].bParam[6] then
        begin
          if WorkMode.FixedMsg and kpp then
          begin
            InsArcNewMsg(Ptr,284+$1000,0); //---------------- "����������� ��������������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,284,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        //---------------------------------------------------------------------------- ���
        if kpa <> ObjZav[Ptr].bParam[7] then
        begin
          if WorkMode.FixedMsg and kpa then
          begin
            InsArcNewMsg(Ptr,285+$1000,0); // ������������� ������� ���� �������� �������.
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,285,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[6] := kpp;
        ObjZav[Ptr].bParam[7] := kpa;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := kpp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := kpa;
        //---------------------------------------------------------------------------- ���
        if szk <> ObjZav[Ptr].bParam[8] then
        begin
          if WorkMode.FixedMsg then
          begin
            if szk then
            begin
              InsArcNewMsg(Ptr,286+$1000,0); //--------- "��������� �������� ���� �������"
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,286,'',0),4,3);
              {$ELSE} SingleBeep3 := true; {$ENDIF}
            end
            else
            begin
              InsArcNewMsg(Ptr,404+$2000,0); //������. ������������� �������� ���� �������
              {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,404,'',0),0,2);
              {$ELSE} SingleBeep2 := true; {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[8] := szk;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := szk;

        //----------------------------------------------------------------------------- ��
        if ak <> ObjZav[Ptr].bParam[9] then
        begin
          if WorkMode.FixedMsg and ak then
          begin
            InsArcNewMsg(Ptr,287+$1000,0); // ��������.������� ���� �����. ��������� �����
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,287,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[9] := ak;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ak;

        //-------------------------------------------------------------------------- �1���
        if k1shvp <> ObjZav[Ptr].bParam[10] then
        begin
          if WorkMode.FixedMsg and k1shvp then
          begin
            InsArcNewMsg(Ptr,288+$2000,0); //--------------------------- "���������� ���1"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,288,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[10] := k1shvp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := k1shvp;
        //-------------------------------------------------------------------------- �2���
        if k2shvp <> ObjZav[Ptr].bParam[11] then
        begin
          if WorkMode.FixedMsg and k2shvp then
          begin
            InsArcNewMsg(Ptr,289+$2000,0); //--------------------------- "���������� ���2"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,289,'',0),4,3);
            {$ELSE} SingleBeep3 := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[11] := k2shvp;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := k2shvp;

        //---------------------------------------------------------------------------- ���
        if knz <> ObjZav[Ptr].bParam[12] then
        begin
          if WorkMode.FixedMsg and knz then
          begin
            InsArcNewMsg(Ptr,290+$1000,0); //------------- "������������� ����� ������� 1"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,290,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[12] := knz;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := knz;

        //---------------------------------------------------------------------------- ���
        if knb <> ObjZav[Ptr].bParam[13] then
        begin
          if WorkMode.FixedMsg and knb then
          begin
            InsArcNewMsg(Ptr,291+$1000,0); //-------------- "��� ����� ���������� �������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,291,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[13] := knb;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := knb;

        //---------------------------------------------------------------------------- ���
        if vmg <> ObjZav[Ptr].bParam[18] then
        begin
          if WorkMode.FixedMsg and vmg then
          begin
            InsArcNewMsg(Ptr,515+$1000,0); //--------------- "���������� �������� �������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,515,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[18] := vmg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := vmg;

        //--------------------------------------- 1�� �������� ����������� ��� 1-�� ������

        if fk1 <> ObjZav[Ptr].bParam[19] then
        begin
          if WorkMode.FixedMsg and fk1 then
          begin
            InsArcNewMsg(Ptr,537+$1000,0); //---------- "��� ����� ����������� ��� ������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,537,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[19] := fk1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[19] := fk1;

        //--------------------------------------- 2�� �������� ����������� ��� 2-�� ������
        if fk2 <> ObjZav[Ptr].bParam[20] then
        begin
          if WorkMode.FixedMsg and fk2 then
          begin
            InsArcNewMsg(Ptr,537+$1000,0); //---------- "��� ����� ����������� ��� ������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,537,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[20] := fk2;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[20] := fk2;

        //-------------------------------------------- 1�� �������� ���������� 1-�� ������
        if fu1 <> ObjZav[Ptr].bParam[21] then
        begin
          if WorkMode.FixedMsg and fu1 then
          begin
            InsArcNewMsg(Ptr,538+$1000,0); //--------------- "��� ����� ���������� ������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,538,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[21] := fu1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[21] := fu1;

        //-------------------------------------------- 2�� �������� ���������� 2-�� ������
        if fu2 <> ObjZav[Ptr].bParam[22] then
        begin
          if WorkMode.FixedMsg and fu2 then
          begin
            InsArcNewMsg(Ptr,538+$1000,0); //--------------- "��� ����� ���������� ������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,538,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[22] := fu2;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[22] := fu2;

        //----------------------------------------------- �������� ���������� 2-�� �������
        if vf <> ObjZav[Ptr].bParam[23] then
        begin
          if WorkMode.FixedMsg and vf then
          begin
            InsArcNewMsg(Ptr,539+$1000,0); //---- "������������� ���������� ����� �������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,539,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[23] := vf;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[23] := vf;

        //------------------------------------------------ �������� ���������� �����������
        if pf1 <> ObjZav[Ptr].bParam[24] then
        begin
          if WorkMode.FixedMsg and pf1 then
          begin
            InsArcNewMsg(Ptr,540+$1000,0); //---------- "��� ����� ���������� �����������"
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,540,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[24] := pf1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[24] := pf1;

        //----------------------------------------------- �������� ������� ��������� �����
        if la <> ObjZav[Ptr].bParam[25] then
        begin
          if WorkMode.FixedMsg and la then
          begin
            InsArcNewMsg(Ptr,484+$1000,0); //------- ������������� ������� ��������� �����
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,484,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[25] := la;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[25] := la;

        //--------------------------------------------------------- �������� ������� �����
        if at <> ObjZav[Ptr].bParam[26] then
        begin
          if WorkMode.FixedMsg and at then
          begin
            InsArcNewMsg(Ptr,484+$1000,0); //----------------- ������������� ������� �����
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,545,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[26] := at;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[26] := at;

        if kmgt <> ObjZav[Ptr].bParam[27] then
        begin
          if WorkMode.FixedMsg and kmgt then
          begin
            InsArcNewMsg(Ptr,574+$1000,0); //----------------- ������������� ������� �����
            {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,574,'',0),4,1);
            {$ELSE} SingleBeep := true; {$ENDIF}
          end;
        end;
        ObjZav[Ptr].bParam[27] := kmgt;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[27] := kmgt;
      end;

      for i := 1 to 34 do //------------------------ ���������� ��� �������������� �������
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] := ObjZav[Ptr].NParam[i];
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i] := ObjZav[Ptr].bParam[i];
      end;
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    end;
  except
    reportf('������ [MainLoop.PrepPitanie]');
    Application.Terminate;
  end;
end;
//========================================================================================
//-------------------------------- ������ � ���������� ���������� ������� ������������ #35
procedure PrepInside(Ptr : Integer);
var
  MainObj,MainCod,cvet_lamp : Integer;
  TXT : string;
begin
  try
    inc(LiveCounter);
    if ObjZav[Ptr].BaseObject > 0 then
    begin
      MainObj := ObjZav[Ptr].BaseObject; //-------------------------------- ������� ������
      case ObjZav[Ptr].ObjConstI[1] of
        1 :
        begin //------------------------------------------------------------------------ �
          ObjZav[Ptr].bParam[1] := ObjZav[MainObj].bParam[8] or //------- � �� FR3 ��� ...
          (ObjZav[MainObj].bParam[9] and ObjZav[MainObj].bParam[14]); //---- ��� � �������
        end;

        2 :
        begin //----------------------------------------------------------------------- ��
          ObjZav[Ptr].bParam[1] := ObjZav[MainObj].bParam[6] or //------ �� �� FR3 ��� ...
          (ObjZav[MainObj].bParam[7] and ObjZav[MainObj].bParam[14]);//----- ��� � �������
        end;

        3 :
        begin //--------------------------------------------------------------------- �&��
          ObjZav[Ptr].bParam[1] := ObjZav[MainObj].bParam[6] or //------ �� �� FR3 ��� ...
          ObjZav[MainObj].bParam[8] or //-------------------------------- � �� FR3 ��� ...
          ((ObjZav[MainObj].bParam[7] or ObjZav[MainObj].bParam[9]) //---- ��� ��� ��� ...
          and ObjZav[MainObj].bParam[14]); //----------------------------------- � �������
        end;

        4 : //----------------------------------- ������ � 2-������� ������� �������� ����
        begin
          MainCod := 0;
          if ObjZav[MainObj].bParam[1] then MainCod := MainCod + 1;
          if ObjZav[MainObj].bParam[2] then MainCod := MainCod + 2;
          if MainCod <> ObjZav[MainObj].iParam[1] then //------------- ���� ��������� ����
          begin
            if ((ObjZav[Ptr].ObjConstI[MainCod+1]) <> 0) and (MainCod <> 0) then
            begin
              if MainCod = 1 then cvet_lamp := ObjZav[Ptr].ObjConstI[10];
              if MainCod = 2 then cvet_lamp := ObjZav[Ptr].ObjConstI[11];
              if MainCod = 3 then cvet_lamp := ObjZav[Ptr].ObjConstI[12];
              if cvet_lamp = 28  then cvet_lamp := 1;
              if cvet_lamp = 27  then cvet_lamp := 1;
              if cvet_lamp = 29  then cvet_lamp := 2;
              if cvet_lamp = 26  then cvet_lamp := 9;
              if cvet_lamp = 7 then cvet_lamp := 1;
              
              TXT := MsgList[ObjZav[Ptr].ObjConstI[MainCod+1]];
              PutShortMsg(cvet_lamp,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
              AddFixMessage(TXT,cvet_lamp,0);
            end;
          end;
          ObjZav[MainObj].iParam[1] := MainCod;
        end;

        5://------------------------------------- ������ � 3-������� ������� �������� ����
        begin
          MainCod := 0;
          if ObjZav[MainObj].bParam[1] then MainCod := MainCod + 1;
          if ObjZav[MainObj].bParam[2] then MainCod := MainCod + 2;
          if ObjZav[MainObj].bParam[3] then MainCod := MainCod + 4;
          if MainCod <> ObjZav[MainObj].iParam[1] then //------------- ���� ��������� ����
          begin
            if ObjZav[Ptr].ObjConstI[MainCod+1] <> 0 then
            begin
              TXT := MsgList[ObjZav[Ptr].ObjConstI[MainCod+1]];
              PutShortMsg(0,LastX,LastY,TXT);
              SingleBeep2 := WorkMode.Upravlenie;
              AddFixMessage(TXT,0,0);
            end;
          end;
          ObjZav[MainObj].iParam[1] := MainCod;
        end;

        else ObjZav[Ptr].bParam[1] := false;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepInside]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------ ���������� ������(���/����) ��� ������ �� ����� #36
procedure PrepSwitch(Ptr : Integer);
var
  b : array[1..5] of boolean;
  ii,ColorVkl,ColorOtkl : integer;
  TXT : string;
  nep : boolean;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    for ii := 1 to 32 do  ObjZav[Ptr].NParam[32] := false; //-------------- ��������������
    //---------------------------------------------------- ������������ 5 �������� �������
    for ii := 1 to 5 do
    begin
      nep := false;
      b[ii] := //-------------------------------------------------------- ������ ���������
      GetFR3(ObjZav[Ptr].ObjConstI[10+ii],nep,ObjZav[Ptr].bParam[31]);
      ObjZav[Ptr].NParam[ii] := nep;
      if ObjZav[Ptr].ObjConstB[ii] then //---------- ���� ����� �������� ��������� �������
      b[ii] := not b[ii];
    end;
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := false;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];

      //---------------------------------------------------------- ��������� 5-�� ��������
      for ii := 1 to 5 do
      if ObjZav[Ptr].bParam[ii] <> b[ii] then //------------ ���� ������ ������� ���������
      begin
        if ObjZav[Ptr].ObjConstB[ii+5] then  //-------------------- ���� ����� �����������
        begin //------ ����������� ��������� ��������� ������� - ����� ��������� ���������
          if b[ii] then //--------------------------------------- ���� ��������� ���������
          begin
            if ((ii = 1) and (ObjZav[Ptr].ObjConstI[2] > 0)) or
            ((ii > 1) and (ObjZav[Ptr].ObjConstI[16+(ii-2)*2] > 0)) then//���� ����. o ���
              if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);
                SingleBeep2 := WorkMode.Upravlenie;
                if ObjZav[Ptr].ObjConstI[23+ii] = 1 then
                begin
                  ColorVkl := 7; //------------------------------------------------ ������
                  ColorOtkl := 7; //----------------------------------------------- ������
                end else
                if ObjZav[Ptr].ObjConstI[23+ii] = 2 then
                begin
                  ColorVkl := 1; //----------------------------------------------- �������
                  ColorOtkl := 2; //---------------------------------------------- �������
                end else
                if ObjZav[Ptr].ObjConstI[23+ii] = 3 then
                begin
                  ColorVkl := 2; //----------------------------------------------- �������
                  ColorOtkl := 7; //----------------------------------------------- ������
                end else
                begin
                  ColorVkl := 15; //------------------------------------------------ �����
                  ColorOtkl := 15; //----------------------------------------------- �����
                end;

                if ii = 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[2]];
                if ii > 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[16+(ii-2)*2]];
                PutShortMsg(ColorVkl,LastX,LastY,TXT);
                SingleBeep2 := WorkMode.Upravlenie;
                AddFixMessage(TXT,0,1);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[2],0);
{$ENDIF}
            end;
          end else
          begin
            if ObjZav[Ptr].ObjConstI[3] > 0 then //----- ���� ���� ��������� �� ����������
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ii = 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[3]];
              if ii > 1 then TXT := MsgList[ObjZav[Ptr].ObjConstI[17+(ii-2)*2]];

              if config.ru = ObjZav[ptr].RU then
              begin
                InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],ColorOtkl);
                AddFixMessage(TXT,0,1);
                SingleBeep2 := WorkMode.Upravlenie;
                PutShortMsg(7,LastX,LastY,TXT);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,ObjZav[Ptr].ObjConstI[3],ColorOtkl);
{$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[ii] := b[ii];
      end;

      if ObjZav[Ptr].VBufferIndex > 0 then
      for ii := 1 to 5 do
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[ii] := ObjZav[Ptr].bParam[ii];
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];
      end;
    end;
  except
    reportf('������ [MainLoop.PrepSwitch]');
    Application.Terminate;
  end;
end;
//========================================================================================
//---------------------------- ���������� ������� �������� ������� ��� ������ �� ����� #38
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
//========================================================================================
//--------------------------------- ���������� � ������ �� ����� ����������� ����/���� #37
procedure PrepIKTUMS(Ptr : Integer);
var
  r,ao,ar,a,b,p,kp1,kp2,otu,rotu : Boolean;
  i,ii : integer;
  myt,svaz1 : byte;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������

    for i:= 1 to 32 do ObjZav[Ptr].NParam[i] :=false;

    r := //----------------------------------------------------------------------------- �
    GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);

    ao :=//---------------------------------------------------------------------------- ��
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]);

    ar :=//---------------------------------------------------------------------------- ��
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[4] :=//---------------------------------------------�������t�������
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);

    kp1 :=  //------------------------------------------------------------------------ ��1
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].NParam[5],ObjZav[Ptr].bParam[31]);

    kp2 := //------------------------------------------------------------------------- ��2
    GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].NParam[6],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[7] := //--------------------------------------------------------- �
    GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].NParam[7],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[11] := //------------------------------------------------------- ��
    GetFR3(ObjZav[Ptr].ObjConstI[9],ObjZav[Ptr].NParam[11],ObjZav[Ptr].bParam[31]);

    ObjZav[Ptr].bParam[12] :=//-------------------------------------------------------- ��
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].NParam[12],ObjZav[Ptr].bParam[31]);

    otu :=  //------------------------------------------------------------------------ ���
    GetFR3(ObjZav[Ptr].ObjConstI[11],ObjZav[Ptr].NParam[13],ObjZav[Ptr].bParam[31]);

    rotu := //----------------------------------------------------------------------- ����
    GetFR3(ObjZav[Ptr].ObjConstI[12],ObjZav[Ptr].NParam[14],ObjZav[Ptr].bParam[31]);

    //---------------- �������� ��������� ������ � ���������� ������� --------------------
    i := ObjZav[Ptr].ObjConstI[8] div 8;  //------ ��������� ������ ������ ������ �� MYTHX
    if i > 0 then
    begin
      myt := FR3[i] and $38;   //------------------------- ����������� ���� ��������� ����
      if myt > 0 then
      begin
        if myt = $38 then
        begin //-------------------------- ����������� ��������� ��������-----------------
          ObjZav[Ptr].bParam[8] := true;  //---------------- ����������� ������� ���������
          ObjZav[Ptr].bParam[9] := false; //----------- ����� �������� �������� ����������
          ObjZav[Ptr].bParam[10] := false; //-------- ����� �������� ���������� ����������
        end else //--------------------------- ���� ��� ������� ��������� �������� � �����
        begin
          ObjZav[Ptr].bParam[8] := false; //---------------- ����� �������� ��������� ����
          if myt = $28 then //----------------------- ����������� ���� �������� ����������
          begin //----------------------------- ���� �������� ���������� �������� ��������
            ObjZav[Ptr].bParam[9] := true; //-------------- ����������� ������� ����������
            ObjZav[Ptr].bParam[10] := false; //------------- �������� ��������� ����������
          end else
          begin //--------------------------- ���� ��������� ���������� ��������� ��������
            ObjZav[Ptr].bParam[9] := false; //---------------- �������� ������� ����������
            if not ObjZav[Ptr].bParam[10] then //--------------- ���� ��������� ����������
            begin
              InsArcNewMsg(Ptr,4+$3000,0); //-------------------- "������� �� ���������� "
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,4,'',0),4,4);
              {$ENDIF}
            end;
            ObjZav[Ptr].bParam[10] := true; //----------- ����������� ��������� ����������
          end;
        end;
      end;
    end;

    a := false; b := false; p := false; //------------ �������� ��������������� ����������

    if ObjZav[Ptr].VBufferIndex > 0 then //-------------------------- ���� ���� ����������
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];//-����������
      for ii := 1 to 32 do
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];

      if ObjZav[Ptr].bParam[31] then
      begin
        //------------------------------------------------ ���� ��������� ��������� �� ��1
        if kp1 <> ObjZav[Ptr].bParam[5] and not ObjZav[Ptr].NParam[5] then
        begin
          if WorkMode.FixedMsg then //----------------------------- ���� �������� ��������
          begin
            if kp1 then //------------------------ ���� ���������� �������� ������� ������
            begin
              InsArcNewMsg(Ptr,493+$3000,0); //- "������������� ��������� ��������� �������"
              {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,493,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[5] := kp1; //----------------------- ��������� �������� ��� ��1

        //------------------------------------------------ ���� ��������� ��������� �� ��2
        if kp2 <> ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].NParam[6] then
        begin
          if WorkMode.FixedMsg then
          begin
            if kp2 then//------------------------ ���� ���������� ��������� ������� ������
            begin
              InsArcNewMsg(Ptr,494+$3000,0); //������������� ���������� ��������� �������
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,494,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[6] := kp2; //---------------------------------------- ���������

        //---------------------------------------- ���� ��������� ��������� ��������� ����
        if ao <> ObjZav[Ptr].bParam[2] and not ObjZav[Ptr].NParam[2] then
        begin
          if WorkMode.FixedMsg then
          begin
            a := true;
            if ao then //--------------------------------- ���� ��������� 1 ��������� ����
            begin
              InsArcNewMsg(Ptr,366+$3000,0); //"��������� ����-1"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,366,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //---------------------------------------------- ���� ������� 1 ��������
              InsArcNewMsg(Ptr,367+$3000,0); //------------------------ "��������� ����-1"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,367,ObjZav[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[2] := ao;//------------------------------------------ ���������

        //--------------------------------------- ���� ��������� ���������� ��������� ����
        if ar <> ObjZav[Ptr].bParam[3] and not ObjZav[Ptr].NParam[3] then
        begin
          if WorkMode.FixedMsg then
          begin
            b := true;
            if ar then
            begin//-------------------------------------------- ��������� 2 ��������� ����
              InsArcNewMsg(Ptr,368+$3000,0); //"��������� ����-2"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,368,ObjZav[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //------------------------------------------------ ���� ������� ��������
              InsArcNewMsg(Ptr,369+$3000,0); //------------------------ "��������� ����-2"
              {$IFDEF RMDSP}
                AddFixMessage(GetShortMsg(1,369,ObjZav[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZav[Ptr].bParam[3] := ar;//------------------------------------------ ���������

        if ObjZav[Ptr].ObjConstB[1]  then //------------------------- ���� ���������� ����
        begin
          //------------------------------------------------ ���� ���������� ��������� ���
          if otu <> ObjZav[Ptr].bParam[13] and not ObjZav[Ptr].NParam[13] then
          begin
            if WorkMode.FixedMsg then
            begin
              if otu then //---------------------- ���� ���������� ��������� ��� ���������
              begin
                InsArcNewMsg(Ptr,500+$3000,0); //�������� ��������� �� ��������� ���������
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,500,ObjZav[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //------------------------------------ ������� ��������� ��� ���������
                InsArcNewMsg(Ptr,501+$3000,0); //-������� ��������� �� ��������� ���������
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,501,ObjZav[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZav[Ptr].bParam[13] := otu;  //------------------------------------ ���������

          //------------------------------------------ ��������� ��������� ���������� ����
          if rotu <> ObjZav[Ptr].bParam[14] and not ObjZav[Ptr].NParam[14] then
          begin
            if WorkMode.FixedMsg then
            begin
              if rotu then //------------------------- ���������� ��������� ���� ���������
              begin
                InsArcNewMsg(Ptr,502+$3000,0);//�������� ��������� �� ���������� ���������
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,502,ObjZav[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //----------------------------------- ������� ��������� ���� ���������
                InsArcNewMsg(Ptr,503+$3000,0); //������� ��������� �� ���������� ���������
                {$IFDEF RMDSP}
                  AddFixMessage(GetShortMsg(1,503,ObjZav[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZav[Ptr].bParam[14] := rotu;  //----------------------------------- ���������
        end;


        if r <> ObjZav[Ptr].bParam[1] then  //---------- ���� ������������ ���������� ����
        begin
          if WorkMode.FixedMsg then p := true;
          ObjZav[Ptr].bParam[1] := r; //---------------------------------------- ���������
        end;

        if p or a or b then  // ���� ������������ ���  ��������� ����1 ��� ��������� ����2
        begin //------------------------------- ������������� ������������ ���������� ����
          if r and not ar then //------------------------------ ������� ��������� ��������
          begin
            InsArcNewMsg(Ptr,365+$3000,0); //---------------------------- "� ������ ����2"
            {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,365,ObjZav[Ptr].Liter,0),5,2);
            {$ENDIF}
          end else
          if not r and not ao then //--------------------------- ������� �������� ��������
          begin
            InsArcNewMsg(Ptr,364+$3000,0); //---------------------------- "� ������ ����1"
            {$IFDEF RMDSP}
              AddFixMessage(GetShortMsg(1,364,ObjZav[Ptr].Liter,0),5,2);
            {$ENDIF}
          end;
          ObjZav[Ptr].bParam[1] := r; //---------------------------------------- ���������
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //-------------------------------------------------------- ������ � �������� �����
        if (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][2]) and
        (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][3]) then
        svaz1 := config.SVAZ_TUMS[1][1] //------------- ��������� ��������� �������� �����
        else exit;

        if svaz1 <> ObjZav[Ptr].iParam[1] then //------------- ���������� ��������� ������
        begin
          if (svaz1 and $40) = $40 then WorkMode.OKError := true
          else WorkMode.OKError := false;

          if ObjZav[Ptr].ObjConstI[13] = 1 then//------------------------------ ��� ���� 1
          begin
            if (svaz1 and $1) = $1 then //----------------------------------- ������ �����
            begin
              ObjZav[Ptr].bParam[18] := true;
              if not ObjZav[Ptr].bParam[33] then //--------- �� ���� �������� ������ �����
              begin
                AddFixMessage(GetShortMsg(1,433,'1',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[33] := true;
              end;
            end else //-------------------------------------------------- ��� ������ �����
            begin
              if ObjZav[Ptr].bParam[33] then //---------------- ���� �������� ������ �����
              begin
                AddFixMessage(GetShortMsg(1,434,'1',0),5,2);
                InsArcNewMsg(0,434+$1000,0);
                ObjZav[Ptr].bParam[33] := false;
              end;
              ObjZav[Ptr].bParam[18] := false;
            end;

            if (svaz1 and $4) = $4 then //-------------------------------------- ������ ��
            begin
              ObjZav[Ptr].bParam[17] := true;
              if not ObjZav[Ptr].bParam[30] then //------------ �� ���� �������� ������ ��
              begin
                AddFixMessage(GetShortMsg(1,519,'1',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[30] := true;
              end;
            end else //----------------------------------------------------- ��� ������ ��
            begin
              if ObjZav[Ptr].bParam[30] then //------------------- ���� �������� ������ ��
              begin
                AddFixMessage(GetShortMsg(1,520,'1',0),5,2);
                InsArcNewMsg(0,520+$1000,0);
                ObjZav[Ptr].bParam[30] := false;
              end;
              ObjZav[Ptr].bParam[17] := false;
            end;
          end else
          if ObjZav[Ptr].ObjConstI[13] = 2 then //--------------------------------- ����-2
          begin
            if (svaz1 and $2) = $2 then //----------------------------------- ������ �����
            begin
              ObjZav[Ptr].bParam[18] := true;
              if not ObjZav[Ptr].bParam[33] then //--------- �� ���� �������� ������ �����
              begin
                AddFixMessage(GetShortMsg(1,433,'2',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[33] := true;
              end;
            end else //-------------------------------------------------- ��� ������ �����
            begin
              if ObjZav[Ptr].bParam[33] then //---------------- ���� �������� ������ �����
              begin
                AddFixMessage(GetShortMsg(1,434,'2',0), 5,2);
                InsArcNewMsg(0,434+$1000,0);
                ObjZav[Ptr].bParam[33] := false;
              end;
              ObjZav[Ptr].bParam[18] := false;
            end;

            if (svaz1 and $8) = $8 then //-------------------------------------- ������ ��
            begin
              ObjZav[Ptr].bParam[17] := true;
              if not ObjZav[Ptr].bParam[30] then //------------ �� ���� �������� ������ ��
              begin
                AddFixMessage(GetShortMsg(1,519,'2',0),4,3);
                InsArcNewMsg(0,433+$1000,0);
                ObjZav[Ptr].bParam[30] := true;
              end;
            end else //----------------------------------------------------- ��� ������ ��
            begin
              if ObjZav[Ptr].bParam[30] then //------------------- ���� �������� ������ ��
              begin
                AddFixMessage(GetShortMsg(1,520,'2',0),5,2);
                InsArcNewMsg(0,520+$1000,0);
                ObjZav[Ptr].bParam[30] := false;
              end;
              ObjZav[Ptr].bParam[17] := false;
            end;
          end;

          //-------------------------------------------------------------- ������� �������
          if (svaz1 and $20) = $20 then
          begin
            ObjZav[Ptr].bParam[19] := true;
            if not ObjZav[Ptr].bParam[32] then //--------------- �� ���� �������� ��������
            begin
              AddFixMessage(GetShortMsg(1,521,'2',0),4,2);
              InsArcNewMsg(0,521+$1000,0);
              ObjZav[Ptr].bParam[32] := true;
            end;
          end else
          begin //--------------------------------------------------- ��� �������� �������
            if ObjZav[Ptr].bParam[32] then //---------------------- ���� �������� ��������
            begin
              AddFixMessage(GetShortMsg(1,520,'2',0),5,2);
              InsArcNewMsg(0,520+$1000,0);
              ObjZav[Ptr].bParam[32] := false;
            end;
            ObjZav[Ptr].bParam[19] := false;
          end;

          //--------------------------- �������� �� ������� ������� � ���������� ���������
          if (svaz1 and $40) = $40 then KOMANDA_OUT := true //- ������ ������� � ����� ���
          else KOMANDA_OUT := false;

          if(KOMANDA_OUT and (not KVITOK)) then //���� ������ �������, �� ��� ������������
          begin
            ObjZav[Ptr].bParam[21] := true; //------ ���������, ��� ������� ������ � �����
            if not ObjZav[Ptr].bParam[29] then //--------- �� ���� �������� ������ �������
            begin
              AddFixMessage(GetShortMsg(1,535,'',0),7,2);
              InsArcNewMsg(0,535+$1000,0);
              ObjZav[Ptr].bParam[29] := true; //- ���������� ���������� �������� ���������
            end;
          end;

          //------------------------------------------------------- ������ ����� � �������
          if (svaz1 and $10) = $10 then
          begin
            ObjZav[Ptr].bParam[20] := true;
            if not ObjZav[Ptr].bParam[34] then //---------- �� ���� �������� ������ ������
            begin
              AddFixMessage(GetShortMsg(1,522,'',0),4,2);
              InsArcNewMsg(0,522+$1000,0);
              ObjZav[Ptr].bParam[34] := true;
            end;
          end else
          begin //------------------------------------------------------ ��� ������ ������
            if ObjZav[Ptr].bParam[34] then //----------------- ���� �������� ������ ������
            begin
              AddFixMessage(GetShortMsg(1,523,'',0),5,2);
              InsArcNewMsg(0,523+$1000,0);
              ObjZav[Ptr].bParam[34] := false;
            end;
            ObjZav[Ptr].bParam[20] := false;
          end;

          if((not KOMANDA_OUT) and (not KVITOK)) then//���� ������� �������� ��� ���������
          begin
            if WorkMode.OtvKom and (NET_PRIEMA_UVK <> 0) then
            begin
                AddFixMessage(GetShortMsg(1,542,'',0),4,3); // ������� �� ������� ��������
                InsArcNewMsg(0,542+$1000,0);
                SingleBeep3 := true;
                NET_PRIEMA_UVK := 0;
                ObjZav[Ptr].bParam[29] := false; //----------- �������� �������� ���������
                ObjZav[Ptr].bParam[21] := false; //--------- ����� �������� ������ �������
                WorkMode.OtvKom := false;
            end else
            if ObjZav[Ptr].bParam[21] then //---------- ���� ����� �������� ������ �������
            begin
              inc(NET_PRIEMA_UVK);
              if WorkMode.OtvKom then inc(NET_PRIEMA_UVK);
              AddFixMessage(GetShortMsg(1,541,'',0),4,4); //----- ��� ������ ������� � ���
              InsArcNewMsg(0,541+$1000,0);
              ObjZav[Ptr].bParam[29] := false; //------------- �������� �������� ���������
              ObjZav[Ptr].bParam[21] := false; //----------- ����� �������� ������ �������

              if NET_PRIEMA_UVK >= 2 then
              begin
                inc(NET_PRIEMA_UVK);
                AddFixMessage(GetShortMsg(1,542,'',0),4,3); // ������� �� ������� ��������
                InsArcNewMsg(0,542+$1000,0);
                SingleBeep3 := true;
                NET_PRIEMA_UVK := 0;
                ObjZav[Ptr].bParam[29] := false; //----------- �������� �������� ���������
                ObjZav[Ptr].bParam[21] := false; //--------- ����� �������� ������ �������
              end;
            end;
          end;

          if(KOMANDA_OUT and KVITOK) then //���� ������ �������, � ������ ��������� �� ���
          begin //---------------------------------------------- ���� ��������� �� �������
            if ObjZav[Ptr].bParam[21] then //---------- ���� ����� �������� ������ �������
            begin
              AddFixMessage(GetShortMsg(1,536,'',0),5,2); //----------- ��� ������ �������
              InsArcNewMsg(0,536+$1000,0);
              ObjZav[Ptr].bParam[29] := false; //------------- �������� �������� ���������
              ObjZav[Ptr].bParam[21] := false; //----------- ����� �������� ������ �������
            end;
          end;
          ObjZav[Ptr].iParam[1] := svaz1;
        end;

        //--------------------- ��������� ��������� ����������� --------------------------
        for ii := 1 to 15 do
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[ii] := ObjZav[Ptr].bParam[ii];
          OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];
        end;

        for ii := 17 to 32 do
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[ii] := ObjZav[Ptr].bParam[ii];
          OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[ii] := ObjZav[Ptr].NParam[ii];
        end;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepIKTUMS]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------------------------- �������� ������ ���������� #39
var ops : array[1..3] of Integer;
procedure PrepKRU(Ptr : Integer);
var
  group,i : integer;
  lock,nepar,Ru,Ou,Su,Vsu,Du : boolean;
  ps : array[1..3] of Integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    nepar := false; //----------------------------------------------------- ��������������


    Ru := GetFR3(ObjZav[Ptr].ObjConstI[2],nepar,ObjZav[Ptr].bParam[31]); //------------ ��

    Ou := GetFR3(ObjZav[Ptr].ObjConstI[3],nepar,ObjZav[Ptr].bParam[31]); //------------ ��

    Su := GetFR3(ObjZav[Ptr].ObjConstI[4],nepar,ObjZav[Ptr].bParam[31]); //------------ ��

    Vsu := GetFR3(ObjZav[Ptr].ObjConstI[5],nepar,ObjZav[Ptr].bParam[31]); //---------- ���

    Du := GetFR3(ObjZav[Ptr].ObjConstI[6],nepar,ObjZav[Ptr].bParam[31]); //------------ ��

    if (Ru <> ObjZav[Ptr].bParam[1]) or (Ou <> ObjZav[Ptr].bParam[2]) or
    (Su <> ObjZav[Ptr].bParam[3]) or (Vsu <> ObjZav[Ptr].bParam[4]) or
    (Du <> ObjZav[Ptr].bParam[5]) then   ChDirect := true;

    ObjZav[Ptr].bParam[1] := Ru; ObjZav[Ptr].bParam[2] := Ou; ObjZav[Ptr].bParam[3] := Su;
    ObjZav[Ptr].bParam[4] := Vsu;  ObjZav[Ptr].bParam[5] := Du;

    ObjZav[Ptr].bParam[32] := nepar; //------------------------------------ ��������������

    if ObjZav[Ptr].ObjConstI[7] > 0 then
    ObjZav[Ptr].bParam[6] :=
    not GetFR3(ObjZav[Ptr].ObjConstI[7],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31])//���
    else ObjZav[Ptr].bParam[6] := true;

    group := ObjZav[Ptr].ObjConstI[1];//------------------- ����� ������ �������� ��������

    if ObjZav[Ptr].ObjConstI[1] < 1 then group := 0;
    if ObjZav[Ptr].ObjConstI[1] > 8 then group := 0;

    //----------------------------------------------------- ��������� ��������� ����������
    WorkMode.BU[group] := not ObjZav[Ptr].bParam[31]; //-------------- �������� ����������

    WorkMode.NU[group] := ObjZav[Ptr].bParam[32];     //----------- �������� �������������

    if ObjZav[Ptr].ObjConstI[2] > 0 //-------------------------------- ���� ���� ������ ��
    then WorkMode.RU[group] := ObjZav[Ptr].bParam[1];//�������� ���������� ������ "�����"

    if ObjZav[Ptr].ObjConstI[3] > 0 //-------------------------------- ���� ���� ������ ��
    then WorkMode.OU[group] := ObjZav[Ptr].bParam[2];//- �������� ���������� ������ "���"

    if ObjZav[Ptr].ObjConstI[4] > 0  //------------------------------- ���� ���� ������ ��
    then WorkMode.SUpr[group] := ObjZav[Ptr].bParam[3]; //-- �������� ���������� ������ ��

    if ObjZav[Ptr].ObjConstI[5] > 0 //------------------------------- ���� ���� ������ ���
    then WorkMode.VSU[group] := ObjZav[Ptr].bParam[4]; //- �������� ���������� ������� ���

    if ObjZav[Ptr].ObjConstI[6] > 0 //---------------------------------���� ���� ������ ��
    then WorkMode.DU[group] := ObjZav[Ptr].bParam[5]; //--- �������� ���������� ������� ��

    WorkMode.KRU[group] := ObjZav[Ptr].bParam[6];//------�������� ��������� ���������� ���

    if group = 0 then
    begin //---------------------------------------- ���������� ������� �������� ���������
      lock := false;
      if WorkMode.BU[0] then
      begin
        ObjZav[Ptr].Timers[1].Active := false;
        lock := true;
      end else
      begin
        if ObjZav[Ptr].Timers[1].Active then
        begin
          if ObjZav[Ptr].Timers[1].First < LastTime then
          begin //------------------ ��������� �������� ����� ��������� ������ � ���������
            lock := false;
            ObjZav[Ptr].Timers[1].Active := false;
          end;
        end else
        begin //---------------------- ������ ������ �������� ������ ����������� ���������
          ObjZav[Ptr].Timers[1].First := LastTime + 15/80000;
          ObjZav[Ptr].Timers[1].Active := true;
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
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];//---------��
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[1];//---------��
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := not ObjZav[Ptr].bParam[6];//----���
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[3];//---------��
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[4];//--------���
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[5];//---------��
      end;
    end;

    inc(LiveCounter);
    //----------------------------- ��������� ���������� �������� ��������������� ��������
    ps[1] := 0; ps[2] := 0; ps[3] := 0; //--- ��������� �� �������� �� 3 ������ ����������
    for i := 1 to WorkMode.LimitObjZav do //-------------------- �������� �� ���� ��������
    if ObjZav[i].TypeObj = 7 then //------------------ ���� ������� ��������������� ������
    begin
      if ObjZav[i].bParam[1] then inc(ps[ObjZav[i].RU]); //���� ������� ��, ��������� ����
    end;
    //---------------------------------------------------------------------------- ����� 1
    if ps[1] <> ops[1] then //���� ���������� ����� �������� ��������������� � 1-�� ������
    begin
      if (ps[1] > 1) and (ps[1] > ops[1]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 1) {$ENDIF} then
        begin
          InsArcNewMsg(Ptr,455+$1000,0); //---- ������� ����� ������ ���������������� ����
          {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,'',0),4,3); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[19] := true; //----------- �������� ������� �� �� � 1-�� ������
      end
      else ObjZav[Ptr].bParam[19] := false;
      ops[1] := ps[1];
    end;
    //---------------------------------------------------------------------------- ����� 2
    if ps[2] <> ops[2] then
    begin
      if (ps[2] > 1) and (ps[2] > ops[2]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 2) {$ENDIF} then
        begin
          InsArcNewMsg(Ptr,455+$1000,0);
          {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,'',0),4,3); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[20] := true;
      end
      else ObjZav[Ptr].bParam[20] := false;
      ops[2] := ps[2];
    end;
    //---------------------------------------------------------------------------- ����� 3
    if ps[3] <> ops[3] then
    begin
      if (ps[3] > 1) and (ps[3] > ops[3]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 3) {$ENDIF} then
        begin
          InsArcNewMsg(Ptr,455+$1000,0);
          {$IFDEF RMDSP} AddFixMessage(GetShortMsg(1,455,'',0),4,3); {$ENDIF}
        end;
        ObjZav[Ptr].bParam[21] := true;
      end
      else  ObjZav[Ptr].bParam[21] := false;
      ops[3] := ps[3];
    end;
  except
    reportf('������ [MainLoop.PrepKRU]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------------------------------------------------ ����� ����������� #40
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
//========================================================================================
//-------------- ���������� ������� ���������� ������� � ���� ��� �������� ����������� #41
procedure PrepVPStrelki(VPSTR : Integer);
var
  svet_otpr, //------------------------------------------------------ �������� �����������
  sp_otpr, //---------------------------------------------- ����������� �� ��� �����������
  str_ohr, //------------------------------------------------- ���������� ������� (� ����)
  hvost_str_ohr, //-------------------------------------------------- ����� ������� � ����
  RZS, //------------------------------------------------ ������ ������� ��������� �������
  Para, //----------------------------------------------------------------- ������ �������
  Para_hvost, //----------------------------------------------------- ����� ������ �������
  i : integer;
  z,dzs : boolean;
begin
  try
    inc(LiveCounter);
    svet_otpr := ObjZav[VPSTR].BaseObject; //------------------------- �������� ����������

    if svet_otpr > 0 then //----------------------------- ���� ������ �������� �����������
    if ((ObjZav[svet_otpr].bParam[3] or //------- ���� ���� �� � ��������� ����������� ���
    ObjZav[svet_otpr].bParam[4] or //------------- ���� ���� � � ��������� ����������� ���
    ObjZav[svet_otpr].bParam[8]) and //- ���� ������ � ��������� ����������� �� STAN � ...
    not ObjZav[svet_otpr].bParam[1])
    then ObjZav[VPSTR].bParam[20] := true //-------- ���������� ������� ����������� ������
    else ObjZav[VPSTR].bParam[20] := false;

    sp_otpr := ObjZav[VPSTR].UpdateObject; //----------- ������ ����������� �� �����������

    if sp_otpr > 0 then
    begin
      z := ObjZav[sp_otpr].bParam[2] or
      not ObjZav[VPSTR].bParam[20]; //--- �������� ��������� ����������� �� �������� ����.

      if ObjZav[VPSTR].bParam[5] <> z then //------- ���� ������� ��������� ����� ��������
      if z then //------ ���� ��������� ���������� ����������� ������ �������� �����������
      ObjZav[VPSTR].bParam[20] := false; //-- ����� ������� ��������� �������� �����������

      ObjZav[VPSTR].bParam[5] := z; //----------------------------- ��������� ��������� ��


      if (not ObjZav[VPSTR].bParam[20] or //-- ���� ��� ��������� �������� ����������� �
      ObjZav[VPSTR].bParam[21]) then exit; //----- ��� ����������� ��������� �����������
//----------------------------------------------------------------------------------------
      for i := 1 to 4 do
      begin
        str_ohr := ObjZav[VPSTR].ObjConstI[i];//-- ������ ������� ��������� ������� � ����
        if str_ohr > 0 then //------------------------- ���� ���� ��������� ������� � ����
        begin
          Para := ObjZav[str_ohr].ObjConstI[25]; //----------------- ������ ������ �������
          Para_hvost := 0;
          if Para > 0 then Para_hvost := ObjZav[Para].BaseObject; //- ����� ������ �������
          hvost_str_ohr := ObjZav[str_ohr].BaseObject; //---------- ����� �������� �������
          RZS := ObjZav[hvost_str_ohr].ObjConstI[12];
          dzs := ObjZav[RZS].bParam[1];
          inc(LiveCounter);
          ObjZav[sp_otpr].bParam[14] := ObjZav[sp_otpr].bParam[14] and z;

          if ObjZav[VPSTR].ObjConstB[1] then //-------------------- ��� �������� ���������
          ObjZav[str_ohr].bParam[27] := not z;

          if ObjZav[VPSTR].ObjConstB[2] then //---------------------- ��� ������ ���������
          ObjZav[str_ohr].bParam[26] := not z;

          if not dzs then
          ObjZav[str_ohr].bParam[4] := //--------------- �������� �������������� ���������
          ObjZav[str_ohr].bParam[27] or ObjZav[str_ohr].bParam[26] or
          ObjZav[str_ohr].bParam[33] or ObjZav[str_ohr].bParam[25]
          else ObjZav[str_ohr].bParam[4] := true;

          if Para_hvost > 0 then ObjZav[Para_hvost].bParam[4]:= ObjZav[str_ohr].bParam[4];

          OVBuffer[ObjZav[str_ohr].VBufferIndex].Param[7] :=
          ObjZav[str_ohr].bParam[4];//----------------------------------- ������� �� �����

          if Para_hvost > 0 then
          OVBuffer[ObjZav[Para].VBufferIndex].Param[7] :=
          ObjZav[Para_hvost].bParam[4];//-------------------------------- ������� �� �����


          //------------------------------- ����������� �������� ����� �������� ����������
          if ObjZav[sp_otpr].bParam[14] then //---- ������ ����������� �������� ����������
          begin
            if (ObjZav[VPSTR].ObjConstI[i+4] = 0) or//� ���� ��� ����������� � ������� ���
            ((ObjZav[VPSTR].ObjConstI[i+4] > 0) and //------------ ����� ������ ���� � ...
            (ObjZav[hvost_str_ohr].bParam[21] and //����� ������� � ���� �������  �� � ...
            ObjZav[hvost_str_ohr].bParam[22])) then //--- ����� ������� � ���� ����� �� ��
            begin
              ObjZav[VPSTR].bParam[22+i] := true;//-- ���������� ��������������� ���������

              if ObjZav[VPSTR].ObjConstB[i*3] then // ���� i-� ������� ������ ���� � �����
              begin
                if not ObjZav[str_ohr].bParam[1] //----------- ���� i-� ������� �� � �����
                then ObjZav[VPSTR].bParam[7+i] := true;//-- ������� �������� �������� i-��
              end else
              if ObjZav[VPSTR].ObjConstB[i*3+1] then //������� ������ ������ ���� � ������
              begin
                if not ObjZav[str_ohr].bParam[2] //-------------- ���� ������� �� � ������
                then ObjZav[VPSTR].bParam[7+i] := true; //- ������� �������� �������� i-��
              end;
            end;
          end else //---------------------- ���� ��� ���������������� ��������� ��, �� ...
          ObjZav[VPSTR].bParam[22+i] := false; //-- ����� ������� ��������� ������� � ����

          if not ObjZav[VPSTR].bParam[7+i] then //--------- ���� ��� �������� ��������, ��
          begin
            ObjZav[VPSTR].bParam[i] := //----- ���������� �������� i-�� ������� ������� ��
            not ObjZav[sp_otpr].bParam[8] and //-------- �����. ����������� �� �����������
            not ObjZav[sp_otpr].bParam[14];//-------------- �����.��������� �� �����������
          end
          else  ObjZav[VPSTR].bParam[i] := false;//- ����� ���� ��������, ����� ����������

          if ObjZav[svet_otpr].bParam[9] then
          if not ObjZav[hvost_str_ohr].bParam[5] then //--- ���� ����� �� ������� ��������
          ObjZav[hvost_str_ohr].bParam[5] := ObjZav[VPSTR].bParam[i];//���������� ��������

          if not ObjZav[hvost_str_ohr].bParam[8] then //--- ���� ����� �� ������� ��������
          ObjZav[hvost_str_ohr].bParam[8] := ObjZav[VPSTR].bParam[7+i];//------ ����������

          if not ObjZav[hvost_str_ohr].bParam[23] then //- ���� ����� �� ����� �����������
          ObjZav[hvost_str_ohr].bParam[23] := ObjZav[VPSTR].bParam[22+i];//---- ����������
        end;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepVPStrelki]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------- ����� ������������� ��������� �������� �� ���������� (�� ��� ������� � ����) #42
procedure PrepVP(Ptr : Integer);
var
  i,o,sp_v_p,svetofor : integer;

  z,nepar,VP : boolean;
begin
  try
    inc(LiveCounter);
    VP := GetFR3(ObjZav[Ptr].ObjConstI[11],nepar,ObjZav[Ptr].bParam[31]); //---- ������ ��
    sp_v_p := ObjZav[Ptr].UpdateObject; //------------------- ������ �� ��� ������� � ����
    svetofor := ObjZav[Ptr].BaseObject; //-------------- �������� ��������� ������� � ����
    z := ObjZav[sp_v_p].bParam[2]; //-------------------- �������� ��������� ������ � ����

    ObjZav[Ptr].bParam[1] := VP;

    if ObjZav[Ptr].bParam[3] <> z then //----------------------- ���� ��������� ����������
    if z then//---------------------------------------- ��������� ���������� ������ � ����
    begin
      ObjZav[Ptr].bParam[1] := false; //----------- ����� ������� ��������� ������ �� ����
      ObjZav[Ptr].bParam[2] := false; // ����� ���������� ������������� ��������� ��������
      ObjZav[Ptr].bParam[3] := false; //--------------------- �������� ��������� ���������
    end;


     //------ ����  ���� ������� ��������� ������, ���������, ���������� ��  � �����������
    //------------------------------- ���������� ������ � ����, � ���������� ������ ������
    if ObjZav[Ptr].bParam[1] and //------------------- ���� ������� ��������� ������ � ...
    not ObjZav[svetofor].bParam[1] and //------------- ��� ��1 ����������� � ������� � ...
    not ObjZav[svetofor].bParam[2] and //----------- ��� ��2 � ����������� � ������� � ...
    ObjZav[sp_v_p].bParam[1] and //------------------------------------- �������� �� � ...
    not ObjZav[sp_v_p].bParam[2] and  //-------------------------------- �������� �� � ...
    not ObjZav[sp_v_p].bParam[3] then //--------------------------- ��� �������� �� ��� ��
    begin
      z := true;
      ObjZav[Ptr].bParam[3] := z; //------------------------ ��������� ��������� ���������
      for i := 1 to 4 do //----------------------- ������ �� 4-� ��������� �������� � ����
      begin //------------------------ ��������� ������� ��������� �������� ������� � ����
        o := ObjZav[Ptr].ObjConstI[i]; //----- �������� ������� (��������� ������� � ����)
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] //-------------------- ���� ������� � ���� �� � �����
          then z := z and not z; //----------------- �������� ��� z false �� ����� �������
        end;
      end;

      if z then
      begin //--------------------------------- ��� ������� � ���� ����� �������� �� �����
        o := ObjZav[Ptr].ObjConstI[10]; //---------- ���������� ���������� �������� � ����
        if o > 0 then //----------------------------------------- ���� ���� ����� ��������
        begin //------------------------------- �������� ����������� ����������� ���������
          if ObjZav[o].bParam[1] or //--------------------------------------- ���� ��1 ���
          ObjZav[o].bParam[2] or //----------------------------------------------- ��2 ���
          ObjZav[o].bParam[6] or //---------- ���� ���� ������ ����������� �� STAN ��� ...
          ObjZav[o].bParam[7] //---------------------- ���� ������� ���������� �����������
          then z := false;
        end;
      end;
      //------------------- ���������� ������� ���������� ������������� ��������� ��������
      //-------------------------------------------- �� ���������� �� ����������� ��������
      ObjZav[Ptr].bParam[2] := z;
    end else
    begin
      ObjZav[Ptr].bParam[3] := z;
      ObjZav[Ptr].bParam[2] := false; //- ����� ���������� ������������� ��������� ��������
    end;
  except
    reportf('������ [MainLoop.PrepVP]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------- ������ ���������� ���� �� ����������� ������ #43
procedure PrepOPI(Ptr : Integer);
  var k,o,p,j : integer;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ �����������
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- ��������������

  ObjZav[Ptr].bParam[1] :=
  GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ���

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-- ���

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
        begin //------------------------------------------------------ �� �������� �������
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] :=
          ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2];
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
        end else
        begin //--------------------------------------------------------- ������� ��������
          if ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin //--------------------------------------------------------- ���� ��� � ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if ObjZav[Ptr].bParam[1] and not ObjZav[Ptr].bParam[2] then
          begin //------------------------------------------------------- ���� ��� ��� ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := true;
          end else
          if not ObjZav[Ptr].bParam[1] and ObjZav[Ptr].bParam[2] then
          begin //------------------------------------------------------- ���� ��� ��� ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := true;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end else
          begin //---------------------------------------------------------- ��� ��� � ���
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := false;
            OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := false;
          end;
        end;
      end;
    end;
  end;

  o := ObjZav[Ptr].BaseObject;
  if (o > 0) and not (ObjZav[Ptr].bParam[1] or ObjZav[Ptr].bParam[2]) then
  begin //---------------------------- ��������������� ����� �� ���� �� ����������� ������
    inc(LiveCounter);
    if ObjZav[Ptr].ObjConstB[1] then p := 2
    else p := 1;
    o := ObjZav[Ptr].Neighbour[p].Obj;
    p := ObjZav[Ptr].Neighbour[p].Pin;
    j := 50;
    while j > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 :
        begin //------------------------------------------------------------------ �������
          case p of
            2 : ObjZav[ObjZav[o].BaseObject].bParam[10] := true;
            3 : ObjZav[ObjZav[o].BaseObject].bParam[11] := true;
          end;
          p := ObjZav[o].Neighbour[1].Pin;
          o := ObjZav[o].Neighbour[1].Obj;
        end;

        44 :
        begin
          if not ObjZav[o].bParam[1] then
          ObjZav[o].bParam[1] := ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[10];

          if not ObjZav[o].bParam[2] then
          ObjZav[o].bParam[2] := ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[11];

          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin;
            o := ObjZav[o].Neighbour[2].Obj;
          end
          else
          begin
            p := ObjZav[o].Neighbour[1].Pin;
            o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;

        48 : begin //----------------------------------------------------------------- ���
          ObjZav[o].bParam[1] := true;
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
        dec(j);
      end;
    end;
  except
    reportf('������ [MainLoop.PrepOPI]');
    Application.Terminate;
  end;
end;
//========================================================================================
//-------- ������ ���������� ���� �� ����������� ������ (��������� ���������� �������) #43
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
//========================================================================================
//------------------------------------------------------------- ���������� ������� ��� #44
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
//========================================================================================
//------------------------------------------ ���������� ������� ������ ���� ���������� #45
procedure PrepKNM(Ptr : Integer);
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; //------------------------------------------ �����������
  ObjZav[Ptr].bParam[32] := false; //-------------------------------------- ��������������

  ObjZav[Ptr].bParam[1] := //--------------------------------------------------------- ���
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

  ObjZav[Ptr].bParam[2] := //---------------------------------------------------------- ��
  GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);

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
//========================================================================================
//-------------------------------------- ���������� ������� "�������� � �������������" #46
procedure PrepAutoSvetofor(Ptr : Integer);
{$IFDEF RMDSP}
var
  i,o : integer;
{$ENDIF}
begin
{$IFDEF RMDSP}
  try
    inc(LiveCounter);
    if not ObjZav[Ptr].bParam[1] then exit; //------------- ��������� ������������ �������

    if not (WorkMode.Upravlenie and WorkMode.OU[0]
    and WorkMode.OU[ObjZav[Ptr].Group])// ��� ������������ ���  ������ ���������� � ��-���
    then exit
    else
    if not WorkMode.CmdReady and not WorkMode.LockCmd then
    begin
      //------------------------------------------------------------------ ������ ������ ?
      if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
      begin
        ObjZav[Ptr].Timers[1].Active := false;
        ObjZav[Ptr].bParam[2] := false;
        exit;
      end;

      //------------------------------------ ��������� ������� ��������� ��������� �������
      for i := 1 to 10 do
      begin
        o := ObjZav[Ptr].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] then
          begin
            ObjZav[Ptr].bParam[2] := false;
            exit;
          end;
        end;
      end;

      //---------------------------------------- ��������� ������� ����� ��������� �������
      if ObjZav[Ptr].Timers[1].Active then
      begin
        if ObjZav[Ptr].Timers[1].First > LastTime then exit;
      end;

      //---------------------------- ��������� ����������� ������ ������� �������� �������
      if CheckAutoMarsh(Ptr,ObjZav[Ptr].ObjConstI[25]) then
      begin
        inc(LiveCounter);
        if SendCommandToSrv(ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[5] div 8,
        cmdfr3_svotkrauto,ObjZav[Ptr].BaseObject) then
        begin //--------------------------------------------- ������ ������� �� ����������
          if SetProgramZamykanie(ObjZav[Ptr].ObjConstI[25],true) then
          begin
            if OperatorDirect > LastTime then // �������� ���-�� ������ - ��������� 15 ������ �� ��������� ������� ������ ������� �������� ������� �������������
            ObjZav[Ptr].Timers[1].First := LastTime + IntervalAutoMarsh / 86400
            else // �������� ������ �� ������ - ��������� 10 ������ � ������ ��������� �������
            ObjZav[Ptr].Timers[1].First := LastTime + 10 / 86400;
            ObjZav[Ptr].Timers[1].Active := true;
            // AddFixMessage(GetShortMsg(1,423,ObjZav[ObjZav[Ptr].BaseObject].Liter),5,1);
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
//========================================================================================
//------------------------------- ���������� ������� "��������� ������������ ��������" #47
procedure PrepAutoMarshrut(Ptr : Integer);
{$IFDEF RMDSP}
var
  i,j,o,p,q : integer;
{$ENDIF}
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    if ObjZav[Ptr].ObjConstI[2] >0 then
    begin
      ObjZav[Ptr].bParam[2] :=
      GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//���
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    end
    else OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := true;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] :=
      ObjZav[Ptr].bParam[1]; //---------------------------------- ����������� ������������

      if not ObjZav[Ptr].bParam[1] then //-------------------- ���� ������������ ���������
      begin
        if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
        begin
          OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] :=
          ObjZav[Ptr].bParam[2];  //-------------------------------- �������� ������������
        end;
      end;
    end;

{$IFDEF RMDSP}
    inc(LiveCounter);

    if ObjZav[Ptr].ObjConstB[1] then  //---------------------- ������ ������� ������������
    begin
      if CHAS and not ObjZav[Ptr].bParam[1] then
      begin
        if not AutoMarsh(Ptr,true) then CHAS := false;
      end else
      if ObjZav[Ptr].bParam[1] and not CHAS
      then AutoMarsh(Ptr,false);
    end else
    begin   //---------------------------------------------- ������ ��������� ������������
      if NAS and not ObjZav[Ptr].bParam[1] then
      begin
        if not AutoMarsh(Ptr,true) then NAS := false;
      end else
      if ObjZav[Ptr].bParam[1] and not NAS
      then  AutoMarsh(Ptr,false);
    end;

    if not ObjZav[Ptr].bParam[1] then exit;

    if not(WorkMode.OU[0] and WorkMode.OU[ObjZav[Ptr].Group]) then
    begin //----------------- ����� ������������ ���  ������ ��������� ���������� � ��-���
      ObjZav[Ptr].bParam[1] := false;
      NAS := false;
      CHAS := false;
      for q := 10 to 12 do
      if ObjZav[Ptr].ObjConstI[q] > 0 then
      begin
        ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
        AutoMarshOFF(ObjZav[Ptr].ObjConstI[q],ObjZav[Ptr].ObjConstB[1]);
      end;
    end else
    //----------------------- ��������� ������� ��������� ������ ������������ ������������
    for i := 10 to 12 do //-------- ������ �� ��������� �������� ��.��������� ������������
    begin
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin //---------------------------------- ����������� ��������� ������ ������������
        if ObjZav[ObjZav[o].BaseObject].bParam[23] then //-- ���� ���� ������ ��� ��������
        begin
          AddFixMessage(GetShortMsg(1,430,ObjZav[Ptr].Liter,0),4,3);//��������� ������������
          ObjZav[Ptr].bParam[1] := false;

          for q := 10 to 12 do //------ ������ �� ���� ������������ ��������� ������������
          if ObjZav[Ptr].ObjConstI[q] > 0 then
          begin
            ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false; // ��������� ������������
            AutoMarshOFF(ObjZav[Ptr].ObjConstI[q],ObjZav[Ptr].ObjConstB[1]);
          end;
          exit;
        end;

        for j := 1 to 10 do //--------- ������ �� ���� �������� ������������� ������������
        begin
          p := ObjZav[o].ObjConstI[j];
          if p > 0 then
          begin
            if ObjZav[ObjZav[p].BaseObject].bParam[26] or
            ObjZav[ObjZav[p].BaseObject].bParam[32] then
            begin //-------- ���� ������������� ������ �������� ������� ��� ��������������
              AddFixMessage(GetShortMsg(1,430,ObjZav[Ptr].Liter,0),4,3);//����. ������������
              ObjZav[Ptr].bParam[1] := false;
              for q := 10 to 12 do
              if ObjZav[Ptr].ObjConstI[q] > 0 then
              begin
                ObjZav[ObjZav[Ptr].ObjConstI[q]].bParam[1] := false;
                AutoMarshOFF(ObjZav[Ptr].ObjConstI[q],ObjZav[Ptr].ObjConstB[1]);
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
//========================================================================================
//------------------------------------------------------------- ���������� ������� ��� #48
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
//========================================================================================
//------------------------------------------------------------ ���������� ������� ���� #49
procedure PrepABTC(Ptr : Integer);
  var gpo,ak,kl,pkl,rkl : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������
  gpo := GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //���
  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  ak := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
  kl := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //��
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
          if config.ru = ObjZav[ptr].RU then
          begin
            InsArcNewMsg(Ptr,488+$1000,0);
            AddFixMessage(GetShortMsg(1,488,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,488+$1000,0);
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
            InsArcNewMsg(Ptr,489+$1000,0);
            AddFixMessage(GetShortMsg(1,489,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,489+$1000,0);
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
            InsArcNewMsg(Ptr,490+$1000,0);
            AddFixMessage(GetShortMsg(1,490,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,490+$1000,0);
{$ENDIF}
        end;
      end;
    ObjZav[Ptr].bParam[5] := kl;

    if pkl <> ObjZav[Ptr].bParam[6] then
      if pkl then
      begin //---------------------------------------- ������������� ����� �������� ������
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZav[ptr].RU then
          begin
            InsArcNewMsg(Ptr,491+$1000,0);
            AddFixMessage(GetShortMsg(1,491,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,491+$1000,0);
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
            InsArcNewMsg(Ptr,492+$1000,0);
            AddFixMessage(GetShortMsg(1,492,ObjZav[Ptr].Liter,0),4,4);
          end;
{$ELSE}
          InsArcNewMsg(Ptr,492+$1000,0);
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
//========================================================================================
//--------------------------------------- ���������� ������� �������� ���������� ����� #50
procedure PrepDCSU(Ptr : Integer);
var
  activ,nepar : boolean;
begin
try
  inc(LiveCounter);
  activ := true; //----------------------------------------------------------- �����������
  nepar := false; //------------------------------------------------------- ��������������

  ObjZav[Ptr].bParam[1] := GetFR3(ObjZav[Ptr].ObjConstI[1], nepar,activ); //---------- 1��
  ObjZav[Ptr].bParam[2] := GetFR3(ObjZav[Ptr].ObjConstI[2], nepar,activ); //---------- 1��

  ObjZav[Ptr].bParam[3] := GetFR3(ObjZav[Ptr].ObjConstI[3], nepar,activ); //---------- 2��
  ObjZav[Ptr].bParam[4] := GetFR3(ObjZav[Ptr].ObjConstI[4], nepar,activ); //---------- 2��

  ObjZav[Ptr].bParam[5] := GetFR3(ObjZav[Ptr].ObjConstI[5], nepar,activ); //---------- 3��
  ObjZav[Ptr].bParam[6] := GetFR3(ObjZav[Ptr].ObjConstI[6],nepar,activ); //----------- 3��

  ObjZav[Ptr].bParam[7] := GetFR3(ObjZav[Ptr].ObjConstI[7],nepar,activ); //----------- 4��
  ObjZav[Ptr].bParam[8] := GetFR3(ObjZav[Ptr].ObjConstI[8],nepar,activ); //----------- 4��

  ObjZav[Ptr].bParam[9] := GetFR3(ObjZav[Ptr].ObjConstI[9],nepar,activ); //----------- 5��
  ObjZav[Ptr].bParam[10] := GetFR3(ObjZav[Ptr].ObjConstI[10],nepar,activ);//---------- 5��

  ObjZav[Ptr].bParam[11] := GetFR3(ObjZav[Ptr].ObjConstI[11],nepar,activ);//---------- 6��
  ObjZav[Ptr].bParam[12] := GetFR3(ObjZav[Ptr].ObjConstI[12],nepar,activ);//---------- 6��

  ObjZav[Ptr].bParam[13] := GetFR3(ObjZav[Ptr].ObjConstI[13],nepar,activ);//---------- 7��
  ObjZav[Ptr].bParam[14] := GetFR3(ObjZav[Ptr].ObjConstI[14],nepar,activ);//---------- 7��

  ObjZav[Ptr].bParam[15] := GetFR3(ObjZav[Ptr].ObjConstI[15],nepar,activ);//---------- 8��
  ObjZav[Ptr].bParam[16] := GetFR3(ObjZav[Ptr].ObjConstI[16],nepar,activ);//---------- 8��

  ObjZav[Ptr].bParam[31]:= activ;
  ObjZav[Ptr].bParam[32]:= nepar;

  //-------------------------------------------------------- ��������� � ����� �����������
  if ObjZav[Ptr].BaseObject > 0 then
  begin
    if ObjZav[ObjZav[Ptr].BaseObject].bParam[31] and  //------------ ���� �� ������� � ...
    not ObjZav[ObjZav[Ptr].BaseObject].bParam[32] then //----------------------- ���������
    begin
      ObjZav[Ptr].bParam[17] := not ObjZav[ObjZav[Ptr].BaseObject].bParam[4];//----- �����
      ObjZav[Ptr].bParam[18] := ObjZav[ObjZav[Ptr].BaseObject].bParam[4];    //-- ��������
    end else
    begin //------------ -------------- ����� ���������� ��������� ����������� �� ��������
      ObjZav[Ptr].bParam[17] := false;
      ObjZav[Ptr].bParam[18] := false;
    end;
  end;

  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32];

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[1]; //---------- 1��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[2]; //---------- 1��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[3]; //---------- 2��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := ObjZav[Ptr].bParam[4]; //---------- 2��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[6] := ObjZav[Ptr].bParam[5]; //---------- 3��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[7] := ObjZav[Ptr].bParam[6]; //---------- 3��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[8] := ObjZav[Ptr].bParam[7]; //---------- 4��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[9] := ObjZav[Ptr].bParam[8]; //---------- 4��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[10] := ObjZav[Ptr].bParam[9]; //--------- 5��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[11] := ObjZav[Ptr].bParam[10]; //-------- 5��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[12] := ObjZav[Ptr].bParam[11]; //-------- 6��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[13] := ObjZav[Ptr].bParam[12]; //-------- 6��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[14] := ObjZav[Ptr].bParam[13]; //-------- 7��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[15] := ObjZav[Ptr].bParam[14]; //-------- 7��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[17] := ObjZav[Ptr].bParam[15]; //-------- 8��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[18] := ObjZav[Ptr].bParam[16]; //-------- 8��
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[19] := ObjZav[Ptr].bParam[17]; //------ �����
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[20] := ObjZav[Ptr].bParam[18]; // �����������
  end;

except
  reportf('������ [MainLoop.PrepDCSU]');
  Application.Terminate;
end;
end;
//========================================================================================
//----------------------------------------------------- ������ �������������� �������� #51
procedure PrepDopDat(Ptr : Integer);
var
  i: Integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true;
    ObjZav[Ptr].bParam[32] := false;
    for i := 1 to 34 do ObjZav[Ptr].NParam[i] := false;

    for i := 1 to 10 do
    begin
      if ObjZav[Ptr].ObjConstI[i] > 0 then
      begin
        ObjZav[Ptr].bParam[i] :=
        GetFR3(ObjZav[Ptr].ObjConstI[i],ObjZav[Ptr].NParam[i],ObjZav[Ptr].bParam[31]);
      end;
      if ObjZav[Ptr].ObjConstI[10+i] > 0 then // ���� ������������� ��������� �� ���������
      begin
        if ObjZav[Ptr].bParam[i] then //----------------------------------- ���� ���������
        begin
          if not ObjZav[Ptr].bParam[i+10] then //----------------------- �� ���� ���������
          begin
            ObjZav[Ptr].bParam[i+10] := true;
            ObjZav[Ptr].bParam[i+20] := false;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+10],0);
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[i+10]],4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+10],0);
              SingleBeep3 := true;
{$ENDIF}
            end;
          end;
        end;
        if not ObjZav[Ptr].bParam[i] then //------------------------------ ���� ����������
        ObjZav[Ptr].bParam[i+10] := false;
      end;


      if ObjZav[Ptr].ObjConstI[20+i] > 0 then //���� ������������� ��������� �� ����������
      begin
        if not ObjZav[Ptr].bParam[i] then //------------------------------ ���� ����������
        begin
          if not ObjZav[Ptr].bParam[i+20] then //----------------------- �� ���� ���������
          begin
            ObjZav[Ptr].bParam[i+20] := true;
            ObjZav[Ptr].bParam[i+10] := false;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZav[Ptr].RU then
              begin
                InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+20],0);
                AddFixMessage(MsgList[ObjZav[Ptr].ObjConstI[i+20]],4,3);
              end;
{$ELSE}
              InsArcNewMsg(Ptr,$1000+ObjZav[Ptr].ObjConstI[i+20],0);
              SingleBeep3 := true;
{$ENDIF}
            end;
          end;
        end;
        if ObjZav[Ptr].bParam[i] then //----------------------------------- ���� ���������
        ObjZav[Ptr].bParam[i+20] := false;
      end;
    end;

    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
    for i := 1 to 10 do
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[i] := ObjZav[Ptr].bParam[i];
      OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[i] := ObjZav[Ptr].NParam[i];
    end;
  except
    reportf('������ [MainLoop.PrepDopDat]');
    Application.Terminate;
  end;
end;
//========================================================================================
//------------------------ ������ ����������� ��� ��� ��������� �� ���������� �������� #52
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
            2 :
            begin // �������
              case p of
                2 :
                begin
                  if not ObjZav[ObjZav[o].BaseObject].bParam[1] then break;
                end;
                3 :
                begin
                  if not ObjZav[ObjZav[o].BaseObject].bParam[2] then break;
                end;

                else   break;
              end;
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;

            53 :
            begin // �����
              if (ObjZav[Ptr].UpdateObject = o) and (k = ObjZav[o].BaseObject) then
              begin
                ObjZav[Ptr].bParam[1] := true;
                break;
              end
              else
              begin
                if p = 1 then
                begin
                  p := ObjZav[o].Neighbour[2].Pin;
                  o := ObjZav[o].Neighbour[2].Obj;
                end
                else
                begin
                  p := ObjZav[o].Neighbour[1].Pin;
                  o := ObjZav[o].Neighbour[1].Obj;
                end;
              end;
            end;
            else
            if p = 1 then
            begin
              p := ObjZav[o].Neighbour[2].Pin;
              o := ObjZav[o].Neighbour[2].Obj;
            end
            else
            begin
              p := ObjZav[o].Neighbour[1].Pin;
              o := ObjZav[o].Neighbour[1].Obj;
            end;
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
//========================================================================================
//--------------------------------- ���������� ������� ���������� ����� ��� ������� �� #54
procedure PrepST(Ptr : Integer);
  var o : boolean;
begin
try
  inc(LiveCounter);
  ObjZav[Ptr].bParam[31] := true; // �����������
  ObjZav[Ptr].bParam[32] := false; // ��������������

  ObjZav[Ptr].bParam[2] :=
  GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- �1

  ObjZav[Ptr].bParam[3] :=
  GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //--- �2

  o := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//��

  if o <> ObjZav[Ptr].bParam[4] then
  begin //------------------------------------------------ ������� ���� �������� ���������
    if o then
    begin //-------------------------------------------- ������������� ��������� ���������
      if WorkMode.FixedMsg then
      begin
{$IFDEF RMDSP}
        if config.ru = ObjZav[ptr].RU then
        begin
          InsArcNewMsg(Ptr,272+$1000,0);
          AddFixMessage(GetShortMsg(1,272, ObjZav[ptr].Liter,0),4,4);
          SingleBeep4 := true;
          ObjZav[Ptr].bParam[4] := o;
          ObjZav[Ptr].dtParam[1] := LastTime;
          inc(ObjZav[Ptr].siParam[1]);
        end;
{$ENDIF}
      end;
      ObjZav[Ptr].bParam[20] := false; // ����� ���������� �������������
    end
    else ObjZav[Ptr].bParam[4] := o;
  end;
  if ObjZav[Ptr].VBufferIndex > 0 then
  begin
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31]; //����������
    OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[32]; //��������������
    if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];//�1
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];//�2
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];//��
    end;
  end;
except
  reportf('������ [MainLoop.PrepST]');
  Application.Terminate;
end;
end;
//========================================================================================
//------------------------------------------ ��������� ���������� ���������� � ������� #55
procedure PrepDopSvet(Ptr : Integer);
var
  Signal : integer; //--------------- ������ ������� ������������ ���������������� �������
  VidBuf : integer; //-------------------- ����� ����������� ��� ����������������� �������
  ij : integer;
begin
  try
    for ij:=1 to 6 do ObjZav[Ptr].bParam[ij] := false;

    Signal := ObjZav[Ptr].BaseObject;
    VidBuf := ObjZav[Signal].VBufferIndex;
    inc(LiveCounter);

    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    if ObjZav[Ptr].ObjConstI[1] <> 0 then
    ObjZav[Ptr].bParam[1] :=
    GetFR3(ObjZav[Ptr].ObjConstI[1],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //- ��

    if ObjZav[Ptr].ObjConstI[2] <> 0 then
    ObjZav[Ptr].bParam[2] :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //- ��

    if ObjZav[Ptr].ObjConstI[3] <> 0 then
    ObjZav[Ptr].bParam[3] :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]); //-2��

    if ObjZav[Ptr].ObjConstI[4] <> 0 then
    ObjZav[Ptr].bParam[4] :=
    GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//- ���

    if ObjZav[Ptr].ObjConstI[5] <> 0 then
    ObjZav[Ptr].bParam[5] :=
    GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-����

    if ObjZav[Ptr].ObjConstI[6] <> 0 then
    ObjZav[Ptr].bParam[6] :=
    GetFR3(ObjZav[Ptr].ObjConstI[6],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//-- ��

    if ObjZav[Ptr].ObjConstI[10] <> 0 then
    ObjZav[Ptr].bParam[10] :=
    GetFR3(ObjZav[Ptr].ObjConstI[10],ObjZav[Ptr].bParam[32],ObjZav[Ptr].bParam[31]);//- ��

    if VidBuf > 0 then
    begin
      OVBuffer[VidBuf].Param[20] := ObjZav[Ptr].bParam[1]; //-------------------------- ��
      OVBuffer[VidBuf].Param[22] := ObjZav[Ptr].bParam[2]; //---------------------- ��(��)
      OVBuffer[VidBuf].Param[21] := ObjZav[Ptr].bParam[3]; //------------------------- 2��
      OVBuffer[VidBuf].Param[23] := ObjZav[Ptr].bParam[4]; //------------------------- ���
      OVBuffer[VidBuf].Param[24] := ObjZav[Ptr].bParam[5]; //-------------------------����
      OVBuffer[VidBuf].Param[25] := ObjZav[Ptr].bParam[6]; //-------------------------- ��
      OVBuffer[VidBuf].Param[28] := ObjZav[Ptr].bParam[10]; //------------------------- ��
    end;
  except
    reportf('������ [MainLoop.PrepDopSvet]');
    Application.Terminate;
  end;
end;
//========================================================================================
//----------------------------------------- ���������� ������� ��� ��� ������ �� ����� #56
procedure PrepUKG(Ptr : Integer);
var
  vkgd,vkgd1,kg,okg : boolean;
  ob_vkgd,ob_vkgd1, kod,i : integer;
  TXT1 : string;
begin
  try
    kod := 0;
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    for i := 1 to 32 do ObjZav[Ptr].NParam[i] := false;
    ob_vkgd := ObjZav[Ptr].ObjConstI[4];
    ob_vkgd1 := ObjZav[Ptr].ObjConstI[5];

    kg :=
    GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[2],ObjZav[Ptr].bParam[31]); //-���

    okg :=
    GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]); // ���

    vkgd :=
    GetFR3(ob_vkgd,ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);//------------------ ����

    vkgd1 :=
    GetFR3(ob_vkgd1,ObjZav[Ptr].NParam[5],ObjZav[Ptr].bParam[31]);//---------------- ����1

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31];
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].NParam[2] or
      ObjZav[Ptr].NParam[3] or  ObjZav[Ptr].NParam[4] or  ObjZav[Ptr].NParam[5];

      if ObjZav[Ptr].bParam[31] and not ObjZav[Ptr].bParam[32] then
      begin
        if kg then  kod := kod + 1;
        if okg then kod := kod + 2;
        if vkgd then kod := kod + 4;
        if vkgd1 then kod := kod + 8;


        ObjZav[Ptr].bParam[1] := kg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := KG;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[2] := ObjZav[Ptr].NParam[2];

        ObjZav[Ptr].bParam[3] := vkgd;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := vkgd;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4];

        ObjZav[Ptr].bParam[4] := vkgd1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[5] := vkgd1;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[5] := ObjZav[Ptr].NParam[5];

        ObjZav[Ptr].bParam[2] := okg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := okg;
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[3] := ObjZav[Ptr].NParam[3];

        if kod <> ObjZav[Ptr].iParam[1] then   //-------------- ��������� ��� �������� ���
        begin
          if not ObjZav[Ptr].Timers[1].Active then //-------------- ���� ������ �� �������
          begin
            ObjZav[Ptr].Timers[1].Active := true; //---------------- �������������� ������
            ObjZav[Ptr].Timers[1].First := LastTime + 2 / 86400; // ����� �������� �� 2���
          end;
        end;

        if ObjZav[Ptr].Timers[1].Active and //------------------ ���� ������ ������� � ...
        (LastTime > ObjZav[Ptr].Timers[1].First) then //----------- ������� ����� ��������
        begin
{$IFDEF RMDSP}
          if WorkMode.FixedMsg and (config.ru = ObjZav[ptr].RU) then
          case kod of
            4,8,12:  //--------------------------------------------- ��������, �� ���������
            begin
              InsArcNewMsg(Ptr,554+$1000,0); //------------------- ���������� �������� ���
              TXT1 := GetShortMsg(1,554,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,2);
              PutShortMsg(7,LastX,LastY,TXT1);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            1,5,9,13://------------------------------------------- ����������� �����������
            begin
              InsArcNewMsg(Ptr,553+$1000,0); //----------------------------- ��� ���������
              TXT1 := GetShortMsg(1,553,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,2);
              PutShortMsg(7,LastX,LastY,TXT1);
            end;

            0://-------------------------------------- ��������� ��������� ����������� ���
            begin
              InsArcNewMsg(Ptr,557+$1000,0); //------------------ ��� ��������� � ��������
              TXT1 := GetShortMsg(1,557,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,0,2);
              PutShortMsg(2,LastX,LastY,TXT1);
              SingleBeep2 := WorkMode.Upravlenie;
            end;

            3: //-------------------------------------------- ��������� ������� ��1 � ���
            begin
              InsArcNewMsg(Ptr,552+$1000,0); //----------------------- �������� ������ ���
              TXT1:= GetShortMsg(1,552,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,3);
              PutShortMsg(1,LastX,LastY,TXT1);
            end;
            else
            begin
              InsArcNewMsg(Ptr,550+$1000,0); //---------------- ����������� �������� �����
              TXT1 := GetShortMsg(1,550,ObjZav[Ptr].Liter,0);
              AddFixMessage(TXT1,4,3);
              PutShortMsg(11,LastX,LastY,TXT1);
            end;
          end;

{$ELSE}
          case kod of
            4,8,12:  //-------------------------------------------- ��������, �� ���������
            begin
              InsArcNewMsg(Ptr,554+$1000,0);
              SingleBeep3 := true;
            end;

            5,9,13:
            begin
              InsArcNewMsg(Ptr,553+$1000,0);//���������� �������� ���������(���) ���������
              SingleBeep3 := true;
            end;

            0://-------------------------------------- ��������� ��������� ����������� ���
            begin
              InsArcNewMsg(Ptr,557+$1000,0); //------------------ ��� ��������� � ��������
              SingleBeep3 := true;
            end;

            3:
            begin
              InsArcNewMsg(Ptr,552+$1000,0);
              SingleBeep3 := true;
            end;
            else
            begin
              InsArcNewMsg(Ptr,550+$1000,0); //---------------- ����������� �������� �����
              SingleBeep3 := true;
            end;
          end;
{$ENDIF}
          ObjZav[Ptr].Timers[1].Active := false;
          ObjZav[Ptr].Timers[1].First := 0;
        end;

        ObjZav[Ptr].iParam[1] := kod;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepUKG]');
    Application.Terminate;
  end;
end;
//========================================================================================
//--------------------------------------------------- ���������� ��� ������� ����/���� #92
procedure PrepDN(Ptr : Integer);
var
  dnk,nnk,auk,dn : boolean;
  dnk_kod,nnk_kod,auk_kod,dn_kod,AllKod : integer;
begin
  try
    inc(LiveCounter);
    ObjZav[Ptr].bParam[31] := true; //---------------------------------------- �����������
    ObjZav[Ptr].bParam[32] := false; //------------------------------------ ��������������

    //--------------------- ������ �������� ������� ������ "����"
    dnk := GetFR3(ObjZav[Ptr].ObjConstI[2],ObjZav[Ptr].NParam[1],ObjZav[Ptr].bParam[31]);
    if dnk then dnk_kod := 1
    else dnk_kod :=0;

    //--------------------- ������ �������� ������� ������ "����"
    nnk := GetFR3(ObjZav[Ptr].ObjConstI[3],ObjZav[Ptr].Nparam[2],ObjZav[Ptr].bParam[31]);
    if nnk then nnk_kod := 1
    else nnk_kod :=0;

    //------------------ ������ �������� ������� ������ "�������"
    auk := GetFR3(ObjZav[Ptr].ObjConstI[4],ObjZav[Ptr].NParam[3],ObjZav[Ptr].bParam[31]);
    if auk then auk_kod := 1
    else auk_kod :=0;

    //----------------------- ������ �������� ������� "����/����"
    dn := GetFR3(ObjZav[Ptr].ObjConstI[5],ObjZav[Ptr].NParam[4],ObjZav[Ptr].bParam[31]);
    if dn then dn_kod := 1
    else dn_kod :=0;
    AllKod := dnk_kod*8 + nnk_kod*4 + auk_kod*2 + dn_kod;

    if (ObjZav[Ptr].iParam[1] <> AllKod) then //���� ���������� ��������� ������ �������
    begin
      ObjZav[ptr].iParam[1] := AllKod;
      ObjZav[Ptr].dtParam[1] := LastTime;
      case AllKod of
        //-------------------------------------------------------------------------------
        2: //--------------------------------------------------- ������� ����� � ��������
        begin // ������ ������ "�������"
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,362+$1000,0); //--------------------------- ������� �������
              AddFixMessage(GetShortMsg(1,362, ObjZav[ptr].Liter,0),4,4);
              InsArcNewMsg(Ptr,360+$1000,0); //------------------------------ ������� ����
              AddFixMessage(GetShortMsg(1,360, ObjZav[ptr].Liter,0),4,4);
              inc(ObjZav[Ptr].siParam[1]);
            end;
            {$ENDIF}
          end;
        end;
        //-------------------------------------------------------------------------------
        3: //---------------------------------------------------- ������ ����� � ��������
        begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,362+$1000,0); //--------------------------- ������� �������
              AddFixMessage(GetShortMsg(1,362, ObjZav[ptr].Liter,0),4,4);
              InsArcNewMsg(Ptr,361+$1000,0); //----------------------------- �������� ����
              AddFixMessage(GetShortMsg(1,361, ObjZav[ptr].Liter,0),4,4);
              inc(ObjZav[Ptr].siParam[1]);
            end;
          {$ENDIF}
          end;
         end;

         4,6,7,9..15: //------------------------ ������� ����� ������������
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,516+$1000,0);
              AddFixMessage(GetShortMsg(1,516, ObjZav[ptr].Liter,0),4,4);
              ObjZav[Ptr].dtParam[1] := LastTime;
              inc(ObjZav[Ptr].siParam[1]);
            end;
            {$ENDIF}
          end;
         end;
         5: //------------------------------------------------------- ���� � ������ ������
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,361+$1000,0);
              AddFixMessage(GetShortMsg(1,361, ObjZav[ptr].Liter,0),4,4);
              inc(ObjZav[Ptr].siParam[1]);
            end;
          {$ENDIF}
          end;
         end;
         8: //------------------------------------------------------- ���� � ������ ������
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZav[ptr].RU then
            begin
              InsArcNewMsg(Ptr,360+$1000,0);
              AddFixMessage(GetShortMsg(1,360, ObjZav[ptr].Liter,0),4,4);
              ObjZav[Ptr].dtParam[1] := LastTime;
              inc(ObjZav[Ptr].siParam[1]);
            end;
            {$ENDIF}
          end;
         end;
      end;
    end;
    ObjZav[Ptr].bParam[1] := dnk;
    ObjZav[Ptr].bParam[2] := nnk;
    ObjZav[Ptr].bParam[3] := auk;
    ObjZav[Ptr].bParam[4] := dn;

    if ObjZav[Ptr].VBufferIndex > 0 then
    begin
      OVBuffer[ObjZav[Ptr].VBufferIndex].Param[16] := ObjZav[Ptr].bParam[31]; //����������
      if ObjZav[Ptr].bParam[31] then
      begin
        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[1] := ObjZav[Ptr].bParam[1];//������ "����"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[1] := ObjZav[Ptr].NParam[1];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[2] := ObjZav[Ptr].bParam[2];//������ "����"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[2] := ObjZav[Ptr].NParam[2];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[3] := ObjZav[Ptr].bParam[3];//������ "����"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[3] := ObjZav[Ptr].NParam[3];

        OVBuffer[ObjZav[Ptr].VBufferIndex].Param[4] := ObjZav[Ptr].bParam[4];//- ������ "��"
        OVBuffer[ObjZav[Ptr].VBufferIndex].NParam[4] := ObjZav[Ptr].NParam[4];

        OVBuffer[ObjZav[Ptr].VBufferIndex].DZ3 := AllKod;
      end;
    end;
  except
    reportf('������ [MainLoop.PrepST]');
    Application.Terminate;
  end;
end;
end.
