unit Marshrut;
{$INCLUDE d:\Sapr2012\CfgProject}
//------------------------------------------------------------------------------
//             ��������� � ��������� ��������� ��������� ��-���
//------------------------------------------------------------------------------
interface

uses
  Windows,
  SysUtils,
  TypeAll;
var
  MarhRdy      : Boolean; //----------------- ������� ���������� �������� � ������ � �����
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

//================== ������� ����������� ����� ������� ===================================
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

//==================  ������� ����������� ����� �� ��� �� ================================
function StepTrasSP    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpPutFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpZavTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepS�ChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpZamTras (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpCirc    (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpOtmen   (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpRazdel  (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpPovtRazd(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpFindIzv (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSpFindStr (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
function StepSPPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;


//==================  ������� ����������� ����� ����  ====================================
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

//==================   ������� ����������� ����� ��������� ===============================
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

//==================== ������� ����������� ����� �������������� ==========================
function StepTrasAB(var Con:TSos; const Lvl:TTrLev; Rod:Byte; AB:TSos) : TTrRes;

//==================== ������� ����������� ����� ��������������� ������ ==================
function StepTrasPrigl(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Prig:TSos) : TTrRes;

//==================== ������� ����������� ����� ����� ===================================
function StepTrasUksps(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Uksps:TSos) : TTrRes;

//==================== ������� ����������� ����� ��������������� �� ======================
function StepTrasVsn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Vsn:TSos) : TTrRes;

//==================== ������� ����������� ����� ������ � ���������� ������� =============
function StepTrasManRn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; ManR:TSos) : TTrRes;

//==================== ������ �������� ��������� ����������� =============================
function StepTrasZapPO(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Zapr:TSos) : TTrRes;

function StepTrasPAB(var Con:TSos; const Lvl:TTrLev; Rod:Byte; PAB:TSos) : TTrRes;

function StepTrasDZOhr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Dz:TSos) : TTrRes;

function StepTrasIzPer(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Per:TSos) : TTrRes;

function StepTrasDZSp (var Con:TSos; const Lvl:TTrLev; Rod:Byte; DZSp:TSos) : TTrRes;

function StepTrasPSogl(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sogl:TSos) : TTrRes;

function StepUvazGor(var Con:TSos; const Lvl:TTrLev;Rod:Byte; Uvaz:TSos):TTrRes;

function StepTrasNad(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Nad:TSos):TTrRes;

//======= ����������� ����� ��������� �������� ����������� ��� ������� � ���� ============
function StepTrasOtpr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Otpr:TSos) : TTrRes;

//============= �������� ������������� ��������� ������ ��� ������� � ���� (42) ==========
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
function AutoMarsh(AvtoM : SmallInt; mode : Boolean) : Boolean; //���/���� �����. ��������
function CheckAutoMarsh(AvtoS : SmallInt; Grp : Byte) : Boolean;
function AutoMarshON(AvtoS : SmallInt; Napr : Boolean): Boolean;//���������� �����.�������
function AutoMarshOFF(AvtoS : SmallInt; Napr : Boolean  ) : Boolean; //����� �����.�������

const
  MarshM = 3;   //----------------------------------------------------- ���������� �������
  MarshP = 12;  //------------------------------------------------------- �������� �������
  MarshL = 19;  //--------------------------------------------------- ���������� ���������

  TryMarhLimit = 6962;//----------------------- ������� �������� ��� ����������� ��������.
                      //----------------  ���-�� ��������� �������� �������� ��� ��������,
                      //-------- �� ��������� 231 ("�������� ������� ������� �����������")

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
//----------------------------------------------------- �������� ��������� ������ ��������
var
  i,k,sp,sig : integer;
begin
  WorkMode.GoTracert  := false; //-------------------- �������� ������� "���� �����������"
  MarhTrac.SvetBrdr   := 0;//----- ����� ������� ���������,���������. ������������ �������
  MarhTrac.AutoMarh   := false; //--- ����� �������� �������.�������� ������������ �������
  MarhTrac.Povtor     := false; //------ ����� �������� ��������� �������� ������ ��������
                                    //- (��� ������ �������� ���������. ��������� �� ����)
  MarhTrac.GonkaStrel := false;//-------- ����� �������� ������������ ������ ������� �����
                                    //  ������� (��� ������ �������� ��� ��������� ������)
  MarhTrac.GonkaList  := 0; //-- ����� ���������� ������� ��� ������ ������� ����� �������
  MarhTrac.LockPovtor := false;//---- ����� �������� ���������� ������ ��������� ���������
                                    //            �������� ����� ����������� �������������
  MarhTrac.Finish     := false; //--------- ����� ���������� ������� ������ "����� ������"
  MarhTrac.TailMsg    :=  '';  //-------------------- �������� ��������� � ������ ��������
  MarhTrac.FindTail   := false; // ����� �������� ������ ��������� � ����� ������ ��������
  MarhTrac.WarN   := 0; //----------- ����� �������� �������������� ��� ��������� ��������
  MarhTrac.MsgN   := 0; //--------------------------- ����� �������� ��������� �����������
  k := 0;
  MarhTrac.VP         := 0; //--------- �������� ������ �� ��� ����������� �������� ������
  MarhTrac.TraSRazdel := false;//----- ����� �������� ����������� � ���������� ����������

  if MarhTrac.ObjStart > 0 then //----------------------- ���� ���� ������ ������ ��������
  begin //------------------------------------------------ ����� �������� ��� �� ���������
    k := MarhTrac.ObjStart;
    if not ObjZv[k].bP[14] then //------------------------ ���� ��� ������������ ���������
    //-------------------------------------------- ����� ���������� � �������� �����������
    begin ObjZv[k].bP[7] := false; ObjZv[k].bP[9] := false; end;
  end;

  MarhTrac.ObjStart := 0;

  for i := 1 to WorkMode.LimitObjZav do
  begin //-------------------------- ������ ��������� ����������� �� ���� �������� �������
    with ObjZv[i] do
    case TypeObj of
      1: begin bP[27] := false;  iP[3] := 0; end;//------------------------- ����� �������
      2: begin bP[10]:= false;bP[11]:= false;bP[12]:= false;bP[13]:= false; end;// �������
      3: begin if not bP[14] then bP[8] := true;  end; //-------------------------- ������
      4: begin if not bP[14] then bP[8] := true;  end; //---------------------------- ����
      5: if not bP[14] and bP[11]//�������� ��� �������������� � ��������������� ���������
         then begin bP[7] := false; bP[9] := false; end;
      8: bP[27] := false; //---------------------------------------------------------- ���
      //- �� ��� �����. � ��������. ���������
      15:if not bP[14] and ObjZv[BasOb].bP[2] then bP[15] := false;
      25:if not bP[14] then bP[8] := false; //---- �������, ��� ���������������� ���������
      //-----------------------------------������� � ���� - �������� �������� �����������
      41 :
      begin
        sp := UpdOb; sig := BasOb; //----------------------------- �� � ������ �����������
        if not ObjZv[sp].bP[14] and ObjZv[sp].bP[2] and //------------ ��� ��������� � ...
        not ObjZv[sig].bP[3] and not ObjZv[sig].bP[4] then //--- ������ �� ������ ��������
        begin bP[20] := false; bP[21] := false; end; //�������� �������� �������� � ������
      end;
      42 :
      begin //-------------------------------------- ������������� ��������� �� ����������
        sp := UpdOb;     //---------------------------------- �������������� ������
        if not ObjZv[sp].bP[14] and  ObjZv[sp].bP[2] then //------- ��� �������� ���������
        begin bP[1] := false; bP[2] := false; end; // ����� �������� ����� � �������������
      end;
    end;
  end;

  with MarhTrac do
  begin
    //------------------------------------------------------------- �������� ��� ���������
    for i:= 1 to High(Msg) do begin Msg[i]:= ''; MsgInd[i]:= 0; MsgObj[i]:= 0; end;
    MsgN:= 0;

    //-------------------------------------------------------- �������� ��� ��������������
    for i:= 1 to High(War) do begin War[i]:= ''; WarInd[i]:= 0; WarObj[i]:= 0; end;
    WarN := 0;

    //---------------------------------------------------------- �������� ��� ����� ������
    for i:= 1 to High(ObjTRS) do ObjTRS[i]:= 0; MarhTrac.Counter := 0;

    //-------------------------------------------------------- �������� ��� ������� ������
    for i := 1 to High(StrOtkl) do
    begin StrOtkl[i]:=0; PolTras[i,1]:= false; PolTras[i,2]:= false; end;
    StrCount:= 0;

    ObjEnd := 0; ObjLast := 0; ObjStart := 0; PinLast := 0; Rod := 0;
  end;

  WorkMode.GoTracert := false;

  if (k > 0) and not ObjZv[k].bP[14] then
  begin InsNewMsg(k,2,1,''); ShowSMsg(2,LastX,LastY,'�� '+ ObjZv[k].Liter); end;
  ResetTrace := true;
  ZeroMemory(@MarhTrac,sizeof(MarhTrac));
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function ResetMarhrutSrv(fr : word) : Boolean;
//---------------------------------------------------- ������� �� ����� �������� � �������
var
  i,im : integer;
begin
  im := 0;
  //------------------------------------------------- ����� ������� �������� �� ������ FR3
  for i := 1 to WorkMode.LimitObjZav do
  if ObjZv[i].TypeObj = 5 then
  begin
    if ObjZv[i].ObCI[3] > 0 then
    if fr = (ObjZv[i].ObCI[3] div 8) then begin im := i; break; end;

    if ObjZv[i].ObCI[5] > 0 then
    if fr = (ObjZv[i].ObCI[5] div 8) then begin im := i; break; end;
  end;

  if im > 0 then // ���������� ����� �������� ������� ��� ���� ���������� ������� ��������
  begin
    for i := 1 to WorkMode.LimitObjZav do
    if ObjZv[i].TypeObj = 5 then
    if ObjZv[i].iP[1] = im then ObjZv[i].bP[34] := true;//�� ��������� ���������� ��������

    if ObjZv[im].RU = config.ru then //--------- ������� ��������� � ������������ ��������
    begin MsgStateRM := GetSmsg(2,7,ObjZv[im].Liter,1);  MsgStateClr := 1; end;
    InsNewMsg(im,7+$400,1,'');
    ResetMarhrutSrv := true;
  end else ResetMarhrutSrv := false; //---------------------- ������ �������� �� ���������
end;

//========================================================================================
//----------------------------------------------------------------------------------------
procedure InsWar(Obj,Index : SmallInt);
//---------------------------------------------------------- �������� ����� ��������������
begin
  MarhTrac.WarObj[MarhTrac.WarN] := Obj;
  MarhTrac.WarInd[MarhTrac.WarN] := Index;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
procedure InsMsg(Obj,Index : SmallInt);
//----------------------------------------------------- �������� ������������ ������������
begin
  MarhTrac.MsgObj[MarhTrac.MsgN] := Obj;
  MarhTrac.MsgInd[MarhTrac.MsgN] := Index;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
//------------------------------------------ ������� ������ � ���������� ������ ����������
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

  // ��������� ������������ �� ���� ������
  i := 1000;
  jmp := ObjZv[Svetofor].Sosed[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTrac.Level := tlRazdelSign; //---------- ����� ������� ������ � ����������
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
  begin // ������ �������� ���������
    result := false;
    InsNewMsg(Svetofor,228,1,'');
    ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
    MarhTrac.LockPovtor := true; MarhTrac.ObjStart := 0;
    exit;
  end;

  if MarhTrac.MsgN > 0 then
  begin  //--------------------------------------------------------- ����� �� ������������
    MarhTrac.TraSRazdel := true;//---- ��������� ����������� ���� ���� ������������
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
    result := false;
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  //-------- ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki (Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1); //
    InsWar(MarhTrac.ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- ����� ���������

    NewMenu_(CmdMarsh_Razdel,LastX,LastY);
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
end;

//========================================================================================
//---------------------- �������� ����������� ������ ������� �������� ������� ������������
function CheckAutoMarsh(AvtoS : SmallInt; Grp : Byte) : Boolean;
//------------------------------ AvtoS - ������ ������������ ��� ��������� � �������������
//--------------------------------------------------------------------- Grp - ������ ���
var
  i, Sig, SP, ZUch : Integer;
  jmp : TSos;
  tr : boolean;
begin
    result := false;
    Sig := ObjZv[AvtoS].BasOb; //-------------------------------- ������ ������������
    ZUch := ObjZv[AvtoS].UpdOb; //------------------- �������� ������� ������������
    SP := ObjZv[Sig].BasOb; //--------------- ����������� ������ ������� ������������
    //------------------------- ��������� ������� ������������������ �������� ������������
    if ObjZv[AvtoS].bP[2] then   //--- ���� ������������� �������, ������ ��� ������������
    begin
      //----------------------------------------- ������� ���������� �������� ������������
      MarhTrac.Rod := MarshP;
      MarhTrac.Finish := false;
      MarhTrac.WarN := 0;
      MarhTrac.MsgN := 0;
      MarhTrac.ObjStart := Sig; //------------------------ �������� � �������������
      MarhTrac.Counter := 0;

      //- ������ ������� �������� ������� ������������ � ���� ����������� �������� �������

      jmp := ObjZv[Sig].Sosed[2]; //----- ����� ��������� �� ������� 2
      MarhTrac.FindTail := true;
      //--------------------------------- ��������� ��������� ����������� ������ ���������

      if ObjZv[SP].bP[2] then //------------------------------- ���� ����� "�" �����������
      begin
        //------- ����� ������� ������� ����������� ������ ��� ���������� ��������� ������
        ObjZv[AvtoS].bP[3] := false; //---- ����� �������� ����.������� �� �������� �����.
        ObjZv[AvtoS].bP[4] := false;//--- ����� �������� ����.������� ��� �������� �������
        ObjZv[AvtoS].bP[5] := false;  //---- ����� �������� ����.������ �����.� ����������
        tr := true;
      end else
      begin
        //----- ��������� ������� ����������� ������ ����� ��������� �������� ������������
        tr := false;
        if ObjZv[AvtoS].bP[3] then
        begin //������������� ��������� ����������� �� ��� ��������� �������� ������������
          if not ObjZv[AvtoS].bP[4] then  // �� ���� �������� ������� ��� �������� �������
          begin
            if not ObjZv[AvtoS].bP[5] then //--------- �� ���� �������� ���������� �������
            begin
              InsNewMsg(Sig,475,1,'');//----------- ������ �� ������ �������� ������������
              AddFixMes(GetSmsg(1,475,ObjZv[Sig].Liter,1),4,5);
              ObjZv[AvtoS].bP[5] := true;  //------------------ ��������� ������ ���������
            end;
          end;
          MarhTrac.ObjStart := 0;
          exit;
        end else//--------------------------------------------------- ���� ������ ��������
        if ObjZv[SP].bP[1] then MarhTrac.Level := tlSignalCirc//����� ������.������
        else //-------------------------------------------------------- ���� ������ ������
        begin
          ObjZv[AvtoS].bP[3] := true; //------------ ����������� ������� ������ � ��������

          //- �������� ������ ������, �������� ������� ����������� �� ��� �������� �������
          if ObjZv[Sig].bP[4] then ObjZv[AvtoS].bP[4] := true;

          MarhTrac.ObjStart := 0;
          exit;
        end;
      end;

      if tr then //----------------------------------------- ����������� ������ ����������
      begin
        if ObjZv[Sig].bP[9] or ObjZv[Sig].bP[14] then//�������� ������ ��� �����.���������
         MarhTrac.Level := tlPovtorRazdel //--- ����� ������ �������� �� ����������
         else  MarhTrac.Level := tlRazdelSign;//- ����� ������� ������ � ����������
      end;

      MarhTrac.AutoMarh := true;
      MarhTrac.SvetBrdr := Sig;
      ObjZv[Sig].bP[9] := true;  //-------------------------- ������� �������� �����������

      i := 1000;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
          trStop, trEnd, trKonec :  break;
        end;
        dec(i);
      end;
      if i < 1 then exit; //------------------------------------ ������ �������� ���������

      if MarhTrac.MsgN > 0 then //--------------- ���� ��������� � ������������
      begin MarhTrac.ObjStart := 0; exit; end; //------------ ����� �� ������������
      result := true;
    end else //--------------------------------------------- ��� ���������� ��������������
    begin //------------------ ��������� ������������ �� ���� ������ �������� ������������
      ObjZv[Sig].bP[7] := false; //--------- ����� ���������� ����������� � ������� ������
      ObjZv[Sig].bP[9] := false; //----------- ����� �������� ����������� � ������� ������
      MarhTrac.Rod := MarshP;
      MarhTrac.Finish := false;
      MarhTrac.WarN := 0;
      MarhTrac.MsgN := 0;
      MarhTrac.ObjStart := Sig;
      MarhTrac.Counter := 0;

      i := 1000;
      jmp := ObjZv[Sig].Sosed[2];
      MarhTrac.Level := tlAutoTrace; // �����  ������� ������ � �����. ������������

      MarhTrac.FindTail := true;
      while i > 0 do
      begin
        case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
          trStop, trEnd, trKonec : break;
        end;
        dec(i);
      end;

      if i < 1 then exit; //------------------------------------ ������ �������� ���������

      if MarhTrac.MsgN > 0 then
      begin
        MarhTrac.ObjStart := 0;
        MarhTrac.MsgN := 0;
        exit; //---------------------------------------------------- ����� �� ������������
      end;

      case ObjZv[ZUch].TypeObj of //------------------------------- ����� �������� �������
        4 :
        begin //--------------------------------------------------------------------- ����
          if not ObjZv[ZUch].bP[1] or not ObjZv[ZUch].bP[16] then  //- ����� ������ ��� ��
          begin  MarhTrac.ObjStart := 0;  exit; end; //------------- ����� ��������
        end;

        15 :
        begin //----------------------------------------------------------------------- ��
          if not ObjZv[ZUch].bP[2] then   //------------------------------------ ����� 1��
          begin   MarhTrac.ObjStart := 0;  exit; end;//------------- ����� ��������
        end;

        else //--------------------------------------------------------------------- ��,��
          if not ObjZv[ZUch].bP[1] then  //----------------------------------- ����� ��/��
          begin MarhTrac.ObjStart := 0; exit; end; //--------------- ����� ��������
      end;
      ObjZv[AvtoS].bP[2] := true;//��� ������ �� ������ ������������, ������ �������������
    end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Grp : Byte) : Boolean;
//----------------------------------------- ������� �������� ���������� �������� ���������
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
    //---------------------------------------------- ��������� ������������ �� ���� ������
    i := 1000;
    jmp := ObjZv[Svetofor].Sosed[2];
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlSignalCirc;  //----------------- ����� ���������� ������
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
    begin //---------------------------------------------------- ������ �������� ���������
      InsNewMsg(Svetofor,228,1,''); //---------------------- ������ �������� �� $ ��������
      result := false;
      ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
      MarhTrac.LockPovtor := true;
      MarhTrac.ObjStart := 0;
      exit;
    end;

    if MarhTrac.MsgN > 0 then
    begin  //------------------------------------------------------- ����� �� ������������
    // ��������� ����������� � �������� ������ ���� ���� ������������
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
    result := false;
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;
  //-------- ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki(Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsWar(MarhTrac.ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- ����� ���������
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
//�������� ���������� �������� ������� (� ����������) �� ���������������� ��������� ������
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
  //------------------------------------------------ ��������� ������������ �� ���� ������
  i := 1000;
  jmp := ObjZv[Svetofor].Sosed[2];

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  MarhTrac.Level := tlPovtorRazdel;  //----- ����� ������ �������� �� ����������
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
  begin // ������ �������� ���������
    InsNewMsg(Svetofor,228,1,'');
    result := false;
    ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  if MarhTrac.MsgN > 0 then
  begin  //--------------------------------------------------------- ����� �� ������������
    //--------------------- ��������� ����������� � �������� ������ ���� ���� ������������
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
    result := false;
    MarhTrac.LockPovtor := true;
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    MarhTrac.ObjStart := 0;
    exit;
  end;

  //-------- ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki(Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsWar(MarhTrac.ObjStart,333);
  end;
  
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- ����� ���������
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
//-------------------------------------------------- ��������� ��������� �������� ��������
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
    //---------------------------------------------- ��������� ������������ �� ���� ������
    i := 1000;
    jmp := ObjZv[Svetofor].Sosed[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlPovtorMarh; //------- ����� ��������� ��������� ��������
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
    begin //---------------------------------------------------- ������ �������� ���������
      InsNewMsg(Svetofor,228,1,''); //-------------------- "������ �������� �� $ ��������"
      result := false;
      ShowSMsg(228, LastX, LastY, ObjZv[Svetofor].Liter);
      MarhTrac.LockPovtor := true;
      MarhTrac.ObjStart := 0;
      exit;
    end;

    if MarhTrac.MsgN > 0 then
    begin  //------------------------------------------------------- ����� �� ������������
      //------------------- ��������� ����������� � �������� ������ ���� ���� ������������
      InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
      PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);
      result := false;
      MarhTrac.LockPovtor := true;
      MarhTrac.ObjStart := 0;
      exit;
    end;

    //---------------------------------------------- ��������� ������������ �� ���� ������
    i := 1000;
    MarhTrac.SvetBrdr := Svetofor;
    MarhTrac.Povtor := true;
    MarhTrac.MsgN := 0;
    //----------- "�������" ������������ ������, ������������� ������ �� �������� ��������
    MarhTrac.HTail := MarhTrac.ObjTRS[1];
    jmp := ObjZv[MarhTrac.ObjStart].Sosed[2];

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlCheckTrace;//---- ����� �������� ������������� �� ������ 
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
      begin // ��������� ������ ����� ������
        // ������������ � ������
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
  begin // ����� �� ���������� ��������
    InsNewMsg(Svetofor,231,1,'');
    RestorePrevTrace; result := false;
    ShowSMsg(231, LastX, LastY, '');
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  if MarhTrac.MsgN > 0 then
  begin  //--------------------------------------------------------- ����� �� ������������
    //--------------------- ��������� ����������� � �������� ������ ���� ���� ������������
    InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
    PutSMsg(1,LastX,LastY,MarhTrac.Msg[Grp]);
    result := false;
    MarhTrac.LockPovtor := true;
    MarhTrac.ObjStart := 0;
    exit;
  end;

  //-------- ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
  if FindIzvStrelki(Svetofor, MarhTrac.Rod) then
  begin
    inc(MarhTrac.WarN);
    MarhTrac.War[MarhTrac.WarN] :=
    GetSmsg(1, 333, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsWar(MarhTrac.ObjStart,333);
  end;
{$IFNDEF RMARC}
  if MarhTrac.WarN > 0 then
  begin //---------------------------------------------------------------- ����� ���������
    NewMenu_(CmdMarsh_PovtorMarh,LastX,LastY);
    DspMenu.WC := true;
    result := false;
    exit;
  end;
{$ENDIF}
  result := true;
end;

//========================================================================================
// ��������� �������������� ������� �� ���������� ������ �� ����������� �������� (��� ���)
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
//--------------------------------- Svetofor - ������ ������������ ������� ������ ��������
//------------------------------------------ Marh - ��� �������� (�������� ��� ����������)
//---------------------- ����������  ������� ����������� ������� &  ������� ������� ������
var
  i : integer;
  jmp : TSos;
begin
    result := false;
    if Svetofor < 1 then exit;
    i := 1000; //--------------------------------------- ���������� ���������� ����� �����
    MarhTrac.IzvStrNZ := false;//- ����� ������� ����������� ������� ����� ���������
    MarhTrac.IzvStrFUZ := false; // ����� �������� ��������� ������� ������ ��������
    MarhTrac.IzvStrUZ := false;//����� �������� ������� ������� ������ �� ���������.

    MarhTrac.ObjStart := Svetofor; //----- �������� �������� �� ������������ �������

    jmp := ObjZv[Svetofor].Sosed[1]; //------------------------- ����� ����� ��������

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlFindIzvStrel;//-- ����� "�������� ������. ��������. �������"
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    while i > 0 do //--------------------------------------------- ��������� ���� ��������
    begin
      //------------------------------------------------ ������������� �� ����������� ����
      case StepTrace(jmp, MarhTrac.Level, MarhTrac.Rod,0) of
        trStop, //----- ��������� ���� = ����� ����������� ��-�� ����������� �������������
        trEnd,  //-------------------------------------- ��� - ����� ����������� ���������
        trBreak : //-------------------------- ��� - ������������� ����������� �� ��������
        begin
          //------------ ��������� = ������� ����������� ������� �  ������� ������� ������
          result := MarhTrac.IzvStrNZ and MarhTrac.IzvStrUZ;
          if result then //----------------------------------------- ���� ���� �� � ������
          begin //-------------------------------------------------- ������ ��������������
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
//------------------------------------------ ��������� �������� ���������� ������ ��������
begin
    result := '';
    if Uslovie > 0 then
    begin //-------------------------------------- ��������� ���������� �� ������ ��������
      case ObjZv[Uslovie].TypeObj of //---------------------------- ���� ������� ���� ...
        30 :
        begin //------------------------------------------- ���� �������� ��������� ������
          if ObjZv[Uslovie].bP[2] then  //--- ���� "�"
          //------------------------------------- ������� ������� �� (��������� ������)...
          result := GetSmsg(1,254,ObjZv[ObjZv[Uslovie].BasOb].Liter,1);
        end;

      33 :
      begin //---------------------------------------------------------- ���������� ������
        if ObjZv[Uslovie].ObCB[1] then  //-------------------- ���� ������ ���������
        begin
          if ObjZv[Uslovie].bP[1] then   //------------------- ���� ������ ����������
          result := MsgList[ObjZv[Uslovie].ObCI[3]]; //------ �������� �� ����������
        end else
        begin
          if ObjZv[Uslovie].bP[1] then
          result := MsgList[ObjZv[Uslovie].ObCI[2]]; //-------- �������� � ���������
        end;
      end;

      38 :
      begin //------------------------------------------------------------ ������� �������
        if ObjZv[Uslovie].bP[1] then    //-------------------------------- ���� � ???
        //----------------------------------------------- ���������� ������� ������� � ...
        result := GetSmsg(1,346,ObjZv[ObjZv[Uslovie].BasOb].Liter,1);
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
//------------------------ �������� ��������� ����������� ��� ������ �������� (������ ���)
//-------------------------------------  Svetofor - ������ ���������t; Marh - ��� ��������

var
  i : integer;
  jmp : TSos;
begin
    result := 0;
    if Svetofor < 1 then exit; //------------------------------ �� ������ �������� - �����
    MarhTrac.Rod := Marh;
    case Marh of
      MarshP :  //------------------------------------------------------- �������� �������
      begin
        //------------------------------------------ ��������� ����� ��������� �����������
        if ObjZv[Svetofor].ObCI[27] > 0 then //------ ���� ���� �������� �����������
        begin
          if ObjZv[ObjZv[Svetofor].ObCI[27]].bP[1] then//���� ����������� �����
          begin result := 1; exit; end;//--------- ����� �� �������������� ������� - �����
        end;
        //---------------------------------------------- ������ �� ��������������� �������
        if ObjZv[Svetofor].ObCB[19] //---- ���� �������������� �������� ��� ��������
        then MarhTrac.IzvCount := 0   //----------------------- �� ����-�������� ���
        else MarhTrac.IzvCount := 1; //------ ���� �� ��������, �� ����-������� ����
      end;

      MarshM : //------------------------------------------------------ ���������� �������
      begin
        if ObjZv[Svetofor].ObCB[20]  //- ���� �������������� �������� ��� ����������
        then MarhTrac.IzvCount := 0 //------------------------- �� ����-�������� ���
        else MarhTrac.IzvCount := 1; //------ ���� �� ��������, �� ����-������� ����
      end;

      else MarhTrac.IzvCount := 1; //---- ��� ������ ��������� ����-������� ���� ???
    end;

    if not ObjZv[Svetofor].bP[2] and  //------------ ���� ��� ��2 � ��� �2 , �� �����
    not ObjZv[Svetofor].bP[4]
    then exit; //----------------------------------------------------------- ������ ������

    i := 1000;
    jmp := ObjZv[Svetofor].Sosed[1]; //--------------------- ��������� ����� ��������

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlFindIzvest;//- ����� ���� ����������� ����� ������� ��������
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


    while i > 0 do
    begin
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
      trStop, trEnd : break;

      trBreak :
      begin
        //------------------------------------- ��������� ��������������� �������� �������
        if MarhTrac.IzvCount < 2 then
        begin //--------------------------------------------------- �������������� �������
          if ObjZv[jmp.Obj].TypeObj = 26 then result := 3
          else

          if ObjZv[jmp.Obj].TypeObj = 15 then result := 3
          else result := 1;
        end
        else  result := 2; //------------------------------------------- ����� �� ��������
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
//----------------------------------- ������ ������� ������ �������� � ������ (������ ���)
function OtmenaMarshruta(Svetofor:SmallInt; Marh:Byte) : Boolean;
var
  index,i : integer;
  jmp : TSos;
begin
{$ifndef TABLO}
  result := false;
    //--------------------------- ������� ������� ��������������� ������������ ��� ��������}
    index := Svetofor;
    MarhTrac.TailMsg := '';
    MarhTrac.ObjStart := Svetofor;
    MarhTrac.Rod := Marh;
    MarhTrac.Finish := false;
    if ObjZv[ObjZv[MarhTrac.ObjStart].BasOb].bP[2] then
    begin
      //--------------------------------------------- ����� ���������� ��������� ���������
      ObjZv[MarhTrac.ObjStart].bP[14] := false;
      ObjZv[MarhTrac.ObjStart].bP[7] := false;
      ObjZv[MarhTrac.ObjStart].bP[9] := false;
    end;
    i := 1000;
    jmp := ObjZv[MarhTrac.ObjStart].Sosed[2]; // ��������� �����

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlOtmenaMarh;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    //------------------------------------------------ ����� ���������� ��������� ��������
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
        trStop, trEnd : break;
      end;
      dec(i);
    end;

    //----------------------------------------------------- ������ ������� ������ ��������
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
//--------------------------------------------------------------- �������� ������ ��������
function SetProgramZamykanie(Grp : Byte; Auto : Boolean) : Boolean;
var
  jmp : TSos;
  i,j,k,obj_tras,Sig_End : integer;
begin
    k := 0;
    //-------------------------------- ���������� ����������� ��������� ��������� ��������
    MarhTrac.SvetBrdr := MarhTrac.ObjStart;//��������� �������� ������
    MarhTrac.Finish := false;    //------------- ����� ������ ���� ������ ������
    MarhTrac.TailMsg := '';      //------ ��������� � "������" �������� ���� ���
    ObjZv[MarhTrac.ObjStart].bP[14] := true; //- ���������� �������� ������

    ObjZv[MarhTrac.ObjStart].iP[1] :=
    MarhTrac.ObjStart; //----------------------------- ��������� ������ ��������

    i := MarhTrac.Counter; //---------------- ��������� ����� ��������� ��������

    jmp := ObjZv[MarhTrac.ObjStart].Sosed[2]; //----------- ����� � ����� 2

    //############## � � � � � � � � � � � �  � � � � � � � � � ##########################
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    MarhTrac.Level := tlZamykTrace; // ���� ����������� = ������������ ���������
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    MarhTrac.FindTail := true; //--------------- ������� ������ ��� ����� ������
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
    

    MarhTrac.CIndex := 1; //----------------- ����������� ������ ������ � ������
    if j < 1 then j := MarhTrac.ObjTRS[MarhTrac.Counter];
    while i > 0 do
    begin
      if jmp.Obj = j then //-------------------------------- ��������� ������ ����� ������
      begin
        case ObjZv[jmp.Obj].TypeObj of
          //-------------------------- ������� � ����� ������ �������� ���������� ��������
          2 : StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);

          5 : //-------------------------------------------------- �������� � ����� ������
          begin
            //������ � ��� 2,������ ��������� � ����� ������ ��������, ���������� ��������
            if jmp.Pin = 2 then
            StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0)
            else //------------------------ ���� �� ����� 2, �� �������� �������� � ������
            if MarhTrac.FindTail //-------------- ���� ����� �������� ��� ������
            then MarhTrac.TailMsg:=' �� '+ObjZv[jmp.Obj].Liter;//����� ��������
          end;

          //------------------------------- �� � ����� ������ �������� ���������� ��������
          15 : StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);

          30 : //------------------------------------------ ������ ���� ��������� ��������
          begin
            if MarhTrac.FindTail// ���� ����� ������ �����, �� ��� ������ ������
            then MarhTrac.TailMsg:=' �� '+ObjZv[ObjZv[jmp.Obj].BasOb].Liter;
          end;

          //------------------------------------------------------- ������ ������ � ������
          32 : MarhTrac.TailMsg:=' �� '+ ObjZv[jmp.Obj].Liter;//������ �� �����
        end;
        break; //---------------------------- ����� �� ����� ��� ���������� ����� ��������
      end;
      //----- ���� ����� ������ ��� �� ��������� �� ������ ��������� ��� � ����������� ���
      case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
        trStop, trEnd : //���� ����� �� ������������ ��� ����� ���������, �� �������� ����
        begin i := -1; break; end;
      end;
      dec(i); //---------------------------- ��������� ����� ���������� ��������� ��������
      inc(MarhTrac.CIndex); //------------------- ��������� �� ��������� �������
    end;

    if (i < 1) and not Auto then
    begin // ����� �� ���������� ������
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
     //--------------------------------------------------- ������������ ���������� �������
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

     case MarhTrac.Rod of // ���������� ��������� ��������
      MarshM :
      begin
        if MarhTrac.Povtor then
        MarhTrac.MarhCmd[10] := _povtormarhmanevr
        else MarhTrac.MarhCmd[10] := _marshrutmanevr;
        tm := '�����������';
      end;

      MarshP :
      begin
        if MarhTrac.Povtor then
        MarhTrac.MarhCmd[10] := _povtormarhpoezd
        else MarhTrac.MarhCmd[10] := _marshrutpoezd;
        tm := '���������';
      end;

      MarshL :
      begin
        MarhTrac.MarhCmd[10] := _marshrutlogic;
        tm := '�����������';
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

    ShowSMsg(5, LastX, LastY, tm + ' �������� �� '+
    ObjZv[MarhTrac.ObjStart].Liter+ MarhTrac.TailMsg);

    LastMsgToDSP := ObjZv[MarhTrac.ObjStart].Liter+ MarhTrac.TailMsg;

    CmdBuff.LastObj := MarhTrac.ObjStart;

    //-------------------------------------------------------- ����� ��������� �����������

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
    WorkMode.CmdReady  := true; //-------- ������ ���������� ������ �� ��������� ���������
    result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function SendTraceCommand(Grp : Byte) : Boolean;
//--------------------------------------------- ������ ������� ��������� �������� � ������
var
  i,baza : integer;
  os,oe : SmallInt;
begin
    if (MarhTrac.GonkaList = 0) or //���� ��� ������� ������ ����������� ��� ...
    not MarhTrac.GonkaStrel then //------ ��� ������� ������� ������ �� ��������
    begin
      ResetTrace;
      result := false;
      exit;
    end;
    MarhTrac.Finish     := false;  //���������� ������ ������ ����� ������ �����
    MarhTrac.GonkaStrel := false;
    MarhTrac.GonkaList  := 0;

    //--------------------------------------------------------------- ������������ �������
    for i := 1 to 10 do MarhTrac.MarhCmd[i] := 0; //---- �������� ������ �������

    baza := ObjZv[MarhTrac.ObjStart].BasOb; //--- ����� ������� ��� ������

    if ObjZv[MarhTrac.ObjStart].TypeObj = 30 then //���� ������ "���� ��������"
    os := ObjZv[baza].ObCI[5] div 8 //----- ������ ������� �2 ��������� ������ � FR3
    else

    if ObjZv[MarhTrac.ObjStart].ObCI[3] > 0 then  //-------- ���� ���� ��2
    os := ObjZv[MarhTrac.ObjStart].ObCI[3] div 8 //------ ������ ��2 � FR3

    else
    os := ObjZv[MarhTrac.ObjStart].ObCI[5] div 8; //------ ������ �2 � FR3

    baza := ObjZv[MarhTrac.ObjEnd].BasOb;  //--------- ����� ������� �����

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 30 then // ���� ����� - "���� ��������"
    oe := ObjZv[baza].ObCI[5] div 8 //------- ������ ������� C2 ������� ������ � FR3
    else

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 24 then//���� ����� - ������ � ��������
    oe := ObjZv[MarhTrac.ObjEnd].ObCI[13] div 8//- �� ������� ����� ������
    else

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 26 then//---- ���� ����� - ������ � ���
    oe := ObjZv[baza].ObCI[4] div 8 //--- ������ ������� C1 �������� ��������� � FR3
    else

    if ObjZv[MarhTrac.ObjEnd].TypeObj = 32 then // ���� ����� - ������ � ������
    oe := ObjZv[baza].ObCI[2] div 8 // ������ ��� �C1 ������.��������� � ����� � FR3
    else

    if ObjZv[MarhTrac.ObjEnd].ObCI[3] > 0 then  //-- ���� � ����� ���� ��2
    oe := ObjZv[MarhTrac.ObjEnd].ObCI[3] div 8 //-------- ������ ��2 � FR3
    else

    if ObjZv[MarhTrac.ObjEnd].ObCI[5] > 0 then //---- ���� � ����� ���� �2
    oe := ObjZv[MarhTrac.ObjEnd].ObCI[5] div 8  //-------- ������ �2 � FR3
    else

    oe := ObjZv[MarhTrac.ObjEnd].ObCI[7] div 8; //--- ����� ��� ��� ??????

    MarhTrac.MarhCmd[1] := os;
    MarhTrac.MarhCmd[2] := os div 256;
    MarhTrac.MarhCmd[3] := oe;
    MarhTrac.MarhCmd[4] := oe div 256;
    MarhTrac.MarhCmd[5] := MarhTrac.StrCount;
    MarhTrac.MarhCmd[10] := _ustanovkastrelok;

    if MarhTrac.StrCount > 0 then //���� ���� �������, �� ��������� �� ���������
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
    tm := GetSmsg(1,5, ' ������� �� ������ �������� �� '+ //- ������ ������� ���������
    ObjZv[MarhTrac.ObjStart].Liter + MarhTrac.TailMsg,7);

    LastMsgToDSP := ObjZv[MarhTrac.ObjStart].Liter+ MarhTrac.TailMsg;

    CmdBuff.LastObj := MarhTrac.ObjStart;

    //-------------------------------------------------------- ����� ��������� �����������
    ResetTrace;
    PutSMsg(2,LastX,LastY,tm); //----------------------------------- ������ $ ��������
    WorkMode.CmdReady  := true; //-------- ������ ���������� ������ �� ��������� ���������
    result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
var
  cvet : integer;
//----------------------------------------------- ������������ ������ ����������� ��������
begin
    ResetTrace; //------------------------------------- ����� ����� ����� ��������� ������
    case command of
      M_BeginMarshManevr :  //---------------------------- ������ ���������� �������
      begin
        MarhTrac.Rod := MarshM;
        ObjZv[index].bP[7] := true; //------------------------- ���������� ������� ��
        cvet := 7;
      end;

      M_BeginMarshPoezd :  //------------------------------- ������ �������� �������
      begin
        MarhTrac.Rod := MarshP;
        ObjZv[index].bP[9] := true; //-------------------------- ���������� ������� �
        cvet := 2;
      end;

      else
        InsNewMsg(MarhTrac.ObjStart,32,1,''); //"��������� ����������� ��� ��������"
        result := false;
        ShowSMsg(32,LastX,LastY,ObjZv[MarhTrac.ObjStart].Liter);
        exit;
    end;
    WorkMode.GoTracert := true; //-------------------------- �������� ����������� ��������
    MarhTrac.AutoMarh := false; //---------------- �������� ����������� ������������
    MarhTrac.MsgN := 0; MarhTrac.WarN := 0;
    MarhTrac.ObjStart := index; //---------- �������� ����������� � ������� ��������
    MarhTrac.ObjLast := index; //--------------- �������, ��� ���� ������ � ��������
    MarhTrac.PinLast := 2; //--------------------------- ������ ������ �� ����������
    MarhTrac.ObjPrev := MarhTrac.ObjLast;
    MarhTrac.PinPrev := MarhTrac.PinLast;
    InsNewMsg(MarhTrac.ObjStart,78,cvet,''); //---------- ������� ������ �������� ��
    ShowSMsg(78,LastX,LastY,ObjZv[MarhTrac.ObjStart].Liter);
    result := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function RestorePrevTrace : Boolean;
//----------------------------- ������������ ������ �� ��������� ������������ ������������
var
  i : integer;
begin
    i := MarhTrac.Counter; //------------------------------- ����� �������� � ������

    while i > 0 do
    begin
      if MarhTrac.ObjTRS[i] = MarhTrac.ObjPrev then break //- ���� ���������
      else //------------------------------ ���� �� ������� ��������� ������� ����� ������
      begin
        if ObjZv[MarhTrac.ObjTRS[i]].TypeObj = 2 then //--- ���� ����� �� �������
        begin //----------------------------------- �������� ��������� ����������� �������
          ObjZv[MarhTrac.ObjTRS[i]].bP[10] := false;
          ObjZv[MarhTrac.ObjTRS[i]].bP[11] := false;
          ObjZv[MarhTrac.ObjTRS[i]].bP[12] := false;
          ObjZv[MarhTrac.ObjTRS[i]].bP[13] := false;
        end;
        MarhTrac.ObjTRS[i] := 0; //----------------------- ������ ������ �� ������
      end;
      dec(i);
    end;

    MarhTrac.Counter := i; //---------------- ������ � ������ ������� ����� ��������
    MarhTrac.ObjLast := MarhTrac.ObjPrev; //---- ����������� ������ ����������
    MarhTrac.PinLast := MarhTrac.PinPrev; //----- ����������� ����� ����������
    MarhTrac.MsgN := 0;
    RestorePrevTrace := true;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function EndTracertMarshrut : Boolean;
//------------------------------------------------------- ������� ���������� ������ ������
begin
    if MarhTrac.Counter < 1 then //------------------- ���� � �������� ��� ���������
    begin result := false; exit; end
    else
    if MarhTrac.ObjEnd < 1 then //------------------ ���� ��� ������� ����� ��������
    begin //-------------------- ������������� �� ���� ���������� �������� ������ ��������
      case ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].TypeObj of

        5,15,26,30 :// ���� ��� ������,��,��� ��� "��������", �� ��� � ���� ����� ��������
        MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];

        else  result := false; exit; //---------------------------- ����� ����� � ��������
      end;
    end;

    //-------------------------------------------------------- ���� ������ �������� � ....
    if (ObjZv[MarhTrac.ObjLast].TypeObj = 5) and (MarhTrac.PinLast = 2) and
    //--- �� ������� �� ���������� 1-�� ��� 2-�� ������� �� �������� 1-�� ��� 2-�� �������
    not (ObjZv[MarhTrac.ObjLast].bP[1] or ObjZv[MarhTrac.ObjLast].bP[2] or
    ObjZv[MarhTrac.ObjLast].bP[3] or ObjZv[MarhTrac.ObjLast].bP[4]) then
    begin
      if ObjZv[MarhTrac.ObjLast].bP[5] then //---------- ���� �� ����� ��������
      begin //----------------------------- ������� �� ������� ����������� ����� ���������
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        //---------------------------- "������� �� ��������.���������� ����������� �����."
        GetSmsg(1,115, ObjZv[MarhTrac.ObjLast].Liter,1);
        InsWar(MarhTrac.ObjLast,115);
      end;

      //----------- ��������� �������� ������� �������� ������� ���� �������� ����-�������
      case MarhTrac.Rod of
        MarshP :    //----------------------------------------------------- ������� ��������
        begin
          //-------------------------- ���� �������� �������������� ������� �������� � ...
          if ObjZv[MarhTrac.ObjLast].ObCB[19] and
          not ObjZv[MarhTrac.ObjLast].bP[4] then //--- ��� 2-�� ������� ���������
          begin
            InsNewMsg(MarhTrac.ObjLast,391,1,'');//----------------- "������ ������"
            ShowSMsg(391,LastX,LastY, ObjZv[MarhTrac.ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        MarshM :  //---------------------------------------------------- ������� ����������
        begin
          //------------------------ ���� �������� �������������� ������� ���������� � ...
          if ObjZv[MarhTrac.ObjLast].ObCB[20] and
          not ObjZv[MarhTrac.ObjLast].bP[2] then //- ��� 2-�� ������� �����������
          begin
            InsNewMsg(MarhTrac.ObjLast,391,1,'');//----------------- "������ ������"
            ShowSMsg(391,LastX,LastY, ObjZv[MarhTrac.ObjLast].Liter);
            result := false;
            exit;
          end;
        end;

        else  result := false; exit; //---------------------- ������ ��������� ���� �� �����
      end;
    end;

    //------ ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
    if FindIzvStrelki(MarhTrac.ObjStart, MarhTrac.Rod) then //-------- ���� ����
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      //- �������������� "�������� ���� ����������� ������� ��������������� ������� �������"
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
//--------------------------- ������� ����������� �� ��������� �����, ��������� ����������
var i,j,nextptr : integer;
begin
    if (index = MarhTrac.ObjStart) or (index = MarhTrac.ObjEnd)
    or (ObjZv[index].TypeObj = 3) then
    begin
      InsNewMsg(MarhTrac.ObjStart,1,7,''); //------- "����������� ����� �������� ��"
      ShowSMsg(1, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
      if (ObjZv[index].TypeObj = 3) then result := NextToTracertMarshrut(index)
      else result := false;
      exit;
    end;

    for i := 1 to MarhTrac.Counter do
    if MarhTrac.ObjTRS[i] = index then
    begin //------------------------- ���� ������ ��� � ������ - ��������� ��������� �����
      InsNewMsg(MarhTrac.ObjStart,1,7,'');
      ShowSMsg(1, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
      result := false;
      exit;
    end;

    //--------------------------------------------------------- ����� ������ � ������ ����
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
//----------------------------------------------------- �������� ������ �� ��������� �����
function NextToTracertMarshrut(index : SmallInt) : Boolean;
//------------------- index - ������ �������, ��������� �������� ���������� ������� ������
var
  i,j,c,k,wc,oe,strelka,signal,Put,Nomer  : Integer;
  jmp : TSos;
  TST_TRAS : TTrRes;
  b,res : boolean;
begin
    signal := 0;
    MarhTrac.FindNext := false;//----- �������-���������� �������� ����������� �����������
    MarhTrac.LvlFNext := false;//----- ������� �������� ������ ������ ��� ���������� ����.
    MarhTrac.Dobor    := false;//---------- ������� �������� ����������� "������" ��������
    MarhTrac.HTail    := index; //------------------- "�����" ������, ��������� ����������
    MarhTrac.FullTail := false; //----------------  ������� ������� ������ ������ ��������
    MarhTrac.VP := 0; //------------------------------- ������ �������� ��� ������� � ����
    MarhTrac.TailMsg  := ''; //--------- ��������� � ����� �������� ("��" ������ ��� "��")
    MarhTrac.FindTail := true; //----------------- ������� �������� �����������, ���� "��"
    LastJmp.TypeJmp := 0; LastJmp.Obj := 0; LastJmp.Pin := 0;

    if WorkMode.GoTracert and not WorkMode.MarhRdy then //���� �����������,�����. �� �����
    begin
      result := true;
      if (index = MarhTrac.ObjLast) then //----------- ���� ����� �� �������� ����� ������
      begin
        InsNewMsg(MarhTrac.ObjStart,1,7,'');//------------ "����������� ����� �������� ��"
        ShowSMsg(1, LastX, LastY, ObjZv[MarhTrac.ObjStart].Liter);
        result := true;
        exit;
      end;
      //------------------------------------------ ��������� ��������� ������� �����������
      MarhTrac.ObjPrev := MarhTrac.ObjLast; //-------------- ������ � ����� ������� ������
      MarhTrac.PinPrev := MarhTrac.PinLast; //------------ ����������� ����� ����� �������

      if MarhTrac.Counter < High(MarhTrac.ObjTRS) then //------------- ���� �������� �����
      begin //---------------- ����������� - ��������� ����, ����� ����� ��������� �������
        i := TryMarhLimit; //------------------------- ���������� ������������ �����������
        jmp :=ObjZv[MarhTrac.ObjLast].Sosed[MarhTrac.PinLast];//---------------- ���������

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTrac.Level := tlFindTrace; //------- ��������� ������� �������� ������� ������
        //-------------------------------------------- ����� ���������� ���� ������ ������
        while i > 0 do //-------- ���� �� ���������� ������, ���� ���������� ����� �������
        begin //------------------------------------------ ������������ �� ��������� �����

          if jmp.Obj = index then break; //-------- ��������� ������, ��������� ����������

          case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of //------------- ������� ���
            trRepeat : //---------- ����� �� ������, ���������� ����� �� ��������� �������
            begin
              if MarhTrac.Counter > 0 then
              begin //------------------------- ������� � ��������� �������������� �������
                j := MarhTrac.Counter; //------------- �������� �� �������� ������� ������
                while j > 0 do
                begin
                  case ObjZv[MarhTrac.ObjTRS[j]].TypeObj of //------------ ������� �� ����
                    2 :
                    begin //------------------------------------------------------ �������
                      strelka := MarhTrac.ObjTRS[j]; //---------- ������ ������� �� ������
                      if ObjZv[strelka].ObCB[3] then //------- �������� �������� �� ������
                      begin
                        if (ObjZv[strelka].bP[10] and //---------- ��� ������ ������ � ...
                        not ObjZv[strelka].bP[11]) or //-------- �� ���� ���� 2-�� ��� ...
                        ObjZv[strelka].bP[12] or  //----- ���������� ����� � ����� ��� ...
                        ObjZv[strelka].bP[13] then //----------- ���������� ����� � ������
                        begin
                          ObjZv[strelka].bP[10] := false; //-- ����� �������� 1-�� �������
                          ObjZv[strelka].bP[11] := false; //-- ����� �������� 2-�� �������
                          ObjZv[strelka].bP[12] := false; //------ ����� ����������� �����
                          ObjZv[strelka].bP[13] := false; //----- ����� ����������� ������
                          MarhTrac.ObjTRS[j] := 0; //------------ ������ �� ������ �������
                          dec(MarhTrac.Counter);  //------------ ��������� ����� ���������
                        end else
                        begin
                          ObjZv[strelka].bP[11] := false; //----- ����� �������� 2-�� ����
                          jmp := ObjZv[strelka].Sosed[2]; //-------- ������� �� ����-�����
                          break;
                        end;
                      end else //------------------------------ �������� �������� �� �����
                      begin
                        if ObjZv[strelka].bP[11] or //------ ������ ��� �� ������� ��� ...
                        ObjZv[strelka].bP[12] or //------------ ���������� � ����� ��� ...
                        ObjZv[strelka].bP[13] then //----------------- ���������� � ������
                        begin
                          ObjZv[strelka].bP[10] :=false;//---- ����� �������� 1-�� �������
                          ObjZv[strelka].bP[11] :=false;//---- ����� �������� 2-�� �������
                          ObjZv[strelka].bP[12] :=false; //------- ����� ����������� �����
                          ObjZv[strelka].bP[13] :=false; //------ ����� ����������� ������
                          MarhTrac.ObjTRS[j] := 0;
                          dec(MarhTrac.Counter);
                        end else
                        begin
                          ObjZv[strelka].bP[11] := true;
                          jmp := ObjZv[strelka].Sosed[3]; //------- ������� �� �����-�����
                          break;
                        end;
                      end;
                    end;

                    else //------------------------------ ����� ������ �������� �� �������
                      if MarhTrac.ObjTRS[j] = MarhTrac.ObjLast then
                      begin j := 0; break; end //------ ��������� � ����� ������, ��������
                      else
                      begin //--------------------------- �������� �� ���� ������ � ������
                        MarhTrac.ObjTRS[j] := 0;
                        dec(MarhTrac.Counter);
                      end;
                  end; //------------------------------------------------------ ����� case
                  dec(j);
                end; //------------------------------------------ ������� while ��� ������

                if j < 1 then //----------------------- ��������� �����, ������ �� �������
                begin //------------------------ ����� ����������� - ����� ������� �������
                  InsNewMsg(MarhTrac.ObjStart,86,1,'');
                  RestorePrevTrace;
                  result := false;
                  ShowSMsg(86, LastX, LastY, '');
//                  SBeep[1] := true;
                  exit;
                end;
              end else //-------------------------- � ������ ��� ��������� (������ ������)
              begin //-------------------------- ����� ����������� - ����� ������� �������
                InsNewMsg(MarhTrac.ObjStart,86,1,'');
                RestorePrevTrace; //------- ������������ ������ �� ��������� ������� �����
                result := false;
                ShowSMsg(86, LastX, LastY, ''); //--- "����� ������ $ ������� �������"
                exit;
              end;
            end;

            trStop : //------------ ��� ������� ������ ����� ������ - ��������� �� �������
            begin
              InsNewMsg(MarhTrac.ObjStart,77,1,'');
              RestorePrevTrace; //-------------- �������������� �� ��������� ������� �����
              result := false;
              ShowSMsg(77, LastX, LastY, '');  //--------------- ������� �� ����������
              exit;
            end;

            trEnd :
            begin //---------------------------- ����� ����������� - ������� �� ����������
              InsNewMsg(MarhTrac.ObjStart,77,1,'');
              RestorePrevTrace;
              result := false;
              ShowSMsg(77, LastX, LastY, ''); exit;
            end;
          end; //------------------------------------------------- ����� ���� ����� ������
          dec(i); //------ ������� � ���������� ����, �������� ����� ���������� ����������
        end; //------------------------------ ����� ����� ������� ������� �� �������� ����

        if i < 1 then //--------------------------- ����� �� ������� �������������� ������
        begin //------------------------------------------------- �������� ������� �������
          InsNewMsg(MarhTrac.ObjStart,231,1,'');// �������� ���� ������� �����������
          RestorePrevTrace;
          result := false;
          ShowSMsg(231, LastX, LastY, '');
          exit;
        end;

        MarhTrac.ObjLast := index; //------------------------ ��������� ����� ������

        if ObjZv[index].TypeObj = 5 then MarhTrac.ObjEnd := index;

        case jmp.Pin of
          1 : MarhTrac.PinLast := 2; // ���������� ����� ������ �� ��������� �������
          else MarhTrac.PinLast := 1;
        end;

        //------------------- ��������� ������������� ������ �������������� �������� �����
        b := true;
        MarhTrac.PutPO := false; //--------------- ����� �������� ����������� � ����

        if ObjZv[MarhTrac.ObjLast].TypeObj = 5 then
        begin //------------------ ��� ��������� ��������� ������� ����������� �����������
          signal := MarhTrac.ObjLast;
          if ObjZv[signal].ObCB[1] then  //-- ���� ����� ����������� � ����� �������
          begin//����� ������� ��������� �/� (����� ����������� �������� �� �������, �����)
            b := false;
            MarhTrac.ObjEnd := signal;
          end
          else
          case MarhTrac.PinLast of
            1 :  //----------------------- ����� �� ������� � ����� 1 (����� �� ���������)
            begin
              case MarhTrac.Rod of
                MarshP :
                begin
                  if ObjZv[signal].ObCB[6] then //---- ���� ����� �������� � ����� 2
                  begin //------------------ ��������� ����������� ���� �������� �� ������
                    b := false; MarhTrac.ObjEnd := signal;
                  end else //-------------- ��� ����� � � ����� 2 ( �� ��������� ��������)
                  if ((ObjZv[signal].Sosed[1].TypeJmp = 0) or
                  (ObjZv[signal].Sosed[1].TypeJmp = LnkNecentr))
                  then begin b := false; i := 0; end; //����� ���� ��� ��������� �� ������
                end;

                MarshM :
                begin
                  if ObjZv[signal].ObCB[7] and //���� ����� ���������� � ����� 1 �..
                  ObjZv[signal].ObCB[23] //------------- �������� ����� �� ���������
                  then
                  begin //----- ��������� ����������� �� ���������, �� ��������� ���� ����
                    b := true;  MarhTrac.ObjEnd := signal;
                  end else
                  begin
                    InsNewMsg(index,86,1,'');   //---------- ����� ������ $ ������� �������
                    RestorePrevTrace; result := false;
                    ShowSMsg(86, LastX, LastY, ObjZv[index].Liter);
                    exit;
                  end;
                end;

                else b := true; //---------------------------- �������������� ��� ��������
              end;
            end;

            else //--- ����� �� ������� ����� � ����� 2 (�� ��������, ������ ������� "��")

            //-------------- ���� ���������� � ���� ����� ���������� � ����� 1 ("��")  ���
            if(((MarhTrac.Rod=MarshM) and ObjZv[signal].ObCB[7]) or
            //--------------------------- ���� �������� � ���� ����� �������� � ����� 1 �
            ((MarhTrac.Rod = MarshP) and ObjZv[signal].ObCB[5])) and
            //---------------- ���� ���������� FR4 ��� ���������� � �� ��� ��� ��/�� ���
            (ObjZv[signal].bP[12] or
            ObjZv[signal].bP[13] or
            ObjZv[jmp.Obj].bP[18] or
            //-----------------------------------------------���� ������ �������� � �1 ���
            (ObjZv[signal].ObCB[2] and
            (ObjZv[signal].bP[3] or
            //----------------------------------------------- �2 ��� ������ �� ������� ���
            ObjZv[signal].bP[4] or
            ObjZv[signal].bP[8] or
            //--------------------------------- ��� ����������� ��� ���� ������ ����������
            ObjZv[signal].bP[9])) or
            (ObjZv[signal].ObCB[3]
            //-------------------------------------------------------------- � ��1 ��� ��2
            and (ObjZv[signal].bP[1]
            or ObjZv[signal].bP[2]
            //--------------------------------- ��� ���� �� �� ������� ��� ��� �����������
            or ObjZv[signal].bP[6]
            or ObjZv[signal].bP[7]
            //��� ���
            or ObjZv[signal].bP[21]))) then
            begin //--------------- ��������� ����������� ���� �������� ������� ��� ������
              b := false;
              MarhTrac.ObjEnd := signal;
            end else //----------------------------------------------------- ������ ������
            begin
              case MarhTrac.Rod of
                MarshP :      //-------------------------------------------- ���� ��������
                begin //------------------------------- ���� ���� ����� �������� � ����� 1
                  if ObjZv[signal].ObCB[5] then
                  begin //---------------------- ���� ����� ��������� �������� � ���������
                    MarhTrac.FullTail := true;
                    MarhTrac.FindNext := true;
                  end;
                  //------------------- ���� ��� ��������� �������� � ���� ������ ��������
                  if ObjZv[signal].ObCB[16] and
                  ObjZv[signal].ObCB[2] then //-------------- ��� ��������� ��������
                  begin //-------------- ��������� ����������� ���� ��� ��������� ��������
                    b := false;
                    MarhTrac.ObjEnd := signal;
                    MarhTrac.FullTail := true //------------- ��������� ����� ������
                  end else
                  begin
                    if ObjZv[signal].ObCB[5] then b := false // ���� ����� "�" � �.1
                    else b := true;

                    if ObjZv[signal].ObCB[5] and //------ ���� ����� "�" � �.1 � ...
                    not ObjZv[signal].ObCB[2] then //---------- ��� ��������� ������
                    begin
                      MarhTrac.ObjEnd := signal; //-- �����, ��� �������� �� �������
                    end;
                  end;
                end;

                MarshM :
                begin
                  if ObjZv[signal].ObCB[7] then //-- ���� ����� ���������� � ����� 1
                  begin
                    MarhTrac.FullTail := true;
                    MarhTrac.FindNext := true;
                  end;

                  if ObjZv[signal].ObCB[7]
                  then b := false
                  else b := true;

                  if ObjZv[signal].ObCB[7] and //------ ���� ����� � � ����� 1 � ...
                  not ObjZv[signal].ObCB[3] then //- � ������� ��� ������ ����������
                  begin
                    MarhTrac.ObjEnd := signal;//- ���������, ��� �������� �� �������
                  end;
                end;

                else  b := true; //--------------- �������������� ������� ������� ��������
              end;
            end;
          end;
        end else //--------------------------------- ������� ���� "����" ��� "�� � ������"
        if ((ObjZv[MarhTrac.ObjLast].TypeObj = 4) or //---------- ���� ���� ��� ...

        ((ObjZv[MarhTrac.ObjLast].TypeObj = 3) and //--------------------- �� � ...
        (MarhTrac.Rod = MarshP) and //----------------------- �������� ������� � ...
        (MarhTrac.PinLast = 1) and  //-------------- ����� �� �� ����� ����� 1 � ...
        (ObjZv[MarhTrac.ObjLast].ObCB[10] = true)) or //���� ����� � ��� 1 ���

        ((ObjZv[MarhTrac.ObjLast].TypeObj = 3) and //--------------------- �� � ...
        (MarhTrac.Rod = MarshP) and //----------------------- �������� ������� � ...
        (MarhTrac.PinLast = 2) and  //-------------- ����� �� �� ����� ����� 2 � ...
        (ObjZv[MarhTrac.ObjLast].ObCB[11] = true)))  //---- ���� ����� � ��� 2
        then  MarhTrac.PutPO := true
        //---------------- ��� ���� ��� �� � ������ ���������� ������� ����� ������ ������
        else
        if ObjZv[MarhTrac.ObjLast].TypeObj = 24 then
        begin //-------------------------- ��� ����������� ������ ��������� ����� ��������
          b := false;
          MarhTrac.ObjEnd := MarhTrac.ObjLast;
        end else
        if ObjZv[MarhTrac.ObjLast].TypeObj = 32 then
        begin //------------------------------------- ��� ������� ��������� ����� ��������
          b := false;
          MarhTrac.ObjEnd := MarhTrac.ObjLast;
        end;

        //++++++++++++++++++++++++++++++++++++++++++++ ��������� ������ �������� �� ������
        if b then  //-------------------------------- ��� ���������� ��������, ����� �����
        begin //--- ������ �� �������� ����� ��� ����������� �������, ����������� ��������
          MarhTrac.FullTail := false;

          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          MarhTrac.Level := tlContTrace; //------------------ ����� ��������� ������
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          //---------------------- � � � � �   � � � � � �  ------------------------------
          i := 1000;

          while i > 0 do
          begin
            TST_TRAS := StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0);//�������
            case TST_TRAS of
              trStop :
              begin //-------------------------- ����� ����������� - ������� �� ����������
                InsNewMsg(MarhTrac.ObjStart,77,1,'');
                RestorePrevTrace;
                result := false;
                ShowSMsg(77, LastX, LastY, '');
                exit;
              end;

              trBreak :
              begin //------------------------- ������� ����� �� ���������� ����� ��������
                b := false;
                break;
              end;

              trEnd :
                      break; //------------------------- ���������� ������� ����� ��������

              trKonec :
              begin  //-------------------------------- ���������� �������� ����� ��������
                MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];
                MarhTrac.ObjLast := ObjZv[signal].Sosed[1].Obj;//������ �� ���.
                break;
              end;
            end;
            dec(i);
          end;

          if i < 1 then
          begin //----------------------------------------------- �������� ������� �������
            InsNewMsg(MarhTrac.ObjStart,231,1,'');
            RestorePrevTrace;
            result := false;
            ShowSMsg(231, LastX, LastY, ''); exit;
          end;

          if ObjZv[MarhTrac.ObjLast].TypeObj = 3 then b := true;

          if b then
          begin //------------------------------------------------------------- ��� ������
            jmp.Obj := MarhTrac.ObjLast;
            case jmp.Pin of
              1 : MarhTrac.PinLast := 2;
              else  MarhTrac.PinLast := 1;
            end;
          end else
          begin //-------------------------------------------------- ��� ����� �� ���� ���
            //------------------------------------------------------ ���������� �� �������

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTrac.Level := tlStepBack; //----- ����� ��� ����� �� ������ ��������
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
        begin //------------------------------------------ ���� ��� ������ ������ ��������
          if MarhTrac.Counter < High(MarhTrac.ObjTRS) then
          begin //---------------------------------------- ��������� ����� � ������ ������
            inc(MarhTrac.Counter);
            MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
          end;
        end;

        LastJmp := jmp; //-------------------- ��������� ��������� ������� ����� ���������

        if i < 1 then
        begin //----------------------------------- ����� �� �������������� �������� �����
          InsNewMsg(index,86,1,'');   //------------------- ����� ������ $ ������� �������
          RestorePrevTrace;
          result := false;
          ShowSMsg(86, LastX, LastY, ObjZv[index].Liter);
          exit;
        end;

        //-------------------------------------------- ��������� ���������� �� ���� ������
        i := 1000;
        MarhTrac.VP := 0;
        jmp := ObjZv[MarhTrac.ObjStart].Sosed[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTrac.Level := tlVZavTrace; //----- ����� �������� ������������ �� ������
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        j := MarhTrac.ObjEnd; //------------------ ��������� ����� ���������� ������

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
          if jmp.Obj = j then res := true; //--------------- ��������� ������ ����� ������
          inc(MarhTrac.CIndex);
        end;

        if MarhTrac.MsgN > 0 then //-- ���� ����������� ��������� (������������)
        begin
          InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],1,'');
          RestorePrevTrace;
          result := false;
          PutSMsg(1, LastX, LastY, MarhTrac.Msg[1]);
          exit;
        end;

        if i < 0 then //--------------------- ����� �� ����������� - ������� �� ����������
        begin
          InsNewMsg(MarhTrac.ObjStart,77,1,'');
          RestorePrevTrace;
          result := false;
          ShowSMsg(77, LastX, LastY, '');
          exit;
        end;

        //------------------------------ ��������� �������� ����������� �� �������� ������
        for i := 1 to MarhTrac.Counter do
        begin
          case ObjZv[MarhTrac.ObjTRS[i]].TypeObj of
            3 :   //--------------------------------------------------------------- ������
            begin
              if  not ObjZv[MarhTrac.ObjTRS[i]].bP[14] then
              ObjZv[MarhTrac.ObjTRS[i]].bP[8] := false;
            end;

            4 :  //------------------------------------------------------------------ ����
            begin
              Put := MarhTrac.ObjTRS[i];
              if (not ObjZv[Put].ObCB[10]) and (not ObjZv[Put].ObCB[11]) and
              (not ObjZv[Put].bP[14]) then ObjZv[Put].bP[8] := false;
            end;
          end;
        end;

        //------------------------------------------ ��������� ������������ �� ���� ������
        i := 1000;
        MarhTrac.MsgN := 0;
        MarhTrac.WarN := 0;
        MarhTrac.GonkaStrel := false; //----- ������ ������� ����� ������� �� ������
        MarhTrac.GonkaList  := 0;    // �������� ������� �������, ��������� ��������
        jmp := ObjZv[MarhTrac.ObjStart].Sosed[2];

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MarhTrac.Level := tlCheckTrace;//---- ����� �������� ������������� �� ������
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        MarhTrac.VP := 0;
        j := MarhTrac.ObjEnd;
        if j < 1 then j := MarhTrac.ObjTRS[MarhTrac.Counter];
        MarhTrac.CIndex := 1;

        while i > 0 do
        begin
          if jmp.Obj = j then
          begin //------------------------------------------ ��������� ������ ����� ������
            //----------------------------------------------- ����� ������������� � ������
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
        begin //--------------------------------------------- ����� �� ���������� ��������
          InsNewMsg(MarhTrac.ObjStart,231,1,'');
          RestorePrevTrace;
          result := false;
          ShowSMsg(231, LastX, LastY, '');
          exit;
        end;
        tm := MarhTrac.TailMsg; //------------ ��������� ��������� � ������ ��������

        if MarhTrac.MsgN > 0 then
        begin  //--------------------------------------------------- ����� �� ������������
          MarhTrac.MsgN := 1; //------------------------ �������� ���� ���������
          //--------------- ��������� ����������� � �������� ������ ���� ���� ������������
          NewMenu_(Key_ReadyResetTrace,LastX,LastY);
          result := false;
          exit;
        end else
        begin
          if MarhTrac.PutPO then //---------------- ��������� ����� ���� ������ ����
           MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];

          if (MarhTrac.WarN > 0) and
          MarhTrac.FullTail then //--------  ��� ������� ��������� � ������ ��������
          MarhTrac.ObjEnd := MarhTrac.ObjTRS[MarhTrac.Counter];

          //------------------------------ �������� ����������� ������ ���������� ��������
          c := MarhTrac.Counter; //-------- ��������� ������� ����� ��������� ������
          wc := MarhTrac.WarN;  //--------------- ��������� ����� ��������������
          oe := MarhTrac.ObjEnd; //--------------------------------- �������� ������

          MarhTrac.VP := 0;
          MarhTrac.LvlFNext := true;

          if (MarhTrac.ObjEnd = 0) and (MarhTrac.FindNext) then
          begin //------------------------ �������� ����������� ������ ���������� ��������
            i := TryMarhLimit * 2;
            jmp := ObjZv[MarhTrac.ObjLast].Sosed[MarhTrac.PinLast];

            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            MarhTrac.Level := tlFindTrace;
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            while i > 0 do
            begin //------------------------------------------------ ������������ �� �����

              case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of

                trRepeat :  //--------------------- ���� ����� ������� � ��������� �������
                begin

                  if MarhTrac.Counter > c then //-- ���� ��� ���� �� ���� ��� ������
                  begin   //------------------- ������� � ��������� �������������� �������
                    j := MarhTrac.Counter; // �������� � ����� (������� ����� j > c)
                    while j > 0 do
                    begin

                      case ObjZv[MarhTrac.ObjTRS[j]].TypeObj of

                        2 :
                        begin //-------------------------------------------------- �������
                          strelka := MarhTrac.ObjTRS[j];

                          if ObjZv[strelka].ObCB[3] then//������� �������� �� ������
                          begin
                            if (ObjZv[strelka].bP[10] and  //-- ��� 1-�� ������ � ...
                            not ObjZv[strelka].bP[11]) or //- ��� 2-�� ������ ��� ...
                            ObjZv[strelka].bP[12] or //  ���������� ����� � ����� ���
                            ObjZv[strelka].bP[13] then //-- ���������� ����� � ������
                            begin
                              ObjZv[strelka].bP[10] := false;//---- �������� ������ ������
                              ObjZv[strelka].bP[11] := false;//---- �������� ������ ������
                              ObjZv[strelka].bP[12] := false;//����� ������ ���������� � +
                              ObjZv[strelka].bP[13] := false;//����� ������ ���������� � -
                              MarhTrac.ObjTRS[j] := 0; //-------- ������ ������� �� ������
                              dec(MarhTrac.Counter); //------------ ��������� ������
                            end else
                            begin
                              ObjZv[strelka].bP[11] := false;//���������� 2-�� ������
                              jmp := ObjZv[strelka].Sosed[2]; //������� �� ����-�����
                              break;
                            end;
                          end else
                          begin //----------------------------- �������� �������� �� �����
                            if ObjZv[strelka].bP[11] or//���� ��� 2-�� ������ ��� ...
                            ObjZv[strelka].bP[12] or//������ ��� ���������� � ����� ���...
                            ObjZv[strelka].bP[13] then //-- ������ ��� ���������� � ������
                            begin
                              ObjZv[strelka].bP[10] := false;
                              ObjZv[strelka].bP[11] := false;
                              ObjZv[strelka].bP[12] := false;
                              ObjZv[strelka].bP[13] := false;
                              MarhTrac.ObjTRS[j] := 0;
                              dec(MarhTrac.Counter);
                            end else
                            begin
                              ObjZv[MarhTrac.ObjTRS[j]].bP[11] := true;//2-��
                              jmp:= ObjZv[MarhTrac.ObjTRS[j]].Sosed[3];//�� -
                              break;
                            end;
                          end;
                        end;

                        else //---------------- ����� ������ ������ (�� �������� ��������)
                          if MarhTrac.ObjTRS[j] = MarhTrac.ObjLast then
                          begin  //- �����, �������� ����������� �� ������ ��� �����������
                            j := 0; break;
                          end else
                          begin //---------------- �������� �� ���� ������ � ������ ������
                            MarhTrac.ObjTRS[j] := 0;
                            dec(MarhTrac.Counter);
                          end;

                      end; //-------------------------------- ����� case �� ����� ��������
                      dec(j);
                    end; //--------- ����� while j > 0 �� ����� �������� �������� � ������

                    if j <= c then //------------------------- ���� �������� ������� �����
                    begin //-------------------------------------------- ����� �����������
                      oe := MarhTrac.ObjLast;
                      break;
                    end;
                  end else //------------ ���� �� ��������� ������� ��� ����������� ������
                  begin //---------------------------------------------- ����� �����������
                    MarhTrac.ObjEnd := MarhTrac.ObjLast;
                    break;
                  end;
                end; //-------------------------- ����� case �� ���������� ���� = trRepeat

                trStop, trEnd : break; //------------------------------- ����� �����������
              end; //------------------------------------------------------ case steptrace

              //-------------------------------------- ��������� ���������� �������� �����
              b := false;

              if ObjZv[jmp.Obj].TypeObj = 5 then //-------------------------- ���� ������
              begin //------------ ��� ��������� ��������� ������� ����������� �����������
                if ObjZv[jmp.Obj].ObCB[1] then b := true //- ����� ������� ���������
                else
                case jmp.Pin of
                  2 :
                  begin //--------------------------- ������� � ����� 2 (������ ���������)
                    case MarhTrac.Rod of
                      MarshP : if ObjZv[jmp.Obj].ObCB[6] then b := true;//� ����� �2

                      MarshM : if ObjZv[jmp.Obj].ObCB[8] then b := true;//� ����� �2

                      else  b := false;
                    end;
                  end;
                  else //---------------------------- ������� � ����� 1, (������ ��������)
                    if ObjZv[jmp.Obj].bP[1] or ObjZv[jmp.Obj].bP[2]//��1 ��� ��2
                    or //------------------------------------------------------------- ���
                    ObjZv[jmp.Obj].bP[3] or ObjZv[jmp.Obj].bP[4] //--- �1 ��� �2
                    or //------------------------------------------------------------- ���
                    ObjZv[jmp.Obj].bP[6] or ObjZv[jmp.Obj].bP[7]//��_FR3 ��� ���
                    or //------------------------------------------------------------- ���
                    ObjZv[jmp.Obj].bP[8] or ObjZv[jmp.Obj].bP[9] //�_FR3 ��� ���
                    or //------------------------------------------------------------- ���
                    ObjZv[jmp.Obj].bP[12] or ObjZv[jmp.Obj].bP[13]//����STAN_DSP
                    or //------------------------------------------------------------- ���
                    ObjZv[jmp.Obj].bP[18] or ObjZv[jmp.Obj].bP[21] //- ��_��_���
                    then b := true //�������� ��� ������, �� ��������, � ������,����������
                    else
                    begin
                      case MarhTrac.Rod of
                        MarshP :
                        begin
                          if ObjZv[jmp.Obj].ObCB[16] and // ��� ��������� �������� �
                          ObjZv[jmp.Obj].ObCB[2] then b := true // ���� ������ ��� �
                          else
                          begin
                            b := ObjZv[jmp.Obj].ObCB[5]; //������� � ����� � ����� 1
                          end;
                        end;

                        MarshM : b := ObjZv[jmp.Obj].ObCB[7];   // � ����� � ����� 1

                        else  b := true;  //------------------- ������� ������� ����������
                      end;
                    end;
                end;
              end else
              if ObjZv[jmp.Obj].TypeObj = 15 then
              begin //-------------------- ��� ������ � ��������� ��������� ����� ��������
                inc(MarhTrac.Counter);
                MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZv[jmp.Obj].TypeObj = 24 then
              begin //-------------------- ��� ����������� ������ ��������� ����� ��������
                b := true;
              end else
              if ObjZv[jmp.Obj].TypeObj = 26 then
              begin //-------------------------- ��� ������ � ��� ��������� ����� ��������
                inc(MarhTrac.Counter);
                MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
                b := true;
              end else
              if ObjZv[jmp.Obj].TypeObj = 32 then
              begin //------------------------------- ��� ������� ��������� ����� ��������
                b := true;
              end;

              if b then //- ������� �������� �� ����� �����������, �� ��������� ����������
              begin
                k := 15000;
                jmp.Obj := MarhTrac.ObjLast;
                if MarhTrac.PinLast = 1 then jmp.Pin := 2 else
                jmp.Pin := 1;

                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                MarhTrac.Level := tlVZavTrace;//����� �������� ������������ � ������
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                j := MarhTrac.ObjTRS[MarhTrac.Counter];
                MarhTrac.CIndex := c;
                b := true;

                while k > 0 do
                begin
                  if jmp.Obj = j then break; //------------- ��������� ������ ����� ������
                  case StepTrace(jmp,MarhTrac.Level,MarhTrac.Rod,0) of
                    trStop :         begin  b := false; break; end;
                    trBreak, trEnd : begin   break;            end;
                  end;
                  dec(k);
                  inc(MarhTrac.CIndex);
                end;

                if (k > 1000) and b then
                begin
                  //----------------------------------------------- ��������� ������������
                  jmp.Obj := MarhTrac.ObjLast;
                  if MarhTrac.PinLast = 1 then jmp.Pin := 2
                  else jmp.Pin := 1;

                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  MarhTrac.Level := tlCheckTrace;//- ����� �������� �����. �� ������
                  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                  MarhTrac.Dobor := true;
                  MarhTrac.MsgN := 0;
                  j := MarhTrac.ObjTRS[MarhTrac.Counter];
                  MarhTrac.CIndex := c;
                  while k > 0 do
                  begin
                    if jmp.Obj = j then
                    begin //-------------------------------- ��������� ������ ����� ������
                      // ������������ � ������
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
                begin //--------------------------- ����� �� ����������� ��� �������������
                  if MarhTrac.Counter > c then
                  begin
                    //------------------------- ������� � ��������� �������������� �������
                    j := MarhTrac.Counter;
                    while j > 0 do
                    begin
                      case ObjZv[MarhTrac.ObjTRS[j]].TypeObj of
                        2 :
                        begin //-------------------------------------------------- �������
                          strelka := MarhTrac.ObjTRS[j];
                          if ObjZv[strelka].ObCB[3] then
                          begin //---------------------------- �������� �������� �� ������
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
                              jmp := ObjZv[strelka].Sosed[2]; //������� �� ����-�����
                              break;
                            end;
                          end else
                          begin //----------------------------- �������� �������� �� �����
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
                              jmp := ObjZv[strelka].Sosed[3];//������� �� �����-�����
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
                          begin //----------------------- �������� �� ���� ������ � ������
                            MarhTrac.ObjTRS[j] := 0;
                            dec(MarhTrac.Counter);
                          end;
                      end;
                      dec(j);
                    end;
                    if j <= c then
                    begin //-------------------------------------------- ����� �����������
                      oe := MarhTrac.ObjLast;
                      break;
                    end;
                  end else
                  begin //---------------------------------------------- ����� �����������
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

            if i < 1 then oe := MarhTrac.ObjLast; //------- �������� ������� �������
          end;

          while MarhTrac.Counter > c do
          begin //------------------ ������ �������� ����������� ����� ������������ ������
            if ObjZv[MarhTrac.ObjTRS[MarhTrac.Counter]].TypeObj = 2 then //------- �������
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
          begin //-------------------------- ��������� ����� ���� ������ ���������� ������
            if (ObjZv[MarhTrac.ObjLast].TypeObj = 5) and  //- ���� ��� ������ � ...
            (MarhTrac.PinLast = 2) and  //------------ ������������ �� ����� 2 � ...
            not (ObjZv[MarhTrac.ObjLast].bP[1] or // ��� �� ����������� ��, ...
            ObjZv[MarhTrac.ObjLast].bP[2] or //�� ��������� ����������� �������
            ObjZv[MarhTrac.ObjLast].bP[3] or //------------ �� ��������� �� ...
            ObjZv[MarhTrac.ObjLast].bP[4]) then  //---- ��� ��������� ���������
            begin
              if ObjZv[MarhTrac.ObjLast].bP[5] then //----------------------- �
              begin //--------------------- ������� �� ������� ����������� ����� ���������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,115, ObjZv[MarhTrac.ObjLast].Liter,1);
                InsWar(MarhTrac.ObjLast,115);
              end;

              case MarhTrac.Rod of // �������� �������� ������� �������� ������� ���� �������� ����-�������
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

            // ��������� �������������� ������� �� ���������� ������ �� ����������� ��������
            if FindIzvStrelki(MarhTrac.ObjStart, MarhTrac.Rod) then
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,333, ObjZv[MarhTrac.ObjStart].Liter,7);
              InsWar(MarhTrac.ObjStart,333);
            end;

            MarhTrac.TailMsg := tm; //----- ������������ ��������� � ������ ��������

            if MarhTrac.WarN > 0 then
            begin //------------------------------------------------- ����� ��������������
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
            MarhTrac.TailMsg := tm; // ������������ ��������� � ������ ��������
            InsNewMsg(MarhTrac.ObjStart,1,7,''); //- "����������� ����� �������� ��"
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
//-------------------------------------- ��������� ���� �� ����, ���������� ��������� ����
function StepTrace(var From:TSos; const Lvl:TTrLev; Rod:Byte; Grp:Byte) : TTrRes;
//------------------------------- Con ---- ����� � �������, �� �������� ������ -----------
//------------------------------- Lvl ---- ���� ����������� �������� ---------------------
//------------------------------- Rod ---- ��� �������� ----------------------------------
//------------------------------- Grp -- ����� �������� � ������ ���������� ------------
var
  jmp1,jmp : TSos;
  tras,tras_end : integer;
