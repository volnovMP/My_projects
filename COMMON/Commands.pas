unit Commands;
{$INCLUDE d:\Sapr2012\CfgProject}
//========================================================================================
//--------------------------------------------------------------------  ������� ����������
interface
uses
  Windows,   Forms,  SysUtils,  Commons,  Controls,

{$IFDEF RMDSP} TimeInput, KanalArmSrvDSP, TabloDSP,{$ENDIF}

{$IFDEF RMSHN} KanalArmSrvSHN, TabloSHN, {$ENDIF}

{$IFDEF RMARC}TabloFormARC,{$ENDIF}

{$IFDEF TABLO}  TabloForm1,{$ENDIF}

 TypeALL;



  function SelectCommand : boolean;
  function Cmd_ChangeMode(mode : integer) : boolean;

{$IFDEF RMDSP}
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
 //---------------------------------------------------- ������ ��������� ������ ����������
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
_ispiskrazmyk        = 1; //------ �������������� ������� �������������� ���������� ������
_isprazmykstr        = 2; //-------------------- �������������� ������� ���������� �������
_isppereezdotkr      = 3; //--------------------- �������������� ������� �������� ��������
_IspolVklZapMont     = 4; //------------ �������������� ������� ��������� ������� ��������
_IspolOtklZapMont    = 5; //----------- �������������� ������� ���������� ������� ��������
_ispukspsotkl        = 6; //---------------------- �������������� ������� ���������� �����
_ispvspotpr          = 7; //---------- �������������� ������� ���������������� �����������
_ispvsppriem         = 8; //--------------- �������������� ������� ���������������� ������
_ispmanevryri        = 9; //---- �������������� ������� �������������� ���������� ��������
_isppabiskpribytie   = 10;//------- �������������� ������� �������������� �������� ��� ���
_ispolpereezdzakr    = 11; //-------------------- �������������� ������� �������� ��������
_ispolOtklUkg        = 12; //------- �������������� ������� ���������� ��� �� ������������
_ispolOtkl3bit       = 13; //------- �������������� ������� ���������� ��� �� ������������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------- 14 - 29 -------------------------------------------------------- ������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_pereezdotklizv1     = 30; //---------- ������� ���������� ��������� �� ������� (��� ����)
//-------------------------------------------------------------------- ������� ��� �������
_otklupr             = 31; //------------------------------ ��������� ������ �� ����������
_vklupr              = 32;//--------------------------------- �������� ���������� ��������
_blokirov            = 33; //-------------------------------------------- ������� ��������
_razblokir           = 34;
_blokirov2           = 35;
_razblokir2          = 36;
_ustmaket            = 37;
_snatmaket           = 38;
_strplus             = 41;
_strminus            = 42;
_strvspplus          = 43;
_strvspminus         = 44;
//------------------------------------------------------------------- ������� ��� ��������
_svotkrmanevr        = 45;
_svotkrpoezd         = 46;
_svzakrmanevr        = 47;
_svzakrpoezd         = 48;
_svpovtormanevr      = 49;
_svpovtorpoezd       = 50;
_svustlogic          = 51;
_svotmenlogic        = 52;
_putustograd         = 53;
_logoff              = 54; //------------------ ������� ���������� ������ ��������� ��-���
_zamykstr            = 55;
_pereezdzakryt       = 56;
_pereezdvklizv       = 57;
_pereezdotklizv      = 58;
_opovvkl             = 59; //----------------------------------------- �������� ����������
_VklZapMont          = 60; //------------------------------------ �������� ������ ��������
_ukspsotklzvon       = 61;
_absmena             = 62;
_absoglasie          = 63;
_knopka1vkl          = 64;
_knopka1otkl         = 65;
_grivkl              = 66;
_upzaprospoezdvkl    = 67;
_upzaprospoezdotkl   = 68;
_upzaprosmanevrvkl   = 69;
_upzaprosmanevrotkl  = 70;
_manevryrm           = 71;
_manevryotmen        = 72;
_dnkden              = 73;
_dnknocth            = 74;
_dnkauto             = 75;
_pabsoglasievkl      = 76;
_pabsoglasieotkl     = 77;
_pabpribytie         = 78;
_directdef           = 79;
_directmanual        = 80;
//-------------------------------------------------------------------- ������� ��� �������
_strmakplus          = 81;
_strmakminus         = 82;
_strvspmakplus       = 83;
_strvspmakminus      = 84;
//----------------------------------------------------------------------------------------
_resettrace           = 85;
_opovotkl             = 86;
_knopka2vkl           = 87;
_knopka2otkl          = 88;
_knopka3vkl           = 89;
_knopka3otkl          = 90;
_knopka4vkl           = 91;
_knopka4otkl          = 92;
_knopka5vkl           = 93;
_knopka5otkl          = 94;
_svprotjagmanevr      = 95;
_restartservera       = 96;
_restartuvk           = 97;
_otmenablokUksps      = 98;
_repmanevrmarsh       = 99;
_reppoezdmarsh        = 100;
_autoDT               = 101;
_newDT                = 102;
_vklksn               = 103;
_otklksn              = 104;
_vklOPI               = 105;
_otklOPI              = 106;
_strautorun           = 107;
_svotkrauto           = 108;
_automarshvkl         = 109;
_automarshotkl        = 110;
_povtorotkrytmanevr   = 111;
_povtorotkrytpoezd    = 112;
_otmenasogsnab        = 113;
_strzakrytprotivosh   = 114;
_strotkrytprotivosh   = 115;
_strzakryt2protivosh  = 116;
_strotkryt2protivosh  = 117;
_blokirovET           = 118;
_razblokirET          = 119;
_blokirovETA          = 120;
_razblokirETA         = 121;
_blokirovETD          = 122;
_razblokirETD         = 123;
_otkldnkauto          = 124;
_rescueotu            = 125;
_datrazreshotpr       = 126; //------------ ���� ���������� ����������� �� ������� (� ���)
_snatrazreshotpr      = 127; //----------------- ����� ���������� ����������� �� ������� )
_otmenaOtklUkg        = 128; //------------------------------------- ������ ���������� ���
_NAS_Vkl              = 129; //---------------------------- �������� �������� ������������
_NAS_Otkl             = 130; //--------------------------- ��������� �������� ������������
_CHAS_Vkl             = 131; //------------------------------ �������� ������ ������������
_CHAS_Otkl            = 132; //----------------------------- ��������� ������ ������������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------ 133 - 186 ---------------------------------------------------- ������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_ustanovkastrelok     = 187; //------------------------------- ��������� ������� �� ������
_povtormarhmanevr     = 188; //------------------ ��������� ��������� ����������� ��������
_povtormarhpoezd      = 189; //-------------------- ��������� ��������� ��������� ��������
_marshrutlogic        = 190; //---------------------------- ��������� ����������� ��������
_marshrutmanevr       = 191; //-------------------- �������� ���������� �������� �� ������
_marshrutpoezd        = 192; //---------------------- �������� �������� �������� �� ������
_predviskrazmyk       = 193; //----------- �����. ������� �������������� ���������� ��(��)
_predvrazmykstr       = 194; //---------- ��������������� ������� ������ ��������� �������
_predvpereezdotkr     = 195; //----------------- ��������������� ������� �������� ��������
_predvOtklUkg         = 196; //-------------------- ��������������� ������� ���������� ���
_PredvOtklZapMont     = 197; //------- ��������������� ������� ���������� ������� ��������
_predvukspsotkl       = 198; //----------- �����. ������� ���������� ����� �� ������������
_predvvspotpr         = 199; //--------------- �����. ������� ���������������� �����������
_predvvsppriem        = 200; //-------------------- �����. ������� ���������������� ������
_predvmanevryri       = 201; //------ ��������������� ������� �������. ���������� ��������
_predvpabiskpribytie  = 202; //------- ��������������� ������� �������������� �������� ���
_predvpereezdzakr     = 203; //----------------- ��������������� ������� �������� ��������
_predvotkl3bit        = 204; //--------- ��������������� ������� ���������� ������� ���� 3
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------- 205 - 223 ----------------------------------------------------- ������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_kvitancija           = 224;

var
  s : string;
  ObjFr3, Xstr, SP : integer;
implementation

uses
{$IFNDEF TABLO} Marshrut,{$ENDIF}
CMenu;

