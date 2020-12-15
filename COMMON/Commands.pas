unit Commands;
{$INCLUDE d:\Sapr2012\CfgProject}
//========================================================================================
//--------------------------------------------------------------------  Команды управления
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
 //----------------------------------------------------- Список вторичных команд управления
  CmdMarsh_Tracert          = 1101;
  CmdMarsh_Ready            = 1102;
  CmdMarsh_Manevr           = 1103;
  CmdMarsh_Poezd            = 1104;
  CmdMarsh_Povtor           = 1105;
  CmdMarsh_Razdel           = 1106;
  CmdMarsh_RdyRazdMan       = 1107;
  CmdMarsh_RdyRazdPzd       = 1108;
  CmdManevry_ReadyWar       = 1109;
  CmdMarsh_ResetTraceParams = 1110; //------------------------ нормализация объекта трассы
  CmdMarsh_PovtorMarh       = 1111;
  CmdMarsh_PovtorOtkryt     = 1112;
  //------------------------------------------------------------------ КОМАНДЫ ДЛЯ СТРЕЛОК
  CmdStr_ReadyPerevodPlus   = 1201;
  CmdStr_ReadyPerevodMinus  = 1202;
  CmdStr_ReadyVPerevodPlus  = 1203;
  CmdStr_ReadyVPerevodMinus = 1204;
  CmdStr_ReadyMPerevodPlus  = 1205;
  CmdStr_ReadyMPerevodMinus = 1206;
  CmdStr_AskPerevod         = 1207;
  CmdStr_ResetMaket         = 1208;

//==================== СПИСОК КОДОВ КОМАНД ДЛЯ ПЕРЕДАЧИ В STAN (FR3-команды) =============
cmdfr3_ispiskrazmyk        = 1; //-исполнительная команда искусственного размыкания секции
cmdfr3_isprazmykstr        = 2; //-------------- исполнительная команда размыкания стрелок
cmdfr3_isppereezdotkr      = 3; //--------------- исполнительная команда открытия переезда
cmdfr3_IspolVklZapMont     = 4; //------ исполнительная команда включения запрета монтерам
cmdfr3_IspolOtklZapMont    = 5; //----- исполнительная команда отключения запрета монтерам
cmdfr3_ispukspsotkl        = 6; //---------------- исполнительная команда отключения УКСПС
cmdfr3_ispvspotpr          = 7; //---- исполнительная команда вспомогательного отправления
cmdfr3_ispvsppriem         = 8; //--------- исполнительная команда вспомогательного приема
cmdfr3_ispmanevryri        = 9;//исполнительная команда искусственного размыкания маневров
cmdfr3_isppabiskpribytie   = 10; // исполнительная команда искусственного прибытия для ПАБ
cmdfr3_ispolpereezdzakr    = 11; //-------------- исполнительная команда закрытия переезда
cmdfr3_ispolOtklUkg        = 12; //- исполнительная команда отключения УКГ из зависимостей
cmdfr3_ispolOtkl3bit       = 13; //- исполнительная команда отключения УКГ из зависимостей
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------------- 14 - 29 резерв
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cmdfr3_pereezdotklizv1     = 30; //---- команда отключения извещения на переезд (без ДОТа)
//-------------------------------------------------------------------- КОМАНДЫ ДЛЯ СТРЕЛОК
cmdfr3_otklupr             = 31; //------------------------ отключить объект от управления
cmdfr3_vklupr              = 32;//--------------------------- включить управление объектом
cmdfr3_blokirov            = 33; //-------------------------------------- закрыть движение
cmdfr3_razblokir           = 34;
cmdfr3_blokirov2           = 35;
cmdfr3_razblokir2          = 36;
cmdfr3_ustmaket            = 37;
cmdfr3_snatmaket           = 38;
cmdfr3_strplus             = 41;
cmdfr3_strminus            = 42;
cmdfr3_strvspplus          = 43;
cmdfr3_strvspminus         = 44;
//------------------------------------------------------------------- КОМАНДЫ ДЛЯ СИГНАЛОВ
cmdfr3_svotkrmanevr        = 45;
cmdfr3_svotkrpoezd         = 46;
cmdfr3_svzakrmanevr        = 47;
cmdfr3_svzakrpoezd         = 48;
cmdfr3_svpovtormanevr      = 49;
cmdfr3_svpovtorpoezd       = 50;
cmdfr3_svustlogic          = 51;
cmdfr3_svotmenlogic        = 52;
cmdfr3_putustograd         = 53;
cmdfr3_logoff              = 54; //------------ штатное завершение работы программы РМ-ДСП
cmdfr3_zamykstr            = 55;
cmdfr3_pereezdzakryt       = 56;
cmdfr3_pereezdvklizv       = 57;
cmdfr3_pereezdotklizv      = 58;
cmdfr3_opovvkl             = 59; //----------------------------------- включить оповещение
cmdfr3_VklZapMont          = 60; //------------------------------ включить запрет монтерам
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
//-------------------------------------------------------------------- КОМАНДЫ ДЛЯ СТРЕЛОК
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
cmdfr3_datrazreshotpr       = 126; //------ дать разрешение отправления на перегон (с КОК)
cmdfr3_snatrazreshotpr      = 127; //----------- снять разрешение отправления на перегон )
cmdfr3_otmenaOtklUkg        = 128; //------------------------------- отмена отключения УКГ
cmdfr3_NAS_Vkl              = 129; //---------------------- включить нечетное автодействие
cmdfr3_NAS_Otkl             = 130; //--------------------- отключить нечетное автодействие
cmdfr3_CHAS_Vkl             = 131; //------------------------ включить четное автодействие
cmdfr3_CHAS_Otkl            = 132; //----------------------- отключить четное автодействие
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------- 133 - 186 резерв
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cmdfr3_ustanovkastrelok     = 187; //------------------------- установка стрелок по трассе
cmdfr3_povtormarhmanevr     = 188; //------------ повторить установку маневрового маршрута
cmdfr3_povtormarhpoezd      = 189; //-------------- повторить установку поездного маршрута
cmdfr3_marshrutlogic        = 190; //---------------------- установка логического маршрута
cmdfr3_marshrutmanevr       = 191; //-------------- открытие маневровых сигналов по трассе
cmdfr3_marshrutpoezd        = 192; //---------------- открытие поездных сигналов по трассе
cmdfr3_predviskrazmyk       = 193; //----- предв. команда искусственного размыкания СП(УП)
cmdfr3_predvrazmykstr       = 194; //---- предварительная команда отмены замыкания стрелок
cmdfr3_predvpereezdotkr     = 195; //----------- предварительная команда открытия переезда
cmdfr3_predvOtklUkg         = 196; //-------------- предварительная команда отключения УКГ
cmdfr3_PredvOtklZapMont     = 197; //- предварительная команда отключения запрета монтерам
cmdfr3_predvukspsotkl       = 198; //----- предв. команда исключения УКСПС из зависимостей
cmdfr3_predvvspotpr         = 199; //--------- предв. команда вспомогательного отправления
cmdfr3_predvvsppriem        = 200; //-------------- предв. команда вспомогательного приема
cmdfr3_predvmanevryri       = 201; // предварительная команда искусст. размыкания маневров
cmdfr3_predvpabiskpribytie  = 202; //- предварительная команда искусственного прибытия ПАБ
cmdfr3_predvpereezdzakr     = 203; //----------- предварительная команда закрытия переезда
cmdfr3_predvotkl3bit        = 204; //--- предварительная команда отключения объекта бита 3
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------- 205 - 223 резерв
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
//---- Выполнить команду изменения режима работы и других напрямую набираемых с клавиатуры
//----------------------------------- mode - код команды для изменения режимов работы АРМа
function Cmd_ChangeMode(mode : integer) : boolean;
begin
  case mode of  //-------------------------------------- переключатель по значению команды

    KeyMenu_RazdeRejim ://------------------------------------------ Раздельное управление
    begin
      ResetTrace; //--------------------------------------------- Сбросить набраную трассу
      WorkMode.GoMaketSt := false; //------------- убрать режим установки стрелки на макет
      WorkMode.RazdUpr := true; WorkMode.MarhUpr := false;// раздельное - да, маршр. - нет
      WorkMode.MarhOtm := false;   //------------------------ убрать режим отмены маршрута
      WorkMode.VspStr  := false;   //------ убрать режим вспомогательного перевода стрелок
      WorkMode.InpOgr  := false; //------------------- убрать режим работы с ограничениями
      InsNewArmCmd($7ff9,0); //------------------ запомнить в архиве
      result := true;
    end;

    KeyMenu_MarshRejim : //----------------------------------------- Маршрутное управление
    begin
      ResetTrace; //--------------------------------------------- Сбросить набраную трассу
      WorkMode.GoMaketSt := false;
      WorkMode.RazdUpr := false;
      WorkMode.MarhUpr := true;
      WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := false;
      InsNewArmCmd($7ff8,0);
      result := true;
    end;

    KeyMenu_OtmenMarsh ://-------------------- Включение/выключение режима отмены маршрута
    begin
      ResetTrace; // Сбросить набраную трассу
      WorkMode.GoMaketSt := false;
      WorkMode.MarhOtm := not WorkMode.MarhOtm;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := false;
      if WorkMode.MarhOtm then //----------------------- если АРМ в режиме отмены маршрута
      begin
        InsNewArmCmd($7ff7,0);
        InsArcNewMsg(0,93,7);
        ShowShortMsg(93,LastX,LastY,'');//-------------------- "укажите объект для отмены"
      end
      else  InsNewArmCmd($7ff6,0);
      result := true;
    end;

    KeyMenu_InputOgr :
    begin //-------------------------------- Включение/выключение режима ввода ограничений
      ResetTrace; //--------------------------------------------- Сбросить набраную трассу
      WorkMode.GoMaketSt := false;
      WorkMode.MarhOtm := false;
      WorkMode.VspStr  := false;
      WorkMode.InpOgr  := not WorkMode.InpOgr;
      if WorkMode.InpOgr then
      begin
        InsNewArmCmd($7ff5,0); InsArcNewMsg(0,94,7);
        ShowShortMsg(94,LastX,LastY,''); //---------------- укажите объект для ограничений
      end else
        InsNewArmCmd($7ff4,0);
      result := true;
    end;

    KeyMenu_VspPerStrel :
    begin //---------------- Включение/выключение режима вспомогательного перевода стрелок
      ResetTrace; //--------------------------------------------- Сбросить набраную трассу
      WorkMode.GoMaketSt := false;
   //   WorkMode.RazdUpr := true;
  //    WorkMode.MarhUpr := false;
      WorkMode.MarhOtm := false;
      WorkMode.InpOgr  := false;
      WorkMode.VspStr  := not WorkMode.VspStr;
      if WorkMode.VspStr then
      begin
        InsArcNewMsg(0,88,7);
        ShowShortMsg(88,LastX,LastY,''); //----------------- "укажите стрелку для перевода
      end else
      begin
        InsArcNewMsg(0,95,7); //------ "установлен режим раздельного управления сигналами"
        ShowShortMsg(95,LastX,LastY,'');
        VspPerevod.Active := false;
      end;
      result := true;
    end;

    KeyMenu_EndTrace :
    begin //-------------------------------------------------------- Конец набора маршрута
      WorkMode.GoMaketSt := false;
      if MarhTracert[1].MsgCount > 1 then //------------ если есть несколько враждебностей
      begin
        dec(MarhTracert[1].MsgCount);
        CreateDspMenu(KeyMenu_ReadyResetTrace,LastX,LastY);
        DspMenu.WC := true;
        result := true;
      end else
      if MarhTracert[1].MsgCount = 1 then
      begin  ResetTrace;result:=true; end // Если осталась одна враждебность- сброс набора
      else
      //------------------------------------------------------------- Вывод предупреждений
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
        else CreateDspMenu(CmdMarsh_Ready,LastX,LastY);//1102 подтверди установку маршрута
        result := true;
      end else
      if WorkMode.MarhUpr and WorkMode.GoTracert then
      begin //---------------------- Выполнить трассировку маршрута и сформировать команду
        if EndTracertMarshrut then //если найден элемент завершения набора трассы иаршрута
        begin //----------------------------------- Сформировать запрос установки маршрута
          if MarhTracert[1].WarCount > 0 then //----------------- если есть предупреждения
          begin //--------------------------------------------------- Вывод предупреждений
            SingleBeep := true;
            TimeLockCmdDsp := LastTime;
            LockCommandDsp := true;
            ShowWarning := true;
            // KeyMenu_ReadyWarningTrace 1013 (Ожидание подтверждения сообщений по трассе)
            CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
          end
          //----------------------- CmdMarsh_Ready 1102 (Подтверждение установки маршрута)
          else CreateDspMenu(CmdMarsh_Ready,LastX,LastY); //------ если нет предупреждений
        end
         //------ Иначе выдать предупреждение, что конечная точка маршрута указана неверно
        else CreateDspMenu(KeyMenu_EndTraceError,LastX,LastY);
        result := true;
      end
      //------------------- если не марш.управление или не трассировка, то сброс сообщений
      else begin ResetShortMsg; result := false; end;
    end;

    KeyMenu_PodsvetkaStrelok :
    begin //-------------------------------------- 1021 Кнопка подсветки положения стрелок
      WorkMode.GoMaketSt := false;
      WorkMode.Podsvet := not WorkMode.Podsvet;
      if WorkMode.Podsvet then InsNewArmCmd($7ff3,0)
      else InsNewArmCmd($7ff2,0);
      result := true;
    end;

    KeyMenu_VvodNomeraPoezda :
    begin //---------------------------------------------- 1022 Кнопка ввода номера поезда
      WorkMode.GoMaketSt := false;
      WorkMode.InpTrain := not WorkMode.InpTrain;
      if WorkMode.InpTrain then InsNewArmCmd($7ff1,0)
      else InsNewArmCmd($7ff0,0);
      result := true;
    end;

    KeyMenu_PodsvetkaNomerov : begin //-------------- 1023 Кнопка подсветки номера поездов
      WorkMode.GoMaketSt := false;
      WorkMode.NumTrain := not WorkMode.NumTrain;
      if WorkMode.NumTrain then InsNewArmCmd($7fef,0)
      else InsNewArmCmd($7fee,0);
      result := true;
    end;

    else  result := false; //-------------------------- если нет команд управления режимом 
  end;