begin
    if Grp <> 0 then MarhTrac := MarhTrac1[Grp];
    
    result := trStop;//- ����� ����������� ��-�� �������������� ����������� ����� ��������

    case Lvl of
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      tlVZavTrace, //---------------------------------------------- �������� ������������,
      tlCheckTrace,//--------------------------- �������� ������������� �� ������ ��������
      tlZamykTrace ://��������� ������ ��������, ���� ��������� ����������� ������� ������
      begin //------------------------------------------------ �������� ����������� ������
        if MarhTrac.CIndex <= MarhTrac.Counter then  //--------------------- ���� �� �����
        begin
          //----------------------------------- ������ �� � ������, ���������� �����������
          if From.Obj <> MarhTrac.ObjTRS[MarhTrac.CIndex] then exit;
        end else
        if MarhTrac.CIndex = MarhTrac.Counter+1 then //--------------- ���� ����� �� �����
        if From.Obj <> MarhTrac.ObjEnd  then exit;//------ ������ �� ����������� - �������
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      tlStepBack : //----------------------------------------------- ����� ����� �� ������
      begin
        jmp := From; //--------------------------------- ��� ������ ����������� ������� ��
        case ObjZv[jmp.Obj].TypeObj of
          27,29 :
          begin
            if jmp.Pin = 1 then
            begin
              From := ObjZv[jmp.Obj].Sosed[2];
              case From.TypeJmp of
                LnkRgn : result := trStop; //-------------------------------- ����� ������
                LnkEnd : result := trStop; //-------------------------------- ����� ������
                else  result := trNext;  //----------------------- ����� ������ ������
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
          else result := trStop; exit; //-------- ��� ������ �������� ������������ � �����
        end;

        if MarhTrac.Counter > 0 then
        begin
          MarhTrac.ObjTRS[MarhTrac.Counter]:=0;// ����� �����-������
          dec(MarhTrac.Counter); //------------ ��������� ����� ��������� ������
        end
        else result := trStop;
        exit;
      end;
    end;
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    jmp := From; //---------------------- � ����������� ������� ���������� ��������� �����

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
    // ���������� ������� ������ ��� ������ ������, � ���������, ������,������� ��������,
    //------------------------------------------ ���������� ��������,  ������� �����������
    if MarhTrac.Counter < High(MarhTrac.ObjTRS) then
    begin
      inc(MarhTrac.Counter);
      MarhTrac.ObjTRS[MarhTrac.Counter] := jmp.Obj;
    end
   else result := trStop;
