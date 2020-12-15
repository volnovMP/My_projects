unit Commands;
{$INCLUDE d:\Sapr2012\CfgProject}
//========================================================================================
//--------------------------------------------------------------------  ������� ����������
interface
uses
  Windows,   Forms,  SysUtils,  Commons,  Controls,

{$IFDEF RMDSP}  TimeInput,  KanalArmSrv,  TabloForm,{$ENDIF}

{$IFDEF RMSHN}  KanalArmSrvSHN,  TabloSHN,{$ENDIF}

{$IFDEF RMARC}TabloFormARC,{$ENDIF}

{$IFDEF TABLO}  TabloForm1,{$ENDIF}

 TypeALL;



function SelectCommand : boolean;

{$IFDEF RMDSP}
  function Cmd_ChangeMode(mode : integer) : boolean;
  function WorkModeCalc: smallint;
  procedure GoWaitOtvCommand(const Obj,BitFR3,CmdSecond : Word);
  function CheckOtvCommand(Obj : SmallInt) : Boolean;
  function SendDoubleToSrv(Param : int64; Cmd : Byte; Index : Word) : Boolean;
  function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
{$ENDIF}

{$IFDEF RMSHN}
  function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
{$ENDIF}

{$IFDEF RMARC}
 function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
 procedure CmdMsg(cmd,ifr : word; index : integer);
{$ENDIF}

const
 //----------------------------------------------------- ������ ��������� ������ ����������
  CmdMarsh_Tracert          = 1101;
  CmdMarsh_Ready            = 1102;
  CmdMarsh_Manevr           = 1103;
  CmdMarsh_Poezd            = 1104;
  CmdMarsh_Povtor           = 1105;
  CmdMarsh_Razdel           = 1106;
  CmdMarsh_RdyRazdMan       = 1107;
  CmdMarsh_RdyRazdPzd       = 1108;
  CmdManevry_ReadyWar       = 1109;
  CmdMarsh_ResetTraceParams = 1110; //------------------------ ������������ ������� ������
  CmdMarsh_PovtorMarh       = 1111;
  CmdMarsh_PovtorOtkryt     = 1112;
  //------------------------------------------------------------------ ������� ��� �������
  CmdStr_ReadyPerevodPlus   = 1201;
  CmdStr_ReadyPerevodMinus  = 1202;
  CmdStr_ReadyVPerevodPlus  = 1203;
  CmdStr_ReadyVPerevodMinus = 1204;
  CmdStr_ReadyMPerevodPlus  = 1205;
  CmdStr_ReadyMPerevodMinus = 1206;
  CmdStr_AskPerevod         = 1207;
  CmdStr_ResetMaket         = 1208;

//==================== ������ ����� ������ ��� �������� � STAN (FR3-�������) =============
cmdfr3_ispiskrazmyk        = 1; //-�������������� ������� �������������� ���������� ������
cmdfr3_isprazmykstr        = 2; //-------------- �������������� ������� ���������� �������
cmdfr3_isppereezdotkr      = 3; //--------------- �������������� ������� �������� ��������
cmdfr3_IspolVklZapMont     = 4; //------ �������������� ������� ��������� ������� ��������
cmdfr3_IspolOtklZapMont    = 5; //----- �������������� ������� ���������� ������� ��������
cmdfr3_ispukspsotkl        = 6; //---------------- �������������� ������� ���������� �����
cmdfr3_ispvspotpr          = 7; //---- �������������� ������� ���������������� �����������
cmdfr3_ispvsppriem         = 8; //--------- �������������� ������� ���������������� ������
cmdfr3_ispmanevryri        = 9;//�������������� ������� �������������� ���������� ��������
cmdfr3_isppabiskpribytie   = 10; // �������������� ������� �������������� �������� ��� ���
cmdfr3_ispolpereezdzakr    = 11; //-------------- �������������� ������� �������� ��������
cmdfr3_ispolOtklUkg        = 12; //- �������������� ������� ���������� ��� �� ������������
cmdfr3_ispolOtkl3bit       = 13; //- �������������� ������� ���������� ��� �� ������������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------------- 14 - 29 ������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cmdfr3_pereezdotklizv1     = 30; //---- ������� ���������� ��������� �� ������� (��� ����)
//-------------------------------------------------------------------- ������� ��� �������
cmdfr3_otklupr             = 31; //------------------------ ��������� ������ �� ����������
cmdfr3_vklupr              = 32;//--------------------------- �������� ���������� ��������
cmdfr3_blokirov            = 33; //-------------------------------------- ������� ��������
cmdfr3_razblokir           = 34;
cmdfr3_blokirov2           = 35;
cmdfr3_razblokir2          = 36;
cmdfr3_ustmaket            = 37;
cmdfr3_snatmaket           = 38;
cmdfr3_strplus             = 41;
cmdfr3_strminus            = 42;
cmdfr3_strvspplus          = 43;
cmdfr3_strvspminus         = 44;
//------------------------------------------------------------------- ������� ��� ��������
cmdfr3_svotkrmanevr        = 45;
cmdfr3_svotkrpoezd         = 46;
cmdfr3_svzakrmanevr        = 47;
cmdfr3_svzakrpoezd         = 48;
cmdfr3_svpovtormanevr      = 49;
cmdfr3_svpovtorpoezd       = 50;
cmdfr3_svustlogic          = 51;
cmdfr3_svotmenlogic        = 52;
cmdfr3_putustograd         = 53;
cmdfr3_logoff              = 54; //------------ ������� ���������� ������ ��������� ��-���
cmdfr3_zamykstr            = 55;
cmdfr3_pereezdzakryt       = 56;
cmdfr3_pereezdvklizv       = 57;
cmdfr3_pereezdotklizv      = 58;
cmdfr3_opovvkl             = 59; //----------------------------------- �������� ����������
cmdfr3_VklZapMont          = 60; //------------------------------ �������� ������ ��������
cmdfr3_ukspsotklzvon       = 61;
cmdfr3_absmena             = 62;
cmdfr3_absoglasie          = 63;
cmdfr3_knopka1vkl          = 64;
cmdfr3_knopka1otkl         = 65;
cmdfr3_grivkl              = 66;
cmdfr3_upzaprospoezdvkl    = 67;
cmdfr3_upzaprospoezdotkl   = 68;
cmdfr3_upzaprosmanevrvkl   = 69;
cmdfr3_upzaprosmanevrotkl  = 70;
cmdfr3_manevryrm           = 71;
cmdfr3_manevryotmen        = 72;
cmdfr3_dnkden              = 73;
cmdfr3_dnknocth            = 74;
cmdfr3_dnkauto             = 75;
cmdfr3_pabsoglasievkl      = 76;
cmdfr3_pabsoglasieotkl     = 77;
cmdfr3_pabpribytie         = 78;
cmdfr3_directdef           = 79;
cmdfr3_directmanual        = 80;
//-------------------------------------------------------------------- ������� ��� �������
cmdfr3_strmakplus          = 81;
cmdfr3_strmakminus         = 82;
cmdfr3_strvspmakplus       = 83;
cmdfr3_strvspmakminus      = 84;
//----------------------------------------------------------------------------------------
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
cmdfr3_datrazreshotpr       = 126; //------ ���� ���������� ����������� �� ������� (� ���)
cmdfr3_snatrazreshotpr      = 127; //----------- ����� ���������� ����������� �� ������� )
cmdfr3_otmenaOtklUkg        = 128; //------------------------------- ������ ���������� ���
cmdfr3_NAS_Vkl              = 129; //---------------------- �������� �������� ������������
cmdfr3_NAS_Otkl             = 130; //--------------------- ��������� �������� ������������
cmdfr3_CHAS_Vkl             = 131; //------------------------ �������� ������ ������������
cmdfr3_CHAS_Otkl            = 132; //----------------------- ��������� ������ ������������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------- 133 - 186 ������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cmdfr3_ustanovkastrelok     = 187; //------------------------- ��������� ������� �� ������
cmdfr3_povtormarhmanevr     = 188; //------------ ��������� ��������� ����������� ��������
cmdfr3_povtormarhpoezd      = 189; //-------------- ��������� ��������� ��������� ��������
cmdfr3_marshrutlogic        = 190; //---------------------- ��������� ����������� ��������
cmdfr3_marshrutmanevr       = 191; //-------------- �������� ���������� �������� �� ������
cmdfr3_marshrutpoezd        = 192; //---------------- �������� �������� �������� �� ������
cmdfr3_predviskrazmyk       = 193; //----- �����. ������� �������������� ���������� ��(��)
cmdfr3_predvrazmykstr       = 194; //---- ��������������� ������� ������ ��������� �������
cmdfr3_predvpereezdotkr     = 195; //----------- ��������������� ������� �������� ��������
cmdfr3_predvOtklUkg         = 196; //-------------- ��������������� ������� ���������� ���
cmdfr3_PredvOtklZapMont     = 197; //- ��������������� ������� ���������� ������� ��������
cmdfr3_predvukspsotkl       = 198; //----- �����. ������� ���������� ����� �� ������������
cmdfr3_predvvspotpr         = 199; //--------- �����. ������� ���������������� �����������
cmdfr3_predvvsppriem        = 200; //-------------- �����. ������� ���������������� ������
cmdfr3_predvmanevryri       = 201; // ��������������� ������� �������. ���������� ��������
cmdfr3_predvpabiskpribytie  = 202; //- ��������������� ������� �������������� �������� ���
cmdfr3_predvpereezdzakr     = 203; //----------- ��������������� ������� �������� ��������
cmdfr3_predvotkl3bit        = 204; //--- ��������������� ������� ���������� ������� ���� 3
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------- 205 - 223 ������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cmdfr3_kvitancija           = 224;

var
  s : string;
  ObjFr3,Strelka,Xstr : integer;


implementation

  uses
{$IFNDEF TABLO}
    Marshrut,
{$ENDIF}
    CMenu;

