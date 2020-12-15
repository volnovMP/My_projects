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

procedure SetDateTimeARM;
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
procedure PrepareOZ;
procedure GoOVBuffer(Ptr,Steps : Integer);

procedure DiagnozUVK;
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
function Get_ManK(Ptr : SmallInt) : Boolean;

procedure PrepXStrelki(Xstr : Integer); //------------------------------ ����� ������� (1)
procedure PrepStrelka(Str : Integer);//-------------------------------------- �������� (2)
procedure PrepOxranStrelka(StrOh : Integer);
procedure PrepSekciya(SP : Integer); //------------------------------ ������ �� ��� �� (3)
procedure PrepPuti(PUT : Integer);  //------------------------------------------- ���� (4)
procedure PrepSvetofor(SVTF : Integer);
procedure PrepRZS(RZST : Integer);//-------------------------- ������ ��������� �������(9)
procedure PrepMagStr(Ptr : Integer);
procedure PrepMagMakS(MagM : Integer); //-------------------------- ���������� ������ (18)
procedure PrepPTO(PTO : Integer);
procedure PrepUTS(UTS : Integer);
procedure PrepUPer(UPER : Integer);
procedure PrepKPer(KPER : Integer);
procedure PrepK2Per(KPER2 : Integer);
procedure PrepOM(OPV : Integer);    //--------------------------- ���������� �������� (13)
procedure PrepUKSPS(UKS : Integer); //------------- �������� ����� ���������� ������� (14)
procedure PrepAB(AB : Integer);    //------------ ������ � ���������, ��������������� (15)
procedure PrepVSNAB(VSN : Integer); //------------- ��������������� ����� ����������� (16)
procedure PrepAPStr(AVP : Integer); //--------------------- ��������� ������� ������� (19)
procedure PrepMaket(MAK : Integer); //----------------------------------------- ����� (20)
procedure PrepOtmen(OTM : Integer); //                                                (21)
procedure PrepGRI(GRI : Integer);   //------------------------------------------- ��� (22)
procedure PrepPAB(PAB : Integer); //------------------- ������������������ ���������� (26)
procedure PrepDZStrelki(Dz : Integer); //--------- �������������� ����������� ������� (27)
procedure PrepDSPP(Ptr : Integer);
procedure PrepPSvetofor(Ptr : Integer);
procedure PrepPriglasit(PRIG : Integer);
procedure PrepNadvig(NAD : Integer); //--------------------- ������ � ������ - ������ (32)
procedure PrepMarhNadvig(Ptr : Integer);
procedure PrepMEC(MEC : Integer);       //------------------------------ ������ � ��� - 23
procedure PrepZapros(UPST : Integer); //------------------------ ������ ����� ������� - 24
procedure PrepManevry(MNK : Integer); //-------------------------- ���������� ������� - 25
procedure PrepSingle(Ptr : Integer);
procedure PrepInside(Ptr : Integer);
procedure PrepPitanie(Ptr : Integer);
procedure PrepSwitch(Ptr : Integer);
procedure PrepIKTUMS(Ptr : Integer);
procedure PrepKRU(KRU : Integer);
procedure PrepIzvPoezd(Ptr : Integer);
procedure PrepVPStrelki(VPSTR : Integer); //--------------------------- ������� � ���� #41
procedure PrepVP(SVP : Integer);//----------------------- ������������� ������� � ���� #42
procedure PrepOPI(Ptr : Integer);
procedure PrepSOPI(Ptr : Integer);
procedure PrepSMI(Ptr : Integer);
procedure PrepZon(Zon : Integer); //---------------------------------- ���� ���������� #45
procedure PrepRPO(Ptr : Integer);
procedure PrepAutoSvetofor(AvtoS : Integer);//----------------- "������������ �������" #46
procedure PrepAutoMarshrut(AvtoM : Integer);//---------------- "������������ ��������" #47
procedure PrepABTC(ABTC : Integer);
procedure PrepDCSU(Ptr : Integer);
procedure PrepDopDat(Ptr : Integer);//-----------------
procedure PrepSVMUS(MUS : Integer);
procedure PrepST(SiT : Integer);    //------------------------------ ���������� ����� (54)
procedure PrepDN(Ptr : Integer);
procedure PrepDopSvet(SvtDop : Integer); //------------ ������ ���������� � ��������� (55)
procedure PrepUKG(UKG : Integer); //---------------------------------------------- ���(56)
procedure PrepRDSH(RDSH : Integer); //--------------- �������� ���������� ����������� (60)
const
  DiagUVK : SmallInt  = 5120; // ����� ��������� � ������������� ���� ���
  DateTimeSync : Word =    1; //6144 ����� ��������� ��� ������������� ������� �������
{$IFDEF RMSHN}
  StatStP = 5;// ���������� ��������� ��� ���������� ������� ������������ �������� �������
{$ENDIF}


implementation

uses
  Marshrut,
  Commands,
  TypeALL,
{$IFDEF RMDSP}
  //PipeProc,
  TabloDSP,
  KanalArmSrvDSP,
{$ENDIF}

{$IFDEF RMSHN}
  KanalArmSrvSHN,
  ValueList,
  TabloSHN,
{$ENDIF}

{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

  Commons;
var
  s,dt  : string;


procedure SetDateTimeARM;

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
  if FR8 > 0 then
  begin
    time64 := FR8; err := false;
    Sc := time64 and $00000000000000ff;  time64 := time64 shr 8;  //-------------- �������
    Mn := time64 and $00000000000000ff;  time64 := time64 shr 8;  //--------------- ������
    Hr := time64 and $00000000000000ff;  time64 := time64 shr 8;  //----------------- ����
    Dy := time64 and $00000000000000ff;  time64 := time64 shr 8;  //----------------- ����
    Mt := time64 and $00000000000000ff;  time64 := time64 shr 8;  //---------------- �����
    Yr := (time64 and $00000000000000ff) + 2000; //----------------------------------- ���

    if not TryEncodeTime(Hr,Mn,Sc,0,nt) then
    begin
      err := true;
      InsNewMsg(0,507,1,'');
      AddFixMes(GetSmsg(1,507,'',1) + '������� ��������� ������� '+
      IntToStr(Hr)+':'+ IntToStr(Mn)+':'+ IntToStr(Sc),4,1);
    end;

    if not TryEncodeDate(Yr,Mt,Dy,nd) then
    begin
      err := true; InsNewMsg(0,507,1,'');
      AddFixMes(GetSmsg(1,507,'',1) + '������� ��������� ���� '+
      IntToStr(Yr)+'-'+ IntToStr(Mt)+'-'+ IntToStr(Dy),4,1);
    end;

    if not err then
    begin
      ndt := nd + nt; delta := ndt - LastTime;
      DateTimeToSystemTime(ndt,uts);
      SystemTimeToTzSpecificLocalTime(nil,uts,lt);
      cdt := SystemTimeToDateTime(lt) - ndt;
      ndt := ndt - cdt;
      DateTimeToSystemTime(ndt,uts);
      SetSystemTime(uts);

      //-------------------------------------------------- ��������� ������� ������� � FR3
      for i := 1 to high(FR3s) do if FR3s[i] > 0.00000001 then FR3s[i] := FR3s[i] - delta;

      //-------------------------------------------------- ��������� ������� ������� � FR3
      for i := 1 to high(FR4s) do if FR4s[i] > 0.00000001 then FR4s[i] := FR4s[i] - delta;

      for i := 1 to high(ObjZv) do
      begin //-------------------------- ��������� ������� ������� � �������� ������������
        if ObjZv[i].T[1].Activ then    ObjZv[i].T[1].F := ObjZv[i].T[1].F - delta;
        if ObjZv[i].T[2].Activ  then   ObjZv[i].T[2].F := ObjZv[i].T[2].F - delta;
        if ObjZv[i].T[3].Activ then    ObjZv[i].T[3].F := ObjZv[i].T[3].F - delta;
        if ObjZv[i].T[4].Activ then    ObjZv[i].T[4].F := ObjZv[i].T[4].F - delta;
        if ObjZv[i].T[5].Activ then    ObjZv[i].T[5].F := ObjZv[i].T[5].F - delta;
      end;
      LastSync := ndt;
      LastTime := ndt;
    end;
    //------------------------------------------------------------------ �������� ��������
    FR8 := 0;
  end;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------------------------- ������ �� ������ �����������
procedure GoOVBuffer(Ptr,Steps : Integer);
var
  LastStep, cPtr : integer;
begin
  LastStep := Steps;
  cPtr := Ptr;
  while LastStep > 0 do  StepOVBuffer(cPtr,LastStep);
end;

//========================================================================================
//------------------------------------------------------ ������� ��� �� ������ �����������
function StepOVBuffer(var Ptr, Step : Integer) : Boolean;
var
  oPtr : integer;
begin
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
        Ptr := OVBuffer[Ptr].Jmp2;
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
        if not ObjZv[OVBuffer[oPtr].DZ1].bP[2] then   //------------------ �� �� �������
        begin
          if ObjZv[OVBuffer[oPtr].DZ1].bP[1] then  //------------------- ���� �� �������
          begin
            if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24] //���� ����.���.
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

          if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24]//--------- ������� �� ��
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

          OVBuffer[Ptr].Param[5] :=OVBuffer[oPtr].Param[5];//���������� ���������� "�"
          OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7]; //------- ���������� "��"

          OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8]; //---------- ���������� ���
          OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //-- ���������� ���������
        end;

        if ObjZv[OVBuffer[oPtr].DZ1].bP[7] or //-���� ������� ���������� �� ��� ...
        (ObjZv[OVBuffer[oPtr].DZ1].bP[10] and //----- ������ ������ �� ������ � ...
        ObjZv[OVBuffer[oPtr].DZ1].bP[11]) or //---- ������ ������ �� ������ ��� ...
        ObjZv[OVBuffer[oPtr].DZ1].bP[13] then //--------------- ���������� � ������
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
        if not ObjZv[OVBuffer[oPtr].DZ1].bP[1] then //----------------- ���� ��� ��
        begin
          if ObjZv[OVBuffer[oPtr].DZ1].bP[2] then //------------------ ���� ���� ��
          begin
            if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24] // ������� �� ��
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
          if ObjZv[ObjZv[OVBuffer[oPtr].DZ1].BasOb].bP[24]//--------- ���� ��
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
          OVBuffer[Ptr].Param[5] := OVBuffer[oPtr].Param[5];  //------------ ����� "�"
          OVBuffer[Ptr].Param[7] := OVBuffer[oPtr].Param[7];  //----------- ����� "��"
          OVBuffer[Ptr].Param[8] := OVBuffer[oPtr].Param[8];   //------------- ����� ���
          OVBuffer[Ptr].Param[10] := OVBuffer[oPtr].Param[10]; //------- ����� ���������
        end;

//------------------------------------------------------- �� �������� �� ��������� �������
//      if not ObjZv[OVBuffer[oPtr].DZ1].bP[3] then //---------------- ���� �� "��"
//      OVBuffer[Ptr].Param[10] := false;

        if ObjZv[OVBuffer[oPtr].DZ1].bP[6] or // ���� ������� ���������� �� ��� ...
        (ObjZv[OVBuffer[oPtr].DZ1].bP[10] and //--- ������ ������ ����������� � ...
        not ObjZv[OVBuffer[oPtr].DZ1].bP[11]) or //�� ������ ������ ����������� ���
        ObjZv[OVBuffer[oPtr].DZ1].bP[12] then //---- ���������� � ����� �� ��������
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
end;

//========================================================================================
//-------- ��������� � ����� ������� �������� ������������ ��������� (����� ��� ���������)
procedure SetPrgZamykFromXStrelka(ptr : SmallInt);
var
  Xstr, str1, str2 : Integer;
begin
  Xstr := ObjZv[ptr].BasOb; //----------------------------------------- ����� �������
  str1 := ObjZv[Xstr].ObCI[8]; //------------------- ��������� ������� (���2) �������
  Str2 := ObjZv[Xstr].ObCI[9]; //------------------- ��������� ������� (���2) �������
  if ObjZv[ptr].bP[14] then ObjZv[Xstr].bP[14] := true //- ������� ��������,�������� �����
  else
  begin //------------------- ���� ��� ��������� ������� - ��������� ������� ��� ���������
    if ObjZv[Xstr].ObCI[9] = 0 then ObjZv[Xstr].bP[14] := false //--------- ���������
    else
    begin //-------------------------------------------------------------------- ���������
      if ObjZv[Xstr].ObCI[8] = ptr then //-- ����� �� ����� ����� ����������� �������
      begin
        if not ObjZv[str2].bP[14] then ObjZv[Xstr].bP[14] := false; //- ������� ����������
      end else
      begin //-------------------------------------------- ����� ����� ����������� �������
        if not ObjZv[str1].bP[14] then  ObjZv[Xstr].bP[14] := false; // ������� ����������
      end;
    end;
  end;
end;

//========================================================================================
//---------------------------------- ��������� ����������� � �������������� ���������� ���
procedure DiagnozUVK;
var
  u,m,p,o,z,c : int64;
  t : boolean;
  msg,ii : Integer;
begin
  c := FR7;
  if NenormUVK[1] <> c then
  begin
    if c > 0 then
    begin
      u := c and $f0000000; u := u shr 28;  //---------------------- �������� ����� ������
      m := c and $0c000000; m := m shr 26;  //----------------- �������� ����� �����������
      o := c and $ff0000;   o := o shr 16;  //--------- �������� ����� ������������ ������
      z := c and $ffff;  //-------------------------------------- �������� �������� ������

      if (u > 0) and (m > 0) and (o > 0) then
      begin
        s := '���' + IntToStr(u)+ ' ����' + IntToStr(m);
        s := s + '. �� ������' + IntToStr(o) + ' ������ ����� ' + IntToHex(z,4);
        AddFixMes('��������� ����������� '+ s,4,4);
        DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
        s := dt + ' > '+ s;
        ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
        NewNeisprav := true; SBeep[4] := true;
        InsNewMsg(0,$3003,1,'');
      end else
      begin //--------------------------------------------------- �������������� ���������
        InsNewMsg(0,508,1,'');
        AddFixMes(GetSmsg(1,508,'',1),4,4);
      end;
      FR7 := 0; // �������� ������������ ���������
    end;
  end else
  begin
    if NenormUVK[1] = FR7 then exit else NenormUVK[1] := FR7;
    if NenormUVK[2] = FR9 then exit else NenormUVK[2] := FR9;
    c := FR7;
    if c > 0 then
    begin
      s := '���������� ������ ';
      if ii < 10 then
      begin
        s := s + NameGrup[ii];
        if c = 1 then s := s +'1' else s := s + '2';
      end else
      begin
        if ii >= 21 then exit;
        if c = 1 then s := s + NameO1[ii-9]  else s := s + NameO2[ii-9];
      end;
      AddFixMes('��������� ����������� '+ s,4,4);
      DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime);
      s := dt + ' > '+ s;
      ListDiagnoz := dt + ' > ' + s + #13#10 + ListDiagnoz;
      NewNeisprav := true; SBeep[4] := true;
      z := ii shl 8;
      z := z or c;
      InsNewMsg(z,3008,1,'');
    end;
  end;
end;

//========================================================================================
//------------------------------------------------------ �������� �� �� ���������� �������
function Get_ManK(Ptr : SmallInt) : Boolean;
begin
  // ������� ���������� �������� (��� ����� ������� ������ ���������� �������� �� �������)
  //-------------------------------------------------------- ��������� ����� �� � �� ��(�)
  result := ObjZv[Ptr].bP[1] and  not ObjZv[Ptr].bP[4];
end;

//========================================================================================
//---------------------------------------- ���������� �������� ������������ ��� ����������
procedure PrepareOZ;
var
  c,Ptr,ii,k,l,jj,i,j,cfp: integer;
  s : string;
  st : byte;
  fix,fp,fn : Boolean;
begin
  c := 0; k := 1;
  SetDateTimeARM;  //-------------- ���������� ������� ������������� �������
  if DiagnozON then DiagnozUVK;//------------- ���������� ����������� � �������������� ���

  //---- �������������� ##################################################################
  if NewFr6 <> OldFr6 then //------------- ���� ���������� ����� �������������� � ��������
  begin
    if NewFr6 > 0 then
    begin
      s :=  '���������� ������ ';   ii :=  NewFr6 and $FF;
      for l := 0 to 7 do
      begin
        k := 1 shl l;    c :=  ii and k;
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

        if NewFr6 > 0 then //--------------------- ��������� ��� ������������ ���� �������
        begin
          jj := (NewFr6 shr 8)*8 + k; s := s+LinkFr[jj].Name+';';
          InsNewMsg(jj,$3010,1,'');
        end;
      end;
      OldFr6 := NewFr6;
      AddFixMes('��������� ����������� '+ s,4,4);
      DateTimeToString(dt,'dd-mm-yy hh:nn:ss', LastTime); s := dt + ' > '+ s;
      ListDiagnoz := s + #13#10 + ListDiagnoz;
      NewNeisprav := true;  SBeep[4] := true;
      OldFr6 := NewFr6;
    end;
  end;

{$IFNDEF RMARC}
  //------------------------------------------------------------ ���������� ������ FR3,FR4
  if DiagnozON and WorkMode.FixedMsg then
  begin //-------------------------- ��������� �������� �������������� ������� �����������
    for Ptr := 1 to FR_LIMIT do
    begin
      if (Ptr <> WorkMode.DirectStateSoob) and (Ptr <> WorkMode.ServerStateSoob) then
      begin  //------------- ���� �� ������ �������������� � �� ������ ���������� ��������
        st := byte(FR3inp[Ptr]);
        if (st and $20) <> (FR3[Ptr] and $20) then //-- ��������� ��������� ��������������
        begin
          if (Ptr <> MYT[1]) and (Ptr <> MYT[2]) and (Ptr <> MYT[3]) and (Ptr <> MYT[4])
          and (Ptr <> MYT[5]) and (Ptr <> MYT[6]) and (Ptr <> MYT[7]) and (Ptr<> MYT[8])
          and (Ptr <> MYT[9]) then
          begin //----------------- ���� ������� ������ �� ��������� � ����� - �����������
            if ((st and $20) <> $20)  then
            begin
              InsNewMsg(Ptr,$3002,7,''); //- "��������.�������������� �������� ����������"
              FR6[Ptr]:=0;  NewFR6 :=0;  OldFr6 := 0;
            end else InsNewMsg(Ptr,$3001,1,'');// ������.������������� �������� ����������
          end;
        end;
        FR3[Ptr] := st;
      end;
      if FR4inp[Ptr] > char(0) then FR4s[Ptr] := LastTime;
    end;
  end else
  begin //------------ ���� ����������� �� �����������, �� ������ ���������� ������� �����
{$ENDIF}
    for Ptr := 1 to FR_LIMIT do
    begin {$IFNDEF RMARC} FR3[Ptr] := byte(FR3inp[Ptr]); {$ENDIF}  end;
{$IFNDEF RMARC}
  end;
  //-------------------------------------------------------------- �������� ���������� FR5
  if LastTime > LastDiagD then begin LastDiagN := 0; LastDiagI := 0; end;
{$ENDIF}

  //########################################### ���������� �������� ��������� ����� ������
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    for ii := 1 to 32 do OVBuffer[ObjZv[ptr].VBufInd].Param[ii] := false;
    case ObjZv[Ptr].TypeObj of
      1 :  //----------------------------------------------------- � ������ ������ �������
      begin
        ObjZv[Ptr].bP[5] := false; //----------------- �����  ���������� �������� ��������
        ObjZv[Ptr].bP[8] := false; //------------ ����� ������� �������� �������� ��������
        ObjZv[Ptr].bP[10] := false;//------ ����� ����(��������� ������� � + ��� ��������)
        ObjZv[Ptr].bP[11] := false;//------ ����� ����(��������� ������� � - ��� ��������)
      end;

      27 : //------------------------------- ��������� ������� �������������� ������������
      begin
        ObjZv[Ptr].bP[5] := false; //------------------ ����� ���������� �������� ��������
        ObjZv[Ptr].bP[8] := false; //------------ ����� ������� �������� �������� ��������
      end;

      41 : //-------------------------------------------- ������ ���������� ������� � ����
      begin
        ObjZv[Ptr].bP[1] := false; //----------------- ����� ������� �������� 1-�� �������
        ObjZv[Ptr].bP[2] := false; //----------------- ����� ������� �������� 2-�� �������
        ObjZv[Ptr].bP[3] := false; //----------------- ����� ������� �������� 3-�� �������
        ObjZv[Ptr].bP[4] := false; //----------------- ����� ������� �������� 4-�� �������
        ObjZv[Ptr].bP[8] := false; //---------------- ����� ������� �������� �������� 1-��
        ObjZv[Ptr].bP[9] := false; //---------------- ����� ������� �������� �������� 2-��
        ObjZv[Ptr].bP[10] := false;//---------------- ����� ������� �������� �������� 3-��
        ObjZv[Ptr].bP[11] := false;//---------------- ����� ������� �������� �������� 4-��
      end;

      44 : //--------------------------------------------- ���������� ������� ��� ��������
      begin
        ObjZv[Ptr].bP[1] := false; //-------------------  ����� ���������� �������� � ����
        ObjZv[Ptr].bP[2] := false; //------------------- ����� ���������� �������� � �����
        ObjZv[Ptr].bP[5] := false; //------------------ ����� ���������� �������� ��������
        ObjZv[Ptr].bP[8] := true; //-------------- ���������� �������� �������� ��������
      end;

      48 : ObjZv[Ptr].bP[1] := false; //��� ----------- ����� ���������� �������� � ������
    end;
  end;

  //------------------------------------------------------ ���������� ����������� �� �����
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
  //  1 : --------------------------------------------- ����� ������� �������������� �����
  //  2 : --------------------------------------------------- ������� �������������� �����
      3  : PrepSekciya(Ptr);//----------------------------------------------------- ������
      4  : PrepPuti(Ptr); //--------------------------------------------------------- ����
//    5 : --------------------------------------------------- ������ �������������� ������
      6  : PrepPTO(Ptr);       //----------------------------------------- ���������� ����
      7  : PrepPriglasit(Ptr); //---------------------------------- ��������������� ������
      8  : PrepUTS(Ptr);  //----------------------------------------- ��������� ���� (���)
      9  : PrepRZS(Ptr);  //------------------------------------- ������ ��������� �������
      10 : PrepUPer(Ptr); //----------------------------------------- ���������� ���������
      11 : PrepKPer(Ptr); //------------------------------------- �������� �������� (���1)
      12 : PrepK2Per(Ptr);//------------------------------------- �������� �������� (���2)
      13 : PrepOM(Ptr);  //------------------------------------------- ���������� ��������
      14 : PrepUKSPS(Ptr); //--------------------------- �������� ����� ���������� �������
      15 : PrepAB(Ptr);    //------------------------------------ ������ � ���������������
      16 : PrepVSNAB(Ptr); //-------------------------- ��������������� ����� ������������
      17 : PrepMagStr(Ptr);//--------------------------------------- ���������� ����������
      18 : PrepMagMakS(Ptr); //--------------------------------- ���������� ������ �������
      19 : PrepAPStr(Ptr); //----------------------------------- ��������� ������� �������
      20 : PrepMaket(Ptr); //----------------------------------------------- ����� �������
      21 : PrepOtmen(Ptr); //----------------------------------- �������� ������ ���������
      22 : PrepGRI(Ptr); //---------------------------------------- ������������� ��������
      23 : PrepMEC(Ptr); //------------------------------- ���������� ������� ������ � ���
      24 : PrepZapros(Ptr); //-------------- ���������� ������� ������ � �������� ��������
      25 : PrepManevry(Ptr); //--------------------- ���������� ������� ���������� �������
      26 : PrepPAB(Ptr); //--------------------------------- ������������������ ����������
//    27 : ------------------------------------------ �� ��� ������� �������������� ������
//    28 : PrepPI(Ptr) ------------------------------ �� ������� ��������������� ���������
//    29 : -------------------------------- �� ��� �� �� ������� ��������������� ���������
      30 : PrepDSPP(Ptr); //-------------------------------- ������� ���� ��������� ������
      31 : PrepPSvetofor(Ptr); //----------------------------------- ����������� ���������
      32 : PrepNadvig(Ptr);   //--------------------------------- ������ � ������ (������)
      33 : PrepSingle(Ptr);     //------------------------------ ������ - ��������� ������
      34 : PrepPitanie(Ptr); //----------------------------------- ������ ����������������
      35 : PrepInside(Ptr); //-------- ������ � ���������� ���������� ������� ������������
      36 : PrepSwitch(Ptr);      //-------------------------- ������ - ������ + 5 ��������
      37 : PrepIKTUMS(Ptr);       //-------------- ������ - �������������� ���������� ����
      38 : PrepMarhNadvig(Ptr); //---------------------------------------- ������ �� �����
      39 : PrepKRU(Ptr); //------------------------------------ �������� ������ ����������
      40 : PrepIzvPoezd(Ptr);  //------------------------------------ �������� �����������
//    41 : ------------------------------------------- ������� � ���� �������������� �����
      42 : PrepVP(Ptr); //----------------------------------- ������������� ������� � ����
      43 : PrepOPI(Ptr);  //------------------------ ���������� ���� �� ����������� ������
      45 : PrepZon(Ptr); //--------------------- ���������� ������� ������ ���� ����������
      46 : PrepAutoSvetofor(Ptr); //------------------------------- ������������ ���������
      48 : PrepRPO(Ptr); //------------- ���������� ������/����������� � ���������� ������
      49 : PrepABTC(Ptr);
      50 : PrepDCSU(Ptr);
      51 : PrepDopDat(Ptr);
      52 : PrepSVMUS(Ptr);
//    53 : ------------------------ ������ ������ ��� �� ������� ��������������� ���������
      54 : PrepST(Ptr);    //-------------------------------------------- ���������� �����
      55 : PrepDopSvet(Ptr);
      56 : PrepUKG(Ptr); //------------------------ ������ "���������� �������� ���������"
      60 : PrepRDSH(Ptr); //--------------------- ������ "�������� ���������� �����������"
      92 : PrepDN(Ptr); //--------------------------------------------- ������ "����-����"
    end;
    inc(c);
    if c > 500 then c := 0;
  end;

  //-------------------------------------------------------- ��������� ��������� ���������
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
      1  : PrepXStrelki(Ptr);
      5  : PrepSvetofor(Ptr);
    end;
  end;


  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
      2  : PrepOxranStrelka(Ptr);
      27 : PrepDZStrelki(Ptr);
    end;
  end;

  //--------------------------------------------- ����� �� ����� ����������� ������� � ��.
  for Ptr := 1 to WorkMode.LimitObjZav do
  begin
    case ObjZv[Ptr].TypeObj of
      2  : PrepStrelka(Ptr);
      41 : PrepVPStrelki(Ptr);
      43 : PrepSOPI(Ptr);
      47 : PrepAutoMarshrut(Ptr);
    end;
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
  begin //---------------------------------------------------------------------- � �������
    if (SrvState and $7) = 0 then
    begin //--------------------------------------- ������������� ������ ������ ����������
      SrvCount := 1;
      WorkMode.RUError := WorkMode.RUError or $4;
    end else
    begin //----------------------------------------- ����������� ������ ������ ����������
      SrvCount := 2;
      WorkMode.RUError :=  WorkMode.RUError and $FB;
    end;
    //--------------------------------------------------------------- ����� �������� �����
    if SrvState and $30 = $10 then SrvActive := 1 else
    if SrvState and $30 = $20 then SrvActive := 2 else
    if SrvState and $30 = $30 then SrvActive := 3 else
    SrvActive := 0;
  end else
  begin //--------------------------------------------------------------------- �� �������
    //---------------------------------------------------------------- ���������� ��������
    if ((SrvState and $7) = 1) or ((SrvState and $7) = 2) or ((SrvState and $7) = 4) or
    ((SrvState and $7) = 0) then SrvCount := 1
    else
    if (SrvState and $7) = 7 then SrvCount := 3 else SrvCount := 2;
    //------------------------------------------------------------ ����� ��������� �������
    if ((LastRcv + MaxTimeOutRecave) > LastTime) then
    begin
      if (SrvState and $30) = $10 then SrvActive := 1
      else
      if (SrvState and $30) = $20 then SrvActive := 2
      else
      if (SrvState and $30) = $30 then SrvActive := 3 else SrvActive := 0;
    end else SrvActive := 0;
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
    if FixNotify[i].Enable and
    ((FixNotify[i].Datchik[1]>0) or (FixNotify[i].Datchik[2]>0) or
    (FixNotify[i].Datchik[3]>0) or (FixNotify[i].Datchik[4]>0)
    or (FixNotify[i].Datchik[5] > 0) or (FixNotify[i].Datchik[6] > 0)) then

    for j := 1 to 6 do
    if FixNotify[i].Datchik[j] > 0 then
    begin
      fp := GetFR3(LinkFR[FixNotify[i].Datchik[j]].FR3,fn,fn);//-------- ��������� �������
      fix := (FixNotify[i].State[j] = fp) and not fn;
      if fix then inc(cfp);
    end;

    if cfp > 0 then
    begin //---------------------------------------------------- ������ ������� �� �������
      for k := 1 to 6 do if FixNotify[i].Datchik[k] > 0 then dec(cfp);

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
      end else FixNotify[i].fix := false;
    end else  FixNotify[i].fix := false;
  end;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------- ���������� ������� ������ ������� #1
procedure PrepXStrelki(Xstr : Integer);
var
  i, oDZ, kSP, kST, p, str_1, str_2, sp_1, sp_2, RMU, grp : integer;
  pk,mk,pks,nps,d,bl : boolean;
  {$IFDEF RMSHN} dvps : Double; {$ENDIF}   //--------------- ������������ �������� �������
begin
  with ObjZv[Xstr] do
  begin
    str_1 := ObCI[8]; str_2 := ObCI[9];//-- 1 ������� ������(����),2 ������� ������ (����)
    sp_1 := ObjZv[str_1].UpdOb; //---------------------------- �� ������ ������� (�������)
    if str_2 > 0 then sp_2 := ObjZv[str_2].UpdOb  //---------- �� ������ ������� (�������)
    else sp_2 := 0;

    grp := Group; //----------------------------------------------------------- ������ ���

    bP[31] := true; //-------------------------------------------------------- �����������
    bP[32] := false;//----------------------------------------------------- ��������������

    pk  := GetFR3(ObCI[2],bP[32],bP[31]); //------------------------------------------- ��
    mk  := GetFR3(ObCI[3],bP[32],bP[31]); //------------------------------------------- ��
    nps := GetFR3(ObCI[4],bP[32],bP[31]); //------------------------- ������������ �������
    pks := GetFR3(ObCI[5],bP[32],bP[31]); //---------------------- ������ �������� �������

    if bP[31] and not bP[32] then  //----------- ���� ������������ � ���������� ����������
    begin
{$IFDEF RMSHN}  //------------------------------------------------------------ ��� ���� ��
      if not(pk or mk or pks or T[1].Activ or T[2].Activ) then
      begin //---------------------------------- ��� ��, ��, ���, �� ������� ������� 1 � 2
        //----------------------- ���������� ��������� "�����" , ��������� ����� ������ ��
        if sbP[2] then begin T[2].Activ  := true; T[2].F := LastTime; end;
        //-------------------- ���� ���������� ��������� "����", ��������� ����� ������ ��
        if sbP[1] then  begin  T[1].Activ  := true;  T[1].F := LastTime; end;
      end;
{$ENDIF}
      if pk and mk then begin  pk := false; mk := false; end; // �������� �� � �� ���� ���

      if (bP[25] <> nps) and nps then // ��������� ��� ���������� ������� � ���� ���������
      begin
        if WorkMode.FixedMsg then
        begin //---------------- ����� ������� "��������� �������", ��������� ���� �������
{$IFDEF RMSHN} InsNewMsg(Xstr,270+$1000,1,'');dtP[2] := LastTime; inc(siP[3]);
{$ELSE}
          if config.ru = RU then
          begin //------------------------------------------- "������� <Xstr> �� ��������"
            InsNewMsg(Xstr,270+$1000,1,'');
            AddFixMes(GetSmsg(1,270,Liter,1),4,1);
          end;
{$ENDIF}
        end;
      end;
      bP[25] := nps;  //------------------------------ ���� ���������� ������� � ���������

      for i := 6 to 7 do
      begin
        d := false;
        oDZ := ObCI[i];  //------------------------- ����� ������ ��� ���������� ������ ��
        if oDZ > 0 then //---- ���� ������� ����� ����� � �� ��������� �������� ����������
        case ObjZv[oDZ].TypeObj of //--------------------- ������������� �� ���� ������ ��
          25: d:= Get_ManK(oDZ); //------------- ���� ���������� �������, �� �������� ��&�
          44: d:= Get_ManK(ObjZv[oDZ].BasOb);//---------------- ������. �� �������� - ��&�
        end;
        if d then break;
      end;

      //-- ���� ��, �� ������ ������� "�����.������", ���� ��� ��, �� ������� ������� "��"
      if d then bP[24] := true else bP[24] := false;

      if bP[26] <> pks then //---------------------  ��������� ��� ������ �������� �������
      begin
        if pks then //----------------------------------- �������� ������ �������� �������
        begin
{$IFDEF RMSHN}
          //-------------------- ��� ��� �� ��������� ��������� ���������� ������ ��������
          T[1].Activ := false; T[2].Activ := false; //---- �������� ������� ������ "+","-"
          //----------------------------- ���� �������� � ���������� �� ��� � ��� � ��� ��
          if WorkMode.FixedMsg and WorkMode.OU[0] and WorkMode.OU[grp] and not d then
          begin// -------------------------------------------- "������� �������� ��������"
            InsNewMsg(Xstr,271+$1000,0,''); SBeep[3] := true; dtP[1] := LastTime;

            //-------------------------------------------------- ���� ������� ���� � �����
            if sbP[1] then  begin if bP[22] then inc(siP[1]) else inc(siP[6]);  end;

            //------------------------------------------------- ���� ������� ���� � ������
            if sbP[2] then begin if bP[22] then inc(siP[2]) else inc(siP[7]); end;
          end;
{$ELSE}
          if WorkMode.FixedMsg and not d and (config.ru = RU) then
          begin //-------------------------------------------- "������� �������� ��������"
            InsNewMsg(Xstr,271+$1000,0,''); AddFixMes(GetSmsg(1,271,Liter,0),4,3);
          end;
{$ENDIF}
        end else //------------------------------------------- ���� �������� �������������
        begin
          if WorkMode.FixedMsg and not d then//- "������������ �������� ��������� �������"
          begin
{$IFDEF RMSHN} InsNewMsg(Xstr,345+$1000,0,''); SBeep[2] := true;
{$ELSE}
            if config.ru = RU then
            begin
             InsNewMsg(Xstr,345+$1000,0,'');AddFixMes(GetSmsg(1,345,Liter,0),5,2);
            end;
{$ENDIF}
          end;
        end;
      end;
      bP[26] := pks;

      bP[1] := pk;   bP[2] := mk;

{$IFDEF RMSHN}
      if pk then //---------------------------------------------------���� ������� � �����
      begin
        T[1].Activ  := false;
        if T[2].Activ then
        begin //----------------------------------- ��������� ������������ �������� � ����
          T[2].Activ  := false; dvps := LastTime - T[2].F; //--- ������������ �������� � +
          if dvps > 1/86400 then
          begin //------------------------------------ ���� ��������� ������ �����.�������
            if siP[4] > StatStP then dvps := (dtP[3] * StatStP + dvps)/(StatStP+1)
            else  dvps := (dtP[3]*siP[4]+dvps)/(siP[4]+1);  //----------- ����� ����������
            dtP[3] := dvps;
          end;
        end;
        if not sbP[1] //- ���� �� � "+", ������� ��������� �� � �� � ��������� ������� "+"
        then begin sbP[1] := pk; sbP[2] := mk; if not StartRM then inc(siP[4]); end;
      end;

      if mk then//---------------------------------------------------���� ������� � ������
      begin
        T[2].Activ  := false;
        if T[1].Activ  then
        begin //---------------------------------- ��������� ������������ �������� � �����
          T[1].Activ  := false; dvps := LastTime - T[1].F;//������� ����� �������� � -
          if dvps > 1/86400 then
          begin
            if siP[5] > StatStP then dvps := (dtP[4] * StatStP + dvps)/(StatStP+1)
            else dvps := (dtP[4] * siP[5] + dvps)/(siP[5]+1);
            dtP[4] := dvps;
          end;
        end;
        if not sbP[2] then   //---------------------- ���� ������ ������� ���� �� � ������
        begin
          sbP[1]:= pk; sbP[2]:= mk; //---------------------------- �������� �������� ��,��
          if not StartRM then inc(siP[5]);//--------------- ��������� ������� ���������  -
        end;
      end;
{$ENDIF}

      if ObCB[3] then  //-------------------- ���� ��� ������� ���� ��������� ��� ��� ����
      begin //------------------------------------------------------------- ���� ��� �� ��
        bP[20] :=  true;
        bP[13] :=  true;

        if ObjZv[str_1].ObCB[9] then //----- ���� 1-�� ������� ����� � ������ ��� ��� ����
        //---------------------------------------------- �������� ���� � ��� �� ������� ��
        begin bP[20] :=  ObjZv[sp_1].bP[4]; bP[13] :=  ObjZv[sp_1].bP[11]; end;

        if (str_2 > 0) and ObjZv[str_2].ObCB[9] then //���� ������ ������� � ��� ����� ���
        begin
          //----------------------------- �������� � ������ ���� ������ �� �� 2-�� �������
          bP[20] := bP[20] and ObjZv[SP_2].bP[4];
          //-------------------- �������� � ������ ��� ������������ ������ �� �� 2 �������
          bP[13] := bP[13] and ObjZv[SP_2].bP[11];
        end;
      end else begin bP[20] := true; bP[13] := true; end;//-- �� ���� ��������� ��� � ����

      //--------------------------------------- ���� ��������� �� �� ---------------------
      d := ObjZv[sp_1].bP[2];//-------------------------- �������� ��������� �� �� �������
      if (str_2 > 0) then d := d and ObjZv[SP_2].bP[2]; //�������� ��������� �� �� �������

      if d <> bP[21] then //-------------------------- ���� ��������� ��������� ����������
      begin
        bP[6] := false; bP[7] := false; //------------------------ ����� ��������� �� � ��

        //----------------------------------- ��������� � ������� ����������� ������������
        bl :=  ObjZv[sp_1].bP[20];//------------ ���������� �� ������� �� ������������� ��
        if (str_2 > 0) then //------- ���� ���� �������, �������� �  ���������� �� �������
        bl := bl or ObjZv[sp_2].bP[20]; //-------------------------------- ���������� 2-��

        // ���������� �� = ��������� �� � ��� ���������� �  �������  �� � ������� � ������
        bP[3] := bP[3] or (d and not bl and ObCB[2] and bP[2] and not bP[1]);
      end;
      bP[21] := d; //--------------------------------------- ��������� ��������� ���������

      //------------------------------------------------------------- ���� ��������� �� ��
      bP[22] := ObjZv[sp_1].bP[1]; //----------------------- ����� ��������� �� ������� ��
       //- ���� ������� ������� � �� ���� ��������� �� �������, �� ����� ��������� �������
      if (str_2 > 0) and bP[22] then bP[22] := ObjZv[sp_2].bP[1];

      //------------------------------------------------------ ����� ��������� �����������
      bP[23] := false;

      //------------------------------------------ �������� �������� �� ������� ����������
      bP[9] := false; //---------------------------------------------- �������� ������� ��

      for i := 20 to 24 do //------------------------- ������ �� 5-�� ��������� ������� ��
      if ObCI[i] > 0 then //-------------- ���� ����� ����� �� ������� ����������, ��
      begin
        RMU := ObCI[i]; //------------------------------ ������ ������ �������� ����������
        case ObjZv[RMU].TypeObj of //------------------------ ������������� �� ���� ������
          //----------------------------------------------------------- ���������� �������
          25 : if not bP[9] then bP[9]:= Get_ManK(RMU);//--------- ���� ��� ��,�� ��= ��&�
           //---------------------------------------------- ���������� ������� �� ��������
          44 : if not bP[9] then bP[9]:= Get_ManK(ObjZv[RMU].BasOb);
        end;
      end;

      //----------------------------------------------- �������� ��������������� ���������
      ObjZv[str_1].bP[4] := false; //--------------------- ����� ��������������� ���������
      ObjZv[str_1].bP[4] := ObjZv[str_1].bP[4] or
      ObjZv[str_1].bP[33] or ObjZv[str_1].bP[25]; //--------------------- ���� ��� ��� ���

      //--------------------------------------------------------- ������ ��������� �������
      if (ObCI[12]> 0) and ObjZv[ObCI[12]].bP[1] then ObjZv[str_1].bP[4]:= true;

      if bP[21] then //--------------------------------- ���� ��� �������� ��������� �� ��
      begin
        //--------------------------------------------------- �������� �������� ����������
        if not ObjZv[str_1].bP[4] then //---------------------- ���� ��� ������. ���������
        for i := 6 to 7 do //------------------------- ������ �� 2-�� ��������� ������� ��
        begin
          RMU := ObCI[i];//-------------------------------------- ����� ������ ������
          if RMU > 0 then //---------------------------------- ���� ��� ������� ���� �����
          begin
            if (ObjZv[RMU].TypeObj = 44) then RMU := ObjZv[RMU].BasOb;// ���. �������
            if(ObjZv[RMU].TypeObj = 25) and not ObjZv[RMU].bP[3] then  //--------- ���� ��
            begin ObjZv[str_1].bP[4] := true; break;end;
          end;
        end;

        //-------------------------------------------------------------- �������� ��������
        for i := 20 to 24 do //-------------- ������ �� 5-�� ��������� �������� ������� ��
        begin
          RMU := ObCI[i]; //------------------- �������� ��������� ������
          if RMU > 0 then
          begin
            if (ObjZv[RMU].TypeObj = 44) then RMU := ObjZv[RMU].BasOb;//----- ���. �������
            if(ObjZv[RMU].TypeObj = 25) and not ObjZv[RMU].bP[3] then  //--------- ���� ��
            begin ObjZv[str_1].bP[4] := true; break;end;
          end;
        end;


        if not ObjZv[str_1].bP[4] then//--------------- ���� ��� ��������������� ���������
        //-------------------------------------------------------- �������� ������ �������
        for i := 14 to 19 do //--------------- ������ �� 6-�� ��������� �������� ���������
        begin
          oDZ := ObCI[i];//---------------------------------------------- ��������� ������
          if oDZ > 0 then //---------------------------------------- ���� ���� ������ ����
          begin
            case ObjZv[oDZ].TypeObj of //------------------- ������������� �� ���� �������

              //------------------------------ ��: ���� ��������, ���������� ���.���������
              3: if not ObjZv[oDZ].bP[2] then begin ObjZv[str_1].bP[4]:= true; break; end;

              //-------------------- ���������� �������: ���� ��, ���������� ���.���������
              25: if not ObjZv[oDZ].bP[3] then begin ObjZv[str_1].bP[4]:= true; break;end;

              27 ://------------------------------------ ������ ������� = �������� �������
              begin
                kST:=ObjZv[oDZ].ObCI[1];kSP:=ObjZv[oDZ].ObCI[2];//����������� ������� � ��
                if not ObjZv[kSP].bP[2] then //------ ���� �� ����������� ������� ��������
                begin
                  if ObjZv[oDZ].ObCB[1] and not ObjZv[kST].bP[2] then // �������� �� �����
                  begin ObjZv[str_1].bP[4]:=true;break;end //��� ��, ���������� ���.�����.
                  else
                  if ObjZv[oDZ].ObCB[2] and not ObjZv[kST].bP[1] then //�������� �� ������
                  begin ObjZv[str_1].bP[4]:=true;break;end;//��� ��, ���������� ���.�����.
                end;
              end;

              41 :  //---------------- ���������� ������� � ���� ��� ��������� �����������
              begin //-- ���� ���� ������� ��������� ����������� � ����������� �� ��������
                kSP := ObjZv[oDZ].UpdOb;
                if ObjZv[oDZ].bP[20] and not ObjZv[kSP].bP[2] then //����������� � �������
                begin ObjZv[str_1].bP[4] := true; break; end;  //---------- ���. ���������
              end;

              46 : //----------------------------------------------- ������������ ��������
              begin //----------------------- ���� �������� ������������ -  ���. ���������
                if ObjZv[oDZ].bP[1] then begin ObjZv[str_1].bP[4] := true; break; end;
              end;
            end;
          end;
        end;

        //���� ��� ��������.��������� ������� �������, � �� ���� ������� �������� �� �����
        //������ ��������� ����������� �� ������ ������� ������� �� �� ������ ����������
        //��������, ��� ����� ������� ������, ������������� ������� 
        if not ObjZv[str_1].bP[4] and (str_1 > 0) and ObjZv[str_1].ObCB[7] then
        begin
          oDZ := ObjZv[str_1].Sosed[2].Obj; p := ObjZv[str_1].Sosed[2].Pin;// ����� �� "+"

          //------------------------------------------ �������� �������� �� ������ �������
          i := 100;//------------ ���������� ���������� ����� �����(����� ��� �����������)
          while i > 0 do //---------------------- ���� �� ���������, ���� �� ������ ������
          begin
            case ObjZv[oDZ].TypeObj of //����������� �� ���� ������������ ������� �� �����
              2 : //-------------------------------------------------------------- �������
              begin
                case p of//----------------------- ����������� �� ������ ����� �����������
                  //------------------------------- ���� �� �������� ������� ����� � ����
                  2: if ObjZv[oDZ].bP[2] then break;//������� � ������ �� ������, ��������

                  //------------------------------ ���� �� �������� ������� ����� � �����
                  3: if ObjZv[oDZ].bP[1] then break; //--------- ������� � ������ �� �����

                  //------------------------------- ���� ����� �� ����� 1 �������� �������
                  else ObjZv[str_1].bP[4] := true; break; //- �������� � �������� (������)
                end;
                p:= ObjZv[oDZ].Sosed[1].Pin;oDZ:= ObjZv[oDZ].Sosed[1].Obj;//����� ������ 1
              end;

              //�������,����: ���. ���. ��������� �� ��������� ����������� ���� ��,��,����
              3,4 : begin ObjZv[str_1].bP[4] := not ObjZv[oDZ].bP[2]; break; end;

              else //---------------------------------- ��� ������ �������� ������� ������
                if p = 1 then //---------------------- ���� ������������ � ����� 1 �������
                begin p := ObjZv[oDZ].Sosed[2].Pin; oDZ := ObjZv[oDZ].Sosed[2].Obj; end
                else //-------------------- ���� ������������ � ������ ����� (��� ����� 2)
                begin p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj; end;
            end;

            if (oDZ = 0) or (p < 1) then break;  //----���� 0-������ ��� 0-�����, �� �����
            dec(i);
          end;
        end;

        //���� ��� ��������������� ���������,�� ������� ������� �� ���� �������� �� ������
        if not ObjZv[str_1].bP[4] and (str_1 > 0) and (ObjZv[str_1].ObCB[8]) then
        begin
          oDZ:= ObjZv[str_1].Sosed[3].Obj; p:= ObjZv[str_1].Sosed[3].Pin; //---- ����� "-"

          i := 100;
          while i > 0 do
          begin
            case ObjZv[oDZ].TypeObj of
              2 :   //------------------------------------------------------------ �������
              begin
                case p of
                  //------------------------------------------------ ���� �� ������� �����
                  2: if ObjZv[oDZ].bP[2] then break; //--- ���� ������� � ������ �� ������

                  //----------------------------------------------- ���� �� ������� ������
                  3: if ObjZv[oDZ].bP[1] then break; //---- ���� ������� � ������ �� �����

                  else  ObjZv[str_1].bP[4] := true; break; //-------- ������ � ���� ������
                end;
                p:= ObjZv[oDZ].Sosed[1].Pin;oDZ:= ObjZv[oDZ].Sosed[1].Obj;//����� ����� �1
              end;

              //----------------------------- �������,���� - �� ��������� ����������� ����
              3,4: begin ObjZv[str_1].bP[4] := not ObjZv[oDZ].bP[2]; break; end;

              else //------------------------------------------------------ ������ �������
                if p= 1 then
                begin p:= ObjZv[oDZ].Sosed[2].Pin; oDZ := ObjZv[oDZ].Sosed[2].Obj; end
                else
                begin p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj; end;
            end;

            if (oDZ = 0) or (p < 1) then break; //  ---���� 0-������ ��� 0-�����, �� �����
            dec(i);
          end;
        end;

        //���� ��� ��������������� ���������, �� ������� ������� �� ���� �������� �� �����
        if not ObjZv[str_1].bP[4] and (str_2>0) and ObjZv[str_2].ObCB[7] then
        begin//------------------------- ����� ������ �� ������� "+" , � ����� ������� "+"
          oDZ := ObjZv[ObCI[9]].Sosed[2].Obj; p := ObjZv[ObCI[9]].Sosed[2].Pin;

          i := 100;
          while i > 0 do
          begin
            case ObjZv[oDZ].TypeObj of
              2 : //------------------------------------------------------ ����� = �������
              begin
                case p of
                  2: begin if ObjZv[oDZ].bP[2] then break;end;//�����, �������-����� � "-"
                  3: begin if ObjZv[oDZ].bP[1] then break;end;//�����, �������-����� � "+"
                  else ObjZv[str_1].bP[4] := true; break; //--------- ������ � ���� ������
                end;
                //------ �������� � ����� ������, � ������ ������,������������� � ����� 1
                p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj;
              end;

              //------------------------- �������,���� ���. ��������� �� ���� �������,����
              3,4 : begin ObjZv[str_1].bP[4]:= not ObjZv[oDZ].bP[2]; break; end;

              else //------------------------------- ��� ���� ������ �������� ������������
              if p = 1 then //------------- ��� ����� 1 ����� ��, ��� ���������� � ����� 2
              begin p := ObjZv[oDZ].Sosed[2].Pin; oDZ := ObjZv[oDZ].Sosed[2].Obj; end
              else//----------------------- ��� ����� 2 ����� ��, ��� ���������� � ����� 1
              begin p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj; end;
            end;
            if (oDZ = 0) or (p < 1) then break; //-----��� 0-������� ��� 0-����� ���������
            dec(i);
          end;
        end;

        //------ ���� ��� ���.���������, ���� ������� ������� � ���� ���� �������� �� "-"
        if not ObjZv[str_1].bP[4] and (str_2 > 0) and (ObjZv[str_2].ObCB[8]) then
        begin   //------------------------------ ����� �� �������? ����� ������ �� �������
          oDZ := ObjZv[ObCI[9]].Sosed[3].Obj; p := ObjZv[ObCI[9]].Sosed[3].Pin;
          i := 100;
          while i > 0 do
          begin
            case ObjZv[oDZ].TypeObj of
              2: //--------------------------------------------------------------- �������
              begin
                case p of
                  2:begin if ObjZv[oDZ].bP[2] then break;end;//���� �� "+",� ������� � "-"
                  3:begin if ObjZv[oDZ].bP[1] then break;end;//���� �� "-",� ������� � "+"
                  else ObjZv[str_1].bP[4] := true; break; //--------- ������ � ���� ������
                end;
                p := ObjZv[oDZ].Sosed[1].Pin; oDZ := ObjZv[oDZ].Sosed[1].Obj;
              end;

              3,4: begin ObjZv[str_1].bP[4]:= not ObjZv[oDZ].bP[2];break;end;//��,� �� ���

              else if p = 1 then
              begin p:= ObjZv[oDZ].Sosed[2].Pin; oDZ:= ObjZv[oDZ].Sosed[2].Obj; end
              else begin p:= ObjZv[oDZ].Sosed[1].Pin; oDZ:= ObjZv[oDZ].Sosed[1].Obj;end;
            end;
            if (oDZ = 0) or (p < 1) then break;
            dec(i);
          end;
        end;
      end;
{$IFDEF RMDSP}
      //-------------------------- �������� ������� ������������ -------------------------
      if ObCB[2] then //------------------------------------- ���� ������� � �������������
      begin
        if bP[3] then //--------------------------------------- ���� ���� ���������� �� ��
        begin
          bP[3] := false; //------------------------------------------ �������� ����������
          //------------------------------------- ����������� ����������� ��� ������� ����
          if StartRM then begin ObjZv[str_1].T[1].Activ := false; end else
          //-------------------- ��� �����, ���� �����, ���� ����������, ���� ��, ���� ���
          if not bP[1] and bP[2] and WorkMode.Upravlenie and WorkMode.OU[grp] then
          begin //-------------------- ��������� ������� ����������� �������� ������������
            //-------------------- ������������ ������� ������������ � ������ �������� � +
            bP[12] := true; ObjZv[str_1].T[1].Activ  := true;
            //--------------- � �� ������� ������ ������������, ���������� ����� � �������
//            if ObjZv[sp_1].T[2].F > 0 then ObjZv[str_1].T[1] := ObjZv[sp_1].T[2];
          end;
        end else //���� ��� ���������� ��� ��� ���������,��������� ������������ ������� ��
        if bP[12] and not bP[1] and bP[2] and //------------ ������� �� � ��� �� � ���� ��
        not ObjZv[str_1].bP[4] and not bP[8] and //��� ���.���. � �� ������� �������� � ��
        not bP[14] and not bP[18] and // ������� �� � ������, �� ��������� �� ���������� �
        not bP[19] and bP[13] and //-- ������� �� �� ������,���������� �������� ��� ��� ��
        bP[20] and bP[21] and bP[22] and //------- ��� ���� � ��� ��������� � ��������� ��
        not bP[23] and not bP[9] and not bP[10] and not bP[24]//�� ���.������,��� ��,��,��
        then
        begin
          if ObjZv[ObCI[10]].bP[3] then //-------------------- ���� ��� ���������� �������
          begin //--- ���� ������ ������� ��������� ����� - ����� ����������� ������������
            bP[12]:= false;
            ObjZv[str_1].T[1].Activ:= false;
            ObjZv[sp_1].T[2].Activ:= false;
          end else
          begin //--------------------------------------- �������� ������� ��������� �����
            d := not bP[19]; //----------------------------------------------------- �����
            if d then d := not bP[15]; //- ���� ����� �� ���������� � ���, ����� ����� FR4

            if d then d := not ObjZv[ObCI[8]].bP[18]; //------- ���������� �� �������
            // ���� ��� �������� ��� ������� //---- �� 1-�� ��� ����� �
            if d then
            d := not ObjZv[str_1].bP[10] and not ObjZv[str_1].bP[12] and not ObjZv[str_1].bP[13];

          if str_2 > 0 then //--------------------------------------- ���� ������� �������
          begin
            if d then //-------------------------------------- ���� �� ���� ����� ��������
            d := not ObjZv[str_2].bP[18]; //----- ��� ���������� ���-��

            if d then //------------------------------------------------ ���� ��� ��������
            d := not ObjZv[str_2].bP[10] and not ObjZv[str_2].bP[12] and not ObjZv[str_2].bP[13];
          end;
          
          if d and //------------------------------------- ���� ��� �������� ��� ������� �
          ObjZv[str_1].T[1].Activ and (T[1].F < LastTime) then   //---------- ������ �����
          begin
            //------------ ���� ��� ���������� ������ ��� �������� � �� ������ ������ �� �
            if (CmdCnt = 0) and not WorkMode.OtvKom and not WorkMode.VspStr and
            not WorkMode.GoMaketSt and  WorkMode.Upravlenie and //���������� �� ���� ��� �
            not WorkMode.LockCmd and not WorkMode.CmdReady and WorkMode.OU[grp] then
            begin // ���� ������� ����������� ������������ � ��� ��������� ������ � ������
              bP[12] := false; ObjZv[str_1].T[1].Activ := false; //---- ����� ������������
              //---------------------------- ������� ������� ������������ ������� � ������
              if  SendCommandToSrv(ObCI[2] div 8, _strautorun,Xstr)
              then AddFixMes(GetSmsg(1,418, Liter,7),5,5);//"������ ������� �������� ������� � �������� ���������"

            end;
          end;
        end;
      end;
    end else //------------------------------ ���� ��� ������� �� ������������ �����������
    begin //--------------------------------- �� ����������� ���������� ���������� ������,
          //--------------------------------------- ���� ��� �������� ������������ �������
      bP[3] := false;
      bP[12] := false;
      ObjZv[str_1].T[1].Activ  := false;
    end;
{$ENDIF}
  end else
  begin //------------------------------------ �������� �������� ��� ���������� ����������
    bP[1] := false;
    bP[2] := false;
    bP[3] := false;
{$IFDEF RMSHN}
    bP[19] := false;
{$ENDIF}
  end;

  {FR4}

  bP[18] := GetFR4State(ObCI[1]-5);//--------------------------- ��������� ����������
  bP[15] := GetFR4State(ObCI[1]-4);//------------------------------------------ �����
  bP[16] := GetFR4State(ObCI[1]-3);//--------------------------- ������� ����.�������
  bP[17] := GetFR4State(ObCI[1]-2);//--------------------------- ������� ����.�������
  bP[33] := GetFR4State(ObCI[1]-1); //---------------------------- ������� �� �������
  bP[34] := GetFR4State(ObCI[1]); //------------------------------ ������� �� �������
  end;
end;

//========================================================================================
//------------------- ���������� ������� ������� � �������� �������� ��� ������ �� ����� 2
procedure PrepOxranStrelka(StrOh : Integer);
var
  s1,s2,VBuf,Xstr : Integer;
begin
  with ObjZv[StrOh] do
  begin
    VBuf := VBufInd;   Xstr := BasOb;
    //---------------------------- 1�� ��� 2�� ������ ����������� ��� ���������� (+ ��� -)
    if bP[10] or bP[11] or bP[12] or bP[13] then
    begin
      OVBuffer[VBuf].Param[6] := false; //--------------------- ���������� �� ������ �����
      OVBuffer[VBuf].Param[5] := false; //------------------------- ������� �������� �����
      exit;
    end else
    begin
      if ObjZv[StrOh].bP[5] = false then //--------- ���� ��� ���������� �������� ��������
      begin
        s1 := ObjZv[Xstr].ObCI[8]; //-------------- �������� ������ 1-�� ������� (�������)
        s2 := ObjZv[Xstr].ObCI[9]; //-------------- �������� ������ 2-�� ������� (�������)

        if (s2 > 0) and (s2 <> StrOh) then  //----- ���� ���� ������� ������� � ��� ������
        begin
          //------------------------------ 1� ��� 2� ������ ��� ���������� (�� + ��� �� -)
          if(ObjZv[s2].bP[10] or ObjZv[s2].bP[11] or ObjZv[s2].bP[12] or ObjZv[s2].bP[13])
          then  OVBuffer[VBuf].Param[6] := true //-------- ���������� �� ������ ����������
          else OVBuffer[VBuf].Param[6] := false; //------ ����� ���������� �� ������ �����
        end else
        if (s1 > 0) and (s1 <> StrOh) then  //-- ���� ���� ������� ������� � ��� ������
        begin
          if(ObjZv[s1].bP[10] or ObjZv[s1].bP[11] or ObjZv[s1].bP[12] or ObjZv[s1].bP[13])
          then OVBuffer[VBuf].Param[6] := true
          else OVBuffer[VBuf].Param[6] := false;
        end
        else  OVBuffer[VBuf].Param[6] := false; //------- ����� ���������� �� ������ �����
      end
      else  OVBuffer[VBuf].Param[6] := true;
    end;
  end;
  //------------------- ��������� �������� �������� �������, �� �������� � ������ ��������
  //--------------------------------------------------- ���� ����������� ��������� �������
  if ObjZv[Xstr].bP[14] then OVBuffer[VBuf].Param[5]:= false //- ����� ���������� ��������
  else OVBuffer[VBuf].Param[5]:=ObjZv[Xstr].bP[8];//-------------- ����.�������� �� ������
end;

//========================================================================================
//---------------------- ���������� ������� "������� ����� �������" ��� ������ �� ����� #2
procedure PrepStrelka(Str : Integer);
var
  i, ohr, ob, p, DZ, SPohr, SPstr, VBuf, Xstr, rzs, Maket_str, Mag_str, grp  : integer;
  text : string;
begin
  with ObjZv[Str] do
  begin
    Dz := 0;
    VBuf      :=  VBufInd;
    Xstr      :=  BasOb;  //------------------------------------------------ ����� �������
    SPstr     :=  UpdOb; //---------------------------------------------------- �� �������
    Mag_str   :=  ObjZv[Xstr].ObCI[11]; //------------------------------ ���������� ������
    Maket_str :=  ObjZv[Mag_str].BasOb; //---------------------------------- ����� �������
    grp       :=  Group;

    OVBuffer[VBuf].Param[16] := ObjZv[Xstr].bP[31]; //------------------------- ����������
    OVBuffer[VBuf].Param[1] := ObjZv[Xstr].bP[32];//------------------------- ������������

    //---------------------------------------------------------------- ��,  ��, �� �������
    bP[1] := ObjZv[Xstr].bP[1]; bP[2] := ObjZv[Xstr].bP[2]; rzs := ObjZv[Xstr].ObCI[12];

    bP[4] := false; //-------------------------------------- ������� ��� ���.��������� ���

    if ObjZv[Xstr].bP[8] then  bP[4] := ObjZv[Xstr].bP[8];//------------- ��������� ������
    bP[4] := bP[4] or bP[33] or bP[25]; //---------------------------------------- ���/���

    //--------------------------------------- ���� ���� ��� ��� �����-���������� �� ������
    if ObjZv[rzs].bP[1] or bP[33] or bP[25] then  OVBuffer[VBuf].Param[7] := true
    else //--------------------------------------- �����, ���� o����� �� ������� ���������
    if ObjZv[SPstr].bP[2] then OVBuffer[VBuf].Param[7] := bP[4] //�������������� ���������
    else OVBuffer[VBuf].Param[7] := false; //---- ����� �� ���������� �����. �����.�������

    if not ObjZv[Xstr].bP[31] or ObjZv[Xstr].bP[32] then // ��������������� ��� ��� ������
    begin  //---------------------------------------- ��������  ��������������� �� �������
      OVBuffer[VBuf].Param[2] := false; OVBuffer[VBuf].Param[3] := false; //-- ��� �� � ��
      OVBuffer[VBuf].Param[8] := false; //----------------- ��� ���������� � �������������
      OVBuffer[VBuf].Param[9] := false; //----------------- ��� ���������� � �������������
      OVBuffer[VBuf].Param[10] := false;//----------------- ��� ���������� � �������������
      OVBuffer[VBuf].Param[12] := false;//---------------------------- ��� �������� ���(�)
    end else
    begin

      bP[9] := ObjZv[XStr].bP[9]; //-------- ������� ���������� �������� �� ������ �������

      if not WorkMode.Upravlenie then
      begin
        ObjZv[XStr].T[3].Activ:= false; ObjZv[XStr].T[3].F:= 0; //------------------ �����
      end;

      //========================= � � � � � �  �  � � � � � � �  =========================
      if ({$IFDEF RMDSP}(XStr = maket_strelki_index) or {$ENDIF} // ��� ��� ���� �� ������
      ObjZv[XStr].bP[24]) and not WorkMode.Podsvet then //---- ��� ���� �� � ��� ���������
      begin //- ������� ����� ������� ��� ������� ���������� - �� �������� ������� �������
        if not WorkMode.Upravlenie or (ObjZv[XStr].T[3].F <> 0) then
        begin //---------------- ���� �� ����������� ��� ��� ���� ������ ������ ��� ������
          if not WorkMode.Upravlenie or (LastTime > ObjZv[XStr].T[3].F) then
          begin //---------------------- ���� �� ����������� ��� ��� ������ ���� ���������
            if not WorkMode.Upravlenie or (ObjZv[XStr].iP[5] = _strmakplus) then
            begin //------------------ ���� �� ����������� ��� ��� ���������� ����� � ����
              if not ObjZv[Maket_str].bP[4] and ObjZv[Maket_str].bP[3] and //- ��� ��� ���
              (not ObjZv[XStr].bP[2] and ObjZv[XStr].bP[1]) then //------------- �� ��� ��
              begin
                //---------------------------- ������� �� ������ � ����� - �������� ������
                ObjZv[XStr].T[3].Activ := false;  ObjZv[XStr].T[3].F := 0;
                ObjZv[XStr].bP[4] := ObjZv[XStr].bP[5]; //���� ��������� ������ ����������
              end else
              begin
                if ObjZv[XStr].T[3].Activ then  //------------ �������� ������� �� � �����
                begin
                  InsNewMsg(XStr,577+$2000,0,'');//----- ������ �������� ������� �� ������
                  AddFixMes(GetSmsg(1,577,ObjZv[XStr].Liter,0),4,4);
                  ObjZv[XStr].T[3].Activ := false;
                end;
              end;
            end;

            if not WorkMode.Upravlenie or (ObjZv[XStr].iP[5] = _strmakminus) then
            begin //--------------------------------------------------- ���������� � �����
              if ObjZv[Maket_str].bP[4] and not ObjZv[Maket_str].bP[3] and //- ��� ��� ���
              (ObjZv[XStr].bP[2] and not ObjZv[XStr].bP[1]) then //------------- �� ��� ��
              begin //----------------------- ������� �� ������ � ������ - �������� ������
                ObjZv[XStr].T[3].Activ := false; ObjZv[XStr].T[3].F := 0;
                ObjZv[XStr].bP[4] := ObjZv[XStr].bP[5]; //���� ��������� ������ ����������
              end else
              begin
                if ObjZv[XStr].T[3].Activ then
                begin
                  InsNewMsg(XStr,577+$2000,0,'');//- ������ ��� �������� ������� �� ������
                  AddFixMes(GetSmsg(1,577,ObjZv[XStr].Liter,0),4,4);
                  ObjZv[XStr].T[3].Activ := false;
                end;
              end;
            end;
          end;
        end;

        //--------------- ������ - ���� ����������� ���  �� ���� ������ ������� ��� ������
        if ObjZv[Maket_str].bP[2] then //------------------------ ���� ���� ������ �������
        begin
          if WorkMode.Upravlenie and (ObjZv[XStr].bP[4] <> ObjZv[XStr].bP[5]) then
          begin //-------------------- ���� ��� �������� � ������� ��� ������ �� ���������
            OVBuffer[VBuf].Param[2] := false; //----------------------------------- ��� ��
            OVBuffer[VBuf].Param[3] := false; //----------------------------------- ��� ��
          end else  //-------------------------- ���� ������� ���������  ��� ��������� ���
          begin
            //------------------------------------------------------------------  �� & M��
            OVBuffer[VBuf].Param[2] := ObjZv[XStr].bP[1] and ObjZv[Maket_str].bP[3];

            //------------------------------------------------------------------  �� & M��
            OVBuffer[VBuf].Param[3] :=  ObjZv[XStr].bP[2] and ObjZv[Maket_str].bP[4];

            if ObjZv[XStr].bP[1] and ObjZv[Maket_str].bP[3] then
            begin
              ObjZv[XStr].iP[4] := _strmakplus;
              ObjZv[XStr].iP[5] := _strmakplus;
            end;

            if ObjZv[XStr].bP[2] and ObjZv[Maket_str].bP[4] then
            begin
              ObjZv[XStr].iP[4] := _strmakminus;
              ObjZv[XStr].iP[5] := _strmakminus;
            end;
          end;

          if WorkMode.Upravlenie then
          begin
            //------------------------------------ ���� ������� "�����" ��� �� ���� ������
            if (ObjZv[XStr].iP[4] = _strmakminus) or (ObjZv[XStr].iP[4] = 0) then
            begin
              //---- ���� ��� ��� ��� ���� ��� ��� ��� �� ��� ���� �� = ���-�� �� � ������
              if not ObjZv[Maket_str].bP[4] or  ObjZv[Maket_str].bP[3] or
              not ObjZv[XStr].bP[2]  or ObjZv[XStr].bP[1] then
              begin
                OVBuffer[VBuf].Param[2] := false; //--------------- ����� �� � �����������
                OVBuffer[VBuf].Param[3] := false;//---------------- ����� �� � �����������

                if not ObjZv[XStr].bP[27] then    //---------- �� ���� ����������� �������
                begin
                  InsNewMsg(XStr,271+$1000,0,'');//----------- "������� �������� ��������"
                  AddFixMes(GetSmsg(1,271,ObjZv[XStr].Liter,0),4,3);
                  ObjZv[XStr].bP[27] := true;  //------------- ���������� ������� ��������
                end;
              end;
            end else

            //----------------------------------- ���� ���� ������� "+" ��� �� ���� ������
            if (ObjZv[XStr].iP[4] =  _strmakplus) or (ObjZv[XStr].iP[4] = 0) then
            begin
              //-------------- ���� ��� ��� ��� ��� ���  �� ��� ��� �� = ���-�� �� � �����
              if ObjZv[Maket_str].bP[4] or not ObjZv[Maket_str].bP[3] or
              ObjZv[XStr].bP[2]  or not ObjZv[XStr].bP[1]  then
              begin
                OVBuffer[VBuf].Param[2] := false; //----------------------------- ����� ��
                OVBuffer[VBuf].Param[3] := false;//------------------------------ ����� ��
                if not ObjZv[XStr].bP[27] then  //------------------- ��� �������� �������
                begin
                  InsNewMsg(XStr,271+$1000,0,'');//----- "������� <Ptr> �������� ��������"
                  AddFixMes(GetSmsg(1,271,ObjZv[XStr].Liter,0),4,3);
                  ObjZv[XStr].bP[27] := true;
                end;
              end;
            end;
          end;
        end;

        if OVBuffer[VBuf].Param[2] <> OVBuffer[VBuf].Param[3] then
        ObjZv[XStr].bP[27] := false; //---------- �������� ������������, �������� ��������
      end else //------------------------------------------------------------ �� �� ������
      begin
        if bP[1] then // ----------------------------------------- ���� ���� ��
        begin
          if bP[2] then //-------------------------------- ������������ ���� ��
          begin
            //--------------------------------------------- ��� ������ ����� �� � ����� ��
            OVBuffer[VBuf].Param[2] := false; OVBuffer[VBuf].Param[3] := false;
          end else
          begin //----------------------------------------------------------------- ��� ��
            //--------------- ���������� ������� ���������� �������� � ����� � �� � ������
            bP[20] := true;  bP[21] := false;

            bP[22] := false; bP[23] := false;

            //----------------------------------------------------- ��� ������ �� � ��� ��
            OVBuffer[VBuf].Param[2] := true; OVBuffer[VBuf].Param[3] := false;
          end;
        end else
        if bP[2] then //-------------------------------------------- ���� �����
        begin
          //------------------------------ ���������� ������� ���������� �������� � ������
          bP[20] := false;   bP[21] := true;

          bP[22] := false;  bP[23] := false;

          //--------------------------------------------------- ��� ������ ��� ��, ���� ��
          OVBuffer[VBuf].Param[2] := false; OVBuffer[VBuf].Param[3] := true;
        end else
        begin
          //------------------------------------- ��� ������ ��� ��, ��� �� = ��� ��������
          OVBuffer[VBuf].Param[2] := false;  OVBuffer[VBuf].Param[3] := false;
        end;
      end;

      //---------------------------------------------------- ������� �������� ������� ����
      OVBuffer[VBuf].Param[12] :=  ObCB[9] and  //- ��������� ���(�) � ...
      not ObjZv[SPstr].bP[4] and ObjZv[SPstr].bP[1] and ObjZv[SPstr].bP[2];//-- ����,� � �

      //--------------------------------------------------------------- ������� �� �������
      bP[3] :=  ObjZv[SPstr].bP[5]; //-------------------------- �� �� ������

      //------------------------------------------------- ��������� ���������� ��� �������
      for i := 1 to 10 do
      if ObCI[i] > 0 then //--------------------------------------- ���� ���� ��������� ��
      begin
        ohr := 0;
        Dz := ObCI[i];
        case ObjZv[Dz].TypeObj of
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          27 :
          begin //--------------------------------------------- �������� ��������� �������
            SPohr := ObjZv[DZ].ObCI[2];//---------- ������ �� ��� ��������� ���������
            if ObjZv[DZ].ObCB[1] then //------- ���� ����������� ��� �������  � �����
            begin
              if bP[1] then //-------------------- ���� ������� ������� � �����
              begin
                ohr := ObjZv[DZ].ObCI[3]; //------------------------ �������� �������
                if ohr > 0 then
                begin
                  if ObjZv[DZ].ObCB[3] then //------- ���� �������� ������ ���� � "+"
                  begin
                    if ObjZv[ohr].bP[1] = false then //---------- ���� �������� �� � �����
                    begin ObjZv[ohr].bP[3] := false; break; end //---- �������� � ��������
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2];
                  end else
                  if ObjZv[DZ].ObCB[4] then //------------- ���� ���������� �� ������
                  begin
                    if ObjZv[ohr].bP[2] = false then //------------------ ���� �� � ������
                    begin bP[3] := false; break; end
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2]; //-- ���������� ���������
                  end;
                end;
              end;
            end else
            if ObjZv[DZ].ObCB[2] then //---------- ���� ������� ������ ���� �� ������
            begin
              if bP[2] then //--------------------------- ���� ������� � ������
              begin
                ohr := ObjZv[Dz].ObCI[3]; //------------------------ �������� �������
                if ohr > 0 then
                begin
                  if ObjZv[DZ].ObCB[3] then//------ ���� �������� ������ ���� � �����
                  begin
                    if ObjZv[ohr].bP[1] = false then //---------------- ������� �� � �����
                    begin bP[3] := false; break; end
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2]; //------- ���������� ����
                  end else //------------------------ ���� �������� ������ ���� �� � �����
                  if ObjZv[DZ].ObCB[4] then //---- ���� �������� ������ ���� � ������
                  begin
                    if ObjZv[ohr].bP[2] = false then //------ �������� ������� �� � ������
                    begin bP[3] := false; break; end
                    else ObjZv[ohr].bP[3] := ObjZv[SPohr].bP[2]; //-- ���������� ���������
                  end;
                end;
              end;
            end;

            if ohr > 0 then
            begin
              ObjZv[ohr].bP[4] := //-------------------- ��������� �������� ������� �� ...
              ObjZv[ohr].bP[4] or //-------------- ����������� ��������� ��������� ��� ...
              (not ObjZv[SPohr].bP[2]) or //------------------------- ������������� �� ���
              ObjZv[ohr].bP[33] or //------------------------ ������� ������������ ��� ...
              ObjZv[ohr].bP[25]; //-------------------------------- ��������� ������������

              OVBuffer[ObjZv[ohr].VBufInd].Param[7] := ObjZv[ohr].bP[4];
              OVBuffer[ObjZv[ohr].VBufInd].Param[6] := ObjZv[ohr].bP[14];
            end;
          end; //---------------------------------------------------------------- ����� 27

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          6 : //---------------------------------------------------------- ���������� ����
          begin
            for p := 14 to 17 do   //------------------------- ������ �� �������� ��������
            begin
              if ObjZv[Dz].ObCI[p] = Str then  //-------- ���� ������� ������ �������
              begin
                if ObjZv[Dz].bP[2] then  //---------------------- ���� �������� ����������
                begin
                  if bP[1] then    //--------------------- ���� ������� � �����
                  begin
                    if not ObjZv[Dz].ObCB[p*2-27] then //-- ���� �������� �� ��������
                    begin  bP[3] := false; break; end;  //------------ ����� ��
                  end else
                  if bP[2] then //----------------------- ���� ������� � ������
                  begin
                    if not ObjZv[Dz].ObCB[p*2-26] then //----- ���� �������� �� �����
                    begin bP[3] := false; break;  end; //------------- ����� ��
                  end;
                end;
              end;
            end;
          end; //6
        end; //case
      end; //for

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ob := 0;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ �������� ��������������
      if bP[3] then  //------------------------------------------------ ���� ��
      begin
        //---------------- ������ �������������� ����� ���� � ���������� ��������� �������
        if bP[1] then    //------------------------------- ���� ������� � �����
        begin
          if (Sosed[3].TypeJmp = LnkNeg) or //---------- ���� ������������ ����
          (ObCB[8]) then//-------------- ��� �������� ����� ���� �� ������
          begin
            ob := Sosed[3].Obj; p := Sosed[3].Pin;
            i := 100;

            while i > 0 do
            begin
              case ObjZv[ob].TypeObj of  //------------ �������� �� ���� ������ �� �������
                2 :   //---------------------------------------------------------- �������
                begin
                  case p of
                    2 ://------------------------------------ ���� �� �������� ����� ����,
                    begin if ObjZv[ob].bP[2] then break; end;//-------- � ������� � ������

                    3 ://------------------------------------ ���� �� �������� ����� �����
                    begin if ObjZv[ob].bP[1] then break; end; //-------- � ������� � �����

                    else bP[3] := false; break; //------ ������ � ���� ������
                  end;
                  p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;//-- ����� 1
                end;

                3,4 : //----------------------------------------------------- �������,����
                begin
                  if Sosed[3].TypeJmp = LnkNeg then
                  bP[3] := ObjZv[ob].bP[1]//-------- ��������� �������� �������
                  else  bP[3] := false;
                  break;
                end;

                else  //--------------------------------------------------- ������ �������
                  if p = 1 then
                  begin p:= ObjZv[ob].Sosed[2].Pin;ob := ObjZv[ob].Sosed[2].Obj;end else
                  begin p:= ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
              end;

              if (ob = 0) or (p < 1) then break;
              dec(i);
            end;
          end;
        end else
        if bP[2] then //------------------------------------------ ���� ���� ��
        begin
          if (Sosed[2].TypeJmp = LnkNeg) or //--------------- ������������ ����
          (ObCB[7]) then //----- ��� �������� ���������� ��������� �������
          begin //------------------------------------------------ �� ��������� ����������
            ob:= Sosed[2].Obj; p:= Sosed[2].Pin; i:= 100;
            while i > 0 do
            begin
              case ObjZv[ob].TypeObj of
                2 : //------------------------------------------------------------ �������
                begin
                  case p of
                    2 :  //------------------------------------------------- ���� �� �����
                    begin if ObjZv[ob].bP[2] then break; end;// ������� � ������ �� ������

                    3 :   //----------------------------------------------- ���� �� ������
                    begin if ObjZv[ob].bP[1] then break; end;//- ������� � ������ �� �����

                    else  bP[3] := false; break; //------- ������ � ���� ������
                  end;
                  p := ObjZv[ob].Sosed[1].Pin;  ob := ObjZv[ob].Sosed[1].Obj;
                end;

                3,4 : //----------------------------------------------------- �������,����
                begin
                  if Sosed[2].TypeJmp = LnkNeg then
                  bP[3]:=ObjZv[ob].bP[1]//---------- ��������� �������� �������
                  else  bP[3] := false;
                  break;
                end;

                else
                  if p = 1 then
                  begin p:= ObjZv[ob].Sosed[2].Pin; ob:=ObjZv[ob].Sosed[2].Obj; end else
                  begin p:= ObjZv[ob].Sosed[1].Pin; ob:=ObjZv[ob].Sosed[1].Obj; end;
              end;

              if (ob = 0) or (p < 1) then break;
              dec(i);
            end;
          end;
        end;
      end;

      //++++++++++++++++++++++++++++++++++++++++ �������� ��������� ��������� ������������
      if ObjZv[XStr].ObCB[1] then //------------------------------------- ���� ������� ���
      begin
        if bP[1] and not bP[2] then //---------------------------------------- ������� � +
        begin
          bP[19] := false; //-------------------------- ����� ������� ���������� ���������
          T[1].Activ := false; //---------------------- ����� ����.������� ������� �� � ��
          OVBuffer[VBuf].Param[8] := true; //--------------------------------- ��� � �����
          OVBuffer[VBuf].Param[9] := false; //-------------------------------- �� �� �����
          OVBuffer[VBuf].Param[10] := false; //------------------------------- ��� � �����
        end else
        begin
          if not ObjZv[XStr].bP[21] then //------------------------ �� �������� � ��������
          begin
            bP[19] := false;//------------------------- ����� ������� ���������� ���������
            T[1].Activ  := false; //------------------ ����� ����� ������� ������� �� � ��
            OVBuffer[VBuf].Param[8] := false; //---------------------------- ��� ���������
            OVBuffer[VBuf].Param[9] := false; //------------------------- ������ ���������
            OVBuffer[VBuf].Param[10] := false;
          end else
          if not ObjZv[XStr].bP[20] or not ObjZv[XStr].bP[22] then //-- ���� ��� ���������
          begin
            bP[19] := false;//------------------------- ����� ������� ���������� ���������
            T[1].Activ  := false; //--------------------- ����� �������� ����.������ �� ��
            OVBuffer[VBuf].Param[8] := false;
            OVBuffer[VBuf].Param[9] := false;
            OVBuffer[VBuf].Param[10] := true;
          end else
          begin //---------------------------------------- �������� �� ��������� ���������
            if not bP[1] and bP[2] then
            begin
              if T[1].Activ then
              begin //---- ������� ������� ���������� ��������� ��������� ���������� �����
                if LastTime >= T[1].F then
                begin
                  if (ObjZv[XStr].ObCI[8] = Str) and //--------- ������� ������ ��� ������
                  not bP[19] and not bP[18] and
                  not ObjZv[XStr].bP[18] and not ObjZv[XStr].bP[15] then//- ��������,�����
                  begin
{$IFDEF RMDSP}
                    if WorkMode.OU[0] and WorkMode.OU[grp] and
                    (RU = config.ru) then //---------------- ���������, ��� ���-����������
                    begin
                      InsNewMsg(XStr,477+$1000,1,'');
                      text := GetSmsg(1,477,ObjZv[XStr].Liter,7);
                      AddFixMes(text,4,3); //------------- ������� �� � �������� ���������
                      ShowSMsg(477,LastX,LastY,ObjZv[XStr].Liter);
                    end;
{$ELSE}
                    InsNewMsg(XStr,477+$1000,2,'');
{$ENDIF}
                  end;
                  T[1].Activ  := false;
                  bP[19] := true;
                end;
              end else
              begin //---------- ������������� ����� ������ ������� �� ��������� ���������
                T[1].Activ  := true;
                T[1].F := LastTime + ObjZv[SPstr].ObCI[15]/86400;
              end;
            end else //-------------------------------------- ��� �������� - ����� �������
            begin
              bP[19] := false;
              T[1].Activ  := false;
            end;

            if bP[19] and  not bP[18] and
            not ObjZv[XStr].bP[18] and not ObjZv[XStr].bP[15] and //------ ��������, �����
            WorkMode.Upravlenie then
            begin //--------------------------------------------------------------- ������
              OVBuffer[VBuf].Param[8] := false;
              OVBuffer[VBuf].Param[9] := tab_page;
              OVBuffer[VBuf].Param[10] := false;
            end else
            begin //------------------------------------------------------------ �� ������
              OVBuffer[VBuf].Param[8] := false;
              OVBuffer[VBuf].Param[9] := true;
              OVBuffer[VBuf].Param[10] := false;
            end;
          end;
        end;
      end;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ��������� ������� �������
      if ObjZv[XStr].ObCI[13] > 0 then  //--- ���������� ������ ���������� ��������
      begin
        if ObjZv[ObjZv[XStr].ObCI[13]].bP[1] then  OVBuffer[VBuf].Param[11] := true
        else  OVBuffer[VBuf].Param[11] := false;
      end;

      //--------- ���� ��������� �� ��� PM ��� �� , �� ����� ����������� ��������� �������
      if not ObjZv[SPstr].bP[2] or ObjZv[SPstr].bP[9] or not ObjZv[SPstr].bP[5] then
      begin
        bP[14] := false; //----------------------- ������ ����������� ���������
        bP[6] := false; //------------------------------------------- ������ ��
        bP[7] := false; //------------------------------------------- ������ ��
        bP[10] := false; //------------------------------ ������ ������ �������
        bP[11] := false; //------------------------------ ������ ������ �������
        bP[12] := false; //----------------------- ������ "����������� � �����"
        bP[13] := false; //---------------------- ������ "����������� � ������"
        SetPrgZamykFromXStrelka(Str); //-------- ����� ���������, ���� ��������� ���������
      end;

      OVBuffer[VBuf].Param[7] := OVBuffer[VBuf].Param[7] or bP[33]; //----- ���
      OVBuffer[VBuf].Param[7] := OVBuffer[VBuf].Param[7] or bP[25]; //----- ���


      if not WorkMode.Podsvet and //------------------------- ���� ��� ��������� ������� �
      (ObjZv[XStr].bP[4] <> ObjZv[XStr].bP[5]) and //----------------- ������� ������ � ..
      (ObjZv[XStr].bP[15] or  //------------------------ ���� ����� �� Fr4 ������� ��� ...
{$IFDEF RMSHN} ObjZv[XStr].bP[19] or {$ENDIF}//------------------ ����� �� ������� "�����"
      ObjZv[Xstr].bP[24]) then //--------------------------- ������� �� ������� ����������
      OVBuffer[VBuf].Param[4] := true //---------------------------- ��������� ���� ������
      else OVBuffer[VBuf].Param[4] := false; //---------------------- �������� ���� ������
    end;

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ FR4
    if ObCB[6] then //------------------ ���� ��������� � ��� ���� �������
    begin
      //-------------------------------- ��������  ��� �������� --------------------------
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[30] := bP[16]
        else  OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[17];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[17];
      //--------------------------------------------- ������ ��� ���������������� ��������
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[29] := bP[17]
        else OVBuffer[VBuf].Param[29] :=  ObjZv[Xstr].bP[34];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[29] :=  ObjZv[Xstr].bP[34];
    end else
    begin //-------------------------------------------------------- ��������� ��� �������
      //------------------------------------------------------------- ������� ��� ��������
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[30] := bP[16]
        else  OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[16];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[30] := ObjZv[Xstr].bP[16];
      //------------------------------------------- ������ ��� ���������������� ��������
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBuf].Param[29] := bP[17]
        else  OVBuffer[VBuf].Param[29] := ObjZv[Xstr].bP[33];
      end else
{$ENDIF}
      OVBuffer[VBuf].Param[29] := ObjZv[Xstr].bP[33];
    end;
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin //------------------------------------------------------------------------ �����
      if tab_page then OVBuffer[VBuf].Param[31] :=  ObjZv[Xstr].bP[19]
      else  OVBuffer[VBuf].Param[31] := ObjZv[Xstr].bP[15];
    end else
{$ENDIF}
    OVBuffer[VBuf].Param[31] := ObjZv[Xstr].bP[15];
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin //--------------------------------------------------------- ��������� ����������
      if tab_page then  OVBuffer[VBuf].Param[32] := bP[18]
      else OVBuffer[VBuf].Param[32] := ObjZv[Xstr].bP[18];
    end else
{$ENDIF}
    OVBuffer[VBuf].Param[32] := ObjZv[Xstr].bP[18];
  end;
end;

//========================================================================================
//--------------------------------------- ���������� ������� ������ ��� ������ �� ����� #3
procedure PrepSekciya(SP : Integer);
var
  p, mspd, msp, z, mi, ri : boolean;
  i, VBuf, MU, MK, StrA : integer;
  sost : byte;
begin
  with ObjZv[SP] do
  begin
    bP[31] := true; bP[32] := false;  //---------------------- �����������, ��������������
    VBuf := VBufInd;
    StrA := ObCI[10]; //------------------------------------------ ������� � �������������
    p  := not GetFR3(ObCI[2], bP[32],bP[31]);
    z  := not GetFR3(ObCI[3], bP[32],bP[31]);
    ri := GetFR3(ObCI[4], bP[32],bP[31]);

    if ObCI[5]  > 0 then mspd := not GetFR3(ObCI[5] , bP[32],bP[31]) else mspd := true;
    if ObCI[13] > 0 then msp  := not GetFR3(ObCI[13], bP[32],bP[31]) else msp  := true;
    if ObCI[6]  > 0 then mi   := not GetFR3(ObCI[6] , bP[32],bP[31]) else mi   := true;

    

    bP[6] := GetFR3(ObCI[7],bP[32],bP[31]);  //------------------------ ��������������� ��
    bP[7] := not GetFR3(ObCI[12],bP[32],bP[31]);//------ ��������������� ��������� �� STAN


    OVBuffer[VBuf].Param[16] := bP[31]; OVBuffer[VBuf].Param[1] := bP[32];

    if bP[31] and not bP[32] then
    begin
      //------------------------- ���� � ���� ���� ������ ���� � ������� �������� ��� ����
      if (ObCI[8] > 0) and(ObCI[9] > 0) then
      begin
        if p <> bP[1] then //----------------------------------------- ��������� ���������
        begin
          if p then //----------------------------------------------- ������������ �������
          begin
            if mspd then T[1].Activ  := false //----------------- ���� ����� �������� ����
            else //------------------------------------------- ���� �������� �������� ����
            if not T[1].Activ  then
            begin //------------------------------------------------ ������ ������ �������
              T[1].F :=LastTime; T[1].Activ := true;
            end;
          end else T[1].Activ  := false;//------------- ������� �����, ����� �������� ����
        end;


        if mspd <> bP[4] then //-------------------------------------- ���� ��������� ����
        begin
          if mspd then //--------------------------------- ��������� ���� = ����� ��������
          begin
{$IFDEF RMSHN}
            if T[1].Activ then dtP[3]:= LastTime - T[1].F;//- ��������� ����� ��������
{$ENDIF}
            T[1].Activ := false; //----------------------------------- ����� �������� ����
          end;
        end;
      end;
      bP[1] := p; bP[4] := mspd; //----------------- ���������,  ��������� �� ������ �����


      //-------------- ���� � ���� ���� ������ ��� � ������� �������� ��� ��� ������������
      if (ObCI[14] > 0) and(ObCI[15] > 0) then
      begin
        if p and z then //-------------------------------- ��������� ��������� � ���������
        begin
          if msp then T[2].Activ  := false //--------------------- ���� ����� �������� ���
          else //---------------------------------------------- ���� �������� �������� ���
          if not T[2].Activ  then
          begin //-------------------------------------------------- ������ ������ �������
            ObjZv[StrA].T[1].S := ObjZv[StrA].T[1].F;
            ObjZv[StrA].T[1].F := ObjZv[StrA].T[1].F + ObCI[15]/86400;
            T[2].F := LastTime; T[2].Activ := true;
          end;
        end
        else
        begin
          T[2].Activ  := false; //---------- ������� �����, ��� ������� ����� �������� ���
          ObjZv[StrA].T[1].Activ := false;
          ObjZv[StrA].T[1].F := 0;
        end;

        if msp <> bP[11] then //--------------------------------------- ���� ��������� ���
        begin
          if msp then //----------------------------------- ��������� ��� = ����� ��������
          begin
{$IFDEF RMSHN}
            if T[2].Activ then dtP[4]:= LastTime - T[2].F;//----- ��������� ����� ��������
{$ENDIF}
            T[2].Activ := false; //------------------------------------ ����� �������� ���
          end;
        end;
      end;
      bP[11] := msp;



      if ObCI[9] > 0 then //---------------------------------------- ���� ���� ������ ����
      begin
        if T[1].Activ  then Timer[ObCI[9]] := 1 + Round((LastTime - T[1].F) * 86400)
        else Timer[ObCI[9]] := 0;//----------------------------------------- ������ ������
      end;

      if ObCI[14] > 0 then //---------------------------------------- ���� ���� ������ ���
      begin
        if T[2].Activ  then Timer[ObCI[14]] := 1 + Round((LastTime - T[2].F) * 86400)
        else Timer[ObCI[14]] := 0;//---------------------------------------- ������ ������
      end;



      if bP[21] then //--------------- ��������� �������� ��������������� ���������� �� ��
      begin bP[20] := true;bP[21] := false; end // ��������� ����������, �������� ��������
      else bP[20] := false;//------------------ ��� �������� - �������� ������� ����������


      OVBuffer[VBuf].Param[18] :=  (config.ru = RU) and WorkMode.Upravlenie; // ����������

      if bP[2] <> z then //------------------------------------------ ���������� ���������
      begin
        bP[8]:= true; bP[14]:= false;//- ����� ��������������� � � ����������� �����������
        if z then //------------------------------------------------ ��� ���������� ������
        //------------------------- ����� ������� ���������, ������� ����, ����� 1�� � 2��
        begin
          ObjZv[StrA].T[1].F := ObjZv[StrA].T[1].F + ObCI[15]/86400;
          iP[2] := 0; iP[3] := 0; bP[15] := false; bP[16] := false;
        end;
      end;
      bP[2] := z;  //--------------------------------- ���������� ������� �������� ��� "�"

      if bP[5] <> mi then //------------------------------------------------ ���������� ��
      begin
        bP[8]:=true; bP[14]:=false; //----------------------- ����� ������ � ����.�����.
        if mi then begin bP[15]:=false;bP[16]:=false; end;//���������� �� �� ����� 1 � 2��
      end;
      bP[5] := mi;  //----------------------------------------------------------------- ��

      bP[9] := false; //----- �������� �������� �� ������� ����������, �������, ��� ��� ��

      for i := 20 to 24 do //------------------------------ ������ �� ��������� ������� ��
      if ObCI[i] > 0 then
      begin
        MU := ObCI[i]; //--------------------- �������� ��������� ����� �������� ���������
        case ObjZv[MU].TypeObj of
          25 : if not bP[9] then bP[9] := Get_ManK(MU); //------------- ���������� �������
          44 : begin MK:=ObjZv[MU].BasOb;if not bP[9] then bP[9]:= Get_ManK(MK); end;//���
        end;
      end;

      OVBuffer[VBuf].Param[2] := bP[9];  //------------------------------------ ������� ��
      OVBuffer[VBuf].Param[3] := bP[5];  //-------------------------------------------- ��
      OVBuffer[VBuf].Param[4] := bP[1];  //--------------------------------------------- �
      OVBuffer[VBuf].Param[5] := bP[2];  //--------------------------------------------- �

{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if not bP[14] then //---------------------- ��� ������� ������������ ��������� DSP
        begin
          if not bP[7] then //------------------ ���� ���� ����������� ��������� �� STAN
          //---------------------- �������� ������������ ��������� � ����������� ���������
          begin OVBuffer[VBuf].Param[6] := false; OVBuffer[VBuf].Param[14] := true; end
          else //-------- ��� ������������ �� STAN, ������� ���������� ������ ����� ������
          //--------------------- ����� ����������� ���������, �������� ����������� �� DSP
          begin OVBuffer[VBuf].Param[14] := false; OVBuffer[VBuf].Param[6] := bP[8]; end;
        end else //------------------------------------------- ���� ��� ����������� �� DSP
        begin
          if not bP[7] then //----------------------------------- ���� ����������� �� STAN
          //----------------------------- �������� ������ � �������� ����������� ���������
          begin OVBuffer[VBuf].Param[6] := false; OVBuffer[VBuf].Param[14] := true; end
          else //------------------------------------------------ ��� ������������ �� STAN
          begin //------------------------------------------------------ ����� �����������
            OVBuffer[VBuf].Param[14] := false;
            if tab_page then OVBuffer[VBuf].Param[6] := true //--------- ����� �����������
            else  OVBuffer[VBuf].Param[6] :=  bP[8]; //--------------- ����������� �� ����
          end;
        end;
      end else //----------- ��� ���������� �� ������� ���, ����� ��������� �� FR3 �� STAN
      begin {$ENDIF}
        OVBuffer[VBuf].Param[6] := bP[7]; OVBuffer[VBuf].Param[14] := not bP[7];
        {$IFDEF RMDSP}
      end;
        {$ENDIF}

      if bP[3] <> ri then  //-------------------------------------- ���������� �������� ��
      begin
        if ri and not StartRM then
        begin //-------------------------------------------- ��������� ����� ������ ��� ��
{$IFDEF RMDSP}
          if RU = config.ru then AddFixMes(GetSmsg(1,84,Liter,7),0,2);{$ENDIF}
          InsNewMsg(SP,84+$2000,7,''); //--------- ����������� ������������� ���������� ��
        end;
      end;
      bP[3] := ri;
      OVBuffer[VBuf].Param[7] := bP[3]; OVBuffer[VBuf].Param[9] := bP[6]; //-- �� � ������
      OVBuffer[VBuf].Param[8] := bP[4]; //------------------------------------------- ����

      sost := GetFR5(ObCI[1]); //--------------------------------------------- �����������
      if bP[5] and (iP[3] = 0) then //------------------------------- ��� �� � ��� �������
      begin
        if ((sost and 1) = 1) then //------------------- ��������� �o���� ��������� ������
        begin
          {$IFDEF RMSHN}  dtP[1] := LastTime; inc(siP[1]);{$ELSE}
          if RU = config.ru then AddFixMes(GetSmsg(1,394,Liter,0),4,1); {$ENDIF}
          InsNewMsg(SP,394+$1000,0,''); bP[19] := true;//----------- ������������� �������
        end;

        if ((sost and 2) = 2) and not bP[9] then //--- ��������� �o���� ����������� ������
        begin
          {$IFDEF RMSHN}  dtP[2] := LastTime; inc(siP[2]); {$ELSE}
          if RU = config.ru then  AddFixMes(GetSmsg(1,395,Liter,0),4,1); {$ENDIF}
          InsNewMsg(SP,395+$1000,0,'');//---------------------- ������������� ������������
          bP[19] := true;
        end;
      end;

      //---------------------------------------------------------------- ��������� �������
      if WorkMode.Podsvet and ObCB[6] then OVBuffer[VBuf].Param[10] := true
      else OVBuffer[VBuf].Param[10] := false;
    end else //---------------------------------- ������� � ������������� ��������� ������
    begin
      if ObCI[9] > 0 then Timer[ObCI[9]] := 0; //------------------------------------ ����
      if ObCI[14] > 0 then Timer[ObCI[14]] := 0; //----------------------------------- ���
      bP[21] := true; //------------------------ ���������� ������� ��������������� ������
    end;

    OVBuffer[VBuf].Param[13] := bP[19]; //------------------ �������� ������������� ������

    //-------------------------------------------------------------------------------- FR4
    bP[12] := GetFR4State(ObCI[1]*8+2); //------------------------- �������� �������� STAN
    {$IFDEF RMDSP}
    if WorkMode.Upravlenie and (RU = config.ru) then
    begin
      if tab_page then OVBuffer[VBuf].Param[32]:=bP[13] //---------- �������� �������� DSP
      else OVBuffer[VBuf].Param[32] := bP[12];      //------------- �������� �������� STAN
    end else
    {$ENDIF}
    OVBuffer[VBuf].Param[32] := bP[12]; //------------ ���� � STAN ��������, �� �� �������

    if ObCB[8] or ObCB[9] then
    begin //------------------------------------------------------------- ���� �����������
      bP[27] := GetFR4State(ObCI[1]*8+3);//-------------------------- �������� �� ��(STAN)

      {$IFDEF RMDSP}
      if WorkMode.Upravlenie and (RU = config.ru) then
      begin
        if tab_page then OVBuffer[VBuf].Param[29] := bP[24] //-------- �������� �� ��(DSP)
        else OVBuffer[VBuf].Param[29] := bP[27]; //------------------ �������� �� ��(STAN)
      end else
      {$ENDIF}

      OVBuffer[VBuf].Param[29] := bP[27];//----------- �� ������,���� �������� �� ��(STAN)

      if ObCB[8] and ObCB[9] then //------------------------------ ���� 2 ���� �����������
      begin
        bP[28] := GetFR4State(ObCI[1]*8); //------------------------- ������� ����.�(STAN)
        {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then  OVBuffer[VBuf].Param[30] := bP[25]
          else  OVBuffer[VBuf].Param[30] := bP[28];
        end else
        {$ENDIF}
        OVBuffer[VBuf].Param[30] := bP[28];

        bP[29] := GetFR4State(ObCI[1]*8+1);
        {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBuf].Param[29] := bP[26]
          else OVBuffer[VBuf].Param[29] := bP[29];
        end else
        {$ENDIF}
        OVBuffer[VBuf].Param[29] := bP[29];
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------- ���������� ������� ���� ��� ������ �� ����� #4
procedure PrepPuti(PUT : Integer);
var
  ni_, chi_, mic, min, Nepar, Activ : boolean;
  i, PutCH, PutN, Ni, CHi, CHkm, Nkm, MI_CH, MI_N, PrZC, PrZN, VidB, RMU : integer;
  sost,sost1,sost2 : Byte;
begin
  Nepar := false;  Activ := true;

  PutCH := ObjZv[PUT].ObCI[2];//- � ������� ���� ������ ��������� (��� �������� ����)
  CHi   := ObjZv[PUT].ObCI[3]; //--------------------------------------- � ������� ��
  CHkm  := ObjZv[PUT].ObCI[5]; //-------------------------------------- � ������� ���
  MI_CH := ObjZv[PUT].ObCI[6]; //------------------------------------ � ������� ��(�)
  PrZC  := ObjZv[PUT].ObCI[11]; //--- � ������� ���������������� ��������� � ��������

  PutN  := ObjZv[PUT].ObCI[9];//� ������� ���� �������� ��������� (��� �������� ����)
  Ni    := ObjZv[PUT].ObCI[4]; //--------------------------------------- � ������� ��
  Nkm   := ObjZv[PUT].ObCI[7]; //-------------------------------------- � ������� ���
  MI_N  := ObjZv[PUT].ObCI[8]; //------------------------------------ � ������� ��(�)
  PrZN  := ObjZv[PUT].ObCI[12]; //--- � ������� ���������������� ��������� � ��������

  VidB :=  ObjZv[PUT].VBufInd;

  //----------------------------------------- ��������� ���� � ������ � � �������� �������
  ObjZv[PUT].bP[1] := not GetFR3(PutCH,Nepar,Activ);//------------------------------- �(�)
  ObjZv[PUT].bP[16] := not GetFR3(PutN,Nepar,Activ);//------------------------------- �(�)

  ni_ :=  not GetFR3(Ni,Nepar,Activ);//------------------------------------------------ ��
  chi_ :=  not GetFR3(CHi,Nepar,Activ);//---------------------------------------------- ��

  ObjZv[PUT].bP[4] := GetFR3(CHkm,Nepar,Activ); //------------------------------------ ���

  if MI_CH > 0 then  mic := not GetFR3(MI_CH,Nepar,Activ)//- ���� ���� ������ ��,���������
  else mic := true; //-------------------------------------------------------- ����� ��(�)

  ObjZv[PUT].bP[15] := GetFR3(Nkm,Nepar,Activ); //------------------------------------ ���

  if MI_N > 0 then min := not GetFR3(MI_N,Nepar,Activ) //--------------------------- ��(�)
  else min := true;

  ObjZv[PUT].bP[7] := not GetFR3(PrZC,Nepar,Activ);//--------------------- - ���� ��� STAN
  ObjZv[PUT].bP[11] := not GetFR3(PrZN,Nepar,Activ); //----------- ����� ����� ��� �� STAN

  ObjZv[PUT].bP[31] := Activ; //---------------------------------------------- �����������
  ObjZv[PUT].bP[32] := Nepar; //------------------------------------------- ��������������

  if  VidB > 0 then
  begin
    OVBuffer[VidB].Param[16] := Activ; OVBuffer[VidB].Param[1] := Nepar;
    if Activ and not Nepar then
    begin
      OVBuffer[VidB].Param[18] := (config.ru = ObjZv[PUT].RU) and  WorkMode.Upravlenie;
      if ObjZv[PUT].bP[3] <> ni_ then //-------------------------------- ���� �� ���������
      begin
        if ObjZv[PUT].bP[3] then
        begin
          ObjZv[PUT].iP[2] := 0;
          ObjZv[PUT].bP[8] := true; //---------------------------------- ����� �����������
          ObjZv[PUT].bP[14] := false; //------------------ ����� ��������������� ���������
        end;
      end;
      ObjZv[PUT].bP[3] := ni_;  //----------------------------------------------------- ��

      if ObjZv[PUT].bP[2] <> chi_  then //------------------------------ ���� �� ���������
      begin
        if ObjZv[PUT].bP[2] then
        begin
          ObjZv[PUT].iP[3] := 0;
          ObjZv[PUT].bP[8] := true; //---------------------------------- ����� �����������
          ObjZv[PUT].bP[14] := false; //------------------ ����� ��������������� ���������
        end;
      end;
      ObjZv[PUT].bP[2] := chi_;  //---------------------------------------------------- ��

      if ObjZv[PUT].bP[5] <> mic then
      begin
        if ObjZv[PUT].bP[5] then
        begin
          ObjZv[PUT].bP[8] := true; //---------------------------------- ����� �����������
          ObjZv[PUT].bP[14] := false; //------------------ ����� ��������������� ���������
        end;
      end;
      ObjZv[PUT].bP[5] := mic;  //-------------------------------------------------- ��(�)

      if ObjZv[PUT].bP[6] <> min then
      begin
        if ObjZv[PUT].bP[6] then
        begin
          ObjZv[PUT].bP[8] := true; //---------------------------------- ����� �����������
          ObjZv[PUT].bP[14] := false; //------------------ ����� ��������������� ���������
        end;
      end;
      ObjZv[PUT].bP[6] := min;  //-------------------------------------------------- ��(�)

      //------------------------------------------ �������� �������� �� ������� ����������
      ObjZv[PUT].bP[9] := false;

      for i := 20 to 24 do //--------------------------- �������� �� ������� ��������� ���
      if ObjZv[PUT].ObCI[i] > 0 then
      begin
        RMU := ObjZv[PUT].ObCI[i];
        case ObjZv[RMU].TypeObj of //---------------------------------------- �� ���� ���
           //------------------------------------------------------ ���������� �������
          25 : if not ObjZv[PUT].bP[9] then ObjZv[PUT].bP[9] := Get_ManK(RMU); //------------------------------------------ ���� ��� ��
           //------------------------------------------- ��� - ���������� ���� �� ��������
          43 : if not ObjZv[PUT].bP[9] then ObjZv[PUT].bP[9]:= Get_ManK(ObjZv[RMU].BasOb);
        end;
      end;

        OVBuffer[VidB].Param[2] := ObjZv[PUT].bP[3]; //--------------------------- ��
        OVBuffer[VidB].Param[3] := ObjZv[PUT].bP[2]; //--------------------------- ��
{$IFDEF RMDSP}
        //------------------------------------------- �������� ��������� �� �������� �����
        OVBuffer[VidB].Param[4] := ObjZv[PUT].bP[1] and ObjZv[PUT].bP[16];
{$ELSE}
        if tab_page  then OVBuffer[VidB].Param[4]:=ObjZv[PUT].bP[1] //--- ��������� �
        else OVBuffer[VidB].Param[4] := ObjZv[PUT].bP[16]; //------------ ��������� �
{$ENDIF}
        OVBuffer[VidB].Param[5] := ObjZv[PUT].bP[4];   //------------------------ ���
        OVBuffer[VidB].Param[7] := ObjZv[PUT].bP[15];  //------------------------ ���
        OVBuffer[VidB].Param[9] := ObjZv[PUT].bP[9];   //------------------------- ��
        OVBuffer[VidB].Param[10] := ObjZv[PUT].bP[5]  and ObjZv[PUT].bP[6];// ��
{$IFDEF RMDSP}
        if WorkMode.Upravlenie then
        begin
          if not ObjZv[PUT].bP[14] then //--- ���� ��� ����������� ��������� � �� ���
          begin
            if not ObjZv[PUT].bP[7] or not ObjZv[PUT].bP[11] then //��, �� � FR3
            begin
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin //--------------------------------- ������� ���������� ������ ����� ������
              OVBuffer[VidB].Param[14] := false;
              OVBuffer[VidB].Param[6] := ObjZv[PUT].bP[8];
            end;
          end else
          begin
            if not ObjZv[PUT].bP[7] or not ObjZv[PUT].bP[11] then
            begin //--------------------------------------------------------------- �� FR3
              OVBuffer[VidB].Param[6] := false;
              OVBuffer[VidB].Param[14] := true;
            end else
            begin
              OVBuffer[VidB].Param[14] := false;
              if tab_page then  OVBuffer[VidB].Param[6] := true//
              else OVBuffer[VidB].Param[6] :=  ObjZv[PUT].bP[8]; //------- �� �������
            end;
          end;
        end else
        begin //------------------------------------------------------------------- �� FR3
{$ENDIF}
          OVBuffer[VidB].Param[6] := ObjZv[PUT].bP[7] and ObjZv[PUT].bP[11];
          OVBuffer[VidB].Param[14]:= not OVBuffer[VidB].Param[6];
{$IFDEF RMDSP}
        end;
{$ENDIF}

        sost1 := GetFR5(PutCH  div 8);

        if (PutN > 0) and (PutCH <> PutN) then sost2 := GetFR5(PutN div 8)//��������� ����
        else sost2 := 0;

        sost := sost1 or sost2;

        //�������� ������� ���������� ������� ����������� �� ������ ������������ �� 1 ���.
        ObjZv[PUT].T[1].Activ  := ObjZv[PUT].T[1].F < LastTime;

        if (sost > 0) and
        ((sost <> byte(ObjZv[PUT].bP[4])) or ObjZv[PUT].T[1].Activ ) then
        begin
          ObjZv[PUT].iP[4] := SmallInt(sost);
{$IFDEF RMSHN}
          //-------------------------------- ������������� ����� ���������� ����������� ��
          ObjZv[PUT].T[1].F := LastTime + 1 / 86400;
{$ELSE}
          //------------------------------- ������������� ����� ���������� ����������� ���
          ObjZv[PUT].T[1].F := LastTime + 2 / 86400;
{$ENDIF}
          if (sost and 4) = 4 then
          begin //---------------------------------------- ��������� ���������� ����� ����
{$IFDEF RMSHN}
              InsNewMsg(PUT,397+$1000,0,'');
//            SBeep[1] := true;
              ObjZv[PUT].bP[19] := true;
              ObjZv[PUT].dtP[3] := LastTime;
              inc(ObjZv[PUT].siP[3]);
{$ELSE}
              if ObjZv[PUT].RU = config.ru then
              begin
                InsNewMsg(PUT,397+$1000,0,'');
                AddFixMes(GetSmsg(1,397,ObjZv[PUT].Liter,0),4,1);
              end;
              //----------------------- ����������� ������������� ���� �������� ����������
              ObjZv[PUT].bP[19] := WorkMode.Upravlenie;
{$ENDIF}
            end;

            if (sost and 1) = 1 then
            begin //--------------------------------------- ��������� �o���� ��������� ����
{$IFDEF RMSHN}
              InsNewMsg(PUT,394+$1000,0,'');
              ObjZv[PUT].bP[19] := true;
              ObjZv[PUT].dtP[1] := LastTime;
              inc(ObjZv[PUT].siP[1]);
{$ELSE}
              if ObjZv[PUT].RU = config.ru then
              begin
                InsNewMsg(PUT,394+$1000,0,'');
                AddFixMes(GetSmsg(1,394,ObjZv[PUT].Liter,0),4,1);
              end;
              ObjZv[PUT].bP[19] := WorkMode.Upravlenie; // ����������� ��� ����������
{$ENDIF}
            end;
            if (sost and 2) = 2 then
            begin //------------------------------------ ��������� ������ ����������� ����
{$IFDEF RMSHN}
              InsNewMsg(PUT,395+$1000,0,'');
              ObjZv[PUT].dtP[2] := LastTime;
              inc(ObjZv[PUT].siP[2]);
{$ELSE}
              if ObjZv[PUT].RU = config.ru then
              begin
                InsNewMsg(PUT,395+$1000,0,'');
                AddFixMes(GetSmsg(1,395,ObjZv[PUT].Liter,0),4,1);
              end;
              ObjZv[PUT].bP[19] := WorkMode.Upravlenie; //- ����������� �������������
{$ENDIF}
            end;
          end;
        end;

        OVBuffer[VidB].Param[13] := ObjZv[PUT].bP[19];

        //---------------------------------------------------------------------------- FR4
        ObjZv[PUT].bP[12] := GetFR4State(PutCH div 8 * 8 + 2);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VidB].Param[32] := ObjZv[PUT].bP[13]
          else OVBuffer[VidB].Param[32] := ObjZv[PUT].bP[12];
        end else
{$ENDIF}
        OVBuffer[VidB].Param[32] := ObjZv[PUT].bP[12];

        if ObjZv[PUT].ObCB[8] or ObjZv[PUT].ObCB[9] then
        begin //--------------------------------------------------------- ���� �����������
          ObjZv[PUT].bP[27] := GetFR4State(PutCH div 8 * 8 + 3);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
          begin
            if tab_page then OVBuffer[VidB].Param[29] := ObjZv[PUT].bP[24]
            else OVBuffer[VidB].Param[29] := ObjZv[PUT].bP[27];
          end else
{$ENDIF}
          OVBuffer[VidB].Param[29] := ObjZv[PUT].bP[27];

          if ObjZv[PUT].ObCB[8] and ObjZv[PUT].ObCB[9] then
          begin //------------------------------------------------ ���� 2 ���� �����������
            ObjZv[PUT].bP[28] := GetFR4State(PutCH div 8 * 8);
{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
            begin
              if tab_page
              then OVBuffer[VidB].Param[31] := ObjZv[PUT].bP[25]
              else OVBuffer[VidB].Param[31] := ObjZv[PUT].bP[28];
            end else
{$ENDIF}
            OVBuffer[VidB].Param[31] := ObjZv[PUT].bP[28];
            ObjZv[PUT].bP[29] := GetFR4State(ObjZv[PUT].ObCI[1] div 8 * 8 + 1);

{$IFDEF RMDSP}
            if WorkMode.Upravlenie and (ObjZv[PUT].RU = config.ru) then
            begin
              if tab_page then OVBuffer[VidB].Param[30] := ObjZv[PUT].bP[26]
              else OVBuffer[VidB].Param[30] := ObjZv[PUT].bP[29];
            end else
{$ENDIF}
              OVBuffer[VidB].Param[30] := ObjZv[PUT].bP[29];
          end;
        end;
      end;
end;

//========================================================================================
//------------------------------------ ���������� ������� ��������� ��� ������ �� ����� #5
procedure PrepSvetofor(SVTF : Integer);
var
  i,j,VidBuf,SP,MU,MK : integer;
  n,o,zso,so,jso,vnp,kz,Nepar,Aktiv : boolean;
  sost : Byte;
begin
  SP := 0;
  MU := 0;
  MK := 0;

    ObjZv[SVTF].bP[31] := true; //-------------------------------------------- �����������
    ObjZv[SVTF].bP[32] := false; //---------------------------------------- ��������������

    ObjZv[SVTF].bP[1] :=  //------------------------------------------ ��1 (�� ����������)
    GetFR3(ObjZv[SVTF].ObCI[2],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[2] := //----------------------------------------------------------- ��2
    GetFR3(ObjZv[SVTF].ObCI[3],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[3] := //---------------------------------------------- �1 (�� ��������)
    GetFR3(ObjZv[SVTF].ObCI[4],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[4] := //------------------------------------------------------------ �2
    GetFR3(ObjZv[SVTF].ObCI[5],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    o :=   //--------------------------------------------------------------------- �������
    GetFR3(ObjZv[SVTF].ObCI[7],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[6] := //------------------------ ������� "���������� ������ ��" �� STAN
    GetFR3(ObjZv[SVTF].ObCI[12],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[8] := //--------------------------- ������� "�������� ������ �" �� STAN
    GetFR3(ObjZv[SVTF].ObCI[13],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    ObjZv[SVTF].bP[10] := // �� ------------------------------ ��������� ������� ���������
    GetFR3(ObjZv[SVTF].ObCI[8],ObjZv[SVTF].bP[32],ObjZv[SVTF].bP[31]);

    if ObjZv[SVTF].bP[4] and //-------------------------- ���� ������� �2 - �������� � ...
    (ObjZv[SVTF].BasOb = 0) then  //-------------------------- ��� ����������� ������
    begin
      ObjZv[SVTF].bP[9] := false; ObjZv[SVTF].bP[14] := false; //------- ����� �����������
    end;

    if ObjZv[SVTF].VBufInd > 0 then
    begin
      VidBuf := ObjZv[SVTF].VBufInd;

      OVBuffer[VidBuf].Param[16] := ObjZv[SVTF].bP[31];
      OVBuffer[VidBuf].Param[1] := ObjZv[SVTF].bP[32];

      if ObjZv[SVTF].bP[31] and not ObjZv[SVTF].bP[32] then //-------- ������� � ���������
      begin
        OVBuffer[VidBuf].Param[18] := (config.ru = ObjZv[SVTF].RU);//����� ���-��� �������

        //-------------------------------------------------------- ��������� �������� ����
        if o <> ObjZv[SVTF].bP[5] then //----------------- ������� ���� �������� ���������
        begin
          if o then //---------------------------------- ������������� ��������� ���������
          begin
            if ObjZv[SVTF].T[3].Activ = false then  //------------- ���� ������ �� �������
            begin
              ObjZv[SVTF].T[3].Activ := true; ObjZv[SVTF].T[3].F := LastTime;
            end else //------------------------------- ���� ������ ��� ����� �������������
            begin
              if (LastTime - ObjZv[SVTF].T[3].F) > 5/80000 then // ������ 5 ������
              begin
                if not ObjZv[SVTF].bP[2] and not ObjZv[SVTF].bP[4] then//------- �� ��2,�2
                begin
                  if WorkMode.FixedMsg then //------------- ���� ������ � ��������� ������
                  begin
{$IFDEF RMDSP}
                    if config.ru = ObjZv[SVTF].RU then //------- ���� ��� ����� ����������
                    begin
                      if ObjZv[SVTF].bP[10] then //------------- ���� ��� ������ ���������
                      begin
                        //-------------"������������� �������� ���� ��������� ��������� $"
                        InsNewMsg(SVTF,481+$1000,1,'');
                        AddFixMes(GetSmsg(1,481, ObjZv[SVTF].Liter,1),4,4);
                      end else
                      begin
                        InsNewMsg(SVTF,272+$1000,0,'');//------------ "���������� �������� $"
                        AddFixMes(GetSmsg(1,272, ObjZv[SVTF].Liter,0),4,4);
                      end;
                    end;
{$ELSE}
                    if ObjZv[SVTF].bP[10] then
                    InsNewMsg(SVTF,481+$1000,0,'') //------- "���������� ������ ���������"
                    else   InsNewMsg(SVTF,272+$1000,0,''); // ���������� ����������� �����
                    SBeep[4] := true;
                    ObjZv[SVTF].dtP[1] := LastTime; //------ ����� ��������� �������������
                    inc(ObjZv[SVTF].siP[1]); //------------- ��������� ���� ��������������
{$ENDIF}
                    ObjZv[SVTF].bP[5] := o;  //--------- �������� �������� �������� ���� �
                  end;   //------------------------------------------------ ����� ��������
                end;//-------------------------------------------- ����� ��������� �������

                ObjZv[SVTF].bP[20] := false; //------------ ����� ���������� �������������
                ObjZv[SVTF].T[3].Activ:= false;
                ObjZv[SVTF].T[3].F := 0; //--------------------------------- ����� �������

              end;//-------------------------------------------------- ����� ������� 5 ���
            end; //----------------------------------------------- ����� ������� ���������
          end else //---------------------------------------------- ����� ��������� = true
          begin  //----------------------------------------------------- ��������� � �����
            ObjZv[SVTF].T[3].Activ := false;  //---------------------------- ����� �������
            ObjZv[SVTF].T[3].F :=0;
            ObjZv[SVTF].bP[5] := o;  //----------------- �������� �������� �������� ���� �
          end;
        end;
        //---------------------------------------------------- ����� ������ � ������� ����

        if ObjZv[SVTF].bP[1] or ObjZv[SVTF].bP[3] or
        ObjZv[SVTF].bP[2] or ObjZv[SVTF].bP[4]  then //------- ������ ��� �������� �������
        begin

          if MarhTrac.SvetBrdr = SVTF then //-------- ������ ������ �������� � ������
          begin
            for j := 1 to 10 do MarhTrac.MarhCmd[j] := 0; // ����� ���������� �������

            ObjZv[SVTF].bP[14] := false; //------ �������� ����������� ��������� �������
            ObjZv[SVTF].bP[7] := false;//------- �������� ���������� ����������� �������
            ObjZv[SVTF].bP[9] := false;//--------- �������� �������� ����������� �������

            j := MarhTrac.HTail; //------------------------------- �������� ����� ������
            ObjZv[j].bP[14] := false; //------------- ����� ����������� ��������� ������
            ObjZv[j].bP[7] := false;//----------- �������� ���������� ����������� ������
            ObjZv[j].bP[9] := false;//------------- �������� �������� ����������� ������

            j := MarhTrac.PutPriem; //---------------- �������� ���� ������ ��� ��������
            ObjZv[j].bP[14] := false; //--------------- ����� ����������� ��������� ����
            ObjZv[j].bP[7] := false;//------------- �������� ���������� ����������� ����
            ObjZv[j].bP[9] := false;//--------------- �������� �������� ����������� ����
          end;


          ObjZv[SVTF].iP[1] := 0; //------------------- �������� ������ �������� � �������
          ObjZv[SVTF].bP[34] := false; //--------------- �������� ������� ������� ��� STAN

          if(((ObjZv[SVTF].iP[10] and $4)= 0) and //-- ��� �������� ������������� ��� �...
          (//-------------------------------- ��1 � �1 ��� ������ �� (��� �� ������������)
          ((ObjZv[SVTF].bP[1] and ObjZv[SVTF].bP[3]) and  not ObjZv[SVTF].ObCB[22])
          or //------------------------------------------------------------------- ��� ...
          (ObjZv[SVTF].bP[2] and ObjZv[SVTF].bP[4]))) then //��2 � �2 (��� ������� ������)
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[SVTF].RU then
              begin
                InsNewMsg(SVTF,300+$1000,1,'');// ���������� ����������� ����� ��������� $
                AddFixMes(GetSmsg(1,300, ObjZv[SVTF].Liter,1),4,4)
              end;
{$ELSE}
              InsNewMsg(SVTF,300+$1000,1,'');
{$ENDIF}
            end;
            ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $4;//------------ �������� �������
          end;
        end
        else ObjZv[SVTF].iP[10]:=ObjZv[SVTF].iP[10] and $FFFB;//����� ��������,���� ������

        //--------------------------------------------------------------------------------
        if ObjZv[SVTF].BasOb > 0 then //---------------- ���� ���� ����������� ������
        begin
          SP := ObjZv[SVTF].BasOb;
          if ObjZv[SVTF].bP[11] <> ObjZv[SP].bP[2] then
          begin //------------------------------------------ ��������� � ������ ����������
            if ObjZv[SVTF].bP[11] then  //------------------ ���� ������ ��������� �� ����
            begin
              ObjZv[SVTF].iP[1] := 0;  //------------------------ �������� ������ ��������
              ObjZv[SVTF].bP[34] := false; //--------- �������� ������� ������� �� �������
            end else
            begin //--- ���� ������ ���� ��������� ����������� ������, ������ ������������
              ObjZv[SVTF].bP[14] := false; //----------------- ����� ����������� ���������
              ObjZv[SVTF].bP[7] := false;  //---------------- ����� ���������� �����������
              ObjZv[SVTF].bP[9] := false;  //------------------ ����� �������� �����������
              ObjZv[SVTF].iP[2] := 0;      //------------------------------------ ����� ��
              ObjZv[SVTF].iP[3] := 0;      //------------------------------------ ����� ��
            end;
            ObjZv[SVTF].bP[11] := ObjZv[SP].bP[2];//------------------------------ ����� �
          end;
        end;


        //---------------------------------------- �������� �������� �� ������� ����������
        ObjZv[SVTF].bP[18] := false;  //-------------------- �������� �������� "�� ��� ��"
        ObjZv[SVTF].bP[21] := false; //-------------------------------------- �������� ���

        for i := 20 to 24 do //---------------------------- ������ �� ��������� ������� ��
        begin
          MU := ObjZv[SVTF].ObCI[i];

          if MU > 0 then //----------------------------- ���� ���� �������������� � ������
          begin
            case ObjZv[MU].TypeObj of //--------------------- ������������� �� ���� ������
              25 :
              begin //-------------------------------------------- �� (���������� �������)
                if not ObjZv[SVTF].bP[18] then ObjZv[SVTF].bP[18] :=  Get_ManK(MU);

                if ObjZv[SVTF].ObCB[18] and not ObjZv[SVTF].bP[21] then
                begin //------------------------------------------------------ ������� ���
                  ObjZv[SVTF].bP[21] := ObjZv[MU].bP[1] and     //--------------- �� � ...
                  not ObjZv[MU].bP[4] and ObjZv[MU].bP[5]; //-------- ��  �  �(����������)
                end;

                ObjZv[SVTF].bP[18] := ObjZv[SVTF].bP[18] or
                not ObjZv[MU].bP[3]; //-------------------------------------- ��&�� ��� ��
              end;

              43 :
              begin //---------------------------------------------------------------- ���
                MK := ObjZv[MU].BasOb;
                if not ObjZv[SVTF].bP[18] then ObjZv[SVTF].bP[18]:= Get_ManK(MK);

                if ObjZv[SVTF].ObCB[18] and //------------- ���� ���������� ��� � ...
                not ObjZv[SVTF].bP[21] then //-------------------------------- ��� = false
                begin //------------------------------------------------------ ������� ���
                  ObjZv[SVTF].bP[21] := ObjZv[MK].bP[1] and //------------------------- ��
                  not ObjZv[MK].bP[4] and ObjZv[MK].bP[5] and  //--------------�� � � �...
                  not ObjZv[MU].bP[2]; //--------------------------------------------- ���
                end;
                ObjZv[SVTF].bP[18]:=ObjZv[SVTF].bP[18] or not ObjZv[MK].bP[3];//��&�� ��� ��
              end;

              48 :
              begin //---------------------------------------------------------------- ���
                MK := ObjZv[MU].BasOb;
                if not ObjZv[SVTF].bP[18] then ObjZv[SVTF].bP[18] := Get_ManK(MK);

                if ObjZv[SVTF].ObCB[18] and //-------------- ���� ���������� ��� � ...
                not ObjZv[SVTF].bP[21] then //--------------------------------- ��� = false
                begin //------------------------------------------------------ ������� ���
                  ObjZv[SVTF].bP[21] :=   ObjZv[MK].bP[1] and //------------------------ ��
                  not ObjZv[MK].bP[4] and //------------------------- ��
                  ObjZv[MK].bP[5] and    //------------------- � �
                  ObjZv[MU].bP[1]; //--------------------------- ��������� ������� �� ����
                end;
                ObjZv[SVTF].bP[18]:=ObjZv[SVTF].bP[18] or not ObjZv[MK].bP[3];//��&�� ��� ��
              end;

              52 :
              begin //-------------------------------------------------------------- �����
                MK := ObjZv[MU].BasOb;
                if not ObjZv[SVTF].bP[18] then
                ObjZv[SVTF].bP[18] :=  Get_ManK(MK);
                if ObjZv[SVTF].ObCB[18] and not ObjZv[SVTF].bP[21] then
                begin //------------------------------------------------------ ������� ���
                  ObjZv[SVTF].bP[21] := ObjZv[MK].bP[1] and //-------------------------- ��
                  not ObjZv[MK].bP[4] and ObjZv[MK].bP[5] and //--------------------�� & �
                  ObjZv[MU].bP[1]; //------------------ ���� ������ �� ���������� ��������
                end;
                ObjZv[SVTF].bP[18]:=ObjZv[SVTF].bP[18] or not ObjZv[MK].bP[3];//��&��  ��
              end;
            end; //--------------------------------- ����� ������������� �� ���� ������ ��
          end; //---------------------------------------- ����� �������������� � ������ ��
        end; //------------------------------------- ����� ������� �� ��������� ������� ��

        if (ObjZv[SVTF].iP[2] = 0) and //-------------------------------------- ������� ��
        (ObjZv[SVTF].iP[3] = 0) and //----------------------------------------- ������� ��
        not ObjZv[SVTF].bP[18] then //----------------------------------------- ������� ��
        begin //------------------------------- �������������� ���������� ����������� ����
          if ObjZv[SP].bP[1] then ObjZv[SVTF].T[1].Activ  := false // ���� �� ��������
          else  //---------------------------------------------- ����������� ������ ������
          if ObjZv[SVTF].bP[4] then //------------------------------ ���� ������ ������ �2
          begin
            if not ObjZv[SVTF].T[1].Activ  then //---------------------- ������ �� �������
            begin //--------------------------------------------- ��������� ������ �������
              ObjZv[SVTF].T[1].Activ  := true;
              ObjZv[SVTF].T[1].F := LastTime;
            end;
          end else
          begin //------------------------------------------------------ ������ ����������
            if ObjZv[SVTF].T[1].Activ  then
            begin
              ObjZv[SVTF].T[1].Activ  := false;
{$IFDEF RMSHN}
              ObjZv[SVTF].dtP[6] := LastTime - ObjZv[SVTF].T[1].F;
{$ENDIF}
            end;
          end;
        end;

        if (ObjZv[SVTF].iP[2] = 0) and (ObjZv[SVTF].iP[3] = 0) and //��� ��������� �� � ��
        not ObjZv[SVTF].bP[18]      //------------------------------------ ��� �������� ��
{$IFDEF RMDSP}
        and (ObjZv[SVTF].RU = config.ru) //----------- � ��-��� - ���� ������������ ������
        and WorkMode.Upravlenie          //-------------------------- � ������� ����������
{$ENDIF}
        then
        begin //-------------------------------------------------- �������� ������ �������
          if ObjZv[SP].bP[2] then //--------------------- ��� ��������� ����������� ������
          begin
            if not ObjZv[SVTF].T[1].Activ  and //-------------------- �� �������� ��������
            not ObjZv[SVTF].bP[8] and not ObjZv[SVTF].bP[9] then //--- ��� � � �����������
            begin
              if ObjZv[SVTF].bP[4] then//------------------------ ���� � (������ ��������)
              begin
                if((ObjZv[SVTF].iP[10] and $2)=0) then //- ��� �������� ���� ������������� 
                begin
                  if WorkMode.FixedMsg then
                  begin
                    InsNewMsg(SVTF,510+$1000,0,'');
                    //---------- "������������� �������� ������� $ ��� ��������� ��������"
                    AddFixMes(GetSmsg(1,510,ObjZv[SVTF].Liter,0),4,1);
                  end;
                end;
                ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $2; //-- ������������� �������
              end
              else ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FFD; //����� ������ ����.
            end;

            if ObjZv[SVTF].bP[2] then //--------------------- ���� ��2 (������ ����������)
            begin
              if not ObjZv[SVTF].bP[6] and not ObjZv[SVTF].bP[7] then//��� �� � ��� ������
              begin //---------------------------------------- ���� �� ��� ������ ��������
                if ObjZv[SVTF].T[2].Activ  then //-------------------- ���� ������� ������
                begin //-------------- �������� ������������� ����������� ����������� ����
                  if LastTime > ObjZv[SVTF].T[2].F then //----------- ����� �������� �����
                  begin
                    if ((ObjZv[SVTF].iP[10] and $1) = 0) then //------------- ��� ��������
                    begin
                      if WorkMode.FixedMsg then
                      begin
                        //-------- ������������� �������� ������� $ ��� ��������� ��������
                        InsNewMsg(SVTF,510+$1000,0,'');
                        AddFixMes(GetSmsg(1,510,ObjZv[SVTF].Liter,0),4,1);
                        ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $1;
                      end;
                    end;
                  end;
                end else
                begin //---------- ��� �������� ������������� ����������� ����������� ����
                  ObjZv[SVTF].T[2].F := LastTime + 5 / 86400;
                  ObjZv[SVTF].T[2].Activ  := true;
                end;
              end;
            end  else
            begin
              ObjZv[SVTF].T[2].Activ  := false;//--------- ����� �������,���������� ������
              ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FFFE;
            end;
          end else //------------------------------------------ ���� ��������� �����������
          if ObjZv[SVTF].bP[6] or ObjZv[SVTF].bP[8] then //------ ���� �� ��� � �� �������
          begin
            if not ObjZv[SP].bP[1] then //-------------------------- ������ ����������� ��
            begin
              if not ObjZv[SVTF].bP[27] then //--------- ��� �������� ������� �� � �������
              begin
                if not (ObjZv[SVTF].bP[2] or ObjZv[SVTF].bP[4]) then//�� �����. ��2 ��� �2
                begin //---------------------------------------------------- ������ ������
                  if WorkMode.FixedMsg then
                  begin
                    InsNewMsg(SVTF,509+$1000,0,'');//----- ������� ��  �� �������� �������
                    AddFixMes(GetSmsg(1,509,ObjZv[SVTF].Liter,0),4,1);
                    ObjZv[SVTF].bP[19] := true; //------------- ��������� ������� ��������
                  end;
                end;
                ObjZv[SVTF].bP[27] := true; //------- ��������� ������� ����������� ������
              end;
            end;
          end;
        end;

        if ObjZv[SP].bP[1] then ObjZv[SVTF].bP[27] := false;//-- ����� �������� ������� ��

        if ObjZv[SVTF].ObCI[28] > 0 then
        begin //-------------------------------- ���������� ��������� ������������ �������
          OVBuffer[VidBuf].Param[31] := ObjZv[ObjZv[SVTF].ObCI[28]].bP[1];
        end else OVBuffer[VidBuf].Param[31] := false;

        OVBuffer[VidBuf].Param[3] :=  //-------------------------  ���������� ������ �����
        ObjZv[SVTF].bP[2] or ObjZv[SVTF].bP[21]; //--------- ���������� ��� ��� ������� OZ

        OVBuffer[VidBuf].Param[5] := ObjZv[SVTF].bP[4];//------------------------ ��������
        OVBuffer[VidBuf].Param[6] := ObjZv[SVTF].bP[5];//----------------------- ���������

        if not ObjZv[SVTF].bP[2] and  //-------------------------- ������ ���������� � ...
        not ObjZv[SVTF].bP[4] and //-------------------------------- ������ �������� � ...
        not ObjZv[SVTF].bP[21] then //-------------------------------------------- ��� ���
        begin
          OVBuffer[VidBuf].Param[2] := ObjZv[SVTF].bP[1]; //----- ������� � ���������� ���

          OVBuffer[VidBuf].Param[4] := ObjZv[SVTF].bP[3]; //----- � ���������� �������� ��

          if not ObjZv[SVTF].bP[1] and not ObjZv[SVTF].bP[3] then //- ���� ��� �������� ��
          begin
            if WorkMode.Upravlenie then //----------------------------- ���� ��� ���������
            begin
              if not ObjZv[SVTF].bP[14] and //--------------- ��� ������������ ��������� �
              ObjZv[SVTF].bP[7] then    //------------------------------- ���� �����������
              begin //--------------------------------- ��� ����������� ������� ����������
                OVBuffer[VidBuf].Param[11] := ObjZv[SVTF].bP[7]; //-����������� �� �������
              end else

              //-------- ����� ������������ ������� ������ �������� ��� �������� �� "STAN"
              if tab_page then //-------------- �������� ������ ������� ��������� ��������
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //�� ������ � ��������
                OVBuffer[VidBuf].Param[11]:=false //--- ����� ������. ������ � �����������
                else
                OVBuffer[VidBuf].Param[11]:=//--- ����� ���������� ������ ����� ������� ��
                ObjZv[SVTF].bP[6] and not ObjZv[SVTF].bP[34]  // �� � ����� ������ �� STAN
              end else
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //�� ������ � ��������
                OVBuffer[VidBuf].Param[11] := false //---- ����� ���������� ������ � �����
                else OVBuffer[VidBuf].Param[11] := //-- ���������� ������ ����� ������� ��
                ObjZv[SVTF].bP[7]; //-------------------------------------- ��� �� �������
              end;
            end
            else //------------------------------------------- ���� ��� ���������� �� ����
            OVBuffer[VidBuf].Param[11] := ObjZv[SVTF].bP[6];//-- ���������� ������ �� STAN

            if WorkMode.Upravlenie then //----------------------------- ���� ��� ���������
            begin
              if not ObjZv[SVTF].bP[14] and ObjZv[SVTF].bP[9] then //��� ���������, ������
              begin //--------------------------------- ��� ����������� ������� ����������
                OVBuffer[VidBuf].Param[12] := //--------- �������� ������ ����� ������� ��
                ObjZv[SVTF].bP[9]; //---------------- �� �������� ����������� ������� ����
              end else //------------------------------ ��� ������� ������������ ���������

              //-------- ����� ������������ ������� ������ �������� ��� �������� �� "STAN"
              if tab_page then //-------------- �������� ������ ������� ��������� ��������
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //�� ������ � ��������
                OVBuffer[VidBuf].Param[12] := false //------ ����� �������� ������ � �����
                else
                OVBuffer[VidBuf].Param[12] := //-- ����� ������� ������ � ����� ������� ��
                ObjZv[SVTF].bP[8] and //----------------------- ������ � �� FR3 ("stan") �
                not ObjZv[SVTF].bP[34] //---------------------- ��� ������ ������ ��� STAN
              end else
              begin
                if not ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] then //�� ������ � ��������
                OVBuffer[VidBuf].Param[12]:=false //-------- ����� �������� ������ � �����
                else
                OVBuffer[VidBuf].Param[12] := ObjZv[SVTF].bP[9]; //--- �� ��� ������� ����
              end;
            end else //------------------------------------------- ���� ��� ����������, ��
            OVBuffer[VidBuf].Param[12] := ObjZv[SVTF].bP[8]; //----------- ������ � �� FR3
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

        sost := GetFR5(ObjZv[SVTF].ObCI[1]);

        if (ObjZv[SVTF].iP[2] = 0) and //--- ������ ���� ��� �������� ������� (������� ��)
        (ObjZv[SVTF].iP[3] = 0) and //--- ������ ���� ��� �������� ���������� (������� ��)
        not ObjZv[SVTF].bP[18] then //----------------------------------------- ������� ��
        begin //- �������� ���������� �������, ���� �� ���������� ������� ������� �� �����
          if ((sost and 1) = 1) and not ObjZv[SVTF].bP[18] then
          begin //----------------------------------------- ��������� ���������� ���������
{$IFDEF RMDSP}
            if ObjZv[SVTF].RU = config.ru then
            begin
{$ENDIF}
              if WorkMode.OU[0] then
              begin //------------------------------ ���������� � ������ ���������� � ����
                InsNewMsg(SVTF,396+$1000,0,''); //----------- "������������� ���������� $"
                AddFixMes(GetSmsg(1,396,ObjZv[SVTF].Liter,0),4,1);
              end else
              begin //---------------------------- ���������� � ������ ���������� � ������
                InsNewMsg(SVTF,403+$1000,0,''); //------ "������������� ���������� $ (��)"
                AddFixMes(GetSmsg(1,403,ObjZv[SVTF].Liter,0),4,1);
              end;
{$IFDEF RMDSP}
            end;
            ObjZv[SVTF].bP[23] :=
            WorkMode.Upravlenie and WorkMode.OU[0]; //�����������,���� �������� ����������
{$ENDIF}
{$IFNDEF RMDSP}
            ObjZv[SVTF].dtP[2] := LastTime;
            inc(ObjZv[SVTF].siP[2]);
            ObjZv[SVTF].bP[23] := true; //---------------------- ����������� �������������
{$ENDIF}
          end;
        end
        else  ObjZv[SVTF].bP[23] := false; //--- ���� ���� ��� �� - ����� �������� �������
        ;
        //--------------------------------------------------------{FR4}-------------------
        ObjZv[SVTF].bP[12] := //------------------ ���������� ��� ����� ���������� �������
        GetFR4State(ObjZv[SVTF].ObCI[1]*8+2);
  {$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZv[SVTF].RU=config.ru) then//���������� � �����  ��
        begin
          if tab_page
          then OVBuffer[VidBuf].Param[32] := ObjZv[SVTF].bP[13] //----------- ���� �� ����
          else OVBuffer[VidBuf].Param[32] :=  ObjZv[SVTF].bP[12]; //--------- ���� �� STAN
        end else
{$ENDIF}
        OVBuffer[VidBuf].Param[32] := ObjZv[SVTF].bP[12]//--------------------- ����� STAN
      end;

      //------------------------ � ����� ������ ------------------------------------------
      OVBuffer[VidBuf].Param[13] := ObjZv[SVTF].bP[23]; //--------------------- ����������

      Aktiv := true; //------------------------------------------------------ �����������2
      Nepar:= false; //--------------------------------------------------- ��������������2
      ObjZv[SVTF].bP[30] := false;

      jso := GetFR3(ObjZv[SVTF].ObCI[9],Nepar,Aktiv);//-------------------------- ���
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      zso :=  GetFR3(ObjZv[SVTF].ObCI[10],Nepar,Aktiv);//------------------------ ���
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      so :=  GetFR3(ObjZv[SVTF].ObCI[25],Nepar,Aktiv);//-------------------------- Co
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      vnp := GetFR3(ObjZv[SVTF].ObCI[26],Nepar,Aktiv);//------------------------- ���
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      n :=   GetFR3(ObjZv[SVTF].ObCI[11],Nepar,Aktiv);//--------------------------- �
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      kz := GetFR3(ObjZv[SVTF].ObCI[30],Nepar,Aktiv);//--------------------------- ��
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar;

      OVBuffer[ObjZv[SVTF].VBufInd].Param[7] :=  Nepar;
      ObjZv[SVTF].bP[30] := ObjZv[SVTF].bP[30] or Nepar; //-------------- �������������� 2

      if not ObjZv[SVTF].bP[30] then //-------------------------------- ���� ������������2
      begin
        if jso <> ObjZv[SVTF].bP[15] then
        begin //-------------------------------------------------------- ��������� ���(��)
          if jso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                if ObjZv[SVTF].ObCI[10] = 0 then //--- ���� � ������� ��� ������� ���
                begin
                  if ObjZv[SVTF].bP[4] then //----------------------- ���� ������ ��������
                  InsNewMsg(SVTF,300+$1000,1,'')//"������������� ������. ���� ��������� $"
                end
                else //---------------------------------------------- ���� ���� ������ ���
                begin
                  if ObjZv[SVTF].bP[4] then //----------------------- ���� ������ ��������
                  InsNewMsg(SVTF,485+$1000,0,'')//������. ���.���� ����� ����� ��������� $
                end;
              end;
{$ELSE}       //----------------------------- ����� ��� ��� �� ---------------------------
              if ObjZv[SVTF].ObCI[10] = 0 then  //---- ���� � ������� ��� ������� ���
              begin
                if ObjZv[SVTF].bP[4]
                then InsNewMsg(SVTF,300+$1000,0,'');//������������� ����. ���� ��������� $
              end else
              begin
                if ObjZv[SVTF].bP[4]
                then InsNewMsg(SVTF,485+$1000,0,'');
                //----------- "������������� �������� ���� ����� ������� ���� ��������� $"
              end;
              SBeep[4] := true;
              ObjZv[SVTF].dtP[3] := LastTime;
              inc(ObjZv[SVTF].siP[3]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ ����� ���������� �������������
        end;
        ObjZv[SVTF].bP[15] := jso; //-------------------------------- ��������� ������� ��

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if zso <> ObjZv[SVTF].bP[24] then
        begin //------------------------------------------------------------ ��������� ���
          if zso then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                if ObjZv[SVTF].bP[4] then //------------------------------ ������ ��������
                begin
                  InsNewMsg(SVTF,486+$1000,0,'');// ���������� �������� ���� ������� �����
                  AddFixMes(GetSmsg(1,486,ObjZv[SVTF].Liter,0),4,4);
                  SBeep[4] := true;
                end;
              end;
{$ELSE}       //--------------------------------------------------------- ����� ��� ��� ��
              if ObjZv[SVTF].bP[4] then
              InsNewMsg(SVTF,486+$1000,0,'');
              //-------------- ������������� �������� ���� ����� �������� ���� ��������� $
              SBeep[4] := true;
              ObjZv[SVTF].dtP[3] := LastTime;
              inc(ObjZv[SVTF].siP[3]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ ����� ���������� �������������
        end;
        ObjZv[SVTF].bP[24] := zso; //------------------------------------------------- ���

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if vnp  and ObjZv[SVTF].bP[4] then //----------------------- ��� � ������ ��������
        begin
          if ObjZv[SVTF].T[4].Activ = false then  //----------- ���� ������ �� ��� �������
          begin
            ObjZv[SVTF].T[4].Activ := true; //--------------------------- ��������� ������
            ObjZv[SVTF].T[4].F := LastTime; //------------------- ������������� ������
            ObjZv[SVTF].T[4].S:= LastTime + 2/86400; //------------- ��������� �����
          end else
          begin //---------------------------------------------- ���� ������ �������������
            if vnp and (ObjZv[SVTF].T[4].S< LastTime) then   //--------- ����� �����
            begin
              ObjZv[SVTF].T[4].Activ := false;
              ObjZv[SVTF].T[4].F := 0;
              ObjZv[SVTF].T[4].S:= 0;
              if vnp then
              begin
                if ( WorkMode.FixedMsg and ((ObjZv[SVTF].iP[10] and $80) = 0)) then
                begin
{$IFDEF RMDSP}
                  if ObjZv[SVTF].RU = config.ru then
                  begin
                    InsNewMsg(SVTF,300+$1000,1,'');// "���������� ����������� ��������� $"
                    AddFixMes(GetSmsg(1,300,ObjZv[SVTF].Liter,1),4,4);
                    ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $80; //------- �������� NN
                  end;
                end;
{$ELSE}
                  InsNewMsg(SVTF,300+$1000,1,'');
                  SBeep[4] := true;
                  ObjZv[SVTF].dtP[3] := LastTime;
                  inc(ObjZv[SVTF].siP[3]);
                  ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $80; //--------- �������� NN
                end;
{$ENDIF}
                ObjZv[SVTF].bP[25] := vnp;
              end;
            end else
            begin
              ObjZv[SVTF].bP[25] := vnp;
              ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FF7F; //--------����� ��������
            end;
          end;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if so and ObjZv[SVTF].bP[4] then //-------------------------- �� � ������ ��������
        begin
          if ObjZv[SVTF].T[3].Activ = false then  //----------- ���� ������ �� ��� �������
          begin
            ObjZv[SVTF].T[3].Activ := true; //--------------------------- ��������� ������
            ObjZv[SVTF].T[3].F := LastTime; //------------------- ������������� ������
            ObjZv[SVTF].T[3].S:= LastTime + 2/86400; //------------- ��������� �����
          end else
          begin //---------------------------------------------- ���� ������ �������������
            if so and (ObjZv[SVTF].T[3].S< LastTime) then   //---------- ����� �����
            begin
              ObjZv[SVTF].T[3].Activ := false;
              ObjZv[SVTF].T[3].F := 0;
              ObjZv[SVTF].T[3].S:= 0;
              if WorkMode.FixedMsg and ((ObjZv[SVTF].iP[10] and $100) = 0) then
              begin
{$IFDEF RMDSP}
                if ObjZv[SVTF].RU = config.ru then
                begin
                  InsNewMsg(SVTF,544+$1000,0,'');// ���������� ���� ������.����� ���������
                  AddFixMes(GetSmsg(1,544,ObjZv[SVTF].Liter,0),4,4);
                  ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $100;
                end;
              end;
{$ELSE}
                InsNewMsg(SVTF,544+$1000,0,'');//- ��������.���.���� ������.���� ���������
                SBeep[4] := true;
                ObjZv[SVTF].dtP[3] := LastTime;
                inc(ObjZv[SVTF].siP[3]);
                ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] or $100;
              end;
{$ENDIF}
              ObjZv[SVTF].bP[26] := so;
            end;
          end;
        end else
        begin
          ObjZv[SVTF].bP[26] := so;
          ObjZv[SVTF].iP[10] := ObjZv[SVTF].iP[10] and $FF; //------------- ����� ��������
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if n <> ObjZv[SVTF].bP[17] then
        begin //-------------------------------------------------------------- ��������� �
          if n then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                InsNewMsg(SVTF,338+$1000,0,''); //---- "������ ����� �������� ��������� $"
                AddFixMes(GetSmsg(1,338,ObjZv[SVTF].Liter,0),4,4);
              end;
{$ELSE}
              InsNewMsg(SVTF,338+$1000,0,'');
              SBeep[4] := true;
              ObjZv[SVTF].dtP[4] := LastTime;
              inc(ObjZv[SVTF].siP[4]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ ����� ���������� �������������
        end;
        ObjZv[SVTF].bP[17] := n;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        if kz <> ObjZv[SVTF].bP[16] then
        begin //-------------------------------------------------------- ��������� �� (��)
          if kz then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObjZv[SVTF].RU = config.ru then
              begin
                if ObjZv[SVTF].bP[4] then //------------------ ���� ������ �������� ������
                begin
                  InsNewMsg(SVTF,497+$1000,1,''); // ���������� �������� ����������� �����
                  AddFixMes(GetSmsg(1,497,ObjZv[SVTF].Liter,1),4,4);
                end else
                begin
                  InsNewMsg(SVTF,497+$1000,1,'');
                  AddFixMes(GetSmsg(1,497,ObjZv[SVTF].Liter,1),4,4);
                end;
              end;
{$ELSE}       //------------------ ��� ��� �� --------------------------------------------
              if ObjZv[SVTF].bP[4]
              then InsNewMsg(SVTF,487+$1000,1,'')//������������ �������� ������� �� ������
              else InsNewMsg(SVTF,497+$1000,1,'');
              SBeep[4] := true;
              ObjZv[SVTF].dtP[5] := LastTime;
              inc(ObjZv[SVTF].siP[5]);
{$ENDIF}
            end;
          end;
          ObjZv[SVTF].bP[20] := false; //------------------ ����� ���������� �������������
        end;
        ObjZv[SVTF].bP[16] := kz;


        OVBuffer[VidBuf].Param[17] := ObjZv[SVTF].bP[20]; //----- ���������� �������������
        OVBuffer[VidBuf].Param[7] := ObjZv[SVTF].bP[30];//--------------- �������������� 2
        if ObjZv[SVTF].bP[4] then
        begin
          OVBuffer[VidBuf].Param[8] := ObjZv[SVTF].bP[26];//------------------- �� � �����
          OVBuffer[VidBuf].Param[15] := ObjZv[SVTF].bP[24];//------------------------- ���
          OVBuffer[VidBuf].Param[29] := ObjZv[SVTF].bP[15];//------------------------- ���
          OVBuffer[VidBuf].Param[19] := ObjZv[SVTF].bP[25]; //------------------------ ���
        end;
        OVBuffer[VidBuf].Param[9] :=  ObjZv[SVTF].bP[16]; //--------------------------- ��
        OVBuffer[VidBuf].Param[10] := ObjZv[SVTF].bP[17]; //---------------------------- �
        OVBuffer[VidBuf].Param[14] := ObjZv[SVTF].bP[14];//--------------------- ��� �����
      end;
    end;
end;

//========================================================================================
//-------------------------------- ���������� ������� ���������� ���� � ������ �� ����� #6
procedure PrepPTO(PTO : Integer);
var
  zo,og : boolean;
  VBUF,OZ,OGR,SOG : integer;
begin
  OZ := ObjZv[PTO].ObCI[2];
  OGR := ObjZv[PTO].ObCI[3];
  SOG := ObjZv[PTO].ObCI[4];

  ObjZv[PTO].bP[31] := true; //----------------------------------------------- �����������
  ObjZv[PTO].bP[32] := false; //------------------------------------------- ��������������
  VBUF := ObjZv[PTO].VBufInd;

  zo := GetFR3(OZ,ObjZv[PTO].bP[32],ObjZv[PTO].bP[31]); //----------------------------- ��
  og := GetFR3(OGR,ObjZv[PTO].bP[32],ObjZv[PTO].bP[31]); //---------------------------- ��

  ObjZv[PTO].bP[3] := GetFR3(SOG,ObjZv[PTO].bP[32],ObjZv[PTO].bP[31]); //------------- ���

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[16] := ObjZv[PTO].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[PTO].bP[32];
    if ObjZv[PTO].bP[31] and not ObjZv[PTO].bP[32] then
    begin
      OVBuffer[VBUF].Param[18] := (config.ru = ObjZv[PTO].RU); //-------- �� �������������
      OVBuffer[VBUF].Param[16] := ObjZv[PTO].bP[31];
      OVBuffer[VBUF].Param[1] := false;

      if og <> ObjZv[PTO].bP[2] then
      begin
        if og then //---------------------------------------------- ����������� ����������
        begin
          if not zo then //------------- ���� ��� ������� �� ���������� - ��������� ������
          begin
            ObjZv[PTO].T[1].F := LastTime + 3/80000;
            ObjZv[PTO].T[1].Activ  := true;
            ObjZv[PTO].bP[4] := false; //--------- �������������� ������� ������������� ��
            ObjZv[PTO].bP[5] := false;
          end;
        end else  ObjZv[PTO].T[1].Activ  := false; //------------------------------- �����
      end;

      ObjZv[PTO].bP[2] := og;

      if zo <> ObjZv[PTO].bP[1] then
      begin
        if zo then  //------------------------------------------ ������� ������ ����������
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (config.ru = ObjZv[PTO].RU) then
            begin
              InsNewMsg(PTO,295,7,''); //-------------------- ������� ������ �� ����������
              if WorkMode.Upravlenie
              then AddFixMes(GetSmsg(1,295,ObjZv[PTO].Liter,7),4,6);
            end;
{$ELSE}
            InsNewMsg(PTO,295,7,'');
{$ENDIF}
          end;
        end else
        begin //--------------------------------------------------- ���� ������ ����������
          ObjZv[PTO].bP[4] := false; //----------- �������������� ������� ������������� ��
          ObjZv[PTO].bP[5] := false;
          ObjZv[PTO].T[1].F := LastTime + 3/80000;
          ObjZv[PTO].T[1].Activ  := true;
        end;
      end;
      ObjZv[PTO].bP[1] := zo;

      OVBuffer[VBUF].Param[6] := ObjZv[PTO].bP[4];

      if ObjZv[PTO].bP[2] and not ObjZv[PTO].bP[1] then
      begin //----------------------------------------------------- ���������� ��� �������
        if ObjZv[PTO].T[1].Activ  then
        begin
          if (ObjZv[PTO].T[1].F > LastTime) or ObjZv[PTO].bP[4]  //------- ����� �����
          then  OVBuffer[VBUF].Param[7] := ObjZv[PTO].bP[2]
          else
          begin
            if not ObjZv[PTO].bP[5] then
            begin //------------------------------------------- ��������� ������������� ��
              ObjZv[PTO].bP[5] := true;
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if (config.ru = ObjZv[PTO].RU) then
                begin
                  InsNewMsg(PTO,337+$1000,1,''); //--- ������������� ����� ���������� ����
                  AddFixMes(GetSmsg(1,337,ObjZv[PTO].Liter,1),4,3);
                end;
{$ELSE}
                InsNewMsg(PTO,337+$1000,1,'');
                ObjZv[PTO].dtP[1] := LastTime;
                inc(ObjZv[PTO].siP[1]);
{$ENDIF}
              end;
            end;
            OVBuffer[VBUF].Param[7] := true;
          end;
        end;
        OVBuffer[VBUF].Param[8] := false;
      end else
      begin
        OVBuffer[VBUF].Param[6] := false;
        OVBuffer[VBUF].Param[8] := ObjZv[PTO].bP[1];
        OVBuffer[VBUF].Param[7] := ObjZv[PTO].bP[2];
        ObjZv[PTO].T[1].Activ  := false;
      end;
    end;
  end;
end;

//========================================================================================
//--------------------- ���������� ������� ���������������� ������� ��� ������ �� ����� #7
procedure PrepPriglasit(PRIG : Integer);
var
  i,prs,pso,VBUF : integer;
  ps : boolean;
begin
  prs := ObjZv[PRIG].ObCI[2];
  pso := ObjZv[PRIG].ObCI[3];
  ObjZv[PRIG].bP[31] := true; //---------------------------------------------- �����������
  ObjZv[PRIG].bP[32] := false; //------------------------------------------ ��������������

  ps := GetFR3(prs,ObjZv[PRIG].bP[32],ObjZv[PRIG].bP[31]);//--------------------------- ��

  if  pso > 0 then
  ObjZv[PRIG].bP[2] := not GetFR3(pso,ObjZv[PRIG].bP[32],ObjZv[PRIG].bP[31]);//------- ���

  if ObjZv[PRIG].VBufInd > 0 then
  begin
    VBUF := ObjZv[PRIG].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[PRIG].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[PRIG].bP[32];
    if ObjZv[PRIG].bP[31] and not ObjZv[PRIG].bP[32] then
    begin
      if ps <> ObjZv[PRIG].bP[1] then
      begin
        if ps then
        begin
{$IFDEF RMDSP or $IFDEF RMSHN}
          if config.ru = ObjZv[PRIG].RU then begin
            InsNewMsg(PRIG,380+$2000,0,'');
            AddFixMes(GetSmsg(1,380,ObjZv[PRIG].Liter,0),0,6);
          end;
{$ELSE}
          InsNewMsg(PRIG,380+$2000,0,'');
{$ENDIF}
        end;
      end;
      ObjZv[PRIG].bP[1] := ps;

      i := ObjZv[PRIG].ObCI[1] * 2;  //------ ����� ��������� �� � ������ �����������

      OVBuffer[VBUF].Param[i] := ObjZv[PRIG].bP[1]; //--------- ���������� �������� ��� ��

      if ObjZv[PRIG].ObCI[3] > 0 then  //------------------------------ ���� ���� ���
      begin
        OVBuffer[VBUF].Param[i+1] := ObjZv[PRIG].bP[2]; //--- ����������� �������� ��� ���
        if ObjZv[PRIG].bP[1] then
        begin //----------------------------------- ���� �� ������ - ��������� �����������
          if ObjZv[PRIG].bP[2] then
          begin
            if not ObjZv[PRIG].bP[19] then //------------------------- ���� �� �����������
            begin //--------------------------------------------------- ��������� 3 ������
              if ObjZv[PRIG].T[1].Activ  then
              begin
                if ObjZv[PRIG].T[1].F < LastTime then //------------------ ����� �����
                begin
                  if WorkMode.FixedMsg then
                  begin
{$IFDEF RMDSP}
                    if (config.ru = ObjZv[PRIG].RU) then
                    begin
                      InsNewMsg(PRIG,454+$1000,1,'');//������������� ���������������� ����
                      AddFixMes(GetSmsg(1,454,ObjZv[PRIG].Liter,1),4,4);
                    end;
{$ELSE}
                    InsNewMsg(PRIG,454+$1000,1,''); SBeep[4] := true;
{$ENDIF}
                    ObjZv[PRIG].bP[19] := true; //-------------- �������� ������������� ��
                  end;
                end;
              end else
              begin
                ObjZv[PRIG].T[1].Activ  := true;
                ObjZv[PRIG].T[1].F := LastTime + 3/80000; //----------- ������ �������
              end;
            end;
          end else
          begin
            ObjZv[PRIG].T[1].Activ  := false;
            ObjZv[PRIG].bP[19] := false; //--------------- ����� �������� ������������� ��
          end;
        end else
        begin
          ObjZv[PRIG].T[1].Activ  := false;
          ObjZv[PRIG].bP[19] := false; //----------------- ����� �������� ������������� ��
        end;
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------- ���������� ������� ��� � ������ �� ����� #8
procedure PrepUTS(UTS : Integer);
var
  uu : Boolean;
  PUT : integer;
begin
  with ObjZv[UTS] do
  begin
    bP[31] := true;  bP[32] := false; //----------------------- ����������� � ������������
    bP[1] := GetFR3(ObCI[2],bP[32],bP[31]); //---------------------- ������ �� (���� ����)
    uu := GetFR3(ObCI[3],bP[32],bP[31]);    //---------------- ������ �� (���� ����������)
    bP[3] := GetFR3(ObCI[4],bP[32],bP[31]); //- ������ ��� (���� �������� �� ������������)

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31]; OVBuffer[VBufInd].Param[1] := bP[32];
      if bP[31] and not bP[32] then
      begin
        PUT := BasOb;
        if uu <> bP[2] then
        begin
          if (PUT > 0) and not bP[3] and uu and not bP[4] then //���� ����������, �� ����.
          begin
            // ��������� ��������� ��������� ����� � ������������� �������� ������ �� ����
            if (not ObjZv[PUT].bP[2] and not ObjZv[PUT].bP[4]) or  //- ���� �� ��� ��� ���
            (not ObjZv[PUT].bP[3] and not ObjZv[PUT].bP[15]) then //----------- �� ��� ���
            begin
              bP[4] := true; //--------------------------------------------------- �������
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if config.ru = RU then
                begin
                  //---------- ���������� ��������� ���� $ ��� ��������� �������� ��������
                  InsNewMsg(UTS,495+$2000,1,'');
                  AddFixMes(GetSmsg(1,495,ObjZv[BasOb].Liter,1),4,3);
                end;
{$ELSE}
                InsNewMsg(UTS,495+$2000,1,'');
{$ENDIF}
              end;
            end;
          end;

          if uu and not bP[1] then
          begin //-------------------------------------------------------- ���� ����������
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UTS,108+$2000,1,''); //------------------ ���������� ��������� ����
                AddFixMes(GetSmsg(1,108,ObjZv[BasOb].Liter,1),0,2);
              end;
{$ELSE}
              InsNewMsg(UTS,108+$2000,1,'');
{$ENDIF}
            end;
          end;
        end;
        bP[2] := uu;

        if not (uu xor bP[1]) then
        begin //--------------------------------------------------- ��� �������� ���������
          if (PUT > 0) and not bP[3] and not bP[4] then
          begin
            if (not ObjZv[BasOb].bP[2] and not ObjZv[BasOb].bP[4]) or
            (not ObjZv[BasOb].bP[3] and not ObjZv[BasOb].bP[15]) then
            begin //-------- ��������� ��������� ��������� ����� � �������� ������ �� ����
              bP[4] := true;
              if WorkMode.FixedMsg then
              begin
{$IFDEF RMDSP}
                if config.ru = RU then
                begin
                  //-- �������� ��������� ���������� ����� ��� ��������� �������� ��������
                  InsNewMsg(UTS,496+$2000,1,'');
                  AddFixMes(GetSmsg(1,496,ObjZv[BasOb].Liter,1),4,3);
                end;
{$ELSE}
                InsNewMsg(UTS,496+$2000,1,'');
{$ENDIF}
              end;
            end;
          end;
          if not WorkMode.FixedMsg then bP[4] := true; //--- ����������� �� ������ �������
          if not bP[4] then
          begin //--------------------------- �� ������������� ��������� � ������ ��������
            if T[1].Activ  then
            begin
              if T[1].F < LastTime then
              begin //---------------------- ������������� ������ �������� ��������� �����
                bP[4] := true;
{$IFDEF RMDSP}
                if config.ru = RU then
                begin
                  InsNewMsg(UTS,109+$1000,1,''); //��������� ���� �� ����� �������� ���������
                  AddFixMes(GetSmsg(1,109,ObjZv[BasOb].Liter,1),4,1);
                end;
{$ELSE}
                InsNewMsg(UTS,109+$1000,1,'');
                SBeep[1] := true;
{$ENDIF}
              end;
            end else
            begin //------------------------------------------------ ������ ������ �������
              T[1].F := LastTime+ 15/86400;
              T[1].Activ  := true;
            end;
          end;
        end else
        begin
          T[1].Activ  := false;
          bP[4] := false;
        end;
        OVBuffer[VBufInd].Param[2] := bP[1];
        OVBuffer[VBufInd].Param[3] := bP[2];
        OVBuffer[VBufInd].Param[4] := bP[3];
      end;
    end;
  end;
end;

//========================================================================================
//-------------------- ���������� ������� ������� ��������� ������� ��� ������ �� ����� #9
procedure PrepRZS(RZST : Integer);
var
  rz,dzs,odzs : boolean;
  ii,cod,Vbufer,DatRZ,DatDZS,DatODZS,Ns,Alr,Clr: integer;
  TXT : string;
begin
  with ObjZv[RZST]do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    DatRZ  := ObCI[6];    DatDZS := ObCI[2];   DatODZS := ObCI[4]; //---- ������� ��������
    for ii := 1 to 32 do NParam[ii] := false; //----------------------------- ������������

    rz :=  GetFR3(DatRZ,NParam[1],bP[31]);
    if  DatDZS > 0 then dzs := GetFR3(DatDZS,NParam[2],bP[31])   else  dzs := rz;
    if DatODZS > 0 then odzs := GetFR3(DatODZS,NParam[3],bP[31]) else odzs := rz;

    cod := 0;

    if VBufInd > 0 then
    begin
      Vbufer := VBufInd; OVBuffer[Vbufer].Param[16] := bP[31];

      if bP[31] then
      begin
        if rz then cod:= cod + 1; if dzs then cod:= cod + 2; if odzs then cod:= cod + 4;

        bP[1] := rz;
        OVBuffer[Vbufer].Param[2]:= rz; OVBuffer[VBufer].NParam[2]:= NParam[1]; //----- ��

        bP[2] := dzs;
        OVBuffer[VBufer].Param[3]:= dzs;  OVBuffer[VBufer].NParam[3]:= NParam[2]; //-- ���

        bP[3] := odzs;
        OVBuffer[VBufer].Param[4]:= odzs; OVBuffer[VBufer].NParam[4]:= NParam[3]; //- ����

        if cod <> iP[1] then //-------------------------- ���� ��������� ��� ��������� ���
        begin
          if not T[1].Activ then begin T[1].Activ:= true;T[1].F:= LastTime + 2/86400; end;
        end;

        if T[1].Activ and (LastTime > T[1].F) then
        begin
        {$IFDEF RMDSP}
          if WorkMode.FixedMsg and (config.ru=RU) and not WorkMode.RU[0] then
          case cod of
            0    : begin Ns := 559; Clr := 7; Alr := 2; end; //------------- ��� ���������
            1    : begin Ns := 560; Clr := 1; Alr := 3; end; //-- ��� �������� ��� �������
            2,4,6: begin Ns := 561; Clr := 1; Alr := 3; end;//��� �������� ��� �� ��������
            5    : begin Ns := 562; Clr := 7; Alr := 2; end;//------ ����.������� ����.���
            3,7  : begin Ns := 558; Clr := 7; Alr := 2; end; //--- ��������� ��������� ���
          end;
          InsNewMsg(RZST,Ns+$2000,Clr,'');
          TXT := GetSmsg(1,Ns,Liter,Clr);
          if Alr = 2 then AddFixMes(TXT,0,Alr) else AddFixMes(TXT,4,Alr);
          PutSMsg(Clr,LastX,LastY,TXT);
          SBeep[2] := WorkMode.Upravlenie;
          {$ELSE}
          case cod of
            0       : begin Ns := 559; Clr := 7; end; //-------------------- ��� ���������
            1       : begin Ns := 560; Clr := 1; end; //--------- ��� �������� ��� �������
            2,3,4,6 : begin Ns := 561; Clr := 1; end; //----- ��� �������� ��� �� ��������
            5       : begin Ns := 562; Clr := 1; end; //-- ��������� ����.������� ����.���
            7       : begin Ns := 558; Clr := 7; end; //---------- ��������� ��������� ���
          end;
          InsNewMsg(RZST,Ns+$2000,Clr,'');
          SBeep[3] := true;
{$ENDIF}
          T[1].Activ  := false;
          T[1].F := 0;
        end;
        iP[1] := cod;
      end;
    end;
  end;
end;

//========================================================================================
//------------------------ ���������� ������� ���������� ��������� ��� ������ �� ����� #10
procedure PrepUPer(UPER : Integer);
var
  rz : boolean;
  VBUF,ii, Zp, Piv, Uzp, Uzpd : integer;
begin
  Zp   := ObjZv[UPER].ObCI[10];
  Piv  := ObjZv[UPER].ObCI[11];
  Uzp  := ObjZv[UPER].ObCI[12];
  Uzpd :=  ObjZv[UPER].ObCI[13];
  for ii := 1 to 32  do ObjZv[UPER].NParam[ii] := false;//----------------- ��������������

  ObjZv[UPER].bP[31] := true; //---------------------------------------------- �����������
  rz := GetFR3(Zp,ObjZv[UPER].NParam[10],ObjZv[UPER].bP[31]); //----------------------- ��
  ObjZv[UPER].bP[11] := GetFR3(Piv,ObjZv[UPER].NParam[11],ObjZv[UPER].bP[31]); //----- ���
  ObjZv[UPER].bP[12] := GetFR3(Uzp,ObjZv[UPER].NParam[12],ObjZv[UPER].bP[31]); //----- ���
  ObjZv[UPER].bP[13] := GetFR3(Uzpd,ObjZv[UPER].NParam[13],ObjZv[UPER].bP[31]);//---- ����

  if ObjZv[UPER].VBufInd > 0 then
  begin
    VBUF := ObjZv[UPER].VBufInd;
    if ObjZv[UPER].bP[31] then
    begin
      OVBuffer[VBUF].Param[12]  := ObjZv[UPER].bP[12]; //----------------------------- ���
      OVBuffer[VBUF].NParam[12] := ObjZv[UPER].NParam[12]; //------------------------- ���

      OVBuffer[VBUF].Param[13] := ObjZv[UPER].bP[13]; //----------------------------- ����
      OVBuffer[VBUF].NParam[13] := ObjZv[UPER].NParam[13]; //--------- �������������� ����

      if rz <> ObjZv[UPER].bP[10] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPER].RU then
            begin
              InsNewMsg(UPER,575+$2000,0,''); //----------------------------------- ������ ��
              AddFixMes(GetSmsg(1,575,ObjZv[UPER].Liter,0),0,2);
            end;
{$ELSE}
            InsNewMsg(UPER,575+$2000,0,'');
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPER].RU then
            begin
              InsNewMsg(UPER,576+$2000,0,'');  //------------------- ����������� ������ ��
              AddFixMes(GetSmsg(1,576,ObjZv[UPER].Liter,0),0,2);
            end;
{$ELSE}
            InsNewMsg(UPER,576+$2000,0,'');
{$ENDIF}
          end;
        end;
      end;

      ObjZv[UPER].bP[10] := rz;
      OVBuffer[VBUF].Param[10] := ObjZv[UPER].bP[10];
      OVBuffer[VBUF].NParam[10] := ObjZv[UPER].NParam[10];

{$IFDEF RMDSP}
      if config.ru = ObjZv[UPER].RU then
      begin
        if rz then
        begin //----------------------------------------------------------- ������� ������
          if ObjZv[UPER].T[1].Activ  then
          begin
            if ObjZv[UPER].T[1].F < LastTime then
            begin //-------- ������ ��������� � ���������� �������� �������� ��� ������ ��
              if not ObjZv[UPER].bP[5] then
              begin
                InsNewMsg(UPER,514+$2000,0,''); //---- ������� ��������� ������ ������� ��
                AddFixMes(GetSmsg(1,514,ObjZv[UPER].Liter,0),4,4);
                ObjZv[UPER].T[1].F := LastTime + 60 / 86400;//---- �������� ����������
                ObjZv[UPER].bP[5] := true;
              end;
            end else ObjZv[UPER].bP[5] := false;
          end else
          begin //----------------------------------- ������ �������� ���������� ���������
            ObjZv[UPER].T[1].F := LastTime + 600 / 86400;
            ObjZv[UPER].T[1].Activ  := true;
          end;
        end else
        begin //----------------------------------------------------------- ������� ������
          ObjZv[UPER].T[1].Activ  := false;
          ObjZv[UPER].bP[5] := false;//------ ����� �������� ����������� �������� �������
        end;
      end;
{$ENDIF}

      OVBuffer[VBUF].Param[11] := ObjZv[UPER].bP[11]; //------------------------------- ��
      OVBuffer[VBUF].NParam[11] := ObjZv[UPER].NParam[11]; //-------------------------- ��
    end;
    OVBuffer[VBUF].Param[16] := ObjZv[UPER].bP[31];
  end;
end;

//========================================================================================
//------------------------ ���������� ������� ��������(1) �������� ��� ������ �� ����� #11
procedure PrepKPer(KPER : Integer);
var
  Npi,Cpi,kop,knp,kap,zg,kzp,Nepar : boolean;
  ii : integer;
begin
  ObjZv[KPER].bP[31] := true; //---------------------------------------------- �����������
  Nepar := false;  //------------------------------------------------------ ��������������

  kap :=  GetFR3(ObjZv[KPER].ObCI[2],Nepar,ObjZv[KPER].bP[31]); //--------------- ���
  ObjZv[KPER].NParam[2] := Nepar;

  Nepar := false;  //------------------------------------------------------ ��������������
  knp := GetFR3(ObjZv[KPER].ObCI[3],Nepar,ObjZv[KPER].bP[31]); //---------------- ���
  ObjZv[KPER].NParam[3] := Nepar;

  Nepar := false;  //------------------------------------------------------ ��������������
  kzp :=  GetFR3(ObjZv[KPER].ObCI[4],Nepar,ObjZv[KPER].bP[31]); //--------------- ���
  ObjZv[KPER].NParam[4] := Nepar;

  Nepar := false;  //------------------------------------------------------ ��������������
  zg := GetFR3(ObjZv[KPER].ObCI[14],Nepar,ObjZv[KPER].bP[31]);//------------------ ��
  ObjZv[KPER].NParam[14] := Nepar;

  Nepar := false;  //------------------------------------------------------ ��������������
  kop := GetFR3(ObjZv[KPER].ObCI[9],Nepar,ObjZv[KPER].bP[31]); //---------------- ���
  ObjZv[KPER].NParam[9] := Nepar;

  Nepar := false;  //------------------------------------------------------ ��������������
  Npi := GetFR3(ObjZv[KPER].ObCI[8],Nepar,ObjZv[KPER].bP[31]); //---------------- ���
  ObjZv[KPER].NParam[8] := Nepar;

  Nepar := false;  //------------------------------------------------------ ��������������
  Cpi := GetFR3(ObjZv[KPER].ObCI[10],Nepar,ObjZv[KPER].bP[31]); //--------------- ���
  ObjZv[KPER].NParam[10] := Nepar;

  ObjZv[KPER].bP[8] := Npi or Cpi;
  ObjZv[KPER].bP[9] := kop;

  if ObjZv[KPER].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[KPER].VBufInd].Param[16] := ObjZv[KPER].bP[31];
    if ObjZv[KPER].bP[31] then
    begin
      if kap <> ObjZv[KPER].bP[2] then
      begin
        if kap then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,143+$1000,0,'');  //---------------------- "������ ��������"
              AddFixMes(GetSmsg(1,143,ObjZv[KPER].Liter,0),4,3);
              SBeep[3] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,143+$1000,0,'');
{$ENDIF}
          end;
        end;
      end;

      ObjZv[KPER].bP[2] := kap;
      OVBuffer[ObjZv[KPER].VBufInd].Param[2] := ObjZv[KPER].bP[2]; //------------ ���
      OVBuffer[ObjZv[KPER].VBufInd].NParam[2] := ObjZv[KPER].NParam[2]; //------- ���
      if knp <> ObjZv[KPER].bP[3] then
      begin
        if knp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,144+$1000,0,''); //----------------- "������������� ��������"
              AddFixMes(GetSmsg(1,144,ObjZv[KPER].Liter,0),4,4);
              SBeep[4] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,144+$1000,0,'');
{$ENDIF}
          end;
        end;
      end;
      ObjZv[KPER].bP[3] := knp;
      OVBuffer[ObjZv[KPER].VBufInd].Param[3] := ObjZv[KPER].bP[3]; //------------ ���
      OVBuffer[ObjZv[KPER].VBufInd].NParam[3] := ObjZv[KPER].NParam[3]; //------- ���

      if kzp <> ObjZv[KPER].bP[4] then
      begin
        if kzp then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,371+$2000,0,''); //------------------------ "������ �������"
              AddFixMes(GetSmsg(1,371,ObjZv[KPER].Liter,0),4,4);
              SBeep[4] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,371+$2000,0,'');
{$ENDIF}
          end;
        end else
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,372+$2000,0,''); //------------------------- "������ �������"
              AddFixMes(GetSmsg(1,372,ObjZv[KPER].Liter,0),0,4);
              SBeep[4] := true;
            end;
{$ELSE}
            InsNewMsg(KPER,372+$2000,0,'');
{$ENDIF}
          end;
        end
      end;
      ObjZv[KPER].bP[4] := kzp;
      OVBuffer[ObjZv[KPER].VBufInd].Param[4] := ObjZv[KPER].bP[4]; //------------ ���
      OVBuffer[ObjZv[KPER].VBufInd].NParam[4] := ObjZv[KPER].NParam[4]; //------- ���

      if zg <> ObjZv[KPER].bP[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER].RU then
            begin
              InsNewMsg(KPER,107+$2000,0,'');//"�������� ������. ������������ �� ��������"
              AddFixMes(GetSmsg(1,107,ObjZv[KPER].Liter,0),4,4);
            end;
{$ELSE}
            InsNewMsg(KPER,107+$2000,0,''); SBeep[4] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[KPER].bP[14] := zg;
      OVBuffer[ObjZv[KPER].VBufInd].Param[14] := ObjZv[KPER].bP[14]; //------------��
      OVBuffer[ObjZv[KPER].VBufInd].Param[4] := ObjZv[KPER].bP[4];  //----------- ���
      OVBuffer[ObjZv[KPER].VBufInd].Param[9] := ObjZv[KPER].bP[9];  //----------- ���
      OVBuffer[ObjZv[KPER].VBufInd].Param[8] := ObjZv[KPER].bP[8];  //------------ ��
      OVBuffer[ObjZv[KPER].VBufInd].NParam[14] := ObjZv[KPER].NParam[14]; //-------��
      OVBuffer[ObjZv[KPER].VBufInd].NParam[4] := ObjZv[KPER].NParam[4];  //------ ���
      OVBuffer[ObjZv[KPER].VBufInd].NParam[9] := ObjZv[KPER].NParam[9];  //------ ���
      OVBuffer[ObjZv[KPER].VBufInd].NParam[8] := ObjZv[KPER].NParam[8];  //------- ��
    end;
  end;
end;

//========================================================================================
//------------------------ ���������� ������� ��������(2) �������� ��� ������ �� ����� #12
procedure PrepK2Per(KPER2 : Integer);
var
  knp,knzp,kop,zg : Boolean;
  ii : integer;
begin
  ObjZv[KPER2].bP[31] := true; //-------------------- ����������� �������������� �����������

  for ii := 2 to 14 do  ObjZv[KPER2].NParam[ii] := false; //--- �������������� ������ �����

  knp :=   //------------------------------------------------------ ������������� ��������
  GetFR3(ObjZv[KPER2].ObCI[3],ObjZv[KPER2].NParam[3],ObjZv[KPER2].bP[31]);// ���/���

  knzp :=  //--------------------------------------------------------- ���������� ��������
  GetFR3(ObjZv[KPER2].ObCI[4],ObjZv[KPER2].NParam[4],ObjZv[KPER2].bP[31]);//����/���

  zg :=  //--------------------------------------------------------- �������������� ������
  GetFR3(ObjZv[KPER2].ObCI[14],ObjZv[KPER2].NParam[14],ObjZv[KPER2].bP[31]); //-- ��

  if ObjZv[KPER2].ObCI[9] >0  then //---------------------- ���� ���������� ������ ���
  kop := //----------------------------------------------------------- ���������� ��������
  GetFR3(ObjZv[KPER2].ObCI[9],ObjZv[KPER2].NParam[9],ObjZv[KPER2].bP[31]) //--- ���
  else kop := not knzp; //------------------------- ���� ������� ��� ���, �� �������� ����

  ObjZv[KPER2].bP[8] := //------------------------------------------ �������� ���������
  GetFR3(ObjZv[KPER2].ObCI[8],ObjZv[KPER2].NParam[8],ObjZv[KPER2].bP[31]); //--- ���

  ObjZv[KPER2].bP[10] := //------------------------------------------- ������ ���������
  GetFR3(ObjZv[KPER2].ObCI[10],ObjZv[KPER2].NParam[10],ObjZv[KPER2].bP[31]);//-- ���

  if ObjZv[KPER2].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[KPER2].VBufInd].Param[16] := ObjZv[KPER2].bP[31];

    if ObjZv[KPER2].bP[31] then
    begin
      if knp <> ObjZv[KPER2].bP[3] then
      begin //----------------------------- ��������� �� ������� ������������� �� ��������
        if knp then
        begin //----------------------------- ������������� ������� �������� -> ����������
          ObjZv[KPER2].T[2].F := LastTime + 10/86400; //------- �������� ������ �� 10 ���.
          ObjZv[KPER2].T[2].Activ  := true;  //-------------------------- ��������� ������
        end else
        begin //----------------------------- ������������� ������� ���������� -> ��������
          ObjZv[KPER2].T[2].F := 0;
          ObjZv[KPER2].T[2].Activ := false;
          ObjZv[KPER2].bP[3] := false; //------- �������� ��������� ������������� ��������
          ObjZv[KPER2].bP[3] := knp;
        end;
      end;


      if not ObjZv[KPER2].bP[3] and ObjZv[KPER2].T[2].Activ  then
      begin //-------------------- �������� 10 ������ �� ������� ������������� �� ��������
        if ObjZv[KPER2].T[2].F < LastTime then
        begin //------------------------------------- ���������� ������������� �� ��������
          ObjZv[KPER2].bP[3] := true;
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER2].RU then
            begin
              InsNewMsg(KPER2,144+$1000,0,''); //"������������� �� ��������"
              AddFixMes(GetSmsg(1,144,ObjZv[KPER2].Liter,0),4,4);
            end;
{$ELSE}
            InsNewMsg(KPER2,144+$1000,0,''); SBeep[4] := true;
{$ENDIF}
          end;
        end;
      end;

      if knzp and not kop then //--------------------- ������� �������� ��������� ��������
      begin
        ObjZv[KPER2].bP[4] := true; //--------------------------------------------- ���
        ObjZv[KPER2].bP[9] := false; //-------------------------------------------- ���
        ObjZv[KPER2].bP[2] := false;  //------------------------------------------- ���
        ObjZv[KPER2].T[1].F := 0;
        ObjZv[KPER2].T[1].Activ  := false;
        ObjZv[KPER2].bP[6] := false;  //---------------------------------- �������� ���
      end else
      if kop and not knzp then //--------------------- ������� �������� ��������� ��������
      begin
        ObjZv[KPER2].bP[4] := false; //-------------------------------------------- ���
        ObjZv[KPER2].bP[9] := true; //--------------------------------------------- ���
        ObjZv[KPER2].bP[2] := false; //-------------------------------------------- ���
        ObjZv[KPER2].T[1].F := 0;
        ObjZv[KPER2].T[1].Activ  := false;
        ObjZv[KPER2].bP[6] := false; //----------------------------------- �������� ���
      end else
      begin //--------------------------------------------------------- ������ �� ��������
        if not ObjZv[KPER2].T[1].Activ  then
        begin //------------------------------- ������������� ��������� �������� -> ������
          ObjZv[KPER2].T[1].F := LastTime+10/86400;
          ObjZv[KPER2].T[1].Activ  := true;
          ObjZv[KPER2].bP[6] := true;     //�������� ���
        end else
        if not ObjZv[KPER2].bP[2] then   // ���
        begin // ������� 10 ������ �� ������� ������ �� ��������
          if ObjZv[KPER2].T[1].F < LastTime then
          begin // ���������� ������ �� ��������
            ObjZv[KPER2].bP[1] := true;
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[KPER2].RU then
               begin
                InsNewMsg(KPER2,143+$1000,0,'');      // "������ ��������"
                AddFixMes(GetSmsg(1,143,ObjZv[KPER2].Liter,0),4,3);
              end;
{$ELSE}
              InsNewMsg(KPER2,143+$1000,0,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        ObjZv[KPER2].bP[4] := false;    //���
        ObjZv[KPER2].bP[9] := false;    //���
      end;

      OVBuffer[ObjZv[KPER2].VBufInd].Param[16] := ObjZv[KPER2].bP[31];

      for ii := 1 to 30 do
      OVBuffer[ObjZv[KPER2].VBufInd].NParam[ii] := ObjZv[KPER2].NParam[ii];

      OVBuffer[ObjZv[KPER2].VBufInd].Param[2] := ObjZv[KPER2].bP[2]; //���

      if ObjZv[KPER2].bP[3] then // ������ �� ��������
      OVBuffer[ObjZv[KPER2].VBufInd].Param[3] := ObjZv[KPER2].bP[2]
      else // ������������� �� ��������
        OVBuffer[ObjZv[KPER2].VBufInd].Param[3] := ObjZv[KPER2].bP[3];  //���
      OVBuffer[ObjZv[KPER2].VBufInd].Param[4] := ObjZv[KPER2].bP[4];    //���
      if zg <> ObjZv[KPER2].bP[14] then
      begin
        if zg then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[KPER2].RU then begin
              InsNewMsg(KPER2,107+$2000,0,''); //"�������� ������. ������������ �� ��������"
              AddFixMes(GetSmsg(1,107,ObjZv[KPER2].Liter,0),4,4);
            end;
{$ELSE}
            InsNewMsg(KPER2,107+$2000,0,''); SBeep[4] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[KPER2].bP[14] := zg;
      OVBuffer[ObjZv[KPER2].VBufInd].Param[14] := ObjZv[KPER2].bP[14];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[9] := ObjZv[KPER2].bP[9];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[4] := ObjZv[KPER2].bP[4];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[8] := ObjZv[KPER2].bP[8];
      OVBuffer[ObjZv[KPER2].VBufInd].Param[10] := ObjZv[KPER2].bP[10];
    end;
  end;
end;

//========================================================================================
//------------------------- ���������� ������� ���������� �������� ��� ������ �� ����� #13
procedure PrepOM(OPV : Integer);
var
  nepar,rz,rrm,vod,vo : boolean;
  i : integer;
begin
  with ObjZv[OPV] do
  begin
    bP[31] := true;  bP[32] := false; //------------------------����������� ��������������
    for i := 1 to 34 do NParam[i] := false;

    rz    := GetFR3(ObCI[2],NParam[2],bP[31]);//---------------------------------- ��(���)
    rrm   := GetFR3(ObCI[3],NParam[3],bP[31]);//-------------------------------------- ���
    bP[4] := GetFR3(ObCI[4],NParam[4],bP[31]);//--------------------------------- ���(���)
    bP[5] := GetFR3(ObCI[5],NParam[5],bP[31]);//--------------------------------- ���(���)
    vo    := GetFR3(ObCI[6],NParam[6],bP[31]);//--------------------------------------- �o
    vod   := GetFR3(ObCI[7],NParam[7],bP[31]);//-------------------------------------- ���

    for i := 2 to 7 do nepar := nepar or NParam[i];
    bp[32] := nepar;

    if VBufInd > 0 then
    begin
      for i := 1 to 32 do OVBuffer[VBufInd].NParam[i] := NParam[i];
      OVBuffer[VBufInd].Param[16] := bP[31];
      OVBuffer[VBufInd].Param[1] := bP[32];

      if bP[31] and not nepar then
      begin
        if rz <> bP[2] then //----------------------------------------- ���� ���������� ��
        begin
          if rz then //----------------------------------------------------------- ���� ��
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObCB[1] then
              begin //--------------------------------------------------- ������������ ���
                if bP[3] and (config.ru = RU) then
                begin
                  InsNewMsg(OPV,374+$2000,7,'');  //------------ ��������� ���������� "�����"
                  AddFixMes(GetSmsg(1,374,Liter,7),0,2);
                end;
              end else
              begin
                if config.ru = ObjZv[OPV].RU then
                begin
                  InsNewMsg(OPV,373+$2000,7,''); //------------- �������� ���������� "�����"
                  AddFixMes(GetSmsg(1,373,Liter,7),0,2);
                end;
              end;
{$ELSE}     //----------------------------------------------------------------- ��� ��� ��
              if ObCB[1] then InsNewMsg(OPV,374+$2000,7,'')
              else InsNewMsg(OPV,373+$2000,7,'');
{$ENDIF}
            end;
          end else
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ObCB[1] then
              begin //--------------------------------------------------- ������������ ���
                if rrm and (config.ru = RU) then
                begin
                  InsNewMsg(OPV,373+$2000,1,'');
                  AddFixMes(GetSmsg(1,373,Liter,1),0,2);
                end;
              end else
              begin
                if config.ru = RU then
                begin
                  InsNewMsg(OPV,374+$2000,1,'');
                  AddFixMes(GetSmsg(1,374,Liter,1),0,2);
                end;
              end;
{$ELSE}
              if ObCB[1] then InsNewMsg(OPV,373+$2000,1,'')
              else InsNewMsg(OPV,374+$2000,1,'');
{$ENDIF}
            end;
          end;
        end;

        ObjZv[OPV].bP[2] := rz;

        if ObCB[1] and( rrm <> bP[3])then
        //��� ������������� ��� ����������� ����� ���������� ��� ������.���������� "�����"
        begin
          if not rrm and not rz and WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then AddFixMes(GetSmsg(1,374,Liter,1),0,2); {$ENDIF}
            InsNewMsg(OPV,374+$2000,1,'')
          end;
        end;
        bP[3] :=  rrm;

      //----------------------------------------------------------------- ������������ ���
        if ObCB[1] then  OVBuffer[VBufInd].Param[3] :=  not bP[2] and bP[3]
        else  OVBuffer[VBufInd].Param[3] := bP[2]; //------------------------------------ ��

        if (vo <> bP[6]) or (vod <> bP[7]) then //--------- �� ��� ���
        if WorkMode.FixedMsg then
        begin
          if (not vo  and not vod) then
          begin
            InsNewMsg(OPV,534+$2000,7,'');    //-------------- "�������� ������ �������� "
            AddFixMes(GetSmsg(1,534,Liter,7),0,2);
          end;
        end else
        if(vo and vod) then
        begin
          InsNewMsg(OPV,518+$2000,7,''); //--------------------- "������� ������ ��������"
          AddFixMes(GetSmsg(1,518,Liter,1),0,2);
        end;
      end;

      ObjZv[OPV].bP[6] := vo;
      ObjZv[OPV].bP[7] := vod;
      OVBuffer[VBufInd].Param[6] := bP[6];
      OVBuffer[VBufInd].Param[7] := bP[7];

      OVBuffer[VBufInd].Param[2] := bP[2]; //----------------------------- ���
      OVBuffer[VBufInd].Param[4] := bP[4]; //----------------------------- ���
      OVBuffer[VBufInd].Param[5] := bP[5]; //----------------------------- ���
    end;
  end;
end;

//========================================================================================
//--------------------------------------- ���������� ������� ����� ��� ������ �� ����� #14
procedure PrepUKSPS(UKS : Integer);
var
  d1,d2,kzk1,kzk2,dvks : boolean;
begin
  with ObjZv[UKS] do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    bP[32] := false; //---------------------------------------------------- ��������������
    bP[1] := GetFR3(ObCI[2],bP[32],bP[31]); //---------------------------------------- ���
    bP[2]:=GetFR3(ObCI[3],bP[32],bP[31]); //--------------------------------- ����.�������
    d1 :=  GetFR3(ObCI[4],bP[32],bP[31]); //------------------------------------------ 1��
    d2 :=  GetFR3(ObCI[5],bP[32],bP[31]); //------------------------------------------ 2��
    kzk1 := GetFR3(ObCI[6],bP[32],bP[31]); //---------------------------------------- ���1
    kzk2 := GetFR3(ObCI[7],bP[32],bP[31]); //---------------------------------------- ���2
    bP[7]:= GetFR3(ObCI[8],bP[32],bP[31]); //-----------------------------------------����

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31];
      OVBuffer[VBufInd].Param[1] := bP[32];

      if bP[31] and not bP[32] then
      begin
        if d1 <> bP[3] then //------------------------------- ������ 1�� ������� ���������
        begin
          if d1 then
            begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,125+$1000,0,''); //------------------ �������� ������1 �����
                AddFixMes(GetSmsg(1,125,Liter,0),4,3);
              end;
{$ELSE}
              InsNewMsg(UKS,125+$1000,0,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[3] := d1;
        OVBuffer[VBufInd].Param[2] := bP[3];

        if d2 <> bP[4] then  //------------------------------ ������ 2�� ������� ���������
        begin
          if d2 then
          begin
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,126+$1000,0,''); //---------------- �������� ������2 ����� $
                AddFixMes(GetSmsg(1,126,Liter,0),4,3);
              end;
{$ELSE}
              InsNewMsg(UKS,126+$1000,0,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[4] := d2;
        OVBuffer[VBufInd].Param[3] := bP[4];

        if kzk1 <> bP[5] then
        begin
          if kzk1 then
          begin //-------------------------------------------- ������������� �����-1 �����
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,127+$1000,1,''); //------------------- ������������� �����-1
                AddFixMes(GetSmsg(1,127,Liter,1),4,3);
                sMsgCvet[1] := 0;
              end;
{$ELSE}
              InsNewMsg(UKS,127+$1000,1,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[5] := kzk1;
        OVBuffer[VBufInd].Param[4] := bP[5];

        if kzk2 <> bP[6] then
        begin
          if kzk2 then
          begin //-------------------------------------------- ������������� �����-2 �����
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = RU then
              begin
                InsNewMsg(UKS,525+$1000,1,''); //----------------- ������������� �����-2 $
                AddFixMes(GetSmsg(1,525,Liter,1),4,3);
                sMsgCvet[1] := 0;
              end;
{$ELSE}
              InsNewMsg(UKS,525+$1000,1,'');
              SBeep[3] := true;
{$ENDIF}
            end;
          end;
        end;
        bP[6] := kzk2;
        OVBuffer[VBufInd].Param[8] := bP[6];
        OVBuffer[VBufInd].Param[9] := bP[7];
        OVBuffer[VBufInd].Param[5] := bP[1];
        OVBuffer[VBufInd].Param[6] := bP[2];
      end;
    end;
  end;
end;

//========================================================================================
//--------------- ���������� ������� ����� ����������� �� �������� ��� ������ �� ����� #15
procedure PrepAB(AB : Integer);
var
  kj,ip1,ip2,zs : boolean;
  VBUF : integer;
begin
  ObjZv[AB].bP[31] := true; ObjZv[AB].bP[32] := false; //-----  �����������,��������������
  with ObjZv[AB] do
  begin
    VBUF := VBufInd;
    bP[1] :=      GetFR3(ObCI[2],bP[32],bP[31]);//-------------------------------------- �
    ip1   :=  not GetFR3(ObCI[3],bP[32],bP[31]);//------------------------------------ 1��
    ip2   :=  not GetFR3(ObCI[4],bP[32],bP[31]); //----------------------------------- 2��
    bP[4] :=      GetFR3(ObCI[5],bP[32],bP[31]); //------------------------------------ ��
    bP[5] :=  not GetFR3(ObCI[6],bP[32],bP[31]); //------------------------------------ ��
    kj     := not GetFR3(ObCI[7], bP[32],bP[31]); //----------------------------------- ��
    bP[7]  :=     GetFR3(ObCI[8], bP[32],bP[31]);//------------------------------------ �1
    zs     :=     GetFR3(ObCI[9], bP[32],bP[31]); //---------------------------- ������ ��
    bP[16] :=     GetFR3(ObCI[10],bP[32],bP[31]);//------------------------------------- �
    bP[8]  :=     GetFR3(ObCI[11],bP[32],bP[31]);   //--------------------------------- �2
    bP[11] :=     GetFR3(ObCI[12],bP[32],bP[31]);//------------------------------  ���/���
    bP[17] :=     GetFR3(ObCI[13],bP[32],bP[31]);//--------------------------- �������� ��

    if VBUF > 0 then
    begin
      OVBuffer[VBUF].Param[16] := bP[31]; OVBuffer[VBUF].Param[1] := bP[32];
      if bP[31] and not bP[32] then
      begin
        OVBuffer[VBUF].Param[5] := bP[5]; //------------------------------ �� � ����������
        if zs <> bP[10] then
        begin //-------------------------------------- ������� ������ �� ����� �����������
          if bP[4] and WorkMode.FixedMsg then
          begin //------------------------------------------------- ������� �� �����������
            {$IFDEF RMDSP}
            if RU = config.ru then
            begin   {$ENDIF}
              if zs then
              begin
                InsNewMsg(AB,439+$2000,0,'');// ������� ������ ����� ���������.�� ��������
                AddFixMes(GetSmsg(1,439,Liter,0),0,6);
              end else
              if bP[1] then //------------------------------ �� ������ ����� (� ��� �����)
              begin
                if bP[17] then InsNewMsg(AB,56+$2000,7,'') // ���� ������� ����.�� �������
                else
                begin  //----------------------------------------------------- ���� ������
                  InsNewMsg(AB,440+$2000,0,'');//���� ������ ����� ����������� �� ��������
                  AddFixMes(GetSmsg(1,440,Liter,0),0,6);
                end;
              end;
              {$IFDEF RMDSP}
            end; {$ENDIF}
          end;
        end;
        bP[10] := zs;

        if bP[17] then OVBuffer[VBUF].Param[18] := tab_page//���� ���� �������� ��- ������
        else  OVBuffer[VBUF].Param[18] := bP[10];//-------------- ������ ����� �����������

        OVBuffer[VBUF].Param[17] := bP[16]; OVBuffer[VBUF].Param[4] := not bP[11];//�, 3��

        if kj <> bP[6] then
        begin
          if kj then bP[9] := false else //----- �������� ��, ����� ����������� ���.������
          begin //--------------------------------------------------------------- ����� ��
            {$IFDEF RMDSP}
            if RU= config.ru then AddFixMes(GetSmsg(1,357,Liter,0),0,6);{$ENDIF}
            InsNewMsg(AB,357+$2000,0,''); //---------------- ����-���� $ ����� �� ��������
          end;
        end;
        bP[6] := kj;  OVBuffer[VBUF].Param[11] := bP[6];

        if ip1 <> bP[2] then
        begin
          if bP[2] then  //----------------------------------------- ������� 1 �����������
          begin
            if not bP[6] then bP[9]:= true; // ����� ����-����,���� ����������� ���.������
            if ObCB[2] then //------------------------------------- ���� ����� �����������
            begin
              if ObCB[3] then  //----------------------------------- ������������ ��������
              begin
                if ObCB[4] then  //------------------ �� ������ ���� �� ��������� ��������
                begin
                  if bP[7] and not bP[8] then
                  begin //---------------------------------------- ���� �������� ���������
                    if not bP[4] and (config.ru = RU) then IpBeep[1] := true;
                  end else //------------------------------------------- �������� ��������
                  if config.ru = RU then IpBeep[1] := true;
                end else
                if ObCB[5] then //---------------------- �� �����������, ���� �� ���������
                begin
                  if bP[8] and not bP[7] then //------------------------------- �2 � �� �1
                  begin
                    if not bP[4] and (config.ru = RU)//- �����
                    then IpBeep[1] := true;
                  end;
                end;
              end else //-------------------------------------- �������� ������� ���������
              if not bP[4] and (config.ru = RU) then IpBeep[1] := true;
            end else
            if ObCB[4] and (config.ru = RU) then IpBeep[1] := true; //-- �� ������ �������
          end;
        end;
        bP[2] := ip1; OVBuffer[VBUF].Param[2] := bP[2];

        if ip2 <> bP[3] then  //--------------------------------------- ���� ��������� ��2
        begin
          if bP[3] then  //-------------------------------------------------- ���� �������
          begin //-------------------------------------------------- ������� 2 �����������
            if ObCB[2] then  //------------------------------- ���� ���� ����� �����������
            begin
              if ObCB[3] then
              begin //---------------------------------------------- ������������ ��������
                if ObCB[4] then  //---------------------------- ���� ����� ��� �����������
                begin
                  if bP[7] and not bP[8] then //----------------------- �������� ���������
                  begin
                    if not bP[4] and (config.ru = RU) then IpBeep[2] := true; //---- �����
                  end else if config.ru = RU then IpBeep[2] := true;//-- �������� ��������
                end else
                if ObCB[5] then //------------  ���� ����������� ��� ����������� ���������
                begin
                  if bP[8] and not bP[7] then //----------------------- �������� ���������
                  begin
                    if not bP[4] and (config.ru = RU) then IpBeep[2] := true; //---- �����
                  end;
                end;
              end else //-------------------------------------- �������� ������� ���������
              if not bP[4] and (config.ru = RU) then IpBeep[2] := true; //---------- �����
            end else //--------------------------------------------- ��� ����� �����������
            if ObCB[4] and (config.ru = RU) then IpBeep[2] := true; //-- �� ������ �������
          end;
        end;
        bP[3] := ip2; OVBuffer[VBUF].Param[3] := bP[3];

        if ObCB[2] then
        begin //--------------------------------------------------- ���� ����� �����������
          OVBuffer[VBUF].Param[5] := bP[5]; //------------------------------------ �������
          if ObCB[3] then
          begin //-------------------------------- �������� ����� ����������� ������������
            if bP[7] and bP[8] then
            begin //------------------------------------------- ������� ��������� ��������
              OVBuffer[VBUF].Param[10] := false;  OVBuffer[VBUF].Param[12] := false;
            end else
            begin
              if ObCB[4] then //---------------------------------------------- ���� ������
              begin
                if bP[7] then //------------------------------------------------------ �1�
                begin
                  OVBuffer[VBUF].Param[6] := bP[1];   OVBuffer[VBUF].Param[7] := bP[4];
                  OVBuffer[VBUF].Param[10] := true;   OVBuffer[VBUF].Param[12] := true;
                end else
                if bP[8] then
                begin //-------------------------------------------------------------- �2�
                  OVBuffer[VBUF].Param[10] := false;   OVBuffer[VBUF].Param[12] := false;
                end else
                begin
                  OVBuffer[VBUF].Param[10] := false;   OVBuffer[VBUF].Param[12] := true;
                end;
              end else
              if ObCB[5] then
              begin //--------------------------------------------------- ���� �����������
                if bP[7] then
                begin //-------------------------------------------------------------- �1�
                  OVBuffer[VBUF].Param[10] := false; OVBuffer[VBUF].Param[12] := false;
                end else
                if bP[8] then
                begin //-------------------------------------------------------------- �2�
                  OVBuffer[VBUF].Param[6] := bP[1];  OVBuffer[VBUF].Param[7] := bP[4];
                  OVBuffer[VBUF].Param[10] := true;  OVBuffer[VBUF].Param[12] := true;
                end else
                begin
                  OVBuffer[VBUF].Param[10] := false; OVBuffer[VBUF].Param[12] := true;
                end;
              end;
            end;
          end else
          begin //--------------------------- �������� ����� ����������� ������� ���������
            OVBuffer[VBUF].Param[6] := bP[1]; OVBuffer[VBUF].Param[7] := bP[4];
          end;
        end;
      end;
      //------------------------------------------------------------------------------ FR4
      bP[12] := GetFR4State(ObCI[3] div 8 * 8 + 2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin //------------------------------------------------------- ��������� ����������
        if tab_page
        then OVBuffer[VBUF].Param[32] := bP[13]  else OVBuffer[VBUF].Param[32] := bP[12];
      end else
{$ENDIF}
      OVBuffer[VBUF].Param[32] := bP[12];
      if ObCB[8] or ObCB[9] then
      begin //----------------------------------------------------------- ���� �����������
        bP[27] := GetFR4State(ObCI[3] div 8 * 8 + 3);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[29] := bP[24]
          else OVBuffer[VBUF].Param[29] := bP[27];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[29] := bP[27];
        if ObCB[8] and ObCB[9] then
        begin //-------------------------------------------------- ���� 2 ���� �����������
          bP[28] := GetFR4State(ObCI[3]{ div 8 * 8});
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (RU = config.ru) then
          begin
            if tab_page then OVBuffer[VBUF].Param[31] := bP[25]
            else OVBuffer[VBUF].Param[31] := bP[28];
          end else
{$ENDIF}
          OVBuffer[VBUF].Param[31] := bP[28];
          bP[29] := GetFR4State(ObCI[3] div 8 *8 +1);
{$IFDEF RMDSP}
          if WorkMode.Upravlenie and (RU = config.ru) then
          begin
            if tab_page then OVBuffer[VBUF].Param[30] := bP[26]
            else OVBuffer[VBUF].Param[30] := bP[29];
          end else
{$ENDIF}
          OVBuffer[VBUF].Param[30] := bP[29];
        end;
      end;

      if BasOb > 0 then
      begin //---------------------------- ��������� ������ �������� ����������� ���������
        if ObjZv[BasOb].bP[2] then
        begin //-------------------------- ������ ����������- ����� ������������ ���������
          bP[14] := false; bP[15] := false; //����� ��������� �������� �������. �� �������
          //------------------------- ���� �������� ��������� ������� �� ��� �������������
        end;
      end;
    end;
  end;
end;

//========================================================================================
// ���������� ������� ��������������� ����� ����������� �� ������� ��� ������ �� ����� #16
procedure PrepVSNAB(VSN : Integer);
var
  VBUF,ij : integer;
begin
  VBUF := ObjZv[VSN].VBufInd;
  with ObjZv[VSN] do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    bP[32] := false; //---------------------------------------------------- ��������������
    for ij := 1 to 32 do NParam[ij] := false;
    bP[1] :=  GetFR3(ObCI[3],NParam[1],bP[31]);  //------------------------------------ ��
    bP[2] :=  GetFR3(ObCI[5],NParam[2],bP[31]);  //----------------------------------- ���
    bP[3] :=  GetFR3(ObCI[2],NParam[3],bP[31]);  //------------------------------------ ��
    bP[4] :=  GetFR3(ObCI[4],NParam[4],bP[31]);  //----------------------------------- ���
    bp[32] := NParam[1] and NParam[2] and NParam[3] and NParam[4];
    if  VBuf > 0 then
    begin
      OVBuffer[VBuf].Param[16] := bP[31];
      OVBuffer[VBuf].Param[1] := bP[32];
      if bP[31] then
      begin
        OVBuffer[VBuf].Param[12] := bP[3]; OVBuffer[VBuf].NParam[12] := NParam[3];
        OVBuffer[VBuf].Param[13] := bP[4]; OVBuffer[VBuf].NParam[13] := NParam[4];
        OVBuffer[VBuf].Param[14] := bP[1]; OVBuffer[VBuf].NParam[14] := NParam[1];
        OVBuffer[VBuf].Param[15] := bP[2]; OVBuffer[VBuf].NParam[15] := NParam[2];
      end;
    end;
  end;
end;

//========================================================================================
//------------ ���������� ������� ���������� �������� ���� ������� ��� ������ �� ����� #17
procedure PrepMagStr(Ptr : Integer);
var
  lar : boolean;
  i,Videobuf : integer;
begin
    Videobuf := ObjZv[Ptr].VBufInd;
    for i := 1 to 32 do
    ObjZv[Ptr].NParam[i] := false;

    ;
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- �����������
    ObjZv[Ptr].bP[32] := false; //------------------------------------ ��������������

    ObjZv[Ptr].bP[1] :=
    GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[2],ObjZv[Ptr].bP[31]);//--- ��

    ObjZv[Ptr].bP[2] :=
    GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);//-- ���

    lar :=
    GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]); //- ���

    if Videobuf > 0 then
    begin
      OVBuffer[Videobuf].Param[16] := ObjZv[Ptr].bP[31];

      for i := 2 to 30 do OVBuffer[Videobuf].NParam[i-1]:=ObjZv[Ptr].NParam[i];

      if ObjZv[Ptr].bP[31] then
      begin
        OVBuffer[Videobuf].Param[16] := ObjZv[Ptr].bP[31];
        OVBuffer[Videobuf].Param[1] := ObjZv[Ptr].bP[1]; //------- ��
        OVBuffer[Videobuf].NParam[1] :=ObjZv[Ptr].NParam[1]; //������� ��
        OVBuffer[Videobuf].Param[2] := ObjZv[Ptr].bP[2]; //------ ���
        OVBuffer[Videobuf].NParam[2]:= ObjZv[Ptr].NParam[2];//������� ���

        if lar <> ObjZv[Ptr].bP[3] then
        begin //-------------------------------------------------- ��������� ��������� ���
          if lar then
          begin //----------------------------------------------- ������������� ������� ��
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                InsNewMsg(Ptr,484+$1000,1,'');
                AddFixMes(GetSmsg(1,484,ObjZv[Ptr].Liter,1),0,1);
              end;
{$ELSE}
              InsNewMsg(Ptr,484+$1000,1,'');//------ ������������� ������� ��������� �����
{$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[3] := lar;
        OVBuffer[Videobuf].Param[3] := ObjZv[Ptr].bP[3];
      end;
    end;
end;

//========================================================================================
//------------------- ���������� ������� ���������� ������ ������� ��� ������ �� ����� #18
procedure PrepMagMakS(MagM : Integer);
var
  rz : boolean;
  VBUF : Integer;
begin
  with ObjZv[MagM] do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    bP[32] := false; //---------------------------------------------------- ��������������
    rz :=  GetFR3(ObCI[2],bP[32],bP[31]); //-------------------------------------- ��
    if bP[31] and not bP[32] then
    begin
      if rz <> bP[1] then
      begin
        if rz then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (config.ru = RU) and (maket_strelki_index > 0) then
            begin
              InsNewMsg(maket_strelki_index,377+$2000,1,'');
              AddFixMes(GetSmsg(1,377,ObjZv[maket_strelki_index].Liter,1),0,2);
            end;
{$ELSE}
            InsNewMsg(maket_strelki_index,377+$2000,1,''); //- ������� ������� $ �� ������
{$ENDIF}
          end;
        end;
      end;
    end;
    bP[1] := rz;
    if VBufInd > 0 then
    begin
      VBUF := VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      OVBuffer[VBUF].Param[1] := bP[32];
      OVBuffer[VBUF].Param[2] := bP[1];
    end;
  end;
end;

//========================================================================================
//----------------- ���������� ������� ���������� �������� ������� ��� ������ �� ����� #19
procedure PrepAPStr(AVP : Integer);
var
  rz : boolean;
  VBUF : integer;
begin
  with ObjZv[AVP] do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    bP[32] := false; //---------------------------------------------------- ��������������
    rz :=  GetFR3(ObCI[2],bP[32],bP[31]); //------------------------------------- ���

    if bP[31] and not bP[32] then
    begin
      if rz <> bP[1] then
      begin
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if config.ru = RU then
          begin
            if rz then
            begin
              InsNewMsg(AVP,378+$2000,0,''); //- ������ ������ ���������������� ��������
              AddFixMes(GetSmsg(1,378,Liter,0),0,2);
            end else
            begin
              InsNewMsg(AVP,379+$2000,0,'');// �������� ������ ���������������� ��������
              AddFixMes(GetSmsg(1,379,Liter,0),0,2);
            end;
          end;
{$ELSE}
          if rz then InsNewMsg(AVP,378+$2000,0,'')
          else InsNewMsg(AVP,379+$2000,0,'');
{$ENDIF}
        end;
      end;
      bP[1] := rz;
    end else bP[1] := false; //---------------- ����� �������� ���������������� ��������
    if VBufInd > 0 then
    begin
      VBUF := VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      OVBuffer[VBUF].Param[1] :=  bP[32];
      OVBuffer[VBUF].Param[2] := bP[1];
    end;
  end;
end;

//========================================================================================
//----------------------------- ���������� ������� �������� ������ ��� ������ �� ����� #20
procedure PrepMaket(MAK : Integer);
var
  km : boolean;
  ii,VBUF : integer;
begin
  ObjZv[MAK].bP[31] := true; //---------------------------------------- �����������
  for ii := 1 to 34 do  ObjZv[MAK].NParam[ii] := false; //-------------- ��������������

  km :=  GetFR3(ObjZv[MAK].ObCI[2],ObjZv[MAK].NParam[2],ObjZv[MAK].bP[31]);  // ��

  ObjZv[MAK].bP[3]:=GetFR3(ObjZv[MAK].ObCI[3],ObjZv[MAK].NParam[3],ObjZv[MAK].bP[31]);  // ���
  ObjZv[MAK].bP[4]:=GetFR3(ObjZv[MAK].ObCI[4],ObjZv[MAK].NParam[4],ObjZv[MAK].bP[31]);  // ���

  if ObjZv[MAK].VBufInd > 0 then
  begin
    VBUF := ObjZv[MAK].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[MAK].bP[31];

    for ii := 1 to 30 do  OVBuffer[VBUF].NParam[ii] := ObjZv[MAK].NParam[ii];

    if ObjZv[MAK].bP[31] then
    begin
      if km <> ObjZv[MAK].bP[2] then
      begin
        if km then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if (ObjZv[MAK].RU = config.ru) then
            begin
              InsNewMsg(MAK,301+$1000,0,'');
              AddFixMes(GetSmsg(1,301,'',0),0,2);
            end;
{$ELSE}
            InsNewMsg(MAK,301+$2000,0,''); //--------------------- ��������� ����� �������
{$ENDIF}
          end;
        end;
      end;
      ObjZv[MAK].bP[2] := km;

      OVBuffer[VBUF].Param[2] := ObjZv[MAK].bP[2];
      OVBuffer[VBUF].Param[3] := ObjZv[MAK].bP[3];
      OVBuffer[VBUF].Param[4] := ObjZv[MAK].bP[4];
    end;
  end;
end;

//========================================================================================
//--------------------- ���������� ������� �������� ������� ������ ��� ������ �� ����� #21
procedure PrepOtmen(OTM : Integer);
var
  om,op,os,vv : boolean;
  i,VBUF,t_os,t_om,t_op : integer;  //------------ ������� ���������, ����������, ��������
begin
  with ObjZv[OTM] do
  begin
    //------------------------- ������� ������ ����������,����������� � ��������� ��������
    t_os := ObCI[5]; t_om := ObCI[6]; t_op := ObCI[7];  //------------------ ������� �����

    bP[31] := true; bP[32] := false; //----------------------- �����������, ��������������

    NParam[2] := false;  os:= GetFR3(ObCI[2],NParam[2],bP[31]); //-------------------- ���
    if (ObCI[32] and $8) = 8 then  os := not os;

    NParam[3] := false;  om:= GetFR3(ObCI[3],NParam[3],bP[31]); //--------------------- ��
    if (ObCI[32] and $4) = 4 then  om := not om;

    NParam[4] := false; op:= GetFR3(ObCI[4],NParam[4],bP[31]); //---------------------- ��
    if (ObCI[32] and $2) = 2 then  op := not op;

    if ObCI[11]>0 then
    begin NParam[7] := false; vv:= GetFR3(ObCI[11],NParam[7],bP[31]); end; //---------- ��

    if (t_os = t_om) and not vv then
    begin Timer[t_os]:=0;T[t_os].Activ:=false;T[t_os].F:= 0;T[t_os].S:=0; end;

    NParam[4]:= false;  bP[4]:= GetFR3(ObCI[8],NParam[4],bP[31]); //------------------- ��
    NParam[5] := false; bP[5]:= GetFR3(ObCI[9],NParam[5],bP[31]); //------------------- ��
    NParam[6] := false; bP[6]:= GetFR3(ObCI[10],NParam[6],bP[31]); //------------------ ��

    if bP[31] then
    begin
      //------------------------------------------------------------- ������ �� ����������
      if ObCI[11] = 0 then //------------------------------ ���� ��� ���������� ������� ��
      begin
        if (t_os> 0) and (os <> bP[1]) then //- ���� ������ ������ �� ���������� ���������
        begin
          if T[t_os].Activ then //----------------------------- ���� ������ �� ��� �������
          begin //------------------------------------------------- ��������� ���� �������
            if t_om <> t_os then  T[t_os].Activ := false;
            {$IFDEF RMSHN}  siP[1] := Timer[t_os]; {$ENDIF}
            if t_om <> t_os then Timer[t_os] := 0;
          end else
          begin
             T[t_os].Activ := true; T[t_os].F := LastTime;
             Timer[t_os] := 0;
          end;
        end;
      end else //-------------------------------------------------- ���� ������ �� �������
      begin
        if (t_os > 0)and(vv <> bP[7]) then //-- ���� ���������� ������ �� ��������� ��� ��
        begin
          if T[t_os].Activ then //----------------------------- ���� ������ �� ��� �������
          begin //------------------------------------------------- ��������� ���� �������
            if t_os <> t_om then T[t_os].Activ := false;
            {$IFDEF RMSHN}  siP[1] := Timer[t_os]; {$ENDIF}
            if t_os <> t_om then Timer[t_os] := 0;
          end else //------------------ ������ ��� ��������, �� ������ ���� ������� � ����
          begin T[t_os].Activ := true; T[t_os].F := LastTime; Timer[t_os] := 0; end;
        end;
      end;

      //---------------------------------------------------------------- ������ ����������
      if ObCI[6] > 0 then
      begin //----------------------------------- ���� ������ ���������� ������ ����������
        if om <> bP[2] then //-------------------------------------- ���� ��������� ��� ��
        begin
          if T[t_om].Activ then //----------------------------- ���� ������ �� ��� �������
          begin //------------------------------------------------- ��������� ���� �������
            T[t_om].Activ := false;
            {$IFDEF RMSHN}   siP[2] := Timer[t_om]; {$ENDIF}
          end else //------------------ ���� ������ ��� ��������, �� ������ ���� �������
          begin T[t_om].Activ := true; T[t_om].F := LastTime; Timer[t_om] := 0; end;
        end;
      end;


      if t_om > 0 then
      begin //--------------------------------------------------- ������ ������ ����������
        if om <> ObjZv[OTM].bP[2] then
        begin
          if (t_om <> t_os) and ObjZv[OTM].T[t_om].Activ then
          begin //--------------------------------------------- ��������� ���� �������
            T[t_om].Activ := false;
            {$IFDEF RMSHN}  siP[2] := Timer[t_om]; {$ENDIF}
            Timer[t_om] := 0;
          end else
          begin //---------------------------------------------------- ������ ���� �������
            T[t_om].Activ := true;
            if t_om <> t_os then
            begin T[t_om].F := LastTime; Timer[t_om] := 0; end;
          end;
        end;
      end;



      if t_op > 0 then
      begin //--------------------------------------------------- ������ ������ ��������
        if op <> bP[3] then
        begin
          if T[t_op].Activ then
          begin //----------------------------------------------- ��������� ���� �������
            T[t_op].Activ := false;
            {$IFDEF RMSHN}  siP[3] := Timer[t_op]; {$ENDIF}
            if t_op <> t_om then Timer[t_op] := 0;
          end else //------------------------------------------------- ������ ���� �������
          begin T[t_op].Activ := true; T[t_op].F := LastTime; Timer[t_op] := 0; end;
        end;
      end;


      if T[t_os].Activ then
      begin //--------------------------- �������� �������� ������� ������ �� ����������
        Timer[t_os] := Round((LastTime - T[t_os].F)*86400);
        if Timer[t_os] > 300 then Timer[t_os] := 300;
      end;

      if (t_om <> t_os) and T[t_om].Activ then
      begin //------------------------------ �������� �������� ������� ������ ����������
        Timer[t_om] := Round((LastTime - T[t_om].F)*86400);
        if Timer[t_om] > 300  then Timer[t_om] := 300;
      end;

      if (t_op <> t_om) and T[t_op].Activ then
      begin //-------------------------------- �������� �������� ������� ������ ��������
        Timer[t_op] := Round((LastTime - T[t_op].F)*86400);
        if Timer[t_op] > 300 then Timer[t_op] := 300;
      end;
    end else
    begin //-- ����� ��������� ��� ����������� ������� ���������� ��� ��������� ����������
      if t_os > 0 then  Timer[t_os] := 0;
      T[t_os].Activ := false;
      bP[1] := false;

      if t_om > 0 then  Timer[t_om] := 0;
      T[t_om].Activ := false;
      bP[2] := false;

      if t_op > 0 then  Timer[t_op] := 0;
      T[t_op].Activ := false;
      bP[3] := false;
    end;

    bP[3] := op;
    bP[2] := om;
    bP[1] := os;
    bP[7] := vv;

    if VBufInd > 0 then
    begin
      VBUF := VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      for i := 1 to 32 do OVBuffer[VBUF].NParam[i] :=  NParam[i];
      OVBuffer[VBUF].Param[2] := bP[1];
      OVBuffer[VBUF].Param[8] := bP[7];
      OVBuffer[VBUF].Param[3] := bP[2];
      OVBuffer[VBUF].Param[4] := bP[3];
      OVBuffer[VBUF].Param[5] := bP[4];
      OVBuffer[VBUF].Param[6] := bP[5];
      OVBuffer[VBUF].Param[7] := bP[6];
    end;

  end;
end;

//========================================================================================
//----------------------------------------- ���������� ������� ��� ��� ������ �� ����� #22
procedure PrepGRI(GRI : Integer);
var
  rz : boolean;
  ii,VBUF : integer;
begin
  with ObjZv[GRI] do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    for ii := 1 to 34 do NParam[ii] := false; //--------------------------- ��������������

    rz    := GetFR3(ObCI[2], NParam[2], bP[31]);//------------------------------ ���1
    bP[3] := GetFR3(ObCI[3], NParam[3], bP[31]); //------------------------------ ���
    bP[4] := GetFR3(ObCI[4], NParam[4], bP[31]); //------------------------------- ��

    if bP[31] then
    begin
      if rz <> bP[2] then //------------------------------- ���� ���������� ��������� ���1
      begin
        if ObCI[5] > 0 then //------------ ���� ���� ������ �������������� ����������
        begin
          if T[1].Activ  then //-------------------------------------- ���� ������ �������
          begin
            T[1].Activ  := false; //------------------------------- ��������� ���� �������
            {$IFDEF RMSHN}  siP[1] := Timer[ObCI[5]]; {$ENDIF}//-- ������ �������
            Timer[ObCI[5]] := 0; //--------------------------- �������� ������ � ����
          end else  //-------------------------- ���� ������ ��������, ������ ���� �������
          begin T[1].Activ := true; T[1].F := LastTime; Timer[ObCI[5]] := 0; end;
        end;

        if rz then
        begin
          if WorkMode.FixedMsg and (config.ru = RU) then
          begin
            InsNewMsg(GRI,375+$2000,0,''); //----------------- "������ �������� �������"
            AddFixMes(GetSmsg(1,375,Liter,0),0,6);
          end;
        end;
      end;
      bP[2] := rz;      //------------------------------- ��������� ������� ��������� ���1

      if T[1].Activ  then
      begin //--------------------------------------------- �������� �������� ������� ��
        Timer[ObCI[5]] := Round((LastTime- T[1].F)*86400);
        if Timer[ObCI[5]]> 300 then Timer[ObCI[5]] := 300;
      end;
    end else
    begin //����� ��������� ��� ������������� �������� ���������� ��� ��������� ����������
      if ObCI[5] > 0 then Timer[ObCI[5]] := 0;
      T[1].Activ  := false;
      bP[1] := false;
    end;

    if VBufInd > 0 then
    begin
      VBUF := ObjZv[GRI].VBufInd;
      OVBuffer[VBUF].Param[16] := ObjZv[GRI].bP[31];
      for ii:=1 to 32 do OVBuffer[VBUF].NParam[ii]:=ObjZv[GRI].NParam[ii];
      //--------------------------------------------------  ��������� ���������� �������
      OVBuffer[VBUF].Param[2] := bP[2];
      OVBuffer[VBUF].Param[3] := bP[3];
      OVBuffer[VBUF].Param[4] := bP[4];
      OVBuffer[VBUF].Param[5] := bP[5];
      OVBuffer[VBUF].Param[6] := bP[6];
    end;
  end;
end;

//========================================================================================
//-------------------------------- ���������� ������� ������ � ��� ��� ������ �� ����� #23
procedure PrepMEC(MEC : Integer);
var
  mo,mp,egs : boolean;
  VBUF : integer;
begin
  VBUF := ObjZv[MEC].VBufInd;
  ObjZv[MEC].bP[31] := true; //----------------------------------------------- �����������
  ObjZv[MEC].bP[32] := false; //------------------------------------------- ��������������
  mp := GetFR3(ObjZv[MEC].ObCI[2],ObjZv[MEC].bP[32],ObjZv[MEC].bP[31]);  //------- ��
  mo := GetFR3(ObjZv[MEC].ObCI[3],ObjZv[MEC].bP[32],ObjZv[MEC].bP[31]);  //------- ��
  egs := GetFR3(ObjZv[MEC].ObCI[4],ObjZv[MEC].bP[32],ObjZv[MEC].bP[31]); //------ ���

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[16] := ObjZv[MEC].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[MEC].bP[32];
    if ObjZv[MEC].bP[31] and not ObjZv[MEC].bP[32] then
    begin
      if (mp <> ObjZv[MEC].bP[1]) and WorkMode.FixedMsg then
      begin
        if mp then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,385,1,''); //-------------- �������� �������� �������� �� ������
            AddFixMes(GetSmsg(1,385,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,385,1,'');
{$ENDIF}
        end else
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,386,1,''); //----------------- ����� �������� �������� �� ������
            AddFixMes(GetSmsg(1,386,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,386,1,'');
{$ENDIF}
        end;
      end;
      ObjZv[MEC].bP[1] := mp;
      OVBuffer[VBUF].Param[2] := ObjZv[MEC].bP[1];

      if(mo <> ObjZv[MEC].bP[2]) and WorkMode.FixedMsg then
      begin
        if mo then
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,387,1,'');
            AddFixMes(GetSmsg(1,387,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,387,1,''); //----------- �������� �������� �������� �� �����������
{$ENDIF}
        end else
        begin
{$IFDEF RMDSP}
          if config.ru = ObjZv[MEC].RU then
          begin
            InsNewMsg(MEC,388,1,'');  //----------- ����� �������� �������� �� �����������
            AddFixMes(GetSmsg(1,388,ObjZv[MEC].Liter,1),0,6);
          end;
{$ELSE}
          InsNewMsg(MEC,388,1,'');
{$ENDIF}
        end;
      end;

      ObjZv[MEC].bP[2] := mo;
      OVBuffer[VBUF].Param[3] := ObjZv[MEC].bP[2];

      if egs <> ObjZv[MEC].bP[3] then
      begin
        if egs then
        begin //------------------------------------------------ ������������� ������� ���
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[MEC].RU then
            begin
              InsNewMsg(MEC,105+$2000,1,'');
              AddFixMes(GetSmsg(1,105,ObjZv[MEC].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(MEC,105+$2000,1,''); //--- ������ ������ ����������� ������� �������
{$ENDIF}
          end;
        end;
      end;
      ObjZv[MEC].bP[3] := egs;
      OVBuffer[VBUF].Param[8] := ObjZv[MEC].bP[3];  //-------------------------------- ���
    end;
  end;
end;

//========================================================================================
//------------------------ ���������� ������� ������ ����� ������� � �������� �������� #24
procedure PrepZapros(UPST : Integer);
var
  zpp,egs : boolean;
  Zpr,ZPo,PPo,VBUF,Gs, Izp, Put, CHI, CHkm, NI, Nkm, MS, FS, SigUv : integer;
begin
  VBUF := VBUF;
  ZPo := ObjZv[UPST].ObCI[2];
  PPo := ObjZv[UPST].ObCI[3];
  Gs := ObjZv[UPST].ObCI[4];
  Izp := ObjZv[UPST].ObCI[6];
  Zpr := ObjZv[UPST].ObCI[7];
  Put := ObjZv[UPST].ObCI[8];
  CHI := ObjZv[UPST].ObCI[9];
  CHkm := ObjZv[UPST].ObCI[10];
  NI := ObjZv[UPST].ObCI[11];
  Nkm := ObjZv[UPST].ObCI[12];
  MS := ObjZv[UPST].ObCI[13];
  FS := ObjZv[UPST].ObCI[14];
  SigUv := ObjZv[UPST].ObCI[20];
  ObjZv[UPST].bP[31] := true; //---------------------------------------------- �����������
  ObjZv[UPST].bP[32] := false; //------------------------------------------ ��������������
  ObjZv[UPST].bP[1] := GetFR3(ZPo,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);//������ �� (���)
  ObjZv[UPST].bP[2] := GetFR3(PPo,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);// ������ ��(���)
  egs := GetFR3(Gs,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //------------------------- ���
  ObjZv[UPST].bP[5] := not GetFR3(Izp,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //------- ��
  zpp := GetFR3(Zpr,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //---- ������ ��������� ������
  ObjZv[UPST].bP[7] := not GetFR3(Put,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //-------- �
  ObjZv[UPST].bP[8] := not GetFR3(CHI,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]); //------- ��
  ObjZv[UPST].bP[9] := GetFR3(CHkm,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);    //------ ���
  ObjZv[UPST].bP[10] := not GetFR3(NI,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);//-------- ��
  ObjZv[UPST].bP[11] := GetFR3(Nkm,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);  //-------  ���
  ObjZv[UPST].bP[12] := GetFR3(MS,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);  //---------- ��
  ObjZv[UPST].bP[13] := GetFR3(FS,ObjZv[UPST].bP[32],ObjZv[UPST].bP[31]);  //---------  ��

  if SigUv > 0 then
  begin
    OVBuffer[SigUv].Param[16] := ObjZv[UPST].bP[31];
    OVBuffer[SigUv].Param[1] := ObjZv[UPST].bP[32];
  end;

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[16] := ObjZv[UPST].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[UPST].bP[32];
    if ObjZv[UPST].bP[31] and not ObjZv[UPST].bP[32] then
    begin
      OVBuffer[VBUF].Param[2] := ObjZv[UPST].bP[10]; //-------------------------------- ��
      OVBuffer[VBUF].Param[3] := ObjZv[UPST].bP[8];  //-------------------------------- ��
      OVBuffer[VBUF].Param[4] := ObjZv[UPST].bP[11]; //------------------------------- ���
      OVBuffer[VBUF].Param[5] := ObjZv[UPST].bP[9];  //------------------------------- ���
      OVBuffer[VBUF].Param[6] := ObjZv[UPST].bP[7];  //--------------------------------- �
      OVBuffer[VBUF].Param[7] := ObjZv[UPST].bP[5];  //-------------------------------- ��

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if egs <> ObjZv[UPST].bP[3] then
      begin
        if egs then
        begin//����������� ������� ��� ��� ������� �� ����������� (������ � �������� ����)
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPST].RU then
            begin
              InsNewMsg(UPST,105+$2000,1,''); // ������ ������ ����������� ������� �������
              AddFixMes(GetSmsg(1,105,ObjZv[UPST].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(UPST,105+$2000,1,'');
{$ENDIF}
          end;
        end;
        ObjZv[UPST].bP[3] := egs;
      end;
      OVBuffer[VBUF].Param[8] := ObjZv[UPST].bP[3];  //------------------------------- ���

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if zpp <> ObjZv[UPST].bP[6] then
      begin
        if zpp then
        begin //------------------------- ������������� ��������� ������� ��������� ������
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[UPST].RU then
            begin
              InsNewMsg(ObjZv[UPST].BasOb,292,0,'');//������� ������ ��������� ������
              AddFixMes(GetSmsg(1,292,ObjZv[ObjZv[UPST].BasOb].Liter,0),0,6);
            end;
{$ELSE}
            InsNewMsg(UPST,292+$2000,0,'');
{$ENDIF}
          end;
        end;
        ObjZv[UPST].bP[6] := zpp;
      end;

      OVBuffer[VBUF].Param[10] := ObjZv[UPST].bP[6]; //���
      OVBuffer[VBUF].Param[11] := ObjZv[UPST].bP[2]; //����
      OVBuffer[VBUF].Param[12] := ObjZv[UPST].bP[1]; //���
      //------------------------------------------------------------------ �������� ������
      if SigUv > 0 then
      begin
        OVBuffer[SigUv].Param[3] := ObjZv[UPST].bP[12]; //��
        OVBuffer[SigUv].Param[5] := ObjZv[UPST].bP[13]; //��
      end;
    end;

    ObjZv[UPST].bP[14] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin //--------------------------------------------------------- ��������� ����������
      if tab_page then OVBuffer[VBUF].Param[32] := ObjZv[UPST].bP[15]
      else OVBuffer[VBUF].Param[32] := ObjZv[UPST].bP[14];
    end else
{$ENDIF}

    OVBuffer[VBUF].Param[32] := ObjZv[UPST].bP[14];

    if ObjZv[UPST].ObCB[8] or ObjZv[UPST].ObCB[9] then
    begin //------------------------------------------------------------- ���� �����������
      ObjZv[UPST].bP[27] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 *8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (ObjZv[UPST].RU = config.ru) then
      begin
        if tab_page
        then OVBuffer[VBUF].Param[29] := ObjZv[UPST].bP[24]
        else OVBuffer[VBUF].Param[29] := ObjZv[UPST].bP[27];
      end else
{$ENDIF}
      OVBuffer[VBUF].Param[29] := ObjZv[UPST].bP[27];

      if ObjZv[UPST].ObCB[8] and ObjZv[UPST].ObCB[9] then
      begin //---------------------------------------------------- ���� 2 ���� �����������
        ObjZv[UPST].bP[28] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (ObjZv[UPST].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[31] := ObjZv[UPST].bP[25]
          else OVBuffer[VBUF].Param[31] := ObjZv[UPST].bP[28];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[31] := ObjZv[UPST].bP[28];
        ObjZv[UPST].bP[29] := GetFR4State(ObjZv[UPST].ObCI[8] div 8 * 8 + 1);
{$IFDEF RMDSP}

        if WorkMode.Upravlenie and (ObjZv[UPST].RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[30] := ObjZv[UPST].bP[26]
          else OVBuffer[VBUF].Param[30] := ObjZv[UPST].bP[29];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[30] := ObjZv[UPST].bP[29];
      end;
    end;
  end;
end;

//========================================================================================
//---------------- ���������� ������� ���������� ������� (�������) ��� ������ �� ����� #25
procedure PrepManevry(MNK : Integer);
var
  rm, v, Act, NPar : boolean;
  VBUF, RazM, Ot, Mi, OiD, Vsp, Egs, PredMi, RMK : integer;
begin
  RazM := ObjZv[MNK].ObCI[2];
  Ot := ObjZv[MNK].ObCI[3];
  Mi := ObjZv[MNK].ObCI[4];
  OiD := ObjZv[MNK].ObCI[5];
  Vsp := ObjZv[MNK].ObCI[6];
  Egs := ObjZv[MNK].ObCI[7];
  PredMi :=  ObjZv[MNK].ObCI[8];
  RMK :=  ObjZv[MNK].ObCI[9];
  Act := true; //------------------------------------------------------------- �����������
  NPar := false; //-------------------------------------------------------- ��������������
  rm := GetFR3(RazM,Npar,Act); //------------------------------------------------------ ��

  ObjZv[MNK].bP[2] := GetFR3(Ot,Npar,Act); //----------------------------- ������ ��������
  ObjZv[MNK].bP[3] := not GetFR3(Mi,NPar,Act); //---------------------------- ��������� ��
  ObjZv[MNK].bP[4] := not GetFR3(OiD,NPar,Act);//-------------------------- ��������� ��/�
  v := GetFR3(Vsp,Npar,Act);//------------------------------------------------- B���������
  ObjZv[MNK].bP[6] := GetFR3(Egs,NPar,Act); //--------------------------------------- ���
  ObjZv[MNK].bP[7] := GetFR3(PredMi,NPar,Act); //-------------------- �����.���.����������
  ObjZv[MNK].bP[9] := GetFR3(RMK,NPar,Act); //---------------------------------------- ���

  ObjZv[MNK].bP[31] := Act; //------------------------------------------------ �����������
  ObjZv[MNK].bP[32] := NPar; //-------------------------------------------- ��������������

  if ObjZv[MNK].VBufInd > 0 then
  begin
    VBUF := ObjZv[MNK].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[MNK].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[MNK].bP[32];

    if ObjZv[MNK].bP[31] and not ObjZv[MNK].bP[32] then
    begin
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if rm <> ObjZv[MNK].bP[1] then
      begin
        if rm then
        begin
          ObjZv[MNK].bP[14] := false; //---------- ����� �������� ������ ������� �� ������
          ObjZv[MNK].bP[8] := false; //------------------ ����� �������� ������ ������� ��
        end;
        ObjZv[MNK].bP[1] := rm;
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if v <> ObjZv[MNK].bP[5] then
      begin
        if WorkMode.FixedMsg
{$IFDEF RMDSP}
        and (config.ru = ObjZv[MNK].RU)
{$ENDIF}
        then
        begin
          if v then
          begin //------------------------------------------- �������� ���������� ��������
            InsNewMsg(MNK,389+$2000,7,'');
{$IFDEF RMDSP}
            AddFixMes(GetSmsg(1,389,ObjZv[MNK].Liter,7),0,6);
{$ENDIF}
          end else
          begin //---------------------------------------------- ����� ���������� ��������
            InsNewMsg(MNK,390+$2000,7,'');
{$IFDEF RMDSP}
            AddFixMes(GetSmsg(1,390,ObjZv[MNK].Liter,7),0,6);
{$ENDIF}
          end;
        end;
        ObjZv[MNK].bP[5] := v;
      end;
      OVBuffer[VBUF].Param[2] := ObjZv[MNK].bP[5]; //----------------------------------- �
      OVBuffer[VBUF].Param[3] := ObjZv[MNK].bP[1]; //---------------------------------- ��
      OVBuffer[VBUF].Param[4] := ObjZv[MNK].bP[2]; //---------------------------------- ��
      OVBuffer[VBUF].Param[5] := ObjZv[MNK].bP[4]; //---------------------------------- ��
      OVBuffer[VBUF].Param[6] := ObjZv[MNK].bP[3]; //---------------------------------- ��
      OVBuffer[VBUF].Param[7] := ObjZv[MNK].bP[7]; //---------------------------- ����� ��
      OVBuffer[VBUF].Param[9] := ObjZv[MNK].bP[6]; //--------------------------------- ���
      OVBuffer[VBUF].Param[10] := ObjZv[MNK].bP[8]; //------------------ ������ ������� ��
      OVBuffer[VBUF].Param[11] := ObjZv[MNK].bP[9]; //-------------------------------- ���
    end;
  end;
end;

//========================================================================================
//----------------------------------------- ���������� ������� ��� ��� ������ �� ����� #26
procedure PrepPAB(PAB : Integer);
var
  fp, gp, kj, o, Act, NPar : Boolean;
  VBUF, SvVh : integer;
begin
  Act := true; //------------------------------------------------------------- �����������
  NPar := false; //-------------------------------------------------------- ��������������
  with ObjZv[PAB] do
  begin
    SvVh := BasOb;

    bP[1] := not GetFR3(ObCI[2],NPar,Act);//-------------------------------------- ��
    fp := GetFR3(ObCI[3],NPar,Act); //-------------------------------------------- ��

    bP[3] := GetFR3(ObCI[4],NPar,Act); //-------------------- ��������������� �������
    bP[4] := GetFR3(ObCI[5],NPar,Act); //---------------------------------------- ���
    bP[5] := not GetFR3(ObCI[6],NPar,Act);//-------  ��������� �������� - �����������
    bP[6] := GetFR3(ObCI[7],NPar,Act); //----------------- ��������� �������� - �����
    kj := not GetFR3(ObCI[8],NPar,Act);//----------------------------------------- ��
    o := GetFR3(ObCI[12],NPar,Act);  //-------------------- ������������� �����������
    gp := not GetFR3(ObCI[13],NPar,Act);//---------------------------------------- ��
    bP[31] := Act;
    bP[32] := NPar;


    if bP[31] and not bP[32] then
    begin
      if (kj <> bP[7]) and not kj then //---------------------------------------- ����� ��
      begin
{$IFDEF RMDSP}
        if RU = config.ru then
        begin
          InsNewMsg(PAB,357+$2000,0,''); AddFixMes(GetSmsg(1,357,Liter,0),0,6);
        end;
{$ELSE}
        InsNewMsg(PAB,357+$2000,0,'');
{$ENDIF}
      end;
      bP[7] := kj;  //----------------------------------------------------------------- ��

      if (o <> bP[8]) and o then
      begin //-------------------------------------- ���������� ����������������� ��������
        if WorkMode.FixedMsg then
        begin
{$IFDEF RMDSP}
          if RU = config.ru then
          begin
            InsNewMsg(SvVh,405+$1000,1,'');
            AddFixMes(GetSmsg(1,405,'�'+ObjZv[SvVh].Liter,1),0,4);
          end;
{$ELSE}
          InsNewMsg(SvVh,405+$1000,1,'');//--------- ���������� ����������������� ��������
{$ENDIF}
        end;
      end;
      bP[8] := o;
    end;


    if (gp <> bP[9]) and not gp and (config.ru = RU) then
    IpBeep[1] := not bP[1] and WorkMode.Upravlenie;
    bP[9] := gp; //------------------------------------------------------- ��

    if VBufInd > 0 then
    begin
      VBUF := ObjZv[PAB].VBufInd;
      OVBuffer[VBUF].Param[16] := bP[31];
      OVBuffer[VBUF].Param[1] := bP[32];
      OVBuffer[VBUF].Param[11] := bP[7];
      OVBuffer[VBUF].Param[3] := o;
      OVBuffer[VBUF].Param[2] := bp[9];

      if SvVh > 0 then  OVBuffer[VBUF].Param[4] := ObjZv[SvVh].bP[4]
      else  OVBuffer[VBUF].Param[4] := false;
    end;

    if not bP[1] and not bP[5] then OVBuffer[VBUF].Param[12] := true
    else
    begin
      OVBuffer[VBUF].Param[6] := bP[1];
      OVBuffer[VBUF].Param[5] := bP[5];
      OVBuffer[VBUF].Param[7] := bP[6];
      OVBuffer[VBUF].Param[8] := bP[4];

      if fp <> bP[2] then
      begin //-------------------------------------------- �������� ������ �������� ������
        if fp and (config.ru = RU)
        then SBeep[1] := WorkMode.Upravlenie; // ��������� � ��������(�������� ��������)
      end;

      bP[2] := fp;
      OVBuffer[VBUF].Param[10] := fp;

      OVBuffer[VBUF].Param[13] := bP[3];
      OVBuffer[VBUF].Param[12] := false;
    end;

    bP[12] := GetFR4State(ObCI[13] div 8 * 8 + 2);
{$IFDEF RMDSP}
    if WorkMode.Upravlenie then
    begin // ��������� ����������
      if tab_page then OVBuffer[VBUF].Param[32] := bP[13]
      else OVBuffer[VBUF].Param[32] := bP[12];
    end else
{$ENDIF}
      OVBuffer[VBUF].Param[32] := bP[12];
    if ObCB[8] or ObCB[9] then
    begin //------------------------------------------------------------- ���� �����������
      bP[27] := GetFR4State(ObCI[13] div 8 * 8 + 3);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie and (RU = config.ru) then
      begin
        if tab_page
        then OVBuffer[VBUF].Param[29] := bP[24]
        else OVBuffer[VBUF].Param[29] := bP[27];
      end else
{$ENDIF}
        OVBuffer[VBUF].Param[29] := bP[27];
      if ObCB[8] and ObCB[9] then
      begin //---------------------------------------------------- ���� 2 ���� �����������
        bP[28] := GetFR4State(ObCI[13] div 8 * 8);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[31] := bP[25]
          else OVBuffer[VBUF].Param[31] := bP[28];
        end else
{$ENDIF}
        OVBuffer[VBUF].Param[31] := bP[28];
        bP[29] := GetFR4State(ObCI[13] div 8 * 8 + 1);
{$IFDEF RMDSP}
        if WorkMode.Upravlenie and (RU = config.ru) then
        begin
          if tab_page then OVBuffer[VBUF].Param[30] := bP[26]
          else OVBuffer[VBUF].Param[30] := bP[29];
        end else
{$ENDIF}
          OVBuffer[VBUF].Param[30] := bP[29];
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------- ���������� ������� ���������� ������� ��� ������ �� ����� #27
procedure PrepDZStrelki(Dz : Integer);
var
  STrO,  VBUF,  StrK,  SpK,  XStrO,  rzs : integer;
begin
  with ObjZv[Dz] do
  begin
    if ObCI[3] > 0 then  //---------------------------- ���� ������� �������� �������
    begin //---------------------------------------- ���������� ��������� �������� �������
      StrK := ObCI[1]; //----------------- ������ �������, ����������� �� �����������
      SpK := ObCI[2]; //-------------------- ������ �� ����������� ������� (� ������)
      StrO := ObCI[3]; //---------------------------- ������ ������� �������� �������

      VBUF := ObjZv[StrO].VBufInd; //-------------------- ���������� �������� �������
      XStrO := ObjZv[StrO].BasOb; //--------- ������ ������� "����� �������� �������"
      rzs := ObjZv[XStrO].ObCI[12];//--------------- ������ ������� ��������� �������

      if StrK > 0 then //------------------------------------- ���� ���� ����������� �������
      begin
        if not ObjZv[rzs].bP[1] and //---------------- ��� ������� ��������� ������� � ...
        ObjZv[XStrO].bP[21] then //------------ �������� ������� �� �������� ����� ���� ��
        begin
          if (ObCB[1] and //-------------- ���� ������� �������������� �� ����� � ...
          ObjZv[StrK].bP[1]) or //------- ����������� ������� ����������� �� ����� ��� ...
          (ObCB[2] and //---------------- ���� ������� �������������� �� ������ � ...
          ObjZv[StrK].bP[2]) //----------------- ����������� ������� ����������� �� ������
          then
          begin
            ObjZv[StrO].bP[4] := //--- �������������� ��������� �������� ������� ����� ...
            ObjZv[StrO].bP[25] or ObjZv[StrO].bP[33] or //------------ ��� ��� ��� ��� ...
            (not ObjZv[SpK].bP[2]); //------------- ����� ��������� �� ����������� �������

            OVBuffer[VBUF].Param[7] := ObjZv[StrO].bP[4];
          end;
        end;

        if not ObjZv[XStrO].bP[21] and not ObjZv[rzs].bP[1]
        then //------------------------------- ����� �������� ������� ������� �� ������ ��
        begin
          ObjZv[StrO].bP[4] := false; //------- �������� �������������� ��������� ��������
          ObjZv[StrO].bP[4] := ObjZv[StrO].bP[4] or
          ObjZv[StrO].bP[26] or ObjZv[StrO].bP[27];
          ObjZv[StrO].bP[14] := false; //--------- �������� ����������� ��������� ��������
          ObjZv[XStrO].bP[14] := false; //---------- �������� ����������� ��������� ������
        end;

        //--------------------------------- ����������� �������� ����� �������� ����������
        if ObjZv[StrK].bP[14] then //--------- ���� ���� ����������� ��������� �����������
        begin
          bP[23] := true; //------------------  ��������������� ��������� �������� �������

          if ObCB[1] then //--------------------- �������������� ������������ � �����
          begin
            if ObjZv[StrK].bP[6] then //----------------------------------- ���� ������ ��
            begin
              //- ��� ������� ������� �� ������ ��� ����������� ������� ���������� � �����
              if (not ObjZv[StrK].bP[11] or ObjZv[StrK].bP[12]) then
              begin
                if ObCB[3] then //---------------------- �������� ������ ���� � �����
                begin
                  if not ObjZv[StrO].bP[1] then bP[8]:=true; // ������� ���� ��������(� +)
                end else
                if ObCB[4] and not ObjZv[StrO].bP[2] // �������� ������ ���� � ������
                then bP[8] := true; //-------------------- ������� ���� �������� (� �����)
              end;
            end;
          end else
          if ObCB[2] then //-------------------- �������������� ������������ � ������
          begin
            if ObjZv[StrK].bP[7] then //----------------------------------------------- ��
            begin
              if ObCB[3] then //------------------------ �������� ������ ���� � �����
              begin
                if not ObjZv[StrO].bP[1] then bP[8] := true;
              end else
              //-------------------------------------------- �������� ������ ���� � ������
              if ObCB[4] and not ObjZv[StrO].bP[2] then bP[8] := true;
            end;
          end;
        end else bP[23] := false;//------------- ����� ���������������� ��������� ��������

        if not bP[8] then //------------------ ���� ��� �������� �������� �������� �������
        begin //--------------------------- ����������� �������� ����� �������� ����������
          if ObCB[1] then //------------- �������������� ������� ������������ � �����
          begin
            if ((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or ObjZv[StrK].bP[12])
            then bP[5] := true; //----------------------------- ��������� ������� ��������
          end else
          if ObCB[2] then //------------ �������������� ������� ������������ � ������
          begin
            if ((ObjZv[StrK].bP[10] and ObjZv[StrK].bP[11]) or
            ObjZv[StrK].bP[13])  then  bP[5] := true; //------- ��������� ������� ��������
          end;
        end;
      end;

      //---------------------------- ���� � ������ �����. ��� �������� ���������� ��������
      if not ObjZv[XStrO].bP[5] then
      ObjZv[XStrO].bP[5] := bP[5]; //------------------------- ���������� ���������� �� ��

      //------------------------------ ���� � ������ �����. ��� �������� �������� ��������
      if not ObjZv[XStrO].bP[8] then
      ObjZv[XStrO].bP[8] := bP[8]; //--------------------------- ���������� �������� �� ��

      if not ObjZv[XStrO].bP[23] then //-------- ���� ��� �������� ���������� ��� ��������
      ObjZv[XStrO].bP[23] := bP[23]; //------------------------- ������� ����������� �� ��
    end;
  end;
end;

//========================================================================================
//----------------------- ���������� ������� ���� ��������� ������ ��� ������ �� ����� #30
procedure PrepDSPP(Ptr : Integer);
var
  egs : boolean;
begin
  ObjZv[Ptr].bP[31] := true; // �����������
  ObjZv[Ptr].bP[32] := false; // ��������������
  egs := GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);  // ���
  ObjZv[Ptr].bP[2] := GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);  // �

  // ���
  if ObjZv[Ptr].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[32];
    if ObjZv[Ptr].bP[31] and not ObjZv[Ptr].bP[32] then
    begin
      if egs <> ObjZv[Ptr].bP[1] then
      begin
        if egs then
        begin
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            InsNewMsg(ObjZv[Ptr].BasOb,105+$2000,1,''); AddFixMes(GetSmsg(1,105,ObjZv[ObjZv[Ptr].BasOb].Liter,1),0,6);
{$ELSE}
            InsNewMsg(ObjZv[Ptr].BasOb,105+$2000,1,'');
{$ENDIF}
          end;
        end;
      end;
      ObjZv[Ptr].bP[1] := egs;
      OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[1];
    end;
  end;
end;

//========================================================================================
//------------------- ���������� ������� ��������������� ��������� ��� ������ �� ����� #31
procedure PrepPSvetofor(Ptr : Integer);
var
  o,sign : boolean;
  VidBuf,IndPovt,Sig,Cod : Integer;
begin
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- �����������
    ObjZv[Ptr].bP[32] := false; //------------------------------------ ��������������
    VidBuf := ObjZv[Ptr].VBufInd;
    IndPovt := ObjZv[Ptr].ObCI[2];
    Sig := ObjZv[Ptr].BasOb;
    //-------------------------------------------------------------- ��������� �����������
    o :=  GetFR3(IndPovt,ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);
    sign := ObjZv[Sig].bP[4];

    Cod := 0;
    if sign then Cod := Cod + 2;
    if o then Cod := Cod + 1;

    if VidBuf > 0 then //--------------------------------- ���� ���� ����������� �� ������
    begin
      OVBuffer[VidBuf].Param[16] := ObjZv[Ptr].bP[31];
      OVBuffer[VidBuf].Param[1] := ObjZv[Ptr].bP[32];

      if ObjZv[Ptr].bP[31] and not ObjZv[Ptr].bP[32] then
      begin
        if Cod <> ObjZv[Ptr].iP[1] then
        if not ObjZv[Ptr].T[1].Activ  then
        begin
          ObjZv[Ptr].T[1].Activ  := true;
          ObjZv[Ptr].T[1].F := LastTime + 3/80000;
        end;

        if ObjZv[Ptr].T[1].Activ  then
        begin //------------------------------------------------------ ���� ��������� ����
          if ObjZv[Ptr].T[1].F < LastTime then
          begin //---------------------------------------------------- ������� 3-4 �������
            //------ ������� �������, ��� ������ ������, ��� = 0 (��������� ��� ���������)
            ObjZv[Ptr].bP[1] := false; //---------------- ����� ������� �������������
            ObjZv[Ptr].bP[2] := false; //-------- ����� ������� ��������� �����������
            ObjZv[Ptr].bP[3] := false; //------------- ����� ������� ��������� ������

            case Cod of
              1:
              begin
                ObjZv[Ptr].bP[2] := true;
                ObjZv[Ptr].bP[3] := true; //---- ������ ������, ��� = 1(������������)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZv[ptr].RU then
                  begin
                    InsNewMsg(Ptr,579+$1000,0,''); //--- ������������� ������� �����������
                    AddFixMes(GetSmsg(1,579,ObjZv[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsNewMsg(Ptr,579+$1000,1,''); SBeep[4] := true;
{$ENDIF}
                end;
              end;

              2:
              begin
                ObjZv[Ptr].bP[1] := true; //--- ������ ������, ��� = 0(�������������)
                if WorkMode.FixedMsg then
                begin
{$IFDEF RMDSP}
                  if config.ru = ObjZv[ptr].RU then
                  begin
                    InsNewMsg(Ptr,339+$1000,0,'');//---- ������������� ������� �����������
                    AddFixMes(GetSmsg(1,339,ObjZv[Ptr].Liter,0),4,0);
                  end;
{$ELSE}
                  InsNewMsg(Ptr,339+$1000,1,''); SBeep[4] := true;
{$ENDIF}
                end;
              end;

              3:  ObjZv[Ptr].bP[2] := true; //������ ������, ��� = 1(����� ���������)
            end;
            ObjZv[Ptr].iP[1]:= Cod;
            ObjZv[Ptr].T[1].Activ  := false;
            ObjZv[Ptr].T[1].F := 0;
          end;
        end;
        OVBuffer[VidBuf].Param[3] := ObjZv[Ptr].bP[1];
        OVBuffer[VidBuf].Param[4] := ObjZv[Ptr].bP[3];
      end;
      OVBuffer[VidBuf].Param[2] := ObjZv[Ptr].bP[2];
    end;
end;

//========================================================================================
//---------------------------- ���������� ������� ������� �� ����� ��� ������ �� ����� #32
procedure PrepNadvig(NAD : Integer);
var
  egs,sn,sm : boolean;
  VBUF : integer;
begin
  ObjZv[NAD].bP[31] := true; //----------------------------------------------- �����������
  ObjZv[NAD].bP[32] := false; //------------------------------------------- ��������������

  ObjZv[NAD].bP[1] :=
  GetFR3(ObjZv[NAD].ObCI[2],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]);  //------------- ��


  ObjZv[NAD].bP[2] :=
  GetFR3(ObjZv[NAD].ObCI[3],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- ��

  ObjZv[NAD].bP[3] :=
  GetFR3(ObjZv[NAD].ObCI[4],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- ��

  ObjZv[NAD].bP[4] :=
  GetFR3(ObjZv[NAD].ObCI[5],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- ��

  ObjZv[NAD].bP[5] :=
  GetFR3(ObjZv[NAD].ObCI[6],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //------------- ���

  ObjZv[NAD].bP[6] :=
  GetFR3(ObjZv[NAD].ObCI[7],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- ��

  egs :=
  GetFR3(ObjZv[NAD].ObCI[8],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //------------- ���

  sn :=
  GetFR3(ObjZv[NAD].ObCI[9],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //-------------- ��

  sm :=
  GetFR3(ObjZv[NAD].ObCI[10],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]); //------------- ��

  ObjZv[NAD].bP[10] :=
  GetFR3(ObjZv[NAD].ObCI[11],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]);//--------------- �

  ObjZv[NAD].bP[11] :=
  GetFR3(ObjZv[NAD].ObCI[12],ObjZv[NAD].bP[32],ObjZv[NAD].bP[31]);//--------------- �

  if ObjZv[NAD].VBufInd > 0 then
  begin
    VBUF := ObjZv[NAD].VBufInd;
    OVBuffer[VBUF].Param[16] := ObjZv[NAD].bP[31];
    OVBuffer[VBUF].Param[1] := ObjZv[NAD].bP[32];
    if ObjZv[NAD].bP[31] and not ObjZv[NAD].bP[32] then
    begin

      OVBuffer[VBUF].Param[2] := ObjZv[NAD].bP[3];
      OVBuffer[VBUF].Param[3] := ObjZv[NAD].bP[4];
      OVBuffer[VBUF].Param[4] := ObjZv[NAD].bP[2];
      OVBuffer[VBUF].Param[5] := ObjZv[NAD].bP[1];
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if egs <> ObjZv[NAD].bP[7] then
      begin
        if egs then
        begin //------------------------------------------------ ������������� ������� ���
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,105+$2000,1,''); //- ������ ������ ����������� ������� �������
              AddFixMes(GetSmsg(1,105,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,105+$2000,1,'');
{$ENDIF}
          end;
        end;
      end;
      ObjZv[NAD].bP[7] := egs;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if sn <> ObjZv[NAD].bP[8] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sn then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,381+$2000,1,''); //----------------- �������� �������� �������
              AddFixMes(GetSmsg(1,381,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,381+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,382+$2000,1,''); //-------------------- ����� �������� �������
              AddFixMes(GetSmsg(1,382,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,382+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[NAD].bP[8] := sn;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if sm <> ObjZv[NAD].bP[9] then
      begin
        if WorkMode.FixedMsg then
        begin
          if sm then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,383+$2000,1,''); //---------------- �������� �������� ��������
              AddFixMes(GetSmsg(1,383,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,383+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end else
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[NAD].RU then
            begin
              InsNewMsg(NAD,384+$2000,1,'');//-------------------- ����� �������� ��������
              AddFixMes(GetSmsg(1,384,ObjZv[NAD].Liter,1),0,6);
            end;
{$ELSE}
            InsNewMsg(NAD,384+$2000,1,'');
            SBeep[1] := true;
{$ENDIF}
          end;
        end;
      end;
      ObjZv[NAD].bP[9] := sm;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      OVBuffer[VBUF].Param[6]  := ObjZv[NAD].bP[8];
      OVBuffer[VBUF].Param[7]  := ObjZv[NAD].bP[9];
      OVBuffer[VBUF].Param[8]  := ObjZv[NAD].bP[7];
      OVBuffer[VBUF].Param[9]  := ObjZv[NAD].bP[5];
      OVBuffer[VBUF].Param[10] := ObjZv[NAD].bP[6];
      OVBuffer[VBUF].Param[11] := ObjZv[NAD].bP[11];
      OVBuffer[VBUF].Param[12] := ObjZv[NAD].bP[10];

      {FR4}
      ObjZv[NAD].bP[12] := GetFR4State(ObjZv[NAD].ObCI[1]*8+2);
{$IFDEF RMDSP}
      if WorkMode.Upravlenie then
      begin
        if tab_page then OVBuffer[VBUF].Param[32] := ObjZv[NAD].bP[13]
        else OVBuffer[VBUF].Param[32] := ObjZv[NAD].bP[12];
      end else
{$ENDIF}
        OVBuffer[VBUF].Param[32] := ObjZv[NAD].bP[12];
    end;
  end;
end;

//========================================================================================
//---------------------------------- ���������� ���������� ������� ��� ������ �� ����� #33
procedure PrepSingle(Ptr : Integer);
var
  b : boolean;
  i : integer;
begin
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- �����������
    ObjZv[Ptr].bP[32] := false; //------------------------------------ ��������������

    for i := 0 to 34 do ObjZv[Ptr].NParam[i] := false;

    if ObjZv[Ptr].ObCB[1] then //--------------------------- ���� �������� ���������
    b := not GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31])
    else //--------------------------------------------------------- ���� ������ ���������
    b := GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);

    if not ObjZv[Ptr].bP[31] then //---------------------------------- ��� ����������
    begin
      if ObjZv[Ptr].VBufInd > 0 then //---------------------------- ���� �����������
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
      end;
    end else
    begin
      if ObjZv[Ptr].VBufInd > 0 then
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
      end;
      if ObjZv[Ptr].bP[1] <> b then
      begin
        if ObjZv[Ptr].ObCB[2] then
        begin //------ ����������� ��������� ��������� ������� - ����� ��������� ���������
          if b then
          begin
            if ObjZv[Ptr].ObCI[2] > 0 then //------- ���� ���� ��������� � ���������
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                if ObjZv[Ptr].ObCI[4] = 1   //------------- ���� ���� ������ �������
                then InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[2],0,'')
                else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');

                if ObjZv[Ptr].ObCI[4] = 1 then
                AddFixMes(MsgList[ObjZv[Ptr].ObCI[2]],4,3)
                else
                begin //--------------------------------------------- ��������� ����������
                  PutSMsg(ObjZv[Ptr].ObCI[4],LastX,LastY,MsgList[ObjZv[Ptr].ObCI[2]]);
                  SBeep[1] := true;
                end;
              end;
{$ELSE}
              if ObjZv[Ptr].ObCI[4] = 1 then
              begin
                InsNewMsg(Ptr,$1000 + ObjZv[Ptr].ObCI[2],0,'');
                SBeep[3] := true;
              end
              else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');

{$ENDIF}
            end;
          end else
          begin
            if ObjZv[Ptr].ObCI[3] > 0 then
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                if ObjZv[Ptr].ObCI[5] = 1
                then InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[3],0,'')
                else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],0,'');
                if ObjZv[Ptr].ObCI[5] = 1 then // ��������� �����������
                AddFixMes(MsgList[ObjZv[Ptr].ObCI[3]],4,3)
                else
                begin //--------------------------------------------- ��������� ����������
                  PutSMsg(ObjZv[Ptr].ObCI[5],LastX,LastY,MsgList[ObjZv[Ptr].ObCI[3]]);
//                  SBeep[1] := true;
                end;
              end;
{$ELSE}
              if ObjZv[Ptr].ObCI[5] = 1 then
              begin
                InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[3],0,'');
                SBeep[3] := true;
              end
              else InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],0,'');
{$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[1] := b;
      end;
      if ObjZv[Ptr].VBufInd > 0 then
      OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[1];
      OVBuffer[ObjZv[Ptr].VBufInd].NParam[1] := ObjZv[Ptr].NParam[1];
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
    for i := 1 to 34 do ObjZv[Ptr].NParam[i] := false;
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- �����������
    ObjZv[Ptr].bP[32] := false; //------------------------------------ ��������������

    k1f:= GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);//-- �1�

    k2f := GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[2],ObjZv[Ptr].bP[31]);//-- �2�

    k3f := GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);//-- ���

    vf1 := GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]);//-- 1��

    vf2 := GetFR3(ObjZv[Ptr].ObCI[5],ObjZv[Ptr].NParam[5],ObjZv[Ptr].bP[31]);//-- 2��

    kpp := GetFR3(ObjZv[Ptr].ObCI[6],ObjZv[Ptr].NParam[6],ObjZv[Ptr].bP[31]); //- ���

    kpa := GetFR3(ObjZv[Ptr].ObCI[7],ObjZv[Ptr].NParam[7],ObjZv[Ptr].bP[31]);//-- ���

    szk := GetFR3(ObjZv[Ptr].ObCI[8],ObjZv[Ptr].NParam[8],ObjZv[Ptr].bP[31]); //- ���

    ak :=  GetFR3(ObjZv[Ptr].ObCI[9],ObjZv[Ptr].NParam[9],ObjZv[Ptr].bP[31]); //-- ��

    k1shvp := GetFR3(ObjZv[Ptr].ObCI[10],ObjZv[Ptr].NParam[10],ObjZv[Ptr].bP[31]);//�1��

    k2shvp := GetFR3(ObjZv[Ptr].ObCI[11],ObjZv[Ptr].NParam[11],ObjZv[Ptr].bP[31]);//�2��

    knz :=   GetFR3(ObjZv[Ptr].ObCI[12],ObjZv[Ptr].NParam[12],ObjZv[Ptr].bP[31]);// ���

    knb :=   GetFR3(ObjZv[Ptr].ObCI[13],ObjZv[Ptr].NParam[13],ObjZv[Ptr].bP[31]);// ���

    dsn :=   GetFR3(ObjZv[Ptr].ObCI[14],ObjZv[Ptr].NParam[14],ObjZv[Ptr].bP[31]);// ���

    saut :=  GetFR3(ObjZv[Ptr].ObCI[15],ObjZv[Ptr].NParam[15],ObjZv[Ptr].bP[31]);//����

    vmg :=   GetFR3(ObjZv[Ptr].ObCI[18],ObjZv[Ptr].NParam[18],ObjZv[Ptr].bP[31]); //���

    fk1 :=   GetFR3(ObjZv[Ptr].ObCI[19],ObjZv[Ptr].NParam[19],ObjZv[Ptr].bP[31]); //1��

    fk2 :=   GetFR3(ObjZv[Ptr].ObCI[20],ObjZv[Ptr].NParam[20],ObjZv[Ptr].bP[31]); //2��

    fu1 :=   GetFR3(ObjZv[Ptr].ObCI[21],ObjZv[Ptr].NParam[21],ObjZv[Ptr].bP[31]); //1��

    fu2 :=   GetFR3(ObjZv[Ptr].ObCI[22],ObjZv[Ptr].NParam[22],ObjZv[Ptr].bP[31]); //2��

    vf :=    GetFR3(ObjZv[Ptr].ObCI[23],ObjZv[Ptr].NParam[23],ObjZv[Ptr].bP[31]); // ��

    pf1 :=   GetFR3(ObjZv[Ptr].ObCI[24],ObjZv[Ptr].NParam[24],ObjZv[Ptr].bP[31]); //��1

    la :=    GetFR3(ObjZv[Ptr].ObCI[25],ObjZv[Ptr].NParam[25],ObjZv[Ptr].bP[31]); // ��

    at :=    GetFR3(ObjZv[Ptr].ObCI[26],ObjZv[Ptr].NParam[26],ObjZv[Ptr].bP[31]); // ��

    kmgt :=  GetFR3(ObjZv[Ptr].ObCI[27],ObjZv[Ptr].NParam[27],ObjZv[Ptr].bP[31]); //���

    if ObjZv[Ptr].VBufInd > 0 then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];

      for i := 1 to 32 do //------------------------ ���������� ��� �������������� �������
      OVBuffer[ObjZv[Ptr].VBufInd].NParam[i] := ObjZv[Ptr].NParam[i];

      if ObjZv[Ptr].bP[31] then
      begin
        if dsn <> ObjZv[Ptr].bP[14] then //-------------------------------------- ���
        begin
          if WorkMode.FixedMsg then
          begin
            if dsn then
            begin
              InsNewMsg(Ptr,358+$2000,0,''); //------------- ������� ����� ���������������
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,358,'',7),4,4);
              {$ELSE}  SBeep[4] := true; {$ENDIF}
            end  else
            begin
              InsNewMsg(Ptr,359+$2000,0,''); //------------ �������� ����� ���������������
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,359,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[14] := dsn;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[14] := dsn;

        if saut <> ObjZv[Ptr].bP[15] then//------------------------------------- ����
        begin
         if saut then
         begin
           InsNewMsg(Ptr,524+$1000,1,''); //------------------------- "������������� ����"
           {$IFDEF RMDSP}  AddFixMes(GetSmsg(1,524,'',0),4,3);
           {$ELSE} SBeep[2] := true; {$ENDIF}
         end;
         ObjZv[Ptr].bP[15] := saut;
         OVBuffer[ObjZv[Ptr].VBufInd].Param[15] := saut;
        end;

        if ObjZv[Ptr].ObCB[1] then//----------------------------------------- ������
        begin //----------------------- ��� ����� ������� (���� �������� �������� �������)
          if k1f <> ObjZv[Ptr].bP[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsNewMsg(Ptr,303+$2000,0,''); //-------------- "�������������� 1-�� ������"
              {$IFDEF RMDSP}  AddFixMes(GetSmsg(1,303,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,302+$1000,0,''); //------------------ "���������� 1-�� ������"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,302,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := k1f;

          if k2f <> ObjZv[Ptr].bP[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsNewMsg(Ptr,305+$2000,0,''); //-------------- "�������������� 2-�� ������"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,305,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,304+$1000,0,'');//------------------- "���������� 2-�� ������"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,304,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := k2f;

          if k3f <> ObjZv[Ptr].bP[3] then
          begin
            if WorkMode.FixedMsg then
            if not k3f then
            begin
              InsNewMsg(Ptr,308+$2000,0,''); //-------------- "����������� ������� �� ���"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,308,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := k3f;

          if vf1 <> ObjZv[Ptr].bP[4] then  //------ ���������� ���������� 1-�� ������
          begin
            if WorkMode.FixedMsg then
            if not vf1 then
            begin
              InsNewMsg(Ptr,306+$2000,7,''); //------- "����������� ������� �� 1-�� �����"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,306,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,307+$2000,0,''); //------- "����������� ������� �� 2-�� �����"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,307,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := vf1;

          ObjZv[Ptr].bP[1] := k1f;
          ObjZv[Ptr].bP[2] := k2f;
          ObjZv[Ptr].bP[3] := k3f;
          ObjZv[Ptr].bP[4] := vf1;
          ObjZv[Ptr].bP[5] := vf2;
        end
        else
        begin //---------------------- ��� ������� ������� (��� �������� �������� �������)
          if k1f <> ObjZv[Ptr].bP[1] then
          begin
            if WorkMode.FixedMsg then
            if not k1f then
            begin
              InsNewMsg(Ptr,303+$2000,0,''); //----------------- "�������������� ������ 1"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,303,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,302+$1000,0,'');  //-------------------- "���������� ������ 1"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,302,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := k1f;

          if k2f <> ObjZv[Ptr].bP[2] then
          begin
            if WorkMode.FixedMsg then
            if not k2f then
            begin
              InsNewMsg(Ptr,305+$2000,0,''); //----------------- "�������������� ������ 2"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,305,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,304+$1000,0,''); //--------------------- "���������� ������ 2"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,304,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := k2f;

          if k3f <> ObjZv[Ptr].bP[3] then
          begin
            if WorkMode.FixedMsg then
            if k3f then //------------------------------------- ����������� ������� �� ���
            begin
              InsNewMsg(Ptr,308+$2000,0,'');
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,308,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := k3f;

          if vf1 <> ObjZv[Ptr].bP[4] then
          begin
            if WorkMode. FixedMsg then
            if not vf1 then
            begin
              InsNewMsg(Ptr,306+$2000,0,'');  //----------- ����������� ������� �� 1 �����
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,306,'',0),5,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := vf1;

          if vf2 <> ObjZv[Ptr].bP[5] then
          begin
            if WorkMode.FixedMsg then
            if not vf2 then
            begin
              InsNewMsg(Ptr,307+$2000,0,'');
              {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,307,'',0),5,2);
              {$ELSE}
              SBeep[2] := true;
              {$ENDIF}
            end;
          end;
          OVBuffer[ObjZv[Ptr].VBufInd].Param[5] := vf2;
          ObjZv[Ptr].bP[1] := k1f;
          ObjZv[Ptr].bP[2] := k2f;
          ObjZv[Ptr].bP[3] := k3f;
          ObjZv[Ptr].bP[4] := vf1;
          ObjZv[Ptr].bP[5] := vf2;
        end;
//------------------------------------------------------------------------------------ ���
        if kpp <> ObjZv[Ptr].bP[6] then
        begin
          if WorkMode.FixedMsg and kpp then
          begin
            InsNewMsg(Ptr,284+$1000,0,''); //---------------- "����������� ��������������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,284,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        //---------------------------------------------------------------------------- ���
        if kpa <> ObjZv[Ptr].bP[7] then
        begin
          if WorkMode.FixedMsg and kpa then
          begin
            InsNewMsg(Ptr,285+$1000,0,''); // ������������� ������� ���� �������� �������.
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,285,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[6] := kpp;
        ObjZv[Ptr].bP[7] := kpa;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[6] := kpp;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[7] := kpa;
        //---------------------------------------------------------------------------- ���
        if szk <> ObjZv[Ptr].bP[8] then
        begin
          if WorkMode.FixedMsg then
          begin
            if szk then
            begin
              InsNewMsg(Ptr,286+$1000,0,''); //--------- "��������� �������� ���� �������"
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,286,'',0),4,3);
              {$ELSE} SBeep[3] := true; {$ENDIF}
            end
            else
            begin
              InsNewMsg(Ptr,404+$2000,0,''); //������. ������������� �������� ���� �������
              {$IFDEF RMDSP} AddFixMes(GetSmsg(1,404,'',0),0,2);
              {$ELSE} SBeep[2] := true; {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[8] := szk;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[8] := szk;

        //----------------------------------------------------------------------------- ��
        if ak <> ObjZv[Ptr].bP[9] then
        begin
          if WorkMode.FixedMsg and ak then
          begin
            InsNewMsg(Ptr,287+$1000,0,''); // ��������.������� ���� �����. ��������� �����
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,287,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[9] := ak;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[9] := ak;

        //-------------------------------------------------------------------------- �1���
        if k1shvp <> ObjZv[Ptr].bP[10] then
        begin
          if WorkMode.FixedMsg and k1shvp then
          begin
            InsNewMsg(Ptr,288+$2000,0,''); //--------------------------- "���������� ���1"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,288,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[10] := k1shvp;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[10] := k1shvp;
        //-------------------------------------------------------------------------- �2���
        if k2shvp <> ObjZv[Ptr].bP[11] then
        begin
          if WorkMode.FixedMsg and k2shvp then
          begin
            InsNewMsg(Ptr,289+$2000,0,''); //--------------------------- "���������� ���2"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,289,'',0),4,3);
            {$ELSE} SBeep[3] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[11] := k2shvp;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[11] := k2shvp;

        //---------------------------------------------------------------------------- ���
        if knz <> ObjZv[Ptr].bP[12] then
        begin
          if WorkMode.FixedMsg and knz then
          begin
            InsNewMsg(Ptr,290+$1000,0,''); //------------- "������������� ����� ������� 1"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,290,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[12] := knz;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[12] := knz;

        //---------------------------------------------------------------------------- ���
        if knb <> ObjZv[Ptr].bP[13] then
        begin
          if WorkMode.FixedMsg and knb then
          begin
            InsNewMsg(Ptr,291+$1000,0,''); //-------------- "��� ����� ���������� �������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,291,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[13] := knb;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[13] := knb;

        //---------------------------------------------------------------------------- ���
        if vmg <> ObjZv[Ptr].bP[18] then
        begin
          if WorkMode.FixedMsg and vmg then
          begin
            InsNewMsg(Ptr,515+$1000,0,''); //--------------- "���������� �������� �������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,515,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[18] := vmg;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[18] := vmg;

        //--------------------------------------- 1�� �������� ����������� ��� 1-�� ������

        if fk1 <> ObjZv[Ptr].bP[19] then
        begin
          if WorkMode.FixedMsg and fk1 then
          begin
            InsNewMsg(Ptr,537+$1000,0,''); //---------- "��� ����� ����������� ��� ������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,537,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[19] := fk1;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[19] := fk1;

        //--------------------------------------- 2�� �������� ����������� ��� 2-�� ������
        if fk2 <> ObjZv[Ptr].bP[20] then
        begin
          if WorkMode.FixedMsg and fk2 then
          begin
            InsNewMsg(Ptr,537+$1000,0,''); //---------- "��� ����� ����������� ��� ������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,537,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[20] := fk2;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[20] := fk2;

        //-------------------------------------------- 1�� �������� ���������� 1-�� ������
        if fu1 <> ObjZv[Ptr].bP[21] then
        begin
          if WorkMode.FixedMsg and fu1 then
          begin
            InsNewMsg(Ptr,538+$1000,0,''); //--------------- "��� ����� ���������� ������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,538,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[21] := fu1;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[21] := fu1;

        //-------------------------------------------- 2�� �������� ���������� 2-�� ������
        if fu2 <> ObjZv[Ptr].bP[22] then
        begin
          if WorkMode.FixedMsg and fu2 then
          begin
            InsNewMsg(Ptr,538+$1000,0,''); //--------------- "��� ����� ���������� ������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,538,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[22] := fu2;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[22] := fu2;

        //----------------------------------------------- �������� ���������� 2-�� �������
        if vf <> ObjZv[Ptr].bP[23] then
        begin
          if WorkMode.FixedMsg and vf then
          begin
            InsNewMsg(Ptr,539+$1000,0,''); //---- "������������� ���������� ����� �������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,539,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[23] := vf;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[23] := vf;

        //------------------------------------------------ �������� ���������� �����������
        if pf1 <> ObjZv[Ptr].bP[24] then
        begin
          if WorkMode.FixedMsg and pf1 then
          begin
            InsNewMsg(Ptr,540+$1000,0,''); //---------- "��� ����� ���������� �����������"
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,540,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[24] := pf1;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[24] := pf1;

        //----------------------------------------------- �������� ������� ��������� �����
        if la <> ObjZv[Ptr].bP[25] then
        begin
          if WorkMode.FixedMsg and la then
          begin
            InsNewMsg(Ptr,484+$1000,0,''); //------- ������������� ������� ��������� �����
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,484,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[25] := la;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[25] := la;

        //--------------------------------------------------------- �������� ������� �����
        if at <> ObjZv[Ptr].bP[26] then
        begin
          if WorkMode.FixedMsg and at then
          begin
            InsNewMsg(Ptr,484+$1000,0,''); //----------------- ������������� ������� �����
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,545,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[26] := at;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[26] := at;

        if kmgt <> ObjZv[Ptr].bP[27] then
        begin
          if WorkMode.FixedMsg and kmgt then
          begin
            InsNewMsg(Ptr,574+$1000,0,''); //----------------- ������������� ������� �����
            {$IFDEF RMDSP} AddFixMes(GetSmsg(1,574,'',0),4,1);
            {$ELSE} SBeep[1] := true; {$ENDIF}
          end;
        end;
        ObjZv[Ptr].bP[27] := kmgt;
        OVBuffer[ObjZv[Ptr].VBufInd].Param[27] := kmgt;
      end;

      for i := 1 to 34 do //------------------------ ���������� ��� �������������� �������
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[i] := ObjZv[Ptr].NParam[i];
        OVBuffer[ObjZv[Ptr].VBufInd].Param[i] := ObjZv[Ptr].bP[i];
      end;
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    end;
end;

//========================================================================================
//-------------------------------- ������ � ���������� ���������� ������� ������������ #35
procedure PrepInside(Ptr : Integer);
var
  i,j,MainObj,MainCod,cvet_lamp : Integer;
  TXT : string;
begin
    cvet_lamp := 0;
    if ObjZv[Ptr].BasOb > 0 then
    begin
      MainObj := ObjZv[Ptr].BasOb; //-------------------------------- ������� ������
      case ObjZv[Ptr].ObCI[1] of
        1 :
        begin //------------------------------------------------------------------------ �
          ObjZv[Ptr].bP[1] := ObjZv[MainObj].bP[8] or //------- � �� FR3 ��� ...
          (ObjZv[MainObj].bP[9] and ObjZv[MainObj].bP[14]); //---- ��� � �������
        end;

        2 :
        begin //----------------------------------------------------------------------- ��
          ObjZv[Ptr].bP[1] := ObjZv[MainObj].bP[6] or //------ �� �� FR3 ��� ...
          (ObjZv[MainObj].bP[7] and ObjZv[MainObj].bP[14]);//----- ��� � �������
        end;

        3 :
        begin //--------------------------------------------------------------------- �&��
          ObjZv[Ptr].bP[1] := ObjZv[MainObj].bP[6] or //---------------- �� �� FR3 ��� ...
          ObjZv[MainObj].bP[8] or //------------------------------------- � �� FR3 ��� ...
          ((ObjZv[MainObj].bP[7] or ObjZv[MainObj].bP[9]) //-------------- ��� ��� ��� ...
          and ObjZv[MainObj].bP[14]); //---------------------------------------- � �������
        end;

        4 : //----------------------------------- ������ � 2-������� ������� �������� ����
        begin
          for i := 1 to 32 do
          begin
            ObjZv[Ptr].bP[i] := ObjZv[MainObj].bP[i];
            ObjZv[Ptr].NParam[i] := ObjZv[MainObj].NParam[i];
          end;

          MainCod := 0;
          if ObjZv[MainObj].bP[1] then MainCod := MainCod + 1;
          if ObjZv[MainObj].bP[2] then MainCod := MainCod + 2;
          //--------------------------------------------- MainCod ����� ���� ����� 0,1,2,3
          if MainCod <> ObjZv[MainObj].iP[1] then //------------- ���� ��������� ����
          begin
            if ((ObjZv[Ptr].ObCI[MainCod+1]) <> 0) and (MainCod <> 0) then
            begin
              if MainCod = 1 then cvet_lamp := ObjZv[Ptr].ObCI[10];
              if MainCod = 2 then cvet_lamp := ObjZv[Ptr].ObCI[11];
              if MainCod = 3 then cvet_lamp := ObjZv[Ptr].ObCI[12];
              if cvet_lamp = 28  then cvet_lamp := 1;
              if cvet_lamp = 27  then cvet_lamp := 1;
              if cvet_lamp = 29  then cvet_lamp := 2;
              if cvet_lamp = 26  then cvet_lamp := 9;
              if cvet_lamp = 7 then cvet_lamp := 1;

              TXT := MsgList[ObjZv[Ptr].ObCI[MainCod+1]];
              PutSMsg(cvet_lamp,LastX,LastY,TXT);
              SBeep[2] := WorkMode.Upravlenie;
              AddFixMes(TXT,cvet_lamp,0);
{$IFDEF RMSHN}
            InsNewMsg(Ptr,ObjZv[Ptr].ObCI[MainCod+1]+$1000,1,''); //----------------
            ObjZv[Ptr].dtP[1] := LastTime; //------------------- ������� ����� �������
            inc(ObjZv[Ptr].siP[1]); //---------------------- ��������� ������� �������
{$ENDIF}
            end;
          end;
          ObjZv[MainObj].iP[1] := MainCod;
        end;

        5://------------------------------------- ������ � 3-������� ������� �������� ����
        begin
          MainCod := 0;
          if ObjZv[MainObj].bP[1] then MainCod := MainCod + 1;
          if ObjZv[MainObj].bP[2] then MainCod := MainCod + 2;
          if ObjZv[MainObj].bP[3] then MainCod := MainCod + 4;
          if MainCod <> ObjZv[MainObj].iP[1] then //------------- ���� ��������� ����
          begin
            if ObjZv[Ptr].ObCI[MainCod+1] <> 0 then
            begin
              TXT := MsgList[ObjZv[Ptr].ObCI[MainCod+1]];
              PutSMsg(0,LastX,LastY,TXT);
              SBeep[2] := WorkMode.Upravlenie;
              AddFixMes(TXT,0,0);
            end;
          end;
          ObjZv[MainObj].iP[1] := MainCod;
        end;

        else ObjZv[Ptr].bP[1] := false;
      end;
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
    ColorVkl := 0;
    ColorOtkl := 0;
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- �����������
    for ii := 1 to 32 do  ObjZv[Ptr].NParam[32] := false; //-------------- ��������������
    //---------------------------------------------------- ������������ 5 �������� �������
    for ii := 1 to 5 do
    begin
      nep := false;
      b[ii] := //-------------------------------------------------------- ������ ���������
      GetFR3(ObjZv[Ptr].ObCI[10+ii],nep,ObjZv[Ptr].bP[31]);
      ObjZv[Ptr].NParam[ii] := nep;
      if ObjZv[Ptr].ObCB[ii] then //---------- ���� ����� �������� ��������� �������
      b[ii] := not b[ii];
    end;
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := false;

    if ObjZv[Ptr].VBufInd > 0 then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];

      //---------------------------------------------------------- ��������� 5-�� ��������
      for ii := 1 to 5 do
      if ObjZv[Ptr].bP[ii] <> b[ii] then //------------ ���� ������ ������� ���������
      begin
        if ObjZv[Ptr].ObCB[ii+5] then  //-------------------- ���� ����� �����������
        begin //------ ����������� ��������� ��������� ������� - ����� ��������� ���������
          if b[ii] then //--------------------------------------- ���� ��������� ���������
          begin
            if ((ii = 1) and (ObjZv[Ptr].ObCI[2] > 0)) or
            ((ii > 1) and (ObjZv[Ptr].ObCI[16+(ii-2)*2] > 0)) then//���� ����. o ���
              if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if config.ru = ObjZv[ptr].RU then
              begin
                InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');
                SBeep[2] := WorkMode.Upravlenie;
                if ObjZv[Ptr].ObCI[23+ii] = 1 then
                begin
                  ColorVkl := 7; //------------------------------------------------ ������
                  ColorOtkl := 7; //----------------------------------------------- ������
                end else
                if ObjZv[Ptr].ObCI[23+ii] = 2 then
                begin
                  ColorVkl := 1; //----------------------------------------------- �������
                  ColorOtkl := 2; //---------------------------------------------- �������
                end else
                if ObjZv[Ptr].ObCI[23+ii] = 3 then
                begin
                  ColorVkl := 2; //----------------------------------------------- �������
                  ColorOtkl := 7; //----------------------------------------------- ������
                end else
                begin
                  ColorVkl := 15; //------------------------------------------------ �����
                  ColorOtkl := 15; //----------------------------------------------- �����
                end;

                if ii = 1 then TXT := MsgList[ObjZv[Ptr].ObCI[2]];
                if ii > 1 then TXT := MsgList[ObjZv[Ptr].ObCI[16+(ii-2)*2]];
                PutSMsg(ColorVkl,LastX,LastY,TXT);
                SBeep[2] := WorkMode.Upravlenie;
                AddFixMes(TXT,0,1);
              end;
{$ELSE}
              InsNewMsg(Ptr,ObjZv[Ptr].ObCI[2],0,'');
{$ENDIF}
            end;
          end else
          begin
            if ObjZv[Ptr].ObCI[3] > 0 then //----- ���� ���� ��������� �� ����������
            if WorkMode.FixedMsg then
            begin
{$IFDEF RMDSP}
              if ii = 1 then TXT := MsgList[ObjZv[Ptr].ObCI[3]];
              if ii > 1 then TXT := MsgList[ObjZv[Ptr].ObCI[17+(ii-2)*2]];

              if config.ru = ObjZv[ptr].RU then
              begin
                InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],ColorOtkl,'');
                AddFixMes(TXT,0,1);
                SBeep[2] := WorkMode.Upravlenie;
                PutSMsg(7,LastX,LastY,TXT);
              end;
{$ELSE}
              InsNewMsg(Ptr,ObjZv[Ptr].ObCI[3],ColorOtkl,'');
{$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[ii] := b[ii];
      end;

      if ObjZv[Ptr].VBufInd > 0 then
      for ii := 1 to 5 do
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[ii] := ObjZv[Ptr].bP[ii];
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];
      end;
    end;
end;

//========================================================================================
//---------------------------- ���������� ������� �������� ������� ��� ������ �� ����� #38
procedure PrepMarhNadvig(Ptr : Integer);
  var v : boolean;
begin
  ObjZv[Ptr].bP[31] := true; // �����������
  ObjZv[Ptr].bP[32] := false; // ��������������
  v := GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].bP[32],ObjZv[Ptr].bP[31]);

  if v <> ObjZv[Ptr].bP[1] then
  begin
    if v then
    begin // ������������� ���������� �������� �������
      SetNadvigParam(ObjZv[Ptr].ObCI[10]); // ���������� ������� �� �� ������� �������
    end;
  end;
  ObjZv[Ptr].bP[1] := v;  //

  if ObjZv[Ptr].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[32];
    if ObjZv[Ptr].bP[31] and not ObjZv[Ptr].bP[32] then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[1];
    end;
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
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- �����������

    for i:= 1 to 32 do ObjZv[Ptr].NParam[i] :=false;

    r := //----------------------------------------------------------------------------- �
    GetFR3(ObjZv[Ptr].ObCI[1],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);

    ao :=//---------------------------------------------------------------------------- ��
    GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[2],ObjZv[Ptr].bP[31]);

    ar :=//---------------------------------------------------------------------------- ��
    GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[4] :=//---------------------------------------------�������t�������
    GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]);

    kp1 :=  //------------------------------------------------------------------------ ��1
    GetFR3(ObjZv[Ptr].ObCI[5],ObjZv[Ptr].NParam[5],ObjZv[Ptr].bP[31]);

    kp2 := //------------------------------------------------------------------------- ��2
    GetFR3(ObjZv[Ptr].ObCI[6],ObjZv[Ptr].NParam[6],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[7] := //-------------------------------------------------------------- �
    GetFR3(ObjZv[Ptr].ObCI[7],ObjZv[Ptr].NParam[7],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[11] := //------------------------------------------------------------ ��
    GetFR3(ObjZv[Ptr].ObCI[9],ObjZv[Ptr].NParam[11],ObjZv[Ptr].bP[31]);

    ObjZv[Ptr].bP[12] :=//------------------------------------------------------------- ��
    GetFR3(ObjZv[Ptr].ObCI[10],ObjZv[Ptr].NParam[12],ObjZv[Ptr].bP[31]);

    otu :=  //------------------------------------------------------------------------ ���
    GetFR3(ObjZv[Ptr].ObCI[11],ObjZv[Ptr].NParam[13],ObjZv[Ptr].bP[31]);

    rotu := //----------------------------------------------------------------------- ����
    GetFR3(ObjZv[Ptr].ObCI[12],ObjZv[Ptr].NParam[14],ObjZv[Ptr].bP[31]);

    //---------------- �������� ��������� ������ � ���������� ������� --------------------
    i := ObjZv[Ptr].ObCI[8] div 8;  //------ ��������� ������ ������ ������ �� MYTHX
    if i > 0 then
    begin
      myt := FR3[i] and $38;   //------------------------- ����������� ���� ��������� ����
      if myt > 0 then
      begin
        if myt = $38 then
        begin //-------------------------- ����������� ��������� ��������-----------------
          ObjZv[Ptr].bP[8] := true;  //--------------------- ����������� ������� ���������
          ObjZv[Ptr].bP[9] := false; //---------------- ����� �������� �������� ����������
          ObjZv[Ptr].bP[10] := false; //------------ ����� �������� ���������� ����������
        end else //--------------------------- ���� ��� ������� ��������� �������� � �����
        begin
          ObjZv[Ptr].bP[8] := false; //--------------------- ����� �������� ��������� ����
          if myt = $28 then //----------------------- ����������� ���� �������� ����������
          begin //----------------------------- ���� �������� ���������� �������� ��������
            ObjZv[Ptr].bP[9] := true; //------------------- ����������� ������� ����������
            ObjZv[Ptr].bP[10] := false; //------------------ �������� ��������� ����������
          end else
          begin //--------------------------- ���� ��������� ���������� ��������� ��������
            ObjZv[Ptr].bP[9] := false; //--------------------- �������� ������� ����������
            if not ObjZv[Ptr].bP[10] then //-------------------- ���� ��������� ����������
            begin
              InsNewMsg(Ptr,4+$3000,0,''); //-------------------- "������� �� ���������� "
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,4,'',0),4,4);
              {$ENDIF}
            end;
            ObjZv[Ptr].bP[10] := true; //----------- ����������� ��������� ����������
          end;
        end;
      end;
    end;

    a := false; b := false; p := false; //------------ �������� ��������������� ����������

    if ObjZv[Ptr].VBufInd > 0 then //-------------------------- ���� ���� ����������
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];//-����������
      for ii := 1 to 32 do
      OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];

      if ObjZv[Ptr].bP[31] then
      begin
        //------------------------------------------------ ���� ��������� ��������� �� ��1
        if kp1 <> ObjZv[Ptr].bP[5] and not ObjZv[Ptr].NParam[5] then
        begin
          if WorkMode.FixedMsg then //----------------------------- ���� �������� ��������
          begin
            if kp1 then //------------------------ ���� ���������� �������� ������� ������
            begin
              InsNewMsg(Ptr,493+$3000,0,''); //- "������������� ��������� ��������� �������"
              {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,493,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[5] := kp1; //----------------------- ��������� �������� ��� ��1

        //------------------------------------------------ ���� ��������� ��������� �� ��2
        if kp2 <> ObjZv[Ptr].bP[6] and not ObjZv[Ptr].NParam[6] then
        begin
          if WorkMode.FixedMsg then
          begin
            if kp2 then//------------------------ ���� ���������� ��������� ������� ������
            begin
              InsNewMsg(Ptr,494+$3000,0,''); //������������� ���������� ��������� �������
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,494,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[6] := kp2; //---------------------------------------- ���������

        //---------------------------------------- ���� ��������� ��������� ��������� ����
        if ao <> ObjZv[Ptr].bP[2] and not ObjZv[Ptr].NParam[2] then
        begin
          if WorkMode.FixedMsg then
          begin
            a := true;
            if ao then //--------------------------------- ���� ��������� 1 ��������� ����
            begin
              InsNewMsg(Ptr,366+$3000,0,''); //"��������� ����-1"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,366,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //---------------------------------------------- ���� ������� 1 ��������
              InsNewMsg(Ptr,367+$3000,0,''); //------------------------ "��������� ����-1"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,367,ObjZv[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[2] := ao;//------------------------------------------ ���������

        //--------------------------------------- ���� ��������� ���������� ��������� ����
        if ar <> ObjZv[Ptr].bP[3] and not ObjZv[Ptr].NParam[3] then
        begin
          if WorkMode.FixedMsg then
          begin
            b := true;
            if ar then
            begin//-------------------------------------------- ��������� 2 ��������� ����
              InsNewMsg(Ptr,368+$3000,0,''); //"��������� ����-2"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,368,ObjZv[Ptr].Liter,0),4,4);
              {$ENDIF}
            end else
            begin //------------------------------------------------ ���� ������� ��������
              InsNewMsg(Ptr,369+$3000,0,''); //------------------------ "��������� ����-2"
              {$IFDEF RMDSP}
                AddFixMes(GetSmsg(1,369,ObjZv[Ptr].Liter,0),5,0);
              {$ENDIF}
            end;
          end;
        end;
        ObjZv[Ptr].bP[3] := ar;//------------------------------------------ ���������

        if ObjZv[Ptr].ObCB[1]  then //------------------------- ���� ���������� ����
        begin
          //------------------------------------------------ ���� ���������� ��������� ���
          if otu <> ObjZv[Ptr].bP[13] and not ObjZv[Ptr].NParam[13] then
          begin
            if WorkMode.FixedMsg then
            begin
              if otu then //---------------------- ���� ���������� ��������� ��� ���������
              begin
                InsNewMsg(Ptr,500+$3000,0,''); //�������� ��������� �� ��������� ���������
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,500,ObjZv[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //------------------------------------ ������� ��������� ��� ���������
                InsNewMsg(Ptr,501+$3000,0,''); //-������� ��������� �� ��������� ���������
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,501,ObjZv[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZv[Ptr].bP[13] := otu;  //------------------------------------ ���������

          //------------------------------------------ ��������� ��������� ���������� ����
          if rotu <> ObjZv[Ptr].bP[14] and not ObjZv[Ptr].NParam[14] then
          begin
            if WorkMode.FixedMsg then
            begin
              if rotu then //------------------------- ���������� ��������� ���� ���������
              begin
                InsNewMsg(Ptr,502+$3000,0,'');//�������� ��������� �� ���������� ���������
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,502,ObjZv[Ptr].Liter,0),4,4);
                {$ENDIF}
              end else
              begin //----------------------------------- ������� ��������� ���� ���������
                InsNewMsg(Ptr,503+$3000,0,''); //������� ��������� �� ���������� ���������
                {$IFDEF RMDSP}
                  AddFixMes(GetSmsg(1,503,ObjZv[Ptr].Liter,0),5,0);
                {$ENDIF}
              end;
            end;
          end;
          ObjZv[Ptr].bP[14] := rotu;  //----------------------------------- ���������
        end;


        if r <> ObjZv[Ptr].bP[1] then  //---------- ���� ������������ ���������� ����
        begin
          if WorkMode.FixedMsg then p := true;
          ObjZv[Ptr].bP[1] := r; //---------------------------------------- ���������
        end;

        if p or a or b then  // ���� ������������ ���  ��������� ����1 ��� ��������� ����2
        begin //------------------------------- ������������� ������������ ���������� ����
          if r and not ar then //------------------------------ ������� ��������� ��������
          begin
            InsNewMsg(Ptr,365+$3000,0,''); //---------------------------- "� ������ ����2"
            {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,365,ObjZv[Ptr].Liter,0),5,2);
            {$ENDIF}
          end else
          if not r and not ao then //--------------------------- ������� �������� ��������
          begin
            InsNewMsg(Ptr,364+$3000,0,''); //---------------------------- "� ������ ����1"
            {$IFDEF RMDSP}
              AddFixMes(GetSmsg(1,364,ObjZv[Ptr].Liter,0),5,2);
            {$ENDIF}
          end;
          ObjZv[Ptr].bP[1] := r; //---------------------------------------- ���������
        end;

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //-------------------------------------------------------- ������ � �������� �����
        if (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][2]) and
        (config.SVAZ_TUMS[1][1] = config.SVAZ_TUMS[1][3]) then
        svaz1 := config.SVAZ_TUMS[1][1] //------------- ��������� ��������� �������� �����
        else exit;

        if svaz1 <> ObjZv[Ptr].iP[1] then //----------------- ���������� ��������� ������
        begin
          if (svaz1 and $40) = $40 then WorkMode.OKError := true
          else WorkMode.OKError := false;

          if ObjZv[Ptr].ObCI[13] = 1 then//------------------------------ ��� ���� 1
          begin
            if (svaz1 and $1) = $1 then //----------------------------------- ������ �����
            begin
              ObjZv[Ptr].bP[18] := true;
              if not ObjZv[Ptr].bP[33] then //--------- �� ���� �������� ������ �����
              begin
                AddFixMes(GetSmsg(1,433,'1',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[33] := true;
              end;
            end else //-------------------------------------------------- ��� ������ �����
            begin
              if ObjZv[Ptr].bP[33] then //---------------- ���� �������� ������ �����
              begin
                AddFixMes(GetSmsg(1,434,'1',0),5,2);
                InsNewMsg(0,434+$1000,0,'');
                ObjZv[Ptr].bP[33] := false;
              end;
              ObjZv[Ptr].bP[18] := false;
            end;

            if (svaz1 and $4) = $4 then //-------------------------------------- ������ ��
            begin
              ObjZv[Ptr].bP[17] := true;
              if not ObjZv[Ptr].bP[30] then //------------ �� ���� �������� ������ ��
              begin
                AddFixMes(GetSmsg(1,519,'1',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[30] := true;
              end;
            end else //----------------------------------------------------- ��� ������ ��
            begin
              if ObjZv[Ptr].bP[30] then //------------------- ���� �������� ������ ��
              begin
                AddFixMes(GetSmsg(1,520,'1',0),5,2);
                InsNewMsg(0,520+$1000,0,'');
                ObjZv[Ptr].bP[30] := false;
              end;
              ObjZv[Ptr].bP[17] := false;
            end;
          end else
          if ObjZv[Ptr].ObCI[13] = 2 then //--------------------------------- ����-2
          begin
            if (svaz1 and $2) = $2 then //----------------------------------- ������ �����
            begin
              ObjZv[Ptr].bP[18] := true;
              if not ObjZv[Ptr].bP[33] then //--------- �� ���� �������� ������ �����
              begin
                AddFixMes(GetSmsg(1,433,'2',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[33] := true;
              end;
            end else //-------------------------------------------------- ��� ������ �����
            begin
              if ObjZv[Ptr].bP[33] then //---------------- ���� �������� ������ �����
              begin
                AddFixMes(GetSmsg(1,434,'2',0), 5,2);
                InsNewMsg(0,434+$1000,0,'');
                ObjZv[Ptr].bP[33] := false;
              end;
              ObjZv[Ptr].bP[18] := false;
            end;

            if (svaz1 and $8) = $8 then //-------------------------------------- ������ ��
            begin
              ObjZv[Ptr].bP[17] := true;
              if not ObjZv[Ptr].bP[30] then //------------ �� ���� �������� ������ ��
              begin
                AddFixMes(GetSmsg(1,519,'2',0),4,3);
                InsNewMsg(0,433+$1000,0,'');
                ObjZv[Ptr].bP[30] := true;
              end;
            end else //----------------------------------------------------- ��� ������ ��
            begin
              if ObjZv[Ptr].bP[30] then //------------------- ���� �������� ������ ��
              begin
                AddFixMes(GetSmsg(1,520,'2',0),5,2);
                InsNewMsg(0,520+$1000,0,'');
                ObjZv[Ptr].bP[30] := false;
              end;
              ObjZv[Ptr].bP[17] := false;
            end;
          end;

          //-------------------------------------------------------------- ������� �������
          if (svaz1 and $20) = $20 then
          begin
            ObjZv[Ptr].bP[19] := true;
            if not ObjZv[Ptr].bP[32] then //-------------------- �� ���� �������� ��������
            begin
              AddFixMes(GetSmsg(1,521,'2',0),4,2);
              InsNewMsg(0,521+$1000,0,'');
              ObjZv[Ptr].bP[32] := true;
            end;
          end else
          begin //--------------------------------------------------- ��� �������� �������
            if ObjZv[Ptr].bP[32] then //--------------------------- ���� �������� ��������
            begin
              AddFixMes(GetSmsg(1,520,'2',0),5,2);  InsNewMsg(0,520+$1000,0,'');
              ObjZv[Ptr].bP[32] := false;
            end;
            ObjZv[Ptr].bP[19] := false;
          end;

          //--------------------------- �������� �� ������� ������� � ���������� ���������
          if (svaz1 and $40) = $40 then KOMANDA_OUT := true //- ������ ������� � ����� ���
          else KOMANDA_OUT := false;

          if(KOMANDA_OUT and (not KVITOK)) then //���� ������ �������, �� ��� ������������
          begin
            ObjZv[Ptr].bP[21] := true; //------ ���������, ��� ������� ������ � �����
            if not ObjZv[Ptr].bP[29] then //--------- �� ���� �������� ������ �������
            begin
              AddFixMes(GetSmsg(1,535,'',0),7,2);
              InsNewMsg(0,535+$1000,0,'');
              ObjZv[Ptr].bP[29] := true; //- ���������� ���������� �������� ���������
            end;
          end;

          //------------------------------------------------------- ������ ����� � �������
          if (svaz1 and $10) = $10 then
          begin
            ObjZv[Ptr].bP[20] := true;
            if not ObjZv[Ptr].bP[34] then //--------------- �� ���� �������� ������ ������
            begin
              AddFixMes(GetSmsg(1,522,'',0),4,2); InsNewMsg(0,522+$1000,0,'');
              ObjZv[Ptr].bP[34] := true;
            end;
          end else
          begin //------------------------------------------------------ ��� ������ ������
            if ObjZv[Ptr].bP[34] then //---------------------- ���� �������� ������ ������
            begin
              AddFixMes(GetSmsg(1,523,'',0),5,2);InsNewMsg(0,523+$1000,0,'');
              ObjZv[Ptr].bP[34] := false;
            end;
            ObjZv[Ptr].bP[20] := false;
          end;

          if((not KOMANDA_OUT) and (not KVITOK)) then//���� ������� �������� ��� ���������
          begin
            if WorkMode.OtvKom and (NET_PRIEMA_UVK <> 0) then
            begin
                AddFixMes(GetSmsg(1,542,'',0),4,3); // ������� �� ������� ��������
                InsNewMsg(0,542+$1000,0,'');
                SBeep[3] := true;
                NET_PRIEMA_UVK := 0;
                ObjZv[Ptr].bP[29] := false; //----------- �������� �������� ���������
                ObjZv[Ptr].bP[21] := false; //--------- ����� �������� ������ �������
                WorkMode.OtvKom := false;
            end else
            if ObjZv[Ptr].bP[21] then //---------- ���� ����� �������� ������ �������
            begin
              inc(NET_PRIEMA_UVK);
              if WorkMode.OtvKom then inc(NET_PRIEMA_UVK);
              AddFixMes(GetSmsg(1,541,'',0),4,4); //----- ��� ������ ������� � ���
              InsNewMsg(0,541+$1000,0,'');
              ObjZv[Ptr].bP[29] := false; //------------- �������� �������� ���������
              ObjZv[Ptr].bP[21] := false; //----------- ����� �������� ������ �������

              if NET_PRIEMA_UVK >= 2 then
              begin
                inc(NET_PRIEMA_UVK);
                AddFixMes(GetSmsg(1,542,'',0),4,3); // ������� �� ������� ��������
                InsNewMsg(0,542+$1000,0,'');
                SBeep[3] := true;
                NET_PRIEMA_UVK := 0;
                ObjZv[Ptr].bP[29] := false; //----------- �������� �������� ���������
                ObjZv[Ptr].bP[21] := false; //--------- ����� �������� ������ �������
              end;
            end;
          end;

          if(KOMANDA_OUT and KVITOK) then //���� ������ �������, � ������ ��������� �� ���
          begin //---------------------------------------------- ���� ��������� �� �������
            if ObjZv[Ptr].bP[21] then //---------- ���� ����� �������� ������ �������
            begin
              AddFixMes(GetSmsg(1,536,'',0),5,2); //----------- ��� ������ �������
              InsNewMsg(0,536+$1000,0,'');
              ObjZv[Ptr].bP[29] := false; //------------- �������� �������� ���������
              ObjZv[Ptr].bP[21] := false; //----------- ����� �������� ������ �������
            end;
          end;
          ObjZv[Ptr].iP[1] := svaz1;
        end;

        //--------------------- ��������� ��������� ����������� --------------------------
        for ii := 1 to 15 do
        begin
          OVBuffer[ObjZv[Ptr].VBufInd].Param[ii] := ObjZv[Ptr].bP[ii];
          OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];
        end;

        for ii := 17 to 32 do
        begin
          OVBuffer[ObjZv[Ptr].VBufInd].Param[ii] := ObjZv[Ptr].bP[ii];
          OVBuffer[ObjZv[Ptr].VBufInd].NParam[ii] := ObjZv[Ptr].NParam[ii];
        end;
      end;
    end;
end;

//========================================================================================
//--------------------------------------------------------- �������� ������ ���������� #39
procedure PrepKRU(KRU : Integer);
var
  ops,ps : array[1..3] of Integer;
  gr,i : integer;
  lock,nepar,bRu,bOu,Su,Vsu,Du : boolean;
begin
  with ObjZv[KRU] do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    nepar := false; //----------------------------------------------------- ��������������
    bRu  := GetFR3(ObCI[2],nepar,bP[31]); //------------------------------------------- ��
    bOu  := GetFR3(ObCI[3],nepar,bP[31]); //------------------------------------------- ��
    Su  := GetFR3(ObCI[4],nepar,bP[31]); //-------------------------------------------- ��
    Vsu := GetFR3(ObCI[5],nepar,bP[31]); //------------------------------------------- ���
    Du  := GetFR3(ObCI[6],nepar,bP[31]); //-------------------------------------------- ��

    if (bRu<> bP[1]) or (bOu <> bP[2]) or  (Su<> bP[3]) or (Vsu<> bP[4]) or (Du<> bP[5])
    then   ChDirect := true;

    bP[1] := bRu; bP[2] := bOu; bP[3] := Su; bP[4] := Vsu;  bP[5] := Du;
    bP[32] := nepar; //---------------------------------------------------- ��������������

    if ObCI[7] > 0 then bP[6] := not GetFR3(ObCI[7],bP[32],bP[31]) //----------------- ���
    else bP[6] := true;

    gr := ObCI[1];//--------------------------------------- ����� ������ �������� ��������
    if (ObCI[1] < 1) or (ObCI[1] > 8) then gr := 0;

    //----------------------------------------------------- ��������� ��������� ����������
    WorkMode.BU[gr] := not bP[31]; //--------------------------------- �������� ����������
    WorkMode.NU[gr] := bP[32];     //------------------------------ �������� �������������
    if ObCI[2]> 0 then WorkMode.RU[gr] := bP[1];//���� ������ ��,���������� ������ "�����"
    if ObCI[3] > 0 then WorkMode.OU[gr] := bP[2];//���� ������ ��, ���������� ������ "���"
    if ObCI[4] > 0 then WorkMode.SUpr[gr] := bP[3]; //���� ������ ��, ���������� ������ ��
    if ObCI[6] > 0 then WorkMode.DU[gr] := bP[5];//- ���� ������ ��, ���������� ������� ��

    WorkMode.KRU[gr] := bP[6];//------------------------ �������� ��������� ���������� ���

    if gr = 0 then
    begin //---------------------------------------- ���������� ������� �������� ���������
      lock := false;
      if WorkMode.BU[0] then
      begin T[1].Activ  := false;    lock := true; end else
      begin
        if T[1].Activ  then
        begin //-------------- ��������� ����� �������� ����� ��������� ������ � ���������
          if T[1].F < LastTime then begin lock := false; T[1].Activ  := false; end;
        end //------------------------ ������ ������ �������� ������ ����������� ���������
        else begin T[1].F := LastTime + 15/80000;  T[1].Activ  := true; end;
      end;
      WorkMode.FixedMsg := not (StartRM or WorkMode.NU[0] or lock);
    end;

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16]:= bP[31]; OVBuffer[VBufInd].Param[1]:= bP[32];
      if bP[31] and not bP[32] then
      begin
        OVBuffer[VBufInd].Param[2] := bP[2];    //---------------------------------��
        OVBuffer[VBufInd].Param[3] := bP[1];    //---------------------------------��
        OVBuffer[VBufInd].Param[4] := not bP[6];//------------------------------- ���
        OVBuffer[VBufInd].Param[5] := bP[3];    //-------------------------------- ��
        OVBuffer[VBufInd].Param[6] := bP[4];    //------------------------------- ���
        OVBuffer[VBufInd].Param[7] := bP[5];//-------------- ��
      end;
    end;

    //----------------------------- ��������� ���������� �������� ��������������� ��������
    ps[1] := 0; ps[2] := 0; ps[3] := 0; //------ ��������� �������� �� 3 ������ ����������

    for i := 1 to WorkMode.LimitObjZav do //-------------------- �������� �� ���� ��������
    if ObjZv[i].TypeObj = 7 then //------------------- ���� ������� ��������������� ������
    begin
      if ObjZv[i].bP[1] then inc(ps[ObjZv[i].RU]); //----- ���� ������� ��, ��������� ����
    end;
    //---------------------------------------------------------------------------- ����� 1
    if ps[1] <> ops[1] then //���� ���������� ����� �������� ��������������� � 1-�� ������
    begin
      if (ps[1] > 1) and (ps[1] > ops[1]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 1) {$ENDIF} then
        begin
          InsNewMsg(KRU,455+$1000,0,''); //---- ������� ����� ������ ���������������� ����
          {$IFDEF RMDSP} AddFixMes(GetSmsg(1,455,'',0),4,3); {$ENDIF}
        end;
        bP[19] := true; //--------------------------- �������� ������� �� �� � 1-�� ������
      end  else bP[19] := false;
      ops[1] := ps[1];
    end;
    //---------------------------------------------------------------------------- ����� 2
    if ps[2] <> ops[2] then
    begin
      if (ps[2] > 1) and (ps[2] > ops[2]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 2) {$ENDIF} then
        begin
          InsNewMsg(KRU,455+$1000,0,'');
          {$IFDEF RMDSP} AddFixMes(GetSmsg(1,455,'',0),4,3); {$ENDIF}
        end;
        bP[20] := true;
      end  else bP[20] := false;
      ops[2] := ps[2];
    end;
    //---------------------------------------------------------------------------- ����� 3
    if ps[3] <> ops[3] then
    begin
      if (ps[3] > 1) and (ps[3] > ops[3]) then
      begin
        if WorkMode.FixedMsg {$IFDEF RMDSP} and (config.ru = 3) {$ENDIF} then
        begin
          InsNewMsg(KRU,455+$1000,0,'');
          {$IFDEF RMDSP} AddFixMes(GetSmsg(1,455,'',0),4,3); {$ENDIF}
        end;
        bP[21] := true;
      end else  bP[21] := false;
      ops[3] := ps[3];
    end;
  end;
end;

//========================================================================================
//------------------------------------------------------------------ ����� ����������� #40
procedure PrepIzvPoezd(Ptr : Integer);
  var i : integer; z : boolean;
begin
  z := false;
  for i := 1 to 10 do
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      if not ObjZv[ObjZv[Ptr].ObCI[i]].bP[1] then
      begin
        z := true;
        break;
      end;
    end;
   ObjZv[Ptr].bP[1] := z;
end;

//========================================================================================
//-------------- ���������� ������� ���������� ������� � ���� ��� �������� ����������� #41
procedure PrepVPStrelki(VPSTR : Integer);
var
  SVotp, //---------------------------------------------------------- �������� �����������
  SP_ot, //------------------------------------------------ ����������� �� ��� �����������
  ST_oh, //--------------------------------------------------- ���������� ������� (� ����)
  XST_oh, //--------------------------------------------------------- ����� ������� � ����
  RZS, //------------------------------------------------ ������ ������� ��������� �������
  Para, //----------------------------------------------------------------- ������ �������
  Para_Xst, //------------------------------------------------------- ����� ������ �������
  i : integer;
  z, dzs : boolean;
begin
  SVotp := ObjZv[VPSTR].BasOb; //---------------------------- �������� ����������

  //------------- ���� ������ �������� ����������� � (�������� ������ ��� ������ ��������)
  if(SVotp>0) and ((ObjZv[SVotp].bP[3] or ObjZv[SVotp].bP[4] or ObjZv[SVotp].bP[8]) and
  not ObjZv[SVotp].bP[1]) then ObjZv[VPSTR].bP[20] := true
  else ObjZv[VPSTR].bP[20] := false; //------------------------ ������� ����������� ������

  SP_ot := ObjZv[VPSTR].UpdOb; //-------------- ������ ����������� �� �����������

  if SP_ot > 0 then
  begin
    z:=ObjZv[SP_ot].bP[2] or not ObjZv[VPSTR].bP[20];//- "�" ����������� �� �������� ����.

    //------------------ ���� ��������� ���������� ����������� ������ �������� �����������
    if (ObjZv[VPSTR].bP[5] <> z) and z then ObjZv[VPSTR].bP[20] := false; // ����� �������
    ObjZv[VPSTR].bP[5] := z; //------------------------------------ ��������� ��������� ��

    //---- ���� ��� ��������� �������� ����������� � ��� ����������� ��������� �����������
    if (not ObjZv[VPSTR].bP[20] or ObjZv[VPSTR].bP[21]) then exit;
//----------------------------------------------------------------------------------------
    for i := 1 to 4 do
    begin
      ST_oh := ObjZv[VPSTR].ObCI[i];//------- ������ ������� ��������� ������� � ����
      if ST_oh > 0 then //----------------------------- ���� ���� ��������� ������� � ����
      begin
        Para := ObjZv[ST_oh].ObCI[25]; //---------------------- ������ ������ �������
        Para_Xst := 0;
        if Para > 0 then Para_Xst := ObjZv[Para].BasOb; //------ ����� ������ �������
        XST_oh := ObjZv[ST_oh].BasOb; //---------------------- ����� �������� �������
        RZS := ObjZv[XST_oh].ObCI[12];
        dzs := ObjZv[RZS].bP[1];

        ObjZv[SP_ot].bP[14] := ObjZv[SP_ot].bP[14] and z;

        if ObjZv[VPSTR].ObCB[1] then ObjZv[ST_oh].bP[27]:= not z;//- ��� �� ���������

        if ObjZv[VPSTR].ObCB[2] then ObjZv[ST_oh].bP[26] := not z;//- ��� � ���������

        //---------------------------------------------- �������� �������������� ���������
        if not dzs then ObjZv[ST_oh].bP[4]:= ObjZv[ST_oh].bP[27] or ObjZv[ST_oh].bP[26] or
        ObjZv[ST_oh].bP[33] or ObjZv[ST_oh].bP[25]
        else ObjZv[ST_oh].bP[4] := true;

        if Para_Xst > 0 then ObjZv[Para_Xst].bP[4] := ObjZv[ST_oh].bP[4];

        OVBuffer[ObjZv[ST_oh].VBufInd].Param[7] :=
        ObjZv[ST_oh].bP[4];//----------------------------------- ������� �� �����

        if Para_Xst > 0 then
        OVBuffer[ObjZv[Para].VBufInd].Param[7] :=
        ObjZv[Para_Xst].bP[4];//-------------------------------- ������� �� �����


        //------------------------------- ����������� �������� ����� �������� ����������
        if ObjZv[SP_ot].bP[14] then //---- ������ ����������� �������� ����������
        begin
          if (ObjZv[VPSTR].ObCI[i+4] = 0) or//� ���� ��� ����������� � ������� ���
          ((ObjZv[VPSTR].ObCI[i+4] > 0) and //------------ ����� ������ ���� � ...
          (ObjZv[XST_oh].bP[21] and //����� ������� � ���� �������  �� � ...
          ObjZv[XST_oh].bP[22])) then //--- ����� ������� � ���� ����� �� ��
          begin
            ObjZv[VPSTR].bP[22+i] := true;//-- ���������� ��������������� ���������

            if ObjZv[VPSTR].ObCB[i*3] then // ���� i-� ������� ������ ���� � �����
            begin
              if not ObjZv[ST_oh].bP[1] //----------- ���� i-� ������� �� � �����
              then ObjZv[VPSTR].bP[7+i] := true;//-- ������� �������� �������� i-��
            end else
            if ObjZv[VPSTR].ObCB[i*3+1] then //������� ������ ������ ���� � ������
            begin
              if not ObjZv[ST_oh].bP[2] //-------------- ���� ������� �� � ������
              then ObjZv[VPSTR].bP[7+i] := true; //- ������� �������� �������� i-��
            end;
          end;
        end else //---------------------- ���� ��� ���������������� ��������� ��, �� ...
        ObjZv[VPSTR].bP[22+i] := false; //-- ����� ������� ��������� ������� � ����

        if not ObjZv[VPSTR].bP[7+i] then //--------- ���� ��� �������� ��������, ��
        begin
          ObjZv[VPSTR].bP[i] := //----- ���������� �������� i-�� ������� ������� ��
          not ObjZv[SP_ot].bP[8] and //-------- �����. ����������� �� �����������
          not ObjZv[SP_ot].bP[14];//-------------- �����.��������� �� �����������
        end
        else  ObjZv[VPSTR].bP[i] := false;//- ����� ���� ��������, ����� ����������

        if ObjZv[SP_ot].bP[9] then
        if not ObjZv[XST_oh].bP[5] then //--- ���� ����� �� ������� ��������
        ObjZv[XST_oh].bP[5] := ObjZv[VPSTR].bP[i];//���������� ��������

        if not ObjZv[XST_oh].bP[8] then //--- ���� ����� �� ������� ��������
        ObjZv[XST_oh].bP[8] := ObjZv[VPSTR].bP[7+i];//------ ����������

        if not ObjZv[XST_oh].bP[23] then //- ���� ����� �� ����� �����������
        ObjZv[XST_oh].bP[23] := ObjZv[VPSTR].bP[22+i];//---- ����������
      end;
    end;
  end;
end;

//========================================================================================
//------ ����� ������������� ��������� �������� �� ���������� (��� ��� ������� � ����) #42
procedure PrepVP(SVP : Integer);
var
  i,ohr,Sm,SP,SVTF : integer;
  Zm,nepar,VP : boolean;
begin
  VP := GetFR3(ObjZv[SVP].ObCI[11],nepar,ObjZv[SVP].bP[31]); //��������� ��������� ��
  SP := ObjZv[SVP].UpdOb; //-------------------------- ������ �� ��� ������� � ����
  SVTF := ObjZv[SVP].BasOb; //--------------------- �������� ��������� ������� � ����
  Zm := ObjZv[SP].bP[2]; //------------------------------ �������� ��������� ������ � ����

  ObjZv[SVP].bP[1] := VP;

  if (ObjZv[SVP].bP[3] <> Zm) and Zm then //----- ���� ���������� ���������� ������ � ����
  begin //------------ ����� ������� �-������ �� ����, ���������� ������������� �-��������
    ObjZv[SVP].bP[1] := false; ObjZv[SVP].bP[2] := false; ObjZv[SVP].bP[3] := Zm;
  end;

  //------------ ���� �-������� � ��� ��1 � ��2 � �������, �������� � �������� �� � ��� ��
  if ObjZv[SVP].bP[1] and not ObjZv[SVTF].bP[1] and not ObjZv[SVTF].bP[2] and
  ObjZv[SP].bP[1] and not ObjZv[SP].bP[2] and not ObjZv[SP].bP[3] then
  begin
    Zm := true;
    ObjZv[SVP].bP[3] := Zm; //------------------------------ ��������� ��������� ���������

    for i := 1 to 4 do //------------------------- ������ �� 4-� ��������� �������� � ����
    begin //-------------------------- ��������� ������� ��������� �������� ������� � ����
      ohr := ObjZv[SVP].ObCI[i]; //------ �������� ������� (��������� ������� � ����)
      //----- ���� ���� �� ���� ������� � ���� �� � �����, �������� z = false ���� �������
      if(ohr > 0) and not ObjZv[ohr].bP[1] then Zm := Zm and not Zm;
    end;

    if Zm then  //---------------------------------------------------- ���� ��� ����������
    begin //----------------------------------- ��� ������� � ���� ����� �������� �� �����
      Sm := ObjZv[SVP].ObCI[10]; //------------ ���������� ���������� �������� � ����
      if Sm > 0 then //------------------------------------------ ���� ���� ����� ��������
      begin //--------------------------------- �������� ����������� ����������� ���������
        //-------- ���� ��1 ��� ��2 ��� ���� �� �� STAN ��� ������� ���������� �����������
        if ObjZv[Sm].bP[1] or ObjZv[Sm].bP[2] or ObjZv[Sm].bP[6] or ObjZv[Sm].bP[7]
        then Zm := false;
      end;
    end;
    //--------------------- ���������� ������� ���������� ������������� ��������� ��������
    //---------------------------------------------- �� ���������� �� ����������� ��������
    ObjZv[SVP].bP[2] := Zm;   //-------------------- ��������� ��� ��������� �������������
  end else
  begin
    ObjZv[SVP].bP[3] := Zm; ObjZv[SVP].bP[2] := false;//����� ���������� �������.��������
  end;
end;

//========================================================================================
//--------------------------------------- ������ ���������� ���� �� ����������� ������ #43
procedure PrepOPI(Ptr : Integer);
var
  MK,Str,Xstr,o,p,j : integer;
begin
  with ObjZv[Ptr] do
  begin
    bP[31] := true; bP[32] := false;//----------------------- ����������� � ��������������
    bP[1]:= GetFR3(ObCI[1],bP[32],bP[31]); bP[2]:= GetFR3(ObCI[2],bP[32],bP[31]);//���,���
    OVBuffer[VBufInd].Param[16] := bP[31]; OVBuffer[VBufInd].Param[1] := bP[32];
    MK := BasOb;   //-------------------------------------------------- ���������� �������

    if bP[31] and not bP[32] then
    begin
      if MK > 0 then
      begin
        //���� �� = �� �������� �������, �� �������� ��� ��� ���
        if ObjZv[MK].bP[3] then
        begin
          OVBuffer[VBufInd].Param[2]:= bP[1] or bP[2]; OVBuffer[VBufInd].Param[3]:= false;
        end else //------------------------------------------------------ ������� ��������
        if bP[1] and bP[2] then //----------------------------------------- ���� ��� � ���
        begin OVBuffer[VBufInd].Param[2]:=true; OVBuffer[VBufInd].Param[3]:=true; end else
        begin OVBuffer[VBufInd].Param[2]:=bP[2];OVBuffer[VBufInd].Param[3]:=bP[1];end;
      end;

      if (MK > 0) and not (bP[1] or bP[2]) then  //------ ���� ������� � ��� ��� � ��� ���
      begin //------------------------ ��������������� ����� �� ���� �� ����������� ������
        if ObCB[1] then p := 2 else p := 1;

        o := Sosed[p].Obj; p := Sosed[p].Pin;
        j := 50;
        while j > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin //-------------------------------------------------------------- �������
              Xstr := ObjZv[o].BasOb;
              case p of
                2: ObjZv[Xstr].bP[10]:= true; //----------- ������ "+" �������� � ��������
                3: ObjZv[Xstr].bP[11]:= true;//------------ ������ "-" �������� � ��������
              end;
              p := ObjZv[Xstr].Sosed[1].Pin;  o := ObjZv[Xstr].Sosed[1].Obj;
            end;

            44 :
            begin
              Str  := ObjZv[o].UpdOb; XStr := ObjZv[Str].BasOb;

              if not ObjZv[o].bP[1] then ObjZv[o].bP[1]:= ObjZv[XStr].bP[10]; //----- ����
              if not ObjZv[o].bP[2] then ObjZv[o].bP[2]:= ObjZv[XStr].bP[11]; //----- ����

              if p = 1 then
              begin p:= ObjZv[o].Sosed[2].Pin; o:= ObjZv[o].Sosed[2].Obj; end else
              begin p:= ObjZv[o].Sosed[1].Pin; o:= ObjZv[o].Sosed[1].Obj; end;
            end;

            48 : begin  ObjZv[o].bP[1] := true; break; end;  //----------------------- ���

            else
              if p = 1 then
              begin p := ObjZv[o].Sosed[2].Pin;  o := ObjZv[o].Sosed[2].Obj; end else
              begin p := ObjZv[o].Sosed[1].Pin;  o := ObjZv[o].Sosed[1].Obj; end;
          end;
          if (o = 0) or (p < 1) then break;
          dec(j);
        end;
      end;
    end;
  end;
end;

//========================================================================================
//-------- ������ ���������� ���� �� ����������� ������ (��������� ���������� �������) #43
procedure PrepSOPI(Ptr : Integer);
var
  MKol,ob,p,j,Put,Xstr : integer;
begin
    if ObjZv[Ptr].UpdOb = 0 then exit;

    Put := ObjZv[Ptr].UpdOb;
    MKol := ObjZv[Ptr].BasOb;

    //------ ���������� �������� �� ������� � ��� �� � ���� ���������� � ...
    if(MKol > 0) and ObjZv[MKol].bP[1] and not ObjZv[MKol].bP[4] and ObjZv[MKol].bP[5] and

    not ObjZv[Ptr].bP[2] and //------------------------- ���������� ����� �������
    (MarhTrac.Rod= MarshP) and not ObjZv[Put].bP[8] then//���� � �������� ��������
    begin
      //--------------------------------- ���������� ���������� ������� ����������� ������
      if ObjZv[Ptr].ObCB[1] then p := 2 else p := 1;    //------ ���� ��������� 1->2

      ob := ObjZv[Ptr].Sosed[p].Obj;  p := ObjZv[Ptr].Sosed[p].Pin; j := 100;

      while j > 0 do
      begin
        case ObjZv[ob].TypeObj of
          2 :
          begin //---------------------------------------------------------------- �������
            Xstr := ObjZv[ob].BasOb;
            case p of
              2 :
              begin
                if ObjZv[Xstr].bP[11] then  // ���� ----- ���������� �������� � �����
                begin
                  if not ObjZv[Xstr].bP[5]// ���� ��� ���������� �������� � ���������
                  then ObjZv[Xstr].bP[5] := true; //------- ���������� ��� ����������
                  break;
                end;
              end;
              3 :
              begin
                if ObjZv[Xstr].bP[10] then // ���� ------- ���������� �������� � ����
                begin
                  if not ObjZv[Xstr].bP[5] then ObjZv[Xstr].bP[5] := true;break;
                end;
              end;
            end;
            p := ObjZv[ob].Sosed[1].Pin;
            ob := ObjZv[ob].Sosed[1].Obj;
          end;

          48 : break;  //------------------------------------------------------------- ���

          else
            if p = 1 then
            begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
            else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
        end;
        if (ob = 0) or (p < 1) then break;
        dec(j);
      end;
    end;
end;

//========================================================================================
//------------------------------------------------------------- ���������� ������� ��� #44
procedure PrepSMI(Ptr : Integer);
begin
{
  o := ObjZv[Ptr].UpdOb; // ������ ������� ����������� ������
  if not ObjZv[ObjZv[o].BasOb].bP[5] then
    ObjZv[ObjZv[o].BasOb].bP[5] := ObjZv[Ptr].bP[5];
  if not ObjZv[ObjZv[o].BasOb].bP[8] then
    ObjZv[ObjZv[o].BasOb].bP[8] := ObjZv[Ptr].bP[8];
}
end;

//========================================================================================
//------------------------------------------ ���������� ������� ������ ���� ���������� #45
procedure PrepZon(Zon : Integer);
begin
  with ObjZv[Zon] do
  begin
    bP[31] := true; //-------------------------------------------------------- �����������
    bP[32] := false; //---------------------------------------------------- ��������������

    bP[1] := //----------------------------------------------------------------------- ���
    GetFR3(ObCI[2],bP[32],bP[31]);
    bP[2] := //------------------------------------------------------------------------ ��
    GetFR3(ObCI[3],bP[32],bP[31]);

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31];
      OVBuffer[VBufInd].Param[1] := bP[32];
      if bP[31] and not bP[32] then
      begin
        OVBuffer[VBufInd].Param[2] := bP[1];
        OVBuffer[VBufInd].Param[3] := bP[2];
      end;
    end;
  end;
end;

//========================================================================================
//-------------------------------------- ���������� ������� "�������� � �������������" #46
procedure PrepAutoSvetofor(AvtoS : Integer);
{$IFDEF RMDSP}
var
  sig,i,str : integer;
{$ENDIF}
begin
{$IFDEF RMDSP}
    Sig := ObjZv[AvtoS].BasOb;
    if not ObjZv[AvtoS].bP[1] then exit; //---------------- ��������� ������������ �������

    if not (WorkMode.Upravlenie and WorkMode.OU[0]
    and WorkMode.OU[ObjZv[AvtoS].Group])//��� ������������ ���  ������ ���������� � ��-���
    then exit
    else
    if not WorkMode.CmdReady and not WorkMode.LockCmd then
    begin
      if ObjZv[sig].bP[4] then //---------------------------------- �������� ������ ������
      begin
        ObjZv[AvtoS].T[1].Activ  := false;
        ObjZv[AvtoS].bP[2] := false;
        exit;
      end;

      //------------------------------------ ��������� ������� ��������� ��������� �������
      for i := 1 to 10 do
      begin
        str := ObjZv[AvtoS].ObCI[i];
        if str > 0 then
        begin
          if not ObjZv[str].bP[1] then  begin ObjZv[AvtoS].bP[2] := false; exit; end;
        end;
      end;

      //---------------------------------------- ��������� ������� ����� ��������� �������
      if ObjZv[AvtoS].T[1].Activ  then
      begin
        if ObjZv[AvtoS].T[1].F > LastTime then exit;
      end;

      //---------------------------- ��������� ����������� ������ ������� �������� �������
      if CheckAutoMarsh(AvtoS,ObjZv[AvtoS].ObCI[25]) then
      begin
        if SendCommandToSrv(ObjZv[Sig].ObCI[5] div 8, _svotkrauto,Sig) then
        begin //--------------------------------------------- ������ ������� �� ����������
          if SetProgramZamykanie(ObjZv[AvtoS].ObCI[25],true) then
          begin
            //���� �������� ���-�� ������, ��������� 15 ������ �� ��������� ������� ������
            //------------------------------------- ������� �������� ������� �������������
            if OperatorDirect > LastTime then
            ObjZv[AvtoS].T[1].F := LastTime + IntervalAutoMarsh / 86400
            //�������� ������ �� ������, ��������� 10 ������ � �������� ������ �������
            else ObjZv[AvtoS].T[1].F := LastTime + 10 / 86400; // �������� ������
            ObjZv[AvtoS].T[1].Activ  := true;
            SBeep[5] := WorkMode.Upravlenie;
          end;
        end;
      end;
    end;
  {$ENDIF}
end;

//========================================================================================
//----------------------------------------- ���������� ������� "������������ ��������" #47
procedure PrepAutoMarshrut(AvtoM : Integer);
var
  {$IFDEF RMDSP} i,j,AvtoS,Signal,Xstr,Str,q,{$ENDIF}
  VBuf : integer;
begin
  with ObjZv[AvtoM] do
  begin
    bP[31] := true; bP[32] := false; //---------------------- ����������� � ��������������
    VBuf := VBufInd;

    //------------ ���� ���������� �������� ������������, ��������� ��������� ������������
    if ObCI[2] >0 then bP[2] := GetFR3(ObCI[2],bP[32],bP[31])
    else bP[2] := false;


    if VBuf > 0 then
    begin
      OVBuffer[VBuf].Param[16] := bP[31]; //----------------------------- ����� ����������
      OVBuffer[VBuf].Param[2] := bP[1]; //-------------- �������� ����������� ������������

      //------------------ ���� ���-������������ ���������, �������� �������� ������������
      if not bP[1] and bP[31] and not bP[32] then OVBuffer[VBuf].Param[3] := bP[2];
    end;

{$IFDEF RMDSP}
    if ObCB[1] then  //------------------------- ���� ��� ������ ������� ������������
    begin //-------------------- ���� ������ ������ ���-������������ � �� ������� ��������
      if CHAS and not bP[1] then begin if not AutoMarsh(AvtoM,true) then CHAS:= false; end
      else if bP[1] and not CHAS then AutoMarsh(AvtoM,false);
    end else //--------------------------------------------- ������ ��������� ������������
    begin
      if NAS and not bP[1] then  begin if not AutoMarsh(AvtoM,true) then NAS := false; end
      else  if bP[1] and not NAS then  AutoMarsh(AvtoM,false);
    end;

    if not bP[1] then exit;

    if not(WorkMode.OU[0] and WorkMode.OU[Group]) then
    begin //----------------- ����� ������������ ���  ������ ��������� ���������� � ��-���
      bP[1] := false;   NAS := false;  CHAS := false;
      for q := 10 to 12 do
      if ObCI[q] > 0 then
      begin
        AvtoS:=ObCI[q]; ObjZv[AvtoS].bP[1]:=false; AutoMarshOFF(AvtoS,ObCB[1]);
      end;
    end else

    //----------------------- ��������� ������� ��������� ������ ������������ ������������
    for i := 10 to 12 do //------------ ������ �� ��������� �������� �������� ������������
    begin
      AvtoS := ObCI[i];
      if AvtoS > 0 then
      begin //---------------------------------- ����������� ��������� ������ ������������
        Signal := ObjZv[AvtoS].BasOb;
        if ObjZv[Signal].bP[23] then //--------------------- ���� ���� ������ ��� ��������
        begin
          AddFixMes(GetSmsg(1,430,Liter,0),4,3);//------  "��������� ������������"
          bP[1] := false;   //------------ ����� ������� ����������� ������������ ��������

          for q := 10 to 12 do //---------------- ������ �� �������� �������� ������������
          if ObCI[q] > 0 then
          begin
            AvtoS := ObCI[q]; ObjZv[AvtoS].bP[1] := false;//����.������������ �������
            AutoMarshOFF(AvtoS,ObCB[1]); //---------------- ��������� ������/��������
          end;
          exit;
        end;

        for j := 1 to 10 do //--------- ������ �� ���� �������� ������������� ������������
        begin
          Str := ObjZv[AvtoS].ObCI[j];
          if Str > 0 then
          begin
            Xstr :=  ObjZv[Str].BasOb;
            if ObjZv[Xstr].bP[26] or ObjZv[Xstr].bP[32] then
            begin //-------- ���� ������������� ������ �������� ������� ��� ��������������
              AddFixMes(GetSmsg(1,430,Liter,0),4,3);//-------------- "����.�����."
              bP[1] := false;
              for q := 10 to 12 do
              if ObCI[q] > 0 then
              begin
                AvtoS := ObCI[q]; ObjZv[AvtoS].bP[1] := false;
                AutoMarshOFF(AvtoS,ObCB[1]);
              end;
              exit;
            end;
          end;
        end;
      end;
    end;
{$ENDIF}
  end;
end;

//========================================================================================
//------------------------------------------------------------- ���������� ������� ��� #48
procedure PrepRPO(Ptr : Integer);
begin
//  if ObjZv[Ptr].BasOb > 0 then
//  begin
//
//  end;
end;

//========================================================================================
//------------------------------------------------------------ ���������� ������� ���� #49
procedure PrepABTC(ABTC : Integer);
var
  gpo,ak,kl,pkl,rkl : boolean;
begin
  with ObjZv[ABTC] do
  begin
    bP[31]:= true; //--------------------------------------------------------- �����������
    bP[32]:= false; //----------------------------------------------------- ��������������
    gpo   := GetFR3(ObCI[1],bP[32],bP[31]); //---------------------------------------- ���
    bP[2] := GetFR3(ObCI[2],bP[32],bP[31]);//----------------------------------------- ���
    bP[3] := GetFR3(ObCI[3],bP[32],bP[31]);//-----------------------------------------  ��
    ak    := GetFR3(ObCI[4],bP[32],bP[31]);//------------------------------------------ ��
    kl    := GetFR3(ObCI[5],bP[32],bP[31]);//------------------------------------------ ��
    pkl   := GetFR3(ObCI[6],bP[32],bP[31]); //---------------------------------------- ���
    rkl   := GetFR3(ObCI[7],bP[32],bP[31]); //---------------------------------------- ���

    if VBufInd > 0 then
    begin
      OVBuffer[VBufInd].Param[16] := bP[31];  OVBuffer[VBufInd].Param[1] := bP[32];

      if (gpo <> bP[1]) and gpo then
      begin //--------------------------------------------------- ������������� ����������
        if WorkMode.FixedMsg then
        begin
          {$IFDEF RMDSP}
          if config.ru = RU then
          begin InsNewMsg(ABTC,488+$1000,0,''); AddFixMes(GetSmsg(1,488,Liter,0),4,4); end;
          {$ELSE}  InsNewMsg(ABTC,488+$1000,0,''); {$ENDIF}
        end;
        bP[1] := gpo;

        if (ak <> bP[4]) and ak then
        begin //------------------------------------------------ ������������� �����������
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,489+$1000,0,''); AddFixMes(GetSmsg(1,489,Liter,0),4,4); end;
            {$ELSE}  InsNewMsg(ABTC,489+$1000,0,'');   {$ENDIF}
          end;
        end;
        bP[4] := ak;

        if (kl <> bP[5]) and kl then
        begin //------------------------------------------------------ ������������� �����
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,490+$1000,0,''); AddFixMes(GetSmsg(1,490,Liter,0),4,4); end;
            {$ELSE} InsNewMsg(ABTC,490+$1000,0,''); {$ENDIF}
          end;
        end;
        bP[5] := kl;

        if (pkl <> bP[6]) and pkl then
        begin //-------------------------------------- ������������� ����� �������� ������
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,491+$1000,0,'');AddFixMes(GetSmsg(1,491,Liter,0),4,4); end;
            {$ELSE}  InsNewMsg(ABTC,491+$1000,0,''); {$ENDIF}
          end;
        end;
        bP[6] := pkl;

        if (rkl <> bP[7]) and rkl then
        begin //---------------------------------------- ������������� ����� �������� ������
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = RU then
            begin InsNewMsg(ABTC,492+$1000,0,''); AddFixMes(GetSmsg(1,492,Liter,0),4,4); end;
            {$ELSE}  InsNewMsg(ABTC,492+$1000,0,'');  {$ENDIF}
          end;
        end;
        bP[7] := rkl;

        OVBuffer[VBufInd].Param[2] := bP[1]; //--------------------------------------- ���
        OVBuffer[VBufInd].Param[3] := bP[2]; //--------------------------------------- ���
        OVBuffer[VBufInd].Param[4] := bP[3]; //---------------------------------------- ��
        OVBuffer[VBufInd].Param[5] := bP[4]; //---------------------------------------- ��
        OVBuffer[VBufInd].Param[6] := bP[5]; //---------------------------------------- ��
        OVBuffer[VBufInd].Param[7] := bP[6]; //--------------------------------------- ���
        OVBuffer[VBufInd].Param[8] := bP[7]; //--------------------------------------- ���
      end;
    end;
  end;
end;

//========================================================================================
//--------------------------------------- ���������� ������� �������� ���������� ����� #50
procedure PrepDCSU(Ptr : Integer);
var
  activ,nepar : boolean;
begin
  activ := true; //----------------------------------------------------------- �����������
  nepar := false; //------------------------------------------------------- ��������������

  ObjZv[Ptr].bP[1] := GetFR3(ObjZv[Ptr].ObCI[1], nepar,activ); //---------- 1��
  ObjZv[Ptr].bP[2] := GetFR3(ObjZv[Ptr].ObCI[2], nepar,activ); //---------- 1��

  ObjZv[Ptr].bP[3] := GetFR3(ObjZv[Ptr].ObCI[3], nepar,activ); //---------- 2��
  ObjZv[Ptr].bP[4] := GetFR3(ObjZv[Ptr].ObCI[4], nepar,activ); //---------- 2��

  ObjZv[Ptr].bP[5] := GetFR3(ObjZv[Ptr].ObCI[5], nepar,activ); //---------- 3��
  ObjZv[Ptr].bP[6] := GetFR3(ObjZv[Ptr].ObCI[6],nepar,activ); //----------- 3��

  ObjZv[Ptr].bP[7] := GetFR3(ObjZv[Ptr].ObCI[7],nepar,activ); //----------- 4��
  ObjZv[Ptr].bP[8] := GetFR3(ObjZv[Ptr].ObCI[8],nepar,activ); //----------- 4��

  ObjZv[Ptr].bP[9] := GetFR3(ObjZv[Ptr].ObCI[9],nepar,activ); //----------- 5��
  ObjZv[Ptr].bP[10] := GetFR3(ObjZv[Ptr].ObCI[10],nepar,activ);//---------- 5��

  ObjZv[Ptr].bP[11] := GetFR3(ObjZv[Ptr].ObCI[11],nepar,activ);//---------- 6��
  ObjZv[Ptr].bP[12] := GetFR3(ObjZv[Ptr].ObCI[12],nepar,activ);//---------- 6��

  ObjZv[Ptr].bP[13] := GetFR3(ObjZv[Ptr].ObCI[13],nepar,activ);//---------- 7��
  ObjZv[Ptr].bP[14] := GetFR3(ObjZv[Ptr].ObCI[14],nepar,activ);//---------- 7��

  ObjZv[Ptr].bP[15] := GetFR3(ObjZv[Ptr].ObCI[15],nepar,activ);//---------- 8��
  ObjZv[Ptr].bP[16] := GetFR3(ObjZv[Ptr].ObCI[16],nepar,activ);//---------- 8��

  ObjZv[Ptr].bP[31]:= activ;
  ObjZv[Ptr].bP[32]:= nepar;

  //-------------------------------------------------------- ��������� � ����� �����������
  if ObjZv[Ptr].BasOb > 0 then
  begin
    if ObjZv[ObjZv[Ptr].BasOb].bP[31] and  //------------ ���� �� ������� � ...
    not ObjZv[ObjZv[Ptr].BasOb].bP[32] then //----------------------- ���������
    begin
      ObjZv[Ptr].bP[17] := not ObjZv[ObjZv[Ptr].BasOb].bP[4];//----- �����
      ObjZv[Ptr].bP[18] := ObjZv[ObjZv[Ptr].BasOb].bP[4];    //-- ��������
    end else
    begin //------------ -------------- ����� ���������� ��������� ����������� �� ��������
      ObjZv[Ptr].bP[17] := false;
      ObjZv[Ptr].bP[18] := false;
    end;
  end;

  if ObjZv[Ptr].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31];
    OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[32];

    OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[1]; //---------- 1��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := ObjZv[Ptr].bP[2]; //---------- 1��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := ObjZv[Ptr].bP[3]; //---------- 2��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[5] := ObjZv[Ptr].bP[4]; //---------- 2��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[6] := ObjZv[Ptr].bP[5]; //---------- 3��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[7] := ObjZv[Ptr].bP[6]; //---------- 3��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[8] := ObjZv[Ptr].bP[7]; //---------- 4��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[9] := ObjZv[Ptr].bP[8]; //---------- 4��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[10] := ObjZv[Ptr].bP[9]; //--------- 5��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[11] := ObjZv[Ptr].bP[10]; //-------- 5��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[12] := ObjZv[Ptr].bP[11]; //-------- 6��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[13] := ObjZv[Ptr].bP[12]; //-------- 6��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[14] := ObjZv[Ptr].bP[13]; //-------- 7��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[15] := ObjZv[Ptr].bP[14]; //-------- 7��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[17] := ObjZv[Ptr].bP[15]; //-------- 8��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[18] := ObjZv[Ptr].bP[16]; //-------- 8��
    OVBuffer[ObjZv[Ptr].VBufInd].Param[19] := ObjZv[Ptr].bP[17]; //------ �����
    OVBuffer[ObjZv[Ptr].VBufInd].Param[20] := ObjZv[Ptr].bP[18]; // �����������
  end;
end;

//========================================================================================
//----------------------------------------------------- ������ �������������� �������� #51
procedure PrepDopDat(Ptr : Integer);
var
  Vid_Buf, i: Integer;
begin
  ObjZv[Ptr].bP[31] := true; ObjZv[Ptr].bP[32] := false;
  for i := 1 to 34 do ObjZv[Ptr].NParam[i] := false;

  for i := 1 to 10 do
  begin
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      ObjZv[Ptr].bP[i] :=
      GetFR3(ObjZv[Ptr].ObCI[i],ObjZv[Ptr].NParam[i],ObjZv[Ptr].bP[31]);
    end;
    if ObjZv[Ptr].ObCI[10+i] > 0 then //--- ���� ������������� ��������� �� ���������
    begin
      if ObjZv[Ptr].bP[i] then //------------------------------------------ ���� ���������
      begin
        if not ObjZv[Ptr].bP[i+10] then //------------------------------ �� ���� ���������
        begin
          ObjZv[Ptr].bP[i+10] := true; ObjZv[Ptr].bP[i+20] := false;

          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[Ptr].RU then
            begin
              InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+10],0,'');
              AddFixMes(MsgList[ObjZv[Ptr].ObCI[i+10]],4,3);
            end;
{$ELSE}
            InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+10],0,'');
            SBeep[3] := true;
{$ENDIF}
          end;
        end;
      end;
      if not ObjZv[Ptr].bP[i] then ObjZv[Ptr].bP[i+10] := false; //------- ���� ����������
    end;


    if ObjZv[Ptr].ObCI[20+i] > 0 then //-- ���� ������������� ��������� �� ����������
    begin
      if not ObjZv[Ptr].bP[i] then //------------------------------------- ���� ����������
      begin
        if not ObjZv[Ptr].bP[i+20] then //------------------------------ �� ���� ���������
        begin
          ObjZv[Ptr].bP[i+20] := true;  ObjZv[Ptr].bP[i+10] := false;
          if WorkMode.FixedMsg then
          begin
{$IFDEF RMDSP}
            if config.ru = ObjZv[Ptr].RU then
            begin
              InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+20],0,'');
              AddFixMes(MsgList[ObjZv[Ptr].ObCI[i+20]],4,3);
            end;
{$ELSE}
            InsNewMsg(Ptr,$1000+ObjZv[Ptr].ObCI[i+20],0,'');
            SBeep[3] := true;
{$ENDIF}
          end;
        end;
      end;
      if ObjZv[Ptr].bP[i] then ObjZv[Ptr].bP[i+20] := false;//------------- ���� ���������
      
    end;
  end;
  Vid_Buf := ObjZv[Ptr].VBufInd;

  if Vid_Buf > 0 then
  begin
    OVBuffer[Vid_Buf].Param[16] := ObjZv[Ptr].bP[31];
    for i := 1 to 10 do
    begin
      OVBuffer[Vid_Buf].Param[i] := ObjZv[Ptr].bP[i];
      OVBuffer[Vid_Buf].NParam[i] := ObjZv[Ptr].NParam[i];
    end;
  end;
end;

//========================================================================================
//------------------------ ������ ����������� ��� ��� ��������� �� ���������� �������� #52
procedure PrepSVMUS(MUS : Integer);
var
  MNK,Sos,Pin,j : integer;
begin
  ObjZv[MUS].bP[1] := false;
  MNK := ObjZv[MUS].BasOb;
  if MNK > 0 then
  begin
    if not ObjZv[MNK].bP[3] and ObjZv[MNK].bP[1]
    and ObjZv[MNK].bP[4] and ObjZv[MNK].bP[5] then
    begin //-------------------------------------------- �������� �������, ���� ��, �, �
      //---------------------- ��������� �� ������� ��� ������ �� ������ ������ ������ ���
      if ObjZv[MUS].ObCB[1] then Pin := 2 else Pin := 1;

      Sos := ObjZv[MUS].Sosed[Pin].Obj; Pin := ObjZv[MUS].Sosed[Pin].Pin;

      j := 50;
      while j > 0 do
      begin
        case ObjZv[Sos].TypeObj of
          2 :
          begin //---------------------------------------------------------------- �������
            case Pin of
              2 : if not ObjZv[ObjZv[Sos].BasOb].bP[1] then break;
              3 : if not ObjZv[ObjZv[Sos].BasOb].bP[2] then break;
              else   break;
            end;
            Pin := ObjZv[Sos].Sosed[1].Pin;
            Sos := ObjZv[Sos].Sosed[1].Obj;
          end;

          53 : //------------------------------------------------------------------- �����
          begin
            if (ObjZv[MUS].UpdOb = Sos) and (MNK = ObjZv[Sos].BasOb)
            then  begin  ObjZv[MUS].bP[1] := true;  break; end else
            if Pin = 1
            then begin Pin := ObjZv[Sos].Sosed[2].Pin; Sos := ObjZv[Sos].Sosed[2].Obj; end
            else begin Pin:=ObjZv[Sos].Sosed[1].Pin; Sos:=ObjZv[Sos].Sosed[1].Obj;end;
          end;

          else
            if Pin = 1 then
            begin Pin := ObjZv[Sos].Sosed[2].Pin; Sos := ObjZv[Sos].Sosed[2].Obj; end
            else begin Pin:=ObjZv[Sos].Sosed[1].Pin; Sos := ObjZv[Sos].Sosed[1].Obj; end;
        end;
        if (Sos = 0) or (Pin < 1) then break;
        dec(j);
      end;
    end;
  end;
end;

//========================================================================================
//--------------------------------- ���������� ������� ���������� ����� ��� ������� �� #54
procedure PrepST(SiT: Integer);
var
  Og : boolean;
begin
  ObjZv[SiT].bP[31] := true; //----------------------------------------------- �����������
  ObjZv[SiT].bP[32] := false; //------------------------------------------- ��������������

  ObjZv[SiT].bP[2] :=
  GetFR3(ObjZv[SiT].ObCI[1],ObjZv[SiT].bP[32],ObjZv[SiT].bP[31]); //-------------- �1

  ObjZv[SiT].bP[3] :=
  GetFR3(ObjZv[SiT].ObCI[2],ObjZv[SiT].bP[32],ObjZv[SiT].bP[31]); //-------------- �2

  Og := GetFR3(ObjZv[SiT].ObCI[3],ObjZv[SiT].bP[32],ObjZv[SiT].bP[31]);//--------- ��

  if Og <> ObjZv[SiT].bP[4] then
  begin //------------------------------------------------ ������� ���� �������� ���������
    if Og then
    begin //-------------------------------------------- ������������� ��������� ���������
      if WorkMode.FixedMsg then
      begin
{$IFDEF RMDSP}
        if config.ru = ObjZv[SiT].RU then
        begin
          InsNewMsg(SiT,272+$1000,0,''); //------- ���������� ���� ����� ������������ ����
          AddFixMes(GetSmsg(1,272, ObjZv[SiT].Liter,0),4,4);
          SBeep[4] := true;
          ObjZv[SiT].bP[4] := Og;
          ObjZv[SiT].dtP[1] := LastTime;
          inc(ObjZv[SiT].siP[1]);
        end;
{$ELSE}
          InsNewMsg(Sit,272+$1000,0,'');
          SBeep[3] := true;
{$ENDIF}
      end;
      ObjZv[SiT].bP[20] := false; //----------------------- ����� ���������� �������������
    end
    else ObjZv[SiT].bP[4] := Og;
  end;
  if ObjZv[SiT].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[SiT].VBufInd].Param[16] := ObjZv[SiT].bP[31]; //------- ����������
    OVBuffer[ObjZv[SiT].VBufInd].Param[1] := ObjZv[SiT].bP[32]; //---- ��������������
    if ObjZv[SiT].bP[31] and not ObjZv[SiT].bP[32] then
    begin
      OVBuffer[ObjZv[SiT].VBufInd].Param[2] := ObjZv[SiT].bP[2];//---------------- �1
      OVBuffer[ObjZv[SiT].VBufInd].Param[3] := ObjZv[SiT].bP[3];//---------------- �2
      OVBuffer[ObjZv[SiT].VBufInd].Param[4] := ObjZv[SiT].bP[4];//---------------- ��
    end;
  end;
end;

//========================================================================================
//------------------------------------------ ��������� ���������� ���������� � ������� #55
procedure PrepDopSvet(SvtDop : Integer);
var
  Signal : integer; //--------------- ������ ������� ������������ ���������������� �������
  VBUF : integer; //---------------------- ����� ����������� ��� ����������������� �������
  ij, GM, LS, Zs2, JMS, VKMG, PrS, EN : integer;
  Act, Nepar : boolean;
begin
  for ij:=1 to 6 do ObjZv[SvtDop].bP[ij] := false;

  GM   := ObjZv[SvtDop].ObCI[1];
  LS   := ObjZv[SvtDop].ObCI[2];
  Zs2  := ObjZv[SvtDop].ObCI[3];
  JMS  := ObjZv[SvtDop].ObCI[4];
  VKMG := ObjZv[SvtDop].ObCI[5];
  PrS  := ObjZv[SvtDop].ObCI[6];
  EN   := ObjZv[SvtDop].ObCI[10];

  Signal := ObjZv[SvtDop].BasOb;
  VBUF   := ObjZv[Signal].VBufInd;

  Act := true; //------------------------------------------------------------- �����������
  Nepar := false; //------------------------------------------------------- ��������������

  if GM  <>  0 then ObjZv[SvtDop].bP[1]:=  GetFR3(GM, Nepar,Act); //------------------- ��
  if LS  <>  0 then ObjZv[SvtDop].bP[2] := GetFR3(LS,Nepar,Act);  //------------------- ��
  if Zs2 <>  0 then ObjZv[SvtDop].bP[3] := GetFR3(Zs2,Nepar,Act); //------------------ 2��
  if JMS <>  0 then ObjZv[SvtDop].bP[4] := GetFR3(JMS,Nepar,Act); //------------------ ���
  if VKMG <> 0 then ObjZv[SvtDop].bP[5] := GetFR3(VKMG,Nepar,Act);//----------------- ����
  if PrS  <> 0 then ObjZv[SvtDop].bP[6] := GetFR3(PrS,Nepar,Act); //------------------- ��
  if EN   <> 0 then ObjZv[SvtDop].bP[10]:= GetFR3(EN,Nepar,Act);  //------------------- ��

  if VBUF > 0 then
  begin
    OVBuffer[VBUF].Param[20] := ObjZv[SvtDop].bP[1]; //-------------------------------- ��
    OVBuffer[VBUF].Param[22] := ObjZv[SvtDop].bP[2]; //---------------------------- ��(��)
    OVBuffer[VBUF].Param[21] := ObjZv[SvtDop].bP[3]; //------------------------------- 2��
    OVBuffer[VBUF].Param[23] := ObjZv[SvtDop].bP[4]; //------------------------------- ���
    OVBuffer[VBUF].Param[24] := ObjZv[SvtDop].bP[5]; //-------------------------------����
    OVBuffer[VBUF].Param[25] := ObjZv[SvtDop].bP[6]; //-------------------------------- ��
    OVBuffer[VBUF].Param[28] := ObjZv[SvtDop].bP[10]; //------------------------------- ��
  end;

  ObjZv[SvtDop].bP[31] := Act;   //------------------------------------------- �����������
  ObjZv[SvtDop].bP[32] := Nepar; //---------------------------------------- ��������������

end;

//========================================================================================
//----------------------------------------- ���������� ������� ��� ��� ������ �� ����� #56
procedure PrepUKG(UKG : Integer);
var
  vkgd,vkgd1,kg,okg : boolean;
  ob_vkgd,ob_vkgd1, kod,i : integer;
  TXT1 : string;
begin
  kod := 0;
  ObjZv[UKG].bP[31] := true; //----------------------------------------------- �����������
  ObjZv[UKG].bP[32] := false; //------------------------------------------- ��������������

  for i := 1 to 32 do ObjZv[UKG].NParam[i] := false;
  ob_vkgd := ObjZv[UKG].ObCI[4];
  ob_vkgd1 := ObjZv[UKG].ObCI[5];

  kg    := GetFR3(ObjZv[UKG].ObCI[2],ObjZv[UKG].NParam[2],ObjZv[UKG].bP[31]); //- ���
  okg   := GetFR3(ObjZv[UKG].ObCI[3],ObjZv[UKG].NParam[3],ObjZv[UKG].bP[31]); //- ���
  vkgd  := GetFR3(ob_vkgd,ObjZv[UKG].NParam[4],ObjZv[UKG].bP[31]);//----------------- ����
  vkgd1 := GetFR3(ob_vkgd1,ObjZv[UKG].NParam[5],ObjZv[UKG].bP[31]);//--------------- ����1

  if ObjZv[UKG].VBufInd > 0 then
  begin
    OVBuffer[ObjZv[UKG].VBufInd].Param[16] := ObjZv[UKG].bP[31];
    OVBuffer[ObjZv[UKG].VBufInd].Param[1] := ObjZv[UKG].NParam[2] or
    ObjZv[UKG].NParam[3] or  ObjZv[UKG].NParam[4] or  ObjZv[UKG].NParam[5];

    if ObjZv[UKG].bP[31] and not ObjZv[UKG].bP[32] then
    begin
      if kg then  kod := kod + 1;
      if okg then kod := kod + 2;
      if vkgd then kod := kod + 4;
      if vkgd1 then kod := kod + 8;

      ObjZv[UKG].bP[1] := kg;
      OVBuffer[ObjZv[UKG].VBufInd].Param[2] := KG;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[2] := ObjZv[UKG].NParam[2];

      ObjZv[UKG].bP[3] := vkgd;
      OVBuffer[ObjZv[UKG].VBufInd].Param[4] := vkgd;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[4] := ObjZv[UKG].NParam[4];

      ObjZv[UKG].bP[4] := vkgd1;
      OVBuffer[ObjZv[UKG].VBufInd].Param[5] := vkgd1;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[5] := ObjZv[UKG].NParam[5];

      ObjZv[UKG].bP[2] := okg;
      OVBuffer[ObjZv[UKG].VBufInd].Param[3] := okg;
      OVBuffer[ObjZv[UKG].VBufInd].NParam[3] := ObjZv[UKG].NParam[3];

      if kod <> ObjZv[UKG].iP[1] then   //--------------------- ��������� ��� �������� ���
      begin
        if not ObjZv[UKG].T[1].Activ  then //---------------------- ���� ������ �� �������
        begin
          ObjZv[UKG].T[1].Activ  := true; //------------------------ �������������� ������
          ObjZv[UKG].T[1].F := LastTime + 2 / 86400; //-------- ����� �������� �� 2���
        end;
      end;

      if ObjZv[UKG].T[1].Activ  and //-------------------------- ���� ������ ������� � ...
      (LastTime > ObjZv[UKG].T[1].F) then //------------------- ������� ����� ��������
      begin
{$IFDEF RMDSP}
        if WorkMode.FixedMsg and (config.ru = ObjZv[UKG].RU) then
        case kod of
          4,8,12:  //---------------------------------------------- ��������, �� ���������
          begin
            InsNewMsg(UKG,554+$1000,0,''); //--------------------- ���������� �������� ���
            TXT1 := GetSmsg(1,554,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,2);
            PutSMsg(7,LastX,LastY,TXT1);
            SBeep[2] := WorkMode.Upravlenie;
          end;

          1,5,9,13://--------------------------------------------- ����������� �����������
          begin
            InsNewMsg(UKG,553+$1000,0,''); //------------------------------- ��� ���������
            TXT1 := GetSmsg(1,553,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,2);
            PutSMsg(7,LastX,LastY,TXT1);
          end;

          0://---------------------------------------- ��������� ��������� ����������� ���
          begin
            InsNewMsg(UKG,557+$1000,0,''); //-------------------- ��� ��������� � ��������
            TXT1 := GetSmsg(1,557,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,0,2);
            PutSMsg(2,LastX,LastY,TXT1);
            SBeep[2] := WorkMode.Upravlenie;
          end;

          3: //----------------------------------------------- ��������� ������� ��1 � ���
          begin
            InsNewMsg(UKG,552+$1000,0,''); //------------------------- �������� ������ ���
            TXT1:= GetSmsg(1,552,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,3);
            PutSMsg(1,LastX,LastY,TXT1);
          end;

          else
          begin
            InsNewMsg(UKG,550+$1000,0,''); //------------------ ����������� �������� �����
            TXT1 := GetSmsg(1,550,ObjZv[UKG].Liter,0);
            AddFixMes(TXT1,4,3);
            PutSMsg(11,LastX,LastY,TXT1);
          end;
        end;

{$ELSE}
        case kod of
          4,8,12:  //---------------------------------------------- ��������, �� ���������
          begin   InsNewMsg(UKG,554+$1000,0,''); SBeep[3] := true; end;
          5,9,13:  //------------------------ ���������� �������� ���������(���) ���������
          begin  InsNewMsg(UKG,553+$1000,0,'');  SBeep[3] := true; end;

          0: //------------- ��������� ��������� ����������� ���, ��� ��������� � ��������
          begin InsNewMsg(UKG,557+$1000,0,''); SBeep[3] := true; end;

          3: //--------------------------------- ��������! ������������� ������������ ���!
          begin InsNewMsg(UKG,552+$1000,0,''); SBeep[3] := true; end;

          else //---------------------------------------------- ����������� �������� �����
          begin InsNewMsg(UKG,550+$1000,0,''); SBeep[3] := true; end;
        end;
{$ENDIF}
        ObjZv[UKG].T[1].Activ  := false;
        ObjZv[UKG].T[1].F := 0;
      end;

      ObjZv[UKG].iP[1] := kod;
    end;
  end;
end;

//========================================================================================
//----------------------------------------- ���������� ������� ��� ��� ������ �� ����� #60
procedure PrepRDSH(RDSH : Integer);
var
  i,rele,Vbufer : integer;
  TXT1 : string;
begin
    ObjZv[RDSH].bP[31] := true; //-------------------------------------------- �����������
    ObjZv[RDSH].bP[32] := false; //---------------------------------------- ��������������

    for i := 1 to 32 do ObjZv[RDSH].NParam[i] := false;

    for i := 1 to 24 do
    begin
      rele := ObjZv[RDSH].ObCI[i];
      if rele > 0 then
      ObjZv[RDSH].bP[i] :=
      GetFR3(rele+2,ObjZv[RDSH].NParam[i],ObjZv[RDSH].bP[31]) or
      GetFR3(rele+3,ObjZv[RDSH].NParam[i],ObjZv[RDSH].bP[31]);
    end;

    if ObjZv[RDSH].VBufInd > 0 then
    begin
      Vbufer := ObjZv[RDSH].VBufInd;
      OVBuffer[VBufer].Param[1] := false;
      OVBuffer[VBufer].NParam[1] := false;
      OVBuffer[VBufer].Param[16] := ObjZv[RDSH].bP[31];

      for i := 1 to 24 do
      begin
        OVBuffer[VBufer].Param[1] :=  OVBuffer[VBufer].Param[1] or ObjZv[RDSH].bP[i];
        if ObjZv[RDSH].bP[i] then break;
        OVBuffer[VBufer].NParam[1] := OVBuffer[VBufer].NParam[1] or ObjZv[RDSH].NParam[i];
      end;

      if i <= 24 then
      begin
        rele := ObjZv[RDSH].ObCI[i];  TXT1 := LinkFr[rele].Name;
      end;

      if not OVBuffer[VBufer].Param[1] then ObjZv[RDSH].T[1].F := 0;
{$IFDEF RMDSP}
      if WorkMode.FixedMsg and (config.ru = ObjZv[RDSH].RU)
      and OVBuffer[VBufer].Param[1] and (ObjZv[RDSH].T[1].F = 0) then
      begin
        InsNewMsg(rele{RDSH},581 + $1000,0,TXT1); //---- ������������� ��������� ����������� ���
        TXT1 := GetSmsg(1,581,TXT1,0);
        AddFixMes(TXT1,4,2);
        PutSMsg(7,LastX,LastY,TXT1);
        ObjZv[RDSH].T[1].F := LastTime;
        SBeep[2] := WorkMode.Upravlenie;
      end;
{$ELSE}
      if OVBuffer[ObjZv[RDSH].VBufInd].Param[1] and (ObjZv[RDSH].T[1].F = 0) then
      begin
       InsNewMsg(RDSH,581+$1000,0,TXT1);
       ObjZv[RDSH].T[1].F := LastTime;
       SBeep[3] := true;
      end;
{$ENDIF}
    end;
end;

//========================================================================================
//--------------------------------------------------- ���������� ��� ������� ����/���� #92
procedure PrepDN(Ptr : Integer);
var
  dnk,nnk,auk,dn : boolean;
  dnk_kod,nnk_kod,auk_kod,dn_kod,AllKod : integer;
begin
    ObjZv[Ptr].bP[31] := true; //---------------------------------------- �����������
    ObjZv[Ptr].bP[32] := false; //------------------------------------ ��������������

    //--------------------- ������ �������� ������� ������ "����"
    dnk := GetFR3(ObjZv[Ptr].ObCI[2],ObjZv[Ptr].NParam[1],ObjZv[Ptr].bP[31]);
    if dnk then dnk_kod := 1
    else dnk_kod :=0;

    //--------------------- ������ �������� ������� ������ "����"
    nnk := GetFR3(ObjZv[Ptr].ObCI[3],ObjZv[Ptr].Nparam[2],ObjZv[Ptr].bP[31]);
    if nnk then nnk_kod := 1
    else nnk_kod :=0;

    //------------------ ������ �������� ������� ������ "�������"
    auk := GetFR3(ObjZv[Ptr].ObCI[4],ObjZv[Ptr].NParam[3],ObjZv[Ptr].bP[31]);
    if auk then auk_kod := 1
    else auk_kod :=0;

    //----------------------- ������ �������� ������� "����/����"
    dn := GetFR3(ObjZv[Ptr].ObCI[5],ObjZv[Ptr].NParam[4],ObjZv[Ptr].bP[31]);
    if dn then dn_kod := 1
    else dn_kod :=0;
    AllKod := dnk_kod*8 + nnk_kod*4 + auk_kod*2 + dn_kod;

    if (ObjZv[Ptr].iP[1] <> AllKod) then //���� ���������� ��������� ������ �������
    begin
      ObjZv[ptr].iP[1] := AllKod;
      ObjZv[Ptr].dtP[1] := LastTime;
      case AllKod of
        //-------------------------------------------------------------------------------
        2: //--------------------------------------------------- ������� ����� � ��������
        begin // ������ ������ "�������"
          if WorkMode.FixedMsg then
          begin
            {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,362+$1000,0,''); //--------------------------- ������� �������
              AddFixMes(GetSmsg(1,362, ObjZv[ptr].Liter,0),4,4);
              InsNewMsg(Ptr,360+$1000,0,''); //------------------------------ ������� ����
              AddFixMes(GetSmsg(1,360, ObjZv[ptr].Liter,0),4,4);
              inc(ObjZv[Ptr].siP[1]);
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
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,362+$1000,0,''); //--------------------------- ������� �������
              AddFixMes(GetSmsg(1,362, ObjZv[ptr].Liter,0),4,4);
              InsNewMsg(Ptr,361+$1000,0,''); //----------------------------- �������� ����
              AddFixMes(GetSmsg(1,361, ObjZv[ptr].Liter,0),4,4);
              inc(ObjZv[Ptr].siP[1]);
            end;
          {$ENDIF}
          end;
         end;

         4,6,7,9..15: //------------------------ ������� ����� ������������
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,516+$1000,0,'');
              AddFixMes(GetSmsg(1,516, ObjZv[ptr].Liter,0),4,4);
              ObjZv[Ptr].dtP[1] := LastTime;
              inc(ObjZv[Ptr].siP[1]);
            end;
            {$ENDIF}
          end;
         end;
         5: //------------------------------------------------------- ���� � ������ ������
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,361+$1000,0,'');
              AddFixMes(GetSmsg(1,361, ObjZv[ptr].Liter,0),4,4);
              inc(ObjZv[Ptr].siP[1]);
            end;
          {$ENDIF}
          end;
         end;
         8: //------------------------------------------------------- ���� � ������ ������
         begin
          if WorkMode.FixedMsg then
          begin
          {$IFDEF RMDSP}
            if config.ru = ObjZv[ptr].RU then
            begin
              InsNewMsg(Ptr,360+$1000,0,'');
              AddFixMes(GetSmsg(1,360, ObjZv[ptr].Liter,0),4,4);
              ObjZv[Ptr].dtP[1] := LastTime;
              inc(ObjZv[Ptr].siP[1]);
            end;
            {$ENDIF}
          end;
         end;
      end;
    end;
    ObjZv[Ptr].bP[1] := dnk;
    ObjZv[Ptr].bP[2] := nnk;
    ObjZv[Ptr].bP[3] := auk;
    ObjZv[Ptr].bP[4] := dn;

    if ObjZv[Ptr].VBufInd > 0 then
    begin
      OVBuffer[ObjZv[Ptr].VBufInd].Param[16] := ObjZv[Ptr].bP[31]; //����������
      if ObjZv[Ptr].bP[31] then
      begin
        OVBuffer[ObjZv[Ptr].VBufInd].Param[1] := ObjZv[Ptr].bP[1];//������ "����"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[1] := ObjZv[Ptr].NParam[1];

        OVBuffer[ObjZv[Ptr].VBufInd].Param[2] := ObjZv[Ptr].bP[2];//������ "����"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[2] := ObjZv[Ptr].NParam[2];

        OVBuffer[ObjZv[Ptr].VBufInd].Param[3] := ObjZv[Ptr].bP[3];//������ "����"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[3] := ObjZv[Ptr].NParam[3];

        OVBuffer[ObjZv[Ptr].VBufInd].Param[4] := ObjZv[Ptr].bP[4];//- ������ "��"
        OVBuffer[ObjZv[Ptr].VBufInd].NParam[4] := ObjZv[Ptr].NParam[4];

        OVBuffer[ObjZv[Ptr].VBufInd].DZ3 := AllKod;
      end;
    end;
end;
end.