end;
{$ENDIF}

//========================================================================================
//----------------------------------------------------------- Выполнить команду управления
function SelectCommand : boolean;
var
  i,o,p,ObjMaket,Strelka,XStr : integer;
  obj_for_kom : integer;
  TXT : string;
  ComServ : Byte;
  ObjServ : Word;
begin
  //-------------------------------------------------------- сброс активности меню/запроса
  DspMenu.Ready := false;
  DspMenu.WC := false;
  DspMenu.obj := -1;
  //ShowWarning := false;
{$IFDEF RMDSP}
//-------------------------------------------------------- сохранить выбор команды в архив
  if (DspCommand.obj > 0) and (DspCommand.Command > 0) then
  InsNewArmCmd(DspCommand.obj+$4000,DspCommand.Command);

  //---------------------------------- Отработка команд в режиме резервного рабочего места
  if DspCommand.Active then
  begin
    case DspCommand.Command of
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //---------- Команды выбора режима работы РМ-ДСП, команд прямого набора с клавиатуры
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
      end; //--- изменить режим
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_Osnovnoy ://------------------------------- Запрос на изменение статуса АРМа
      begin
        ComServ := cmdfr3_directmanual;
        ObjServ := WorkMode.DirectStateSoob;
        //------------------------------------ для проверки   WorkMode.Upravlenie := true;
        InsNewArmCmd($7fed,0);
        SendCommandToSrv(ObjServ,ComServ,0);
        result := true;
        exit;
      end;
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RU1 ://включить 1-ый РУ.Проверить допутимость изменения режима работы РМ-ДСП
      begin
        InsNewArmCmd($7fec,0);
        config.ru := 1; SetParamTablo;
        result := true;
        exit;
      end;
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RU2 ://включить 2-ой РУ.Проверить допутимость изменения режима работы РМ-ДСП
      begin
        InsNewArmCmd($7feb,0);
        config.ru := 2; SetParamTablo; result := true; exit;
      end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_ResetCommandBuffers : //---------------------------- сброс буферов команд ТУ
      begin
        InsNewArmCmd($7fea,0);
        CmdCnt := 0;   //-------------------------------- сброс счетчика раздельных команд
        WorkMode.MarhRdy := false; //----------------- сброс готовности маршрутной команды
        WorkMode.CmdReady := false; //--------------- сброс ожидания подтверждения команды
        result := true;
        exit;
      end;
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RestartServera : //-------------------------------------- перезапуск сервера
      begin
        CreateDspMenu(KeyMenu_ReadyRestartServera,LastX,LastY);
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_RezervARM ://----------------------------------------- Перевод АРМа в резерв
      begin
        InsNewArmCmd($7fe9,0);
        if WorkMode.Upravlenie then //------------ если ранее АРМ был назначен управляющим
        begin
          //-------------- если нет управления от УВК (Режим АУ) или нет данных от сервера
          if ((StateRU and $40) = 0) or WorkMode.BU[0] then
          begin
            WorkMode.Upravlenie := false;
            StDirect := false;
            ChDirect := true;
          end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRestartServera : //---- 1017 Ожидание подтверждения перезапуска сервера
      begin
        ComServ := cmdfr3_restartservera;
        ObjServ := WorkMode.ServerStateSoob;
        if SendCommandToSrv(ObjServ,ComServ,0) then
        begin
          IncrementKOK;
          InsArcNewMsg(0,$2000+349,7);   //---------- "Выдана команда перезапуска сервера"
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
          InsArcNewMsg(DspCommand.Obj,$2000+350,7);//---- "Выдана команда переключения ИК"
          msg := GetShortMsg(1,350,ObjZav[DspCommand.Obj].Liter,7);
          ShowShortMsg(350,LastX,LastY,''); 
          AddFixMessage(msg,4,2);
        end;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_RescueOTU :  //------------------------------ 189 Восстановить интерфейс ОТУ
      begin
        IndexFR3IK := DspCommand.Obj;
        //KeyMenu_ReadyRescueOTU=1024 ждать подтверждения восстановления интерфейса ОТУУВК
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
        //------------------------ код команды для передачи в сервер cmdfr3_rescueotu  125
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
      begin //-------------------------- Сброс набираемого маршрута, очистка буфера команд
        if CmdCnt > 0 then
        AddFixMessage(GetShortMsg(1,296,GetNameObjZav(CmdBuff.LastObj),1),7,2);
        CmdCnt := 0;                  // сброс раздельных команд и ограничений
        WorkMode.MarhRdy := false; // сброс маршрутной команды
        WorkMode.CmdReady := false;   // сброс блокировки ТУ по неприему квитанции
        ResetCommands;
        result := true;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_DateTime :
      begin //-------------------------------------------------------- Ввод времени РМ-ДСП
        ResetTrace; // Сбросить набраную трассу
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
              InsArcNewMsg(0,435,1); //----- Коррекция времени с 22:55 до 01:05 запрещена!
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
      begin //-------------------------------------------------- Сброс фиксируемого звонка
        InsNewArmCmd($7fe8,0);
        sound := false; result := true; exit;
      end;
    end;
  end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------- Проверка допустимости формирования команд
  if not WorkMode.GoTracert then
  begin
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin
      InsNewArmCmd($7fff,0);
      ShowShortMsg(76,LastX,LastY,'');  //--------------------------- управление отключено
      result := false;
      exit;
    end;
    if CmdCnt > 0 then
    begin //------------- буфер команд заполнен - блокировка команд до освобождения буфера
      InsNewArmCmd($7ffe,0);
      ShowShortMsg(251,LastX,LastY,'');
      result := false;
      exit;
    end;
  end;

  if DspCommand.Active then
  begin
    case DspCommand.Command of
    //----------------------------------------------------------------- Команды на объекты
    //---------------------------------------------------------------------------- стрелки
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
      begin // Запрос перевода стрелки
        CreateDspMenu(CmdStr_AskPerevod,LastX,LastY);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyPerevodPlus :
      begin
        ComServ := cmdfr3_strplus;
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;

        if WorkMode.VspStr then //------------------- если вспомогательный перевод стрелки
        begin
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end
        else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then //-- если занятость из СП
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end
        else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and // если надо проверять МСП и
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then //........ идет выдержка МСП
        begin//ожидается завершение выдержки времени дополнительного замыкания (МСП, МСПД)
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
        begin //------------------------------------------ вспомогательный перевод стрелки
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin //----------------------------------------------------------- Стрелка занята
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin //ожидается завершение выдержки времени дополнительного замыкания (МСП,МСПД)
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
//---------------------- этап выдачи команды в STAN  для перевода в плюс стрелки на макете
      CmdStr_ReadyMPerevodPlus :
      begin
        Strelka := DspCommand.Obj;
        XStr :=  ObjZav[Strelka].BaseObject;
        ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
        ComServ := cmdfr3_strmakplus;
        ObjZav[XStr].iParam[5] := cmdfr3_strmakplus; //---------------- запоминаем команду
        ObjZav[XStr].iParam[4] := 0; //----------------------------- сбрасываем исполнение
        ObjZav[XStr].Timers[3].First := LastTime + 5/80000;//-------------- время проверки
        ObjZav[XStr].Timers[3].Active := true; //--------------------- активизируем таймер
        if WorkMode.VspStr then
        begin //------------------------------------------ вспомогательный перевод стрелки
          VspPerevod.Cmd := CmdStr_ReadyVPerevodPlus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin //----------------------------------------------------------- Стрелка занята
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin //ожидается завершение выдержки времени дополнительного замыкания (МСП,МСПД)
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
//--------------------- этап выдачи команды в STAN  для перевода в минус стрелки на макете
      CmdStr_ReadyMPerevodMinus :
      begin
        Strelka := DspCommand.Obj;
        XStr := ObjZav[Strelka].BaseObject;
        ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
        ComServ := cmdfr3_strmakminus;
        ObjZav[XStr].iParam[5] := cmdfr3_strmakminus; //--------------- запоминаем команду
        ObjZav[XStr].iParam[4] := 0; //----------------------------- сбрасываем исполнение
        ObjZav[XStr].Timers[3].First := LastTime + 5/80000; //------------- время проверки
        ObjZav[XStr].Timers[3].Active := true;

        if WorkMode.VspStr then
        begin //------------------------------------------ вспомогательный перевод стрелки
          VspPerevod.Cmd := CmdStr_ReadyVPerevodMinus;
          VspPerevod.Strelka := DspCommand.Obj;
          VspPerevod.Reper := LastTime + 20/80000;
          VspPerevod.Active := true;
        end else
        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[22] then
        begin //----------------------------------------------------------- Стрелка занята
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,150+$4000,1);
          ShowShortMsg(150,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[3] and
        not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[20] then
        begin // ожидается завершение выдержки времени дополнительного замыкания(МСП,МСПД)
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
        begin //---------------------------------------- на макете вспомогательный перевод
          ComServ := cmdfr3_strvspmakplus;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := true;
            ObjZav[DspCommand.Obj].bParam[23] := false;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,14,2);
            ShowShortMsg(14, LastX, LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end else
        begin // вспомогательный перевод
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
        begin //---------------------------------------- на макете вспомогательный перевод
          ComServ := cmdfr3_strvspmakminus;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            ObjZav[DspCommand.Obj].bParam[22] := false;
            ObjZav[DspCommand.Obj].bParam[23] := true;
            InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,15,7);
            ShowShortMsg(15,LastX,LastY, ObjZav[ObjZav[DspCommand.Obj].BaseObject].Liter);
          end;
        end else
        begin //-------------------------------------------------- вспомогательный перевод
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
        WorkMode.InpOgr := false; // Сбросить режим ввода ограничений
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
        WorkMode.InpOgr := false; //--------------------- Сбросить режим ввода ограничений
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
        WorkMode.InpOgr := false; //--------------------- Сбросить режим ввода ограничений
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        ObjZav[DspCommand.Obj].bParam[16] := true;

        if ObjZav[DspCommand.Obj].ObjConstB[6] then ComServ := cmdfr3_blokirov2 // дальняя
        else  ComServ := cmdfr3_blokirov;//--------------------------------------- ближняя

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,18,7);
          ShowShortMsg(18, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrOtkrytDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- Сбросить режим ввода ограничений
        ObjZav[DspCommand.Obj].bParam[16] := false;
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;

        if ObjZav[DspCommand.Obj].ObjConstB[6] then ComServ := cmdfr3_razblokir2 //дальняя
        else ComServ := cmdfr3_razblokir;//--------------------------------------- ближняя

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,452,2);
          ShowShortMsg(452, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrZakrytProtDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- Сбросить режим ввода ограничений
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        ObjZav[DspCommand.Obj].bParam[17] := true;

        if ObjZav[DspCommand.Obj].ObjConstB[6] then
        ComServ := cmdfr3_strzakryt2protivosh //---------------------------------- дальняя
        else ComServ := cmdfr3_strzakrytprotivosh; //----------------------------- ближняя

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,451,7);
          ShowShortMsg(451, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_StrOtkrytProtDvizenie :
      begin
        WorkMode.InpOgr := false; //--------------------- Сбросить режим ввода ограничений
        ObjZav[DspCommand.Obj].bParam[17] := false;
        ObjServ := ObjZav[ObjZav[DspCommand.Obj].BaseObject].ObjConstI[2] div 8;
        if ObjZav[DspCommand.Obj].ObjConstB[6]
        then ComServ := cmdfr3_strotkryt2protivosh //----------------------------- дальняя
        else ComServ := cmdfr3_strotkrytprotivosh; //----------------------------- ближняя

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(ObjZav[DspCommand.Obj].BaseObject,19,2);
          ShowShortMsg(19, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_UstMaketStrelki :
      begin //------------------------------------------------ Постановка стрелки на макет
        Strelka := DspCommand.Obj;
        XStr := ObjZav[Strelka].BaseObject;
        WorkMode.InpOgr := false; //--------------------- Сбросить режим ввода ограничений
        WorkMode.GoMaketSt := false;
        for i := 1 to High(ObjZav) do
        begin  //------------------------------------ Проверка подключения макетного шнура
          if (ObjZav[i].RU = config.ru) and (ObjZav[i].TypeObj = 20) then
          begin
            if ObjZav[i].bParam[2] then
            begin //---------------------------------------------------- Установка стрелки
              if not ObjZav[Strelka].bParam[1] and //------- если стрелка не в плюсе и ...
              not ObjZav[Strelka].bParam[2] then   //------------------------- не в минусе
              begin //-------------------------------------------------- Установка стрелки
                ObjZav[XStr].iParam[4] := 1; //------ признак начала установки неясно куда
                ObjZav[XStr].iParam[5] := 0; //--------- ожидаемый результат пока сбросить

                maket_strelki_index := XStr;
                maket_strelki_name  := ObjZav[XStr].Liter;

                ObjZav[XStr].bParam[19] := true;
                ObjZav[XStr].bParam[15] := true;
                ObjServ := ObjZav[XStr].ObjConstI[2] div 8;
                ComServ := cmdfr3_ustmaket;
                if SendCommandToSrv(ObjServ,ComServ,XStr) then
                begin
                  InsArcNewMsg(XStr,10,7);//--------------- Стрелка $ установлена на макет
                  ShowShortMsg(10, LastX, LastY, ObjZav[XStr].Liter);
                end;
              end else
              begin //-------------- Есть контроль положения - отказ от установки на макет
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
      begin //----------------------------------------------------- Снять стрелку с макета
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
          ObjZav[Xstr].iParam[4] := 0; //--------------- сбросить признак начала установки
          ObjZav[Xstr].iParam[5] := 0; //-------------------- ожидаемый результат сбросить
          ObjZav[Xstr].Timers[3].First := 0; //-------------------- сбросить таймер макета
          ObjZav[Xstr].Timers[3].Active := false; //------------------ сбросить активность
          fr4[Xstr] := fr4[Xstr] and $fd;
          ObjMaket := ObjZav[Strelka].VBufferIndex;
          OVBuffer[ObjMaket].Param[31] := false;
          maket_strelki_index := 0;
          maket_strelki_name  := '';
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ResetMaket :
      begin //----------------------------- Сбросить макет стрелки в случае развала макета
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
//------------------------------------------------------------------------------ светофоры
      CmdMarsh_RdyRazdMan :
      begin //------------------------------------- Выдать команду раздельного маневрового
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
      begin //--------------------------------------- Выдать команду раздельного поездного
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
      begin //--------------------------------------------- Запрос раздельного маневрового
        WorkMode.InpOgr := false;
        if OtkrytRazdel(DspCommand.Obj,MarshM,1) then
        CreateDspMenu(CmdMarsh_RdyRazdMan,LastX,LastY);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtkrytProtjag :
      begin // Выдать команду открытия маневрового для протяжки
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
      begin // Запрос раздельного поездного
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
        begin // Выдать команду раздельного открытия сигнала
          if MarhTracert[1].Rod = MarshM then //НМ
          begin CreateDspMenu(CmdMarsh_RdyRazdMan,LastX,LastY); end else
          if MarhTracert[1].Rod = MarshP then //Н
          begin CreateDspMenu(CmdMarsh_RdyRazdPzd,LastX,LastY); end;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaManevrovogo :
      begin
        WorkMode.MarhOtm := false;
        WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCommand.Obj,MarshM); //выдать команду отмены маневрового
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_OtmenaPoezdnogo :
      begin
        WorkMode.MarhOtm := false; WorkMode.InpOgr := false;
        OtmenaMarshruta(DspCommand.Obj,MarshP); // выдать команду отмены поездного
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorManevrovogo :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_svpovtormanevr;
        if PovtorSvetofora(DspCommand.Obj, MarshM,1) then
        begin //----------------------------------------------------------- выдать команду
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
        begin // выдать команду
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
        begin //--------------------------------------- Выдать команду повторного открытия
          if ObjZav[DspCommand.Obj].bParam[6] or ObjZav[DspCommand.Obj].bParam[7] then
          begin //--------------------------------------------------------------------- НМ
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
            ComServ := cmdfr3_svpovtormanevr;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,26,7);//Выдана команда повт. открытия маневровым
              ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          if ObjZav[DspCommand.Obj].bParam[8] or ObjZav[DspCommand.Obj].bParam[9] then
          begin //----------------------------------------------------- если есть начало Н
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
            ComServ := cmdfr3_svpovtorpoezd;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,27,2); // Выдана команда повт. открытия поездным
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
        begin //----------------------------------------------------------- выдать команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
          ComServ := cmdfr3_povtorotkrytmanevr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,26,7);// Выдана команда повто. открытия маневровым
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
        begin //----------------------------------------------------------- выдать команду
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
        begin //--------------------------------------- Выдать команду повторного открытия
          if ObjZav[DspCommand.Obj].bParam[6] or ObjZav[DspCommand.Obj].bParam[7] then
          begin //--------------------------------------------------------------------- НМ
            ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
            ComServ := cmdfr3_povtorotkrytmanevr;
            if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
            begin
              InsArcNewMsg(DspCommand.Obj,26,7);
              ShowShortMsg(26, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            end;
          end else
          if ObjZav[DspCommand.Obj].bParam[8] or ObjZav[DspCommand.Obj].bParam[9] then
          begin //---------------------------------------------------------------------- Н
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
        if PovtorMarsh(DspCommand.Obj,MarshM,1) then  SendMarshrutCommand(1);//выдать команду
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_PovtorPoezdMarsh :
      begin
        WorkMode.InpOgr := false;
        if PovtorMarsh(DspCommand.Obj,MarshP,1)
        then SendMarshrutCommand(1);//------------------------------------- выдать команду
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorMarh :
      begin
        if MarhTracert[1].WarCount > 0 then
        begin
          CreateDspMenu(CmdMarsh_PovtorMarh,LastX,LastY);
        end else SendMarshrutCommand(1); // Выдать команду повторной установки маршрута
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
          InsArcNewMsg(DspCommand.Obj,28,7);//-------------- Выдана команда блокирования $
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
          InsArcNewMsg(DspCommand.Obj,29,7); //-------- Выдана команда снятия блокировки $
          ShowShortMsg(29, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_BeginMarshManevr :
      begin //------------------------------------ Начать трассировку маневрового маршрута
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCommand.Obj, DspCommand.Command);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_BeginMarshPoezd :
      begin //-------------------------------------- Начать трассировку поездного маршрута
        WorkMode.InpOgr := false;
        BeginTracertMarshrut(DspCommand.Obj, DspCommand.Command);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------- Выдача команды установки стрелок по введенной трассе
      KeyMenu_QuerySetTrace : SendTraceCommand(1);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Tracert ://-- если продолжать трассировку маршрута,добавить объект в трассу
      begin
        WorkMode.InpOgr := false;  //-------------------- сброс признака ввода ограничений
        if MarhTracert[1].MsgCount > 0 then //------------ если есть сообщения трассировки
        begin
          if MarhTracert[1].GonkaStrel and //-------------- если допустима гонка стрелок и
          (MarhTracert[1].GonkaList > 0) then //-------- в трассе есть переводимые стрелки
           // KeyMenu_QuerySetTrace = 1020 Запрос на установку стрелок по введенной трассе
           CreateDspMenu(KeyMenu_QuerySetTrace,LastX,LastY)//- запрос выдачи команды гонки
          else
          begin //--------------------------------------------------- иначе сбросить набор
            ResetTrace;
            PutShortMsg(1,LastX,LastY,MarhTracert[1].Msg[1]);
          end;
        end else //---------------------------------------- если нет сообщений трассировки
        if (MarhTracert[1].WarCount > 0) and //------------ если есть предупреждения и ...
        ((MarhTracert[1].ObjEnd > 0) or //- определен конец маршрута или готов его "хвост"
        (MarhTracert[1].FullTail)) then
        begin
          dec(MarhTracert[1].WarCount); //--------------- уменьшить счетчик предупреждений
          if MarhTracert[1].WarCount > 0 then //--------- если еще остались предупреждения
          begin
//            SingleBeep := true;
            TimeLockCmdDsp := LastTime;
            LockCommandDsp := true;
            ShowWarning := true;
            //KeyMenu_ReadyWarningTrace = 1013  Ожидание подтверждения сообщений по трассе
            CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
          end
          //если конец предупреждений CmdMarsh_Ready=1102 подтверждение установки маршрута
          else CreateDspMenu(CmdMarsh_Ready,LastX,LastY);
        end
        // если нет предупреждений или не определен конец маршрута, продолжить трассировку
        else AddToTracertMarshrut(DspCommand.Obj);
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Manevr ://------------------- если формировать команду маневрового маршрута
      if SetProgramZamykanie(1,false) then  SendMarshrutCommand(1);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Poezd : //------------------------- Сформировать команду поездного маршрута
      if SetProgramZamykanie(1,false) then SendMarshrutCommand(1);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------------- блокировать надвиг
      CmdMenu_BlokirovkaNadviga :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[13] := true;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[1];
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,28,7); //------------- Выдана команда блокирования $
          ShowShortMsg(28, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------ разблокировать надвиг
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
//------------------------------------------------------ Включение автодействия светофоров
      CmdMenu_AutoMarshVkl :
      begin
        if ObjZav[DspCommand.Obj].ObjConstB[1] then ComServ := cmdfr3_CHAS_Vkl //----- ЧАС
        else ComServ := cmdfr3_NAS_Vkl;

        if AutoMarsh(DspCommand.Obj,true) then
        if SendCommandToSrv(config.avtodst,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,421,2);
          ShowShortMsg(421, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------- Отключение автодействия светофоров
      CmdMenu_AutoMarshOtkl :
      begin
        if ObjZav[DspCommand.Obj].ObjConstB[1] then ComServ := cmdfr3_CHAS_otkl //---- ЧАС
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
      begin //--------------------------------------------- сброс трассировочных признаков
        case ObjZav[DspCommand.Obj].TypeObj of
          2 :   //---------------------------------------------------------------- стрелка
          begin
            ObjZav[DspCommand.Obj].bParam[4]  := false; //-------- сбросить доп. замыкание
            ObjZav[DspCommand.Obj].bParam[6]  := false; //-------------------- сбросить ПУ
            ObjZav[DspCommand.Obj].bParam[7]  := false; //-------------------- сбросить МУ
            ObjZav[DspCommand.Obj].bParam[10] := false; // сбросить 1-й проход трассировки
            ObjZav[DspCommand.Obj].bParam[11] := false; // сбросить 2-й проход трассировки
            ObjZav[DspCommand.Obj].bParam[12] := false;//сброс пошерстная маршрута в плюсе
            ObjZav[DspCommand.Obj].bParam[13] := false;// сброс пошерст. маршрута в минусе
            ObjZav[DspCommand.Obj].bParam[14] := false; //------ сбросить замыкание РМ ДСП
            ObjZav[DspCommand.Obj].iParam[1] := 0; //-------------- сброс индекса маршрута

            o := ObjZav[DspCommand.Obj].BaseObject; //---------------------- хвост стрелки
            ObjZav[o].bParam[4]  := false; //--------------------- сбросить доп. замыкание
            ObjZav[o].bParam[6]  := false; //--------------------------------- сбросить ПУ
            ObjZav[o].bParam[7]  := false; //--------------------------------- сбросить МУ
            ObjZav[o].bParam[14] := false; //----------------------- сбросить замыкание РМ
            ResetShortMsg;
          end;

          3 :   //---------------------------------------------------------------- участок
          begin
            ObjZav[DspCommand.Obj].bParam[14] := false; //--- сброс программного замыкания
            ObjZav[DspCommand.Obj].bParam[15] := false; //---------------------- сброс 1КМ
            ObjZav[DspCommand.Obj].bParam[16] := false; //---------------------- сброс 2КМ
            ObjZav[DspCommand.Obj].iParam[1] := 0; //-------------- сброс индекса маршрута
            ObjZav[DspCommand.Obj].iParam[2] := 0; //--------------- сброс индекса сигнала
            ObjZav[DspCommand.Obj].bParam[8] := true; // сброс предварительной трассировки
            o := DspCommand.Obj;

            ObjServ := ObjZav[o].ObjConstI[2] div 8;
            ComServ := cmdfr3_resettrace;
            if SendCommandToSrv(ObjServ,ComServ,o) then
            begin
              InsArcNewMsg(o,312,7); //--------------------- "выдана команда нормализации"
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);

              for p := 1 to High(ObjZav) do //------------ пройти по всем объектам станции
              case ObjZav[p].TypeObj of
                2 ://------------------------------------------------------------- стрелка
                begin
                  if ObjZav[p].UpdateObject = DspCommand.Obj then //-- связана с данной СП
                  begin //- снять признаки трассировки стрелок, связанных с данной секцией
                    ObjZav[p].bParam[6]  := false; //--------------------------- убрать ПУ
                    ObjZav[p].bParam[7]  := false; //--------------------------- убрать МУ
                    ObjZav[p].bParam[10] := false; //----- сбросить 1-й проход трассировки
                    ObjZav[p].bParam[11] := false; //----- сбросить 2-й проход трассировки
                    ObjZav[p].bParam[12] := false;//---- сброс пошерстная маршрута в плюсе
                    ObjZav[p].bParam[13] := false;//--- сброс пошерстная маршрута в минусе
                    ObjZav[p].bParam[14] := false; //--------- снять программное замыкание
                    ObjZav[p].iParam[1]  := 0;    //--------------- сброс индекса маршрута
                    o := ObjZav[p].BaseObject;    //------------------------ хвост стрелки
                    ObjZav[o].bParam[6]  := false; //--------------------------- убрать ПУ
                    ObjZav[o].bParam[7]  := false; //--------------------------- убрать МУ
                    ObjZav[o].bParam[14] := false; //--------- снять программное замыкание
                  end;
                end;

                41 :
                begin //------------------------------------ контроль маршрута отправления
                  if ObjZav[p].UpdateObject = DspCommand.Obj then
                  begin //------ снять трассировочные признаки, связанных с данной секцией
                    ObjZav[p].bParam[1]  := false;//требование перевода 1-й стрелки в пути
                    ObjZav[p].bParam[2]  := false;//требование перевода 2-й стрелки в пути
                    ObjZav[p].bParam[3]  := false;//требование перевода 3-й стрелки в пути
                    ObjZav[p].bParam[4]  := false;//требование перевода 4-й стрелки в пути
                    ObjZav[p].bParam[8]  := false;//- ожидание перевода 1-й стрелки в пути
                    ObjZav[p].bParam[9]  := false;//- ожидание перевода 2-й стрелки в пути
                    ObjZav[p].bParam[10] := false;//- ожидание перевода 3-й стрелки в пути
                    ObjZav[p].bParam[11] := false;//- ожидание перевода 4-й стрелки в пути
                    ObjZav[p].bParam[20] := false;//снять признак поездного маршрута отпр.
                    ObjZav[p].bParam[21] := false;//--- снять признак трассировки маршрута
                    ObjZav[p].bParam[23] := false;//снять предварит. замыкание 1-й стрелки
                    ObjZav[p].bParam[24] := false;//снять предварит. замыкание 2-й стрелки
                    ObjZav[p].bParam[25] := false;//снять предварит. замыкание 3-й стрелки
                    ObjZav[p].bParam[26] := false;//снять предварит. замыкание 4-й стрелки
                  end;
                end;

                42 :
                begin //------------ объект перезамыкания поездного маршрута на маневровый
                  if ObjZav[p].UpdateObject = DspCommand.Obj then //--- объект связан с СП
                  begin //------ снять трассировочные признаки, связанные с данной секцией
                    ObjZav[p].bParam[1]  := false;//----- снять "поездной маршрута приема"
                    ObjZav[p].bParam[2]  := false;//------- снять разрешение перезамыкания
                    ObjZav[p].bParam[3]  := false; //----------- снять замыкание СП в пути
                  end;
                end;
              end;
            end;
          end;

          4 :
          begin //------------------------------------------------------------------- путь
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
              InsArcNewMsg(o,312,7); //--------------------- Выдана команда нормализации $
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);
            end;
          end;

          5 :
          begin //--------------------------------------------------------------- светофор
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
              InsArcNewMsg(o,312,7);  //-------------------- Выдана команда нормализации $
              ShowShortMsg(312, LastX, LastY, ObjZav[o].Liter);
            end;
          end;

          else  result := false;
          exit;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// --------------------------------------------------------------------------------Участки
      CmdMenu_SekciaPredvaritRI :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;

        if ObjZav[DspCommand.Obj].ObjConstB[7]
        then i := ObjZav[DspCommand.Obj].BaseObject //---------------------------- сегмент
        else i := DspCommand.Obj; //----------------------------------------------- секция

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7];
        ComServ := cmdfr3_ispiskrazmyk;

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ);

        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7] div 8;
        ComServ := cmdfr3_predviskrazmyk;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(i,33,7); //- Выдана предварит. команда искусственного размыкания СП
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

        i := ObjZav[DspCommand.Obj].BaseObject //--------------------------------- сегмент
        else i := DspCommand.Obj; //----------------------------------------------- секция

        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //------------- выдать исполнительную команду, сбросить признаки трассировки
          ObjZav[DspCommand.Obj].bParam[14] := false;
          ObjZav[DspCommand.Obj].iParam[1] := 0;
          ObjZav[DspCommand.Obj].bParam[8] := true;

          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[7] div 8;
          ComServ := cmdfr3_ispiskrazmyk;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(i,34,7);//Выдана исполн. команда искусственного размыкания секции
            ShowShortMsg(34, LastX, LastY, ObjZav[i].Liter);
            IncrementKOK;
          end;
        end else
        begin
          InsArcNewMsg(i,155,1); //------ нарушен порядок выполнения ответственной команды
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
          InsArcNewMsg(DspCommand.Obj,36,2);//Выдана команда разрешения движения по секции
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
          InsArcNewMsg(DspCommand.Obj,460,7);//Выдана команда закрытия  для движения на ЭТ
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
          InsArcNewMsg(DspCommand.Obj,461,2); //Выдана команда открытия для движения на ЭТ
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
          InsArcNewMsg(DspCommand.Obj,470,7);//Выдана команда закрытия для движения на ~ЭТ
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
          InsArcNewMsg(DspCommand.Obj,471,2);//Выдана команда открытия для движения на ~ЭТ
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
          InsArcNewMsg(DspCommand.Obj,465,7);//Выдана команда закрытия для движения на =ЭТ
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
          InsArcNewMsg(DspCommand.Obj,466,2);//Выдана команда открытия для движения на =ЭТ
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------------------- Пути
      CmdMenu_PutDatSoglasieOgrady :
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZav[ObjZav[DspCommand.Obj].UpdateObject].ObjConstI[4] div 8;
        ComServ := cmdfr3_putustograd;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,37,7);//---- Выдана команда согласия на ограждение $
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
          InsArcNewMsg(DspCommand.Obj,39,7);//------ Выдана команда закрытия движения по $
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
          InsArcNewMsg(DspCommand.Obj,40,2); //--- Выдана команда разрешения движения по $
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
          InsArcNewMsg(DspCommand.Obj,414,7);//Выдана команда исключения маневров на  путь
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
          InsArcNewMsg(DspCommand.Obj,415,7);//Выдана команда разр.маневров на путь при МУ
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
          InsArcNewMsg(DspCommand.Obj,460,7);// Выдана команда закрытия для движения на ЭТ
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
          InsArcNewMsg(DspCommand.Obj,461,2);// Выдана команда открытия для движения на ЭТ
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
          InsArcNewMsg(DspCommand.Obj,470,7);//Выдана команда закрытия для движения на ~ЭТ
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
          InsArcNewMsg(DspCommand.Obj,471,2);//Выдана команда открытия для движения на ~ЭТ
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
          InsArcNewMsg(DspCommand.Obj,465,7);//Выдана команда закрытия для движения на =ЭТ
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
          InsArcNewMsg(DspCommand.Obj,466,2);//Выдана команда открытия для движения на =ЭТ
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------------------- Замыкание стрелок
      CmdMenu_ZamykanieStrelok :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_zamykstr;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,41,7); //---------------- Выдана команда замыкания $
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

        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ); //------ зарядить исполнительную

        ObjServ := ObjServ div 8;
        ComServ := cmdfr3_predvrazmykstr;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,42,7);//-- Выдана предварительная команда размыкания
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
        begin //-------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[4] div 8;
          ComServ := cmdfr3_isprazmykstr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,43,7);//Выдана исполнительная команда размыкания $
            ShowShortMsg(43, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------------------------------------- включить запрет монтерам
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
          InsArcNewMsg(DspCommand.Obj,51,7);//Выдана команда вкл. запрета монтерам (поезд)
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
          InsArcNewMsg(DspCommand.Obj,529,7); // Выдана пред.команда откл.запрета монтерам
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
        begin //-------------------------------------------- выдать исполнительную команду
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj)
          then
          begin
            InsArcNewMsg(DspCommand.Obj,530,7);//----------- выдана исполнительная команда
            ShowShortMsg(530, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
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
          InsArcNewMsg(DspCommand.Obj,529); //-- Выдана пред.команда откл.запрета монтерам
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
        begin //-------------------------------------------- выдать исполнительную команду
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj)
          then
          begin
            InsArcNewMsg(DspCommand.Obj,530);//------------- выдана исполнительная команда
            ShowShortMsg(530, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
        begin
          InsArcNewMsg(DspCommand.Obj,155);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
      }
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------- Управление переездом
      CmdMenu_ZakrytPereezd :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[12] div 8;
        ComServ := cmdfr3_pereezdzakryt;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,44,7);//-------- Выдана команда закрытия переезда  $
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
          InsArcNewMsg(DspCommand.Obj,45,7);// Выдана предварит. команда открытия переезда
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
        begin //-------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8;
          ComServ := cmdfr3_isppereezdotkr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,46,7);//Выдана исполнит. команда открытия переезда
            ShowShortMsg(46, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_DatIzvecheniePereezd :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8; //--------------------- ПИВ
        ComServ := cmdfr3_pereezdvklizv;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,47,7);//------ Выдана команда извещения на переезд $
          ShowShortMsg(47, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMenu_SnatIzvecheniePereezd,
      CmdMenu_SnatIzvecheniePereezd1 :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[14] div 8; //-------------------- оПИВ
        if DspCommand.Command = CmdMenu_SnatIzvecheniePereezd
        then  ComServ := cmdfr3_pereezdotklizv
        else ComServ := cmdfr3_pereezdotklizv1;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,48,7);//- Выдана команда снятия извещения на переезд
          ShowShortMsg(48, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------------------------------------------------------- Оповещение монтеров
      CmdMenu_DatOpovechenie :
      begin
        WorkMode.InpOgr := false;

        if ObjZav[DspCommand.Obj].TypeObj = 36
        then  ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13] div 8
        else ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
        ComServ := cmdfr3_opovvkl;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,49,7); //------- Выдана команда включения оповещения
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
          InsArcNewMsg(DspCommand.Obj,50,7);//------- Выдана команда отключения оповещения
          ShowShortMsg(50, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------------------------------- УКСПС
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
          InsArcNewMsg(DspCommand.Obj,53,7);//- Выдана предварит. команда отключения УКСПС
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
        begin //-------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
          ComServ := cmdfr3_ispukspsotkl;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,54,7);// Выдана исполнит. команда отключения УКСПС
            ShowShortMsg(54, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
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
          InsArcNewMsg(DspCommand.Obj,354,7);//---- Выдана команда отмены отключения УКСПС
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
          InsArcNewMsg(DspCommand.Obj,566,7);//-- Выдана предварит. команда отключения УКГ
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
        begin //-------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
          ComServ := cmdfr3_ispolOtklUkg;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,567,7);//Выдана исполнител. команда отключения УКГ
            ShowShortMsg(567, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
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
          InsArcNewMsg(DspCommand.Obj,568,7); //----- Выдана команда отмены отключения УКГ
          ShowShortMsg(568, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------------------------------------------------------------------- Перегон
      CmdMenu_SmenaNapravleniya :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
        ComServ := cmdfr3_absmena;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,55,7);//Выдана команда смены направления на перегоне
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
          InsArcNewMsg(DspCommand.Obj,56,7);//Выдана команда согласия на смену направления
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
          InsArcNewMsg(DspCommand.Obj,409,7);//--- Выдана команда подключения комплекта СН
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
          InsArcNewMsg(DspCommand.Obj,410,7); //--- Выдана команда отключения комплекта СН
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
          InsArcNewMsg(DspCommand.Obj,59,7);//Выдана предвар. команда вспомог. отправления
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
        begin //-------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[2] div 8;
          ComServ := cmdfr3_ispvspotpr;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,60,7);//Выдана исполн. команда вспомог.отправления
            ShowShortMsg(60, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
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
          InsArcNewMsg(DspCommand.Obj,61,7);//Выдана предв.команда вспомогательного приема
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
        begin //-------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
          ComServ := cmdfr3_ispvsppriem;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,62,7);//Выдана исполнит. команда вспомогат. приема
            ShowShortMsg(62, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
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
          InsArcNewMsg(DspCommand.Obj,57,7); //---------- Выдана команда закрытия перегона
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
          InsArcNewMsg(DspCommand.Obj,58,2); //--------- Выдана команда открытия перегона
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
          InsArcNewMsg(DspCommand.Obj,438,7); //Выдана команда снятия согласия смены напр.
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
          InsArcNewMsg(DspCommand.Obj,460,7);// Выдана команда закрытия для движения на ЭТ
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
          InsArcNewMsg(DspCommand.Obj,461,2);// Выдана команда открытия для движения на ЭТ
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
          InsArcNewMsg(DspCommand.Obj,470,7);//Выдана команда закрытия для движения на ~ЭТ
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
          InsArcNewMsg(DspCommand.Obj,471,2);//Выдана команда открытия для движения на ~ЭТ
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
          InsArcNewMsg(DspCommand.Obj,465,7);//Выдана команда закрытия для движения на =ЭТ
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
          InsArcNewMsg(DspCommand.Obj,466,2);//Выдана команда открытия для движения на =ЭТ
          ShowShortMsg(466, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------------------------ ПАБ
      CmdMenu_VydatSoglasieOtpravl :
      begin
        WorkMode.InpOgr := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[5] div 8;
        ComServ := cmdfr3_pabsoglasievkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,321,7);//----- Выдана команда согласия отправления $
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
          InsArcNewMsg(DspCommand.Obj,322,7);// Выдана команда отмены согласия отправления
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
          InsArcNewMsg(DspCommand.Obj,323,7);//Выдана предв. команда искус.прибытия поезда
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
        begin //-------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[3] div 8;
          ComServ := cmdfr3_isppabiskpribytie;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,324,7);//Выдана испол. команда иск.прибытия поезда
            ShowShortMsg(324, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
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
          InsArcNewMsg(DspCommand.Obj,325,7);//---------- Выдана команда прибытия поезда $
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
          InsArcNewMsg(DspCommand.Obj,5,7); //-------- Выдана команда закрытия перегона $
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
          InsArcNewMsg(DspCommand.Obj,58,2);//--------- Выдана команда открытия перегона $
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
//---------------------------------------------------------- Блокировка межпостовой увязки
      CmdMenu_ZakrytUvjazki :
      begin
        WorkMode.InpOgr := false;
        ObjZav[DspCommand.Obj].bParam[15] := true;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
        ComServ := cmdfr3_blokirov;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,5,7);//--------- Выдана команда закрытия перегона $
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
          InsArcNewMsg(DspCommand.Obj,58,2);//--------- Выдана команда открытия перегона $
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
//--------------------------------------------------------------------------------- Кнопки
      CmdMenu_VkluchOchistkuStrelok :
      begin
        WorkMode.InpOgr := false;
        case (ObjZav[DspCommand.Obj].ObjConstI[11] -
        (ObjZav[DspCommand.Obj].ObjConstI[11] div 8) * 8) of
          0 : ComServ := cmdfr3_knopka1vkl;  //--------------------- команда в первом бите
          1 : ComServ := cmdfr3_knopka2vkl; //--------------------- команда во втором бите
        else
          result := false;
          exit;
        end;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          if ObjZav[DspCommand.Obj].ObjConstI[4] > 0 then//есть текст запроса на включение
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
      //------------------------ подготовка предварительного отключения бита 3 объекта FR3
      CmdMenu_PredOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        i := DspCommand.Obj; //----------------------------- объекта экранного воздействия
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[13]; // датчик состояния предв.команды
        ComServ := cmdfr3_ispolOtkl3bit; //--------- код исполнительной команды отключения
        GoWaitOtvCommand(DspCommand.Obj,ObjServ,ComServ); //- заполняем структуру ожидания
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8; //определяем объект сервера
        ComServ := cmdfr3_predvOtkl3bit; //------------------- код предварительной командц
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then //послать предварительную
        begin
          InsArcNewMsg(DspCommand.Obj,ObjZav[DspCommand.Obj].ObjConstI[18],7);
          ShowShortMsg(529, LastX, LastY, ObjZav[i].Liter);
        end;
      end;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //------------------------------------------------------- отключение 3-го бита в fr3
      CmdMenu_IspolOtklBit3 :
      begin
        WorkMode.InpOgr := false;
        WorkMode.VspStr := false;
        WorkMode.GoOtvKom := false;
        OtvCommand.Active := false;
        ObjServ := ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_IspolOtkl3bit;
        if not OtvCommand.Ready and (OtvCommand.Obj = DspCommand.Obj) then
        begin //-------------------------------------------- выдать исполнительную команду
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj)
          then
          begin
            InsArcNewMsg(DspCommand.Obj,530,7);//----------- выдана исполнительная команда
            ShowShortMsg(530, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
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
//--------------------------------------------------------------------- Маневровая колонка
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
      begin //---------------------------- ожидание подтверждения предупреждения оператору
        if Marhtracert[1].WarCount > 0 then
        begin //------------------------------------------ вывод следующего предупреждения
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
            InsArcNewMsg(DspCommand.Obj,447,7);//----- Выдана команда остановки маневров $
            ShowShortMsg(447, LastX, LastY, ObjZav[DspCommand.Obj].Liter)
          end else
          begin
            InsArcNewMsg(DspCommand.Obj,69,7);//--------- Выдана команда отмены маневров $
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
          InsArcNewMsg(DspCommand.Obj,70,7);// Выдана предв.команда искус.размык. маневров
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
        begin //------------------------------------------- выдать исполнительную команду
          ObjServ := ObjZav[DspCommand.Obj].ObjConstI[8] div 8;
          ComServ := cmdfr3_ispmanevryri;
          if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
          begin
            InsArcNewMsg(DspCommand.Obj,71,7);// Выдана исп. команда иск. размык. маневров
            ShowShortMsg(71, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
            IncrementKOK;
          end;
        end else //---------------------- нарушен порядок выполнения ответственной команды
        begin
          InsArcNewMsg(DspCommand.Obj,155,1);
          ShowShortMsg(155, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------------------------------------------------ отключение режима ДСН
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
//------------------------------------------------------------------- включение режима ДСН
      CmdMenu_VklDSN:
      begin
        WorkMode.InpOgr := false;
        DspCommand.Obj := ObjZav[DspCommand.Obj].BaseObject;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          InsArcNewMsg(DspCommand.Obj,548,7); //------ Выдана команда включения режима ДСН
          ShowShortMsg(548, LastX, LastY, '');
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- включение бита 1 1-го объекта
      CmdMenu_VklBit1_1:
      begin
        WorkMode.InpOgr := false;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
         InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[7]+$4000,7);//- вопрос на сброс бита
         msg := MsgList[ObjZav[ID_Obj].ObjConstI[7]];
         PutShortMsg(7, LastX, LastY, msg);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//---------------------------------------------------------- включение бита 1 2-го объекта
      CmdMenu_VklBit1_2:
      begin
        WorkMode.InpOgr := false;
        DspCommand.Obj := ObjZav[DspCommand.Obj].BaseObject;
        ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_knopka1vkl;
        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
         InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[6]+$4000,7);//- вопрос на сброс бита
         msg := MsgList[ObjZav[ID_Obj].ObjConstI[6]];
         PutShortMsg(2, LastX, LastY, msg);
        end;
      end;


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------- Переключение режима питания ламп светофоров на дневной
      CmdMenu_VkluchitDen :
      begin
        WorkMode.InpOgr := false;

        if (ObjZav[DspCommand.Obj].TypeObj = 36) and ObjZav[DspCommand.Obj].bParam[1] then
        begin
          InsArcNewMsg(DspCommand.Obj,551,7);//---------------- Эта команда уже выполнена!
          ShowShortMsg(551, LastX, LastY, '');
          exit;
        end;

        if ObjZav[DspCommand.Obj].TypeObj = 92
        then ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[5] div 8
        else ObjServ :=ObjZav[DspCommand.Obj].ObjConstI[11] div 8;
        ComServ := cmdfr3_dnkden;

        if SendCommandToSrv(ObjServ,ComServ,DspCommand.Obj) then
        begin
          AddFixMessage(GetShortMsg(1,72,'',2),0,2);//Выдана команда включ.дневного режима
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
          InsArcNewMsg(DspCommand.Obj,73,7); //--- Выдана команда включения ночного режима
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
          InsArcNewMsg(DspCommand.Obj,74,7);//Выдана команда вкл.автопитан.ламп светофоров
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
          InsArcNewMsg(DspCommand.Obj,479,7);//Выдана ком. откл. автопитан.ламп светофоров
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
          InsArcNewMsg(DspCommand.Obj,75,7);//----- Выдана команда отключения звонка УКСПС
          ShowShortMsg(75, LastX, LastY, ObjZav[DspCommand.Obj].Liter);
        end;
      end;

    else
      ResetShortMsg;
      WorkMode.InpOgr := false; //----------------------- Сбросить режим ввода ограничений
      WorkMode.GoMaketSt := false;
      WorkMode.GoOtvKom := false;
    end;
  end;
{$ENDIF}
  result := true;
end;

{$IFDEF RMDSP}
//========================================================================================
//----------------------------- вычислить новое значение контрольной суммы массива режимов
function WorkModeCalc: smallint;
begin
  {вставить подсчет КС}
  result := 0;
end;

//========================================================================================
//---------------------------- Инициализация ожидания исполнительной ответственной команды
procedure GoWaitOtvCommand(const Obj, BitFR3, CmdSecond : Word);
var
  a,b : boolean;
begin
  OtvCommand.Check  := BitFR3; //--------------- индекс ожидаемого бита выполнения команды
  OtvCommand.State  := GetFR3(BitFR3,a,b); //-------- взять текущее состояние бита команды
  OtvCommand.Cmd    := CmdSecond; //-------------- подготовить значение для второй команды
  OtvCommand.Second := 0; //-------------------------- обнулить в
  OtvCommand.SObj   := 0;
  OtvCommand.Obj    := Obj;
  OtvCommand.Reper  := LastTime + 20 / 80000; //-------------- установить границу ожидания
  OtvCommand.Ready  := true;
  OtvCommand.Active := true;
  WorkMode.GoOtvKom := true;
end;

//------------------------------------------------------------------------------
// Проверка индекса объекта для выдачи исполнительной ответственной команды
function CheckOtvCommand(Obj : SmallInt) : Boolean;
begin
  if OtvCommand.Active then result := OtvCommand.Obj <> Obj
  else result := false;
end;
{$ENDIF}

//========================================================================================
//---------------------------------------------------- Выдать раздельную команду на сервер
//------------------------------- Obj - объект зависимостей, для которого выдается команда
//------------------------------------------------ Cmd - код команды, выдаваемой на объект
//------------------------------------------------------------- Index - объект для команды
function SendCommandToSrv(Obj : Word; Cmd : Byte; Index : Word) : Boolean;
begin
  //----------------------- если счетчик команд пока пустой, и есть объект, и есть команда
  if (CmdCnt < 1) and (Obj > 0) and (Cmd > 0) then
  begin
    CmdSendT := LastTime; //------------------------------- сохранить время выдачи команды
    inc(CmdCnt);          //------------------------------------- увеличить счетчик команд
    CmdBuff.Cmd := Cmd;   //--------------------- внести команду в структуру буфера команд
    CmdBuff.Index := Obj; //---------------------- внести в эту же структуру номер объекта
    CmdBuff.LastObj := Index;
    result := true;
    WorkMode.CmdReady := true;
  end
  else result := false;
end;

{$IFDEF RMDSP}
//------------------------------------------------------------------------------
// Выдать параметр в формате Double на сервер
function SendDoubleToSrv(Param : int64; Cmd : Byte; Index : Word) : Boolean;
  var i : int64;
begin
  if (DoubleCnt < 1) and (Cmd > 0) then
  begin
    CmdSendT := LastTime; // сохранить время выдачи параметра
    inc(DoubleCnt);
    ParamDouble.Cmd := Cmd;
    // распаковать Param на 8 байт
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
//--------------------------------------------------------------- Вывести в список команду
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
        0: LstNN := Vrem +' > Сброс команды <Esc>'+ #13#10+ LstNN;
        $7fe5: LstNN := Vrem +' > "Выход из режима ОК"'+ #13#10+ LstNN;
        $7fe6: LstNN := Vrem+' > "Переход в режим ОК"'+ #13#10+ LstNN;
        $7fe7: LstNN :=Vrem+' > "Длительное нажатие клавиши"'+#13#10+ LstNN;
        $7fe8: LstNN :=Vrem+' > "Сброс фиксируемого звонка"'+ #13#10+ LstNN;
        $7fe9: LstNN := Vrem+' > "Отключение управления на РМ-ДСП"'+ #13#10+ LstNN;
        $7fea: LstNN := Vrem+' > "Сброс буферов команд ТУ"'+ #13#10+ LstNN;
        $7feb: LstNN := Vrem+' > "Включен 2-й район управления"'+ #13#10+ LstNN;
        $7fec: LstNN := Vrem+' > "Включен 1-й район управления"'+ #13#10+ LstNN;
        $7fed: LstNN := Vrem+' > "Включено управление на РМ-ДСП"'+ #13#10+ LstNN;
        $7fee: LstNN := Vrem+' > "Отключена подсветка № поезда"'+ #13#10+ LstNN;
        $7fef: LstNN := Vrem+' > "Включена подсветка № поезда"'+ #13#10+ LstNN;
        $7ff0: LstNN := Vrem+' > "Отключен режим ввода № поезда"'+ #13#10+ LstNN;
        $7ff1: LstNN := Vrem+' > "Включен режим ввода № поезда"'+ #13#10+ LstNN;
        $7ff2: LstNN := Vrem+' > "Отключена подсветка положения стрелок"'+ #13#10+ LstNN;
        $7ff3: LstNN := Vrem+' > "Включена подсветка положения стрелок"'+ #13#10+ LstNN;
        $7ff4: LstNN := Vrem+' > "Отключен режим ввода ограничений"'+ #13#10+ LstNN;
        $7ff5: LstNN := Vrem+' > "Включен режим ввода ограничений"'+ #13#10+ LstNN;
        $7ff6: LstNN := Vrem+' > "Отключен режим отмены"'+ #13#10+ LstNN;
        $7ff7: LstNN := Vrem+' > "Включен режим отмены"'+ #13#10+ LstNN;
        $7ff8: LstNN := Vrem+' > "Включен маршрутный режим управления стрелками и сигналами"'+ #13#10+ LstNN;
        $7ff9: LstNN := Vrem+' > "Включен раздельный режим управления стрелками и сигналами"'+ #13#10+ LstNN;
        $7ffa: LstNN := Vrem+' > "Завершение работы РМ ДСП"'+ #13#10+ LstNN;
        $7ffb: LstNN := Vrem+' > "Начало работы РМ ДСП"'+ #13#10+ LstNN;
        $7ffc: LstNN := Vrem+' > "Искажение БД"'+ #13#10+ LstNN;
        $7ffd: LstNN := Vrem+' > "Сброс команды ТУ"'+ #13#10+ LstNN;
        $7ffe: LstNN := Vrem+' > "Канал ТУ занят"'+ #13#10+ LstNN;
        $7fff: LstNN := Vrem+' > "Управление отключено"'+ #13#10+ LstNN;
      end;
    end else
    if ifr >= $4000 then
    begin //----------------------------------------------------------- внутренняя команда
      obj := ifr and $0fff;
      name_obj := ObjZav[obj].Liter;
      case cmd of
        CmdMenu_StrPerevodPlus :   smn := 'перевод в плюс стрелки '+ name_obj;
        CmdMenu_StrPerevodMinus :  smn := 'перевод в минус стрелки '+ name_obj;
        CmdMenu_StrVPerevodPlus :  smn := 'вспомогательный перевод в плюс стрелки '+ name_obj;
        CmdMenu_StrVPerevodMinus : smn := 'вспомогательный перевод в минус стрелки '+ name_obj;
        CmdMenu_StrOtklUpravlenie : smn := 'отключение от управления стрелки '+ name_obj;
        CmdMenu_StrVklUpravlenie :  smn := 'включение управления стрелки '+ name_obj;
        CmdMenu_StrZakrytDvizenie : smn := 'закрыто движение по стрелке '+ name_obj;
        CmdMenu_StrOtkrytDvizenie : smn := 'открыто движение по стрелке '+ name_obj;
        CmdMenu_UstMaketStrelki :  smn := 'установлен макет на стрелку '+ name_obj;
        CmdMenu_SnatMaketStrelki : smn := 'снят макет со стрелки '+ name_obj;
        CmdMenu_StrMPerevodPlus : smn := 'макетный перевод в плюс стрелки '+ name_obj;
        CmdMenu_StrMPerevodMinus : smn := 'макетный перевод в минус стрелки '+ name_obj;
        CmdMenu_StrZakryt2Dvizenie : smn := 'закрыто движение по стрелке '+ name_obj;
        CmdMenu_StrOtkryt2Dvizenie : smn := 'открыто движение по стрелке '+ name_obj;
        CmdMenu_StrZakrytProtDvizenie : smn := 'закрыто противошерстное движение по стрелке '+ name_obj;
        CmdMenu_StrOtkrytProtDvizenie : smn := 'открыто противошерстное движение по стрелке '+ name_obj;
        CmdMarsh_Tracert : smn := 'трассировка маршрута через '+ name_obj;
        CmdMarsh_Ready : smn := 'выдано предупреждение '+ name_obj;
        CmdMarsh_Manevr : smn := 'установить маневровый маршрут {'+ name_obj+'}';
        CmdMarsh_Poezd : smn := 'установить поездной маршрут {'+ name_obj+'}';
        CmdMarsh_Povtor : smn := 'повтор маршрута '+ name_obj;
        CmdMarsh_Razdel : smn := 'открыть '+ name_obj;
        CmdMarsh_RdyRazdMan : smn := 'открыть маневровый '+ name_obj;
        CmdMarsh_RdyRazdPzd : smn := 'открыть поездной '+ name_obj;
        CmdManevry_ReadyWar : smn := 'получено предупреждение '+ name_obj;
        CmdMarsh_ResetTraceParams : smn := 'нормализация '+ name_obj;
        CmdMarsh_PovtorMarh : smn := 'повтор маршрута от '+ name_obj;
        CmdMarsh_PovtorOtkryt : smn := 'повторное открытие '+ name_obj;
        CmdStr_ReadyPerevodPlus : smn := 'перевод в плюс стрелки '+ name_obj;
        CmdStr_ReadyPerevodMinus : smn := 'перевод в минус стрелки '+ name_obj;
        CmdStr_ReadyVPerevodPlus : smn := 'вспомогательный перевод в плюс стрелки '+ name_obj;
        CmdStr_ReadyVPerevodMinus : smn := 'вспомогательный перевод в минус стрелки '+ name_obj;
        CmdStr_ReadyMPerevodPlus : smn := 'перевод на макете в плюс стрелки '+ name_obj;
        CmdStr_ReadyMPerevodMinus : smn := 'перевод на макете в минус стрелки '+ name_obj;
        CmdStr_AskPerevod : smn := 'выбор стрелки '+ name_obj;
        else  smn := 'подтверждена команда '+ IntToStr(cmd)+ ' на объект '+ IntToStr(Obj);
      end;
      LstNN := Vrem + ' < '+ smn+ #13#10+ LstNN;
      NewNeisprav := true;
    end else
    begin // команда ТУ
      smn := Vrem + ' < выдана команда ТУ ';
      LstNN := smn + IntToStr(cmd)+ ' на объект ['+ IntToStr(ifr)+ ']'+ #13#10 + LstNN;
      NewNeisprav := true;
    end;
  end;
end;
{$ENDIF}

end.