{$IFDEF RMDSP}
//========================================================================================
//---- ��������� ������� ��������� ������ ������ � ������ �������� ���������� � ����������
//----------------------------------- mode - ��� ������� ��� ��������� ������� ������ ����
function Cmd_ChangeMode(mode : integer) : boolean;
begin
  case mode of  //-------------------------------------- ������������� �� �������� �������

    KeyMenu_RazdeRejim ://------------------------------------------ ���������� ����������
    begin
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false; //------------- ������ ����� ��������� ������� �� �����
      WorkMode.RazdUpr := true; WorkMode.MarhUpr := false;// ���������� - ��, �����. - ���
      WorkMode.MarhOtm := false;   //------------------------ ������ ����� ������ ��������
      WorkMode.VspStr  := false;   //------ ������ ����� ���������������� �������� �������
      WorkMode.InpOgr  := false; //------------------- ������ ����� ������ � �������������
      InsNewArmCmd($7ff9,0); //------------------ ��������� � ������
      result := true;
    end;

    KeyMenu_MarshRejim : //----------------------------------------- ���������� ����������
    begin
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.RazdUpr := false;
      WorkMode.MarhUpr := true;
      WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := false;
      InsNewArmCmd($7ff8,0);
      result := true;
    end;

    KeyMenu_OtmenMarsh ://-------------------- ���������/���������� ������ ������ ��������
    begin
      ResetTrace; // �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.MarhOtm := not WorkMode.MarhOtm;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := false;
      if WorkMode.MarhOtm then //----------------------- ���� ��� � ������ ������ ��������
      begin
        InsNewArmCmd($7ff7,0);
        InsArcNewMsg(0,93,7);
        ShowShortMsg(93,LastX,LastY,'');//-------------------- "������� ������ ��� ������"
      end
      else  InsNewArmCmd($7ff6,0);
      result := true;
    end;

    KeyMenu_InputOgr :
    begin //-------------------------------- ���������/���������� ������ ����� �����������
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := not WorkMode.InpOgr;
      if WorkMode.InpOgr then
      begin
        InsNewArmCmd($7ff5,0); InsArcNewMsg(0,94,7);
        ShowShortMsg(94,LastX,LastY,''); //---------------- ������� ������ ��� �����������
      end else
        InsNewArmCmd($7ff4,0);
      result := true;
    end;

    KeyMenu_VspPerStrel :
    begin //---------------- ���������/���������� ������ ���������������� �������� �������
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false;
   //   WorkMode.RazdUpr := true;
  //    WorkMode.MarhUpr := false;
      WorkMode.MarhOtm := false;
      WorkMode.InpOgr  := false;
      WorkMode.VspStr  := not WorkMode.VspStr;
      if WorkMode.VspStr then
      begin
        InsArcNewMsg(0,88,7);
        ShowShortMsg(88,LastX,LastY,''); //----------------- "������� ������� ��� ��������
      end else
      begin
        InsArcNewMsg(0,95,7); //------ "���������� ����� ����������� ���������� ���������"
        ShowShortMsg(95,LastX,LastY,'');
        VspPerevod.Active := false;
      end;
      result := true;
    end;

    KeyMenu_EndTrace :
    begin //-------------------------------------------------------- ����� ������ ��������
      WorkMode.GoMaketSt := false;
      if MarhTracert[1].MsgCount > 1 then //------------ ���� ���� ��������� �������������
      begin
        dec(MarhTracert[1].MsgCount);
        CreateDspMenu(KeyMenu_ReadyResetTrace,LastX,LastY);
        DspMenu.WC := true;
        result := true;
      end else
      if MarhTracert[1].MsgCount = 1 then
      begin  ResetTrace;result:=true; end // ���� �������� ���� ������������- ����� ������
      else
      //------------------------------------------------------------- ����� ��������������
      if(MarhTracert[1].WarCount>0) and
      ((MarhTracert[1].ObjEnd>0) or (MarhTracert[1].FullTail)) then
      begin
        dec(MarhTracert[1].WarCount);
        if MarhTracert[1].WarCount > 0 then
        begin
//          SingleBeep := true;
          TimeLockCmdDsp := LastTime;
          LockCommandDsp := true;
          ShowWarning := true;
          CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
        end
        else CreateDspMenu(CmdMarsh_Ready,LastX,LastY);//1102 ��������� ��������� ��������
        result := true;
      end else
      if WorkMode.MarhUpr and WorkMode.GoTracert then
      begin //---------------------- ��������� ����������� �������� � ������������ �������
        if EndTracertMarshrut then //���� ������ ������� ���������� ������ ������ ��������
        begin //----------------------------------- ������������ ������ ��������� ��������
          if MarhTracert[1].WarCount > 0 then //----------------- ���� ���� ��������������
          begin //--------------------------------------------------- ����� ��������������
            SingleBeep := true;
            TimeLockCmdDsp := LastTime;
            LockCommandDsp := true;
            ShowWarning := true;
            // KeyMenu_ReadyWarningTrace 1013 (�������� ������������� ��������� �� ������)
            CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
          end
          //----------------------- CmdMarsh_Ready 1102 (������������� ��������� ��������)
          else CreateDspMenu(CmdMarsh_Ready,LastX,LastY); //------ ���� ��� ��������������
        end
         //------ ����� ������ ��������������, ��� �������� ����� �������� ������� �������
        else CreateDspMenu(KeyMenu_EndTraceError,LastX,LastY);
        result := true;
      end
      //------------------- ���� �� ����.���������� ��� �� �����������, �� ����� ���������
      else begin ResetShortMsg; result := false; end;
    end;

    KeyMenu_PodsvetkaStrelok :
    begin //-------------------------------------- 1021 ������ ��������� ��������� �������
      WorkMode.GoMaketSt := false;
      WorkMode.Podsvet := not WorkMode.Podsvet;
      if WorkMode.Podsvet then InsNewArmCmd($7ff3,0)
      else InsNewArmCmd($7ff2,0);
      result := true;
    end;

    KeyMenu_VvodNomeraPoezda :
    begin //---------------------------------------------- 1022 ������ ����� ������ ������
      WorkMode.GoMaketSt := false;
      WorkMode.InpTrain := not WorkMode.InpTrain;
      if WorkMode.InpTrain then InsNewArmCmd($7ff1,0)
      else InsNewArmCmd($7ff0,0);
      result := true;
    end;

    KeyMenu_PodsvetkaNomerov : begin //-------------- 1023 ������ ��������� ������ �������
      WorkMode.GoMaketSt := false;
      WorkMode.NumTrain := not WorkMode.NumTrain;
      if WorkMode.NumTrain then InsNewArmCmd($7fef,0)
      else InsNewArmCmd($7fee,0);
      result := true;
    end;

    else  result := false; //-------------------------- ���� ��� ������ ���������� ������� 
  end;
end;
{$ENDIF}

//========================================================================================
//----------------------------------------------------------- ��������� ������� ����������
function SelectCommand : boolean;
var
  i,o,p,ObjMaket,Strelka,XStr : integer;
  obj_for_kom : integer;
  TXT : string;
  ComServ : Byte;
  ObjServ : Word;