//========================================================================================
//---- ��������� ������� ��������� ������ ������ � ������ �������� ���������� � ����������
function Cmd_ChangeMode(mode : integer) : boolean;
//----------------------------------- mode - ��� ������� ��� ��������� ������� ������ ����
begin
{$IFDEF RMDSP}
  case mode of  //-------------------------------------- ������������� �� �������� �������

    Key_RazdeRejim ://------------------------------------------ ���������� ����������
    begin
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false; //------------- ������ ����� ��������� ������� �� �����
      WorkMode.RazdUpr := true; WorkMode.MarhUpr := false;// ���������� - ��, �����. - ���
      WorkMode.MarhOtm := false;   //------------------------ ������ ����� ������ ��������
      WorkMode.VspStr  := false;   //------ ������ ����� ���������������� �������� �������
      WorkMode.InpOgr  := false; //------------------- ������ ����� ������ � �������������
      InsNewArmCmd($7ff9,0); //----------------------- ��������� � ������ ���������� �����
      result := true;
    end;

    Key_MarshRejim : //----------------------------------------- ���������� ����������
    begin
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false;
      WorkMode.RazdUpr := false; WorkMode.MarhUpr := true;  WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false; WorkMode.InpOgr  := false;
      InsNewArmCmd($7ff8,0); //----------------------- ��������� � ������ ���������� �����
      result := true;
    end;

    Key_OtmenMarsh ://-------------------- ���������/���������� ������ ������ ��������
    begin
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false; WorkMode.MarhOtm := not WorkMode.MarhOtm;
      WorkMode.VspStr  := false;   WorkMode.InpOgr  := false;
      if WorkMode.MarhOtm then //----------------------- ���� ��� � ������ ������ ��������
      begin
        InsNewArmCmd($7ff7,0);
        InsNewMsg(0,93,7,'');ShowSMsg(93,LastX,LastY,'');//"������� ������ ��� ������"
      end
      else  InsNewArmCmd($7ff6,0);
      result := true;
    end;

    Key_InputOgr :
    begin //-------------------------------- ���������/���������� ������ ����� �����������
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false;  WorkMode.MarhOtm := false;  WorkMode.VspStr  := false;
      WorkMode.InpOgr  := not WorkMode.InpOgr;

      if WorkMode.InpOgr then
      begin
        InsNewArmCmd($7ff5,0); //------------------ ��������� ��������� ������ �����������
        InsNewMsg(0,94,7,'');
        ShowSMsg(94,LastX,LastY,'');// ������� ������ �����������
      end
      else InsNewArmCmd($7ff4,0);result:=true;end; // ��������� ������. ������ �����������

    Key_VspPerStrel :
    begin //---------------- ���������/���������� ������ ���������������� �������� �������
      ResetTrace; //--------------------------------------------- �������� �������� ������
      WorkMode.GoMaketSt := false; WorkMode.MarhOtm := false;  WorkMode.InpOgr  := false;
      WorkMode.VspStr := not WorkMode.VspStr;

      if WorkMode.VspStr then
      begin
        InsNewMsg(0,88,7,'');
        ShowSMsg(88,LastX,LastY,'');//----------- ������� �������
      end else
      begin
        InsNewMsg(0,95,7,''); //------ "���������� ����� ����������� ���������� ���������"
        ShowSMsg(95,LastX,LastY,''); VspPerevod.Active := false;
      end;
      result := true;
    end;

    Key_EndTrace :
    begin //-------------------------------------------------------- ����� ������ ��������
      WorkMode.GoMaketSt := false;
      if MarhTrac.MsgN > 1 then //------------ ���� ���� ��������� �������������
      begin
        dec(MarhTrac.MsgN);
        NewMenu_(Key_ReadyResetTrace,LastX,LastY);
        DspMenu.WC := true;
        result := true;
      end else
      if MarhTrac.MsgN = 1 then
      begin  ResetTrace;result:=true; end // ���� �������� ���� ������������- ����� ������
      else
      //------------------------------------------------------------- ����� ��������������
      if(MarhTrac.WarN>0)and((MarhTrac.ObjEnd>0)or(MarhTrac.FullTail)) then
      begin
        dec(MarhTrac.WarN);
        if MarhTrac.WarN > 0 then
        begin
          TimeLockCmdDsp := LastTime; LockComDsp := true; ShowWarning := true;
          NewMenu_(Key_ReadyWarningTrace,LastX,LastY);
        end
        else NewMenu_(CmdMarsh_Ready,LastX,LastY);//1102 ��������� ��������� ��������
        result := true;
      end else
      if WorkMode.MarhUpr and WorkMode.GoTracert then
      begin //---------------------- ��������� ����������� �������� � ������������ �������
        if EndTracertMarshrut then //���� ������ ������� ���������� ������ ������ ��������
        begin //----------------------------------- ������������ ������ ��������� ��������
          if MarhTrac.WarN > 0 then //-------------------- ���� ���� ��������������
          begin //--------------------------------------------------- ����� ��������������
            SBeep[1] := true; TimeLockCmdDsp := LastTime;
            LockComDsp := true; ShowWarning := true;
            // Key_ReadyWarningTrace 1013 (�������� ������������� ��������� �� ������)
            NewMenu_(Key_ReadyWarningTrace,LastX,LastY);
          end
          //----------------------- CmdMarsh_Ready 1102 (������������� ��������� ��������)
          else NewMenu_(CmdMarsh_Ready,LastX,LastY); //------ ���� ��� ��������������
        end
         //------ ����� ������ ��������������, ��� �������� ����� �������� ������� �������
        else NewMenu_(Key_EndTraceError,LastX,LastY);
        result := true;
      end
      //------------------- ���� �� ����.���������� ��� �� �����������, �� ����� ���������
      else begin RSTMsg; result := false; end;
    end;

    Key_PodsvetkaStrelok :
    begin //-------------------------------------- 1021 ������ ��������� ��������� �������
      WorkMode.GoMaketSt := false;   WorkMode.Podsvet := not WorkMode.Podsvet;
      if WorkMode.Podsvet then InsNewArmCmd($7ff3,0) //---------------- �������� ���������
      else InsNewArmCmd($7ff2,0); //---------------------------------- ��������� ���������
      result := true;
    end;

    Key_VvodNomeraPoezda :
    begin //---------------------------------------------- 1022 ������ ����� ������ ������
      WorkMode.GoMaketSt := false;  WorkMode.InpTrain := not WorkMode.InpTrain;
      if WorkMode.InpTrain then InsNewArmCmd($7ff1,0) //------ ������� ����� ����� �������
      else InsNewArmCmd($7ff0,0);                    //------ �������� ����� ����� �������
      result := true;
    end;

    Key_PodsvetkaNomerov :
    begin //----------------------------------------- 1023 ������ ��������� ������ �������
      WorkMode.GoMaketSt := false; WorkMode.NumTrain := not WorkMode.NumTrain;
      if WorkMode.NumTrain then InsNewArmCmd($7fef,0)
      else InsNewArmCmd($7fee,0);
      result := true;
    end;
    else  result := false; //-------------------------- ���� ��� ������ ���������� �������
  end;
{$ENDIF}
end;


//========================================================================================
//----------------------------------------------------------- ��������� ������� ����������
function SelectCommand : boolean;
var
  i, o, p, ObjMaket, Strelka, obj_for_kom, XStr, mogu, Baza : integer;
  TXT : string;
  ComServ : Byte;
  ObjServ : Word;
begin
  result := false;
  //-------------------------------------------------------- ����� ���������� ����/�������
  DspMenu.Ready := false;   DspMenu.WC := false;  DspMenu.obj := -1;

