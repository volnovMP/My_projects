unit CMenu;
//------------------------------------------------------------------------------
//  ������������ ����
//------------------------------------------------------------------------------
{$INCLUDE d:\sapr2012\CfgProject}

interface

uses
  Windows,
  SysUtils,
  Menus,
  Graphics;

function NewMenu_(ID, X, Y : SmallInt) : Boolean;
function NewMenu_Strelka(X, Y : SmallInt) : Boolean;
function NewMenu_Svetofor(X,Y : SmallInt): boolean;
function NewMenu_AvtoSvetofor(X,Y : SmallInt): boolean;
function NewMenu_1bit(X,Y : SmallInt): boolean;
function NewMenu_2bit(X,Y : SmallInt): boolean;
function NewMenu_PrzdZakrOtkr(X,Y : SmallInt): boolean;
function NewMenu_ZaprRazrMont(X,Y : SmallInt): boolean;
function NewMenu_VklOtkl1bit(X,Y : SmallInt): boolean;
function NewMenu_VydPSogl(X,Y : SmallInt): boolean;
function NewMenu_Nadvig(X,Y : SmallInt): boolean;
function NewMenu_OPI(X,Y : SmallInt): boolean;
function NewMenu_Uchastok(X,Y : SmallInt): boolean;
function NewMenu_PutPO(X,Y : SmallInt): boolean;
function NewMenu_PSogl(X,Y : SmallInt): boolean;
function NewMenu_SmenaNapravleniya(X,Y : SmallInt;var gotomenu : boolean): boolean;
function NewMenu_KSN(X,Y : SmallInt): boolean;
function NewMenu_PAB(X,Y : SmallInt): boolean;
function NewMenu_ManKol(X,Y : SmallInt): boolean;
function NewMenu_ZamykStr(X,Y : SmallInt): boolean;
function NewMenu_RazmykanieStrelok(X,Y : SmallInt): boolean;
function NewMenu_ZakrytPereezd(X,Y : SmallInt): boolean;
function NewMenu_OtkrytPereezd(X,Y : SmallInt): boolean;
function NewMenu_Otkl_ZapretMont(X,Y : SmallInt): boolean;
function NewMenu_PoezdOpov(X,Y : SmallInt): boolean;
function NewMenu_IzvPereezd(X,Y : SmallInt): boolean;
function NewMenu_ZapretMont(X,Y : SmallInt): boolean;
function NewMenu_OtklUKSPS(X,Y : SmallInt): boolean;
function NewMenu_VspomPriem(X,Y : SmallInt): boolean;
function NewMenu_VspOtpr(X,Y : SmallInt): boolean;
function NewMenu_OchistkaStrelok(X,Y : SmallInt): boolean;
function NewMenu_VklGRI1(X,Y : SmallInt): boolean;
function NewMenu_PutIzvst(X,Y : SmallInt): boolean;
function NewMenu_DSNLamp(X,Y : SmallInt): boolean;
function NewMenu_RezymLampDen(X,Y : SmallInt): boolean;
function NewMenu_RezymLampNoch(X,Y : SmallInt): boolean;
function NewMenu_RezymLampAuto(X,Y : SmallInt): boolean;
function NewMenu_OtklZvonkaUKSPS(X,Y : SmallInt): boolean;
function NewMenu_OtklUKG(X,Y : SmallInt): boolean;
function NewMenu_VklUKG(X,Y : SmallInt): boolean;
function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
function LockDirect : Boolean;
function Spec_Reg(ID_Obj : SmallInt) : Boolean;
function NotStr(ID_Obj : SmallInt) : Boolean;
function NazataKOK(ID_Obj : SmallInt) : Boolean;
function ActivenVSP(ID_Obj : SmallInt) : Boolean;
function Trassir : Boolean;


{$IFDEF RMDSP}
function CheckStartTrace(Index : SmallInt) : string;
function CheckAutoON(Index : SmallInt) : Boolean;
function CheckProtag(Index : SmallInt) : Boolean;
function CheckMaket : Boolean;
procedure MakeMenu(var X : smallint);
{$ENDIF}

const
_WIN32_WINNT = $501;
//------------------------------------------------------------------------ ���� ����� ����
ID_Strelka             = 1;  //-------- �������� � Tablo ����������� ������������� �� ����
ID_SvetoforManevr      = 2;  //-------- �������� � Tablo ����������� ������������� �� ����
ID_Uchastok            = 3;  //-------- �������� � Tablo ����������� ������������� �� ����
ID_PutPO               = 4;  //-------- �������� � Tablo ����������� ������������� �� ����
ID_ZamykStr            = 5;  //----------------------- ��������� ������� ��������� �������
ID_RazmykStr           = 6;  //---------------------- ���������� ������� ��������� �������
ID_ZakrytPereezd       = 7;  //----------------------  �������� �������� (������� �������)
ID_OtkrytPereezd       = 8;  //----------------- �������� �������� (������������� �������)
ID_IzvPer              = 9;  //---------------------- ������ / ������ ��������� �� �������
ID_PoezdOpov           = 10; //--------------- ��������� / ���������� ��������� ����������
ID_ZapMont             = 11; //---------------------  ��������� ������� �������� (�������)
ID_VykluchenieUKSPS    = 12; //---------- ���������� ����� �� ������������ (�������������)
ID_SmenaNapravleniya   = 13; //------------------------------- ����� ����������� (�������)
ID_VspomPriem          = 14; //--------------------- ��������������� ����� (�������������)
ID_VspomOtpravlenie    = 15; //--------------- ��������������� ����������� (�������������)
ID_OchistkaStrelok     = 16; //---------------------------------- �������(�������) �������
ID_VkluchenieGRI1      = 17; //-------------------- ��������� �������� ��� (�������������)
ID_PutManevrovyi       = 18; //---------- ������� ��������� �� ������ (����/���� ��������)
ID_SvetoforSovmech     = 19; //-------- �������� � Tablo ����������� ������������� �� ����
ID_SvetoforVhodnoy     = 20; //-------- �������� � Tablo ����������� ������������� �� ����
ID_VydPSogl            = 21; //------------------------ ������ ��������� �������� �� �����
ID_ZaprPSogl           = 22; //--------------- ������ ��������� �������� (��� �����������)
ID_ManKol              = 23; //---------------------------------------- ���������� �������
ID_RezymPitaniyaLamp   = 24; //------------------------------ ��������� ������� ���� "���"
ID_RezymLampDen        = 25; //------------ ��������� ������ ������� ���� ��������� "����"
ID_RezymLampNoch       = 26; //------------ ��������� ������ ������� ���� ��������� "����"
ID_RezymLampAuto       = 27; //--------------- ������� ����� ������� ���� ��������� � ����
ID_OtklZvonkaUKSPS     = 28; //----------------------------------- ���������� ������ �����
ID_PAB                 = 29; //----------------------------- ������������������ ����������
ID_Nadvig              = 30; //---------------------------------------------------- ������
ID_KSN                 = 31; //---------------------------------- ����������� ��������� ��
ID_OPI                 = 32; //------------------------------- ���������� ���� �� ��������
ID_AutoSvetofor        = 33; //----------------------------- ��������� ������ ������������
ID_Tracert             = 34; //--------------------------- ����������� �� �������� �������
ID_GroupDat            = 35; //------------------------- ������ ������� �������� �� ��� ��
ID_1bit                = 36; //----------------------------- ��������� / ���������� ���� 1
ID_2bit                = 37; //----------------------------- ��������� / ���������� ���� 2
ID_3bit                = 38; //----------------------------- ��������� / ���������� ���� 3
ID_4bit                = 39; //----------------------------- ��������� / ���������� ���� 4
ID_5bit                = 40; //----------------------------- ��������� / ���������� ���� 5
ID_OtklZapMont         = 41; //------- ������������� ���������� ������� �������� � 2� ����
ID_VklUKG              = 42; //--------------------------------- ������� � ����������� ���
ID_OtklUKG             = 43; //------------- ��������� ��� �� ������������ (�������������)
ID_VklOtkl_bit1        = 44; //----- ��������/��������� ������ 1-�� ���� � ������ ��������
ID_IzvPer1             = 45; //------- ���������� ���������� �������� ����� ������ �������
ID_PrzdZakrOtkr        = 46; //---------------- �������� / �������� �������� ����� �������
ID_ZaprRazrMont        = 47; //---------------- ������ / ���������� �������� ����� �������

//--------------------------------------------- ������� ���� -----------------------------
//-------------------------------------------------------------------- ������� ��� �������
M_StrPerevodPlus         = 1;
M_StrPerevodMinus        = 2;
M_StrVPerevodPlus        = 3;
M_StrVPerevodMinus       = 4;
M_StrOtklUpravlenie      = 5;
M_StrVklUpravlenie       = 6;
M_StrZakrytDvizenie      = 7;
M_StrOtkrytDvizenie      = 8;
M_UstMaketStrelki        = 9; //------------------------------ ���������� ������� �� �����
M_SnatMaketStrelki      = 10; //----------------------------------- ����� ������� � ������
M_StrMPerevodPlus       = 11;
M_StrMPerevodMinus      = 12;
M_StrZakryt2Dvizenie    = 13;
M_StrOtkryt2Dvizenie    = 14;
M_StrZakrytProtDvizenie = 15;
M_StrOtkrytProtDvizenie = 16;
//                      = 17 - 20 ------------------------------------------------- ������
//------------------------------------------------------------------- ������� ��� ��������
M_OtkrytManevrovym       = 21;
M_OtkrytPoezdnym         = 22;
M_OtmenaManevrovogo      = 23;
M_OtmenaPoezdnogo        = 24;
M_PovtorManevrovogo      = 25;
M_PovtorPoezdnogo        = 26;
M_BlokirovkaSvet         = 27;
M_DeblokirovkaSvet       = 28;
M_BeginMarshManevr       = 29;
M_BeginMarshPoezd        = 30;
M_DatPoezdnoeSoglasie    = 31;
M_SnatPoezdnoeSoglasie   = 32;
M_OtkrytProtjag          = 33;
M_PovtorManevrMarsh      = 34;
M_PovtorPoezdMarsh       = 35;
M_OtkrytAuto             = 36;
M_AutoMarshVkl           = 37;
M_AutoMarshOtkl          = 38;
M_PovtorOtkrytManevr     = 39;
M_PovtorOtkrytPoezd      = 40;
//------------------------------------------------------------------------- ������� ��� ��
M_SekciaPredvaritRI      = 41;
M_SekciaIspolnitRI       = 42;
M_SekciaZakrytDvijenie   = 43;
M_SekciaOtkrytDvijenie   = 44;
M_SekciaZakrytDvijenieET = 45;
M_SekciaOtkrytDvijenieET = 46;
M_SekciaZakrytDvijenieETA= 47;
M_SekciaOtkrytDvijenieETA= 48;
M_SekciaZakrytDvijenieETD= 49;
M_SekciaOtkrytDvijenieETD= 50;
//----------------------------------------------------------------------- ������� ��� ����
M_PutDatSoglasieOgrady   = 51;
//                       = 52 ----------------------------------------------------- ������
M_PutZakrytDvijenie      = 53;
M_PutOtkrytDvijenie      = 54;
M_PutZakrytDvijenieET    = 55;
M_PutOtkrytDvijenieET    = 56;
M_PutZakrytDvijenieETA   = 57;
M_PutOtkrytDvijenieETA   = 58;
M_PutZakrytDvijenieETD   = 59;
M_PutOtkrytDvijenieETD   = 60;
M_ZamykanieStrelok       = 61;
M_PredvRazmykanStrelok   = 62;
M_IspolRazmykanStrelok   = 63;
M_VklDSN                 = 64; //-------------------------------------------- �������� ���
M_OtklDSN                = 65; //------------------------------------------- ��������� ���
M_VklBit1_1              = 66;//--------------------------- �������� ��� 1 ������� �������
M_VklBit1_2              = 67;//--------------------------- �������� ��� 1 ������� �������
//---------------------- = 68 - 70 ------------------------------------------------ ������
M_ZakrytPereezd          = 71;
M_PredvOtkrytPereezd     = 72;
M_IspolOtkrytPereezd     = 73;
M_DatIzvecheniePereezd   = 74;
M_SnatIzvecheniePereezd  = 75;
M_PredvZakrPereezd       = 76;
M_IspolZakrPereezd       = 77;
//---------------------- = 78 - 80 ------------------------------------------------ ������
M_DatOpovechenie         = 81;
M_SnatOpovechenie        = 82;
M_DatZapretMonteram      = 83;//-------- ���������� ������� ������� �����. ������� ��� ���
M_SnatZapretMonteram     = 84;//----------- ������� ���-����������� ������� ������ �������

M_PredOtklBit3           = 85; //-------- ���������� ������� ��������������� ������ ���� 3
M_IspolOtklBit3          = 86; //--------- ���������� ������� �������������� ������ ���� 3

M_PredvOtklZapMont       = 87;//-------- ���������� ������� ��������������� ������ �������
M_IspolOtklZapMont       = 88;//--------- ���������� ������� �������������� ������ �������
//---------------------- = 89..90 ------------------------------------------------- ������
M_PredvOtkluchenieUKSPS  = 91;
M_IspolOtkluchenieUKSPS  = 92;
M_OtklZvonkaUKSPS        = 93;
M_OtmenaOtkluchenieUKSPS = 94;
//----------------------------------------------------------------------------------------
M_PredvOtkluchenieUKG    = 95;
M_IspolOtkluchenieUKG    = 96;
M_OtmenaOtkluchenieUKG   = 97;
//                       =  98 - 100 ---------------------------------------------- ������
M_SmenaNapravleniya      = 101;
M_DatSoglasieSmenyNapr   = 102;
M_ZakrytPeregon          = 103;
M_OtkrytPeregon          = 104;
M_PredvVspomOtpravlenie  = 105;
M_IspolVspomOtpravlenie  = 106;
M_PredvVspomPriem        = 107;
M_IspolVspomPriem        = 108;
M_VklKSN                 = 109;
M_OtklKSN                = 110;
//
M_VkluchOchistkuStrelok  = 111;
M_OtklOchistkuStrelok    = 112;
M_VkluchenieGRI          = 113;
//                       = 114 ---------------------------------------------------- ������
M_ZaprosPoezdSoglasiya   = 115;
M_OtmZaprosPoezdSoglasiya= 116;
//                       = 117 - 120 ---------------------------------------------- ������
M_DatRazreshenieManevrov = 121;
M_OtmenaManevrov         = 122;
M_PredvIRManevrov        = 123;
M_IspolIRManevrov        = 124;
//---------------------- = 125 - 130 ---------------------------------------------- ������
M_VkluchitDen            = 131;
M_VkluchitNoch           = 132;
M_VkluchitAuto           = 133;
M_OtkluchitAuto          = 134;
//
M_Osnovnoy               = 135;
//                       = 136; //------------------------------------------------- ������
M_RU1                    = 137;
M_RU2                    = 138;
M_ResetCommandBuffers    = 139;
//                       = 140 ---------------------------------------------------- ������
//------------------------------------------------------------------------------------ ���
M_VydatSoglasieOtpravl   = 141;
M_OtmenaSoglasieOtpravl  = 142;
M_IskPribytiePredv       = 143;
M_IskPribytieIspolnit    = 144;
M_VydatPribytiePoezda    = 145;
M_ZakrytPeregonPAB       = 146;
M_OtkrytPeregonPAB       = 147;
//                       = 148 - 150 ---------------------------------------------- ������
//--------------------------------------------------------------------- ���������� �������
M_BlokirovkaNadviga      = 151;
M_DeblokirovkaNadviga    = 152;
//---------------------------------------------------------------------- ���������� ������
M_OtkrytUvjazki          = 153;
M_ZakrytUvjazki          = 154;
//                       = 155 - 159 ---------------------------------------------- ������
M_RestartServera         = 160;
M_RestartUVK             = 161;
M_SnatSoglasieSmenyNapr  = 162; //----------------------------------------------------- ��
M_PutVklOPI              = 163; //--------------------------------------------------- ����
M_PutOtklOPI             = 164; //--------------------------------------------------- ����
M_ABZakrytDvijenieET     = 165;
M_ABOtkrytDvijenieET     = 166;
M_ABZakrytDvijenieETA    = 167;
M_ABOtkrytDvijenieETA    = 168;
M_ABZakrytDvijenieETD    = 169;
M_ABOtkrytDvijenieETD    = 170;
M_RPBZakrytDvijenieET    = 171;
M_RPBOtkrytDvijenieET    = 172;
M_RPBZakrytDvijenieETA   = 173;
M_RPBOtkrytDvijenieETA   = 174;
M_RPBZakrytDvijenieETD   = 175;
M_RPBOtkrytDvijenieETD   = 176;
M_EZZakrytDvijenieET     = 177;
M_EZOtkrytDvijenieET     = 178;
M_EZZakrytDvijenieETA    = 179;
M_EZOtkrytDvijenieETA    = 180;
M_EZZakrytDvijenieETD    = 181;
M_EZOtkrytDvijenieETD    = 182;
M_MEZZakrytDvijenieET    = 183;
M_MEZOtkrytDvijenieET    = 184;
M_MEZZakrytDvijenieETA   = 185;
M_MEZOtkrytDvijenieETA   = 186;
M_MEZZakrytDvijenieETD   = 187;
M_MEZOtkrytDvijenieETD   = 188;
M_RescueOTU              = 189; //----------------------------- ������������ ��������� ���
M_VklBit1                = 191; //----------------------------- �������� ��� ������� ��� 1
M_OtklBit1               = 192; //---------------------------- ��������� ��� ������� ��� 1
M_VklBit2                = 193; //----------------------------- �������� ��� ������� ��� 2
M_OtklBit2               = 194; //---------------------------- ��������� ��� ������� ��� 2
M_VklBit3                = 195; //----------------------------- �������� ��� ������� ��� 3
M_OtklBit3               = 196; //---------------------------- ��������� ��� ������� ��� 3
M_VklBit4                = 197; //----------------------------- �������� ��� ������� ��� 4
M_OtklBit4               = 198; //---------------------------- ��������� ��� ������� ��� 4
M_VklBit5                = 199; //----------------------------- �������� ��� ������� ��� 5
M_OtklBit5               = 200; //---------------------------- ��������� ��� ������� ��� 5
//---------------------------------------------------------------- ���� ������-������ ����
Key_RazdeRejim           = 1001; //---------------------- ���������� ����� ���������� <F1>
Key_MarshRejim           = 1002; //---------------------- ���������� ����� ���������� <F1>
Key_MaketStrelki         = 1003; //--------------------------- ���������� ������� �� �����
Key_OtmenMarsh           = 1004; //--------------------------------------- ������ ��������
Key_DateTime             = 1005; //--------------------------------- ���������� ����� <F2>
Key_InputOgr             = 1006; //--------------------------- ������� �� ���� �����������
Key_VspPerStrel          = 1007; //----------------------- ��������������� ������� �������
Key_EndTrace             = 1008; //--------------------------- ����� ������ �������� <End>
Key_ClearTrace           = 1009; //------------------------------------------- <Shift+End>
Key_RejimRaboty          = 1010; //----------------------- ������ ����� ������ ������ ����
Key_ReadyResetTrace      = 1011; //---- ���� ������ ������ ������ �������� �� ������������
Key_EndTraceError        = 1012; //-------- �������� ����� ������ �������� ������� �������
Key_ReadyWarningTrace    = 1013; //------------ �������� ������������� ��������� �� ������
Key_ReadyWarningEnd      = 1014; //------ �������� ������������� ��������� �� ����� ������
Key_BellOff              = 1015; //------------------------------- ���������� ������ <F12>
Key_UpravlenieUVK        = 1016; //----------------------------------- ���� ���������� ���
Key_ReadyRestartServera  = 1017; //------------ �������� ������������� ����������� �������
Key_ReadyRestartUVK      = 1018; //--------------- �������� ������������� ������������ ���
Key_RezervARM            = 1019; //------------------------ ������� �������� ���� � ������
Key_QuerySetTrace        = 1020; //------- ������ �� ��������� ������� �� ��������� ������
Key_PodsvetkaStrelok     = 1021; //-------------------- ������ ��������� ��������� �������
Key_VvodNomeraPoezda     = 1022; //---------------------------- ������ ����� ������ ������
Key_PodsvetkaNomerov     = 1023; //----------------------- ������ ��������� ������ �������
Key_ReadyRescueOTU       = 1024; //-- ���� ������������� �������������� ���������� ��� ���
NetKomandy : string = '��� �������';

var
  IndexFR3IK : SmallInt; //--------- ������ ������� ����������� ��� ��� �������������� ���
  Stol       : TPoint; //--------------- ������ �������� ����� �� ����� ������� ���������

{$IFDEF RMARC}  cmdmnu : string; {$ENDIF}

 msg : string;

 bit_for_kom : integer;

implementation
uses
  Commons, TypeALL,

{$IFDEF RMARC}  TabloFormARC, {$ENDIF}

{$IFNDEF TABLO} Marshrut, {$ENDIF}

{$IFDEF RMSHN}  ValueList, TabloSHN, {$ENDIF}

{$IFDEF RMDSP}  TabloDSP, {$ENDIF}

{$IFDEF TABLO} TabloForm1, {$ENDIF}

Commands;

//========================================================================================
//------------------------------------------------------- ������� ���������� ������ � ����
function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
begin
    result := true;
{$IFNDEF RMARC}
{$IFNDEF TABLO}
    //----------------- ���� ��� ������� ���� ����� � ������� �� ������ � ������ �� ������
    if (DspMenu.Count < Length(DspMenu.Items)) and (ID_Cmd > 0) and (ID_Obj > 0) then
    begin
      inc(DspMenu.Count);  //------------------------------ ��������� ������� ������� ����
      //--------------------------------------------------------------- ������� ����� ����
      DspMenu.Items[DspMenu.Count].MenuItem := TMenuItem.Create(TabloMain);

      //--------------------------------- ���������� ���������� ��� "�����" �� ������ ����
      DspMenu.Items[DspMenu.Count].MenuItem.OnClick := TabloMain.DspPopUpHandler;

      //------------------------------------------- ���������� ��� ������� ��� ������ ����
      DspMenu.Items[DspMenu.Count].ID := DspMenu.Items[DspMenu.Count].MenuItem.Command;

      //------------------------------------------------ ���������� ������ ��� ������ ����
      DspMenu.Items[DspMenu.Count].Obj := ID_Obj;
      DspMenu.Items[DspMenu.Count].Command := ID_Cmd;
      DspMenu.Items[DspMenu.Count].MenuItem.Caption := Caption;
      DspMenu.Items[DspMenu.Count].MenuItem.AutoHotkeys := maManual;
      result := true;
    end else
    begin
      MessageBeep(MB_ICONQUESTION);
      result := false;
    end;
{$ENDIF}
{$ENDIF}
end;
//========================================================================================
//--------------------------------------- ��������� ������� ���������� ���� (��������) ���
function NewMenu_(ID,X,Y : SmallInt): boolean;
//------------------------------------------------ ID = ��� ���������, �������� � ��������
//--------------------------------------------------------------- X,Y = ���������� �������
//------------------ ���� ���������� true - ���� ��������� ��������� �������� ����� ������
var
  i,j,color       : integer;
  gotomen, Trans  : Boolean;
  test_long       : LongInt;
  hMenuWnd        : HWND;
  hMenuDC         : HDC;
  dwStyle         : DWORD;
  t0              : TPoint;
  TXT             : string;
begin
  ObjHintIndex := 0;
  {$IFDEF RMARC}
  if (ID_Obj > 0) and (ID_Obj < WorkMode.LimitObjZav) then
  cmdmnu := DateTimeToStr(CurrentTime)+ ' > '+ ObjZv[ID_Obj].Liter
  else cmdmnu := DateTimeToStr(CurrentTime)+ ' > ';
  {$ELSE}
  SetLockHint; //-------------------------------- ���������� ������ �������� ������� �����
  {$ENDIF}
  DspCom.Active := false; //-------- �������� ������� ������� �������, ��������� ���������
  DspCom.Com := 0;   //---------------------------------------------- �������� ��� �������
  DspCom.Obj := 0;       //--------------------------------------- �������� ������ �������

  DspMenu.Ready := false;    //------------------ �������� ������� �������� ������ �������
  DspMenu.obj := cur_obj; //------------------------- ��������� ����� ������� ��� ��������
  DspMenu.Count := 0; //----------------------------------------- ����� ����� ������� ����
{$IFNDEF RMARC}
  RSTMsg;
  ShowWarning := false;
{$ENDIF}

  result := false;
