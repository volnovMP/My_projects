unit CMenu;
//------------------------------------------------------------------------------
//
//  Формирование меню
//
//------------------------------------------------------------------------------

{$INCLUDE CfgProject}

{$UNDEF DEBUG}

interface

uses
  Windows, Menus, Graphics;

function CreateDspMenu(ID, X, Y : SmallInt) : Boolean;
function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
{$IFDEF RMDSP}
function CheckStartTrace(Index : SmallInt) : string;
function CheckAutoON(Index : SmallInt) : Boolean;
function CheckProtag(Index : SmallInt) : Boolean;
function CheckMaket : Boolean;
{$ENDIF}

const
// Коды типов меню
IDMenu_Strelka             = 1;
IDMenu_SvetoforManevr      = 2;
IDMenu_Uchastok            = 3;
IDMenu_PutPO               = 4;
IDMenu_ZamykanieStrelok    = 5;
IDMenu_RazmykanieStrelok   = 6;
IDMenu_ZakrytPereezd       = 7;
IDMenu_OtkrytPereezd       = 8;
IDMenu_IzvesheniePereezd   = 9;
IDMenu_PoezdnoeOpoveshenie = 10;
IDMenu_ZapretMonteram      = 11;
IDMenu_VykluchenieUKSPS    = 12;
IDMenu_SmenaNapravleniya   = 13;
IDMenu_VspomPriem          = 14;
IDMenu_VspomOtpravlenie    = 15;
IDMenu_OchistkaStrelok     = 16;
IDMenu_VkluchenieGRI1      = 17;
IDMenu_PutManevrovyi       = 18;
IDMenu_SvetoforSovmech     = 19;
IDMenu_SvetoforVhodnoy     = 20;
IDMenu_VydachaPSoglasiya   = 21;
IDMenu_ZaprosPSoglasiya    = 22;
IDMenu_ManevrovayaKolonka  = 23;
IDMenu_RezymPitaniyaLamp   = 24;
IDMenu_RezymLampDen        = 25;
IDMenu_RezymLampNoch       = 26;
IDMenu_RezymLampAuto       = 27;
IDMenu_OtklZvonkaUKSPS     = 28;
IDMenu_PAB                 = 29;
IDMenu_Nadvig              = 30;
IDMenu_KSN                 = 31;
IDMenu_OPI                 = 32;
IDMenu_AutoSvetofor        = 33;
IDMenu_Tracert             = 34;
IDMenu_GroupDat            = 35;

// Коды команд меню
CmdMenu_StrPerevodPlus          =  1;
CmdMenu_StrPerevodMinus         =  2;
CmdMenu_StrVPerevodPlus         =  3;
CmdMenu_StrVPerevodMinus        =  4;
CmdMenu_StrOtklUpravlenie       =  5;
CmdMenu_StrVklUpravlenie        =  6;
CmdMenu_StrZakrytDvizenie       =  7;
CmdMenu_StrOtkrytDvizenie       =  8;
CmdMenu_UstMaketStrelki         =  9;
CmdMenu_SnatMaketStrelki        = 10;
CmdMenu_StrMPerevodPlus         = 11;
CmdMenu_StrMPerevodMinus        = 12;
CmdMenu_StrZakryt2Dvizenie      = 13;
CmdMenu_StrOtkryt2Dvizenie      = 14;
CmdMenu_StrZakrytProtDvizenie   = 15;
CmdMenu_StrOtkrytProtDvizenie   = 16;
// 17..20 - резерв команд для стрелок
CmdMenu_OtkrytManevrovym        = 21;
CmdMenu_OtkrytPoezdnym          = 22;
CmdMenu_OtmenaManevrovogo       = 23;
CmdMenu_OtmenaPoezdnogo         = 24;
CmdMenu_PovtorManevrovogo       = 25;
CmdMenu_PovtorPoezdnogo         = 26;
CmdMenu_BlokirovkaSvet          = 27;
CmdMenu_DeblokirovkaSvet        = 28;
CmdMenu_BeginMarshManevr        = 29;
CmdMenu_BeginMarshPoezd         = 30;
CmdMenu_DatPoezdnoeSoglasie     = 31;
CmdMenu_SnatPoezdnoeSoglasie    = 32;
CmdMenu_OtkrytProtjag           = 33;
CmdMenu_PovtorManevrMarsh       = 34;
CmdMenu_PovtorPoezdMarsh        = 35;
CmdMenu_OtkrytAuto              = 36;
CmdMenu_AutoMarshVkl            = 37;
CmdMenu_AutoMarshOtkl           = 38;
CmdMenu_PovtorOtkrytManevr      = 39;
CmdMenu_PovtorOtkrytPoezd       = 40;
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
CmdMenu_PutDatSoglasieOgrady    = 51;
// 52 - резерв;
CmdMenu_PutZakrytDvijenie       = 53;
CmdMenu_PutOtkrytDvijenie       = 54;
CmdMenu_PutZakrytDvijenieET     = 55;
CmdMenu_PutOtkrytDvijenieET     = 56;
CmdMenu_PutZakrytDvijenieETA    = 57;
CmdMenu_PutOtkrytDvijenieETA    = 58;
CmdMenu_PutZakrytDvijenieETD    = 59;
CmdMenu_PutOtkrytDvijenieETD    = 60;
//
CmdMenu_ZamykanieStrelok        = 61;
CmdMenu_PredvRazmykanStrelok    = 62;
CmdMenu_IspolRazmykanStrelok    = 63;
// 64..70 - резерв команд ручного замыкания стрелок
CmdMenu_ZakrytPereezd           = 71;
CmdMenu_PredvOtkrytPereezd      = 72;
CmdMenu_IspolOtkrytPereezd      = 73;
CmdMenu_DatIzvecheniePereezd    = 74;
CmdMenu_SnatIzvecheniePereezd   = 75;
// 76..80 - резерв команд на переезд
CmdMenu_DatOpovechenie          = 81;
CmdMenu_SnatOpovechenie         = 82;
CmdMenu_DatZapretMonteram       = 83;
CmdMenu_SnatZapretMonteram      = 84;
// 85..90 - резерв команд на оповещение
CmdMenu_PredvOtkluchenieUKSPS   = 91;
CmdMenu_IspolOtkluchenieUKSPS   = 92;
CmdMenu_OtklZvonkaUKSPS         = 93;
CmdMenu_OtmenaOtkluchenieUKSPS  = 94;
// 95..100 - резерв команд УКСПС
CmdMenu_SmenaNapravleniya       = 101;
CmdMenu_DatSoglasieSmenyNapr    = 102;
CmdMenu_ZakrytPeregon           = 103;
CmdMenu_OtkrytPeregon           = 104;
CmdMenu_PredvVspomOtpravlenie   = 105;
CmdMenu_IspolVspomOtpravlenie   = 106;
CmdMenu_PredvVspomPriem         = 107;
CmdMenu_IspolVspomPriem         = 108;
CmdMenu_VklKSN                  = 109;
CmdMenu_OtklKSN                 = 110;
//
CmdMenu_VkluchOchistkuStrelok   = 111;
CmdMenu_OtklOchistkuStrelok     = 112;
CmdMenu_VkluchenieGRI           = 113;
// 114 - резерв
CmdMenu_ZaprosPoezdSoglasiya    = 115;
CmdMenu_OtmZaprosPoezdSoglasiya = 116;
// 117..120 - резерв
CmdMenu_DatRazreshenieManevrov  = 121;
CmdMenu_OtmenaManevrov          = 122;
CmdMenu_PredvIRManevrov         = 123;
CmdMenu_IspolIRManevrov         = 124;
// 125..130 - резерв для маневровой колонки
CmdMenu_VkluchitDen             = 131;
CmdMenu_VkluchitNoch            = 132;
CmdMenu_VkluchitAuto            = 133;
CmdMenu_OtkluchitAuto           = 134;
//
CmdMenu_Osnovnoy                = 135;
//CmdMenu_Rezerv                  = 136; можно использовать для других целей
CmdMenu_RU1                     = 137;
CmdMenu_RU2                     = 138;
CmdMenu_ResetCommandBuffers     = 139;
// 140 - резерв
// ПАБ
CmdMenu_VydatSoglasieOtpravl    = 141;
CmdMenu_OtmenaSoglasieOtpravl   = 142;
CmdMenu_IskPribytiePredv        = 143;
CmdMenu_IskPribytieIspolnit     = 144;
CmdMenu_VydatPribytiePoezda     = 145;
CmdMenu_ZakrytPeregonPAB        = 146;
CmdMenu_OtkrytPeregonPAB        = 147;
// Блокировка надвига
CmdMenu_BlokirovkaNadviga       = 151;
CmdMenu_DeblokirovkaNadviga     = 152;
// Блокировка увязок
CmdMenu_OtkrytUvjazki           = 153;
CmdMenu_ZakrytUvjazki           = 154;
//
CmdMenu_RestartServera          = 160;
CmdMenu_RestartUVK              = 161;

CmdMenu_SnatSoglasieSmenyNapr   = 162; // АБ
CmdMenu_PutVklOPI               = 163; // Путь
CmdMenu_PutOtklOPI              = 164; // Путь
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

CmdMenu_RescueOTU               = 189;

// Коды кнопок-команд меню
KeyMenu_RazdeRejim          = 1001; // <F1>
KeyMenu_MarshRejim          = 1002; // <F1>
KeyMenu_MaketStrelki        = 1003;
KeyMenu_OtmenMarsh          = 1004;
KeyMenu_DateTime            = 1005; // <F2>
KeyMenu_InputOgr            = 1006;
KeyMenu_VspPerStrel         = 1007;
KeyMenu_EndTrace            = 1008; // <End>
KeyMenu_ClearTrace          = 1009; // <Shift+End>
KeyMenu_RejimRaboty         = 1010; // Запрос смены режима работы АРМа
KeyMenu_ReadyResetTrace     = 1011; // Ожидание сброса набираемой трассы маршрута по враждебности
KeyMenu_EndTraceError       = 1012; // Конечная точка трассы маршрута указана неверно
KeyMenu_ReadyWarningTrace   = 1013; // Ожидание подтверждения сообщений по трассе
KeyMenu_ReadyWarningEnd     = 1014; // Ожидание подтверждения сообщений по концу трассы
KeyMenu_BellOff             = 1015; // <F12>
KeyMenu_UpravlenieUVK       = 1016; // Меню управления УВК
KeyMenu_ReadyRestartServera = 1017; // Ожидание подтверждения перезапуска сервера
KeyMenu_ReadyRestartUVK     = 1018; // Ожидание подтверждения переключения УВК
KeyMenu_RezervARM           = 1019; // Команда перевода АРМа в резерв
KeyMenu_QuerySetTrace       = 1020; // Запрос на установку стрелок по введенной трассе
KeyMenu_PodsvetkaStrelok    = 1021; // Кнопка подсветки положения стрелок
KeyMenu_VvodNomeraPoezda    = 1022; // Кнопка ввода номера поезда
KeyMenu_PodsvetkaNomerov    = 1023; // Кнопка подсветки номера поездов
KeyMenu_ReadyRescueOTU      = 1024; // Ожидание подтверждения восстановления интерфейса ОТУ УВК

var
  IndexFR3IK : SmallInt;
  DesktopSize : TPoint; // Размер рабочего стола во время запуска программы

implementation

uses
  SysUtils,
  TypeRpc,
  VarStruct,
  Commands,
  Commons,
  Marshrut,
{$IFDEF RMARC}
  PackArmSrv,
{$ELSE}
  KanalArmSrv,
{$ENDIF}
{$IFDEF RMSHN}
  ValueList,
{$ENDIF}
  TabloForm;

{$IFDEF RMDSP}var msg : string;{$ENDIF}
{$IFDEF RMARC}var cmdmnu : string;{$ENDIF}

const
  NetKomandy : string = 'Нет команды';

function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
begin
try
  if (DspMenu.Count < Length(DspMenu.Items)) and (ID_Cmd > 0) and (ID_Obj > 0) then
  begin
    inc(DspMenu.Count);
    DspMenu.Items[DspMenu.Count].MenuItem := TMenuItem.Create(TabloMain);
    DspMenu.Items[DspMenu.Count].MenuItem.OnClick := TabloMain.DspPopUpHandler;
    DspMenu.Items[DspMenu.Count].ID := DspMenu.Items[DspMenu.Count].MenuItem.Command;
    DspMenu.Items[DspMenu.Count].Obj := ID_Obj;
    DspMenu.Items[DspMenu.Count].Command := ID_Cmd;
    DspMenu.Items[DspMenu.Count].MenuItem.Caption := Caption;
    DspMenu.Items[DspMenu.Count].MenuItem.AutoHotkeys := maManual;
    result := true;
  end else
  begin
    MessageBeep(MB_ICONQUESTION); result := false;
  end;
except
  reportf('Ошибка [CMenu.AddDspMenuItem]'); result := true;
end;
end;

//------------------------------------------------------------------------------
// подготовить меню
function CreateDspMenu(ID,             // Тип обработки, связаный с объектом
                       X,Y : SmallInt) // Координата объекта
                       : boolean;      // true- надо запустить процедуру ожидания ввода команд

  function LockDirect : Boolean;
  begin
  try
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin // Управление отключено
      InsArcNewMsg(0,76); ShowShortMsg(76,LastX,LastY,''); LockDirect := true; exit;
    end;
    if (ID_Obj > 0) and (ID_Obj < 4096) and not WorkMode.OU[ObjZav[ID_Obj].Group] then
    begin // Управление отключено
      InsArcNewMsg(0,76); ShowShortMsg(76,LastX,LastY,''); LockDirect := true; exit;
    end;
    if WorkMode.CmdReady then
    begin // буфер команд заполнен - блокировка команд до освобождения буфера
      InsArcNewMsg(0,251); ShowShortMsg(251,LastX,LastY,''); LockDirect := true;
    end else
      LockDirect := false;
  except
    reportf('Ошибка [CMenu.CreateDspMenu.LockDirect]'); LockDirect := true;
  end;
  end;

{$IFDEF RMDSP}
  var i : integer; ogr,u1,u2,uo : Boolean;
  label mkmnu;
  var j : integer;
{$ENDIF}

begin
try
  ObjHintIndex := 0;
{$IFDEF RMARC}
  if (ID_Obj > 0) and (ID_Obj < WorkMode.LimitObjZav) then
    cmdmnu := DateTimeToStr(CurrentTime)+ ' > '+ ObjZav[ID_Obj].Liter
  else
    cmdmnu := DateTimeToStr(CurrentTime)+ ' > ';
{$ELSE}
  SetLockHint;
{$ENDIF}
  DspCommand.Active := false; // сбросить признак наличия команды, ожидающей обработки
  DspCommand.Command := 0;
  DspCommand.Obj := 0;
  DspMenu.Ready := false;
  DspMenu.obj := cur_obj; // сохранить номер объекта под курсором
  DspMenu.Count := 0;
{$IFNDEF RMARC}
  ResetShortMsg;
  ShowWarning := false;
{$ENDIF}
  result := false;