end;
//========================================================================================
function SoglasieOG(Index : SmallInt) : Boolean;
//------------------------------- ��������� ����������� ������ �������� �� ���������� ����
var
  i,o,p,j : integer;
begin
  j := ObjZv[Index].UpdOb; // ������ ������� ���������� ����
  if j > 0 then
  begin
    result := ObjZv[j].bP[1]; // ���� ������ �� ����������
    // ��������� ���������� �� 1-�� �����
    o := ObjZv[Index].Sosed[1].Obj; p := ObjZv[Index].Sosed[1].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZv[o].TypeObj of
        2 : begin // �������
          case p of
            2 : begin // ���� �� �����
              if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then break; // ������� � ������ �� ������
            end;
            3 : begin // ���� �� ������
              if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then break; // ������� � ������ �� �����
            end;
          else
            result := false; break; // ������ � �������� ������������ - ����������� �� � ����� �����
          end;
          p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
        end;

        3 : begin // �������
          result := ObjZv[o].bP[2]; // ��������� �������
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
    // ��������� ���������� �� 2-�� �����
    o := ObjZv[Index].Sosed[2].Obj; p := ObjZv[Index].Sosed[2].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZv[o].TypeObj of
        2 : begin // �������
          case p of
            2 : begin // ���� �� �����
              if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then break; // ������� � ������ �� ������
            end;
            3 : begin // ���� �� ������
              if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then break; // ������� � ������ �� �����
            end;
          else
            result := false; break; // ������ � �������� ������������ - ����������� �� � ����� �����
          end;
          p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
        end;

        3 : begin // �������
          result := ObjZv[o].bP[2]; // ��������� �������
          break;
        end;
      else
        if p = 1 then begin p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj; end
        else begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;

    // ��������� ������ ���������� ��� ������� ����������
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
//------ ��������� ���������� ���� ����� �� ������� ��� �������� ������������� �����������
var
  i,o,p : integer;
begin
  result := true;
  for i := 1 to 10 do
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      case ObjZv[ObjZv[Ptr].ObCI[i]].TypeObj of
        6 : //------------------------------------------------------------ ���������� ����
        begin
          for p := 14 to 17 do
          begin
            if ObjZv[ObjZv[Ptr].ObCI[i]].ObCI[p] = Ptr then
            begin
              o := ObjZv[Ptr].ObCI[i];
              if ObjZv[o].bP[2] then
              begin //---------------------------------------- ����������� ���������� ����
                if (not MarhTrac.Povtor and (ObjZv[Ptr].bP[10] and not ObjZv[Ptr].bP[11])
                or ObjZv[Ptr].bP[12]) or
                (MarhTrac.Povtor and (ObjZv[Ptr].bP[6] and not ObjZv[Ptr].bP[7])) then
                begin //-------------------------------------------- ������� ����� � �����
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
                begin // ������� ����� � ������
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
//----------------- ��������� ��������� �������� ����������� � ���� � ����������� ��������
//-------------------- ����� ����� ������� ��� �������� ������������� ����������� ��������
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
        begin //--------------------------- �������� ��������� �������� ����������� � ����
          if ObjZv[p].bP[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZv[p].ObCI[j];
              if o = ptr then
              begin //---------- ��������� ��������� ��������� ������� ��� ����� ���������
                if (not MarhTrac.Povtor and
                (ObjZv[Ptr].bP[10] and not ObjZv[Ptr].bP[11])
                or ObjZv[Ptr].bP[12]) or
                (MarhTrac.Povtor and (ObjZv[Ptr].bP[6]
                and not ObjZv[Ptr].bP[7])) then
                begin //-------------------------------------------- ������� ����� � �����
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
                begin //------------------------------------------- ������� ����� � ������
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
// ��������� ���������� ���� ����� �� ������� ��� �������� ������������� ���������� ������
function SignCircOgrad(ptr : SmallInt) : Boolean;
var
  i,o,p : integer;
begin
  result := true;
  for i := 1 to 10 do
    if ObjZv[Ptr].ObCI[i] > 0 then
    begin
      case ObjZv[ObjZv[Ptr].ObCI[i]].TypeObj of
        6 : begin //------------------------------------------------------ ���������� ����
          for p := 14 to 17 do
          begin
            if ObjZv[ObjZv[Ptr].ObCI[i]].ObCI[p] = Ptr then
            begin
              o := ObjZv[Ptr].ObCI[i];
              if ObjZv[o].bP[2] then
              begin //---------------------------------------- ����������� ���������� ����
                if ObjZv[ObjZv[Ptr].BasOb].bP[1] then
                begin //-------------------------------------------- ������� ����� � �����
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
                begin // ������� ����� � ������
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
//----------------- ��������� ��������� �������� ����������� � ���� � ����������� ��������
//----------------------- ����� ����� ������� ��� �������� ������������� ���������� ������
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
        begin //--------------------------- �������� ��������� �������� ����������� � ����
          if ObjZv[p].bP[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZv[p].ObCI[j];
              if o = ptr then
              begin //---------- ��������� ��������� ��������� ������� ��� ����� ���������
                if ObjZv[ObjZv[Ptr].BasOb].bP[1] then
                begin //-------------------------------------------- ������� ����� � �����
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
                begin //------------------------------------------- ������� ����� � ������
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
//---------------------------------------------------------------- �������� ��������������
//-------------------------------------------------------------------------  ptr - �������
//------------------------------------------------------- pk - �������� ������� �� �������
var
  i,o,p : integer;
begin
    result := true;
    //-------------------- ������ �������������� ����� ���� � ���������� ��������� �������
    if pk then
    begin //-------------------------------------------------------------- ������� � �����
      if (ObjZv[Ptr].Sosed[3].TypeJmp = LnkNeg) or //-------------- ������������ ����
      (ObjZv[Ptr].ObCB[8]) then //-------- ��� �������� ���������� ��������� �������
      begin //--------------------------------------------------- �� ���������� ����������
        o := ObjZv[Ptr].Sosed[3].Obj; //----------------------- ������ �� �����������
        p := ObjZv[Ptr].Sosed[3].Pin; //--------------------------- ����� �����������
        i := 100;
        while i > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :   //-------------------------------------------------------------- �������
            begin
              case p of
                2 :   //--------------------------------------------------- ���� �� ������
                if ObjZv[o].bP[2] then break; //---------- ������� � ������ �� ������

                3 : //------------------------------------------------  ���� �� ����������
                if ObjZv[o].bP[1] then break; //----------- ������� � ������ �� �����

                else  ObjZv[Ptr].bP[3] := false; break; //------ ������ � ���� ������
              end;
              p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
            end;

            3,4 :  //-------------------------------------------------------- �������,����
            begin
              if not ObjZv[o].bP[1] then //--------------- ��������� �������� �������
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
  begin  //-------------------------------------------------------------- ������� � ������
    if (ObjZv[Ptr].Sosed[2].TypeJmp = LnkNeg) or //---------------- ������������ ����
    (ObjZv[Ptr].ObCB[7]) then    //------- ��� �������� ���������� ��������� �������
    begin //------------------------------------------------------ �� ��������� ����������
      o := ObjZv[Ptr].Sosed[2].Obj;
      p := ObjZv[Ptr].Sosed[2].Pin;
      i := 100;
      while i > 0 do
      begin
        case ObjZv[o].TypeObj of
          2 :
          begin //---------------------------------------------------------------- �������
            case p of
              2 :
              begin //------------------------------------------------------ ���� �� �����
                if ObjZv[o].bP[2] then break; //---------- ������� � ������ �� ������
              end;
              3 :
              begin //----------------------------------------------------- ���� �� ������
                if ObjZv[o].bP[1] then break; //----------- ������� � ������ �� �����
              end;
              else ObjZv[Ptr].bP[3] := false; break; //--------- ������ � ���� ������
            end;
            p := ObjZv[o].Sosed[1].Pin;
            o := ObjZv[o].Sosed[1].Obj;
          end;

          3,4 :
          begin //----------------------------------------------------------- �������,����
            if not ObjZv[o].bP[1] then //----------------- ��������� �������� �������
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
//------------------------------------------ �������� �������������� ��� ���������� ������
var
  i,o,p : integer;
begin
    result := true;
    //-------------------- ������ �������������� ����� ���� � ���������� ��������� �������
    if pk then
    begin //---------------------------------------------------------------- ������� � �����
      if (ObjZv[Ptr].Sosed[3].TypeJmp = LnkNeg) or //---------------- ������������ ����
      (ObjZv[Ptr].ObCB[8]) then //---------- ��� �������� ���������� ��������� �������
      begin //�� ���������� ����������
        o := ObjZv[Ptr].Sosed[3].Obj;
        p := ObjZv[Ptr].Sosed[3].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin // �������
              case p of
                2 :
                begin // ���� �� �����
                  if ObjZv[o].bP[2] then break; // ������� � ������ �� ������
                end;

                3 :
                begin // ���� �� ������
                  if ObjZv[o].bP[1] then break; // ������� � ������ �� �����
                end;

                else  ObjZv[Ptr].bP[3] := false; break; // ������ � ���� ������
              end;
              p := ObjZv[o].Sosed[1].Pin;
              o := ObjZv[o].Sosed[1].Obj;
            end;

            3,4 :
            begin // �������,����
              if not ObjZv[o].bP[1] then // ��������� �������� �������
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
    begin // ������� � ������
      if (ObjZv[Ptr].Sosed[2].TypeJmp = LnkNeg) or // ������������ ����
      (ObjZv[Ptr].ObCB[7]) then         // ��� �������� ���������� ��������� �������
      begin //�� ��������� ����������
        o := ObjZv[Ptr].Sosed[2].Obj;
        p := ObjZv[Ptr].Sosed[2].Pin;
        i := 100;
        while i > 0 do
        begin
          case ObjZv[o].TypeObj of
            2 :
            begin // �������
              case p of
                2 :
                begin // ���� �� �����
                  if ObjZv[o].bP[2] then break; // ������� � ������ �� ������
                end;
                3 :
                begin // ���� �� ������
                  if ObjZv[o].bP[1] then break; // ������� � ������ �� �����
                end;
                else ObjZv[Ptr].bP[3] := false; break; // ������ � ���� ������
              end;
              p := ObjZv[o].Sosed[1].Pin;
              o := ObjZv[o].Sosed[1].Obj;
            end;

            3,4 :
            begin // �������,����
              if not ObjZv[o].bP[1] then // ��������� �������� �������
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
//------------------------------------------ �������� ������� �������� �� ���������� �����
var
  i,j,g,o,p,q : Integer;
  b,opi : boolean;
begin
  result := false;
  MarhTrac.MsgN := 0; MarhTrac.WarN := 0;
  if ptr < 1 then exit;

  // ���������� ����
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
          43 : begin // ������ ���
            if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
            begin // ���� �������� ��� ��������
              ObjZv[ObjZv[o].UpdOb].bP[8] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // ���������� ������
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
          44 : begin // ������ ���
            if ObjZv[o].bP[1] or ObjZv[o].bP[2] then ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[8] := false;
          end;
        end;
      end;
    end;
  end;
  // ���������� ������� ������� � ������
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
          44 : begin // ���
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
  // ���������� ������� ������� � �����
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
          44 : begin // ���
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
  // ���������� ������� ������� �� ����������
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

  //--------------------------------------------- ��������� ������� ��� ��� ������ �������
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

  // ��������� ������� �� �������
  if ObjZv[ptr].bP[6] then
  begin // ���
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,105,ObjZv[ptr].Liter,1);
    InsMsg(ptr,105);
    exit;
  end;
  if ObjZv[ptr].bP[1] then
  begin // ��
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258,ObjZv[ptr].Liter,1);
    InsMsg(ptr,258);
    exit;
  end;
  if ObjZv[Ptr].bP[4] then
  begin // ���� ��������� �������� �� ������� - ���������:
  // ��������� ���������� �������� �� �������
    if not ObjZv[Ptr].bP[5] then
    begin
      if ObjZv[ptr].bP[3] then
      begin // ������� ��� �� ��������
        inc(MarhTrac.WarN); MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,445,ObjZv[Ptr].Liter,1); InsWar(ptr,445);
      end;
    end;
  // ���������� ����� �� �������� (���������� ������ ��� ����������)
    b := false; opi := false;
    for i := 1 to WorkMode.LimitObjZav do
    begin
      if (ObjZv[i].TypeObj = 48) and (ObjZv[i].BasOb = ptr) then
      begin
        if not ObjZv[i].ObCB[3] then
        begin // �������������� ����������� ������ �� ���� ������ �� ����������� ������
          opi := true;
          if ObjZv[i].bP[1] then b := true;
        end;
      end;
    end;
    if opi and not b then
    begin // ��� ���� ��������� �� ����������� ������
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,427,ObjZv[Ptr].Liter,1);
      InsMsg(ptr,427);
      exit;
    end;
  end;

  // ��������� �������������� ������� �������� �� �������
  g := ObjZv[ptr].ObCI[17];
  if g > 0 then
  begin
    for i := 1 to 5 do
    begin // �������� �������������� ������� �� ������
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          4 : begin // ����
            if not ObjZv[o].bP[2] or not ObjZv[o].bP[3] then
            begin // ���������� ������� �� ���� (����������� ����� �������� �� ����)
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,341,ObjZv[o].Liter,1);
              InsMsg(o,341);
              exit;
            end;
          end;

          6 : begin // ���������� ����
            if ObjZv[o].bP[2] then
            begin // ���������� �����������
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,145,ObjZv[ObjZv[o].BasOb].Liter,1);
              InsMsg(ObjZv[o].BasOb,145);
              exit;
            end;
          end;

          23 : begin // ������ � ���������� �������
            if ObjZv[o].bP[1] then
            begin // ���� ���
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,256,ObjZv[o].Liter,1);
              InsMsg(o,256);
              exit;
            end else
            if ObjZv[o].bP[2] then
            begin // ���� ���
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,257,ObjZv[o].Liter,1);
              InsMsg(o,257);
              exit;
            end;
          end;

          25 : begin // ���������� �������
            if not ObjZv[o].bP[1] then
            begin // ��� ���������� �������� �� ����������� �������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,426,ObjZv[o].Liter,1); InsMsg(o,426); exit;
            end;
          end;

          33 : begin // ���������� ������
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
          begin //-------------------------------------------------------- ���� ����������
            if ObjZv[o].bP[1] then
            begin //----------------------- �������� ���������� � ���� �������� ����������
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

  // ��������� ������ �������
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
            begin // ������� �������
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82,ObjZv[o].Liter,1);
              InsMsg(o,82);
              exit;
            end;
            if not ObjZv[o].bP[5] then
            begin // ������� �� ��������
              for p := 20 to 24 do // ����� ������� � ���������� ���������
                if (ObjZv[o].ObCI[p] > 0) and (ObjZv[o].ObCI[p] <> ptr) then
                begin
                  if not ObjZv[ObjZv[o].ObCI[p]].bP[3] then
                  begin
                    inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258,ObjZv[ObjZv[o].ObCI[p]].Liter,1); InsMsg(ObjZv[o].ObCI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZv[o].bP[7] then
            begin // ������� ������� �� �������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,110,ObjZv[o].Liter,1); InsMsg(o,110); exit;
            end;
          end;
          44 : begin // ���
            if not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[2] then
            begin // ������� �������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,82,ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].UpdOb,82); exit;
            end;
            if not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[5] then
            begin // ������� �� ��������
              for p := 20 to 24 do // ����� ������� � ���������� ���������
                if (ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p] > 0) and (ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p] <> ptr) then
                begin
                  if not ObjZv[ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p]].bP[3] then
                  begin
                    inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258,ObjZv[ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p]].Liter,1); InsMsg(ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].ObCI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].bP[7] then
            begin // ������� ������� �� �������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,110,ObjZv[ObjZv[ObjZv[o].UpdOb].UpdOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].UpdOb,110); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  // ��������� ��������� �������
  g := ObjZv[ptr].ObCI[20];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        if ObjZv[o].bP[1] or ObjZv[o].bP[2] or ObjZv[o].bP[3] or ObjZv[o].bP[4] then
        begin // ������ ������
          inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,114,ObjZv[o].Liter,1); InsMsg(o,114); exit;
        end;
      end;
    end;
  end;

  // ��������� ������� �������� �������� ������� � ������
  g := ObjZv[ptr].ObCI[21];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
        begin // ������� �� ����� ��������
          inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� �������� ������� � �����
  g := ObjZv[ptr].ObCI[22];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
        begin // ������� �� ����� ��������
          inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� ������� ������� � ������
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
            begin // ������� �� ����� ��������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
            end;
          end;
          44 : begin
            if not ObjZv[ObjZv[o].UpdOb].bP[1] and not ObjZv[ObjZv[o].UpdOb].bP[2] then
            begin // ������� �� ����� ��������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� ������� ������� � �����
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
            begin // ������� �� ����� ��������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
            end;
          end;
          44 : begin
            if not ObjZv[ObjZv[o].UpdOb].bP[1] and not ObjZv[ObjZv[o].UpdOb].bP[2] then
            begin // ������� �� ����� ��������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // ��������� ������� �������� ������� �� ����������
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
            begin // ������� �� ����� ��������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,81); exit;
            end;
          end;
          44 : begin
            if not (ObjZv[ObjZv[o].UpdOb].bP[1] xor ObjZv[ObjZv[o].UpdOb].bP[2]) then
            begin // ������� �� ����� ��������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,81,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // ��������� ���� ������
  g := ObjZv[ptr].ObCI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZv[g].ObCI[i];
      if o > 0 then
      begin
        case ObjZv[o].TypeObj of
          4 : begin // ����
            if not ObjZv[o].bP[4] and (not ObjZv[o].bP[2] or not ObjZv[o].bP[3]) then
            begin // ���������� �������� ������� �� ����
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,341,ObjZv[o].Liter,1); InsMsg(o,341); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  if WorkMode.RazdUpr then
  begin // � ������ ����������� ���������� ��������� ��������� ������� � �������� ������� �������

  // ��������� ������� ���
    g := ObjZv[ptr].ObCI[15];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        q := ObjZv[g].ObCI[i];
        if q > 0 then
        begin
          case ObjZv[q].TypeObj of
            43 : begin // ������ ���
              if ObjZv[q].bP[1] then
              begin // ��������� ��������� ��������� �������
              // ��������������� ����� �� ���� �� ����������� ������
                opi := false;
                if ObjZv[q].ObCB[1] then p := 2 else p := 1;
                o := ObjZv[q].Sosed[p].Obj; p := ObjZv[q].Sosed[p].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZv[o].TypeObj of
                    2 : begin // �������
                      case p of
                        2 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[11] then
                          begin // ���� ����������� ������ �������
                            if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then break;
                            opi := true; break;
                          end;
                        end;
                        3 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[10] then
                          begin // ���� ����������� ������ �������
                            if ObjZv[o].bP[1] and not ObjZv[o].bP[2] then break;
                            opi := true; break;
                          end;
                        end;
                      end;
                      p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
                    end;
                    48 : begin // ���
                      opi := true; break;
                    end;
                  else
                    if p = 1 then begin p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj; end
                    else begin p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj; end;
                  end;
                  if (o = 0) or (p < 1) then break;
                  dec(j);
                end;

              // ������� �� ����������� � ����� ��� ����, ������������ �� ��������
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
  // ��������� ������� ������� � ������
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
              begin // ������� �� ����� �������� � -
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,267,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,267); exit;
              end;
              if not SigCircNegStrelki(o,false) then exit;
              if ObjZv[o].bP[16] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[16]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[17]) then
              begin //--------------------------------------- ������� ������� ��� ��������
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,119,ObjZv[o].Liter,1);
                InsMsg(o,119);
                exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1); InsMsg(o,453); exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZv[o].UpdOb,false) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin //-------------------------------------------------- ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // ��������� ������� ������� � �����
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
              begin // ������� �� ����� �������� � +
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,268,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,268); exit;
              end;
              if not SigCircNegStrelki(o,true) then exit;
              if ObjZv[o].bP[16] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[16]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[o].Liter,1); InsMsg(o,119); exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1); InsMsg(o,453); exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZv[o].UpdOb,true) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin // ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // ��������� �������� ������� � ������
    g := ObjZv[ptr].ObCI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[2] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // ������� �� ����� �������� � -
            inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,267,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,267); exit;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // ������� �� ������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
            InsWar(ObjZv[o].BasOb,120+$5000);
          end;
        end;
      end;
    end;
  // ��������� �������� ������� � �����
    g := ObjZv[ptr].ObCI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[1] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // ������� �� ����� �������� � +
            inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,268,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,268); exit;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // ������� �� ������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
            InsWar(ObjZv[o].BasOb,120+$5000);
          end;
        end;
      end;
    end;

  end else
  if WorkMode.MarhUpr then
  begin // � ������ ����������� ���������� ��������� ����������� ����������� � ��������� ���������� �������������

    // ��������� ������� ������� � ������
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
              begin // ������� �� ����� �������� ���������� ���������
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
                begin // ��������� �� ����������
                  inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,159,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,159); exit;
                end;
              end;
              if not NegStrelki(o,false) then exit;
              if ObjZv[o].bP[16] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[16]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[o].Liter,1); InsMsg(o,119); exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1); InsMsg(o,453); exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 :
            begin
              if not ObjZv[ObjZv[o].UpdOb].bP[2] and
                 not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[12] and
                 ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[13] then
              begin // ������� �� ����� �������� ���������� ���������
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
              begin // ��������� �� ����������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,151,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,151); exit;
              end;
              if not NegStrelki(ObjZv[o].UpdOb,false) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin // ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // ��������� ������� ������� � �����
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
              begin // ���� ���� �� + � - ������� ��� ����� ������� 202
                if ObjZv[o].bP[18] or ObjZv[ObjZv[o].BasOb].bP[18] then
                begin //------------------------------------------ ��������� �� ����������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,151,ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,151);
                  exit;
                end;
              end else
              if not ObjZv[o].bP[1] and ObjZv[o].bP[12] and not ObjZv[o].bP[13] then
              begin // ������� �� ����� �������� � �����
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
                begin // ��������� �� ����������
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
              begin // ������� ������� ��� ��������
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[o].Liter,1);
                InsMsg(o,119);
                exit;
              end;
              if ObjZv[o].bP[17] or
                 (ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[33]) or
                 (not ObjZv[o].ObCB[6] and ObjZv[ObjZv[o].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[o].Liter,1);
                InsMsg(o,453);
                exit;
              end;
              if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
              begin // ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[o].BasOb,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZv[ObjZv[o].UpdOb].bP[1] and
                 ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[12] and
                 not ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[13] then
              begin // ������� �� ����� �������� � �����
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
              begin // ��������� �� ����������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,151,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1); InsMsg(ObjZv[ObjZv[o].UpdOb].BasOb,151); exit;
              end;
              if not NegStrelki(ObjZv[o].UpdOb,true) then exit;
              if ObjZv[ObjZv[o].UpdOb].bP[16] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[16]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[17]) then
              begin // ������� ������� ��� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,119); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[17] or
                 (ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[33]) or
                 (not ObjZv[ObjZv[o].UpdOb].ObCB[6] and ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[34]) then
              begin // ������� ������� ��� ���������������� ��������
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453,ObjZv[ObjZv[o].UpdOb].Liter,1); InsMsg(ObjZv[o].UpdOb,453); exit;
              end;
              if ObjZv[ObjZv[o].UpdOb].bP[15] or ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].bP[15] then
              begin // ������� �� ������
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120,ObjZv[ObjZv[ObjZv[o].UpdOb].BasOb].Liter,1)+ '. ����������?';
                InsWar(ObjZv[ObjZv[o].UpdOb].BasOb,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // ��������� �������� ������� � ������
    g := ObjZv[ptr].ObCI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[2] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // ������� �� ����� �������� � -
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
            begin // ��������� �� ����������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,235,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,235); exit;
            end;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // ������� �� ������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
            InsWar(ObjZv[o].BasOb,120+$5000);
          end;
        end;
      end;
    end;

    // ��������� �������� ������� � �����
    g := ObjZv[ptr].ObCI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZv[g].ObCI[i];
        if o > 0 then
        begin
          if not ObjZv[o].bP[1] or (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
          begin // ������� �� ����� �������� � +
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
            begin // ��������� �� ����������
              inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,236,ObjZv[ObjZv[o].BasOb].Liter,1); InsMsg(ObjZv[o].BasOb,236); exit;
            end;
          end;
          if ObjZv[o].bP[15] or ObjZv[ObjZv[o].BasOb].bP[15] then
          begin // ������� �� ������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,120,ObjZv[ObjZv[o].BasOb].Liter,1)+ '. ����������?';
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

  ObjZv[ptr].bP[8] := true; // ������� ������ ������� ��
  result := true;
end;
//========================================================================================
function VytajkaZM(ptr : SmallInt) : Boolean;
//----------------------------------------------- ����������� ��������� ����������� ������
var
  i,g,o : Integer;
begin
  result := false;
  if ptr < 1 then exit;

  // �������� �������
  ObjZv[ptr].bP[14] := true;

  // ��������� ������ �������
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

  // �������� ����
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

  //--------------------------------------------------- ��������� ������� ������� � ������
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

  // ��������� ������� ������� � �����
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

  // ��������� ������� ������� �� ����������
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
//---------------------------------------------- ����������� ���������� ����������� ������
var
  i,g,o : Integer;
begin
  result := false;
  if ptr < 1 then exit;

  // ���������� �������
  ObjZv[ptr].bP[14] := false;
  ObjZv[ptr].bP[8]  := false; // �������� ������� ������ ������� ��

  // ���������� ������ �������
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

  // ���������� ������� ������� � ������
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

  // ���������� ������� ������� � �����
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

  //--------------------------------------------- ���������� ������� ������� �� ����������
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
//------------------------------------------------------- �������� ������� ������ ��������
var
  i,g,o : Integer;
begin
  result := '';
  MarhTrac.MsgN := 0; MarhTrac.WarN := 0;
  if ptr < 1 then exit;
  // ��������� ������� �� �������
  if ObjZv[ptr].bP[2] then
  begin // ��
    result := GetSmsg(1,259,ObjZv[ptr].Liter,1); exit;
  end;

  // ��������� ������ �������
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
//--------------------------------- �������� ������ ��, �������� ������������ ��� ��������
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
var
  sp1,sp2 : integer;
begin
  sp1 := ObjZv[ObjZv[ObjZv[Obj].BasOb].ObCI[8]].UpdOb;
  sp2 := ObjZv[ObjZv[ObjZv[Obj].BasOb].ObCI[9]].UpdOb;
  case mode of
    1 : begin // ��������� ��
      if (sp1 > 0) and not ObjZv[sp1].bP[2] then result := sp1 else
      if (sp2 > 0) and not ObjZv[sp2].bP[2] then result := sp2 else
      result := ObjZv[Obj].UpdOb;
    end;
    2 : begin // ��������� ��
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
//------------------------------------ ���������� ������� �� �� ��������� �������� �������
var
  max,o,p,nadv : integer;
begin
  //------------------------------------- ����� ������ �������� ������� � ���������� �����
  max := 1000; nadv := 0;
  o := ObjZv[Ptr].Sosed[2].Obj; p := ObjZv[Ptr].Sosed[2].Pin;
  while max > 0 do
  begin
    case ObjZv[o].TypeObj of
      2 : begin // �������
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
      32 : begin // ������
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
  begin // ��������� ������� �� �� ���������� ��������
    ObjZv[Ptr].iP[2] := nadv;
    max := 1000;
    o := ObjZv[Ptr].Sosed[2].Obj; p := ObjZv[Ptr].Sosed[2].Pin;
    while max > 0 do
    begin
      case ObjZv[o].TypeObj of
        2 : begin // �������
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
        32 : begin // ������
          break;
        end;

        3 : begin // ��,��
          ObjZv[o].iP[3] := nadv; // �������� ��������� ��
          if p = 1 then
          begin
            p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
          end else
          begin
            p := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
          end;
        end;
        5 : begin // ��������
          if p = 1 then
          begin // �������� �������� �������� ��������� ��
            ObjZv[o].iP[2] := nadv;
            p := ObjZv[o].Sosed[2].Pin; o := ObjZv[o].Sosed[2].Obj;
          end else
          begin // ��������� �������� �������� ��������� ��
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
//------------------------- ���������� / ����� ������������ �������� �� ������� AvtoM (47)
function AutoMarsh(AvtoM : SmallInt; mode : Boolean) : Boolean;
var
  i,j,AvtoS,Str,g,signal,hvost : integer;
  vkl : boolean;
  jmp : TSos;
begin
  vkl := true;
  if mode then //----------------------------- ������� ���������/���������� ������������
  begin //-------------------------------------------------------- �������� ������������
    for i := 10 to 12 do //--- ������ �� ������� �������� ������������ �������� ��������
    begin           //--------- ���������� ���������� ������������ ���� �������� �������
      AvtoS :=ObjZv[AvtoM].ObCI[i]; //------------------------------ ��������� ��������
      if AvtoS > 0 then
      with ObjZv[AvtoS] do
      begin
        signal := BasOb;
        if not ObjZv[signal].bP[4] and WorkMode.Upravlenie then //------ �������� ������
        begin //----------------------------------------------------- �� ������ ��������
          result := false;
          ShowSMsg(429,LastX,LastY,ObjZv[signal].Liter);
          InsNewMsg(signal,429+$4000,1,''); //----------------------- �� ������ ������ $
          exit;
        end;

        for j := 1 to 10 do //--------- ������ �� �������� �������� ������������ �������
        begin //-------------------------------------------- ��������� ��������� �������
          Str := ObCI[j];
          if Str > 0 then
          begin
            if not ObjZv[Str].bP[1] and WorkMode.Upravlenie then
            begin //----------------------------------- ��� �������� ��������� ���������
              result := false;
              ShowSMsg(268,LastX,LastY,ObjZv[ObjZv[Str].BasOb].Liter);
              InsNewMsg(ObjZv[Str].BasOb,268+$4000,1,''); //������� ��� �������� ��
              exit;
            end;
            hvost:= ObjZv[Str].BasOb;
            if (ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19])and //------- �������� ������
            WorkMode.Upravlenie then
            begin //-------------------------------------------------- ������� �� ������
              result := false;
              ShowSMsg(120,LastX,LastY,ObjZv[hvost].Liter);
              InsNewMsg(hvost,120+$4000,1,'');
              exit;
            end;
          end;
        end;
      end;
    end;

    //-------------------------------------------- ��������� ������������ ��� ������������
    for i := 10 to 12 do
    begin
      AvtoS := ObjZv[AvtoM].ObCI[i];
      if AvtoS > 0 then
      begin
        g := ObjZv[AvtoS].ObCI[25]; //----------------------------------- ����� ���
        MarhTrac1[g].Rod := MarshP;
        MarhTrac1[g].Finish := false;
        MarhTrac1[g].WarN := 0;
        MarhTrac1[g].MsgN := 0;
        MarhTrac1[g].ObjStart := ObjZv[AvtoS].BasOb;
        MarhTrac1[g].Counter := 0;
        j := 1000;

        jmp := ObjZv[ObjZv[AvtoS].BasOb].Sosed[2];
        MarhTrac1[g].Level := tlSetAuto; //-------------- ����� ��������� ������������
        MarhTrac1[g].FindTail := true;

        while j > 0 do
        begin
          case StepTrace(jmp,MarhTrac1[g].Level,MarhTrac1[g].Rod,g) of
            trStop, trEnd, trKonec : break;
          end;
            dec(j);
        end;
        if j < 1 then vkl := false; //------------------------ ������ �������� ���������
        if MarhTrac1[g].MsgN > 0 then vkl := false;
      end;
    end;

    if not vkl and WorkMode.Upravlenie then
    begin //--------------------------------------- �������� � ��������� �� ������������
      InsNewMsg(AvtoM,476+$4000,1,'');
      ShowSMsg(476,LastX,LastY,ObjZv[AvtoM].Liter); //������������ �� ����� ���� ���.
      SBeep[4] := true;
      result := false;
      exit;
    end;

    //------------------------------------------------- ���������� �������� ������������
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
  begin //------------------------------------------------------- ��������� ������������
    for i := 10 to 12 do
    if ObjZv[AvtoM].ObCI[i] > 0 then
    begin //--------------------------------- �������� ������������ ���� �������� ������
      AvtoS := ObjZv[AvtoM].ObCI[i];
      ObjZv[AvtoS].bP[1] := false;
      AutoMarshOFF(AvtoS,ObjZv[AvtoM].ObCB[1]);
    end;
    ObjZv[AvtoM].bP[1] := false;
    result := true;
  end;
end;