//------------------------------------------------------------ ��������� ����� ������ ����
{$IFDEF RMDSP}
  msg := '';
  InsNewArmCmd(DspMenu.obj+$8000,ID); //--- �������� ��� ���� � �������� ��������� (�����)
  //---------------------- ����������� �������, ����������� � ������ ���������� ����������
  case ID of
    Key_PodsvetkaStrelok,   //--------------------------- ��������� ��������� ������� 1021
    Key_VvodNomeraPoezda, //-------------------------------------- ���� ������ ������ 1022
    Key_PodsvetkaNomerov,  //------------------------------- ��������� ������ ������� 1023
    Key_BellOff ://----------------------------------- ����� ������������ ������ 1015 <F12
    begin
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      exit;
    end;
    //##################################################################################
    Key_DateTime : //------------------------------------------------------- 1005 <F2>
    begin //---------------------------------------------------------- ���� ������� ��-���
      DspCom.Active := true;  DspCom.Com := ID;  DspCom.Obj := 0;
      if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 / 24) then
      begin
        //------------------------------------------------------------- "�������� ����� ?"
        InsNewMsg(0,252+$4000,0,''); color := 0;
        msg := GetSmsg(1,252,'',color); DspMenu.WC := true; MakeMenu(X); exit;
      end else
      begin
        InsNewMsg(0,435+$4000,1,'');//---- "��������� ������� � 22:55 �� 01:05 ���������!"
        ShowSMsg(435,LastX,LastY,''); DspMenu.WC := true; exit;
      end;
    end;
    //##################################################################################
    Key_ClearTrace : //-------------------------------------------------- 1009 <Shift+End>
    begin //----------------------------- ����� ����������� ��������, ����� ������� ������
      if (CmdCnt > 0) or WorkMode.MarhRdy or WorkMode.CmdReady then
      begin
        DspCom.Active := true; DspCom.Com := ID;  DspCom.Obj := 0;
      end;
      exit;
    end;
    //##################################################################################
    Key_RejimRaboty : //------------------------------------ 1010 ����� ������ ������ ����
    begin
      if config.configKRU > 0 then exit;
      if WorkMode.CmdReady then // ���� ������ �������� ������������.����� �� �����.
      begin
        InsNewMsg(0,251+$4000,1,''); ShowSmsg(251,LastX,LastY,''); exit;
      end;

      if WorkMode.Upravlenie then
      begin //--------------------------------------------------------���� ��� �����������
        if ((StateRU and $40) = 0) or WorkMode.BU[0] then
        begin //--------------------------- ���� �� ������� "����� ��" ��� �������� ������
          DspCom.Active := true;
          DspCom.Com := Key_RezervARM;
          color := 7;
          InsNewMsg(0,225+$4000,color,''); //------ "����������� ������� ���-��� � ������"
          msg := GetSmsg(1,225,'',color);
          DspMenu.WC := true;
          result := true;
          MakeMenu(X);
          exit;
        end;
      end
      else
      begin //--------------------------------------------------------- ���� ��� � �������
        if WorkMode.OtvKom then
        begin
          InsNewMsg(0,224+$4000,0,''); //-------------------------- "�������� ����������?"
          //------------------------------------------------------ M_Osnovnoy = 135;
          color := 0;
          AddDspMenuItem(GetSmsg(1,224,'',color),M_Osnovnoy,ID_Obj);
          DspMenu.WC := true;//--------------------------------------- ����� �������������
          MakeMenu(X);
          exit;
        end else
        begin //------------------------------------ �� ������ ������ ������������� ������
          InsNewMsg(0,276,1,''); //------------------------- "�������� ������� ������� ��"
          ShowSmsg(276,LastX,LastY,'');
          SimpleBeep;
          color := 1;
          msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,color);
          DspMenu.WC := true;
          exit;
        end;
      end;
    end;
    //##################################################################################
    Key_UpravlenieUVK ://-------------------------------------------------------- 1016
    begin //----------------------------------------------- ������� ���������� ������� ���
      if WorkMode.CmdReady then
      begin
        InsNewMsg(0,251+$4000,1,'');//-- ���� ������ �������� ������������. ����� �� �����
        ShowSmsg(251,LastX,LastY,'');
        exit;
      end;
      if WorkMode.OtvKom then //------------------------------------ ���� ������ ������ ��
      begin
        if config.configKRU = 0 then
        begin
          InsNewMsg(0,347+$4000,7,'');//------------ "������ ������� ����������� �������?"
          color := 7;
          AddDspMenuItem(GetSmsg(1,347,'',color),M_RestartServera,ID_Obj);
        end;
        for i := 1 to high(ObjZv) do //---- ������ ���� �� �������� ����������� ���� ����
        begin
          if ObjZv[i].TypeObj = 37 then //-------------- ���� ��� ������ ����������� ����
          begin
            InsNewMsg(i,348+$4000,7,'');//--- "������ ������� ������������ ���������� ��?"
            color := 7;
            AddDspMenuItem(GetSmsg(1,348,ObjZv[i].Liter,color),M_RestartUVK,i);
            if ObjZv[i].ObCB[1] then//----------- ���� ���� ������ - ���������� ����
            begin
              InsNewMsg(i,505+$4000,7,''); //------------ "������������ ��������� ��� ��?"
              color := 7;
              AddDspMenuItem(GetSmsg(1,505,ObjZv[i].Liter,color),M_RescueOTU,i);
            end;
          end;
        end;
        DspMenu.WC := true; //--------------------------------------- ����� ��������������
        MakeMenu(X);
        exit;
      end else
      begin //-------------------------------------- �� ������ ������ ������������� ������
        InsNewMsg(0,276,1,''); //-------------------- "�������� ������� ������� ������ ��"
        ShowSmsg(276,LastX,LastY,'');
        SimpleBeep;
        color := 1;
        msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,color);
        DspMenu.WC := true;
        exit;
      end;
    end;
    //##################################################################################
    Key_ReadyRestartServera ://-------------------------------------------------- 1017
    begin //------------------------------------�������� ������������� ����������� �������
      DspCom.Active := true;
      DspCom.Com := ID;
      color := 7;
      InsNewMsg(0,351+$4000,7,'');//----- "����������� ������ ������� ����������� �������"
      msg := GetSmsg(1,351,'',color);
      DspMenu.WC := true;
      result := true;
      MakeMenu(X);
      exit;
    end;
    //##################################################################################
    Key_ReadyRestartUVK ://---------------------------------------------------------- 1018
    begin //-------------------------------------- �������� ������������� ������������ ���
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := IndexFR3IK;
      color :=  7;
      InsNewMsg(DspCom.Obj,352+$4000,color,''); //"����������� ������� ������������ ���"
      msg := GetSmsg(1,352,ObjZv[DspCom.Obj].Liter,color);
      DspMenu.WC := true;
      result := true;
      IndexFR3IK := 0;
      MakeMenu(X);
      exit;
    end;
    //##################################################################################
    Key_ReadyRescueOTU : //----------------------- �������� ������� �������������� ���
    begin //
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := IndexFR3IK;
      color :=  7;
      InsNewMsg(DspCom.Obj,504+$4000,color,'');// ����������� ������� �������������� ���
      msg := GetSmsg(1,504,ObjZv[DspCom.Obj].Liter,color);
      DspMenu.WC := true;
      result := true;
      IndexFR3IK := 0;
      MakeMenu(X);
      exit;
    end;
  end;//---------------------------------------------------------- ����� ������� "case ID"

  if LockDirect then exit; //----------------------- ���� ���� ������ ������������ - �����

  if CheckOtvCommand(ID_Obj) then //��������� ������� �������� ������������� ��� �������
  begin
    OtvCommand.Active := false;
	  WorkMode.GoOtvKom := false;
		OtvCommand.Ready := false;
    ShowSmsg(153,LastX,LastY,''); //---- "�������������� ������������ ���������������"