// Дополнить буфер команд меню
{$IFDEF RMDSP}
  msg := '';
  InsNewArmCmd(DspMenu.obj+$8000,ID);

  // специфичные команды, разрешенные в режиме отсутствия управления
  case ID of

    KeyMenu_PodsvetkaStrelok : begin // Подсветка положения стрелок
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; exit;
    end;






    KeyMenu_VvodNomeraPoezda : begin // Ввод номера поезда
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; exit;
    end;

    KeyMenu_PodsvetkaNomerov : begin // Подсветка номера поездов
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; exit;
    end;






    KeyMenu_DateTime : begin // Ввод времени РМ-ДСП
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0;
      if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 / 24) then
      begin
        InsArcNewMsg(0,252+$4000); msg := GetShortMsg(1,252,''); DspMenu.WC := true; goto mkmnu;
      end else
      begin
        InsArcNewMsg(0,435+$4000); ShowShortMsg(435,LastX,LastY,''); DspMenu.WC := true; exit;
      end;
    end;

    KeyMenu_ClearTrace : begin // Сброс набираемого маршрута, сброс буферов команд
      if (CmdCnt > 0) or WorkMode.MarhRdy or WorkMode.CmdReady then
      begin
        DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0;
      end;
      exit;
    end;

    KeyMenu_BellOff : begin // Сброс фиксируемого звонка
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; exit;
    end;

    KeyMenu_RejimRaboty : begin // Смена режима работы АРМа
      if config.configKRU > 0 then exit;
      if WorkMode.CmdReady then
      begin
        InsArcNewMsg(0,251+$4000); ShowShortMsg(251,LastX,LastY,''); exit;
      end;
      if WorkMode.Upravlenie then
      begin // АРМ назначен управляющим
        if ((StateRU and $40) = 0) or WorkMode.BU[0] then
        begin // Режим АУ или выключен сервер
          InsArcNewMsg(0,225+$4000); DspCommand.Active := true; DspCommand.Command := KeyMenu_RezervARM; msg := GetShortMsg(1,225,''); result := true; DspMenu.WC := true; goto mkmnu;
        end;
      end else
      begin // АРМ в резерве
        if WorkMode.OtvKom then
        begin
          InsArcNewMsg(0,224+$4000); AddDspMenuItem(GetShortMsg(1,224,''), CmdMenu_Osnovnoy,ID_Obj); DspMenu.WC := true; goto mkmnu;
        end else
        begin // не нажата кнопка ответственных команд
          InsArcNewMsg(0,276); ShowShortMsg(276,LastX,LastY,''); SingleBeep := true; DspMenu.WC := true; exit;
        end;
      end;
    end;

    KeyMenu_UpravlenieUVK : begin // Команды управления работой УВК
      if WorkMode.CmdReady then
      begin
        InsArcNewMsg(0,251+$4000); ShowShortMsg(251,LastX,LastY,''); exit;
      end;
      if WorkMode.OtvKom then
      begin
        if config.configKRU = 0 then
        begin
          InsArcNewMsg(0,347+$4000); AddDspMenuItem(GetShortMsg(1,347,''), CmdMenu_RestartServera,ID_Obj);
        end;
        for i := 1 to high(ObjZav) do
        begin
          if ObjZav[i].TypeObj = 37 then
          begin
            InsArcNewMsg(i,348+$4000); AddDspMenuItem(GetShortMsg(1,348, ObjZav[i].Liter), CmdMenu_RestartUVK,i);
            if ObjZav[i].ObjConstB[1] then
            begin
              InsArcNewMsg(i,505+$4000); AddDspMenuItem(GetShortMsg(1,505, ObjZav[i].Liter), CmdMenu_RescueOTU,i);
            end;
          end;
        end;
        DspMenu.WC := true; goto mkmnu;
      end else
      begin // не нажата кнопка ответственных команд
        InsArcNewMsg(0,276); ShowShortMsg(276,LastX,LastY,''); Beep; DspMenu.WC := true; exit;
      end;
    end;

    KeyMenu_ReadyRestartServera : begin //
      InsArcNewMsg(0,351+$4000); DspCommand.Active := true; DspCommand.Command := ID; msg := GetShortMsg(1,351,''); result := true; DspMenu.WC := true; goto mkmnu;
    end;

    KeyMenu_ReadyRestartUVK : begin //
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := IndexFR3IK; IndexFR3IK := 0;
      InsArcNewMsg(DspCommand.Obj,352+$4000); msg := GetShortMsg(1,352,ObjZav[DspCommand.Obj].Liter); result := true; DspMenu.WC := true; goto mkmnu;
    end;

    KeyMenu_ReadyRescueOTU : begin //
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := IndexFR3IK; IndexFR3IK := 0;
      InsArcNewMsg(DspCommand.Obj,504+$4000); msg := GetShortMsg(1,504,ObjZav[DspCommand.Obj].Liter); result := true; DspMenu.WC := true; goto mkmnu;
    end;
  end;

  if LockDirect then exit;

  if CheckOtvCommand(ID_Obj) then
  begin
    OtvCommand.Active := false; WorkMode.GoOtvKom := false; OtvCommand.Ready := false;
    ShowShortMsg(153,LastX,LastY,''); SingleBeep := true;
    InsArcNewMsg(0,153);
    exit;
  end;
{$ENDIF}

  // Сформировать меню/подтверждение выбора команды
  case ID of