begin
  //-------------------------------------------------------- ����� ���������� ����/�������
  DspMenu.Ready := false;
  DspMenu.WC := false;
  DspMenu.obj := -1;
  //ShowWarning := false;
{$IFDEF RMDSP}
//-------------------------------------------------------- ��������� ����� ������� � �����
  if (DspCommand.obj > 0) and (DspCommand.Command > 0) then
  InsNewArmCmd(DspCommand.obj+$4000,DspCommand.Command);

  //---------------------------------- ��������� ������ � ������ ���������� �������� �����
  if DspCommand.Active then
  begin
    case DspCommand.Command of
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //---------- ������� ������ ������ ������ ��-���, ������ ������� ������ � ����������
      KeyMenu_RazdeRejim,
      KeyMenu_MarshRejim,
      KeyMenu_OtmenMarsh,
      KeyMenu_InputOgr,
      KeyMenu_VspPerStrel,
      KeyMenu_PodsvetkaStrelok,
      KeyMenu_VvodNomeraPoezda,
      KeyMenu_PodsvetkaNomerov,
      KeyMenu_EndTrace :
      begin
        result := Cmd_ChangeMode(DspCommand.Command);
        exit;
      end; //--- �������� �����
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_Osnovnoy ://------------------------------- ������ �� ��������� ������� ����
      begin
        ComServ := cmdfr3_directmanual;
        ObjServ := WorkMode.DirectStateSoob;
        //------------------------------------ ��� ��������   WorkMode.Upravlenie := true;
        InsNewArmCmd($7fed,0);
        SendCommandToSrv(ObjServ,ComServ,0);
        result := true;
        exit;
      end;
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RU1 ://�������� 1-�� ��.��������� ����������� ��������� ������ ������ ��-���
      begin
        InsNewArmCmd($7fec,0);
        config.ru := 1; SetParamTablo;
        result := true;
        exit;
      end;
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RU2 ://�������� 2-�� ��.��������� ����������� ��������� ������ ������ ��-���
      begin
        InsNewArmCmd($7feb,0);
        config.ru := 2; SetParamTablo; result := true; exit;
      end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ResetCommandBuffers : //---------------------------- ����� ������� ������ ��
      begin
        InsNewArmCmd($7fea,0);
        CmdCnt := 0;   //-------------------------------- ����� �������� ���������� ������
        WorkMode.MarhRdy := false; //----------------- ����� ���������� ���������� �������
        WorkMode.CmdReady := false; //--------------- ����� �������� ������������� �������
        result := true;
        exit;
      end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RestartServera : //-------------------------------------- ���������� �������
      begin
        CreateDspMenu(KeyMenu_ReadyRestartServera,LastX,LastY);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_RezervARM ://----------------------------------------- ������� ���� � ������
      begin
        InsNewArmCmd($7fe9,0);
        if WorkMode.Upravlenie then //------------ ���� ����� ��� ��� �������� �����������
        begin
          //-------------- ���� ��� ���������� �� ��� (����� ��) ��� ��� ������ �� �������
          if ((StateRU and $40) = 0) or WorkMode.BU[0] then
          begin
            WorkMode.Upravlenie := false;
            StDirect := false;
            ChDirect := true;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRestartServera : //---- 1017 �������� ������������� ����������� �������
      begin
        ComServ := cmdfr3_restartservera;
        ObjServ := WorkMode.ServerStateSoob;
        if SendCommandToSrv(ObjServ,ComServ,0) then
        begin
          IncrementKOK;
          InsArcNewMsg(0,$2000+349,7);   //---------- "������ ������� ����������� �������"
          AddFixMessage(GetShortMsg(1,349,'',7),4,2);
          ResetShortMsg;
          SendRestartServera := true;
        end;
        result := true; exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RestartUVK :
      begin
        IndexFR3IK := DspCommand.Obj;
        CreateDspMenu(KeyMenu_ReadyRestartUVK,LastX,LastY);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRestartUVK :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_restartuvk;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          IncrementKOK;
          ResetShortMsg;
          InsArcNewMsg(DspCommand.Obj,$2000+350,7);//---- "������ ������� ������������ ��"
          msg := GetShortMsg(1,350,ObjZav[DspCommand.Obj].Liter,7);
          ShowShortMsg(350,LastX,LastY,''); 
          AddFixMessage(msg,4,2);
        end;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RescueOTU :  //------------------------------ 189 ������������ ��������� ���
      begin
        IndexFR3IK := DspCommand.Obj;
        //KeyMenu_ReadyRescueOTU=1024 ����� ������������� �������������� ���������� ������
        CreateDspMenu(KeyMenu_ReadyRescueOTU,LastX,LastY);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRescueOTU :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_rescueotu;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        //------------------------ ��� ������� ��� �������� � ������ cmdfr3_rescueotu  125
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          IncrementKOK;
          InsArcNewMsg(DspCommand.Obj,$2000+506,7);
          AddFixMessage(GetShortMsg(1,506,ObjZav[DspCommand.Obj].Liter,7),4,2);
          ResetShortMsg;
        end;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ClearTrace :
      begin //-------------------------- ����� ����������� ��������, ������� ������ ������
        if CmdCnt > 0 then
        AddFixMessage(GetShortMsg(1,296,GetNameObjZav(CmdBuff.LastObj),1),7,2);
        CmdCnt := 0;                  // ����� ���������� ������ � �����������
        WorkMode.MarhRdy := false; // ����� ���������� �������
        WorkMode.CmdReady := false;   // ����� ���������� �� �� �������� ���������
        ResetCommands;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_DateTime :
      begin //-------------------------------------------------------- ���� ������� ��-���
        ResetTrace; // �������� �������� ������
        WorkMode.GoMaketSt := false;
        WorkMode.MarhOtm := false;
        WorkMode.VspStr := false;
        WorkMode.InpOgr := false;
        if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 /24) then
        begin
          InsArcNewMsg(0,188,7);
          ShowShortMsg(188,LastX,LastY,'');
          ShowWindow(Application.Handle,SW_SHOW);
          case TimeInputDlg.ShowModal of
            mrOk :
            begin
              DateTimeToString(s,'hh:mm:ss', NewTime);
              InsArcNewMsg(0,317,7);
              ShowShortMsg(317,LastX,LastY,s);
            end;
            mrNo :
            begin
              InsArcNewMsg(0,435,1); //----- ��������� ������� � 22:55 �� 01:05 ���������!
              ShowShortMsg(435,LastX,LastY,'');
            end;
          else
            ResetShortMsg;
          end;
        end;
        ShowWindow(Application.Handle,SW_HIDE);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_BellOff :
      begin //-------------------------------------------------- ����� ������������ ������
        InsNewArmCmd($7fe8,0);
        sound := false; result := true; exit;
      end;
    end;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------- �������� ������������ ������������ ������
  if not WorkMode.GoTracert then
  begin
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin
      InsNewArmCmd($7fff,0);
      ShowShortMsg(76,LastX,LastY,'');  //--------------------------- ���������� ���������
      result := false;
      exit;
    end;
    if CmdCnt > 0 then
    begin //------------- ����� ������ �������� - ���������� ������ �� ������������ ������
      InsNewArmCmd($7ffe,0);
      ShowShortMsg(251,LastX,LastY,'');
      result := false;
      exit;
    end;
  end;

  if DspCommand.Active then
  begin
    case DspCommand.Command of
    //----------------------------------------------------------------- ������� �� �������
    //---------------------------------------------------------------------------- �������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrPerevodPlus :
      begin
        WorkMode.InpOgr := false;
        if maket_strelki_index = ObjZav[DspCommand.Obj].BaseObject then
        begin CreateDspMenu(CmdStr_ReadyMPerevodPlus,LastX,LastY); end
        else begin CreateDspMenu(CmdStr_ReadyPerevodPlus,LastX,LastY); end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrPerevodMinus :
      begin
        WorkMode.InpOgr := false;
        if maket_strelki_index = ObjZav[DspCommand.Obj].BaseObject then
        begin CreateDspMenu(CmdStr_ReadyMPerevodMinus,LastX,LastY); end
        else begin CreateDspMenu(CmdStr_ReadyPerevodMinus,LastX,LastY); end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_AskPerevod :
      begin // ������ �������� �������
        CreateDspMenu(CmdStr_AskPerevod,LastX,LastY);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyPerevodPlus :
      begin
        ComServ := cmdfr3_strplus;
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;

        if WorkMode.VspStr then //------------------- ���� ��������������� ������� �������
        begin
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end
        else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then //-- ���� ��������� �� ��
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end
        else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and // ���� ���� ��������� ��� �
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then //........ ���� �������� ���
        begin//��������� ���������� �������� ������� ��������������� ��������� (���, ����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := true;
          ObjZav[DspCommand.Obj].bParam[23] := false;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,12,2);
          ShowShortMsg(12, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyPerevodMinus :
      begin
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        ComServ := cmdfr3_strminus;
        if WorkMode.VspStr then
        begin //------------------------------------------ ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin //----------------------------------------------------------- ������� ������
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin //��������� ���������� �������� ������� ��������������� ��������� (���,����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := false;
          ObjZav[DspCommand.Obj].bParam[23] := true;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,13,7);
          ShowShortMsg(13, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------- ���� ������ ������� � STAN  ��� �������� � ���� ������� �� ������
      CmdStr_ReadyMPerevodPlus :
      begin
        Strelka := DspCommand.Obj;
        XStr :=  ObjZav[Strelka].BaseObject;
        ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
        ComServ := cmdfr3_strmakplus;
        ObjZav[XStr].iParam[5] := cmdfr3_strmakplus; //---------------- ���������� �������
        ObjZav[XStr].iParam[4] := 0; //----------------------------- ���������� ����������
        ObjZav[XStr].Timers[3].First := LastTime + 5/80000;//-------------- ����� ��������
        ObjZav[XStr].Timers[3].Active := true; //--------------------- ������������ ������
        if WorkMode.VspStr then
        begin //------------------------------------------ ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin //----------------------------------------------------------- ������� ������
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin //��������� ���������� �������� ������� ��������������� ��������� (���,����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := true;
          ObjZav[DspCommand.Obj].bParam[23] := false;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,20,2);
          ShowShortMsg(20, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          shortmsgcolor[1] := GetColor1(2);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------- ���� ������ ������� � STAN  ��� �������� � ����� ������� �� ������
      CmdStr_ReadyMPerevodMinus :
      begin
        Strelka := DspCommand.Obj;
        XStr := ObjZav[Strelka].BaseObject;
        ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
        ComServ := cmdfr3_strmakminus;
        ObjZav[XStr].iParam[5] := cmdfr3_strmakminus; //--------------- ���������� �������
        ObjZav[XStr].iParam[4] := 0; //----------------------------- ���������� ����������
        ObjZav[XStr].Timers[3].First := LastTime + 5/80000; //------------- ����� ��������
        ObjZav[XStr].Timers[3].Active := true;

        if WorkMode.VspStr then
        begin //------------------------------------------ ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin //----------------------------------------------------------- ������� ������
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin // ��������� ���������� �������� ������� ��������������� ���������(���,����)
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,392+$4000,1);
          ShowShortMsg(392,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          ObjZav[DspCommand.Obj].bParam[22] := false;
          ObjZav[DspCommand.Obj].bParam[23] := true;
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,21,7);
          ShowShortMsg(21, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodPlus :
      begin
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        if ObjZav[DspCommand.Obj].BaseObject = maket_strelki_index then
        begin //---------------------------------------- �� ������ ��������������� �������
          ComServ := cmdfr3_strvspmakplus;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := true;
            ObjZav[DspCommand.Obj].bParam[23] := false;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,14,2);
            ShowShortMsg(14, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end else
        begin // ��������������� �������
          ComServ := cmdfr3_strvspplus;
          if SendCommandToSrv(ObjServ,ComServ ,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := true;
            ObjZav[DspCommand.Obj].bParam[23] := false;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,14,2);
            ShowShortMsg(14, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodMinus :
      begin
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        if ObjZav[DspCommand.Obj].BaseObject = maket_strelki_index then
        begin //---------------------------------------- �� ������ ��������������� �������
          ComServ := cmdfr3_strvspmakminus;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := false;
            ObjZav[DspCommand.Obj].bParam[23] := true;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,15,7);
            ShowShortMsg(15,LastX,LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end else
        begin //-------------------------------------------------- ��������������� �������
          ComServ := cmdfr3_strvspminus;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := false;
            ObjZav[DspCommand.Obj].bParam[23] := true;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,15,7);
            ShowShortMsg(15,LastX, LastY,ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrOtklUpravlenie :
      begin
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        ComServ := cmdfr3_otklupr;
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[18] := true;
        o := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[8];
        p := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[9];
        if (o > 0) and (p > 0) then
        begin
          if o = DspCommand.Obj then ObjZav[p].bParam[18] := true else
          if p = DspCommand.Obj then ObjZav[o].bParam[18] := true;
        end;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,16,7);
          ShowShortMsg(16, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrVklUpravlenie :
      begin
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        ComServ := cmdfr3_vklupr;
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[18] := false;
        o := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[8];
        p := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[9];
        if (o > 0) and (p > 0) then
        begin
          if o = DspCommand.Obj then ObjZav[p].bParam[18] := false else
          if p = DspCommand.Obj then ObjZav[o].bParam[18] := false;
        end;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,17,2);
          ShowShortMsg(17, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrZakrytDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        ObjZav[DspCommand.Obj].bParam[16] := true;

        if ObjZav[DspCommand.Obj].ObjConstB[6] then ComServ := cmdfr3_blokirov2 // �������
        else  ComServ := cmdfr3_blokirov;//--------------------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,18,7);
          ShowShortMsg(18, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrOtkrytDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[16] := false;
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;

        if ObjZav[DspCommand.Obj].ObjConstB[6] then ComServ := cmdfr3_razblokir2 //�������
        else ComServ := cmdfr3_razblokir;//--------------------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,452,2);
          ShowShortMsg(452, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrZakrytProtDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        ObjZav[DspCommand.Obj].bParam[17] := true;

        if ObjZav[DspCommand.Obj].ObjConstB[6] then
        ComServ := cmdfr3_strzakryt2protivosh //---------------------------------- �������
        else ComServ := cmdfr3_strzakrytprotivosh; //----------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,451,7);
          ShowShortMsg(451, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrOtkrytProtDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjZav[DspCommand.Obj].bParam[17] := false;
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        if ObjZav[DspCommand.Obj].ObjConstB[6]
        then ComServ := cmdfr3_strotkryt2protivosh //----------------------------- �������
        else ComServ := cmdfr3_strotkrytprotivosh; //----------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,19,2);
          ShowShortMsg(19, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_UstMaketStrelki :
      begin //------------------------------------------------ ���������� ������� �� �����
        Strelka := DspCommand.Obj;
        XStr := ObjZav[Strelka].BaseObject;
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        WorkMode.GoMaketSt := false;
        for i := 1 to High(ObjZav) do
        begin  //------------------------------------ �������� ����������� ��������� �����
          if (ObjZav[i].RU = config.ru) and (ObjZav[i].TypeObj = 20) then
          begin
            if ObjZav[i].bParam[2] then
            begin //---------------------------------------------------- ��������� �������
              if not ObjZav[Strelka].bParam[1] and //------- ���� ������� �� � ����� � ...
              not ObjZav[Strelka].bParam[2] then   //------------------------- �� � ������
              begin //-------------------------------------------------- ��������� �������
                ObjZav[XStr].iParam[4] := 1; //------ ������� ������ ��������� ������ ����
                ObjZav[XStr].iParam[5] := 0; //--------- ��������� ��������� ���� ��������

                maket_strelki_index := XStr;
                maket_strelki_name  := ObjZav[XStr].Liter;

                ObjZav[XStr].bParam[19] := true;
                ObjZav[XStr].bParam[15] := true;
                ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
                ComServ := cmdfr3_ustmaket;
                if SendCommandToSrv(ObjServ,ComServ,XStr) then
                begin
                  InsArcNewMsg(XStr,10,7);//--------------- ������� $ ����������� �� �����
                  ShowShortMsg(10, LastX, LastY, ObjZav[XStr].Liter);
                end;
              end else
              begin //-------------- ���� �������� ��������� - ����� �� ��������� �� �����
                InsArcNewMsg(XStr,92,1);
                ResetShortMsg;
                AddFixMessage(GetShortMsg(1,92,ObjZav[XStr].Liter,1),4,1);
              end;
              break;
            end;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SnatMaketStrelki :
      begin //----------------------------------------------------- ����� ������� � ������
        Strelka := DspCommand.Obj;
        XStr := maket_strelki_index;
        WorkMode.InpOgr := false;
        WorkMode.GoMaketSt := false;
        ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
        ComServ := cmdfr3_snatmaket;
        if SendCommandToSrv(ObjServ,ComServ,XStr) then
        begin
          InsArcNewMsg(Xstr,11,7);
          ShowShortMsg(11, LastX, LastY, maket_strelki_name);
          ObjZav[Xstr].bParam[19] := false;
          ObjZav[Xstr].bParam[15] := false;
          ObjZav[Xstr].iParam[4] := 0; //--------------- �������� ������� ������ ���������
          ObjZav[Xstr].iParam[5] := 0; //-------------------- ��������� ��������� ��������
          ObjZav[Xstr].Timers[3].First := 0; //-------------------- �������� ������ ������
          ObjZav[Xstr].Timers[3].Active := false; //------------------ �������� ����������
          fr4[Xstr] := fr4[Xstr] and $fd;
          ObjMaket := ObjZav[Strelka].VBufferIndex;
          OVBuffer[ObjMaket].Param[31] := false;
          maket_strelki_index := 0;
          maket_strelki_name  := '';
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ResetMaket :
      begin //----------------------------- �������� ����� ������� � ������ ������� ������
        WorkMode.InpOgr := false;
        WorkMode.GoMaketSt := false;
        Strelka := DspCommand.Obj;
        XStr := ObjZav[Strelka].BaseObject;
        ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
        ComServ := cmdfr3_snatmaket;
        if SendCommandToSrv(ObjServ,ComServ,XStr) then
        begin
          InsArcNewMsg(XStr,11,1);
          ShowShortMsg(11, LastX, LastY, ObjZav[Xstr].Liter);
          ObjZav[XStr].bParam[19] := false;
          ObjZav[XStr].bParam[15] := false;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------------------ ���������
      CmdMarsh_RdyRazdMan :
      begin //------------------------------------- ������ ������� ����������� �����������
        if SetProgramZamykanie(1,false) then
        begin
          ObjZav[DspCommand.Obj].bParam[34] := true;
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
          ComServ := cmdfr3_svotkrmanevr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,22,7);
            ShowShortMsg(22, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_RdyRazdPzd :
      begin //--------------------------------------- ������ ������� ����������� ���������
        if SetProgramZamykanie(1,false) then
        begin
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
          ComServ := cmdfr3_svotkrpoezd;
          ObjZav[DspCommand.Obj].bParam[34] := true;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,23,2);
            ShowShortMsg(23, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkrytManevrovym :
      begin //--------------------------------------------- ������ ����������� �����������
        WorkMode.InpOgr := false;
        if OtkrytRazdel(DspCommand.Obj,MarshM,1) then
        CreateDspMenu(CmdMarsh_RdyRazdMan,LastX,LastY);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkrytProtjag :
      begin // ������ ������� �������� ����������� ��� ��������
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_svprotjagmanevr;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,417,7);
          ShowShortMsg(417, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkrytPoezdnym :
      begin // ������ ����������� ���������
        WorkMode.InpOgr := false;
        if OtkrytRazdel(DspCommand.Obj,MarshP,1) then
          CreateDspMenu(CmdMarsh_RdyRazdPzd,LastX,LastY);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Razdel :
      begin
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
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaManevrovogo :
      begin
        WorkMode.MarhOtm := false;
        WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCommand.Obj,MarshM); //������ ������� ������ �����������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaPoezdnogo :
      begin
        WorkMode.MarhOtm := false; WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCommand.Obj,MarshP); // ������ ������� ������ ���������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorManevrovogo :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_svpovtormanevr;
        if PovtorSvetofora(DspCommand.Obj, MarshM,1) then
        begin //----------------------------------------------------------- ������ �������
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,26,7);
            ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorPoezdnogo :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
        ComServ := cmdfr3_svpovtorpoezd;
        if PovtorSvetofora(DspCommand.Obj, MarshP,1) then
        begin // ������ �������
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,27,2);
            ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Povtor :
      begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_Povtor,LastX,LastY);
        end else
        begin //--------------------------------------- ������ ������� ���������� ��������
          if ObjZav[DspCommand.Obj].bParam[6] or ObjZav[DspCommand.Obj].bParam[7] then
          begin //--------------------------------------------------------------------- ��
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
            ComServ := cmdfr3_svpovtormanevr;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,26,7);//������ ������� ����. �������� ����������
              ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          if ObjZav[DspCommand.Obj].bParam[8] or ObjZav[DspCommand.Obj].bParam[9] then
          begin //----------------------------------------------------- ���� ���� ������ �
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
            ComServ := cmdfr3_svpovtorpoezd;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,27,2); // ������ ������� ����. �������� ��������
              ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
            ResetShortMsg;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorOtkrytManevr :
      begin
        WorkMode.InpOgr := false;
        if PovtorOtkrytSvetofora(DspCommand.Obj, MarshM,1) then
        begin //----------------------------------------------------------- ������ �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
          ComServ := cmdfr3_povtorotkrytmanevr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,26,7);// ������ ������� �����. �������� ����������
            ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
        ResetTrace;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorOtkrytPoezd :
      begin
        WorkMode.InpOgr := false;
        if PovtorOtkrytSvetofora(DspCommand.Obj, MarshP,1) then
        begin //----------------------------------------------------------- ������ �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
          ComServ := cmdfr3_povtorotkrytpoezd;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,27,2);
            ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
        ResetTrace;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorOtkryt :
      begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_PovtorOtkryt,LastX,LastY);
        end else
        begin //--------------------------------------- ������ ������� ���������� ��������
          if ObjZav[DspCommand.Obj].bParam[6] or ObjZav[DspCommand.Obj].bParam[7] then
          begin //--------------------------------------------------------------------- ��
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
            ComServ := cmdfr3_povtorotkrytmanevr;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,26,7);
              ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          if ObjZav[DspCommand.Obj].bParam[8] or ObjZav[DspCommand.Obj].bParam[9] then
          begin //---------------------------------------------------------------------- �
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
            ComServ := cmdfr3_povtorotkrytpoezd;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,27,2);
              ShowShortMsg(27, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end
          else ResetShortMsg;
          ResetTrace;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorManevrMarsh :
      begin
        WorkMode.InpOgr := false;
        if PovtorMarsh(DspCommand.Obj,MarshM,1) then  SendMarshrutCommand(1);//������ �������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorPoezdMarsh :
      begin
        WorkMode.InpOgr := false;
        if PovtorMarsh(DspCommand.Obj,MarshP,1)
        then SendMarshrutCommand(1);//------------------------------------- ������ �������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorMarh :
      begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_PovtorMarh,LastX,LastY);
        end else SendMarshrutCommand(1); // ������ ������� ��������� ��������� ��������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_BlokirovkaSvet :
      begin
        WorkMode.InpOgr := false; ObjZav[DspCommand.Obj].bParam[13] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_blokirov;
        if ObjServ = 0 then ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,28,7);//-------------- ������ ������� ������������ $
          ShowShortMsg(28, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_DeblokirovkaSvet :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        if ObjServ = 0 then ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
        ComServ := cmdfr3_razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,29,7); //-------- ������ ������� ������ ���������� $
          ShowShortMsg(29, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_BeginMarshManevr :
      begin //------------------------------------ ������ ����������� ����������� ��������
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCommand.Obj, DspCommand.Command);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_BeginMarshPoezd :
      begin //-------------------------------------- ������ ����������� ��������� ��������
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCommand.Obj, DspCommand.Command);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------- ������ ������� ��������� ������� �� ��������� ������
      KeyMenu_QuerySetTrace : SendTraceCommand(1);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Tracert ://-- ���� ���������� ����������� ��������,�������� ������ � ������
      begin
        WorkMode.InpOgr := false;  //-------------------- ����� �������� ����� �����������
        if MarhTracert[1].MsgCount > 0 then //------------ ���� ���� ��������� �����������
        begin
          if MarhTracert[1].GonkaStrel and //-------------- ���� ��������� ����� ������� �
          (MarhTracert[1].GonkaList > 0) then //-------- � ������ ���� ����������� �������
           // KeyMenu_QuerySetTrace = 1020 ������ �� ��������� ������� �� ��������� ������
           CreateDspMenu(KeyMenu_QuerySetTrace,LastX,LastY)//- ������ ������ ������� �����
          else
          begin //--------------------------------------------------- ����� �������� �����
            ResetTrace;
            PutShortMsg(1,LastX,LastY,MarhTracert[1].Msg[1]);
          end;
        end else //---------------------------------------- ���� ��� ��������� �����������
        if (MarhTracert[1].WarCount > 0) and //------------ ���� ���� �������������� � ...
        ((MarhTracert[1].ObjEnd > 0) or //- ��������� ����� �������� ��� ����� ��� "�����"
        (MarhTracert[1].FullTail)) then
        begin
          dec(MarhTracert[1].WarCount); //--------------- ��������� ������� ��������������
          if MarhTracert[1].WarCount > 0 then //--------- ���� ��� �������� ��������������
          begin