//========================================================================================
//---------------- �������� �������� ������������ �� �������� ������ �������� ������������
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
      2 :  //--------------------------------------------------------------------- �������
      begin
        vid := ObjZv[ob].VBufInd;
        OVBuffer[vid].Param[28] := ObjZv[ob].bP[4];
        if p = 1 then
        begin  p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end else
        begin  p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
      end;

      3 :  //----------------------------------------------- ������ ������������ �� ������
      begin
        ObjZv[ob].bP[33] := true;
        if p = 1 then
        begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end  else
        begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
      end;

      4 : //------------------------------------------------------------------------- ����
      begin
        ObjZv[ob].bP[33] := true;
        if p = 1 then
        begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj;  end else
        begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;  end;
      end;

      5 :  //-------------------------------------------------------------------- ��������
      begin
        if p = 1 then
        begin
          if ObjZv[ob].ObCB[5] then break; //--- ����� �������� � ����� 1 - ���������
          ObjZv[ob].bP[33] := true;
          p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj;
        end else
        begin
          if ObjZv[ob].ObCB[6] then break; //--- ����� �������� � ����� 2 - ���������
          ObjZv[ob].bP[33] := true;
          p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- ��
        ObjZv[ob].bP[33] := true; break;
      end;

      else //--------------------------------------------------------------- ��� ���������
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
//-------------- ����� ������������ ������� � ��������� ����������� (������ AvtoS ���� 46)
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
      if Napr then ObjZv[Str].bP[33]:=false else ObjZv[Str].bP[25]:= false;//����� ���/���
      ObjZv[Str].bP[4] := ObjZv[Str].bP[25] or ObjZv[Str].bP[33];
    end;

    Sig := BasOb;   //------------------------------ ������ ��������� � �������������
    ob := ObjZv[Sig].Sosed[2].Obj; //------------------------ ������ ��������� �� ��������
    p := ObjZv[Sig].Sosed[2].Pin;  //--------------------- ����� ����� ������� �� ��������
    ObjZv[Sig].bP[33] := false; //---------------------------- ������ ������������ �������

    j := 100;
    while j > 0 do
    begin
      case ObjZv[ob].TypeObj of
       2 :
       begin //------------------------------------------------------------------- �������
        if Napr then ObjZv[ob].bP[33] := false
        else ObjZv[ob].bP[25] := false;
        vid := ObjZv[ob].VBufInd;
        OvBuffer[vid].Param[28] := ObjZv[ob].bP[33] or ObjZv[ob].bP[25];// ��������� �����
        //--------------------- ���� ������� ��� ��� ������� � ������������ ����� �� �����
        if p = 1 then begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
        else  begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
       end;

        3 :
        begin //------------------------------------------------------------------- ������
          ObjZv[ob].bP[33] := false;  //-------------------------- ����� ������������ � ��
          if p = 1 then begin p:=ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
          else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
        end;

        4 :
        begin //--------------------------------------------------------------------- ����
          ObjZv[ob].bP[33] := false;
          if p = 1 then begin p:= ObjZv[ob].Sosed[2].Pin; ob:= ObjZv[ob].Sosed[2].Obj; end
          else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
        end;

        5 :
        begin //----------------------------------------------------------------- ��������
          if p = 1 then
          begin
            if ObjZv[ob].ObCB[5] then break;//���� �������� ����� ����� ��������-����
            ObjZv[ob].bP[33] := false; //------------------------------ ����� ������������
          p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj;
        end else
        begin
          if ObjZv[ob].ObCB[6] then break; //--------- ����� �� �������� ����� - ����
          ObjZv[ob].bP[33] := false;
          p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj;
        end;
      end;

      15 :
      begin //------------------------------------------------------------------------- ��
        ObjZv[ob].bP[33] := false;
        break;
      end;
      else //--------------------------------------------------------------- ��� ���������
        if p = 1 then begin p := ObjZv[ob].Sosed[2].Pin; ob := ObjZv[ob].Sosed[2].Obj; end
        else begin p := ObjZv[ob].Sosed[1].Pin; ob := ObjZv[ob].Sosed[1].Obj; end;
    end;
    if ob < 1 then break;
    dec(j);
  end;

  end;
end;

//========================================================================================
//------------------------------ ��������� ������� � �������� ����� ������ ���� "�������"
function StepTrasStr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
begin
  case Lvl of //-------------------------------------------- ������������� �� ���� �������
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
//----------------------------------------------------------------------- ��� ����� ������
function StepTrasSP(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  k : integer;
  tail : boolean;
begin
  case Lvl of
    tlFindTrace    : result := StepSpPutFindTras(Con, Lvl, Rod, Sp);
    tlContTrace    : result := StepSPContTras(Con, Lvl, Rod, Sp);
    tlVZavTrace    : result := StepSpZavTras (Con, Lvl, Rod, Sp);
    tlCheckTrace   : result := StepS�ChckTras(Con, Lvl, Rod, Sp);
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
//----------------------------------- (4) ��������� ���������� ���� ����������� ����� ����
//---------- Con - ����������� � �������� ��������, � �������� ������ ����� �� ������ ����
//---------- Lvl -------------------------------------------- ������� ����������� ��������
//---------- Rod ------------------------------------------------------------ ��� ��������
//---------- Put ---------------------------------------- ������ ������������ ������� ����

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
//------------------------------------------------------ ������ ��� ����� �������� �� ����
function StepTrasSig (var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//- Con : TSos - ��� ����� Con = jmp (������ ������), ��� ������ Con - ���� ������
//--------------------------------------- Lvl : TTrLev ---- ���� ������ � ���������
//------------------------------------------------------------ Rod:Byte ----- ��� ��������
//------------------------- jmp : TSos ------  ����� � �������, �� �������� ������
//------- ����� ������� jmp.Obj - ��� ��������, ����� ������� ������� �������� ��� �� ����
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
//---------------------------------------- (15) ��������� ����������� ����� ��������������
function StepTrasAB(var Con:TSos; const Lvl:TTrLev; Rod:Byte; AB:TSos):TTrRes;
var
  NumTxt,WarTxt : integer;
begin
  NumTxt := 0;
  WarTxt := 0;
  with ObjZv[AB.Obj] do
  begin
    case Lvl of
      tlFindTrace : //------------------------------------------------------- ����� ������
      begin
        result := trNext;
        if not MarhTrac.LvlFNext then  //----------------------- ���� �� ��������� �������
        if Con.Pin=1 then Con:= Sosed[2] else  Con := Sosed[1];
        if(Con.TypeJmp = LnkRgn) or(Con.TypeJmp = LnkEnd) then result := trRepeat;
      end;

      // ������� ������ �� ����� ��� ����������� �������, ���� ���� ����������� �� �������
      tlContTrace : if(Rod=MarshP) and ObCB[1] then result:= trKonec else result:= trStop;

      //----------------------------- ��������� ���������� �� ������ (����� ������ � ����)
      tlVZavTrace :
      begin
        if Con.Pin = 1 then  Con := Sosed[2] else Con := Sosed[1];
        if(Con.TypeJmp = LnkRgn) then result := trEnd else
        if(Con.TypeJmp = LnkEnd) then result := trStop else
        result := trNext;
      end;

      tlCheckTrace : //------------ ��������� ������ �� ����������� ������������� ��������
      begin
        result := trNext;
        case Rod of
          MarshP :
          begin
            if not bP[6] then //-------------------------------------------- ���� ����� ��
            begin
              if ObCB[3] and (bP[7] or bP[8]) then // �������� ���������� ��������� � ����
              begin result := trBreak; NumTxt := 363; end //----- ��������� ����������� ��
              else begin result:= trBreak; WarTxt:= 133;end;//�������������� ��� ���������
            end;

            if ObCB[1] then //-------------------------------- ���� ����������� �� �������
            begin
              if ObCB[2] then//------------------------------- ���� ���� ����� �����������
              begin
                if ObCB[3] then//------------------------------ ���� ������������ ��������
                begin
                  if ObCB[4] then //---------------------- ������� �� ������ ��� ���������
                  begin
                    //-------------------- �������� �� ��������� ��� ��������� �����������
                    if not bP[7] or bP[8] then begin result := trBreak; NumTxt := 132; end
                    else
                    if not ObCB[10] then  //---------------------------- ���� �� ���������
                    begin//------------------------------ �� �� ����������� �� �����������
                      if not bP[4] then begin result := trBreak; NumTxt := 128; end;
                    end else //-------------------------------------------- ���� ���������
                    begin
                      if not bP[4] and not bP[5] then //- ������� �� ������, ����� �������
                      begin result := trBreak; NumTxt := 262; end;
                    end;
                  end else
                  if ObCB[5] then //------------------------------- ������� �� �����������
                  begin //--------------------------------- �������� ��������� �����������
                    if bP[7] then begin result := trBreak; NumTxt := 132; end else
                    //------------------- �����, �� ����������� ����������� �� �����������
                    if bP[8] and not bP[4] then begin result:= trBreak; NumTxt:= 128; end;
                  end;
                end else
                begin //------------------- �������� ����� ����������� ��������� ���������
                  if not ObCB[10] then  //------------------------ ���� �� ��������� � ...
                  begin
                     //------------------ �����, �� ����������� ����������� �� �����������
                    if not bP[4] then begin result := trBreak;NumTxt := 128; end;
                  end else //---------------------------------------------- ���� ���������
                  //------------------------------------------------ ����� � ����� �������
                  if not bP[4] and not bP[5] then begin result:= trBreak;NumTxt:= 262;end;
                end;
              end;
            end //--------------------------------------------- ��� ����������� �� �������
            else begin result := trBreak; NumTxt := 131; end;

            if ObCB[3] then  //-------------------------------- ���� ������������ ��������
            begin
              if ObCB[4] then //------------------------------- ���� ��� ��������� - �����
              begin //----------------- � � ���������� - ����������� �� ������������� ����
                if not bP[2] or not bP[3] then //---- 1�� ��� 2�� = ����� ������� ��������
                begin result := trBreak;  NumTxt := 129; end;
              end else
              // ����������� �� ����������� ���� ��������� �� 1�� = ����� ������� ��������
              if not bP[2] then begin result := trBreak; NumTxt := 129; end;
            end else //------------------------------- ���� ��� ������������� ��������� ��
            //------------------------------------------------- 1�� ����� ������� ��������
            if not bP[2] then begin result := trBreak; NumTxt := 129; end;
            //-------------------------------------------------------- ��������� ���.�����
            if bP[9] then begin result := trBreak; NumTxt := 130; end;

            if bP[12] or  bP[13] then //----- ������� ������������ ���������� ("��������")
            begin result := trBreak; NumTxt := 432; end;

            if ObCB[8] or ObCB[9] then  //---------------------------------------- ���� ��
            begin
              //----------------------------------------------- ������ ��� �������� �� ��.
              if bP[24] or bP[27] then WarTxt := 462
              else
              if ObCB[8] and ObCB[9] then //------------------------------------- ����� ��
              begin
                if bP[25] or bP[28] then WarTxt := 467;// ������ ��� �������� �� ����.����
                if bP[26] or bP[29] then WarTxt := 472;//������ ��� �������� �� �����.����
              end;
            end else WarTxt := 474;//-------------------- ����� �������� ��������� �������
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
          if not bP[6] then //--------------------------------------------------------- ��
          begin
            if ObCB[3] and (bP[7] or bP[8]) then begin NumTxt:= 363; result:= trBreak;end
            // ������������ ��������-��������� ����������� ���������, ����� ��������������
            else WartXT := 133;
          end;

          if ObCB[1] then //---------------------------------- ���� ����������� �� �������
          begin
            if ObCB[2] then //------------------------------------- ���� ����� �����������
            begin
              if ObCB[3] then //------------------------------ ������� �������� ����������
              begin
                if ObCB[4] then //------------------------------------ ��� ��������� �����
                begin
                  if (not bP[7]) or (bP[7] and bP[8]) then //-- �� ��������� ��� � �������
                  begin  NumTxt := 132; result:= trBreak; end else

                  if not ObCB[10] and not bP[4] then //----  �� ��������� � �� �����������
                  begin NumTxt := 128; result:= trBreak; end;
                end else
                if ObCB[5] then //------------------------------ ��� ��������� �����������
                begin
                  //--------------------------------------------- �1 ��������� �����������
                  if bP[7] then begin NumTxt := 132; result:= trBreak; end else
                  if bP[8] then //----------------------------------------------------- �2
                  if not bP[4] then begin NumTxt := 128; result:= trBreak; end; //-- �����
                end;
              end
              //------------------------------------------- �������� ��  ��������� �������
              else if not bP[4] then begin NumTxt := 128; result:= trBreak; end;//-- �����
            end;
          end else
          begin NumTxt := 131; result:= trBreak; end; //------- ��� ����������� �� �������

          if ObCB[3] then //------------------------ ���������� �������� �� ��� ����������
          begin
            if ObCB[4] then //------------------------- ��� ���������� ��������� = �����
            begin //����������� �� �������������,  1��  ��� 2�� = ����� ������� ��������
              if not bP[2] or not bP[3] then begin NumTxt := 129; result:= trBreak; end;
            end else
            begin //---- ����������� �� ����������� ����, 1�� - ����� �������
              if not bP[2] then begin NumTxt := 129; result:= trBreak; end;
            end;
          end else //-------------------------------------------- ���������� �������� ��
          begin
            if not bP[2] then //---------------------------------------------------- 1��
            begin
              if Lvl= tlAutoTrace then exit;
              NumTxt := 129;
              result:= trBreak; //--------------------------------- ����� ������� ��������
            end;
          end;

          if bP[9] then begin NumTxt := 130; result:= trBreak; end;//- ��������� ���.�����
          if bP[12] or bP[13] then begin NumTxt:=433;result:= trBreak;end;//������� ������

          if ObCB[8] or ObCB[9] then//-------------------------- ���������� ������������
          begin
            if bP[24] or bP[27] then  WarTxt := 462 //----- ������ ��� �������� �� ��.�.
            else
            if ObCB[8] and ObCB[9] then //---------------------- ��� ���� �� �� ��������
            begin
              if bP[25] or bP[28] then WarTxt:=467;//---- ������ ��� �������� �� ����.�.
              if bP[26] or bP[29] then WarTxt:=472; //---- ������ ��� �������� �� ���.�.
            end;
          end else  WarTxt:=474;//--------------------- ������� $ �� �������������������
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
        MarhTrac.ObjEnd := AB.Obj; //------------ ������������� ����� �������� �����������
        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];
        if Con.TypeJmp = LnkRgn then result := trEnd else
        if Con.TypeJmp = LnkEnd then result := trStop
        else result := trNext;
      end;

      tlZamykTrace :
      begin
        bP[14] := true;  bP[15] := true;   //--------------------------- �������� � ������
        iP[1] := MarhTrac.ObjStart; //--------------------- �������� ������ ������� ������
        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];
        if Con.TypeJmp = LnkRgn then result := trEnd else
        if Con.TypeJmp = LnkEnd then result := trStop
        else result := trNext;
      end;

      tlOtmenaMarh :
      begin
        bP[14] := false; bP[15] := false; //----------------------------------- ����������
        if Con.Pin = 1 then Con := Sosed[2] else Con := Sosed[1];

        if Con.TypeJmp = LnkRgn then result := trEnd else
        if Con.TypeJmp = LnkEnd then result := trStop
        else result := trNext;
      end;

      tlFindIzvest :
      begin
        if ObCB[2] then  //--------------------------- ��� �������� ���� ����� �����������
        begin
          if ObCB[3] then //---------------------------------- �������� �� ���������������
          begin
            if ObCB[4] then //-------------- ��� ��������� ������� ������������� �� ������
            begin
              if bP[7] and not bP[8] then   //----------------- ��������� �1 � �������� �2
              begin
                if bP[4] then //------------------------------ ������� ���������� �� �����
                begin
                  if not bP[2] or not bP[3] then result := trBreak //-- ����� 1�� ��� 2��
                  else result := trStop;
                end else result := trStop;
              end else //-----------------------------------------  �1 � �2 �������� �����
              if not bP[2] or not bP[3] then result := trBreak      //-- ����� 1�� ��� 2��
              else result := trStop;
            end else
            if ObCB[5] then //----------------------- ������� ������������� �� �����������
            begin
              if not bP[7] and bP[8] then   //----------------- ��������� �2 � �������� �1
              begin
                if not bP[4] then //------------------------- �� �������� ���������� �����
                begin
                  if not bP[2] or not bP[3] then result := trBreak  //-- ����� 1�� ��� 2��
                  else result := trStop;
                end else
                if not bP[2] then result := trBreak else result := trStop;
              end else result := trStop;
            end else result := trStop;
          end else
          begin //------------------------------------------- �������� ��������� ���������
            if not bP[4] then //------------------------------ ������� ���������� �� �����
            begin
              if not bP[2] or not bP[3] then result := trBreak //------ ������ �����������
              else result := trStop;
            end else
            if not bP[2] then result := trBreak else result := trStop;
          end;
        end else //-------------------------------------- � �������� ��� ����� �����������
        if ObCB[4] then //-------------------------------- ������� ������������� �� ������
        begin
          if not bP[2] or not bP[3] then result := trBreak //---------- ������ �����������
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
//------------------------------------------------------------- ��������������� ������ (7)
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
      if ObjZv[Prig.Obj].bP[1] then //--------------------------------------------- ��
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,116, ObjZv[Prig.Obj].Liter,1);
        InsMsg(Prig.Obj,116); //------------ ������ ���������� ��������������� ������
        MarhTrac.GonkaStrel := false;
      end;

      if Con.Pin = 1 then   //---------------------------------- ��������� ���������������
      begin
        Con := ObjZv[Prig.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
        end;
      end else  //----------------------------------------------- �������� ���������������
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
      if ObjZv[Prig.Obj].bP[1] then //--------------------------------------------- ��
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,116, ObjZv[Prig.Obj].Liter,1);//---- ������ ���������� ���������������
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
//----------------------------------------------------------------------------- ����� (14)
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
            if ObjZv[Uksps.Obj].bP[1] then //----------------------------------------- ���
            begin
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,124, ObjZv[Uksps.Obj].Liter,1);
              InsWar(Uksps.Obj,124);
            end else
            begin
              if ObjZv[Uksps.Obj].bP[3] then //--------------------------------------- 1��
              begin
                result := trBreak;
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                GetSmsg(1,125, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,125);
                MarhTrac.GonkaStrel := false;
              end;

              if ObjZv[Uksps.Obj].bP[4] then //--------------------------------------- 2��
              begin
                result := trBreak;
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                GetSmsg(1,126, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,126);
                MarhTrac.GonkaStrel := false;
              end;

              if ObjZv[Uksps.Obj].bP[5] then //--------------------------------------- ���
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
            if ObjZv[Uksps.Obj].bP[1] then //-------------------------------------- ���
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,124, ObjZv[Uksps.Obj].Liter,1);
              InsWar(Uksps.Obj,124);
            end else
            begin
              if ObjZv[Uksps.Obj].bP[3] then //------------------------------------ 1��
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,125, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,125);
              end;

              if ObjZv[Uksps.Obj].bP[4] then //------------------------------------ 2��
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,126, ObjZv[Uksps.Obj].Liter,0);
                InsMsg(Uksps.Obj,126);
              end;

              if ObjZv[Uksps.Obj].bP[5] then //------------------------------------ ���
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
//---------------------------------------------- ��������������� ����� ����������� �� (16)
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
//------------------------------------------------------- ������ � ���������� ������� (23)
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
          InsMsg(ManR.Obj,244);    //----------------------- "��� �������� ���������"
          MarhTrac.GonkaStrel := false;
        end;

        MarshM :
        begin
         case Con.Pin of
          1 :
          begin
            if not ObjZv[ManR.Obj].bP[1] then //---------------------------------- ���
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
            if not ObjZv[ManR.Obj].bP[2] then //---------------------------------- ���
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
                  if not ObjZv[ManR.Obj].bP[1] then //---------------------------- ���
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,245, ObjZv[ManR.Obj].Liter,1);
                    InsMsg(ManR.Obj,245);
                  end;
                end;
              else
                if not ObjZv[ManR.Obj].bP[2] then //------------------------------ ���
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
//--------------------------------------------- ������ �������� ��������� ����������� (24)
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
          if not ObjZv[Zapr.Obj].bP[13] then //------------------------------------ ��
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,246, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,246); //------------------- ��� �������� ��������� ������
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Zapr.Obj].bP[3] then //--------------------------------------- ����
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,105, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,105);//-------- ������ ������ ����������� ������� �������
            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Zapr.Obj].bP[8] then //------------------------------------- ��
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,248, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,248); //---------- ���������� ���������� �������� �������
          end;

          if ObjZv[Zapr.Obj].bP[9] then //---------------------------------------- ���
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,249, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,249); //-------- ���������� ���������� ���������� �������
          end;

          if not ObjZv[Zapr.Obj].bP[7] then //-------------------------------------- �
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,250, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,250); //------------------------- ����� ������� �� ������
          end;

          if ObjZv[Zapr.Obj].bP[14] or
          ObjZv[Zapr.Obj].bP[15] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,432);  //------------------------------ ������� $ ������#
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Zapr.Obj].ObCB[8] or ObjZv[Zapr.Obj].ObCB[9] then
          begin
            if ObjZv[Zapr.Obj].bP[24] or
            ObjZv[Zapr.Obj].bP[27] then //--------------- ������ ��� �������� �� ��.�.
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[Zapr.Obj].Title,1);
              InsWar(Zapr.Obj,462); //--------------- ������� �������� �� �����������
            end else
            if ObjZv[Zapr.Obj].ObCB[8] and ObjZv[Zapr.Obj].ObCB[9] then
            begin
              if ObjZv[Zapr.Obj].bP[25] or
              ObjZv[Zapr.Obj].bP[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,467); // ������� �������� �� �� ����������� ���� �� $
              end;

              if ObjZv[Zapr.Obj].bP[26] or
              ObjZv[Zapr.Obj].bP[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,472); //-- ������� �������� �� �� ����������� ���� ��
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
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
          if not ObjZv[Zapr.Obj].bP[13] then //------------------------------------ ��
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,246, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,246);   //----------------- ��� �������� ��������� ������
          end;

          if ObjZv[Zapr.Obj].bP[3] then //--------------------------------------- ����
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,105, ObjZv[Zapr.Obj].Liter,1);
            InsMsg(Zapr.Obj,105);
          end;

          if not ObjZv[Zapr.Obj].bP[8] then //------------------------------------- ��
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,248, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,248);  //--------- ���������� ���������� �������� �������
          end;

          if ObjZv[Zapr.Obj].bP[9] then //---------------------------------------- ���
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,249, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,249); //-------- ���������� ���������� ���������� �������
          end;

          if not ObjZv[Zapr.Obj].bP[7] then //-------------------------------------- �
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,250, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,250); //------------------------- ����� ������� �� ������
          end;

          if ObjZv[Zapr.Obj].bP[14] or
          ObjZv[Zapr.Obj].bP[15] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[Zapr.Obj].Title,1);
            InsMsg(Zapr.Obj,432); //-------------------------------- ������� $ ������
          end;

          if ObjZv[Zapr.Obj].ObCB[8] or ObjZv[Zapr.Obj].ObCB[9] then
          begin
            if ObjZv[Zapr.Obj].bP[24] or
            ObjZv[Zapr.Obj].bP[27] then //--------------- ������ ��� �������� �� ��.�.
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[Zapr.Obj].Title,1);
              InsWar(Zapr.Obj,462); //------------ ������� �������� �� ����������� ��
            end else
            if ObjZv[Zapr.Obj].ObCB[8] and ObjZv[Zapr.Obj].ObCB[9] then
            begin
              if ObjZv[Zapr.Obj].bP[25] or
              ObjZv[Zapr.Obj].bP[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,467); //-- ������� �������� �� �� ����������� ���� ��
              end;

              if ObjZv[Zapr.Obj].bP[26] or
              ObjZv[Zapr.Obj].bP[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[Zapr.Obj].Title,1);
                InsWar(Zapr.Obj,472); //----------------- ����� ���������� �������� $
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,474, ObjZv[Zapr.Obj].Title,1);
            InsWar(Zapr.Obj,474);   //-------------- ������� $ �� �������������������
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
      not ObjZv[Zapr.Obj].bP[7] then //---------------------------- ������ �����������
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
//-------------------------------------------------------------------------------- ���(26)
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
          ObjZv[PAB.Obj].bP[13] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,432);  //------------------------------ ������� $ ������#
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[PAB.Obj].ObCB[8] or ObjZv[PAB.Obj].ObCB[9] then
          begin
            if ObjZv[PAB.Obj].bP[24] or
            ObjZv[PAB.Obj].bP[27] then //------------------ ������ ��� �������� �� ��
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[PAB.Obj].Liter,1);
              InsWar(PAB.Obj,462); //------------ ������� �������� �� ����������� ��
            end else
            if ObjZv[PAB.Obj].ObCB[8] and ObjZv[PAB.Obj].ObCB[9] then
            begin
              if ObjZv[PAB.Obj].bP[25] or
              ObjZv[PAB.Obj].bP[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,467); // ������� �������� �� �� ����������� ���� �� $
              end;

              if ObjZv[PAB.Obj].bP[26] or
              ObjZv[PAB.Obj].bP[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,472); // ������� �������� �� �� ����������� ���� �� $
              end;
            end;
          end else
          begin //--------------------------------------- ����� �������� ��������� �������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,474, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,474); //---------------- ������� $ �� �������������������
          end;

          if not ObjZv[PAB.Obj].bP[7] then //------------------- �������� �� ��������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,130, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,130); //-------- ��������� ������������� ����� �� �������
            MarhTrac.GonkaStrel := false;
          end else
          if not ObjZv[PAB.Obj].bP[1] then //---------------- ������� ����� �� ������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,318, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,318); //----------------------- ������� $ ����� �� ������
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[PAB.Obj].bP[2] then //------------------- �������� �������� ������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,319, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,319); //------------ �������� �������� ������ �� ��������
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[PAB.Obj].bP[4] then //-------- ������ �������� �� �������� �������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,320, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,320); // ������ �������� ����������� ������ �� �������� $
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[PAB.Obj].bP[6] then //----------------------- �������� �����������
          begin
            if not ObjZv[PAB.Obj].bP[5] then //���� ��������� �������� �� �����������
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,299, ObjZv[PAB.Obj].Liter,1);
              InsMsg(PAB.Obj,299); //---------------- ������� $ ����� �� �����������
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,237, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,237); //------------- ��� �������� ����������� �� �������
          end;

          if not ObjZv[PAB.Obj].bP[9] then //---------------------- ����� �����������
          begin
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,83);  //--------------------------------- ������� $ �����
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
          ObjZv[PAB.Obj].bP[13] then //------------------------- ������� ������������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,432, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,432); //-------------------------------- ������� $ ������
          end;

          if ObjZv[PAB.Obj].ObCB[8] or ObjZv[PAB.Obj].ObCB[9] then
          begin
            if ObjZv[PAB.Obj].bP[24] or
            ObjZv[PAB.Obj].bP[27] then //--------------- ������ ��� �������� �� ��.�.
            begin
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,462, ObjZv[PAB.Obj].Liter,1);
              InsWar(PAB.Obj,462); //---------- ������� �������� �� ����������� �� $
            end else
            if ObjZv[PAB.Obj].ObCB[8] and ObjZv[PAB.Obj].ObCB[9] then
            begin
              if ObjZv[PAB.Obj].bP[25] or
              ObjZv[PAB.Obj].bP[28] then //----------- ������ ��� �������� �� ����.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,467, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,467);
              end;

              if ObjZv[PAB.Obj].bP[26] or
              ObjZv[PAB.Obj].bP[29] then //------------ ������ ��� �������� �� ���.�.
              begin
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,472, ObjZv[PAB.Obj].Liter,1);
                InsWar(PAB.Obj,472); //-- ������� �������� �� �� ����������� ���� ��
              end;
            end;
          end else
          begin //-------------------------------------- ����� �������� ���������� �������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,474, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,474);
          end;

          if not ObjZv[PAB.Obj].bP[7] then //------------------- �������� �� ��������
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,130, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,130); //------ ��������� ������������� ����� �� ������� $
          end else
          if not ObjZv[PAB.Obj].bP[1] then //---------------- ������� ����� �� ������
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,318, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,318); //----------------------- ������� $ ����� �� ������
          end else
          if ObjZv[PAB.Obj].bP[2] then //------------------- �������� �������� ������
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,319, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,319); //---------- �������� �������� ������ �� �������� $
          end else
          if ObjZv[PAB.Obj].bP[4] then //-------- ������ �������� �� �������� �������
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,320, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,320); // ������ �������� ����������� ������ �� �������� $
          end else
          if ObjZv[PAB.Obj].bP[6] then //----------------------- �������� �����������
          begin
            if not ObjZv[PAB.Obj].bP[5] then //���� ��������� �������� �� �����������
            begin
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,299, ObjZv[PAB.Obj].Liter,1);
              InsMsg(PAB.Obj,299); //---------------- ������� $ ����� �� �����������
            end;
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,237, ObjZv[PAB.Obj].Liter,1);
            InsMsg(PAB.Obj,237);  //------------ ��� �������� ����������� �� �������
          end;

          if not ObjZv[PAB.Obj].bP[9] then //---------------------- ����� �����������
          begin
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[PAB.Obj].Liter,1);
            InsWar(PAB.Obj,83); //---------------------------------- ������� $ �����
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
      if not ObjZv[PAB.Obj].bP[9] then  result := trBreak  //----- ������ �����������
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
//---------------------------------------------------------------- ���������� ������� (27)
function StepTrasDZOhr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Dz:TSos) : TTrRes;
var
  StrO,StrK,HvostO,HvostK : integer;
  tr : boolean;
begin
  StrK := ObjZv[Dz.Obj].ObCI[1]; //-------------------------------- �������������� �������
  StrO := ObjZv[Dz.Obj].ObCI[3]; //-------------------------------------- �������� �������
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

    tlVZavTrace : //------------------------- �������� ��������� ��������� ��� �����������
    begin
      if (StrK > 0) and (StrO > 0) then
      begin
        tr := ObjZv[StrO].bP[6] or ObjZv[StrO].bP[7] or //- ��,�� ��� ����������� ��������
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
        begin //---------------------------- ����������� ����� �������� ������� � ��������
          if ObjZv[Dz.Obj].ObCB[1] then //------ �������������� ������� ���������� � �����
          begin
            if((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or ObjZv[StrK].bP[12]) then
            begin
              if ObjZv[Dz.Obj].ObCB[3] then //--------------- �������� ������ ���� � �����
              begin
                if (ObjZv[StrO].bP[10] and ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20]=0) and ObjZv[StrO].bP[7])or ObjZv[StrO].bP[13] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //------ ������ �� � ...
                  not ObjZv[StrO].bP[14] then //-------------------- ��� ��������� �� STAN
                  begin
                    result := trStop;
                    exit; //----------------------- �������� ������������ � ������ - �����
                  end;
                end;
              end else
              if ObjZv[Dz.Obj].ObCB[4] then //------- �������� ������ ���� � ������
              begin
                if (ObjZv[StrO].bP[10] and not ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20] = 0) and ObjZv[StrO].bP[6]) or
                ObjZv[StrO].bP[12] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //-- ������ ��
                  not ObjZv[StrO].bP[14] then //-- �� ������ ���������� ������� � ������
                  begin
                    result := trStop; exit; //------ �������� ������������ � ����� - �����
                  end;
                end;
              end;
            end;
          end else
          if ObjZv[Dz.Obj].ObCB[2] then//�������������� ������� ���������� � ������
          begin
            if ((ObjZv[StrK].bP[10] and ObjZv[StrK].bP[11]) or
            ObjZv[StrK].bP[13]) then
            begin
              if ObjZv[Dz.Obj].ObCB[3] then //-------- �������� ������ ���� � �����
              begin
                if (ObjZv[StrO].bP[10] and ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20] = 0) and ObjZv[StrO].bP[7]) or
                ObjZv[StrO].bP[13] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //-- ������ ��
                  not ObjZv[StrO].bP[14] then //-- �� ������ ���������� ������� � ������
                  begin
                    result := trStop; exit; //----- �������� ������������ � ������ - �����
                  end;
                end;
              end else
              if ObjZv[Dz.Obj].ObCB[4] then //------- �������� ������ ���� � ������
              begin
                if (ObjZv[StrO].bP[10] and not ObjZv[StrO].bP[11]) or
                ((ObjZv[StrK].ObCI[20] = 0) and ObjZv[StrO].bP[6]) or
                ObjZv[StrO].bP[12] then
                begin
                  if (ObjZv[StrK].UpdOb <> ObjZv[StrO].UpdOb) and //-- ������ ��
                  not ObjZv[StrO].bP[14] then //-- �� ������ ���������� ������� � ������
                  begin
                    result := trStop; exit; //------ �������� ������������ � ����� - �����
                  end;
                end;
              end;
            end;
          end;
        end else
        begin //------------------------- �� ����������� ����� �������� ������� � ��������
          if ((Dz.Pin = 1) and not ObjZv[Dz.Obj].ObCB[6]) or
          ((Dz.Pin = 2) and not ObjZv[Dz.Obj].ObCB[7]) then
          begin
            if ObjZv[Dz.Obj].ObCB[1] then //- �������������� ������� ���������� � +
            begin
              if ((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or
              ObjZv[StrK].bP[12]) then
              begin
                if ObjZv[Dz.Obj].ObCB[3] then //------ �������� ������ ���� � �����
                begin
                  if not (ObjZv[StrO].bP[1] and not ObjZv[StrO].bP[2]) then
                  begin //--------------------- �������� �� ����� �������� � ����� - �����
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,268); //- ��� �������� ����� �������
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZv[Dz.Obj].ObCB[4] then //----- �������� ������ ���� � ������
                begin
                  if not (not ObjZv[StrO].bP[1] and ObjZv[StrO].bP[2]) then
                  begin //-------------------- �������� �� ����� �������� � ������ - �����
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,267,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,267); // ��� �������� ������ �������
                    result := trStop;
                    exit;
                  end;
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[2] then //- �������������� ������� ���������� � -
            begin
              if ((ObjZv[StrK].bP[10] and ObjZv[StrK].bP[11]) or
              ObjZv[StrK].bP[13]) then
              begin
                if ObjZv[Dz.Obj].ObCB[3] then //------ �������� ������ ���� � �����
                begin
                  if not (ObjZv[StrO].bP[1] and not ObjZv[StrO].bP[2]) then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,268); //- ��� �������� ����� �������
                    result := trStop;
                    exit;
                  end;
                end else
                if ObjZv[Dz.Obj].ObCB[4] then //----- �������� ������ ���� � ������
                begin
                  if not (not ObjZv[StrO].bP[1] and ObjZv[StrO].bP[2]) then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,267,ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,267); // ��� �������� ������ �������
                    result := trStop; exit;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      //--------------------------------------------------- ����� ��������� ������� ������
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
      //------------ �������� ����������� ��������� �������� ������� � ��������� ���������
      StrK := ObjZv[Dz.Obj].ObCI[1]; //---------------------------- �������������� �������
      StrO := ObjZv[Dz.Obj].ObCI[3]; //---------------------------------- �������� �������

      if (StrK > 0) and (StrO > 0) then
      begin
        if ObjZv[Dz.Obj].ObCB[1] then
        begin
          if ((ObjZv[StrK].bP[10] and not ObjZv[StrK].bP[11]) or
          ObjZv[StrK].bP[12]) then //----------�������������� ������� ���������� � �����
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //--------- �������� ������� ������ ���� � �����
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZv[HvostO].bP[7] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);// �� ��������(���. � �������� +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if not ObjZv[StrO].bP[1] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); // ��������� ����� �������, � ���������

                if not ObjZv[StrO].bP[2] then //----------------- ��� �������� ���������
                begin
                  if not ObjZv[StrO].bP[6] then
                  begin
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                    InsMsg(HvostO,81); //------ ������� $ ��� ��������
                    result := trBreak;
                    MarhTrac.GonkaStrel := false;
                  end;
                end else
                if not ObjZv[HvostO].bP[21] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);// �� ��������(���. � �������� +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].ObCB[3] and//--- ���� ��������� ��� �
                not ObjZv[HvostO].bP[20] then //..... ���� �������� ���
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80); //------------ ������� $ ��������
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,118, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,118);//�� ������ ��� $ � �������� �� +
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,136, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,136);// ��� �� ������(������ ���� ��+)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- �������� ������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,121, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,121);//��� ��������� (� �������� �� +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZv[HvostO].bP[6] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if ObjZv[HvostO].ObCB[3] and//--- ���� ��������� ��� �
                not ObjZv[HvostO].bP[20] then //..... ���� �������� ���
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTrac.GonkaStrel := false;
                end;

              if not ObjZv[StrO].bP[2] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); // ��������� ����� ������������ �������
                if not ObjZv[StrO].bP[1] then
                begin //------------------------------------------- ��� �������� ���������
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
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,157, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,157);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,158, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,158);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,137, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,137);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- �������� ������� ���������
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
          ObjZv[StrK].bP[13]) then //-------- �������������� ������� ���������� � ������
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //-- �������� ������� ������ ���� � �����
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZv[HvostO].bP[7] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);//�� �������� (������� ����� � +)
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if ObjZv[HvostO].ObCB[3] and//--- ���� ��������� ��� �
                not ObjZv[HvostO].bP[20] then //..... ���� �������� ���
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTrac.GonkaStrel := false;
                end;

              if not ObjZv[StrO].bP[1] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); // ��������� ����� ������������ �������

                if not ObjZv[StrO].bP[2] then
                begin //------------------------------------------- ��� �������� ���������
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
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].ObCB[3] and//--- ���� ��������� ��� �
                not ObjZv[HvostO].bP[20] then //..... ���� �������� ���
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //- ���� �������� ������� ��������. ��������� �������
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,118, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,118);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,136, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,136);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- �������� ������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,121, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,121);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZv[StrK].ObCI[20] = StrO then
              begin //--------- ������� �������� ����������� �������� �������� ����� �����
                if ObjZv[HvostO].bP[6] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,117, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,117);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if ObjZv[HvostO].ObCB[3] and//--- ���� ��������� ��� �
                not ObjZv[HvostO].bP[20] then //..... ���� �������� ���
                begin
                  InsNewMsg(HvostO,392+$4000,1,'');
                  ShowSMsg(392,LastX,LastY,ObjZv[HvostO].Liter);
                  result := trBreak;
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,392, ObjZv[StrO].Liter,1);
                  InsMsg(StrO,392); //-- ���� �������� ������� ��������. ��������� �������
                  MarhTrac.GonkaStrel := false;
                end;
                
              if not ObjZv[StrO].bP[2] then
              begin
                if not MarhTrac.Povtor and not MarhTrac.Dobor then
                inc(MarhTrac.GonkaList); //- ��������� ����� ����������� �������

                if not ObjZv[StrO].bP[1] then
                begin //------------------------------------------- ��� �������� ���������
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
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,157, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,157);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[4] then
                begin //---------------------------------------- �������� ������� ��������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if not ObjZv[HvostO].bP[22] then
                begin //------------------------------------------ �������� ������� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,158, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,158);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[HvostO].bP[19] then
                begin //--------------------------------------- �������� ������� �� ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,137, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,137);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;

                if ObjZv[StrO].bP[18] then
                begin //--------------------------------------- �������� ������� ���������
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
      //------------ �������� ����������� ��������� �������� ������� � ��������� ���������
      StrK := ObjZv[Dz.Obj].ObCI[1]; //---------------------------- �������������� �������
      StrO := ObjZv[Dz.Obj].ObCI[3]; //---------------------------------- �������� �������

      if (StrK > 0) and (StrO > 0) then
      begin
        if ObjZv[Dz.Obj].ObCB[1] then
        begin
          if ObjZv[StrK].bP[1] then //---------- �������������� ������� ���������� � �����
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //--------- �������� ������� ������ ���� � �����
            begin
              if ObjZv[StrO].bP[1] then
              begin //------------------------------------ ��������� ������� ����� � �����
                if ObjZv[StrO].bP[7] then
                begin //--------------------------------- �������� ������� ������� � �����
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);
                end;
              end else
              begin
                if not ObjZv[StrO].bP[2] then
                begin //------------------------------------------- ��� �������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81);
                end else
                begin //---------------------------------------- �������� ������� � ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZv[StrO].bP[2] then
              begin //------------------------------------- ��������� ������� ����� � ����
                if ObjZv[StrO].bP[6] then
                begin //---------------------------------- �������� ������� ������� � ����
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235);
                end;
              end else
              begin
                if not ObjZv[StrO].bP[1] then
                begin //------------------------------------------- ��� �������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81); //--- ������� $ �� ����� ��������
                end else
                begin //----------------------------------------- �������� ������� � �����
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235); //-- �������� ���. � + (����� -)
                end;
              end;
            end;
          end;
        end else
        if ObjZv[Dz.Obj].ObCB[2] then
        begin
          if ObjZv[StrK].bP[2] then //------- �������������� ������� ���������� � ������
          begin
            if ObjZv[Dz.Obj].ObCB[3] then //-- �������� ������� ������ ���� � �����
            begin
              if ObjZv[StrO].bP[1] then
              begin //------------------------------------ ��������� ������� ����� � �����
                if ObjZv[StrO].bP[7] then
                begin //--------------------------------- �������� ������� ������� � �����
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);//--- �������� ���. � - (����� +)
                end;
              end else
              begin
                if not ObjZv[StrO].bP[2] then
                begin //------------------------------------------- ��� �������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81); //--- ������� $ �� ����� ��������
                end else
                begin //---------------------------------------- �������� ������� � ������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,236, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,236);//--- �������� ���. � - (����� +)
                end;
              end;
            end else
            if ObjZv[Dz.Obj].ObCB[4] then //- �������� ������� ������ ���� � ������
            begin
              if ObjZv[StrO].bP[2] then
              begin //----------------------------00------- ��������� ������� ����� � ����
                if ObjZv[StrO].bP[6] then
                begin //-------------------------00------- �������� ������� ������� � ����
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235); //00 �������� ���. � + (����� -)
                end;
              end else
              begin
                if not ObjZv[StrO].bP[1] then
                begin //-----------------------00------------------ ��� �������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,81, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,81); //----------------------- ������� $ �� ����� ��������
                end else
                begin //----------------------------------------- �������� ������� � �����
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,235, ObjZv[HvostO].Liter,1);
                  InsMsg(HvostO,235); //-- �������� ���. � + (����� -)
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
//-------------------------------------------------------------- ��������� �� ������� (28)
function StepTrasIzPer(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Per:TSos) : TTrRes;
var
  o : integer;
