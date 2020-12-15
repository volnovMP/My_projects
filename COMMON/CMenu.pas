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

function CreateDspMenu(ID, X, Y : SmallInt) : Boolean;
function CreateDspMenu_Strelka(ID, X, Y : SmallInt) : Boolean;
function CreateDspMenuSvetofor(ID,X,Y : SmallInt): boolean;
function CreateDspMenuAvtoSvetofor(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_1bit(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_2bit(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_PRZD_Zakr_Otkr(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_Zapr_Razr_Mont(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_VklOtkl1bit(ID,X,Y : SmallInt): boolean;
function CreateDspMenuVydachaPSoglasiya(ID,X,Y : SmallInt): boolean;
function CreateDspMenuNadvig(ID,X,Y : SmallInt): boolean;
function CreateDspMenuOPI(ID,X,Y : SmallInt): boolean;
function CreateDspMenuUchastok(ID,X,Y : SmallInt): boolean;
function CreateDspMenuPutPO(ID,X,Y : SmallInt): boolean;
function CreateDspMenuPSoglasiya(ID,X,Y : SmallInt): boolean;
function CreateDspMenuSmenaNapravleniya(ID,X,Y : SmallInt;var gotomenu : boolean): boolean;
function CreateDspMenu_KSN(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_PAB(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_ManevrovayaKolonka(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_ZamykanieStrelok(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_RazmykanieStrelok(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_ZakrytPereezd(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_OtkrytPereezd(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_Otkl_ZapretMonteram(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_PoezdnoeOpoveshenie(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_IzvesheniePereezd(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_ZapretMonteram(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_VykluchenieUKSPS(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_VspomPriem(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_VspomOtpravlenie(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_OchistkaStrelok(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_VkluchenieGRI1(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_PutManevrovyi(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_RezymPitaniyaLamp(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_RezymLampDen(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_RezymLampNoch(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_RezymLampAuto(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_OtklZvonkaUKSPS(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_OtklUKG(ID,X,Y : SmallInt): boolean;
function CreateDspMenu_VklUKG(ID,X,Y : SmallInt): boolean;
function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
function LockDirect : Boolean;

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
IDMenu_Strelka             = 1;  //---- �������� � Tablo ����������� ������������� �� ����
IDMenu_SvetoforManevr      = 2;  //---- �������� � Tablo ����������� ������������� �� ����
IDMenu_Uchastok            = 3;  //---- �������� � Tablo ����������� ������������� �� ����
IDMenu_PutPO               = 4;  //---- �������� � Tablo ����������� ������������� �� ����
IDMenu_ZamykanieStrelok    = 5;  //------------------- ��������� ������� ��������� �������
IDMenu_RazmykanieStrelok   = 6;  //------------------ ���������� ������� ��������� �������
IDMenu_ZakrytPereezd       = 7;  //------------------  �������� �������� (������� �������)
IDMenu_OtkrytPereezd       = 8;  //------------- �������� �������� (������������� �������)
IDMenu_IzvesheniePereezd   = 9;  //------------------ ������ / ������ ��������� �� �������
IDMenu_PoezdnoeOpoveshenie = 10; //----------- ��������� / ���������� ��������� ����������
IDMenu_ZapretMonteram      = 11; //-----------------  ��������� ������� �������� (�������)
IDMenu_VykluchenieUKSPS    = 12; //------ ���������� ����� �� ������������ (�������������)
IDMenu_SmenaNapravleniya   = 13; //--------------------------- ����� ����������� (�������)
IDMenu_VspomPriem          = 14; //----------------- ��������������� ����� (�������������)
IDMenu_VspomOtpravlenie    = 15; //----------- ��������������� ����������� (�������������)
IDMenu_OchistkaStrelok     = 16; //------------------------------ �������(�������) �������
IDMenu_VkluchenieGRI1      = 17; //---------------- ��������� �������� ��� (�������������)
IDMenu_PutManevrovyi       = 18; //------ ������� ��������� �� ������ (����/���� ��������)
IDMenu_SvetoforSovmech     = 19; //---- �������� � Tablo ����������� ������������� �� ����
IDMenu_SvetoforVhodnoy     = 20; //---- �������� � Tablo ����������� ������������� �� ����
IDMenu_VydachaPSoglasiya   = 21; //-------------------- ������ ��������� �������� �� �����
IDMenu_ZaprosPSoglasiya    = 22; //----------- ������ ��������� �������� (��� �����������)
IDMenu_ManevrovayaKolonka  = 23; //------------------------------------ ���������� �������
IDMenu_RezymPitaniyaLamp   = 24; //-------------------------- ��������� ������� ���� "���"
IDMenu_RezymLampDen        = 25; //-------- ��������� ������ ������� ���� ��������� "����"
IDMenu_RezymLampNoch       = 26; //-------- ��������� ������ ������� ���� ��������� "����"
IDMenu_RezymLampAuto       = 27; //----------- ������� ����� ������� ���� ��������� � ����
IDMenu_OtklZvonkaUKSPS     = 28; //------------------------------- ���������� ������ �����
IDMenu_PAB                 = 29; //------------------------- ������������������ ����������
IDMenu_Nadvig              = 30; //------------------------------------------------ ������
IDMenu_KSN                 = 31; //------------------------------ ����������� ��������� ��
IDMenu_OPI                 = 32; //--------------------------- ���������� ���� �� ��������
IDMenu_AutoSvetofor        = 33; //------------------------- ��������� ������ ������������
IDMenu_Tracert             = 34; //----------------------- ����������� �� �������� �������
IDMenu_GroupDat            = 35; //--------------------- ������ ������� �������� �� ��� ��
IDMenu_1bit                = 36; //------------------------- ��������� / ���������� ���� 1
IDMenu_2bit                = 37; //------------------------- ��������� / ���������� ���� 2
IDMenu_3bit                = 38; //------------------------- ��������� / ���������� ���� 3
IDMenu_4bit                = 39; //------------------------- ��������� / ���������� ���� 4
IDMenu_5bit                = 40; //------------------------- ��������� / ���������� ���� 5
IDMenu_OtklZapMont         = 41; //--- ������������� ���������� ������� �������� � 2� ����
IDMenu_VklUKG              = 42; //----------------------------- ������� � ����������� ���
IDMenu_OtklUKG             = 43; //--------- ��������� ��� �� ������������ (�������������)
IDMenu_VklOtkl_bit1        = 44; //- ��������/��������� ������ 1-�� ���� � ������ ��������
IDMenu_IzvesheniePereezd1  = 45; //--- ���������� ���������� �������� ����� ������ �������
IDMenu_PRZD_Zakr_Otkr      = 46; //------------ �������� / �������� �������� ����� �������
IDMenu_Zapr_Razr_Mont      = 47; //------------ ������ / ���������� �������� ����� �������

//--------------------------------------------- ������� ���� -----------------------------
//-------------------------------------------------------------------- ������� ��� �������
CmdMenu_StrPerevodPlus         = 1;
CmdMenu_StrPerevodMinus        = 2;
CmdMenu_StrVPerevodPlus        = 3;
CmdMenu_StrVPerevodMinus       = 4;
CmdMenu_StrOtklUpravlenie      = 5;
CmdMenu_StrVklUpravlenie       = 6;
CmdMenu_StrZakrytDvizenie      = 7;
CmdMenu_StrOtkrytDvizenie      = 8;
CmdMenu_UstMaketStrelki        = 9; //------------------------ ���������� ������� �� �����
CmdMenu_SnatMaketStrelki      = 10; //----------------------------- ����� ������� � ������
CmdMenu_StrMPerevodPlus       = 11;
CmdMenu_StrMPerevodMinus      = 12;
CmdMenu_StrZakryt2Dvizenie    = 13;
CmdMenu_StrOtkryt2Dvizenie    = 14;
CmdMenu_StrZakrytProtDvizenie = 15;
CmdMenu_StrOtkrytProtDvizenie = 16;
//-------------------------- 17..20 ---------------------------- ������ ������ ��� �������
//------------------------------------------------------------------- ������� ��� ��������
CmdMenu_OtkrytManevrovym      = 21;
CmdMenu_OtkrytPoezdnym        = 22;
CmdMenu_OtmenaManevrovogo     = 23;
CmdMenu_OtmenaPoezdnogo       = 24;
CmdMenu_PovtorManevrovogo     = 25;
CmdMenu_PovtorPoezdnogo       = 26;
CmdMenu_BlokirovkaSvet        = 27;
CmdMenu_DeblokirovkaSvet      = 28;
CmdMenu_BeginMarshManevr      = 29;
CmdMenu_BeginMarshPoezd       = 30;
CmdMenu_DatPoezdnoeSoglasie   = 31;
CmdMenu_SnatPoezdnoeSoglasie  = 32;
CmdMenu_OtkrytProtjag         = 33;
CmdMenu_PovtorManevrMarsh     = 34;
CmdMenu_PovtorPoezdMarsh      = 35;
CmdMenu_OtkrytAuto            = 36;
CmdMenu_AutoMarshVkl          = 37;
CmdMenu_AutoMarshOtkl         = 38;
CmdMenu_PovtorOtkrytManevr    = 39;
CmdMenu_PovtorOtkrytPoezd     = 40;
//
CmdMenu_SekciaPredvaritRI       = 41;
CmdMenu_SekciaIspolnitRI        = 42;
CmdMenu_SekciaZakrytDvijenie    = 43;
CmdMenu_SekciaOtkrytDvijenie    = 44;
CmdMenu_SekciaZakrytDvijenieET  = 45;
CmdMenu_SekciaOtkrytDvijenieET  = 46;
CmdMenu_SekciaZakrytDvijenieETA = 47;
CmdMenu_SekciaOtkrytDvijenieETA = 48;
CmdMenu_SekciaZakrytDvijenieETD = 49;
CmdMenu_SekciaOtkrytDvijenieETD = 50;
//
CmdMenu_PutDatSoglasieOgrady   = 51;
//--------------------------------------------------------------------------- 52 - ������;
CmdMenu_PutZakrytDvijenie      = 53;
CmdMenu_PutOtkrytDvijenie      = 54;
CmdMenu_PutZakrytDvijenieET    = 55;
CmdMenu_PutOtkrytDvijenieET    = 56;
CmdMenu_PutZakrytDvijenieETA   = 57;
CmdMenu_PutOtkrytDvijenieETA   = 58;
CmdMenu_PutZakrytDvijenieETD   = 59;
CmdMenu_PutOtkrytDvijenieETD   = 60;
//
CmdMenu_ZamykanieStrelok       = 61;
CmdMenu_PredvRazmykanStrelok   = 62;
CmdMenu_IspolRazmykanStrelok   = 63;

CmdMenu_VklDSN = 64; //------------------------------------------------------ �������� ���
CmdMenu_OtklDSN = 65; //---------------------------------------------------- ��������� ���

CmdMenu_VklBit1_1 = 66;//---------------------------------- �������� ��� 1 ������� �������
CmdMenu_VklBit1_2 = 67;//---------------------------------- �������� ��� 1 ������� �������

//----------------------------------------------------------------- 68..70 - ������ ������
CmdMenu_ZakrytPereezd          = 71;
CmdMenu_PredvOtkrytPereezd     = 72;
CmdMenu_IspolOtkrytPereezd     = 73;
CmdMenu_DatIzvecheniePereezd   = 74;
CmdMenu_SnatIzvecheniePereezd  = 75;
CmdMenu_PredvZakrPereezd       = 76;
CmdMenu_IspolZakrPereezd       = 77;
CmdMenu_SnatIzvecheniePereezd1  = 78;
//------------------------------------------------------------------ 79,80 - ������ ������
CmdMenu_DatOpovechenie         = 81;
CmdMenu_SnatOpovechenie        = 82;
CmdMenu_DatZapretMonteram      = 83;//-- ���������� ������� ������� �����. ������� ��� ���
CmdMenu_SnatZapretMonteram     = 84;//----- ������� ���-����������� ������� ������ �������

CmdMenu_PredOtklBit3           = 85; //---���������� ������� ��������������� ������ ���� 3
CmdMenu_IspolOtklBit3          = 86; //----���������� ������� �������������� ������ ���� 3

CmdMenu_PredvOtklZapMont       = 87;//-- ���������� ������� ��������������� ������ �������
CmdMenu_IspolOtklZapMont       = 88;//--- ���������� ������� �������������� ������ �������
//--------------------------------------------------- 89..90 - ������ ������ �� ����������
CmdMenu_PredvOtkluchenieUKSPS  = 91;
CmdMenu_IspolOtkluchenieUKSPS  = 92;
CmdMenu_OtklZvonkaUKSPS        = 93;
CmdMenu_OtmenaOtkluchenieUKSPS = 94;
//----------------------------------------------------------------------------------------
CmdMenu_PredvOtkluchenieUKG  = 95;
CmdMenu_IspolOtkluchenieUKG  = 96;
CmdMenu_OtmenaOtkluchenieUKG = 97;
//---------------------------------------------------------- 98..100 - ������ ������ �����
CmdMenu_SmenaNapravleniya      = 101;
CmdMenu_DatSoglasieSmenyNapr   = 102;
CmdMenu_ZakrytPeregon          = 103;
CmdMenu_OtkrytPeregon          = 104;
CmdMenu_PredvVspomOtpravlenie  = 105;
CmdMenu_IspolVspomOtpravlenie  = 106;
CmdMenu_PredvVspomPriem        = 107;
CmdMenu_IspolVspomPriem        = 108;
CmdMenu_VklKSN                 = 109;
CmdMenu_OtklKSN                = 110;
//
CmdMenu_VkluchOchistkuStrelok  = 111;
CmdMenu_OtklOchistkuStrelok    = 112;
CmdMenu_VkluchenieGRI          = 113;
//--------------------------------------------------------------------------- 114 - ������
CmdMenu_ZaprosPoezdSoglasiya    = 115;
CmdMenu_OtmZaprosPoezdSoglasiya = 116;
// 117..120 - ������
CmdMenu_DatRazreshenieManevrov  = 121;
CmdMenu_OtmenaManevrov          = 122;
CmdMenu_PredvIRManevrov         = 123;
CmdMenu_IspolIRManevrov         = 124;
//----------------------------------------------- 125..130 - ������ ��� ���������� �������
CmdMenu_VkluchitDen             = 131;
CmdMenu_VkluchitNoch            = 132;
CmdMenu_VkluchitAuto            = 133;
CmdMenu_OtkluchitAuto           = 134;
//
CmdMenu_Osnovnoy                = 135;
//CmdMenu_Rezerv                = 136; ����� ������������ ��� ������ �����
CmdMenu_RU1                     = 137;
CmdMenu_RU2                     = 138;
CmdMenu_ResetCommandBuffers     = 139;
// 140 - ������
// ���
CmdMenu_VydatSoglasieOtpravl    = 141;
CmdMenu_OtmenaSoglasieOtpravl   = 142;
CmdMenu_IskPribytiePredv        = 143;
CmdMenu_IskPribytieIspolnit     = 144;
CmdMenu_VydatPribytiePoezda     = 145;
CmdMenu_ZakrytPeregonPAB        = 146;
CmdMenu_OtkrytPeregonPAB        = 147;
// ���������� �������
CmdMenu_BlokirovkaNadviga       = 151;
CmdMenu_DeblokirovkaNadviga     = 152;
// ���������� ������
CmdMenu_OtkrytUvjazki           = 153;
CmdMenu_ZakrytUvjazki           = 154;
//
CmdMenu_RestartServera          = 160;
CmdMenu_RestartUVK              = 161;

CmdMenu_SnatSoglasieSmenyNapr   = 162; //---------------------------------------------- ��
CmdMenu_PutVklOPI               = 163; //-------------------------------------------- ����
CmdMenu_PutOtklOPI              = 164; //-------------------------------------------- ����
CmdMenu_ABZakrytDvijenieET      = 165;
CmdMenu_ABOtkrytDvijenieET      = 166;
CmdMenu_ABZakrytDvijenieETA     = 167;
CmdMenu_ABOtkrytDvijenieETA     = 168;
CmdMenu_ABZakrytDvijenieETD     = 169;
CmdMenu_ABOtkrytDvijenieETD     = 170;
CmdMenu_RPBZakrytDvijenieET     = 171;
CmdMenu_RPBOtkrytDvijenieET     = 172;
CmdMenu_RPBZakrytDvijenieETA    = 173;
CmdMenu_RPBOtkrytDvijenieETA    = 174;
CmdMenu_RPBZakrytDvijenieETD    = 175;
CmdMenu_RPBOtkrytDvijenieETD    = 176;
CmdMenu_EZZakrytDvijenieET      = 177;
CmdMenu_EZOtkrytDvijenieET      = 178;
CmdMenu_EZZakrytDvijenieETA     = 179;
CmdMenu_EZOtkrytDvijenieETA     = 180;
CmdMenu_EZZakrytDvijenieETD     = 181;
CmdMenu_EZOtkrytDvijenieETD     = 182;
CmdMenu_MEZZakrytDvijenieET     = 183;
CmdMenu_MEZOtkrytDvijenieET     = 184;
CmdMenu_MEZZakrytDvijenieETA    = 185;
CmdMenu_MEZOtkrytDvijenieETA    = 186;
CmdMenu_MEZZakrytDvijenieETD    = 187;
CmdMenu_MEZOtkrytDvijenieETD    = 188;
CmdMenu_RescueOTU               = 189; //---------------------- ������������ ��������� ���
CmdMenu_VklBit1                 = 191; //---------------------- �������� ��� ������� ��� 1
CmdMenu_OtklBit1                = 192; //--------------------- ��������� ��� ������� ��� 1
CmdMenu_VklBit2                 = 193; //---------------------- �������� ��� ������� ��� 2
CmdMenu_OtklBit2                = 194; //--------------------- ��������� ��� ������� ��� 2
CmdMenu_VklBit3                 = 195; //---------------------- �������� ��� ������� ��� 3
CmdMenu_OtklBit3                = 196; //--------------------- ��������� ��� ������� ��� 3
CmdMenu_VklBit4                 = 197; //---------------------- �������� ��� ������� ��� 4
CmdMenu_OtklBit4                = 198; //--------------------- ��������� ��� ������� ��� 4
CmdMenu_VklBit5                 = 199; //---------------------- �������� ��� ������� ��� 5
CmdMenu_OtklBit5                = 200; //--------------------- ��������� ��� ������� ��� 5
//---------------------------------------------------------------- ���� ������-������ ����
KeyMenu_RazdeRejim          = 1001; //------------------- ���������� ����� ���������� <F1>
KeyMenu_MarshRejim          = 1002; //------------------- ���������� ����� ���������� <F1>
KeyMenu_MaketStrelki        = 1003; //------------------------ ���������� ������� �� �����
KeyMenu_OtmenMarsh          = 1004; //------------------------------------ ������ ��������
KeyMenu_DateTime            = 1005; //------------------------------ ���������� ����� <F2>
KeyMenu_InputOgr            = 1006; //------------------------ ������� �� ���� �����������
KeyMenu_VspPerStrel         = 1007; //-------------------- ��������������� ������� �������
KeyMenu_EndTrace            = 1008; //------------------------ ����� ������ �������� <End>
KeyMenu_ClearTrace          = 1009; //---------------------------------------- <Shift+End>
KeyMenu_RejimRaboty         = 1010; //-------------------- ������ ����� ������ ������ ����
KeyMenu_ReadyResetTrace     = 1011; //- ���� ������ ������ ������ �������� �� ������������
KeyMenu_EndTraceError       = 1012; //----- �������� ����� ������ �������� ������� �������
KeyMenu_ReadyWarningTrace   = 1013; //--------- �������� ������������� ��������� �� ������
KeyMenu_ReadyWarningEnd     = 1014; //--- �������� ������������� ��������� �� ����� ������
KeyMenu_BellOff             = 1015; //---------------------------- ���������� ������ <F12>
KeyMenu_UpravlenieUVK       = 1016; //-------------------------------- ���� ���������� ���
KeyMenu_ReadyRestartServera = 1017; //--------- �������� ������������� ����������� �������
KeyMenu_ReadyRestartUVK     = 1018; //------------ �������� ������������� ������������ ���
KeyMenu_RezervARM           = 1019; //--------------------- ������� �������� ���� � ������
KeyMenu_QuerySetTrace       = 1020; //---- ������ �� ��������� ������� �� ��������� ������
KeyMenu_PodsvetkaStrelok    = 1021; //----------------- ������ ��������� ��������� �������
KeyMenu_VvodNomeraPoezda    = 1022; //------------------------- ������ ����� ������ ������
KeyMenu_PodsvetkaNomerov    = 1023; //-------------------- ������ ��������� ������ �������
KeyMenu_ReadyRescueOTU      = 1024; //���� ������������� �������������� ���������� ��� ���
NetKomandy : string = '��� �������';

var
  IndexFR3IK : SmallInt; //--------- ������ ������� ����������� ��� ��� �������������� ���
  DesktopSize : TPoint; //--------------- ������ �������� ����� �� ����� ������� ���������

{$IFDEF RMARC}  cmdmnu : string; {$ENDIF}

{$IFDEF RMDSP} msg : string; {$ENDIF}

 bit_for_kom : integer;

implementation
uses
  Commons,
  TypeALL,

{$IFDEF RMARC}
  TabloFormARC,
{$ENDIF}

{$IFNDEF TABLO}
  Marshrut,
{$ENDIF}


{$IFDEF RMSHN}
  ValueList,
  TabloSHN,
{$ENDIF}

{$IFDEF RMDSP}
  TabloForm,
{$ENDIF}

{$IFDEF TABLO}
  TabloForm1,
{$ENDIF}

 Commands;


//========================================================================================
//------------------------------------------------------- ������� ���������� ������ � ����
function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
begin
  try
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
  except
    reportf('������ [CMenu.AddDspMenuItem]');
    result := true;
  end;
end;
//========================================================================================
//-------------------------------------------------- ��������� ������� ���������� ���� ���
//------------------------------------------------ ID = ��� ���������, �������� � ��������
//--------------------------------------------------------------- X,Y = ���������� �������
//------------------ ���� ���������� true - ���� ��������� ��������� �������� ����� ������
function CreateDspMenu(ID,X,Y : SmallInt): boolean;
var
  i,j,color : integer;
  gotomen, Trans : Boolean;
  test_long : LongInt;
  hMenuWnd : HWND;
  hMenuDC : HDC;
  dwStyle : DWORD;
  t0 : TPoint;
  TXT : string;
begin
  try
    ObjHintIndex := 0;
{$IFDEF RMARC}
    if (ID_Obj > 0) and (ID_Obj < WorkMode.LimitObjZav) then
    cmdmnu := DateTimeToStr(CurrentTime)+ ' > '+ ObjZav[ID_Obj].Liter
    else cmdmnu := DateTimeToStr(CurrentTime)+ ' > ';
{$ELSE}
    SetLockHint; //------------------------------ ���������� ������ �������� ������� �����
{$ENDIF}

    DspCommand.Active := false; //-- �������� ������� ������� �������, ��������� ���������
    DspCommand.Command := 0;   //------------------------------------ �������� ��� �������
    DspCommand.Obj := 0;       //--------------------------------- �������� ������ �������

    DspMenu.Ready := false;    //---------------- �������� ������� �������� ������ �������
    DspMenu.obj := cur_obj; //----------------------- ��������� ����� ������� ��� ��������
    DspMenu.Count := 0; //--------------------------------------- ����� ����� ������� ����
{$IFNDEF RMARC}
    ResetShortMsg;
    ShowWarning := false;
{$ENDIF}

    result := false;
//------------------------------------------------------------ ��������� ����� ������ ����
{$IFDEF RMDSP}
    msg := '';
    InsNewArmCmd(DspMenu.obj+$8000,ID); //-- �������� ������� � �������� ��������� (�����)
    //-------------------- ����������� �������, ����������� � ������ ���������� ����������
    case ID of
      KeyMenu_PodsvetkaStrelok,   //--------------------- ��������� ��������� ������� 1021
      KeyMenu_VvodNomeraPoezda, //-------------------------------- ���� ������ ������ 1022
      KeyMenu_PodsvetkaNomerov,  //------------------------- ��������� ������ ������� 1023
      KeyMenu_BellOff ://----------------------------- ����� ������������ ������ 1015 <F12
      begin
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_DateTime : //----------------------------------------------------- 1005 <F2>
      begin //-------------------------------------------------------- ���� ������� ��-���
        DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0;
        if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 / 24) then
        begin
          InsArcNewMsg(0,252+$4000,0); //------------------------------ "�������� ����� ?"
          color := 0;
          msg := GetShortMsg(1,252,'',color);
          DspMenu.WC := true;
          MakeMenu(X);
          exit;
        end else
        begin
          InsArcNewMsg(0,435+$4000,1);//-- "��������� ������� � 22:55 �� 01:05 ���������!"
          ShowShortMsg(435,LastX,LastY,'');
          DspMenu.WC := true;
          exit;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ClearTrace : //-------------------------------------------- 1009 <Shift+End>
      begin //--------------------------- ����� ����������� ��������, ����� ������� ������
        if (CmdCnt > 0) or WorkMode.MarhRdy or WorkMode.CmdReady then
        begin
          DspCommand.Active := true;
          DspCommand.Command := ID;
          DspCommand.Obj := 0;
        end;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_RejimRaboty : //------------------------------------------------------- 1010
      begin //--------------------------------------------------- ����� ������ ������ ����
        if config.configKRU > 0 then exit;

        if WorkMode.CmdReady then
        begin
          InsArcNewMsg(0,251+$4000,1);// ���� ������ �������� ������������.����� �� �����.
          ShowShortMsg(251,LastX,LastY,'');
          exit;
        end;

        if WorkMode.Upravlenie then
        begin //------------------------------------------------------���� ��� �����������
          if ((StateRU and $40) = 0) or WorkMode.BU[0] then
          begin //------------------------- ���� �� ������� "����� ��" ��� �������� ������
            InsArcNewMsg(0,225+$4000,7); //-------- "����������� ������� ���-��� � ������"
            DspCommand.Active := true;
            DspCommand.Command := KeyMenu_RezervARM;
            color := 7;
            msg := GetShortMsg(1,225,'',color);
            result := true;
            DspMenu.WC := true;
            MakeMenu(X);
            exit;
          end;
        end
        else
        begin //------------------------------------------------------- ���� ��� � �������
          if WorkMode.OtvKom then
          begin
            InsArcNewMsg(0,224+$4000,0); //------------------------ "�������� ����������?"
            //---------------------------------------------------- CmdMenu_Osnovnoy = 135;
            color := 0;
            AddDspMenuItem(GetShortMsg(1,224,'',color),CmdMenu_Osnovnoy,ID_Obj);
            DspMenu.WC := true;//------------------------------------- ����� �������������
            MakeMenu(X);
            exit;
          end
          else
          begin //---------------------------------- �� ������ ������ ������������� ������
            InsArcNewMsg(0,276,1); //----------------------- "�������� ������� ������� ��"
            ShowShortMsg(276,LastX,LastY,'');
            SimpleBeep;
            color := 1;
            msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,color);
            DspMenu.WC := true;
            exit;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_UpravlenieUVK ://------------------------------------------------------ 1016
      begin //--------------------------------------------- ������� ���������� ������� ���
        if WorkMode.CmdReady then
        begin
          InsArcNewMsg(0,251+$4000,1);// ���� ������ �������� ������������. ����� �� �����
          ShowShortMsg(251,LastX,LastY,'');
          exit;
        end;
        if WorkMode.OtvKom then //---------------------------------- ���� ������ ������ ��
        begin
          if config.configKRU = 0 then
          begin
            InsArcNewMsg(0,347+$4000,7);//---------- "������ ������� ����������� �������?"
            color := 7;
            AddDspMenuItem(GetShortMsg(1,347,'',color),CmdMenu_RestartServera,ID_Obj);
          end;
          for i := 1 to high(ObjZav) do //-- ������ ���� �� �������� ����������� ���� ����
          begin
            if ObjZav[i].TypeObj = 37 then //------------ ���� ��� ������ ����������� ����
            begin
              InsArcNewMsg(i,348+$4000,7);//- "������ ������� ������������ ���������� ��?"
              color := 7;
              AddDspMenuItem(GetShortMsg(1,348,ObjZav[i].Liter,color),CmdMenu_RestartUVK,i);
              if ObjZav[i].ObjConstB[1] then//--------- ���� ���� ������ - ���������� ����
              begin
                InsArcNewMsg(i,505+$4000,7); //---------- "������������ ��������� ��� ��?"
                color := 7;
                AddDspMenuItem(GetShortMsg(1,505,ObjZav[i].Liter,color),CmdMenu_RescueOTU,i);
              end;
            end;
          end;
          DspMenu.WC := true; //------------------------------------- ����� ��������������
          MakeMenu(X);
          exit;
        end else
        begin //------------------------------------ �� ������ ������ ������������� ������
          InsArcNewMsg(0,276,1); //------------------ "�������� ������� ������� ������ ��"
          ShowShortMsg(276,LastX,LastY,'');
          SimpleBeep;
          color := 1;
          msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,color);
          DspMenu.WC := true;
          exit;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRestartServera ://------------------------------------------------ 1017
      begin //----------------------------------�������� ������������� ����������� �������
        InsArcNewMsg(0,351+$4000,7);//--- "����������� ������ ������� ����������� �������"
        DspCommand.Active := true;
        DspCommand.Command := ID;
        color := 7;
        msg := GetShortMsg(1,351,'',color);
        result := true;
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRestartUVK ://---------------------------------------------------- 1018
      begin //------------------------------------ �������� ������������� ������������ ���
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := IndexFR3IK;
        IndexFR3IK := 0;
        InsArcNewMsg(DspCommand.Obj,352+$4000,7); //"����������� ������� ������������ ���"
        color :=  7;
        msg := GetShortMsg(1,352,ObjZav[DspCommand.Obj].Liter,color);
        result := true;
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRescueOTU : //--------------------- �������� ������� �������������� ���
      begin //
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := IndexFR3IK;
        IndexFR3IK := 0;
        InsArcNewMsg(DspCommand.Obj,504+$4000,7);// ����������� ������� �������������� ���
        color :=  7;
        msg := GetShortMsg(1,504,ObjZav[DspCommand.Obj].Liter,color);
        result := true;
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
    end;//-------------------------------------------------------- ����� ������� "case ID"

    if LockDirect then exit; //--------------------- ���� ���� ������ ������������ - �����

    if CheckOtvCommand(ID_Obj) then //��������� ������� �������� ������������� ��� �������
    begin
      OtvCommand.Active := false; 
			WorkMode.GoOtvKom := false; 
			OtvCommand.Ready := false;
      ShowShortMsg(153,LastX,LastY,''); //-- "�������������� ������������ ���������������"
//      SingleBeep := true;
      InsArcNewMsg(0,153,1);
      exit;
    end;
{$ENDIF}

    //===================================== ������������ ����/������������� ������ �������
    case ID of
{$IFDEF RMDSP}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_RazdeRejim : //-------------------------------------------------------- 1001
      begin //------------------------------------------- ������������ ������ "����������"
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        InsArcNewMsg(DspCommand.Obj,95+$4000,7);//- ���������� ���������� ����� ����������
        color := 7;
        msg := GetShortMsg(1,95,'',color);
        result := false;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_MarshRejim ://----------------------------- ������������ ������ "����������"
      begin
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        InsArcNewMsg(DspCommand.Obj,96+$4000,2); // ���������� ���������� ����� ����������
        color :=  2;
        msg := GetShortMsg(1,96,'',color);
        result := false;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_MaketStrelki : //----------------------- ���������/���������� ������ �������
      begin
        if WorkMode.OtvKom then
        begin //------------------------ ����  ������ �� - ���������� ������������ �������
          ResetCommands;
          InsArcNewMsg(0,283,1); //------------------ "������ ������ ������������� ������"
          ShowShortMsg(283,LastX,LastY,'');
          color := 1;
          msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,color);
          exit;
        end;

        ResetTrace; //-------------------------------------------- �������� ����� ��������
        WorkMode.MarhOtm := false;
        WorkMode.VspStr := false;
        WorkMode.InpOgr := false;

        if maket_strelki_index > 0 then //-------------------- ���� �� ������ ���� �������
        begin //------------------------------------------- ������ ������ ������� � ������
          color := 7;
          msg := GetShortMsg(1,172, maket_strelki_name,color);//"����� � ������ ������� ?"
          DspCommand.Command := CmdMenu_SnatMaketStrelki;
          DspCommand.Obj := maket_strelki_index;
          DspMenu.WC := true;
          InsArcNewMsg(DspCommand.Obj,172+$4000,7);
        end else //-------------------------------------------- ���� �� ������ ������� ���
        if WorkMode.GoMaketSt then  //--------------- ���� ���� ��������� ������� �� �����
        begin //--------------------- ����� ������� ������ ������� ��� ���������� �� �����
          WorkMode.GoMaketSt := false;
          ResetShortMsg;
          exit;
        end else //------------------------------- ���� ���� ��� ������ ��������� �� �����
        begin //----------------------------------- ������� ������� ��� ��������� �� �����
          for i := 1 to High(ObjZav) do //------------------------ ������ �� ���� ��������
          begin  //---------------------- � ��������� �������� ����������� ��������� �����
            if(ObjZav[i].RU = config.ru)and(ObjZav[i].TypeObj = 20) then // ����� �� �����
            begin
              if ObjZav[i].bParam[2] then //--------------------------------- ���� ���� ��
              begin //------------------------------------------- ��������� ������ �������
                WorkMode.GoMaketSt := true;
                InsArcNewMsg(0,8+$4000,7); //---- "������� ������� ��� ��������� �� �����"
                ShowShortMsg(8,LastX,LastY,'');
              end else //----------------------------------------------------- ���� ��� ��
              begin //----------------------------------------- �������� ���� �� ���������
                ResetShortMsg;
                InsArcNewMsg(0,90,1); //-------------- "�� ��������� ���� ������ �������!"
                ShowShortMsg(90,LastX,LastY,'');
                color := 1;
                AddFixMessage(GetShortMsg(1,90,'',color),4,2);
              end;
              exit; //--------- ����� ����� ����������� ��������� ������ � ������ ��������
            end;
          end;
          exit; //- ����� ����� ������� �� ���� �������� ��� �� ��������� ��������� ������
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_OtmenMarsh, //------------------ ���������/���������� ������ ������ ��������
      KeyMenu_InputOgr ,//------------------ ���������/���������� ������ ����� �����������
      KeyMenu_VspPerStrel: //���������/���������� ������ ���������������� �������� �������
      begin
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_EndTrace :
      begin //----------------------------------------------- ����� ������ �������� = 1008
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        if MarhTracert[1].WarCount > 0 then  //---- ���� ���� �������������� ��� ���������
        begin
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount];//�������� ��������������
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1],1);
        end
        else   exit; //--------------------------------------------------- ����� ���������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_EndTraceError :
      begin //--------- ������ ��������������, ��� �������� ����� �������� ������� �������
        DspCommand.Active := true;
        DspCommand.Command := KeyMenu_ClearTrace;
        DspCommand.Obj := 0;
        InsArcNewMsg(0,87,1);
        ShowShortMsg(87,LastX,LastY,'');
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Ready : //------------------------------------------------------------ 1102
      begin //--------------------------------- ��������� ������������� ��������� ��������
        DspMenu.obj := cur_obj;
        case MarhTracert[1].Rod of //---------------------- ������������� �� ���� ��������
          MarshM :    //-------------------------------------------------- ���� ����������
          begin
            InsArcNewMsg(MarhTracert[1].ObjStart,6+$4000,7);//���������� ���������� ����.?
            color := 7;
            TXT := ObjZav[MarhTracert[1].ObjStart].Liter;
            msg := GetShortMsg(1,6, TXT + MarhTracert[1].TailMsg,color);
            DspCommand.Active := true;
            DspCommand.Command := CmdMarsh_Manevr;
            DspCommand.Obj := ID_Obj;
          end;
          MarshP ://-------------------------------------------------------- ���� ��������
          begin
            InsArcNewMsg(MarhTracert[1].ObjStart,7+$4000,2);//"���������� �������� �������?"
            color := 2;
            TXT := ObjZav[MarhTracert[1].ObjStart].Liter;
            msg := GetShortMsg(1,7, TXT + MarhTracert[1].TailMsg,color);
            DspCommand.Active := true;
            DspCommand.Command := CmdMarsh_Poezd;
            DspCommand.Obj := ID_Obj;
          end;
          else exit;
        end;
        DspMenu.WC := true;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_RdyRazdMan :
      begin //------------------------------------- ������ �������� ���������� �����������
        InsArcNewMsg(MarhTracert[1].ObjStart,6+$4000,7);
        color := 2;
        msg := GetShortMsg(1,6, ObjZav[MarhTracert[1].ObjStart].Liter,color );
        DspCommand.Command := ID;
        if ObjZav[ID_Obj].TypeObj = 5 then DspCommand.Obj := ID_Obj
        else DspCommand.Obj := ObjZav[ID_Obj].BaseObject;
        DspMenu.WC := true;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_RdyRazdPzd :
      begin //--------------------------------------- ������ �������� ���������� ���������
        InsArcNewMsg(MarhTracert[1].ObjStart,7+$4000,2);
        color := 2;
        msg := GetShortMsg(1,7, ObjZav[MarhTracert[1].ObjStart].Liter,color);
        DspCommand.Command := ID;
        if ObjZav[ID_Obj].TypeObj = 5 then  DspCommand.Obj := ID_Obj
        else DspCommand.Obj := ObjZav[ID_Obj].BaseObject;
        DspMenu.WC := true;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Povtor  :
      begin //-------------------------- ����� ��������� ����� ��������� ��������� �������
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. ����������?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorMarh  :
      begin //------------------------ ����� ��������� ����� ��������� ���������� ��������
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. ����������?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorOtkryt  :
      begin //------ ����� ��������� ����� ��������� ��������� ������� � ���������� ������
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. ����������?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Razdel :
      begin //----- ����� ��������� ����� ��������� ������� � ���������� ������ ����������
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. ����������?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_QuerySetTrace :
      begin //------------- ������ �� ������ ������� ��������� ������� �� ��������� ������
        SingleBeep2 := true;
        TimeLockCmdDsp := LastTime;
        LockCommandDsp := true; 
				ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].ObjStart,442+$4000,7);//"���������� ������� �� ������ ?"
        color := 7;
        TXT := ObjZav[MarhTracert[1].ObjStart].Liter;
        msg := GetShortMsg(1,442,TXT + MarhTracert[1].TailMsg,color);
        DspCommand.Command := KeyMenu_QuerySetTrace;
        DspCommand.Active := true;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyResetTrace :
      begin //----------------- ��������� ����� ���������� ������ �������� �� ������������
        ShowWarning := true;
        if MarhTracert[1].GonkaStrel and (MarhTracert[1].GonkaList > 0) then
        begin
          InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]+$5000,7);
          msg := MarhTracert[1].Msg[1] + '. �������� ������� �������. ����������?';
        end else
        begin
          InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1],7);
          msg := MarhTracert[1].Msg[1];
        end;
        PutShortMsg(1, LastX, LastY, msg);
        DspMenu.WC := true;
        DspCommand.Command := CmdMarsh_Tracert;
        DspCommand.Active := true;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyWarningTrace : //----------- �������� ������������� ��������� �� ������
      begin //----------------------- ��������� ������������� ��������� �� ������ ��������
        if MarhTracert[1].WarCount > 0 then //------- ���� ���� �������������� ��� �������
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount]+ '. ����������?';
          DspMenu.WC := true;
          DspCommand.Command := CmdMarsh_Tracert;
          DspCommand.Active := true;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyWarningEnd :
      begin //----------------- ��������� ������������� ��������� �� ����� ������ ��������
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount]+ '. ����������?';
          DspMenu.WC := true;
          DspCommand.Command := KeyMenu_EndTrace;
          DspCommand.Active := true;
          DspCommand.Obj := ID_Obj;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyMPerevodPlus :
      begin //----------------------------- ������������� �������� �������� ������� � ����
        //------------------------------------------ "������� �� ������.��������� � ����?"
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,101+$4000,2);
        color := 2;
        msg := GetShortMsg(1,101,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyMPerevodPlus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyMPerevodMinus :
      begin //---------------------------- ������������� �������� �������� ������� � �����
        //----------------------------------------- "������� �� ������.��������� � �����?"
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,102+$4000,7);
        color := 7;
        msg:=GetShortMsg(1,102,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyMPerevodMinus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_AskPerevod :
      begin //------------------------------------------------------------ ������� �������
        if ObjZav[ID_Obj].bParam[1] then
        begin //------------------------------------------------------------------ � �����
          if maket_strelki_index = ObjZav[ID_Obj].BaseObject then
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,102+$4000,7);
            color := 7;
            msg := GetShortMsg(1,102,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
            DspCommand.Command := CmdStr_ReadyMPerevodMinus;
            DspCommand.Obj := ID_Obj;
          end else
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,98+$4000,7);
            color := 7;
            msg := GetShortMsg(1,98,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
            DspCommand.Command := CmdStr_ReadyPerevodMinus;
            DspCommand.Obj := ID_Obj;
          end;
        end else //---------------------------------------------------------------- � ����
        if ObjZav[ID_Obj].bParam[2] then
        begin
          if maket_strelki_index = ObjZav[ID_Obj].BaseObject then
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,101+$4000,2);
            color := 2;
            msg := GetShortMsg(1,101,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
            DspCommand.Command := CmdStr_ReadyMPerevodPlus;
            DspCommand.Obj := ID_Obj;
          end else
          begin
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,97+$4000,2);
            color := 2;
            msg := GetShortMsg(1,97,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
            DspCommand.Command := CmdStr_ReadyPerevodPlus;
            DspCommand.Obj := ID_Obj;
          end;
        end else
        begin //---------------------------------------------------------------- �� ������
          if ObjZav[ID_Obj].bParam[22] or //------------------------ ���� ������ �� �� ���
          (not ObjZav[ID_Obj].bParam[22] and //--------------------- �� ������ �� �� � ...
          not ObjZav[ID_Obj].bParam[23] and //--------- �� ������������ ��� �������� � ...
          ObjZav[ID_Obj].bParam[20]) //----------------------------------- �������� �� ���
          then msg := ' <'
          else msg := '';
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,165+$4000,7);
          color := 7;
          AddDspMenuItem(GetShortMsg(1,165,msg,color), CmdMenu_StrPerevodMinus,ID_Obj);
          if ObjZav[ID_Obj].bParam[23] or
          (not ObjZav[ID_Obj].bParam[22]and
          not ObjZav[ID_Obj].bParam[23]and ObjZav[ID_Obj].bParam[21])
          then msg := ' <'
          else msg := '';
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,164+$4000,2);
          color := 2;
          AddDspMenuItem(GetShortMsg(1,164,msg,color),CmdMenu_StrPerevodPlus,ID_Obj);
        end;
        DspMenu.WC := true;
      end;
 {$ENDIF}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdManevry_ReadyWar :
      begin //--------------------------------- �������� ������������� �������� �� �������
{$IFDEF RMDSP}
        if MarhTracert[1].WarCount > 0 then
        begin
          InsArcNewMsg(MarhTracert[1].WarObject[Marhtracert[1].WarCount],MarhTracert[1].WarIndex[Marhtracert[1].WarCount]+$5000,7);
          msg := MarhTracert[1].Warning[Marhtracert[1].WarCount];
          dec (Marhtracert[1].WarCount);
          DspCommand.Command := CmdManevry_ReadyWar;
          DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ID_Obj,217+$4000,7);
          color := 7;
          msg := GetShortMsg(1,217, ObjZav[ID_Obj].Liter,color);
          DspCommand.Command := CmdMenu_DatRazreshenieManevrov;
          DspCommand.Obj := ID_Obj;
        end;
{$ENDIF}
      end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{$IFDEF RMDSP}
      CmdStr_ReadyPerevodPlus :
      begin //-------------------------------------- ������������� �������� ������� � ����
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,97+$4000,2);
        color := 2;
        msg := GetShortMsg(1,97,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyPerevodPlus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyPerevodMinus :
      begin //------------------------------------- ������������� �������� ������� � �����
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,98+$4000,7);
        color := 7;
        msg := GetShortMsg(1,98,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyPerevodMinus;
        DspCommand.Obj := ID_Obj; //---------------------- ������ ������� ��� ������� � OZ
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodPlus :
      begin //--------------------- ������������� ���������������� �������� ������� � ����
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,99+$4000,2);
        color := 2;
        msg := GetShortMsg(1,99,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyVPerevodPlus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodMinus :
      begin //-------------------- ������������� ���������������� �������� ������� � �����
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,100+$4000,7);
        color := 7;
        msg := GetShortMsg(1,100,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyVPerevodMinus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_Tracert :
      begin //------------------------ IDMenu_Tracert = 34 ����������� �� �������� �������
        DspCommand.Active  := true;
        DspCommand.Command := CmdMarsh_Tracert; // ��������� ������� CmdMarsh_Tracert=1101
        DspCommand.Obj := ID_Obj;
        exit;
      end;
 {$ENDIF}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//******************************************************************************** �������
      IDMenu_Strelka :
      result := CreateDspMenu_Strelka(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//***************************************** ��������� (����������, ����������� � �������)
      IDMenu_SvetoforManevr,
      IDMenu_SvetoforSovmech,
      IDMenu_SvetoforVhodnoy :
      result := CreateDspMenuSvetofor(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//**************************************************** ���������� ������������� ����������
      IDMenu_AutoSvetofor :
      result := CreateDspMenuAvtoSvetofor(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//*********************************************** ���������� ��������� ������� �� 1-�� ���
      IDMenu_1bit :
      result := CreateDspMenu_1bit(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------- ���������� ��������� ������� �� 2-�� ���
      IDMenu_2bit :
      result := CreateDspMenu_2bit(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------- ���������� ��������� ������� � ����������� �� ��������� ����
      IDMenu_VklOtkl_bit1 :
      result := CreateDspMenu_VklOtkl1bit(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------- ���������� ������� �������� ��� �������������� �������� ��������
      IDMenu_PRZD_Zakr_Otkr :
      result := CreateDspMenu_PRZD_Zakr_Otkr(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------- ���������� ������� ������� ��� �������������� ���������� ������ ��������
      IDMenu_Zapr_Razr_Mont:
      result := CreateDspMenu_Zapr_Razr_Mont(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------- ���������� ���� ��� ������ ��������� �������� �� �������� ����
      IDMenu_VydachaPSoglasiya :
      result := CreateDspMenuVydachaPSoglasiya(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_Nadvig : //----------------------���������� ���� ��� ������ "������ �� �����"
      result := CreateDspMenuNadvig(ID,X,Y);

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_Uchastok ://���������� ���� ���������� �������� "������� �� ��� �������������"
      result := CreateDspMenuUchastok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PutPO : //------------------------ ���������� ���� ���������� �������� "����"
      result := CreateDspMenuPutPO(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OPI ://���������� ���� ���������� �������� "���"(���������� ���� �� ��������)
      result := CreateDspMenuOPI(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZaprosPSoglasiya :  //--------- ������ ��������� ����������� �� �������� ����
      result := CreateDspMenuPSoglasiya(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_SmenaNapravleniya : //------------------------------------------- ������ � ��
      begin
        gotomen := false;
        result := CreateDspMenuSmenaNapravleniya(ID,X,Y,gotomen);
{$IFDEF RMDSP}
        if gotomen then
        begin
          MakeMenu(X);
          exit;
        end;
{$ENDIF}
      end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_KSN : //----------------------------- ����������� ��������� ����� �����������
      result := CreateDspMenu_KSN(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PAB : //------------------------------------------ ���������� ���������������
      result := CreateDspMenu_PAB(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ManevrovayaKolonka : //------------- ���������� �������� "���������� �������"
      result := CreateDspMenu_ManevrovayaKolonka(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZamykanieStrelok :  //------------------------------------- ��������� �������
      result := CreateDspMenu_ZamykanieStrelok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RazmykanieStrelok : //------------------------------------ ���������� �������
      result := CreateDspMenu_RazmykanieStrelok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZakrytPereezd :  //------------------------------------------ ������� �������
      result := CreateDspMenu_ZakrytPereezd(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtkrytPereezd : //------------------------------------------- ������� �������
      result := CreateDspMenu_OtkrytPereezd(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_IzvesheniePereezd1, 
      IDMenu_IzvesheniePereezd : //---------------------------------- ��������� �� �������
      result := CreateDspMenu_IzvesheniePereezd(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PoezdnoeOpoveshenie ://----- �������� ���� ���  ������� "�������� ����������"
      result := CreateDspMenu_PoezdnoeOpoveshenie(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZapretMonteram ://--- �������� ���� ��� ���������� �������� "������ ��������"
      result := CreateDspMenu_ZapretMonteram(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtklZapMont:
      result := CreateDspMenu_Otkl_ZapretMonteram(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VykluchenieUKSPS : //--------------------- �������� ���� ��� ���������� �����
      result := CreateDspMenu_VykluchenieUKSPS(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtklUKG ://--------------------------------- �������� ���� ��� ���������� ���
      result := CreateDspMenu_OtklUKG(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VklUKG :
      result := CreateDspMenu_VklUKG(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VspomPriem :
      result := CreateDspMenu_VspomPriem(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VspomOtpravlenie : // �������� ���� ��� ������� "��������������� �����������"
      result := CreateDspMenu_VspomOtpravlenie(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OchistkaStrelok : //------------- �������� ���� ��� ������� "������� �������"
      result := CreateDspMenu_OchistkaStrelok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VkluchenieGRI1 : //-------------------------- ��������� �������� ������� ���1
      result := CreateDspMenu_VkluchenieGRI1(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PutManevrovyi : //---------- ������� ��������� �� ������, ���� ��� ����������
      result := CreateDspMenu_PutManevrovyi(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymPitaniyaLamp : //------------------------- ������� ���� ���������� (���)
      result := CreateDspMenu_RezymPitaniyaLamp(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymLampDen : //---------------------------------- ��������� �������� ������
      result := CreateDspMenu_RezymLampDen(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymLampNoch ://----------------------------------- ��������� ������� ������
      result := CreateDspMenu_RezymLampNoch(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymLampAuto ://--------------------------- ��������� ��������������� ������
      result := CreateDspMenu_RezymLampAuto(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtklZvonkaUKSPS : //--------------------------------- ���������� ������ �����
      result := CreateDspMenu_OtklZvonkaUKSPS(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{$IFNDEF RMDSP}
      IDMenu_GroupDat :
      begin//------------------------------------------- ������ ������� �������� �� ���-��
        DspMenu.obj := cur_obj;
        ID_ViewObj := ID_Obj;
        result := true;
        exit;
      end;
{$ENDIF}
      else
        DspCommand.Command := 0;
        DspCommand.Obj := 0;
        exit;
    end;
{$IFDEF RMDSP}
//mkmnu : //----------------------------------------------------------- ������������ ����
    if DspMenu.Count > 0 then //-------------------------------- ���� ���� ���-�� ��� ����
    begin
      TabloMain.PopupMenuCmd.Items.Clear; //-------------------------- �������� ���� �����
      for i := 1 to DspMenu.Count  do
      TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//----- ����� �� DspMenu
      //i := configRU[config.ru].Tablo_Size.Y - 10;
      GetCursorPos(t0);
      // SetCursorPos(x,i);
      SetCursorPos(t0.x ,t0.Y);
      //TabloMain.PopupMenuCmd.Popup(X, i+3-17*DspMenu.Count);

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
    begin //-------------------------- ������� ��������� ����� ����������� ������� �������
      j := x div configRU[config.ru].MonSize.X + 1; //------------------ ����� ����� �����
      for i := 1 to Length(shortMsg) do
      begin
        if i = j then //------- ���� ��� �� �����, ������� ������������� ������ ����������
        //begin
        if(shortMsg[i] = '') and (msg <> '') then shortMsg[i] := msg;
        //; shortMsgColor[i] := GetColor1(7); end
        //else shortMsg[i] := '';
      end;
    end;
//    if not result then SingleBeep := true;
{$ENDIF}
  except
    {$IFNDEF RMARC}
    reportf('������ [CMenu.CreateDspMenu]');
    {$ENDIF}
    result := true;
  end;
end;

{$IFDEF RMDSP}
//========================================================================================
//------------ �������� ������� ������������ ����������� ���������� �������� ��� ���������
function CheckStartTrace(Index : SmallInt) : string;
var
  color : Integer;
begin
  try
    result := '';
    case ObjZav[Index].TypeObj of
      33 :
      begin //--------------------------------------------- ���� ��� ���������� ������ FR3
        if ObjZav[Index].ObjConstB[1] then //--------------------- ���� �������� ���������
        begin
          if ObjZav[Index].bParam[1]  //----------------------------- ���� ������ = .True.
          then
            result := MsgList[ObjZav[Index].ObjConstI[3]]; //------ �������� �� ����������
        end else
        begin //--------------------------------------------------------- ������ ���������
          if not ObjZav[Index].bParam[1]  //------------------ ��������� ������� = .False.
          then result := MsgList[ObjZav[Index].ObjConstI[2]]; //---- ��������� � ���������
        end;
      end;

      35 :
      begin //-------- ������ � ���������� ��������� ��������������� ������� (�����������)
        if ObjZav[Index].ObjConstB[1] then
        begin //-------------------------------------------------- ���� �������� ���������
          if ObjZav[Index].bParam[1]
          then result := MsgList[ObjZav[Index].ObjConstI[2]]; //------- �������� �� ������
        end else
        begin //--------------------------------------------------------- ������ ���������
          if not ObjZav[Index].bParam[1]
          then result := MsgList[ObjZav[Index].ObjConstI[2]]; //------- �������� �� ������
        end;
      end;

      47 :
      begin //----------------------------------- �������� ��������� ������������ ��������
        color := 1;
        if ObjZav[Index].bParam[1]   //------------------ ���� ���� ��������� ������������
        then result := GetShortMsg(1, 431, ObjZav[Index].Liter,color);//�������� ��������.
      end;
    end;
  except
    reportf('������ [CMenu.CheckStartTrace]');
    result := '#';
  end;
end;

//========================================================================================
//------------ �������� ������� ������������ ����������� ���������� �������� ��� ���������
function CheckAutoON(Index : SmallInt) : Boolean;
begin
try
  result := false;
  if index = 0 then exit;
  if ObjZav[Index].TypeObj <> 47 then exit;
  // �������� ��������� ������������ ��������
  if ObjZav[Index].bParam[1] then result := true;
except
  reportf('������ [CMenu.CheckStartTrace]'); result := false;
end;
end;

//========================================================================================
//----- ��������� ������� ������������� ��������� �������� ���������� ��� �������� �������
function CheckProtag(Index : SmallInt) : Boolean;
var
  o,put : integer;
begin
  try
    result := false;
    o := ObjZav[Index].ObjConstI[17];
    if o < 1 then exit;

    if ObjZav[o].TypeObj <> 42 then exit; //-------------------- ��� ������� �������������
    put :=  ObjZav[o].ObjConstI[7];

    if ObjZav[ObjZav[index].BaseObject].bParam[2]
    then exit; //--------------------------- ����������� ������ �� �������� - ��� ��������

    if ObjZav[o].bParam[1] and //--------------------------- �������� ������� �����  � ...
    ObjZav[o].bParam[2] and //----------------------------------- ��������� �������������
    not (ObjZav[put].bParam[1] or ObjZav[put].bParam[16]) then //--- ����� ���� ���������  
    begin
      if ObjZav[Index].ObjConstB[17] then
      begin //------------------------------------------------- � ������������ �������� ��
        DspCommand.Command := CmdMenu_OtkrytManevrovym;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
      end else
      begin //------------------------------------------------ ��� ����������� �������� ��
        DspCommand.Command := CmdMenu_OtkrytProtjag;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
      end;
      result := true;
    end;
  except
    reportf('������ � [CMenu.CheckProtag]');
    result := false;
  end;
end;

//========================================================================================
//----------------------------------------- �������� ���������� ��������� ������� �� �����
function CheckMaket : Boolean;
var
  i : integer;
begin
  try
    result := false;
    for i := 1 to High(ObjZav) do //------------------------------ ������ �� ���� ��������
    begin
      if (ObjZav[i].RU = config.ru) and //-------------------------- ���� ���� ����� � ...
      (ObjZav[i].TypeObj = 20) then //------------------------- ��� ������ �������� ������
      begin
        if ObjZav[i].bParam[2] then //--------------- �������� ����������� ��������� �����
        result := (maket_strelki_index < 1);
        exit;
      end;
    end;
  except
    reportf('������ ��� �������� ����������� ����� ������ ������� [CMenu.CheckMaket]');
    result := false;
  end;
end;
{$ENDIF}

//========================================================================================
//--------------------------------------- ������� ��������� � ������ ���������� ����������
function LockDirect : Boolean;
begin
  try
     result := true;
{$IFDEF RMDSP}
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin
      InsArcNewMsg(0,76,1); //------------------------------------- "���������� ���������"
      ShowShortMsg(76,LastX,LastY,'');
      exit;
    end;

    if (ID_Obj > 0) and (ID_Obj < 4096) and not WorkMode.OU[ObjZav[ID_Obj].Group] then
    begin
      InsArcNewMsg(0,76,1);  //------------------------------------ "���������� ���������"
      ShowShortMsg(76,LastX,LastY,'');
      exit;
    end;

    if WorkMode.CmdReady then
    begin
      InsArcNewMsg(0,251,1); //-------- "���� ������ �������� ������������.����� �� �����"
      ShowShortMsg(251,LastX,LastY,'');
     end
    else result := false;
{$ENDIF}
  except
    {$IFNDEF RMARC}
    reportf('������ [CMenu.CreateDspMenu.LockDirect]');
    {$ENDIF}
    result := true;
  end;
end;

//========================================================================================
//----------------------------------- ������� ���������� ���� ��� ��� ���������� ���������
//ID  ������������� (IDMenu_SvetoforManevr,IDMenu_SvetoforSovmech, IDMenu_SvetoforVhodnoy)
function CreateDspMenuSvetofor(ID, X, Y : SmallInt): boolean;
{$IFDEF RMDSP}
var
  u1,u2,uo : Boolean;
  TXT : string;
  color : integer;
{$ENDIF}
begin
  DspMenu.obj := cur_obj;
  result := false;
  if ObjZav[ID_Obj].bParam[33] then
  begin
    InsArcNewMsg(ID_Obj,431+$4000,1);//---------------------------" �������� ������������"
    WorkMode.InpOgr := false;  //---------------------------- ���������� ������ � ��������
    ShowShortMsg(431, LastX, LastY, '');
    exit;
  end;

{$IFNDEF RMDSP}
  if ObjZav[ID_Obj].bParam[23] or //-------------- ���� ���� ���������� ���������� ��� ...
  ((ObjZav[ID_Obj].bParam[5] or //------------------------- ���� ������� ��������� ��� ...
  ObjZav[ID_Obj].bParam[15] or //--------------------------------- ���� ������� �� ��� ...
  ObjZav[ID_Obj].bParam[17] or //------------------------------- ���� ������ ����� ��� ...
  ObjZav[ID_Obj].bParam[24] or //-------------------------------- ���� ������� ��� ��� ...
  ObjZav[ID_Obj].bParam[25]) and //-------------------------------- ���� ������� ��� � ...
  not ObjZav[ID_Obj].bParam[20] and //-------- ��� �������� ���������� ������������� � ...
  not WorkMode.GoTracert) then //------------------------------ ��� ���������� �����������
  begin //------------------------------------------------ ����� ������� ��� �������������
    ObjZav[ID_Obj].bParam[23] := false; //-------------------- ����� ���������� ����������
    ObjZav[ID_Obj].bParam[20] := true; //------------------- ���������� ���������� �������
  end;

  ID_ViewObj := ID_Obj;  //------------ ������ ������� ��� ������������ �������� ���������
  result := true;
  exit;
{$ELSE}

  ObjZav[ID_Obj].bParam[34]:=false; //-------- ����� ���������� ������� ��������� ��������

  //:::::::::::::::::::::::::::::::::::::::::::::::::::::: ��������������� ������� :::::::
  if VspPerevod.Active then //------- ���� ������� ��������� ��� ���������������� ��������
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1); //--- "�������� �������� ������� ������ ���. ��������"
    VspPerevod.Active := false; //--- ����� ���������� ��������� ���������������� ��������
    WorkMode.VspStr := false;   //------ ����� ���������� ������ ���������������� ��������
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end;

  //::::::::::::: ����� ������ "����� ��� ��������������� �������" :::::::::::::::::::::::
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1); //----------------------------------- "��� �� �������"
    color := 1;
    msg := GetShortMsg(1,9,'',color);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end;

  if WorkMode.OtvKom then //:::::::::::::::::::::: ���� ������������� ������� ::::::::::::
  begin //------------------- ������ �� - ������������� �������� ����������� ��� ���������
    InsArcNewMsg(ID_Obj,311+$4000,7);  //------------------------------- "������������� ?"
    color := 7;
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,color);
    DspCommand.Command := CmdMarsh_ResetTraceParams; //-------- ������� ������ �����������
    DspCommand.Obj := ID_Obj;
  end else

  begin //::::::::::::::::::::::::::::::::::::: ������� ����� ::::::::::::::::::::::::::::
    if ObjZav[ID_Obj].bParam[23] and //----------------- ���� ���� ���������� ���������� �
    not WorkMode.GoTracert then  //---------------------------- �� ����������� �����������
    begin
      ObjZav[ID_Obj].bParam[23] := false;//--------- ���������� ���������� ��������� �����
      exit;
    end;

    if ObjZav[ID_Obj].bParam[18] then //----------------------------------- ���� �� ��� ��
    begin
      InsArcNewMsg(ID_Obj,232+$4000,1);//------------------ "������ �� ������� ����������"
      WorkMode.GoMaketSt := false; //----------------- ���������� ����� ��������� �� �����
      ShowShortMsg(232,LastX,LastY,ObjZav[ID_Obj].Liter);
      exit;
    end;

    if WorkMode.InpOgr then //------------------------------------------- ���� �����������
    begin
      if ObjZav[ID_Obj].bParam[33] then //--- ���� ������������ �������� ��� ����� �������
      begin
        InsArcNewMsg(ID_Obj,431+$4000,1);//-----------------------" �������� ������������"
        WorkMode.InpOgr := false;  //------------------ ���������� ����� ����� �����������
        ShowShortMsg(431, LastX, LastY, '');
        exit;
      end;

      if ObjZav[ID_Obj].bParam[14] then //-------------- ���� ����������� ��������� � ����
      begin
        InsArcNewMsg(ID_Obj,238+$4000,1);//-------------------- "�������� � ������ ��������"
        WorkMode.InpOgr := false;  //------------------ ���������� ����� ����� �����������
        ShowShortMsg(238, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end;

      //------------------------------------------- �����, ���� ��� ������������ ���������


      //-------------------------------------- ���� ���������� �� ������� � ���� � �������
      if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
      begin
        InsArcNewMsg(ID_Obj,179+$4000,7);//------------------------ "������������� ��������"
        InsArcNewMsg(ID_Obj,180+$4000,7);//----------------------- "�������������� ��������"
        color := 7;
        AddDspMenuItem(GetShortMsg(1,179, '',color),CmdMenu_BlokirovkaSvet,ID_Obj);
        AddDspMenuItem(GetShortMsg(1,180, '',color),CmdMenu_DeblokirovkaSvet,ID_Obj);
      end else
      if ObjZav[ID_Obj].bParam[13] then //----------------------- ���� ������ ������������
      begin
        color := 7;
        InsArcNewMsg(ID_Obj,180+$4000,7); //----------------- "�������������� �������� $?"
        msg := GetShortMsg(1,180, ObjZav[ID_Obj].Liter,color);
        DspCommand.Command := CmdMenu_DeblokirovkaSvet;
        DspCommand.Obj := ID_Obj;
      end else//------------------------------------------------ ���� ������ �� ����������
      begin
        InsArcNewMsg(ID_Obj,179+$4000,7); //------------------ "������������� �������� $?"
        color := 7;
        msg := GetShortMsg(1,179, ObjZav[ID_Obj].Liter,color);
        DspCommand.Command := CmdMenu_BlokirovkaSvet;
        DspCommand.Obj := ID_Obj;
      end;
    end else //------------------------------------------- �����, ���� �� ���� �����������

    if WorkMode.MarhOtm then //-------------------------------------- ���� ������ ��������
    begin
      if ObjZav[ID_Obj].bParam[33] then
      begin //----------------------------------------------- ���� ������ �� ������������
        color := 1;
        msg := GetShortMsg(1,431,ObjZav[ID_Obj].Liter,color);
        if msg <> '' then //------------------------------ ���� ���� ����� ��������� ...
        begin
          PutShortMsg(1,LastX,LastY,msg);  //--- ������ ����� ��������� �� ����� � �����
          exit;
        end;
      end;

      if ObjZav[ID_Obj].ObjConstB[3] and  //------------- ���� ���� ������ ���������� �...
      (ObjZav[ID_Obj].bParam[6] or //--------------------------- ���� �� �� ������� ���...
      ObjZav[ID_Obj].bParam[7]) or //------------------------- ���� ��� ����������� ���...
      (ObjZav[ID_Obj].bParam[1] or //------------------------------------ ���� ��1 ��� ...
      ObjZav[ID_Obj].bParam[2]) then //------------------------------------------ ���� ��2
      begin
        if ObjZav[ID_Obj].bParam[2] then //--------------------------------- ���� ���� ��2
        begin //-------- ���� ������ ������ - ��������� ������� ���������� ������ ��������
          msg := GetSoglOtmeny(ObjZav[ID_Obj].ObjConstI[19]); //- �������� ����� ���������
          if msg <> '' then //------------------------------ ���� ���� ����� ��������� ...
          begin
            PutShortMsg(1,LastX,LastY,msg);  //--- ������ ����� ��������� �� ����� � �����
            exit;
          end;
        end;

        InsArcNewMsg(ID_Obj,175+$4000,7); //-------------- "�������� ���������� ������� ?"
        msg := '';
        case GetIzvestitel(ID_Obj,MarshM) of
          1 :
          begin
            color := 1;
            msg := GetShortMsg(1,329, '',color) + ' '; //"����� �� �������������� �������"
            InsArcNewMsg(ID_Obj,329+$5000,1);
          end;

          2 :
          begin
            color := 1;
            msg := GetShortMsg(1,330, '',color) + ' '; //------------- "����� �� ��������"
            InsArcNewMsg(ID_Obj,330+$5000,1);
          end;

          3 :
          begin
            color := 1;
            msg := GetShortMsg(1,331, '',color) + ' '; //-- "����� �� ������� �����������"
            InsArcNewMsg(ID_Obj,331+$5000,1);
          end;
        end;
        color := 7;
        msg:=msg+GetShortMsg(1,175,'�� '+ObjZav[ID_Obj].Liter,color);//�������� ����������
        DspCommand.Command := CmdMenu_OtmenaManevrovogo;
        DspCommand.Obj := ID_Obj;
      end else

      if ObjZav[ID_Obj].ObjConstB[2] and//������ ����� ����� ������ �������� ��������� �..
      (ObjZav[ID_Obj].bParam[8] or //-------------- ���� ������� ������ �� ������� ��� ...
      ObjZav[ID_Obj].bParam[9]) or //--- ���� ������� �������� ����������� ������� ��� ...
      (ObjZav[ID_Obj].bParam[3] or //--------------------------- ������� ������ �1 ��� ...
      ObjZav[ID_Obj].bParam[4]) then  //-------------------------------- ������� ������ �2
      begin //---------------------------------------------------------- �������� ��������
        if ObjZav[ID_Obj].bParam[4] then //------------------------------- ���� ������� �2
        begin //-------------- ���� ������ ������ - ��������� ������������ ������ ��������
          msg := GetSoglOtmeny(ObjZav[ID_Obj].ObjConstI[16]);// ��������� ������� � ������
          if msg <> '' then
          begin PutShortMsg(1,LastX,LastY,msg); exit; end; //---- ����� ��������� �� �����
        end;
        InsArcNewMsg(ID_Obj,176+$4000,7);//----------------- "�������� �������� ������� ?"
        msg := '';

        case GetIzvestitel(ID_Obj,MarshP) of //------------ �������� ��������� �����������
          1 :
          begin
            color := 1;
            msg := GetShortMsg(1,329, '',color) + ' '; // ����� �� �������������� �������!
            InsArcNewMsg(ID_Obj,329+$5000,1);
          end;

          2 :
          begin
            color := 1;
            msg := GetShortMsg(1,330, '',color) + ' '; //------------------ ����� �� ��������!
            InsArcNewMsg(ID_Obj,330+$5000,1);
          end;

          3 :
          begin
            color := 1;
            msg := GetShortMsg(1,331, '',color) + ' '; //------- ����� �� ������� �����������!
            InsArcNewMsg(ID_Obj,331+$5000,1);
          end;
        end;

        color := 7;
        msg := msg+GetShortMsg(1,176,'�� '+ObjZav[ID_Obj].Liter,color);//���.�����. ������� $?
        DspCommand.Command := CmdMenu_OtmenaPoezdnogo; //������� ������� ������ � ��������
        DspCommand.Obj := ID_Obj;
      end else

      //------------------------------------------------------------------- ������ ��� ���
      if ObjZav[ID_Obj].BaseObject <>0 then //--------------- ���� ���� ����������� ������
      if  not ObjZav[ID_Obj].bParam[14] and //---- ��� ������������ ��������� ������� �...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] then//��� ������������ ��������� ��
      begin //------------------------------------- ������� ��������� ����������� ��������
        if ObjZav[ID_Obj].ObjConstB[2] and //-------- � ������� ���� ������ �������� � ...
        ObjZav[ID_Obj].ObjConstB[3] then //-------------- � ������� ���� ������ ����������
        begin //---------------- ������� ��������� ������ (��������), ��� ��� ������ �����
          InsArcNewMsg(ID_Obj,175+$4000,7); //-------------- �������� ���������� ������� ?
          InsArcNewMsg(ID_Obj,176+$4000,7); //---------------- �������� �������� ������� ?

          color := 1;
          AddDspMenuItem('��� ������ ��������! '+ GetShortMsg(1,175, '',color),
          CmdMenu_OtmenaManevrovogo,ID_Obj);

          color := 1;
          AddDspMenuItem('��� ������ ��������! '+ GetShortMsg(1,176, '',color),
          CmdMenu_OtmenaPoezdnogo,ID_Obj);
        end else

        if ObjZav[ID_Obj].ObjConstB[3] then // � ������� �������� ������ ���������� ������
        begin //------------------------------------------- �������� ���������� (��������)
          InsArcNewMsg(ID_Obj,175+$4000,7);
          color := 7;
          TXT := ObjZav[ID_Obj].Liter;
          msg := '��� ������ ��������! '+ GetShortMsg(1,175,'�� ' + TXT,color);
          DspCommand.Command := CmdMenu_OtmenaManevrovogo;
          DspCommand.Obj := ID_Obj;
        end else
        if ObjZav[ID_Obj].ObjConstB[2] then //--------------------- ������ �������� ������
        begin //--------------------------------------------- �������� �������� (��������)
          InsArcNewMsg(ID_Obj,176+$4000,1);
          color := 1;
          TXT := ObjZav[ID_Obj].Liter;
          msg := '��� ������ ��������! '+ GetShortMsg(1,176,'�� ' + TXT,color);
          DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
          DspCommand.Obj := ID_Obj;
        end
        else  exit; //------------------------------------------ ��� ������� ����� - �����
      end
      else  exit; //------------------------------------ ���� �����-���� ��������� - �����
      //---------------------------------------------------------- ����� ��������� ��� ���
    end else //--------------------------------------------- ����� ������ � ������� ������

    if ObjZav[ID_Obj].bParam[23] or //-------------- ���������� ���������� ������� ��� ...
    ((ObjZav[ID_Obj].bParam[5] or //----------------------------- ������� �������� ��� ...
    ObjZav[ID_Obj].bParam[15] or //------------------------------------ ������� �� ��� ...
    ObjZav[ID_Obj].bParam[17] or //---------------------------------- ������ ����� ��� ...
    ObjZav[ID_Obj].bParam[24] or //----------------------------------- ������� ��� ��� ...
    ObjZav[ID_Obj].bParam[25] or //----------------------------------- ������� ��� ��� ...
    ObjZav[ID_Obj].bParam[26]) and //------------------------------------ ������� �� � ...
    not ObjZav[ID_Obj].bParam[20] and //--------------- ��� ���������� ������������� � ...
    not WorkMode.GoTracert) then   //-----------------------�� ����������� ����������� ...
    begin //------------------------------------------ ����� ������� ��� ������������� ...
      ObjZav[ID_Obj].bParam[23] := false; //----------------- ������ ���������� ����������
      ObjZav[ID_Obj].bParam[20] := true; //----------- ���������� ���������� �������������
      exit;
    end else

    if not ObjZav[ID_Obj].bParam[31] then //-------------------------- ���� ��� ����������
    begin //-------------------------------------------------- �� ���� ��� ������ � ������
      InsArcNewMsg(ID_Obj,310+$4000,1); //- "����������� ���������� � ��������� ���������"
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowShortMsg(310, LastX, LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else

    if ObjZav[ID_Obj].bParam[13] and not WorkMode.GoTracert then //- �������� ������������
    begin
      InsArcNewMsg(ID_Obj,123+$4000,1);//----------------------- "�������� $ ������������"
      ShowShortMsg(123,LastX,LastY,ObjZav[ID_Obj].Liter);
      color := 1;
      msg := GetShortMsg(1,123, ObjZav[ID_Obj].Liter,color);
//      SingleBeep := true;
      exit;
    end else
    if CheckAutoON(ObjZav[ID_Obj].ObjConstI[28]) then //-- /��������� ��������� ���������.
    begin
      InsArcNewMsg(ID_Obj,431+$4000,1);//------------------------- "�������� ������������"
      ShowShortMsg(431,LastX,LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.MarhUpr then //------------------------------ ����� ����������� ����������
    begin
      if CheckMaket then  //----------------------- ���� ����� ���������� �� �������� ����
      begin //--------------- ����� ���������� �� ��������� - ����������� ���������� �����
        InsArcNewMsg(ID_Obj,344+$4000,1);
        ShowShortMsg(344,LastX,LastY,ObjZav[ID_Obj].Liter);
        color := 1;
        msg := GetShortMsg(1,344, ObjZav[ID_Obj].Liter,color);
//        SingleBeep := true;
        ShowWarning := true;
        exit;
      end else

      if WorkMode.GoTracert then //----------------------------- ���� ����������� ��������
      begin //-------------------------------------------------- ����� ������������� �����
        //---------- ���� ������ ����� �������� �� ������������� ���� ����������� ��������
        if ((MarhTracert[1].Rod = MarshP) and( ObjZav[ID_Obj].ObjConstB[2] = false)) or
        ((MarhTracert[1].Rod = MarshM) and( ObjZav[ID_Obj].ObjConstB[3] = false)) then
        begin
          ShowShortMsg(87,LastX,LastY,ObjZav[ID_Obj].Liter);
          msg := GetShortMsg(1,87, ObjZav[ID_Obj].Liter,1);
          ShowWarning := true;
        end else
        begin
          DspCommand.Active  := true;
          DspCommand.Command := CmdMarsh_Tracert;
          DspCommand.Obj := ID_Obj;
        end;
        exit;
      end else

      if CheckProtag(ID_Obj) then
      begin //-- ������� ������ ��� �������� (������������� ��������� �������� ����������)
        InsArcNewMsg(ID_Obj,416+$4000,7); //--- ������� ������ $ ��� ������������ �������?
        msg := GetShortMsg(1,416, ObjZav[ID_Obj].Liter,7);
      end else
      begin //------------------------------------ ��������� ������������ �������� �������
        if ObjZav[ID_Obj].bParam[2] or //------------------------------------ ���� ��2 ���
        ObjZav[ID_Obj].bParam[4] then //------------------------------------------ ���� �2
        begin
          InsArcNewMsg(ID_Obj,230+$4000,7);//------------------------- "������ $ ��� ������"
          ShowShortMsg(230,LastX,LastY,ObjZav[ID_Obj].Liter);
          msg := GetShortMsg(1,230, ObjZav[ID_Obj].Liter,7);
          exit;
        end else

        if ObjZav[ID_Obj].bParam[1] or //------------------------------------ ���� ��1 ���
        ObjZav[ID_Obj].bParam[3] then //------------------------------------------ ���� �1
        begin
          InsArcNewMsg(ID_Obj,402+$4000,1);//-- "������� ������� ����.������� �� ��������"
          ShowShortMsg(402,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end else

        if ObjZav[ID_Obj].bParam[6] or //---------------------- ���� �� �� ������� ��� ...
        ObjZav[ID_Obj].bParam[7] then //---------------------------------- ����������� ���
        begin
          if ObjZav[ID_Obj].bParam[11] then //--- �������� ��������� ��������� �����������
          begin
            //---------------- ��������� ������� ������������ ������� ����������� ��������
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then //---------- ���� ���� ������� ��� ��
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[18] > 0 then //------- ���� ���� ������� ��� ��(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //-------------------------- ������ ������� ������� ����������� ��������
              InsArcNewMsg(ID_Obj,177+$4000,7);//-------- "�������� ������� ���������� $?"
              msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorManevrMarsh;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //------------- ������� ��, ������ ������ - ��������� �������� �����������
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[18] > 0 then
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              InsArcNewMsg(ID_Obj,177+$4000,7); //----------- �������� ������� ���������� $?
              msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorManevrovogo;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end else
        if ObjZav[ID_Obj].bParam[8] or //------------------ ���� ���� � �� ������� ��� ...
        ObjZav[ID_Obj].bParam[9] then //----------------- �������� ��� ����������� �������
        begin
          if ObjZav[ID_Obj].bParam[11] then //--- ���� ����������� ������ ������� ��������
          begin
            //------------------ ��������� ������� ������������ ������� ��������� ��������
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then //----------- ���� ���� ������� ��� �
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //-- ��������� �������
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then //-------- ���� ���� ������� ��� �(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //-- ��������� �������
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //---------------------------- ������ ������� ������� ��������� ��������
              InsArcNewMsg(ID_Obj,178+$4000,2);//------------ �������� ������� �������� $?
              msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorPoezdMarsh;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //---------------- ������� �, ������ ������ - ��������� �������� ���������
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then  //- ���� ���� ������� 1 ��� ��������
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]);//- ���� ���� ������� 2
              u2 := msg = '';
            end
            else u2 := false;
            msg := '';
            if u1 or u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              InsArcNewMsg(ID_Obj,178+$4000,2); //------------- �������� ������� �������� $?
              msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorPoezdnogo;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end else
        begin
          if (ObjZav[ID_Obj].bParam[14] or //���� ���� ����������� ��������� ��� � ��� ...
          (ObjZav[ID_Obj].BaseObject > 0)) and not ObjZav[ID_Obj].bParam[6]
          and not ObjZav[ID_Obj].bParam[8]
          then //---------------------------------------- ���� ����������� ������ �� � ...
          begin
            TXT := ObjZav[ObjZav[ID_Obj].BaseObject].Liter;
            if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14]
            then TXT := ' ���������� ������� ������� ' + TXT else//�����.�����. �� ��� ...
            if  not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1]
            then TXT := ' ����� ������� ' + TXT else  //------------- ��������� �� ��� ...
            if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[2]
            then TXT := ' ������� ������� ' + TXT else //--- �������� ��������� �� ��� ...
            if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[7]
            then TXT := ' ���������� ������� ������� ' + TXT else//����.�����. ������� ���
            if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[8]
            then TXT := ' ������� ������� � ������ ������ ' + TXT;//����.�����.�����������
            if TXT = ObjZav[ObjZav[ID_Obj].BaseObject].Liter then TXT := '';
          end;
          if TXT <> '' then //-------------- ���� ��������� ����������� �������� �� ��-���
          begin
            InsArcNewMsg(ID_Obj,328+$4000,1);  //---- ������ ���������� ������� �� �������
            msg := GetShortMsg(1,328, ObjZav[ID_Obj].Liter,1) + ',' + TXT;
            //ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
            exit;
          end else
          if ObjZav[ID_Obj].ObjConstB[2] and //------------ ���� ����� ���� ������ � � ...
          ObjZav[ID_Obj].ObjConstB[3] then //------------------------- ����� ���� ������ �
          begin //--------------------------------------------- ������� ��������� ��������
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then  //---------- ���� ���� ������� ��� �
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //-- ��������� �������
              u1 := msg = '';
            end else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then  //------ ����  ���� ������� ��� �(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //-- ��������� �������
              u2 := msg = '';
            end else u2 := false;

            uo := u1 or u2;
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then //--------- ����  ���� ������� ��� ��
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); //-- ��������� �������
              u1 := msg = '';
            end  else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[18] > 0 then //------ ����  ���� ������� ��� ��(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); //-- ��������� �������
              u2 := msg = '';
            end else u2 := false;

            if uo and (u1 or u2) then
            begin
              InsArcNewMsg(ID_Obj,181+$4000,7);  //----------------- ���������� ������� $?
              InsArcNewMsg(ID_Obj,182+$4000,2); //-------------------- �������� ������� $?
              AddDspMenuItem(GetShortMsg(1,181, '',7), CmdMenu_BeginMarshManevr,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,182, '',2), CmdMenu_BeginMarshPoezd,ID_Obj);
            end else

            if uo then
            begin //------------------------------------------------ ������������ ��������
              InsArcNewMsg(ID_Obj,182+$4000,2); //---------------------- �������� ������� $?
              msg := GetShortMsg(1,182, '�� ' + ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshPoezd;
              DspCommand.Obj := ID_Obj;
            end else

            if u1 or u2 then
            begin //---------------------------------------------- ������������ ����������
              InsArcNewMsg(ID_Obj,181+$4000,7); //-------------------- ���������� ������� $?
              msg := GetShortMsg(1,181, '�� ' + ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshManevr;
              DspCommand.Obj := ID_Obj;
            end else
            begin //- ����� �� ����������� ��-�� ���������� ���������� ��������� ���������
              InsArcNewMsg(ID_Obj,328+$4000,1);  //-- ������ ���������� ������� �� �������
              ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
              exit;
            end;
          end else
          if ObjZav[ID_Obj].ObjConstB[2] then  //--------- �� ������� ���� �������� ������
          begin //--------------------------------------- ������ ������ ��������� ��������
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then //���� ������� 1 ��� ������ ���������
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);
              u1 := msg = '';
            end
            else u1 := true; //------------------------ ��� ������� 1 ��� ������ ���������

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then //���� ������� 2 ��� ������ ���������
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]);
              u2 := msg = '';
            end
            else u2 := true;

            if u1 and u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              InsArcNewMsg(ID_Obj,182+$4000,2); //-------------------- �������� ������� $?
              msg := GetShortMsg(1,182, '�� ' + ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshPoezd;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          if ObjZav[ID_Obj].ObjConstB[3] then//���� � ������� ���������� ������ ����������
          begin //------------------------------------- ������ ������ ����������� ��������
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then //-- ���� ���� ������� 1 ��� ��������
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);
              u1 := msg = '';
            end else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[18] > 0 then //-- ���� ���� ������� 2 ��� ��������
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //------------------------------------ ������ ������� ������ �����������
              InsArcNewMsg(ID_Obj,181+$4000,2);  //----------------- ���������� ������� $?
              msg := GetShortMsg(1,181, '�� ' + ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshManevr;
              DspCommand.Obj := ID_Obj;
              result := true;
            end else
            begin //------------------------------------------ ����� �� ������ �����������
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end;
      end;
    end else
    begin //------------------------------------------------- ����� ����������� ����������
      if ObjZav[ID_Obj].bParam[2] or ObjZav[ID_Obj].bParam[4] then //----- ���� ��2 ��� �2
      begin //-------------------------------------------------------------- ������ ������
        InsArcNewMsg(ID_Obj,230+$4000,1); //-------------------------- ������ $ ��� ������
        ShowShortMsg(230,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[3] then //--- ���� ��1 ��� �1
      begin //------------------------------------------------- ������ �� �������� �������
        InsArcNewMsg(ID_Obj,402+$4000,1); // ������� ������� �� ����.������� $ �� ��������
        ShowShortMsg(402,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if CheckProtag(ID_Obj) then
      begin  //--------- ������� ������ ��� �������� (������������� ��������� ����������)?
        InsArcNewMsg(ID_Obj,416+$4000,7);
        msg := GetShortMsg(1,416, ObjZav[ID_Obj].Liter,7);
      end else
      if ObjZav[ID_Obj].bParam[6] or   //-------------------------- ���� �� �� FR3 ��� ...
      ObjZav[ID_Obj].bParam[7] then //------------------------------------ ��� �����������
      begin
        if ObjZav[ID_Obj].bParam[11] then //------------ ���� ��������� ����������� ������
        begin //-------------- ��������� ������� ������������ ������� ����������� ��������
          if Marhtracert[1].LockPovtor then //------------------- ���� ������������ ������
          begin
            ResetTrace;
            exit;
          end;
          if ObjZav[ID_Obj].ObjConstI[17] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);
            u1 := msg = '';
          end else u1 := true;

          if ObjZav[ID_Obj].ObjConstI[18] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);
            u2 := msg = '';
          end  else u2 := false;

          if u1 or u2 then
          begin //---------------------------- ������ ������� ������� ����������� ��������
            InsArcNewMsg(ID_Obj,173+$4000,7);
            msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_PovtorOtkrytManevr;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //--------------- ������� ��, ������ ������ - ��������� �������� �����������
          if ObjZav[ID_Obj].ObjConstI[17] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);
            u1 := msg = '';
          end else u1 := true;

          if ObjZav[ID_Obj].ObjConstI[18] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);
            u2 := msg = '';
          end  else u2 := false;

          if u1 or u2 then
          begin //-------------------------------------- ������ ������� ������ �����������
            InsArcNewMsg(ID_Obj,177+$4000,7);
            msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter,7);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorManevrovogo;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZav[ID_Obj].bParam[8] or  //---------------------------- ���� � �� FR3 ��� ...
      ObjZav[ID_Obj].bParam[9] then //------------------------------------ ��� �����������
      begin
        if ObjZav[ID_Obj].bParam[11] then  //------------ ���� �������� ����������� ������
        begin  //--------------- ��������� ������� ������������ ������� ��������� ��������
          if Marhtracert[1].LockPovtor then //------------------- ���� ������ ������������
          begin
            ResetTrace;
            exit;
          end;

          if ObjZav[ID_Obj].ObjConstI[14] > 0 then    //-------- ���� ���� ������� 1 ��� �
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //---- ��������� �������
            u1 := msg = '';
          end else u1 := true;

          if ObjZav[ID_Obj].ObjConstI[15] > 0 then    //-------- ���� ���� ������� 2 ��� �
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //---- ��������� �������
            u2 := msg = '';
          end else u2 := false;

          if u1 or u2 then
          begin //------------------------------ ������ ������� ������� ��������� ��������
            InsArcNewMsg(ID_Obj,174+$4000,2); //---------------------- ������� �������� $?
            msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter,2);
            DspCommand.Command := CmdMenu_PovtorOtkrytPoezd;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //------------------ ������� �, ������ ������ - ��������� �������� ���������
          if ObjZav[ID_Obj].ObjConstI[14] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);
            u1 := msg = '';
          end  else u1 := true;

          if ObjZav[ID_Obj].ObjConstI[15] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]);
            u2 := msg = '';
          end else u2 := false;

          if u1 or u2 then
          begin //-------------------------------------- ������ ������� ������ �����������
            InsArcNewMsg(ID_Obj,178+$4000,2);   //----------- �������� ������� �������� $?
            msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter,2);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorPoezdnogo;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZav[ID_Obj].bParam[14] or // ���� ���� ����������� ��������� �� �� ��� ��� ...
      ((ObjZav[ID_Obj].BaseObject <> 0) and  //------------- ���� ����������� ������ � ...
      (ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] or //-- �� ���������� �������� ��� ...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[2] or  //-- �� �������� ������� ��� ...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[7] or  //- �����. ��������� FR3 ��� ...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[8])) then//�����. ��������� �����������
      begin //------------------- ��������������� ��������� ����������� �������� �� ��-���
        InsArcNewMsg(ID_Obj,328+$4000,1); //--------- ������ ���������� ������� �� �������
        msg := GetShortMsg(1,328, ObjZav[ID_Obj].Liter,1);
        ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else

      if ObjZav[ID_Obj].ObjConstB[2] and //------- ���� ������ ����� ������ �������� � ...
      ObjZav[ID_Obj].ObjConstB[3] then //------------------ ������ ����� ������ ����������
      begin //------------------------------------------------- ������� ��������� ��������
        if ObjZav[ID_Obj].ObjConstI[14] > 0 then //--- ���� � ������� ���� ������� 1 ��� �
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);//------- ��������� �������
          u1 := msg = ''; //---------------- ������� ����, �� ��� �� ������ ? ��� ������ ?
        end
        else u1 := true; //---------------------------- ������� ���, ������� ��� �� ������

        if ObjZav[ID_Obj].ObjConstI[15] > 0 then //--- ���� � ������� ���� ������� 2 ��� �
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]);//------- ��������� �������
          u2 := msg = ''; //---------------- ������� ����, �� ��� �� ������ ? ��� ������ ?
        end
        else u2 := false; //--------------------------- ������� ���, ������� ��� �� ������

        uo := u1 or u2;  //---------------------------------- �������� ������� 1 � 2 ��� �

        if ObjZav[ID_Obj].ObjConstI[17] > 0 then   //---------- ���� ���� ������� 1 ��� ��
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);//-- ��������� ������� 1 ��
          u1 := msg = ''; //---------------- ������� ����, �� ��� �� ������ ? ��� ������ ?
        end else u1 := true;

        if ObjZav[ID_Obj].ObjConstI[18] > 0 then   //---------- ���� ���� ������� 2 ��� ��
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);//�������� ������� 2 ��� ��
          u2 := msg = '';
        end  else u2 := false;

        if uo and (u1 or u2) then //���������� ������� (1 ��� 2) ���  � � (1 ��� 2) ��� ��
        begin  //----------------- ���� ��� �������: ��� � � ��� ��, ������� ���� ��������
          InsArcNewMsg(ID_Obj,173+$4000,7);  //--------------------- ������� ���������� $?
          InsArcNewMsg(ID_Obj,174+$4000,2);   //---------------------- ������� �������� $?
          AddDspMenuItem(GetShortMsg(1,173, '',7), CmdMenu_OtkrytManevrovym,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,174, '',2), CmdMenu_OtkrytPoezdnym,ID_Obj);
        end else
        if uo then //------------------------------------------- ���� ������� ������ ��� �
        begin
          InsArcNewMsg(ID_Obj,174+$4000,2);  //----------------------- ������� �������� $?
          msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter,2);
          DspCommand.Command := CmdMenu_OtkrytPoezdnym;
          DspCommand.Obj := ID_Obj;
        end else
        if u1 or u2 then //------------------------------------ ���� ������� ������ ��� ��
        begin
          InsArcNewMsg(ID_Obj,173+$4000,7);//----------------------- ������� ���������� $?
          msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtkrytManevrovym;
          DspCommand.Obj := ID_Obj;
        end else
        begin //-------------------- ����� ��-�� ���������� ���������� ��������� ���������
          InsArcNewMsg(ID_Obj,328+$4000,1); //------- ������ ���������� ������� �� �������
          ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end else

      if ObjZav[ID_Obj].ObjConstB[2] then  //--------- ���� � ������� ���� �������� ������
      begin //--------------------------------------------------- ������ �������� ��������
        if ObjZav[ID_Obj].ObjConstI[14] > 0 then //--- ���� � ������� ���� ������� 1 ��� �
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //�������� ������� 1 ��� �
          u1 := msg = '';
        end else u1 := true;

        if ObjZav[ID_Obj].ObjConstI[15] > 0 then //--- ���� � ������� ���� ������� 2 ��� �
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //�������� ������� 2 ��� �
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- ������ ������� ������ �����������
          InsArcNewMsg(ID_Obj,174+$4000,2); //---------------------- "������� �������� $?"
          msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter,2);
          DspCommand.Command := CmdMenu_OtkrytPoezdnym;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- ����� �� ������ �����������
          PutShortMsg(1,LastX,LastY,msg);
          exit;
        end;
      end else

      if ObjZav[ID_Obj].ObjConstB[3] then   //------ ���� � ������� ���� ������ ����������
      begin //------------------------------------------------- ������ �������� ����������
        if ObjZav[ID_Obj].ObjConstI[17] > 0 then //------------ ���� ���� ������� 1 ��� ��
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);  //------ �������� �������
          u1 := msg = '';
        end else u1 := true;

        if ObjZav[ID_Obj].ObjConstI[18] > 0 then //------------ ���� ���� ������� 2 ��� ��
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);  //------ �������� �������
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- ������ ������� ������ �����������
          InsArcNewMsg(ID_Obj,173+$4000,7); //-------------------- "������� ���������� $?"
          msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtkrytManevrovym;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- ����� �� ������ �����������
          PutShortMsg(1,LastX,LastY,msg);
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
function CreateDspMenuAvtoSvetofor(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- ���� ����� ������ � ������� ��� ��
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- ���� ����� ��������� �������, �� �������� �����
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- ���� ����� ���������� ������ ��������
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ ���� �������� ������������
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- ������ ������ "��������� ������������ ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else //----------------------------------------------- ���� ������������ ���������
    begin
      InsArcNewMsg(ID_Obj,408+$4000,1); //---------- ������ ����� "������������ ���������"
      msg := GetShortMsg(1,408, ObjZav[ID_Obj].Liter,7);
      ShowShortMsg(408,LastX,LastY,'');
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//--------- ������ ������ "��������� ������������?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------- �������� ������������
      InsArcNewMsg(ID_Obj,419+$4000,7);//---------- ������ ������ "�������� ������������?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,419, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshVkl;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//---------------------------------  ������� ���������� ���� ��� ��� ���������� ��� ���� 1
function CreateDspMenu_1bit(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "������ ������ ������������� ������"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "�������� �������� ������� ������ ���. ��������"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- ���� ����� ������ � ������� ��� ��
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1);  //---------------------------------- "��� �� �������"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- ���� ����� ��������� �������, �� �������� �����
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- ���� ����� ���������� ������ ��������
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ ���� �������� ������������
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- ������ ������ "��������� ������������ ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else //----------------------------------------------- ���� ������������ ���������
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[3]+$4000,1);// ������ ����� "���������"
      ShowShortMsg(408,LastX,LastY,'');
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin
      if ObjZav[ID_Obj].ObjConstI[5] > 0 then
      begin
        InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[5]+$4000,7);//������ ������ ���������?
        WorkMode.MarhOtm := false;
        msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
        PutShortMsg(7,LastX,LastY,msg);
        DspCommand.Command := CmdMenu_OtklBit1;
        DspCommand.Obj := ID_Obj;
      end else
      begin
        InsArcNewMsg(ID_Obj,572,1); //------------  ������ ��������� � ��������� ���������
        msg := GetShortMsg(1,572, '',1);
        PutShortMsg(1,LastX,LastY,msg);
        DspMenu.WC := false;
        DspCommand.Command := 0;
        DspCommand.Obj := 0;
        exit;
      end;
    end else
    begin //-------------------------------------------------------------- �������� ���-��
      if ObjZav[ID_Obj].ObjConstI[4] > 0 then
      begin
        InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[4]+$4000,7);//������ ������ ��������?
        msg := MsgList[ObjZav[ID_Obj].ObjConstI[4]];
        WorkMode.MarhOtm := false;
        DspCommand.Command := CmdMenu_VklBit1;
        DspCommand.Obj := ID_Obj;
      end else
      begin
        InsArcNewMsg(ID_Obj,572,1); //------------  ������ ��������� � ��������� ���������
        msg := GetShortMsg(1,572, '',1);
        PutShortMsg(1,LastX,LastY,msg);
        DspMenu.WC := false;
        DspCommand.Command := 0;
        DspCommand.Obj := 0;
        exit;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
function CreateDspMenu_VklOtkl1bit(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "������ ������ ������������� ������"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "�������� �������� ������� ������ ���. ��������"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- ���� ����� ������ � ������� ��� ��
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1);  //---------------------------------- "��� �� �������"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- ���� ����� ��������� �������, �� �������� �����
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- ���� ����� ���������� ������ ��������
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ ���� �������� ������������
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- ������ ������ "��������� ������������ ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else //----------------------------------------------- ���� ������������ ���������
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[3]+$4000,1);//������ ����� "���������"
      ShowShortMsg(408,LastX,LastY,'');
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[5]+$4000,7);//������ ������ ������ ����
      WorkMode.MarhOtm := false;
      msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
      DspCommand.Command := CmdMenu_VklBit1_2;
      DspCommand.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------------- �������� ���-��
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[4]+$4000,7);//������ ������ � ���������
      msg := MsgList[ObjZav[ID_Obj].ObjConstI[4]];
      WorkMode.MarhOtm := false;
      DspCommand.Command := CmdMenu_VklBit1_1;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
function CreateDspMenu_2bit(ID,X,Y : SmallInt): boolean;
var
  razresh : integer;
begin
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}

  if ObjZav[ID_Obj].BaseObject <> 0 then
  begin
    razresh := ObjZav[ID_Obj].BaseObject;
    if not ObjZav[razresh].bParam[1] then
    begin
      InsArcNewMsg(razresh,543+$4000,1);  //--------------- ������� ������������� ��������
      msg := GetShortMsg(1,543, ObjZav[razresh].Liter,1);
      exit;
    end;
  end;

  DspMenu.obj := cur_obj;

  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "������ ������ ������������� ������"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "�������� �������� ������� ������ ���. ��������"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- ���� ����� ������ � ������� ��� ��
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1);  //---------------------------------- "��� �� �������"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- ���� ����� ��������� �������, �� �������� �����
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- ���� ����� ���������� ������ ��������
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ ���� �������� ������������
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- ������ ������ "��������� ������������ ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
      result := true;
    end else //----------------------------------------------- ���� ������������ ���������
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[3]+$4000,1);// ������ ����� "���������"
      ShowShortMsg(408,LastX,LastY,'');//------------------------ ������������ $ ���������
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[5]+$4000,7);// ������ ������ ���������?
      WorkMode.MarhOtm := false;
      msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
      DspCommand.Command := CmdMenu_OtklBit2;
      DspCommand.Obj := ID_Obj;
      result := true;
    end else
    begin //-------------------------------------------------------------- �������� ���-��
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[4]+$4000,7);//������ ������ �������� ?
      msg := MsgList[ObjZav[ID_Obj].ObjConstI[4]];
      WorkMode.MarhOtm := false;
      DspCommand.Command := CmdMenu_VklBit2;
      DspCommand.Obj := ID_Obj;
      result := true;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------- ���������� ���� ��� ������� ��� �������������� ���������� ������ ��������
function CreateDspMenu_Zapr_Razr_Mont(ID,X,Y : SmallInt): boolean;
var
  TXT : string;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end;

  if WorkMode.OtvKom and not ObjZav[ID_Obj].bParam[1] then //-------- ��� ������� ��������
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "������ ������ ������������� ������"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end;

  if not WorkMode.OtvKom and (not ObjZav[ID_Obj].bParam[1])then //��� �������,�� ������ ��
  begin
    InsArcNewMsg(ID_Obj,199+$4000,7);
    msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_DatZapretMonteram;
    DspCommand.Obj := ID_Obj;
  end else  //------------------------------------------------------ ���� ������, ����� ��
  begin
    if WorkMode.OtvKom then
    begin //----------------------------------------- ������ ������ ������������� ������
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,528+$4000,7);
        msg := GetShortMsg(1,528, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsArcNewMsg(ID_Obj,527+$4000,7);
        msg := GetShortMsg(1,527, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands;
      ShowShortMsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;


//========================================================================================
//---------------------- ���������� ���� ��� �������� ��� �������������� �������� ��������
function CreateDspMenu_PRZD_Zakr_Otkr(ID,X,Y : SmallInt): boolean;
var
  TXT : string;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end;

  if WorkMode.OtvKom and not ObjZav[ID_Obj].bParam[12] and not ObjZav[ID_Obj].bParam[13] then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "������ ������ ������������� ������"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end;

  if not WorkMode.OtvKom and (not ObjZav[ID_Obj].bParam[12] or
  not ObjZav[ID_Obj].bParam[13]) then //-------------------- ������ ������� � �� ������ ��
  begin
    InsArcNewMsg(ID_Obj,192+$4000,7);
    msg := GetShortMsg(1,192, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_ZakrytPereezd;
    DspCommand.Obj := ID_Obj;
  end else  //-------------------------------------------------- ������� ������, ����� ��
  begin
    if WorkMode.OtvKom then
    begin //----------------------------------------- ������ ������ ������������� ������
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,194+$4000,7);
        msg := GetShortMsg(1,194, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsArcNewMsg(ID_Obj,193+$4000,7);
        msg := GetShortMsg(1,193, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands;
      ShowShortMsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------- ���������� ���� ��� ������ ��������� �������� �� �������� ����
function CreateDspMenuVydachaPSoglasiya(ID,X,Y : SmallInt): boolean;
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
    InsArcNewMsg(ObjZav[i].BaseObject,311+$4000,7);  //------------------ ������������� $?
    msg := GetShortMsg(1,311, ObjZav[ObjZav[i].BaseObject].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ObjZav[i].BaseObject;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "�������� �������� ������� ������ ���. ��������"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.InpOgr then exit //-------------------------------------- ���� �����������
    else
    if ObjZav[ObjZav[i].BaseObject].bParam[18] then
    begin //-------------------------------------------------------- �� ������� ����������
      InsArcNewMsg(ObjZav[i].BaseObject,232+$4000,1); //--- ������ $ �� ������� ����������
      WorkMode.GoMaketSt := false;
      ShowShortMsg(232,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
      exit;
    end else
    if WorkMode.MarhOtm then
    begin //----------------------- ������ ��������� ��� ���� ������� ���������� ���������
      if ObjZav[ObjZav[i].BaseObject].bParam[8] or
      ObjZav[ObjZav[i].BaseObject].bParam[9] or
      ObjZav[ObjZav[i].BaseObject].bParam[3] or
      ObjZav[ObjZav[i].BaseObject].bParam[4] then
      begin
        if ObjZav[ObjZav[i].BaseObject].bParam[3] or
        ObjZav[ObjZav[i].BaseObject].bParam[4] then
        begin //----------------------------------------- �������� ��������, ������ ������
          if ObjZav[i].UpdateObject > 0 then
          begin //------------------------------------------------------ ������ ����� ����
            if ObjZav[ObjZav[i].UpdateObject].bParam[2] and
            ObjZav[ObjZav[i].UpdateObject].bParam[3] then
            begin //------------------------ ��� ��������� �� ��������� ���� - ���� ������
              InsArcNewMsg(ObjZav[i].BaseObject,184+$4000,7);//�������� ����.�����.������?
              msg := GetShortMsg(1,184, '�� ' + ObjZav[ObjZav[i].BaseObject].Liter,7);
              DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
              DspCommand.Obj := ObjZav[i].BaseObject;
            end else
            begin
              InsArcNewMsg(ObjZav[i].BaseObject,254+$4000,1);//------ ������� ������� �� $
              ShowShortMsg(254,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
            end;
          end else
          begin //------------------------------------------ ������ �� ���������� � ������
            if ObjZav[i].bParam[2] then
            begin //------------------------------------------- ������� ������� �� �������
              InsArcNewMsg(ID_Obj,254+$4000,1);
              ShowShortMsg(254,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
              exit;
            end else
            begin //---------------------------------------- �� ������� ������� �� �������
              InsArcNewMsg(ObjZav[i].BaseObject,184+$4000,1);
              msg := GetShortMsg(1,184, '�� ' + ObjZav[ObjZav[i].BaseObject].Liter,1);
              DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
              DspCommand.Obj := ObjZav[i].BaseObject;
            end;
          end;
        end else
        begin //������ �� ��������������� - ������ ������� ��� �������� ��������� ��������
          InsArcNewMsg(ObjZav[i].BaseObject,184+$4000,7); //- �������� ����.�����.������?
          msg := GetShortMsg(1,184, '�� ' + ObjZav[ObjZav[i].BaseObject].Liter,7);
          DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
          DspCommand.Obj := ObjZav[i].BaseObject;
        end;
      end;
    end else
    if ObjZav[ObjZav[i].BaseObject].bParam[13] and not WorkMode.GoTracert then
    begin //-------------------------------------------------------- �������� ������������
      InsArcNewMsg(ObjZav[i].BaseObject,123+$4000,1);
      ShowShortMsg(123,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
      exit;
    end else
    if WorkMode.MarhUpr then
    begin //------------------------------------------------- ����� ����������� ����������
      if CheckMaket then
      begin //--------------- ����� ���������� �� ��������� - ����������� ���������� �����
        InsArcNewMsg(ID_Obj,344+$4000,1);
        ShowShortMsg(344,LastX,LastY,ObjZav[ID_Obj].Liter);
//        SingleBeep := true;
        ShowWarning := true;
        exit;
      end else
      if WorkMode.CmdReady then
      begin //--------------------- �������� �������� � ������ - ����� ���������� ��������
        InsArcNewMsg(ID_Obj,239+$4000,1);
        ShowShortMsg(239,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin //-------------------------------------------------- ����� ������������� �����
        DspCommand.Active  := true;
        DspCommand.Command := CmdMarsh_Tracert;
        DspCommand.Obj := ObjZav[i].BaseObject;
        exit;
      end else
      begin //------------------------------------ ��������� ������������ �������� �������
        if ObjZav[i].bParam[1] then
        begin //-------------------------------------------------------- ������ ������ ���
          InsArcNewMsg(ObjZav[i].BaseObject,105+$4000,1);
          ShowShortMsg(105,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
          exit;
        end else
        if ObjZav[ObjZav[i].BaseObject].bParam[1] or
        ObjZav[ObjZav[i].BaseObject].bParam[2] or
        ObjZav[ObjZav[i].BaseObject].bParam[3] or
        ObjZav[ObjZav[i].BaseObject].bParam[4] then
        begin //------------------------------------------------------------ ������ ������
          InsArcNewMsg(ObjZav[i].BaseObject,230+$4000,1);
          ShowShortMsg(230,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
          exit;
        end else
        if ObjZav[ObjZav[i].BaseObject].bParam[7] then exit //------------ ������� - �����
        else
        if ObjZav[ObjZav[i].BaseObject].bParam[9] then
        begin
          if ObjZav[ObjZav[i].BaseObject].bParam[11] then
          begin //---------- ����������� ������ �� �������� - ����� �� ���������� ��������
            InsArcNewMsg(ObjZav[i].BaseObject,229+$4000,1);
            ShowShortMsg(229,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
            exit;
          end else
          begin //---------------- ������� �, ������ ������ - ��������� �������� ���������
            InsArcNewMsg(ObjZav[i].BaseObject,178+$4000,2);
            msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter,2);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorPoezdnogo;
            DspCommand.Obj := ObjZav[i].BaseObject;
          end;
        end else
        if ObjZav[ID_Obj].bParam[14] then
        begin //----------------------------- ��������������� ��������� �������� �� ��-���
          //--------------------- ��������� ������� ������������ ������� ��������� ��������
          if ObjZav[ObjZav[i].BaseObject].ObjConstI[14] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[14]);
            u1 := msg = '';
          end
          else u1 := true;

          if ObjZav[ObjZav[i].BaseObject].ObjConstI[15] > 0 then
          begin
            msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[15]);
            u2 := msg = '';
          end else u2 := false;

          if u1 or u2 then
          begin //------------------------------ ������ ������� ������� ��������� ��������
            InsArcNewMsg(ObjZav[i].BaseObject,178+$4000,2);
            msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter,2);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorPoezdMarsh;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- ����� �� ������ �����������
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //----------------------------------------- ������ ������ ��������� ��������
          InsArcNewMsg(ObjZav[i].BaseObject,183+$4000,2);
          msg := GetShortMsg(1,183, '�� ' + ObjZav[ObjZav[i].BaseObject].Liter,2);
          DspCommand.Active := true;
          DspCommand.Command := CmdMenu_BeginMarshPoezd;
          DspCommand.Obj := ObjZav[i].BaseObject;
        end;
      end;
    end else
    begin //------------------------------------------------- ����� ����������� ����������
      if ObjZav[i].bParam[1] then
      begin // ������ ������ ���
        InsArcNewMsg(ObjZav[i].BaseObject,105+$4000,1);
        ShowShortMsg(105,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
        exit;
      end else
      if ObjZav[ObjZav[i].BaseObject].bParam[1] or
      ObjZav[ObjZav[i].BaseObject].bParam[2] or
      ObjZav[ObjZav[i].BaseObject].bParam[3] or
      ObjZav[ObjZav[i].BaseObject].bParam[4] then
      begin //-------------------------------------------------------------- ������ ������
        InsArcNewMsg(ObjZav[i].BaseObject,230+$4000,1);
        ShowShortMsg(230,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
        exit;
      end else
      if ObjZav[ObjZav[i].BaseObject].bParam[9] then
      begin
        if ObjZav[ObjZav[i].BaseObject].bParam[11] then
        begin //------------ ����������� ������ �� �������� - ����� �� ���������� ��������
          InsArcNewMsg(ObjZav[i].BaseObject,229+$4000,1);
          ShowShortMsg(229,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
          exit;
        end else
        begin //------------------ ������� �, ������ ������ - ��������� �������� ���������
          InsArcNewMsg(ObjZav[i].BaseObject,178+$4000,2);
          msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter,2);
          DspCommand.Active := true;
          DspCommand.Command := CmdMenu_PovtorPoezdnogo;
          DspCommand.Obj := ObjZav[i].BaseObject;
        end;
      end else
      if ObjZav[i].bParam[14] then
      begin //------------------------------- ��������������� ��������� �������� �� ��-���
        //---------------------- ��������� ������� ������������ ������� ��������� ��������
        if Marhtracert[1].LockPovtor then ResetTrace; exit;
        if ObjZav[ObjZav[i].BaseObject].ObjConstI[14] > 0 then
        begin
          msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[14]);
          u1 := msg = '';
        end  else u1 := true;
        if ObjZav[ObjZav[i].BaseObject].ObjConstI[15] > 0 then
        begin
          msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[15]);
          u2 := msg = '';
        end else u2 := false;
        if u1 or u2 then
        begin //-------------------------------- ������ ������� ������� ��������� ��������
          InsArcNewMsg(ObjZav[i].BaseObject,174+$4000,2);
          msg := GetShortMsg(1,174, ObjZav[ObjZav[i].BaseObject].Liter,2);
          DspCommand.Command := CmdMenu_PovtorOtkrytPoezd;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- ����� �� ������ �����������
          PutShortMsg(1,LastX,LastY,msg);
          exit;
        end;
      end else
      begin //--------------------------------------------------- ������ �������� ��������
        InsArcNewMsg(ObjZav[i].BaseObject,183+$4000,2);
        msg := GetShortMsg(1,183, ObjZav[ObjZav[i].BaseObject].Liter,2);
        DspCommand.Command := CmdMenu_OtkrytPoezdnym;
        DspCommand.Obj := ObjZav[i].BaseObject;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//------------------------------------------- ���������� ���� ��� ������ "������ �� �����"
function CreateDspMenuNadvig(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.OtvKom then
  begin //------------------- ������ �� - ������������� �������� ����������� ��� ���������
    InsArcNewMsg(ID_Obj,311+$4000,7);
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ID_Obj;
  end else
  begin
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZav[ID_Obj].bParam[13] then
      begin //---------------------------------------------------- �������������� ��������
        InsArcNewMsg(ID_Obj,180+$4000,7);
        msg := GetShortMsg(1,180, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_DeblokirovkaNadviga;
        DspCommand.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- ������������� ��������
        InsArcNewMsg(ID_Obj,179+$4000,7);
        msg := GetShortMsg(1,179, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_BlokirovkaNadviga;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    if ObjZav[ID_Obj].bParam[13] then
    begin //-------------------------------------------------------- �������� ������������
      InsArcNewMsg(ID_Obj,123+$4000,1);
      ShowShortMsg(123,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
    end else
    if WorkMode.MarhUpr then
    begin //------------------------------------------------- ����� ����������� ����������
      if WorkMode.CmdReady then
      begin //--------------------- �������� �������� � ������ - ����� ���������� ��������
        InsArcNewMsg(ID_Obj,239+$4000,1);
        ShowShortMsg(239,LastX,LastY,'');
        exit;
      end else
      if WorkMode.GoTracert then
      begin //-------------------------------------------------- ����� ������������� �����
        DspCommand.Active  := true;
        DspCommand.Command := CmdMarsh_Tracert;
        DspCommand.Obj := ID_Obj;
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
function CreateDspMenuUchastok(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if ObjZav[ID_Obj].bParam[19] then
    begin //---------------------------------------- ���������� ���������������� ���������
      ObjZav[ID_Obj].bParam[19] := false;
      exit;
    end else
    if ObjZav[ID_Obj].bParam[9] or not ObjZav[ID_Obj].bParam[5] then
    begin //-------------------------------------------------------- �� ������� ����������
      InsArcNewMsg(ID_Obj,233+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(233,LastX,LastY,ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZav[ID_Obj].bParam[33] then
      begin //------------------------------------------------------ �������� ������������
        InsArcNewMsg(ID_Obj,431+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(431, LastX, LastY, '');
        exit;
      end else
      if not ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[14] then
      begin //--------------------------------------------------- ������ � ������ ��������
        InsArcNewMsg(ID_Obj,512+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(512, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZav[ID_Obj].ObjConstB[8] or
        ObjZav[ID_Obj].ObjConstB[9] then //--------- ���� �������� �������� �� �����������
        begin
          //------------------------------------------------------------ �������� ��������
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            InsArcNewMsg(ID_Obj,171+$4000,7);
            AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_SekciaZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_SekciaOtkrytDvijenie,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,171+$4000,7);
            AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_SekciaOtkrytDvijenie,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_SekciaZakrytDvijenie,ID_Obj);
          end;
          //--------------------------------------------- �������� �������� �� �����������
          if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
          begin
            InsArcNewMsg(ID_Obj,458+$4000,7);
            InsArcNewMsg(ID_Obj,459+$4000,7);
            AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_SekciaZakrytDvijenieET,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_SekciaOtkrytDvijenieET,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[27] then
          begin
            InsArcNewMsg(ID_Obj,459+$4000,7);
            AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_SekciaOtkrytDvijenieET,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,458+$4000,7);
            AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_SekciaZakrytDvijenieET,ID_Obj);
          end;
          if ObjZav[ID_Obj].ObjConstB[8] and
          ObjZav[ID_Obj].ObjConstB[9] then //--------------------- ���� 2 ���� �����������
          begin //---------------------- �������� �������� �� ����������� ����������� ����
            if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
            begin
              InsArcNewMsg(ID_Obj,463+$4000,7);
              InsArcNewMsg(ID_Obj,464+$4000,7);
              AddDspMenuItem(GetShortMsg(1,463,'',7),CmdMenu_SekciaZakrytDvijenieETD,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,464,'',7),CmdMenu_SekciaOtkrytDvijenieETD,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[28] then
            begin
              InsArcNewMsg(ID_Obj,464+$4000,7);
              AddDspMenuItem(GetShortMsg(1,464,'',7),CmdMenu_SekciaOtkrytDvijenieETD,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,463+$4000,7);
              AddDspMenuItem(GetShortMsg(1,463,'',7),CmdMenu_SekciaZakrytDvijenieETD,ID_Obj);
            end;
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);
              InsArcNewMsg(ID_Obj,469+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_SekciaZakrytDvijenieETA,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_SekciaOtkrytDvijenieETA,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,469+$4000,7);
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_SekciaOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_SekciaZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //---------------------------------------------------------- ��� �����������
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            InsArcNewMsg(ID_Obj,171+$4000,7);
            AddDspMenuItem(GetShortMsg(1,170,'',7),CmdMenu_SekciaZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,171,'',7),CmdMenu_SekciaOtkrytDvijenie,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,171+$4000,7);
            msg := GetShortMsg(1,171, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_SekciaOtkrytDvijenie;
            DspCommand.Obj := ID_Obj;
          end else
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            msg := GetShortMsg(1,170, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_SekciaZakrytDvijenie;
            DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
    end else

    if not ObjZav[ID_Obj].bParam[31] then
    begin //---------------------------------------------------------- ��� ������ � ������
      InsArcNewMsg(ID_Obj,293+$4000,1);
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowShortMsg(293, LastX, LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else

    if WorkMode.GoTracert then
    begin //---------------------------------------------------- ����� ������������� �����
      DspCommand.Active  := true;
      DspCommand.Command := CmdMarsh_Tracert;
      DspCommand.Obj := ID_Obj;
      exit;
    end else
    if WorkMode.OtvKom then
    begin //------------------------------------------- ������ ������ ������������� ������
      if ObjZav[ID_Obj].ObjConstB[7] then
      begin //---- ��� ������ � ������� �������� ������ ������� �����. ���������� ��������
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- �������������� �������
          OtvCommand.SObj := ID_Obj;
          InsArcNewMsg(ID_Obj,214+$4000,7);
          msg := GetShortMsg(1,214, ObjZav[ObjZav[ID_Obj].BaseObject].Liter,7);
          DspCommand.Command := CmdMenu_SekciaIspolnitRI;
          DspCommand.Obj := ID_Obj;
        end else
        if ObjZav[ID_Obj].bParam[2] then
        begin //-------- ������ ���������� - ������������� �������� ����������� ��� ������
          InsArcNewMsg(ID_Obj,311+$4000,7);
          msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMarsh_ResetTraceParams;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------------------- ������ ��������
          if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1] then
          begin //------------------------------------- ����������� �� �������� - ��������
            InsArcNewMsg(ID_Obj,335+$4000,1);
            ShowShortMsg(335,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
//            SingleBeep := true;
            exit;
          end else
          begin //----------------------------- ������ ��������������� ������� �� ��������
            InsArcNewMsg(ID_Obj,185+$4000,7);
            msg := GetShortMsg(1,185, ObjZav[ObjZav[ID_Obj].BaseObject].Liter,7);
            DspCommand.Command := CmdMenu_SekciaPredvaritRI;
            DspCommand.Obj := ID_Obj;
          end;
        end;
      end else
      begin //- ��� ������ ��� ������������ ���������� ������ ������� ������ ������ ��� ��
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- �������������� �������
          OtvCommand.SObj := ID_Obj;
          InsArcNewMsg(ID_Obj,186+$4000,7);
          msg := GetShortMsg(1,186, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_SekciaIspolnitRI;
          DspCommand.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- ��������������� �������
          if ObjZav[ID_Obj].bParam[2] then
          begin //------ ������ ���������� - ������������� �������� ����������� ��� ������
            InsArcNewMsg(ID_Obj,311+$4000,7);
            msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMarsh_ResetTraceParams;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------------------- ������ ��������
            if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1] then
            begin //----------------------------- �������� �������� ������� ��� - ��������
              InsArcNewMsg(ID_Obj,334+$4000,1);
              AddFixMessage(GetShortMsg(1,334,ObjZav[ID_Obj].Liter,1),4,2);
              exit;
            end else
            if ObjZav[ID_Obj].bParam[3] then
            begin //------------------------- ����������� ���.���������� ������ - ��������
              InsArcNewMsg(ID_Obj,84+$4000,1);
              ShowShortMsg(84,LastX,LastY,ObjZav[ID_Obj].Liter);
              exit;
            end else
            begin //------------------------------------------- ��������������� ������� ��
              InsArcNewMsg(ID_Obj,185+$4000,7);
              msg := GetShortMsg(1,185, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_SekciaPredvaritRI;
              DspCommand.Obj := ID_Obj;
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
function CreateDspMenuPutPO(ID,X,Y : SmallInt): boolean;
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
    InsArcNewMsg(ID_Obj,311+$4000,7);
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ID_Obj;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if ObjZav[ID_Obj].bParam[19] then
    begin //---------------------------------------- ���������� ���������������� ���������
      ObjZav[ID_Obj].bParam[19] := false;
      exit;
    end else
    if ObjZav[ID_Obj].bParam[9] and not WorkMode.GoTracert then
    begin //-------------------------------------------------------- �� ������� ����������
      InsArcNewMsg(ID_Obj,234+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(234,LastX,LastY,ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZav[ID_Obj].bParam[33] then
      begin //------------------------------------------------------ �������� ������������
        InsArcNewMsg(ID_Obj,431+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(431, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      if ObjZav[ID_Obj].bParam[9] then
      begin //------------------------------------------------- ���� �� ������� ����������
        InsArcNewMsg(ID_Obj,234+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(234, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      if not ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[14] then
      begin //----------------------------------------------------- ���� � ������ ��������
        InsArcNewMsg(ID_Obj,513+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(513, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZav[ID_Obj].ObjConstB[8] or
        ObjZav[ID_Obj].ObjConstB[9] then //--------- ���� �������� �������� �� �����������
        begin
          //------------------------------------------------------------ �������� ��������
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            InsArcNewMsg(ID_Obj,171+$4000,7);
            AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_PutZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_PutOtkrytDvijenie,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,171+$4000,7);
            AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_PutOtkrytDvijenie,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_PutZakrytDvijenie,ID_Obj);
          end;
          //--------------------------------------------- �������� �������� �� �����������
          if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
          begin
            InsArcNewMsg(ID_Obj,458+$4000,7);
            InsArcNewMsg(ID_Obj,459+$4000,7);
            AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_PutZakrytDvijenieET,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_PutOtkrytDvijenieET,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[27] then
          begin
            InsArcNewMsg(ID_Obj,459+$4000,7);
            AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_PutOtkrytDvijenieET,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,458+$4000,7);
            AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_PutZakrytDvijenieET,ID_Obj);
          end;
          if ObjZav[ID_Obj].ObjConstB[8] and
          ObjZav[ID_Obj].ObjConstB[9] then //--------------------- ���� 2 ���� �����������
          begin
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
            begin
              InsArcNewMsg(ID_Obj,463+$4000,7);
              InsArcNewMsg(ID_Obj,464+$4000,7);
              AddDspMenuItem(GetShortMsg(1,463, '',7), CmdMenu_PutZakrytDvijenieETD,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,464, '',7), CmdMenu_PutOtkrytDvijenieETD,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[28] then
            begin
              InsArcNewMsg(ID_Obj,464+$4000,7);
              AddDspMenuItem(GetShortMsg(1,464,'',7),CmdMenu_PutOtkrytDvijenieETD,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,463+$4000,7);
              AddDspMenuItem(GetShortMsg(1,463,'',7),CmdMenu_PutZakrytDvijenieETD,ID_Obj);
            end;
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);
              InsArcNewMsg(ID_Obj,469+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_PutZakrytDvijenieETA,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_PutOtkrytDvijenieETA,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,469+$4000,7);
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_PutOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_PutZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //---------------------------------------------------------- ��� �����������
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            InsArcNewMsg(ID_Obj,171+$4000,7);
            AddDspMenuItem(GetShortMsg(1,170,'',7),CmdMenu_PutZakrytDvijenie,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,171,'',7),CmdMenu_PutOtkrytDvijenie,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,171+$4000,7);
            msg := GetShortMsg(1,171, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_PutOtkrytDvijenie;
            DspCommand.Obj := ID_Obj;
          end else
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7);
            msg := GetShortMsg(1,170, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_PutZakrytDvijenie;
            DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
    end else
    if not ObjZav[ID_Obj].bParam[31] then
    begin //---------------------------------------------------------- ��� ������ � ������
      InsArcNewMsg(ID_Obj,294+$4000,1);
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowShortMsg(294, LastX, LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.GoTracert then //----------------------- ���� ����� ����������� ����������
    begin //---------------------------------------------------- ����� ������������� �����
      DspCommand.Active := true;
      DspCommand.Command := CmdMarsh_Tracert;
      DspCommand.Obj := ID_Obj;
      result := false;
      exit;
    end else
    begin
      i := ObjZav[ID_Obj].UpdateObject;
      if i > 0 then
      begin //------------------------------------------------------- ���� ���������� ����
        if ObjZav[i].Timers[1].Active and not ObjZav[i].bParam[4] then
        begin //-------------------------------- ����� �������� ��������� ������������� ��
          ObjZav[i].bParam[4] := true;
          exit;
        end else
        if ObjZav[i].bParam[1] and not ObjZav[i].bParam[2] then
        begin //----- ���� ���� ������ ��� - ��������� ������� ������ �������� ����������
          if SoglasieOG(ID_Obj) then
          begin //------------------------------ ��� ��������� ��/� ���� - ������ ��������
            InsArcNewMsg(ID_Obj,187+$4000,7);
            msg := GetShortMsg(1,187, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_PutDatSoglasieOgrady;
            DspCommand.Obj := ID_Obj;
          end else
          begin //------------------------------------------------ ���� �������� ��/� ����
            InsArcNewMsg(ID_Obj,393+$4000,1);
            ShowShortMsg(393,LastX,LastY,ObjZav[ID_Obj].Liter);
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
function CreateDspMenuOPI(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- �������� ����� ��������
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------------------------- ������
    if ObjZav[ID_Obj].bParam[1] then
    begin  //- ����� ���������� ���� �� ����������� ������{��������� ����������� ��������}
      InsArcNewMsg(ID_Obj,413+$4000,7);
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,413, ObjZav[ObjZav[ID_Obj].UpdateObject].Liter,7);
      DspCommand.Command := CmdMenu_PutOtklOPI;
      DspCommand.Obj := ID_Obj;
    end
    else
    begin WorkMode.MarhOtm := false; exit; end;
  end
  else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin //-- ����� ���������� ���� �� ����������� ������{��������� ����������� ��������}
      InsArcNewMsg(ID_Obj,413+$4000,7);
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,413,ObjZav[ObjZav[ID_Obj].UpdateObject].Liter,7);
      DspCommand.Command := CmdMenu_PutOtklOPI;
      DspCommand.Obj := ID_Obj;
    end else
    begin //----------------------------------- ���� ���������� ���� �� ����������� ������
      InsArcNewMsg(ID_Obj,412+$4000,7);
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,412, ObjZav[ObjZav[ID_Obj].UpdateObject].Liter,7);
      DspCommand.Command := CmdMenu_PutVklOPI;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//------------------------------------------ ������ ��������� ����������� �� �������� ����
function CreateDspMenuPSoglasiya(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- �������� ����� ��������
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- ������ -
    if ObjZav[ID_Obj].bParam[1] then
    begin //----------------------------------------------------- ����� ������ �����������
      InsArcNewMsg(ID_Obj,216+$4000,7);
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,216, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtmZaprosPoezdSoglasiya;
      DspCommand.Obj := ID_Obj;
    end else
    begin
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      //-------------------------------------------- ���� �������� �������� �� �����������
      if ObjZav[ID_Obj].ObjConstB[8] or ObjZav[ID_Obj].ObjConstB[9] then
      begin
        //-------------------------------------------------------------- �������� ��������
        if ObjZav[ID_Obj].bParam[14] <> ObjZav[ID_Obj].bParam[15] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7);
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytUvjazki,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytUvjazki,ID_Obj);
        end else
        if ObjZav[ID_Obj].bParam[15] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7); //-------------------------- ������� ������� ?
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytUvjazki,ID_Obj);
        end else
        begin
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytUvjazki,ID_Obj);
        end;
        //----------------------------------------------- �������� �������� �� �����������
        if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
        begin
          InsArcNewMsg(ID_Obj,458+$4000,7);
          InsArcNewMsg(ID_Obj,459+$4000,7);
          AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_EZZakrytDvijenieET,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_EZOtkrytDvijenieET,ID_Obj);
        end else
        if ObjZav[ID_Obj].bParam[27] then
        begin
          InsArcNewMsg(ID_Obj,459+$4000,7);
          AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_EZOtkrytDvijenieET,ID_Obj);
        end else
        begin
          InsArcNewMsg(ID_Obj,458+$4000,7);
          AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_EZZakrytDvijenieET,ID_Obj);
        end;

        //-------------------------------------------------------- ���� 2 ���� �����������
        if ObjZav[ID_Obj].ObjConstB[8] and ObjZav[ID_Obj].ObjConstB[9] then
        begin
          //---------------------------- �������� �������� �� ����������� ����������� ����
          if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
          begin
            InsArcNewMsg(ID_Obj,463+$4000,7);
            InsArcNewMsg(ID_Obj,464+$4000,7);
            AddDspMenuItem(GetShortMsg(1,463, '',7), CmdMenu_EZZakrytDvijenieETD,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,464, '',7), CmdMenu_EZOtkrytDvijenieETD,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[28] then
          begin
            InsArcNewMsg(ID_Obj,464+$4000,7);
            AddDspMenuItem(GetShortMsg(1,464, '',7), CmdMenu_EZOtkrytDvijenieETD,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,463+$4000,7);
            AddDspMenuItem(GetShortMsg(1,463, '',7), CmdMenu_EZZakrytDvijenieETD,ID_Obj);
          end;
          //---------------------------- �������� �������� �� ����������� ����������� ����
          if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
          begin
            InsArcNewMsg(ID_Obj,468+$4000,7);
            InsArcNewMsg(ID_Obj,469+$4000,7);
            AddDspMenuItem(GetShortMsg(1,468, '',7), CmdMenu_EZZakrytDvijenieETA,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,469, '',7), CmdMenu_EZOtkrytDvijenieETA,ID_Obj);
          end else
            if ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,469+$4000,7);
              AddDspMenuItem(GetShortMsg(1,469, '',7), CmdMenu_EZOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468, '',7), CmdMenu_EZZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //---------------------------------------------------------- ��� �����������
          if ObjZav[ID_Obj].bParam[14] <> ObjZav[ID_Obj].bParam[15] then
          begin
            InsArcNewMsg(ID_Obj,207+$4000,7);
            InsArcNewMsg(ID_Obj,206+$4000,7);
            AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytUvjazki,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytUvjazki,ID_Obj);
          end else
          begin
            if ObjZav[ID_Obj].bParam[15] or ObjZav[ID_Obj].bParam[14] then
            begin //------------------------------------- ������� ������ - ������� �������
              InsArcNewMsg(ID_Obj,207+$4000,7);
              msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_OtkrytUvjazki;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------- ������� ������ - ������� �������
              InsArcNewMsg(ID_Obj,206+$4000,7);
              msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_ZakrytUvjazki;
              DspCommand.Obj := ID_Obj;
            end;
          end;
        end;
      end else
      begin //--------------------------------------------------------------------- ������
        if ObjZav[ID_Obj].bParam[1] then
        begin //------------------------------------------------- ����� ������ �����������
          InsArcNewMsg(ID_Obj,216+$4000,7);
          msg := GetShortMsg(1,216, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtmZaprosPoezdSoglasiya; DspCommand.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- ���� ������ �����������
          InsArcNewMsg(ID_Obj,215+$4000,7);
          msg := GetShortMsg(1,215, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_ZaprosPoezdSoglasiya; DspCommand.Obj := ID_Obj;
        end;
      end;
    end;
    DspMenu.WC := true;
{$ENDIF}
  end;
//========================================================================================
//------------------------------ �������� ���� ��� ���������� �������� "����� �����������"
function CreateDspMenuSmenaNapravleniya(ID,X,Y : SmallInt;var gotomenu : boolean):boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}

  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1); //--------------- "������ ������ ������������� ������"
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);//---- �������� �������� ������� ������ �����. ��������
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then //------------------------------------ �������� ������ ��������
  begin
    if (ObjZav[ID_Obj].ObjConstI[9] > 0) and //--------- ������� � �������� �������� �� ��
    ObjZav[ID_Obj].bParam[17] then        //----------- ���� �������� �� ����� �����������
    begin  //----------------------------------------------------------- �������� ��������
      InsArcNewMsg(ID_Obj,437+$4000,4); //--- "����� �������� ����� ����������� �� ��������"
      msg := GetShortMsg(1,437, ObjZav[ID_Obj].Liter,4);
      DspCommand.Command := CmdMenu_SnatSoglasieSmenyNapr;
      DspCommand.Obj := ID_Obj;
      DspMenu.WC := true;
      gotomenu := true;
      exit;
    end else
    begin
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1);//-------------------------------------- "��� �� �������"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
  if WorkMode.InpOgr then //--------------------------------------------- ���� �����������
  begin
    if ObjZav[ID_Obj].bParam[33] then
    begin //-------------------------------------------------------- �������� ������������
      InsArcNewMsg(ID_Obj,431+$4000,1);//--------------------------- "�������� ������������"
      WorkMode.InpOgr := false;
      ShowShortMsg(431, LastX, LastY, '');
      exit;
    end else
    begin
      //-------------------------------------------- ���� �������� �������� �� �����������
        if ObjZav[ID_Obj].ObjConstB[8] or
        ObjZav[ID_Obj].ObjConstB[9] then
        begin
          //------------------------------------------------------------ �������� ��������
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,207+$4000,7); //----------------------- "������� ������� $?"
            InsArcNewMsg(ID_Obj,206+$4000,7); //----------------------- "������� ������� $?"
            AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytPeregon,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytPeregon,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,207+$4000,7);
            AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytPeregon,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,206+$4000,7);
            AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytPeregon,ID_Obj);
          end;
          //--------------------------------------------- �������� �������� �� �����������
          if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
          begin
            InsArcNewMsg(ID_Obj,458+$4000,7); //------ ������� $ ��� �������� �� �����������
            InsArcNewMsg(ID_Obj,459+$4000,7); //------ ������� $ ��� �������� �� �����������
            AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_ABZakrytDvijenieET,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_ABOtkrytDvijenieET,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[27] then
          begin
            InsArcNewMsg(ID_Obj,459+$4000,7);
            AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_ABOtkrytDvijenieET,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,458+$4000,7);
            AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_ABZakrytDvijenieET,ID_Obj);
          end;
          if ObjZav[ID_Obj].ObjConstB[8] and
          ObjZav[ID_Obj].ObjConstB[9] then //--------------------- ���� 2 ���� �����������
          begin
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
            begin
              InsArcNewMsg(ID_Obj,463+$4000,7);
              InsArcNewMsg(ID_Obj,464+$4000,7);
              AddDspMenuItem(GetShortMsg(1,463,'',7),CmdMenu_ABZakrytDvijenieETD,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,464,'',7),CmdMenu_ABOtkrytDvijenieETD,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[28] then
            begin
              InsArcNewMsg(ID_Obj,464+$4000,7);
              AddDspMenuItem(GetShortMsg(1,464,'',7),CmdMenu_ABOtkrytDvijenieETD,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,463+$4000,7);
              AddDspMenuItem(GetShortMsg(1,463,'',7),CmdMenu_ABZakrytDvijenieETD,ID_Obj);
            end;
            //-------------------------- �������� �������� �� ����������� ����������� ����
            if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);//������� ��� �������� �� �� ����������� ����
              InsArcNewMsg(ID_Obj,469+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_ABZakrytDvijenieETA,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_ABOtkrytDvijenieETA,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,469+$4000,7);//-- ������ ������� ����.����. �� �����. ����
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_ABOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_ABZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //---------------------------------------------------------- ��� �����������
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,207+$4000,7);  //---------------------- ������� ������� $?
            InsArcNewMsg(ID_Obj,206+$4000,7);  //---------------------- ������� ������� $?
            AddDspMenuItem(GetShortMsg(1,207,'',7),CmdMenu_OtkrytPeregon,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,206,'',7),CmdMenu_ZakrytPeregon,ID_Obj);
          end else
          begin
            if ObjZav[ID_Obj].bParam[13] or ObjZav[ID_Obj].bParam[12] then
            begin //------------------------------------- ������� ������ - ������� �������
              InsArcNewMsg(ID_Obj,207+$4000,7);
              msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_OtkrytPeregon;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------- ������� ������ - ������� �������
              InsArcNewMsg(ID_Obj,206+$4000,7);
              msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_ZakrytPeregon;
              DspCommand.Obj := ID_Obj;
            end;
          end;
        end;
      end;
    end else
    begin //------------------------------------------------------------ ����� �����������
      if ObjZav[ID_Obj].ObjConstB[3] then //------------------- ���� ����������� ���������
      begin
        if ObjZav[ID_Obj].bParam[7] and ObjZav[ID_Obj].bParam[8] then
        begin //--------------------------------------------- ������ ����������� ���������
          InsArcNewMsg(ID_Obj,261+$4000,1);//�������� ����� ����������� $ ��������� �� �����
          ShowShortMsg(261,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
        if ObjZav[ID_Obj].ObjConstB[4] then
        begin //-------------------------------------------------------------------- �����
          if not ObjZav[ID_Obj].bParam[7] then
          begin //---------------------------------------- �� ��������� �������� �� ������
            InsArcNewMsg(ID_Obj,260+$4000,1);
            ShowShortMsg(260,LastX,LastY,ObjZav[ID_Obj].Liter);
            exit;
          end;
        end else
        if ObjZav[ID_Obj].ObjConstB[5] then
        begin //-------------------------------------------------------------- �����������
          if not ObjZav[ID_Obj].bParam[8] then
          begin //----------------------------------- �� ��������� �������� �� �����������
            InsArcNewMsg(ID_Obj,260+$4000,1); // �������� ����� ����������� $ �� ���������
            ShowShortMsg(260,LastX,LastY,ObjZav[ID_Obj].Liter);
            exit;
          end;
        end;
      end;

      if (ObjZav[ID_Obj].ObjConstI[9] > 0) and //------- ������� � �������� �������� �� ��
      ObjZav[ID_Obj].bParam[17] then        //--------- ���� �������� �� ����� �����������
      begin //---------------------------------------------------------- �������� ��������
        InsArcNewMsg(ID_Obj,437+$4000,7); //- ����� �������� ����� ����������� �� ��������
        msg := GetShortMsg(1,437, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_SnatSoglasieSmenyNapr;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
        gotomenu := true;
        exit;
      end;

      if not ObjZav[ID_Obj].bParam[5] then
      begin //-------------------------------------------------------------- ������� �����
        InsArcNewMsg(ID_Obj,262+$4000,1);
        ShowShortMsg(262,LastX,LastY,ObjZav[ID_Obj].Liter);
        msg :=GetShortMsg(1,262, ObjZav[ID_Obj].Liter,1);
        exit;
      end;

      if not ObjZav[ID_Obj].bParam[6] then
      begin //--------------------------------------- ��������� �������� (����� ����-����)
        InsArcNewMsg(ID_Obj,130+$4000,1);
        ShowShortMsg(130,LastX,LastY,ObjZav[ID_Obj].Liter);
        msg := GetShortMsg(1, 130, ObjZav[ID_Obj].Liter,1);
        exit;
      end;

      if ObjZav[ID_Obj].bParam[4] then//------------------- "������� ����� �� �����������"
      begin
        if ObjZav[ID_Obj].ObjConstI[9] > 0 then //------ ������� � �������� �������� �� ��
        begin
          if ObjZav[ID_Obj].bParam[10] then //----------- ���� ������ �� ����� �����������
          begin
            if ObjZav[ID_Obj].bParam[15] then //----------- ��������� �������� �����������
            begin
              InsArcNewMsg(ID_Obj,436+$4000,1);//"���������� �����.����.������ �� �������"
              ShowShortMsg(436,LastX,LastY,ObjZav[ID_Obj].Liter);
              exit;
            end;
            InsArcNewMsg(ID_Obj,205+$4000,7);//- "������ �������� �� ����� ����������� $?"
            msg := GetShortMsg(1,205, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_DatSoglasieSmenyNapr;
            DspCommand.Obj := ID_Obj;
            DspMenu.WC := true;
            gotomenu := true;
            exit;
          end else //-----------------------------------  ��� ������� �� ����� �����������
          begin
            InsArcNewMsg(ID_Obj,266+$4000,1);
            msg := GetShortMsg(1,266, ObjZav[ID_Obj].Liter,1);
            ShowShortMsg(266,LastX,LastY,ObjZav[ID_Obj].Liter);
          end;
          exit;
        end else //------------------------ ������� ��� ������� �������� ����� �����������
        begin
          InsArcNewMsg(ID_Obj,265+$4000,1);
          msg := GetShortMsg(1,265, ObjZav[ID_Obj].Liter,1);
          ShowShortMsg(265,LastX,LastY,ObjZav[ID_Obj].Liter);
//          SingleBeep := true;
        end;
        exit;
      end else
      begin //-------------------------------------------------- "������� ����� �� ������"
        InsArcNewMsg(ID_Obj,204+$4000,7);
        msg := GetShortMsg(1,204, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_SmenaNapravleniya;
        DspCommand.Obj := ID_Obj;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//------------------------------------------------ ����������� ��������� ����� �����������
function CreateDspMenu_KSN(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if not WorkMode.OtvKom then
  begin //--------------------------------- �� ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,276+$4000,1);
    ResetCommands;
    ShowShortMsg(276,LastX,LastY,'');
    SimpleBeep;
    msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- �������� ����� ��������
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- ������ -
    if ObjZav[ID_Obj].bParam[1] then
    begin //-------------------------------------------------------- ��������� �������� ��
      InsArcNewMsg(ID_Obj,406+$4000,7);
      msg := GetShortMsg(1,406, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtklKSN;
      DspCommand.Obj := ID_Obj;
    end else
    begin
      InsArcNewMsg(ID_Obj,260+$4000,1);
      ShowShortMsg(260,LastX,LastY,''); exit;
    end;
    DspCommand.Active := true;
    WorkMode.MarhOtm := false;
    DspMenu.WC := true;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin //-------------------------------------------------------- ��������� �������� ��
      InsArcNewMsg(ID_Obj,406+$4000,7);
      msg := GetShortMsg(1,406, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtklKSN;
      DspCommand.Obj := ID_Obj;
    end else
    begin //------------------------------------------------------- ���������� �������� ��
      InsArcNewMsg(ID_Obj,407+$4000,7);
      msg := GetShortMsg(1,407, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_VklKSN;
      DspCommand.Obj := ID_Obj;
    end;
    DspCommand.Active := true;
    WorkMode.MarhOtm := false;
    DspMenu.WC := true;
  end;
{$ENDIF}
end;
//========================================================================================
//--------------------------------------------------------------------------- ������ � ���
function CreateDspMenu_PAB(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- ������ -
    WorkMode.MarhOtm := false;
    if ObjZav[ID_Obj].bParam[4] then
    begin //--------------------------------------------------- ����� �������� �����������
      InsArcNewMsg(ID_Obj,279+$4000,7);
      msg := GetShortMsg(1,279, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtmenaSoglasieOtpravl;
      DspCommand.Obj := ID_Obj;
    end
    else exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ���� �����������
      if ObjZav[ID_Obj].ObjConstB[8] or
      ObjZav[ID_Obj].ObjConstB[9] then //----------- ���� �������� �������� �� �����������
      begin //---------------------------------------------------------- �������� ��������
        if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7);
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytPeregonPAB,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytPeregonPAB,ID_Obj);
        end else
        if ObjZav[ID_Obj].bParam[13] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7);
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytPeregonPAB,ID_Obj);
        end else
        begin
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytPeregonPAB,ID_Obj);
        end;
        //----------------------------------------------- �������� �������� �� �����������
        if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
        begin
          InsArcNewMsg(ID_Obj,458+$4000,7);
          InsArcNewMsg(ID_Obj,459+$4000,7);
          AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_RPBZakrytDvijenieET,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_RPBOtkrytDvijenieET,ID_Obj);
        end else
        if ObjZav[ID_Obj].bParam[27] then
        begin
          InsArcNewMsg(ID_Obj,459+$4000,7);
          AddDspMenuItem(GetShortMsg(1,459, '',7), CmdMenu_RPBOtkrytDvijenieET,ID_Obj);
        end else
        begin
          InsArcNewMsg(ID_Obj,458+$4000,7);
          AddDspMenuItem(GetShortMsg(1,458, '',7), CmdMenu_RPBZakrytDvijenieET,ID_Obj);
        end;
        if ObjZav[ID_Obj].ObjConstB[8] and
        ObjZav[ID_Obj].ObjConstB[9] then //----------------------- ���� 2 ���� �����������
        begin  //----------------------- �������� �������� �� ����������� ����������� ����
          if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
          begin
            InsArcNewMsg(ID_Obj,463+$4000,7);
            InsArcNewMsg(ID_Obj,464+$4000,7);
            AddDspMenuItem(GetShortMsg(1,463, '',7), CmdMenu_RPBZakrytDvijenieETD,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,464, '',7), CmdMenu_RPBOtkrytDvijenieETD,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[28] then
          begin
            InsArcNewMsg(ID_Obj,464+$4000,7);
            AddDspMenuItem(GetShortMsg(1,464, '',7), CmdMenu_RPBOtkrytDvijenieETD,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,463+$4000,7);
            AddDspMenuItem(GetShortMsg(1,463, '',7), CmdMenu_RPBZakrytDvijenieETD,ID_Obj);
          end;
          //---------------------------- �������� �������� �� ����������� ����������� ����
          if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
          begin
            InsArcNewMsg(ID_Obj,468+$4000,7);
            InsArcNewMsg(ID_Obj,469+$4000,7);
            AddDspMenuItem(GetShortMsg(1,468, '',7), CmdMenu_RPBZakrytDvijenieETA,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,469, '',7), CmdMenu_RPBOtkrytDvijenieETA,ID_Obj);
          end else
          if ObjZav[ID_Obj].bParam[29] then
          begin
            InsArcNewMsg(ID_Obj,469+$4000,7);
            AddDspMenuItem(GetShortMsg(1,469, '',7), CmdMenu_RPBOtkrytDvijenieETA,ID_Obj);
          end else
          begin
            InsArcNewMsg(ID_Obj,468+$4000,7);
            AddDspMenuItem(GetShortMsg(1,468, '',7), CmdMenu_RPBZakrytDvijenieETA,ID_Obj);
          end;
        end;
      end else
      begin //------------------------------------------------------------ ��� �����������
        if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7);
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytPeregonPAB,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytPeregonPAB,ID_Obj);
        end else
        begin
          if ObjZav[ID_Obj].bParam[13] or ObjZav[ID_Obj].bParam[12] then
          begin //--------------------------------------- ������� ������ - ������� �������
            InsArcNewMsg(ID_Obj,207+$4000,7);
            msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_OtkrytPeregonPAB;
            DspCommand.Obj := ID_Obj;
          end else
          begin //--------------------------------------- ������� ������ - ������� �������
            InsArcNewMsg(ID_Obj,206+$4000,7);
            msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_ZakrytPeregonPAB;
            DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
    end else
    begin //
      if WorkMode.OtvKom then
      begin //------------------------------------------------------------------- ����� ��
        if not ObjZav[ID_Obj].bParam[1] then
        begin //-------------------------------------------------- ������� ����� �� ������
          if ObjZav[ID_Obj].bParam[3] then
          begin //------------------------------------------ ������ �������������� �������
            InsArcNewMsg(ID_Obj,281+$4000,7);
            msg := GetShortMsg(1,281, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_IskPribytieIspolnit;
            DspCommand.Obj := ID_Obj;
          end else
          begin //----------------------------------------- ������ ��������������� �������
            InsArcNewMsg(ID_Obj,280+$4000,7);
            msg := GetShortMsg(1,280, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_IskPribytiePredv;
            DspCommand.Obj := ID_Obj;
          end;
        end else
        begin //----------------------------------------- �� ��������� ������ ���.��������
          InsArcNewMsg(ID_Obj,298+$4000,7);
          ShowShortMsg(298,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end else
      if not ObjZav[ID_Obj].bParam[1] then
      begin //---------------------------------------------------- ������� ����� �� ������
        if ObjZav[ID_Obj].bParam[2] then
        begin //--------------------------------- �������� �������� ������ - ���� ��������
          InsArcNewMsg(ID_Obj,282+$4000,7);
          msg := GetShortMsg(1,282, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_VydatPribytiePoezda;
          DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ID_Obj,318+$4000,1);
          ShowShortMsg(318,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end else
      if not ObjZav[ID_Obj].bParam[5] then
      begin //----------------------------------------------- ������� ����� �� �����������
        InsArcNewMsg(ID_Obj,299+$4000,7);
        ShowShortMsg(299,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if ObjZav[ID_Obj].bParam[6] then
      begin //---------------------------------------------- �������� �������� �����������
        InsArcNewMsg(ID_Obj,326+$4000,7);
        ShowShortMsg(326,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if not ObjZav[ID_Obj].bParam[7] then
      begin //------------------------------------------------------- �������� �� ��������
        InsArcNewMsg(ID_Obj,130+$4000,1);
        ShowShortMsg(130,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      begin //----------------------------------- ������� �������� - ������/����� ��������
        if ObjZav[ID_Obj].bParam[4] then
        begin //----------------------------------------------- ����� �������� �����������
          InsArcNewMsg(ID_Obj,279+$4000,7);
          msg := GetShortMsg(1,279, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtmenaSoglasieOtpravl;
          DspCommand.Obj := ID_Obj;
        end else
        begin //------------------------------------------------ ���� �������� �����������
          InsArcNewMsg(ID_Obj,278+$4000,7);
          msg := GetShortMsg(1,278, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_VydatSoglasieOtpravl;
          DspCommand.Obj := ID_Obj;
        end;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//-------------------------------------------------- �������� ���� ��� ���������� ��������
function CreateDspMenu_Strelka(ID, X, Y : SmallInt) : Boolean;
var
  ogr : boolean;
	hvost,SP_str,AvPer : SmallInt;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}

	hvost := ObjZav[ID_Obj].BaseObject;   //-------------------------- ������ ������ �������
  SP_str := ObjZav[ID_Obj].UpdateObject;//------------------------------ ������ �� �������
  AvPer := ObjZav[hvost].ObjConstI[13];//-------------- ������ ���������� �������� �������

  //------- ��� ����������� ������ ��������� �� �������� ��������� �������������� ��������
  if ObjZav[hvost].ObjConstB[2] and //------------- ���� ��� ������� ������� ����������� �
  (ObjZav[hvost].bParam[3] or//------------------------ ���������� ������ ������������ ���
  ObjZav[hvost].bParam[12]) then //------------------------- ������� �������� ������������
  begin //------------------ ��� ������� ������������ ��������� ������������ - �������� ��
    ObjZav[hvost].bParam[3] := false; //------ ����� �������� ���������� ���������� ������
    ObjZav[hvost].bParam[12] := false; // ����� �������� ����������� �������� ������������
    InsArcNewMsg(hvost,424+$4000,7);//------------------- "������� ����������� � ��������"
    AddFixMessage(GetShortMsg(1,424,ObjZav[hvost].Liter,7),4,1);
  end;

  //-------------- ������� ������ � �������������� ���������, ��� ������� ��� ������������
  if WorkMode.OtvKom then //----------------------------------------------- ���� ������ ��
  begin //--------------------- ������ �� - ������������� �������� ����������� ��� �������
    InsArcNewMsg(ID_Obj,311+$4000,7); //--------------------------------- "�������������?"
    msg := GetShortMsg(1,311, '������� '+ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams; //-----
    DspCommand.Obj := ID_Obj;
  end

	//------------------------------------------------------ ����� ������ � ������� ��������
  else
  if WorkMode.MarhOtm then //-------------------------- ���� ����� ������� ������ ��������
  begin //----------------------------------------------- �������� ������ �������� � �����
    WorkMode.MarhOtm := false;
    exit;
  end else

	//----------------------------------------------- ����� ������ ���������������� ��������
  if VspPerevod.Active then //------------------------------------- ���� ������������� ���
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);//------------ "�������� �������� ������� ������ ���"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else

	//----------------------------------------------------------- ����� ������ � �����������
  if WorkMode.GoTracert then //--------------------------- ���� ���� ����� ������ ��������
  begin
    ResetTrace; //---------------- �������� ��������� ������ �������� � ��������� ��������
    exit; //---------------------------------------------------------------------- � �����
  end else

	//----------------------------------------------- ��������� ������ � ���������� �� �����
  if WorkMode.GoMaketSt then //----------------------- ���� ���� ������ ��������� �� �����
  begin
    if not ObjZav[SP_str].bParam[5] or //-------------------------------- ���� � �� �� ���
    ObjZav[SP_str].bParam[9] then      //----------------------------------------- � �� ��
    begin //--- ��������:"������� �� ������� ����������" �������� ������ � ������� � �����
      InsArcNewMsg(hvost,91+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(91,LastX,LastY,ObjZav[hvost].Liter);//"������� $ �� ������� ����������"
      WorkMode.GoMaketSt := false; //----------- ����� �������� ������ �� ��������� ������
      exit;
    end else
    if ObjZav[hvost].bParam[14] or//----------------------- ������� �������� ��������� ���
    ObjZav[ID_Obj].bParam[10] or //--------------- ������� ������� ������� ����������� ���
    ObjZav[ID_Obj].bParam[11] or//---------------- ������� ������� ������� ����������� ���
    ObjZav[ID_Obj].bParam[12] or //------------------------ ������� ���������� � ����� ���
    ObjZav[ID_Obj].bParam[13] or //----------------------- ������� ���������� � ������ ���
    ObjZav[ID_Obj].bParam[6] or //------------------------------------ ���� ������� �� ���
    ObjZav[ID_Obj].bParam[7] then //-------------------------------------- ���� ������� ��
    begin //------------- ��������: "������� � ��������" �������� ������ � ������� � �����
      InsArcNewMsg(hvost,511+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(511,LastX,LastY,ObjZav[hvost].Liter);//--------- "������� $ � ��������"
      WorkMode.GoMaketSt := false; //----------- ����� �������� ������ �� ��������� ������
      exit;
    end else
    if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[2] then //--- ���� ���� �� ��� ��
    begin //------------------------ ���� �������� ��������� - ����� �� ��������� �� �����
      //--- "��� ��������� � ������ �������� ��������� ������� $! ������ ��������� ������"
      InsArcNewMsg(hvost,92,1);
      ResetShortMsg;
      AddFixMessage(GetShortMsg(1,92,ObjZav[hvost].Liter,1),4,1);
      ShowShortMsg(92, LastX, LastY, ObjZav[hvost].Liter);
      WorkMode.GoMaketSt := false;
      exit;
    end else
    if ObjZav[hvost].bParam[26] and //-------------- ���� ���� ��������� � ������ ��������
    not(ObjZav[hvost].bParam[32] or ObjZav[ID_Obj].bParam[32])then //----- � ��� ���������
    begin //----------------------------------- ��������� ������������� ��������� �� �����
      InsArcNewMsg(hvost,138+$4000,7); //------------------ ���������� ������� $ �� �����?
      msg := GetShortMsg(1,138,ObjZav[hvost].Liter,7);
      DspCommand.Command := CmdMenu_UstMaketStrelki;
      DspCommand.Obj := ID_Obj;
    end else
    begin
      //--- "��� ��������� � ������ �������� ��������� ������� $! ������ ��������� ������"
      InsArcNewMsg(hvost,92,1);
//      ResetShortMsg;
      AddFixMessage(GetShortMsg(1,92,ObjZav[hvost].Liter,1),4,1);
      ShowShortMsg(92, LastX, LastY, ObjZav[hvost].Liter);
      WorkMode.GoMaketSt := false;
      exit;
    end;
  end else

  //--------------------------------------------- �������� ������ � ���������� �����������
  begin //---------------------------------------------------- ���� ��� ��������� �� �����
    if WorkMode.InpOgr then //------------------------------------------- ���� �����������
    begin
      if ObjZav[ID_Obj].bParam[33] or ObjZav[ID_Obj].bParam[25 ] then // ���� ������������
      begin //------------------------------------------------------ �������� ������������
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,431+$4000,1); //--- "�������� ������������"
        WorkMode.InpOgr := false;
        ShowShortMsg(431, LastX, LastY, '');
        exit;
      end else
      if ObjZav[ID_Obj].bParam[5] or //-------- ���� ���� ���������� �������� �������� ���
      ObjZav[ID_Obj].bParam[6] or //------------------------------------------ ���� �� ���
      ObjZav[ID_Obj].bParam[7] or //------------------------------------------ ���� �� ���
      ObjZav[ID_Obj].bParam[8] or //---------------- ���� �������� �������� � �������� ���
      ObjZav[ID_Obj].bParam[14] then //---------- ���� ������� ������������ ��������� ����
      begin //------------ ������� � ����������� �������� ����������� ������������� ������
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,511+$4000,1);//------- "������� � ��������"
        WorkMode.InpOgr := false;
        ShowShortMsg(511, LastX, LastY, ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        exit;
      end else
      if not ObjZav[SP_str].bParam[5] or//------------------------------------ ���� �� ���
      ObjZav[SP_str].bParam[9] then //------------------------------------ ���� ������� ��
      begin //-------------------------------------- ������� ������� �� ������� ����������
        InsArcNewMsg(hvost,91+$4000,1); //---------------------- "������� �� ������� ���."
        WorkMode.InpOgr := false;
        ShowShortMsg(91, LastX, LastY, ObjZav[hvost].Liter);
        exit;
      end else
      begin //---------- ���� ��� ������������ �� ���������� ������� � �������� � � ������
        if ObjZav[ID_Obj].bParam[18] <> ObjZav[hvost].bParam[18] then //
        begin
          InsArcNewMsg(hvost,169+$4000,7); //--------------------- "�������� ���������� ?"
          InsArcNewMsg(hvost,168+$4000,7); //-------------------- "��������� ���������� ?"
          AddDspMenuItem(GetShortMsg(1,169, '',7), CmdMenu_StrVklUpravlenie,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,168, '',7), CmdMenu_StrOtklUpravlenie,ID_Obj);
        end else //------------------------------------ ���� �� ���������� ���� ����������
        begin
          if ObjZav[ID_Obj].bParam[18] then //------- ���� ������� ��������� �� ����������
          begin
            InsArcNewMsg(hvost,169+$4000,7); //--------------------- �������� ���������� $
            AddDspMenuItem(GetShortMsg(1,169, '',7), CmdMenu_StrVklUpravlenie,ID_Obj);
          end else
          begin
            InsArcNewMsg(hvost,168+$4000,7); //----------------- ��������� �� ���������� $
            AddDspMenuItem(GetShortMsg(1,168, '',7),CmdMenu_StrOtklUpravlenie,ID_Obj);
          end;
        end;

        //------------------------------------------- ������� ��� �������� ������� (��� 2)
        if ObjZav[ID_Obj].ObjConstB[6] then //--------------------- ���� "�������" �������
        ogr := ObjZav[hvost].bParam[17]//--------- �������� �������� �� ������ ��� �������
        else ogr :=ObjZav[hvost].bParam[16];//------- ����� �������� �� ������ ��� �������

        if ObjZav[ID_Obj].bParam[16] <> ogr then //---- ���� ����.������� �� �����. ������
        begin
          InsArcNewMsg(ID_Obj,171+$4000,7); //--------------------- "������� ��� ��������"
          InsArcNewMsg(ID_Obj,170+$4000,7); //--------------------- "������� ��� ��������"
          AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_StrOtkrytDvizenie,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_StrZakrytDvizenie,ID_Obj);
        end else //----------------------- ���� ������������� ����������� ������� � ������
        begin
          if ObjZav[ID_Obj].bParam[16] then //------------------ ���� ������� ��� ��������
          begin
            InsArcNewMsg(ID_Obj,171+$4000,7); //------------------- "������� ��� ��������"
            AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_StrOtkrytDvizenie,ID_Obj);
          end else //---------------------------------------- ���� �� ������� ��� ��������
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7); //--------------------"������� ��� ��������"
            AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_StrZakrytDvizenie,ID_Obj);
          end;
        end;

        if not ObjZav[ID_Obj].ObjConstB[10] then // ���� �������, � �� ������������ ������
        begin //--- ������� ��� �������� ���������������, ���� �� �������� �����. ��������
          if ObjZav[ID_Obj].ObjConstB[6] //----------------------- ���� ��� ������ �������
          then ogr:= ObjZav[hvost].bParam[34]//--------------- ����� �� ������ ��� �������
          else ogr:=ObjZav[hvost].bParam[33];//--------- ����� ����� �� ������ ��� �������

          if ObjZav[ID_Obj].bParam[17] <> ogr then //------- �������� �� ������� � �������
          begin
            InsArcNewMsg(ID_Obj,450+$4000,7); //-- "������� ��� ���������������� ��������"
            InsArcNewMsg(ID_Obj,449+$4000,7); //-- "������� ��� ���������������� ��������"
            AddDspMenuItem(GetShortMsg(1,450, '',7),CmdMenu_StrOtkrytProtDvizenie,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,449, '',7),CmdMenu_StrZakrytProtDvizenie,ID_Obj);
          end else //------------------------------------------ ���� �������� ��� � ������
          begin
            if ObjZav[ID_Obj].bParam[17] then //-------- ���� ������� ��� ����������������
            begin
              InsArcNewMsg(ID_Obj,450+$4000,7);//- "������� ��� ���������������� ��������"
              AddDspMenuItem(GetShortMsg(1,450,'',7),CmdMenu_StrOtkrytProtDvizenie,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,449+$4000,7);//- "������� ��� ���������������� ��������"
              AddDspMenuItem(GetShortMsg(1,449,'',7),CmdMenu_StrZakrytProtDvizenie,ID_Obj);
            end;
          end;
        end;

        //--------------------------------- �������� ����� ������� � ������ ������� ������
        if ObjZav[hvost].bParam[15] and //------------------------- ���� ����� �� ������ �
        (maket_strelki_index <> hvost) then //--------------------- � ������ �� �� �������
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,172+$4000,7);//- "����� � ������ �������"
          AddDspMenuItem(GetShortMsg(1,172, '',7),CmdStr_ResetMaket,ID_Obj);
        end;
      end;
    end else

    //------------------------------------------------------ ���� �� ��������� �����������
    if not ObjZav[hvost].bParam[31] then //----------------- ���� ��� ���������� �� ������
    begin //---------------------------------------------------------- ��� ������ � ������
      InsArcNewMsg(ID_Obj,255+$4000,7); //--- "����������� ���������� � ��������� �������"
      VspPerevod.Active := false; //----------- ����� ���������� ���������������� ��������
      WorkMode.VspStr := false;  //----- ��������� ����� ���������������� �������� �������
      ShowShortMsg(255, LastX, LastY, ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
      exit;
    end else

    //---------------------------------------------- �����, ���� ���� ���������� �� ������
    if ObjZav[hvost].bParam[4] or // ���� ���� �������������� ��������� ������ ������� ���
    ObjZav[ID_Obj].bParam[4] or //------------ ���� �������������� ��������� � ������� ���
    not ObjZav[hvost].bParam[21] then //-------------------- ���� ��������� � ������ �� ��
    begin //------------------------------------------ "������� ��������,������� ��������"
      ShowWarning := true;
      msg := GetShortMsg(1,147,ObjZav[hvost].Liter,1);
      InsArcNewMsg(hvost,147+$4000,1);
      exit;
    end else //-------------------------------------------------- �����,���� ��� ���������
    if ObjZav[ID_Obj].bParam[18] or //------------------------- ���� ��������� ������� ���
    ObjZav[hvost].bParam[18] then //--------------------------------------- �������� �����
    begin //-------------------------- "������� ��������� �� ����������, ������� ��������"
      InsArcNewMsg(hvost,151+$4000,7);
      ShowShortMsg(151,LastX,LastY,ObjZav[hvost].Liter);
      msg := GetShortMsg(1,151,ObjZav[hvost].Liter,7);
      exit;
    end else //-------------------------------------------------- �����, ���� �� ���������
    if ObjZav[AvPer].bParam[1] then // ���� � ������� ���������� �������� ���� ������� ���
    begin
      if WorkMode.VspStr then //-------------- ���� ���� ������� ���������������� ��������
      begin
        InsArcNewMsg(hvost,411+$4000,7);//---- "������� ������� �������. �������� �������"
        ShowShortMsg(411,LastX,LastY,ObjZav[hvost].Liter);
        msg := GetShortMsg(1,411,ObjZav[hvost].Liter,7);
        exit;
      end else //----------------------------- ���� ��� �������� ���������������� ��������
      begin
        //--------- "������ ������ ���������������� ��������. ������� ������� $ ��������!"
				InsArcNewMsg(hvost,139+$4000,1);
        ShowShortMsg(139,LastX,LastY,ObjZav[hvost].Liter);
        exit;
      end;
    end else //---------------------------------------------- �����, ���� ��� �������� ���
    if ObjZav[hvost].bParam[14] or//----------------------- ���� ����������� ��������� ���
    ObjZav[hvost].bParam[23] then //----------------------------- ����������� ��� ��������
    begin //----- ������� ������������ � ��������  - ������������, ����� ��������� �������
      InsArcNewMsg(hvost,240+$4000,7); //---------------- "������� � ��������,����������?"
      msg := GetShortMsg(1,240,ObjZav[hvost].Liter,7);
      ShowWarning := true;
      DspCommand.Command := CmdStr_AskPerevod;
      DspCommand.Obj := ID_Obj;
    end else //------------------------ ���� ��� ������������ ��������� ������� � ��������
    begin //---------------------------------------------------- ������ �� ������� �������
      DspCommand.Command := CmdStr_AskPerevod;
      DspCommand.Obj := ID_Obj;
      DspCommand.Active := true;
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------------------- �������� ���� ��� ���������� �������� "���������� �������"
function CreateDspMenu_ManevrovayaKolonka(ID,X,Y : SmallInt): boolean;
var
  MessCount,MessObj,WarObj : Integer;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.InpOgr then
  WorkMode.InpOgr := false //----------------------------------- �������� ���� �����������
  else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- �������� ����� ��������
    ResetTrace; DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- ������ -
    WorkMode.MarhOtm := false;
    if ObjZav[ID_Obj].bParam[8] then
    begin //---------------------------------- ������ �� - �������� ��� ���������� �������
      if ObjZav[ID_Obj].bParam[3] then
      begin //---------------------------------------------------- ������� ��� �� ��������
        InsArcNewMsg(ID_Obj,218+$4000,7);
        msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- ������� ��������
        if ObjZav[ID_Obj].bParam[5] then //---------------------- ���� ���������� ��������
        begin //------------------------------------------------------- ���������� �������
          InsArcNewMsg(ID_Obj,446+$4000,7);
          msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
        end else
        begin
          InsArcNewMsg(ID_Obj,218+$4000,7);
          msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
        end;
      end;
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[9] then
    begin //------------------------------------------- ���� �� ��� ��� - �������� �������
      if ObjZav[ID_Obj].bParam[5] and
      not ObjZav[ID_Obj].bParam[3] then //------------------ ���� ���������� �������� � ��
      begin //--------------------------------------------------------- ���������� �������
        InsArcNewMsg(ID_Obj,446+$4000,7);
        msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ ��������� ������� ������ ��������
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ ��� ������� ��� ������ - ���������� �������
          InsArcNewMsg(ID_Obj,446+$4000,7);
          msg := msg + '! ' + GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
        end else
        begin //--------------------------------------------------------- �������� �������
          InsArcNewMsg(ID_Obj,218+$4000,7);
          msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
        end;
      end;
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    if not ObjZav[ID_Obj].bParam[3] and not ObjZav[ID_Obj].bParam[5] then
    begin //-------------- ���� �� � ����� ���������� �������� - ��������� ������ ��������
      InsArcNewMsg(ID_Obj,218+$4000,7);
      msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    if ObjZav[ID_Obj].bParam[5] then //---------------------- �� ����� ���������� ��������
    begin //--------------------------------------------------------------------- ��������
      InsArcNewMsg(ID_Obj,269+$4000,7);
      ShowShortMsg(269,LastX,LastY, ObjZav[ID_Obj].Liter); exit;
    end;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,220+$4000,7);
        msg := GetShortMsg(1,220, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolIRManevrov;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsArcNewMsg(ID_Obj,219+$4000,7);
        msg := GetShortMsg(1,219, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvIRManevrov;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    if ObjZav[ID_Obj].bParam[8] then
    begin //------------------------------------------------- ������ �� - �������� �������
      if ObjZav[ID_Obj].bParam[3] then
      begin //---------------------------------------------------- ������� ��� �� ��������
        InsArcNewMsg(ID_Obj,218+$4000,7);
        msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- ������� ��������
        if ObjZav[ID_Obj].bParam[5] then //---------------------- ���� ���������� ��������
        begin //------------------------------------------------------- ���������� �������
          InsArcNewMsg(ID_Obj,446+$4000,7);
          msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
        end else
        begin
          InsArcNewMsg(ID_Obj,218+$4000,7);
          msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
        end;
      end;
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[9] then
    begin //------------------------------------------- ���� �� ��� ��� - �������� �������
      if ObjZav[ID_Obj].bParam[5] and
      not ObjZav[ID_Obj].bParam[3] then //------------------ ���� ���������� �������� � ��
      begin //--------------------------------------------------------- ���������� �������
        InsArcNewMsg(ID_Obj,446+$4000,7);
        msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ ��������� ������� ������ ��������
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ ��� ������� ��� ������ - ���������� �������
          InsArcNewMsg(ID_Obj,446+$4000,1);
          msg := msg + '! ' + GetShortMsg(1,446, ObjZav[ID_Obj].Liter,1);
        end else
        begin //--------------------------------------------------------- �������� �������
          InsArcNewMsg(ID_Obj,218+$4000,7);
          msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
        end;
      end;
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    begin //------------------------------- ��� �� - ��������� ������� �������� �� �������
      if ObjZav[ID_Obj].bParam[3] then
      begin //--------------------------------------------------------------------- ��� ��
        if VytajkaRM(ID_Obj) then
        begin
          if MarhTracert[1].WarCount > 0 then
          begin
            MessCount :=Marhtracert[1].WarCount;//����� ����������. ��� ��������� ��������
            MessObj :=  MarhTracert[1].WarObject[MessCount];//������ �����. ��������������
            WarObj := MarhTracert[1].WarIndex[MessCount];//������ ��������� ��������������
            InsArcNewMsg(MessObj,WarObj + $5000,1);
            msg := MarhTracert[1].Warning[MessCount];
            dec (Marhtracert[1].WarCount);
            DspCommand.Command := CmdManevry_ReadyWar;
            DspCommand.Obj := ID_Obj;
          end else
          begin
            InsArcNewMsg(ID_Obj,217+$4000,7);
            msg := GetShortMsg(1,217, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_DatRazreshenieManevrov;
            DspCommand.Obj := ID_Obj;
          end;
        end else
        begin //-------------------------- ������� ��������� �� ������ �������� �� �������
          InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]+$4000,7);
          PutShortMsg(1,LastX,LastY,MarhTracert[1].Msg[1]);
          exit;
        end;
      end else
      begin //-------------------------------------------------------------------- ���� ��
        InsArcNewMsg(ID_Obj,448+$4000,7);
        msg := GetShortMsg(1,448, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_DatRazreshenieManevrov;
        DspCommand.Obj := ID_Obj;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ �������� ���� ��� ������� "��������� �������"
function CreateDspMenu_ZamykanieStrelok(ID,X,Y : SmallInt): boolean;
begin //---------------------------------------------------------------- ��������� �������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,7);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,7);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0; exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
     if WorkMode.OtvKom then
     begin //------------------------------------ ������ �� - ���������� ������������ �������
        InsArcNewMsg(ID_Obj,283+$4000,1);
        ResetCommands;
        ShowShortMsg(283,LastX,LastY,'');
        msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
        exit;
     end else
    begin //-------------------------------------------------------------------- ���������
      InsArcNewMsg(ID_Obj,189+$4000,1);
      msg := GetShortMsg(1,189, ObjZav[ID_Obj].Liter,1);
      DspCommand.Command := CmdMenu_ZamykanieStrelok;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//----------------------------------------- �������� ���� ��� ������� "���������� �������"
function CreateDspMenu_RazmykanieStrelok(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,191+$4000,7);
        msg := GetShortMsg(1,191, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolRazmykanStrelok;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsArcNewMsg(ID_Obj,190+$4000,7);
        msg := GetShortMsg(1,190, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvRazmykanStrelok;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands; ShowShortMsg(276,LastX,LastY,'');
      ShowShortMsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------------------------------ ������� �������
function CreateDspMenu_ZakrytPereezd(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0; exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    InsArcNewMsg(ID_Obj,192+$4000,7);
    msg := GetShortMsg(1,192, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_ZakrytPereezd;
    DspCommand.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ �������� ���� ��� ������� "�������� ��������"
function CreateDspMenu_OtkrytPereezd(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //======================================================= �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,194+$4000,7);
        msg := GetShortMsg(1,194, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsArcNewMsg(ID_Obj,193+$4000,7);
        msg := GetShortMsg(1,193, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands;
      ShowShortMsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------------- �������� ���� ��� "��������� �� �������"
function CreateDspMenu_IzvesheniePereezd(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin // ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    result := false;
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if ObjZav[ID_Obj].bParam[11] then
    begin //-------------------------------------------------------------- ����� ���������
      InsArcNewMsg(ID_Obj,196+$4000,7);
      msg := GetShortMsg(1,196, ObjZav[ID_Obj].Liter,7);
      if ID <> IDMenu_IzvesheniePereezd1
      then DspCommand.Command := CmdMenu_SnatIzvecheniePereezd
      else DspCommand.Command := CmdMenu_SnatIzvecheniePereezd1;
      DspCommand.Obj := ID_Obj;
    end else
    begin //--------------------------------------------------------------- ���� ���������
      InsArcNewMsg(ID_Obj,195+$4000,7);
      msg := GetShortMsg(1,195, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_DatIzvecheniePereezd;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//---------------------------- �������� ���� ��� ���������� �������� "�������� ����������"
function CreateDspMenu_PoezdnoeOpoveshenie(ID,X,Y : SmallInt): boolean;
begin //-------------------------------------------------------------- �������� ����������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ObjZav[ID_Obj].TypeObj = 36 then bit_for_kom := 1
  else bit_for_kom := 2;
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin //---------------------------------- ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,283+$4000,1);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
      exit;
    end else
    if WorkMode.MarhOtm then
    begin //----------------------------------------------------- �������� ������ ��������
      WorkMode.MarhOtm := false;
      if ObjZav[ID_Obj].bParam[bit_for_kom] then
      begin //------------------------------------------------------- ��������� ����������
        InsArcNewMsg(ID_Obj,198+$4000,7);
        msg := '';
        if ObjZav[ID_Obj].bParam[bit_for_kom+1] or
        ObjZav[ID_Obj].bParam[bit_for_kom+2] then
        begin
          msg := GetShortMsg(1,309,'',7);
//          SingleBeep := true;
        end;
        msg := msg + GetShortMsg(1,198, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_SnatOpovechenie;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin
      if ObjZav[ID_Obj].bParam[bit_for_kom] then
      begin //------------------------------------------------------- ��������� ����������
        InsArcNewMsg(ID_Obj,198+$4000,7);
        msg := '';
        if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
        begin
          msg := GetShortMsg(1,309,'',7);
//          SingleBeep := true;
        end;
        msg := msg + GetShortMsg(1,198, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_SnatOpovechenie;
        DspCommand.Obj := ID_Obj;
      end else
      begin //-------------------------------------------------------- �������� ����������
        InsArcNewMsg(ID_Obj,197+$4000,7);  //----------------------- �������� ���������� ?
        msg := GetShortMsg(1,197, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_DatOpovechenie;
        DspCommand.Obj := ID_Obj;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------- �������� ���� ��� ���������� �������� "������ ��������"
function CreateDspMenu_ZapretMonteram(ID,X,Y : SmallInt): boolean;
begin// ������ ��������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,7);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,7);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom or (not ObjZav[ID_Obj].bParam[1]) then
    begin
      if ObjZav[ID_Obj].ObjConstB[1] then
      begin
        if ObjZav[ID_Obj].bParam[2] then
        begin
          if not ObjZav[ID_Obj].bParam[1] then
          begin //---------------------------------------------- ��������� ������ ��������
            InsArcNewMsg(ID_Obj,200+$4000,7);
            msg := GetShortMsg(1,200, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_SnatZapretMonteram;
            DspCommand.Obj := ID_Obj;
          end else
          begin //----------------------------------------------- �������� ������ ��������
            InsArcNewMsg(ID_Obj,199+$4000,7);
            msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_DatZapretMonteram;
            DspCommand.Obj := ID_Obj;
          end;
        end else
        begin //------------------------- ���������� ��������� - ������ ��������� ��������
          InsArcNewMsg(ID_Obj,483+$4000,1);
          ShowShortMsg(483,LastX,LastY,'');
          exit;
        end;
      end else
      begin
        if ObjZav[ID_Obj].bParam[1] then
        begin //------------------------------------------------ ��������� ������ ��������
          InsArcNewMsg(ID_Obj,200+$4000,7);
          msg := GetShortMsg(1,200, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_SnatZapretMonteram;
          DspCommand.Obj := ID_Obj;
        end else
        begin //------------------------------------------------- �������� ������ ��������
          InsArcNewMsg(ID_Obj,199+$4000,7);
          msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_DatZapretMonteram;
          DspCommand.Obj := ID_Obj;
        end;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands; ShowShortMsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//------------------------------ �������� ���� ��� ���������� ����������� ������� ��������
function CreateDspMenu_Otkl_ZapretMonteram(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //======================================================= �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- �������������� �������
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,528+$4000,7);
        msg := GetShortMsg(1,528, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- ��������������� �������
        InsArcNewMsg(ID_Obj,527+$4000,7);
        msg := GetShortMsg(1,527, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands;
      SimpleBeep;
      msg := GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      ShowShortMsg(276,LastX,LastY,'');
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------------------- �������� ���� ��� ���������� �����
function CreateDspMenu_VykluchenieUKSPS(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end;
  //--------------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- �������������� �������
      OtvCommand.SObj := ID_Obj;
      InsArcNewMsg(ID_Obj,202+$4000,7);
      msg := GetShortMsg(1,202, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_IspolOtkluchenieUKSPS;
      DspCommand.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- ���� 1-�� ��� 2-�� ������
    //if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
    begin //------------------------------------- �������� ����� - ��������������� �������
      InsArcNewMsg(ID_Obj,201+$4000,7);
      msg := GetShortMsg(1,201, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_PredvOtkluchenieUKSPS;
      DspCommand.Obj := ID_Obj;
    end;
  end
  else
  begin //--------------------------------------- �� ������ �� - �������� ���������� �����
    if ObjZav[ID_Obj].bParam[1] and ObjZav[ID_Obj].ObjConstB[1] then
    begin //--------------- ���� ������� ������ � ����� ������������ - �������� ����������
      InsArcNewMsg(ID_Obj,353+$4000,1);
      msg := GetShortMsg(1,353, ObjZav[ID_Obj].Liter,1);
      DspCommand.Command := CmdMenu_OtmenaOtkluchenieUKSPS;
      DspCommand.Obj := ID_Obj;
    end else
    begin
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands;
      ShowShortMsg(276,LastX,LastY,'');
      SimpleBeep;
      msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------- �������� ���� ��� ���������� �������� "��������������� �����"
function CreateDspMenu_VspomPriem(ID,X,Y : SmallInt): boolean;
begin //------------------------------------------------------------ ��������������� �����
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //-------------------------------------------------- �������������� ������� ��
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,211+$4000,7);
        msg := GetShortMsg(1,211, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolVspomPriem;
        DspCommand.Obj := ID_Obj;
      end else
      begin
        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[6] then //����-���� �������� � �������
        begin //----------------------------------------------- ��������������� ������� ��
          InsArcNewMsg(ID_Obj,210+$4000,7);
          msg := GetShortMsg(1,210, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_PredvVspomPriem;
          DspCommand.Obj := ID_Obj;
        end else
        begin //----------------------------------------------------- �� ����� �� ��������
          InsArcNewMsg(ID_Obj,337+$4000,1);
          ShowShortMsg(357,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end;
    end else
    begin //------------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands;
      ShowShortMsg(276,LastX,LastY,'');
      msg := GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      SimpleBeep;
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------- �������� ���� ��� ������� "��������������� �����������"
function CreateDspMenu_VspomOtpravlenie(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //-------------------------------------------------- �������������� ������� ��
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,209+$4000,7);
        msg := GetShortMsg(1,209, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolVspomOtpravlenie;
        DspCommand.Obj := ID_Obj;
      end else
      begin //--------------------------------------------------------------- ��������� ��
        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[6] then //����-���� �������� � �������
        begin //----------------------------------------------- ��������������� ������� ��
          InsArcNewMsg(ID_Obj,208+$4000,7);
          msg := GetShortMsg(1,208, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_PredvVspomOtpravlenie;
          DspCommand.Obj := ID_Obj;
        end else
        begin //----------------------------------------------------- �� ����� �� ��������
          InsArcNewMsg(ID_Obj,357+$4000,1);
          ShowShortMsg(357,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end;
    end else
    begin //----------------------------- �� ������ �� - ���������� ������������ �������
      InsArcNewMsg(ID_Obj,276+$4000,1);
      ResetCommands;
      ShowShortMsg(276,LastX,LastY,'');
      msg := GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
      SimpleBeep;
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------- �������� ���� ��� ������� "������� �������"
function CreateDspMenu_OchistkaStrelok(ID,X,Y : SmallInt): boolean;
begin //------------------------------------------------------------------ ������� �������
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}  ID_ViewObj := ID_Obj; exit;  {$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      InsArcNewMsg(ID_Obj,283+$4000,1);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
      exit;
    end else
    begin
      if ObjZav[ID_Obj].bParam[1] then
      begin //------------------------------------------------------------ �������� ������
        InsArcNewMsg(ID_Obj,5+$4000,7);
        msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
        DspCommand.Command := CmdMenu_OtklOchistkuStrelok;
        DspCommand.Obj := ID_Obj;
      end else
      begin //-------------------------------------------------------------- ������ ������
        InsArcNewMsg(ID_Obj,4+$4000,7);
        msg := MsgList[ObjZav[ID_Obj].ObjConstI[4]];
        DspCommand.Command := CmdMenu_VkluchOchistkuStrelok;
        DspCommand.Obj := ID_Obj;
      end;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------------- ��������� �������� ������� ���1
function CreateDspMenu_VkluchenieGRI1(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then //--------------------------------- ���� ������������� �������
    begin //--------------------------------------------------------------- ������ �������
      if ObjZav[ID_Obj].bParam[2] then
      begin //----------------------------------- ��� �������� �������� ������� �� - �����
        InsArcNewMsg(ID_Obj,335+$4000,1);
        ShowShortMsg(335,LastX,LastY,ObjZav[ID_Obj].Liter);
//        SingleBeep := true;
        exit;
      end else
      begin //------------------------------------------------------------- ������ �������
        msg := '';
        if ObjZav[ID_Obj].ObjConstI[3] <> 0 then
        begin
          //--------------------------------- �� ������� ������ ��� ��,���� ��������������
          InsArcNewMsg(ID_Obj,214+$4000,7);
          if not ObjZav[ID_Obj].bParam[3] then msg := GetShortMsg(1,264,'',1) + ' ';
        end;
        msg := msg + GetShortMsg(1,214, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_VkluchenieGRI;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //----------------------------------------------------- �� ������������� �������
      InsArcNewMsg(ID_Obj,263+$4000,1);
      ShowShortMsg(263,LastX,LastY,'');
//      SingleBeep := true;
      exit;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------- ������� ��������� �� ������, ���� ��� ����������
function CreateDspMenu_PutManevrovyi(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------- �� - ������������� �������� ����������� ��� ����
    InsArcNewMsg(ID_Obj,311+$4000,7);
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ID_Obj;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  if ObjZav[ID_Obj].bParam[19] then
  begin //------------------------------------------ ���������� ���������������� ���������
    ObjZav[ID_Obj].bParam[19] := false;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if ObjZav[ID_Obj].bParam[13] then
    begin
      InsArcNewMsg(ID_Obj,171+$4000,7);
      msg := GetShortMsg(1,171, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_PutOtkrytDvijenie;
      DspCommand.Obj := ID_Obj;
    end else
    begin
      InsArcNewMsg(ID_Obj,170+$4000,7);
      msg := GetShortMsg(1,170, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_PutZakrytDvijenie;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------- ������� ���� ����������
function CreateDspMenu_RezymPitaniyaLamp(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if not WorkMode.OtvKom then
  begin //--------------------------------- �� ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,276+$4000,1); //- �������� ������� ������� ������ ��������. ������
    ResetCommands;
    SimpleBeep;
    ShowShortMsg(276,LastX,LastY,'');
    msg := GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1); //-- "�������� �������� ������� ������ ���.��������"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    msg := GetShortMsg(1,149, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- ��� ��������� ������� �� ����� ���
  begin                                     //--------- ������ � ������������� ��� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);//------------------------------------ "��� �� �������"
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //-------------------------------- ��� ������ ������ ��������
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin
    if not ObjZav[ID_Obj].bParam[1]  then
    begin
      InsArcNewMsg(ID_Obj,546+$4000,7);   //------------------------ "�������� ����� ���?"
      msg := GetShortMsg(1,546,'',7);
      DspCommand.Command := CmdMenu_VklDSN;
    end else
    begin
      InsArcNewMsg(ID_Obj,547+$4000,7);   //----------------------- "��������� ����� ���?"
      msg := GetShortMsg(1,547,'',7);
      DspCommand.Command := CmdMenu_OtklDSN;
    end;
    DspCommand.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------------------- ��������� �������� ������
function CreateDspMenu_RezymLampDen(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);     //--------------------------- "������ ������ ��"
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1); //--- "�������� �������� ������� ������ ���.�������"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      InsArcNewMsg(ID_Obj,283+$4000,7);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,7);
      exit;
    end else
    begin
      InsArcNewMsg(ID_Obj,221+$4000,7);   //------------------- "�������� ������� ����� ?"
      msg := GetShortMsg(1,221, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_VkluchitDen;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------------- ��������� ������� ������
function CreateDspMenu_RezymLampNoch(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      InsArcNewMsg(ID_Obj,283+$4000,7);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');   //----------- ������ ������ ������������� ������
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,7);
      exit;
    end else
    begin
      InsArcNewMsg(ID_Obj,222+$4000,7);
      msg := GetShortMsg(1,222, ObjZav[ID_Obj].Liter,7);// �������� ������ ����� (������)?
      DspCommand.Command := CmdMenu_VkluchitNoch;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------------- ��������� ��������������� ������
function CreateDspMenu_RezymLampAuto(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    result := false;
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      InsArcNewMsg(ID_Obj,283+$4000,1);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
      exit;
    end else
    begin
      InsArcNewMsg(ID_Obj,223+$4000,7);
      msg := GetShortMsg(1,223, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_VkluchitAuto;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//--------------------------------------------------------- ���������� ��� �� ������������
function CreateDspMenu_OtklUKG(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end;
  //--------------------------------------------------------------------- ���������� �����
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- �������������� �������
      OtvCommand.SObj := ID_Obj;
      InsArcNewMsg(ID_Obj,565+$4000,7);
      msg := GetShortMsg(1,565, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_IspolOtkluchenieUKG;
      DspCommand.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- ���� 1-�� ��� 2-�� ������
    //if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
    begin //------------------------------------- �������� ��� - ��������������� �������
      InsArcNewMsg(ID_Obj,564+$4000,7);
      msg := GetShortMsg(1,564, ObjZav[ID_Obj].Liter,7);
      ShowShortMsg(564,LastX,LastY,'');
      DspCommand.Command := CmdMenu_PredvOtkluchenieUKG;
      DspCommand.Obj := ID_Obj;
    end;
  end
  else
  begin //------------------------------------------------ �� ������ �� - �������� �������
    InsArcNewMsg(ID_Obj,276+$4000,1);
    ResetCommands;
    msg := GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
    SimpleBeep;
    ShowShortMsg(276,LastX,LastY,'');
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//------------------------------------------------------------ ��������� ��� � �����������
function CreateDspMenu_VklUKG(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    result := false;
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    if WorkMode.OtvKom then
    begin
      InsArcNewMsg(ID_Obj,283+$4000,1);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
      exit;
    end else
    begin
      InsArcNewMsg(ID_Obj,563+$4000,7);
      msg := GetShortMsg(1,563, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtmenaOtkluchenieUKG ;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------- ���������� ������ �����
function CreateDspMenu_OtklZvonkaUKSPS(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ ������ �� - ���������� ������������ �������
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,''); exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ ����� ���������������� ��������
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- �������� ������ ��������
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- ��� �� �������
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ �������� ����� ��������
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- ���������� �����
    InsArcNewMsg(ID_Obj,203+$4000,7);
    msg := GetShortMsg(1,203, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_OtklZvonkaUKSPS;
    DspCommand.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//---------------------------------------------------------------------- ������������ ����
procedure MakeMenu(var X : smallint);
var
  i,j : integer;
begin   //------------------------------------------------------------ ������������ ����
{$IFDEF RMDSP}
  if DspMenu.Count > 0 then //---------------------------------- ���� ���� ���-�� ��� ����
  begin
    TabloMain.PopupMenuCmd.Items.Clear; //---------------------------- �������� ���� �����
    for i := 1 to DspMenu.Count
    do TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//����� ���� �� DspMenu
    i := configRU[config.ru].Tablo_Size.Y - 10;
    SetCursorPos(x,i);
    TabloMain.PopupMenuCmd.Popup(X, i+3-17*DspMenu.Count);
  end  else
  begin //---------------------------- ������� ��������� ����� ����������� ������� �������
    j := x div configRU[config.ru].MonSize.X + 1; //-------------------- ����� ����� �����
    for i := 1 to Length(shortMsg) do
    begin
      if i = j then //--------- ���� ��� �� �����, ������� ������������� ������ ����������
      begin
        shortMsg[i] := msg;
        shortMsgColor[i] := GetColor1(7);
      end
      else   shortMsg[i] := '';
    end;
  end;
{$ENDIF}
end;

end.