{$IFDEF RMDSP}
    KeyMenu_RazdeRejim : begin // Переключение режима Раздельный
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; InsArcNewMsg(DspCommand.Obj,95+$4000); msg := GetShortMsg(1,95,''); result := false;
    end;

    KeyMenu_MarshRejim : begin // Переключение режима Маршрутный
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; InsArcNewMsg(DspCommand.Obj,96+$4000); msg := GetShortMsg(1,96,''); result := false;
    end;

    KeyMenu_MaketStrelki : begin // Включение/выключение макета стрелок
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        ResetCommands; InsArcNewMsg(0,283); ShowShortMsg(283,LastX,LastY,''); exit;
      end;
      ResetTrace; // Сбросить набор маршрута
      WorkMode.MarhOtm := false; WorkMode.VspStr := false; WorkMode.InpOgr := false;
      if maket_strelki_index > 0 then
      begin // запрос снятия стрелки с макета
        msg := GetShortMsg(1,172, maket_strelki_name); DspCommand.Command := CmdMenu_SnatMaketStrelki;
        DspCommand.Obj := maket_strelki_index; DspMenu.WC := true; InsArcNewMsg(DspCommand.Obj,172+$4000);
      end else
      if WorkMode.GoMaketSt then
      begin // Снять признак выбора стрелки для постановки на макет
        WorkMode.GoMaketSt := false; ResetShortMsg; exit;
      end else
      begin // Выбрать стрелку для установки на макет
        for i := 1 to High(ObjZav) do
        begin                              //Проверка подключения макетного шнура
          if (ObjZav[i].RU = config.ru) and (ObjZav[i].TypeObj = 20) then
          begin
            if ObjZav[i].bParam[1] then
            begin // Запрос номера стрелки
              WorkMode.GoMaketSt := true; InsArcNewMsg(0,8+$4000); ShowShortMsg(8,LastX,LastY,'');
            end else
            begin // макетный шнур не подключен
              ResetShortMsg; InsArcNewMsg(0,90); AddFixMessage(GetShortMsg(1,90,''),4,2);
            end;
            exit;
          end;
        end;
        exit;
      end;
    end;

    KeyMenu_OtmenMarsh : begin // Включение/выключение режима отмены маршрута
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; exit;
    end;

    KeyMenu_InputOgr : begin // Включение/выключение режима ввода ограничений
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; exit;
    end;

    KeyMenu_VspPerStrel : begin // Включение/выключение режима вспомогательного перевода стрелок
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0; exit;
    end;

    KeyMenu_EndTrace : begin // Конец набора маршрута
      DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0;
      if MarhTracert[1].WarCount > 0 then
      begin
        msg := MarhTracert[1].Warning[MarhTracert[1].WarCount]; InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]);
      end else
        exit;
    end;

    KeyMenu_EndTraceError : begin // Выдать предупреждение, что конечная точка маршрута указана неверно
      DspCommand.Active := true; DspCommand.Command := KeyMenu_ClearTrace; DspCommand.Obj := 0;
      InsArcNewMsg(0,87); ShowShortMsg(87,LastX,LastY,''); exit;
    end;

    CmdMarsh_Ready : begin // Запросить подтверждение установки маршрута
      DspMenu.obj := cur_obj;
      case MarhTracert[1].Rod of
        MarshM : begin
          InsArcNewMsg(MarhTracert[1].ObjStart,6+$4000);
          msg := GetShortMsg(1,6, ObjZav[MarhTracert[1].ObjStart].Liter + MarhTracert[1].TailMsg);
          DspCommand.Active := true; DspCommand.Command := CmdMarsh_Manevr; DspCommand.Obj := ID_Obj;
        end;
        MarshP : begin
          InsArcNewMsg(MarhTracert[1].ObjStart,7+$4000);
          msg := GetShortMsg(1,7, ObjZav[MarhTracert[1].ObjStart].Liter + MarhTracert[1].TailMsg);
          DspCommand.Active := true; DspCommand.Command := CmdMarsh_Poezd; DspCommand.Obj := ID_Obj;
        end;
      else
        exit;
      end;
      DspMenu.WC := true;
    end;

    CmdMarsh_RdyRazdMan : begin // Запрос открытия раздельным маневрового
      InsArcNewMsg(MarhTracert[1].ObjStart,6+$4000);
      msg := GetShortMsg(1,6, ObjZav[MarhTracert[1].ObjStart].Liter);
      DspCommand.Command := ID;
      if ObjZav[ID_Obj].TypeObj = 5 then DspCommand.Obj := ID_Obj else DspCommand.Obj := ObjZav[ID_Obj].BaseObject;
      DspMenu.WC := true;
    end;

    CmdMarsh_RdyRazdPzd : begin // Запрос открытия раздельным поездного
      InsArcNewMsg(MarhTracert[1].ObjStart,7+$4000);
      msg := GetShortMsg(1,7, ObjZav[MarhTracert[1].ObjStart].Liter);
      DspCommand.Command := ID;
      if ObjZav[ID_Obj].TypeObj = 5 then DspCommand.Obj := ID_Obj else DspCommand.Obj := ObjZav[ID_Obj].BaseObject;
      DspMenu.WC := true;
    end;

    CmdMarsh_Povtor  : begin // Вывод сообщений перед повторным открытием сигнала
      if MarhTracert[1].WarCount > 0 then
      begin
        ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000);
        msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
        DspCommand.Command := ID; DspCommand.Obj := ID_Obj; DspMenu.WC := true;
        dec(MarhTracert[1].WarCount);
      end;
    end;

    CmdMarsh_PovtorMarh  : begin // Вывод сообщений перед повторной установкой маршрута
      if MarhTracert[1].WarCount > 0 then
      begin
        ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000);
        msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
        DspCommand.Command := ID; DspCommand.Obj := ID_Obj; DspMenu.WC := true;
        dec(MarhTracert[1].WarCount);
      end;
    end;

    CmdMarsh_PovtorOtkryt  : begin // Вывод сообщений перед повторным открытием сигнала в раздельном режиме
      if MarhTracert[1].WarCount > 0 then
      begin
        ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000);
        msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
        DspCommand.Command := ID; DspCommand.Obj := ID_Obj; DspMenu.WC := true;
        dec(MarhTracert[1].WarCount);
      end;
    end;

    CmdMarsh_Razdel : begin // Вывод сообщений перед открытием сигнала в раздельном режиме управления
      if MarhTracert[1].WarCount > 0 then
      begin
        ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000);
        msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
        DspCommand.Command := ID; DspCommand.Obj := ID_Obj; DspMenu.WC := true;
        dec(MarhTracert[1].WarCount);
      end;
    end;

    KeyMenu_QuerySetTrace : begin // Запрос на выдачу команды установки стрелок по введенной трассе
      SingleBeep2 := true; TimeLockCmdDsp := LastTime; LockCommandDsp := true; ShowWarning := true;
      InsArcNewMsg(MarhTracert[1].ObjStart,442+$4000);
      msg := GetShortMsg(1,442,ObjZav[MarhTracert[1].ObjStart].Liter+ MarhTracert[1].TailMsg);
      DspCommand.Command := KeyMenu_QuerySetTrace; DspCommand.Active := true; DspCommand.Obj := ID_Obj; DspMenu.WC := true; goto mkmnu;
    end;

    KeyMenu_ReadyResetTrace : begin // Ожидается сброс набираемой трассы маршрута по враждебности
      ShowWarning := true;
      if MarhTracert[1].GonkaStrel and (MarhTracert[1].GonkaList > 0) then
      begin
        InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]+$5000);
        msg := MarhTracert[1].Msg[1] + '. Возможен перевод стрелок. Продолжать?';
      end else
      begin
        InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]);
        msg := MarhTracert[1].Msg[1];
      end;
      PutShortMsg(1, LastX, LastY, msg); DspMenu.WC := true;
      DspCommand.Command := CmdMarsh_Tracert; DspCommand.Active := true; DspCommand.Obj := ID_Obj; DspMenu.WC := true; exit;
    end;

    KeyMenu_ReadyWarningTrace : begin // Ожидается подтверждение сообщения по трассе маршрута
      if MarhTracert[1].WarCount > 0 then
      begin
        ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000);
        msg := MarhTracert[1].Warning[MarhTracert[1].WarCount]+ '. Продолжать?'; DspMenu.WC := true;
        DspCommand.Command := CmdMarsh_Tracert; DspCommand.Active := true; DspCommand.Obj := ID_Obj; DspMenu.WC := true;
      end;
    end;

    KeyMenu_ReadyWarningEnd : begin // Ожидается подтверждение сообщения по концу трассы маршрута
      if MarhTracert[1].WarCount > 0 then
      begin
        ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000);
        msg := MarhTracert[1].Warning[MarhTracert[1].WarCount]+ '. Продолжать?'; DspMenu.WC := true;
        DspCommand.Command := KeyMenu_EndTrace; DspCommand.Active := true; DspCommand.Obj := ID_Obj;
      end;
    end;

    CmdStr_ReadyMPerevodPlus : begin // Подтверждение перевода макетной стрелки в плюс
      InsArcNewMsg(ObjZav[ID_Obj].BaseObject,101+$4000);
      msg := GetShortMsg(1,101,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
      DspMenu.WC := true; DspCommand.Command := CmdStr_ReadyMPerevodPlus; DspCommand.Obj := ID_Obj;
    end;

    CmdStr_ReadyMPerevodMinus : begin // Подтверждение перевода макетной стрелки в минус
      InsArcNewMsg(ObjZav[ID_Obj].BaseObject,102+$4000);
      msg := GetShortMsg(1,102,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
      DspMenu.WC := true; DspCommand.Command := CmdStr_ReadyMPerevodMinus; DspCommand.Obj := ID_Obj;
    end;

    CmdStr_AskPerevod : begin // перевод стрелки
      if ObjZav[ID_Obj].bParam[1] then
      begin // в минус
        if maket_strelki_index = ObjZav[ID_Obj].BaseObject then
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,102+$4000); msg := GetShortMsg(1,102,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspCommand.Command := CmdStr_ReadyMPerevodMinus; DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,98+$4000); msg := GetShortMsg(1,98,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspCommand.Command := CmdStr_ReadyPerevodMinus; DspCommand.Obj := ID_Obj;
        end;
      end else // в плюс
      if ObjZav[ID_Obj].bParam[2] then
      begin
        if maket_strelki_index = ObjZav[ID_Obj].BaseObject then
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,101+$4000); msg := GetShortMsg(1,101,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspCommand.Command := CmdStr_ReadyMPerevodPlus; DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,97+$4000); msg := GetShortMsg(1,97,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspCommand.Command := CmdStr_ReadyPerevodPlus; DspCommand.Obj := ID_Obj;
        end;
      end else
      begin // по выбору
        if ObjZav[ID_Obj].bParam[22] or (not ObjZav[ID_Obj].bParam[22] and not ObjZav[ID_Obj].bParam[23] and ObjZav[ID_Obj].bParam[20]) then msg := ' <' else msg := '';
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,165+$4000); AddDspMenuItem(GetShortMsg(1,165,msg), CmdMenu_StrPerevodMinus,ID_Obj);
        if ObjZav[ID_Obj].bParam[23] or (not ObjZav[ID_Obj].bParam[22] and not ObjZav[ID_Obj].bParam[23] and ObjZav[ID_Obj].bParam[21]) then msg := ' <' else msg := '';
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,164+$4000); AddDspMenuItem(GetShortMsg(1,164,msg), CmdMenu_StrPerevodPlus,ID_Obj);
      end;
      DspMenu.WC := true;
    end;

    IDMenu_Tracert : begin // трассировка по острякам стрелок
      DspCommand.Active  := true; DspCommand.Command := CmdMarsh_Tracert; DspCommand.Obj := ID_Obj; exit;
    end;
{$ENDIF}

    IDMenu_Strelka : begin// Стрелка
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstB[2] and
         (ObjZav[ObjZav[ID_Obj].BaseObject].bParam[3] or ObjZav[ObjZav[ID_Obj].BaseObject].bParam[12]) then
      begin // при наличии возбужденных признаков автовозврата - сбросить их
        ObjZav[ObjZav[ID_Obj].BaseObject].bParam[3] := false;
        ObjZav[ObjZav[ID_Obj].BaseObject].bParam[12] := false;
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,424+$4000);
        AddFixMessage(GetShortMsg(1,424,ObjZav[ObjZav[ID_Obj].BaseObject].Liter),4,1);
      end;
      if WorkMode.OtvKom then
      begin // нажата ОК - нормализовать признаки трассировки для стрелки
        InsArcNewMsg(ID_Obj,311+$4000);
        msg := GetShortMsg(1,311, 'стрелку '+ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ID_Obj;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoTracert then
      begin // Сбросить набор маршрута
        ResetTrace; exit;
      end else
      if WorkMode.GoMaketSt then
      begin
        if not ObjZav[ObjZav[ID_Obj].UpdateObject].bParam[5] or ObjZav[ObjZav[ID_Obj].UpdateObject].bParam[9] then
        begin // стрелка на местном управлении
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,91+$4000); WorkMode.GoMaketSt := false; ShowShortMsg(91,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); WorkMode.GoMaketSt := false; exit;
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] or ObjZav[ID_Obj].bParam[10] or ObjZav[ID_Obj].bParam[11] or ObjZav[ID_Obj].bParam[12] or ObjZav[ID_Obj].bParam[13] or ObjZav[ID_Obj].bParam[6] or ObjZav[ID_Obj].bParam[7] then
        begin // стрелка в маршруте
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,511+$4000); WorkMode.GoMaketSt := false; ShowShortMsg(511,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); WorkMode.GoMaketSt := false; exit;
        end else
        if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[2] then
        begin // Есть контроль положения - отказ от установки на макет
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,92); ResetShortMsg; AddFixMessage(GetShortMsg(1,92,ObjZav[ObjZav[ID_Obj].BaseObject].Liter),4,1); WorkMode.GoMaketSt := false; exit;
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[26] then
        begin // Запросить подтверждение установки на макет если есть потеря контроля стрелки
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,138+$4000);
          msg := GetShortMsg(1,138,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspCommand.Command := CmdMenu_UstMaketStrelki; DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,92); ResetShortMsg; AddFixMessage(GetShortMsg(1,92,ObjZav[ObjZav[ID_Obj].BaseObject].Liter),4,1); WorkMode.GoMaketSt := false; exit;
        end;
      end else
      begin // нормальный режим
        if WorkMode.InpOgr then
        begin // ввод ограничений
          if ObjZav[ID_Obj].bParam[33] then
          begin // включено автодействие
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,431+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(431, LastX, LastY, ''); exit;
          end else
          if ObjZav[ID_Obj].bParam[5] or ObjZav[ID_Obj].bParam[6] or ObjZav[ID_Obj].bParam[7] or ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[14] then
          begin // стрелка в трассировке маршрута
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,511+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(511, LastX, LastY, ObjZav[ObjZav[ID_Obj].BaseObject].Liter); exit;
          end else
          if not ObjZav[ObjZav[ID_Obj].UpdateObject].bParam[5] or ObjZav[ObjZav[ID_Obj].UpdateObject].bParam[9] then
          begin // ходовая стрелка на местном управлении
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,91+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(91, LastX, LastY, ObjZav[ObjZav[ID_Obj].BaseObject].Liter); exit;
          end else
          begin
            // отключить от управления
            if ObjZav[ID_Obj].bParam[18] <> ObjZav[ObjZav[ID_Obj].BaseObject].bParam[18] then
            begin
              InsArcNewMsg(ObjZav[ID_Obj].BaseObject,169+$4000);
              InsArcNewMsg(ObjZav[ID_Obj].BaseObject,168+$4000);
              AddDspMenuItem(GetShortMsg(1,169, ''), CmdMenu_StrVklUpravlenie,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,168, ''), CmdMenu_StrOtklUpravlenie,ID_Obj);
            end else
            begin
              if ObjZav[ID_Obj].bParam[18] then
              begin
                InsArcNewMsg(ObjZav[ID_Obj].BaseObject,169+$4000);
                AddDspMenuItem(GetShortMsg(1,169, ''), CmdMenu_StrVklUpravlenie,ID_Obj);
              end else
              begin
                InsArcNewMsg(ObjZav[ID_Obj].BaseObject,168+$4000);
                AddDspMenuItem(GetShortMsg(1,168, ''), CmdMenu_StrOtklUpravlenie,ID_Obj);
              end;
            end;
            // закрыть для движения
            if ObjZav[ID_Obj].ObjConstB[6] then ogr := ObjZav[ObjZav[ID_Obj].BaseObject].bParam[16] else ogr := ObjZav[ObjZav[ID_Obj].BaseObject].bParam[17];
            if ObjZav[ID_Obj].bParam[16] <> ogr then
            begin
              InsArcNewMsg(ID_Obj,171+$4000);
              InsArcNewMsg(ID_Obj,170+$4000);
              AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_StrOtkrytDvizenie,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_StrZakrytDvizenie,ID_Obj);
            end else
            begin
              if ObjZav[ID_Obj].bParam[16] then
              begin
                InsArcNewMsg(ID_Obj,171+$4000);
                AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_StrOtkrytDvizenie,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_StrZakrytDvizenie,ID_Obj);
              end;
            end;
            if not ObjZav[ID_Obj].ObjConstB[10] then
            begin // закрыть для движения противошерстных если не является сбрасывающим башмаком
            if ObjZav[ID_Obj].ObjConstB[6] then ogr := ObjZav[ObjZav[ID_Obj].BaseObject].bParam[33] else ogr := ObjZav[ObjZav[ID_Obj].BaseObject].bParam[34];
              if ObjZav[ID_Obj].bParam[17] <> ogr then
              begin
                InsArcNewMsg(ID_Obj,450+$4000);
                InsArcNewMsg(ID_Obj,449+$4000);
                AddDspMenuItem(GetShortMsg(1,450, ''), CmdMenu_StrOtkrytProtDvizenie,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,449, ''), CmdMenu_StrZakrytProtDvizenie,ID_Obj);
              end else
              begin
                if ObjZav[ID_Obj].bParam[17] then
                begin
                  InsArcNewMsg(ID_Obj,450+$4000);
                  AddDspMenuItem(GetShortMsg(1,450, ''), CmdMenu_StrOtkrytProtDvizenie,ID_Obj);
                end else
                begin
                  InsArcNewMsg(ID_Obj,449+$4000);
                  AddDspMenuItem(GetShortMsg(1,449, ''), CmdMenu_StrZakrytProtDvizenie,ID_Obj);
                end;
              end;
            end;

            // сбросить макет стрелки в случае развала макета
            if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[15] and (maket_strelki_index <> ObjZav[ID_Obj].BaseObject) then
            begin
              InsArcNewMsg(ObjZav[ID_Obj].BaseObject,172+$4000);
              AddDspMenuItem(GetShortMsg(1,172, ''), CmdStr_ResetMaket,ID_Obj);
            end;
          end;
        end else

        if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[31] then
        begin // нет данных в канале
          InsArcNewMsg(ID_Obj,255+$4000); VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(255, LastX, LastY, ObjZav[ObjZav[ID_Obj].BaseObject].Liter); exit;
        end else

        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[4] or
           not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[21] then
        begin // стрелка замкнута
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,147+$4000);
          ShowShortMsg(147,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true; exit;
        end else
        if ObjZav[ID_Obj].bParam[18] or ObjZav[ObjZav[ID_Obj].BaseObject].bParam[18] then
        begin // стрелка выключена из управления
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,151+$4000);
          ShowShortMsg(151,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true; exit;
        end else

        if ObjZav[ObjZav[ObjZav[ID_Obj].BaseObject].ObjConstI[13]].bParam[1] then
        begin // Выключен контроль занятости секции
          if WorkMode.VspStr then
          begin // нарушен порядок вспомогательного перевода стрелки
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,411+$4000);
            ShowShortMsg(411,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true; exit;
          end else
          begin // Дать предупреждение о выключении контроля изоляции
            InsArcNewMsg(ObjZav[ID_Obj].BaseObject,139+$4000);
            ShowShortMsg(139,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true; exit;
          end;
        end else
        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] or ObjZav[ObjZav[ID_Obj].BaseObject].bParam[23] then
        begin // стрелка трассируется в маршруте  - предупредить, затем запросить перевод
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,240+$4000);
          msg := GetShortMsg(1,240,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true; ShowWarning := true;
          DspCommand.Command := CmdStr_AskPerevod; DspCommand.Obj := ID_Obj;
        end else
        begin // запрос на перевод стрелки
          DspCommand.Command := CmdStr_AskPerevod; DspCommand.Obj := ID_Obj; DspCommand.Active := true; exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_SvetoforManevr,
    IDMenu_SvetoforSovmech,
    IDMenu_SvetoforVhodnoy
     : begin// Светофор
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      if ObjZav[ID_Obj].bParam[23] or ((ObjZav[ID_Obj].bParam[5] or ObjZav[ID_Obj].bParam[15] or ObjZav[ID_Obj].bParam[17] or ObjZav[ID_Obj].bParam[24] or ObjZav[ID_Obj].bParam[25]) and
        not ObjZav[ID_Obj].bParam[20] and not WorkMode.GoTracert) then
      begin // снять мигание при неисправности
        ObjZav[ID_Obj].bParam[23] := false; ObjZav[ID_Obj].bParam[20] := true;
      end;
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      ObjZav[ID_Obj].bParam[34] := false; // сбросить признак требования повтора установки маршрута

      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.OtvKom then
      begin // нажата ОК - нормализовать признаки трассировки для светофора
        InsArcNewMsg(ID_Obj,311+$4000);
        msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ID_Obj;
      end else
      begin // нормальный режим
        if ObjZav[ID_Obj].bParam[23] and not WorkMode.GoTracert then
        begin // восприятие перекрытия светофора
          ObjZav[ID_Obj].bParam[23] := false; exit;
        end else
        if ObjZav[ID_Obj].bParam[18] then
        begin // на местном управлении
          InsArcNewMsg(ID_Obj,232+$4000);
          WorkMode.GoMaketSt := false; ShowShortMsg(232,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
        end else
        if WorkMode.InpOgr then
        begin // ввод ограничений
          if ObjZav[ID_Obj].bParam[33] then
          begin // включено автодействие
            InsArcNewMsg(ID_Obj,431+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(431, LastX, LastY, ''); exit;
          end else
          if ObjZav[ID_Obj].bParam[14] then
          begin // светофор в трассе маршрута
            InsArcNewMsg(ID_Obj,238+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(238, LastX, LastY, ObjZav[ID_Obj].Liter); exit;
          end else
          begin
            if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
            begin
              InsArcNewMsg(ID_Obj,179+$4000);
              InsArcNewMsg(ID_Obj,180+$4000);
              AddDspMenuItem(GetShortMsg(1,179, ''), CmdMenu_BlokirovkaSvet,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,180, ''), CmdMenu_DeblokirovkaSvet,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[13] then
            begin // разблокировать светофор
              InsArcNewMsg(ID_Obj,180+$4000);
              msg := GetShortMsg(1,180, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DeblokirovkaSvet; DspCommand.Obj := ID_Obj;
            end else
            begin // заблокировать светофор
              InsArcNewMsg(ID_Obj,179+$4000);
              msg := GetShortMsg(1,179, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_BlokirovkaSvet; DspCommand.Obj := ID_Obj;
            end;
          end;
        end else
        if WorkMode.MarhOtm then
        begin // отмена маршрутов для всех режимов управления сигналами
          AutoMarshReset(ObjZav[ID_Obj].ObjConstI[28]); // Сброс автодействия (если существует)
          if ObjZav[ID_Obj].ObjConstB[3] and
             (ObjZav[ID_Obj].bParam[6] or ObjZav[ID_Obj].bParam[7]) or
             (ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[2]) then
          begin // отменить маневровый
            if ObjZav[ID_Obj].bParam[2] then
            begin // если сигнал открыт - проверить допустимость отмены маршрута
              msg := GetSoglOtmeny(ObjZav[ID_Obj].ObjConstI[19]);
              if msg <> '' then begin PutShortMsg(1,LastX,LastY,msg);  exit; end;
            end;
            InsArcNewMsg(ID_Obj,175+$4000);
            msg := '';
            case GetIzvestitel(ID_Obj,MarshM) of
              1 : begin msg := GetShortMsg(1,329, '') + ' '; InsArcNewMsg(ID_Obj,329+$5000); end;
              2 : begin msg := GetShortMsg(1,330, '') + ' '; InsArcNewMsg(ID_Obj,330+$5000); end;
              3 : begin msg := GetShortMsg(1,331, '') + ' '; InsArcNewMsg(ID_Obj,331+$5000); end;
            end;
            msg := msg + GetShortMsg(1,175, 'от ' + ObjZav[ID_Obj].Liter);
            DspCommand.Command := CmdMenu_OtmenaManevrovogo; DspCommand.Obj := ID_Obj;
          end else
          if ObjZav[ID_Obj].ObjConstB[2] and
             (ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[9]) or
             (ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4]) then
          begin // отменить поездной
            if ObjZav[ID_Obj].bParam[4] then
            begin // если сигнал открыт - проверить допустимость отмены маршрута
              msg := GetSoglOtmeny(ObjZav[ID_Obj].ObjConstI[16]);
              if msg <> '' then begin PutShortMsg(1,LastX,LastY,msg); exit; end;
            end;
            InsArcNewMsg(ID_Obj,176+$4000);
            msg := '';
            case GetIzvestitel(ID_Obj,MarshP) of
              1 : begin msg := GetShortMsg(1,329, '') + ' '; InsArcNewMsg(ID_Obj,329+$5000); end;
              2 : begin msg := GetShortMsg(1,330, '') + ' '; InsArcNewMsg(ID_Obj,330+$5000); end;
              3 : begin msg := GetShortMsg(1,331, '') + ' '; InsArcNewMsg(ID_Obj,331+$5000); end;
            end;
            msg := msg + GetShortMsg(1,176, 'от ' + ObjZav[ID_Obj].Liter);
            DspCommand.Command := CmdMenu_OtmenaPoezdnogo; DspCommand.Obj := ID_Obj;
          end else
// Только для РПЦ
          if not ObjZav[ID_Obj].bParam[14] and not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] then
          begin // Если нет признаков трассировки маршрута или перекрывная секция замкнута - выбрать категорию отменяемого маршрута
            if ObjZav[ID_Obj].ObjConstB[2] and ObjZav[ID_Obj].ObjConstB[3] then
            begin // выбрать категорию отмены (аварийно)
              InsArcNewMsg(ID_Obj,175+$4000);
              InsArcNewMsg(ID_Obj,176+$4000);
              AddDspMenuItem('Нет начала маршрута! '+ GetShortMsg(1,175, ''), CmdMenu_OtmenaManevrovogo,ID_Obj);
              AddDspMenuItem('Нет начала маршрута! '+ GetShortMsg(1,176, ''), CmdMenu_OtmenaPoezdnogo,ID_Obj);
            end else
            if ObjZav[ID_Obj].ObjConstB[3] then
            begin // отменить маневровый (аварийно)
              InsArcNewMsg(ID_Obj,175+$4000);
              msg := 'Нет начала маршрута! '+ GetShortMsg(1,175, 'от ' + ObjZav[ID_Obj].Liter);
              DspCommand.Command := CmdMenu_OtmenaManevrovogo; DspCommand.Obj := ID_Obj;
            end else
            if ObjZav[ID_Obj].ObjConstB[2] then
            begin // отменить поездной (аварийно)
              InsArcNewMsg(ID_Obj,176+$4000);
              msg := 'Нет начала маршрута! '+ GetShortMsg(1,176, 'от ' + ObjZav[ID_Obj].Liter);
              DspCommand.Command := CmdMenu_OtmenaPoezdnogo; DspCommand.Obj := ID_Obj;
            end else
              exit;
          end else
// конец фрагмента для РПЦ
            exit;
        end else
        if ObjZav[ID_Obj].bParam[23] or ((ObjZav[ID_Obj].bParam[5] or ObjZav[ID_Obj].bParam[15] or ObjZav[ID_Obj].bParam[17] or
           ObjZav[ID_Obj].bParam[24] or ObjZav[ID_Obj].bParam[25] or ObjZav[ID_Obj].bParam[26]) and
          not ObjZav[ID_Obj].bParam[20] and not WorkMode.GoTracert) then
        begin // снять мигание при неисправности
          ObjZav[ID_Obj].bParam[23] := false; ObjZav[ID_Obj].bParam[20] := true; exit;
        end else

        if not ObjZav[ID_Obj].bParam[31] then
        begin // нет данных в канале
          InsArcNewMsg(ID_Obj,310+$4000); VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(310, LastX, LastY, ObjZav[ID_Obj].Liter); exit;
        end else

        if ObjZav[ID_Obj].bParam[13] and not WorkMode.GoTracert then
        begin // светофор заблокирован
          InsArcNewMsg(ID_Obj,123+$4000);
          ShowShortMsg(123,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
        end else
        if CheckAutoON(ObjZav[ID_Obj].ObjConstI[28]) then
        begin // Включено автодействия сигнала
          InsArcNewMsg(ID_Obj,431+$4000);
          ShowShortMsg(431,LastX,LastY, ObjZav[ID_Obj].Liter); exit;
        end else
        if WorkMode.MarhUpr then
        begin // режим маршрутного управления
          if CheckMaket then
          begin // макет установлен не полностью - блокировать маршрутный набор
            InsArcNewMsg(ID_Obj,344+$4000);
            ShowShortMsg(344,LastX,LastY,ObjZav[ID_Obj].Liter); SingleBeep := true; ShowWarning := true; exit;
          end else
          if WorkMode.GoTracert then
          begin // выбор промежуточной точки
            DspCommand.Active  := true; DspCommand.Command := CmdMarsh_Tracert; DspCommand.Obj := ID_Obj; exit;
          end else
          if CheckProtag(ID_Obj) then
          begin // Открыть сигнал для протяжки (перезамыкание поездного маршрута маневровым)
            InsArcNewMsg(ID_Obj,416+$4000);
            msg := GetShortMsg(1,416, ObjZav[ID_Obj].Liter);
          end else
          begin // Проверить допустимость открытия сигнала
            if ObjZav[ID_Obj].bParam[2] or ObjZav[ID_Obj].bParam[4] then
            begin // открыт сигнал
              InsArcNewMsg(ID_Obj,230+$4000);
              ShowShortMsg(230,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end else
            if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[3] then
            begin // сигнал на выдержке времени
              InsArcNewMsg(ID_Obj,402+$4000);
              ShowShortMsg(402,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end else
            if ObjZav[ID_Obj].bParam[6] or ObjZav[ID_Obj].bParam[7] then
            begin
              if ObjZav[ID_Obj].bParam[11] then
              begin
              // проверить условия допустимости повтора маневрового маршрута
                if ObjZav[ID_Obj].ObjConstI[17] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
                if ObjZav[ID_Obj].ObjConstI[18] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
                if u1 or u2 then
                begin // выдать команду повтора маневрового маршрута
                  InsArcNewMsg(ID_Obj,177+$4000);
                  msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorManevrMarsh; DspCommand.Obj := ID_Obj;
                end else
                begin // отказ от начала трассировки

                  PutShortMsg(1,LastX,LastY,msg); exit;
                end;

              end else
              begin // Признак НМ, сигнал закрыт - повторное открытие маневрового
                if ObjZav[ID_Obj].ObjConstI[17] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
                if ObjZav[ID_Obj].ObjConstI[18] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
                if u1 or u2 then
                begin // выдать команду начала трассировки
                  InsArcNewMsg(ID_Obj,177+$4000);
                  msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorManevrovogo; DspCommand.Obj := ID_Obj;
                end else
                begin // отказ от начала трассировки

                  PutShortMsg(1,LastX,LastY,msg); exit;
                end;
              end;
            end else
            if ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[9] then
            begin
              if ObjZav[ID_Obj].bParam[11] then
              begin
              //проверить условия допустимости повтора поездного маршрута
                if ObjZav[ID_Obj].ObjConstI[14] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); u1 := msg = ''; end else u1 := true;
                if ObjZav[ID_Obj].ObjConstI[15] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
                if u1 or u2 then
                begin // выдать команду повтора поездного маршрута
                  InsArcNewMsg(ID_Obj,178+$4000);
                  msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorPoezdMarsh; DspCommand.Obj := ID_Obj;
                end else
                begin // отказ от начала трассировки

                  PutShortMsg(1,LastX,LastY,msg); exit;
                end;

              end else
              begin // Признак Н, сигнал закрыт - повторное открытие поездного
                if ObjZav[ID_Obj].ObjConstI[14] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); u1 := msg = ''; end else u1 := true;
                if ObjZav[ID_Obj].ObjConstI[15] > 0 then
                begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
                if u1 or u2 then
                begin // выдать команду начала трассировки
                  InsArcNewMsg(ID_Obj,178+$4000);
                  msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorPoezdnogo; DspCommand.Obj := ID_Obj;
                end else
                begin // отказ от начала трассировки

                  PutShortMsg(1,LastX,LastY,msg); exit;
                end;
              end;
            end else
            if ObjZav[ID_Obj].bParam[14] or ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] or
              not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[2] or not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[7] or
              not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[8] then
            begin // предварительное замыкание враждебного маршрута на РМ-ДСП
              InsArcNewMsg(ID_Obj,328+$4000);
              ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end else
            if ObjZav[ID_Obj].ObjConstB[2] and ObjZav[ID_Obj].ObjConstB[3] then
            begin // Выбрать категорию маршрута
              if ObjZav[ID_Obj].ObjConstI[14] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[15] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
              uo := u1 or u2;
              if ObjZav[ID_Obj].ObjConstI[17] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[18] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
              if uo and (u1 or u2) then
              begin
                InsArcNewMsg(ID_Obj,181+$4000);
                InsArcNewMsg(ID_Obj,182+$4000);
                AddDspMenuItem(GetShortMsg(1,181, ''), CmdMenu_BeginMarshManevr,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,182, ''), CmdMenu_BeginMarshPoezd,ID_Obj);
              end else
              if uo then
              begin // трассировать поездной
                InsArcNewMsg(ID_Obj,182+$4000);
                msg := GetShortMsg(1,182, 'от ' + ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_BeginMarshPoezd; DspCommand.Obj := ID_Obj;
              end else
              if u1 or u2 then
              begin // трассировать маневровый
                InsArcNewMsg(ID_Obj,181+$4000);
                msg := GetShortMsg(1,181, 'от ' + ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_BeginMarshManevr; DspCommand.Obj := ID_Obj;
              end else
              begin // отказ от трассировки из-за отсутствия разрешения начальных признаков
                InsArcNewMsg(ID_Obj,328+$4000);
                ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
              end;
            end else
            if ObjZav[ID_Obj].ObjConstB[2] then
            begin // Запрос начала поездного маршрута
              if ObjZav[ID_Obj].ObjConstI[14] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[15] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
              if u1 or u2 then
              begin // выдать команду начала трассировки
                InsArcNewMsg(ID_Obj,182+$4000);
                msg := GetShortMsg(1,182, 'от ' + ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_BeginMarshPoezd; DspCommand.Obj := ID_Obj;
              end else
              begin // отказ от начала трассировки

                PutShortMsg(1,LastX,LastY,msg); exit;
              end;
            end else
            if ObjZav[ID_Obj].ObjConstB[3] then
            begin // Запрос начала маневрового маршрута
              if ObjZav[ID_Obj].ObjConstI[17] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[18] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
              if u1 or u2 then
              begin // выдать команду начала трассировки
                InsArcNewMsg(ID_Obj,181+$4000);
                msg := GetShortMsg(1,181, 'от ' + ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_BeginMarshManevr; DspCommand.Obj := ID_Obj;
              end else
              begin // отказ от начала трассировки

                PutShortMsg(1,LastX,LastY,msg); exit;
              end;
            end;
          end;
        end else
        begin // режим раздельного управления
          if ObjZav[ID_Obj].bParam[2] or ObjZav[ID_Obj].bParam[4] then
          begin // открыт сигнал
            InsArcNewMsg(ID_Obj,230+$4000);
            ShowShortMsg(230,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end else
          if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[3] then
          begin // сигнал на выдержке времени
            InsArcNewMsg(ID_Obj,402+$4000);
            ShowShortMsg(402,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end else
          if CheckProtag(ID_Obj) then
          begin // Открыть сигнал для протяжки (перезамыкание поездного маршрута маневровым)
            InsArcNewMsg(ID_Obj,416+$4000);
            msg := GetShortMsg(1,416, ObjZav[ID_Obj].Liter);
          end else
          if ObjZav[ID_Obj].bParam[6] or ObjZav[ID_Obj].bParam[7] then
          begin
            if ObjZav[ID_Obj].bParam[11] then
            begin
            // проверить условия допустимости повтора маневрового маршрута
              if Marhtracert[1].LockPovtor then
              begin
                ResetTrace; exit;
              end;
              if ObjZav[ID_Obj].ObjConstI[17] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[18] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
              if u1 or u2 then
              begin // выдать команду повтора маневрового маршрута
                InsArcNewMsg(ID_Obj,173+$4000);
                msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PovtorOtkrytManevr; DspCommand.Obj := ID_Obj;
              end else
              begin // отказ от начала трассировки

                PutShortMsg(1,LastX,LastY,msg); exit;
              end;

            end else
            begin // Признак НМ, сигнал закрыт - повторное открытие маневрового
              if ObjZav[ID_Obj].ObjConstI[17] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[18] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
              if u1 or u2 then
              begin // выдать команду начала трассировки
                InsArcNewMsg(ID_Obj,177+$4000);
                msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorManevrovogo; DspCommand.Obj := ID_Obj;
              end else
              begin // отказ от начала трассировки

                PutShortMsg(1,LastX,LastY,msg); exit;
              end;
            end;
          end else
          if ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[9] then
          begin
            if ObjZav[ID_Obj].bParam[11] then
            begin
            // проверить условия допустимости повтора поездного маршрута
              if Marhtracert[1].LockPovtor then
              begin
                ResetTrace; exit;
              end;
              if ObjZav[ID_Obj].ObjConstI[14] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[15] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
              if u1 or u2 then
              begin // выдать команду повтора поездного маршрута
                InsArcNewMsg(ID_Obj,174+$4000);
                msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PovtorOtkrytPoezd; DspCommand.Obj := ID_Obj;
              end else
              begin // отказ от начала трассировки

                PutShortMsg(1,LastX,LastY,msg); exit;
              end;

            end else
            begin // Признак Н, сигнал закрыт - повторное открытие поездного
              if ObjZav[ID_Obj].ObjConstI[14] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);u1 := msg = ''; end else u1 := true;
              if ObjZav[ID_Obj].ObjConstI[15] > 0 then
              begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
              if u1 or u2 then
              begin // выдать команду начала трассировки
                InsArcNewMsg(ID_Obj,178+$4000);
                msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorPoezdnogo; DspCommand.Obj := ID_Obj;
              end else
              begin // отказ от начала трассировки

                PutShortMsg(1,LastX,LastY,msg); exit;
              end;
            end;
          end else
          if ObjZav[ID_Obj].bParam[14] or ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] or
            not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[2] or not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[7] or
            not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[8] then
          begin // предварительное замыкание враждебного маршрута на РМ-ДСП
            InsArcNewMsg(ID_Obj,328+$4000);
            ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end else
          if ObjZav[ID_Obj].ObjConstB[2] and ObjZav[ID_Obj].ObjConstB[3] then
          begin // Выбрать категорию маршрута
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); u1 := msg = ''; end else u1 := true;
            if ObjZav[ID_Obj].ObjConstI[15] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
            uo := u1 or u2;
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
            if ObjZav[ID_Obj].ObjConstI[18] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
            if uo and (u1 or u2) then
            begin
              InsArcNewMsg(ID_Obj,173+$4000);
              InsArcNewMsg(ID_Obj,174+$4000);
              AddDspMenuItem(GetShortMsg(1,173, ''), CmdMenu_OtkrytManevrovym,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,174, ''), CmdMenu_OtkrytPoezdnym,ID_Obj);
            end else
            if uo then
            begin // открыть поездной
              InsArcNewMsg(ID_Obj,174+$4000);
              msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtkrytPoezdnym; DspCommand.Obj := ID_Obj;
            end else
            if u1 or u2 then
            begin // открыть маневровый
              InsArcNewMsg(ID_Obj,173+$4000);
              msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtkrytManevrovym; DspCommand.Obj := ID_Obj;
            end else
            begin // отказ из-за отсутствия разрешения начальных признаков
              InsArcNewMsg(ID_Obj,328+$4000);
              ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end;
          end else
          if ObjZav[ID_Obj].ObjConstB[2] then
          begin // Запрос открытия поездным
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);u1 := msg = ''; end else u1 := true;
            if ObjZav[ID_Obj].ObjConstI[15] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
            if u1 or u2 then
            begin // выдать команду начала трассировки
              InsArcNewMsg(ID_Obj,174+$4000);
              msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtkrytPoezdnym; DspCommand.Obj := ID_Obj;
            end else
            begin // отказ от начала трассировки

              PutShortMsg(1,LastX,LastY,msg); exit;
            end;
          end else
          if ObjZav[ID_Obj].ObjConstB[3] then
          begin // Запрос открытия маневровым
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); u1 := msg = ''; end else u1 := true;
            if ObjZav[ID_Obj].ObjConstI[18] > 0 then
            begin msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); u2 := msg = ''; end else u2 := false;
            if u1 or u2 then
            begin // выдать команду начала трассировки
              InsArcNewMsg(ID_Obj,173+$4000);
              msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtkrytManevrovym; DspCommand.Obj := ID_Obj;
            end else
            begin // отказ от начала трассировки

              PutShortMsg(1,LastX,LastY,msg); exit;
            end;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_AutoSvetofor : begin // управление автодействием светофоров
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        ResetCommands;
        InsArcNewMsg(ID_Obj,283+$4000);
        ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin // Сбросить набор маршрута
        ResetTrace; DspCommand.Command := 0; exit;
      end else
      if WorkMode.MarhOtm then
      begin // отмена -
        if ObjZav[ID_Obj].bParam[1] then
        begin // отключить автодействие
          InsArcNewMsg(ID_Obj,420+$4000);
          WorkMode.MarhOtm := false; msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_AutoMarshOtkl; DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ID_Obj,408+$4000); ShowShortMsg(408,LastX,LastY,''); WorkMode.MarhOtm := false; exit;
        end;
      end else
      begin
        if ObjZav[ID_Obj].bParam[1] then
        begin // отключить автодействие
          InsArcNewMsg(ID_Obj,420+$4000);
          WorkMode.MarhOtm := false; msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_AutoMarshOtkl; DspCommand.Obj := ID_Obj;
        end else
        begin // включить автодействие
          InsArcNewMsg(ID_Obj,419+$4000);
          WorkMode.MarhOtm := false; msg := GetShortMsg(1,419, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_AutoMarshVkl; DspCommand.Obj := ID_Obj;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_VydachaPSoglasiya : begin// Поездное согласие на соседний пост
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      i := ID_Obj;
      if WorkMode.OtvKom then
      begin // нажата ОК - нормализовать признаки трассировки для светофора
        InsArcNewMsg(ObjZav[i].BaseObject,311+$4000);
        msg := GetShortMsg(1,311, ObjZav[ObjZav[i].BaseObject].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ObjZav[i].BaseObject;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      begin // нормальный режим
        if WorkMode.InpOgr then
        begin // ввод ограничений
          exit;
        end else
        if ObjZav[ObjZav[i].BaseObject].bParam[18] then
        begin // на местном управлении
          InsArcNewMsg(ObjZav[i].BaseObject,232+$4000);
          WorkMode.GoMaketSt := false; ShowShortMsg(232,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
        end else
        if WorkMode.MarhOtm then
        begin // отмена маршрутов для всех режимов управления сигналами
          if ObjZav[ObjZav[i].BaseObject].bParam[8] or ObjZav[ObjZav[i].BaseObject].bParam[9] or ObjZav[ObjZav[i].BaseObject].bParam[3] or ObjZav[ObjZav[i].BaseObject].bParam[4] then
          begin
            if ObjZav[ObjZav[i].BaseObject].bParam[3] or ObjZav[ObjZav[i].BaseObject].bParam[4] then
            begin // отменить поездной, сигнал открыт
              if ObjZav[i].UpdateObject > 0 then
              begin // увязка через путь
                if ObjZav[ObjZav[i].UpdateObject].bParam[2] and ObjZav[ObjZav[i].UpdateObject].bParam[3] then
                begin // нет замыкания на увязочном пути - дать отмену
                  InsArcNewMsg(ObjZav[i].BaseObject,184+$4000);
                  msg := GetShortMsg(1,184, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter);
                  DspCommand.Command := CmdMenu_OtmenaPoezdnogo; DspCommand.Obj := ObjZav[i].BaseObject;
                end else
                begin
                  InsArcNewMsg(ObjZav[i].BaseObject,254+$4000);
                  ShowShortMsg(254,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
                end;
              end else
              begin // увязка по светофорам в створе
                if ObjZav[i].bParam[2] then
                begin // замкнут маршрут до сигнала
                  InsArcNewMsg(ID_Obj,254+$4000);
                  ShowShortMsg(254,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
                end else
                begin // не замкнут маршрут до сигнала
                  InsArcNewMsg(ObjZav[i].BaseObject,184+$4000);
                  msg := GetShortMsg(1,184, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter);
                  DspCommand.Command := CmdMenu_OtmenaPoezdnogo; DspCommand.Obj := ObjZav[i].BaseObject;
                end;
              end;
            end else
            begin // сигнал на противоповторке - выдать команду без проверки замыкания маршрута до сигнала
              InsArcNewMsg(ObjZav[i].BaseObject,184+$4000);
              msg := GetShortMsg(1,184, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter);
              DspCommand.Command := CmdMenu_OtmenaPoezdnogo; DspCommand.Obj := ObjZav[i].BaseObject;
            end;
          end;
        end else
        if ObjZav[ObjZav[i].BaseObject].bParam[13] and not WorkMode.GoTracert then
        begin // светофор заблокирован
          InsArcNewMsg(ObjZav[i].BaseObject,123+$4000);
          ShowShortMsg(123,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
        end else
        if WorkMode.MarhUpr then
        begin // режим маршрутного управления
          if CheckMaket then
          begin // макет установлен не полностью - блокировать маршрутный набор
            InsArcNewMsg(ID_Obj,344+$4000);
            ShowShortMsg(344,LastX,LastY,ObjZav[ID_Obj].Liter); SingleBeep := true; ShowWarning := true; exit;
          end else
          if WorkMode.CmdReady then
          begin // передача маршрута в сервер - отказ маршрутных операций
            InsArcNewMsg(ID_Obj,239+$4000);
            ShowShortMsg(239,LastX,LastY,''); exit;
          end else
          if WorkMode.GoTracert then
          begin // выбор промежуточной точки
            DspCommand.Active  := true; DspCommand.Command := CmdMarsh_Tracert; DspCommand.Obj := ObjZav[i].BaseObject; exit;
          end else
          begin // Проверить допустимость открытия сигнала
            if ObjZav[i].bParam[1] then
            begin // нажата кнопка ЭГС
              InsArcNewMsg(ObjZav[i].BaseObject,105+$4000); ShowShortMsg(105,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
            end else
            if ObjZav[ObjZav[i].BaseObject].bParam[1] or ObjZav[ObjZav[i].BaseObject].bParam[2] or
               ObjZav[ObjZav[i].BaseObject].bParam[3] or ObjZav[ObjZav[i].BaseObject].bParam[4] then
            begin // открыт сигнал
              InsArcNewMsg(ObjZav[i].BaseObject,230+$4000); ShowShortMsg(230,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
            end else
            if ObjZav[ObjZav[i].BaseObject].bParam[7] then
            begin // маневры - отказ
              exit;
            end else
            if ObjZav[ObjZav[i].BaseObject].bParam[9] then
            begin
              if ObjZav[ObjZav[i].BaseObject].bParam[11] then
              begin // перекрывная секция не замкнута - отказ от повторного открытия
                InsArcNewMsg(ObjZav[i].BaseObject,229+$4000); ShowShortMsg(229,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
              end else
              begin // Признак Н, сигнал закрыт - повторное открытие поездного
                InsArcNewMsg(ObjZav[i].BaseObject,178+$4000); msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter);
                DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorPoezdnogo; DspCommand.Obj := ObjZav[i].BaseObject;
              end;
            end else
            if ObjZav[ID_Obj].bParam[14] then
            begin // предварительное замыкание маршрута на РМ-ДСП
              //проверить условия допустимости повтора поездного маршрута
                if ObjZav[ObjZav[i].BaseObject].ObjConstI[14] > 0 then
                begin msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[14]); u1 := msg = ''; end else u1 := true;
                if ObjZav[ObjZav[i].BaseObject].ObjConstI[15] > 0 then
                begin msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
                if u1 or u2 then
                begin // выдать команду повтора поездного маршрута
                  InsArcNewMsg(ObjZav[i].BaseObject,178+$4000);
                  msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter); DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorPoezdMarsh; DspCommand.Obj := ID_Obj;
                end else
                begin // отказ от начала трассировки

                  PutShortMsg(1,LastX,LastY,msg); exit;
                end;

            end else
            begin // Запрос начала поездного маршрута
              InsArcNewMsg(ObjZav[i].BaseObject,183+$4000); msg := GetShortMsg(1,183, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter);
              DspCommand.Active := true; DspCommand.Command := CmdMenu_BeginMarshPoezd; DspCommand.Obj := ObjZav[i].BaseObject;
            end;
          end;
        end else
        begin // режим раздельного управления
          if ObjZav[i].bParam[1] then
          begin // нажата кнопка ЭГС
            InsArcNewMsg(ObjZav[i].BaseObject,105+$4000); ShowShortMsg(105,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
          end else
          if ObjZav[ObjZav[i].BaseObject].bParam[1] or ObjZav[ObjZav[i].BaseObject].bParam[2] or
             ObjZav[ObjZav[i].BaseObject].bParam[3] or ObjZav[ObjZav[i].BaseObject].bParam[4] then
          begin // открыт сигнал
            InsArcNewMsg(ObjZav[i].BaseObject,230+$4000);
            ShowShortMsg(230,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
          end else
          if ObjZav[ObjZav[i].BaseObject].bParam[9] then
          begin
            if ObjZav[ObjZav[i].BaseObject].bParam[11] then
            begin // перекрывная секция не замкнута - отказ от повторного открытия
              InsArcNewMsg(ObjZav[i].BaseObject,229+$4000);
              ShowShortMsg(229,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
            end else
            begin // Признак Н, сигнал закрыт - повторное открытие поездного
              InsArcNewMsg(ObjZav[i].BaseObject,178+$4000);
              msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter);
              DspCommand.Active := true; DspCommand.Command := CmdMenu_PovtorPoezdnogo; DspCommand.Obj := ObjZav[i].BaseObject;
            end;
          end else
          if ObjZav[i].bParam[14] then
          begin // предварительное замыкание маршрута на РМ-ДСП
          // проверить условия допустимости повтора поездного маршрута
            if Marhtracert[1].LockPovtor then
            begin
              ResetTrace; exit;
            end;
            if ObjZav[ObjZav[i].BaseObject].ObjConstI[14] > 0 then
            begin msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[14]);u1 := msg = ''; end else u1 := true;
            if ObjZav[ObjZav[i].BaseObject].ObjConstI[15] > 0 then
            begin msg := CheckStartTrace(ObjZav[ObjZav[i].BaseObject].ObjConstI[15]); u2 := msg = ''; end else u2 := false;
            if u1 or u2 then
            begin // выдать команду повтора поездного маршрута
              InsArcNewMsg(ObjZav[i].BaseObject,174+$4000);
              msg := GetShortMsg(1,174, ObjZav[ObjZav[i].BaseObject].Liter); DspCommand.Command := CmdMenu_PovtorOtkrytPoezd; DspCommand.Obj := ID_Obj;
            end else
            begin // отказ от начала трассировки

              PutShortMsg(1,LastX,LastY,msg); exit;
            end;

          end else
          begin // Запрос открытия поездным
            InsArcNewMsg(ObjZav[i].BaseObject,183+$4000); msg := GetShortMsg(1,183, ObjZav[ObjZav[i].BaseObject].Liter);
            DspCommand.Command := CmdMenu_OtkrytPoezdnym; DspCommand.Obj := ObjZav[i].BaseObject;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_Nadvig : // Надвиг на горку
    begin
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.OtvKom then
      begin // нажата ОК - нормализовать признаки трассировки для светофора
          InsArcNewMsg(ID_Obj,311+$4000);
          msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ID_Obj;
      end else
      begin
        if WorkMode.InpOgr then
        begin // ввод ограничений
          if ObjZav[ID_Obj].bParam[13] then
          begin // разблокировать светофор
            InsArcNewMsg(ID_Obj,180+$4000);
            msg := GetShortMsg(1,180, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DeblokirovkaNadviga; DspCommand.Obj := ID_Obj;
          end else
          begin // заблокировать светофор
            InsArcNewMsg(ID_Obj,179+$4000);
            msg := GetShortMsg(1,179, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_BlokirovkaNadviga; DspCommand.Obj := ID_Obj;
          end;
        end else
        if ObjZav[ID_Obj].bParam[13] then
        begin // светофор заблокирован
          InsArcNewMsg(ID_Obj,123+$4000);
          ShowShortMsg(123,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
        end else
        if WorkMode.MarhUpr then
        begin // режим маршрутного управления
          if WorkMode.CmdReady then
          begin // передача маршрута в сервер - отказ маршрутных операций
            InsArcNewMsg(ID_Obj,239+$4000);
            ShowShortMsg(239,LastX,LastY,''); exit;
          end else
          if WorkMode.GoTracert then
          begin // выбор промежуточной точки
            DspCommand.Active  := true; DspCommand.Command := CmdMarsh_Tracert; DspCommand.Obj := ID_Obj; exit;
          end else
            exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_Uchastok : begin// Участок стрелочный и бесстрелочный
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      begin // нормальный режим
        if ObjZav[ID_Obj].bParam[19] then
        begin // Восприятие диагностического сообщения
          ObjZav[ID_Obj].bParam[19] := false; exit;
        end else
        if ObjZav[ID_Obj].bParam[9] or not ObjZav[ID_Obj].bParam[5] then
        begin // на местном управлении
          InsArcNewMsg(ID_Obj,233+$4000);
          WorkMode.GoMaketSt := false; ShowShortMsg(233,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
        end else
        if WorkMode.InpOgr then
        begin // ввод ограничений
          if ObjZav[ID_Obj].bParam[33] then
          begin // включено автодействие
            InsArcNewMsg(ID_Obj,431+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(431, LastX, LastY, ''); exit;
          end else
          if not ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[14] then
          begin // секция в трассе маршрута
            InsArcNewMsg(ID_Obj,512+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(512, LastX, LastY, ObjZav[ID_Obj].Liter); exit;
          end else
          begin
            if ObjZav[ID_Obj].ObjConstB[8] or ObjZav[ID_Obj].ObjConstB[9] then // есть закрытие движения на электротяге
            begin
            // закрытие движения
              if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                InsArcNewMsg(ID_Obj,171+$4000);
                AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_SekciaZakrytDvijenie,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_SekciaOtkrytDvijenie,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,171+$4000);
                AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_SekciaOtkrytDvijenie,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_SekciaZakrytDvijenie,ID_Obj);
              end;
            // закрытие движения на электротяге
              if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
              begin
                InsArcNewMsg(ID_Obj,458+$4000);
                InsArcNewMsg(ID_Obj,459+$4000);
                AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_SekciaZakrytDvijenieET,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_SekciaOtkrytDvijenieET,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[27] then
              begin
                InsArcNewMsg(ID_Obj,459+$4000);
                AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_SekciaOtkrytDvijenieET,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,458+$4000);
                AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_SekciaZakrytDvijenieET,ID_Obj);
              end;
              if ObjZav[ID_Obj].ObjConstB[8] and ObjZav[ID_Obj].ObjConstB[9] then // есть 2 вида электротяги
              begin
            // закрытие движения на электротяге постоянного тока
                if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
                begin
                  InsArcNewMsg(ID_Obj,463+$4000);
                  InsArcNewMsg(ID_Obj,464+$4000);
                  AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_SekciaZakrytDvijenieETD,ID_Obj);
                  AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_SekciaOtkrytDvijenieETD,ID_Obj);
                end else
                if ObjZav[ID_Obj].bParam[28] then
                begin
                  InsArcNewMsg(ID_Obj,464+$4000);
                  AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_SekciaOtkrytDvijenieETD,ID_Obj);
                end else
                begin
                  InsArcNewMsg(ID_Obj,463+$4000);
                  AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_SekciaZakrytDvijenieETD,ID_Obj);
                end;
            // закрытие движения на электротяге переменного тока
                if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
                begin
                  InsArcNewMsg(ID_Obj,468+$4000);
                  InsArcNewMsg(ID_Obj,469+$4000);
                  AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_SekciaZakrytDvijenieETA,ID_Obj);
                  AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_SekciaOtkrytDvijenieETA,ID_Obj);
                end else
                if ObjZav[ID_Obj].bParam[29] then
                begin
                  InsArcNewMsg(ID_Obj,469+$4000);
                  AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_SekciaOtkrytDvijenieETA,ID_Obj);
                end else
                begin
                  InsArcNewMsg(ID_Obj,468+$4000);
                  AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_SekciaZakrytDvijenieETA,ID_Obj);
                end;
              end;
            end else
            begin // нет электротяги
              if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                InsArcNewMsg(ID_Obj,171+$4000);
                AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_SekciaZakrytDvijenie,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_SekciaOtkrytDvijenie,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,171+$4000);
                msg := GetShortMsg(1,171, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SekciaOtkrytDvijenie; DspCommand.Obj := ID_Obj;
              end else
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                msg := GetShortMsg(1,170, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SekciaZakrytDvijenie; DspCommand.Obj := ID_Obj;
              end;
            end;
          end;
        end else

        if not ObjZav[ID_Obj].bParam[31] then
        begin // нет данных в канале
          InsArcNewMsg(ID_Obj,293+$4000); VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(293, LastX, LastY, ObjZav[ID_Obj].Liter); exit;
        end else

        if WorkMode.GoTracert then
        begin // выбор промежуточной точки
          DspCommand.Active  := true; DspCommand.Command := CmdMarsh_Tracert; DspCommand.Obj := ID_Obj; exit;
        end else
        if WorkMode.OtvKom then
        begin // Нажата кнопка ответственных команд
          if ObjZav[ID_Obj].ObjConstB[7] then
          begin // для секции в составе сегмента выдать команду искусственного размыкания сегмента
            if WorkMode.GoOtvKom then
            begin // исполнительная команда
              OtvCommand.SObj := ID_Obj;
              InsArcNewMsg(ID_Obj,214+$4000);
              msg := GetShortMsg(1,214, ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspCommand.Command := CmdMenu_SekciaIspolnitRI; DspCommand.Obj := ID_Obj;
            end else
            if ObjZav[ID_Obj].bParam[2] then
            begin // секция разомкнута - нормализовать признаки трассировки для секции
              InsArcNewMsg(ID_Obj,311+$4000);
              msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ID_Obj;
            end else
            begin // секция замкнута
              if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1] then
              begin // выполняется ИР сегмента - отказать
                InsArcNewMsg(ID_Obj,335+$4000);
                ShowShortMsg(335,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); SingleBeep := true; exit;
              end else
              begin // выдать предварительныю команду ИР сегмента
                InsArcNewMsg(ID_Obj,185+$4000);
                msg := GetShortMsg(1,185, ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspCommand.Command := CmdMenu_SekciaPredvaritRI; DspCommand.Obj := ID_Obj;
              end;
            end;
          end else
          begin // для секции при посекционном размыкании выдать команду выбора секции для РИ
            if WorkMode.GoOtvKom then
            begin // исполнительная команда
              OtvCommand.SObj := ID_Obj;
              InsArcNewMsg(ID_Obj,186+$4000);
              msg := GetShortMsg(1,186, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SekciaIspolnitRI; DspCommand.Obj := ID_Obj;
            end else
            begin // предварительная команда
              if ObjZav[ID_Obj].bParam[2] then
              begin // секция разомкнута - нормализовать признаки трассировки для секции
                InsArcNewMsg(ID_Obj,311+$4000);
                msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ID_Obj;
              end else
              begin // секция замкнута
                if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1] then
                begin // запушена выдержка времени ГИР - отказать
                  InsArcNewMsg(ID_Obj,334+$4000);
                  AddFixMessage(GetShortMsg(1,334,ObjZav[ID_Obj].Liter),4,2); exit;
                end else
                if ObjZav[ID_Obj].bParam[3] then
                begin // Выполняется иск.размыкание секции - отказать
                  InsArcNewMsg(ID_Obj,84+$4000);
                  ShowShortMsg(84,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
                end else
                begin // - предварительная команда РИ
                  InsArcNewMsg(ID_Obj,185+$4000);
                  msg := GetShortMsg(1,185, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SekciaPredvaritRI; DspCommand.Obj := ID_Obj;
                end;
              end;
            end;
          end;
        end else exit;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_PutPO : begin// Приемоотправочный путь с ограждением
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // ОК - нормализовать признаки трассировки для пути
        InsArcNewMsg(ID_Obj,311+$4000);
        msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ID_Obj;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      begin // нормальный режим
        if ObjZav[ID_Obj].bParam[19] then
        begin // Восприятие диагностического сообщения
          ObjZav[ID_Obj].bParam[19] := false; exit;
        end else
        if ObjZav[ID_Obj].bParam[9] and not WorkMode.GoTracert then
        begin // на местном управлении
          InsArcNewMsg(ID_Obj,234+$4000);
          WorkMode.GoMaketSt := false; ShowShortMsg(234,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
        end else
        if WorkMode.InpOgr then
        begin // ввод ограничений
          if ObjZav[ID_Obj].bParam[33] then
          begin // включено автодействие
            InsArcNewMsg(ID_Obj,431+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(431, LastX, LastY, ''); exit;
          end else
          if ObjZav[ID_Obj].bParam[9] then
          begin // путь на местном управлении
            InsArcNewMsg(ID_Obj,234+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(234, LastX, LastY, ObjZav[ID_Obj].Liter); exit;
          end else
          if not ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[14] then
          begin // путь в трассе маршрута
            InsArcNewMsg(ID_Obj,513+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(513, LastX, LastY, ObjZav[ID_Obj].Liter); exit;
          end else
          begin
            if ObjZav[ID_Obj].ObjConstB[8] or ObjZav[ID_Obj].ObjConstB[9] then // есть закрытие движения на электротяге
            begin
            // закрытие движения
              if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                InsArcNewMsg(ID_Obj,171+$4000);
                AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_PutZakrytDvijenie,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_PutOtkrytDvijenie,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,171+$4000);
                AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_PutOtkrytDvijenie,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_PutZakrytDvijenie,ID_Obj);
              end;
            // закрытие движения на электротяге
              if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
              begin
                InsArcNewMsg(ID_Obj,458+$4000);
                InsArcNewMsg(ID_Obj,459+$4000);
                AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_PutZakrytDvijenieET,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_PutOtkrytDvijenieET,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[27] then
              begin
                InsArcNewMsg(ID_Obj,459+$4000);
                AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_PutOtkrytDvijenieET,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,458+$4000);
                AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_PutZakrytDvijenieET,ID_Obj);
              end;
              if ObjZav[ID_Obj].ObjConstB[8] and ObjZav[ID_Obj].ObjConstB[9] then // есть 2 вида электротяги
              begin
            // закрытие движения на электротяге постоянного тока
                if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
                begin
                  InsArcNewMsg(ID_Obj,463+$4000);
                  InsArcNewMsg(ID_Obj,464+$4000);
                  AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_PutZakrytDvijenieETD,ID_Obj);
                  AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_PutOtkrytDvijenieETD,ID_Obj);
                end else
                if ObjZav[ID_Obj].bParam[28] then
                begin
                  InsArcNewMsg(ID_Obj,464+$4000);
                  AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_PutOtkrytDvijenieETD,ID_Obj);
                end else
                begin
                  InsArcNewMsg(ID_Obj,463+$4000);
                  AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_PutZakrytDvijenieETD,ID_Obj);
                end;
            // закрытие движения на электротяге переменного тока
                if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
                begin
                  InsArcNewMsg(ID_Obj,468+$4000);
                  InsArcNewMsg(ID_Obj,469+$4000);
                  AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_PutZakrytDvijenieETA,ID_Obj);
                  AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_PutOtkrytDvijenieETA,ID_Obj);
                end else
                if ObjZav[ID_Obj].bParam[29] then
                begin
                  InsArcNewMsg(ID_Obj,469+$4000);
                  AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_PutOtkrytDvijenieETA,ID_Obj);
                end else
                begin
                  InsArcNewMsg(ID_Obj,468+$4000);
                  AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_PutZakrytDvijenieETA,ID_Obj);
                end;
              end;
            end else
            begin // нет электротяги
              if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                InsArcNewMsg(ID_Obj,171+$4000);
                AddDspMenuItem(GetShortMsg(1,170, ''), CmdMenu_PutZakrytDvijenie,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,171, ''), CmdMenu_PutOtkrytDvijenie,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,171+$4000);
                msg := GetShortMsg(1,171, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PutOtkrytDvijenie; DspCommand.Obj := ID_Obj;
              end else
              begin
                InsArcNewMsg(ID_Obj,170+$4000);
                msg := GetShortMsg(1,170, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PutZakrytDvijenie; DspCommand.Obj := ID_Obj;
              end;
            end;
          end;
        end else

        if not ObjZav[ID_Obj].bParam[31] then
        begin // нет данных в канале
          InsArcNewMsg(ID_Obj,294+$4000); VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(294, LastX, LastY, ObjZav[ID_Obj].Liter); exit;
        end else

        if WorkMode.GoTracert then // режим маршрутного управления
        begin // выбор промежуточной точки
          DspCommand.Active := true; DspCommand.Command := CmdMarsh_Tracert; DspCommand.Obj := ID_Obj; result := false; exit;
        end else
        begin
          i := ObjZav[ID_Obj].UpdateObject;
          if i > 0 then
          begin // есть ограждение пути
            if ObjZav[i].Timers[1].Active and not ObjZav[i].bParam[4] then
            begin // снять мигающую индикацию неисправности ОГ
              ObjZav[i].bParam[4] := true; exit;
            end else
            if ObjZav[i].bParam[1] and not ObjZav[i].bParam[2] then
            begin // если есть запрос ПТО - проверить условия выдачи согласия ограждения
              if SoglasieOG(ID_Obj) then
              begin // нет маршрутов на/с путь - выдать согласие
                InsArcNewMsg(ID_Obj,187+$4000);
                msg := GetShortMsg(1,187, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PutDatSoglasieOgrady; DspCommand.Obj := ID_Obj;
              end else
              begin // есть маршруты на/с путь
                InsArcNewMsg(ID_Obj,393+$4000);
                ShowShortMsg(393,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
              end;
            end else exit;
          end else exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_OPI : begin // Исключение пути из маневрового района
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin // Сбросить набор маршрута
        ResetTrace; DspCommand.Command := 0; exit;
      end else
      if WorkMode.MarhOtm then
      begin // отмена -
        if ObjZav[ID_Obj].bParam[1] then
        begin // Снять исключение пути из маневрового района
{проверить возможность действия}
          InsArcNewMsg(ID_Obj,413+$4000);
          WorkMode.MarhOtm := false; msg := GetShortMsg(1,413, ObjZav[ObjZav[ID_Obj].UpdateObject].Liter); DspCommand.Command := CmdMenu_PutOtklOPI; DspCommand.Obj := ID_Obj;
        end else
        begin
          WorkMode.MarhOtm := false; exit;
        end;
      end else
      begin
        if ObjZav[ID_Obj].bParam[1] then
        begin // Снять исключение пути из маневрового района
{проверить возможность действия}
          InsArcNewMsg(ID_Obj,413+$4000);
          WorkMode.MarhOtm := false; msg := GetShortMsg(1,413, ObjZav[ObjZav[ID_Obj].UpdateObject].Liter); DspCommand.Command := CmdMenu_PutOtklOPI; DspCommand.Obj := ID_Obj;
        end else
        begin // Дать исключение пути из маневрового района
          InsArcNewMsg(ID_Obj,412+$4000);
          WorkMode.MarhOtm := false; msg := GetShortMsg(1,412, ObjZav[ObjZav[ID_Obj].UpdateObject].Liter); DspCommand.Command := CmdMenu_PutVklOPI; DspCommand.Obj := ID_Obj;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_ZaprosPSoglasiya : begin// Запрос поездного отправления на соседний пост
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin // Сбросить набор маршрута
        ResetTrace; DspCommand.Command := 0; exit;
      end else
      if WorkMode.MarhOtm then
      begin // отмена -
        if ObjZav[ID_Obj].bParam[1] then
        begin // Снять запрос отправления
          InsArcNewMsg(ID_Obj,216+$4000);
          WorkMode.MarhOtm := false; msg := GetShortMsg(1,216, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtmZaprosPoezdSoglasiya; DspCommand.Obj := ID_Obj;
        end else
        begin
          WorkMode.MarhOtm := false; exit;
        end;
      end else
      begin // нормальный режим
        if WorkMode.InpOgr then
        begin // Ввод ограничений
          if ObjZav[ID_Obj].ObjConstB[8] or ObjZav[ID_Obj].ObjConstB[9] then // есть закрытие движения на электротяге
          begin
          // закрытие движения
            if ObjZav[ID_Obj].bParam[14] <> ObjZav[ID_Obj].bParam[15] then
            begin
              InsArcNewMsg(ID_Obj,207+$4000);
              InsArcNewMsg(ID_Obj,206+$4000);
              AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytUvjazki,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytUvjazki,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[15] then
            begin
              InsArcNewMsg(ID_Obj,207+$4000);
              AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytUvjazki,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,206+$4000);
              AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytUvjazki,ID_Obj);
            end;
          // закрытие движения на электротяге
            if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
            begin
              InsArcNewMsg(ID_Obj,458+$4000);
              InsArcNewMsg(ID_Obj,459+$4000);
              AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_EZZakrytDvijenieET,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_EZOtkrytDvijenieET,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[27] then
            begin
              InsArcNewMsg(ID_Obj,459+$4000);
              AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_EZOtkrytDvijenieET,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,458+$4000);
              AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_EZZakrytDvijenieET,ID_Obj);
            end;
            if ObjZav[ID_Obj].ObjConstB[8] and ObjZav[ID_Obj].ObjConstB[9] then // есть 2 вида электротяги
            begin
          // закрытие движения на электротяге постоянного тока
              if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
              begin
                InsArcNewMsg(ID_Obj,463+$4000);
                InsArcNewMsg(ID_Obj,464+$4000);
                AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_EZZakrytDvijenieETD,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_EZOtkrytDvijenieETD,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[28] then
              begin
                InsArcNewMsg(ID_Obj,464+$4000);
                AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_EZOtkrytDvijenieETD,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,463+$4000);
                AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_EZZakrytDvijenieETD,ID_Obj);
              end;
          // закрытие движения на электротяге переменного тока
              if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
              begin
                InsArcNewMsg(ID_Obj,468+$4000);
                InsArcNewMsg(ID_Obj,469+$4000);
                AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_EZZakrytDvijenieETA,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_EZOtkrytDvijenieETA,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[29] then
              begin
                InsArcNewMsg(ID_Obj,469+$4000);
                AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_EZOtkrytDvijenieETA,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,468+$4000);
                AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_EZZakrytDvijenieETA,ID_Obj);
              end;
            end;
          end else
          begin // нет электротяги
            if ObjZav[ID_Obj].bParam[14] <> ObjZav[ID_Obj].bParam[15] then
            begin
              InsArcNewMsg(ID_Obj,207+$4000);
              InsArcNewMsg(ID_Obj,206+$4000);
              AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytUvjazki,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytUvjazki,ID_Obj);
            end else
            begin
              if ObjZav[ID_Obj].bParam[15] or ObjZav[ID_Obj].bParam[14] then
              begin // Перегон закрыт - открыть перегон
                InsArcNewMsg(ID_Obj,207+$4000);
                msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtkrytUvjazki; DspCommand.Obj := ID_Obj;
              end else
              begin // Перегон открыт - закрыть перегон
                InsArcNewMsg(ID_Obj,206+$4000);
                msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_ZakrytUvjazki; DspCommand.Obj := ID_Obj;
              end;
            end;
          end;
        end else
        begin // Запрос
          if ObjZav[ID_Obj].bParam[1] then
          begin // Снять запрос отправления
            InsArcNewMsg(ID_Obj,216+$4000);
            msg := GetShortMsg(1,216, ObjZav[ID_Obj].Liter);
            DspCommand.Command := CmdMenu_OtmZaprosPoezdSoglasiya; DspCommand.Obj := ID_Obj;
          end else
          begin // Дать запрос отправления
            InsArcNewMsg(ID_Obj,215+$4000);
            msg := GetShortMsg(1,215, ObjZav[ID_Obj].Liter);
            DspCommand.Command := CmdMenu_ZaprosPoezdSoglasiya; DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_SmenaNapravleniya : begin// Увязка с АБ
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        if (ObjZav[ID_Obj].ObjConstI[9] > 0) and // вариант с запросом согласия на смену направления
           ObjZav[ID_Obj].bParam[17] then        // Есть согласие на смену направления
        begin // сбросить согласие
          InsArcNewMsg(ID_Obj,437+$4000);
          msg := GetShortMsg(1,437, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SnatSoglasieSmenyNapr;
          DspCommand.Obj := ID_Obj; DspMenu.WC := true; goto mkmnu;
        end else
        begin
          WorkMode.MarhOtm := false; exit;
        end;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.InpOgr then
        begin // Ввод ограничений
          if ObjZav[ID_Obj].bParam[33] then
          begin // включено автодействие
            InsArcNewMsg(ID_Obj,431+$4000);
            WorkMode.InpOgr := false; ShowShortMsg(431, LastX, LastY, ''); exit;
          end else
          begin
            if ObjZav[ID_Obj].ObjConstB[8] or ObjZav[ID_Obj].ObjConstB[9] then // есть закрытие движения на электротяге
            begin
            // закрытие движения
              if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,207+$4000);
                InsArcNewMsg(ID_Obj,206+$4000);
                AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytPeregon,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytPeregon,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,207+$4000);
                AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytPeregon,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,206+$4000);
                AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytPeregon,ID_Obj);
              end;
            // закрытие движения на электротяге
              if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
              begin
                InsArcNewMsg(ID_Obj,458+$4000);
                InsArcNewMsg(ID_Obj,459+$4000);
                AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_ABZakrytDvijenieET,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_ABOtkrytDvijenieET,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[27] then
              begin
                InsArcNewMsg(ID_Obj,459+$4000);
                AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_ABOtkrytDvijenieET,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,458+$4000);
                AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_ABZakrytDvijenieET,ID_Obj);
              end;
              if ObjZav[ID_Obj].ObjConstB[8] and ObjZav[ID_Obj].ObjConstB[9] then // есть 2 вида электротяги
              begin
            // закрытие движения на электротяге постоянного тока
                if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
                begin
                  InsArcNewMsg(ID_Obj,463+$4000);
                  InsArcNewMsg(ID_Obj,464+$4000);
                  AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_ABZakrytDvijenieETD,ID_Obj);
                  AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_ABOtkrytDvijenieETD,ID_Obj);
                end else
                if ObjZav[ID_Obj].bParam[28] then
                begin
                  InsArcNewMsg(ID_Obj,464+$4000);
                  AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_ABOtkrytDvijenieETD,ID_Obj);
                end else
                begin
                  InsArcNewMsg(ID_Obj,463+$4000);
                  AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_ABZakrytDvijenieETD,ID_Obj);
                end;
            // закрытие движения на электротяге переменного тока
                if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
                begin
                  InsArcNewMsg(ID_Obj,468+$4000);
                  InsArcNewMsg(ID_Obj,469+$4000);
                  AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_ABZakrytDvijenieETA,ID_Obj);
                  AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_ABOtkrytDvijenieETA,ID_Obj);
                end else
                if ObjZav[ID_Obj].bParam[29] then
                begin
                  InsArcNewMsg(ID_Obj,469+$4000);
                  AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_ABOtkrytDvijenieETA,ID_Obj);
                end else
                begin
                  InsArcNewMsg(ID_Obj,468+$4000);
                  AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_ABZakrytDvijenieETA,ID_Obj);
                end;
              end;
            end else
            begin // нет электротяги
              if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
              begin
                InsArcNewMsg(ID_Obj,207+$4000);
                InsArcNewMsg(ID_Obj,206+$4000);
                AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytPeregon,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytPeregon,ID_Obj);
              end else
              begin
                if ObjZav[ID_Obj].bParam[13] or ObjZav[ID_Obj].bParam[12] then
                begin // Перегон закрыт - открыть перегон
                  InsArcNewMsg(ID_Obj,207+$4000);
                  msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtkrytPeregon; DspCommand.Obj := ID_Obj;
                end else
                begin // Перегон открыт - закрыть перегон
                  InsArcNewMsg(ID_Obj,206+$4000);
                  msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_ZakrytPeregon; DspCommand.Obj := ID_Obj;
                end;
              end;
            end;
          end;
        end else
        begin // Смена направления
          if ObjZav[ID_Obj].ObjConstB[3] then
          begin
            if ObjZav[ID_Obj].bParam[7] and ObjZav[ID_Obj].bParam[8] then
            begin // ошибка подключения комплекта
              InsArcNewMsg(ID_Obj,261+$4000);
              ShowShortMsg(261,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end;
            if ObjZav[ID_Obj].ObjConstB[4] then
            begin // прием
              if not ObjZav[ID_Obj].bParam[7] then
              begin // не подключен комплект по приему
                InsArcNewMsg(ID_Obj,260+$4000);
                ShowShortMsg(260,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
              end;
            end else
            if ObjZav[ID_Obj].ObjConstB[5] then
            begin // отправление
              if not ObjZav[ID_Obj].bParam[8] then
              begin // не подключен комплект по отправлению
                InsArcNewMsg(ID_Obj,260+$4000);
                ShowShortMsg(260,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
              end;
            end;
          end;
          if (ObjZav[ID_Obj].ObjConstI[9] > 0) and // вариант с запросом согласия на смену направления
             ObjZav[ID_Obj].bParam[17] then        // Есть согласие на смену направления
          begin // сбросить согласие
            InsArcNewMsg(ID_Obj,437+$4000);
            msg := GetShortMsg(1,437, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SnatSoglasieSmenyNapr;
            DspCommand.Obj := ID_Obj; DspMenu.WC := true; goto mkmnu;
          end;
          if not ObjZav[ID_Obj].bParam[5] then
          begin // перегон занят
            InsArcNewMsg(ID_Obj,262+$4000);
            ShowShortMsg(262,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end;
          if not ObjZav[ID_Obj].bParam[6] then
          begin // отправлен хозпоезд (изъят ключ-жезл)
            InsArcNewMsg(ID_Obj,130+$4000);
            ShowShortMsg(130,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end;
          if ObjZav[ID_Obj].bParam[4] then
          begin // перегон по отправлению
            if ObjZav[ID_Obj].ObjConstI[9] > 0 then
            begin // вариант с запросом согласия на смену направления
              if ObjZav[ID_Obj].bParam[10] then
              begin // Есть запрос на смену направления
                if ObjZav[ID_Obj].bParam[15] then // проверка замыкания маршрута отправления
                begin
                  InsArcNewMsg(ID_Obj,436+$4000);
                  ShowShortMsg(436,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
                end;
                InsArcNewMsg(ID_Obj,205+$4000);
                msg := GetShortMsg(1,205, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatSoglasieSmenyNapr;
                DspCommand.Obj := ID_Obj; DspMenu.WC := true; goto mkmnu;
              end else // Нет запроса на смену направления
              begin
                InsArcNewMsg(ID_Obj,266+$4000);
                ShowShortMsg(266,LastX,LastY,ObjZav[ID_Obj].Liter);
              end;
              exit;
            end else // вариант без запроса согласия смены направления
            begin
              InsArcNewMsg(ID_Obj,265+$4000);
              ShowShortMsg(265,LastX,LastY,ObjZav[ID_Obj].Liter);
            end;
            exit;
          end else
          begin // перегон по приему
            InsArcNewMsg(ID_Obj,204+$4000);
            msg := GetShortMsg(1,204, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SmenaNapravleniya; DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_KSN : begin // Подключение комплекта смены направления
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if not WorkMode.OtvKom then
      begin // не нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,276+$4000);
        ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin // Сбросить набор маршрута
        ResetTrace; DspCommand.Command := 0; exit;
      end else
      if WorkMode.MarhOtm then
      begin // отмена -
        if ObjZav[ID_Obj].bParam[1] then
        begin // отключить комплект СН
          InsArcNewMsg(ID_Obj,406+$4000); msg := GetShortMsg(1,406, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtklKSN; DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ID_Obj,260+$4000); ShowShortMsg(260,LastX,LastY,''); exit;
        end;
        DspCommand.Active := true; WorkMode.MarhOtm := false; DspMenu.WC := true;
      end else
      begin
        if ObjZav[ID_Obj].bParam[1] then
        begin // отключить комплект СН
          InsArcNewMsg(ID_Obj,406+$4000);
          msg := GetShortMsg(1,406, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtklKSN; DspCommand.Obj := ID_Obj;
        end else
        begin // подключить комплект СН
          InsArcNewMsg(ID_Obj,407+$4000);
          msg := GetShortMsg(1,407, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VklKSN; DspCommand.Obj := ID_Obj;
        end;
        DspCommand.Active := true; WorkMode.MarhOtm := false; DspMenu.WC := true;
      end;
{$ENDIF}
    end;

    IDMenu_PAB : begin// Увязка с ПАБ
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      if WorkMode.MarhOtm then
      begin // отмена -
        WorkMode.MarhOtm := false;
        if ObjZav[ID_Obj].bParam[4] then
        begin // снять согласие отправления
          InsArcNewMsg(ID_Obj,279+$4000);
          msg := GetShortMsg(1,279, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtmenaSoglasieOtpravl; DspCommand.Obj := ID_Obj;
        end else
          exit;
      end else
      begin // нормальный режим
        if WorkMode.InpOgr then
        begin // Ввод ограничений
          if ObjZav[ID_Obj].ObjConstB[8] or ObjZav[ID_Obj].ObjConstB[9] then // есть закрытие движения на электротяге
          begin
          // закрытие движения
            if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
            begin
              InsArcNewMsg(ID_Obj,207+$4000);
              InsArcNewMsg(ID_Obj,206+$4000);
              AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytPeregonPAB,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytPeregonPAB,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[13] then
            begin
              InsArcNewMsg(ID_Obj,207+$4000);
              AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytPeregonPAB,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,206+$4000);
              AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytPeregonPAB,ID_Obj);
            end;
          // закрытие движения на электротяге
            if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
            begin
              InsArcNewMsg(ID_Obj,458+$4000);
              InsArcNewMsg(ID_Obj,459+$4000);
              AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_RPBZakrytDvijenieET,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_RPBOtkrytDvijenieET,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[27] then
            begin
              InsArcNewMsg(ID_Obj,459+$4000);
              AddDspMenuItem(GetShortMsg(1,459, ''), CmdMenu_RPBOtkrytDvijenieET,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,458+$4000);
              AddDspMenuItem(GetShortMsg(1,458, ''), CmdMenu_RPBZakrytDvijenieET,ID_Obj);
            end;
            if ObjZav[ID_Obj].ObjConstB[8] and ObjZav[ID_Obj].ObjConstB[9] then // есть 2 вида электротяги
            begin
          // закрытие движения на электротяге постоянного тока
              if ObjZav[ID_Obj].bParam[25] <> ObjZav[ID_Obj].bParam[28] then
              begin
                InsArcNewMsg(ID_Obj,463+$4000);
                InsArcNewMsg(ID_Obj,464+$4000);
                AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_RPBZakrytDvijenieETD,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_RPBOtkrytDvijenieETD,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[28] then
              begin
                InsArcNewMsg(ID_Obj,464+$4000);
                AddDspMenuItem(GetShortMsg(1,464, ''), CmdMenu_RPBOtkrytDvijenieETD,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,463+$4000);
                AddDspMenuItem(GetShortMsg(1,463, ''), CmdMenu_RPBZakrytDvijenieETD,ID_Obj);
              end;
          // закрытие движения на электротяге переменного тока
              if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
              begin
                InsArcNewMsg(ID_Obj,468+$4000);
                InsArcNewMsg(ID_Obj,469+$4000);
                AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_RPBZakrytDvijenieETA,ID_Obj);
                AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_RPBOtkrytDvijenieETA,ID_Obj);
              end else
              if ObjZav[ID_Obj].bParam[29] then
              begin
                InsArcNewMsg(ID_Obj,469+$4000);
                AddDspMenuItem(GetShortMsg(1,469, ''), CmdMenu_RPBOtkrytDvijenieETA,ID_Obj);
              end else
              begin
                InsArcNewMsg(ID_Obj,468+$4000);
                AddDspMenuItem(GetShortMsg(1,468, ''), CmdMenu_RPBZakrytDvijenieETA,ID_Obj);
              end;
            end;
          end else
          begin // нет электротяги
            if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
            begin
              InsArcNewMsg(ID_Obj,207+$4000);
              InsArcNewMsg(ID_Obj,206+$4000);
              AddDspMenuItem(GetShortMsg(1,207, ''), CmdMenu_OtkrytPeregonPAB,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,206, ''), CmdMenu_ZakrytPeregonPAB,ID_Obj);
            end else
            begin
              if ObjZav[ID_Obj].bParam[13] or ObjZav[ID_Obj].bParam[12] then
              begin // Перегон закрыт - открыть перегон
                InsArcNewMsg(ID_Obj,207+$4000);
                msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtkrytPeregonPAB; DspCommand.Obj := ID_Obj;
              end else
              begin // Перегон открыт - закрыть перегон
                InsArcNewMsg(ID_Obj,206+$4000);
                msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_ZakrytPeregonPAB; DspCommand.Obj := ID_Obj;
              end;
            end;
          end;
        end else
        begin //
          if WorkMode.OtvKom then
          begin // режим ОК
            if not ObjZav[ID_Obj].bParam[1] then
            begin // перегон занят по приему
              if ObjZav[ID_Obj].bParam[3] then
              begin // выдать исполнительную команду
                InsArcNewMsg(ID_Obj,281+$4000);
                msg := GetShortMsg(1,281, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IskPribytieIspolnit; DspCommand.Obj := ID_Obj;
              end else
              begin // выдать предварительную команду
                InsArcNewMsg(ID_Obj,280+$4000);
                msg := GetShortMsg(1,280, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IskPribytiePredv; DspCommand.Obj := ID_Obj;
              end;
            end else
            begin // не требуется выдача иск.прибытия
              InsArcNewMsg(ID_Obj,298+$4000);
              ShowShortMsg(298,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end;
          end else
          if not ObjZav[ID_Obj].bParam[1] then
          begin // Перегон занят по приему
            if ObjZav[ID_Obj].bParam[2] then
            begin // получено прибытие поезда - дать прибытие
              InsArcNewMsg(ID_Obj,282+$4000);
              msg := GetShortMsg(1,282, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VydatPribytiePoezda; DspCommand.Obj := ID_Obj;
            end else
            begin
              InsArcNewMsg(ID_Obj,318+$4000); ShowShortMsg(318,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end;
          end else
          if not ObjZav[ID_Obj].bParam[5] then
          begin // Перегон занят по отправлению
            InsArcNewMsg(ID_Obj,299+$4000);
            ShowShortMsg(299,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end else
          if ObjZav[ID_Obj].bParam[6] then
          begin // Получено согласие отправления
            InsArcNewMsg(ID_Obj,326+$4000);
            ShowShortMsg(326,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end else
          if not ObjZav[ID_Obj].bParam[7] then
          begin // Хозпоезд на перегоне
            InsArcNewMsg(ID_Obj,130+$4000);
            ShowShortMsg(130,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
          end else
          begin // Перегон свободен - выдать/снять согласие
            if ObjZav[ID_Obj].bParam[4] then
            begin // снять согласие отправления
              InsArcNewMsg(ID_Obj,279+$4000);
              msg := GetShortMsg(1,279, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtmenaSoglasieOtpravl; DspCommand.Obj := ID_Obj;
            end else
            begin // дать согласие отправления
              InsArcNewMsg(ID_Obj,278+$4000);
              msg := GetShortMsg(1,278, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VydatSoglasieOtpravl; DspCommand.Obj := ID_Obj;
            end;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

{$IFDEF RMDSP}
    CmdManevry_ReadyWar : begin // Ожидание подтверждения передачи на маневры
      if MarhTracert[1].WarCount > 0 then
      begin
        InsArcNewMsg(MarhTracert[1].WarObject[Marhtracert[1].WarCount],MarhTracert[1].WarIndex[Marhtracert[1].WarCount]+$5000);
        msg := MarhTracert[1].Warning[Marhtracert[1].WarCount]; dec (Marhtracert[1].WarCount); DspCommand.Command := CmdManevry_ReadyWar; DspCommand.Obj := ID_Obj;
      end else
      begin
        InsArcNewMsg(ID_Obj,217+$4000);
        msg := GetShortMsg(1,217, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatRazreshenieManevrov; DspCommand.Obj := ID_Obj;
      end;
    end;
{$ENDIF}

    IDMenu_ManevrovayaKolonka : begin// Маневровая колонка
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.InpOgr then
      begin // Сбросить ввод ограничений
        WorkMode.InpOgr := false;
      end else
      if WorkMode.GoTracert then
      begin // Сбросить набор маршрута
        ResetTrace; DspCommand.Command := 0; exit;
      end else
      if WorkMode.MarhOtm then
      begin // отмена -
        WorkMode.MarhOtm := false;
        if ObjZav[ID_Obj].bParam[8] then
        begin // выдана РМ - отменить или остановить маневры
          if ObjZav[ID_Obj].bParam[3] then
          begin // маневры еще не замкнуты
            InsArcNewMsg(ID_Obj,218+$4000);
            msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter);
          end else
          begin // маневры замкнуты
            if ObjZav[ID_Obj].bParam[5] then // есть восприятие маневров
            begin // остановить маневры
              InsArcNewMsg(ID_Obj,446+$4000);
              msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter);
            end else
            begin
              InsArcNewMsg(ID_Obj,218+$4000);
              msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter);
            end;
          end;
          DspCommand.Command := CmdMenu_OtmenaManevrov; DspCommand.Obj := ID_Obj;
        end else
        if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[9] then
        begin // есть РМ или РМК - отменить маневры
          if ObjZav[ID_Obj].bParam[5] and not ObjZav[ID_Obj].bParam[3] then // есть восприятие маневров и МИ
          begin // остановить маневры
            InsArcNewMsg(ID_Obj,446+$4000);
            msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter);
          end else
          begin // проверить условия отмены маневров
            msg := VytajkaCOT(ID_Obj);
            if msg <> '' then
            begin // нет условий для отмены - остановить маневры
              InsArcNewMsg(ID_Obj,446+$4000);
              msg := msg + '! ' + GetShortMsg(1,446, ObjZav[ID_Obj].Liter);
            end else
            begin // отменить маневры
              InsArcNewMsg(ID_Obj,218+$4000);
              msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter);
            end;
          end;
          DspCommand.Command := CmdMenu_OtmenaManevrov; DspCommand.Obj := ID_Obj;
        end else
        if not ObjZav[ID_Obj].bParam[3] and not ObjZav[ID_Obj].bParam[5] then
        begin // есть МИ и снято восприятие маневров - запустить отмену маневров
          InsArcNewMsg(ID_Obj,218+$4000);
          msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtmenaManevrov; DspCommand.Obj := ID_Obj;
        end else
        if ObjZav[ID_Obj].bParam[5] then // не снято восприятие маневров
        begin // отказать
          InsArcNewMsg(ID_Obj,269+$4000);
          ShowShortMsg(269,LastX,LastY, ObjZav[ID_Obj].Liter); exit;
        end;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          if WorkMode.GoOtvKom then
          begin // исполнительная команда
            OtvCommand.SObj := ID_Obj;
            InsArcNewMsg(ID_Obj,220+$4000);
            msg := GetShortMsg(1,220, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IspolIRManevrov; DspCommand.Obj := ID_Obj;
          end else
          begin // предварительная команда
            InsArcNewMsg(ID_Obj,219+$4000);
            msg := GetShortMsg(1,219, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PredvIRManevrov; DspCommand.Obj := ID_Obj;
          end;
        end else
        if ObjZav[ID_Obj].bParam[8] then
        begin // выдана РМ - отменить маневры
          if ObjZav[ID_Obj].bParam[3] then
          begin // маневры еще не замкнуты
            InsArcNewMsg(ID_Obj,218+$4000);
            msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter);
          end else
          begin // маневры замкнуты
            if ObjZav[ID_Obj].bParam[5] then // есть восприятие маневров
            begin // остановить маневры
              InsArcNewMsg(ID_Obj,446+$4000);
              msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter);
            end else
            begin
              InsArcNewMsg(ID_Obj,218+$4000);
              msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter);
            end;
          end;
          DspCommand.Command := CmdMenu_OtmenaManevrov; DspCommand.Obj := ID_Obj;
        end else
        if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[9] then
        begin // есть РМ или РМК - отменить маневры
          if ObjZav[ID_Obj].bParam[5] and not ObjZav[ID_Obj].bParam[3] then // есть восприятие маневров и МИ
          begin // остановить маневры
            InsArcNewMsg(ID_Obj,446+$4000);
            msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter);
          end else
          begin // проверить условия отмены маневров
            msg := VytajkaCOT(ID_Obj);
            if msg <> '' then
            begin // нет условий для отмены - остановить маневры
              InsArcNewMsg(ID_Obj,446+$4000);
              msg := msg + '! ' + GetShortMsg(1,446, ObjZav[ID_Obj].Liter);
            end else
            begin // отменить маневры
              InsArcNewMsg(ID_Obj,218+$4000);
              msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter);
            end;
          end;
          DspCommand.Command := CmdMenu_OtmenaManevrov; DspCommand.Obj := ID_Obj;
        end else
        begin // нет РМ - проверить условия передачи на маневры
          if ObjZav[ID_Obj].bParam[3] then
          begin // нет МИ
            if VytajkaRM(ID_Obj) then
            begin
              if MarhTracert[1].WarCount > 0 then
              begin
                InsArcNewMsg(MarhTracert[1].WarObject[Marhtracert[1].WarCount],MarhTracert[1].WarIndex[Marhtracert[1].WarCount]+$5000);
                msg := MarhTracert[1].Warning[Marhtracert[1].WarCount]; dec (Marhtracert[1].WarCount); DspCommand.Command := CmdManevry_ReadyWar; DspCommand.Obj := ID_Obj;
              end else
              begin
                InsArcNewMsg(ID_Obj,217+$4000);
                msg := GetShortMsg(1,217, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatRazreshenieManevrov; DspCommand.Obj := ID_Obj;
              end;
            end else
            begin // вывести сообщение об отказе передачи на маневры
              InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]+$4000);
              PutShortMsg(1,LastX,LastY,MarhTracert[1].Msg[1]); exit;
            end;
          end else
          begin // есть МИ
            InsArcNewMsg(ID_Obj,448+$4000);
            msg := GetShortMsg(1,448, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatRazreshenieManevrov; DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;


    IDMenu_ZamykanieStrelok : begin// Замыкание стрелок
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin // Замыкание
          InsArcNewMsg(ID_Obj,189+$4000);
          msg := GetShortMsg(1,189, ObjZav[ID_Obj].Liter);
          DspCommand.Command := CmdMenu_ZamykanieStrelok; DspCommand.Obj := ID_Obj;
        end else
        begin // не нажата ОК - прекратить формирование команды
          InsArcNewMsg(ID_Obj,276+$4000);
          ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;
    IDMenu_RazmykanieStrelok : begin// Размыкание стрелок
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          if WorkMode.GoOtvKom then
          begin // исполнительная команда
            OtvCommand.SObj := ID_Obj;
            InsArcNewMsg(ID_Obj,191+$4000);
            msg := GetShortMsg(1,191, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IspolRazmykanStrelok; DspCommand.Obj := ID_Obj;
          end else
          begin // предварительная команда
            InsArcNewMsg(ID_Obj,190+$4000);
            msg := GetShortMsg(1,190, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PredvRazmykanStrelok; DspCommand.Obj := ID_Obj;
          end;
        end else
        begin // не нажата ОК - прекратить формирование команды
          InsArcNewMsg(ID_Obj,276+$4000);
          ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_ZakrytPereezd : begin // Закрыть переезд
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        InsArcNewMsg(ID_Obj,192+$4000);
        msg := GetShortMsg(1,192, ObjZav[ID_Obj].Liter);
        DspCommand.Command := CmdMenu_ZakrytPereezd; DspCommand.Obj := ID_Obj;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;
    IDMenu_OtkrytPereezd : begin// Открыть переезд
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          if WorkMode.GoOtvKom then
          begin // исполнительная команда
            OtvCommand.SObj := ID_Obj;
            InsArcNewMsg(ID_Obj,194+$4000);
            msg := GetShortMsg(1,194, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IspolOtkrytPereezd; DspCommand.Obj := ID_Obj;
          end else
          begin // предварительная команда
            InsArcNewMsg(ID_Obj,193+$4000);
            msg := GetShortMsg(1,193, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PredvOtkrytPereezd; DspCommand.Obj := ID_Obj;
          end;
        end else
        begin // не нажата ОК - прекратить формирование команды
          InsArcNewMsg(ID_Obj,276+$4000);
          ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;
    IDMenu_IzvesheniePereezd : begin// Извещение на переезд
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        result := false; DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if ObjZav[ID_Obj].bParam[2] then
        begin // снять извещение
        InsArcNewMsg(ID_Obj,196+$4000);
          msg := GetShortMsg(1,196, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SnatIzvecheniePereezd; DspCommand.Obj := ID_Obj;
        end else
        begin // дать извещение
          InsArcNewMsg(ID_Obj,195+$4000);
          msg := GetShortMsg(1,195, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatIzvecheniePereezd; DspCommand.Obj := ID_Obj;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_PoezdnoeOpoveshenie : begin// Поездное оповещение
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin // нажата ОК - прекратить формирование команды
          InsArcNewMsg(ID_Obj,283+$4000);
          ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
        end else
        if WorkMode.MarhOtm then
        begin // Сбросить отмену маршрута
          WorkMode.MarhOtm := false;
          if ObjZav[ID_Obj].bParam[2] then
          begin // отключить оповещение
            InsArcNewMsg(ID_Obj,198+$4000);
            msg := '';
            if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
            begin
              msg := GetShortMsg(1,309,''); SingleBeep := true;
            end;
            msg := msg + GetShortMsg(1,198, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SnatOpovechenie; DspCommand.Obj := ID_Obj;
          end;
        end else
        begin
          if ObjZav[ID_Obj].bParam[2] then
          begin // отключить оповещение
            InsArcNewMsg(ID_Obj,198+$4000);
            msg := '';
            if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
            begin
              msg := GetShortMsg(1,309,''); SingleBeep := true;
            end;
            msg := msg + GetShortMsg(1,198, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SnatOpovechenie; DspCommand.Obj := ID_Obj;
          end else
          begin // включить оповещение
            InsArcNewMsg(ID_Obj,197+$4000);
            msg := GetShortMsg(1,197, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatOpovechenie; DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;
    IDMenu_ZapretMonteram : begin// Запрет монтерам
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          if ObjZav[ID_Obj].ObjConstB[1] then
          begin
            if ObjZav[ID_Obj].bParam[2] then
            begin
              if not ObjZav[ID_Obj].bParam[1] then
              begin // отключить запрет монтерам
                InsArcNewMsg(ID_Obj,200+$4000);
                msg := GetShortMsg(1,200, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SnatZapretMonteram; DspCommand.Obj := ID_Obj;
              end else
              begin // включить запрет монтерам
                InsArcNewMsg(ID_Obj,199+$4000);
                msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatZapretMonteram; DspCommand.Obj := ID_Obj;
              end;
            end else
            begin // оповещение выключено - нельзя управлять запретом
              InsArcNewMsg(ID_Obj,483+$4000);
              ShowShortMsg(483,LastX,LastY,''); exit;
            end;
          end else
          begin
            if ObjZav[ID_Obj].bParam[1] then
            begin // отключить запрет монтерам
              InsArcNewMsg(ID_Obj,200+$4000);
              msg := GetShortMsg(1,200, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_SnatZapretMonteram; DspCommand.Obj := ID_Obj;
            end else
            begin // включить запрет монтерам
              InsArcNewMsg(ID_Obj,199+$4000);
              msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_DatZapretMonteram; DspCommand.Obj := ID_Obj;
            end;
          end;
        end else
        begin // не нажата ОК - прекратить формирование команды
          InsArcNewMsg(ID_Obj,276+$4000);
          ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_VykluchenieUKSPS : begin// УКСПС
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          if WorkMode.GoOtvKom then
          begin // исполнительная команда
            OtvCommand.SObj := ID_Obj;
            InsArcNewMsg(ID_Obj,202+$4000);
            msg := GetShortMsg(1,202, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IspolOtkluchenieUKSPS; DspCommand.Obj := ID_Obj;
          end else
          if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
          begin // сработал УКСПС - предварительная команда
            InsArcNewMsg(ID_Obj,201+$4000);
            msg := GetShortMsg(1,201, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PredvOtkluchenieUKSPS; DspCommand.Obj := ID_Obj;
          end;
        end else
        begin // не нажата ОК - сбросить блокировку УКСПС
          if ObjZav[ID_Obj].bParam[1] and ObjZav[ID_Obj].ObjConstB[1] then
          begin // Есть команда отмены и УКСПС заблокирован - сбросить блокировку
            InsArcNewMsg(ID_Obj,353+$4000);
            msg := GetShortMsg(1,353, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtmenaOtkluchenieUKSPS; DspCommand.Obj := ID_Obj;
          end else
          begin
            InsArcNewMsg(ID_Obj,276+$4000);
            ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_VspomPriem : begin// Вспомогательный прием
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          if WorkMode.GoOtvKom then
          begin // исполнительная команда ВП
            OtvCommand.SObj := ID_Obj;
            InsArcNewMsg(ID_Obj,211+$4000);
            msg := GetShortMsg(1,211, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IspolVspomPriem; DspCommand.Obj := ID_Obj;
          end else
          begin
            if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[6] then // ключ-жезл вставлен в аппарат
            begin // предварительная команда ВП
              InsArcNewMsg(ID_Obj,210+$4000);
              msg := GetShortMsg(1,210, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PredvVspomPriem; DspCommand.Obj := ID_Obj;
            end else
            begin // КЖ изъят из аппарата
              InsArcNewMsg(ID_Obj,337+$4000);
              ShowShortMsg(357,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end;
          end;
        end else
        begin // не нажата ОК - прекратить формирование команды
          InsArcNewMsg(ID_Obj,276+$4000);
          ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;
    IDMenu_VspomOtpravlenie : begin// Вспомогательное отправление
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          if WorkMode.GoOtvKom then
          begin // исполнительная команда Во
            OtvCommand.SObj := ID_Obj;
            InsArcNewMsg(ID_Obj,209+$4000);
            msg := GetShortMsg(1,209, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_IspolVspomOtpravlenie; DspCommand.Obj := ID_Obj;
          end else
          begin // проверить КЖ
            if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[6] then // ключ-жезл вставлен в аппарат
            begin // предварительная команда Во
              InsArcNewMsg(ID_Obj,208+$4000);
              msg := GetShortMsg(1,208, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_PredvVspomOtpravlenie; DspCommand.Obj := ID_Obj;
            end else
            begin // КЖ изъят из аппарата
              InsArcNewMsg(ID_Obj,357+$4000);
              ShowShortMsg(357,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
            end;
          end;
        end else
        begin // не нажата ОК - прекратить формирование команды
          InsArcNewMsg(ID_Obj,276+$4000);
          ResetCommands; ShowShortMsg(276,LastX,LastY,''); exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_OchistkaStrelok : begin// Очистка стрелок
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          InsArcNewMsg(ID_Obj,283+$4000);
          ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
        end else
        begin
          if ObjZav[ID_Obj].bParam[1] then
          begin // вытащить кнопку
            InsArcNewMsg(ID_Obj,5+$4000);
            msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]]; DspCommand.Command := CmdMenu_OtklOchistkuStrelok; DspCommand.Obj := ID_Obj;
          end else
          begin // нажать кнопку
            InsArcNewMsg(ID_Obj,4+$4000);
            msg := MsgList[ObjZav[ID_Obj].ObjConstI[4]]; DspCommand.Command := CmdMenu_VkluchOchistkuStrelok; DspCommand.Obj := ID_Obj;
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_VkluchenieGRI1 : begin // Включение выдержки времени ГРИ1
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin // выдать команду
          if ObjZav[ID_Obj].bParam[1] then
          begin // уже включена выдержка времени ИР - отказ
            InsArcNewMsg(ID_Obj,335+$4000);
            ShowShortMsg(335,LastX,LastY,ObjZav[ID_Obj].Liter); SingleBeep := true; exit;
          end else
          begin // выдать команду
            InsArcNewMsg(ID_Obj,214+$4000);
            msg := '';
            if not ObjZav[ID_Obj].bParam[2] then
            begin // не выбраны секции для ИР  - выдать предупреждение
              msg := GetShortMsg(1,264,'') + ' ';
            end;
            msg := msg + GetShortMsg(1,214, ObjZav[ID_Obj].Liter);
            DspCommand.Command := CmdMenu_VkluchenieGRI; DspCommand.Obj := ID_Obj;
          end;
        end else
        begin // не нажата кнопка ОК
          InsArcNewMsg(ID_Obj,263+$4000);
          ShowShortMsg(263,LastX,LastY,''); SingleBeep := true; exit;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_PutManevrovyi : begin// Участок извещения из тупика, Путь без ограждения
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // ОК - нормализовать признаки трассировки для пути
        InsArcNewMsg(ID_Obj,311+$4000);
        msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMarsh_ResetTraceParams; DspCommand.Obj := ID_Obj;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      if ObjZav[ID_Obj].bParam[19] then
      begin // Восприятие диагностического сообщения
        ObjZav[ID_Obj].bParam[19] := false; exit;
      end else
      begin // нормальный режим
        if ObjZav[ID_Obj].bParam[13] then
        begin
          InsArcNewMsg(ID_Obj,171+$4000);
          msg := GetShortMsg(1,171, ObjZav[ID_Obj].Liter);
          DspCommand.Command := CmdMenu_PutOtkrytDvijenie; DspCommand.Obj := ID_Obj;
        end else
        begin
          InsArcNewMsg(ID_Obj,170+$4000);
          msg := GetShortMsg(1,170, ObjZav[ID_Obj].Liter);
          DspCommand.Command := CmdMenu_PutZakrytDvijenie; DspCommand.Obj := ID_Obj;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_RezymPitaniyaLamp : begin// Питание ламп светофоров
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin
        if ObjZav[ID_Obj].ObjConstI[16] = 0 then
        begin // нет РСВ
          if ObjZav[ID_Obj].bParam[15] then
          begin // включить НОЧЬ
            InsArcNewMsg(ID_Obj,222+$4000);
            msg := GetShortMsg(1,222, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VkluchitNoch; DspCommand.Obj := ID_Obj;
          end else
          begin // включить ДЕНЬ
            InsArcNewMsg(ID_Obj,221+$4000);
            msg := GetShortMsg(1,221, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VkluchitDen; DspCommand.Obj := ID_Obj;
          end;
        end else
        begin // есть РСВ
          if ObjZav[ID_Obj].bParam[15] then
          begin // включить НОЧЬ
            InsArcNewMsg(ID_Obj,222+$4000);
            AddDspMenuItem(GetShortMsg(1,222, ''), CmdMenu_VkluchitNoch,ID_Obj);
          end else
          begin // включить ДЕНЬ
            InsArcNewMsg(ID_Obj,221+$4000);
            AddDspMenuItem(GetShortMsg(1,221, ''), CmdMenu_VkluchitDen,ID_Obj);
          end;
          if ObjZav[ID_Obj].bParam[16] then
          begin // отключить АВТО
            InsArcNewMsg(ID_Obj,480+$4000);
            AddDspMenuItem(GetShortMsg(1,480, ''), CmdMenu_OtkluchitAuto,ID_Obj);
          end else
          begin // включить АВТО
            InsArcNewMsg(ID_Obj,223+$4000);
            AddDspMenuItem(GetShortMsg(1,223, ''), CmdMenu_VkluchitAuto,ID_Obj);
          end;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_RezymLampDen : begin // Включение дневного режима
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          InsArcNewMsg(ID_Obj,283+$4000);
          ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
        end else
        begin
          InsArcNewMsg(ID_Obj,221+$4000);
          msg := GetShortMsg(1,221, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VkluchitDen; DspCommand.Obj := ID_Obj;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_RezymLampNoch : begin // Включение ночного режима
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          InsArcNewMsg(ID_Obj,283+$4000);
          ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
        end else
        begin
          InsArcNewMsg(ID_Obj,222+$4000);
          msg := GetShortMsg(1,222, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VkluchitNoch; DspCommand.Obj := ID_Obj;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_RezymLampAuto : begin // Включение автоматического режима
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        result := false; DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        if WorkMode.OtvKom then
        begin
          InsArcNewMsg(ID_Obj,283+$4000);
          ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
        end else
        begin
          InsArcNewMsg(ID_Obj,223+$4000);
          msg := GetShortMsg(1,223, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_VkluchitAuto; DspCommand.Obj := ID_Obj;
        end;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

    IDMenu_OtklZvonkaUKSPS : begin // Выключение звонка УКСПС
      DspMenu.obj := cur_obj;
{$IFNDEF RMDSP}
      ID_ViewObj := ID_Obj; result := true; exit;
{$ELSE}
      if WorkMode.OtvKom then
      begin // нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000);
        ResetCommands; ShowShortMsg(283,LastX,LastY,''); exit;
      end else
      if VspPerevod.Active then
      begin // Сброс вспомогательного перевода
        InsArcNewMsg(ID_Obj,149+$4000);
        VspPerevod.Active := false; WorkMode.VspStr := false; ShowShortMsg(149, LastX, LastY, ''); exit;
      end else
      if WorkMode.MarhOtm then
      begin // Сбросить отмену маршрута
        WorkMode.MarhOtm := false; exit;
      end else
      if WorkMode.GoMaketSt or WorkMode.VspStr then
      begin // это не стрелка
        InsArcNewMsg(ID_Obj,9+$4000);
        ShowShortMsg(9,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin
        ResetTrace; // Сбросить набор маршрута
        DspCommand.Command := 0; exit;
      end else
      begin // нормальный режим
        InsArcNewMsg(ID_Obj,203+$4000);
        msg := GetShortMsg(1,203, ObjZav[ID_Obj].Liter); DspCommand.Command := CmdMenu_OtklZvonkaUKSPS; DspCommand.Obj := ID_Obj;
      end;
      DspMenu.WC := true;
{$ENDIF}
    end;

{$IFDEF RMDSP}
    CmdStr_ReadyPerevodPlus : begin // Подтверждение перевода стрелки в плюс
      InsArcNewMsg(ObjZav[ID_Obj].BaseObject,97+$4000);
      msg := GetShortMsg(1,97,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspMenu.WC := true;
      DspCommand.Command := CmdStr_ReadyPerevodPlus; DspCommand.Obj := ID_Obj;
    end;

    CmdStr_ReadyPerevodMinus : begin // Подтверждение перевода стрелки в минус
      InsArcNewMsg(ObjZav[ID_Obj].BaseObject,98+$4000);
      msg := GetShortMsg(1,98,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspMenu.WC := true;
      DspCommand.Command := CmdStr_ReadyPerevodMinus; DspCommand.Obj := ID_Obj;
    end;

    CmdStr_ReadyVPerevodPlus : begin // Подтверждение вспомогательного перевода стрелки в плюс
      InsArcNewMsg(ObjZav[ID_Obj].BaseObject,99+$4000);
      msg := GetShortMsg(1,99,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspMenu.WC := true;
      DspCommand.Command := CmdStr_ReadyVPerevodPlus; DspCommand.Obj := ID_Obj;
    end;

    CmdStr_ReadyVPerevodMinus : begin // Подтверждение вспомогательного перевода стрелки в минус
      InsArcNewMsg(ObjZav[ID_Obj].BaseObject,100+$4000);
      msg := GetShortMsg(1,100,ObjZav[ObjZav[ID_Obj].BaseObject].Liter); DspMenu.WC := true;
      DspCommand.Command := CmdStr_ReadyVPerevodMinus; DspCommand.Obj := ID_Obj;
    end;
{$ENDIF}

{$IFNDEF RMDSP}
    IDMenu_GroupDat : begin// Группа теневых датчиков на АРМ-ШН
      DspMenu.obj := cur_obj;
      ID_ViewObj := ID_Obj; result := true; exit;
    end;
{$ENDIF}

  else
    DspCommand.Command := 0; DspCommand.Obj := 0; exit;
  end;

{$IFDEF RMDSP}
mkmnu :
  if DspMenu.Count > 0 then
  begin
  // Сформировать меню
    TabloMain.PopupMenuCmd.Items.Clear;
    for i := 1 to DspMenu.Count do TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);
    i := configRU[config.ru].TabloSize.Y - 10; SetCursorPos(x,i);
    TabloMain.PopupMenuCmd.Popup(X, i+3-17*DspMenu.Count);
  end else
  begin
  // Вывести подсказку перед выполнением простой команды
    j := x div configRU[config.ru].MonSize.X + 1; // Найти номер табло
    for i := 1 to Length(shortMsg) do
    begin
      if i = j then
      begin
        shortMsg[i] := msg; shortMsgColor[i] := GetColor(7);
      end else
        shortMsg[i] := '';
    end;
  end;
{$ENDIF}
except
  reportf('Ошибка [CMenu.CreateDspMenu]'); result := true;
end;
end;


{$IFDEF RMDSP}
//------------------------------------------------------------------------------
// Проверка условий допустимости возбуждения начального признака для светофора
function CheckStartTrace(Index : SmallInt) : string;
begin
try
  result := '';
  case ObjZav[Index].TypeObj of
    33 : begin // датчик FR3
      if ObjZav[Index].ObjConstB[1] then
      begin // инверсия состояния
        if ObjZav[Index].bParam[1] then result := MsgList[ObjZav[Index].ObjConstI[3]];
      end else
      begin // прямое состояние
        if not ObjZav[Index].bParam[1] then result := MsgList[ObjZav[Index].ObjConstI[2]];
      end;
    end;

    35 : begin // Доступ к внутренним свойствам контролируемого объекта
      if ObjZav[Index].ObjConstB[1] then
      begin // инверсия состояния
        if ObjZav[Index].bParam[1] then result := MsgList[ObjZav[Index].ObjConstI[2]];
      end else
      begin // прямое состояние
        if not ObjZav[Index].bParam[1] then result := MsgList[ObjZav[Index].ObjConstI[2]];
      end;
    end;

    47 : begin // Проверка включения автодействия сигналов
      if ObjZav[Index].bParam[1] then result := GetShortMsg(1, 431, ObjZav[Index].Liter);
    end;
  end;
except
  reportf('Ошибка [CMenu.CheckStartTrace]'); result := '#';
end;
end;

//------------------------------------------------------------------------------
// Проверка условий допустимости возбуждения начального признака для светофора
function CheckAutoON(Index : SmallInt) : Boolean;
begin
try
  result := false;
  if index = 0 then exit;
  if ObjZav[Index].TypeObj <> 47 then exit;
  // Проверка включения автодействия сигналов
  if ObjZav[Index].bParam[1] then result := true;
except
  reportf('Ошибка [CMenu.CheckStartTrace]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Проверить условия перезамыкания поездного маршрута маневровым для протяжки состава
function CheckProtag(Index : SmallInt) : Boolean;
  var o : integer;
begin
try
  result := false;
  o := ObjZav[Index].ObjConstI[17];
  if o < 1 then exit;
  if ObjZav[o].TypeObj <> 42 then exit; // нет объекта перезамыкания
  if ObjZav[ObjZav[index].BaseObject].bParam[2] then exit; // перекрывная секция не замкнута - нет протяжки
  if ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
  begin
    if ObjZav[Index].ObjConstB[17] then
    begin // с возбуждением признака НМ
      DspCommand.Command := CmdMenu_OtkrytManevrovym; DspCommand.Obj := ID_Obj; DspMenu.WC := true;
    end else
    begin // без возбуждения признака НМ
      DspCommand.Command := CmdMenu_OtkrytProtjag; DspCommand.Obj := ID_Obj; DspMenu.WC := true;
    end;
    result := true;
  end;
except
  reportf('Ошибка при проверке допутимости открытия маневрового сигнала для протяжки состава [CMenu.CheckProtag]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// проверка завершения установки стрелки на макет
function CheckMaket : Boolean;
  var i : integer;
begin
try
  result := false;
  for i := 1 to High(ObjZav) do
  begin
    if (ObjZav[i].RU = config.ru) and (ObjZav[i].TypeObj = 20) then
    begin
      if ObjZav[i].bParam[1] then //Проверка подключения макетного шнура
        result := (maket_strelki_index < 1);
      exit;
    end;
  end;
except
  reportf('Ошибка при проверке подключения шнура макета стрелки [CMenu.CheckMaket]'); result := false;
end;
end;
{$ENDIF}

end.
