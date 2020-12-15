unit Commands;
//------------------------------------------------------------------------------
//
//  ������� ����������
//
//------------------------------------------------------------------------------

{$INCLUDE CfgProject}

interface

{$IFDEF RMDSP}
function Cmd_ChangeMode(mode : integer) : boolean;
function WorkModeCalc: smallint;
procedure GoWaitOtvCommand(const Obj,BitFR3,CmdSecond : Word);
function CheckOtvCommand(Obj : SmallInt) : Boolean;
function SendDoubleToSrv(Param : int64; Cmd : Byte; Index : Word) : Boolean;
function SelectCommand : boolean;
function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
{$ENDIF}
{$IFDEF RMSHN}
function SelectCommand : boolean;
function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
{$ENDIF}
{$IFDEF RMARC}
function SelectCommand : boolean;
function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
procedure CmdMsg(cmd,ifr,index : word);
{$ENDIF}

const
// ������ ��������� ������ ����������
  CmdMarsh_Tracert          = 1101;
  CmdMarsh_Ready            = 1102;
  CmdMarsh_Manevr           = 1103;
  CmdMarsh_Poezd            = 1104;
  CmdMarsh_Povtor           = 1105;
  CmdMarsh_Razdel           = 1106;
  CmdMarsh_RdyRazdMan       = 1107;
  CmdMarsh_RdyRazdPzd       = 1108;
  CmdManevry_ReadyWar       = 1109;
  CmdMarsh_ResetTraceParams = 1110;
  CmdMarsh_PovtorMarh       = 1111;
  CmdMarsh_PovtorOtkryt     = 1112;
  CmdStr_ReadyPerevodPlus   = 1201;
  CmdStr_ReadyPerevodMinus  = 1202;
  CmdStr_ReadyVPerevodPlus  = 1203;
  CmdStr_ReadyVPerevodMinus = 1204;
  CmdStr_ReadyMPerevodPlus  = 1205;
  CmdStr_ReadyMPerevodMinus = 1206;
  CmdStr_AskPerevod         = 1207;
  CmdStr_ResetMaket         = 1208;

// ������ ����� ������ FR3
cmdfr3_ispiskrazmyk         = 1;
cmdfr3_isprazmykstr         = 2;
cmdfr3_isppereezdotkr       = 3;
//cmdfr3_ispopovvtkl          = 4;
cmdfr3_ispopovzaprotkl      = 5;
cmdfr3_ispukspsotkl         = 6;
cmdfr3_ispvspotpr           = 7;
cmdfr3_ispvsppriem          = 8;
cmdfr3_ispmanevryri         = 9;
cmdfr3_isppabiskpribytie    = 10;
cmdfr3_otklupr              = 31;
cmdfr3_vklupr               = 32;
cmdfr3_blokirov             = 33;
cmdfr3_razblokir            = 34;
cmdfr3_blokirov2            = 35;
cmdfr3_razblokir2           = 36;
cmdfr3_ustmaket             = 37;
cmdfr3_snatmaket            = 38;
cmdfr3_strplus              = 41;
cmdfr3_strminus             = 42;
cmdfr3_strvspplus           = 43;
cmdfr3_strvspminus          = 44;
cmdfr3_svotkrmanevr         = 45;
cmdfr3_svotkrpoezd          = 46;
cmdfr3_svzakrmanevr         = 47;
cmdfr3_svzakrpoezd          = 48;
cmdfr3_svpovtormanevr       = 49;
cmdfr3_svpovtorpoezd        = 50;
cmdfr3_svustlogic           = 51;
cmdfr3_svotmenlogic         = 52;
cmdfr3_putustograd          = 53;
cmdfr3_logoff               = 54;
cmdfr3_zamykstr             = 55;
cmdfr3_pereezdzakryt        = 56;
cmdfr3_pereezdvklizv        = 57;
cmdfr3_pereezdotklizv       = 58;
cmdfr3_opovvkl              = 59;
cmdfr3_opovzaprvkl          = 60;
cmdfr3_ukspsotklzvon        = 61;
cmdfr3_absmena              = 62;
cmdfr3_absoglasie           = 63;
cmdfr3_knopka1vkl           = 64;
cmdfr3_knopka1otkl          = 65;
cmdfr3_grivkl               = 66;
cmdfr3_upzaprospoezdvkl     = 67;
cmdfr3_upzaprospoezdotkl    = 68;
cmdfr3_upzaprosmanevrvkl    = 69;
cmdfr3_upzaprosmanevrotkl   = 70;
cmdfr3_manevryrm            = 71;
cmdfr3_manevryotmen         = 72;
cmdfr3_dnkden               = 73;
cmdfr3_dnknocth             = 74;
cmdfr3_dnkauto              = 75;
cmdfr3_pabsoglasievkl       = 76;
cmdfr3_pabsoglasieotkl      = 77;
cmdfr3_pabpribytie          = 78;
cmdfr3_directdef            = 79;
cmdfr3_directmanual         = 80;
cmdfr3_strmakplus           = 81;
cmdfr3_strmakminus          = 82;
cmdfr3_strvspmakplus        = 83;
cmdfr3_strvspmakminus       = 84;
cmdfr3_resettrace           = 85;
cmdfr3_opovotkl             = 86;
cmdfr3_knopka2vkl           = 87;
cmdfr3_knopka2otkl          = 88;
cmdfr3_knopka3vkl           = 89;
cmdfr3_knopka3otkl          = 90;
cmdfr3_knopka4vkl           = 91;
cmdfr3_knopka4otkl          = 92;
cmdfr3_knopka5vkl           = 93;
cmdfr3_knopka5otkl          = 94;
cmdfr3_svprotjagmanevr      = 95;
cmdfr3_restartservera       = 96;
cmdfr3_restartuvk           = 97;
cmdfr3_otmenablokUksps      = 98;
cmdfr3_repmanevrmarsh       = 99;
cmdfr3_reppoezdmarsh        = 100;
cmdfr3_autodatetime         = 101;
cmdfr3_newdatetime          = 102;
cmdfr3_vklksn               = 103;
cmdfr3_otklksn              = 104;
cmdfr3_vklOPI               = 105;
cmdfr3_otklOPI              = 106;
cmdfr3_strautorun           = 107;
cmdfr3_svotkrauto           = 108;
cmdfr3_automarshvkl         = 109;
cmdfr3_automarshotkl        = 110;
cmdfr3_povtorotkrytmanevr   = 111;
cmdfr3_povtorotkrytpoezd    = 112;
cmdfr3_otmenasogsnab        = 113;
cmdfr3_strzakrytprotivosh   = 114;
cmdfr3_strotkrytprotivosh   = 115;
cmdfr3_strzakryt2protivosh  = 116;
cmdfr3_strotkryt2protivosh  = 117;
cmdfr3_blokirovET           = 118;
cmdfr3_razblokirET          = 119;
cmdfr3_blokirovETA          = 120;
cmdfr3_razblokirETA         = 121;
cmdfr3_blokirovETD          = 122;
cmdfr3_razblokirETD         = 123;
cmdfr3_otkldnkauto          = 124;
cmdfr3_rescueotu            = 125;

cmdfr3_ustanovkastrelok     = 187;
cmdfr3_povtormarhmanevr     = 188;
cmdfr3_povtormarhpoezd      = 189;
cmdfr3_marshrutlogic        = 190;
cmdfr3_marshrutmanevr       = 191;
cmdfr3_marshrutpoezd        = 192;
cmdfr3_predviskrazmyk       = 193;
cmdfr3_predvrazmykstr       = 194;
cmdfr3_predvpereezdotkr     = 195;
//cmdfr3_predvopovotkl        = 196;
cmdfr3_predvopovzaprotkl    = 197;
cmdfr3_predvukspsotkl       = 198;
cmdfr3_predvvspotpr         = 199;
cmdfr3_predvvsppriem        = 200;
cmdfr3_predvmanevryri       = 201;
cmdfr3_predvpabiskpribytie  = 202;
cmdfr3_kvitancija           = 224;


implementation

uses
  Windows,
  Forms,
{$IFDEF RMARC}
  PackArmSrv,
{$ELSE}
  KanalArmSrv,
{$ENDIF}
{$IFDEF RMDSP}
  TimeInput,
{$ENDIF}
  Dialogs,
  SysUtils,
  VarStruct,
  Commons,
  Marshrut,
  CMenu,
  TabloForm,
  Controls;