begin
  case Lvl of
    tlFindTrace :  //-------------------------------------------------------- ����� ������
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
      o := ObjZv[Per.Obj].BasOb; //--------------------------------- ������ ��������
      if ObjZv[o].bP[4] then //--------------------------------------- �� �� ��������
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,107, ObjZv[o].Liter,1);
        result := trBreak;
        InsMsg(o,107);
        MarhTrac.GonkaStrel := false;
      end;

      if ObjZv[o].bP[1] then //----------------------------------- ������ �� ��������
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,143, ObjZv[o].Liter,1);
        result := trBreak;
        InsWar(o,143);
        MarhTrac.GonkaStrel := false;
      end;

      if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then // ������������� �� ��������
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
      if ObjZv[o].bP[4] then //--------------------------------------- �� �� ��������
      begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,107, ObjZv[o].Liter,1);
            InsMsg(o,107);
          end;
          if ObjZv[o].bP[1] then
          begin // ������ �� ��������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,143, ObjZv[o].Liter,1);
            InsWar(o,143);
          end;
          if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
          begin // ������������� �� ��������
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
//------------------------------------------------------------------------- �� ������ (29)
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
                  begin //------------------------------------------------------------ ���
                    if ((not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                    (ObjZv[o].bP[1] and ObjZv[o].bP[2])) and not ObjZv[o].bP[3] then
                    begin // ���� ������� � ����������� � �� ����� �������� ���������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                      InsMsg(o,109); result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end
                    else
                    if not ObjZv[o].bP[1] and ObjZv[o].bP[2] and
                    not ObjZv[o].bP[3] and (Rod = MarshP) then
                    begin //--- ���� ���������� � ������� � ����������� � �������� �������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                      InsMsg(o,108); result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end else
                    if not ObjZv[o].bP[27] then
                    begin //------------------------- �� ���������������� ��������� �� ���
                      if ObjZv[o].bP[3] then
                      begin //------------------------------ ���� �������� �� ������������
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,253, ObjZv[o].Liter,1);
                        InsWar(o,253); result := trBreak;
                      end;
                      if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                      begin // ���� ����������
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                        InsWar(o,108); result := trBreak;
                      end else
                      if (not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                      (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
                      begin //--------------------------- ���� �� ����� �������� ���������
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                        InsWar(o,109);
                        result := trBreak;
                      end;
                    end;
                    if result = trBreak then ObjZv[o].bP[27] := true;
                  end;

                  33 :
                  begin //----------------------------------------------- ��������� ������
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
                  //------------------------------------------ ������ ������� ������������
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
                  begin // ���
                    if ((not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                    (ObjZv[o].bP[1] and ObjZv[o].bP[2])) and not ObjZv[o].bP[3] then
                    begin // ���� ������� � ����������� � �� ����� �������� ���������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                      InsMsg(o,109);
                    end else
                    if not ObjZv[o].bP[1] and ObjZv[o].bP[2] and
                    not ObjZv[o].bP[3] and (Rod = MarshP) then
                    begin // ���� ���������� � ������� � ����������� � �������� �������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                      InsMsg(o,108);
                    end else
                    if not ObjZv[o].bP[27] then
                    begin
                      p := false;
                      if ObjZv[o].bP[3] then
                      begin // ���� �������� �� ������������
                        p := true;
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,253, ObjZv[o].Liter,1);
                        InsWar(o,253);
                      end;
                      if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                      begin // ���� ����������
                        p := true;
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,108, ObjZv[o].Liter,1);
                        InsWar(o,108);
                      end else
                      if (not ObjZv[o].bP[1] and not ObjZv[o].bP[2]) or
                      (ObjZv[o].bP[1] and ObjZv[o].bP[2]) then
                      begin // ���� �� ����� �������� ���������
                        p := true;
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] := GetSmsg(1,109, ObjZv[o].Liter,1);
                        InsWar(o,109);
                      end;
                      if p then ObjZv[o].bP[27] := true;
                    end;
                  end;

                  33 : begin // ��������� ������
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
                  // ������ ������� ������������
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
//--------------------------------------------------------- ������ ��������� �������� (30)
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
      begin //-------------------------- ���������� ����������� ���� ���� ����� ����������
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
      begin //-------------------------- ���������� ����������� ���� ���� ����� ����������
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
      else result := trKonec; //��������� ����������� ��������, ������ ����� ����������
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
              begin //-------------------------------------------------- ������ ������ ���
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,105, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,105);//- "������ ������ ����������� ������� �������"
                result := trBreak;
              end;

              if not ObjZv[sig_uvaz].bP[4] then
              begin //--------------------------------------------- ��� ��������� ��������
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,246, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,246);  //----------- "��� �������� ��������� ������"
                result := trBreak;
              end;
            end;
          end;
        end;
      end;

      if Sogl.Obj <> MarhTrac.ObjLast then
      begin
        if uch_uvaz > 0 then
        begin //------------------------------------ ��������� ������������ ������� ������
          if not ObjZv[uch_uvaz].bP[2] or not ObjZv[uch_uvaz].bP[3] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[uch_uvaz].Liter,1);
            InsMsg(uch_uvaz,113); //-------- "�� ���� ���������� ���������� �������"
            result := trBreak;
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;

      MarhTrac.TailMsg := ' �� '+ ObjZv[ObjZv[Sogl.Obj].BasOb].Liter;
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
              begin //-------------------------------------------------- ������ ������ ���
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,105, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,105);
              end;

              if not ObjZv[sig_uvaz].bP[4] then
              begin //--------------------------------------------- ��� ��������� ��������
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
        begin //------------------------------------ ��������� ������������ ������� ������
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
              begin //-------------------------------------------------- ������ ������ ���
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,105, ObjZv[sig_uvaz].Liter,1);
                InsMsg(sig_uvaz,105);
              end;

              if not ObjZv[sig_uvaz].bP[4] then
              begin //--------------------------------------------- ��� ��������� ��������
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
        begin //------------------------------------ ��������� ������������ ������� ������
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
      MarhTrac.TailMsg := ' �� '+ ObjZv[sig_uvaz].Liter;
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
//---------------------------------------------------------- ������ � ������ (������) (32)
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
                      result := trBreak;  TailMsg := ' �� '+ ObjZv[Uvaz.Obj].Liter;
                      if ObjZv[Uvaz.Obj].bP[10] then
                      begin //-------------------------  ��� ���� ������� ������� �� �����
                        inc(MsgN);
                        Msg[MsgN] := GetSmsg(1,355, ObjZv[Uvaz.Obj].Liter,1);
                        InsMsg(Uvaz.Obj,355); //------------- ������� ������� ������� ��
                        GonkaStrel := false;
                        exit;
                      end;

                      case Rod of
                        MarshP :
                        begin
                          o := 1;
                          while o < 13 do //- 12 ���������� ������� � ������� ������ �����
                          begin
                            if ObjStart = ObjZv[ObjZv[Uvaz.Obj].UpdOb].ObCI[o] then break;
                            inc(o);
                          end;

                          if o > 12 then
                          begin
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,106, ObjZv[ObjStart].Liter,1);
                            InsMsg(ObjStart,106); //- "��� ��������� ������� �� ..."
                            GonkaStrel := false;
                            exit;
                          end else
                          if ObjZv[Uvaz.Obj].bP[12] or ObjZv[Uvaz.Obj].bP[13] then
                          begin //------------------ ���������� ������ ��������� ���������
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,123, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,123);  //------ "�������� $ ������������"
                            GonkaStrel := false;
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[11] then
                          begin //----------------------------------------------------- ��
                            inc(MsgN);
                            Msg[MsgN] :=
                            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                            GetSmsg(1,83, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,83); //---------------- "������� $ �����"
                            GonkaStrel := false;
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[7] then
                          begin //---------------------------------------------------- ���
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,105, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,105);
                            GonkaStrel := false;
                            exit;
                          end;

                          if not ObjZv[Uvaz.Obj].bP[8] then
                          begin //----------------------------------- ��� �������� �������
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
                          begin //------------ ���������� �������� ������� �� ���� �������
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
                          begin //---------------------------------- ��� �������� ��������
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
                      begin //-------------------------- ��� ���� ������� ������� �� �����
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
                            InsMsg(ObjStart,106);  //------- ��� ��������� ������� �� $
                            exit;
                          end else
                          if ObjZv[Uvaz.Obj].bP[12] or ObjZv[Uvaz.Obj].bP[13] then
                          begin //------------------ ���������� ������ ��������� ���������
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,123, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,123);
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[11] then
                          begin //----------------------------------------------------- ��
                            inc(MsgN);
                            Msg[MsgN] :=
                            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                            GetSmsg(1,83, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,83);  //-------------------- ������� $ �����
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[7] then
                          begin //---------------------------------------------------- ���
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,105, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,105);//----------------- "������ ������ ���"
                            exit;
                          end;

                          if not ObjZv[Uvaz.Obj].bP[8] then
                          begin //----------------------------------- ��� �������� �������
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,103, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,103); //------------ ��� �������� ������� ��
                            exit;
                          end;

                          o := PutNadviga;
                          if Con.Pin = 1 then
                          begin
                            if not ObjZv[ObjZv[o].BasOb].bP[4] and
                            not ObjZv[ObjZv[o].BasOb].bP[2] then
                            begin //--- ���������� ������ �������� ������� �� ���� �������
                              inc(MsgN);
                              Msg[MsgN]:=GetSmsg(1,356,ObjZv[ObjZv[o].BasOb].Liter,1);
                              InsMsg(ObjZv[o].BasOb,356);
                              exit;
                            end;
                          end else
                          begin
                            if not ObjZv[ObjZv[o].BasOb].bP[4] and
                            not ObjZv[ObjZv[o].BasOb].bP[3] then
                            begin // ���������� �������� �������� ������� �� ���� �������
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
                          begin //---------------------------------- ��� �������� ��������
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
                          begin //------------------ ���������� ������ ��������� ���������
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,123, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,123);
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[11] then
                          begin //----------------------------------------------------- ��
                            inc(MsgN);
                            Msg[MsgN] :=
                            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
                            GetSmsg(1,83,ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,83);
                            exit;
                          end;

                          if ObjZv[Uvaz.Obj].bP[7] then
                          begin //---------------------------------------------------- ���
                            inc(MsgN);
                            Msg[MsgN] := GetSmsg(1,105, ObjZv[Uvaz.Obj].Liter,1);
                            InsMsg(Uvaz.Obj,105);
                            exit;
                          end;

                          if not ObjZv[Uvaz.Obj].bP[8] then
                          begin //----------------------------------- ��� �������� �������
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
                            begin //���������� ���������� �������� ������� �� ���� �������
                              inc(MsgN);
                              Msg[MsgN]:=GetSmsg(1,356,ObjZv[ObjZv[o].BasOb].Liter,1);
                              InsMsg(ObjZv[o].BasOb,356);
                              exit;
                            end;
                          end else
                          begin
                            if not ObjZv[ObjZv[o].BasOb].bP[4] and
                            not ObjZv[ObjZv[o].BasOb].bP[3] then
                            begin //- ���������� �������� �������� ������� �� ���� �������
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
                          begin //---------------------------------- ��� �������� ��������
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

     tlFindIzvest : if ObjZv[Uvaz.Obj].bP[11] then result := trBreak //������ �����������
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
//-------------------------------------------------------- �������� �������� �������  (38)
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
          MarhTrac.PutNadviga := Nad.Obj; // ��������� ������ ������� �������� ������� � ����
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
          MarhTrac.PutNadviga := Nad.Obj; // ��������� ������ ������� �������� ������� � ����
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
//----------------------------------------------------- �������� �������� ����������� (41)
function StepTrasOtpr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Otpr:TSos) : TTrRes;
var
  k,o,hvost,s_v_put : integer;
begin
  result := trNext;
  s_v_put := Otpr.Obj;
  case Lvl of
    tlFindTrace : //--------------------------------------------------------- ����� ������
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

      if Con.Pin = 1 then //--------------------- ���� � ������ ��  ������� ��� 1 (������)
      begin
        Con := ObjZv[s_v_put].Sosed[2];
        if (Rod = MarshP) and ObjZv[s_v_put].ObCB[1] then //�������� � ��������� ���
        begin
          ObjZv[s_v_put].bP[21] := true; //-------- ����������� ��������� �����������
          for k := 1 to 4 do //----------------------- ������ �� ��������� �������� � ����
          begin
            o := ObjZv[s_v_put].ObCI[k]; //------------- ����� ������ ������� � ����
            if o > 0 then
            begin
              hvost := ObjZv[o].BasOb;

              if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
              begin //------------------------- ������� � ���� �� ����� �������� ���������
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,81, ObjZv[hvost].Liter,1);
                InsMsg(hvost,81);//----------- ������� $ �� ����� �������� ���������
                MarhTrac.GonkaStrel := false;
                exit;
              end else
              if (ObjZv[hvost].bP[4] or //------ ���� � ������� ���.��������� ��� ...
              ObjZv[hvost].bP[14]) and //----------------- ����������� ��������� �...
              ObjZv[hvost].bP[21] then //------------------------ ��� ��������� �� ��
              begin //--------------------------- �������� ������� ������������ � ��������
                if (ObjZv[s_v_put].ObCB[k*3+1] and //���������� �� "-" ������� � ...
                ObjZv[hvost].bP[6]) or //-------------------- ���� ������� �� ��� ...
                (ObjZv[s_v_put].ObCB[k*3] and //---- ���������� �� "+" ������� � ...
                ObjZv[hvost].bP[7]) then //-------------------------- ���� ������� ��
                begin //------------------------ ����������� � ������ �������� �����������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[hvost].Liter,1); //----------- ������� $ ��������
                  InsMsg(hvost,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if (not ObjZv[o].bP[1] or ObjZv[o].bP[2]) and //- �� � ����� � ...
              (not ObjZv[hvost].bP[21]) and (Rod = MarshP) then //-- ������� ��������
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,80, ObjZv[hvost].Liter,1);
                InsMsg(hvost,80);//----------- ������� $ �� ����� �������� ���������
                MarhTrac.GonkaStrel := false;
                exit;
              end;

              if ObjZv[s_v_put].ObCB[k*3+2] then // ���� ������������� ����� �������
              begin
                if ObjZv[s_v_put].ObCB[k*3] and //---------- ���������� �� "+" � ...
                not ObjZv[o].bP[1] then  //----------------------- ������� �� � �����
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then //--- ��� ������� ������� ...
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZv[hvost].bP[21] then //-���� �������� ������� ��������
                    begin
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117); //-------------- ���������� ������ ��������
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then //------- �������� ������� ������
                    begin
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118); //--------------- ���������� ������ ������
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or   //-------- ���� ������� �� ������ ���
                    ObjZv[hvost].bP[19] then   //-------------------- �� ����� ������
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,136, ObjZv[hvost].Liter,1);//----- ������� $ �� ������.
                      InsMsg(hvost,136);//����� ��������� ������ ���� ���������� � +
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then //------------ �������� ������� ���������
                    begin
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,121, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,121);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZv[hvost].bP[21] and //----- ���� ��� ��������� �� �� � ...
                    ObjZv[hvost].bP[22] then  //----------------- ��� ��������� �� ��
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZv[hvost].bP[15] or //------------- ������� �� ������ ���
                      ObjZv[hvost].bP[19] then //-------------------- �� ����� ������
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,136, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,136); //"������� �� ������, ������� �������� +"
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- �������� ������� ���������
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,121, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,121); //------- ������� ��������� �� ����������
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end else
                    begin
                      if ObjZv[hvost].bP[15] or
                      ObjZv[hvost].bP[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTrac.WarN);
                        MarhTrac.War[MarhTrac.WarN] :=
                        GetSmsg(1,136, ObjZv[hvost].Liter,1);
                        InsWar(hvost,136); //----- ������� �� ������, ������� � ����
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;
                    end;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and
                not ObjZv[o].bP[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZv[hvost].bP[21] then
                    begin //------------------------------------ �������� ������� ��������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117); //---------------------- ������ �� ��������
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then
                    begin //-------------------------------------- �������� ������� ������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or
                    ObjZv[hvost].bP[19] then
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,137, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,137);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then
                    begin //----------------------------------- �������� ������� ���������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,159, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,159);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZv[hvost].bP[21] and
                    ObjZv[hvost].bP[22] then
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZv[hvost].bP[15] or
                      ObjZv[hvost].bP[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,137, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,137);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- �������� ������� ���������
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
                      begin //--------------------------------- �������� ������� �� ������
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
              begin //--------------------- ���������� ����� ������� � ���� �� �����������
                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //- ��� ����.�����. ��� ������� � ���� ��� ��� ���������,���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[o].Liter,1);
                    InsMsg(hvost,268);
                    MarhTrac.GonkaStrel := false;
                    exit;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //-- ��� ����.�����.��� ������� � ���� ��� ��� ���������,���������
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
              begin //------------------------- ������� � ���� �� ����� �������� ���������
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,81, ObjZv[hvost].Liter,1);
                InsMsg(hvost,81);
                MarhTrac.GonkaStrel := false; exit;
              end else

              if (ObjZv[hvost].bP[4] or ObjZv[hvost].bP[14]) and
              ObjZv[hvost].bP[21] then
              begin //--------------------------- �������� ������� ������������ � ��������
                if (ObjZv[s_v_put].ObCB[k*3+1] and ObjZv[hvost].bP[6]) or
                (ObjZv[s_v_put].ObCB[k*3] and ObjZv[hvost].bP[7]) then
                begin //------------------------ ����������� � ������ �������� �����������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,80, ObjZv[hvost].Liter,1);
                  InsMsg(hvost,80);
                  result := trBreak;
                  MarhTrac.GonkaStrel := false;
                end;
              end;

              if (not ObjZv[o].bP[1] or ObjZv[o].bP[2]) and //- �� � ����� � ...
              (not ObjZv[hvost].bP[21]) and (Rod = MarshP) then //-- ������� ��������
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] :=
                GetSmsg(1,80, ObjZv[hvost].Liter,1);
                InsMsg(hvost,80);//------------------------------ ������� $ ��������
                MarhTrac.GonkaStrel := false;
                exit;
              end;

              if ObjZv[s_v_put].ObCB[k*3+2] then
              begin //------------------------ ���������� ����� ������� � ���� �����������
                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZv[hvost].bP[21] then
                    begin //------------------------------------ �������� ������� ��������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then
                    begin //-------------------------------------- �������� ������� ������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,136, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,136);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then
                    begin //----------------------------------- �������� ������� ���������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,121, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,121);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22] then
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,136, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,136);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- �������� ������� ���������
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
                      begin //--------------------------------- �������� ������� �� ������
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
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    if not ObjZv[ObjZv[o].BasOb].bP[21] then
                    begin //------------------------------------ �������� ������� ��������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,117, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,117);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if not ObjZv[hvost].bP[22] then
                    begin //-------------------------------------- �������� ������� ������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,118, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,118);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                    begin //----------------------------------- �������� ������� �� ������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,137, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,137);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;

                    if ObjZv[o].bP[18] then
                    begin //----------------------------------- �������� ������� ���������
                      inc(MarhTrac.MsgN);
                      MarhTrac.Msg[MarhTrac.MsgN] :=
                      GetSmsg(1,159, ObjZv[hvost].Liter,1);
                      InsMsg(hvost,159);
                      result := trBreak;
                      MarhTrac.GonkaStrel := false;
                    end;
                  end else
                  begin //---------------------------------- ���� ��������� ������� � ����
                    if ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22] then
                    begin //------------------------------- ������� �������� � �� ��������
                      if ObjZv[hvost].bP[15] or ObjZv[hvost].bP[19] then
                      begin //--------------------------------- �������� ������� �� ������
                        inc(MarhTrac.MsgN);
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,137, ObjZv[hvost].Liter,1);
                        InsMsg(hvost,137);
                        result := trBreak;
                        MarhTrac.GonkaStrel := false;
                      end;

                      if ObjZv[o].bP[18] then
                      begin //--------------------------------- �������� ������� ���������
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
                      begin //--------------------------------- �������� ������� �� ������
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
              begin //--------------------- ���������� ����� ������� � ���� �� �����������
                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //- ��� ����.�����. ��� ������� � ���� ��� ��� ���������,���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[o].Liter,1);
                    InsMsg(hvost,268);
                    MarhTrac.GonkaStrel := false; exit;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if (ObjZv[s_v_put].ObCI[k+4] = 0) or
                  (ObjZv[hvost].bP[21] and ObjZv[hvost].bP[22]) then
                  begin //- ��� ����.�����. ��� ������� � ���� ��� ��� ���������,���������
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

    //----------------------- ������������ ��������� ������ �������� ---------------------
    tlZamykTrace :
    begin
      ObjZv[s_v_put].bP[21] := false;//---- ������� ����������� ��������� �����������

      if Con.Pin = 1 then
      begin
        Con := ObjZv[s_v_put].Sosed[2];

        case Con.TypeJmp of
          LnkRgn : result := trEnd;
          LnkEnd : result := trStop;
          else result := trNext;
        end;

        if ObjZv[s_v_put].ObCB[1] then //--------------------- ���� ��������� 1->2
        begin
          if Rod = MarshP then ObjZv[s_v_put].bP[20] := true //�������� �����������
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

        if ObjZv[s_v_put].ObCB[2] then //--------------------- ���� ��������� 2->1
        begin
          if Rod = MarshP then ObjZv[s_v_put].bP[20] := true //�������� �����������
          else ObjZv[s_v_put].bP[20] := false;
        end;
      end
      else  ObjZv[s_v_put].bP[20] := false; //------------ ������ ����� �����������
    end;

    tlAutoTrace,
    tlSignalCirc,
    tlPovtorRazdel,
    tlRazdelSign :
    begin
      result := trNext;
      if Con.Pin = 1 then
      begin
        if ObjZv[s_v_put].ObCB[1] then  //-------- ���� ����������� � ��������� 1->2
        begin
          if Rod = MarshP then
          begin
            ObjZv[s_v_put].bP[20] := true; //--------- ��������� �������� �����������
            ObjZv[s_v_put].bP[21] := true; //��������� ����������� ��������� ����-���
            for k := 1 to 4 do
            begin
              o := ObjZv[s_v_put].ObCI[k];
              if o > 0 then
              begin
                if not ObjZv[o].bP[1] and not ObjZv[o].bP[2] then
                begin //----------------------- ������� � ���� �� ����� �������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,81);
                end;

                if Lvl = tlRazdelSign then
                begin
                  if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                  begin //----------------------- ������� � ���� �� � �������� ���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end;
                end;


                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //������.������ ��������� ������� � ���� ��� ��������� �������� ��
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin //-------------------------------- ���������� ������ ���������
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else //------------------------------------- ���������� ��������
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,272, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //-- ������.������ ��������� ���. � ���� ��� ��������� �������� ��
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else // ���������� ��������

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
                begin //----------------------- ������� � ���� �� ����� �������� ���������
                  inc(MarhTrac.MsgN);
                  MarhTrac.Msg[MarhTrac.MsgN] :=
                  GetSmsg(1,81, ObjZv[ObjZv[o].BasOb].Liter,1);
                  InsMsg(ObjZv[o].BasOb,81);
                end;

                if Lvl = tlRazdelSign then
                begin
                  if not ObjZv[o].bP[1] and ObjZv[o].bP[2] then
                  begin //----------------------- ������� � ���� �� � �������� ���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3] and not ObjZv[o].bP[1] then
                begin //------------------------- ������� � ���� �� ����� �������� � �����
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //-- ������.������ ��������� ��� � ���� ��� ���������� �������� ��
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      //-------------------------------------- ���������� ������ ���������
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else //------------------------------------- ���������� ��������
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,272, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],272);
                      end;
                    end;
                  end;
                end;

                if ObjZv[s_v_put].ObCB[k*3+1] and not ObjZv[o].bP[2] then
                begin //------------------------ ������� � ���� �� ����� �������� � ������
                  if ObjZv[s_v_put].ObCI[k+4] = 0 then
                  begin //----------------------- ��� ������� ��������� ��� ������� � ����
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else
                  if ObjZv[ObjZv[o].BasOb].bP[21] and
                  ObjZv[ObjZv[o].BasOb].bP[22] then
                  begin //--------------------------------------- ��� ���������, ���������
                    inc(MarhTrac.MsgN);
                    MarhTrac.Msg[MarhTrac.MsgN] :=
                    GetSmsg(1,268, ObjZv[ObjZv[o].BasOb].Liter,1);
                    InsMsg(ObjZv[o].BasOb,268);
                  end else

                  if not ObjZv[ObjZv[s_v_put].UpdOb].bP[2] then
                  begin //-- ������.������ ��������� ���. � ���� ��� ��������� �������� ��
                    if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[5] then
                    begin
                      inc(MarhTrac.MsgN);
                      if ObjZv[ObjZv[s_v_put].ObCI[k+4]].bP[10] then
                      begin
                        MarhTrac.Msg[MarhTrac.MsgN] :=
                        GetSmsg(1,481, ObjZv[ObjZv[s_v_put].ObCI[k+4]].Liter,1);
                        InsMsg(ObjZv[s_v_put].ObCI[k+4],481);
                      end else // ���������� ��������
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
//------------------------ �������� ������������� ��������� ������ ��� ������� � ���� (42)
function StepTrasPrzPr(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Prz:TSos) : TTrRes;
var
  k,o : integer;
begin
  case Lvl of
    //----------------------------- � � � � �   � � � � � � ------------------------------
    tlFindTrace :
    begin
      result := trNext;
      //------------- ��� ������ ������ ��������� �������� ��������� ������ ������� � ����
      if Rod = MarshP then
      MarhTrac.VP := Prz.Obj;

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else Con := ObjZv[Prz.Obj].Sosed[1];

      case Con.TypeJmp of
        LnkRgn : result := trRepeat;
        LnkEnd : result := trRepeat;
      end;
    end;

    tlVZavTrace,   //--------- �������� ������������������ �� ������ (���������� � ������)
    tlContTrace :  //----- ������� ������ �� ��������������� ����� ��� ����������� �������
    begin
      result := trNext;

      if Rod = MarshP then MarhTrac.VP := Prz.Obj; //��������� ������ ��� ������

      if Con.Pin = 1 then Con := ObjZv[Prz.Obj].Sosed[2]
      else Con := ObjZv[Prz.Obj].Sosed[1];

      case Con.TypeJmp of
        LnkRgn : result := trEnd;
        LnkEnd : result := trStop;
      end;
    end;

    //--------------------------- � � � � � � � �   � � � � � �  -------------------------
    tlCheckTrace :
    begin
      if Rod = MarshP then
      begin
        for k := 1 to 4 do //--------------------- ������ �� 4-� ��������� �������� � ����
        begin
          o := ObjZv[Prz.Obj].ObCI[k];
          if o > 0 then
          begin //-------------------- ��������� ������� ����������� �� "-" ������� � ����
            if ObjZv[o].bP[13] then
            begin// ��������� ����������� ���� ���� ���� �� "-" ������� � ����
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
      if Rod = MarshP then ObjZv[Prz.Obj].bP[1] := true; //- ������� ��������� ������

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
      if Rod = MarshP then MarhTrac.VP:= Prz.Obj;//������� ������ ������� � ����
      result := trNext;

      if Rod = MarshP then ObjZv[Prz.Obj].bP[1] := true; //- ������� ��������� ������

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
//------------------------------------------------------------------------------- ��� (43)
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
              begin // ��������������� ����� �� ���� �� ����������� ������
                k := 2;
                o := ObjZv[OPI.Obj].Sosed[k].Obj; k := ObjZv[OPI.Obj].Sosed[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZv[o].TypeObj of
                    2 : begin // �������
                      case k of
                        2 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[11] then
                          begin // ������� ����� ��������� � ����� �� ������
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[10] then
                          begin // ������� ����� ��������� � ����� �� �����
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
                    end;
                    48 : begin // ���
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
              if tr then //---------- ��� ��������� ������� �� ������ �� ����� ����� �����
              begin
                inc(MarhTrac.MsgN);
                MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1);
                InsMsg(ObjZv[OPI.Obj].BasOb,258);
                MarhTrac.GonkaStrel := false;
              end else
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // �� � ���
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
              begin //---------------- ��������������� ����� �� ���� �� ����������� ������
                k := 1;
                o := ObjZv[OPI.Obj].Sosed[k].Obj;
                k := ObjZv[OPI.Obj].Sosed[k].Pin;
                j := 50;
                while j > 0 do
                begin
                  case ObjZv[o].TypeObj of
                    2 : begin // �������
                      case k of
                        2 : begin// ������� ����� ��������� � ����� �� ������
                          if ObjZv[ObjZv[o].BasOb].bP[11] then begin tr := false; break; end;
                        end;
                        3 : begin
                          if ObjZv[ObjZv[o].BasOb].bP[10] then
                          begin // ������� ����� ��������� � ����� �� �����
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZv[o].Sosed[1].Pin; o := ObjZv[o].Sosed[1].Obj;
                    end;
                    48 : begin // ���
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
              if tr then // ��� ��������� ������� �� ������ �� ����� ����� �����
              begin
                inc(MarhTrac.MsgN); MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,258, ObjZv[ObjZv[OPI.Obj].BasOb].Liter,1); InsMsg(ObjZv[OPI.Obj].BasOb,258); MarhTrac.GonkaStrel := false;
              end else
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // �� � ���
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
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // �� � ���
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
              if not ObjZv[ObjZv[OPI.Obj].BasOb].bP[3] and not ObjZv[OPI.Obj].bP[1] then // �� � ���
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
//------------------------------------------------------------------- ���� ���������� (45)
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
          begin //------------------------------------------- �������� ���������� ��������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,456, ObjZv[Zon.Obj].Liter,1); //-- $ ���������� �������� ��������
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
//--------------------------------------- ������ ������� (������� ����� ���� ��� ��������)
function StepTrasRazn(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Raz:TSos) : TTrRes;
begin
  if Con.Pin = 1 then Con := ObjZv[Raz.Obj].Sosed[2] else Con := ObjZv[Raz.Obj].Sosed[1];
  if (Con.TypeJmp <> LnkRgn) and (Con.TypeJmp <> LnkEnd) then result := trNext
  else
  if Lvl = tlFindTrace then result := trRepeat  //------ ��� ������ ������ ������� = �����
  else result := trEnd;
end;

//========================================================================================
//---------------------------------------------------- ��� ����� ������� ��� ������ ������
function StepStrFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
begin
  result := trNext;
  with ObjZv[Str.Obj] do
  begin
    case Con.Pin of //------------- ������������� �� ����� ����� ����� ��������� � �������
      //-------------------------------------------------------------------- ������ ������
      1 :
      begin
        if ObCB[1] then //------------ ���� ������������, �� ������������ ������ �� ������
        begin Con := Sosed[3]; BP[10] := true; BP[11] := true; end
        else //----------------------------------------------------------- ������� �������
        begin
          if OBCB[3] then //----------------------------- ���� �������� �������� �� ������
          begin
            //---------- �� ���� ������� �������, ������� ���� �� ������, ������ 1� ������
            if not BP[10] then begin Con := Sosed[3]; BP[10] := true;  BP[11] := true; end
            //------------------- ��� ������ ������� ������ �� �����, ������ ������ ������
            else begin Con := Sosed[2]; BP[11] := false; end;
          end else//-------------------------------------- ���� �������� �������� �� �����
          begin
            //--- 1� ������ ���, 2� ������ ���� �� ������ �������, ������ ��������� ������
            if BP[10] then begin Con := Sosed[3];BP[11] := true; end
            //------------------- ������� ������ �� ����� �������, ������ ��������� ������
            else begin Con := Sosed[2]; BP[10] := true; end;
          end;
        end;
      end;

      2 : begin BP[12] := true; Con := Sosed[1]; end; // �������� ������ �� ������ � �����
      3 : begin BP[13] := true; Con := Sosed[1]; end;// �������� ������ �� ������ � ������
    end;
    if(Con.TypeJmp = LnkRgn) or  (Con.TypeJmp = LnkEnd) then result := trRepeat
    else result := trNext;
  end;
end;