//      SingleBeep := true;
    InsNewMsg(0,153,1,'');
    exit;
  end;
{$ENDIF}

  //======================================= ������������ ����/������������� ������ �������
  case ID of
{$IFDEF RMDSP}
    //##################################################################################
    Key_RazdeRejim : //-------------------------------------------------------------- 1001
    begin //--------------------------------------------- ������������ ������ "����������"
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      color := 7;
      InsNewMsg(DspCom.Obj,95+$4000,color,'');//--- ���������� ���������� ����� ����������
      msg := GetSmsg(1,95,'',color);
      result := false;
    end;
    //##################################################################################
    Key_MarshRejim ://------------------------------- ������������ ������ "����������"
    begin
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      color :=  2;
      InsNewMsg(DspCom.Obj,96+$4000,color,''); // ���������� ���������� ����� ����������
      msg := GetSmsg(1,96,'',color);
      result := false;
    end;
    //##################################################################################
    Key_MaketStrelki : //------------------------- ���������/���������� ������ �������
    begin
      if WorkMode.OtvKom then
      begin //-------------------------- ����  ������ �� - ���������� ������������ �������
        ResetCommands;
        InsNewMsg(0,283,1,''); //-------------------- "������ ������ ������������� ������"
        ShowSmsg(283,LastX,LastY,'');
        color := 1;
        msg := GetSmsg(1,283, ObjZv[ID_Obj].Liter,color);
        exit;
      end;

      ResetTrace; //---------------------------------------------- �������� ����� ��������
      WorkMode.MarhOtm := false;
      WorkMode.VspStr := false;
      WorkMode.InpOgr := false;

      if maket_strelki_index > 0 then //---------------------- ���� �� ������ ���� �������
      begin //--------------------------------------------- ������ ������ ������� � ������
        DspCom.Com := M_SnatMaketStrelki;
        DspCom.Obj := maket_strelki_index;
        color := 7;
        InsNewMsg(DspCom.Obj,172+$4000,color,'');
        msg := GetSmsg(1,172, maket_strelki_name,color);//"����� � ������ ������� ?"
        DspMenu.WC := true;
      end else //---------------------------------------------- ���� �� ������ ������� ���
      if WorkMode.GoMaketSt then  //----------------- ���� ���� ��������� ������� �� �����
      begin //----------------------- ����� ������� ������ ������� ��� ���������� �� �����
        WorkMode.GoMaketSt := false;
        RSTMsg;
        exit;
      end else //--------------------------------- ���� ���� ��� ������ ��������� �� �����
      begin //------------------------------------- ������� ������� ��� ��������� �� �����
        for i := 1 to High(ObjZv) do //-------------------------- ������ �� ���� ��������
        begin  //------------------------ � ��������� �������� ����������� ��������� �����
          if(ObjZv[i].RU = config.ru)and(ObjZv[i].TypeObj = 20) then // ����� �� �����
          begin
            if ObjZv[i].bP[2] then //----------------------------------- ���� ���� ��
            begin //--------------------------------------------- ��������� ������ �������
              WorkMode.GoMaketSt := true;
              InsNewMsg(0,8+$4000,7,''); //------ "������� ������� ��� ��������� �� �����"
              ShowSmsg(8,LastX,LastY,'');
            end else //------------------------------------------------------- ���� ��� ��
            begin //------------------------------------------- �������� ���� �� ���������
              RSTMsg;
              InsNewMsg(0,90,1,''); //---------------- "�� ��������� ���� ������ �������!"
              ShowSmsg(90,LastX,LastY,'');
              color := 1;
              AddFixMes(GetSmsg(1,90,'',color),4,2);
            end;
            exit; //----------- ����� ����� ����������� ��������� ������ � ������ ��������
          end;
        end;
        exit; //--- ����� ����� ������� �� ���� �������� ��� �� ��������� ��������� ������
      end;
    end;
    //##################################################################################
    Key_OtmenMarsh, //-------------------- ���������/���������� ������ ������ ��������
    Key_InputOgr ,//-------------------- ���������/���������� ������ ����� �����������
    Key_VspPerStrel: //���������/���������� ������ ���������������� �������� �������
    begin
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      exit;
    end;
    //##################################################################################
    Key_EndTrace :
    begin //------------------------------------------------- ����� ������ �������� = 1008
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      if MarhTrac.WarN > 0 then  //------------ ���� ���� �������������� ��� ���������
      begin
        msg := MarhTrac.War[MarhTrac.WarN];//---------------- �������� ��������������
        InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1],1,'');
      end
      else   exit; //----------------------------------------------------- ����� ���������
    end;
    //##################################################################################
    Key_EndTraceError :
    begin //----------- ������ ��������������, ��� �������� ����� �������� ������� �������
      DspCom.Active := true;
      DspCom.Com := Key_ClearTrace;
      DspCom.Obj := 0;
      InsNewMsg(0,87,1,'');
      ShowSmsg(87,LastX,LastY,'');
      exit;
    end;
    //##################################################################################
    CmdMarsh_Ready : //-------------------------------------------------------------- 1102
    begin //----------------------------------- ��������� ������������� ��������� ��������
      DspMenu.obj := cur_obj;
      case MarhTrac.Rod of //------------------------------ ������������� �� ���� ��������
        MarshM :    //---------------------------------------------------- ���� ����������
        begin
          DspCom.Active := true;
          DspCom.Com := CmdMarsh_Manevr;
          DspCom.Obj := ID_Obj;
          color := 7;
          InsNewMsg(MarhTrac.ObjStart,6+$4000,color,'');//--- ���������� ���������� ����.?
          TXT := ObjZv[MarhTrac.ObjStart].Liter;
          msg := GetSmsg(1,6, TXT + MarhTrac.TailMsg,color);
          DspMenu.WC := true;
        end;
        MarshP ://---------------------------------------------------------- ���� ��������
        begin
          DspCom.Active := true;
          DspCom.Com := CmdMarsh_Poezd;
          DspCom.Obj := ID_Obj;
          color := 2;
            InsNewMsg(MarhTrac.ObjStart,7+$4000,color,'');//"���������� �������� �������?"
            TXT := ObjZv[MarhTrac.ObjStart].Liter;
            msg := GetSmsg(1,7, TXT + MarhTrac.TailMsg,color);
            DspMenu.WC := true;
          end;
          else exit;
        end;
      end;
      //##################################################################################
      CmdMarsh_RdyRazdMan :
      begin //--------------------------------------- ������ �������� ���������� �����������
        InsNewMsg(MarhTrac.ObjStart,6+$4000,7,'');
        color := 2;
        msg := GetSmsg(1,6, ObjZv[MarhTrac.ObjStart].Liter,color );
        DspCom.Com := ID;
        if ObjZv[ID_Obj].TypeObj = 5 then DspCom.Obj := ID_Obj
        else DspCom.Obj := ObjZv[ID_Obj].BasOb;
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdMarsh_RdyRazdPzd :
      begin //----------------------------------------- ������ �������� ���������� ���������
        InsNewMsg(MarhTrac.ObjStart,7+$4000,2,'');
        color := 2;
        msg := GetSmsg(1,7, ObjZv[MarhTrac.ObjStart].Liter,color);
        DspCom.Com := ID;
        if ObjZv[ID_Obj].TypeObj = 5 then  DspCom.Obj := ID_Obj
        else DspCom.Obj := ObjZv[ID_Obj].BasOb;
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdMarsh_Povtor  :
      begin //---------------------------- ����� ��������� ����� ��������� ��������� �������
        if MarhTrac.WarN > 0 then
        begin
          DspCom.Com := ID;
          DspCom.Obj := ID_Obj;
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. ����������?';
          DspMenu.WC := true;
          dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      CmdMarsh_PovtorMarh  :
      begin //-------------------------- ����� ��������� ����� ��������� ���������� ��������
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. ����������?';
          DspCom.Com := ID;  DspCom.Obj := ID_Obj;
          DspMenu.WC := true; dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      CmdMarsh_PovtorOtkryt  :
      begin //-------- ����� ��������� ����� ��������� ��������� ������� � ���������� ������
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. ����������?';
          DspCom.Com := ID;  DspCom.Obj := ID_Obj;
          DspMenu.WC := true; dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      CmdMarsh_Razdel :
      begin //------- ����� ��������� ����� ��������� ������� � ���������� ������ ����������
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. ����������?';
          DspCom.Com := ID; DspCom.Obj := ID_Obj;
          DspMenu.WC := true; dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      Key_QuerySetTrace :
      begin //--------------- ������ �� ������ ������� ��������� ������� �� ��������� ������
        SBeep[2] := true;
        TimeLockCmdDsp := LastTime;
        LockComDsp := true;
				ShowWarning := true;
        DspCom.Active := true;
        DspCom.Com := Key_QuerySetTrace;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(MarhTrac.ObjStart,442+$4000,color,'');//"���������� ������� �� ������ ?"
        TXT := ObjZv[MarhTrac.ObjStart].Liter;
        msg := GetSmsg(1,442,TXT + MarhTrac.TailMsg,color);
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
      //##################################################################################
      Key_ReadyResetTrace :
      begin //------------------- ��������� ����� ���������� ������ �������� �� ������������
        ShowWarning := true;
        if MarhTrac.GonkaStrel and (MarhTrac.GonkaList > 0) then
        begin
          InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1]+$5000,7,'');
          msg := MarhTrac.Msg[1] + '. �������� ������� �������. ����������?';
        end else
        begin
          InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1],7,'');
          msg := MarhTrac.Msg[1];
        end;
        PutSmsg(1, LastX, LastY, msg);
        DspMenu.WC := true;
        DspCom.Com := CmdMarsh_Tracert;
        DspCom.Active := true;
        DspCom.Obj := ID_Obj;
        DspMenu.WC := true;
        exit;
      end;
      //##################################################################################
      Key_ReadyWarningTrace : //----------------- �������� ������������� ��������� �� ������
      begin //------------------------- ��������� ������������� ��������� �� ������ ��������
        if MarhTrac.WarN > 0 then //--------------- ���� ���� �������������� ��� �������
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN]+ '. ����������?';
          DspMenu.WC := true; DspCom.Com := CmdMarsh_Tracert;
          DspCom.Active := true; DspCom.Obj := ID_Obj;
          DspMenu.WC := true;
        end;
      end;
      //##################################################################################
      Key_ReadyWarningEnd :
      begin //----------------- ��������� ������������� ��������� �� ����� ������ ��������
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN]+ '. ����������?';
          DspMenu.WC := true;   DspCom.Com := Key_EndTrace;
          DspCom.Active := true; DspCom.Obj := ID_Obj;
        end;
      end;
      //##################################################################################
      CmdStr_ReadyMPerevodPlus :
      begin //----------------------------- ������������� �������� �������� ������� � ����
        //------------------------------------------ "������� �� ������.��������� � ����?"
        DspCom.Com := CmdStr_ReadyMPerevodPlus;
        DspCom.Obj := ID_Obj;
        color := 2;
        InsNewMsg(ObjZv[ID_Obj].BasOb,101+$4000,color,'');
        msg := GetSmsg(1,101,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyMPerevodMinus :
      begin //------ ������������� �������� ������� � "������� �� ������.��������� � �����?"
        DspCom.Com := CmdStr_ReadyMPerevodMinus;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ObjZv[ID_Obj].BasOb,102+$4000,color,'');
        msg:=GetSmsg(1,102,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_AskPerevod :
      begin //------------------------------------------------------------ ������� �������
        with ObjZv[ID_Obj] do
        begin
        if bP[1] then
        begin //------------------------------------------------------------------ � �����
          if maket_strelki_index = BasOb then
          begin
            DspCom.Com := CmdStr_ReadyMPerevodMinus;
            DspCom.Obj := ID_Obj;
            color := 7;
            InsNewMsg(BasOb,102+$4000,color,'');
            msg := GetSmsg(1,102,ObjZv[BasOb].Liter,color);
          end else
          begin
            DspCom.Com := CmdStr_ReadyPerevodMinus;
            DspCom.Obj := ID_Obj;
            color := 7;
            InsNewMsg(BasOb,98+$4000,color,'');
            msg := GetSmsg(1,98,ObjZv[BasOb].Liter,color);
          end;
        end else //---------------------------------------------------------------- � ����
        if bP[2] then
        begin
          if maket_strelki_index = BasOb then
          begin
            DspCom.Com := CmdStr_ReadyMPerevodPlus;
            DspCom.Obj := ID_Obj;
            color := 2;
            InsNewMsg(BasOb,101+$4000,color,'');
            msg := GetSmsg(1,101,ObjZv[BasOb].Liter,color);
          end else
          begin
            DspCom.Com := CmdStr_ReadyPerevodPlus;
            DspCom.Obj := ID_Obj;
            color := 2;
            InsNewMsg(BasOb,97+$4000,color,'');
            msg := GetSmsg(1,97,ObjZv[BasOb].Liter,color);
          end;
        end else
        begin //------------------------------------------------------------------ �� ������
          //-------------- ��������� ������� + ��� (��������� �� - � ��������� �������� "+")
          if bP[22] or (not bP[23] and bP[20]) then msg := ' <' else msg := '';//����� "-"
          InsNewMsg(BasOb,165+$4000,7,'');
          color := 7;
          AddDspMenuItem(GetSmsg(1,165,msg,color), M_StrPerevodMinus,ID_Obj); //---- � �����
          if bP[23] or (not bP[22]and not bP[23]and bP[21]) then msg:= ' <' else msg:= '';
          InsNewMsg(BasOb,164+$4000,2,'');
          color := 2;
          AddDspMenuItem(GetSmsg(1,164,msg,color),M_StrPerevodPlus,ID_Obj); //------- � ����
        end;
        DspMenu.WC := true;
       end;
      end;
 {$ENDIF}
      //##################################################################################
      CmdManevry_ReadyWar :
      begin //----------------------------------- �������� ������������� �������� �� �������
{$IFDEF RMDSP}
        if MarhTrac.WarN > 0 then
        begin
          InsNewMsg(MarhTrac.WarObj[MarhTrac.WarN],MarhTrac.WarInd[MarhTrac.WarN]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN];
          dec (MarhTrac.WarN);
          DspCom.Com := CmdManevry_ReadyWar;
          DspCom.Obj := ID_Obj;
        end else
        begin
          InsNewMsg(ID_Obj,217+$4000,7,'');
          color := 7;
          msg := GetSmsg(1,217, ObjZv[ID_Obj].Liter,color);
          DspCom.Com := M_DatRazreshenieManevrov;
          DspCom.Obj := ID_Obj;
        end;
{$ENDIF}
      end;
      //##################################################################################
{$IFDEF RMDSP}
      CmdStr_ReadyPerevodPlus :
      begin //---------------------------------------- ������������� �������� ������� � ����
        DspCom.Com := CmdStr_ReadyPerevodPlus;
        DspCom.Obj := ID_Obj;
        color := 2;
        InsNewMsg(ObjZv[ID_Obj].BasOb,97+$4000,color,'');
        msg := GetSmsg(1,97,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyPerevodMinus :
      begin //--------------------------------------- ������������� �������� ������� � �����
        DspCom.Com := CmdStr_ReadyPerevodMinus;
        DspCom.Obj := ID_Obj; //---------------------------- ������ ������� ��� ������� � OZ
        color := 7;
        InsNewMsg(ObjZv[ID_Obj].BasOb,98+$4000,color,'');
        msg := GetSmsg(1,98,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyVPerevodPlus :
      begin //----------------------- ������������� ���������������� �������� ������� � ����
        DspCom.Com := CmdStr_ReadyVPerevodPlus;
        DspCom.Obj := ID_Obj;
        color := 2;
        InsNewMsg(ObjZv[ID_Obj].BasOb,99+$4000,color,'');
        msg := GetSmsg(1,99,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyVPerevodMinus :
      begin //---------------------- ������������� ���������������� �������� ������� � �����
        DspCom.Com := CmdStr_ReadyVPerevodMinus;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ObjZv[ID_Obj].BasOb,100+$4000,color,'');
        msg := GetSmsg(1,100,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      ID_Tracert :
      begin //---------------------------- ID_Tracert = 34 ����������� �� �������� �������
        DspCom.Active  := true;
        DspCom.Com := CmdMarsh_Tracert; //-------- ��������� ������� CmdMarsh_Tracert=1101
        DspCom.Obj := ID_Obj;
        exit;
      end;
 {$ENDIF}
      //##################################################################################
      //************************************************************************** �������
      ID_Strelka : result := NewMenu_Strelka(X,Y);

      //##################################################################################
      //************************************ ��������� (����������, ����������� � �������)
      ID_SvetoforManevr,
      ID_SvetoforSovmech,
      ID_SvetoforVhodnoy :
      result := NewMenu_Svetofor(X,Y);

      //##################################################################################
      //********************************************** ���������� ������������� ����������
      ID_AutoSvetofor : result := NewMenu_AvtoSvetofor(X,Y);

      //##################################################################################
      //***************************************** ���������� ��������� ������� �� 1-�� ���
      ID_1bit : result := NewMenu_1bit(X,Y);

      //##################################################################################
      //------------------------------------------- ���������� ��������� ������� �� 2-�� ���
      ID_2bit : result := NewMenu_2bit(X,Y);

      //##################################################################################
      //----------------------- ���������� ��������� ������� � ����������� �� ��������� ����
      ID_VklOtkl_bit1 : result := NewMenu_VklOtkl1bit(X,Y);

      //##################################################################################
    //------------------- ���������� ������� �������� ��� �������������� �������� ��������
    ID_PrzdZakrOtkr : result := NewMenu_PRZDZakrOtkr(X,Y);
    ID_ZaprRazrMont : result := NewMenu_ZaprRazrMont(X,Y); //------ ������/������ ��������
    ID_VydPSogl     : result := NewMenu_VydPSogl(X,Y);//------ ���� ������ �������� ������
    ID_Nadvig       : result := NewMenu_Nadvig(X,Y);   //---------- ���� "������ �� �����"
    ID_Uchastok     : result := NewMenu_Uchastok(X,Y);//-- ���� ���������� �������� ��(��)
    ID_PutPO        : result := NewMenu_PutPO(X,Y);//----- ���� ���������� �������� "����"
    ID_OPI          : result := NewMenu_OPI(X,Y); //--- "���"(���������� ���� �� ��������)
    ID_ZaprPSogl    : result := NewMenu_PSogl(X,Y);//- ������ ��������� ����������� ������

    ID_SmenaNapravleniya :  //------------------------------------------------ ������ � ��
    begin gotomen := false; result := NewMenu_SmenaNapravleniya(X,Y,gotomen);
      {$IFDEF RMDSP} if gotomen then begin MakeMenu(X); exit; end; {$ENDIF}
    end;
    ID_KSN               : result := NewMenu_KSN(X,Y);//�����. ��������� ����� �����������
    ID_PAB               : result := NewMenu_PAB(X,Y);//------- ���������� ���������������
    ID_ManKol            : result := NewMenu_ManKol(X,Y); //----------- ���������� �������
    ID_ZamykStr          : result := NewMenu_ZamykStr(X,Y); //---------- ��������� �������
    ID_RazmykStr         : result := NewMenu_RazmykanieStrelok(X,Y);//- ���������� �������
    ID_ZakrytPereezd     : result := NewMenu_ZakrytPereezd(X,Y); //------- ������� �������
    ID_OtkrytPereezd     : result := NewMenu_OtkrytPereezd(X,Y); //------- ������� �������
    ID_IzvPer1,ID_IzvPer : result := NewMenu_IzvPereezd(X,Y);//------ ��������� �� �������
    ID_PoezdOpov         : result := NewMenu_PoezdOpov(X,Y);//���/���� �������� ����������
    ID_ZapMont           : result := NewMenu_ZapretMont(X,Y); //-------- "������ ��������"
    ID_OtklZapMont       : result := NewMenu_Otkl_ZapretMont(X,Y);// ����. ������ ��������
    ID_VykluchenieUKSPS  : result := NewMenu_OtklUKSPS(X,Y);//------ ���� ���������� �����
    ID_OtklUKG           : result := NewMenu_OtklUKG(X,Y);//- �������� ���� ���������� ���
    ID_VklUKG            : result := NewMenu_VklUKG(X,Y); //---------------- ��� ���������
    ID_VspomPriem        : result := NewMenu_VspomPriem(X,Y);//----- ��������������� �����
    ID_VspomOtpravlenie  : result := NewMenu_VspOtpr(X,Y); //-------- �������. �����������
    ID_OchistkaStrelok   : result := NewMenu_OchistkaStrelok(X,Y);//------ ������� �������
    ID_VkluchenieGRI1    : result := NewMenu_VklGRI1(X,Y);//------ ��������� �������� ���1
    ID_PutManevrovyi     : result := NewMenu_PutIzvst(X,Y);//--------- ������� �����������
    ID_RezymPitaniyaLamp : result := NewMenu_DSNLamp(X,Y); //------------ ������� ���� ���
    ID_RezymLampDen      : result := NewMenu_RezymLampDen(X,Y); //---- ���.�������� ������
    ID_RezymLampNoch     : result := NewMenu_RezymLampNoch(X,Y);//---- ���. ������� ������
    ID_RezymLampAuto     : result := NewMenu_RezymLampAuto(X,Y);  //------ ���. ����������
    ID_OtklZvonkaUKSPS   : result := NewMenu_OtklZvonkaUKSPS(X,Y);//---- ����.������ �����
{$IFNDEF RMDSP}
    ID_GroupDat :
    begin//--------------------------------------------- ������ ������� �������� �� ���-��
      DspMenu.obj := cur_obj;
      ID_ViewObj := ID_Obj;
      result := true;
      exit;
    end;
{$ENDIF}
    else   DspCom.Com := 0;   DspCom.Obj := 0;   exit;
  end;
{$IFDEF RMDSP}
//mkmnu : //------------------------------------------------------------- ������������ ����
  if DspMenu.Count > 0 then //---------------------------------- ���� ���� ���-�� ��� ����
  begin
    TabloMain.PopupMenuCmd.Items.Clear; //---------------------------- �������� ���� �����
    for i := 1 to DspMenu.Count  do
    TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//------- ����� �� DspMenu
    GetCursorPos(t0);
    SetCursorPos(t0.x ,t0.Y);
    if TabloMain.PopupMenuCmd.Items.Count > 0 then
    begin
      TabloMain.PopupMenuCmd.MenuAnimation := [maNone];
      hMenuDC := GetDC(TabloMain.PopupMenuCmd.WindowHandle);
      hMenuWnd := WindowFromDC(hMenuDC);
      if IsWindow(hMenuWnd)  then
      begin
        test_long := GetWindowLong(hMenuWnd, GWL_EXSTYLE);
        test_long := SetWindowLong(hMenuWnd,test_long,GWL_EXSTYLE or WS_EX_LAYERED);
        Trans := SetLayeredWindowAttributes(hMenuWnd,0,200,LWA_ALPHA);
      end;
    end;
    TabloMain.PopupMenuCmd.Popup(X, t0.Y+10);
    TabloMain.Canvas.Draw(t0.X,t0.Y,TabloMain.PopupMenuCmd.Items.Bitmap);
  end else
  begin //---------------------------- ������� ��������� ����� ����������� ������� �������
    j := x div configRU[config.ru].MonSize.X + 1; //-------------------- ����� ����� �����
    for i := 1 to High(SMsg) do
    //------------------- ���� ��� �� �����, ������� ������������� ������ ����������
    if (i = j) and (Smsg[i] = '') and (msg <> '') then Smsg[i] := msg;
  end;
{$ENDIF}
end;

{$IFDEF RMDSP}
//========================================================================================
//------------ �������� ������� ������������ ����������� ���������� �������� ��� ���������
function CheckStartTrace(Index : SmallInt) : string;
var
  color : Integer;
begin
    result := '';
    case ObjZv[Index].TypeObj of
      33 :
      begin //--------------------------------------------- ���� ��� ���������� ������ FR3
        if ObjZv[Index].ObCB[1] then //--------------------- ���� �������� ���������
        begin
          if ObjZv[Index].bP[1]  //----------------------------- ���� ������ = .True.
          then
            result := MsgList[ObjZv[Index].ObCI[3]]; //------ �������� �� ����������
        end else
        begin //--------------------------------------------------------- ������ ���������
          if not ObjZv[Index].bP[1]  //------------------ ��������� ������� = .False.
          then result := MsgList[ObjZv[Index].ObCI[2]]; //---- ��������� � ���������
        end;
      end;

      35 :
      begin //-------- ������ � ���������� ��������� ��������������� ������� (�����������)
        if ObjZv[Index].ObCB[1] then
        begin //-------------------------------------------------- ���� �������� ���������
          if ObjZv[Index].bP[1]
          then result := MsgList[ObjZv[Index].ObCI[2]]; //------- �������� �� ������
        end else
        begin //--------------------------------------------------------- ������ ���������
          if not ObjZv[Index].bP[1]
          then result := MsgList[ObjZv[Index].ObCI[2]]; //------- �������� �� ������
        end;
      end;

      47 :
      begin //----------------------------------- �������� ��������� ������������ ��������
        color := 1;
        if ObjZv[Index].bP[1]   //------------------ ���� ���� ��������� ������������
        then result := GetSmsg(1, 431, ObjZv[Index].Liter,color);//�������� ��������.
      end;
    end;
end;

//========================================================================================
//------------ �������� ������� ������������ ����������� ���������� �������� ��� ���������
function CheckAutoON(Index : SmallInt) : Boolean;
begin
  result := false;
  if index = 0 then exit;
  if ObjZv[Index].TypeObj <> 47 then exit;
  // �������� ��������� ������������ ��������
  if ObjZv[Index].bP[1] then result := true;
end;

//========================================================================================
//----- ��������� ������� ������������� ��������� �������� ���������� ��� �������� �������
function CheckProtag(Index : SmallInt) : Boolean;
var
  o,put : integer;
begin
    result := false;
    o := ObjZv[Index].ObCI[17];
    if o < 1 then exit;

    if ObjZv[o].TypeObj <> 42 then exit; //-------------------- ��� ������� �������������
    put :=  ObjZv[o].ObCI[7];

    if ObjZv[ObjZv[index].BasOb].bP[2]
    then exit; //--------------------------- ����������� ������ �� �������� - ��� ��������

    if ObjZv[o].bP[1] and //--------------------------- �������� ������� �����  � ...
    ObjZv[o].bP[2] and //----------------------------------- ��������� �������������
    not (ObjZv[put].bP[1] or ObjZv[put].bP[16]) then //--- ����� ���� ���������  
    begin
      if ObjZv[Index].ObCB[17] then
      begin //------------------------------------------------- � ������������ �������� ��
        DspCom.Com := M_OtkrytManevrovym;
        DspCom.Obj := ID_Obj;
        DspMenu.WC := true;
      end else
      begin //------------------------------------------------ ��� ����������� �������� ��
        DspCom.Com := M_OtkrytProtjag;
        DspCom.Obj := ID_Obj;
        DspMenu.WC := true;
      end;
      result := true;
    end;
end;

//========================================================================================
//----------------------------------------- �������� ���������� ��������� ������� �� �����
function CheckMaket : Boolean;
var
  i : integer;
begin
    result := false;
    for i := 1 to High(ObjZv) do //------------------------------ ������ �� ���� ��������
    begin
      if (ObjZv[i].RU = config.ru) and //-------------------------- ���� ���� ����� � ...
      (ObjZv[i].TypeObj = 20) then //------------------------- ��� ������ �������� ������
      begin
        if ObjZv[i].bP[2] then //--------------- �������� ����������� ��������� �����
        result := (maket_strelki_index < 1);
        exit;
      end;
    end;
end;
{$ENDIF}

//========================================================================================
//--------------------------------------- ������� ��������� � ������ ���������� ����������
function LockDirect : Boolean;
begin
     result := true;
{$IFDEF RMDSP}
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin
      InsNewMsg(0,76,1,''); //------------------------------------- "���������� ���������"
      ShowSmsg(76,LastX,LastY,'');
      exit;
    end;

    if (ID_Obj > 0) and (ID_Obj < 4096) and not WorkMode.OU[ObjZv[ID_Obj].Group] then
    begin
      InsNewMsg(0,76,1,'');  //------------------------------------ "���������� ���������"
      ShowSmsg(76,LastX,LastY,'');
      exit;
    end;

    if WorkMode.CmdReady then
    begin
      InsNewMsg(0,251,1,''); //-------- "���� ������ �������� ������������.����� �� �����"
      ShowSmsg(251,LastX,LastY,'');
     end
    else result := false;
{$ENDIF}
end;

//========================================================================================
//----------------------------------- ������� ���������� ���� ��� ��� ���������� ���������
function NewMenu_Svetofor(X, Y : SmallInt): boolean;
//ID  ������������� (ID_SvetoforManevr,ID_SvetoforSovmech, ID_SvetoforVhodnoy)
{$IFDEF RMDSP}
var
  u1,u2,uo : Boolean;
  TXT : string;
  color : integer;
{$ENDIF}
begin
  DspMenu.obj := cur_obj;
  result := false;
  if ObjZv[ID_Obj].bP[33] then
  begin
    InsNewMsg(ID_Obj,431+$4000,1,'');//---------------------------" �������� ������������"
    WorkMode.InpOgr := false;  //---------------------------- ���������� ������ � ��������
    ShowSmsg(431, LastX, LastY, '');
    exit;
  end;

{$IFNDEF RMDSP}
  if ObjZv[ID_Obj].bP[23] or //-------------- ���� ���� ���������� ���������� ��� ...
  ((ObjZv[ID_Obj].bP[5] or //------------------------- ���� ������� ��������� ��� ...
  ObjZv[ID_Obj].bP[15] or //--------------------------------- ���� ������� �� ��� ...
  ObjZv[ID_Obj].bP[17] or //------------------------------- ���� ������ ����� ��� ...
  ObjZv[ID_Obj].bP[24] or //-------------------------------- ���� ������� ��� ��� ...
  ObjZv[ID_Obj].bP[25]) and //-------------------------------- ���� ������� ��� � ...
  not ObjZv[ID_Obj].bP[20] and //-------- ��� �������� ���������� ������������� � ...
  not WorkMode.GoTracert) then //------------------------------ ��� ���������� �����������
  begin //------------------------------------------------ ����� ������� ��� �������������
    ObjZv[ID_Obj].bP[23] := false; //-------------------- ����� ���������� ����������
    ObjZv[ID_Obj].bP[20] := true; //------------------- ���������� ���������� �������
  end;

  ID_ViewObj := ID_Obj;  //------------ ������ ������� ��� ������������ �������� ���������
  result := true;
  exit;
{$ELSE}

  ObjZv[ID_Obj].bP[34]:=false; //-------- ����� ���������� ������� ��������� ��������

  //:::::::::::::::::::::::::::::::::::::::::::::::::::::: ��������������� ������� :::::::
  if ActivenVSP(ID_Obj) then exit;

  //------------------------------------- ����� ������ "����� ��� ��������������� �������"
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;

  if WorkMode.OtvKom then //:::::::::::::::::::::: ���� ������������� ������� ::::::::::::
  begin //------------------- ������ �� - ������������� �������� ����������� ��� ���������
    InsNewMsg(ID_Obj,311+$4000,7,'');  //------------------------------- "������������� ?"
    color := 7;
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,color);
    DspCom.Com := CmdMarsh_ResetTraceParams; //-------- ������� ������ �����������
    DspCom.Obj := ID_Obj;
  end else

  begin //::::::::::::::::::::::::::::::::::::: ������� ����� ::::::::::::::::::::::::::::
    if ObjZv[ID_Obj].bP[23] and //----------------- ���� ���� ���������� ���������� �
    not WorkMode.GoTracert then  //---------------------------- �� ����������� �����������
    begin
      ObjZv[ID_Obj].bP[23] := false;//--------- ���������� ���������� ��������� �����
      exit;
    end;

    if ObjZv[ID_Obj].bP[18] then //----------------------------------- ���� �� ��� ��
    begin
      InsNewMsg(ID_Obj,232+$4000,1,'');//------------------ "������ �� ������� ����������"
      WorkMode.GoMaketSt := false; //----------------- ���������� ����� ��������� �� �����
      ShowSmsg(232,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end;

    if WorkMode.InpOgr then //------------------------------------------- ���� �����������
    begin
      if ObjZv[ID_Obj].bP[33] then //--- ���� ������������ �������� ��� ����� �������
      begin
        InsNewMsg(ID_Obj,431+$4000,1,'');//-----------------------" �������� ������������"
        WorkMode.InpOgr := false;  //------------------ ���������� ����� ����� �����������
        ShowSmsg(431, LastX, LastY, '');
        exit;
      end;

      if ObjZv[ID_Obj].bP[14] then //-------------- ���� ����������� ��������� � ����
      begin
        InsNewMsg(ID_Obj,238+$4000,1,'');//-------------------- "�������� � ������ ��������"
        WorkMode.InpOgr := false;  //------------------ ���������� ����� ����� �����������
        ShowSmsg(238, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end;

      //------------------------------------------- �����, ���� ��� ������������ ���������


      //-------------------------------------- ���� ���������� �� ������� � ���� � �������
      if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
      begin
        InsNewMsg(ID_Obj,179+$4000,7,'');//------------------------ "������������� ��������"
        InsNewMsg(ID_Obj,180+$4000,7,'');//----------------------- "�������������� ��������"
        color := 7;
        AddDspMenuItem(GetSmsg(1,179, '',color),M_BlokirovkaSvet,ID_Obj);
        AddDspMenuItem(GetSmsg(1,180, '',color),M_DeblokirovkaSvet,ID_Obj);
      end else
      if ObjZv[ID_Obj].bP[13] then //---------------------------- ���� ������ ������������
      begin
        DspCom.Com := M_DeblokirovkaSvet;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ID_Obj,180+$4000,7,''); //----------------- "�������������� �������� $?"
        msg := GetSmsg(1,180, ObjZv[ID_Obj].Liter,color);
      end else//------------------------------------------------ ���� ������ �� ����������
      begin
        DspCom.Com := M_BlokirovkaSvet;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ID_Obj,179+$4000,color,''); //-------------- "������������� �������� $?"
        msg := GetSmsg(1,179, ObjZv[ID_Obj].Liter,color);
      end;
    end else //------------------------------------------- �����, ���� �� ���� �����������

    if WorkMode.MarhOtm then //-------------------------------------- ���� ������ ��������
    begin
      if ObjZv[ID_Obj].bP[33] then
      begin //----------------------------------------------- ���� ������ �� ������������
        color := 1;
        msg := GetSmsg(1,431,ObjZv[ID_Obj].Liter,color);
        if msg <> '' then //------------------------------ ���� ���� ����� ��������� ...
        begin
          PutSmsg(1,LastX,LastY,msg);  //--- ������ ����� ��������� �� ����� � �����
          exit;
        end;
      end;

      if ObjZv[ID_Obj].ObCB[3] and  //------------- ���� ���� ������ ���������� �...
      (ObjZv[ID_Obj].bP[6] or //--------------------------- ���� �� �� ������� ���...
      ObjZv[ID_Obj].bP[7]) or //------------------------- ���� ��� ����������� ���...
      (ObjZv[ID_Obj].bP[1] or //------------------------------------ ���� ��1 ��� ...
      ObjZv[ID_Obj].bP[2]) then //------------------------------------------ ���� ��2
      begin
        if ObjZv[ID_Obj].bP[2] then //--------------------------------- ���� ���� ��2
        begin //-------- ���� ������ ������ - ��������� ������� ���������� ������ ��������
          msg := GetSoglOtmeny(ObjZv[ID_Obj].ObCI[19]); //- �������� ����� ���������
          if msg <> '' then //------------------------------ ���� ���� ����� ��������� ...
          begin
            PutSmsg(1,LastX,LastY,msg);  //--- ������ ����� ��������� �� ����� � �����
            exit;
          end;
        end;

        InsNewMsg(ID_Obj,175+$4000,7,''); //-------------- "�������� ���������� ������� ?"
        msg := '';
        case GetIzvestitel(ID_Obj,MarshM) of
          1 :
          begin
            color := 1;
            msg := GetSmsg(1,329, '',color) + ' '; //"����� �� �������������� �������"
            InsNewMsg(ID_Obj,329+$5000,1,'');
          end;

          2 :
          begin
            color := 1;
            msg := GetSmsg(1,330, '',color) + ' '; //------------- "����� �� ��������"
            InsNewMsg(ID_Obj,330+$5000,1,'');
          end;

          3 :
          begin
            color := 1;
            msg := GetSmsg(1,331, '',color) + ' '; //-- "����� �� ������� �����������"
            InsNewMsg(ID_Obj,331+$5000,1,'');
          end;
        end;
        color := 7;
        msg:=msg+GetSmsg(1,175,'�� '+ObjZv[ID_Obj].Liter,color);//�������� ����������
        DspCom.Com := M_OtmenaManevrovogo;
        DspCom.Obj := ID_Obj;
      end else

      if ObjZv[ID_Obj].ObCB[2] and//������ ����� ����� ������ �������� ��������� �..
      (ObjZv[ID_Obj].bP[8] or //-------------- ���� ������� ������ �� ������� ��� ...
      ObjZv[ID_Obj].bP[9]) or //--- ���� ������� �������� ����������� ������� ��� ...
      (ObjZv[ID_Obj].bP[3] or //--------------------------- ������� ������ �1 ��� ...
      ObjZv[ID_Obj].bP[4]) then  //-------------------------------- ������� ������ �2
      begin //---------------------------------------------------------- �������� ��������
        if ObjZv[ID_Obj].bP[4] then //------------------------------- ���� ������� �2
        begin //-------------- ���� ������ ������ - ��������� ������������ ������ ��������
          msg := GetSoglOtmeny(ObjZv[ID_Obj].ObCI[16]);// ��������� ������� � ������
          if msg <> '' then
          begin PutSmsg(1,LastX,LastY,msg); exit; end; //---- ����� ��������� �� �����
        end;
        InsNewMsg(ID_Obj,176+$4000,7,'');//----------------- "�������� �������� ������� ?"
        msg := '';

        case GetIzvestitel(ID_Obj,MarshP) of //------------ �������� ��������� �����������
          1 :
          begin
            color := 1;
            msg := GetSmsg(1,329, '',color) + ' '; // ����� �� �������������� �������!
            InsNewMsg(ID_Obj,329+$5000,1,'');
          end;

          2 :
          begin
            color := 1;
            msg := GetSmsg(1,330, '',color) + ' '; //------------------ ����� �� ��������!
            InsNewMsg(ID_Obj,330+$5000,1,'');
          end;

          3 :
          begin
            color := 1;
            msg := GetSmsg(1,331, '',color) + ' '; //------- ����� �� ������� �����������!
            InsNewMsg(ID_Obj,331+$5000,1,'');
          end;
        end;

        color := 7;
        msg := msg+GetSmsg(1,176,'�� '+ObjZv[ID_Obj].Liter,color);//���.�����. ������� $?
        DspCom.Com := M_OtmenaPoezdnogo; //������� ������� ������ � ��������
        DspCom.Obj := ID_Obj;
      end else

      //------------------------------------------------------------------- ������ ��� ���
      if ObjZv[ID_Obj].BasOb <>0 then //--------------- ���� ���� ����������� ������
      if  not ObjZv[ID_Obj].bP[14] and //---- ��� ������������ ��������� ������� �...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[14] then//��� ������������ ��������� ��
      begin //------------------------------------- ������� ��������� ����������� ��������
        if ObjZv[ID_Obj].ObCB[2] and //-------- � ������� ���� ������ �������� � ...
        ObjZv[ID_Obj].ObCB[3] then //-------------- � ������� ���� ������ ����������
        begin //---------------- ������� ��������� ������ (��������), ��� ��� ������ �����
          InsNewMsg(ID_Obj,175+$4000,7,''); //-------------- �������� ���������� ������� ?
          InsNewMsg(ID_Obj,176+$4000,7,''); //---------------- �������� �������� ������� ?

          color := 1;
          AddDspMenuItem('��� ������ ��������! '+ GetSmsg(1,175, '',color),
          M_OtmenaManevrovogo,ID_Obj);

          color := 1;
          AddDspMenuItem('��� ������ ��������! '+ GetSmsg(1,176, '',color),
          M_OtmenaPoezdnogo,ID_Obj);
        end else

        if ObjZv[ID_Obj].ObCB[3] then //------ � ������� �������� ������ ���������� ������
        begin //------------------------------------------- �������� ���������� (��������)
          DspCom.Com := M_OtmenaManevrovogo;
          DspCom.Obj := ID_Obj;
          color := 7;
          InsNewMsg(ID_Obj,175+$4000,color,'');
          TXT := ObjZv[ID_Obj].Liter;
          msg := '��� ������ ��������! '+ GetSmsg(1,175,'�� ' + TXT,color);
        end else
        if ObjZv[ID_Obj].ObCB[2] then //--------------------- ������ �������� ������
        begin //--------------------------------------------- �������� �������� (��������)
          DspCom.Com := M_OtmenaPoezdnogo;
          DspCom.Obj := ID_Obj;
          color := 1;
          InsNewMsg(ID_Obj,176+$4000,color,'');
          TXT := ObjZv[ID_Obj].Liter;
          msg := '��� ������ ��������! '+ GetSmsg(1,176,'�� ' + TXT,color);
        end
        else  exit; //------------------------------------------ ��� ������� ����� - �����
      end
      else  exit; //------------------------------------ ���� �����-���� ��������� - �����
      //---------------------------------------------------------- ����� ��������� ��� ���
    end else //--------------------------------------------- ����� ������ � ������� ������

    if ObjZv[ID_Obj].bP[23] or //-------------- ���������� ���������� ������� ��� ...
    ((ObjZv[ID_Obj].bP[5] or //----------------------------- ������� �������� ��� ...
    ObjZv[ID_Obj].bP[15] or //------------------------------------ ������� �� ��� ...
    ObjZv[ID_Obj].bP[17] or //---------------------------------- ������ ����� ��� ...
    ObjZv[ID_Obj].bP[24] or //----------------------------------- ������� ��� ��� ...
    ObjZv[ID_Obj].bP[25] or //----------------------------------- ������� ��� ��� ...
    ObjZv[ID_Obj].bP[26]) and //------------------------------------ ������� �� � ...
    not ObjZv[ID_Obj].bP[20] and //--------------- ��� ���������� ������������� � ...
    not WorkMode.GoTracert) then   //-----------------------�� ����������� ����������� ...
    begin //------------------------------------------ ����� ������� ��� ������������� ...
      ObjZv[ID_Obj].bP[23] := false; //----------------- ������ ���������� ����������
      ObjZv[ID_Obj].bP[20] := true; //----------- ���������� ���������� �������������
      exit;
    end else

    if not ObjZv[ID_Obj].bP[31] then //-------------------------- ���� ��� ����������
    begin //-------------------------------------------------- �� ���� ��� ������ � ������
      InsNewMsg(ID_Obj,310+$4000,1,''); //- "����������� ���������� � ��������� ���������"
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowSmsg(310, LastX, LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else

    if ObjZv[ID_Obj].bP[13] and not WorkMode.GoTracert then //- �������� ������������
    begin
      InsNewMsg(ID_Obj,123+$4000,1,'');//----------------------- "�������� $ ������������"
      ShowSmsg(123,LastX,LastY,ObjZv[ID_Obj].Liter);
      color := 1;
      msg := GetSmsg(1,123, ObjZv[ID_Obj].Liter,color);
//      SingleBeep := true;
      exit;
    end else
    if CheckAutoON(ObjZv[ID_Obj].ObCI[28]) then //-- /��������� ��������� ���������.
    begin
      InsNewMsg(ID_Obj,431+$4000,1,'');//------------------------- "�������� ������������"
      ShowSmsg(431,LastX,LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.MarhUpr then //------------------------------ ����� ����������� ����������
    begin
      if CheckMaket then  //----------------------- ���� ����� ���������� �� �������� ����
      begin //--------------- ����� ���������� �� ��������� - ����������� ���������� �����
        InsNewMsg(ID_Obj,344+$4000,1,'');
        ShowSmsg(344,LastX,LastY,ObjZv[ID_Obj].Liter);
        color := 1;
        msg := GetSmsg(1,344, ObjZv[ID_Obj].Liter,color);
//        SingleBeep := true;
        ShowWarning := true;
        exit;
      end else

      if WorkMode.GoTracert then //----------------------------- ���� ����������� ��������
      begin //-------------------------------------------------- ����� ������������� �����
        //---------- ���� ������ ����� �������� �� ������������� ���� ����������� ��������
        if ((MarhTrac.Rod = MarshP) and( ObjZv[ID_Obj].ObCB[2] = false)) or
        ((MarhTrac.Rod = MarshM) and( ObjZv[ID_Obj].ObCB[3] = false)) then
        begin
          ShowSmsg(87,LastX,LastY,ObjZv[ID_Obj].Liter);
          msg := GetSmsg(1,87, ObjZv[ID_Obj].Liter,1);
          ShowWarning := true;
        end else
        begin
          DspCom.Active  := true;
          DspCom.Com := CmdMarsh_Tracert;
          DspCom.Obj := ID_Obj;
        end;
        exit;
      end else

      if CheckProtag(ID_Obj) then
      begin //-- ������� ������ ��� �������� (������������� ��������� �������� ����������)
        InsNewMsg(ID_Obj,416+$4000,7,''); //--- ������� ������ $ ��� ������������ �������?
        msg := GetSmsg(1,416, ObjZv[ID_Obj].Liter,7);
      end else
      begin //------------------------------------ ��������� ������������ �������� �������
        if ObjZv[ID_Obj].bP[2] or //------------------------------------ ���� ��2 ���
        ObjZv[ID_Obj].bP[4] then //------------------------------------------ ���� �2
        begin
          InsNewMsg(ID_Obj,230+$4000,7,'');//------------------------- "������ $ ��� ������"
          ShowSmsg(230,LastX,LastY,ObjZv[ID_Obj].Liter);
          msg := GetSmsg(1,230, ObjZv[ID_Obj].Liter,7);
          exit;
        end else

        if ObjZv[ID_Obj].bP[1] or //------------------------------------ ���� ��1 ���
        ObjZv[ID_Obj].bP[3] then //------------------------------------------ ���� �1
        begin
          InsNewMsg(ID_Obj,402+$4000,1,'');//-- "������� ������� ����.������� �� ��������"
          ShowSmsg(402,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end else

        if ObjZv[ID_Obj].bP[6] or //---------------------- ���� �� �� ������� ��� ...
        ObjZv[ID_Obj].bP[7] then //---------------------------------- ����������� ���
        begin
          if ObjZv[ID_Obj].bP[11] then //--- �������� ��������� ��������� �����������
          begin
            //---------------- ��������� ������� ������������ ������� ����������� ��������
            if ObjZv[ID_Obj].ObCI[17] > 0 then //---------- ���� ���� ������� ��� ��
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZv[ID_Obj].ObCI[18] > 0 then //------- ���� ���� ������� ��� ��(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //-------------------------- ������ ������� ������� ����������� ��������
              DspCom.Active := true;
              DspCom.Com := M_PovtorManevrMarsh;
              DspCom.Obj := ID_Obj;
              color := 7;
              InsNewMsg(ID_Obj,398+$4000,color,'');//---- "�������� ������� ���������� $?"
              msg := GetSmsg(1,398, ObjZv[ID_Obj].Liter,color);
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //------------- ������� ��, ������ ������ - ��������� �������� �����������
            if ObjZv[ID_Obj].ObCI[17] > 0 then
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZv[ID_Obj].ObCI[18] > 0 then
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              DspCom.Active := true;
              DspCom.Com := M_PovtorManevrovogo;
              DspCom.Obj := ID_Obj;
              color := 7;
              InsNewMsg(ID_Obj,177+$4000,color,''); //----- �������� ������� ���������� $?
              msg := GetSmsg(1,177, ObjZv[ID_Obj].Liter,color);
            end else
            begin PutSmsg(1,LastX,LastY,msg);exit; end;//- ����� �� ������ �����������
          end;
        end else
        if ObjZv[ID_Obj].bP[8] or //------------------ ���� ���� � �� ������� ��� ...
        ObjZv[ID_Obj].bP[9] then //----------------- �������� ��� ����������� �������
        begin
          if ObjZv[ID_Obj].bP[11] then //--- ���� ����������� ������ ������� ��������
          begin
            //------------------ ��������� ������� ������������ ������� ��������� ��������
            if ObjZv[ID_Obj].ObCI[14] > 0 then //----------- ���� ���� ������� ��� �
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //-- ��������� �������
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZv[ID_Obj].ObCI[15] > 0 then //-------- ���� ���� ������� ��� �(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //-- ��������� �������
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //---------------------------- ������ ������� ������� ��������� ��������
              InsNewMsg(ID_Obj,399+$4000,2,'');//------------ �������� ������� �������� $?
              msg := GetSmsg(1,399, ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_PovtorPoezdMarsh;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //---------------- ������� �, ������ ������ - ��������� �������� ���������
            if ObjZv[ID_Obj].ObCI[14] > 0 then  //- ���� ���� ������� 1 ��� ��������
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZv[ID_Obj].ObCI[15] > 0 then
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]);//- ���� ���� ������� 2
              u2 := msg = '';
            end
            else u2 := false;
            msg := '';
            if u1 or u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              InsNewMsg(ID_Obj,178+$4000,2,''); //------------- �������� ������� �������� $?
              msg := GetSmsg(1,178, ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_PovtorPoezdnogo;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end else
        begin
          if (ObjZv[ID_Obj].bP[14] or //���� ���� ����������� ��������� ��� � ��� ...
          (ObjZv[ID_Obj].BasOb > 0)) and not ObjZv[ID_Obj].bP[6]
          and not ObjZv[ID_Obj].bP[8]
          then //---------------------------------------- ���� ����������� ������ �� � ...
          begin
            TXT := ObjZv[ObjZv[ID_Obj].BasOb].Liter;
            if ObjZv[ObjZv[ID_Obj].BasOb].bP[14]
            then TXT := ' ���������� ������� ������� ' + TXT else//�����.�����. �� ��� ...
            if  not ObjZv[ObjZv[ID_Obj].BasOb].bP[1]
            then TXT := ' ����� ������� ' + TXT else  //------------- ��������� �� ��� ...
            if not ObjZv[ObjZv[ID_Obj].BasOb].bP[2]
            then TXT := ' ������� ������� ' + TXT else //--- �������� ��������� �� ��� ...
            if not ObjZv[ObjZv[ID_Obj].BasOb].bP[7]
            then TXT := ' ���������� ������� ������� ' + TXT else//����.�����. ������� ���
            if not ObjZv[ObjZv[ID_Obj].BasOb].bP[8]
            then TXT := ' ������� ������� � ������ ������ ' + TXT;//����.�����.�����������
            if TXT = ObjZv[ObjZv[ID_Obj].BasOb].Liter then TXT := '';
          end;
          if TXT <> '' then //-------------- ���� ��������� ����������� �������� �� ��-���
          begin
            InsNewMsg(ID_Obj,328+$4000,1,'');  //---- ������ ���������� ������� �� �������
            msg := GetSmsg(1,328, ObjZv[ID_Obj].Liter,1) + ' -' + TXT;
            //ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
            exit;
          end else
          if ObjZv[ID_Obj].ObCB[2] and //------------ ���� ����� ���� ������ � � ...
          ObjZv[ID_Obj].ObCB[3] then //------------------------- ����� ���� ������ �
          begin //--------------------------------------------- ������� ��������� ��������
            if ObjZv[ID_Obj].ObCI[14] > 0 then  //---------- ���� ���� ������� ��� �
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //-- ��������� �������
              u1 := msg = '';
            end else u1 := true;

            if ObjZv[ID_Obj].ObCI[15] > 0 then  //------ ����  ���� ������� ��� �(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //-- ��������� �������
              u2 := msg = '';
            end else u2 := false;

            uo := u1 or u2;
            if ObjZv[ID_Obj].ObCI[17] > 0 then //--------- ����  ���� ������� ��� ��
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]); //-- ��������� �������
              u1 := msg = '';
            end  else u1 := true;

            if ObjZv[ID_Obj].ObCI[18] > 0 then //------ ����  ���� ������� ��� ��(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]); //-- ��������� �������
              u2 := msg = '';
            end else u2 := false;

            if uo and (u1 or u2) then
            begin
              InsNewMsg(ID_Obj,181+$4000,7,'');  //----------------- ���������� ������� $?
              InsNewMsg(ID_Obj,182+$4000,2,''); //-------------------- �������� ������� $?
              AddDspMenuItem(GetSmsg(1,181, '',7), M_BeginMarshManevr,ID_Obj);
              AddDspMenuItem(GetSmsg(1,182, '',2), M_BeginMarshPoezd,ID_Obj);
            end else

            if uo then
            begin //------------------------------------------------ ������������ ��������
              InsNewMsg(ID_Obj,182+$4000,2,''); //---------------------- �������� ������� $?
              msg := GetSmsg(1,182, '�� ' + ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshPoezd;
              DspCom.Obj := ID_Obj;
            end else

            if u1 or u2 then
            begin //---------------------------------------------- ������������ ����������
              InsNewMsg(ID_Obj,181+$4000,7,''); //-------------------- ���������� ������� $?
              msg := GetSmsg(1,181, '�� ' + ObjZv[ID_Obj].Liter,7);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshManevr;
              DspCom.Obj := ID_Obj;
            end else
            begin //- ����� �� ����������� ��-�� ���������� ���������� ��������� ���������
              InsNewMsg(ID_Obj,328+$4000,1,'');  //-- ������ ���������� ������� �� �������
              ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
              exit;
            end;
          end else
          if ObjZv[ID_Obj].ObCB[2] then  //--------- �� ������� ���� �������� ������
          begin //--------------------------------------- ������ ������ ��������� ��������
            if ObjZv[ID_Obj].ObCI[14] > 0 then //���� ������� 1 ��� ������ ���������
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]);
              u1 := msg = '';
            end
            else u1 := true; //------------------------ ��� ������� 1 ��� ������ ���������

            if ObjZv[ID_Obj].ObCI[15] > 0 then //���� ������� 2 ��� ������ ���������
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]);
              u2 := msg = '';
            end
            else u2 := true;

            if u1 and u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              InsNewMsg(ID_Obj,182+$4000,2,''); //-------------------- �������� ������� $?
              msg := GetSmsg(1,182, '�� ' + ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshPoezd;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          if ObjZv[ID_Obj].ObCB[3] then//���� � ������� ���������� ������ ����������
          begin //------------------------------------- ������ ������ ����������� ��������
            if ObjZv[ID_Obj].ObCI[17] > 0 then //-- ���� ���� ������� 1 ��� ��������
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);
              u1 := msg = '';
            end else u1 := true;

            if ObjZv[ID_Obj].ObCI[18] > 0 then //-- ���� ���� ������� 2 ��� ��������
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              InsNewMsg(ID_Obj,181+$4000,2,'');  //----------------- ���������� ������� $?
              msg := GetSmsg(1,181, '�� ' + ObjZv[ID_Obj].Liter,7);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshManevr;
              DspCom.Obj := ID_Obj;
              result := true;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end;
      end;
    end else
    begin //------------------------------------------------- ����� ����������� ����������
      if ObjZv[ID_Obj].bP[2] or ObjZv[ID_Obj].bP[4] then //----- ���� ��2 ��� �2
      begin //-------------------------------------------------------------- ������ ������
        InsNewMsg(ID_Obj,230+$4000,1,''); //-------------------------- ������ $ ��� ������
        ShowSmsg(230,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if ObjZv[ID_Obj].bP[1] or ObjZv[ID_Obj].bP[3] then //--- ���� ��1 ��� �1
      begin //------------------------------------------------- ������ �� �������� �������
        InsNewMsg(ID_Obj,402+$4000,1,''); // ������� ������� �� ����.������� $ �� ��������
        ShowSmsg(402,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if CheckProtag(ID_Obj) then
      begin  //--------- ������� ������ ��� �������� (������������� ��������� ����������)?
        InsNewMsg(ID_Obj,416+$4000,7,'');
        msg := GetSmsg(1,416, ObjZv[ID_Obj].Liter,7);
      end else
      if ObjZv[ID_Obj].bP[6] or   //-------------------------- ���� �� �� FR3 ��� ...
      ObjZv[ID_Obj].bP[7] then //------------------------------------ ��� �����������
      begin
        if ObjZv[ID_Obj].bP[11] then //------------ ���� ��������� ����������� ������
        begin //-------------- ��������� ������� ������������ ������� ����������� ��������
          if MarhTrac.LockPovtor then begin ResetTrace;exit;end;//���� ������������ ������
          if ObjZv[ID_Obj].ObCI[17] > 0 then
          begin msg:=CheckStartTrace(ObjZv[ID_Obj].ObCI[17]); u1:= msg='';end
          else u1:= true;

          if ObjZv[ID_Obj].ObCI[18] > 0 then
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
            u2 := msg = '';
          end  else u2 := false;

          if u1 or u2 then
          begin //---------------------------- ������ ������� ������� ����������� ��������
            InsNewMsg(ID_Obj,173+$4000,7,'');
            msg := GetSmsg(1,173, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_PovtorOtkrytManevr;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //--------------- ������� ��, ������ ������ - ��������� �������� �����������
          if ObjZv[ID_Obj].ObCI[17] > 0 then
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);
            u1 := msg = '';
          end else u1 := true;

          if ObjZv[ID_Obj].ObCI[18] > 0 then
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
            u2 := msg = '';
          end  else u2 := false;

          if u1 or u2 then
          begin //-------------------------------------- ������ ������� ������ �����������
            InsNewMsg(ID_Obj,177+$4000,7,'');
            msg := GetSmsg(1,177, ObjZv[ID_Obj].Liter,7);
            DspCom.Active := true;
            DspCom.Com := M_PovtorManevrovogo;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZv[ID_Obj].bP[8] or  //---------------------------- ���� � �� FR3 ��� ...
      ObjZv[ID_Obj].bP[9] then //------------------------------------ ��� �����������
      begin
        if ObjZv[ID_Obj].bP[11] then  //------------ ���� �������� ����������� ������
        begin  //--------------- ��������� ������� ������������ ������� ��������� ��������
          if MarhTrac.LockPovtor then begin ResetTrace;exit;end;//���� ������ ������������

          if ObjZv[ID_Obj].ObCI[14] > 0 then    //-------- ���� ���� ������� 1 ��� �
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //---- ��������� �������
            u1 := msg = '';
          end else u1 := true;

          if ObjZv[ID_Obj].ObCI[15] > 0 then    //-------- ���� ���� ������� 2 ��� �
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //---- ��������� �������
            u2 := msg = '';
          end else u2 := false;

          if u1 or u2 then
          begin //------------------------------ ������ ������� ������� ��������� ��������
            InsNewMsg(ID_Obj,174+$4000,2,''); //---------------------- ������� �������� $?
            msg := GetSmsg(1,174, ObjZv[ID_Obj].Liter,2);
            DspCom.Com := M_PovtorOtkrytPoezd;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //------------------ ������� �, ������ ������ - ��������� �������� ���������
          if ObjZv[ID_Obj].ObCI[14] > 0 then
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]);
            u1 := msg = '';
          end  else u1 := true;

          if ObjZv[ID_Obj].ObCI[15] > 0 then
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]);
            u2 := msg = '';
          end else u2 := false;

          if u1 or u2 then
          begin //-------------------------------------- ������ ������� ������ �����������
            InsNewMsg(ID_Obj,178+$4000,2,'');   //----------- �������� ������� �������� $?
            msg := GetSmsg(1,178, ObjZv[ID_Obj].Liter,2);
            DspCom.Active := true;
            DspCom.Com := M_PovtorPoezdnogo;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZv[ID_Obj].bP[14] or // ���� ���� ����������� ��������� �� �� ��� ��� ...
      ((ObjZv[ID_Obj].BasOb <> 0) and  //------------- ���� ����������� ������ � ...
      (ObjZv[ObjZv[ID_Obj].BasOb].bP[14] or //-- �� ���������� �������� ��� ...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[2] or  //-- �� �������� ������� ��� ...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[7] or  //- �����. ��������� FR3 ��� ...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[8])) then//�����. ��������� �����������
      begin //------------------- ��������������� ��������� ����������� �������� �� ��-���
        InsNewMsg(ID_Obj,328+$4000,1,''); //--------- ������ ���������� ������� �� �������
        msg := GetSmsg(1,328, ObjZv[ID_Obj].Liter,1);
        ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else

      if ObjZv[ID_Obj].ObCB[2] and //------- ���� ������ ����� ������ �������� � ...
      ObjZv[ID_Obj].ObCB[3] then //------------------ ������ ����� ������ ����������
      begin //------------------------------------------------- ������� ��������� ��������
        if ObjZv[ID_Obj].ObCI[14] > 0 then //--- ���� � ������� ���� ������� 1 ��� �
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]);//------- ��������� �������
          u1 := msg = ''; //---------------- ������� ����, �� ��� �� ������ ? ��� ������ ?
        end
        else u1 := true; //---------------------------- ������� ���, ������� ��� �� ������

        if ObjZv[ID_Obj].ObCI[15] > 0 then //--- ���� � ������� ���� ������� 2 ��� �
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]);//------- ��������� �������
          u2 := msg = ''; //---------------- ������� ����, �� ��� �� ������ ? ��� ������ ?
        end
        else u2 := false; //--------------------------- ������� ���, ������� ��� �� ������

        uo := u1 or u2;  //---------------------------------- �������� ������� 1 � 2 ��� �

        if ObjZv[ID_Obj].ObCI[17] > 0 then   //---------- ���� ���� ������� 1 ��� ��
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);//-- ��������� ������� 1 ��
          u1 := msg = ''; //---------------- ������� ����, �� ��� �� ������ ? ��� ������ ?
        end else u1 := true;

        if ObjZv[ID_Obj].ObCI[18] > 0 then   //---------- ���� ���� ������� 2 ��� ��
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);//�������� ������� 2 ��� ��
          u2 := msg = '';
        end  else u2 := false;

        if uo and (u1 or u2) then //���������� ������� (1 ��� 2) ���  � � (1 ��� 2) ��� ��
        begin  //----------------- ���� ��� �������: ��� � � ��� ��, ������� ���� ��������
          InsNewMsg(ID_Obj,173+$4000,7,'');  //--------------------- ������� ���������� $?
          InsNewMsg(ID_Obj,174+$4000,2,'');   //---------------------- ������� �������� $?
          AddDspMenuItem(GetSmsg(1,173, '',7), M_OtkrytManevrovym,ID_Obj);
          AddDspMenuItem(GetSmsg(1,174, '',2), M_OtkrytPoezdnym,ID_Obj);
        end else
        if uo then //------------------------------------------- ���� ������� ������ ��� �
        begin
          InsNewMsg(ID_Obj,174+$4000,2,'');  //----------------------- ������� �������� $?
          msg := GetSmsg(1,174, ObjZv[ID_Obj].Liter,2);
          DspCom.Com := M_OtkrytPoezdnym;
          DspCom.Obj := ID_Obj;
        end else
        if u1 or u2 then //------------------------------------ ���� ������� ������ ��� ��
        begin
          InsNewMsg(ID_Obj,173+$4000,7,'');//----------------------- ������� ���������� $?
          msg := GetSmsg(1,173, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_OtkrytManevrovym;
          DspCom.Obj := ID_Obj;
        end else
        begin //-------------------- ����� ��-�� ���������� ���������� ��������� ���������
          InsNewMsg(ID_Obj,328+$4000,1,''); //------- ������ ���������� ������� �� �������
          ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end else

      if ObjZv[ID_Obj].ObCB[2] then  //--------- ���� � ������� ���� �������� ������
      begin //--------------------------------------------------- ������ �������� ��������
        if ObjZv[ID_Obj].ObCI[14] > 0 then //--- ���� � ������� ���� ������� 1 ��� �
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //�������� ������� 1 ��� �
          u1 := msg = '';
        end else u1 := true;

        if ObjZv[ID_Obj].ObCI[15] > 0 then //--- ���� � ������� ���� ������� 2 ��� �
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //�������� ������� 2 ��� �
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- ������ ������� ������ �����������
          InsNewMsg(ID_Obj,174+$4000,2,''); //---------------------- "������� �������� $?"
          msg := GetSmsg(1,174, ObjZv[ID_Obj].Liter,2);
          DspCom.Com := M_OtkrytPoezdnym;
          DspCom.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- ����� �� ������ �����������
          PutSmsg(1,LastX,LastY,msg);
          exit;
        end;
      end else

      if ObjZv[ID_Obj].ObCB[3] then   //------ ���� � ������� ���� ������ ����������
      begin //------------------------------------------------- ������ �������� ����������
        if ObjZv[ID_Obj].ObCI[17] > 0 then //------------ ���� ���� ������� 1 ��� ��
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);  //------ �������� �������
          u1 := msg = '';
        end else u1 := true;

        if ObjZv[ID_Obj].ObCI[18] > 0 then //------------ ���� ���� ������� 2 ��� ��
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);  //------ �������� �������
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- ������ ������� ������ �����������
          InsNewMsg(ID_Obj,173+$4000,7,''); //-------------------- "������� ���������� $?"
          msg := GetSmsg(1,173, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_OtkrytManevrovym;
          DspCom.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- ����� �� ������ �����������
          PutSmsg(1,LastX,LastY,msg);
          exit;
        end;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//------------------------------  ������� ���������� ���� ��� ��� ���������� �������������
function NewMenu_AvtoSvetofor(X,Y : SmallInt): boolean;
var
  color : Integer;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}

  if Spec_Reg(ID_Obj) then exit;

  if WorkMode.MarhOtm then //----------------------- ���� ����� ���������� ������ ��������
  begin
    if ObjZv[ID_Obj].bP[1] then //------------------------ ���� �������� ������������
    begin
      InsNewMsg(ID_Obj,420+$4000,7,'');//-------- ������ ������ "��������� ������������ ?"
      WorkMode.MarhOtm := false;
      msg := GetSmsg(1,420, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_AutoMarshOtkl;
      DspCom.Obj := ID_Obj;
    end else //----------------------------------------------- ���� ������������ ���������
    begin
      InsNewMsg(ID_Obj,408+$4000,1,''); //---------- ������ ����� "������������ ���������"
      msg := GetSmsg(1,408, ObjZv[ID_Obj].Liter,7);
      ShowSmsg(408,LastX,LastY,'');
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZv[ID_Obj].bP[1] then
    begin
      InsNewMsg(ID_Obj,420+$4000,7,'');//--------- ������ ������ "��������� ������������?"
      WorkMode.MarhOtm := false;
      msg := GetSmsg(1,420, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_AutoMarshOtkl;
      DspCom.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------- �������� ������������
      InsNewMsg(ID_Obj,419+$4000,7,'');//---------- ������ ������ "�������� ������������?"
      WorkMode.MarhOtm := false;
      msg := GetSmsg(1,419, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_AutoMarshVkl;
      DspCom.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//---------------------------------  ������� ���������� ���� ��� ��� ���������� ��� ���� 1
function NewMenu_1bit(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;   result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}

  if Spec_Reg(ID_Obj) then exit;

  if ObjZv[ID_Obj].bP[1] then
  begin
    if ObjZv[ID_Obj].ObCI[5] > 0 then
    begin
      InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[5]+$4000,7,'');//--------- ������ ������ ���������?
      WorkMode.MarhOtm := false;
      msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
      PutSmsg(7,LastX,LastY,msg);
      DspCom.Com := M_OtklBit1;
      DspCom.Obj := ID_Obj;
    end else
    begin
      InsNewMsg(ID_Obj,572,1,''); //-----------------  ������ ��������� � ��������� ���������
      msg := GetSmsg(1,572, '',1);
      PutSmsg(1,LastX,LastY,msg);
      DspMenu.WC := false;
      DspCom.Com := 0;
      DspCom.Obj := 0;
      exit;
    end;
  end else
  begin //---------------------------------------------------------------- �������� ���-��
    if ObjZv[ID_Obj].ObCI[4] > 0 then
    begin
      InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[4]+$4000,7,'');//---------- ������ ������ ��������?
      msg := MsgList[ObjZv[ID_Obj].ObCI[4]];
      WorkMode.MarhOtm := false;
      DspCom.Com := M_VklBit1;
      DspCom.Obj := ID_Obj;
    end else
    begin
      InsNewMsg(ID_Obj,572,1,''); //-----------------  ������ ��������� � ��������� ���������
      msg := GetSmsg(1,572, '',1);
      PutSmsg(1,LastX,LastY,msg);
      DspMenu.WC := false;
      DspCom.Com := 0;
      DspCom.Obj := 0;
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
function NewMenu_VklOtkl1bit(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}

  if Spec_Reg(ID_Obj) then exit;

  if ObjZv[ID_Obj].bP[1] then
  begin
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[5]+$4000,7,'');//������ ������ ������ ����
    WorkMode.MarhOtm := false;
    msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
    DspCom.Com := M_VklBit1_2;
    DspCom.Obj := ID_Obj;
  end else
  begin //-------------------------------------------------------------- �������� ���-��
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[4]+$4000,7,'');//������ ������ � ���������
    msg := MsgList[ObjZv[ID_Obj].ObCI[4]];
    WorkMode.MarhOtm := false;
    DspCom.Com := M_VklBit1_1;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