//            SingleBeep := true;
            TimeLockCmdDsp := LastTime;
            LockCommandDsp := true;
            ShowWarning := true;
            //KeyMenu_ReadyWarningTrace = 1013  �������� ������������� ��������� �� ������
            CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
          end
          //���� ����� �������������� CmdMarsh_Ready=1102 ������������� ��������� ��������
          else CreateDspMenu(CmdMarsh_Ready,LastX,LastY);
        end
        // ���� ��� �������������� ��� �� ��������� ����� ��������, ���������� �����������
        else AddToTracertMarshrut(DspCommand.Obj);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Manevr ://------------------- ���� ����������� ������� ����������� ��������
      if SetProgramZamykanie(1,false) then  SendMarshrutCommand(1);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Poezd : //------------------------- ������������ ������� ��������� ��������
      if SetProgramZamykanie(1,false) then SendMarshrutCommand(1);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------------- ����������� ������
      CmdMenu_BlokirovkaNadviga :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[1];
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,28,7); //------------- ������ ������� ������������ $
          ShowShortMsg(28, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------ �������������� ������
      CmdMenu_DeblokirovkaNadviga :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[1];
        ComServ := cmdfr3_razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,29,7);
          ShowShortMsg(29, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------ ��������� ������������ ����������
      CmdMenu_AutoMarshVkl :
      begin
        if ObjZav[DspCommand.Obj].ObjConstB[1] then ComServ := cmdfr3_CHAS_Vkl //----- ���
        else ComServ := cmdfr3_NAS_Vkl;

        if AutoMarsh(DspCommand.Obj,true) then
        if SendCommandToSrv(config.avtodst,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,421,2);
          ShowShortMsg(421, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------- ���������� ������������ ����������
      CmdMenu_AutoMarshOtkl :
      begin
        if ObjZav[DspCommand.Obj].ObjConstB[1] then ComServ := cmdfr3_CHAS_otkl //---- ���
        else ComServ := cmdfr3_NAS_otkl;
        if AutoMarsh(DspCommand.Obj,false) then
        if SendCommandToSrv(config.avtodst,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,422,7);
          ShowShortMsg(422, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_ResetTraceParams :
      begin //--------------------------------------------- ����� �������������� ���������
        case ObjZav[DspCommand.Obj].TypeObj of
          2 :   //---------------------------------------------------------------- �������
          begin
            ObjZav[DspCommand.Obj].bParam[4]  := false; //-------- �������� ���. ���������
            ObjZav[DspCommand.Obj].bParam[6]  := false; //-------------------- �������� ��
            ObjZav[DspCommand.Obj].bParam[7]  := false; //-------------------- �������� ��
            ObjZav[DspCommand.Obj].bParam[10] := false; // �������� 1-� ������ �����������
            ObjZav[DspCommand.Obj].bParam[11] := false; // �������� 2-� ������ �����������
            ObjZav[DspCommand.Obj].bParam[12] := false;//����� ���������� �������� � �����
            ObjZav[DspCommand.Obj].bParam[13] := false;// ����� �������. �������� � ������
            ObjZav[DspCommand.Obj].bParam[14] := false; //------ �������� ��������� �� ���
            ObjZav[DspCommand.Obj].iParam[1] := 0; //-------------- ����� ������� ��������

            o := ObjZav[DspCommand.Obj].BaseObject; //---------------------- ����� �������
            ObjZav[o].bParam[4]  := false; //--------------------- �������� ���. ���������
            ObjZav[o].bParam[6]  := false; //--------------------------------- �������� ��
            ObjZav[o].bParam[7]  := false; //--------------------------------- �������� ��
            ObjZav[o].bParam[14] := false; //----------------------- �������� ��������� ��
            ResetShortMsg;
          end;

          3 :   //---------------------------------------------------------------- �������
          begin
            ObjZav[DspCommand.Obj].bParam[14] := false; //--- ����� ������������ ���������
            ObjZav[DspCommand.Obj].bParam[15] := false; //---------------------- ����� 1��
            ObjZav[DspCommand.Obj].bParam[16] := false; //---------------------- ����� 2��
            ObjZav[DspCommand.Obj].iParam[1] := 0; //-------------- ����� ������� ��������
            ObjZav[DspCommand.Obj].iParam[2] := 0; //--------------- ����� ������� �������
            ObjZav[DspCommand.Obj].bParam[8] := true; // ����� ��������������� �����������
            o := DspCommand.Obj;

            ObjServ := ObjZav[o].ObjConstI[2] div 8;
            ComServ := cmdfr3_resettrace;
            if SendCommandToSrv(ObjServ,ComServ,o) then
            begin
              InsArcNewMsg(o,312,7); //--------------------- "������ ������� ������������"
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);

              for p := 1 to High(ObjZav) do //------------ ������ �� ���� �������� �������
              case ObjZav[p].TypeObj of
                2 ://------------------------------------------------------------- �������
                begin
                  if ObjZav[p].UpdateObject = DspCommand.Obj then //-- ������� � ������ ��
                  begin //- ����� �������� ����������� �������, ��������� � ������ �������
                    ObjZav[p].bParam[6]  := false; //--------------------------- ������ ��
                    ObjZav[p].bParam[7]  := false; //--------------------------- ������ ��
                    ObjZav[p].bParam[10] := false; //----- �������� 1-� ������ �����������
                    ObjZav[p].bParam[11] := false; //----- �������� 2-� ������ �����������
                    ObjZav[p].bParam[12] := false;//---- ����� ���������� �������� � �����
                    ObjZav[p].bParam[13] := false;//--- ����� ���������� �������� � ������
                    ObjZav[p].bParam[14] := false; //--------- ����� ����������� ���������
                    ObjZav[p].iParam[1]  := 0;    //--------------- ����� ������� ��������
                    o := ObjZav[p].BaseObject;    //------------------------ ����� �������
                    ObjZav[o].bParam[6]  := false; //--------------------------- ������ ��
                    ObjZav[o].bParam[7]  := false; //--------------------------- ������ ��
                    ObjZav[o].bParam[14] := false; //--------- ����� ����������� ���������
                  end;
                end;

                41 :
                begin //------------------------------------ �������� �������� �����������
                  if ObjZav[p].UpdateObject = DspCommand.Obj then
                  begin //------ ����� �������������� ��������, ��������� � ������ �������
                    ObjZav[p].bParam[1]  := false;//���������� �������� 1-� ������� � ����
                    ObjZav[p].bParam[2]  := false;//���������� �������� 2-� ������� � ����
                    ObjZav[p].bParam[3]  := false;//���������� �������� 3-� ������� � ����
                    ObjZav[p].bParam[4]  := false;//���������� �������� 4-� ������� � ����
                    ObjZav[p].bParam[8]  := false;//- �������� �������� 1-� ������� � ����
                    ObjZav[p].bParam[9]  := false;//- �������� �������� 2-� ������� � ����
                    ObjZav[p].bParam[10] := false;//- �������� �������� 3-� ������� � ����
                    ObjZav[p].bParam[11] := false;//- �������� �������� 4-� ������� � ����
                    ObjZav[p].bParam[20] := false;//����� ������� ��������� �������� ����.
                    ObjZav[p].bParam[21] := false;//--- ����� ������� ����������� ��������
                    ObjZav[p].bParam[23] := false;//����� ���������. ��������� 1-� �������
                    ObjZav[p].bParam[24] := false;//����� ���������. ��������� 2-� �������
                    ObjZav[p].bParam[25] := false;//����� ���������. ��������� 3-� �������
                    ObjZav[p].bParam[26] := false;//����� ���������. ��������� 4-� �������
                  end;
                end;

                42 :
                begin //------------ ������ ������������� ��������� �������� �� ����������
                  if ObjZav[p].UpdateObject = DspCommand.Obj then //--- ������ ������ � ��
                  begin //------ ����� �������������� ��������, ��������� � ������ �������
                    ObjZav[p].bParam[1]  := false;//----- ����� "�������� �������� ������"
                    ObjZav[p].bParam[2]  := false;//------- ����� ���������� �������������
                    ObjZav[p].bParam[3]  := false; //----------- ����� ��������� �� � ����
                  end;
                end;
              end;
            end;
          end;

          4 :
          begin //------------------------------------------------------------------- ����
            ObjZav[DspCommand.Obj].bParam[14] := false;
            ObjZav[DspCommand.Obj].iParam[1] := 0;
            ObjZav[DspCommand.Obj].iParam[2] := 0;
            ObjZav[DspCommand.Obj].iParam[3] := 0;
            ObjZav[DspCommand.Obj].bParam[8] := true;
            o := DspCommand.Obj;
            ObjServ := ObjZav[o].ObjConstI[2] div 8;
            ComServ := cmdfr3_resettrace;
            if SendCommandToSrv(ObjServ,ComServ,o) then
            begin
              InsArcNewMsg(o,312,7); //--------------------- ������ ������� ������������ $
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);
            end;
          end;

          5 :
          begin //--------------------------------------------------------------- ��������
            ObjZav[DspCommand.Obj].bParam[14] := false;
            ObjZav[DspCommand.Obj].iParam[1] := 0;
            ObjZav[DspCommand.Obj].bParam[7] := false;
            ObjZav[DspCommand.Obj].bParam[9] := false;
            o := DspCommand.Obj;

            ObjServ := ObjZav[o].ObjConstI[3] div 8;
            if  ObjServ = 0 then ObjServ := ObjZav[o].ObjConstI[5] div 8;
            ComServ := cmdfr3_resettrace;

            if SendCommandToSrv(ObjServ,ComServ,o) then
            begin
              InsArcNewMsg(o,312,7);  //-------------------- ������ ������� ������������ $
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);
            end;
          end;

          else  result := false;
          exit;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// --------------------------------------------------------------------------------�������
      CmdMenu_SekciaPredvaritRI :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        if ObjZav[DspCommand.Obj].ObjConstB[7]
        then i := ObjZav[DspCommand.Obj].BaseObject //---------------------------- �������
        else i := DspCommand.Obj; //----------------------------------------------- ������

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7];
        ComServ := cmdfr3_ispiskrazmyk;

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7] div 8;
        ComServ := cmdfr3_predviskrazmyk;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(i,33,7); //- ������ ���������. ������� �������������� ���������� ��
          ShowShortMsg(33, LastX, LastY, ObjZav[i].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaIspolnitRI :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if ObjZav[DspCommand.Obj].ObjConstB[7] then

        i := ObjZav[DspCommand.Obj].BaseObject //--------------------------------- �������
        else i := DspCommand.Obj; //----------------------------------------------- ������

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //------------- ������ �������������� �������, �������� �������� �����������
          ObjZav[DspCommand.Obj].bParam[14] := false;
          ObjZav[DspCommand.Obj].iParam[1] := 0;
          ObjZav[DspCommand.Obj].bParam[8] := true;

          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7] div 8;
          ComServ := cmdfr3_ispiskrazmyk;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(i,34,7);//������ ������. ������� �������������� ���������� ������
            ShowShortMsg(34, LastX, LastY, ObjZav[i].Liter);
            IncrementKOK;
          end;
        end else
        begin
          InsArcNewMsg(i,155,1); //------ ������� ������� ���������� ������������� �������
          ShowShortMsg(155, LastX, LastY, ObjZav[i].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaZakrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,35,7);
          ShowShortMsg(35, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaOtkrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,36,2);//������ ������� ���������� �������� �� ������
          ShowShortMsg(36, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460,7);//������ ������� ��������  ��� �������� �� ��
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461,2); //������ ������� �������� ��� �������� �� ��
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470,7);//������ ������� �������� ��� �������� �� ~��
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471,2);//������ ������� �������� ��� �������� �� ~��
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465,7);//������ ������� �������� ��� �������� �� =��
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SekciaOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466,2);//������ ������� �������� ��� �������� �� =��
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------------------- ����
      CmdMenu_PutDatSoglasieOgrady :
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZav[ObjZav[DspCommand.Obj].UpdateObject].ObjConstI[4] div 8;
        ComServ := cmdfr3_putustograd;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,37,7);//---- ������ ������� �������� �� ���������� $
          ShowShortMsg(37, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutZakrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,39,7);//------ ������ ������� �������� �������� �� $
          ShowShortMsg(39, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutOtkrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,40,2); //--- ������ ������� ���������� �������� �� $
          ShowShortMsg(40, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutVklOPI :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[1] div 8;
        ComServ := cmdfr3_vklOPI;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,414,7);//������ ������� ���������� �������� ��  ����
          ShowShortMsg(414,LastX,LastY,ObjZav[ObjZav[DspCommand.Obj].UpdateObject].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutOtklOPI :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[1] div 8;
        ComServ := cmdfr3_otklOPI;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,415,7);//������ ������� ����.�������� �� ���� ��� ��
          ShowShortMsg(415,LastX,LastY,ObjZav[ObjZav[DspCommand.Obj].UpdateObject].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460,7);// ������ ������� �������� ��� �������� �� ��
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461,2);// ������ ������� �������� ��� �������� �� ��
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470,7);//������ ������� �������� ��� �������� �� ~��
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471,2);//������ ������� �������� ��� �������� �� ~��
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465,7);//������ ������� �������� ��� �������� �� =��
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PutOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466,2);//������ ������� �������� ��� �������� �� =��
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------------------- ��������� �������
      CmdMenu_ZamykanieStrelok :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_zamykstr;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,41,7); //---------------- ������ ������� ��������� $
          ShowShortMsg(41, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PredvRazmykanStrelok :
      begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2];
        ComServ := cmdfr3_isprazmykstr;

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ); //------ �������� ��������������

        ObjServ := ObjServ div 8;
        ComServ := cmdfr3_predvrazmykstr;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,42,7);//-- ������ ��������������� ������� ����������
          ShowShortMsg(42, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolRazmykanStrelok :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4] div 8;
          ComServ := cmdfr3_isprazmykstr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,43,7);//������ �������������� ������� ���������� $
            ShowShortMsg(43, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------- �������� ������ ��������
      CmdMenu_DatZapretMonteram  :
      begin
        if(ObjZav[DspCommand.Obj].TypeObj=36) and (ObjZav[DspCommand.Obj].BaseObject >0)
        then
        begin
          if not ObjZav[DspCommand.Obj].bParam[2] then
          begin
            InsArcNewMsg(DspCommand.Obj,578,1);
            ShowShortMsg(578, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            DspCommand.Command := 0;
            DspCommand.Active := false;
            DspCommand.Obj := 0;
            exit;
          end;
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        end
        else ObjServ := ObjZav[DspCommand.Obj].ObjConstI[6] div 8;
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_VklZapMont;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,51,7);//������ ������� ���. ������� �������� (�����)
          ShowShortMsg(51, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//----------------------------------------------------------------------------------------
      CmdMenu_PredvOtklZapMont :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        if(ObjZav[DspCommand.Obj].TypeObj=36) and (ObjZav[DspCommand.Obj].BaseObject >0)
        then  ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13]
        else  ObjServ := ObjZav[DspCommand.Obj].ObjConstI[6];
        ComServ := cmdfr3_IspolOtklZapMont;

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := cmdfr3_PredvOtklZapMont;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,529,7); // ������ ����.������� ����.������� ��������
          ShowShortMsg(529, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolOtklZapMont :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;

        if(ObjZav[DspCommand.Obj].TypeObj=36) and (ObjZav[DspCommand.Obj].BaseObject >0)
        then  ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11]
        else  ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7];
        ObjServ := ObjServ div 8;
        ComServ := cmdfr3_IspolOtklZapMont;

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj)
          then
          begin
            InsArcNewMsg(DspCommand.Obj,530,7);//----------- ������ �������������� �������
            ShowShortMsg(530, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//----------------------------------------------------------------------------------------
      {
      CmdMenu_PredvOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[6];
        ComServ := cmdfr3_IspolOtklBit3;

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := cmdfr3_PredvOtklZapMont;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,529); //-- ������ ����.������� ����.������� ��������
          ShowShortMsg(529, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolOtklZapMont :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7] div 8;
        ComServ := cmdfr3_IspolOtklZapMont;

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj)
          then
          begin
            InsArcNewMsg(DspCommand.Obj,530);//------------- ������ �������������� �������
            ShowShortMsg(530, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
      }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------- ���������� ���������
      CmdMenu_ZakrytPereezd :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[12] div 8;
        ComServ := cmdfr3_pereezdzakryt;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,44,7);//-------- ������ ������� �������� ��������  $
          ShowShortMsg(44, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PredvOtkrytPereezd :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[12];
        ComServ := cmdfr3_isppereezdotkr;

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := cmdfr3_predvpereezdotkr;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,45,7);// ������ ���������. ������� �������� ��������
          ShowShortMsg(45, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolOtkrytPereezd :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
          ComServ := cmdfr3_isppereezdotkr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,46,7);//������ ��������. ������� �������� ��������
            ShowShortMsg(46, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_DatIzvecheniePereezd :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8; //--------------------- ���
        ComServ := cmdfr3_pereezdvklizv;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,47,7);//------ ������ ������� ��������� �� ������� $
          ShowShortMsg(47, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SnatIzvecheniePereezd,
      CmdMenu_SnatIzvecheniePereezd1 :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[14] div 8; //-------------------- ����
        if DspCommand.Command = CmdMenu_SnatIzvecheniePereezd
        then  ComServ := cmdfr3_pereezdotklizv
        else ComServ := cmdfr3_pereezdotklizv1;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,48,7);//- ������ ������� ������ ��������� �� �������
          ShowShortMsg(48, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------------------------------------------------------- ���������� ��������
      CmdMenu_DatOpovechenie :
      begin
        WorkMode.InpOgr := false;

        if ObjZav[DspCommand.Obj].TypeObj = 36
        then  ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8
        else ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_opovvkl;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,49,7); //------- ������ ������� ��������� ����������
          ShowShortMsg(49, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SnatOpovechenie :
      begin
        WorkMode.InpOgr := false;

        if ObjZav[DspCommand.Obj].TypeObj = 36
        then  ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8
        else ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_opovotkl;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,50,7);//------- ������ ������� ���������� ����������
          ShowShortMsg(50, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------------------------------- �����
      CmdMenu_PredvOtkluchenieUKSPS :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3];
        ComServ := cmdfr3_ispukspsotkl;
        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_predvukspsotkl;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,53,7);//- ������ ���������. ������� ���������� �����
          ShowShortMsg(53, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolOtkluchenieUKSPS :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
          ComServ := cmdfr3_ispukspsotkl;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,54,7);// ������ ��������. ������� ���������� �����
            ShowShortMsg(54, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,7);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaOtkluchenieUKSPS :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_otmenablokUksps;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,354,7);//---- ������ ������� ������ ���������� �����
          ShowShortMsg(354, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PredvOtkluchenieUKG :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4];
        ComServ := cmdfr3_ispolOtklUkg;

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := cmdfr3_predvOtklUkg;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,566,7);//-- ������ ���������. ������� ���������� ���
          ShowShortMsg(566, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolOtkluchenieUKG:
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
          ComServ := cmdfr3_ispolOtklUkg;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,567,7);//������ ����������. ������� ���������� ���
            ShowShortMsg(567, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaOtkluchenieUKG :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4] div 8;
        ComServ := cmdfr3_otmenaOtklUkg;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,568,7); //----- ������ ������� ������ ���������� ���
          ShowShortMsg(568, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------------------------------------------------------------------- �������
      CmdMenu_SmenaNapravleniya :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_absmena;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,55,7);//������ ������� ����� ����������� �� ��������
          ShowShortMsg(55, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_DatSoglasieSmenyNapr :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[9] div 8;
        ComServ := cmdfr3_absoglasie;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,56,7);//������ ������� �������� �� ����� �����������
          ShowShortMsg(56, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VklKSN :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[1] div 8;
        ComServ := cmdfr3_vklksn;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,409,7);//--- ������ ������� ����������� ��������� ��
          ShowShortMsg(409, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklKSN :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[1] div 8;
        ComServ := cmdfr3_otklksn;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,410,7); //--- ������ ������� ���������� ��������� ��
          ShowShortMsg(410, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PredvVspomOtpravlenie :
      begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4];
        ComServ := cmdfr3_ispvspotpr;
        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4] div 8;
        ComServ := cmdfr3_predvvspotpr;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,59,7);//������ �������. ������� �������. �����������
          ShowShortMsg(59, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolVspomOtpravlenie :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
          ComServ := cmdfr3_ispvspotpr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,60,7);//������ ������. ������� �������.�����������
            ShowShortMsg(60, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PredvVspomPriem :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5];
        ComServ := cmdfr3_ispvsppriem;
        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
        ComServ := cmdfr3_predvvsppriem;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,61,7);//������ �����.������� ���������������� ������
          ShowShortMsg(61, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolVspomPriem :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
          ComServ := cmdfr3_ispvsppriem;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,62,7);//������ ��������. ������� ���������. ������
            ShowShortMsg(62, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ZakrytPeregon :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,57,7); //---------- ������ ������� �������� ��������
          ShowShortMsg(57, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkrytPeregon :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,58,2); //--------- ������ ������� �������� ��������
          ShowShortMsg(58, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SnatSoglasieSmenyNapr :
      begin
        WorkMode.InpOgr := false;
        WorkMode.MarhOtm := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[9] div 8;
        ComServ := cmdfr3_otmenasogsnab;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,438,7); //������ ������� ������ �������� ����� ����.
          ShowShortMsg(438, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ABZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460,7);// ������ ������� �������� ��� �������� �� ��
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ABOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461,2);// ������ ������� �������� ��� �������� �� ��
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ABZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470,7);//������ ������� �������� ��� �������� �� ~��
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ABOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471,2);//������ ������� �������� ��� �������� �� ~��
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ABZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465,7);//������ ������� �������� ��� �������� �� =��
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ABOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466,2);//������ ������� �������� ��� �������� �� =��
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------------------------ ���
      CmdMenu_VydatSoglasieOtpravl :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
        ComServ := cmdfr3_pabsoglasievkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,321,7);//----- ������ ������� �������� ����������� $
          ShowShortMsg(321, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaSoglasieOtpravl :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
        ComServ := cmdfr3_pabsoglasieotkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,322,7);// ������ ������� ������ �������� �����������
          ShowShortMsg(322, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IskPribytiePredv :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4];
        ComServ := cmdfr3_isppabiskpribytie;
        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4] div 8;
        ComServ := cmdfr3_predvpabiskpribytie;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,323,7);//������ �����. ������� �����.�������� ������
          ShowShortMsg(323, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IskPribytieIspolnit :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
          ComServ := cmdfr3_isppabiskpribytie;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,324,7);//������ �����. ������� ���.�������� ������
            ShowShortMsg(324, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VydatPribytiePoezda :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_pabpribytie;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,325,7);//---------- ������ ������� �������� ������ $
          ShowShortMsg(325, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ZakrytPeregonPAB :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,5,7); //-------- ������ ������� �������� �������� $
          ShowShortMsg(57, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkrytPeregonPAB :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,58,2);//--------- ������ ������� �������� �������� $
          ShowShortMsg(58, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RPBZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460,7);
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RPBOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461,2);
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RPBZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470,7);
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RPBOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471,2);
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RPBZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465,7);
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RPBOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
        ComServ := cmdfr3_razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466,2);
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- ���������� ����������� ������
      CmdMenu_ZakrytUvjazki :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[15] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,5,7);//--------- ������ ������� �������� �������� $
          ShowShortMsg(57, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkrytUvjazki :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[15] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,58,2);//--------- ������ ������� �������� �������� $
          ShowShortMsg(58, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_EZZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,460,7);
          ShowShortMsg(460, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_EZOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[24] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,461,2);
          ShowShortMsg(461, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_EZZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,470,7);
          ShowShortMsg(470, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_EZOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[26] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,471,2);
          ShowShortMsg(471, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_EZZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := true;
        if SendCommandToSrv(ObjZav[DspCommand.Obj].ObjConstI[8] div 8,cmdfr3_blokirovETD,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,465,7);
          ShowShortMsg(465, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_EZOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[25] := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,466,2);
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------------------------- ������
      CmdMenu_VkluchOchistkuStrelok :
      begin
        WorkMode.InpOgr := false;
        case (ObjZav[DspCommand.Obj].ObjConstI[11] -
        (ObjZav[DspCommand.Obj].ObjConstI[11] div 8) * 8) of
          0 : ComServ := cmdfr3_knopka1vkl;  //--------------------- ������� � ������ ����
          1 : ComServ := cmdfr3_knopka2vkl; //--------------------- ������� �� ������ ����
        else
          result := false;
          exit;
        end;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then//���� ����� ������� �� ���������
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[6],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklOchistkuStrelok :
      begin
        WorkMode.InpOgr := false;

        case (ObjZav[DspCommand.Obj].ObjConstI[11] -
        (ObjZav[DspCommand.Obj].ObjConstI[11] div 8) * 8) of
          0 : ComServ := cmdfr3_knopka1otkl;
          1 : ComServ := cmdfr3_knopka2otkl;
          else result := false; exit;
        end;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[5] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[7],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //----------------------------------------------------------------------------------
      CmdMenu_VklBit1 :
      begin
        if(ObjZav[DspCommand.Obj].TypeObj=36) and (ObjZav[DspCommand.Obj].BaseObject >0)
        then
        if not ObjZav[DspCommand.Obj].bParam[2] then
        begin
          InsArcNewMsg(DspCommand.Obj,578,1);
          ShowShortMsg(578, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          DspCommand.Command := 0;
          DspCommand.Active := false;
          DspCommand.Obj := 0;
          exit;
        end;
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka1vkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[6],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklBit1 :
      begin
        if(ObjZav[DspCommand.Obj].TypeObj=36) and (ObjZav[DspCommand.Obj].BaseObject >0)
        then
        if not ObjZav[DspCommand.Obj].bParam[2] then
        begin
          InsArcNewMsg(DspCommand.Obj,578,1);
          ShowShortMsg(578, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          DspCommand.Command := 0;
          DspCommand.Active := false;
          DspCommand.Obj := 0;
          exit;
        end;
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka1otkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[5] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[7],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VklBit2 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka2vkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[6],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklBit2 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka2otkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[7],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VklBit3 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka3vkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[6],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklBit3 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka3otkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[7],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[7]]);
          end;
        end;
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //------------------------ ���������� ���������������� ���������� ���� 3 ������� FR3
      CmdMenu_PredOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        i := DspCommand.Obj; //----------------------------- ������� ��������� �����������
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13]; // ������ ��������� �����.�������
        ComServ := cmdfr3_ispolOtkl3bit; //--------- ��� �������������� ������� ����������
        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ); //- ��������� ��������� ��������
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8; //���������� ������ �������
        ComServ := cmdfr3_predvOtkl3bit; //------------------- ��� ��������������� �������
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then //������� ���������������
        begin
          InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[18],7);
          ShowShortMsg(529, LastX, LastY, ObjZav[i].Liter);
        end;
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //------------------------------------------------------- ���������� 3-�� ���� � fr3
      CmdMenu_IspolOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_IspolOtkl3bit;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj)
          then
          begin
            InsArcNewMsg(DspCommand.Obj,530,7);//----------- ������ �������������� �������
            ShowShortMsg(530, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VklBit4 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka4vkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[6],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklBit4 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka4otkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[7],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VklBit5 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka5vkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[6],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklBit5 :
      begin
        WorkMode.InpOgr := false;
        ComServ := cmdfr3_knopka5otkl;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then
          begin
            InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[7],7);
            PutShortMsg(2, LastX, LastY, MsgList[ObjZav[DspCommand.Obj].ObjConstI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VkluchenieGRI :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_grivkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,65,7);
          ShowShortMsg(65, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          IncrementKOK;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      CmdMenu_ZaprosPoezdSoglasiya :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_upzaprospoezdvkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,66,7);
          ShowShortMsg(66, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmZaprosPoezdSoglasiya :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_upzaprospoezdotkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,67,7);
          ShowShortMsg(67, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------------- ���������� �������
      CmdMenu_DatRazreshenieManevrov :
      begin
        WorkMode.InpOgr := false;
        VytajkaZM(DspCommand.Obj);

        if WorkMode.RazdUpr then
        begin

          i := ObjZav[DspCommand.Obj].ObjConstI[2] -
          (ObjZav[DspCommand.Obj].ObjConstI[2] div 8) * 8;
          case i of
            1 : ComServ := cmdfr3_knopka2vkl;
            2 : ComServ := cmdfr3_knopka3vkl;
            3 : ComServ := cmdfr3_knopka4vkl;
            4 : ComServ := cmdfr3_knopka5vkl;
            else  ComServ := cmdfr3_knopka1vkl;
          end;
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;

          if SendCommandToSrv(ObjServ,ComServ ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,68,7);
            ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end else
        begin
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
          ComServ := cmdfr3_manevryrm;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,68,7);
            ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdManevry_ReadyWar :
      begin //---------------------------- �������� ������������� �������������� ���������
        if Marhtracert[1].WarCount > 0 then
        begin //------------------------------------------ ����� ���������� ��������������
          CreateDspMenu(CmdManevry_ReadyWar,LastX,LastY);
        end else
        begin
          VytajkaZM(DspCommand.Obj);
          if WorkMode.RazdUpr then
          begin
            i := ObjZav[DspCommand.Obj].ObjConstI[2] -
            (ObjZav[DspCommand.Obj].ObjConstI[2] div 8) * 8;
            case i of
              1  : ComServ := cmdfr3_knopka2vkl;
              2  : ComServ := cmdfr3_knopka3vkl;
              3  : ComServ := cmdfr3_knopka4vkl;
              4  : ComServ := cmdfr3_knopka5vkl;
              else ComServ := cmdfr3_knopka1vkl;
            end;
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,68,7);
              ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          begin
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
            ComServ := cmdfr3_manevryrm;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,68,7);
              ShowShortMsg(68, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaManevrov :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_manevryotmen;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin

          VytajkaOZM(DspCommand.Obj);

          if not ObjZav[DspCommand.Obj].bParam[3] and
          ObjZav[DspCommand.Obj].bParam[5] then
          begin
            InsArcNewMsg(DspCommand.Obj,447,7);//----- ������ ������� ��������� �������� $
            ShowShortMsg(447, LastX, LastY, ObjZav[DspCommand.Obj].Liter)
          end else
          begin
            InsArcNewMsg(DspCommand.Obj,69,7);//--------- ������ ������� ������ �������� $
            ShowShortMsg(69, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PredvIRManevrov :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8];
        ComServ := CmdMenu_IspolIRManevrov;
        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_predvmanevryri;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,70,7);// ������ �����.������� �����.������. ��������
          ShowShortMsg(70, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_IspolIRManevrov :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //------------------------------------------- ������ �������������� �������
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
          ComServ := cmdfr3_ispmanevryri;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,71,7);// ������ ���. ������� ���. ������. ��������
            ShowShortMsg(71, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------ ���������� ������ ���
      CmdMenu_OtklDSN:
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,549,7);
          ShowShortMsg(549, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------- ��������� ������ ���
      CmdMenu_VklDSN:
      begin
        WorkMode.InpOgr := false;
        DspCommand.Obj := ObjZav[DspCommand.Obj].BaseObject;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,548,7); //------ ������ ������� ��������� ������ ���
          ShowShortMsg(548, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- ��������� ���� 1 1-�� �������
      CmdMenu_VklBit1_1:
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
         InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[7]+$4000,7);//- ������ �� ����� ����
         msg := MsgList[ObjZav[ID_Obj].ObjConstI[7]];
         PutShortMsg(7, LastX, LastY, msg);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- ��������� ���� 1 2-�� �������
      CmdMenu_VklBit1_2:
      begin
        WorkMode.InpOgr := false;
        DspCommand.Obj := ObjZav[DspCommand.Obj].BaseObject;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
         InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[6]+$4000,7);//- ������ �� ����� ����
         msg := MsgList[ObjZav[ID_Obj].ObjConstI[6]];
         PutShortMsg(2, LastX, LastY, msg);
        end;
      end;


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------- ������������ ������ ������� ���� ���������� �� �������
      CmdMenu_VkluchitDen :
      begin
        WorkMode.InpOgr := false;

        if (ObjZav[DspCommand.Obj].TypeObj = 36) and ObjZav[DspCommand.Obj].bParam[1] then
        begin
          InsArcNewMsg(DspCommand.Obj,551,7);//---------------- ��� ������� ��� ���������!
          ShowShortMsg(551, LastX, LastY, '');
          exit;
        end;

        if ObjZav[DspCommand.Obj].TypeObj = 92
        then ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[5] div 8
        else ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_dnkden;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          AddFixMessage(GetShortMsg(1,72,'',2),0,2);//������ ������� �����.�������� ������
          InsArcNewMsg(DspCommand.Obj,72,2);
          ShowShortMsg(72, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VkluchitNoch :
      begin
        WorkMode.InpOgr := false;
        if (ObjZav[DspCommand.Obj].TypeObj = 36) and
        not ObjZav[DspCommand.Obj].bParam[1] then
        begin
          InsArcNewMsg(DspCommand.Obj,551,7);
          ShowShortMsg(551, LastX, LastY, '');
          exit;
        end;

        if ObjZav[DspCommand.Obj].TypeObj = 92
        then ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[5] div 8
        else ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_dnknocth;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          AddFixMessage(GetShortMsg(1,73,'',7),0,2);
          InsArcNewMsg(DspCommand.Obj,73,7); //--- ������ ������� ��������� ������� ������
          TXT := GetShortMsg(1,73,ObjZav[DspCommand.Obj].Liter,7);
          PutShortMsg(7, LastX, LastY, TXT);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_VkluchitAuto :
      begin
        WorkMode.InpOgr := false;
        if (ObjZav[DspCommand.Obj].TypeObj = 36) and
        ObjZav[DspCommand.Obj].bParam[1] then
        begin
          InsArcNewMsg(DspCommand.Obj,551,7);
          ShowShortMsg(551, LastX, LastY, '');
          exit;
        end;
        if ObjZav[DspCommand.Obj].TypeObj = 92
        then ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[4] div 8
        else ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_dnkauto;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,74,7);//������ ������� ���.���������.���� ����������
          ShowShortMsg(74, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkluchitAuto :
      begin
        WorkMode.InpOgr := false;

        if ObjZav[DspCommand.Obj].TypeObj = 92
        then ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[4] div 8
        else ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_otkldnkauto;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,479,7);//������ ���. ����. ���������.���� ����������
          ShowShortMsg(479, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtklZvonkaUKSPS :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[1] div 8;
        ComServ := cmdfr3_ukspsotklzvon;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,75,7);//----- ������ ������� ���������� ������ �����
          ShowShortMsg(75, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

    else
      ResetShortMsg;
      WorkMode.InpOgr := false; //----------------------- �������� ����� ����� �����������
      WorkMode.GoMaketSt := false;
      WorkMode.GoOtvKom := false;
    end;
  end;
{$ENDIF}
  result := true;
end;

{$IFDEF RMDSP}
//========================================================================================
//----------------------------- ��������� ����� �������� ����������� ����� ������� �������
function WorkModeCalc: smallint;
begin
  {�������� ������� ��}
  result := 0;
end;

//========================================================================================
//---------------------------- ������������� �������� �������������� ������������� �������
procedure GoWaitOtvCommand(const Obj, BitFR3, CmdSecond : Word);
var
  a,b : boolean;
begin
  OtvCommand.Check  := BitFR3; //--------------- ������ ���������� ���� ���������� �������
  OtvCommand.State  := GetFR3(BitFR3,a,b); //-------- ����� ������� ��������� ���� �������
  OtvCommand.Cmd    := CmdSecond; //-------------- ����������� �������� ��� ������ �������
  OtvCommand.Second := 0; //-------------------------- �������� �
  OtvCommand.SObj   := 0;
  OtvCommand.Obj    := Obj;
  OtvCommand.Reper  := LastTime + 20 / 80000; //-------------- ���������� ������� ��������
  OtvCommand.Ready  := true;
  OtvCommand.Active := true;
  WorkMode.GoOtvKom := true;
end;

//------------------------------------------------------------------------------
// �������� ������� ������� ��� ������ �������������� ������������� �������
function CheckOtvCommand(Obj : SmallInt) : Boolean;
begin
  if OtvCommand.Active then result := OtvCommand.Obj <> Obj
  else result := false;
end;
{$ENDIF}

//========================================================================================
//---------------------------------------------------- ������ ���������� ������� �� ������
//------------------------------- Obj - ������ ������������, ��� �������� �������� �������
//------------------------------------------------ Cmd - ��� �������, ���������� �� ������
//------------------------------------------------------------- Index - ������ ��� �������
function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
begin
  //----------------------- ���� ������� ������ ���� ������, � ���� ������, � ���� �������
  if (CmdCnt < 1) and (Obj > 0) and (Cmd > 0) then
  begin
    CmdSendT := LastTime; //------------------------------- ��������� ����� ������ �������
    inc(CmdCnt);          //------------------------------------- ��������� ������� ������
    CmdBuff.Cmd := Cmd;   //--------------------- ������ ������� � ��������� ������ ������
    CmdBuff.Index := Obj; //---------------------- ������ � ��� �� ��������� ����� �������
    CmdBuff.LastObj := Index;
    result := true;
    WorkMode.CmdReady := true;
  end
  else result := false;
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
//========================================================================================
//--------------------------------------------------------------- ������� � ������ �������
procedure CmdMsg(cmd,ifr : word; index : integer);
var
  obj : word;
  name_obj, Vrem : string;
begin
  if LastFixed < index then
  begin
    Vrem := DateTimeToStr(DTFrameOffset);
    if Cmd = 0 then
    begin
      NewNeisprav := true;
      case ifr of
        0: LstNN := Vrem +' > ����� ������� <Esc>'+ #13#10+ LstNN;
        $7fe5: LstNN := Vrem +' > "����� �� ������ ��"'+ #13#10+ LstNN;
        $7fe6: LstNN := Vrem+' > "������� � ����� ��"'+ #13#10+ LstNN;
        $7fe7: LstNN :=Vrem+' > "���������� ������� �������"'+#13#10+ LstNN;
        $7fe8: LstNN :=Vrem+' > "����� ������������ ������"'+ #13#10+ LstNN;
        $7fe9: LstNN := Vrem+' > "���������� ���������� �� ��-���"'+ #13#10+ LstNN;
        $7fea: LstNN := Vrem+' > "����� ������� ������ ��"'+ #13#10+ LstNN;
        $7feb: LstNN := Vrem+' > "������� 2-� ����� ����������"'+ #13#10+ LstNN;
        $7fec: LstNN := Vrem+' > "������� 1-� ����� ����������"'+ #13#10+ LstNN;
        $7fed: LstNN := Vrem+' > "�������� ���������� �� ��-���"'+ #13#10+ LstNN;
        $7fee: LstNN := Vrem+' > "��������� ��������� � ������"'+ #13#10+ LstNN;
        $7fef: LstNN := Vrem+' > "�������� ��������� � ������"'+ #13#10+ LstNN;
        $7ff0: LstNN := Vrem+' > "�������� ����� ����� � ������"'+ #13#10+ LstNN;
        $7ff1: LstNN := Vrem+' > "������� ����� ����� � ������"'+ #13#10+ LstNN;
        $7ff2: LstNN := Vrem+' > "��������� ��������� ��������� �������"'+ #13#10+ LstNN;
        $7ff3: LstNN := Vrem+' > "�������� ��������� ��������� �������"'+ #13#10+ LstNN;
        $7ff4: LstNN := Vrem+' > "�������� ����� ����� �����������"'+ #13#10+ LstNN;
        $7ff5: LstNN := Vrem+' > "������� ����� ����� �����������"'+ #13#10+ LstNN;
        $7ff6: LstNN := Vrem+' > "�������� ����� ������"'+ #13#10+ LstNN;
        $7ff7: LstNN := Vrem+' > "������� ����� ������"'+ #13#10+ LstNN;
        $7ff8: LstNN := Vrem+' > "������� ���������� ����� ���������� ��������� � ���������"'+ #13#10+ LstNN;
        $7ff9: LstNN := Vrem+' > "������� ���������� ����� ���������� ��������� � ���������"'+ #13#10+ LstNN;
        $7ffa: LstNN := Vrem+' > "���������� ������ �� ���"'+ #13#10+ LstNN;
        $7ffb: LstNN := Vrem+' > "������ ������ �� ���"'+ #13#10+ LstNN;
        $7ffc: LstNN := Vrem+' > "��������� ��"'+ #13#10+ LstNN;
        $7ffd: LstNN := Vrem+' > "����� ������� ��"'+ #13#10+ LstNN;
        $7ffe: LstNN := Vrem+' > "����� �� �����"'+ #13#10+ LstNN;
        $7fff: LstNN := Vrem+' > "���������� ���������"'+ #13#10+ LstNN;
      end;
    end else
    if ifr >= $4000 then
    begin //----------------------------------------------------------- ���������� �������
      obj := ifr and $0fff;
      name_obj := ObjZav[obj].Liter;
      case cmd of
        CmdMenu_StrPerevodPlus :   smn := '������� � ���� ������� '+ name_obj;
        CmdMenu_StrPerevodMinus :  smn := '������� � ����� ������� '+ name_obj;
        CmdMenu_StrVPerevodPlus :  smn := '��������������� ������� � ���� ������� '+ name_obj;
        CmdMenu_StrVPerevodMinus : smn := '��������������� ������� � ����� ������� '+ name_obj;
        CmdMenu_StrOtklUpravlenie : smn := '���������� �� ���������� ������� '+ name_obj;
        CmdMenu_StrVklUpravlenie :  smn := '��������� ���������� ������� '+ name_obj;
        CmdMenu_StrZakrytDvizenie : smn := '������� �������� �� ������� '+ name_obj;
        CmdMenu_StrOtkrytDvizenie : smn := '������� �������� �� ������� '+ name_obj;
        CmdMenu_UstMaketStrelki :  smn := '���������� ����� �� ������� '+ name_obj;
        CmdMenu_SnatMaketStrelki : smn := '���� ����� �� ������� '+ name_obj;
        CmdMenu_StrMPerevodPlus : smn := '�������� ������� � ���� ������� '+ name_obj;
        CmdMenu_StrMPerevodMinus : smn := '�������� ������� � ����� ������� '+ name_obj;
        CmdMenu_StrZakryt2Dvizenie : smn := '������� �������� �� ������� '+ name_obj;
        CmdMenu_StrOtkryt2Dvizenie : smn := '������� �������� �� ������� '+ name_obj;
        CmdMenu_StrZakrytProtDvizenie : smn := '������� ��������������� �������� �� ������� '+ name_obj;
        CmdMenu_StrOtkrytProtDvizenie : smn := '������� ��������������� �������� �� ������� '+ name_obj;
        CmdMarsh_Tracert : smn := '����������� �������� ����� '+ name_obj;
        CmdMarsh_Ready : smn := '������ �������������� '+ name_obj;
        CmdMarsh_Manevr : smn := '���������� ���������� ������� {'+ name_obj+'}';
        CmdMarsh_Poezd : smn := '���������� �������� ������� {'+ name_obj+'}';
        CmdMarsh_Povtor : smn := '������ �������� '+ name_obj;
        CmdMarsh_Razdel : smn := '������� '+ name_obj;
        CmdMarsh_RdyRazdMan : smn := '������� ���������� '+ name_obj;
        CmdMarsh_RdyRazdPzd : smn := '������� �������� '+ name_obj;
        CmdManevry_ReadyWar : smn := '�������� �������������� '+ name_obj;
        CmdMarsh_ResetTraceParams : smn := '������������ '+ name_obj;
        CmdMarsh_PovtorMarh : smn := '������ �������� �� '+ name_obj;
        CmdMarsh_PovtorOtkryt : smn := '��������� �������� '+ name_obj;
        CmdStr_ReadyPerevodPlus : smn := '������� � ���� ������� '+ name_obj;
        CmdStr_ReadyPerevodMinus : smn := '������� � ����� ������� '+ name_obj;
        CmdStr_ReadyVPerevodPlus : smn := '��������������� ������� � ���� ������� '+ name_obj;
        CmdStr_ReadyVPerevodMinus : smn := '��������������� ������� � ����� ������� '+ name_obj;
        CmdStr_ReadyMPerevodPlus : smn := '������� �� ������ � ���� ������� '+ name_obj;
        CmdStr_ReadyMPerevodMinus : smn := '������� �� ������ � ����� ������� '+ name_obj;
        CmdStr_AskPerevod : smn := '����� ������� '+ name_obj;
        else  smn := '������������ ������� '+ IntToStr(cmd)+ ' �� ������ '+ IntToStr(Obj);
      end;
      LstNN := Vrem + ' < '+ smn+ #13#10+ LstNN;
      NewNeisprav := true;
    end else
    begin // ������� ��
      smn := Vrem + ' < ������ ������� �� ';
      LstNN := smn + IntToStr(cmd)+ ' �� ������ ['+ IntToStr(ifr)+ ']'+ #13#10 + LstNN;
      NewNeisprav := true;
    end;
  end;
end;
{$ENDIF}

end.