//========================================================================================
//---------------------------------------------- ������ ����� ������� ��� ��������� ������
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
      1 ://----------------------------------------------- ��������������� ���� �� �������
      begin
        if MarhTrac.VP >0 then //----------------- ���� �� ��� ����������� �������� ������
        begin //------------------------------------------ ������ �� ������ ������� � ����
          //- �������� ��������� ������� � ����, ���� ��� ���  � ����� �� �������� ������
          for k := 1 to 4 do //-------------------------- ����� ���� �� 4-� ������� � ����
          //---------- ���� ��� ������a ������� � ������� ��, � ���� ������� ������ ������
          if(ObjZv[MarhTrac.VP].ObCI[k] = Str.obj) and ObjZv[MarhTrac.VP].ObCB[k+1] then
          begin //------------------------------------------ ������������ ������� �� �����
            Con := Sosed[2]; //------------------------------- �������� ��������� �� �����
            bP[10] := true; bP[11] := false; //-- ���������� 1-�� ������ ����� 2-�� ������
            bP[12] := false; bP[13] := false;//------- ����� ���������� � ����� � � ������
            result := trNext;
            p := true;
            break;
          end;

          if not p then
          begin //--------------------- ������� �� ������� � ������� ������ ������� � ����
            con := Sosed[1]; //-------------------------------- ��������� �� ������� �����
            result := trBreak; //------------------------------------- �������� �� �������
          end;
        end else //---------------------------------------------------- ��� ������� � ����
        if ObCB[1] then //-------------------------------------- ���� ������������ �������
        begin //---------------- ������������ ������� ������ ������������ ������ �� ������
          Con := Sosed[3]; //---------------------------------- ����� ��������� �� �������
          bP[10] := true; bP[11] := true; //--------- ����� 1�� � 2�� ������� �����������
          bP[12] := false; bP[13] := false; //---------- ���������� �� � �����,�� � ������
          result := trNext;
        end else
        begin //---------------------------------------- ��� ������� � ���� � ������������
          con := Sosed[1];result := trBreak; //��������� ����� ������, �������� �� �������
        end;
      end;

      2 :
      begin //-------------------------------- ���������� ������ �� ������� �� ������� "+"
        bP[12] := true; Con := Sosed[1];//- ������ ������ �� ������ � �����,������� �� ���
        case Con.TypeJmp of  //------------------------------------------- ���� ����������
          LnkRgn : result := trStop; //------------------------- �������� ��������� ������
          LnkEnd : result := trStop; //------------------------- �������� ��������� ������
          else result := trNext;
        end;
      end;

      3 :
      begin //------------------------------------------- ���������� ������ �� ������� "-"
        bP[13] := true; Con := Sosed[1];// ������ ������ �� ������ � ������,������� �� ���
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
//----------------------------------------- ������ ����� ������� ��� �������� ������������
function StepStrZavTras(var Con:TSos; const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  k : integer;
begin
  result := trNext;
  with ObjZv[Str.Obj] do
    begin
    case Con.Pin of
      1 :
      begin //-----------------------------��������������� ����, ��������� �� ������ �������
        if MarhTrac.VP > 0 then //------------- ���� ���� ������� � ���� � �������� ��������
        begin
          for k := 1 to 4 do //-------------- ��������� ����������� ������� � ���� �� ������
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
//------------------------ ��� ����� ������� ��� �������� ������������� �� ������ ��������
function StepStrChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
var
  zak : boolean;
  o,Xst : integer;
begin
  result := trNext;

  with ObjZv[Str.Obj] do
  begin
    Xst := BasOb;
    //---------------- ������� ��������� ��������� �������� ����������� �� �������� � ����
    if not CheckOtpravlVP(Str.Obj) then result := trBreak;

    //---------------------------------- ������ ��������� ���������� ���� ����� �� �������
    if not CheckOgrad(Str.Obj) then result := trBreak;

  if ObCB[6] then zak:=ObjZv[Xst].bP[17]//�������� �������
  else zak := ObjZv[Xst].bP[16]; //------- ����� ������� �������� �������

  if bP[16] or zak then //---------------- ���� �� ������� ������� ��������
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,119, Liter,1);
    InsMsg(Str.Obj,119);  //------------------------- "������� $ ������� ��� ��������"
    MarhTrac.GonkaStrel := false;
  end;

  case Con.Pin of
    1 : //-------------------------------------------------- ���� �� ������� ����� ����� 1
    begin
      if not ObCB[11] then
      begin //-------------------------- ������� �� ������������ ��� ������� �� ����������
        //----------------------------------------------------------- ���� ������� �������
        if ObCB[6] then zak := ObjZv[Xst].bP[34]
        else zak := ObjZv[Xst].bP[33];

        if bP[17] or zak then
        begin //---------------------------- ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,453, Liter,1);
          InsMsg(Str.Obj,453);//---- ������� $ ������� ��� ���������������� ��������
          MarhTrac.GonkaStrel := false;
        end;
      end;
       //�� ������ ������� ��������, 1�� ������ �����������, �� 2� ������ ����������� ���
      if(not MarhTrac.Povtor and (bP[10] and not bP[11])) or
      // ������ ������� ��������, ���� �� � ��� �� (���. ���� � +)
      (MarhTrac.Povtor and (ObjZv[Xst].bP[6] and not ObjZv[Xst].bP[7]))
      then
      begin
        if not NegStrelki(Str.Obj,true)
        then result := trBreak;//------------------------------------------ ��������������

        if bP[1] then //--------------------------------- ���� ���� ��
        begin
          if ObjZv[Xst].bP[19] then //--------- ���� �� ������
          begin //------------------------------ ������� �� ������ - ������ ��������������
            if ObjZv[Xst].bP[27] then //---- ���� �����. ����.
            begin //---------------------- ��������� �������������� ��� ���������� �������
              if ObjZv[Xst].iP[3]=Str.Obj then //�� ������
              begin
                result := trBreak;
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120, ObjZv[Xst].Liter,1);
                InsWar(Str.Obj,120); //------------------------- ������� $ �� ������
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
              InsWar(BasOb,120);//--------- ������� $ �� ������
            end;
          end;
        end else
        begin
          if not MarhTrac.Povtor and not MarhTrac.Dobor then
          inc(MarhTrac.GonkaList);//-- ��������� ���� ����������� ������� ������
          if ObjZv[Xst].bP[19] then
          begin //--------------------------------------= ������� �� ������ - ������������
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,136, ObjZv[Xst].Liter,1);

            InsMsg(BasOb,136);
            //������� $ �� ������. ����� ���������� �������� ������ ���� ���������� � ����

            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Xst].bP[21] then //--------------------------------��������� ������
          begin
            o := GetStateSP(1,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[o].Liter,1);
            InsMsg(o,82); //-------------------------------------------  ������� $ �������
            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Xst].ObCB[3] and//���� ���� ��������� ��� �
          not ObjZv[Xst].bP[20] then //..... ���� �������� ���
          begin
            InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
            ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,392, Liter,1);
            InsMsg(Str.Obj,392);// ���� �������� ������� ��������. ��������� �������
            MarhTrac.GonkaStrel := false;
          end;



          if ObjZv[Xst].bP[4] then //------ ��������� � ������
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,80, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,80); //------------ ������� $ ��������
            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Xst].bP[22] then //------ ������� �� ��
          begin
            o := GetStateSP(2,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[o].Liter,1);
            InsMsg(o,83); //---------------------------------------- ������� $ �����
            MarhTrac.GonkaStrel := false;
          end;

          if bP[18] then
          begin //---------------------------------------- ������� ��������� �� ����������
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,121, ObjZv[Xst].Liter,1);

            //-------------------- ������� $ ��������� �� ���������� (� �������� �� �����)
            InsMsg(BasOb,121);

            MarhTrac.GonkaStrel := false;
          end;

          if MarhTrac.Povtor then
          begin //---------------------------------- �������� ��������� ��������� ��������
            if not bP[2] then //------------------------------- ��� ��
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,81, ObjZv[Xst].Liter,1);
              InsMsg(BasOb,81); //------ ������� $ ��� ��������
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- �������� ��������� ����������� ��������
            if not bP[2] and  //----------------------------- ��� �� �
            not ObjZv[Xst].bP[6] then  //-------------- ��� ��
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,81, ObjZv[Xst].Liter,1);
              InsMsg(BasOb,81); //------ ������� $ ��� ��������
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
      end else //-------------------------------------------------- ������� �� ���� � ����
      if (not MarhTrac.Povtor and //------------------- �� ������ �������� � ...
      (bP[10] and //------------------------------ ������ ������ � ...
      bP[11])) or //---------------------------- ������ ������ ��� ...
      (MarhTrac.Povtor and  //------------------------------------- ������ � ...
      (not ObjZv[Xst].bP[6] and  //-------------- ��� �� � ...
      ObjZv[Xst].bP[7])) then //---------------------- ���� ��
      begin
        if  not NegStrelki(Str.Obj,false) then result := trBreak; //------ ���������

        if bP[2] then //-------------------------------------- ���� ��
        begin
          if ObjZv[Xst].bP[19] then //----- ���� ���.�� ������
          begin //------------------------------ ������� �� ������ - ������ ��������������
            if ObjZv[Xst].bP[27] then  //-------- �������� ���
            begin //---------------------- ��������� �������������� ��� ���������� �������
              if ObjZv[Xst].iP[3] = Str.Obj then //--- ��� ���
              begin
                result := trBreak;
                inc(MarhTrac.WarN);
                MarhTrac.War[MarhTrac.WarN] :=
                GetSmsg(1,120, ObjZv[Xst].Liter,1);
                InsWar(BasOb,120); //------ ������� $ �� ������
              end;
            end else //---------------------------------------------- �� ���� �������� ���
            begin
              if not MarhTrac.Dobor then  //------------------- �� ����� "�����"
              begin
                ObjZv[Xst].iP[3] := Str.Obj;  //----- ���������
                ObjZv[Xst].bP[27] := true; //-----  ���� �����
              end;
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,120, ObjZv[Xst].Liter,1);
              InsWar(BasOb,120);
            end;
          end;
        end else //---------------------------------------------------------------- ��� ��
        begin
          if not MarhTrac.Povtor and //--------------- �� ������� �������� � ...
          not MarhTrac.Dobor //-------------------------------------- �� "�����"
          then inc(MarhTrac.GonkaList);//--- ��������� ����� ����������� �������

          if ObjZv[Xst].bP[19] then
          begin //--------------------------------------- ������� �� ������ - ������������
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,137, ObjZv[Xst].Liter,1);

            InsMsg(BasOb,137);
            //������� $ �� ������.����� ���������� �������� ������ ���� ���������� � �����

            MarhTrac.GonkaStrel := false;
          end;

          if ObjZv[Xst].ObCB[3] and//���� ���� ��������� ��� �
          not ObjZv[Xst].bP[20] then //..... ���� �������� ���
          begin
            InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
            ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,392, Liter,1);
            InsMsg(Str.Obj,392);// ���� �������� ������� ��������. ��������� �������
            MarhTrac.GonkaStrel := false;
          end;

          if not ObjZv[Xst].bP[21] then //---- ��������� �� ��
          begin
            o := GetStateSP(1,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[o].Liter,1);
            InsMsg(o,82);//--------------------------------------------- ������� $ �������
            MarhTrac.GonkaStrel := false;
          end else
          if ObjZv[Xst].bP[4] or bP[4] then
          begin //---------------------------------------------------- ��������. ���������
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,80, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,80); //------------ ������� $ ��������
            MarhTrac.GonkaStrel := false;
          end else
          if not ObjZv[Xst].bP[22] then //------- ��������� ��
          begin
            o := GetStateSP(2,Str.Obj);
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, ObjZv[o].Liter,1);
            InsMsg(o,83); //---------------------------------------- ������� $ �����
            MarhTrac.GonkaStrel := false;
          end else
          if bP[18] then
          begin //---------------------------------------- ������� ��������� �� ����������
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,159, ObjZv[Xst].Liter,1);

            InsMsg(BasOb,159);
            //------------------- ������� $ ��������� �� ���������� (� �������� �� ������)

            MarhTrac.GonkaStrel := false;
          end;

          if MarhTrac.Povtor then
          begin //---------------------------------- �������� ��������� ��������� ��������
            if not bP[1] then //------------------------------- ��� ��
            begin
              result := trBreak;
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,81, ObjZv[Xst].Liter,1);
              InsMsg(BasOb,81); //------ ������� $ ��� ��������
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin //-------------------------------- �������� ��������� ����������� ��������
            if not bP[1] and  //------------------------------- ��� ��
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

        if ObjZv[Xst].bP[6] then //------------------- ���� ��
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);  //------------- ������� $ ��������
          MarhTrac.GonkaStrel := false;
        end;

        con := Sosed[3]; //------------ ����� �� ������� �� ����������
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

    2 : //------------------------------------------------ ���� ����� ������ ����� �������
    begin
      if  not NegStrelki(Str.Obj,true) then result := trBreak; //--------- ���������

      if bP[1] then //----------------------------------- ���� ���� ��
      begin
        if ObjZv[Xst].bP[19] then
        begin //-------------------------------- ������� �� ������ - ������ ��������������
          if ObjZv[Xst].bP[27] then
          begin //------------------------ ��������� �������������� ��� ���������� �������
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
        then inc(MarhTrac.GonkaList); //---- ��������� ����� ����������� �������

        if ObjZv[Xst].bP[19] then
        begin //----------------------------------------- ������� �� ������ - ������������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,136, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,136);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[21] then  //--------------------------------- ��������� �� ��
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

        if ObjZv[Xst].ObCB[3] and//���� ���� ��������� ��� �
        not ObjZv[Xst].bP[20] then //..... ���� �������� ���
        begin
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,392, Liter,1);
          InsMsg(Str.Obj,392);//-- ���� �������� ������� ��������. ��������� �������
          MarhTrac.GonkaStrel := false;
        end;

        if ObjZv[Xst].bP[4] then  //----------- ���. ���������
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[22] then  //-------- ��������� ��
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
        begin //------------------------------------------ ������� ��������� �� ����������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,121, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,121);
          MarhTrac.GonkaStrel := false;
        end;

        if MarhTrac.Povtor then
        begin //------------------------------------ �������� ��������� ��������� ��������
          if not bP[2] then //--------------------------------- ��� ��
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,81, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,81);
            MarhTrac.GonkaStrel := false;
          end;
        end else
        begin //---------------------------------- �������� ��������� ����������� ��������
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

      if (not MarhTrac.Povtor and bP[12]) or//�� ������ � ������������� ����������� ���...
      (MarhTrac.Povtor and //-------------------------------------- ������ � ...
      ObjZv[Xst].bP[6] and not ObjZv[Xst].bP[7]) then  //�� � ��� ��
      begin
        if ObjZv[Xst].bP[7] then //------------------------------------------------ ��� ��
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80); //----------------------------------------- ������� $ ��������
          MarhTrac.GonkaStrel := false;
        end else
        if not bP[1] and not bP[2] and not ObjZv[Xst].bP[6] then//���� ��� ��, �� � ��� ��
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=  GetSmsg(1,81, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,81);//-------------------------------------- ������� $ ��� ��������
          MarhTrac.GonkaStrel := false;
        end;

        con := Sosed[1]; //------------------------------------ ����� ����� ���� (����� 1)

        if result = trBreak then exit;

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
      end
      else result := trStop;
    end;

    3 : //----------------------------------------------- ���� �� ������� ����� ����������
    begin
      if ObCB[11] then//------------------------ ������� ������������ � ������� ����������
      begin
        if ObCB[6] //----------------------------------------------------- ������� �������
        //----------------------- ����� ����� �������� �� FR4 ������� ��� ����������������
        then zak := ObjZv[Xst].bP[33]
        //----------------------- ����� ����� �������� �� FR4 ������� ��� ����������������
        else zak := ObjZv[Xst].bP[34];

        if bP[17] or zak then
        begin //---------------------------- ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] := GetSmsg(1,453, Liter,1);
          InsMsg(Str.Obj,453);//------------- ������� $ ������� ��� ���������������� ����.
          MarhTrac.GonkaStrel := false;
        end;
      end;

      if  not NegStrelki(Str.Obj,false)  then result := trBreak; //-------- ��������������

      if bP[2] then //------------------------------------------------------- ���� ���� ��
      begin
        if ObjZv[Xst].bP[19] then
        begin //-------------------------------- ������� �� ������ - ������ ��������������
          if ObjZv[Xst].bP[27] then
          begin //------------------------ ��������� �������������� ��� ���������� �������
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
            InsWar(BasOb,120);//----------- ������� $ �� ������
          end;
        end;
      end else //------------------------------------------------------------- ���� ��� ��
      begin
        if not MarhTrac.Povtor and not MarhTrac.Dobor
        then inc(MarhTrac.GonkaList);//------��������� ����� ����������� �������

        if ObjZv[Xst].bP[19] then
        begin //----------------------------------------- ������� �� ������ - ������������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,137, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,137);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[21] then //------------------------------------- ��������� ��
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

        if ObjZv[Xst].ObCB[3] and//���� ���� ��������� ��� �
        not ObjZv[Xst].bP[20] then //..... ���� �������� ���
        begin
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,392, Liter,1);
          InsMsg(Str.Obj,392); //- ���� �������� ������� ��������. ��������� �������
          MarhTrac.GonkaStrel := false;
        end;

        if ObjZv[Xst].bP[4] or  bP[4] then
        begin  //---------------------------------------------------------- ���. ���������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);
          MarhTrac.GonkaStrel := false;
        end;

        if not ObjZv[Xst].bP[22] then //--------- ��������� ��
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

        if bP[18] then //------------- ������� ��������� �� ����������
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,159, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,159);
          MarhTrac.GonkaStrel := false;
        end;

        if MarhTrac.Povtor then //-------- �������� ��������� ��������� ��������
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
        begin //---------------------------------- �������� ��������� ����������� ��������
          if not bP[1] and //---------------------------- ��� �� � ...
          not ObjZv[Xst].bP[7] then //----------------- ��� ��
          begin
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,81, ObjZv[Xst].Liter,1);
            InsMsg(BasOb,81); //-------- ������� $ ��� ��������
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;

      if (not MarhTrac.Povtor and //------------------- �� ������ �������� � ...
      bP[13]) or //------------ ���������� � �������� � ������ ��� ...

      (MarhTrac.Povtor and //----------------------------- ������ �������� � ...
      not ObjZv[Xst].bP[6] and //------- ��� �� � ������ � ...
      ObjZv[Xst].bP[7]) then  //------------- ���� �� � ������
      begin
        if ObjZv[Xst].bP[6] then //---------- ���� � ������ ��
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,80, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,80);
          MarhTrac.GonkaStrel := false;
        end else  //------------------------------------------------- ���� � ������ ��� ��
        if not bP[1] and  //----------------------------- ��� �� � ...
        not bP[2] and  //-------------------------------- ��� �� � ...
        not ObjZv[Xst].bP[6] then //---------- ��� �� � ������
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,81, ObjZv[Xst].Liter,1);
          InsMsg(BasOb,81); //------------ ������� ��� ��������
          MarhTrac.GonkaStrel := false;
        end;

        con := Sosed[1]; //------------ ������� �� ������� ����� ��� 1

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
//--------------------------------������ ����� ������� �� ����� ��������� ��������� ������
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
      begin //--------------------------------------------------------- ��� ��������� � ��
        if ObjZv[Str.Obj].bP[10] then
        begin
          if ObjZv[Str.Obj].bP[11] then
          begin //-------------------------------------------------- ����������� �� ������
            mk := true;
            p := false;
          end else
          begin //--------------------------------------------------- ����������� �� �����
            p := true;
            mk := false;
          end;
        end;
      end else //--------------------------------------------------- ���� ��������� ��� ��
      begin
        if ObjZv[Str.Obj].bP[1] and not ObjZv[Str.Obj].bP[2] then
        begin //--------------------------------------------------- ���� �������� �� �����
          p := true;
          mk := false;
        end else
        if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then
        begin //-------------------------------------------------- ���� �������� �� ������
          mk := true;
          p := false;
        end;
      end;

      if p and //--------------------------------------------------------- ���� ���� � ...
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[7] then //--------------------- ��� ��
      begin
        con := ObjZv[Str.Obj].Sosed[2]; //------------------ ������� �� ������� �����

        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;

        if result = trNext then
        begin
          if not ObjZv[Str.Obj].ObCB[1] then //--------------------- �� ������������
          begin
            inc(MarhTrac.StrCount);
            MarhTrac.StrOtkl[MarhTrac.StrCount] := Str.Obj;
            MarhTrac.PolTras[MarhTrac.StrCount,1] := true;
            MarhTrac.PolTras[MarhTrac.StrCount,2] := false;
          end;
          ObjZv[Str.Obj].bP[6] := true;   //-------------------------------------- ��
          ObjZv[Str.Obj].bP[7] := false;  //-------------------------------------- ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := true;   //------------------- ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false;  //------------------- ��
          ObjZv[Str.Obj].bP[10] := false; //---------------- �� 1-�� ������ �� ������
          ObjZv[Str.Obj].bP[11] := false; //---------------- �� 2-�� ������ �� ������
          ObjZv[Str.Obj].bP[12] := false; //--------- ��������� �� � ����� ��  ������
          ObjZv[Str.Obj].bP[13] := false; //-------- ���������� �� � ������ �� ������
          ObjZv[Str.Obj].bP[14] := true;  //------------------------- ����. ���������

          ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true;//-------- ����. ���������
          ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart;//-------- ����� ������
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
          ObjZv[Str.Obj].bP[6] := false;  //-------------------------------------- ��
          ObjZv[Str.Obj].bP[7] := true;   //-------------------------------------- ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //-------------------- ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := true;  //-------------------- ��

          ObjZv[Str.Obj].bP[10] := false; //-------------- �� ������ ������ �� ������
          ObjZv[Str.Obj].bP[11] := false; //-------------- �� ������ ������ �� ������
          ObjZv[Str.Obj].bP[12] := false; //----------- ����� ���������� ������������
          ObjZv[Str.Obj].bP[13] := false; //--------------- ����� ���������� � ������
          ObjZv[Str.Obj].bP[14] := true;  //------------------ ������ ����. ���������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true;  //------ ����. ���������
          ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart; //------������� ������
        end;
        exit;
      end
      else result := trStop;
    end;

    2 :   //------------------------------------------------------ ���� ����� ������ �����
    begin
      if ObjZv[ObjZv[Str.Obj].UpdOb].bP[2] and  //------- �� �� ������� � ...
      not ObjZv[ObjZv[Str.Obj].UpdOb].bP[9] then  //------------------ ��� ��
      begin
        if ObjZv[Str.Obj].bP[12] //-------------- ��� ���������� ����������� �� �����
        then result := trNext; //----------------------------------------- ���� ������
      end
      else //------------------------------------------------------- ���� ��������� ��� ��
      if ObjZv[Str.Obj].bP[1] and //----------------------------------- ���� �� � ...
      not ObjZv[Str.Obj].bP[2] //--------------------------------------------- ��� ��
      then result := trNext;  //------------------------------------------ ���� ������

      if result = trNext then //------------------------------------- ���� ���� ������
      begin
        con := ObjZv[Str.Obj].Sosed[1]; //---------------- ����� ����� ���� (����� 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZv[Str.Obj].bP[6] := true;   //------------------------------ ����� ��
            ObjZv[Str.Obj].bP[7] := false;  //--------------------------- �� ����� ��
            ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := true;  //------------------ ��
            ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //------------------ ��
            ObjZv[Str.Obj].bP[10] := false; //------------ �� ������ ������ �� ������
            ObjZv[Str.Obj].bP[11] := false; //------------ �� ������ ������ �� ������
            ObjZv[Str.Obj].bP[12] := false; //------- ��� ���������� � ����� � ������
            ObjZv[Str.Obj].bP[13] := false; //------ ��� ���������� � ������ � ������
            ObjZv[Str.Obj].bP[14] := true;  //----------------------- ����. ���������
            ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true; //----- ����. ���������
            ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart; //--- ������� ������
        end;
      end;
    end;

    3 : //----------------------------------------------------- ���� �� ������� ����������
    begin
      if ObjZv[ObjZv[Str.Obj].UpdOb].bP[2] and //------��� ��������� �� � ...
      not ObjZv[ObjZv[Str.Obj].UpdOb].bP[9] then //------------------- ��� ��
      begin
        if ObjZv[Str.Obj].bP[13] then  //------------------ ���������� ����� � ������
        result := trNext; //---------------------------------------------- ���� ������
      end
      else //------------------------------------------------------- ���� ��������� ��� ��
      if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then//��� ��, ���� ��
      result := trNext;  //--------------------------- ������� �� ������ - ���� ������

      if result = trNext then
      begin
        con := ObjZv[Str.Obj].Sosed[1]; //---------------- ����� ����� ���� (����� 1)
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else
            ObjZv[Str.Obj].bP[6] := false; //---------------------------- �� ����� ��
            ObjZv[Str.Obj].bP[7] := true;  //------------------------------- �� �����
            ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //------------------ ��
            ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := true;  //------------------ ��
            ObjZv[Str.Obj].bP[10] := false; //------------ �� ������ ������ �� ������
            ObjZv[Str.Obj].bP[11] := false; //------------ �� ������ ������ �� ������
            ObjZv[Str.Obj].bP[12] := false; //------- ��� ���������� � ����� � ������
            ObjZv[Str.Obj].bP[13] := false; //------ ��� ���������� � ������ � ������
            ObjZv[Str.Obj].bP[14] := true;  //----------------------- ����. ���������
            ObjZv[ObjZv[Str.Obj].BasOb].bP[14] := true;//------ ����. ���������
            ObjZv[Str.Obj].iP[1] := MarhTrac.ObjStart;
        end;
      end;
    end;
  end;
end;

//========================================================================================
function StepStrCirc(var Con:TSos;  const Lvl:TTrLev;Rod:Byte;Str:TSos) : TTrRes;
//------------------------------------- ��� ����� ������� ��� �������� "���������� ������"
var
  k : integer;
  zak : boolean;
begin
  result := trNext;
  //------------------ ��������� ��������� �������� ����������� �� �������� � ����
  if not SignCircOtpravlVP(Str.Obj) then result := trStop;
  //----------------------------------- ��������� ���������� ���� ����� �� �������

  if not SignCircOgrad(Str.Obj) then result := trStop; //--- ���������� ����

  if ObjZv[Str.Obj].ObCB[6]
  then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[16]
  else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[17];

  if ObjZv[Str.Obj].bP[16] or zak then
  begin //------------------------------------------- ������� ������� ��� ��������
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1); InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin //------------------------------------------------- ��� �������� ���������
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; //---------------------------------------- ��������������

  case Con.Pin of
    1 :
    begin
      //------- ��������� ����������� �� ������ ������� � ���� � �������� ��������
      if MarhTrac.VP > 0 then
      begin //----------------------------------------- ���� ������ ������� � ����
        for k := 1 to 4 do
        if (ObjZv[MarhTrac.VP].ObCI[k] = Str.Obj) and // ������ ������� � ����
        ObjZv[MarhTrac.VP].ObCB[k+1] then          // ������� ������ ������ �� �����
        begin // ��������� ����������� ������� �� ������
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
      begin //-------------------- ������� �� ������������ ��� ������� �� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin //---------------------- ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin //-------------------------- ������� �� ������ - ������ ��������������
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsWar(ObjZv[Str.Obj].BasOb,120);
      end;

      //---------------------------------------------- ����������� ������� � �����
      if ObjZv[Str.Obj].bP[1] then con := ObjZv[Str.Obj].Sosed[2]
      else //------------------------------------------ ����������� ������� � ������
      if ObjZv[Str.Obj].bP[2] then con := ObjZv[Str.Obj].Sosed[3]
      else result := trStop; //------------------------------ ��� �������� ���������

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
      begin //------------------------------------------ ����������� ������� � �����
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin //-------------------------- ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin //----------------------------------------- ����������� ������� � ������
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);//---- ������� $ �� �� ��������
      end
      else result := trStop; //------------------------------ ��� �������� ���������
      Con := ObjZv[Str.Obj].Sosed[1];

      if result <> trStop then
      case Con.TypeJmp of
        LnkRgn : result := trStop;
        LnkEnd :
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,242, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,242); //��� ��������� �� + ������� $
          result := trStop;
        end;
      end;
    end;

    3 :
    begin
      if ObjZv[Str.Obj].ObCB[11] then
      begin //------------------------------ ������� ������������ � ������� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin //------------------------ ������� ������� ��� ���������������� ��������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453); //������� $ ������� ��� ���������������� ��������
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin //-------------------------------------------- ����������� ������� � �����
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160); //----- ������� $ �� �� ��������
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin //------------------------------------------- ����������� ������� � ������
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin //---------------------------- ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else result := trStop; //-------------------------------- ��� �������� ���������

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
//---------------------------------- ������ ����� ������� ��� �������� ��� ������ ��������
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
      begin //--------------------------------------------------------- ��� ��������� � ��
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
            ObjZv[Str.Obj].bP[6] := false; //------------------------------------------ ��
            ObjZv[Str.Obj].bP[7] := false; //------------------------------------------ ��
            o := 0;

            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0)
            and (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj) then
            o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj) then
            o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- ���������� ������� ����� ��� ��������� �������
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ ��
            end else
            begin //---------------------------------- �������� ����� ������� � ������� ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- ��
            end;

            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[11] := false;
            ObjZv[Str.Obj].bP[12] := false;
            ObjZv[Str.Obj].bP[13] := false;
            ObjZv[Str.Obj].bP[14] := false; //---------------------- ����������� ���������
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
            ObjZv[Str.Obj].bP[6] := false; //------------------------------------------ ��
            ObjZv[Str.Obj].bP[7] := false; //------------------------------------------ ��
            o := 0;

            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
            then o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- ���������� ������� ����� ��� ��������� �������
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ ��
            end else
            begin //---------------------------------- �������� ����� ������� � ������� ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- ��
            end;
            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[11] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[12] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[13] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[14] := false; //---------------------------- ����. ���������
            SetPrgZamykFromXStrelka(Str.Obj);
            ObjZv[Str.Obj].iP[1]  := 0;
          end;
          exit;
        end
        else result := trStop;
      end else
      begin //------------- ���� ��������� ��� �� - ������ �� ���������� ��������� �������
        if ObjZv[Str.Obj].bP[1] and not ObjZv[Str.Obj].bP[2] then
        begin //-------------------------------------------------  ������ �� ����� �������
          con := ObjZv[Str.Obj].Sosed[2];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else result := trNext;
          end;

          if result = trNext then
          begin
            ObjZv[Str.Obj].bP[6] := false; // ��
            ObjZv[Str.Obj].bP[7] := false; // ��
            o := 0;
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- ���������� ������� ����� ��� ��������� �������
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ ��
            end else
            begin //---------------------------------- �������� ����� ������� � ������� ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- ��
            end;
            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[11] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[12] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[13] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[14] := false; //---------------------------- ����. ���������
            SetPrgZamykFromXStrelka(Str.Obj);
            ObjZv[Str.Obj].iP[1]  := 0;
          end;
          exit;
        end else
        if not ObjZv[Str.Obj].bP[1] and ObjZv[Str.Obj].bP[2] then
        begin //------------------------------------------------- ������ �� ������ �������
          con := ObjZv[Str.Obj].Sosed[3];
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
            else  result := trNext;
          end;

          if result = trNext then
          begin
            ObjZv[Str.Obj].bP[6] := false; //------------------------------------------ ��
            ObjZv[Str.Obj].bP[7] := false; //------------------------------------------ ��
            o := 0;

            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
            else
            if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
            (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
            then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

            if (o > 0) then
            begin //----------------------- ���������� ������� ����� ��� ��������� �������
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //------------------ ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //------------------ ��
            end else
            begin //---------------------------------- �������� ����� ������� � ������� ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //--------------------------- ��
              ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //--------------------------- ��
            end;
            ObjZv[Str.Obj].bP[10] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[11] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[12] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[13] := false; //------------------------------------- ������
            ObjZv[Str.Obj].bP[14] := false; //---------------------------- ����. ���������
            SetPrgZamykFromXStrelka(Str.Obj);
            ObjZv[Str.Obj].iP[1]  := 0;
          end;
          exit;
        end
        else result := trStop; //-- ������� �� ����� �������� ��������� - ������ �� ������
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
        ObjZv[Str.Obj].bP[6] := false; //---------------------------------------------- ��
        ObjZv[Str.Obj].bP[7] := false; //---------------------------------------------- ��
        o := 0;

        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
        then o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
        else
        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
        then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

        if (o > 0) then
        begin //--------------------------- ���������� ������� ����� ��� ��������� �������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; // ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; // ��
        end else
        begin //-------------------------------------- �������� ����� ������� � ������� ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //------------------------------- ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //------------------------------- ��
        end;

        ObjZv[Str.Obj].bP[10] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[11] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[12] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[13] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[14] := false; //-------------------------------- ����. ���������
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
        ObjZv[Str.Obj].bP[6] := false; //---------------------------------------------- ��
        ObjZv[Str.Obj].bP[7] := false; //---------------------------------------------- ��
        o := 0;
        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8] <> Str.Obj)
        then  o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[8]
        else
        if (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] > 0) and
        (ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9] <> Str.Obj)
        then o := ObjZv[ObjZv[Str.Obj].BasOb].ObCI[9];

        if (o > 0) then
        begin //--------------------------- ���������� ������� ����� ��� ��������� �������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := ObjZv[o].bP[6]; //---------------------- ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := ObjZv[o].bP[7]; //---------------------- ��
        end else
        begin //-------------------------------------- �������� ����� ������� � ������� ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[6] := false; //------------------------------- ��
          ObjZv[ObjZv[Str.Obj].BasOb].bP[7] := false; //------------------------------- ��
        end;

        ObjZv[Str.Obj].bP[10] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[11] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[12] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[13] := false; //----------------------------------------- ������
        ObjZv[Str.Obj].bP[14] := false; //-------------------------------- ����. ���������
        SetPrgZamykFromXStrelka(Str.Obj);
        ObjZv[Str.Obj].iP[1]  := 0;
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------- ������ ����� ������� ��� ���������� �������� �������
function StepStrRazdel(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  zak : boolean;
  k : integer;
begin
  result := trNext;
  // ��������� ��������� �������� ����������� �� �������� � ����
  if not SignCircOtpravlVP(Str.Obj) then result := trStop;

  // ��������� ���������� ���� ����� �� �������
  if not SignCircOgrad(Str.Obj) then result := trStop; // ���������� ����

  if ObjZv[Str.Obj].ObCB[6] then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[16]
  else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[17];

  if ObjZv[Str.Obj].bP[16] or zak then
  begin // ������� ������� ��� ��������
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1);
    InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // ��� �������� ���������
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; // ��������������

  case Con.Pin of
    1 :
    begin
      // ��������� ����������� �� ������ ������� � ���� � �������� ��������
      if MarhTrac.VP > 0 then
      begin // ���� ������ ������� � ����
        for k := 1 to 4 do
        if (ObjZv[MarhTrac.VP].ObCI[k] = Str.Obj) and // ������ ������� � ����
        ObjZv[MarhTrac.VP].ObCB[k+1] then          // ������� ������ ������ �� �����
        begin // ��������� ����������� ������� �� ������
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
      begin // ������� �� ������������ ��� ������� �� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin // ������� �� ������ - ������ ��������������
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsWar(ObjZv[Str.Obj].BasOb,120);
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // ����������� ������� � �����
        ObjZv[Str.Obj].bP[10] := true;
        ObjZv[Str.Obj].bP[11] := false;// +
        con := ObjZv[Str.Obj].Sosed[2];
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // ����������� ������� � ������
        ObjZv[Str.Obj].bP[10] := true;
        ObjZv[Str.Obj].bP[11] := true; // -
        con := ObjZv[Str.Obj].Sosed[3];
      end
      else  result := trStop; // ��� �������� ���������

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
      begin // ������� � �����
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // ������� � ������
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end
      else  result := trStop; // ��� �������� ���������

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
      begin // ������� ������������ � ������� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // ������� � �����
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // ������� � ������
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else result := trStop;// ��� �������� ���������

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
//------------------------------ ������ ����� ������� ��� �������� ������� �� ������������
function StepStrAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Str:TSos) : TTrRes;
var
  zak : boolean;