function NewMenu_2bit(X,Y : SmallInt): boolean;
var
  razresh : integer;
begin
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}

  if ObjZv[ID_Obj].BasOb <> 0 then
  begin
    razresh := ObjZv[ID_Obj].BasOb;
    if not ObjZv[razresh].bP[1] then
    begin
      InsNewMsg(razresh,543+$4000,1,'');  //--------------- ������� ������������� ��������
      msg := GetSmsg(1,543, ObjZv[razresh].Liter,1);
      exit;
    end;
  end;

  DspMenu.obj := cur_obj;

  if Spec_Reg(ID_Obj) then exit;

  if ObjZv[ID_Obj].bP[1] then
  begin
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[5]+$4000,7,'');// ������ ������ ���������?
    WorkMode.MarhOtm := false;
    msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
    DspCom.Com := M_OtklBit2;
    DspCom.Obj := ID_Obj;
    result := true;
  end else
  begin //-------------------------------------------------------------- �������� ���-��
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[4]+$4000,7,'');//������ ������ �������� ?
    msg := MsgList[ObjZv[ID_Obj].ObCI[4]];
    WorkMode.MarhOtm := false;
    DspCom.Com := M_VklBit2;
    DspCom.Obj := ID_Obj;
    result := true;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------- ���������� ���� ��� ������� ��� �������������� ���������� ������ ��������
function NewMenu_ZaprRazrMont(X,Y : SmallInt): boolean;
var
  TXT : string;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}

  if not ObjZv[ID_Obj].bP[1] and NazataKOK(ID_Obj) then exit;
  if ActivenVSP(ID_Obj) then exit;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;

  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end; //- �������� ������

  if not WorkMode.OtvKom and (not ObjZv[ID_Obj].bP[1])then //---- ��� �������,�� ������ ��
  begin
    InsNewMsg(ID_Obj,199+$4000,7,''); msg := GetSmsg(1,199, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_DatZapretMonteram;
    DspCom.Obj := ID_Obj;
  end else  //------------------------------------------------------ ���� ������, ����� ��
  begin
    if WorkMode.OtvKom then
    begin //------------------------------------------- ������ ������ ������������� ������
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsNewMsg(ID_Obj,528+$4000,7,'');
        msg := GetSmsg(1,528, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_IspolOtklZapMont;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsNewMsg(ID_Obj,527+$4000,7,'');
        msg := GetSmsg(1,527, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvOtklZapMont;
        DspCom.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsNewMsg(ID_Obj,276+$4000,1,'');
      ResetCommands;
      ShowSmsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------- ���������� ���� ��� �������� ��� �������������� �������� ��������
function NewMenu_PRZDZakrOtkr(X,Y : SmallInt): boolean;
var
  TXT : string;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}

  if not (ObjZv[ID_Obj].bP[12] or ObjZv[ID_Obj].bP[13]) and NazataKOK(ID_Obj) then exit;
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;


  if not WorkMode.OtvKom and (not ObjZv[ID_Obj].bP[12] or
  not ObjZv[ID_Obj].bP[13]) then //-------------------- ������ ������� � �� ������ ��
  begin
    InsNewMsg(ID_Obj,192+$4000,7,'');
    msg := GetSmsg(1,192, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_ZakrytPereezd;
    DspCom.Obj := ID_Obj;
  end else  //-------------------------------------------------- ������� ������, ����� ��
  begin
    if WorkMode.OtvKom then
    begin //----------------------------------------- ������ ������ ������������� ������
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsNewMsg(ID_Obj,194+$4000,7,'');
        msg := GetSmsg(1,194, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_IspolOtkrytPereezd;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsNewMsg(ID_Obj,193+$4000,7,'');
        msg := GetSmsg(1,193, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvOtkrytPereezd;
        DspCom.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsNewMsg(ID_Obj,276+$4000,1,'');
      ResetCommands;
      ShowSmsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------- ���������� ���� ��� ������ ��������� �������� �� �������� ����
function NewMenu_VydPSogl(X,Y : SmallInt): boolean;
var
  i : integer;
  u1,u2 : boolean;
begin//------------------------------------------------ �������� �������� �� �������� ����
  DspMenu.obj := cur_obj;
  result := true;
  {$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  i := ID_Obj;

  if WorkMode.OtvKom then
  begin //------------------- ������ �� - ������������� �������� ����������� ��� ���������
    InsNewMsg(ObjZv[i].BasOb,311+$4000,7,'');  //------------------ ������������� $?
    msg := GetSmsg(1,311, ObjZv[ObjZv[i].BasOb].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ObjZv[i].BasOb;
  end else
  if ActivenVSP(ID_Obj) then exit;

  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;

   //--------------------------------------------------------------- ���������� �����
  if WorkMode.InpOgr then exit; //-------------------------------------- ���� �����������

  if ObjZv[ObjZv[i].BasOb].bP[18] then
  begin //-------------------------------------------------------- �� ������� ����������
    InsNewMsg(ObjZv[i].BasOb,232+$4000,1,''); //--- ������ $ �� ������� ����������
    WorkMode.GoMaketSt := false;
    ShowSmsg(232,LastX,LastY,ObjZv[ObjZv[i].BasOb].Liter);
    exit;
  end;
  with ObjZv[i] do
  if WorkMode.MarhOtm then
  begin //----------------------- ������ ��������� ��� ���� ������� ���������� ���������
    if ObjZv[BasOb].bP[8] or ObjZv[BasOb].bP[9] or ObjZv[BasOb].bP[3] or ObjZv[BasOb].bP[4] then
    begin
      if ObjZv[BasOb].bP[3] or ObjZv[BasOb].bP[4] then
      begin //----------------------------------------- �������� ��������, ������ ������
        if UpdOb > 0 then
        begin //------------------------------------------------------ ������ ����� ����
          if ObjZv[UpdOb].bP[2] and  ObjZv[UpdOb].bP[3] then
          begin //------------------------ ��� ��������� �� ��������� ���� - ���� ������
            InsNewMsg(BasOb,184+$4000,7,'');//�������� ����.�����.������?
            msg := GetSmsg(1,184, '�� ' + ObjZv[BasOb].Liter,7);
            DspCom.Com := M_OtmenaPoezdnogo;
            DspCom.Obj := BasOb;
          end else
          begin
            InsNewMsg(BasOb,254+$4000,1,'');//------ ������� ������� �� $
            ShowSmsg(254,LastX,LastY,ObjZv[BasOb].Liter); exit;
          end;
        end else
        begin //------------------------------------------ ������ �� ���������� � ������
          if bP[2] then
          begin //------------------------------------------- ������� ������� �� �������
            InsNewMsg(ID_Obj,254+$4000,1,'');
            ShowSmsg(254,LastX,LastY,ObjZv[BasOb].Liter);
            exit;
          end else
          begin //---------------------------------------- �� ������� ������� �� �������
            InsNewMsg(BasOb,184+$4000,1,'');
            msg := GetSmsg(1,184, '�� ' + ObjZv[BasOb].Liter,1);
            DspCom.Com := M_OtmenaPoezdnogo;
            DspCom.Obj := BasOb;
          end;
        end;
      end else
      begin //������ �� ��������������� - ������ ������� ��� �������� ��������� ��������
        InsNewMsg(BasOb,184+$4000,7,''); //- �������� ����.�����.������?
        msg := GetSmsg(1,184, '�� ' + ObjZv[BasOb].Liter,7);
        DspCom.Com := M_OtmenaPoezdnogo;
        DspCom.Obj := BasOb;
      end;
    end;
  end else
  if ObjZv[BasOb].bP[13] and not WorkMode.GoTracert then
  begin //-------------------------------------------------------- �������� ������������
    InsNewMsg(BasOb,123+$4000,1,'');
    ShowSmsg(123,LastX,LastY,ObjZv[BasOb].Liter);
    exit;
  end else
  if WorkMode.MarhUpr then
  begin //------------------------------------------------- ����� ����������� ����������
    if CheckMaket then
    begin //--------------- ����� ���������� �� ��������� - ����������� ���������� �����
      InsNewMsg(ID_Obj,344+$4000,1,'');
      ShowSmsg(344,LastX,LastY,ObjZv[ID_Obj].Liter);
      ShowWarning := true;
      exit;
    end else
    if WorkMode.CmdReady then
    begin //--------------------- �������� �������� � ������ - ����� ���������� ��������
      InsNewMsg(ID_Obj,239+$4000,1,'');
      ShowSmsg(239,LastX,LastY,''); exit;
    end else
    if WorkMode.GoTracert then
    begin //-------------------------------------------------- ����� ������������� �����
      DspCom.Active  := true;
      DspCom.Com := CmdMarsh_Tracert;
      DspCom.Obj := BasOb;
      exit;
    end else
    begin //------------------------------------ ��������� ������������ �������� �������
      if bP[1] then
      begin //-------------------------------------------------------- ������ ������ ���
        InsNewMsg(BasOb,105+$4000,1,'');
        ShowSmsg(105,LastX,LastY,ObjZv[BasOb].Liter);
        exit;
      end else
      if ObjZv[BasOb].bP[1] or ObjZv[BasOb].bP[2] or ObjZv[BasOb].bP[3] or  ObjZv[BasOb].bP[4] then
      begin //------------------------------------------------------------ ������ ������
        InsNewMsg(BasOb,230+$4000,1,'');
        ShowSmsg(230,LastX,LastY,ObjZv[BasOb].Liter);
        exit;
      end else
      if ObjZv[BasOb].bP[7] then exit //------------ ������� - �����
      else
      if ObjZv[BasOb].bP[9] then
      begin
        if ObjZv[BasOb].bP[11] then
        begin //---------- ����������� ������ �� �������� - ����� �� ���������� ��������
          InsNewMsg(BasOb,229+$4000,1,'');
          ShowSmsg(229,LastX,LastY,ObjZv[BasOb].Liter);
          exit;
        end else
        begin //---------------- ������� �, ������ ������ - ��������� �������� ���������
          InsNewMsg(BasOb,178+$4000,2,'');
          msg := GetSmsg(1,178, ObjZv[BasOb].Liter,2);
          DspCom.Active := true;
          DspCom.Com := M_PovtorPoezdnogo;
          DspCom.Obj := BasOb;
        end;
      end else
      if ObjZv[ID_Obj].bP[14] then
      begin //----------------------------- ��������������� ��������� �������� �� ��-���
        //--------------------- ��������� ������� ������������ ������� ��������� ��������
        if ObjZv[BasOb].ObCI[14] > 0 then
        begin
          msg := CheckStartTrace(ObjZv[BasOb].ObCI[14]);
          u1 := msg = '';
        end
        else u1 := true;

        if ObjZv[BasOb].ObCI[15] > 0 then
        begin
          msg := CheckStartTrace(ObjZv[BasOb].ObCI[15]);
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //------------------------------ ������ ������� ������� ��������� ��������
          InsNewMsg(BasOb,178+$4000,2,'');
          msg := GetSmsg(1,178, ObjZv[BasOb].Liter,2);
          DspCom.Active := true;
          DspCom.Com := M_PovtorPoezdMarsh;
          DspCom.Obj := ID_Obj;
        end else
        begin //-------------------------------------------- ����� �� ������ �����������
          PutSmsg(1,LastX,LastY,msg);
          exit;
        end;
      end else
      begin //----------------------------------------- ������ ������ ��������� ��������
        InsNewMsg(BasOb,183+$4000,2,'');
        msg := GetSmsg(1,183, '�� ' + ObjZv[BasOb].Liter,2);
        DspCom.Active := true;
        DspCom.Com := M_BeginMarshPoezd;
        DspCom.Obj := BasOb;
      end;
    end;
  end else
  begin //------------------------------------------------- ����� ����������� ����������
    if bP[1] then
    begin // ������ ������ ���
      InsNewMsg(BasOb,105+$4000,1,'');
      ShowSmsg(105,LastX,LastY,ObjZv[BasOb].Liter);
      exit;
    end else
    if ObjZv[BasOb].bP[1] or ObjZv[BasOb].bP[2] or
    ObjZv[BasOb].bP[3] or ObjZv[BasOb].bP[4] then
    begin //-------------------------------------------------------------- ������ ������
      InsNewMsg(BasOb,230+$4000,1,'');
      ShowSmsg(230,LastX,LastY,ObjZv[BasOb].Liter);
      exit;
    end else
    if ObjZv[BasOb].bP[9] then
    begin
      if ObjZv[BasOb].bP[11] then
      begin //------------ ����������� ������ �� �������� - ����� �� ���������� ��������
        InsNewMsg(BasOb,229+$4000,1,'');
        ShowSmsg(229,LastX,LastY,ObjZv[BasOb].Liter);
        exit;
      end else
      begin //------------------ ������� �, ������ ������ - ��������� �������� ���������
        InsNewMsg(BasOb,178+$4000,2,'');
        msg := GetSmsg(1,178, ObjZv[BasOb].Liter,2);
        DspCom.Active := true;
        DspCom.Com := M_PovtorPoezdnogo;
        DspCom.Obj := BasOb;
      end;
    end else
    if bP[14] then
    begin //------------------------------- ��������������� ��������� �������� �� ��-���
      //---------------------- ��������� ������� ������������ ������� ��������� ��������
      if MarhTrac.LockPovtor then begin ResetTrace; exit; end;
      if ObjZv[BasOb].ObCI[14] > 0 then
      begin
        msg := CheckStartTrace(ObjZv[BasOb].ObCI[14]);
        u1 := msg = '';
      end  else u1 := true;
      if ObjZv[BasOb].ObCI[15] > 0 then
      begin
        msg := CheckStartTrace(ObjZv[BasOb].ObCI[15]);
        u2 := msg = '';
      end else u2 := false;
      if u1 or u2 then
      begin //-------------------------------- ������ ������� ������� ��������� ��������
        InsNewMsg(BasOb,174+$4000,2,'');
        msg := GetSmsg(1,174, ObjZv[BasOb].Liter,2);
        DspCom.Com := M_PovtorOtkrytPoezd;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------- ����� �� ������ �����������
        PutSmsg(1,LastX,LastY,msg);
        exit;
      end;
    end else
    begin //--------------------------------------------------- ������ �������� ��������
      InsNewMsg(BasOb,183+$4000,2,'');
      msg := GetSmsg(1,183, ObjZv[BasOb].Liter,2);
      DspCom.Com := M_OtkrytPoezdnym;
      DspCom.Obj := BasOb;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------- ���������� ���� ��� ������ "������ �� �����"
function NewMenu_Nadvig(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if WorkMode.OtvKom then
  begin //------------------- ������ �� - ������������� �������� ����������� ��� ���������
    InsNewMsg(ID_Obj,311+$4000,7,'');
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ID_Obj;
  end else
  begin
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZv[ID_Obj].bP[13] then
      begin //---------------------------------------------------- �������������� ��������
        InsNewMsg(ID_Obj,180+$4000,7,'');
        msg := GetSmsg(1,180, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_DeblokirovkaNadviga;
        DspCom.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- ������������� ��������
        InsNewMsg(ID_Obj,179+$4000,7,'');
        msg := GetSmsg(1,179, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_BlokirovkaNadviga;
        DspCom.Obj := ID_Obj;
      end;
    end else
    if ObjZv[ID_Obj].bP[13] then
    begin //-------------------------------------------------------- �������� ������������
      InsNewMsg(ID_Obj,123+$4000,1,'');
      ShowSmsg(123,LastX,LastY,ObjZv[ID_Obj].Liter); exit;
    end else
    if WorkMode.MarhUpr then
    begin //------------------------------------------------- ����� ����������� ����������
      if WorkMode.CmdReady then
      begin //--------------------- �������� �������� � ������ - ����� ���������� ��������
        InsNewMsg(ID_Obj,239+$4000,1,'');
        ShowSmsg(239,LastX,LastY,'');
        exit;
      end else
      if WorkMode.GoTracert then
      begin //-------------------------------------------------- ����� ������������� �����
        DspCom.Active  := true;
        DspCom.Com := CmdMarsh_Tracert;
        DspCom.Obj := ID_Obj;
        exit;
      end
      else exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------- ���������� ���� ���������� �������� "������� �� ��� �������������"
function NewMenu_Uchastok(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;  exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin  WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit else
  begin //--------------------------------------------------------------- ���������� �����
    if ObjZv[ID_Obj].bP[19] then
    begin //---------------------------------------- ���������� ���������������� ���������
      ObjZv[ID_Obj].bP[19] := false;
      exit;
    end else
    if ObjZv[ID_Obj].bP[9] or not ObjZv[ID_Obj].bP[5] then
    begin //-------------------------------------------------------- �� ������� ����������
      InsNewMsg(ID_Obj,233+$4000,1,'');
      WorkMode.GoMaketSt := false;
      ShowSmsg(233,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZv[ID_Obj].bP[33] then
      begin //------------------------------------------------------ �������� ������������
        InsNewMsg(ID_Obj,431+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(431, LastX, LastY, '');
        exit;
      end else
      if not ObjZv[ID_Obj].bP[8] or ObjZv[ID_Obj].bP[14] then
      begin //--------------------------------------------------- ������ � ������ ��������
        InsNewMsg(ID_Obj,512+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(512, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZv[ID_Obj].ObCB[8] or
        ObjZv[ID_Obj].ObCB[9] then //--------- ���� �������� �������� �� �����������
        begin
          //------------------------------------------------------------ �������� ��������
          if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            InsNewMsg(ID_Obj,171+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,170, '',7), M_SekciaZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,171, '',7), M_SekciaOtkrytDvijenie,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,171+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,171, '',7), M_SekciaOtkrytDvijenie,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,170, '',7), M_SekciaZakrytDvijenie,ID_Obj);
          end;
          //--------------------------------------------- �������� �������� �� �����������
          if ObjZv[ID_Obj].bP[24] <> ObjZv[ID_Obj].bP[27] then
          begin
            InsNewMsg(ID_Obj,458+$4000,7,'');
            InsNewMsg(ID_Obj,459+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,458, '',7), M_SekciaZakrytDvijenieET,ID_Obj);
            AddDspMenuItem(GetSmsg(1,459, '',7), M_SekciaOtkrytDvijenieET,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[27] then
          begin
            InsNewMsg(ID_Obj,459+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,459, '',7), M_SekciaOtkrytDvijenieET,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,458+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,458, '',7), M_SekciaZakrytDvijenieET,ID_Obj);
          end;
          if ObjZv[ID_Obj].ObCB[8] and
          ObjZv[ID_Obj].ObCB[9] then //--------------------- ���� 2 ���� �����������
          begin //---------------------- �������� �������� �� ����������� ����������� ����
            if ObjZv[ID_Obj].bP[25] <> ObjZv[ID_Obj].bP[28] then
            begin
              InsNewMsg(ID_Obj,463+$4000,7,'');
              InsNewMsg(ID_Obj,464+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,463,'',7),M_SekciaZakrytDvijenieETD,ID_Obj);
              AddDspMenuItem(GetSmsg(1,464,'',7),M_SekciaOtkrytDvijenieETD,ID_Obj);
            end else
            if ObjZv[ID_Obj].bP[28] then
            begin
              InsNewMsg(ID_Obj,464+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,464,'',7),M_SekciaOtkrytDvijenieETD,ID_Obj);
            end else
            begin
              InsNewMsg(ID_Obj,463+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,463,'',7),M_SekciaZakrytDvijenieETD,ID_Obj);
            end;
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZv[ID_Obj].bP[26] <> ObjZv[ID_Obj].bP[29] then
            begin
              InsNewMsg(ID_Obj,468+$4000,7,'');
              InsNewMsg(ID_Obj,469+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,468,'',7),M_SekciaZakrytDvijenieETA,ID_Obj);
              AddDspMenuItem(GetSmsg(1,469,'',7),M_SekciaOtkrytDvijenieETA,ID_Obj);
            end else
            if ObjZv[ID_Obj].bP[29] then
            begin
              InsNewMsg(ID_Obj,469+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,469,'',7),M_SekciaOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsNewMsg(ID_Obj,468+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,468,'',7),M_SekciaZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //---------------------------------------------------------- ��� �����������
          if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            InsNewMsg(ID_Obj,171+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,170,'',7),M_SekciaZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,171,'',7),M_SekciaOtkrytDvijenie,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,171+$4000,7,'');
            msg := GetSmsg(1,171, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_SekciaOtkrytDvijenie;
            DspCom.Obj := ID_Obj;
          end else
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            msg := GetSmsg(1,170, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_SekciaZakrytDvijenie;
            DspCom.Obj := ID_Obj;
          end;
        end;
      end;
    end else

    if not ObjZv[ID_Obj].bP[31] then
    begin //---------------------------------------------------------- ��� ������ � ������
      InsNewMsg(ID_Obj,293+$4000,1,'');
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowSmsg(293, LastX, LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else

    if WorkMode.GoTracert then
    begin //---------------------------------------------------- ����� ������������� �����
      DspCom.Active  := true;
      DspCom.Com := CmdMarsh_Tracert;
      DspCom.Obj := ID_Obj;
      exit;
    end else
    if WorkMode.OtvKom then
    begin //------------------------------------------- ������ ������ ������������� ������
      if ObjZv[ID_Obj].ObCB[7] then
      begin //---- ��� ������ � ������� �������� ������ ������� �����. ���������� ��������
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- �������������� �������
          OtvCommand.SObj := ID_Obj;
          InsNewMsg(ID_Obj,214+$4000,7,'');
          msg := GetSmsg(1,214, ObjZv[ObjZv[ID_Obj].BasOb].Liter,7);
          DspCom.Com := M_SekciaIspolnitRI;
          DspCom.Obj := ID_Obj;
        end else
        if ObjZv[ID_Obj].bP[2] then
        begin //-------- ������ ���������� - ������������� �������� ����������� ��� ������
          InsNewMsg(ID_Obj,311+$4000,7,'');
          msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := CmdMarsh_ResetTraceParams;
          DspCom.Obj := ID_Obj;
        end else
        begin //---------------------------------------------------------- ������ ��������
          if ObjZv[ObjZv[ID_Obj].BasOb].bP[1] then
          begin //------------------------------------- ����������� �� �������� - ��������
            InsNewMsg(ID_Obj,335+$4000,1,'');
            ShowSmsg(335,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
//            SingleBeep := true;
            exit;
          end else
          begin //----------------------------- ������ ��������������� ������� �� ��������
            InsNewMsg(ID_Obj,185+$4000,7,'');
            msg := GetSmsg(1,185, ObjZv[ObjZv[ID_Obj].BasOb].Liter,7);
            DspCom.Com := M_SekciaPredvaritRI;
            DspCom.Obj := ID_Obj;
          end;
        end;
      end else
      begin //- ��� ������ ��� ������������ ���������� ������ ������� ������ ������ ��� ��
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- �������������� �������
          OtvCommand.SObj := ID_Obj;
          InsNewMsg(ID_Obj,186+$4000,7,'');
          msg := GetSmsg(1,186, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_SekciaIspolnitRI;
          DspCom.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- ��������������� �������
          if ObjZv[ID_Obj].bP[2] then
          begin //------ ������ ���������� - ������������� �������� ����������� ��� ������
            InsNewMsg(ID_Obj,311+$4000,7,'');
            msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := CmdMarsh_ResetTraceParams;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------------------- ������ ��������
            if ObjZv[ObjZv[ID_Obj].BasOb].bP[1] then
            begin //----------------------------- �������� �������� ������� ��� - ��������
              InsNewMsg(ID_Obj,334+$4000,1,'');
              AddFixMes(GetSmsg(1,334,ObjZv[ID_Obj].Liter,1),4,2);
              exit;
            end else
            if ObjZv[ID_Obj].bP[3] then
            begin //------------------------- ����������� ���.���������� ������ - ��������
              InsNewMsg(ID_Obj,84+$4000,1,'');
              ShowSmsg(84,LastX,LastY,ObjZv[ID_Obj].Liter);
              exit;
            end else
            begin //------------------------------------------- ��������������� ������� ��
              InsNewMsg(ID_Obj,185+$4000,7,'');
              msg := GetSmsg(1,185, ObjZv[ID_Obj].Liter,7);
              DspCom.Com := M_SekciaPredvaritRI;
              DspCom.Obj := ID_Obj;
            end;
          end;
        end;
      end;
    end else exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------- ���������� ���� ���������� �������� "����"
function NewMenu_PutPO(X,Y : SmallInt): boolean;
var
  i : integer;
begin //--------------------------------------------- ����������������� ���� � �����������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------- �� - ������������� �������� ����������� ��� ����
    InsNewMsg(ID_Obj,311+$4000,7,'');
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ID_Obj;
  end else
  if ActivenVSP(ID_Obj) then exit;  
  if WorkMode.MarhOtm then  begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit else
  begin //--------------------------------------------------------------- ���������� �����
    if ObjZv[ID_Obj].bP[19] then begin ObjZv[ID_Obj].bP[19] := false;  exit; end;
    if ObjZv[ID_Obj].bP[9] and not WorkMode.GoTracert then
    begin //-------------------------------------------------------- �� ������� ����������
      InsNewMsg(ID_Obj,234+$4000,1,'');
      WorkMode.GoMaketSt := false;
      ShowSmsg(234,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZv[ID_Obj].bP[33] then
      begin //------------------------------------------------------ �������� ������������
        InsNewMsg(ID_Obj,431+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(431, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      if ObjZv[ID_Obj].bP[9] then
      begin //------------------------------------------------- ���� �� ������� ����������
        InsNewMsg(ID_Obj,234+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(234, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      if not ObjZv[ID_Obj].bP[8] or ObjZv[ID_Obj].bP[14] then
      begin //----------------------------------------------------- ���� � ������ ��������
        InsNewMsg(ID_Obj,513+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(513, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZv[ID_Obj].ObCB[8] or
        ObjZv[ID_Obj].ObCB[9] then //--------- ���� �������� �������� �� �����������
        begin
          //------------------------------------------------------------ �������� ��������
          if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            InsNewMsg(ID_Obj,171+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,170, '',7), M_PutZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,171, '',7), M_PutOtkrytDvijenie,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,171+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,171, '',7), M_PutOtkrytDvijenie,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,170, '',7), M_PutZakrytDvijenie,ID_Obj);
          end;
          //--------------------------------------------- �������� �������� �� �����������
          if ObjZv[ID_Obj].bP[24] <> ObjZv[ID_Obj].bP[27] then
          begin
            InsNewMsg(ID_Obj,458+$4000,7,'');
            InsNewMsg(ID_Obj,459+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,458, '',7), M_PutZakrytDvijenieET,ID_Obj);
            AddDspMenuItem(GetSmsg(1,459, '',7), M_PutOtkrytDvijenieET,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[27] then
          begin
            InsNewMsg(ID_Obj,459+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,459, '',7), M_PutOtkrytDvijenieET,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,458+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,458, '',7), M_PutZakrytDvijenieET,ID_Obj);
          end;
          if ObjZv[ID_Obj].ObCB[8] and
          ObjZv[ID_Obj].ObCB[9] then //--------------------- ���� 2 ���� �����������
          begin
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZv[ID_Obj].bP[25] <> ObjZv[ID_Obj].bP[28] then
            begin
              InsNewMsg(ID_Obj,463+$4000,7,'');
              InsNewMsg(ID_Obj,464+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,463, '',7), M_PutZakrytDvijenieETD,ID_Obj);
              AddDspMenuItem(GetSmsg(1,464, '',7), M_PutOtkrytDvijenieETD,ID_Obj);
            end else
            if ObjZv[ID_Obj].bP[28] then
            begin
              InsNewMsg(ID_Obj,464+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,464,'',7),M_PutOtkrytDvijenieETD,ID_Obj);
            end else
            begin
              InsNewMsg(ID_Obj,463+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,463,'',7),M_PutZakrytDvijenieETD,ID_Obj);
            end;
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZv[ID_Obj].bP[26] <> ObjZv[ID_Obj].bP[29] then
            begin
              InsNewMsg(ID_Obj,468+$4000,7,'');
              InsNewMsg(ID_Obj,469+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,468,'',7),M_PutZakrytDvijenieETA,ID_Obj);
              AddDspMenuItem(GetSmsg(1,469,'',7),M_PutOtkrytDvijenieETA,ID_Obj);
            end else
            if ObjZv[ID_Obj].bP[29] then
            begin
              InsNewMsg(ID_Obj,469+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,469,'',7),M_PutOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsNewMsg(ID_Obj,468+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,468,'',7),M_PutZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //---------------------------------------------------------- ��� �����������
          if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            InsNewMsg(ID_Obj,171+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,170,'',7),M_PutZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,171,'',7),M_PutOtkrytDvijenie,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[13] then
          begin
            InsNewMsg(ID_Obj,171+$4000,7,'');
            msg := GetSmsg(1,171, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_PutOtkrytDvijenie;
            DspCom.Obj := ID_Obj;
          end else
          begin
            InsNewMsg(ID_Obj,170+$4000,7,'');
            msg := GetSmsg(1,170, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_PutZakrytDvijenie;
            DspCom.Obj := ID_Obj;
          end;
        end;
      end;
    end else
    if not ObjZv[ID_Obj].bP[31] then
    begin //---------------------------------------------------------- ��� ������ � ������
      InsNewMsg(ID_Obj,294+$4000,1,'');
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowSmsg(294, LastX, LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.GoTracert then //----------------------- ���� ����� ����������� ����������
    begin //---------------------------------------------------- ����� ������������� �����
      DspCom.Active := true;
      DspCom.Com := CmdMarsh_Tracert;
      DspCom.Obj := ID_Obj;
      result := false;
      exit;
    end else
    begin
      i := ObjZv[ID_Obj].UpdOb;
      if i > 0 then
      begin //------------------------------------------------------- ���� ���������� ����
        if ObjZv[i].T[1].Activ and not ObjZv[i].bP[4] then
        begin //-------------------------------- ����� �������� ��������� ������������� ��
          ObjZv[i].bP[4] := true;
          exit;
        end else
        if ObjZv[i].bP[1] and not ObjZv[i].bP[2] then
        begin //----- ���� ���� ������ ��� - ��������� ������� ������ �������� ����������
          if SoglasieOG(ID_Obj) then
          begin //------------------------------ ��� ��������� ��/� ���� - ������ ��������
            InsNewMsg(ID_Obj,187+$4000,7,'');
            msg := GetSmsg(1,187, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_PutDatSoglasieOgrady;
            DspCom.Obj := ID_Obj;
          end else
          begin //------------------------------------------------ ���� �������� ��/� ����
            InsNewMsg(ID_Obj,393+$4000,1,'');
            ShowSmsg(393,LastX,LastY,ObjZv[ID_Obj].Liter);
            exit;
          end;
        end else exit;
      end else exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------- ���������� ���� ���������� �������� "���"(���������� ���� �� ��������)
function NewMenu_OPI(X,Y : SmallInt): boolean;
var
  Num : Integer;
begin
  DspMenu.obj := cur_obj; result := true;
{$IFNDEF RMDSP} ID_ViewObj := ID_Obj; exit; {$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  WorkMode.InpOgr := false;
  DspCom.Obj := ID_Obj;
  with ObjZv[ID_Obj] do
  begin
    if WorkMode.MarhOtm then
    begin //----------------------------------------------------------------------- ������
      if bP[1] then  //---------------------------------------------- ���� ����������� ���
      begin Num := 413; DspCom.Com := M_PutOtklOPI; end //----------- ��������� ������� ?
      else exit;
    end else
    begin
      if bP[1] then begin Num := 413; DspCom.Com := M_PutOtklOPI; end //��������� �������?
      else begin  Num := 412; DspCom.Com := M_PutVklOPI;  end;  //---- ��������� ������� ?
    end;
    InsNewMsg(ID_Obj,Num+$4000,7,'');  msg := GetSmsg(1,Num, ObjZv[UpdOb].Liter,7);
  end;
  WorkMode.MarhOtm := false;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ ������ ��������� ����������� �� �������� ����
function NewMenu_PSogl(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;  result := true;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj;  exit; {$ELSE}
  if Spec_Reg(ID_Obj) then exit;

  with ObjZv[ID_Obj] do
  begin
    if WorkMode.MarhOtm then
    begin //--------------------------------------------------------------------- ������ -
      if bP[1] then
      begin //--------------------------------------------------- ����� ������ �����������
        InsNewMsg(ID_Obj,216+$4000,7,'');  WorkMode.MarhOtm := false;
        msg := GetSmsg(1,216, Liter,7);
        DspCom.Com := M_OtmZaprosPoezdSoglasiya;  DspCom.Obj := ID_Obj;
      end else  begin WorkMode.MarhOtm := false; exit; end;
    end else
    begin //------------------------------------------------------------- ���������� �����
      if WorkMode.InpOgr then
      begin //----------------------------------------------------------- ���� �����������
        //------------------------------------------ ���� �������� �������� �� �����������
        if ObCB[8] or ObCB[9] then
        begin
          //------------------------------------------------------------ �������� ��������
          if bP[14] <> bP[15] then
          begin
            InsNewMsg(ID_Obj,207+$4000,7,''); InsNewMsg(ID_Obj,206+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytUvjazki,ID_Obj);
            AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytUvjazki,ID_Obj);
          end else
          if bP[15] then
          begin
            InsNewMsg(ID_Obj,207+$4000,7,''); //--------------------------- ������� ������� ?
            AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytUvjazki,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,206+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytUvjazki,ID_Obj);
          end;
          //--------------------------------------------- �������� �������� �� �����������
          if bP[24] <> bP[27] then
          begin
            InsNewMsg(ID_Obj,458+$4000,7,''); InsNewMsg(ID_Obj,459+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,458, '',7), M_EZZakrytDvijenieET,ID_Obj);
            AddDspMenuItem(GetSmsg(1,459, '',7), M_EZOtkrytDvijenieET,ID_Obj);
          end else
          if bP[27] then
          begin
            InsNewMsg(ID_Obj,459+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,459, '',7), M_EZOtkrytDvijenieET,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,458+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,458, '',7), M_EZZakrytDvijenieET,ID_Obj);
          end;

          //------------------------------------------------------ ���� 2 ���� �����������
          if ObCB[8] and ObCB[9] then
          begin
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if bP[25] <> bP[28] then
            begin
              InsNewMsg(ID_Obj,463+$4000,7,''); InsNewMsg(ID_Obj,464+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,463, '',7), M_EZZakrytDvijenieETD,ID_Obj);
              AddDspMenuItem(GetSmsg(1,464, '',7), M_EZOtkrytDvijenieETD,ID_Obj);
            end else
            if bP[28] then
            begin
              InsNewMsg(ID_Obj,464+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,464, '',7), M_EZOtkrytDvijenieETD,ID_Obj);
            end else
            begin
              InsNewMsg(ID_Obj,463+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,463, '',7), M_EZZakrytDvijenieETD,ID_Obj);
            end;
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if bP[26] <> bP[29] then
            begin
              InsNewMsg(ID_Obj,468+$4000,7,''); InsNewMsg(ID_Obj,469+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,468, '',7), M_EZZakrytDvijenieETA,ID_Obj);
              AddDspMenuItem(GetSmsg(1,469, '',7), M_EZOtkrytDvijenieETA,ID_Obj);
            end else
            if bP[29] then
            begin
              InsNewMsg(ID_Obj,469+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,469, '',7), M_EZOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsNewMsg(ID_Obj,468+$4000,7,'');
              AddDspMenuItem(GetSmsg(1,468, '',7), M_EZZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //-------------------------------------------------------- ��� �����������
          if bP[14] <> bP[15] then
          begin
            InsNewMsg(ID_Obj,207+$4000,7,'');  InsNewMsg(ID_Obj,206+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytUvjazki,ID_Obj);
            AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytUvjazki,ID_Obj);
          end else
          begin
            if bP[15] or bP[14] then
            begin //------------------------------------- ������� ������ - ������� �������
              InsNewMsg(ID_Obj,207+$4000,7,''); msg := GetSmsg(1,207, Liter,7);
              DspCom.Com := M_OtkrytUvjazki;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------- ������� ������ - ������� �������
              InsNewMsg(ID_Obj,206+$4000,7,''); msg := GetSmsg(1,206, Liter,7);
              DspCom.Com := M_ZakrytUvjazki;
              DspCom.Obj := ID_Obj;
            end;
          end;
        end;
      end else
      begin //--------------------------------------------------------------------- ������
        if bP[1] then
        begin //------------------------------------------------- ����� ������ �����������
          InsNewMsg(ID_Obj,216+$4000,7,'');  msg := GetSmsg(1,216, Liter,7);
          DspCom.Com := M_OtmZaprosPoezdSoglasiya; DspCom.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- ���� ������ �����������
          InsNewMsg(ID_Obj,215+$4000,7,''); msg := GetSmsg(1,215, Liter,7);
          DspCom.Com := M_ZaprosPoezdSoglasiya; DspCom.Obj := ID_Obj;
        end;
      end;
    end;
    DspMenu.WC := true;
  end;
{$ENDIF}
end;

//========================================================================================
//------------------------------ �������� ���� ��� ���������� �������� "����� �����������"
function NewMenu_SmenaNapravleniya(X,Y : SmallInt;var gotomenu : boolean):boolean;
var
  color : Integer;
begin
  DspMenu.obj := cur_obj;  result := true;
  {$IFNDEF RMDSP}  ID_ViewObj := ID_Obj;  exit; {$ELSE}

  if Spec_Reg(ID_Obj) then exit;

  if WorkMode.MarhOtm then //--------------------------------------------- ������ ��������
  begin //-------- ������� � �������� �������� �� ��, � ���� �������� �� ����� �����������
    if (ObjZv[ID_Obj].ObCI[9] > 0) and  ObjZv[ID_Obj].bP[17] then
    begin  //----------------------------------------------------------- �������� ��������
      DspCom.Com := M_SnatSoglasieSmenyNapr;  DspCom.Obj := ID_Obj;
      color := 4;
      InsNewMsg(ID_Obj,437+$4000,color,'');// ����� �������� ����� ����������� �� ��������
      msg := GetSmsg(1,437, ObjZv[ID_Obj].Liter,color);
      DspMenu.WC := true; gotomenu := true; exit;
    end else  begin WorkMode.MarhOtm := false;  exit; end;
  end;

  if WorkMode.InpOgr then //--------------------------------------------- ���� �����������
  begin
    if ObjZv[ID_Obj].bP[33] then
    begin //-------------------------------------------------------- �������� ������������
      InsNewMsg(ID_Obj,431+$4000,1,'');//------------------------- "�������� ������������"
      WorkMode.InpOgr := false; ShowSmsg(431, LastX, LastY, '');  exit;
    end else
    begin
      //-------------------------------------------- ���� �������� �������� �� �����������
      if ObjZv[ID_Obj].ObCB[8] or ObjZv[ID_Obj].ObCB[9] then
      begin
        //-------------------------------------------------------------- �������� ��������
        if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,''); //----------------------- "������� ������� $?"
          InsNewMsg(ID_Obj,206+$4000,7,''); //----------------------- "������� ������� $?"
          AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytPeregon,ID_Obj);
          AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytPeregon,ID_Obj);
        end else
        if ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytPeregon,ID_Obj);
        end else
        begin
          InsNewMsg(ID_Obj,206+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytPeregon,ID_Obj);
        end;

        //----------------------------------------------- �������� �������� �� �����������
        if ObjZv[ID_Obj].bP[24] <> ObjZv[ID_Obj].bP[27] then
        begin
          InsNewMsg(ID_Obj,458+$4000,7,''); //------ ������� $ ��� �������� �� �����������
          InsNewMsg(ID_Obj,459+$4000,7,''); //------ ������� $ ��� �������� �� �����������
          AddDspMenuItem(GetSmsg(1,458, '',7), M_ABZakrytDvijenieET,ID_Obj);
          AddDspMenuItem(GetSmsg(1,459, '',7), M_ABOtkrytDvijenieET,ID_Obj);
        end else
        if ObjZv[ID_Obj].bP[27] then
        begin
          InsNewMsg(ID_Obj,459+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,459, '',7), M_ABOtkrytDvijenieET,ID_Obj);
        end else
        begin
          InsNewMsg(ID_Obj,458+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,458, '',7), M_ABZakrytDvijenieET,ID_Obj);
        end;

        if ObjZv[ID_Obj].ObCB[8] and ObjZv[ID_Obj].ObCB[9] then // ���� 2 ���� �����������
        begin
          //---------------------------- �������� �������� �� ����������� ����������� ����
          if ObjZv[ID_Obj].bP[25] <> ObjZv[ID_Obj].bP[28] then
          begin
            InsNewMsg(ID_Obj,463+$4000,7,'');
            InsNewMsg(ID_Obj,464+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,463,'',7),M_ABZakrytDvijenieETD,ID_Obj);
            AddDspMenuItem(GetSmsg(1,464,'',7),M_ABOtkrytDvijenieETD,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[28] then
          begin
            InsNewMsg(ID_Obj,464+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,464,'',7),M_ABOtkrytDvijenieETD,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,463+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,463,'',7),M_ABZakrytDvijenieETD,ID_Obj);
          end;

          //---------------------------- �������� �������� �� ����������� ����������� ����
          if ObjZv[ID_Obj].bP[26] <> ObjZv[ID_Obj].bP[29] then
          begin
            InsNewMsg(ID_Obj,468+$4000,7,'');//������� ��� �������� �� �� ����������� ����
            InsNewMsg(ID_Obj,469+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,468,'',7),M_ABZakrytDvijenieETA,ID_Obj);
            AddDspMenuItem(GetSmsg(1,469,'',7),M_ABOtkrytDvijenieETA,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[29] then
          begin
            InsNewMsg(ID_Obj,469+$4000,7,'');//-- ������ ������� ����.����. �� �����. ����
            AddDspMenuItem(GetSmsg(1,469,'',7),M_ABOtkrytDvijenieETA,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,468+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,468,'',7),M_ABZakrytDvijenieETA,ID_Obj);
          end;
        end;
      end else
      begin //------------------------------------------------------------ ��� �����������
        if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,'');  //------------------------ ������� ������� $?
          InsNewMsg(ID_Obj,206+$4000,7,'');  //------------------------ ������� ������� $?
          AddDspMenuItem(GetSmsg(1,207,'',7),M_OtkrytPeregon,ID_Obj);
          AddDspMenuItem(GetSmsg(1,206,'',7),M_ZakrytPeregon,ID_Obj);
        end else
        begin
          if ObjZv[ID_Obj].bP[13] or ObjZv[ID_Obj].bP[12] then
          begin //--------------------------------------- ������� ������ - ������� �������
            InsNewMsg(ID_Obj,207+$4000,7,'');
            msg := GetSmsg(1,207, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_OtkrytPeregon;
            DspCom.Obj := ID_Obj;
          end else
          begin //--------------------------------------- ������� ������ - ������� �������
            InsNewMsg(ID_Obj,206+$4000,7,'');
            msg := GetSmsg(1,206, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_ZakrytPeregon;
            DspCom.Obj := ID_Obj;
          end;
        end;
      end;
    end;
  end else
  begin //-------------------------------------------------------------- ����� �����������
    if ObjZv[ID_Obj].ObCB[3] then //--------------------------- ���� ����������� ���������
    begin
      if ObjZv[ID_Obj].bP[7] and ObjZv[ID_Obj].bP[8] then
      begin //----------------------------------------------- ������ ����������� ���������
        InsNewMsg(ID_Obj,261+$4000,1,'');//�������� ����� ����������� $ ��������� �� �����
        ShowSmsg(261,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end;
      if ObjZv[ID_Obj].ObCB[4] then
      begin //---------------------------------------------------------------------- �����
        if not ObjZv[ID_Obj].bP[7] then
        begin //------------------------------------------ �� ��������� �������� �� ������
          InsNewMsg(ID_Obj,260+$4000,1,'');
          ShowSmsg(260,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end else
      if ObjZv[ID_Obj].ObCB[5] then
      begin //---------------------------------------------------------------- �����������
        if not ObjZv[ID_Obj].bP[8] then
        begin //------------------------------------- �� ��������� �������� �� �����������
          InsNewMsg(ID_Obj,260+$4000,1,''); //-- �������� ����� ����������� $ �� ���������
          ShowSmsg(260,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end;
    end;

    //-------------- ������� � �������� �������� �� ��, ���� �������� �� ����� �����������
    if (ObjZv[ID_Obj].ObCI[9] > 0) and ObjZv[ID_Obj].bP[17] then
    begin //------------------------------------------------------------ �������� ��������
      InsNewMsg(ID_Obj,437+$4000,7,''); //--- ����� �������� ����� ����������� �� ��������
      msg := GetSmsg(1,437, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_SnatSoglasieSmenyNapr;
      DspCom.Obj := ID_Obj;
      DspMenu.WC := true;
      gotomenu := true;
      exit;
    end;

    if not ObjZv[ID_Obj].bP[5] then
    begin //---------------------------------------------------------------- ������� �����
      InsNewMsg(ID_Obj,262+$4000,1,'');
      ShowSmsg(262,LastX,LastY,ObjZv[ID_Obj].Liter);
      msg :=GetSmsg(1,262, ObjZv[ID_Obj].Liter,1);
      exit;
    end;

    if not ObjZv[ID_Obj].bP[6] then
    begin //----------------------------------------- ��������� �������� (����� ����-����)
      InsNewMsg(ID_Obj,130+$4000,1,'');
      ShowSmsg(130,LastX,LastY,ObjZv[ID_Obj].Liter);
      msg := GetSmsg(1, 130, ObjZv[ID_Obj].Liter,1);
      exit;
    end;

    if ObjZv[ID_Obj].bP[4] then//-------------------------- "������� ����� �� �����������"
    begin
      if ObjZv[ID_Obj].ObCI[9] > 0 then //-------------- ������� � �������� �������� �� ��
      begin
        if ObjZv[ID_Obj].bP[10] then //------------------ ���� ������ �� ����� �����������
        begin
          if ObjZv[ID_Obj].bP[15] then //------------------ ��������� �������� �����������
          begin
            InsNewMsg(ID_Obj,436+$4000,1,'');//--- ���������� �����.����.������ �� �������
            ShowSmsg(436,LastX,LastY,ObjZv[ID_Obj].Liter);
            exit;
          end;
          DspCom.Com := M_DatSoglasieSmenyNapr;  DspCom.Obj := ID_Obj;
          color := 7;
          InsNewMsg(ID_Obj,205+$4000,color,''); //-- ������ �������� �� ����� �����������?
          msg := GetSmsg(1,205, ObjZv[ID_Obj].Liter,color);
          DspMenu.WC := true;  gotomenu := true;
          exit;
        end else //-------------------------------------  ��� ������� �� ����� �����������
        begin
          InsNewMsg(ID_Obj,266+$4000,1,''); msg := GetSmsg(1,266, ObjZv[ID_Obj].Liter,1);
          ShowSmsg(266,LastX,LastY,ObjZv[ID_Obj].Liter);
        end;
        exit;
      end else //-------------------------- ������� ��� ������� �������� ����� �����������
      begin
        InsNewMsg(ID_Obj,265+$4000,1,''); msg := GetSmsg(1,265, ObjZv[ID_Obj].Liter,1);
        ShowSmsg(265,LastX,LastY,ObjZv[ID_Obj].Liter);
      end;
      exit;
    end else
    begin //---------------------------------------------------- "������� ����� �� ������"
      InsNewMsg(ID_Obj,204+$4000,7,''); msg := GetSmsg(1,204, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_SmenaNapravleniya;
      DspCom.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------ ����������� ��������� ����� �����������
function NewMenu_KSN(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;  result := true;

{$IFNDEF RMDSP} ID_ViewObj := ID_Obj; exit; {$ELSE}

  if not WorkMode.OtvKom then
  begin //--------------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands;
    ShowSmsg(276,LastX,LastY,'');
    SimpleBeep;
    msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    exit;
  end else
  if ActivenVSP(ID_Obj) then exit;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;  
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- ������ -
    if ObjZv[ID_Obj].bP[1] then
    begin //-------------------------------------------------------- ��������� �������� ��
      InsNewMsg(ID_Obj,406+$4000,7,'');
      msg := GetSmsg(1,406, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_OtklKSN;
      DspCom.Obj := ID_Obj;
    end else
    begin
      InsNewMsg(ID_Obj,260+$4000,1,'');
      ShowSmsg(260,LastX,LastY,''); exit;
    end;
    DspCom.Active := true;
    WorkMode.MarhOtm := false;
    DspMenu.WC := true;
  end else
  begin
    if ObjZv[ID_Obj].bP[1] then
    begin //-------------------------------------------------------- ��������� �������� ��
      InsNewMsg(ID_Obj,406+$4000,7,'');
      msg := GetSmsg(1,406, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_OtklKSN;
      DspCom.Obj := ID_Obj;
    end else
    begin //------------------------------------------------------- ���������� �������� ��
      InsNewMsg(ID_Obj,407+$4000,7,'');
      msg := GetSmsg(1,407, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_VklKSN;
      DspCom.Obj := ID_Obj;
    end;
    DspCom.Active := true;
    WorkMode.MarhOtm := false;
    DspMenu.WC := true;
  end;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------------------------- ������ � ���
function NewMenu_PAB(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- ������ -
    WorkMode.MarhOtm := false;
    if ObjZv[ID_Obj].bP[4] then
    begin //--------------------------------------------------- ����� �������� �����������
      InsNewMsg(ID_Obj,279+$4000,7,'');
      msg := GetSmsg(1,279, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_OtmenaSoglasieOtpravl;
      DspCom.Obj := ID_Obj;
    end
    else exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZv[ID_Obj].ObCB[8] or
      ObjZv[ID_Obj].ObCB[9] then //----------- ���� �������� �������� �� �����������
      begin //---------------------------------------------------------- �������� ��������
        if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,'');
          InsNewMsg(ID_Obj,206+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytPeregonPAB,ID_Obj);
          AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytPeregonPAB,ID_Obj);
        end else
        if ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytPeregonPAB,ID_Obj);
        end else
        begin
          InsNewMsg(ID_Obj,206+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytPeregonPAB,ID_Obj);
        end;
        //----------------------------------------------- �������� �������� �� �����������
        if ObjZv[ID_Obj].bP[24] <> ObjZv[ID_Obj].bP[27] then
        begin
          InsNewMsg(ID_Obj,458+$4000,7,'');
          InsNewMsg(ID_Obj,459+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,458, '',7), M_RPBZakrytDvijenieET,ID_Obj);
          AddDspMenuItem(GetSmsg(1,459, '',7), M_RPBOtkrytDvijenieET,ID_Obj);
        end else
        if ObjZv[ID_Obj].bP[27] then
        begin
          InsNewMsg(ID_Obj,459+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,459, '',7), M_RPBOtkrytDvijenieET,ID_Obj);
        end else
        begin
          InsNewMsg(ID_Obj,458+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,458, '',7), M_RPBZakrytDvijenieET,ID_Obj);
        end;
        if ObjZv[ID_Obj].ObCB[8] and
        ObjZv[ID_Obj].ObCB[9] then //----------------------- ���� 2 ���� �����������
        begin  //----------------------- �������� �������� �� ����������� ����������� ����
          if ObjZv[ID_Obj].bP[25] <> ObjZv[ID_Obj].bP[28] then
          begin
            InsNewMsg(ID_Obj,463+$4000,7,'');
            InsNewMsg(ID_Obj,464+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,463, '',7), M_RPBZakrytDvijenieETD,ID_Obj);
            AddDspMenuItem(GetSmsg(1,464, '',7), M_RPBOtkrytDvijenieETD,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[28] then
          begin
            InsNewMsg(ID_Obj,464+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,464, '',7), M_RPBOtkrytDvijenieETD,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,463+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,463, '',7), M_RPBZakrytDvijenieETD,ID_Obj);
          end;
          //---------------------------- �������� �������� �� ����������� ����������� ����
          if ObjZv[ID_Obj].bP[26] <> ObjZv[ID_Obj].bP[29] then
          begin
            InsNewMsg(ID_Obj,468+$4000,7,'');
            InsNewMsg(ID_Obj,469+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,468, '',7), M_RPBZakrytDvijenieETA,ID_Obj);
            AddDspMenuItem(GetSmsg(1,469, '',7), M_RPBOtkrytDvijenieETA,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[29] then
          begin
            InsNewMsg(ID_Obj,469+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,469, '',7), M_RPBOtkrytDvijenieETA,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,468+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,468, '',7), M_RPBZakrytDvijenieETA,ID_Obj);
          end;
        end;
      end else
      begin //------------------------------------------------------------ ��� �����������
        if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,'');
          InsNewMsg(ID_Obj,206+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytPeregonPAB,ID_Obj);
          AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytPeregonPAB,ID_Obj);
        end else
        begin
          if ObjZv[ID_Obj].bP[13] or ObjZv[ID_Obj].bP[12] then
          begin //--------------------------------------- ������� ������ - ������� �������
            InsNewMsg(ID_Obj,207+$4000,7,'');
            msg := GetSmsg(1,207, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_OtkrytPeregonPAB;
            DspCom.Obj := ID_Obj;
          end else
          begin //--------------------------------------- ������� ������ - ������� �������
            InsNewMsg(ID_Obj,206+$4000,7,'');
            msg := GetSmsg(1,206, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_ZakrytPeregonPAB;
            DspCom.Obj := ID_Obj;
          end;
        end;
      end;
    end else
    begin //
      if WorkMode.OtvKom then
      begin //------------------------------------------------------------------- ����� ��
        if not ObjZv[ID_Obj].bP[1] then
        begin //-------------------------------------------------- ������� ����� �� ������
          if ObjZv[ID_Obj].bP[3] then
          begin //------------------------------------------ ������ �������������� �������
            InsNewMsg(ID_Obj,281+$4000,7,'');
            msg := GetSmsg(1,281, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_IskPribytieIspolnit;
            DspCom.Obj := ID_Obj;
          end else
          begin //----------------------------------------- ������ ��������������� �������
            InsNewMsg(ID_Obj,280+$4000,7,'');
            msg := GetSmsg(1,280, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_IskPribytiePredv;
            DspCom.Obj := ID_Obj;
          end;
        end else
        begin //----------------------------------------- �� ��������� ������ ���.��������
          InsNewMsg(ID_Obj,298+$4000,7,'');
          ShowSmsg(298,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end else
      if not ObjZv[ID_Obj].bP[1] then
      begin //---------------------------------------------------- ������� ����� �� ������
        if ObjZv[ID_Obj].bP[2] then
        begin //--------------------------------- �������� �������� ������ - ���� ��������
          InsNewMsg(ID_Obj,282+$4000,7,'');
          msg := GetSmsg(1,282, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_VydatPribytiePoezda;
          DspCom.Obj := ID_Obj;
        end else
        begin
          InsNewMsg(ID_Obj,318+$4000,1,'');
          ShowSmsg(318,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end else
      if not ObjZv[ID_Obj].bP[5] then
      begin //----------------------------------------------- ������� ����� �� �����������
        InsNewMsg(ID_Obj,299+$4000,7,'');
        ShowSmsg(299,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if ObjZv[ID_Obj].bP[6] then
      begin //---------------------------------------------- �������� �������� �����������
        InsNewMsg(ID_Obj,326+$4000,7,'');
        ShowSmsg(326,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if not ObjZv[ID_Obj].bP[7] then
      begin //------------------------------------------------------- �������� �� ��������
        InsNewMsg(ID_Obj,130+$4000,1,'');
        ShowSmsg(130,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      begin //----------------------------------- ������� �������� - ������/����� ��������
        if ObjZv[ID_Obj].bP[4] then
        begin //----------------------------------------------- ����� �������� �����������
          InsNewMsg(ID_Obj,279+$4000,7,'');
          msg := GetSmsg(1,279, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_OtmenaSoglasieOtpravl;
          DspCom.Obj := ID_Obj;
        end else
        begin //------------------------------------------------ ���� �������� �����������
          InsNewMsg(ID_Obj,278+$4000,7,'');
          msg := GetSmsg(1,278, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_VydatSoglasieOtpravl;
          DspCom.Obj := ID_Obj;
        end;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------- �������� ���� ��� ���������� ��������
function NewMenu_Strelka(X, Y : SmallInt) : Boolean;
var
  ogr : boolean;
	hvost,SP_str,AvPer : SmallInt;
begin
  DspMenu.obj := cur_obj;
  result := true;
  {$IFNDEF RMDSP}  ID_ViewObj := ID_Obj; exit; {$ELSE}
  with ObjZv[ID_Obj] do
  begin
	  hvost := BasOb; SP_str := UpdOb; AvPer := ObjZv[hvost].ObCI[13];//�����, �� � ����.���
    //----- ��� ����������� ������ ��������� �� �������� ��������� �������������� ��������
    with ObjZv[hvost] do
    begin //---------------------- ������� �� � (���������� �� �� ��� ������� �������� ��)
      if ObCB[2] and (bP[3] or bP[12]) then
      begin //---------- ����� ��������� ���������� �� � ����������� �������� ������������
        bP[3] := false; bP[12] := false;
        InsNewMsg(hvost,424+$4000,7,'');//------------------ "������� ����������� � ��������"
        AddFixMes(GetSmsg(1,424,Liter,7),4,1);
      end;
    end;
    //------------ ������� ������ � �������������� ���������, ��� ������� ��� ������������
    if WorkMode.OtvKom then //--------------------------------------------- ���� ������ ��
    begin //------------------- ������ �� - ������������� �������� ����������� ��� �������
      InsNewMsg(ID_Obj,311+$4000,7,''); //------------------------------- "�������������?"
      msg := GetSmsg(1,311, '������� '+Liter,7);
      DspCom.Com := CmdMarsh_ResetTraceParams; //-----
      DspCom.Obj := ID_Obj;
    end else
	  //---------------------------------------------------- ����� ������ � ������� ��������
    //----------- ���� ����� ������� ������ ��������, �������� ������ �������� � �����
    if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
    if ActivenVSP(ID_Obj) then exit;
	  //--------------------------------------------------------- ����� ������ � �����������
    if WorkMode.GoTracert then //------------------------- ���� ���� ����� ������ ��������
    begin
      ResetTrace; //-------------- �������� ��������� ������ �������� � ��������� ��������
      exit; //-------------------------------------------------------------------- � �����
    end else

	  //--------------------------------------------- ��������� ������ � ���������� �� �����
    if WorkMode.GoMaketSt then //--------------------- ���� ���� ������ ��������� �� �����
    begin
      if not ObjZv[SP_str].bP[5] or //----------------------------------- ���� � �� �� ���
      ObjZv[SP_str].bP[9] then      //-------------------------------------------- � �� ��
      begin //- ��������:"������� �� ������� ����������" �������� ������ � ������� � �����
        InsNewMsg(hvost,91+$4000,1,'');
        WorkMode.GoMaketSt := false;
        ShowSmsg(91,LastX,LastY,ObjZv[hvost].Liter);//-- "������� $ �� ������� ����������"
        WorkMode.GoMaketSt := false; //--------- ����� �������� ������ �� ��������� ������
        exit;
      end else
      if ObjZv[hvost].bP[14] or//-------------------------- ������� �������� ��������� ���
      bP[10] or //-------------------------------- ������� ������� ������� ����������� ���
      bP[11] or//--------------------------------- ������� ������� ������� ����������� ���
      bP[12] or //------------------------ ������� ���������� � ����� ���
      bP[13] or //----------------------- ������� ���������� � ������ ���
      bP[6] or //------------------------------------ ���� ������� �� ���
      bP[7] then //-------------------------------------- ���� ������� ��
      begin //------------- ��������: "������� � ��������" �������� ������ � ������� � �����
        InsNewMsg(hvost,511+$4000,1,'');
        WorkMode.GoMaketSt := false;
        ShowSmsg(511,LastX,LastY,ObjZv[hvost].Liter);//--------- "������� $ � ��������"
        WorkMode.GoMaketSt := false; //----------- ����� �������� ������ �� ��������� ������
        exit;
      end else
      if bP[1] or bP[2] then //--- ���� ���� �� ��� ��
      begin //------------------------ ���� �������� ��������� - ����� �� ��������� �� �����
      //--- "��� ��������� � ������ �������� ��������� ������� $! ������ ��������� ������"
        InsNewMsg(hvost,92,1,'');
        RSTMsg;
        AddFixMes(GetSmsg(1,92,ObjZv[hvost].Liter,1),4,1);
        ShowSmsg(92, LastX, LastY, ObjZv[hvost].Liter);
        WorkMode.GoMaketSt := false;
        exit;
      end else
      if ObjZv[hvost].bP[26] and //-------------- ���� ���� ��������� � ������ ��������
      not(ObjZv[hvost].bP[32] or bP[32])then //----- � ��� ���������
      begin //----------------------------------- ��������� ������������� ��������� �� �����
        InsNewMsg(hvost,138+$4000,7,''); //------------------ ���������� ������� $ �� �����?
        msg := GetSmsg(1,138,ObjZv[hvost].Liter,7);
        DspCom.Com := M_UstMaketStrelki;
        DspCom.Obj := ID_Obj;
      end else
      begin
        //--- "��� ��������� � ������ �������� ��������� ������� $! ������ ��������� ������"
        InsNewMsg(hvost,92,1,'');
        AddFixMes(GetSmsg(1,92,ObjZv[hvost].Liter,1),4,1);
        ShowSmsg(92, LastX, LastY, ObjZv[hvost].Liter);
        WorkMode.GoMaketSt := false;
        exit;
      end;
    end else
    //--------------------------------------------- �������� ������ � ���������� �����������
    begin //---------------------------------------------------- ���� ��� ��������� �� �����
      if WorkMode.InpOgr then //------------------------------------------- ���� �����������
      begin
        if bP[33] or bP[25 ] then // ���� ������������
        begin //------------------------------------------------------ �������� ������������
          InsNewMsg(BasOb,431+$4000,1,''); //--- "�������� ������������"
          WorkMode.InpOgr := false;
          ShowSmsg(431, LastX, LastY, '');
          exit;
        end else
        if bP[5] or //-------- ���� ���� ���������� �������� �������� ���
        bP[6] or //------------------------------------------ ���� �� ���
        bP[7] or //------------------------------------------ ���� �� ���
        bP[8] or //---------------- ���� �������� �������� � �������� ���
        bP[14] then //---------- ���� ������� ������������ ��������� ����
        begin //------------ ������� � ����������� �������� ����������� ������������� ������
          InsNewMsg(BasOb,511+$4000,1,'');//------- "������� � ��������"
          WorkMode.InpOgr := false;
          ShowSmsg(511, LastX, LastY, ObjZv[BasOb].Liter);
          exit;
        end else
        if not ObjZv[SP_str].bP[5] or//------------------------------------ ���� �� ���
        ObjZv[SP_str].bP[9] then //------------------------------------ ���� ������� ��
        begin //-------------------------------------- ������� ������� �� ������� ����������
          InsNewMsg(hvost,91+$4000,1,''); //---------------------- "������� �� ������� ���."
          WorkMode.InpOgr := false;
          ShowSmsg(91, LastX, LastY, ObjZv[hvost].Liter);
          exit;
        end else
        begin //---------- ���� ��� ������������ �� ���������� ������� � �������� � � ������
          if bP[18] <> ObjZv[hvost].bP[18] then //
          begin
            InsNewMsg(hvost,169+$4000,7,''); //--------------------- "�������� ���������� ?"
            InsNewMsg(hvost,168+$4000,7,''); //-------------------- "��������� ���������� ?"
            AddDspMenuItem(GetSmsg(1,169, '',7), M_StrVklUpravlenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,168, '',7), M_StrOtklUpravlenie,ID_Obj);
          end else //------------------------------------ ���� �� ���������� ���� ����������
          begin
            if bP[18] then //------- ���� ������� ��������� �� ����������
            begin
              InsNewMsg(hvost,169+$4000,7,''); //--------------------- �������� ���������� $
              AddDspMenuItem(GetSmsg(1,169, '',7), M_StrVklUpravlenie,ID_Obj);
            end else
            begin
              InsNewMsg(hvost,168+$4000,7,''); //----------------- ��������� �� ���������� $
              AddDspMenuItem(GetSmsg(1,168, '',7),M_StrOtklUpravlenie,ID_Obj);
            end;
          end;

          //------------------------------------------- ������� ��� �������� ������� (��� 2)
          if ObCB[6] then //--------------------- ���� "�������" �������
          ogr := ObjZv[hvost].bP[17]//--------- �������� �������� �� ������ ��� �������
          else ogr :=ObjZv[hvost].bP[16];//------- ����� �������� �� ������ ��� �������

          if bP[16] <> ogr then //---- ���� ����.������� �� �����. ������
          begin
            InsNewMsg(ID_Obj,171+$4000,7,''); //--------------------- "������� ��� ��������"
            InsNewMsg(ID_Obj,170+$4000,7,''); //--------------------- "������� ��� ��������"
            AddDspMenuItem(GetSmsg(1,171, '',7), M_StrOtkrytDvizenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,170, '',7), M_StrZakrytDvizenie,ID_Obj);
          end else //----------------------- ���� ������������� ����������� ������� � ������
          begin
            if bP[16] then //------------------ ���� ������� ��� ��������
            begin
              InsNewMsg(ID_Obj,171+$4000,7,''); //------------------- "������� ��� ��������"
              AddDspMenuItem(GetSmsg(1,171, '',7), M_StrOtkrytDvizenie,ID_Obj);
            end else //---------------------------------------- ���� �� ������� ��� ��������
            begin
              InsNewMsg(ID_Obj,170+$4000,7,''); //--------------------"������� ��� ��������"
              AddDspMenuItem(GetSmsg(1,170, '',7), M_StrZakrytDvizenie,ID_Obj);
            end;
          end;

          if not ObCB[10] then // ���� �������, � �� ������������ ������
          begin //--- ������� ��� �������� ���������������, ���� �� �������� �����. ��������
            if ObCB[6] //----------------------- ���� ��� ������ �������
            then ogr:= ObjZv[hvost].bP[34]//--------------- ����� �� ������ ��� �������
            else ogr:=ObjZv[hvost].bP[33];//--------- ����� ����� �� ������ ��� �������

            if bP[17] <> ogr then //------- �������� �� ������� � �������
            begin
              InsNewMsg(ID_Obj,450+$4000,7,''); //-- "������� ��� ���������������� ��������"
              InsNewMsg(ID_Obj,449+$4000,7,''); //-- "������� ��� ���������������� ��������"
              AddDspMenuItem(GetSmsg(1,450, '',7),M_StrOtkrytProtDvizenie,ID_Obj);
              AddDspMenuItem(GetSmsg(1,449, '',7),M_StrZakrytProtDvizenie,ID_Obj);
            end else //------------------------------------------ ���� �������� ��� � ������
            begin
              if bP[17] then //-------- ���� ������� ��� ����������������
              begin
                InsNewMsg(ID_Obj,450+$4000,7,'');//- "������� ��� ���������������� ��������"
                AddDspMenuItem(GetSmsg(1,450,'',7),M_StrOtkrytProtDvizenie,ID_Obj);
              end else
              begin
                InsNewMsg(ID_Obj,449+$4000,7,'');//- "������� ��� ���������������� ��������"
                AddDspMenuItem(GetSmsg(1,449,'',7),M_StrZakrytProtDvizenie,ID_Obj);
              end;
            end;
          end;

          //--------------------------------- �������� ����� ������� � ������ ������� ������
          if ObjZv[hvost].bP[15] and //------------------------- ���� ����� �� ������ �
          (maket_strelki_index <> hvost) then //--------------------- � ������ �� �� �������
          begin
            InsNewMsg(BasOb,172+$4000,7,'');//- "����� � ������ �������"
            AddDspMenuItem(GetSmsg(1,172, '',7),CmdStr_ResetMaket,ID_Obj);
          end;
        end;
      end else
      //------------------------------------------------------ ���� �� ��������� �����������
      if not ObjZv[hvost].bP[31] then //----------------- ���� ��� ���������� �� ������
      begin //---------------------------------------------------------- ��� ������ � ������
        InsNewMsg(ID_Obj,255+$4000,7,''); //--- "����������� ���������� � ��������� �������"
        VspPerevod.Active := false; //----------- ����� ���������� ���������������� ��������
        WorkMode.VspStr := false;  //----- ��������� ����� ���������������� �������� �������
        ShowSmsg(255, LastX, LastY, ObjZv[BasOb].Liter);
        exit;
      end else
      //---------------------------------------------- �����, ���� ���� ���������� �� ������
      if ObjZv[hvost].bP[4] or // ���� ���� �������������� ��������� ������ ������� ���
      bP[4] or //------------ ���� �������������� ��������� � ������� ���
      not ObjZv[hvost].bP[21] then //-------------------- ���� ��������� � ������ �� ��
      begin //------------------------------------------ "������� ��������,������� ��������"
        ShowWarning := true;
        msg := GetSmsg(1,147,ObjZv[hvost].Liter,1);
        InsNewMsg(hvost,147+$4000,1,'');
        exit;
      end else //-------------------------------------------------- �����,���� ��� ���������
      if bP[18] or //------------------------- ���� ��������� ������� ���
      ObjZv[hvost].bP[18] then //--------------------------------------- �������� �����
      begin //-------------------------- "������� ��������� �� ����������, ������� ��������"
        InsNewMsg(hvost,151+$4000,7,'');
        ShowSmsg(151,LastX,LastY,ObjZv[hvost].Liter);
        msg := GetSmsg(1,151,ObjZv[hvost].Liter,7);
        exit;
      end else //-------------------------------------------------- �����, ���� �� ���������
      if ObjZv[AvPer].bP[1] then // ���� � ������� ���������� �������� ���� ������� ���
      begin
        if WorkMode.VspStr then //-------------- ���� ���� ������� ���������������� ��������
        begin
          InsNewMsg(hvost,411+$4000,7,'');//---- "������� ������� �������. �������� �������"
          ShowSmsg(411,LastX,LastY,ObjZv[hvost].Liter);
          msg := GetSmsg(1,411,ObjZv[hvost].Liter,7);
          exit;
        end else //----------------------------- ���� ��� �������� ���������������� ��������
        begin
          //--------- "������ ������ ���������������� ��������. ������� ������� $ ��������!"
				  InsNewMsg(hvost,139+$4000,1,'');
          ShowSmsg(139,LastX,LastY,ObjZv[hvost].Liter);
          exit;
        end;
      end else //---------------------------------------------- �����, ���� ��� �������� ���
      if ObjZv[hvost].bP[14] or//----------------------- ���� ����������� ��������� ���
      ObjZv[hvost].bP[23] then //----------------------------- ����������� ��� ��������
      begin //----- ������� ������������ � ��������  - ������������, ����� ��������� �������
        InsNewMsg(hvost,240+$4000,7,''); //---------------- "������� � ��������,����������?"
        msg := GetSmsg(1,240,ObjZv[hvost].Liter,7);
        ShowWarning := true;
        DspCom.Com := CmdStr_AskPerevod;
        DspCom.Obj := ID_Obj;
      end else //------------------------ ���� ��� ������������ ��������� ������� � ��������
      begin //---------------------------------------------------- ������ �� ������� �������
        DspCom.Com := CmdStr_AskPerevod;
        DspCom.Obj := ID_Obj;
        DspCom.Active := true;
        exit;
      end;
    end;
    DspMenu.WC := true;
   end;
{$ENDIF}
end;

//========================================================================================
//----------------------------- �������� ���� ��� ���������� �������� "���������� �������"
function NewMenu_ManKol(X,Y : SmallInt): boolean;
var
  MessCount,MessObj,WarObj : Integer;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if WorkMode.InpOgr then WorkMode.InpOgr := false;//----------- �������� ���� �����������
  if Trassir then exit;
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- ������ -
    WorkMode.MarhOtm := false;
    if ObjZv[ID_Obj].bP[8] then
    begin //---------------------------------- ������ �� - �������� ��� ���������� �������
      if ObjZv[ID_Obj].bP[3] then
      begin //---------------------------------------------------- ������� ��� �� ��������
        InsNewMsg(ID_Obj,218+$4000,7,'');
        msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- ������� ��������
        if ObjZv[ID_Obj].bP[5] then //---------------------- ���� ���������� ��������
        begin //------------------------------------------------------- ���������� �������
          InsNewMsg(ID_Obj,446+$4000,7,'');
          msg := GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
        end else
        begin
          InsNewMsg(ID_Obj,218+$4000,7,'');
          msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
        end;
      end;
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    if ObjZv[ID_Obj].bP[1] or ObjZv[ID_Obj].bP[9] then
    begin //------------------------------------------- ���� �� ��� ��� - �������� �������
      if ObjZv[ID_Obj].bP[5] and
      not ObjZv[ID_Obj].bP[3] then //------------------ ���� ���������� �������� � ��
      begin //--------------------------------------------------------- ���������� �������
        InsNewMsg(ID_Obj,446+$4000,7,'');
        msg := GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ ��������� ������� ������ ��������
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ ��� ������� ��� ������ - ���������� �������
          InsNewMsg(ID_Obj,446+$4000,7,'');
          msg := msg + '! ' + GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
        end else
        begin //--------------------------------------------------------- �������� �������
          InsNewMsg(ID_Obj,218+$4000,7,'');
          msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
        end;
      end;
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    if not ObjZv[ID_Obj].bP[3] and not ObjZv[ID_Obj].bP[5] then
    begin //-------------- ���� �� � ����� ���������� �������� - ��������� ������ ��������
      InsNewMsg(ID_Obj,218+$4000,7,'');
      msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    if ObjZv[ID_Obj].bP[5] then //---------------------- �� ����� ���������� ��������
    begin //--------------------------------------------------------------------- ��������
      InsNewMsg(ID_Obj,269+$4000,7,'');
      ShowSmsg(269,LastX,LastY, ObjZv[ID_Obj].Liter); exit;
    end;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsNewMsg(ID_Obj,220+$4000,7,'');
        msg := GetSmsg(1,220, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_IspolIRManevrov;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsNewMsg(ID_Obj,219+$4000,7,'');
        msg := GetSmsg(1,219, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvIRManevrov;
        DspCom.Obj := ID_Obj;
      end;
    end else
    if ObjZv[ID_Obj].bP[8] then
    begin //------------------------------------------------- ������ �� - �������� �������
      if ObjZv[ID_Obj].bP[3] then
      begin //---------------------------------------------------- ������� ��� �� ��������
        InsNewMsg(ID_Obj,218+$4000,7,'');
        msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- ������� ��������
        if ObjZv[ID_Obj].bP[5] then //---------------------- ���� ���������� ��������
        begin //------------------------------------------------------- ���������� �������
          InsNewMsg(ID_Obj,446+$4000,7,'');
          msg := GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
        end else
        begin
          InsNewMsg(ID_Obj,218+$4000,7,'');
          msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
        end;
      end;
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    if ObjZv[ID_Obj].bP[1] or ObjZv[ID_Obj].bP[9] then
    begin //------------------------------------------- ���� �� ��� ��� - �������� �������
      if ObjZv[ID_Obj].bP[5] and
      not ObjZv[ID_Obj].bP[3] then //------------------ ���� ���������� �������� � ��
      begin //--------------------------------------------------------- ���������� �������
        InsNewMsg(ID_Obj,446+$4000,7,'');
        msg := GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ ��������� ������� ������ ��������
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ ��� ������� ��� ������ - ���������� �������
          InsNewMsg(ID_Obj,446+$4000,1,'');
          msg := msg + '! ' + GetSmsg(1,446, ObjZv[ID_Obj].Liter,1);
        end else
        begin //--------------------------------------------------------- �������� �������
          InsNewMsg(ID_Obj,218+$4000,7,'');
          msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
        end;
      end;
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    begin //------------------------------- ��� �� - ��������� ������� �������� �� �������
      if ObjZv[ID_Obj].bP[3] then
      begin //--------------------------------------------------------------------- ��� ��
        if VytajkaRM(ID_Obj) then
        begin
          if MarhTrac.WarN > 0 then
          begin
            MessCount :=MarhTrac.WarN;//����� ����������. ��� ��������� ��������
            MessObj :=  MarhTrac.WarObj[MessCount];//������ �����. ��������������
            WarObj := MarhTrac.WarInd[MessCount];//������ ��������� ��������������
            InsNewMsg(MessObj,WarObj + $5000,1,'');
            msg := MarhTrac.War[MessCount];
            dec (MarhTrac.WarN);
            DspCom.Com := CmdManevry_ReadyWar;
            DspCom.Obj := ID_Obj;
          end else
          begin
            InsNewMsg(ID_Obj,217+$4000,7,'');
            msg := GetSmsg(1,217, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_DatRazreshenieManevrov;
            DspCom.Obj := ID_Obj;
          end;
        end else
        begin //-------------------------- ������� ��������� �� ������ �������� �� �������
          InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1]+$4000,7,'');
          PutSmsg(1,LastX,LastY,MarhTrac.Msg[1]);
          exit;
        end;
      end else
      begin //-------------------------------------------------------------------- ���� ��
        InsNewMsg(ID_Obj,448+$4000,7,'');
        msg := GetSmsg(1,448, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_DatRazreshenieManevrov;
        DspCom.Obj := ID_Obj;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ �������� ���� ��� ������� "��������� �������"
function NewMenu_ZamykStr(X,Y : SmallInt): boolean;
begin //---------------------------------------------------------------- ��������� �������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin  WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- ���������� �����
  InsNewMsg(ID_Obj,189+$4000,1,'');
  msg := GetSmsg(1,189, ObjZv[ID_Obj].Liter,1);
  DspCom.Com := M_ZamykanieStrelok;
  DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------- �������� ���� ��� ������� "���������� �������"
function NewMenu_RazmykanieStrelok(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false;  exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //----------------------------------------------------- �������������� �������
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,191+$4000,7,'');
      msg := GetSmsg(1,191, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolRazmykanStrelok;
      DspCom.Obj := ID_Obj;
    end else
    begin //---------------------------------------------------- ��������������� �������
      InsNewMsg(ID_Obj,190+$4000,7,'');
      msg := GetSmsg(1,190, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvRazmykanStrelok;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //------------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands; ShowSmsg(276,LastX,LastY,'');
    ShowSmsg(276,LastX,LastY,'');
    SimpleBeep;
    msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------------------------------ ������� �������
function NewMenu_ZakrytPereezd(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- ���������� �����
  InsNewMsg(ID_Obj,192+$4000,7,'');
  msg := GetSmsg(1,192, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_ZakrytPereezd;
  DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ �������� ���� ��� ������� "�������� ��������"
function NewMenu_OtkrytPereezd(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //----------------------------------------------------- �������������� �������
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,194+$4000,7,'');
      msg := GetSmsg(1,194, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtkrytPereezd;
      DspCom.Obj := ID_Obj;
    end else
    begin //---------------------------------------------------- ��������������� �������
      InsNewMsg(ID_Obj,193+$4000,7,'');
      msg := GetSmsg(1,193, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvOtkrytPereezd;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //------------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands;
    ShowSmsg(276,LastX,LastY,'');
    SimpleBeep;
    msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------------- �������� ���� ��� "��������� �� �������"
function NewMenu_IzvPereezd(X,Y : SmallInt): boolean;
var
  color : Integer;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------------- ���������� �����
  if ObjZv[ID_Obj].bP[11] then
  begin //-------------------------------------------------------------- ����� ���������
    DspCom.Com := M_SnatIzvecheniePereezd;
    DspCom.Obj := ID_Obj;
    color := 7;
    InsNewMsg(ID_Obj,196+$4000,color,'');
    msg := GetSmsg(1,196, ObjZv[ID_Obj].Liter,color);
  end else
  begin //--------------------------------------------------------------- ���� ���������
    InsNewMsg(ID_Obj,195+$4000,7,'');
    msg := GetSmsg(1,195, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_DatIzvecheniePereezd;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------- �������� ���� ��� ���������� �������� "�������� ����������"
function NewMenu_PoezdOpov(X,Y : SmallInt): boolean;
begin //-------------------------------------------------------------- �������� ����������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ObjZv[ID_Obj].TypeObj = 36 then bit_for_kom := 1  else bit_for_kom := 2;

  if Spec_Reg(ID_Obj) then exit;

  if WorkMode.MarhOtm then
  begin //----------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    if ObjZv[ID_Obj].bP[bit_for_kom] then
    begin //------------------------------------------------------- ��������� ����������
      InsNewMsg(ID_Obj,198+$4000,7,'');
      msg := '';
      if ObjZv[ID_Obj].bP[bit_for_kom+1] or ObjZv[ID_Obj].bP[bit_for_kom+2] then
      msg := GetSmsg(1,309,'',7);
      msg := msg + GetSmsg(1,198, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_SnatOpovechenie;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin
    if ObjZv[ID_Obj].bP[bit_for_kom] then
    begin //------------------------------------------------------- ��������� ����������
      InsNewMsg(ID_Obj,198+$4000,7,'');
      msg := '';
      if ObjZv[ID_Obj].bP[3] or ObjZv[ID_Obj].bP[4] then  msg := GetSmsg(1,309,'',7);
      msg := msg + GetSmsg(1,198, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_SnatOpovechenie;
      DspCom.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------- �������� ����������
      InsNewMsg(ID_Obj,197+$4000,7,'');  //----------------------- �������� ���������� ?
      msg := GetSmsg(1,197, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_DatOpovechenie;
      DspCom.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------- �������� ���� ��� ���������� �������� "������ ��������"
function NewMenu_ZapretMont(X,Y : SmallInt): boolean;
begin// ������ ��������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom or (not ObjZv[ID_Obj].bP[1]) then
  begin
    if ObjZv[ID_Obj].ObCB[1] then
    begin
      if ObjZv[ID_Obj].bP[2] then
      begin
        if not ObjZv[ID_Obj].bP[1] then
        begin //---------------------------------------------- ��������� ������ ��������
          InsNewMsg(ID_Obj,200+$4000,7,'');
          msg := GetSmsg(1,200, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_SnatZapretMonteram;
          DspCom.Obj := ID_Obj;
        end else
        begin //----------------------------------------------- �������� ������ ��������
          InsNewMsg(ID_Obj,199+$4000,7,'');
          msg := GetSmsg(1,199, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_DatZapretMonteram;
          DspCom.Obj := ID_Obj;
        end;
      end else
      begin //------------------------- ���������� ��������� - ������ ��������� ��������
        InsNewMsg(ID_Obj,483+$4000,1,'');
        ShowSmsg(483,LastX,LastY,'');
        exit;
      end;
    end else
    begin
      if ObjZv[ID_Obj].bP[1] then
      begin //------------------------------------------------ ��������� ������ ��������
        InsNewMsg(ID_Obj,200+$4000,7,'');
        msg := GetSmsg(1,200, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_SnatZapretMonteram;
        DspCom.Obj := ID_Obj;
      end else
      begin //------------------------------------------------- �������� ������ ��������
        InsNewMsg(ID_Obj,199+$4000,7,'');
        msg := GetSmsg(1,199, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_DatZapretMonteram;
        DspCom.Obj := ID_Obj;
      end;
    end;
  end else
  begin //------------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands; ShowSmsg(276,LastX,LastY,'');
    SimpleBeep;
    msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------ �������� ���� ��� ���������� ����������� ������� ��������
function NewMenu_Otkl_ZapretMont(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //----------------------------------------------------- �������������� �������
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,528+$4000,7,'');
      msg := GetSmsg(1,528, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtklZapMont;
      DspCom.Obj := ID_Obj;
    end else
    begin //---------------------------------------------------- ��������������� �������
      InsNewMsg(ID_Obj,527+$4000,7,'');
      msg := GetSmsg(1,527, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvOtklZapMont;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //------------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands;
    SimpleBeep;
    msg := GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    ShowSmsg(276,LastX,LastY,'');
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------------------- �������� ���� ��� ���������� �����
function NewMenu_OtklUKSPS(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- �������������� �������
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,202+$4000,7,'');
      msg := GetSmsg(1,202, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtkluchenieUKSPS;
      DspCom.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- ���� 1-�� ��� 2-�� ������
    //if ObjZv[ID_Obj].bP[3] or ObjZv[ID_Obj].bP[4] then
    begin //------------------------------------- �������� ����� - ��������������� �������
      InsNewMsg(ID_Obj,201+$4000,7,'');
      msg := GetSmsg(1,201, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvOtkluchenieUKSPS;
      DspCom.Obj := ID_Obj;
    end;
  end
  else
  begin //--------------------------------------- �� ������ �� - �������� ���������� �����
    if ObjZv[ID_Obj].bP[1] and ObjZv[ID_Obj].ObCB[1] then
    begin //--------------- ���� ������� ������ � ����� ������������ - �������� ����������
      InsNewMsg(ID_Obj,353+$4000,1,'');
      msg := GetSmsg(1,353, ObjZv[ID_Obj].Liter,1);
      DspCom.Com := M_OtmenaOtkluchenieUKSPS;
      DspCom.Obj := ID_Obj;
    end else
    begin
      InsNewMsg(ID_Obj,276+$4000,1,'');
      ResetCommands;
      ShowSmsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------- �������� ���� ��� ���������� �������� "��������������� �����"
function NewMenu_VspomPriem(X,Y : SmallInt): boolean;
begin //------------------------------------------------------------ ��������������� �����
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //-------------------------------------------------- �������������� ������� ��
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,211+$4000,7,'');
      msg := GetSmsg(1,211, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolVspomPriem;
      DspCom.Obj := ID_Obj;
    end else
    begin
      if ObjZv[ObjZv[ID_Obj].BasOb].bP[6] then //����-���� �������� � �������
      begin //----------------------------------------------- ��������������� ������� ��
        InsNewMsg(ID_Obj,210+$4000,7,'');
        msg := GetSmsg(1,210, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvVspomPriem;
        DspCom.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- �� ����� �� ��������
        InsNewMsg(ID_Obj,337+$4000,1,'');
        ShowSmsg(357,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end;
    end;
  end else
  begin //------------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands;
    ShowSmsg(276,LastX,LastY,'');
    msg := GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    SimpleBeep;
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------- �������� ���� ��� ������� "��������������� �����������"
function NewMenu_VspOtpr(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //-------------------------------------------------- �������������� ������� ��
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,209+$4000,7,'');
      msg := GetSmsg(1,209, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolVspomOtpravlenie;
      DspCom.Obj := ID_Obj;
    end else
    begin //--------------------------------------------------------------- ��������� ��
      if ObjZv[ObjZv[ID_Obj].BasOb].bP[6] then //����-���� �������� � �������
      begin //----------------------------------------------- ��������������� ������� ��
        InsNewMsg(ID_Obj,208+$4000,7,'');
        msg := GetSmsg(1,208, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvVspomOtpravlenie;
        DspCom.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- �� ����� �� ��������
        InsNewMsg(ID_Obj,357+$4000,1,'');
        ShowSmsg(357,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end;
    end;
  end else
  begin //----------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands;
    ShowSmsg(276,LastX,LastY,'');
    msg := GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    SimpleBeep;
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------- �������� ���� ��� ������� "������� �������"
function NewMenu_OchistkaStrelok(X,Y : SmallInt): boolean;
begin //------------------------------------------------------------------ ������� �������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}  ID_ViewObj := ID_Obj; exit;  {$ELSE}

  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- ���������� �����

  if ObjZv[ID_Obj].bP[1] then
  begin //---------------------------------------------------------------- �������� ������
    InsNewMsg(ID_Obj,5+$4000,7,'');
    msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
    DspCom.Com := M_OtklOchistkuStrelok;
    DspCom.Obj := ID_Obj;
  end else
  begin //------------------------------------------------------------------ ������ ������
    InsNewMsg(ID_Obj,4+$4000,7,'');
    msg := MsgList[ObjZv[ID_Obj].ObCI[4]];
    DspCom.Com := M_VkluchOchistkuStrelok;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------------- ��������� �������� ������� ���1
function NewMenu_VklGRI1(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then //--------------------------------- ���� ������������� �������
  begin //--------------------------------------------------------------- ������ �������
    if ObjZv[ID_Obj].bP[2] then
    begin //----------------------------------- ��� �������� �������� ������� �� - �����
      InsNewMsg(ID_Obj,335+$4000,1,'');
      ShowSmsg(335,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end else
    begin //------------------------------------------------------------- ������ �������
      msg := '';
      if ObjZv[ID_Obj].ObCI[3] <> 0 then
      begin
        //--------------------------------- �� ������� ������ ��� ��,���� ��������������
        InsNewMsg(ID_Obj,214+$4000,7,'');
        if not ObjZv[ID_Obj].bP[3] then msg := GetSmsg(1,264,'',1) + ' ';
      end;
      msg := msg + GetSmsg(1,214, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_VkluchenieGRI;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //----------------------------------------------------- �� ������������� �������
    InsNewMsg(ID_Obj,263+$4000,1,'');
    ShowSmsg(263,LastX,LastY,'');
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------- ������� ��������� �� ������, ���� ��� ����������
function NewMenu_PutIzvst(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP} ID_ViewObj := ID_Obj; exit; {$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if(WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  if WorkMode.MarhOtm then begin  WorkMode.MarhOtm := false;  exit; end;

  if WorkMode.OtvKom then
  begin //------------------------------- �� - ������������� �������� ����������� ��� ����
    InsNewMsg(ID_Obj,311+$4000,7,'');
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ID_Obj;
  end else

  if ObjZv[ID_Obj].bP[19] then //------------------- ���������� ���������������� ���������
  begin ObjZv[ID_Obj].bP[19] := false; exit; end;
  //--------------------------------------------------------------------- ���������� �����
  if ObjZv[ID_Obj].bP[13] then
  begin
    InsNewMsg(ID_Obj,171+$4000,7,'');
    msg := GetSmsg(1,171, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_PutOtkrytDvijenie;
    DspCom.Obj := ID_Obj;
  end else
  begin
    InsNewMsg(ID_Obj,170+$4000,7,'');
    msg := GetSmsg(1,170, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_PutZakrytDvijenie;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------- ������� ���� ����������
function NewMenu_DSNLamp(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if not WorkMode.OtvKom then
  begin //--------------------------------- �� ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,276+$4000,1,''); //- �������� ������� ������� ������ ��������. ������
    ResetCommands;
    SimpleBeep;
    ShowSmsg(276,LastX,LastY,'');
    msg := GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    exit;
  end else
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;

  if not ObjZv[ID_Obj].bP[1]  then
  begin
    InsNewMsg(ID_Obj,546+$4000,7,'');   //------------------------ "�������� ����� ���?"
    msg := GetSmsg(1,546,'',7);
    DspCom.Com := M_VklDSN;
  end else
  begin
    InsNewMsg(ID_Obj,547+$4000,7,'');   //----------------------- "��������� ����� ���?"
    msg := GetSmsg(1,547,'',7);
    DspCom.Com := M_OtklDSN;
  end;
  DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------------------- ��������� �������� ������
function NewMenu_RezymLampDen(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    InsNewMsg(ID_Obj,283+$4000,7,'');
    ResetCommands;
    ShowSmsg(283,LastX,LastY,'');
    msg := GetSmsg(1,283, ObjZv[ID_Obj].Liter,7);
    exit;
  end else
  begin
    InsNewMsg(ID_Obj,221+$4000,7,'');   //------------------- "�������� ������� ����� ?"
    msg := GetSmsg(1,221, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_VkluchitDen;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------------- ��������� ������� ������
function NewMenu_RezymLampNoch(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    InsNewMsg(ID_Obj,283+$4000,7,'');
    ResetCommands;
    ShowSmsg(283,LastX,LastY,'');   //----------- ������ ������ ������������� ������
    msg := GetSmsg(1,283, ObjZv[ID_Obj].Liter,7);
    exit;
  end else
  begin
    InsNewMsg(ID_Obj,222+$4000,7,'');
    msg := GetSmsg(1,222, ObjZv[ID_Obj].Liter,7);// �������� ������ ����� (������)?
    DspCom.Com := M_VkluchitNoch;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------------- ��������� ��������������� ������
function NewMenu_RezymLampAuto(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- ���������� �����
  InsNewMsg(ID_Obj,223+$4000,7,'');
  msg := GetSmsg(1,223, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_VkluchitAuto;
  DspCom.Obj := ID_Obj;
  result := true;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------- ���������� ��� �� ������������
function NewMenu_OtklUKG(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- �������������� �������
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,565+$4000,7,'');
      msg := GetSmsg(1,565, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtkluchenieUKG;
      DspCom.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- ���� 1-�� ��� 2-�� ������
    //if ObjZv[ID_Obj].bP[3] or ObjZv[ID_Obj].bP[4] then
    begin //------------------------------------- �������� ��� - ��������������� �������
      InsNewMsg(ID_Obj,564+$4000,7,'');
      msg := GetSmsg(1,564, ObjZv[ID_Obj].Liter,7);
      ShowSmsg(564,LastX,LastY,'');
      DspCom.Com := M_PredvOtkluchenieUKG;
      DspCom.Obj := ID_Obj;
    end;
  end
  else
  begin //------------------------------------------------ �� ������ �� - �������� �������
    InsNewMsg(ID_Obj,276+$4000,1,'');
    ResetCommands;
    msg := GetSmsg(1,276, ObjZv[ID_Obj].Liter,1);
    SimpleBeep;
    ShowSmsg(276,LastX,LastY,'');
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------------------ ��������� ��� � �����������
function NewMenu_VklUKG(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- ���������� �����
  InsNewMsg(ID_Obj,563+$4000,7,'');
  msg := GetSmsg(1,563, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_OtmenaOtkluchenieUKG ;
  DspCom.Obj := ID_Obj;
  result := true;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------- ���������� ������ �����
function NewMenu_OtklZvonkaUKSPS(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj; result := true;
  {$IFNDEF RMDSP}  ID_ViewObj := ID_Obj;  exit; {$ELSE}

  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsNewMsg(ID_Obj,283+$4000,1,''); ResetCommands;  ShowSmsg(283,LastX,LastY,''); exit;
  end else
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------------- ���������� �����
  InsNewMsg(ID_Obj,203+$4000,7,''); msg := GetSmsg(1,203, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_OtklZvonkaUKSPS; DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------------- ������������ ����
procedure MakeMenu(var X : smallint);
var
  i,j : integer;
begin   //-------------------------------------------------------------- ������������ ����
{$IFDEF RMDSP}
  if DspMenu.Count > 0 then //---------------------------------- ���� ���� ���-�� ��� ����
  begin
    TabloMain.PopupMenuCmd.Items.Clear; //---------------------------- �������� ���� �����
    for i := 1 to DspMenu.Count
    do TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//����� ���� �� DspMenu
    i := configRU[config.ru].T_S.Y - 10;
    SetCursorPos(x,i);
    TabloMain.PopupMenuCmd.Popup(X, i+3-17*DspMenu.Count);
  end  else
  begin //---------------------------- ������� ��������� ����� ����������� ������� �������
    j := x div configRU[config.ru].MonSize.X + 1; //-------------------- ����� ����� �����
    //------------------------- ���� ��� �� �����, ������� ������������� ������ ����������

    for i:=1 to High(SMsg) do
    begin
      if i=j then begin Smsg[i]:=msg; SMsgCvet[i]:=GetColor1(7); end else Smsg[i]:='';
    end;
  end;
{$ENDIF}
end;

//========================================================================================
//------------------------------------ �������� ����������� ��������� � ����������� ������
function Spec_Reg(ID_Obj : SmallInt) : Boolean;
begin
  result := true;
  if NazataKOK(ID_Obj) then exit;
  if ActivenVSP(ID_Obj) then exit;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  result := false;
end;

//========================================================================================
//------------------------------------------------------- ����� ��������� "��� �� �������"
function NotStr(ID_Obj : SmallInt): boolean;
var
  clr : Integer;
begin
  clr := 1;
  InsNewMsg(ID_Obj,9+$4000,clr,'');  //------------------------------------- "��� �� �������"
  msg := GetSmsg(1,9,'',clr);
  ShowSmsg(9,LastX,LastY,'');
  result := true;
end;

//========================================================================================
//------------------------------------------------------ ����� ��������� "������ ������ ��
function NazataKOK(ID_Obj : SmallInt) : Boolean;
var
  color : Integer;
begin //------------------------------------ ������ �� - ���������� ������������ �������
  if WorkMode.OtvKom then
  begin
    color := 1;
    ResetCommands;
    InsNewMsg(ID_Obj,283+$4000,color,'');
    ShowSmsg(283,LastX,LastY,'');
    msg := GetSmsg(1,283, ObjZv[ID_Obj].Liter,color);
    result := true;  
  end else result := false;
end;

//========================================================================================
//-------------------------------------------------------- ����� ���������������� ��������
function ActivenVSP(ID_Obj : SmallInt) : Boolean;
begin
  if VspPerevod.Active then
  begin
    InsNewMsg(ID_Obj,149+$4000,1,'');
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowSmsg(149, LastX, LastY, '');
    result := true; 
  end else result := false;
end;

//========================================================================================
//---------------------------------------------------------------------- ����� �����������
function Trassir : Boolean;
begin
{$IFNDEF TABLO}
  if WorkMode.GoTracert then begin ResetTrace; DspCom.Com := 0; result := true; end
  else result := false;
{$ENDIF}
end;

end.