{$IFDEF RMDSP}
//-------------------------------------------------------- ��������� ����� ������� � �����
  if (DspCom.obj > 0) and (DspCom.Com > 0) then InsNewArmCmd(DspCom.obj+$4000,DspCom.Com);

  //---------------------------------- ��������� ������ � ������ ���������� �������� �����
  if DspCom.Active then
  begin
    case DspCom.Com of
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //---------- ������� ������ ������ ������ ��-���, ������ ������� ������ � ����������
      Key_RazdeRejim,
      Key_MarshRejim,
      Key_OtmenMarsh,
      Key_InputOgr,
      Key_VspPerStrel,
      Key_PodsvetkaStrelok,
      Key_VvodNomeraPoezda,
      Key_PodsvetkaNomerov,
      Key_EndTrace :
      begin  result := Cmd_ChangeMode(DspCom.Com);  exit;  end; //--------- �������� �����

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_Osnovnoy ://------------------------------------- ������ �� ��������� ������� ����
      begin
        ComServ := _directmanual;   ObjServ := WorkMode.DirectStateSoob;
        //------------------------------------ ��� ��������   WorkMode.Upravlenie := true;
        InsNewArmCmd($7fed,0); //------------------------------ �������� ���������� � ����
        SendCommandToSrv(ObjServ,ComServ,0);  result := true;  exit;
      end;
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RU1 ://�������� 1-�� ��.��������� ����������� ��������� ������ ������ ��-���
      begin InsNewArmCmd($7fec,0); config.ru:= 1; SetParamTablo; result:= true; exit; end;
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RU2 ://�������� 2-�� ��.��������� ����������� ��������� ������ ������ ��-���
      begin InsNewArmCmd($7feb,0); config.ru:= 2; SetParamTablo; result:= true; exit; end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ResetCommandBuffers : //---------------------------- ����� ������� ������ ��
      begin
        InsNewArmCmd($7fea,0);
        CmdCnt := 0;   //-------------------------------- ����� �������� ���������� ������
        WorkMode.MarhRdy := false; //----------------- ����� ���������� ���������� �������
        WorkMode.CmdReady := false; //--------------- ����� �������� ������������� �������
        result := true;
        exit;
      end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RestartServera : //-------------------------------------- ���������� �������
      begin
        NewMenu_(Key_ReadyRestartServera,LastX,LastY);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Key_RezervARM ://----------------------------------------- ������� ���� � ������
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
      Key_ReadyRestartServera : //---- 1017 �������� ������������� ����������� �������
      begin
        ComServ := _restartservera;
        ObjServ := WorkMode.ServerStateSoob;
        if SendCommandToSrv(ObjServ,ComServ,0) then
        begin
          IncrementKOK;
          InsNewMsg(0,$2000+349,7,'');   //---------- "������ ������� ����������� �������"
          AddFixMes(GetSmsg(1,349,'',7),4,2);
          RSTMsg;
          SendRestartServera := true;
        end;
        result := true; exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RestartUVK :
      begin
        IndexFR3IK := DspCom.Obj;
        NewMenu_(Key_ReadyRestartUVK,LastX,LastY);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Key_ReadyRestartUVK :
      begin
        WorkMode.InpOgr := false;
        ComServ := _restartuvk;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          IncrementKOK;
          RSTMsg;
          InsNewMsg(DspCom.Obj,$2000+350,7,'');//-- "������ ������� ������������ ��"
          msg := GetSmsg(1,350,ObjZv[DspCom.Obj].Liter,7);
          ShowSMsg(350,LastX,LastY,''); 
          AddFixMes(msg,4,2);
        end;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RescueOTU :  //------------------------------ 189 ������������ ��������� ���
      begin
        IndexFR3IK := DspCom.Obj;
        //Key_ReadyRescueOTU=1024 ����� ������������� �������������� ���������� ������
        NewMenu_(Key_ReadyRescueOTU,LastX,LastY);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Key_ReadyRescueOTU :
      begin
        WorkMode.InpOgr := false;
        ComServ := _rescueotu;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        //------------------------ ��� ������� ��� �������� � ������ _rescueotu  125
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          IncrementKOK;
          InsNewMsg(DspCom.Obj,$2000+506,7,'');
          AddFixMes(GetSmsg(1,506,ObjZv[DspCom.Obj].Liter,7),4,2);
          RSTMsg;
        end;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Key_ClearTrace :
      begin //-------------------------- ����� ����������� ��������, ������� ������ ������
        if CmdCnt > 0 then
        AddFixMes(GetSmsg(1,296,GetNameObj(CmdBuff.LastObj),1),7,2);
        CmdCnt := 0;                  // ����� ���������� ������ � �����������
        WorkMode.MarhRdy := false; // ����� ���������� �������
        WorkMode.CmdReady := false;   // ����� ���������� �� �� �������� ���������
        ResetCommands;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Key_DateTime :
      begin //-------------------------------------------------------- ���� ������� ��-���
        ResetTrace; // �������� �������� ������
        WorkMode.GoMaketSt := false;
        WorkMode.MarhOtm := false;
        WorkMode.VspStr := false;
        WorkMode.InpOgr := false;
        if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 /24) then
        begin
          InsNewMsg(0,188,7,'');
          ShowSMsg(188,LastX,LastY,'');
          ShowWindow(Application.Handle,SW_SHOW);
          case TimeInputDlg.ShowModal of
            mrOk :
            begin
              DateTimeToString(s,'hh:mm:ss', NewTime);
              InsNewMsg(0,317,7,'');
              ShowSMsg(317,LastX,LastY,s);
            end;
            mrNo :
            begin
              InsNewMsg(0,435,1,''); //----- ��������� ������� � 22:55 �� 01:05 ���������!
              ShowSMsg(435,LastX,LastY,'');
            end;
          else
            RSTMsg;
          end;
        end;
        ShowWindow(Application.Handle,SW_HIDE);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Key_BellOff :
      begin //-------------------------------------------------- ����� ������������ ������
        InsNewArmCmd($7fe8,0);
        Zvuk := false; result := true; exit;
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
      ShowSMsg(76,LastX,LastY,'');  //--------------------------- ���������� ���������
      result := false;
      exit;
    end;
    if CmdCnt > 0 then
    begin //------------- ����� ������ �������� - ���������� ������ �� ������������ ������
      InsNewArmCmd($7ffe,0);
      ShowSMsg(251,LastX,LastY,'');
      result := false;
      exit;
    end;
  end;

  if DspCom.Active then
  begin
    case DspCom.Com of
    //----------------------------------------------------------------- ������� �� �������
    //---------------------------------------------------------------------------- �������
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrPerevodPlus :
      begin
        WorkMode.InpOgr := false;
        if maket_strelki_index = ObjZv[DspCom.Obj].BasOb then
        begin NewMenu_(CmdStr_ReadyMPerevodPlus,LastX,LastY); end
        else begin NewMenu_(CmdStr_ReadyPerevodPlus,LastX,LastY); end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrPerevodMinus :
      begin
        WorkMode.InpOgr := false;
        if maket_strelki_index = ObjZv[DspCom.Obj].BasOb then
        begin NewMenu_(CmdStr_ReadyMPerevodMinus,LastX,LastY); end
        else begin NewMenu_(CmdStr_ReadyPerevodMinus,LastX,LastY); end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_AskPerevod: NewMenu_(CmdStr_AskPerevod,LastX,LastY); //- ������ ��������

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyPerevodPlus :
      begin
        ComServ := _strplus;
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;

        if WorkMode.VspStr then //------------------- ���� ��������������� ������� �������
        begin
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus;
          VspPerevod.Strelka := DspCom.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end
        else
        if not ObjZv[ObjZv[ID_Obj].BasOb].bP[22] then //-- ���� ��������� �� ��
        begin
          InsNewMsg(ObjZv[ID_Obj].BasOb,150+$4000,1,'');
          ShowSMsg(150,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end
        else
        if ObjZv[ObjZv[ID_Obj].BasOb].ObCB[3] and // ���� ���� ��������� ��� �
        not ObjZv[ObjZv[ID_Obj].BasOb].bP[20] then //........ ���� �������� ���
        begin//��������� ���������� �������� ������� ��������������� ��������� (���, ����)
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          ObjZv[DspCom.Obj].bP[22] := true;
          ObjZv[DspCom.Obj].bP[23] := false;
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,12,2,'');
          ShowSMsg(12, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyPerevodMinus :
      begin
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        ComServ := _strminus;
        if WorkMode.VspStr then
        begin //------------------------------------------ ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus;
          VspPerevod.Strelka := DspCom.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZv[ObjZv[ID_Obj].BasOb].bP[22] then
        begin //----------------------------------------------------------- ������� ������
          InsNewMsg(ObjZv[ID_Obj].BasOb,150+$4000,1,'');
          ShowSMsg(150,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end else
        if ObjZv[ObjZv[ID_Obj].BasOb].ObCB[3] and
        not ObjZv[ObjZv[ID_Obj].BasOb].bP[20] then
        begin //��������� ���������� �������� ������� ��������������� ��������� (���,����)
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          ObjZv[DspCom.Obj].bP[22] := false;
          ObjZv[DspCom.Obj].bP[23] := true;
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,13,7,'');
          ShowSMsg(13, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------- ���� ������ ������� � STAN  ��� �������� � ���� ������� �� ������
      CmdStr_ReadyMPerevodPlus :
      begin
        Strelka := DspCom.Obj;
        XStr :=  ObjZv[Strelka].BasOb;
        ObjServ := ObjZv[XStr].ObCI[2] div 8;
        ComServ := _strmakplus;
        ObjZv[XStr].iP[5] := _strmakplus; //---------------- ���������� �������
        ObjZv[XStr].iP[4] := 0; //----------------------------- ���������� ����������
        ObjZv[XStr].T[3].F := LastTime + 5/80000;//-------------- ����� ��������
        ObjZv[XStr].T[3].Activ := true; //--------------------- ������������ ������
        if WorkMode.VspStr then
        begin //------------------------------------------ ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus;
          VspPerevod.Strelka := DspCom.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZv[ObjZv[ID_Obj].BasOb].bP[22] then
        begin //----------------------------------------------------------- ������� ������
          InsNewMsg(ObjZv[ID_Obj].BasOb,150+$4000,1,'');
          ShowSMsg(150,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end else
        if ObjZv[ObjZv[ID_Obj].BasOb].ObCB[3] and
        not ObjZv[ObjZv[ID_Obj].BasOb].bP[20] then
        begin //��������� ���������� �������� ������� ��������������� ��������� (���,����)
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          ObjZv[DspCom.Obj].bP[22] := true;
          ObjZv[DspCom.Obj].bP[23] := false;
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,20,2,'');
          ShowSMsg(20, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
          SMsgCvet[1] := GetColor1(2);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------- ���� ������ ������� � STAN  ��� �������� � ����� ������� �� ������
      CmdStr_ReadyMPerevodMinus :
      begin
        Strelka := DspCom.Obj;
        XStr := ObjZv[Strelka].BasOb;
        ObjServ := ObjZv[XStr].ObCI[2] div 8;
        ComServ := _strmakminus;
        ObjZv[XStr].iP[5] := _strmakminus; //--------------- ���������� �������
        ObjZv[XStr].iP[4] := 0; //----------------------------- ���������� ����������
        ObjZv[XStr].T[3].F := LastTime + 5/80000; //------------- ����� ��������
        ObjZv[XStr].T[3].Activ := true;

        if WorkMode.VspStr then
        begin //------------------------------------------ ��������������� ������� �������
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus;
          VspPerevod.Strelka := DspCom.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZv[ObjZv[ID_Obj].BasOb].bP[22] then
        begin //----------------------------------------------------------- ������� ������
          InsNewMsg(ObjZv[ID_Obj].BasOb,150+$4000,1,'');
          ShowSMsg(150,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end else
        if ObjZv[ObjZv[ID_Obj].BasOb].ObCB[3] and
        not ObjZv[ObjZv[ID_Obj].BasOb].bP[20] then
        begin // ��������� ���������� �������� ������� ��������������� ���������(���,����)
          InsNewMsg(ObjZv[ID_Obj].BasOb,392+$4000,1,'');
          ShowSMsg(392,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
        end else
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          ObjZv[DspCom.Obj].bP[22] := false;
          ObjZv[DspCom.Obj].bP[23] := true;
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,21,7,'');
          ShowSMsg(21, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodPlus :
      begin
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        if ObjZv[DspCom.Obj].BasOb = maket_strelki_index then
        begin //---------------------------------------- �� ������ ��������������� �������
          ComServ := _strvspmakplus;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            ObjZv[DspCom.Obj].bP[22] := true;
            ObjZv[DspCom.Obj].bP[23] := false;
            InsNewMsg(ObjZv[DspCom.Obj].BasOb,14,2,'');
            ShowSMsg(14, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
          end;
        end else
        begin // ��������������� �������
          ComServ := _strvspplus;
          if SendCommandToSrv(ObjServ,ComServ ,DspCom.Obj) then
          begin
            ObjZv[DspCom.Obj].bP[22] := true;
            ObjZv[DspCom.Obj].bP[23] := false;
            InsNewMsg(ObjZv[DspCom.Obj].BasOb,14,2,'');
            ShowSMsg(14, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodMinus :
      begin
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        if ObjZv[DspCom.Obj].BasOb = maket_strelki_index then
        begin //---------------------------------------- �� ������ ��������������� �������
          ComServ := _strvspmakminus;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            ObjZv[DspCom.Obj].bP[22] := false;
            ObjZv[DspCom.Obj].bP[23] := true;
            InsNewMsg(ObjZv[DspCom.Obj].BasOb,15,7,'');
            ShowSMsg(15,LastX,LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
          end;
        end else
        begin //-------------------------------------------------- ��������������� �������
          ComServ := _strvspminus;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            ObjZv[DspCom.Obj].bP[22] := false;
            ObjZv[DspCom.Obj].bP[23] := true;
            InsNewMsg(ObjZv[DspCom.Obj].BasOb,15,7,'');
            ShowSMsg(15,LastX, LastY,ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrOtklUpravlenie :
      begin
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        ComServ := _otklupr;
        WorkMode.InpOgr := false; // �������� ����� ����� �����������
        ObjZv[DspCom.Obj].bP[18] := true;
        o := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[8];
        p := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[9];
        if (o > 0) and (p > 0) then
        begin
          if o = DspCom.Obj then ObjZv[p].bP[18] := true else
          if p = DspCom.Obj then ObjZv[o].bP[18] := true;
        end;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,16,7,'');
          ShowSMsg(16, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrVklUpravlenie :
      begin
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        ComServ := _vklupr;
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjZv[DspCom.Obj].bP[18] := false;
        o := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[8];
        p := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[9];
        if (o > 0) and (p > 0) then
        begin
          if o = DspCom.Obj then ObjZv[p].bP[18] := false else
          if p = DspCom.Obj then ObjZv[o].bP[18] := false;
        end;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,17,2,'');
          ShowSMsg(17, LastX, LastY, ObjZv[ObjZv[DspCom.Obj].BasOb].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrZakrytDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        ObjZv[DspCom.Obj].bP[16] := true;

        if ObjZv[DspCom.Obj].ObCB[6] then ComServ := _blokirov2 // �������
        else  ComServ := _blokirov;//--------------------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,18,7,'');
          ShowSMsg(18, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrOtkrytDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjZv[DspCom.Obj].bP[16] := false;
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;

        if ObjZv[DspCom.Obj].ObCB[6] then ComServ := _razblokir2 //�������
        else ComServ := _razblokir;//--------------------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,452,2,'');
          ShowSMsg(452, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrZakrytProtDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        ObjZv[DspCom.Obj].bP[17] := true;

        if ObjZv[DspCom.Obj].ObCB[6] then
        ComServ := _strzakryt2protivosh //---------------------------------- �������
        else ComServ := _strzakrytprotivosh; //----------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,451,7,'');
          ShowSMsg(451, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_StrOtkrytProtDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        ObjZv[DspCom.Obj].bP[17] := false;
        ObjServ := ObjZv[ObjZv[DspCom.Obj].BasOb].ObCI[2] div 8;
        if ObjZv[DspCom.Obj].ObCB[6]
        then ComServ := _strotkryt2protivosh //----------------------------- �������
        else ComServ := _strotkrytprotivosh; //----------------------------- �������

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(ObjZv[DspCom.Obj].BasOb,19,2,'');
          ShowSMsg(19, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_UstMaketStrelki :
      begin //------------------------------------------------ ���������� ������� �� �����
        Strelka := DspCom.Obj;
        XStr := ObjZv[Strelka].BasOb;
        WorkMode.InpOgr := false; //--------------------- �������� ����� ����� �����������
        WorkMode.GoMaketSt := false;
        for i := 1 to High(ObjZv) do
        begin  //------------------------------------ �������� ����������� ��������� �����
          if (ObjZv[i].RU = config.ru) and (ObjZv[i].TypeObj = 20) then
          begin
            if ObjZv[i].bP[2] then
            begin //---------------------------------------------------- ��������� �������
              if not ObjZv[Strelka].bP[1] and //------- ���� ������� �� � ����� � ...
              not ObjZv[Strelka].bP[2] then   //------------------------- �� � ������
              begin //-------------------------------------------------- ��������� �������
                ObjZv[XStr].iP[4] := 1; //------ ������� ������ ��������� ������ ����
                ObjZv[XStr].iP[5] := 0; //--------- ��������� ��������� ���� ��������

                maket_strelki_index := XStr;
                maket_strelki_name  := ObjZv[XStr].Liter;

                ObjZv[XStr].bP[19] := true;
                ObjZv[XStr].bP[15] := true;
                ObjServ := ObjZv[XStr].ObCI[2] div 8;
                ComServ := _ustmaket;
                if SendCommandToSrv(ObjServ,ComServ,XStr) then
                begin
                  InsNewMsg(XStr,10,7,'');//--------------- ������� $ ����������� �� �����
                  ShowSMsg(10, LastX, LastY, ObjZv[XStr].Liter);
                end;
              end else
              begin //-------------- ���� �������� ��������� - ����� �� ��������� �� �����
                InsNewMsg(XStr,92,1,'');
                RSTMsg;
                AddFixMes(GetSmsg(1,92,ObjZv[XStr].Liter,1),4,1);
              end;
              break;
            end;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SnatMaketStrelki :
      begin //----------------------------------------------------- ����� ������� � ������
        Strelka := DspCom.Obj;
        XStr := maket_strelki_index;
        WorkMode.InpOgr := false;
        WorkMode.GoMaketSt := false;
        ObjServ := ObjZv[XStr].ObCI[2] div 8;
        ComServ := _snatmaket;
        if SendCommandToSrv(ObjServ,ComServ,XStr) then
        begin
          InsNewMsg(Xstr,11,7,'');
          ShowSMsg(11, LastX, LastY, maket_strelki_name);
          ObjZv[Xstr].bP[19] := false;
          ObjZv[Xstr].bP[15] := false;
          ObjZv[Xstr].iP[4] := 0; //----------- �������� ������� ������ ��������� �� �����
          ObjZv[Xstr].iP[5] := 0; //------------ �������� ������� ����� ��������� �� �����
          ObjZv[Xstr].T[3].F := 0; //-------------------------- �������� ������ ������
          ObjZv[Xstr].T[3].Activ := false; //------------------------- �������� ����������
          fr4[Xstr] := fr4[Xstr] and $fd;
          ObjMaket := ObjZv[Strelka].VBufInd;
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
        Strelka := DspCom.Obj;
        XStr := ObjZv[Strelka].BasOb;
        ObjServ := ObjZv[XStr].ObCI[2] div 8;
        ComServ := _snatmaket;
        if SendCommandToSrv(ObjServ,ComServ,XStr) then
        begin
          InsNewMsg(XStr,11,1,'');
          ShowSMsg(11, LastX, LastY, ObjZv[Xstr].Liter);
          ObjZv[XStr].bP[19] := false;
          ObjZv[XStr].bP[15] := false;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------------------ ���������
      CmdMarsh_RdyRazdMan :
      begin //------------------------------------- ������ ������� ����������� �����������
        if SetProgramZamykanie(1,false) then
        begin
          ObjZv[DspCom.Obj].bP[34] := true;
          ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
          ComServ := _svotkrmanevr;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,22,7,'');
            ShowSMsg(22, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_RdyRazdPzd :
      begin //--------------------------------------- ������ ������� ����������� ���������
        if SetProgramZamykanie(1,false) then
        begin
          ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
          ComServ := _svotkrpoezd;
          ObjZv[DspCom.Obj].bP[34] := true;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,23,2,'');
            ShowSMsg(23, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtkrytManevrovym :
      begin //--------------------------------------------- ������ ����������� �����������
        WorkMode.InpOgr := false;
        if OtkrytRazdel(DspCom.Obj,MarshM,1) then
        NewMenu_(CmdMarsh_RdyRazdMan,LastX,LastY);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtkrytProtjag :
      begin // ������ ������� �������� ����������� ��� ��������
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _svprotjagmanevr;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,417,7,'');
          ShowSMsg(417, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtkrytPoezdnym :
      begin // ������ ����������� ���������
        WorkMode.InpOgr := false;
        if OtkrytRazdel(DspCom.Obj,MarshP,1) then
          NewMenu_(CmdMarsh_RdyRazdPzd,LastX,LastY);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Razdel :
      begin
        if MarhTrac.WarN > 0 then
        begin
          NewMenu_(CmdMarsh_Razdel,LastX,LastY);
        end else
        begin // ������ ������� ����������� �������� �������
          if MarhTrac.Rod = MarshM then //��
          begin NewMenu_(CmdMarsh_RdyRazdMan,LastX,LastY); end else
          if MarhTrac.Rod = MarshP then //�
          begin NewMenu_(CmdMarsh_RdyRazdPzd,LastX,LastY); end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtmenaManevrovogo :
      begin
        WorkMode.MarhOtm := false;
        WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCom.Obj,MarshM); //������ ������� ������ �����������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtmenaPoezdnogo :
      begin
        WorkMode.MarhOtm := false; WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCom.Obj,MarshP); // ������ ������� ������ ���������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PovtorManevrovogo :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _svpovtormanevr;
        if PovtorSvetofora(DspCom.Obj, MarshM,1) then
        begin //----------------------------------------------------------- ������ �������
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,26,7,'');
            ShowSMsg(26, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PovtorPoezdnogo :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
        ComServ := _svpovtorpoezd;
        if PovtorSvetofora(DspCom.Obj, MarshP,1) then
        begin // ������ �������
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,27,2,'');
            ShowSMsg(27, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Povtor :
      begin
        if MarhTrac.WarN > 0 then
        begin
          NewMenu_(CmdMarsh_Povtor,LastX,LastY);
        end else
        begin //--------------------------------------- ������ ������� ���������� ��������
          if ObjZv[DspCom.Obj].bP[6] or ObjZv[DspCom.Obj].bP[7] then
          begin //--------------------------------------------------------------------- ��
            ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
            ComServ := _svpovtormanevr;
            if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
            begin
              InsNewMsg(DspCom.Obj,26,7,'');//������ ������� ����. �������� ����������
              ShowSMsg(26, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            end;
          end else
          if ObjZv[DspCom.Obj].bP[8] or ObjZv[DspCom.Obj].bP[9] then
          begin //----------------------------------------------------- ���� ���� ������ �
            ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
            ComServ := _svpovtorpoezd;
            if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
            begin
              InsNewMsg(DspCom.Obj,27,2,''); // ������ ������� ����. �������� ��������
              ShowSMsg(27, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            end;
          end else
            RSTMsg;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PovtorOtkrytManevr :
      begin
        WorkMode.InpOgr := false;
        if PovtorOtkrytSvetofora(DspCom.Obj, MarshM,1) then
        begin //----------------------------------------------------------- ������ �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
          ComServ := _povtorotkrytmanevr;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,26,7,'');// ������ ������� �����. �������� ����������
            ShowSMsg(26, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
        ResetTrace;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PovtorOtkrytPoezd :
      begin
        WorkMode.InpOgr := false;
        if PovtorOtkrytSvetofora(DspCom.Obj, MarshP,1) then
        begin //----------------------------------------------------------- ������ �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
          ComServ := _povtorotkrytpoezd;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,27,2,'');
            ShowSMsg(27, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
        ResetTrace;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorOtkryt :
      begin
        if MarhTrac.WarN> 0 then NewMenu_(CmdMarsh_PovtorOtkryt,LastX,LastY) else
        begin //--------------------------------------- ������ ������� ���������� ��������
          if ObjZv[DspCom.Obj].bP[6] or ObjZv[DspCom.Obj].bP[7] then
          begin //--------------------------------------------------------------------- ��
            ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
            ComServ := _povtorotkrytmanevr;
            if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
            begin
              InsNewMsg(DspCom.Obj,26,7,'');
              ShowSMsg(26, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            end;
          end else
          if ObjZv[DspCom.Obj].bP[8] or ObjZv[DspCom.Obj].bP[9] then
          begin //---------------------------------------------------------------------- �
            ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
            ComServ := _povtorotkrytpoezd;
            if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
            begin
              InsNewMsg(DspCom.Obj,27,2,'');
              ShowSMsg(27, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            end;
          end
          else RSTMsg;
          ResetTrace;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PovtorManevrMarsh :
      begin
        WorkMode.InpOgr := false;
        if PovtorMarsh(DspCom.Obj,MarshM,1) then  SendMarshrutCommand(1);//������ �������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PovtorPoezdMarsh :
      begin
        WorkMode.InpOgr := false;
        if PovtorMarsh(DspCom.Obj,MarshP,1)
        then SendMarshrutCommand(1);//------------------------------------- ������ �������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorMarh :
      begin
        if MarhTrac.WarN > 0 then
        begin
          NewMenu_(CmdMarsh_PovtorMarh,LastX,LastY);
        end else SendMarshrutCommand(1); // ������ ������� ��������� ��������� ��������
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_BlokirovkaSvet :
      begin
        WorkMode.InpOgr := false; ObjZv[DspCom.Obj].bP[13] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _blokirov;
        if ObjServ = 0 then ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,28,7,'');//-------------- ������ ������� ������������ $
          ShowSMsg(28, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_DeblokirovkaSvet :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        if ObjServ = 0 then ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
        ComServ := _razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,29,7,''); //-------- ������ ������� ������ ���������� $
          ShowSMsg(29, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_BeginMarshManevr :
      begin //------------------------------------ ������ ����������� ����������� ��������
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCom.Obj, DspCom.Com);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_BeginMarshPoezd :
      begin //-------------------------------------- ������ ����������� ��������� ��������
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCom.Obj, DspCom.Com);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------- ������ ������� ��������� ������� �� ��������� ������
      Key_QuerySetTrace : SendTraceCommand(1);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Tracert ://-- ���� ���������� ����������� ��������,�������� ������ � ������
      begin
        WorkMode.InpOgr := false;  //-------------------- ����� �������� ����� �����������
        if MarhTrac.MsgN > 0 then //------------ ���� ���� ��������� �����������
        begin //--------- ���� ��������� ����� ������� � � ������ ���� ����������� �������
          if MarhTrac.GonkaStrel and (MarhTrac.GonkaList > 0) then
          NewMenu_(Key_QuerySetTrace,LastX,LastY)//- ������ ������ ������� �����
          else  //--------------------------------------------------- ����� �������� �����
          begin ResetTrace;  PutSMsg(1,LastX,LastY,MarhTrac.Msg[1]);  end;
        end else //---------------------------------------- ���� ��� ��������� �����������
        //------ ���� ���� �������������� � ��������� ����� �������� ��� ����� ��� "�����"
        if (MarhTrac.WarN > 0) and ((MarhTrac.ObjEnd > 0) or (MarhTrac.FullTail)) then
        begin
          dec(MarhTrac.WarN); //--------------------- ��������� ������� ��������������
          if MarhTrac.WarN > 0 then //--------------- ���� ��� �������� ��������������
          begin
            TimeLockCmdDsp := LastTime; LockComDsp := true;  ShowWarning := true;
            NewMenu_(Key_ReadyWarningTrace,LastX,LastY);
          end
          //���� ����� �������������� CmdMarsh_Ready=1102 ������������� ��������� ��������
          else NewMenu_(CmdMarsh_Ready,LastX,LastY);
        end
        // ���� ��� �������������� ��� �� ��������� ����� ��������, ���������� �����������
        else AddToTracertMarshrut(DspCom.Obj);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Manevr ://------------------- ���� ����������� ������� ����������� ��������
      if SetProgramZamykanie(1,false) then  SendMarshrutCommand(1);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Poezd : //------------------------- ������������ ������� ��������� ��������
      if SetProgramZamykanie(1,false) then SendMarshrutCommand(1);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------------- ����������� ������
      M_BlokirovkaNadviga :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := true;
        ObjServ :=ObjZv[DspCom.Obj].ObCI[1];
        ComServ := _blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,28,7,''); //------------- ������ ������� ������������ $
          ShowSMsg(28, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------ �������������� ������
      M_DeblokirovkaNadviga :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[1];
        ComServ := _razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,29,7,'');
          ShowSMsg(29, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------ ��������� ������������ ����������
      M_AutoMarshVkl :
      begin
        if ObjZv[DspCom.Obj].ObCB[1] then ComServ := _CHAS_Vkl //----- ���
        else ComServ := _NAS_Vkl;

        if AutoMarsh(DspCom.Obj,true) then
        if SendCommandToSrv(config.avtodst,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,421,2,'');
          ShowSMsg(421, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------- ���������� ������������ ����������
      M_AutoMarshOtkl :
      begin
        if ObjZv[DspCom.Obj].ObCB[1] then ComServ := _CHAS_otkl //---- ���
        else ComServ := _NAS_otkl;
        if AutoMarsh(DspCom.Obj,false) then
        if SendCommandToSrv(config.avtodst,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,422,7,'');
          ShowSMsg(422, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_ResetTraceParams :
      begin //--------------------------------------------- ����� �������������� ���������
        case ObjZv[DspCom.Obj].TypeObj of
          2 :   //---------------------------------------------------------------- �������
          begin
            ObjZv[DspCom.Obj].bP[4]  := false; //----------------- �������� ���. ���������
            ObjZv[DspCom.Obj].bP[6]  := false; //----------------------------- �������� ��
            ObjZv[DspCom.Obj].bP[7]  := false; //----------------------------- �������� ��
            ObjZv[DspCom.Obj].bP[10] := false; //--------- �������� 1-� ������ �����������
            ObjZv[DspCom.Obj].bP[11] := false; //--------- �������� 2-� ������ �����������
            ObjZv[DspCom.Obj].bP[12] := false;//---------����� ���������� �������� � �����
            ObjZv[DspCom.Obj].bP[13] := false;//--------- ����� �������. �������� � ������
            ObjZv[DspCom.Obj].bP[14] := false; //--------------- �������� ��������� �� ���
            ObjZv[DspCom.Obj].iP[1] := 0; //----------------------- ����� ������� ��������

            o := ObjZv[DspCom.Obj].BasOb; //--------------------------- ����� �������
            ObjZv[o].bP[4]  := false; //-------------------------- �������� ���. ���������
            ObjZv[o].bP[6]  := false; //-------------------------------------- �������� ��
            ObjZv[o].bP[7]  := false; //-------------------------------------- �������� ��
            ObjZv[o].bP[14] := false; //---------------------------- �������� ��������� ��
            RSTMsg;
          end;

          3 :   //---------------------------------------------------------------- �������
          begin
            ObjZv[DspCom.Obj].bP[14] := false; //------------ ����� ������������ ���������
            ObjZv[DspCom.Obj].bP[15] := false; //------------------------------- ����� 1��
            ObjZv[DspCom.Obj].bP[16] := false; //------------------------------- ����� 2��
            ObjZv[DspCom.Obj].iP[1] := 0; //----------------------- ����� ������� ��������
            ObjZv[DspCom.Obj].iP[2] := 0; //------------------------ ����� ������� �������
            ObjZv[DspCom.Obj].bP[8] := true; //--------- ����� ��������������� �����������
            o := DspCom.Obj;

            ObjServ := ObjZv[o].ObCI[2] div 8;
            ComServ := _resettrace;
            if SendCommandToSrv(ObjServ,ComServ,o) then
            begin
              InsNewMsg(o,312,7,''); //--------------------- "������ ������� ������������"
              ShowSMsg(312, LastX, LastY, ObjZv[o].Liter);

              for p := 1 to High(ObjZv) do //------------ ������ �� ���� �������� �������
              case ObjZv[p].TypeObj of
                2 ://------------------------------------------------------------- �������
                begin
                  if ObjZv[p].UpdOb = DspCom.Obj then //------- ������� � ������ ��
                  begin //- ����� �������� ����������� �������, ��������� � ������ �������
                    ObjZv[p].bP[6]  := false; //-------------------------------- ������ ��
                    ObjZv[p].bP[7]  := false; //-------------------------------- ������ ��
                    ObjZv[p].bP[10] := false; //---------- �������� 1-� ������ �����������
                    ObjZv[p].bP[11] := false; //---------- �������� 2-� ������ �����������
                    ObjZv[p].bP[12] := false;//--------- ����� ���������� �������� � �����
                    ObjZv[p].bP[13] := false;//-------- ����� ���������� �������� � ������
                    ObjZv[p].bP[14] := false; //-------------- ����� ����������� ���������
                    ObjZv[p].iP[1]  := 0;    //-------------------- ����� ������� ��������
                    o := ObjZv[p].BasOb;    //------------------------- ����� �������
                    ObjZv[o].bP[6]  := false; //-------------------------------- ������ ��
                    ObjZv[o].bP[7]  := false; //-------------------------------- ������ ��
                    ObjZv[o].bP[14] := false; //-------------- ����� ����������� ���������
                  end;
                end;

                41 :
                begin //------------------------------------ �������� �������� �����������
                  if ObjZv[p].UpdOb = DspCom.Obj then
                  begin //------ ����� �������������� ��������, ��������� � ������ �������
                    ObjZv[p].bP[1]  := false;//---- ���������� �������� 1-� ������� � ����
                    ObjZv[p].bP[2]  := false;//---- ���������� �������� 2-� ������� � ����
                    ObjZv[p].bP[3]  := false;//---- ���������� �������� 3-� ������� � ����
                    ObjZv[p].bP[4]  := false;//---- ���������� �������� 4-� ������� � ����
                    ObjZv[p].bP[8]  := false;//---- - �������� �������� 1-� ������� � ����
                    ObjZv[p].bP[9]  := false;//---- - �������� �������� 2-� ������� � ����
                    ObjZv[p].bP[10] := false;//---- - �������� �������� 3-� ������� � ����
                    ObjZv[p].bP[11] := false;//---- - �������� �������� 4-� ������� � ����
                    ObjZv[p].bP[20] := false;//---- ����� ������� ��������� �������� ����.
                    ObjZv[p].bP[21] := false;//----- -- ����� ������� ����������� ��������
                    ObjZv[p].bP[23] := false;//---- ����� ���������. ��������� 1-� �������
                    ObjZv[p].bP[24] := false;//---- ����� ���������. ��������� 2-� �������
                    ObjZv[p].bP[25] := false;//---- ����� ���������. ��������� 3-� �������
                    ObjZv[p].bP[26] := false;//---- ����� ���������. ��������� 4-� �������
                  end;
                end;

                42 :
                begin //------------ ������ ������������� ��������� �������� �� ����������
                  if ObjZv[p].UpdOb = DspCom.Obj then //-------- ������ ������ � ��
                  begin //------ ����� �������������� ��������, ��������� � ������ �������
                    ObjZv[p].bP[1]  := false;//---------- ����� "�������� �������� ������"
                    ObjZv[p].bP[2]  := false;//------------ ����� ���������� �������������
                    ObjZv[p].bP[3]  := false; //---------------- ����� ��������� �� � ����
                  end;
                end;
              end;
            end;
          end;

          4 :
          begin //------------------------------------------------------------------- ����
            ObjZv[DspCom.Obj].bP[14] := false;
            ObjZv[DspCom.Obj].iP[1] := 0;
            ObjZv[DspCom.Obj].iP[2] := 0;
            ObjZv[DspCom.Obj].iP[3] := 0;
            ObjZv[DspCom.Obj].bP[8] := true;
            o := DspCom.Obj;
            ObjServ := ObjZv[o].ObCI[2] div 8;
            ComServ := _resettrace;
            if SendCommandToSrv(ObjServ,ComServ,o) then
            begin
              InsNewMsg(o,312,7,''); //--------------------- ������ ������� ������������ $
              ShowSMsg(312, LastX, LastY, ObjZv[o].Liter);
            end;
          end;

          5 :
          begin //--------------------------------------------------------------- ��������
            ObjZv[DspCom.Obj].bP[14] := false;
            ObjZv[DspCom.Obj].iP[1] := 0;
            ObjZv[DspCom.Obj].bP[7] := false;
            ObjZv[DspCom.Obj].bP[9] := false;
            o := DspCom.Obj;

            ObjServ := ObjZv[o].ObCI[3] div 8;
            if  ObjServ = 0 then ObjServ := ObjZv[o].ObCI[5] div 8;
            ComServ := _resettrace;

            if SendCommandToSrv(ObjServ,ComServ,o) then
            begin
              InsNewMsg(o,312,7,'');  //-------------------- ������ ������� ������������ $
              ShowSMsg(312, LastX, LastY, ObjZv[o].Liter);
            end;
          end;

          else  result := false;
          exit;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// --------------------------------------------------------------------------------�������
      M_SekciaPredvaritRI :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        if ObjZv[DspCom.Obj].ObCB[7]
        then i := ObjZv[DspCom.Obj].BasOb //--------------------------------- �������
        else i := DspCom.Obj; //--------------------------------------------------- ������

        ObjServ := ObjZv[DspCom.Obj].ObCI[7];
        ComServ := _ispiskrazmyk;

        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjZv[DspCom.Obj].ObCI[7] div 8;
        ComServ := _predviskrazmyk;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(i,33,7,''); //- ������ ���������. ������� �������������� ���������� ��
          ShowSMsg(33, LastX, LastY, ObjZv[i].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaIspolnitRI :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if ObjZv[DspCom.Obj].ObCB[7] then

        i := ObjZv[DspCom.Obj].BasOb //-------------------------------------- �������
        else i := DspCom.Obj; //--------------------------------------------------- ������

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //------------- ������ �������������� �������, �������� �������� �����������
          ObjZv[DspCom.Obj].bP[14] := false;
          ObjZv[DspCom.Obj].iP[1] := 0;
          ObjZv[DspCom.Obj].bP[8] := true;

          ObjServ := ObjZv[DspCom.Obj].ObCI[7] div 8;
          ComServ := _ispiskrazmyk;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(i,34,7,'');//������ ������. ������� �������������� ���������� ������
            ShowSMsg(34, LastX, LastY, ObjZv[i].Liter);
            IncrementKOK;
          end;
        end else
        begin
          InsNewMsg(i,155,1,''); //------ ������� ������� ���������� ������������� �������
          ShowSMsg(155, LastX, LastY, ObjZv[i].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaZakrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,35,7,'');
          ShowSMsg(35, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaOtkrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,36,2,'');//--- ������ ������� ���������� �������� �� ������
          ShowSMsg(36, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,460,7,'');//--- ������ ������� ��������  ��� �������� �� ��
          ShowSMsg(460, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,461,2,'');//---- ������ ������� �������� ��� �������� �� ��
          ShowSMsg(461, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,470,7,'');//--- ������ ������� �������� ��� �������� �� ~��
          ShowSMsg(470, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,471,2,'');//--- ������ ������� �������� ��� �������� �� ~��
          ShowSMsg(471, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,465,7,'');//--- ������ ������� �������� ��� �������� �� =��
          ShowSMsg(465, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SekciaOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,466,2,'');//--- ������ ������� �������� ��� �������� �� =��
          ShowSMsg(466, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------------------- ����
      M_PutDatSoglasieOgrady :
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZv[ObjZv[DspCom.Obj].UpdOb].ObCI[4] div 8;
        ComServ := _putustograd;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,37,7,'');//-------- ������ ������� �������� �� ���������� $
          ShowSMsg(37, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutZakrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,39,7,'');//---------- ������ ������� �������� �������� �� $
          ShowSMsg(39, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutOtkrytDvijenie :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,40,2,''); //------- ������ ������� ���������� �������� �� $
          ShowSMsg(40, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutVklOPI :
      with ObjZv[DspCom.Obj] do  //-------------------------------------------- ������ ���
      begin
        ObjServ := ObCI[1] div 8;  ComServ := _vklOPI; //---------------------- ������ ���
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin //------------------------------ ������ ������� ���������� �������� ��  ����
          InsNewMsg(DspCom.Obj,414,7,''); ShowSMsg(414,LastX,LastY,ObjZv[UpdOb].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutOtklOPI :
      with ObjZv[DspCom.Obj] do
      begin
        ObjServ := ObCI[1] div 8; ComServ := _otklOPI;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin //------------------------------ ������ ������� ����.�������� �� ���� ��� ��
          InsNewMsg(DspCom.Obj,415,7,''); ShowSMsg(415,LastX,LastY,ObjZv[UpdOb].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,460,7,'');//---- ������ ������� �������� ��� �������� �� ��
          ShowSMsg(460, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,461,2,'');//---- ������ ������� �������� ��� �������� �� ��
          ShowSMsg(461, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,470,7,'');//--- ������ ������� �������� ��� �������� �� ~��
          ShowSMsg(470, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,471,2,'');//--- ������ ������� �������� ��� �������� �� ~��
          ShowSMsg(471, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,465,7,'');//--- ������ ������� �������� ��� �������� �� =��
          ShowSMsg(465, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PutOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,466,2,'');//--- ������ ������� �������� ��� �������� �� =��
          ShowSMsg(466, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------------------- ��������� �������
      M_ZamykanieStrelok :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _zamykstr;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,41,7,''); //-------------------- ������ ������� ��������� $
          ShowSMsg(41, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          IncrementKOK;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PredvRazmykanStrelok :
      begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2];
        ComServ := _isprazmykstr;

        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ); //---------- �������� ��������������

        ObjServ := ObjServ div 8;
        ComServ := _predvrazmykstr;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,42,7,'');//------ ������ ��������������� ������� ����������
          ShowSMsg(42, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolRazmykanStrelok :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[4] div 8;
          ComServ := _isprazmykstr;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,43,7,'');//--- ������ �������������� ������� ���������� $
            ShowSMsg(43, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------- �������� ������ ��������
      M_DatZapretMonteram  :
      begin
        if(ObjZv[DspCom.Obj].TypeObj=36) and (ObjZv[DspCom.Obj].BasOb >0) then
        begin
          Baza := ObjZv[DspCom.Obj].BasOb;
          mogu := ObjZv[DspCom.Obj].ObCI[32];
          if (mogu > 0) and not ObjZv[Baza].bP[mogu] then
          begin
            InsNewMsg(DspCom.Obj,578,1,'');
            ShowSMsg(578, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            DspCom.Com := 0;
            DspCom.Active := false;
            DspCom.Obj := 0;
            exit;
          end;
          ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        end
        else ObjServ := ObjZv[DspCom.Obj].ObCI[6] div 8;
        WorkMode.InpOgr := false;
        ComServ := _VklZapMont;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,51,7,'');//--- ������ ������� ���. ������� �������� (�����)
          ShowSMsg(51, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//----------------------------------------------------------------------------------------
      M_PredvOtklZapMont :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        if(ObjZv[DspCom.Obj].TypeObj=36) and (ObjZv[DspCom.Obj].BasOb >0)
        then  ObjServ := ObjZv[DspCom.Obj].ObCI[13]
        else  ObjServ := ObjZv[DspCom.Obj].ObCI[6];
        ComServ := _IspolOtklZapMont;

        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := _PredvOtklZapMont;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,529,7,''); //---- ������ ����.������� ����.������� ��������
          ShowSMsg(529, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolOtklZapMont :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;

        if(ObjZv[DspCom.Obj].TypeObj=36) and (ObjZv[DspCom.Obj].BasOb >0)
        then  ObjServ := ObjZv[DspCom.Obj].ObCI[11]
        else  ObjServ := ObjZv[DspCom.Obj].ObCI[7];
        ObjServ := ObjServ div 8;
        ComServ := _IspolOtklZapMont;

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj)
          then
          begin
            InsNewMsg(DspCom.Obj,530,7,'');//--------------- ������ �������������� �������
            ShowSMsg(530, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//----------------------------------------------------------------------------------------
      {
      M_PredvOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZv[DspCom.Obj].ObCI[6];
        ComServ := _IspolOtklBit3;

        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := _PredvOtklZapMont;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,529); //-- ������ ����.������� ����.������� ��������
          ShowSMsg(529, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolOtklZapMont :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;

        ObjServ := ObjZv[DspCom.Obj].ObCI[7] div 8;
        ComServ := _IspolOtklZapMont;

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj)
          then
          begin
            InsNewMsg(DspCom.Obj,530);//------------- ������ �������������� �������
            ShowSMsg(530, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155);
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
      }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------- ���������� ���������
      M_ZakrytPereezd :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[12] div 8;
        ComServ := _pereezdzakryt;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,44,7,'');//-------- ������ ������� �������� ��������  $
          ShowSMsg(44, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PredvOtkrytPereezd :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[12];
        ComServ := _isppereezdotkr;

        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := _predvpereezdotkr;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,45,7,'');// ������ ���������. ������� �������� ��������
          ShowSMsg(45, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolOtkrytPereezd :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
          ComServ := _isppereezdotkr;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,46,7,'');//������ ��������. ������� �������� ��������
            ShowSMsg(46, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_DatIzvecheniePereezd :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8; //--------------------- ���
        ComServ := _pereezdvklizv;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,47,7,'');//------ ������ ������� ��������� �� ������� $
          ShowSMsg(47, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SnatIzvecheniePereezd :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[14] div 8; //-------------------- ����
        if DspCom.Com = M_SnatIzvecheniePereezd
        then  ComServ := _pereezdotklizv
        else ComServ := _pereezdotklizv1;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,48,7,'');//- ������ ������� ������ ��������� �� �������
          ShowSMsg(48, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------------------------------------------------------- ���������� ��������
      M_DatOpovechenie :
      begin
        WorkMode.InpOgr := false;

        if ObjZv[DspCom.Obj].TypeObj = 36
        then  ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8
        else ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _opovvkl;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,49,7,''); //------- ������ ������� ��������� ����������
          ShowSMsg(49, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SnatOpovechenie :
      begin
        WorkMode.InpOgr := false;

        if ObjZv[DspCom.Obj].TypeObj = 36
        then  ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8
        else ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _opovotkl;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,50,7,'');//------- ������ ������� ���������� ����������
          ShowSMsg(50, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------------------------------- �����
      M_PredvOtkluchenieUKSPS :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZv[DspCom.Obj].ObCI[3];
        ComServ := _ispukspsotkl;
        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _predvukspsotkl;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,53,7,'');//- ������ ���������. ������� ���������� �����
          ShowSMsg(53, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolOtkluchenieUKSPS :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
          ComServ := _ispukspsotkl;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,54,7,'');// ������ ��������. ������� ���������� �����
            ShowSMsg(54, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,7,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtmenaOtkluchenieUKSPS :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _otmenablokUksps;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,354,7,'');//---- ������ ������� ������ ���������� �����
          ShowSMsg(354, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PredvOtkluchenieUKG :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZv[DspCom.Obj].ObCI[4];
        ComServ := _ispolOtklUkg;

        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjServ div 8;
        ComServ := _predvOtklUkg;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,566,7,'');//-- ������ ���������. ������� ���������� ���
          ShowSMsg(566, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolOtkluchenieUKG:
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
          ComServ := _ispolOtklUkg;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,567,7,'');//������ ����������. ������� ���������� ���
            ShowSMsg(567, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtmenaOtkluchenieUKG :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[4] div 8;
        ComServ := _otmenaOtklUkg;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,568,7,''); //----- ������ ������� ������ ���������� ���
          ShowSMsg(568, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------------------------------------------------------------------- �������
      M_SmenaNapravleniya :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _absmena;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,55,7,'');//������ ������� ����� ����������� �� ��������
          ShowSMsg(55, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_DatSoglasieSmenyNapr :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[9] div 8;
        ComServ := _absoglasie;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,56,7,'');//������ ������� �������� �� ����� �����������
          ShowSMsg(56, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VklKSN :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[1] div 8;
        ComServ := _vklksn;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,409,7,'');//--- ������ ������� ����������� ��������� ��
          ShowSMsg(409, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          IncrementKOK;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklKSN :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[1] div 8;
        ComServ := _otklksn;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,410,7,''); //--- ������ ������� ���������� ��������� ��
          ShowSMsg(410, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PredvVspomOtpravlenie :
      begin
        WorkMode.InpOgr := false; WorkMode.VspStr := false;

        ObjServ := ObjZv[DspCom.Obj].ObCI[4];
        ComServ := _ispvspotpr;
        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjZv[DspCom.Obj].ObCI[4] div 8;
        ComServ := _predvvspotpr;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,59,7,'');//������ �������. ������� �������. �����������
          ShowSMsg(59, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolVspomOtpravlenie :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
          ComServ := _ispvspotpr;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,60,7,'');//������ ������. ������� �������.�����������
            ShowSMsg(60, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PredvVspomPriem :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZv[DspCom.Obj].ObCI[5];
        ComServ := _ispvsppriem;
        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
        ComServ := _predvvsppriem;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,61,7,'');//������ �����.������� ���������������� ������
          ShowSMsg(61, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolVspomPriem :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
          ComServ := _ispvsppriem;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,62,7,'');//������ ��������. ������� ���������. ������
            ShowSMsg(62, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ZakrytPeregon :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,57,7,''); //---------- ������ ������� �������� ��������
          ShowSMsg(57, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtkrytPeregon :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,58,2,''); //--------- ������ ������� �������� ��������
          ShowSMsg(58, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_SnatSoglasieSmenyNapr :
      begin
        WorkMode.InpOgr := false;
        WorkMode.MarhOtm := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[9] div 8;
        ComServ := _otmenasogsnab;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,438,7,''); //������ ������� ������ �������� ����� ����.
          ShowSMsg(438, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ABZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,460,7,'');// ������ ������� �������� ��� �������� �� ��
          ShowSMsg(460, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ABOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,461,2,'');// ������ ������� �������� ��� �������� �� ��
          ShowSMsg(461, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ABZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,470,7,'');//������ ������� �������� ��� �������� �� ~��
          ShowSMsg(470, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ABOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,471,2,'');//������ ������� �������� ��� �������� �� ~��
          ShowSMsg(471, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ABZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,465,7,'');//������ ������� �������� ��� �������� �� =��
          ShowSMsg(465, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ABOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
        ComServ := _razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,466,2,'');//������ ������� �������� ��� �������� �� =��
          ShowSMsg(466, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------------------------ ���
      M_VydatSoglasieOtpravl :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
        ComServ := _pabsoglasievkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,321,7,'');//----- ������ ������� �������� ����������� $
          ShowSMsg(321, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtmenaSoglasieOtpravl :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[5] div 8;
        ComServ := _pabsoglasieotkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,322,7,'');// ������ ������� ������ �������� �����������
          ShowSMsg(322, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IskPribytiePredv :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        ObjServ := ObjZv[DspCom.Obj].ObCI[4];
        ComServ := _isppabiskpribytie;
        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjZv[DspCom.Obj].ObCI[4] div 8;
        ComServ := _predvpabiskpribytie;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,323,7,'');//������ �����. ������� �����.�������� ������
          ShowSMsg(323, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IskPribytieIspolnit :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[3] div 8;
          ComServ := _isppabiskpribytie;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,324,7,'');//������ �����. ������� ���.�������� ������
            ShowSMsg(324, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VydatPribytiePoezda :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _pabpribytie;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,325,7,'');//---------- ������ ������� �������� ������ $
          ShowSMsg(325, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_ZakrytPeregonPAB :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,5,7,''); //-------- ������ ������� �������� �������� $
          ShowSMsg(57, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtkrytPeregonPAB :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[13] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,58,2,'');//--------- ������ ������� �������� �������� $
          ShowSMsg(58, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RPBZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,460,7,'');
          ShowSMsg(460, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RPBOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,461,2,'');
          ShowSMsg(461, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RPBZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,470,7,'');
          ShowSMsg(470, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RPBOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,471,2,'');
          ShowSMsg(471, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RPBZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _blokirovETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,465,7,'');
          ShowSMsg(465, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_RPBOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[13] div 8;
        ComServ := _razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,466,2,'');
          ShowSMsg(466, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- ���������� ����������� ������
      M_ZakrytUvjazki :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[15] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,5,7,'');//--------- ������ ������� �������� �������� $
          ShowSMsg(57, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtkrytUvjazki :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[15] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _razblokir;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,58,2,'');//--------- ������ ������� �������� �������� $
          ShowSMsg(58, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_EZZakrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _blokirovET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,460,7,'');
          ShowSMsg(460, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_EZOtkrytDvijenieET :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[24] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _razblokirET;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,461,2,'');
          ShowSMsg(461, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_EZZakrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := true;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _blokirovETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,470,7,'');
          ShowSMsg(470, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_EZOtkrytDvijenieETA :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[26] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _razblokirETA;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,471,2,'');
          ShowSMsg(471, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_EZZakrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := true;
        if SendCommandToSrv(ObjZv[DspCom.Obj].ObCI[8] div 8,_blokirovETD,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,465,7,'');
          ShowSMsg(465, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_EZOtkrytDvijenieETD :
      begin
        WorkMode.InpOgr := false;
        ObjZv[DspCom.Obj].bP[25] := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _razblokirETD;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,466,2,'');
          ShowSMsg(466, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------------------------- ������
      M_VkluchOchistkuStrelok :
      begin
        WorkMode.InpOgr := false;
        case (ObjZv[DspCom.Obj].ObCI[11] -
        (ObjZv[DspCom.Obj].ObCI[11] div 8) * 8) of
          0 : ComServ := _knopka1vkl;  //--------------------- ������� � ������ ����
          1 : ComServ := _knopka2vkl; //--------------------- ������� �� ������ ����
        else
          result := false;
          exit;
        end;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then//���� ����� ������� �� ���������
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[6],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklOchistkuStrelok :
      begin
        WorkMode.InpOgr := false;

        case (ObjZv[DspCom.Obj].ObCI[11] -
        (ObjZv[DspCom.Obj].ObCI[11] div 8) * 8) of
          0 : ComServ := _knopka1otkl;
          1 : ComServ := _knopka2otkl;
          else result := false; exit;
        end;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[5] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[7],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //----------------------------------------------------------------------------------
      M_VklBit1 :
      begin
        if(ObjZv[DspCom.Obj].TypeObj=36) and (ObjZv[DspCom.Obj].BasOb >0)
        then
        if not ObjZv[DspCom.Obj].bP[2] then
        begin
          InsNewMsg(DspCom.Obj,578,1,'');
          ShowSMsg(578, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          DspCom.Com := 0;
          DspCom.Active := false;
          DspCom.Obj := 0;
          exit;
        end;
        WorkMode.InpOgr := false;
        ComServ := _knopka1vkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[6],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklBit1 :
      begin
        if(ObjZv[DspCom.Obj].TypeObj=36) and (ObjZv[DspCom.Obj].BasOb >0)
        then
        if not ObjZv[DspCom.Obj].bP[2] then
        begin
          InsNewMsg(DspCom.Obj,578,1,'');
          ShowSMsg(578, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          DspCom.Com := 0;
          DspCom.Active := false;
          DspCom.Obj := 0;
          exit;
        end;
        WorkMode.InpOgr := false;
        ComServ := _knopka1otkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[5] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[7],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VklBit2 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka2vkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[6],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklBit2 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka2otkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[7],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VklBit3 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka3vkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[6],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklBit3 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka3otkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[7],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[7]]);
          end;
        end;
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //------------------------ ���������� ���������������� ���������� ���� 3 ������� FR3
      M_PredOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        i := DspCom.Obj; //----------------------------- ������� ��������� �����������
        ObjServ := ObjZv[DspCom.Obj].ObCI[13]; // ������ ��������� �����.�������
        ComServ := _ispolOtkl3bit; //--------- ��� �������������� ������� ����������
        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ); //- ��������� ��������� ��������
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8; //���������� ������ �������
        ComServ := _predvOtkl3bit; //------------------- ��� ��������������� �������
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then //������� ���������������
        begin
          InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[18],7,'');
          ShowSMsg(529, LastX, LastY, ObjZv[i].Liter);
        end;
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //------------------------------------------------------- ���������� 3-�� ���� � fr3
      M_IspolOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _IspolOtkl3bit;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //-------------------------------------------- ������ �������������� �������
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj)
          then
          begin
            InsNewMsg(DspCom.Obj,530,7,'');//----------- ������ �������������� �������
            ShowSMsg(530, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VklBit4 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka4vkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[6],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklBit4 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka4otkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[7],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VklBit5 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka5vkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[6],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[6]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklBit5 :
      begin
        WorkMode.InpOgr := false;
        ComServ := _knopka5otkl;
        ObjServ := ObjZv[DspCom.Obj].ObCI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          if ObjZv[DspCom.Obj].ObCI[4] > 0 then
          begin
            InsNewMsg(DspCom.Obj,ObjZv[DspCom.Obj].ObCI[7],7,'');
            PutSMsg(2, LastX, LastY, MsgList[ObjZv[DspCom.Obj].ObCI[7]]);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VkluchenieGRI :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _grivkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,65,7,'');
          ShowSMsg(65, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          IncrementKOK;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      M_ZaprosPoezdSoglasiya :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _upzaprospoezdvkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,66,7,'');
          ShowSMsg(66, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtmZaprosPoezdSoglasiya :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _upzaprospoezdotkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,67,7,'');
          ShowSMsg(67, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------------- ���������� �������
      M_DatRazreshenieManevrov :
      begin
        WorkMode.InpOgr := false;
        VytajkaZM(DspCom.Obj);

        if WorkMode.RazdUpr then
        begin

          i := ObjZv[DspCom.Obj].ObCI[2] -
          (ObjZv[DspCom.Obj].ObCI[2] div 8) * 8;
          case i of
            1 : ComServ := _knopka2vkl;
            2 : ComServ := _knopka3vkl;
            3 : ComServ := _knopka4vkl;
            4 : ComServ := _knopka5vkl;
            else  ComServ := _knopka1vkl;
          end;
          ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;

          if SendCommandToSrv(ObjServ,ComServ ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,68,7,'');
            ShowSMsg(68, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end else
        begin
          ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
          ComServ := _manevryrm;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,68,7,'');
            ShowSMsg(68, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdManevry_ReadyWar :
      begin //---------------------------- �������� ������������� �������������� ���������
        if MarhTrac.WarN > 0 then
        begin //------------------------------------------ ����� ���������� ��������������
          NewMenu_(CmdManevry_ReadyWar,LastX,LastY);
        end else
        begin
          VytajkaZM(DspCom.Obj);
          if WorkMode.RazdUpr then
          begin
            i := ObjZv[DspCom.Obj].ObCI[2] -
            (ObjZv[DspCom.Obj].ObCI[2] div 8) * 8;
            case i of
              1  : ComServ := _knopka2vkl;
              2  : ComServ := _knopka3vkl;
              3  : ComServ := _knopka4vkl;
              4  : ComServ := _knopka5vkl;
              else ComServ := _knopka1vkl;
            end;
            ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
            if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
            begin
              InsNewMsg(DspCom.Obj,68,7,'');
              ShowSMsg(68, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            end;
          end else
          begin
            ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
            ComServ := _manevryrm;
            if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
            begin
              InsNewMsg(DspCom.Obj,68,7,'');
              ShowSMsg(68, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            end;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtmenaManevrov :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[2] div 8;
        ComServ := _manevryotmen;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin

          VytajkaOZM(DspCom.Obj);

          if not ObjZv[DspCom.Obj].bP[3] and
          ObjZv[DspCom.Obj].bP[5] then
          begin
            InsNewMsg(DspCom.Obj,447,7,'');//----- ������ ������� ��������� �������� $
            ShowSMsg(447, LastX, LastY, ObjZv[DspCom.Obj].Liter)
          end else
          begin
            InsNewMsg(DspCom.Obj,69,7,'');//--------- ������ ������� ������ �������� $
            ShowSMsg(69, LastX, LastY, ObjZv[DspCom.Obj].Liter);
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_PredvIRManevrov :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[8];
        ComServ := M_IspolIRManevrov;
        GoWaitOtvCommand(DspCom.Obj,ObjServ,ComServ);

        ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
        ComServ := _predvmanevryri;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,70,7,'');// ������ �����.������� �����.������. ��������
          ShowSMsg(70, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_IspolIRManevrov :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCom.Obj) then
        begin //------------------------------------------- ������ �������������� �������
          ObjServ := ObjZv[DspCom.Obj].ObCI[8] div 8;
          ComServ := _ispmanevryri;
          if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
          begin
            InsNewMsg(DspCom.Obj,71,7,'');// ������ ���. ������� ���. ������. ��������
            ShowSMsg(71, LastX, LastY, ObjZv[DspCom.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- ������� ������� ���������� ������������� �������
        begin
          InsNewMsg(DspCom.Obj,155,1,'');
          ShowSMsg(155, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------ ���������� ������ ���
      M_OtklDSN:
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,549,7,'');
          ShowSMsg(549, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------- ��������� ������ ���
      M_VklDSN:
      begin
        WorkMode.InpOgr := false;
        DspCom.Obj := ObjZv[DspCom.Obj].BasOb;
        ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,548,7,''); //------ ������ ������� ��������� ������ ���
          ShowSMsg(548, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- ��������� ���� 1 1-�� �������
      M_VklBit1_1:
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
         InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[7]+$4000,7,'');//- ������ �� ����� ����
         msg := MsgList[ObjZv[ID_Obj].ObCI[7]];
         PutSMsg(7, LastX, LastY, msg);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- ��������� ���� 1 2-�� �������
      M_VklBit1_2:
      begin
        WorkMode.InpOgr := false;
        DspCom.Obj := ObjZv[DspCom.Obj].BasOb;
        ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
         InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[6]+$4000,7,'');//- ������ �� ����� ����
         msg := MsgList[ObjZv[ID_Obj].ObCI[6]];
         PutSMsg(2, LastX, LastY, msg);
        end;
      end;


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------- ������������ ������ ������� ���� ���������� �� �������
      M_VkluchitDen :
      begin
        WorkMode.InpOgr := false;

        if (ObjZv[DspCom.Obj].TypeObj = 36) and ObjZv[DspCom.Obj].bP[1] then
        begin
          InsNewMsg(DspCom.Obj,551,7,'');//---------------- ��� ������� ��� ���������!
          ShowSMsg(551, LastX, LastY, '');
          exit;
        end;

        if ObjZv[DspCom.Obj].TypeObj = 92
        then ObjServ :=ObjZv[DspCom.Obj].ObCI[5] div 8
        else ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _dnkden;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          AddFixMes(GetSmsg(1,72,'',2),0,2);//������ ������� �����.�������� ������
          InsNewMsg(DspCom.Obj,72,2,'');
          ShowSMsg(72, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VkluchitNoch :
      begin
        WorkMode.InpOgr := false;
        if (ObjZv[DspCom.Obj].TypeObj = 36) and
        not ObjZv[DspCom.Obj].bP[1] then
        begin
          InsNewMsg(DspCom.Obj,551,7,'');
          ShowSMsg(551, LastX, LastY, '');
          exit;
        end;

        if ObjZv[DspCom.Obj].TypeObj = 92
        then ObjServ :=ObjZv[DspCom.Obj].ObCI[5] div 8
        else ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _dnknocth;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          AddFixMes(GetSmsg(1,73,'',7),0,2);
          InsNewMsg(DspCom.Obj,73,7,''); //--- ������ ������� ��������� ������� ������
          TXT := GetSmsg(1,73,ObjZv[DspCom.Obj].Liter,7);
          PutSMsg(7, LastX, LastY, TXT);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_VkluchitAuto :
      begin
        WorkMode.InpOgr := false;
        if (ObjZv[DspCom.Obj].TypeObj = 36) and
        ObjZv[DspCom.Obj].bP[1] then
        begin
          InsNewMsg(DspCom.Obj,551,7,'');
          ShowSMsg(551, LastX, LastY, '');
          exit;
        end;
        if ObjZv[DspCom.Obj].TypeObj = 92
        then ObjServ :=ObjZv[DspCom.Obj].ObCI[4] div 8
        else ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _dnkauto;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,74,7,'');//������ ������� ���.���������.���� ����������
          ShowSMsg(74, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtkluchitAuto :
      begin
        WorkMode.InpOgr := false;

        if ObjZv[DspCom.Obj].TypeObj = 92
        then ObjServ :=ObjZv[DspCom.Obj].ObCI[4] div 8
        else ObjServ :=ObjZv[DspCom.Obj].ObCI[11] div 8;
        ComServ := _otkldnkauto;

        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,479,7,'');//������ ���. ����. ���������.���� ����������
          ShowSMsg(479, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      M_OtklZvonkaUKSPS :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZv[DspCom.Obj].ObCI[1] div 8;
        ComServ := _ukspsotklzvon;
        if SendCommandToSrv(ObjServ,ComServ,DspCom.Obj) then
        begin
          InsNewMsg(DspCom.Obj,75,7,'');//----- ������ ������� ���������� ������ �����
          ShowSMsg(75, LastX, LastY, ObjZv[DspCom.Obj].Liter);
        end;
      end;

    else
      RSTMsg;
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
function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
//------------------------------- Obj - ������ ������������, ��� �������� �������� �������
//------------------------------------------------ Cmd - ��� �������, ���������� �� ������
//------------------------------------------------------------- Index - ������ ��� �������
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
//========================================================================================
//--------------------------------------------- ������ �������� � ������� Double �� ������
function SendDoubleToSrv(Param : int64; Cmd : Byte; Index : Word) : Boolean;
var
  i : int64;
begin
  if (DoubleCnt < 1) and (Cmd > 0) then
  begin
    CmdSendT := LastTime; // ��������� ����� ������ ���������
    inc(DoubleCnt);
    ParamDouble.Cmd := Cmd;
    // ����������� Param �� 8 ����
    ParamDouble.Index[1] := Param and $ff;
    i := (Param and $ff00) shr 8;              ParamDouble.Index[2] := i;
    i := (Param and $ff0000) shr 16;           ParamDouble.Index[3] := i;
    i := (Param and $ff000000) shr 24;         ParamDouble.Index[4] := i;
    i := (Param and $ff00000000) shr 32;       ParamDouble.Index[5] := i;
    i := (Param and $ff0000000000) shr 40;     ParamDouble.Index[6] := i;
    i := (Param and $ff000000000000) shr 48;   ParamDouble.Index[7] := i;
    i := (Param and $ff00000000000000) shr 56; ParamDouble.Index[8] := i;
    ParamDouble.LastObj := Index;  result := true;
    if not((Cmd=_newDT) or (Cmd=_autoDT)) then WorkMode.CmdReady := true;
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
  Ima, Vrem : string;
begin
  if index <= LastFixed then exit;
  Vrem := DateTimeToStr(DTFrameOffset);
  if Cmd = 0 then
  begin
    NewNeisprav := true;
    case ifr of
          0: LstNN := Vrem+' > ����� ������� <Esc>'                    + #13#10+ LstNN;
      $7fe5: LstNN := Vrem+' > "����� �� ������ ��"'                   + #13#10+ LstNN;
      $7fe6: LstNN := Vrem+' > "������� � ����� ��"'                   + #13#10+ LstNN;
      $7fe7: LstNN := Vrem+' > "���������� ������� �������"'           + #13#10+ LstNN;
      $7fe8: LstNN := Vrem+' > "����� ������������ ������"'            + #13#10+ LstNN;
      $7fe9: LstNN := Vrem+' > "���������� ���������� �� ��-���"'      + #13#10+ LstNN;
      $7fea: LstNN := Vrem+' > "����� ������� ������ ��"'              + #13#10+ LstNN;
      $7feb: LstNN := Vrem+' > "������� 2-� ����� ����������"'         + #13#10+ LstNN;
      $7fec: LstNN := Vrem+' > "������� 1-� ����� ����������"'         + #13#10+ LstNN;
      $7fed: LstNN := Vrem+' > "�������� ���������� �� ��-���"'        + #13#10+ LstNN;
      $7fee: LstNN := Vrem+' > "��������� ��������� � ������"'         + #13#10+ LstNN;
      $7fef: LstNN := Vrem+' > "�������� ��������� � ������"'          + #13#10+ LstNN;
      $7ff0: LstNN := Vrem+' > "�������� ����� ����� � ������"'        + #13#10+ LstNN;
      $7ff1: LstNN := Vrem+' > "������� ����� ����� � ������"'         + #13#10+ LstNN;
      $7ff2: LstNN := Vrem+' > "��������� ��������� ��������� �������"'+ #13#10+ LstNN;
      $7ff3: LstNN := Vrem+' > "�������� ��������� ��������� �������"' + #13#10+ LstNN;
      $7ff4: LstNN := Vrem+' > "�������� ����� ����� �����������"'     + #13#10+ LstNN;
      $7ff5: LstNN := Vrem+' > "������� ����� ����� �����������"'      + #13#10+ LstNN;
      $7ff6: LstNN := Vrem+' > "�������� ����� ������"'                + #13#10+ LstNN;
      $7ff7: LstNN := Vrem+' > "������� ����� ������"'                 + #13#10+ LstNN;
      $7ff8: LstNN := Vrem+' > "������� ���������� ����� ����������"'  + #13#10+ LstNN;
      $7ff9: LstNN := Vrem+' > "������� ���������� ����� ����������"'  + #13#10+ LstNN;
      $7ffa: LstNN := Vrem+' > "���������� ������ �� ���"'             + #13#10+ LstNN;
      $7ffb: LstNN := Vrem+' > "������ ������ �� ���"'                 + #13#10+ LstNN;
      $7ffc: LstNN := Vrem+' > "��������� ��"'                         + #13#10+ LstNN;
      $7ffd: LstNN := Vrem+' > "����� ������� ��"'                     + #13#10+ LstNN;
      $7ffe: LstNN := Vrem+' > "����� �� �����"'                       + #13#10+ LstNN;
      $7fff: LstNN := Vrem+' > "���������� ���������"'                 + #13#10+ LstNN;
    end;
  end else
  if ifr >= $4000 then
  begin //------------------------------------------------------------- ���������� �������
    obj := ifr and $0fff;
    Ima := ObjZv[obj].Liter;
    case cmd of
      M_StrPerevodPlus          : smn := '������� � ���� ������� '           + Ima;
      M_StrPerevodMinus         : smn := '������� � ����� ������� '          + Ima;
      M_StrVPerevodPlus         : smn := '�����.������� � ���� ������� '     + Ima;
      M_StrVPerevodMinus        : smn := '�����.������� � ����� ������� '    + Ima;
      M_StrOtklUpravlenie       : smn := '���������� �� ���������� ������� ' + Ima;
      M_StrVklUpravlenie        : smn := '��������� ���������� ������� '     + Ima;
      M_StrZakrytDvizenie       : smn := '������� �������� �� ������� '      + Ima;
      M_StrOtkrytDvizenie       : smn := '������� �������� �� ������� '      + Ima;
      M_UstMaketStrelki         : smn := '���������� ����� �� ������� '      + Ima;
      M_SnatMaketStrelki        : smn := '���� ����� �� ������� '            + Ima;
      M_StrMPerevodPlus         : smn := '�������� ������� � ���� ������� '  + Ima;
      M_StrMPerevodMinus        : smn := '�������� ������� � ����� ������� ' + Ima;
      M_StrZakryt2Dvizenie      : smn := '������� �������� �� ������� '      + Ima;
      M_StrOtkryt2Dvizenie      : smn := '������� �������� �� ������� '      + Ima;
      M_StrZakrytProtDvizenie   : smn := '������� �� �������� �� ������� '   + Ima;
      M_StrOtkrytProtDvizenie   : smn := '������� �� �������� �� ������� '   + Ima;
      CmdMarsh_Tracert          : smn := '����������� �������� ����� '       + Ima;
      CmdMarsh_Ready            : smn := '������ �������������� '            + Ima;
      CmdMarsh_Manevr           : smn := '���������� ���������� ������� {'   + Ima+'}';
      CmdMarsh_Poezd            : smn := '���������� �������� ������� {'     + Ima+'}';
      CmdMarsh_Povtor           : smn := '������ �������� '                  + Ima;
      CmdMarsh_Razdel           : smn := '������� '                          + Ima;
      CmdMarsh_RdyRazdMan       : smn := '������� ���������� '               + Ima;
      CmdMarsh_RdyRazdPzd       : smn := '������� �������� '                 + Ima;
      CmdManevry_ReadyWar       : smn := '�������� �������������� '          + Ima;
      CmdMarsh_ResetTraceParams : smn := '������������ '                     + Ima;
      CmdMarsh_PovtorMarh       : smn := '������ �������� �� '               + Ima;
      CmdMarsh_PovtorOtkryt     : smn := '��������� �������� '               + Ima;
      CmdStr_ReadyPerevodPlus   : smn := '������� � ���� ������� '           + Ima;
      CmdStr_ReadyPerevodMinus  : smn := '������� � ����� ������� '          + Ima;
      CmdStr_ReadyVPerevodPlus  : smn := '�����. ������� ������� � ����'     + Ima;
      CmdStr_ReadyVPerevodMinus : smn := '�����. ������� ������� � �����'    + Ima;
      CmdStr_ReadyMPerevodPlus  : smn := '������� �� ������ � ���� ������� '+ Ima;
      CmdStr_ReadyMPerevodMinus : smn := '������� �� ������ � ����� ������� '+ Ima;
      CmdStr_AskPerevod         : smn := '����� ������� '                    + Ima;
      else  smn := '������������ ������� '+ IntToStr(cmd)+ ' �� ������ '+ IntToStr(Obj);
    end;
    LstNN := Vrem + ' < '+ smn+ #13#10+ LstNN;
    NewNeisprav := true;
  end else
  begin //--------------------------------------------------------------------- ������� ��
    smn := Vrem + ' < ������ ������� �� ';
    LstNN := smn + IntToStr(cmd)+ ' �� ������ ['+ IntToStr(ifr)+ ']'+ #13#10 + LstNN;
    NewNeisprav := true;
  end;
end;
{$ENDIF}
end.