{$IFDEF RMDSP}
var
  s : string;

//------------------------------------------------------------------------------
// ��������� ������� ��������� ������ ������ � ������ �������� ���������� � ����������
function Cmd_ChangeMode(mode : integer) : boolean;
begin
  {�������� ������������� ������������� �������}

  case mode of
    KeyMenu_RazdeRejim : begin // ���������� ����������
      ResetTrace; // �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.RazdUpr := true;
      WorkMode.MarhUpr := false;
      WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := false;
      InsNewArmCmd($7ff9,0);
      result := true;
    end;
    KeyMenu_MarshRejim : begin // ���������� ����������
      ResetTrace; // �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.RazdUpr := false;
      WorkMode.MarhUpr := true;
      WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := false;
      InsNewArmCmd($7ff8,0);
      result := true;
    end;
    KeyMenu_OtmenMarsh : begin // ���������/���������� ������ ������ ��������
      ResetTrace; // �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.MarhOtm := not WorkMode.MarhOtm;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := false;
      if WorkMode.MarhOtm then
      begin
        InsNewArmCmd($7ff7,0);
        InsArcNewMsg(0,93);
        ShowShortMsg(93,LastX,LastY,'');
      end else
        InsNewArmCmd($7ff6,0);
      result := true;
    end;
    KeyMenu_InputOgr : begin // ���������/���������� ������ ����� �����������
      ResetTrace; // �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := not WorkMode.InpOgr;
      if WorkMode.InpOgr then
      begin
        InsNewArmCmd($7ff5,0);
        InsArcNewMsg(0,94);
        ShowShortMsg(94,LastX,LastY,'');
      end else
        InsNewArmCmd($7ff4,0);
      result := true;
    end;
    KeyMenu_VspPerStrel : begin // ���������/���������� ������ ���������������� �������� �������
      ResetTrace; // �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.RazdUpr := true;
      WorkMode.MarhUpr := false;
      WorkMode.MarhOtm := false;
      WorkMode.InpOgr  := false;
      WorkMode.VspStr  := not WorkMode.VspStr;
      if WorkMode.VspStr then
      begin
        InsArcNewMsg(0,88); ShowShortMsg(88,LastX,LastY,'');
      end else
      begin
        InsArcNewMsg(0,95); ShowShortMsg(95,LastX,LastY,''); VspPerevod.Active := false;
      end;
      result := true;
    end;
    KeyMenu_EndTrace : begin // ����� ������ ��������
      WorkMode.GoMaketSt := false;
      // ����� �������������
      if MarhTracert[1].MsgCount > 1 then
      begin
        dec(MarhTracert[1].MsgCount); CreateDspMenu(KeyMenu_ReadyResetTrace,LastX,LastY); DspMenu.WC := true; result := true;
      end else
      if MarhTracert[1].MsgCount = 1 then
      begin // �������� �����
        ResetTrace; result := true;
      end else
      // ����� ��������������
      if (MarhTracert[1].WarCount > 0) and ((MarhTracert[1].ObjEnd > 0) or (MarhTracert[1].FullTail)) then
      begin
        dec(MarhTracert[1].WarCount);
        if MarhTracert[1].WarCount > 0 then
        begin
          SingleBeep := true; TimeLockCmdDsp := LastTime; LockCommandDsp := true; ShowWarning := true;
          CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
        end else
        begin
          CreateDspMenu(CmdMarsh_Ready,LastX,LastY);
        end;
        result := true;
      end else
      if WorkMode.MarhUpr and WorkMode.GoTracert then
      begin // ��������� ����������� �������� � ������������ �������
        if EndTracertMarshrut then //  ��������� ����� ������ ��������
        begin // ������������ ������ ��������� ��������
          if MarhTracert[1].WarCount > 0 then
          begin // ����� ��������������
            SingleBeep := true; TimeLockCmdDsp := LastTime; LockCommandDsp := true; ShowWarning := true;
            CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
          end else
          begin
            CreateDspMenu(CmdMarsh_Ready,LastX,LastY);
          end;
        end else
        begin // ������ ��������������, ��� �������� ����� �������� ������� �������
          CreateDspMenu(KeyMenu_EndTraceError,LastX,LastY);
        end;
        result := true;
      end else
      begin
        ResetShortMsg; result := false;
      end;
    end;
    KeyMenu_PodsvetkaStrelok : begin //   = 1021; // ������ ��������� ��������� �������
      WorkMode.GoMaketSt := false;
      WorkMode.Podsvet := not WorkMode.Podsvet;
      if WorkMode.Podsvet then
      begin
        InsNewArmCmd($7ff3,0);
      end else
        InsNewArmCmd($7ff2,0);
      result := true;
    end;
    KeyMenu_VvodNomeraPoezda : begin //    = 1022; // ������ ����� ������ ������
      WorkMode.GoMaketSt := false;

      WorkMode.InpTrain := not WorkMode.InpTrain;
      if WorkMode.InpTrain then
      begin
        InsNewArmCmd($7ff1,0);
      end else
        InsNewArmCmd($7ff0,0);
      result := true;
    end;
    KeyMenu_PodsvetkaNomerov : begin //    = 1023; // ������ ��������� ������ �������
      WorkMode.GoMaketSt := false;
      WorkMode.NumTrain := not WorkMode.NumTrain;
      if WorkMode.NumTrain then
      begin
        InsNewArmCmd($7fef,0);
      end else
        InsNewArmCmd($7fee,0);
      result := true;
    end;

  else
    result := false;
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------
// ��������� ������� ����������
function SelectCommand : boolean;
  {$IFDEF RMDSP} var i,o,p : integer; {$ENDIF}
begin
  // ����� ���������� ����/�������
  DspMenu.Ready := false; DspMenu.WC := false; DspMenu.obj := -1; ShowWarning := false;

{$IFDEF RMDSP}
// ��������� ����� ������� � �����
  if (DspCommand.obj > 0) and (DspCommand.Command > 0) then
    InsNewArmCmd(DspCommand.obj+$4000,DspCommand.Command);

//
// ��������� ������ � ������ ���������� �������� �����
//

  if DspCommand.Active then
  begin
    case DspCommand.Command of

      // ������� ������ ������ ������ ��-���, ������ ������� ������ � ����������
      KeyMenu_RazdeRejim,
      KeyMenu_MarshRejim,
      KeyMenu_OtmenMarsh,
      KeyMenu_InputOgr,
      KeyMenu_VspPerStrel,
      KeyMenu_PodsvetkaStrelok,
      KeyMenu_VvodNomeraPoezda,
      KeyMenu_PodsvetkaNomerov,
      KeyMenu_EndTrace : begin // ��������� ������� ������ ���� �����
        result := Cmd_ChangeMode(DspCommand.Command); exit;
      end;

      CmdMenu_Osnovnoy :
      begin // ������ �� ��������� ������ ������
//��� ��������        WorkMode.Upravlenie := true;
        InsNewArmCmd($7fed,0);
        SendCommandToSrv(WorkMode.DirectStateSoob,cmdfr3_directmanual,0);
        result := true;
        exit;
      end;

      CmdMenu_RU1 :
      begin
        {��������� ����������� ��������� ������ ������ ��-���}
        InsNewArmCmd($7fec,0);
        shiftscr := 0; config.ru := 1; SetParamTablo; result := true; exit;
      end;

      CmdMenu_RU2 :
      begin
        {��������� ����������� ��������� ������ ������ ��-���}
        InsNewArmCmd($7feb,0);
        shiftscr := 0; config.ru := 2; SetParamTablo; result := true; exit;
      end;

      CmdMenu_ResetCommandBuffers : {?}
      begin
        InsNewArmCmd($7fea,0);
        CmdCnt := 0;                  // ����� ���������� ������ � �����������
        WorkMode.MarhRdy := false; // ����� ���������� �������
        WorkMode.CmdReady := false;   // ����� ���������� �� �� �������� ���������
        result := true; exit;
      end;

      CmdMenu_RestartServera :
      begin
        CreateDspMenu(KeyMenu_ReadyRestartServera,LastX,LastY); result := true; exit;
      end;

      KeyMenu_RezervARM :
      begin // ������� ���� � ������
        InsNewArmCmd($7fe9,0);
        if WorkMode.Upravlenie then
        begin // ��� �������� �����������
          if ((StateRU and $40) = 0) or WorkMode.BU[0] then
          begin // ����� �� ��� �������� ������
            WorkMode.Upravlenie := false; StDirect := false; ChDirect := true;
          end;
        end;
      end;

      KeyMenu_ReadyRestartServera :
      begin
        if SendCommandToSrv(WorkMode.ServerStateSoob,cmdfr3_restartservera,0) then
        begin
          IncrementKOK;
          InsArcNewMsg(0,$2000+349); AddFixMessage(GetShortMsg(1,349,''),4,2); ResetShortMsg; SendRestartServera := true;
        end;
        result := true; exit;
      end;

      CmdMenu_RestartUVK :
      begin
        IndexFR3IK := DspCommand.Obj; CreateDspMenu(KeyMenu_ReadyRestartUVK,LastX,LastY); result := true; exit;
      end;

      KeyMenu_ReadyRestartUVK :
      begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_restartuvk,DspCommand.Obj) then
        begin
          IncrementKOK; InsArcNewMsg(DspCommand.Obj,$2000+350); AddFixMessage(GetShortMsg(1,350,ObjZav[DspCommand.Obj].Liter),4,2); ResetShortMsg;
        end;
        result := true; exit;
      end;

      CmdMenu_RescueOTU :
      begin
        IndexFR3IK := DspCommand.Obj; CreateDspMenu(KeyMenu_ReadyRescueOTU,LastX,LastY); result := true; exit;
      end;

      KeyMenu_ReadyRescueOTU :
      begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_rescueotu,DspCommand.Obj) then
        begin
          IncrementKOK; InsArcNewMsg(DspCommand.Obj,$2000+506); AddFixMessage(GetShortMsg(1,506,ObjZav[DspCommand.Obj].Liter),4,2); ResetShortMsg;
        end;
        result := true; exit;
      end;

      KeyMenu_ClearTrace : begin // ����� ����������� ��������, ������� ������ ������
        if CmdCnt > 0 then AddFixMessage(GetShortMsg(1,296,GetNameObjZav(CmdBuff.LastObj)),7,2);
        CmdCnt := 0;                  // ����� ���������� ������ � �����������
        WorkMode.MarhRdy := false; // ����� ���������� �������
        WorkMode.CmdReady := false;   // ����� ���������� �� �� �������� ���������
        ResetCommands;
        result := true; exit;
      end;


      KeyMenu_DateTime : begin // ���� ������� ��-���
        ResetTrace; // �������� �������� ������
        WorkMode.GoMaketSt := false; WorkMode.MarhOtm := false; WorkMode.VspStr := false; WorkMode.InpOgr := false;
        if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 /24) then
        begin
          InsArcNewMsg(0,188);
          ShowShortMsg(188,LastX,LastY,'');
          ShowWindow(Application.Handle,SW_SHOW);
          case TimeInputDlg.ShowModal of
            mrOk :
            begin
              DateTimeToString(s,'hh:mm:ss',NewTime);
              InsArcNewMsg(0,317);
              ShowShortMsg(317,LastX,LastY,s);
            end;
            mrNo :
            begin
              InsArcNewMsg(0,435);
              ShowShortMsg(435,LastX,LastY,'');
            end;
          else
            ResetShortMsg;
          end;
        end;
        ShowWindow(Application.Handle,SW_HIDE);
        result := true; exit;
      end;

      KeyMenu_BellOff : begin // ����� ������������ ������
        InsNewArmCmd($7fe8,0);
        sound := false; result := true; exit;
      end;

    end;
  end;





//
// �������� ������������ ������������ ������
//

  if not WorkMode.GoTracert then
  begin
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin
      InsNewArmCmd($7fff,0); ShowShortMsg(76,LastX,LastY,''); result := false; exit;
    end;

    if CmdCnt > 0 then
    begin // ����� ������ �������� - ���������� ������ �� ������������ ������
      InsNewArmCmd($7ffe,0); ShowShortMsg(251,LastX,LastY,''); result := false; exit;
    end;
  end;

  if DspCommand.Active then
  begin
    case DspCommand.Command of

      // ������� �� �������

// �������
      CmdMenu_StrPerevodPlus : begin
        WorkMode.InpOgr := false;
        if maket_strelki_index = ObjZav[DspCommand.Obj].BaseObject then
        begin CreateDspMenu(CmdStr_ReadyMPerevodPlus,LastX,LastY); end else
        begin CreateDspMenu(CmdStr_ReadyPerevodPlus,LastX,LastY); end;
      end;

      CmdMenu_StrPerevodMinus : begin
        WorkMode.InpOgr := false;
        if maket_strelki_index = ObjZav[DspCommand.Obj].BaseObject then
        begin CreateDspMenu(CmdStr_ReadyMPerevodMinus,LastX,LastY); end else
        begin CreateDspMenu(CmdStr_ReadyPerevodMinus,LastX,LastY); end;
      end;

      CmdStr_AskPerevod : begin // ������ �������� �������
        CreateDspMenu(CmdStr_AskPerevod,LastX,LastY);
      end;

      CmdStr_ReadyPerevodPlus : begin
        if WorkMode.VspStr then
        begin // ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus; VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000; VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin // ������� ������
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true;
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin // ��������� ���������� �������� ������� ��������������� ��������� (��� ��� ����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000);
          SingleBeep := true; ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strplus,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := true; ObjZav[DspCommand.Obj].bParam[23] := false;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,12);
          ShowShortMsg(12, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;

      CmdStr_ReadyPerevodMinus : begin
        if WorkMode.VspStr then
        begin // ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus; VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000; VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin // ������� ������
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true;
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin // ��������� ���������� �������� ������� ��������������� ��������� (��� ��� ����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000);
          SingleBeep := true; ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strminus,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := false; ObjZav[DspCommand.Obj].bParam[23] := true;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,13);
          ShowShortMsg(13, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;

      CmdStr_ReadyMPerevodPlus : begin
        if WorkMode.VspStr then
        begin // ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus; VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000; VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin // ������� ������
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true;
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin // ��������� ���������� �������� ������� ��������������� ��������� (��� ��� ����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000);
          SingleBeep := true; ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strmakplus,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := true; ObjZav[DspCommand.Obj].bParam[23] := false;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,20);
          ShowShortMsg(20, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;

      CmdStr_ReadyMPerevodMinus : begin
        if WorkMode.VspStr then
        begin // ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus; VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000; VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin // ������� ������
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true;
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin // ��������� ���������� �������� ������� ��������������� ��������� (��� ��� ����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000);
          SingleBeep := true; ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strmakminus,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := false; ObjZav[DspCommand.Obj].bParam[23] := true;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,21);
          ShowShortMsg(21, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;

      CmdStr_ReadyVPerevodPlus : begin
        if ObjZav[DspCommand.Obj].BaseObject = maket_strelki_index then
        begin // �� ������ ��������������� �������
          if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strvspmakplus,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := true; ObjZav[DspCommand.Obj].bParam[23] := false;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,14);
            ShowShortMsg(14, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end else
        begin // ��������������� �������
          if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strvspplus,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := true; ObjZav[DspCommand.Obj].bParam[23] := false;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,14);
            ShowShortMsg(14, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end;
      end;

      CmdStr_ReadyVPerevodMinus : begin
        if ObjZav[DspCommand.Obj].BaseObject = maket_strelki_index then
        begin // �� ������ ��������������� �������
          if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strvspmakminus,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := false; ObjZav[DspCommand.Obj].bParam[23] := true;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,15);
            ShowShortMsg(15, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end else
        begin // ��������������� �������
          if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_strvspminus,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := false; ObjZav[DspCommand.Obj].bParam[23] := true;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,15);
            ShowShortMsg(15, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end;
      end;

      CmdMenu_StrOtklUpravlenie : begin
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[18] := true;
        o := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[8];
        p := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[9];
        if (o > 0) and (p > 0) then
        begin
          if o = DspCommand.Obj then ObjZav[p].bParam[18] := true else
          if p = DspCommand.Obj then ObjZav[o].bParam[18] := true;
        end;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_otklupr,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,16);
          ShowShortMsg(16, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;

      CmdMenu_StrVklUpravlenie : begin
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[18] := false;
        o := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[8];
        p := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[9];
        if (o > 0) and (p > 0) then
        begin
          if o = DspCommand.Obj then ObjZav[p].bParam[18] := false else
          if p = DspCommand.Obj then ObjZav[o].bParam[18] := false;
        end;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_vklupr,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,17);
          ShowShortMsg(17, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;

      CmdMenu_StrZakrytDvizenie : begin
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[16] := true;
        if ObjZav[DspCommand.Obj].ObjConstB[6] then
        begin // �������
          i := cmdfr3_blokirov2;
        end else
        begin // �������
          i := cmdfr3_blokirov;
        end;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, i,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,18);
          ShowShortMsg(18, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_StrOtkrytDvizenie : begin
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[16] := false;
        if ObjZav[DspCommand.Obj].ObjConstB[6] then
        begin // �������
          i := cmdfr3_razblokir2;
        end else
        begin // �������
          i := cmdfr3_razblokir;
        end;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, i,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,452);
          ShowShortMsg(452, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_StrZakrytProtDvizenie : begin
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[17] := true;
        if ObjZav[DspCommand.Obj].ObjConstB[6] then
        begin // �������
          i := cmdfr3_strzakryt2protivosh;
        end else
        begin // �������
          i := cmdfr3_strzakrytprotivosh;
        end;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, i,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,451);
          ShowShortMsg(451, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_StrOtkrytProtDvizenie : begin
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[17] := false;
        if ObjZav[DspCommand.Obj].ObjConstB[6] then
        begin // �������
          i := cmdfr3_strotkryt2protivosh;
        end else
        begin // �������
          i := cmdfr3_strotkrytprotivosh;
        end;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, i,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,19);
          ShowShortMsg(19, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;




      CmdMenu_UstMaketStrelki : begin // ���������� ������� �� �����
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        WorkMode.GoMaketSt := false;
        for i := 1 to High(ObjZav) do
        begin                              //�������� ����������� ��������� �����
          if (ObjZav[i].RU = config.ru) and (ObjZav[i].TypeObj = 20) then
          begin
            if ObjZav[i].bParam[1] then
            begin // ��������� �������
              if not ObjZav[DspCommand.Obj].bParam[1] and not ObjZav[DspCommand.Obj].bParam[2] then
              begin // ��������� �������
                maket_strelki_index := ObjZav[DspCommand.Obj].BaseObject;
                ObjZav[maket_strelki_index].bParam[19] := true;
                maket_strelki_name  := ObjZav[maket_strelki_index].Liter;
                if SendCommandToSrv(ObjZav[maket_strelki_index].ObjConstI[2] div 8  , cmdfr3_ustmaket,maket_strelki_index) then
                begin
                  InsArcNewMsg(maket_strelki_index,10);
                  ShowShortMsg(10, LastX, LastY, ObjZav[maket_strelki_index].Liter);
                end;
              end else
              begin // ���� �������� ��������� - ����� �� ��������� �� �����
                InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,92);
                ResetShortMsg;
                AddFixMessage(GetShortMsg(1,92,ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter),4,1);
              end;
              break;
            end;
          end;
        end;
      end;

      CmdMenu_SnatMaketStrelki : begin // ����� ������� � ������
        WorkMode.InpOgr := false; WorkMode.GoMaketSt := false;
        if SendCommandToSrv(ObjZav[maket_strelki_index].ObjConstI[2] div 8, cmdfr3_snatmaket,maket_strelki_index) then
        begin
          InsArcNewMsg(maket_strelki_index,11); ShowShortMsg(11, LastX, LastY, maket_strelki_name);
          ObjZav[maket_strelki_index].bParam[19] := false;
          maket_strelki_index := 0; maket_strelki_name  := '';
        end;
      end;

      CmdStr_ResetMaket : begin // �������� ����� ������� � ������ ������� ������
        WorkMode.InpOgr := false; WorkMode.GoMaketSt := false;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8, cmdfr3_snatmaket,ObjZav[DspCommand.Obj].BaseObject) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,11); ShowShortMsg(11, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          ObjZav[ObjZav[DspCommand.Obj].BaseObject].bParam[19] := false;
        end;
      end;

// ���������
      CmdMarsh_RdyRazdMan : begin // ������ ������� ����������� �����������
        if SetProgramZamykanie(1) then
        begin
          ObjZav[DspCommand.Obj].bParam[34] := true;
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_svotkrmanevr,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,22);
            ShowShortMsg(22, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;

      CmdMarsh_RdyRazdPzd : begin // ������ ������� ����������� ���������
        if SetProgramZamykanie(1) then
        begin
          ObjZav[DspCommand.Obj].bParam[34] := true;
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_svotkrpoezd,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,23);
            ShowShortMsg(23, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;

      CmdMenu_OtkrytManevrovym : begin // ������ ����������� �����������
        WorkMode.InpOgr := false;
        if OtkrytRazdel(DspCommand.Obj,MarshM,1) then
          CreateDspMenu(CmdMarsh_RdyRazdMan,LastX,LastY);
      end;

      CmdMenu_OtkrytProtjag : begin // ������ ������� �������� ����������� ��� ��������
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_svprotjagmanevr,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,417);
          ShowShortMsg(417, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_OtkrytPoezdnym : begin // ������ ����������� ���������
        WorkMode.InpOgr := false;
        if OtkrytRazdel(DspCommand.Obj,MarshP,1) then
          CreateDspMenu(CmdMarsh_RdyRazdPzd,LastX,LastY);
      end;

      CmdMarsh_Razdel : begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_Razdel,LastX,LastY);
        end else
        begin // ������ ������� ����������� �������� �������
          if MarhTracert[1].Rod = MarshM then //��
          begin CreateDspMenu(CmdMarsh_RdyRazdMan,LastX,LastY); end else
          if MarhTracert[1].Rod = MarshP then //�
          begin CreateDspMenu(CmdMarsh_RdyRazdPzd,LastX,LastY); end;
        end;
      end;

      CmdMenu_OtmenaManevrovogo : begin
        WorkMode.MarhOtm := false; WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCommand.Obj,MarshM); //������ ������� ������ �����������
      end;

      CmdMenu_OtmenaPoezdnogo : begin
        WorkMode.MarhOtm := false; WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCommand.Obj,MarshP); // ������ ������� ������ ���������
      end;

      CmdMenu_PovtorManevrovogo : begin
        WorkMode.InpOgr := false;
        if PovtorSvetofora(DspCommand.Obj, MarshM,1) then
        begin // ������ �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_svpovtormanevr,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,26);
            ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;

      CmdMenu_PovtorPoezdnogo : begin
        WorkMode.InpOgr := false;
        if PovtorSvetofora(DspCommand.Obj, MarshP,1) then
        begin // ������ �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_svpovtorpoezd,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,27);
            ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;

      CmdMarsh_Povtor : begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_Povtor,LastX,LastY);
        end else
        begin // ������ ������� ���������� ��������
          if ObjZav[DspCommand.Obj].bParam[6] or ObjZav[DspCommand.Obj].bParam[7] then
          begin //��
            if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_svpovtormanevr,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,26);
              ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          if ObjZav[DspCommand.Obj].bParam[8] or ObjZav[DspCommand.Obj].bParam[9] then
          begin //�
            if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_svpovtorpoezd,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,27);
              ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
            ResetShortMsg;
        end;
      end;

      CmdMenu_PovtorOtkrytManevr : begin
        WorkMode.InpOgr := false;
        if PovtorOtkrytSvetofora(DspCommand.Obj, MarshM,1) then
        begin // ������ �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_povtorotkrytmanevr,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,26);
            ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
        ResetTrace;
      end;

      CmdMenu_PovtorOtkrytPoezd : begin
        WorkMode.InpOgr := false;
        if PovtorOtkrytSvetofora(DspCommand.Obj, MarshP,1) then
        begin // ������ �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_povtorotkrytpoezd,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,27);
            ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
        ResetTrace;
      end;

      CmdMarsh_PovtorOtkryt : begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_PovtorOtkryt,LastX,LastY);
        end else
        begin // ������ ������� ���������� ��������
          if ObjZav[DspCommand.Obj].bParam[6] or ObjZav[DspCommand.Obj].bParam[7] then
          begin //��
            if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_povtorotkrytmanevr,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,26);
              ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          if ObjZav[DspCommand.Obj].bParam[8] or ObjZav[DspCommand.Obj].bParam[9] then
          begin //�
            if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_povtorotkrytpoezd,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,27);
              ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
            ResetShortMsg;
          ResetTrace;
        end;
      end;

      CmdMenu_PovtorManevrMarsh : begin
        WorkMode.InpOgr := false;
        if PovtorMarsh(DspCommand.Obj, MarshM,1) then
        begin // ������ �������
          SendMarshrutCommand(1);
        end;
      end;

      CmdMenu_PovtorPoezdMarsh : begin
        WorkMode.InpOgr := false;
        if PovtorMarsh(DspCommand.Obj, MarshP,1) then
        begin // ������ �������
          SendMarshrutCommand(1);
        end;
      end;

      CmdMarsh_PovtorMarh : begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_PovtorMarh,LastX,LastY);
        end else
        begin // ������ ������� ��������� ��������� ��������
          SendMarshrutCommand(1);
        end;
      end;

      CmdMenu_BlokirovkaSvet : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := true;
        i := ObjZav[DspCommand.Obj].ObjConstI[3]; if i = 0 then i := ObjZav[DspCommand.Obj].ObjConstI[5];
        if SendCommandToSrv(i div 8,cmdfr3_blokirov,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,28);
          ShowShortMsg(28, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_DeblokirovkaSvet : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := false;
        i := ObjZav[DspCommand.Obj].ObjConstI[3]; if i = 0 then i := ObjZav[DspCommand.Obj].ObjConstI[5];
        if SendCommandToSrv(i div 8,cmdfr3_razblokir,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,29);
          ShowShortMsg(29, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_BeginMarshManevr : begin // ������ ����������� ����������� ��������
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCommand.Obj, DspCommand.Command);
      end;

      CmdMenu_BeginMarshPoezd : begin // ������ ����������� ��������� ��������
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCommand.Obj, DspCommand.Command);
      end;

      KeyMenu_QuerySetTrace : begin // ������ ������� ��������� ������� �� ��������� ������
        SendTraceCommand(1);
      end;

      CmdMarsh_Tracert : begin // ���������� ����������� ��������, �������� ������ � ������
        WorkMode.InpOgr := false;
        if MarhTracert[1].MsgCount > 0 then
        begin
          if MarhTracert[1].GonkaStrel and (MarhTracert[1].GonkaList > 0) then
          begin //������ ������ ������� ����� ������� � �������� ������
            CreateDspMenu(KeyMenu_QuerySetTrace,LastX,LastY);
          end else
          begin
            ResetTrace;// �������� �����
            PutShortMsg(1,LastX,LastY,MarhTracert[1].Msg[1]);
          end;
        end else
        if (MarhTracert[1].WarCount > 0) and ((MarhTracert[1].ObjEnd > 0) or (MarhTracert[1].FullTail)) then
        begin
          dec(MarhTracert[1].WarCount);
          if MarhTracert[1].WarCount > 0 then
          begin
            SingleBeep := true; TimeLockCmdDsp := LastTime; LockCommandDsp := true; ShowWarning := true;
            CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
          end else
          begin
            CreateDspMenu(CmdMarsh_Ready,LastX,LastY);
          end;
        end else
        begin
          AddToTracertMarshrut(DspCommand.Obj);
        end;
      end;

      CmdMarsh_Manevr : begin // ������������ ������� ����������� ��������
        if SetProgramZamykanie(1) then SendMarshrutCommand(1);
      end;

      CmdMarsh_Poezd : begin // ������������ ������� ��������� ��������
        if SetProgramZamykanie(1) then SendMarshrutCommand(1);
      end;

      CmdMenu_BlokirovkaNadviga : begin // ����������� ������
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1],cmdfr3_blokirov,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,28);
          ShowShortMsg(28, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_DeblokirovkaNadviga : begin // �������������� ������
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1],cmdfr3_razblokir,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,29);
          ShowShortMsg(29, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_AutoMarshVkl : begin // ��������� ������������ ����������
        if AutoMarsh(DspCommand.Obj,true) then
        begin
          InsArcNewMsg(DspCommand.Obj,421);
          ShowShortMsg(421, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_AutoMarshOtkl : begin // ���������� ������������ ����������
        if AutoMarsh(DspCommand.Obj,false) then
        begin
          InsArcNewMsg(DspCommand.Obj,422);
          ShowShortMsg(422, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMarsh_ResetTraceParams : begin // ����� �������������� ���������
        case ObjZav[DspCommand.Obj].TypeObj of
          2 : begin // �������
            ObjZav[DspCommand.Obj].bParam[6]  := false;
            ObjZav[DspCommand.Obj].bParam[7]  := false;
            ObjZav[DspCommand.Obj].bParam[10] := false;
            ObjZav[DspCommand.Obj].bParam[11] := false;
            ObjZav[DspCommand.Obj].bParam[12] := false;
            ObjZav[DspCommand.Obj].bParam[13] := false;
            ObjZav[DspCommand.Obj].bParam[14] := false;
            ObjZav[DspCommand.Obj].iParam[1] := 0;
            o := ObjZav[DspCommand.Obj].BaseObject;
            ObjZav[o].bParam[6]  := false;
            ObjZav[o].bParam[7]  := false;
            ObjZav[o].bParam[14] := false;
            ResetShortMsg;
          end;
          3 : begin // �������
            ObjZav[DspCommand.Obj].bParam[14] := false;
            ObjZav[DspCommand.Obj].bParam[15] := false;
            ObjZav[DspCommand.Obj].bParam[16] := false;
            ObjZav[DspCommand.Obj].iParam[1] := 0;
            ObjZav[DspCommand.Obj].iParam[2] := 0;
            ObjZav[DspCommand.Obj].bParam[8] := true;
            o := DspCommand.Obj;
            if SendCommandToSrv(ObjZav[o].ObjConstI[2] div 8, cmdfr3_resettrace,o) then
            begin
              InsArcNewMsg(o,312);
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);
              for p := 1 to High(ObjZav) do
                case ObjZav[p].TypeObj of
                  2 : begin // �������
                    if ObjZav[p].UpdateObject = DspCommand.Obj then
                    begin // ����� �������������� �������� �� �������, ��������� � ������ �������
                      ObjZav[p].bParam[6]  := false;
                      ObjZav[p].bParam[7]  := false;
                      ObjZav[p].bParam[10] := false;
                      ObjZav[p].bParam[11] := false;
                      ObjZav[p].bParam[12] := false;
                      ObjZav[p].bParam[13] := false;
                      ObjZav[p].bParam[14] := false;
                      ObjZav[p].iParam[1]  := 0;
                      o := ObjZav[p].BaseObject;
                      ObjZav[o].bParam[6]  := false;
                      ObjZav[o].bParam[7]  := false;
                      ObjZav[o].bParam[14] := false;
                    end;
                  end;

                  41 : begin // �������� �������� �����������
                    if ObjZav[p].UpdateObject = DspCommand.Obj then
                    begin // ����� �������������� ��������, ��������� � ������ �������
                      ObjZav[p].bParam[1]  := false;
                      ObjZav[p].bParam[2]  := false;
                      ObjZav[p].bParam[3]  := false;
                      ObjZav[p].bParam[4]  := false;
                      ObjZav[p].bParam[8]  := false;
                      ObjZav[p].bParam[9]  := false;
                      ObjZav[p].bParam[10] := false;
                      ObjZav[p].bParam[11] := false;
                      ObjZav[p].bParam[20] := false;
                      ObjZav[p].bParam[21] := false;
                      ObjZav[p].bParam[23] := false;
                      ObjZav[p].bParam[24] := false;
                      ObjZav[p].bParam[25] := false;
                      ObjZav[p].bParam[26] := false;
                    end;
                  end;

                  42 : begin // ������ ������������� ��������� �������� �� ����������
                    if ObjZav[p].UpdateObject = DspCommand.Obj then
                    begin // ����� �������������� ��������, ��������� � ������ �������
                      ObjZav[p].bParam[1]  := false;
                      ObjZav[p].bParam[2]  := false;
                    end;
                  end;
                end;
            end;
          end;
          4 : begin // ����
            ObjZav[DspCommand.Obj].bParam[14] := false;
            ObjZav[DspCommand.Obj].iParam[1] := 0;
            ObjZav[DspCommand.Obj].iParam[2] := 0;
            ObjZav[DspCommand.Obj].iParam[3] := 0;
            ObjZav[DspCommand.Obj].bParam[8] := true;
            o := DspCommand.Obj;
            if SendCommandToSrv(ObjZav[o].ObjConstI[2] div 8, cmdfr3_resettrace,o) then
            begin
              InsArcNewMsg(o,312);
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);
            end;
          end;
          5 : begin // ��������
            ObjZav[DspCommand.Obj].bParam[14] := false;
            ObjZav[DspCommand.Obj].iParam[1] := 0;
            ObjZav[DspCommand.Obj].bParam[7] := false;
            ObjZav[DspCommand.Obj].bParam[9] := false;
            o := DspCommand.Obj;
            i := ObjZav[o].ObjConstI[3]; if i = 0 then i := ObjZav[o].ObjConstI[5];
            if SendCommandToSrv(i div 8, cmdfr3_resettrace,o) then
            begin
              InsArcNewMsg(o,312);
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);
            end;
          end;
        else
          result := false; exit;
        end;
      end;