begin
  result := trNext;
  //-------------------------- ��������� ��������� �������� ����������� �� �������� � ����
  if not SignCircOtpravlVP(Str.Obj) then result := trStop;

  // ��������� ���������� ���� ����� �� �������
  if not SignCircOgrad(Str.Obj) then result := trStop; // ���������� ����

  if ObjZv[Str.Obj].ObCB[6]
  then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[16]
  else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[17];

  if ObjZv[Str.Obj].bP[16] or zak then
  begin //--------------------------------------------------- ������� ������� ��� ��������
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1);
    InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin //--------------------------------------------------------- ��� �������� ���������
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; //------------------------------------------------ ��������������

  case Con.Pin of
    1 :
    begin
      if not ObjZv[Str.Obj].ObCB[11] then
      begin //-------------------------- ������� �� ������������ ��� ������� �� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin //---------------------------- ������� ������� ��� ���������������� ��������
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin //---------------------------------- ������� �� ������ - ������ ��������������
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,120);
      end;

      if ObjZv[Str.Obj].bP[1]
      then con := ObjZv[Str.Obj].Sosed[2]  //------------ ����������� ������� � �����
      else
      if ObjZv[Str.Obj].bP[2]
      then  con := ObjZv[Str.Obj].Sosed[3]//------------ ����������� ������� � ������
      else result := trStop; //------------------------------------ ��� �������� ���������

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
      begin // ����������� ������� � �����
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // ����������� ������� � ������
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end
      else result := trStop; // ��� �������� ���������

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
      begin // ������� ������������ � ������� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // ����������� ������� � �����
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // ����������� ������� � ������
        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else  result := trStop;// ��� �������� ���������

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
//---------- ������ ����� ������� ��� �������� ��� ���������� �������� � ���������� ������
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
  begin // ������� ������� ��� ��������
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,119, ObjZv[Str.Obj].Liter,1);
    InsMsg(Str.Obj,119);
  end;

  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // ��� �������� ���������
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,81, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
    InsMsg(ObjZv[Str.Obj].BasOb,81);
  end else
  if not SigCircNegStrelki(Str.Obj,ObjZv[Str.Obj].bP[1])
  then result := trStop; // ��������������

  case Con.Pin of
    1 :
    begin
      // ��������� ����������� �� ������ ������� � ���� � �������� ��������
      if MarhTrac.VP > 0 then
      begin // ���� ������ ������� � ����
        for k := 1 to 4 do
        if (ObjZv[MarhTrac.VP].ObCI[k] = Str.Obj) and // ������ ������� � ����
        ObjZv[MarhTrac.VP].ObCB[k+1] then          // ������� ������ ������ �� �����
        begin // ��������� ����������� ������� �� ������
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
      begin // ������� �� ������������ ��� ������� �� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];

        if ObjZv[Str.Obj].bP[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
      not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
      begin // ������� �� ������ - ������ ��������������
        ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,120);
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // ����������� ������� � �����
        if not ObjZv[Str.Obj].bP[6] then
        begin // ������� �� �� ��������
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
      begin // ����������� ������� � ������
        if not ObjZv[Str.Obj].bP[7] then
        begin // ������� �� �� ��������
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
      else result := trStop;// ��� �������� ���������

      // ��������� ���������� ���� ����� �� �������
      if not SignCircOgrad(Str.Obj) then result := trStop; // ���������� ����

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
      begin // ����������� ������� � �����
        if not ObjZv[Str.Obj].bP[6] then
        begin // ������� �� �� ��������
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,160);
        end;

        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // ����������� ������� � ������
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end
      else  result := trStop; // ��� �������� ���������

      Con := ObjZv[Str.Obj].Sosed[1];
      // ��������� ���������� ���� ����� �� �������
      if not SignCircOgrad(Str.Obj)
      then result := trStop; // ���������� ����

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
      begin // ������� ������������ � ������� ����������
        if ObjZv[Str.Obj].ObCB[6]
        then zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[33]
        else zak := ObjZv[ObjZv[Str.Obj].BasOb].bP[34];
        if ObjZv[Str.Obj].bP[17] or zak then
        begin // ������� ������� ��� ���������������� ��������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,453, ObjZv[Str.Obj].Liter,1);
          InsMsg(Str.Obj,453);
        end;
      end;

      if ObjZv[Str.Obj].bP[1] then
      begin // ����������� ������� � �����
        result := trStop;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
        InsMsg(ObjZv[Str.Obj].BasOb,160);
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // ����������� ������� � ������
        if not ObjZv[Str.Obj].bP[7] then
        begin // ������� �� �� ��������
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,160, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsMsg(ObjZv[Str.Obj].BasOb,160);
        end;

        if ObjZv[ObjZv[Str.Obj].BasOb].bP[19] and
        not ObjZv[ObjZv[Str.Obj].BasOb].bP[27] then
        begin // ������� �� ������ - ������ ��������������
          ObjZv[ObjZv[Str.Obj].BasOb].bP[27] := true;
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,120, ObjZv[ObjZv[Str.Obj].BasOb].Liter,1);
          InsWar(ObjZv[Str.Obj].BasOb,120);
        end;
      end
      else  result := trStop; // ��� �������� ���������

      Con := ObjZv[Str.Obj].Sosed[1];
      // ��������� ���������� ���� ����� �� �������
      if not SignCircOgrad(Str.Obj) then result := trStop; // ���������� ����

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
//-------------------------------------------- ������ ����� ������� ��� ������ �����������
function StepStrFindIzv(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
begin
  result := trNext;
  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // ���� ������� �� ����� �������� ��������� - �������� ������ �����������
    result := trStop;
    exit;
  end;
  case Con.Pin of
    1 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin // �� �����
        con := ObjZv[Str.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else  result := trNext;
        end;
        exit;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // �� ������
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
      begin // �� �����
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
      begin // �� ������
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
//------------------- ������ ����� ������� ��� �������� ����������� �������������� �������
function StepStrFindStr(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
var
  zak : boolean;
  o,j,k : integer;
begin
  result := trNext;
  if not (ObjZv[Str.Obj].bP[1] xor ObjZv[Str.Obj].bP[2]) then
  begin // ���� ������� �� ����� �������� ��������� - �������� ������ �����������
    result := trStop;
    exit;
  end;

  o := ObjZv[Str.Obj].BasOb;
  zak := false;

  if Rod = MarshP then
  begin // ��������� ��������� ������� (� ����) � �������� ����������� � ����
    for j := 14 to 19 do
    begin
      if ObjZv[ObjZv[o].ObCI[j]].TypeObj = 41 then
      begin // �������� �������� ����������� � ���� �� �������� � ����
        if ObjZv[ObjZv[o].ObCI[j]].BasOb = MarhTrac.ObjStart then
        begin // ������� ���������� � �������� �������� ��� ��������
          zak := true;
          break;
        end;
      end;
    end;
  end;

  if not zak then
  begin // ��������� ���������� �������� �������
    k := ObjZv[Str.Obj].UpdOb;
    if not (ObjZv[ObjZv[o].ObCI[12]].bP[1] or // ���
    ObjZv[Str.Obj].bP[5] or     // ������� �������� ��������
    not ObjZv[k].bP[2] or       // ��������� �� ��
    ObjZv[o].bP[18] or          // ��������� �� ���������� FR4
    ObjZv[Str.Obj].bP[18]) then // ��������� �� ���������� ��-���
    MarhTrac.IzvStrNZ := true;
  end;

  case Con.Pin of
    1 :
    begin
      if ObjZv[Str.Obj].bP[1] then
      begin // �� �����
        con := ObjZv[Str.Obj].Sosed[2];
        case Con.TypeJmp of
          LnkRgn : result := trStop;
          LnkEnd : result := trStop;
          else result := trNext;
        end;
        exit;
      end else
      if ObjZv[Str.Obj].bP[2] then
      begin // �� ������
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
      begin // �� �����
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
      begin // �� ������
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
//------------------------------------ ������ ����� ������� ��� ��������� ������� ��������
function StepStrPovtMarh(var Con:TSos;const Lvl:TTrLev;Rod:Byte;Str:TSos):TTrRes;
begin
  result := trNext;
  if not ObjZv[Str.Obj].bP[14] then
  begin //------------------------------------------------------ ��������� ������ ��������
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
//----------------------------------------------------- ��� ����� ������ ��� ������ ������
function StepSigFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
begin
  if ObjZv[Con.Obj].RU = ObjZv[MarhTrac.ObjStart].RU then //--- ���� ���� ����� ����������
  begin
    if ObjZv[Sig.Obj].ObCB[1] then result := trRepeat else //����������� ����� �����������

    if Con.Pin = 1 then Con := ObjZv[Sig.Obj].Sosed[2] //����� � ����� 1, ����� �� ����� 2
    else Con := ObjZv[Sig.Obj].Sosed[1]; //-------------- ����� � ����� 2, ����� � ����� 1

    if(Con.TypeJmp>=LnkRgn) or (Con.TypeJmp=LnkEnd) then result := trRepeat
    else result := trNext;
  end
  else result := trRepeat; //------------------------------------------------- ����� �����
end;

//========================================================================================
function StepSigContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//---------------------------------------------------- ��������� ������ �� ��������� �����
var
  i,j,k : integer;
begin
  if ObjZv[Con.Obj].RU = ObjZv[MarhTrac.ObjStart].RU then
  begin //------------------------------ ���������� ����������� ���� ���� ����� ����������
    //----------------------------------- ���� ������ ������, ����� ����������� �/�, �����
    if ObjZv[Sig.Obj].ObCB[1] then  result := trKonec
    else
    if Con.Pin = 1 then
    begin //-------------------------------------------------------------- �������� ������
      if (((Rod = MarshM) and ObjZv[Sig.Obj].ObCB[7]) or//--- ������ � ����� �.1 ���
      ((Rod = MarshP) and ObjZv[Sig.Obj].ObCB[5])) and //--------- ����� � ����� �.1
                                                                 //----------------- � ...
      (ObjZv[Sig.Obj].bP[12] or ObjZv[Sig.Obj].bP[13] or //--- ���� STAN ��� DSP
      ObjZv[Sig.Obj].bP[18] or //----------------------------------------  ��� ��(��)
                                        //---------------------------------------  ��� ...
      (ObjZv[Sig.Obj].ObCB[2] and //----------------- �������� ������ �������� � ...
      (ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4] or //----- �1 ��� �2 ��� ...
      ObjZv[Sig.Obj].bP[8] or ObjZv[Sig.Obj].bP[9])) or //---- � �� STAN ��� ���
                                            //------------------------------------ ��� ...
      (ObjZv[Sig.Obj].ObCB[3] and  //-------------- �������� ������ ���������� � ...
      (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or //--- ��1 ��� ��2 ��� ...
      ObjZv[Sig.Obj].bP[6] or ObjZv[Sig.Obj].bP[7]))) then //--- �� STAN ��� ���
      result := trKonec //------ ��������� ����������� ���� �������� ������� ��� ������
      else
      case Rod of
        MarshP : //----------------------------------------------------- �������� ��������
        begin
          if ObjZv[Sig.Obj].ObCB[16] and //------------ ��� �������� ��������� � ...
          ObjZv[Sig.Obj].ObCB[2] then //------------------- �������� ������ ��������
          result := trKonec //-------------------------------- ��������� ����� ��������
          else
          if ObjZv[Sig.Obj].ObCB[5] then
          begin //----------- ���� ����� ��������� �������� � ����� 1 ��������� ( � �����)
            MarhTrac.FullTail := true; //-------- ������� ������ ������ ��������
            MarhTrac.FindNext := true; //------ �������� ����������� �����������
            if ObjZv[Sig.Obj].ObCB[2] //------------------- �������� ������ ��������
            then
            begin
              result := trEnd;     //------------------------- ����� ����������� ���������
              MarhTrac.ObjEnd := Sig.Obj; // ������� ����� ��������� �� ��������
            end
            else result := trKonec; //------------------------ ��������� ����� ��������
          end
          else result := trNext; //----- ��� ����� ��������� �������� � ���������,����
        end;

        MarshM : //--------------------------------------------------- ���������� ��������
        begin
          if ObjZv[Sig.Obj].ObCB[7] then //----- ���� ����� ���������� � �.1 �������
          begin
            MarhTrac.FullTail := true; //------------------------ ������� ������
            MarhTrac.FindNext := true; //----- ��������� ����������� �����������
            if ObjZv[Sig.Obj].ObCB[3] //----------------- �������� ������ ����������
            then
            begin
              result := trEnd;  //---------------------------- ����� ����������� ���������
              MarhTrac.ObjEnd := Sig.Obj;
            end
            else result := trKonec;
          end
          else result := trNext; //---- ��� ����� ���������� � �.1 - ������ ������
        end;

        else result := trEnd; //------ ��������� ��� �������� - ��������� ����� ������
      end;

      if result = trNext then //-------------------------- ���� ���� ������ ������
      begin
        Con := ObjZv[Sig.Obj].Sosed[2]; //- ���������� ��������� �� �������� (�2)
        case Con.TypeJmp of
          LnkRgn : result := trStop; //----------------------- ����� ������ ����������
          LnkEnd : result := trStop; //----------------------------- ����� �����������
        end;
      end;
    end else
    begin //------------------------ ��������� ������ (����� �� ������ �� ������� �.2)
      case Rod of
        MarshP : //-------------------------- ��������� ������� ��� �������� -------------
        begin
          if ObjZv[Sig.Obj].ObCB[5] //---- �������� ����� ���� � �.1 �� ��������
          then result := {trPlus} trNext //- ���� ����� ��������, �� �������� ���� ���������
          else //-------------------------------------- ���� ��������� ����� ��� � �.1
          begin
            if ObjZv[Sig.Obj].Sosed[1].TypeJmp = 0 then //------------ ������ ���
            result := trStop //-------------------- ����� ���� ��� ��������� �� ������
            else result := trNext; //-------------------------------- ����� ������
          end;
        end;

        MarshM : //------------------------- ��������� ������� ��� ��������---------------
        begin
          if ObjZv[Sig.Obj].ObCB[8] //���� ������� �������� ����� �������� �� �����
          then
          begin
            result := trKonec;
            if Sig.Pin = 1  then Sig := ObjZv[Sig.Obj].Sosed[2]
            else Sig := ObjZv[Sig.Obj].Sosed[1];
          end
          else
            if ObjZv[Sig.Obj].ObCB[7]//���� ����� �������� � �.1 (�� ��������� ����.)
            then result := trNext //----------------------------  �� ���������� ������
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
              result := trEnd; //------------------------------------------- ����� ����
            end;

        end;

        else result := trEnd; //------------------ ������� ����������, �� ������������
      end;

      if result = trNext then //------------------------- ���� ����� ������ ������
      begin
        Con := ObjZv[Sig.Obj].Sosed[1]; //----- ��������������� ��������� ����� 1
        case Con.TypeJmp of
          LnkRgn : result := trRepeat;
          LnkEnd : result := trRepeat;
          LnkFull : result := trNext;
          LnkNecentr : result := trKonec;
        end;
      end;

      if result = trPlus then  result := trKonec; //--- ����� ������� @@@@@@@@@@@@

    end;
  end
  else result := trKonec;//��������� ����������� �������� ���� ������ ����� ����������
end;

//========================================================================================
function StepSigZavTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//-------------------------------------------------------- �������� ������������ �� ������
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
//---------------------------------------------- �������� ������������� �� ������ ��������
begin
  result := trNext;
  if (ObjZv[Sig.Obj].bP[12] or  //--------------------- ���������� � STAN ��� ...
  ObjZv[Sig.Obj].bP[13]) and //--------------------------- ���������� � DSP � ...
  (Sig.Obj <> MarhTrac.ObjTRS[MarhTrac.Counter]) // �� ���������
  then
  begin //------------------------------------ ������������ �������� � �������� ������
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,123, ObjZv[Sig.Obj].Liter,1);
    InsMsg(Sig.Obj,123); //----------------------------- �������� $ ������������
    MarhTrac.GonkaStrel := false;
  end;

  if ObjZv[Sig.Obj].bP[18] and //------------------------------- ���� �� (��� ��)
  (Sig.Obj <> MarhTrac.ObjTRS[MarhTrac.Counter]) then //- ������
  begin //--------------------------- �������� �� ������� ���������� � �������� ������
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,232, ObjZv[Sig.Obj].Liter,1);//------- ������ $ �� ������� ����������
    InsMsg(Sig.Obj,232);
    MarhTrac.GonkaStrel := false;
  end;

  if Con.Pin = 1 then //-------------------------------------- ����� � �������� ������
  begin //----------------------------------------------------- ������������ ���������
    if ((not ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP)) or//��� �-����� � �1 ���
    (not ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM))) and //��� �-����� � �1 �
    (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or  //---- ��1 ��� ��2 ���
    ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4]) then //--------- �1 ��� �2
    begin
      result := trBreak;
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,114);  //----------------------- ������ ���������� ������ $
      MarhTrac.GonkaStrel := false;
    end;

    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTrac.FindTail //----------- ���� ������� ��������� � ����� ������
    then MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter;
  end else
  begin //------- ���� ����� �� ��������� ������, �� �������� ������������� ����������
    if ObjZv[Sig.Obj].bP[1] or   //---------------------------------- ��1 ��� ...
    ObjZv[Sig.Obj].bP[2] or   //------------------------------------- ��2 ��� ...
    ObjZv[Sig.Obj].bP[3] or   //-------------------------------------- �1 ��� ...
    ObjZv[Sig.Obj].bP[4] then //---------------------------------------------- �2
    begin
      result := trBreak;
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,114);  //----------------------- ������ ���������� ������ $
      MarhTrac.GonkaStrel := false;
    end;

    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;

    if MarhTrac.FindTail then //----------------------- ���� ������ ����� ������
    begin
      if (ObjZv[MarhTrac.ObjEnd].TypeObj = 5) and (Sig.Pin = 1)
      then //---------------------------------------------- ���� ����� �� �������� �������
       MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter
      else
        if ObjZv[MarhTrac.ObjEnd].ObCB[3] and (Rod = MarshM) then
        MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter
        else
        if ObjZv[MarhTrac.ObjEnd].ObCB[2] and (Rod = MarshP) then
        MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter
        else
        begin
          result := trBreak;
        end;
//        MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter;
    end;
  end;
end;

//========================================================================================
function StepSigZamTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//------------------- ��������� ������ ��������, ���� ��������� ����������� ������� ������
begin
  if Con.Pin = 1 then  //--------------------------------------------- �������� ������
  begin
    Con := ObjZv[Sig.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;
      else result := trNext;
    end;

    if result = trNext then
    begin
      if MarhTrac.FindTail //------------------------------------ ���� ������ ����� ������
      then MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter;

      //-------------------------------------- �������� �������� ������ � �������� �������
      if ObjZv[MarhTrac.ObjStart].bP[7] then //------------------ ���������� ������� �����
      begin
        if ObjZv[Sig.Obj].ObCB[3] then //-------------------------- ���� ���������� ������
        begin
          MarhTrac.SvetBrdr := Sig.Obj;//------------- ������� ������ ������� ����-�������
          ObjZv[Sig.Obj].bP[7] := true;  //-------------------------------------------- ��
//        ObjZv[Sig.Obj].bP[14] := true; //------------------------------- ����. ���������
          ObjZv[Sig.Obj].iP[1] := MarhTrac.ObjStart; //------------------- ������ ��������
        end;
      end else

      if ObjZv[MarhTrac.ObjStart].bP[9] then //-------------------- �������� ������� �����
      begin
        if ObjZv[Sig.Obj].ObCB[2] then //---------------------------- ���� �������� ������
        begin
          MarhTrac.SvetBrdr := Sig.Obj;//------------- ������� ������ ������� ����-�������
          ObjZv[Sig.Obj].bP[8] := true;  //--------------------------------------------- �
//        ObjZv[Sig.Obj].bP[14] := true; //-------------------- ���������� ����. ���������
          ObjZv[Sig.Obj].iP[1] := MarhTrac.ObjStart; //------------------- ������ ��������
        end;
      end;
    end;
  end else //------------------------------------- ����� �� ��������� ������ (�� ����� �2)
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
      if ObjZv[MarhTrac.ObjEnd].TypeObj = 5 then //----------------- ���� ����� �� �������
      MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter
      else MarhTrac.TailMsg := ' �� '+ ObjZv[Sig.Obj].Liter;
    end;

    // ObjZv[Sig.Obj].bP[14] := true;  //--------------------------------- ����. ���������
    ObjZv[Sig.Obj].iP[1] := MarhTrac.ObjStart; //------------------------- ������ ��������
  end;
end;

//========================================================================================
function StepSigCirc(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
//------------------------ ���������� ������ (��������� �������� �������, ������ ��������)
begin
  result := trNext;
  if ObjZv[Sig.Obj].bP[12] or ObjZv[Sig.Obj].bP[13] then
  begin //------------------------------------------------------ ������������ ��������
    if not((ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,123, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,123);   //------------------------- �������� $ ������������
    end;
  end else
  if ObjZv[Sig.Obj].bP[18] then
  begin //--------------------------------------------- �������� �� ������� ����������
    if not((ObjZv[Sig.Obj].ObCB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
    (ObjZv[Sig.Obj].ObCB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
    (ObjZv[Sig.Obj].ObCB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,232, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,232); //-------------------- ������ $ �� ������� ����������
    end;
  end
  else result := trNext;

  if Con.Pin = 1 then
  begin //----------------------------------------------------- ������������ ���������
    case Rod of
      MarshP :
      begin
        if ObjZv[Sig.Obj].ObCB[5] then //------------------------------- ���� �2
        begin
          if ObjZv[Sig.Obj].bP[5] and //----------------------- ������� � ��� ...
          not (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or// ��1 ��� ��2
          ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4]) then //��� �1 ��� �2
          begin //--------------------- ������� �� ������� ����������� ����� ���������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,115, ObjZv[Sig.Obj].Liter,1);
            InsWar(Sig.Obj,115); //- ������� �� ��������! ���������� �����������
          end;
          result := trKonec;
        end;

        if ObjZv[Sig.Obj].ObCB[19] then
        begin //--------------- �������� �������������� ������� ��� ��������� ��������
          if not ObjZv[Sig.Obj].bP[4] then
          begin //------------------------------------------------------ ������ ������
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,391, ObjZv[Sig.Obj].Liter,1);
            InsMsg(Sig.Obj,391); //----------------------------- ������ $ ������
          end;
        end;
      end;

      MarshM :
      begin
        if ObjZv[Sig.Obj].ObCB[7] then   //- �������� ���������� ����� � ����� 1
        begin
          if ObjZv[Sig.Obj].bP[5] and not //----------------------- ������� � ���
          (ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or //��1 ��� ��2 ���
          ObjZv[Sig.Obj].bP[3] or ObjZv[Sig.Obj].bP[4]) then //--- �1 ��� �2
          begin //--------------------- ������� �� ������� ����������� ����� ���������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,115, ObjZv[Sig.Obj].Liter,1);
            InsWar(Sig.Obj,115); //- ������� �� ��������! ���������� �����������
          end;
          result := trKonec;
        end;

        if ObjZv[Sig.Obj].ObCB[20] then
        begin //------------- �������� �������������� ������� ��� ����������� ��������
          if not ObjZv[Sig.Obj].bP[2] then //---------------------------- ��� ��2
          begin //------------------------------------------------------ ������ ������
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

    Con := ObjZv[Sig.Obj].Sosed[2]; //-------------- ��������� �� ������� ����� 2
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin //---------------------------------------- ������������ ���������� ����� � �.2
    if ObjZv[Sig.Obj].ObCB[6] and (Rod = MarshP) //�������� ����� �������� � �.2
    then result := trStop
    else
    if ObjZv[Sig.Obj].ObCB[8] and (Rod =MarshM)//�������� ����� ���������� � �.2
    then result := trStop
    else
    if ObjZv[Sig.Obj].bP[1] or   //------------------------------------------ ��1
    ObjZv[Sig.Obj].bP[2] or   //--------------------------------------------- ��2
    ObjZv[Sig.Obj].bP[3] or   //---------------------------------------------- �1
    ObjZv[Sig.Obj].bP[4] then //---------------------------------------------- �2
    begin
      result := trStop;
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
      InsMsg(Sig.Obj,114); //------------------------ ������ ���������� ������ $
    end;

    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end;
end;

//========================================================================================
//-------------------------------------- ������ ��������, ���������� ���� "�" ��� ��������
function StepSigOtmena(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos) : TTrRes;
begin
  result := trNext;
  if Con.Pin = 1 then
  begin //------------------------------------------------------------ �������� ������
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
    begin     //----------------------- ����� ����� ������ ��������� ��������
      if Rod = MarshM then
      begin // ����������
        if ObjZv[Sig.Obj].ObCB[7] then result := trStop
        else ObjZv[Sig.Obj].bP[14] := false;
      end else
      if Rod = MarshP then
      begin // ��������
        if ObjZv[Sig.Obj].ObCB[5] then result := trStop
        else ObjZv[Sig.Obj].bP[14] := false;
      end;
    end;
  end else
  begin // ��������� ������
    ObjZv[Sig.Obj].bP[14] := false;
    Con := ObjZv[Sig.Obj].Sosed[1];
    case Con.TypeJmp of
      LnkRgn : result := trEnd;
      LnkEnd : result := trStop;      // ����� ����� ������ ��������� ��������
      else   // ����� ����� ������ ��������� ��������
      if Rod = MarshM then
      begin // ����������
        if ObjZv[Sig.Obj].ObCB[8]
        then result := trStop
        else result := trNext;
      end else
      if Rod = MarshP then
      begin // ��������
        if ObjZv[Sig.Obj].ObCB[6]
        then result := trStop
        else result := trNext;
      end;
    end;
  end;
end;

//========================================================================================
//------------------ ������ ��� ������������, ���������� �������� ��� ������� � ����������
function StepSigAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sig:TSos):TTrRes;
begin
  result := trNext;
  if ObjZv[Sig.Obj].bP[12] or ObjZv[Sig.Obj].bP[13] then
  begin // ������������ ��������
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
  begin // �������� �� ������� ����������
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
  begin // ������������ ���������
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
          begin // ������� �� ������� ����������� ����� ���������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,115, ObjZv[Sig.Obj].Liter,1);
            InsWar(Sig.Obj,115);
          end;
          result := trKonec;
        end else
        begin
          if ObjZv[Sig.Obj].bP[1] or ObjZv[Sig.Obj].bP[2] or ObjZv[Sig.Obj].bP[6] or ObjZv[Sig.Obj].bP[7] or ObjZv[Sig.Obj].bP[21] then
          begin // ������ ���������� ������
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1); InsMsg(Sig.Obj,114);
          end;
        end;

        if ObjZv[Sig.Obj].ObCB[19] then
        begin // �������� �������������� ������� ��� ��������� ��������
          if not ObjZv[Sig.Obj].bP[4] then
          begin // ������ ������
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
          begin // ������� �� ������� ����������� ����� ���������
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
          begin // ������ ���������� ������
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,114, ObjZv[Sig.Obj].Liter,1);
            InsMsg(Sig.Obj,114);
          end;
        end;

        if ObjZv[Sig.Obj].ObCB[20] then
        begin // �������� �������������� ������� ��� ����������� ��������
          if not ObjZv[Sig.Obj].bP[2] then
          begin // ������ ������
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
  begin // ������������ ����������
    if ObjZv[Sig.Obj].bP[1] or   // ��1
    ObjZv[Sig.Obj].bP[2] or   // ��2
    ObjZv[Sig.Obj].bP[3] or   // �1
    ObjZv[Sig.Obj].bP[4] then // �2
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
          // ������� �� ����������
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
//--------------------------------------------- ������ ����� ������ ��� ������ �����������
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
  begin //---------------------------------------- ��������� ������� ��� ��������� �������
    if ObjZv[Sig.Obj].bP[2] or ObjZv[Sig.Obj].bP[4] then  //---- �������� ������
    inc(MarhTrac.IzvCount)
    else
    if ObjZv[Sig.Obj].bP[6] or
    ObjZv[Sig.Obj].bP[7] or
    ObjZv[Sig.Obj].bP[1] then
    begin //---------- ��������� ������� ����������� ������ ��� ������ �� �������� �������
      if not ObjZv[Sig.Obj].bP[2] then
      begin //------------------------------------------------------------ �������� ������
        result := trStop;
        exit;
      end;
      inc(MarhTrac.IzvCount);
    end else
    if ObjZv[Sig.Obj].bP[8] or
    ObjZv[Sig.Obj].bP[9] or
    ObjZv[Sig.Obj].bP[3] then
    begin //------------ ��������� ������� ��������� ������ ��� ������ �� �������� �������
      if not ObjZv[Sig.Obj].bP[4] then
      begin //------------------------------------------------------------ �������� ������
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
//----------- ������ ����� ������ ��� ������ ����������� ������� �� �������������� �������
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
  begin // ��������� ������� ��� ��������� �������
    if ((Rod = MarshM) and ObjZv[Sig.Obj].ObCB[3]) or
    ((Rod = MarshP) and (ObjZv[Sig.Obj].ObCB[2] or ObjZv[Sig.Obj].bP[2])) then
    begin // �������� ������������ �������������� �������
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
//----------------------------- ������� ������� ����� ������ ��� ��������� ������ ��������
function StepSigPovtMarh(var Con:TSos; const Lvl:TTrLev; Rod :Byte; Sig:TSos) : TTrRes;
//------------------------------------ Con - ���������, � �������� ������ ������ �� ������
//----------------------------------------------------- Lvl - ����������� ���� �����������
//------------------------------------------------------- Rod - ��� ������������� ��������
//------------------------------------- jmp - �����, �� �������� ������ ������ �� ��������
//--- ������� ���������� ��������� ����������� ����� ������ �� ���������� ������ ���������
var
  old_con : TSos;
begin
  result := trNext; //------------ ���������� ���������, ��� ������ ������ ���� ������
  old_con := Con;
  //------------------------------------ ��������� ������� ������ ��������� ����� ��������
  if Con.Pin = 1 then //-------------- ���� ����� �� ������ � ����� 1 (�������� ���������)
  begin
    case Rod of
      MarshP : //-------------------------------------------------- ��� ��������� ��������
        if ObjZv[Sig.Obj].ObCB[5] //------------- ���� � ����� 1 ���� ����� ��������
        then result := trKonec; //---------------------- ����� ��������� = ����� ������
      MarshM : //------------------------------------------------ ��� ����������� ��������
        if ObjZv[Sig.Obj].ObCB[7] //----------- ���� � ����� 1 ���� ����� ����������
        then result := trKonec; //---------------------- ����� ��������� = ����� ������
      else  result := trEnd;    //---------------- ��� ������������� ��������� ����� �����
    end;

    if result = trNext then //- ���� � ����� 1 �� ���� ��������, � ������ ������������
    begin
      Con := ObjZv[Sig.Obj].Sosed[2]; //- �������� ����� ��������� �� ������� ����� 2
      case Con.TypeJmp of
        LnkRgn : result := trStop; //----------------- ���� ������ � ������ �����, �� ����
        LnkEnd : result := trStop; //---------------------- ���� ��������� ������, �� ����
      end;
    end;
  end else //--------- ���� ����� �� ������ � ����� 2 ��������� ������� ������ �� ��������
  begin
    case Rod of
      MarshP :
        if ObjZv[Sig.Obj].ObCB[5] or ObjZv[Sig.Obj].ObCB[6]
        then result := trKonec;//------------------------------ � ����� � ����� 1 ��� 2

      MarshM :
        if ObjZv[Sig.Obj].ObCB[7] or ObjZv[Sig.Obj].ObCB[8]
        then result := trKonec;//------------------------------ � ����� � ����� 1 ��� 2
    end;
  end;
  Con := old_con;
  if result = trNext then //---------------------------- ���� ������������ �����������
  begin
    if Con.Pin = 1 then Con := ObjZv[Sig.Obj].Sosed[2]
    else Con := ObjZv[Sig.Obj].Sosed[1];

    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd :
      begin  //---------------------------------------------------- ������� �� ����������
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
//--------------------------------------------- ������ ����� �� ��� ������ ������ ��������
function StepSpPutFindTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  PinX : integer;
begin
  if Con.Pin = 1 then  //------------------------------ ����� �� ������ �� ������� ����� 1
  begin
    PinX := 2;
    case Rod of //------------------- ���� ���� �������� ��� ���������� � ����������� 1->2
      MarshP : if ObjZv[Sp.Obj].ObCB[1] then result := trNext  else result := trRepeat;
      MarshM : if ObjZv[Sp.Obj].ObCB[3] then result := trNext  else result := trRepeat;
      else result := trStop;
    end;
  end else  //----------------------------------------- ����� �� ������ �� ������� ����� 2
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
//---------------------- ������ ����� �� ��� ��������� ������ �������� �� ��������� ������
function StepSPContTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trBreak;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
        if ObjZv[Sp.Obj].ObCB[1]  //--------- ���� ���� �������� � ����������� 1->2
        then result := trNext
        else result := trStop;

      MarshM :
        if ObjZv[Sp.Obj].ObCB[3] //-------- ���� ���� ���������� � ����������� 1->2
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
        if ObjZv[Sp.Obj].ObCB[2]then //-------���� ���� �������� � ����������� 2->1
        result := trNext
        else result := trStop;

      MarshM :
        if ObjZv[Sp.Obj].ObCB[4]//--------- ���� ���� ���������� � ����������� 2->1
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
//---------------------------------------------- ������ ����� �� ��� �������� ������������
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
//----------------------------- ��� ����� �� ��� �������� ������������� �� ������ ��������
function StepS�ChckTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
var
  tail : boolean;
  k : integer;
begin
  with ObjZv[Sp.Obj] do
  begin
    result := trNext;
    //------ ���� "�" ��� ��� �������� ��������� �������� � ���� ����������� ��������� ���
    //----------------------------------------- ��������������� ��������� STAN �����������
    if not bP[2] or (not MarhTrac.Povtor and (bP[14] or not bP[7])) then
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,82, Liter,1);
    InsMsg(Sp.Obj,82); //----------------------------------------------- ������� $ �������
    MarhTrac.GonkaStrel := false;
  end;

  if bP[12] or bP[13] then //----------------------------------------- ������ ��� ��������
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,134, Liter,1);
    InsMsg(Sp.Obj,134); //---------------------------------- ������� $ ������ ��� ��������
    MarhTrac.GonkaStrel := false;
  end;

  //""""""""""""""""""""""""""""""" ��������� ��������� ����������� """"""""""""""""""""""

  if ObCB[8] or ObCB[9] then //--------------------------------------------- ���� ��. ����
  begin
    if bP[24] or bP[27] then //--------------------------------------------- ������ ��� ��
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, Liter,1);
      InsWar(Sp.Obj,462); //------------------------- ������� �������� �� ����������� �� $
    end else
    if ObCB[8] and ObCB[9] then
    begin
      if bP[25] or bP[28] then//������ ��� ��=
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, Liter,1);
        InsWar(Sp.Obj,467);//------------- ������� �������� �� ����������� ����. ���� �� $
      end;

      if bP[26] or bP[29] then//------------------------------------------- ������ ��� ��~
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, Liter,1);
        InsWar(Sp.Obj,472); //----------- ������� �������� �� ����������� �����. ���� �� $
      end;
    end;
  end;

  if bP[3] then //--------------------------------------------------------------------- ��
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,84, Liter,1);
    InsMsg(Sp.Obj,84); //------------------ ����������� ������������� ���������� ������� $
    MarhTrac.GonkaStrel := false;
  end;

  if not bP[5] then //----------------------------------------------------------------- ��
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,85, Liter,1);
    InsMsg(Sp.Obj,85);  //----------------------------------- ������� $ ������� � ��������
    MarhTrac.GonkaStrel := false;
  end;

  case Rod of
    MarshP :
    begin
      if not bP[1] then //---------------------------------------------- ��������� �������
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
        GetSmsg(1,83, Liter,1);
        InsMsg(Sp.Obj,83);   //------------------------------------------- ������� $ �����
        MarhTrac.GonkaStrel := false;
      end;
    end;

    MarshM :
    begin
      if not bP[1] then //------------------------------------------- ��������� ������� ��
      begin
        if ObCB[5] then  //------------------------------------------------------- ���� ��
        begin
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,83, Liter,1);
          InsMsg(Sp.Obj,83); //------------------------------------------- ������� $ �����
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

          if tail then  //-------------------------------------------- ���� ����� ��������
          begin
            MarhTrac.TailMsg := ' �� ������� ������� '+ Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, Liter,1);
            InsWar(Sp.Obj,83); //----------------------------------------- ������� $ �����
            result := trEnd;
          end else  //------------------------------------------- ���� �� � ����� ��������
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,83, Liter,1);
            InsMsg(Sp.Obj,83); //----------------------------------------- ������� $ �����
            result := trBreak;
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;
    end;

    else
      result := trStop;
      exit; //------------------------------------ ���� �� �������� �������, �� ����������
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
  if not ObjZv[Sp.Obj].bP[1] and    //--------------------- ���� ����� ������� � ...
  not ObjZv[Sp.Obj].ObCB[5] and    //------------------------ ���� ������� �� � ...
  (Rod = MarshM) then //----------------------------------------------- ���������� �������
  begin //---------------- ������ �������������� � ���������� �������� � ��������� �������
    MarhTrac.TailMsg := ' �� ������� ������� '+ ObjZv[Sp.Obj].Liter;
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
      then ObjZv[Sp.Obj].bP[14] := true; //------------------------- ����. ���������

      ObjZv[Sp.Obj].iP[1] := MarhTrac.ObjStart; //---------- ������ ������
      ObjZv[Sp.Obj].iP[2] := MarhTrac.SvetBrdr; //------- ������ ���������

      if not ObjZv[Sp.Obj].ObCB[5] and //---------------------------- ���� �� � ...
      (Rod = MarshM) then //------------------------------------------- ���������� �������
      begin //-------------------------------------------- ��� �� � �������� ��������� 1��
        ObjZv[Sp.Obj].bP[15] := true;  //--------------------------------------- 1��
        ObjZv[Sp.Obj].bP[16] := false; //--------------------------------------- 2��
      end else
      begin //----------------------------------------------------------- ����� ����� ����
        ObjZv[Sp.Obj].bP[15] := false; //--------------------------------------- 1��
        ObjZv[Sp.Obj].bP[16] := false; //--------------------------------------- 2��
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
      if ObjZv[Sp.Obj].bP[2] //--------------------- ���� ��� "�" �� �������� ������
      then ObjZv[Sp.Obj].bP[14] := true;  //---- �� ���������� ����������� ���������

      ObjZv[Sp.Obj].iP[1] := MarhTrac.ObjStart; //---------- ������ ������
      ObjZv[Sp.Obj].iP[2] := MarhTrac.SvetBrdr; //------- ������ ���������

      if not ObjZv[Sp.Obj].ObCB[5] and (Rod = MarshM) then
      begin //-------------------------------------------- ��� �� � �������� ��������� 2��
        ObjZv[Sp.Obj].bP[15] := false; //--------------------------------------- 1��
        ObjZv[Sp.Obj].bP[16] := true;  //--------------------------------------- 2��
      end else
      begin //----------------------------------------------------------------- ����� ����
        ObjZv[Sp.Obj].bP[15] := false; //--------------------------------------- 1��
        ObjZv[Sp.Obj].bP[16] := false; //--------------------------------------- 2��
      end;
    end;
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSpCirc(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trNext;

  //""""""""""""""""""""""" ��������� ��������� ����������� """"""""""""""""""""""""""""""
  if ObjZv[Sp.Obj].bP[12] or ObjZv[Sp.Obj].bP[13] then //-- ������ ��� ������.
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,134); //--------------------------- ������� $ ������ ��� ��������
    result :=  trBreak;
  end;

  if ObjZv[Sp.Obj].ObCB[8] or  //----------------- ���� �� ����������� ���� ��� ...
  ObjZv[Sp.Obj].ObCB[9] then   //------------------------------ �� ����������� ����
  begin
    if ObjZv[Sp.Obj].bP[24] or //--- ���� ������ ��� �������� �� ��.�. � ��� ��� ���
    ObjZv[Sp.Obj].bP[27] then //---------------- ������ ��� �������� �� ��.�. � STAN
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and //------------------------- ��� ������� ����������
    ObjZv[Sp.Obj].ObCB[9] then //--- ���� �� ����������� ���� � �� ����������� ����
    begin
      if ObjZv[Sp.Obj].bP[25] or //-------- ������ ��� �������� �� ����.�. � ��� ���
      ObjZv[Sp.Obj].bP[28] then //------------ ������ ��� �������� �� ����.�. � STAN
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467); //-------- ������� �������� �� �� ����������� ���� �� $
      end;
      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472); //-------- ������� �������� �� �� ����������� ���� �� $
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- ��
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84); //----------- ����������� ������������� ���������� ������� $
  end;

  if not ObjZv[Sp.Obj].bP[5] then //--------------------------------------------- ��
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,85, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,85); //----------------------------- ������� $ ������� � ��������
  end;

  if Rod = MarshP then
  begin
    if not ObjZv[Sp.Obj].bP[1] then //---------------------------- ��������� �������
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
      GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
      InsMsg(Sp.Obj,83); //---------------------------------------- ������� $ �����
    end;
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].ObCB[1] then   //----- ��� �������� � ����������� 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //----------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[3] then  //---- ��� ���������� � ����������� 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162);  //-------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZv[Sp.Obj].bP[1] then //------------------------ ��������� �������
        begin
          if ObjZv[Sp.Obj].bP[15] then //--------------------------------------------- 1��
          begin
            MarhTrac.TailMsg :=' �� ������� ������� '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83); //----------------------------------------- ������� $ �����
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

  end else //-------------------------------------------------------- ���� ����� � ����� 2
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].ObCB[2] then //-------- ���� ��� �������� � ����. 1<-2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161);  //---------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin

        if not ObjZv[Sp.Obj].ObCB[4] then    //���� ��� ���������� � �������. 1<-2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //--------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZv[Sp.Obj].bP[16] then //--------------------------------------- 2��
          begin
            MarhTrac.TailMsg :=' �� ������� ������� '+ObjZv[Sp.Obj].Liter;
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
    ObjZv[Sp.Obj].bP[14] := false; //------------------------------- ����. ���������
    ObjZv[Sp.Obj].bP[8]  := true;  //---------------------------------------- ������
    ObjZv[Sp.Obj].iP[1]  := 0;
    ObjZv[Sp.Obj].iP[2]  := 0;
    ObjZv[Sp.Obj].bP[15] := false; //------------------------------------------- 1��
    ObjZv[Sp.Obj].bP[16] := false; //------------------------------------------- 2��
  end;
end;