// �������
      CmdMenu_SekciaPredvaritRI : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        if ObjZav[DspCommand.Obj].ObjConstB[7] then
        begin // �������
          i := ObjZav[DspCommand.Obj].BaseObject;
        end else
        begin // ������
          i := DspCommand.Obj;
        end;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[7],cmdfr3_ispiskrazmyk);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[7] div 8,cmdfr3_predviskrazmyk,DspCommand.Obj) then
        begin
          InsArcNewMsg(i,33);
          ShowShortMsg(33, LastX, LastY, ObjZav[i].Liter);
        end;
      end;

      CmdMenu_SekciaIspolnitRI : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false; OtvCommand.Active := false;
        if ObjZav[DspCommand.Obj].ObjConstB[7] then
        begin // �������
          i := ObjZav[DspCommand.Obj].BaseObject;
        end else
        begin // ������
          i := DspCommand.Obj;
        end;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������, �������� �������� �����������
          ObjZav[DspCommand.Obj].bParam[14] := false;
          ObjZav[DspCommand.Obj].iParam[1] := 0;
          ObjZav[DspCommand.Obj].bParam[8] := true;
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[7] div 8,cmdfr3_ispiskrazmyk,DspCommand.Obj) then
          begin
            InsArcNewMsg(i,34);
            ShowShortMsg(34, LastX, LastY, ObjZav[i].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(i,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[i].Liter);
        end;
      end;

      CmdMenu_SekciaZakrytDvijenie : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirov,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,35);
          ShowShortMsg(35, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SekciaOtkrytDvijenie : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokir,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,36);
          ShowShortMsg(36, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SekciaZakrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirovET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460);
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SekciaOtkrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokirET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461);
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SekciaZakrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirovETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470);
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SekciaOtkrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokirETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471);
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SekciaZakrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirovETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465);
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SekciaOtkrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokirETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466);
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ����
      CmdMenu_PutDatSoglasieOgrady : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[ObjZav[DspCommand.Obj].UpdateObject].ObjConstI[4] div 8,cmdfr3_putustograd,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,37);
          ShowShortMsg(37, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutZakrytDvijenie : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirov,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,39);
          ShowShortMsg(39, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutOtkrytDvijenie : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokir,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,40);
          ShowShortMsg(40, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutVklOPI : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1] div 8,cmdfr3_vklOPI,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,414);
          ShowShortMsg(414, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].UpdateObject].Liter);
        end;
      end;

      CmdMenu_PutOtklOPI : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1] div 8,cmdfr3_otklOPI,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,415);
          ShowShortMsg(415, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].UpdateObject].Liter);
        end;
      end;

      CmdMenu_PutZakrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirovET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460);
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutOtkrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokirET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461);
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutZakrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirovETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470);
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutOtkrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokirETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471);
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutZakrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_blokirovETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465);
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PutOtkrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_razblokirETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466);
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ��������� �������
      CmdMenu_ZamykanieStrelok : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_zamykstr,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,41);
          ShowShortMsg(41, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;

      CmdMenu_PredvRazmykanStrelok : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[2],cmdfr3_isprazmykstr);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_predvrazmykstr,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,42);
          ShowShortMsg(42, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IspolRazmykanStrelok : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false; OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[4] div 8,cmdfr3_isprazmykstr,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,43);
            ShowShortMsg(43, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ���������� ���������
      CmdMenu_ZakrytPereezd : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_pereezdzakryt,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,44);
          ShowShortMsg(44, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PredvOtkrytPereezd : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[2],cmdfr3_isppereezdotkr);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_predvpereezdotkr,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,45);
          ShowShortMsg(45, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IspolOtkrytPereezd : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false; OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_isppereezdotkr,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,46);
            ShowShortMsg(46, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_DatIzvecheniePereezd : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_pereezdvklizv,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,47);
          ShowShortMsg(47, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SnatIzvecheniePereezd : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_pereezdotklizv,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,48);
          ShowShortMsg(48, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ���������� ��������
      CmdMenu_DatOpovechenie : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_opovvkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,49);
          ShowShortMsg(49, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SnatOpovechenie : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_opovotkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,50);
          ShowShortMsg(50, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_DatZapretMonteram : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_opovzaprvkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,51);
          ShowShortMsg(51, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;

      CmdMenu_SnatZapretMonteram : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_predvopovzaprotkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,52);
          ShowShortMsg(52, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;

// �����
      CmdMenu_PredvOtkluchenieUKSPS : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[3],cmdfr3_ispukspsotkl);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_predvukspsotkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,53);
          ShowShortMsg(53, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IspolOtkluchenieUKSPS : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false; OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_ispukspsotkl,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,54);
            ShowShortMsg(54, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_OtmenaOtkluchenieUKSPS : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_otmenablokUksps,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,354);
          ShowShortMsg(354, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// �������
      CmdMenu_SmenaNapravleniya : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_absmena,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,55);
          ShowShortMsg(55, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_DatSoglasieSmenyNapr : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[9] div 8,cmdfr3_absoglasie,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,56);
          ShowShortMsg(56, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_VklKSN : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1] div 8,cmdfr3_vklksn,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,409);
          ShowShortMsg(409, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;

      CmdMenu_OtklKSN : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1] div 8,cmdfr3_otklksn,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,410);
          ShowShortMsg(410, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PredvVspomOtpravlenie : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[4],cmdfr3_ispvspotpr);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[4] div 8,cmdfr3_predvvspotpr,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,59);
          ShowShortMsg(59, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IspolVspomOtpravlenie : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false; OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_ispvspotpr,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,60);
            ShowShortMsg(60, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_PredvVspomPriem : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[5],cmdfr3_ispvsppriem);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_predvvsppriem,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,61);
          ShowShortMsg(61, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IspolVspomPriem : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false; OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_ispvsppriem,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,62);
            ShowShortMsg(62, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ZakrytPeregon : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_blokirov,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,57);
          ShowShortMsg(57, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_OtkrytPeregon : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_razblokir,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,58);
          ShowShortMsg(58, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_SnatSoglasieSmenyNapr : begin
        WorkMode.InpOgr := false; WorkMode.MarhOtm := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[9] div 8,cmdfr3_otmenasogsnab,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,438);
          ShowShortMsg(438, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ABZakrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_blokirovET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460);
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ABOtkrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_razblokirET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461);
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ABZakrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_blokirovETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470);
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ABOtkrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_razblokirETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471);
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ABZakrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_blokirovETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465);
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ABOtkrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_razblokirETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466);
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ���
      CmdMenu_VydatSoglasieOtpravl : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_pabsoglasievkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,321);
          ShowShortMsg(321, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_OtmenaSoglasieOtpravl : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[5] div 8,cmdfr3_pabsoglasieotkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,322);
          ShowShortMsg(322, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IskPribytiePredv : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[4],cmdfr3_isppabiskpribytie);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[4] div 8,cmdfr3_predvpabiskpribytie,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,323);
          ShowShortMsg(323, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IskPribytieIspolnit : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false; OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[3] div 8,cmdfr3_isppabiskpribytie,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,324);
            ShowShortMsg(324, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_VydatPribytiePoezda : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_pabpribytie,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,325);
          ShowShortMsg(325, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_ZakrytPeregonPAB : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_blokirov,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,57);
          ShowShortMsg(57, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_OtkrytPeregonPAB : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_razblokir,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,58);
          ShowShortMsg(58, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_RPBZakrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_blokirovET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460);
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_RPBOtkrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_razblokirET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461);
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_RPBZakrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_blokirovETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470);
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_RPBOtkrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_razblokirETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471);
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_RPBZakrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_blokirovETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465);
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_RPBOtkrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[13] div 8,cmdfr3_razblokirETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466);
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ���������� ����������� ������
      CmdMenu_ZakrytUvjazki : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[15] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_blokirov,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,57);
          ShowShortMsg(57, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_OtkrytUvjazki : begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[15] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_razblokir,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,58);
          ShowShortMsg(58, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_EZZakrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_blokirovET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460);
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_EZOtkrytDvijenieET : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_razblokirET,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461);
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_EZZakrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_blokirovETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470);
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_EZOtkrytDvijenieETA : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_razblokirETA,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471);
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_EZZakrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_blokirovETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465);
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_EZOtkrytDvijenieETD : begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_razblokirETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466);
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ������
      CmdMenu_VkluchOchistkuStrelok : begin
        WorkMode.InpOgr := false;
        case (ObjZav[DspCommand.Obj].ObjConstI[1] - (ObjZav[DspCommand.Obj].ObjConstI[1] div 8) * 8) of
          0 : p := cmdfr3_knopka1vkl;
          1 : p := cmdfr3_knopka2vkl;
        else
          result := false; exit;
        end;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1] div 8,p,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,6);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[6]]);
          end;
        end;
      end;

      CmdMenu_OtklOchistkuStrelok : begin
        WorkMode.InpOgr := false;
        case (ObjZav[DspCommand.Obj].ObjConstI[1] - (ObjZav[DspCommand.Obj].ObjConstI[1] div 8) * 8) of
          0 : p := cmdfr3_knopka1otkl;
          1 : p := cmdfr3_knopka2otkl;
        else
          result := false; exit;
        end;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1] div 8,p,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[5] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[7]]);
          end;
        end;
      end;

      CmdMenu_VkluchenieGRI : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_grivkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,65);
          ShowShortMsg(65, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;

      CmdMenu_ZaprosPoezdSoglasiya : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_upzaprospoezdvkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,66);
          ShowShortMsg(66, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_OtmZaprosPoezdSoglasiya : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_upzaprospoezdotkl,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,67);
          ShowShortMsg(67, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ���������� �������
      CmdMenu_DatRazreshenieManevrov : begin
        WorkMode.InpOgr := false; VytajkaZM(DspCommand.Obj);

        if WorkMode.RazdUpr then
        begin
          i := ObjZav[DspCommand.Obj].ObjConstI[2] - (ObjZav[DspCommand.Obj].ObjConstI[2] div 8) * 8;
          case i of
            1 : i := cmdfr3_knopka2vkl;
            2 : i := cmdfr3_knopka3vkl;
            3 : i := cmdfr3_knopka4vkl;
            4 : i := cmdfr3_knopka5vkl;
          else
            i := cmdfr3_knopka1vkl;
          end;
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,i,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,68);
            ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end else
        begin
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_manevryrm,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,68);
            ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;

      CmdManevry_ReadyWar : begin // �������� ������������� �������������� ���������
        if Marhtracert[1].WarCount > 0 then
        begin // ����� ���������� ��������������
          CreateDspMenu(CmdManevry_ReadyWar,LastX,LastY);
        end else
        begin
          VytajkaZM(DspCommand.Obj);

          if WorkMode.RazdUpr then
          begin
            i := ObjZav[DspCommand.Obj].ObjConstI[2] - (ObjZav[DspCommand.Obj].ObjConstI[2] div 8) * 8;
            case i of
              1 : i := cmdfr3_knopka2vkl;
              2 : i := cmdfr3_knopka3vkl;
              3 : i := cmdfr3_knopka4vkl;
              4 : i := cmdfr3_knopka5vkl;
            else
              i := cmdfr3_knopka1vkl;
            end;
            if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,i,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,68); ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          begin
            if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_manevryrm,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,68); ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end;
        end;
      end;

      CmdMenu_OtmenaManevrov : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[2] div 8,cmdfr3_manevryotmen,DspCommand.Obj) then
        begin
          VytajkaOZM(DspCommand.Obj);
          if not ObjZav[DspCommand.Obj].bParam[3] and ObjZav[DspCommand.Obj].bParam[5] then
          begin
            InsArcNewMsg(DspCommand.Obj,447);
            ShowShortMsg(447, LastX, LastY, ObjZav[DspCommand.Obj].Liter) // ��������� ��������
          end else
          begin
            InsArcNewMsg(DspCommand.Obj,69);
            ShowShortMsg(69, LastX, LastY, ObjZav[DspCommand.Obj].Liter); // ������ ��������
          end;
        end;
      end;

      CmdMenu_PredvIRManevrov : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        GoWaitOtvCommand(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[8],CmdMenu_IspolIRManevrov);
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_predvmanevryri,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,70);
          ShowShortMsg(70, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

      CmdMenu_IspolIRManevrov : begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false; WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin // ������ �������������� �������
          if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_ispmanevryri,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,71);
            ShowShortMsg(71, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else // ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

// ������������ ������ ������� ���� ����������
      CmdMenu_VkluchitDen : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[15] div 8,cmdfr3_dnkden,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,72);
          ShowShortMsg(72, LastX, LastY, '');
        end;
      end;

      CmdMenu_VkluchitNoch : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[15] div 8,cmdfr3_dnknocth,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,73);
          ShowShortMsg(73, LastX, LastY, '');
        end;
      end;

      CmdMenu_VkluchitAuto : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[16] div 8,cmdfr3_dnkauto,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,74);
          ShowShortMsg(74, LastX, LastY, '');
        end;
      end;

      CmdMenu_OtkluchitAuto : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[16] div 8,cmdfr3_otkldnkauto,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,479);
          ShowShortMsg(479, LastX, LastY, '');
        end;
      end;

      CmdMenu_OtklZvonkaUKSPS : begin
        WorkMode.InpOgr := false;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[1] div 8,cmdfr3_ukspsotklzvon,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,75);
          ShowShortMsg(75, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

    else
      ResetShortMsg;
      WorkMode.InpOgr := false; // �������� ����� ����� �����������
      WorkMode.GoMaketSt := false;
      WorkMode.GoOtvKom := false;
    end;
  end;
{$ENDIF}
  result := true;
end;

{$IFDEF RMDSP}
//------------------------------------------------------------------------------
// ��������� ����� �������� ����������� ����� ������� �������
function WorkModeCalc: smallint;
begin
  {�������� ������� ��}
  result := 0;
end;

//------------------------------------------------------------------------------
// ������������� �������� �������������� ������������� �������
procedure GoWaitOtvCommand(const Obj, BitFR3, CmdSecond : Word);
  var a,b : boolean;
begin
  OtvCommand.Check  := BitFR3;
  OtvCommand.State  := GetFR3(BitFR3,a,b); // ������� ��������� ��������������� �������
  OtvCommand.Cmd    := CmdSecond;
  OtvCommand.Second := 0;
  OtvCommand.SObj   := 0;
  OtvCommand.Obj    := Obj;
  OtvCommand.Reper  := LastTime + 20 / 80000;
  OtvCommand.Ready  := true;
  OtvCommand.Active := true;
  WorkMode.GoOtvKom := true;
end;

//------------------------------------------------------------------------------
// �������� ������� ������� ��� ������ �������������� ������������� �������
function CheckOtvCommand(Obj : SmallInt) : Boolean;
begin
  if OtvCommand.Active then
  begin
    result := OtvCommand.Obj <> Obj;
  end else result := false;
end;
{$ENDIF}

//------------------------------------------------------------------------------
// ������ ���������� ������� �� ������
function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
begin
  if (CmdCnt < 1) and (Obj > 0) and (Cmd > 0) then
  begin
    CmdSendT := LastTime; // ��������� ����� ������ �������
    inc(CmdCnt);
    CmdBuff.Cmd := Cmd;
    CmdBuff.Index := Obj;
    CmdBuff.LastObj := Index;
    result := true;
    WorkMode.CmdReady := true;
  end else
    result := false;
end;

{$IFDEF RMDSP}
//------------------------------------------------------------------------------
// ������ �������� � ������� Double �� ������
function SendDoubleToSrv(Param : int64; Cmd : Byte; Index : Word) : Boolean;
  var i : int64;
begin
  if (DoubleCnt < 1) and (Cmd > 0) then
  begin
    CmdSendT := LastTime; // ��������� ����� ������ ���������
    inc(DoubleCnt);
    ParamDouble.Cmd := Cmd;
    // ����������� Param �� 8 ����
    ParamDouble.Index[1] := Param and $ff;
    i := (Param and $ff00) shr 8;
    ParamDouble.Index[2] := i;
    i := (Param and $ff0000) shr 16;
    ParamDouble.Index[3] := i;
    i := (Param and $ff000000) shr 24;
    ParamDouble.Index[4] := i;
    i := (Param and $ff00000000) shr 32;
    ParamDouble.Index[5] := i;
    i := (Param and $ff0000000000) shr 40;
    ParamDouble.Index[6] := i;
    i := (Param and $ff000000000000) shr 48;
    ParamDouble.Index[7] := i;
    i := (Param and $ff00000000000000) shr 56;
    ParamDouble.Index[8] := i;
    ParamDouble.LastObj := Index;
    result := true;
    if not ((Cmd = cmdfr3_newdatetime) or (Cmd = cmdfr3_autodatetime)) then WorkMode.CmdReady := true;
  end else
    result := false;
end;
{$ENDIF}

{$IFDEF RMARC}
var smn : string;
//------------------------------------------------------------------------------
// ������� � ������ �������
procedure CmdMsg(cmd,ifr,index : word);
  var obj : word;
begin
  if LastFixed < index then
  begin
    if Cmd = 0 then
    begin
      case ifr of
        0 : begin // ����� �������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > ����� ������� <Esc>'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fe5 : begin // ����� �� ������ ������������� ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "����� �� ������ ������������� ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fe6 : begin // ������� � ����� ������������� ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� � ����� ������������� ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fe7 : begin // ���������� ��������� �������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "���������� ��������� �������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fe8 : begin // ����� ������������ ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "����� ������������ ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fe9 : begin // ���������� ���������� �� ��-���
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "���������� ���������� �� ��-���"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fea : begin // ����� ������� ������ ��
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "����� ������� ������ ��"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7feb : begin // ��������� 2 ����� ����������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� 2-� ����� ����������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fec : begin // ��������� 1 ����� ����������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� 1-� ����� ����������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fed : begin // ��������� ���������� �� ��-���
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "�������� ���������� �� ��-���"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fee : begin // ���������� ������ ��������� ������ ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "�������� ����� ��������� ������ ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fef : begin // ��������� ������ ��������� ������ ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� ����� ��������� ������ ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff0 : begin // ���������� ������ ����� ������ ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "�������� ����� ����� ������ ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff1 : begin // ��������� ������ ����� ������ ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� ����� ����� ������ ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff2 : begin // ���������� ������ ��������� ��������� �������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "�������� ����� ��������� ��������� �������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff3 : begin // ��������� ������ ��������� ��������� �������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� ����� ��������� ��������� �������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff4 : begin // ���������� ������ ����� �����������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "�������� ����� ����� �����������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff5 : begin // ��������� ������ ����� �����������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� ����� ����� �����������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff6 : begin // ���������� ������ ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "�������� ����� ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff7 : begin // ��������� ������ ������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� ����� ������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff8 : begin // ��������� ����������� ������ ����������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� ���������� ����� ���������� ��������� � ���������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ff9 : begin // ��������� ����������� ������ ����������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������� ���������� ����� ���������� ��������� � ���������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ffa : begin // ���������� ������ �� ���
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "���������� ������ �� ���"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ffb : begin // ������ ������ �� ���
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "������ ������ �� ���"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ffc : begin // ��������� ��
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "��������� ��"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ffd : begin // ����� ������� ��
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "����� ������� ��"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7ffe : begin // ����� �� �����
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "����� �� �����"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
        $7fff : begin // ���������� ���������
          ListNeisprav := DateTimeToStr(DTFrameOffset)+' > "���������� ���������"'+ #13#10+ ListNeisprav; NewNeisprav := true;
        end;
      end;
    end else
    if ifr >= $4000 then
    begin // ���������� �������
      obj := ifr and $0fff;
      case cmd of
        CmdMenu_StrPerevodPlus : begin
          smn := '������� � ���� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrPerevodMinus : begin
          smn := '������� � ����� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrVPerevodPlus : begin
          smn := '��������������� ������� � ���� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrVPerevodMinus : begin
          smn := '��������������� ������� � ����� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrOtklUpravlenie : begin
          smn := '���������� �� ���������� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrVklUpravlenie : begin
          smn := '��������� ���������� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrZakrytDvizenie : begin
          smn := '������� �������� �� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrOtkrytDvizenie : begin
          smn := '������� �������� �� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_UstMaketStrelki : begin
          smn := '���������� ����� �� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_SnatMaketStrelki : begin
          smn := '���� ����� �� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrMPerevodPlus : begin
          smn := '�������� ������� � ���� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrMPerevodMinus : begin
          smn := '�������� ������� � ����� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrZakryt2Dvizenie : begin
          smn := '������� �������� �� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrOtkryt2Dvizenie : begin
          smn := '������� �������� �� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrZakrytProtDvizenie : begin
          smn := '������� ��������������� �������� �� ������� '+ ObjZav[obj].Liter;
        end;
        CmdMenu_StrOtkrytProtDvizenie : begin
          smn := '������� ��������������� �������� �� ������� '+ ObjZav[obj].Liter;
        end;








        CmdMarsh_Tracert : begin
          smn := '����������� �������� ����� '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_Ready : begin
          smn := '������ �������������� '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_Manevr : begin
          smn := '���������� ���������� ������� {'+ ObjZav[obj].Liter+'}'
        end;
        CmdMarsh_Poezd : begin
          smn := '���������� �������� ������� {'+ ObjZav[obj].Liter+'}'
        end;
        CmdMarsh_Povtor : begin
          smn := '������ �������� '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_Razdel : begin
          smn := '������� '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_RdyRazdMan : begin
          smn := '������� ���������� '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_RdyRazdPzd : begin
          smn := '������� �������� '+ ObjZav[obj].Liter;
        end;
        CmdManevry_ReadyWar : begin
          smn := '�������� �������������� '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_ResetTraceParams : begin
          smn := '������������ '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_PovtorMarh : begin
          smn := '������ �������� �� '+ ObjZav[obj].Liter;
        end;
        CmdMarsh_PovtorOtkryt : begin
          smn := '��������� �������� '+ ObjZav[obj].Liter;
        end;
        CmdStr_ReadyPerevodPlus : begin
          smn := '������� � ���� ������� '+ ObjZav[obj].Liter;
        end;
        CmdStr_ReadyPerevodMinus : begin
          smn := '������� � ����� ������� '+ ObjZav[obj].Liter;
        end;
        CmdStr_ReadyVPerevodPlus : begin
          smn := '��������������� ������� � ���� ������� '+ ObjZav[obj].Liter;
        end;
        CmdStr_ReadyVPerevodMinus : begin
          smn := '��������������� ������� � ����� ������� '+ ObjZav[obj].Liter;
        end;
        CmdStr_ReadyMPerevodPlus : begin
          smn := '������� �� ������ � ���� ������� '+ ObjZav[obj].Liter;
        end;
        CmdStr_ReadyMPerevodMinus : begin
          smn := '������� �� ������ � ����� ������� '+ ObjZav[obj].Liter;
        end;
        CmdStr_AskPerevod : begin
          smn := '����� ������� '+ ObjZav[obj].Liter;
        end;
      else
        smn := '������������ ������� '+ IntToStr(cmd)+ ' �� ������ '+ IntToStr(Obj);
      end;

      ListNeisprav := DateTimeToStr(DTFrameOffset) + ' < '+ smn+ #13#10+ ListNeisprav; NewNeisprav := true;
    end else
    begin // ������� ��
      smn := DateTimeToStr(DTFrameOffset) + ' < ������ ������� �� ';
      ListNeisprav := smn+ IntToStr(cmd)+ ' �� ������ ['+ IntToStr(ifr)+ ']'+ #13#10+ ListNeisprav; NewNeisprav := true;
    end;
  end;
end;
{$ENDIF}

end.