//========================================================================================
//----------------------------------------------------------------------------------------
function StepSpRazdel(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trNext;
  if not ObjZv[Sp.Obj].bP[2] then //--------------------------------------- ��������� ����
  begin
    if ObjZv[Sp.Obj].ObCB[5] then //----------------------------------------- ���� ��� ��
    begin //--------------------------------------------------- �� - ������ ��������������
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
      GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,82);   //------------------------------------------- ������� $ �������
    end else
    begin //--------------------------------------------------------------------------- ��
      case Rod of
        MarshP :
        begin
          if not ObjZv[Sp.Obj].bP[15] and
          not ObjZv[Sp.Obj].ObCB[16] then //------------------------------ ��� ����
          begin //-------------------------------------------------- ������ ��������������
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,82); //-------------------------------- ������� $ �������
          end else
          begin //----------------------------------------------------------- ������������
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
            GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,82); //-------------------------------- ������� $ �������
          end;
        end;

        MarshM :
        begin
          if Con.Pin = 1 then
          begin
            if ObjZv[Sp.Obj].bP[15] and
            not ObjZv[Sp.Obj].ObCB[16] then //-------------------- ���� 1�� ��� 2��
            begin //------------------------------------------------ ������ ��������������
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsWar(Sp.Obj,82); //------------------------------ ������� $ �������
            end else
            begin //--------------------------------------------------------- ������������
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsMsg(Sp.Obj,82); //------------------------------ ������� $ �������
            end;
          end else
          begin
            if not ObjZv[Sp.Obj].bP[15] and
            ObjZv[Sp.Obj].ObCB[16] then //------------------------ ���� 2�� ��� 1��
            begin //------------------------------------------------ ������ ��������������
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsWar(Sp.Obj,82); //------------------------------ ������� $ �������
            end else
            begin //--------------------------------------------------------- ������������
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
              GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
              InsMsg(Sp.Obj,82); //------------------------------ ������� $ �������
            end;
          end;
        end;

        else
          inc(MarhTrac.MsgN); //------------------------------- ������������
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
          GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,82); //---------------------------------- ������� $ �������
      end;
    end;
  end;

  if not ObjZv[Sp.Obj].bP[7] or
  ObjZv[Sp.Obj].bP[14] then //-------------------------------- ����������� ���������
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,82); //---------------------------------------- ������� $ �������
  end;

  if ObjZv[Sp.Obj].bP[12] or
  ObjZv[Sp.Obj].bP[13] then //------------- ������ ��� �������� � ��� ��� ��� � STAN
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,134);
  end;

  if ObjZv[Sp.Obj].ObCB[8] or
  ObjZv[Sp.Obj].ObCB[9] then //---------------------- ���� ������� ����������������
  begin
    if ObjZv[Sp.Obj].bP[24] or
    ObjZv[Sp.Obj].bP[27] then //----------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTrac.WarN);         //------------------------- ��������������
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462);  //----------------- ������� �������� �� ����������� �� $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and ObjZv[Sp.Obj].ObCB[9] then //----- ��� ����
    begin
      if ObjZv[Sp.Obj].bP[25] or
      ObjZv[Sp.Obj].bP[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTrac.WarN);       //------------------------- ��������������
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467);//--------- ������� �������� �� �� ����������� ���� �� $
      end;

      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTrac.WarN);       //------------------------- ��������������
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472); //-------- ������� �������� �� �� ����������� ���� �� $
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- ��
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84);
  end;

  if not ObjZv[Sp.Obj].bP[5] then //--------------------------------------------- ��
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,85, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,85); //----------------------------- ������� $ ������� � ��������
  end;

  if Con.Pin = 1 then
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ ��������� �������
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);  //----------------------------------- ������� $ �����
        end;

        if not ObjZv[Sp.Obj].ObCB[1] then //------- ��� �������� � ����������� 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //----------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[3] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //--------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- ��������� �������
          if not ObjZv[Sp.Obj].ObCB[5] then //---------------------------------- ��
          begin
            MarhTrac.TailMsg := ' �� ������� ������� '+ ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83); //---------------------------------- ������� $ �����
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
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ ��������� �������
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
          InsMsg(Sp.Obj,161);   //--------------------- ��� �������� ��������� �� $
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[4] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //----------------- ��� ���������� ��������� �� $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- ��������� �������
          if not ObjZv[Sp.Obj].ObCB[5] then //---------------------------------- ��
          begin
            MarhTrac.TailMsg :=' �� ������� ������� '+ObjZv[Sp.Obj].Liter;
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
  if not ObjZv[Sp.Obj].bP[2] then //-------------------------------------- ���������
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,328, ObjZv[MarhTrac.ObjStart].Liter,0) + ' - ' +
    GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,82);
  end;

  if ObjZv[Sp.Obj].bP[12] or ObjZv[Sp.Obj].bP[13] then//- ������ ��� ��������.
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,134);  //-------------------------- ������� $ ������ ��� ��������
  end;

  if ObjZv[Sp.Obj].ObCB[8] or ObjZv[Sp.Obj].ObCB[9] then  //-------- ���� ��
  begin
    if ObjZv[Sp.Obj].bP[24] or
    ObjZv[Sp.Obj].bP[27] then //----------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and ObjZv[Sp.Obj].ObCB[9] then
    begin
      if ObjZv[Sp.Obj].bP[25] or
      ObjZv[Sp.Obj].bP[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467);
      end;

      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472);
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- ��
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84);  //---------- ����������� ������������� ���������� ������� $
  end;

  if not ObjZv[Sp.Obj].bP[5] then //----------------------------------------- ��
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,85, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,85);  //---------------------------- ������� $ ������� � ��������
  end;

  if Con.Pin = 1 then //--------------------------------------------- ���� ����� � ����� 1
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ ��������� �������
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);  //----------------------------------- ������� $ �����
        end;

        if not ObjZv[Sp.Obj].ObCB[1] then //------- ��� �������� � ����������� 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //--------------------- "��� �������� ��������� �� $"
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[5] //-------------------------------- ���� ��� ��
        then ObjZv[Sp.Obj].bP[15] := true; //----------------------------------- 1��

        if not ObjZv[Sp.Obj].ObCB[3] then  //---- ��� ���������� � ����������� 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //--------------------- ��� ���������� ��������� �� $
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZv[Sp.Obj].bP[15] then //--------------------------------------- 1��
          begin
            MarhTrac.TailMsg :=' �� ������� ������� '+ObjZv[Sp.Obj].Liter;
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
  end else //-------------------------------------------------------- ���� ����� � ����� 2
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ ��������� �������
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
          InsMsg(Sp.Obj,161); //--------------------- "��� �������� ��������� �� $"
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
          InsMsg(Sp.Obj,162); //------------------- "��� ���������� ��������� �� $"
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZv[Sp.Obj].bP[16] then //--------------------------------------- 1��
          begin
            MarhTrac.TailMsg :=' �� ������� ������� '+ObjZv[Sp.Obj].Liter;
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
//----------------------------------------------------------- ����������� ��� ������������
function StepSpAutoTras(var Con:TSos; const Lvl:TTrLev; Rod:Byte; Sp:TSos) : TTrRes;
begin
  result := trNext;

  if not ObjZv[Sp.Obj].bP[2] {or not ObjZv[Sp.Obj].bP[7]} then //--- ���������
  exit;
  {
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,82, ObjZv[Sp.Obj].Liter,1); //---------------------- "������� $ �������"
    InsMsg(Sp.Obj,82);
  end;
  }
  if ObjZv[Sp.Obj].bP[12] or ObjZv[Sp.Obj].bP[13] then //---- ������ ��� ����.
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,134, ObjZv[Sp.Obj].Liter,1); //------- "������� $ ������ ��� ��������"
    InsMsg(Sp.Obj,134);
  end;

  if ObjZv[Sp.Obj].ObCB[8] or ObjZv[Sp.Obj].ObCB[9] then
  begin
    if ObjZv[Sp.Obj].bP[24] or
    ObjZv[Sp.Obj].bP[27] then //----------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Sp.Obj].Liter,1);
      InsWar(Sp.Obj,462);//------------------- ������� �������� �� ����������� �� $
    end else
    if ObjZv[Sp.Obj].ObCB[8] and ObjZv[Sp.Obj].ObCB[9] then
    begin
      if ObjZv[Sp.Obj].bP[25] or
      ObjZv[Sp.Obj].bP[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,467);
      end;

      if ObjZv[Sp.Obj].bP[26] or
      ObjZv[Sp.Obj].bP[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Sp.Obj].Liter,1);
        InsWar(Sp.Obj,472);
      end;
    end;
  end;

  if ObjZv[Sp.Obj].bP[3] then //------------------------------------------------- ��
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,84, ObjZv[Sp.Obj].Liter,1);
    InsMsg(Sp.Obj,84);//---------- "����������� ������������� ���������� ������� $"
  end;

  if not ObjZv[Sp.Obj].bP[5] then //--------------------------------------------- ��
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
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ ��������� �������
        begin
          exit;
          {
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);  //--------------- "������� $ �����"
          InsMsg(Sp.Obj,83);
          }
        end;

        if not ObjZv[Sp.Obj].ObCB[1] then   //------------------- ��� �������� 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,161, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,161); //--------------------- "��� �������� ��������� �� $"
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Sp.Obj].ObCB[5] then ObjZv[Sp.Obj].bP[15] := true;

        if not ObjZv[Sp.Obj].ObCB[3] then  //------------------ ��� ���������� 1->2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,162); //------------------- "��� ���������� ��������� �� $"
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZv[Sp.Obj].bP[15] then //--------------------------------------- 1��
          begin
            MarhTrac.TailMsg :=' �� ������� ������� '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83);    //----------------------------- "������� $ �����"
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);    //----------------------------- "������� $ �����"
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
        if not ObjZv[Sp.Obj].bP[1] then //------------------------ ��������� �������
        begin
          exit;
          {
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
          InsMsg(Sp.Obj,83);       //---------------------------- "������� $ �����"
          }
        end;
        if not ObjZv[Sp.Obj].ObCB[2] then    //---------------- ��� �������� 1 <- 2
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

        if not ObjZv[Sp.Obj].ObCB[4] then   //--------------- ��� ���������� 1 <- 2
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,162, ObjZv[Sp.Obj].Liter,1); InsMsg(Sp.Obj,162);
        end;

        if not ObjZv[Sp.Obj].bP[1] then
        begin //-------------------------------------------------------- ��������� �������
          if ObjZv[Sp.Obj].bP[16] then //--------------------------------------- 1��
          begin
            MarhTrac.TailMsg :=' �� ������� ������� '+ObjZv[Sp.Obj].Liter;
            MarhTrac.FindTail := false;
            inc(MarhTrac.WarN);
            MarhTrac.War[MarhTrac.WarN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsWar(Sp.Obj,83); //-------------------------------- "������� $ �����"
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,83, ObjZv[Sp.Obj].Liter,1);
            InsMsg(Sp.Obj,83);  //------------------------------- "������� $ �����"
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
  begin //------------------------------------------------------------------ ������� �����
    result := trBreak;
    exit;
  end else
  if ObjZv[Sp.Obj].bP[2] then
  begin //-------------------------------------------------- ������� �� ������� � ��������
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
  begin //------------------------------------------------------------------ ������� �����
    MarhTrac.IzvStrFUZ := true;
    if ObjZv[Sp.Obj].ObCB[5] then
    begin //-------------------------------------------------- ���� �� - ��������� �������
      if ObjZv[Sp.Obj].bP[2] or
      MarhTrac.IzvStrNZ then //------------------------------ ������� �� �������
      MarhTrac.IzvStrUZ := true;

      if MarhTrac.IzvStrNZ then //------------------------ ���� ������� � ������
      begin //------------------- �������� ��������� � ����������� �������� ����� ��������
        result := trStop;
        exit;
      end;
    end else
    begin //-------------------------------- ���� �� - ��������� ������� ������� �� ������
      if MarhTrac.IzvStrNZ then
      begin //---- ���� ������� - �������� ��������� � ����������� �������� ����� ��������
        MarhTrac.IzvStrUZ := true;
        result := trStop;
        exit;
      end;
    end;
  end else
  if MarhTrac.IzvStrFUZ then
  begin//-- ������� �������� � ���� ��������� ������� ����� ���-�� �������� ��������������
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

  if not ObjZv[Sp.Obj].bP[14] and //--------------- ��� ������������ ��������� � ...
  ObjZv[Sp.Obj].bP[7] then //------------------------ ��� ���������������� ���������
  begin //------------------------------------------------------ ��������� ������ ��������
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
  if Con.Pin = 1 then //--------------------------------- ����� �� ���� �� ������� ����� 1
  begin
    case Rod of
      MarshP :
        if ObjZv[Put.Obj].ObCB[1] then result := trNext
        else result := trStop;
      MarshM :
        if ObjZv[Put.Obj].ObCB[3] then result := trNext//���� ���� ������� 1->2
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
  end else   //------------------------------------------ ����� �� ���� �� ������� ����� 2
  begin
    case Rod of
      MarshP :
        if ObjZv[Put.Obj].ObCB[2] then result := trNext
        else result := trStop;

      MarshM :
        if ObjZv[Put.Obj].ObCB[4] then result := trNext//���� ���� ������� 1<-2
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
  //--------------------------------------------------------------- ���� ��� ���� ���� ���
  if UTS > 0 then
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- ���� ����������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Pt].Liter,1);
          InsMsg(Pt,108);  //---------------------- "���������� ��������� ����"
          MarhTrac.GonkaStrel := false;
        end else
        if not ObjZv[UTS].bP[1] and not ObjZv[UTS].bP[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          result := trBreak;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Pt].Liter,1);
          InsMsg(Pt,109);//------- "��������� ���� �� ����� �������� ���������"
          MarhTrac.GonkaStrel := false;
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZv[Pt].bP[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZv[UTS].bP[27] then
            begin //------------------------------------------- ��������� �� �������������
              ObjZv[ObjZv[Pt].BasOb].bP[27] := true;
              result := trBreak;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Pt].Liter,1);
              InsWar(Pt,108);  //------------------ "���������� ��������� ����"
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            result := trBreak;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Pt].Liter,1);
            InsMsg(Pt,108);  //-------------------- "���������� ��������� ����"
            MarhTrac.GonkaStrel := false;
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Pt].bP[12] or ObjZv[Pt].bP[13] then //- ������ ��� ��������
  begin
    result := trBreak;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Pt].Liter,1);
    InsMsg(Pt,135); //------------------------------ ���� $ ������ ��� ��������
    MarhTrac.GonkaStrel := false;
  end;

  if ObjZv[Pt].ObCB[8] or ObjZv[Pt].ObCB[9] then //--------- ���� ��
  begin
    if ObjZv[Pt].bP[24]
    or ObjZv[Pt].bP[27] then //-------------------- ������ ��� �������� �� ��.�.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Pt].Liter,1);
      InsWar(Pt,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZv[Pt].ObCB[8] and ObjZv[Pt].ObCB[9] then
    begin
      if ObjZv[Pt].bP[25] or
      ObjZv[Pt].bP[28] then //------------------- ������ ��� �������� �� ����.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Pt].Liter,1); InsWar(Pt,467);
      end;

      if ObjZv[Pt].bP[26] or
      ObjZv[Pt].bP[29] then //-------------------- ������ ��� �������� �� ���.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Pt].Liter,1);
        InsWar(Pt,472); //------------------------- ����� ���������� �������� $
      end;
    end;
  end;

  case Rod of
    MarshP : //---------------------------------------------------- ��� ��������� ��������
    begin
      if not MarhTrac.Povtor and   //---------- ���� �� ��������� �������� � ...
      (ObjZv[Pt].bP[14] or  //--------------- ����������� ��������� ��� ...
      not ObjZv[Pt].bP[7] or //-------- ��������������� ��������� ������ ��� ...
      not ObjZv[Pt].bP[11]) then //---------- ��������������� ��������� ��������
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,110, ObjZv[Pt].Liter,1);
        InsMsg(Pt,110);
        MarhTrac.GonkaStrel := false;
      end;

      if not (ObjZv[Pt].bP[1] and ObjZv[Pt].bP[16]) then //- ��������� � ��� �
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Pt].Liter,1);
        InsMsg(Pt,112); //-------------------------------------------- ���� $ �����
        MarhTrac.GonkaStrel := false;
      end;

      if Chi or Ni then //------------------------------------------------------ �� ��� ��
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,113, ObjZv[Pt].Liter,1);
        InsMsg(Pt,113);//------------------ �� ���� $ ���������� ���������� �������
        MarhTrac.GonkaStrel := false;
      end;

      if not (ObjZv[Pt].bP[5] and ObjZv[Pt].bP[6]) then //----------- ~��(�&�)
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Pt].Liter,1);
        InsMsg(Pt,111); //--------------------------- ���� $ ������� � ��������
        MarhTrac.GonkaStrel := false;
      end;

      //---------------------------------------------------------- ������  ������� �� ����
      //----------------------------------------------------------------------------------
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin //-----------  ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZv[Pt].ObCB[11] then  //-------------------- ����� �������.�������� �
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Pt].Liter,1);
          InsWar(Pt,473); //----------------------- ����� ���������� �������� $
        end;
      end else //------------------------------------------------ �������� ������� �� ����
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
        if ObjZv[Pt].ObCB[10] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Pt].Liter,1);
          InsWar(Pt,473);
        end;
      end;
    end;

    //--------------------------------------------------- ��� ����������� �������� �� ����
    MarshM :
    begin
      if not MarhTrac.Povtor and
      (ObjZv[Pt].bP[14] or //----------- ����������� ��������� �� ��-��� ��� ...
      not ObjZv[Pt].bP[7] or //-------- ��������������� ��������� FR3(�) ��� ...
      not ObjZv[Pt].bP[11]) then //-----------  ��������������� ��������� FR3(�)
      begin
        result := trBreak;
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,110, ObjZv[Pt].Liter,1);
        InsMsg(Pt,110); //----------------------- ����������� ��������� $ � ���
        MarhTrac.GonkaStrel := false;
      end;

      if not (ObjZv[Pt].bP[5] and ObjZv[Pt].bP[6]) then //--------- ~��(� & �)
      begin
        result := trBreak;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Pt].Liter,1);
        InsWar(Pt,111);   //----------------------------- ���� $ ������� � ��������
      end;

      //----------------------------------------------------------  ������ ������� �� ����
      if (((Con.Pin = 1) and OddRight) or ((Con.Pin = 2) and (not OddRight))) then
      begin
        if (not NKM and Ni) or Chi then//------------------------- �� ��� ��� ��� ����� ��
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Pt].Liter,1);
          result := trBreak;
          InsMsg(Pt,113); //----------- �� ���� $ ���������� ���������� �������
          MarhTrac.GonkaStrel := false;
        end else
        if Ni then //------------------------------------------------------------------ ��
        begin
          if NKM then //--------------------------------------------------------- ���� ���
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
              MarhTrac.TailMsg := ' �� ��������� ���� '+ ObjZv[Pt].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Pt].Liter,1);
              InsWar(Pt,441);// �� ���� ���������� ��������� ���������� �������
            end else
            begin //--------��� �������� ����� ������ ����� ������ ���������� ���� - �����
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Pt].Liter,1);
              InsMsg(Pt,113);//-------- �� ���� $ ���������� ���������� �������
              MarhTrac.GonkaStrel := false;
            end;
          end else
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Pt].Liter,1);
            InsMsg(Pt,113);//---------- �� ���� $ ���������� ���������� �������
            MarhTrac.GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end else //-------------------------------------------------------- �������� �������
      begin
        if (not ChKM and Chi) or Ni then //------ ����� ������ �������� ��� ����� ��������
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Pt].Liter,1);
          result := trBreak;
          InsMsg(Pt,113);//------------ �� ���� $ ���������� ���������� �������
          MarhTrac.GonkaStrel := false;
        end else
        if Chi then //----------------------------------------------------------------- ��
        begin
          if ChKM then //------------------------------------------------------------- ���
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
              MarhTrac.TailMsg :=  ' �� ��������� ���� '+ ObjZv[Pt].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Pt].Liter,1);
              InsWar(Pt,441);// �� ���� ���������� ��������� ���������� �������
            end else
            begin //------ ���� �������� ����� ������ ����� ������ ���������� ���� - �����
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Pt].Liter,1);
              InsMsg(Pt,113);//-------- �� ���� $ ���������� ���������� �������
              MarhTrac.GonkaStrel := false;
            end;
          end else //------------------------------------------------------------- ��� ���
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Pt].Liter,1);
            InsMsg(Pt,113);//---------- �� ���� $ ���������� ���������� �������
            MarhTrac.GonkaStrel := false;
          end;
          result := trBreak;
        end;
      end;

      if not (ObjZv[Pt].bP[1] and ObjZv[Pt].bP[16]) //- �����(� ��� �)
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
          MarhTrac.TailMsg := ' �� ������� ���� '+ ObjZv[Pt].Liter;
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

    else begin result := trStop; exit; end;  //------------------- ��� ���������� ��������
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

  if not ObjZv[put.Obj].bP[1] then //------------------------------------- ���� �����
  begin
    MarhTrac.TailMsg := ' �� ������� ���� '+ ObjZv[put.Obj].Liter;
    MarhTrac.FindTail := false;
  end;

  Con := ObjZv[put.Obj].Sosed[sosed]; //---------------------- ��������� ����� ������
  case Con.TypeJmp of
    LnkRgn : result := trEnd;
    LnkEnd : result := trStop;
    else  result := trNext;
  end;

  if result = trNext then  //--------------------------- ���� ������������ ���������
  begin
    ObjZv[put.Obj].bP[8] := true;  //------------------------ ����� ����. ���������
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
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- ���� ����������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Put.Obj].Liter,1); //------ ���������� ��������� ���� $
          InsMsg(Put.Obj,108);
        end else
        if not ObjZv[UTS].bP[1] and
        not ObjZv[UTS].bP[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Put.Obj].Liter,1);//----- ���� $ ��� �������� ���������
          InsMsg(Put.Obj,109);
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and  ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZv[Put.Obj].bP[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZv[UTS].bP[27] then//--------------- ��������� �� �������������
            begin
              ObjZv[UTS].bP[27] := true;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,108); //------------------- "���������� ��������� ����"
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,108);
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Put.Obj].bP[12] or ObjZv[Put.Obj].bP[13] then //-------------- �������� �������
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,135); //------------------------------ ���� $ ������ ��� ��������
  end;

  if ObjZv[Put.Obj].ObCB[8] or ObjZv[Put.Obj].ObCB[9] then
  begin
    if ObjZv[Put.Obj].bP[24] or ObjZv[Put.Obj].bP[27] then //------------ ������� �� ����.
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Put.Obj].Liter,1); //- ������� �������� �� ����������� �� $
      InsWar(Put.Obj,462);
    end else
    if ObjZv[Put.Obj].ObCB[8] and ObjZv[Put.Obj].ObCB[9] then
    begin
      if ObjZv[Put.Obj].bP[25] or ObjZv[Put.Obj].bP[28] then //---- ��� ����. -�
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Put.Obj].Liter,1); //-- ������� �������� �� �� ����. ����
        InsWar(Put.Obj,467);
      end;

      if ObjZv[Put.Obj].bP[26] or ObjZv[Put.Obj].bP[29] then //-------------- ��� ����. ~�
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Put.Obj].Liter,1);//-- ������� �������� �� �� ���.���� ��
        InsWar(Put.Obj,472);
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not(ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then //- �����(�&�)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1); //------------------------ ���� $ �����
        InsMsg(Put.Obj,112);
      end;

      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //--- ~��(�&�)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1); //----------- ���� $ ������� � ��������
        InsMsg(Put.Obj,111);
      end;

      if Con.Pin = 1 then //----------------------------- ����� �� ���� �� ������� ����� 1
      begin //------------ ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZv[Put.Obj].ObCB[11] then //------- ���� ������� ����� ���������� ����
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);//-------- ����� ���������� �������� $
          InsWar(Put.Obj,473);
        end;
      end else //---------------------------------------- ����� �� ���� �� ������� ����� 2
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
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
      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //--- ~��(�&�)
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1); //----------- ���� $ ������� � ��������
        InsWar(Put.Obj,111);
      end;

      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then //----- �����
      begin
        MarhTrac.TailMsg := ' �� ������� ���� '+ ObjZv[Put.Obj].Liter;
        MarhTrac.FindTail := false;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,112);
      end;
    end;

    else result := trStop;
  end;

  if (((Con.Pin = 1) and not OddRight)//--------- ����� �� ����� 1, �  �������� ������ ��� ...
  or ((Con.Pin = 2) and OddRight)) then //--------- ����� �� ����� 2, � �������� �����
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[1] then
        begin //-------------------------------------------- ��� �������� �������� �� ����
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);  //----------------------------- ������� �� ����������
        end else
        if ObjZv[Put.Obj].bP[3] or   //------------------------------- ��� �� ��� ...
        (not ObjZv[Put.Obj].bP[2] and ObjZv[Put.Obj].bP[4]) then //---- �� � ���
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //----------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
             //------------------------------ ���� ��� ���������� 1->2 ��� ����� � ����� 1
        if not ObjZv[Put.Obj].ObCB[3] or ObjZv[Put.Obj].ObCB[10] then
        begin //----------------------- �� ����� ���� �������� ���������� �������� �� ����
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);  //----------------------------- ������� �� ����������
        end;

        if (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4])//- �� ��� ���
        or  //-------------------------------------------------------------------- ��� ...
        (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15]) //-- �� ��� ���
        then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //-------------------------- ������ ���������� ������
        end;
      end;
    end;

    if ObjZv[Put.Obj].bP[3] and (ObjZv[Put.Obj].ObCI[4]<>0)
    then //------------------------------------------------ ��� ��, � ������ �� ����������
    begin
      inc(MarhTrac.MsgN);
      MarhTrac.Msg[MarhTrac.MsgN] :=
      GetSmsg(1,457, ObjZv[Put.Obj].Liter,1); //----------------------- ��� ���������
      InsMsg(Put.Obj,457);
    end;

    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else
  begin //------------------------------------------------- ����� �� ���� � ������ �������
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[2] then
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ ������� �� ����������
        end else
        if(ObjZv[Put.Obj].bP[2]) or //---------- ���� �� ��� ...
        (not ObjZv[Put.Obj].bP[3] and ObjZv[Put.Obj].bP[15]) then //------------- �� � ���
        begin
          if not ObjZv[Signal].bP[8] then
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,113); //-------------------- ���������� ���������� �������
          end;
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Put.Obj].ObCB[4] or ObjZv[Put.Obj].ObCB[11] then
        begin //------------------------------------ ��� �������� 1<-2 ��� ����� � ����� 2
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ ������� �� ����������
        end;

        if (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15])// �� ��� ���
        or  //-------------------------------------------------------------------- ��� ...
        (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4]) then//�� ��� ���
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //-------------------------- ������ ���������� ������
        end;
      end;
    end;

    if ObjZv[Put.Obj].bP[2] and (ObjZv[Put.Obj].ObCI[3]<>0)
    then //--------------------------------------------------------- ��� ��, � ������ ����
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
    ObjZv[Put.Obj].bP[14] := false;  //------------------------------ ����. ���������
    ObjZv[Put.Obj].bP[8]  := true;  //---------------------------------------- ������
    ObjZv[Put.Obj].iP[sosed+1] := 0; //------------------------------ ������ ��������
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
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- ���� ����������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,108); //------------------------- ���������� ��������� ����
        end else
        if not ObjZv[UTS].bP[1] and not ObjZv[UTS].bP[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,109);//------- ��������� ���� $ �� ����� �������� ���������
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZv[Put.Obj].bP[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZv[UTS].bP[27] then
            begin //------------------------------------------- ��������� �� �������������
              ObjZv[UTS].bP[27] := true;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,108); //--------------------- ���������� ��������� ����
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,108); //----------------------- ���������� ��������� ����
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Put.Obj].bP[14] or
  not ObjZv[Put.Obj].bP[7] or
  not ObjZv[Put.Obj].bP[11] then //----------- ���� ����������� ��������� �����������
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,110, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,110); //--------------------------- ����������� ��������� $ � ���
  end;

  if ObjZv[Put.Obj].bP[12] or ObjZv[Put.Obj].bP[13] then //- ������ ��� ��������
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,135);  //----------------------------- ���� $ ������ ��� ��������
  end;

  if ObjZv[Put.Obj].ObCB[8] or ObjZv[Put.Obj].ObCB[9] then //--- ���� ����� ��
  begin
    if ObjZv[Put.Obj].bP[24] or ObjZv[Put.Obj].bP[27] then //----- ������ ��� ��
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Put.Obj].Liter,1);
      InsWar(Put.Obj,462);  //----------------- ������� �������� �� ����������� �� $
    end else
    if ObjZv[Put.Obj].ObCB[8] and ObjZv[Put.Obj].ObCB[9] then
    begin
      if ObjZv[Put.Obj].bP[25] or ObjZv[Put.Obj].bP[28] then //������ �� ����.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,467);// ������� �������� �� ����������� ����������� ���� �� $
      end;

      if ObjZv[Put.Obj].bP[26] or ObjZv[Put.Obj].bP[29] then //������ ��� ���.�.
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,472); //������� �������� �� ����������� ����������� ���� �� $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // �����(�|�)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,112); //--------------------------------------- ���� $ �����#
      end;

      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //--- ~��(�&�)
      begin
        inc(MarhTrac.MsgN);  //-------------------------------- ������������
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,111);     //----------------------- ���� $ ������� � ��������
      end;

      if Con.Pin = 1 then
      begin //------------ ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZv[Put.Obj].ObCB[11] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473);//------------------------ ����� ���������� �������� $
        end;
      end else
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
        if ObjZv[Put.Obj].ObCB[10] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473); //----------------------- ����� ���������� �������� $
        end;
      end;
    end;

    MarshM :
    begin
      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then // ~��(�&�)
      begin
        inc(MarhTrac.WarN); //------------------------------- ��������������
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,111); //--------------------------- ���� $ ������� � ��������
      end;

      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // �����(�|�)
      begin
        MarhTrac.TailMsg := ' �� ������� ���� '+ ObjZv[Put.Obj].Liter;
        MarhTrac.FindTail := false;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,112);  //--------------------------------------- ���� $ �����
      end;
    end;

    else  result := trStop;
  end;

  if Con.Pin = 1 then    //------------------- ���� �� ���� � ����� 1 (� �������� �������)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[1] then
        begin //-------------------------------------------- ��� �������� �������� �� ����
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);
        end else
        if not(ObjZv[Put.Obj].bP[3] and ObjZv[Put.Obj].bP[2]) //--- �� ��� ��
        or  ObjZv[Put.Obj].bP[4] then //------------------------------------- ��� ���
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113); //----------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if (not ObjZv[Put.Obj].ObCB[10]) and (not ObjZv[Put.Obj].ObCB[11]) then
        begin
          if not ObjZv[Put.Obj].ObCB[3] then
          begin //---------------------------------------- ��� �������� ���������� �� ����
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,77); //---------------------------- ������� �� ����������
          end;

          if not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4] then//�� ��� ���
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,113); //----------- �� ���� $ ���������� ���������� �������
          end;

          if not ObjZv[Put.Obj].bP[3] then // -------------------------------------- ��
          begin
            if ObjZv[Put.Obj].bP[15] then //--------------------------------------- ���
            begin
              MarhTrac.TailMsg := ' �� ��������� ���� '+ ObjZv[Put.Obj].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,441); //�� ���� $ ���������� ��������� ���������� �������
            end else
            begin
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
              InsMsg(Put.Obj,113); //--------- �� ���� $ ���������� ���������� �������
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
  end else    //-------------------------------- ���� �� ���� � ����� 2 (� ������ �������)
  begin
    case Rod of
      MarshP : begin
        if not ObjZv[Put.Obj].ObCB[2] then
        begin //---------------------------------------------- ��� ������ �������� �� ����
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //----------------------------- ������� �� ����������
        end else
        if not ObjZv[Put.Obj].bP[2] or  //------------------------------------ �� ���
        (not ObjZv[Put.Obj].bP[3]) then //---------------------------------------  ��
        begin
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if(not ObjZv[Put.Obj].ObCB[10]) and (not ObjZv[Put.Obj].ObCB[11]) then
        begin
          if not ObjZv[Put.Obj].ObCB[4] then
          begin //------------------------------------------ ��� ������ ���������� �� ����
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,77); //---------------------------- ������� �� ����������
          end;

          if not ObjZv[Put.Obj].bP[3] and
          not (ObjZv[Put.Obj].bP[15] and ObjZv[Put.Obj].bP[2] and
          ObjZv[Put.Obj].bP[4]) then //---- �� � ��� � ���
          begin
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,113);  //-------- �� ���� $ ���������� ���������� �������
          end;

          if not ObjZv[Put.Obj].bP[2] then //-------------------------------- ���� ��
          begin
            if ObjZv[Put.Obj].bP[4] then //--------------------------------- ���� ���
            begin
              MarhTrac.TailMsg := ' �� ��������� ���� '+ ObjZv[Put.Obj].Liter;
              MarhTrac.FindTail := false;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,441, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,441); //�� ���� ���������� ��������� ���������� �������
            end else
            begin
              inc(MarhTrac.MsgN);
              MarhTrac.Msg[MarhTrac.MsgN] :=
              GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
              InsMsg(Put.Obj,113);//-------- �� ���� $ ���������� ���������� �������
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
  begin //------------------------------------------------------------------ ��������� ���
    case Rod of
      MarshP :
      begin
        if ObjZv[UTS].bP[2] then
        begin //---------------------------------------------------------- ���� ����������
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,108); //------------------------- ���������� ��������� ����
        end else
        if not ObjZv[UTS].bP[1] and not ObjZv[UTS].bP[3] then
        begin //--------------------------- ���� �� ����� �������� ��������� � �� ��������
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,109, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,109);//------- ��������� ���� $ �� ����� �������� ���������
        end;
      end;

      MarshM :
      begin
        if not ObjZv[UTS].bP[1] and ObjZv[UTS].bP[2] and
        not ObjZv[UTS].bP[3] then
        begin //-------------------------------------------- ���� ���������� � �� ��������
          if not ObjZv[Put.Obj].bP[1] then
          begin //------------------------------------------------------------- ���� �����
            if not ObjZv[UTS].bP[27] then
            begin //------------------------------------------- ��������� �� �������������
              ObjZv[UTS].bP[27] := true;
              result := trStop;
              inc(MarhTrac.WarN);
              MarhTrac.War[MarhTrac.WarN] :=
              GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
              InsWar(Put.Obj,108); //--------------------- ���������� ��������� ����
            end;
          end else
          begin //---------------------------------------------------------- ���� ��������
            result := trStop;
            inc(MarhTrac.MsgN);
            MarhTrac.Msg[MarhTrac.MsgN] :=
            GetSmsg(1,108, ObjZv[Put.Obj].Liter,1);
            InsMsg(Put.Obj,108); //----------------------- ���������� ��������� ����
          end;
        end;
      end;
    end;
  end;

  if ObjZv[Put.Obj].bP[14] then //----------------- ����������� ��������� �����������
  begin
    result := trStop;
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,110, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,110);  //-------------------------- ����������� ��������� $ � ���
  end;

  if ObjZv[Put.Obj].bP[12] or ObjZv[Put.Obj].bP[13] then //- ������ ��� ��������
  begin
    inc(MarhTrac.MsgN);
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,135, ObjZv[Put.Obj].Liter,1);
    InsMsg(Put.Obj,135); //------------------------------ ���� $ ������ ��� ��������
  end;

  if ObjZv[Put.Obj].ObCB[8] or ObjZv[Put.Obj].ObCB[9] then
  begin
    if ObjZv[Put.Obj].bP[24] or ObjZv[Put.Obj].bP[27] then //----- ������ ��� ��
    begin
      inc(MarhTrac.WarN);
      MarhTrac.War[MarhTrac.WarN] :=
      GetSmsg(1,462, ObjZv[Put.Obj].Liter,1);
      InsWar(Put.Obj,462); //------------------ ������� �������� �� ����������� �� $
    end else
    if ObjZv[Put.Obj].ObCB[8] and ObjZv[Put.Obj].ObCB[9] then
    begin
      if ObjZv[Put.Obj].bP[25] or ObjZv[Put.Obj].bP[28] then //- ������ ����. ��
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,467, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,467); //������� �������� �� ����������� ����������� ���� �� $
      end;

      if ObjZv[Put.Obj].bP[26] or ObjZv[Put.Obj].bP[29] then //-- ������ ���. ��
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,472, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,472); //������� �������� �� ����������� ����������� ���� �� $
      end;
    end;
  end;

  case Rod of
    MarshP :
    begin
      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // �����(�|�)
      begin
        exit;
        {
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,112); //---------------------------------------- ���� $ �����
        }
      end;

      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //---- ��(�|�)
      begin
        inc(MarhTrac.MsgN);
        MarhTrac.Msg[MarhTrac.MsgN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsMsg(Put.Obj,111); //--------------------------- ���� $ ������� � ��������
      end;

      if Con.Pin = 1 then
      begin //------------ ��������� ����� �������� ��������� ���� ��� ������� �����������
        if ObjZv[Put.Obj].ObCB[11] then
        begin
          inc(MarhTrac.WarN);
          MarhTrac.War[MarhTrac.WarN] :=
          GetSmsg(1,473, ObjZv[Put.Obj].Liter,1);
          InsWar(Put.Obj,473); //----------------------- ����� ���������� �������� $
        end;
      end else
      begin //---------- ��������� ����� �������� ��������� ���� ��� ��������� �����������
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
      if not (ObjZv[Put.Obj].bP[5] and ObjZv[Put.Obj].bP[6]) then //---- ��(�|�)
      begin
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,111, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,111);
      end;

      if not (ObjZv[Put.Obj].bP[1] and ObjZv[Put.Obj].bP[16]) then // �����(�|�)
      begin
        MarhTrac.TailMsg := ' �� ������� ���� '+ ObjZv[Put.Obj].Liter;
        MarhTrac.FindTail := false;
        inc(MarhTrac.WarN);
        MarhTrac.War[MarhTrac.WarN] :=
        GetSmsg(1,112, ObjZv[Put.Obj].Liter,1);
        InsWar(Put.Obj,112); //---------------------------------------- ���� $ �����
      end;
    end;

    else result := trStop;
  end;

  if (((Con.Pin = 1) and (not OddRight))
  or ((Con.Pin = 2) and OddRight)) then //------------------ ����� �� ������� 1 (��������)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[1] then
        begin //-------------------------------------------- ��� �������� �������� �� ����
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77);
        end else
        if not ObjZv[Put.Obj].bP[3] or (not ObjZv[Put.Obj].bP[2]
        and ObjZv[Put.Obj].bP[4]) then //---------------------------- �� ��� �� � ���
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Put.Obj].ObCB[3] then
        begin //------------------------------------------ ��� �������� ���������� �� ����
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ ������� �� ����������
        end;

        if (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15])// �� ��� ���
        or//-------------------------------------------------------------------------- ���
        (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4]) //--- �� ��� ���
        then
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;
    end;

    Con := ObjZv[Put.Obj].Sosed[2];
    case Con.TypeJmp of
      LnkRgn : result := trStop;
      LnkEnd : result := trStop;
    end;
  end else  //------------------------------------------------ ����� �� ������� 2 (������)
  begin
    case Rod of
      MarshP :
      begin
        if not ObjZv[Put.Obj].ObCB[2] then
        begin //---------------------------------------------- ��� ������ �������� �� ����
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ ������� �� ����������
        end else
        if not ObjZv[Put.Obj].bP[2] or //--------------------------------- �� ��� ...
        (not ObjZv[Put.Obj].bP[3] and ObjZv[Put.Obj].bP[15]) then //--- �� � ���
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
        end;
      end;

      MarshM :
      begin
        if not ObjZv[Put.Obj].ObCB[4] then
        begin //-------------------------------------------- ��� ������ ���������� �� ����
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,77, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,77); //------------------------------ ������� �� ����������
        end;

        if (not ObjZv[Put.Obj].bP[2] and not ObjZv[Put.Obj].bP[4]) // �� ��� ���
        or  //------------------------------------------------------------------------ ���
        (not ObjZv[Put.Obj].bP[3] and not ObjZv[Put.Obj].bP[15]) //-- �� ��� ���
        then
        begin
          result := trStop;
          inc(MarhTrac.MsgN);
          MarhTrac.Msg[MarhTrac.MsgN] :=
          GetSmsg(1,113, ObjZv[Put.Obj].Liter,1);
          InsMsg(Put.Obj,113);  //---------- �� ���� $ ���������� ���������� �������
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
  begin //--------------------------------------------------------------------- ���� �����
    result := trBreak;
    exit;
  end else
  if ObjZv[Put.Obj].bP[2] and ObjZv[Put.Obj].bP[3] then
  begin //----------------------------------------------------- ���� �� ������� � ��������
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
  begin //------------------------------------------------------------------ ������� �����
    MarhTrac.IzvStrFUZ := true;
    if MarhTrac.IzvStrNZ then
    begin //------ ���� ������� - �������� ��������� � ����������� �������� ����� ��������
      MarhTrac.IzvStrUZ := true;
      result := trStop;
      exit;
    end;
  end else
  if MarhTrac.IzvStrFUZ then
  begin //������� �������� � ���� ��������� ������� ����� ��� - �� �������� ��������������
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
  begin //------------------------------------------------------ ��������� ������ ��������
    MarhTrac.Msg[MarhTrac.MsgN] :=
    GetSmsg(1,228, ObjZv[MarhTrac.ObjStart].Liter,1);
    InsMsg(Put.Obj,228); //--------------------------- ������ �������� �� $ ��������
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

