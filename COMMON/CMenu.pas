unit CMenu;
//------------------------------------------------------------------------------
//  Формирование меню
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
//------------------------------------------------------------------------ Коды типов меню
ID_Strelka             = 1;  //-------- привязка в Tablo выполняется автоматически по типу
ID_SvetoforManevr      = 2;  //-------- привязка в Tablo выполняется автоматически по типу
ID_Uchastok            = 3;  //-------- привязка в Tablo выполняется автоматически по типу
ID_PutPO               = 4;  //-------- привязка в Tablo выполняется автоматически по типу
ID_ZamykStr            = 5;  //----------------------- включение ручного замыкания стрелок
ID_RazmykStr           = 6;  //---------------------- отключение ручного замыкания стрелок
ID_ZakrytPereezd       = 7;  //----------------------  закрытие переезда (простая команда)
ID_OtkrytPereezd       = 8;  //----------------- открытие переезда (ответственная команда)
ID_IzvPer              = 9;  //---------------------- выдача / снятие извещения на переезд
ID_PoezdOpov           = 10; //--------------- включение / отключение поездного оповещения
ID_ZapMont             = 11; //---------------------  включение запрета монтерам (простая)
ID_VykluchenieUKSPS    = 12; //---------- исключение УКСПС из зависимостей (ответственная)
ID_SmenaNapravleniya   = 13; //------------------------------- смена направления (простая)
ID_VspomPriem          = 14; //--------------------- вспомогательный прием (ответственная)
ID_VspomOtpravlenie    = 15; //--------------- вспомогательное отправление (ответственная)
ID_OchistkaStrelok     = 16; //---------------------------------- очистка(обдувка) стрелок
ID_VkluchenieGRI1      = 17; //-------------------- включение выдержки ГРИ (ответственная)
ID_PutManevrovyi       = 18; //---------- участок извещения из тупика (откр/закр движение)
ID_SvetoforSovmech     = 19; //-------- привязка в Tablo выполняется автоматически по типу
ID_SvetoforVhodnoy     = 20; //-------- привязка в Tablo выполняется автоматически по типу
ID_VydPSogl            = 21; //------------------------ выдача поездного согласия на прием
ID_ZaprPSogl           = 22; //--------------- запрос поездного согласия (для отправления)
ID_ManKol              = 23; //---------------------------------------- маневровая колонка
ID_RezymPitaniyaLamp   = 24; //------------------------------ спецрежим питания ламп "ДСН"
ID_RezymLampDen        = 25; //------------ включение режима питания ламп светофора "День"
ID_RezymLampNoch       = 26; //------------ включение режима питания ламп светофора "Ночь"
ID_RezymLampAuto       = 27; //--------------- перевод режим питания ламп светофора в авто
ID_OtklZvonkaUKSPS     = 28; //----------------------------------- отключение звонка УКСПС
ID_PAB                 = 29; //----------------------------- Полуавтоматическая блокировка
ID_Nadvig              = 30; //---------------------------------------------------- Надвиг
ID_KSN                 = 31; //---------------------------------- Подключение комплекта СН
ID_OPI                 = 32; //------------------------------- исключение пути из маневров
ID_AutoSvetofor        = 33; //----------------------------- включение режима автодействия
ID_Tracert             = 34; //--------------------------- трассировка по острякам стрелок
ID_GroupDat            = 35; //------------------------- группа теневых датчиков на АРМ ШН
ID_1bit                = 36; //----------------------------- включение / отключение бита 1
ID_2bit                = 37; //----------------------------- включение / отключение бита 2
ID_3bit                = 38; //----------------------------- включение / отключение бита 3
ID_4bit                = 39; //----------------------------- включение / отключение бита 4
ID_5bit                = 40; //----------------------------- включение / отключение бита 5
ID_OtklZapMont         = 41; //------- ответственное отключение запрета монтерам в 2х реле
ID_VklUKG              = 42; //--------------------------------- вернуть в зависимости УКГ
ID_OtklUKG             = 43; //------------- исключить УКГ из зависимостей (ответственная)
ID_VklOtkl_bit1        = 44; //----- включить/отключить объект 1-го бита в разных объектах
ID_IzvPer1             = 45; //------- управление извещением переезда через разные объекты
ID_PrzdZakrOtkr        = 46; //---------------- закрытие / открытие переезда одной кнопкой
ID_ZaprRazrMont        = 47; //---------------- запрет / разрешение монтерам одной кнопкой

//--------------------------------------------- КОМАНДЫ МЕНЮ -----------------------------
//-------------------------------------------------------------------- КОМАНДЫ ДЛЯ СТРЕЛОК
M_StrPerevodPlus         = 1;
M_StrPerevodMinus        = 2;
M_StrVPerevodPlus        = 3;
M_StrVPerevodMinus       = 4;
M_StrOtklUpravlenie      = 5;
M_StrVklUpravlenie       = 6;
M_StrZakrytDvizenie      = 7;
M_StrOtkrytDvizenie      = 8;
M_UstMaketStrelki        = 9; //------------------------------ установить стрелку на макет
M_SnatMaketStrelki      = 10; //----------------------------------- снять стрелку с макета
M_StrMPerevodPlus       = 11;
M_StrMPerevodMinus      = 12;
M_StrZakryt2Dvizenie    = 13;
M_StrOtkryt2Dvizenie    = 14;
M_StrZakrytProtDvizenie = 15;
M_StrOtkrytProtDvizenie = 16;
//                      = 17 - 20 ------------------------------------------------- резерв
//------------------------------------------------------------------- КОМАНДЫ ДЛЯ СИГНАЛОВ
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
//------------------------------------------------------------------------- команды для СП
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
//----------------------------------------------------------------------- команды для пути
M_PutDatSoglasieOgrady   = 51;
//                       = 52 ----------------------------------------------------- резерв
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
M_VklDSN                 = 64; //-------------------------------------------- включить ДСН
M_OtklDSN                = 65; //------------------------------------------- отключить ДСН
M_VklBit1_1              = 66;//--------------------------- включить бит 1 первого объекта
M_VklBit1_2              = 67;//--------------------------- включить бит 1 второго объекта
//---------------------- = 68 - 70 ------------------------------------------------ резерв
M_ZakrytPereezd          = 71;
M_PredvOtkrytPereezd     = 72;
M_IspolOtkrytPereezd     = 73;
M_DatIzvecheniePereezd   = 74;
M_SnatIzvecheniePereezd  = 75;
M_PredvZakrPereezd       = 76;
M_IspolZakrPereezd       = 77;
//---------------------- = 78 - 80 ------------------------------------------------ резерв
M_DatOpovechenie         = 81;
M_SnatOpovechenie        = 82;
M_DatZapretMonteram      = 83;//-------- внутренний признак команды включ. запрета без КОК
M_SnatZapretMonteram     = 84;//----------- признак КОК-однотактной команды снятия запрета

M_PredOtklBit3           = 85; //-------- внутренний признак предварительной отмены бита 3
M_IspolOtklBit3          = 86; //--------- внутренний признак исполнительной отмены бита 3

M_PredvOtklZapMont       = 87;//-------- внутренний признак предварительной отмены запрета
M_IspolOtklZapMont       = 88;//--------- внутренний признак исполнительной отмены запрета
//---------------------- = 89..90 ------------------------------------------------- резерв
M_PredvOtkluchenieUKSPS  = 91;
M_IspolOtkluchenieUKSPS  = 92;
M_OtklZvonkaUKSPS        = 93;
M_OtmenaOtkluchenieUKSPS = 94;
//----------------------------------------------------------------------------------------
M_PredvOtkluchenieUKG    = 95;
M_IspolOtkluchenieUKG    = 96;
M_OtmenaOtkluchenieUKG   = 97;
//                       =  98 - 100 ---------------------------------------------- резерв
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
//                       = 114 ---------------------------------------------------- резерв
M_ZaprosPoezdSoglasiya   = 115;
M_OtmZaprosPoezdSoglasiya= 116;
//                       = 117 - 120 ---------------------------------------------- резерв
M_DatRazreshenieManevrov = 121;
M_OtmenaManevrov         = 122;
M_PredvIRManevrov        = 123;
M_IspolIRManevrov        = 124;
//---------------------- = 125 - 130 ---------------------------------------------- резерв
M_VkluchitDen            = 131;
M_VkluchitNoch           = 132;
M_VkluchitAuto           = 133;
M_OtkluchitAuto          = 134;
//
M_Osnovnoy               = 135;
//                       = 136; //------------------------------------------------- резерв
M_RU1                    = 137;
M_RU2                    = 138;
M_ResetCommandBuffers    = 139;
//                       = 140 ---------------------------------------------------- резерв
//------------------------------------------------------------------------------------ ПАБ
M_VydatSoglasieOtpravl   = 141;
M_OtmenaSoglasieOtpravl  = 142;
M_IskPribytiePredv       = 143;
M_IskPribytieIspolnit    = 144;
M_VydatPribytiePoezda    = 145;
M_ZakrytPeregonPAB       = 146;
M_OtkrytPeregonPAB       = 147;
//                       = 148 - 150 ---------------------------------------------- резерв
//--------------------------------------------------------------------- Блокировка надвига
M_BlokirovkaNadviga      = 151;
M_DeblokirovkaNadviga    = 152;
//---------------------------------------------------------------------- Блокировка увязок
M_OtkrytUvjazki          = 153;
M_ZakrytUvjazki          = 154;
//                       = 155 - 159 ---------------------------------------------- резерв
M_RestartServera         = 160;
M_RestartUVK             = 161;
M_SnatSoglasieSmenyNapr  = 162; //----------------------------------------------------- АБ
M_PutVklOPI              = 163; //--------------------------------------------------- Путь
M_PutOtklOPI             = 164; //--------------------------------------------------- Путь
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
M_RescueOTU              = 189; //----------------------------- Восстановить интерфейс ОТУ
M_VklBit1                = 191; //----------------------------- включить для объекта бит 1
M_OtklBit1               = 192; //---------------------------- отключить для объекта бит 1
M_VklBit2                = 193; //----------------------------- включить для объекта бит 2
M_OtklBit2               = 194; //---------------------------- отключить для объекта бит 2
M_VklBit3                = 195; //----------------------------- включить для объекта бит 3
M_OtklBit3               = 196; //---------------------------- отключить для объекта бит 3
M_VklBit4                = 197; //----------------------------- включить для объекта бит 4
M_OtklBit4               = 198; //---------------------------- отключить для объекта бит 4
M_VklBit5                = 199; //----------------------------- включить для объекта бит 5
M_OtklBit5               = 200; //---------------------------- отключить для объекта бит 5
//---------------------------------------------------------------- Коды кнопок-команд меню
Key_RazdeRejim           = 1001; //---------------------- раздельный режим управления <F1>
Key_MarshRejim           = 1002; //---------------------- маршрутный режим управления <F1>
Key_MaketStrelki         = 1003; //--------------------------- установить стрелку на макет
Key_OtmenMarsh           = 1004; //--------------------------------------- отмена маршрута
Key_DateTime             = 1005; //--------------------------------- установить время <F2>
Key_InputOgr             = 1006; //--------------------------- перейти на ввод ограничений
Key_VspPerStrel          = 1007; //----------------------- вспомогательный перевод стрелок
Key_EndTrace             = 1008; //--------------------------- конец трассы маршрута <End>
Key_ClearTrace           = 1009; //------------------------------------------- <Shift+End>
Key_RejimRaboty          = 1010; //----------------------- Запрос смены режима работы АРМа
Key_ReadyResetTrace      = 1011; //---- Ждем сброса набора трассы маршрута по враждебности
Key_EndTraceError        = 1012; //-------- Конечная точка трассы маршрута указана неверно
Key_ReadyWarningTrace    = 1013; //------------ Ожидание подтверждения сообщений по трассе
Key_ReadyWarningEnd      = 1014; //------ Ожидание подтверждения сообщений по концу трассы
Key_BellOff              = 1015; //------------------------------- Отключение звонка <F12>
Key_UpravlenieUVK        = 1016; //----------------------------------- Меню управления УВК
Key_ReadyRestartServera  = 1017; //------------ Ожидание подтверждения перезапуска сервера
Key_ReadyRestartUVK      = 1018; //--------------- Ожидание подтверждения переключения УВК
Key_RezervARM            = 1019; //------------------------ Команда перевода АРМа в резерв
Key_QuerySetTrace        = 1020; //------- Запрос на установку стрелок по введенной трассе
Key_PodsvetkaStrelok     = 1021; //-------------------- Кнопка подсветки положения стрелок
Key_VvodNomeraPoezda     = 1022; //---------------------------- Кнопка ввода номера поезда
Key_PodsvetkaNomerov     = 1023; //----------------------- Кнопка подсветки номера поездов
Key_ReadyRescueOTU       = 1024; //-- Ждем подтверждения восстановления интерфейса ОТУ УВК
NetKomandy : string = 'Нет команды';

var
  IndexFR3IK : SmallInt; //--------- индекс объекта перезапуска УВК или восстановления ОТУ
  Stol       : TPoint; //--------------- Размер рабочего стола во время запуска программы

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
//------------------------------------------------------- функция добавления пункта в меню
function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
begin
    result := true;
{$IFNDEF RMARC}
{$IFNDEF TABLO}
    //----------------- если для команды есть место и команда не пустая и объект не пустой
    if (DspMenu.Count < Length(DspMenu.Items)) and (ID_Cmd > 0) and (ID_Obj > 0) then
    begin
      inc(DspMenu.Count);  //------------------------------ увеличить счетчик пунктов меню
      //--------------------------------------------------------------- создать пункт меню
      DspMenu.Items[DspMenu.Count].MenuItem := TMenuItem.Create(TabloMain);

      //--------------------------------- установить обработчик для "клика" по пункту меню
      DspMenu.Items[DspMenu.Count].MenuItem.OnClick := TabloMain.DspPopUpHandler;

      //------------------------------------------- установить код команды для пункта меню
      DspMenu.Items[DspMenu.Count].ID := DspMenu.Items[DspMenu.Count].MenuItem.Command;

      //------------------------------------------------ установить объект для пункта меню
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
//--------------------------------------- Диспетчер функций подготовки меню (запросов) ДСП
function NewMenu_(ID,X,Y : SmallInt): boolean;
//------------------------------------------------ ID = Тип обработки, связаный с объектом
//--------------------------------------------------------------- X,Y = Координата объекта
//------------------ если возвращает true - надо запустить процедуру ожидания ввода команд
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
  SetLockHint; //-------------------------------- блокировка вывода описания объекта табло
  {$ENDIF}
  DspCom.Active := false; //-------- сбросить признак наличия команды, ожидающей обработки
  DspCom.Com := 0;   //---------------------------------------------- сбросить код команды
  DspCom.Obj := 0;       //--------------------------------------- сбросить объект команды

  DspMenu.Ready := false;    //------------------ сбросить признак ожидания выбора команды
  DspMenu.obj := cur_obj; //------------------------- сохранить номер объекта под курсором
  DspMenu.Count := 0; //----------------------------------------- сброс числа пунктов меню
{$IFNDEF RMARC}
  RSTMsg;
  ShowWarning := false;
{$ENDIF}

  result := false;
//------------------------------------------------------------ Дополнить буфер команд меню
{$IFDEF RMDSP}
  msg := '';
  InsNewArmCmd(DspMenu.obj+$8000,ID); //--- добавить код меню в протокол дежурного (архив)
  //---------------------- специфичные команды, разрешенные в режиме отсутствия управления
  case ID of
    Key_PodsvetkaStrelok,   //--------------------------- Подсветка положения стрелок 1021
    Key_VvodNomeraPoezda, //-------------------------------------- Ввод номера поезда 1022
    Key_PodsvetkaNomerov,  //------------------------------- Подсветка номера поездов 1023
    Key_BellOff ://----------------------------------- Сброс фиксируемого звонка 1015 <F12
    begin
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      exit;
    end;
    //##################################################################################
    Key_DateTime : //------------------------------------------------------- 1005 <F2>
    begin //---------------------------------------------------------- Ввод времени РМ-ДСП
      DspCom.Active := true;  DspCom.Com := ID;  DspCom.Obj := 0;
      if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 / 24) then
      begin
        //------------------------------------------------------------- "изменить время ?"
        InsNewMsg(0,252+$4000,0,''); color := 0;
        msg := GetSmsg(1,252,'',color); DspMenu.WC := true; MakeMenu(X); exit;
      end else
      begin
        InsNewMsg(0,435+$4000,1,'');//---- "Коррекция времени с 22:55 до 01:05 запрещена!"
        ShowSMsg(435,LastX,LastY,''); DspMenu.WC := true; exit;
      end;
    end;
    //##################################################################################
    Key_ClearTrace : //-------------------------------------------------- 1009 <Shift+End>
    begin //----------------------------- Сброс набираемого маршрута, сброс буферов команд
      if (CmdCnt > 0) or WorkMode.MarhRdy or WorkMode.CmdReady then
      begin
        DspCom.Active := true; DspCom.Com := ID;  DspCom.Obj := 0;
      end;
      exit;
    end;
    //##################################################################################
    Key_RejimRaboty : //------------------------------------ 1010 Смена режима работы АРМа
    begin
      if config.configKRU > 0 then exit;
      if WorkMode.CmdReady then // Ввод команд временно заблокирован.Канал ТУ занят.
      begin
        InsNewMsg(0,251+$4000,1,''); ShowSmsg(251,LastX,LastY,''); exit;
      end;

      if WorkMode.Upravlenie then
      begin //--------------------------------------------------------если АРМ управляющий
        if ((StateRU and $40) = 0) or WorkMode.BU[0] then
        begin //--------------------------- если из сервера "Режим АУ" или выключен сервер
          DspCom.Active := true;
          DspCom.Com := Key_RezervARM;
          color := 7;
          InsNewMsg(0,225+$4000,color,''); //------ "подтвердите перевод АРМ-ДСП в резерв"
          msg := GetSmsg(1,225,'',color);
          DspMenu.WC := true;
          result := true;
          MakeMenu(X);
          exit;
        end;
      end
      else
      begin //--------------------------------------------------------- если АРМ в резерве
        if WorkMode.OtvKom then
        begin
          InsNewMsg(0,224+$4000,0,''); //-------------------------- "включить управление?"
          //------------------------------------------------------ M_Osnovnoy = 135;
          color := 0;
          AddDspMenuItem(GetSmsg(1,224,'',color),M_Osnovnoy,ID_Obj);
          DspMenu.WC := true;//--------------------------------------- ждать подтверждения
          MakeMenu(X);
          exit;
        end else
        begin //------------------------------------ не нажата кнопка ответственных команд
          InsNewMsg(0,276,1,''); //------------------------- "Действие требует нажатия ОК"
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
    begin //----------------------------------------------- Команды управления работой УВК
      if WorkMode.CmdReady then
      begin
        InsNewMsg(0,251+$4000,1,'');//-- Ввод команд временно заблокирован. Канал ТУ занят
        ShowSmsg(251,LastX,LastY,'');
        exit;
      end;
      if WorkMode.OtvKom then //------------------------------------ если нажата кнопка ОК
      begin
        if config.configKRU = 0 then
        begin
          InsNewMsg(0,347+$4000,7,'');//------------ "Выдать команду перезапуска сервера?"
          color := 7;
          AddDspMenuItem(GetSmsg(1,347,'',color),M_RestartServera,ID_Obj);
        end;
        for i := 1 to high(ObjZv) do //---- сборка меню из объектов перезапуска всех ТУМС
        begin
          if ObjZv[i].TypeObj = 37 then //-------------- если это объект контроллера ТУМС
          begin
            InsNewMsg(i,348+$4000,7,'');//--- "Выдать команду переключения комплектов ИК?"
            color := 7;
            AddDspMenuItem(GetSmsg(1,348,ObjZv[i].Liter,color),M_RestartUVK,i);
            if ObjZv[i].ObCB[1] then//----------- если этот объект - контроллер МСТУ
            begin
              InsNewMsg(i,505+$4000,7,''); //------------ "Восстановить интерфейс ОТУ ИК?"
              color := 7;
              AddDspMenuItem(GetSmsg(1,505,ObjZv[i].Liter,color),M_RescueOTU,i);
            end;
          end;
        end;
        DspMenu.WC := true; //--------------------------------------- ждать подтвверждения
        MakeMenu(X);
        exit;
      end else
      begin //-------------------------------------- не нажата кнопка ответственных команд
        InsNewMsg(0,276,1,''); //-------------------- "Действие требует нажатия кнопки ОК"
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
    begin //------------------------------------Ожидание подтверждения перезапуска сервера
      DspCom.Active := true;
      DspCom.Com := ID;
      color := 7;
      InsNewMsg(0,351+$4000,7,'');//----- "Подтвердите выдачу команды перезапуска сервера"
      msg := GetSmsg(1,351,'',color);
      DspMenu.WC := true;
      result := true;
      MakeMenu(X);
      exit;
    end;
    //##################################################################################
    Key_ReadyRestartUVK ://---------------------------------------------------------- 1018
    begin //-------------------------------------- Ожидание подтверждения переключения УВК
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := IndexFR3IK;
      color :=  7;
      InsNewMsg(DspCom.Obj,352+$4000,color,''); //"подтвердите команду переключения УВК"
      msg := GetSmsg(1,352,ObjZv[DspCom.Obj].Liter,color);
      DspMenu.WC := true;
      result := true;
      IndexFR3IK := 0;
      MakeMenu(X);
      exit;
    end;
    //##################################################################################
    Key_ReadyRescueOTU : //----------------------- ожидание команды восстановления ОТУ
    begin //
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := IndexFR3IK;
      color :=  7;
      InsNewMsg(DspCom.Obj,504+$4000,color,'');// подтвердите команду восстановления ОТУ
      msg := GetSmsg(1,504,ObjZv[DspCom.Obj].Liter,color);
      DspMenu.WC := true;
      result := true;
      IndexFR3IK := 0;
      MakeMenu(X);
      exit;
    end;
  end;//---------------------------------------------------------- конец первого "case ID"

  if LockDirect then exit; //----------------------- если ввод команд заблокирован - выйти

  if CheckOtvCommand(ID_Obj) then //проверить наличие активной ответственной для объекта
  begin
    OtvCommand.Active := false;
	  WorkMode.GoOtvKom := false;
		OtvCommand.Ready := false;
    ShowSmsg(153,LastX,LastY,''); //---- "Исполнительная противоречит предварительной"
//      SingleBeep := true;
    InsNewMsg(0,153,1,'');
    exit;
  end;
{$ENDIF}

  //======================================= Сформировать меню/подтверждение выбора команды
  case ID of
{$IFDEF RMDSP}
    //##################################################################################
    Key_RazdeRejim : //-------------------------------------------------------------- 1001
    begin //--------------------------------------------- Переключение режима "Раздельный"
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      color := 7;
      InsNewMsg(DspCom.Obj,95+$4000,color,'');//--- установлен раздельный режим управления
      msg := GetSmsg(1,95,'',color);
      result := false;
    end;
    //##################################################################################
    Key_MarshRejim ://------------------------------- Переключение режима "Маршрутный"
    begin
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      color :=  2;
      InsNewMsg(DspCom.Obj,96+$4000,color,''); // установлен маршрутный режим управления
      msg := GetSmsg(1,96,'',color);
      result := false;
    end;
    //##################################################################################
    Key_MaketStrelki : //------------------------- Включение/выключение макета стрелок
    begin
      if WorkMode.OtvKom then
      begin //-------------------------- если  нажата ОК - прекратить формирование команды
        ResetCommands;
        InsNewMsg(0,283,1,''); //-------------------- "нажата кнопка ответственных команд"
        ShowSmsg(283,LastX,LastY,'');
        color := 1;
        msg := GetSmsg(1,283, ObjZv[ID_Obj].Liter,color);
        exit;
      end;

      ResetTrace; //---------------------------------------------- Сбросить набор маршрута
      WorkMode.MarhOtm := false;
      WorkMode.VspStr := false;
      WorkMode.InpOgr := false;

      if maket_strelki_index > 0 then //---------------------- если на макете есть стрелка
      begin //--------------------------------------------- запрос снятия стрелки с макета
        DspCom.Com := M_SnatMaketStrelki;
        DspCom.Obj := maket_strelki_index;
        color := 7;
        InsNewMsg(DspCom.Obj,172+$4000,color,'');
        msg := GetSmsg(1,172, maket_strelki_name,color);//"снять с макета стрелку ?"
        DspMenu.WC := true;
      end else //---------------------------------------------- если на макете стрелки нет
      if WorkMode.GoMaketSt then  //----------------- если идет установка стрелки на макет
      begin //----------------------- Снять признак выбора стрелки для постановки на макет
        WorkMode.GoMaketSt := false;
        RSTMsg;
        exit;
      end else //--------------------------------- если пока нет режима установки на макет
      begin //------------------------------------- Выбрать стрелку для установки на макет
        for i := 1 to High(ObjZv) do //-------------------------- пройти по всем объектам
        begin  //------------------------ и выполнить проверку подключения макетного шнура
          if(ObjZv[i].RU = config.ru)and(ObjZv[i].TypeObj = 20) then // вышли на макет
          begin
            if ObjZv[i].bP[2] then //----------------------------------- если есть КМ
            begin //--------------------------------------------- Запросить номера стрелки
              WorkMode.GoMaketSt := true;
              InsNewMsg(0,8+$4000,7,''); //------ "Укажите стрелку для установки на макет"
              ShowSmsg(8,LastX,LastY,'');
            end else //------------------------------------------------------- если нет КМ
            begin //------------------------------------------- макетный шнур не подключен
              RSTMsg;
              InsNewMsg(0,90,1,''); //---------------- "Не подключен шнур макета стрелок!"
              ShowSmsg(90,LastX,LastY,'');
              color := 1;
              AddFixMes(GetSmsg(1,90,'',color),4,2);
            end;
            exit; //----------- выход после обнаружения комплекта макета и выбора действия
          end;
        end;
        exit; //--- выход после прохода по всем объектам при не найденном комплекте макета
      end;
    end;
    //##################################################################################
    Key_OtmenMarsh, //-------------------- Включение/выключение режима отмены маршрута
    Key_InputOgr ,//-------------------- Включение/выключение режима ввода ограничений
    Key_VspPerStrel: //Включение/выключение режима вспомогательного перевода стрелок
    begin
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      exit;
    end;
    //##################################################################################
    Key_EndTrace :
    begin //------------------------------------------------- Конец набора маршрута = 1008
      DspCom.Active := true;
      DspCom.Com := ID;
      DspCom.Obj := 0;
      if MarhTrac.WarN > 0 then  //------------ если есть предупреждения при установке
      begin
        msg := MarhTrac.War[MarhTrac.WarN];//---------------- показать предупреждение
        InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1],1,'');
      end
      else   exit; //----------------------------------------------------- иначе закончить
    end;
    //##################################################################################
    Key_EndTraceError :
    begin //----------- Выдать предупреждение, что конечная точка маршрута указана неверно
      DspCom.Active := true;
      DspCom.Com := Key_ClearTrace;
      DspCom.Obj := 0;
      InsNewMsg(0,87,1,'');
      ShowSmsg(87,LastX,LastY,'');
      exit;
    end;
    //##################################################################################
    CmdMarsh_Ready : //-------------------------------------------------------------- 1102
    begin //----------------------------------- Запросить подтверждение установки маршрута
      DspMenu.obj := cur_obj;
      case MarhTrac.Rod of //------------------------------ переключатель по роду маршрута
        MarshM :    //---------------------------------------------------- если маневровый
        begin
          DspCom.Active := true;
          DspCom.Com := CmdMarsh_Manevr;
          DspCom.Obj := ID_Obj;
          color := 7;
          InsNewMsg(MarhTrac.ObjStart,6+$4000,color,'');//--- Установить маневровый марш.?
          TXT := ObjZv[MarhTrac.ObjStart].Liter;
          msg := GetSmsg(1,6, TXT + MarhTrac.TailMsg,color);
          DspMenu.WC := true;
        end;
        MarshP ://---------------------------------------------------------- если поездной
        begin
          DspCom.Active := true;
          DspCom.Com := CmdMarsh_Poezd;
          DspCom.Obj := ID_Obj;
          color := 2;
            InsNewMsg(MarhTrac.ObjStart,7+$4000,color,'');//"Установить поездной маршрут?"
            TXT := ObjZv[MarhTrac.ObjStart].Liter;
            msg := GetSmsg(1,7, TXT + MarhTrac.TailMsg,color);
            DspMenu.WC := true;
          end;
          else exit;
        end;
      end;
      //##################################################################################
      CmdMarsh_RdyRazdMan :
      begin //--------------------------------------- Запрос открытия раздельным маневрового
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
      begin //----------------------------------------- Запрос открытия раздельным поездного
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
      begin //---------------------------- Вывод сообщений перед повторным открытием сигнала
        if MarhTrac.WarN > 0 then
        begin
          DspCom.Com := ID;
          DspCom.Obj := ID_Obj;
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. Продолжать?';
          DspMenu.WC := true;
          dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      CmdMarsh_PovtorMarh  :
      begin //-------------------------- Вывод сообщений перед повторной установкой маршрута
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. Продолжать?';
          DspCom.Com := ID;  DspCom.Obj := ID_Obj;
          DspMenu.WC := true; dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      CmdMarsh_PovtorOtkryt  :
      begin //-------- Вывод сообщений перед повторным открытием сигнала в раздельном режиме
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. Продолжать?';
          DspCom.Com := ID;  DspCom.Obj := ID_Obj;
          DspMenu.WC := true; dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      CmdMarsh_Razdel :
      begin //------- Вывод сообщений перед открытием сигнала в раздельном режиме управления
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN] + '. Продолжать?';
          DspCom.Com := ID; DspCom.Obj := ID_Obj;
          DspMenu.WC := true; dec(MarhTrac.WarN);
        end;
      end;
      //##################################################################################
      Key_QuerySetTrace :
      begin //--------------- Запрос на выдачу команды установки стрелок по введенной трассе
        SBeep[2] := true;
        TimeLockCmdDsp := LastTime;
        LockComDsp := true;
				ShowWarning := true;
        DspCom.Active := true;
        DspCom.Com := Key_QuerySetTrace;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(MarhTrac.ObjStart,442+$4000,color,'');//"Установить стрелки по трассе ?"
        TXT := ObjZv[MarhTrac.ObjStart].Liter;
        msg := GetSmsg(1,442,TXT + MarhTrac.TailMsg,color);
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
      //##################################################################################
      Key_ReadyResetTrace :
      begin //------------------- Ожидается сброс набираемой трассы маршрута по враждебности
        ShowWarning := true;
        if MarhTrac.GonkaStrel and (MarhTrac.GonkaList > 0) then
        begin
          InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1]+$5000,7,'');
          msg := MarhTrac.Msg[1] + '. Возможен перевод стрелок. Продолжать?';
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
      Key_ReadyWarningTrace : //----------------- Ожидание подтверждения сообщений по трассе
      begin //------------------------- Ожидается подтверждение сообщения по трассе маршрута
        if MarhTrac.WarN > 0 then //--------------- если есть предупреждения или запреты
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN]+ '. Продолжать?';
          DspMenu.WC := true; DspCom.Com := CmdMarsh_Tracert;
          DspCom.Active := true; DspCom.Obj := ID_Obj;
          DspMenu.WC := true;
        end;
      end;
      //##################################################################################
      Key_ReadyWarningEnd :
      begin //----------------- Ожидается подтверждение сообщения по концу трассы маршрута
        if MarhTrac.WarN > 0 then
        begin
          ShowWarning := true;
          InsNewMsg(MarhTrac.WarObj[1],MarhTrac.WarInd[1]+$5000,7,'');
          msg := MarhTrac.War[MarhTrac.WarN]+ '. Продолжать?';
          DspMenu.WC := true;   DspCom.Com := Key_EndTrace;
          DspCom.Active := true; DspCom.Obj := ID_Obj;
        end;
      end;
      //##################################################################################
      CmdStr_ReadyMPerevodPlus :
      begin //----------------------------- Подтверждение перевода макетной стрелки в плюс
        //------------------------------------------ "стрелка на макете.Перевести в плюс?"
        DspCom.Com := CmdStr_ReadyMPerevodPlus;
        DspCom.Obj := ID_Obj;
        color := 2;
        InsNewMsg(ObjZv[ID_Obj].BasOb,101+$4000,color,'');
        msg := GetSmsg(1,101,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyMPerevodMinus :
      begin //------ Подтверждение перевода стрелки в "стрелка на макете.Перевести в минус?"
        DspCom.Com := CmdStr_ReadyMPerevodMinus;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ObjZv[ID_Obj].BasOb,102+$4000,color,'');
        msg:=GetSmsg(1,102,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_AskPerevod :
      begin //------------------------------------------------------------ перевод стрелки
        with ObjZv[ID_Obj] do
        begin
        if bP[1] then
        begin //------------------------------------------------------------------ в минус
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
        end else //---------------------------------------------------------------- в плюс
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
        begin //------------------------------------------------------------------ по выбору
          //-------------- последняя команда + или (последняя не - и последний контроль "+")
          if bP[22] or (not bP[23] and bP[20]) then msg := ' <' else msg := '';//метим "-"
          InsNewMsg(BasOb,165+$4000,7,'');
          color := 7;
          AddDspMenuItem(GetSmsg(1,165,msg,color), M_StrPerevodMinus,ID_Obj); //---- в минус
          if bP[23] or (not bP[22]and not bP[23]and bP[21]) then msg:= ' <' else msg:= '';
          InsNewMsg(BasOb,164+$4000,2,'');
          color := 2;
          AddDspMenuItem(GetSmsg(1,164,msg,color),M_StrPerevodPlus,ID_Obj); //------- в плюс
        end;
        DspMenu.WC := true;
       end;
      end;
 {$ENDIF}
      //##################################################################################
      CmdManevry_ReadyWar :
      begin //----------------------------------- Ожидание подтверждения передачи на маневры
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
      begin //---------------------------------------- Подтверждение перевода стрелки в плюс
        DspCom.Com := CmdStr_ReadyPerevodPlus;
        DspCom.Obj := ID_Obj;
        color := 2;
        InsNewMsg(ObjZv[ID_Obj].BasOb,97+$4000,color,'');
        msg := GetSmsg(1,97,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyPerevodMinus :
      begin //--------------------------------------- Подтверждение перевода стрелки в минус
        DspCom.Com := CmdStr_ReadyPerevodMinus;
        DspCom.Obj := ID_Obj; //---------------------------- индекс объекта для команды в OZ
        color := 7;
        InsNewMsg(ObjZv[ID_Obj].BasOb,98+$4000,color,'');
        msg := GetSmsg(1,98,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyVPerevodPlus :
      begin //----------------------- Подтверждение вспомогательного перевода стрелки в плюс
        DspCom.Com := CmdStr_ReadyVPerevodPlus;
        DspCom.Obj := ID_Obj;
        color := 2;
        InsNewMsg(ObjZv[ID_Obj].BasOb,99+$4000,color,'');
        msg := GetSmsg(1,99,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      CmdStr_ReadyVPerevodMinus :
      begin //---------------------- Подтверждение вспомогательного перевода стрелки в минус
        DspCom.Com := CmdStr_ReadyVPerevodMinus;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ObjZv[ID_Obj].BasOb,100+$4000,color,'');
        msg := GetSmsg(1,100,ObjZv[ObjZv[ID_Obj].BasOb].Liter,color);
        DspMenu.WC := true;
      end;
      //##################################################################################
      ID_Tracert :
      begin //---------------------------- ID_Tracert = 34 трассировка по острякам стрелок
        DspCom.Active  := true;
        DspCom.Com := CmdMarsh_Tracert; //-------- вторичная команда CmdMarsh_Tracert=1101
        DspCom.Obj := ID_Obj;
        exit;
      end;
 {$ENDIF}
      //##################################################################################
      //************************************************************************** Стрелка
      ID_Strelka : result := NewMenu_Strelka(X,Y);

      //##################################################################################
      //************************************ Светофоры (маневровый, совмещенный и входной)
      ID_SvetoforManevr,
      ID_SvetoforSovmech,
      ID_SvetoforVhodnoy :
      result := NewMenu_Svetofor(X,Y);

      //##################################################################################
      //********************************************** управление автодействием светофоров
      ID_AutoSvetofor : result := NewMenu_AvtoSvetofor(X,Y);

      //##################################################################################
      //***************************************** подготовка кнопочной команды на 1-ый бит
      ID_1bit : result := NewMenu_1bit(X,Y);

      //##################################################################################
      //------------------------------------------- подготовка кнопочной команды на 2-ой бит
      ID_2bit : result := NewMenu_2bit(X,Y);

      //##################################################################################
      //----------------------- подготовка кнопочной команды в зависимости от состояния бита
      ID_VklOtkl_bit1 : result := NewMenu_VklOtkl1bit(X,Y);

      //##################################################################################
    //------------------- подготовка команды закрытия или ответственного открытия переезда
    ID_PrzdZakrOtkr : result := NewMenu_PRZDZakrOtkr(X,Y);
    ID_ZaprRazrMont : result := NewMenu_ZaprRazrMont(X,Y); //------ запрет/разреш монтерам
    ID_VydPSogl     : result := NewMenu_VydPSogl(X,Y);//------ меню выдачи согласия соседу
    ID_Nadvig       : result := NewMenu_Nadvig(X,Y);   //---------- меню "Надвиг на горку"
    ID_Uchastok     : result := NewMenu_Uchastok(X,Y);//-- меню управления объектом СП(УП)
    ID_PutPO        : result := NewMenu_PutPO(X,Y);//----- меню управления объектом "Путь"
    ID_OPI          : result := NewMenu_OPI(X,Y); //--- "ОПИ"(исключение пути из маневров)
    ID_ZaprPSogl    : result := NewMenu_PSogl(X,Y);//- Запрос поездного отправления соседу

    ID_SmenaNapravleniya :  //------------------------------------------------ Увязка с АБ
    begin gotomen := false; result := NewMenu_SmenaNapravleniya(X,Y,gotomen);
      {$IFDEF RMDSP} if gotomen then begin MakeMenu(X); exit; end; {$ENDIF}
    end;
    ID_KSN               : result := NewMenu_KSN(X,Y);//Подкл. комплекта смены направления
    ID_PAB               : result := NewMenu_PAB(X,Y);//------- Управление полуавтоматикой
    ID_ManKol            : result := NewMenu_ManKol(X,Y); //----------- Маневровая колонка
    ID_ZamykStr          : result := NewMenu_ZamykStr(X,Y); //---------- Замыкание стрелок
    ID_RazmykStr         : result := NewMenu_RazmykanieStrelok(X,Y);//- Размыкание стрелок
    ID_ZakrytPereezd     : result := NewMenu_ZakrytPereezd(X,Y); //------- Закрыть переезд
    ID_OtkrytPereezd     : result := NewMenu_OtkrytPereezd(X,Y); //------- Открыть переезд
    ID_IzvPer1,ID_IzvPer : result := NewMenu_IzvPereezd(X,Y);//------ Извещение на переезд
    ID_PoezdOpov         : result := NewMenu_PoezdOpov(X,Y);//Вкл/откл Поездное оповещение
    ID_ZapMont           : result := NewMenu_ZapretMont(X,Y); //-------- "Запрет монтерам"
    ID_OtklZapMont       : result := NewMenu_Otkl_ZapretMont(X,Y);// откл. запрет монтерам
    ID_VykluchenieUKSPS  : result := NewMenu_OtklUKSPS(X,Y);//------ меню отключения УКСПС
    ID_OtklUKG           : result := NewMenu_OtklUKG(X,Y);//- создание меню отключения УКГ
    ID_VklUKG            : result := NewMenu_VklUKG(X,Y); //---------------- УКГ включение
    ID_VspomPriem        : result := NewMenu_VspomPriem(X,Y);//----- Вспомогательный прием
    ID_VspomOtpravlenie  : result := NewMenu_VspOtpr(X,Y); //-------- Вспомог. отправление
    ID_OchistkaStrelok   : result := NewMenu_OchistkaStrelok(X,Y);//------ Очистка стрелок
    ID_VkluchenieGRI1    : result := NewMenu_VklGRI1(X,Y);//------ Включение выдержки ГРИ1
    ID_PutManevrovyi     : result := NewMenu_PutIzvst(X,Y);//--------- путевой известитель
    ID_RezymPitaniyaLamp : result := NewMenu_DSNLamp(X,Y); //------------ Питание ламп ДСН
    ID_RezymLampDen      : result := NewMenu_RezymLampDen(X,Y); //---- Вкл.дневного режима
    ID_RezymLampNoch     : result := NewMenu_RezymLampNoch(X,Y);//---- Вкл. ночного режима
    ID_RezymLampAuto     : result := NewMenu_RezymLampAuto(X,Y);  //------ Вкл. авторежима
    ID_OtklZvonkaUKSPS   : result := NewMenu_OtklZvonkaUKSPS(X,Y);//---- откл.звонка УКСПС
{$IFNDEF RMDSP}
    ID_GroupDat :
    begin//--------------------------------------------- Группа теневых датчиков на АРМ-ШН
      DspMenu.obj := cur_obj;
      ID_ViewObj := ID_Obj;
      result := true;
      exit;
    end;
{$ENDIF}
    else   DspCom.Com := 0;   DspCom.Obj := 0;   exit;
  end;
{$IFDEF RMDSP}
//mkmnu : //------------------------------------------------------------- формирование меню
  if DspMenu.Count > 0 then //---------------------------------- если есть что-то для меню
  begin
    TabloMain.PopupMenuCmd.Items.Clear; //---------------------------- очистить меню табло
    for i := 1 to DspMenu.Count  do
    TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//------- взять из DspMenu
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
  begin //---------------------------- Вывести подсказку перед выполнением простой команды
    j := x div configRU[config.ru].MonSize.X + 1; //-------------------- Найти номер табло
    for i := 1 to High(SMsg) do
    //------------------- если это то табло, которое соответствует району управления
    if (i = j) and (Smsg[i] = '') and (msg <> '') then Smsg[i] := msg;
  end;
{$ENDIF}
end;

{$IFDEF RMDSP}
//========================================================================================
//------------ Проверка условий допустимости возбуждения начального признака для светофора
function CheckStartTrace(Index : SmallInt) : string;
var
  color : Integer;
begin
    result := '';
    case ObjZv[Index].TypeObj of
      33 :
      begin //--------------------------------------------- если это дискретный датчик FR3
        if ObjZv[Index].ObCB[1] then //--------------------- если инверсия состояния
        begin
          if ObjZv[Index].bP[1]  //----------------------------- если датчик = .True.
          then
            result := MsgList[ObjZv[Index].ObCI[3]]; //------ сообщить об отключении
        end else
        begin //--------------------------------------------------------- прямое состояние
          if not ObjZv[Index].bP[1]  //------------------ состояние датчика = .False.
          then result := MsgList[ObjZv[Index].ObCI[2]]; //---- сообщение о включении
        end;
      end;

      35 :
      begin //-------- Доступ к внутренним свойствам контролируемого объекта (зависимости)
        if ObjZv[Index].ObCB[1] then
        begin //-------------------------------------------------- если инверсия состояния
          if ObjZv[Index].bP[1]
          then result := MsgList[ObjZv[Index].ObCI[2]]; //------- сообщить об отказе
        end else
        begin //--------------------------------------------------------- прямое состояние
          if not ObjZv[Index].bP[1]
          then result := MsgList[ObjZv[Index].ObCI[2]]; //------- сообщить об отказе
        end;
      end;

      47 :
      begin //----------------------------------- Проверка включения автодействия сигналов
        color := 1;
        if ObjZv[Index].bP[1]   //------------------ если есть включение автодействия
        then result := GetSmsg(1, 431, ObjZv[Index].Liter,color);//включено автодейс.
      end;
    end;
end;

//========================================================================================
//------------ Проверка условий допустимости возбуждения начального признака для светофора
function CheckAutoON(Index : SmallInt) : Boolean;
begin
  result := false;
  if index = 0 then exit;
  if ObjZv[Index].TypeObj <> 47 then exit;
  // Проверка включения автодействия сигналов
  if ObjZv[Index].bP[1] then result := true;
end;

//========================================================================================
//----- Проверить условия перезамыкания поездного маршрута маневровым для протяжки состава
function CheckProtag(Index : SmallInt) : Boolean;
var
  o,put : integer;
begin
    result := false;
    o := ObjZv[Index].ObCI[17];
    if o < 1 then exit;

    if ObjZv[o].TypeObj <> 42 then exit; //-------------------- нет объекта перезамыкания
    put :=  ObjZv[o].ObCI[7];

    if ObjZv[ObjZv[index].BasOb].bP[2]
    then exit; //--------------------------- перекрывная секция не замкнута - нет протяжки

    if ObjZv[o].bP[1] and //--------------------------- поездной маршрут прием  и ...
    ObjZv[o].bP[2] and //----------------------------------- разрешено перезамыкание
    not (ObjZv[put].bP[1] or ObjZv[put].bP[16]) then //--- занят путь прибытием  
    begin
      if ObjZv[Index].ObCB[17] then
      begin //------------------------------------------------- с возбуждением признака НМ
        DspCom.Com := M_OtkrytManevrovym;
        DspCom.Obj := ID_Obj;
        DspMenu.WC := true;
      end else
      begin //------------------------------------------------ без возбуждения признака НМ
        DspCom.Com := M_OtkrytProtjag;
        DspCom.Obj := ID_Obj;
        DspMenu.WC := true;
      end;
      result := true;
    end;
end;

//========================================================================================
//----------------------------------------- проверка завершения установки стрелки на макет
function CheckMaket : Boolean;
var
  i : integer;
begin
    result := false;
    for i := 1 to High(ObjZv) do //------------------------------ проход по всем объектам
    begin
      if (ObjZv[i].RU = config.ru) and //-------------------------- если свой район и ...
      (ObjZv[i].TypeObj = 20) then //------------------------- это объект контроля макета
      begin
        if ObjZv[i].bP[2] then //--------------- Проверка подключения макетного шнура
        result := (maket_strelki_index < 1);
        exit;
      end;
    end;
end;
{$ENDIF}

//========================================================================================
//--------------------------------------- функция установки и отмены блокировок управления
function LockDirect : Boolean;
begin
     result := true;
{$IFDEF RMDSP}
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin
      InsNewMsg(0,76,1,''); //------------------------------------- "Управление отключено"
      ShowSmsg(76,LastX,LastY,'');
      exit;
    end;

    if (ID_Obj > 0) and (ID_Obj < 4096) and not WorkMode.OU[ObjZv[ID_Obj].Group] then
    begin
      InsNewMsg(0,76,1,'');  //------------------------------------ "Управление отключено"
      ShowSmsg(76,LastX,LastY,'');
      exit;
    end;

    if WorkMode.CmdReady then
    begin
      InsNewMsg(0,251,1,''); //-------- "Ввод команд временно заблокирован.Канал ТУ занят"
      ShowSmsg(251,LastX,LastY,'');
     end
    else result := false;
{$ENDIF}
end;

//========================================================================================
//----------------------------------- Функция подготовки меню ДСП при управлении сигналами
function NewMenu_Svetofor(X, Y : SmallInt): boolean;
//ID  идентификатор (ID_SvetoforManevr,ID_SvetoforSovmech, ID_SvetoforVhodnoy)
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
    InsNewMsg(ID_Obj,431+$4000,1,'');//---------------------------" включено автодействие"
    WorkMode.InpOgr := false;  //---------------------------- прекратить работу с сигналом
    ShowSmsg(431, LastX, LastY, '');
    exit;
  end;

{$IFNDEF RMDSP}
  if ObjZv[ID_Obj].bP[23] or //-------------- если было воспринято перекрытие или ...
  ((ObjZv[ID_Obj].bP[5] or //------------------------- есть ненорма огневушки или ...
  ObjZv[ID_Obj].bP[15] or //--------------------------------- есть ненорма Со или ...
  ObjZv[ID_Obj].bP[17] or //------------------------------- есть авария шкафа или ...
  ObjZv[ID_Obj].bP[24] or //-------------------------------- есть ненорма зСо или ...
  ObjZv[ID_Obj].bP[25]) and //-------------------------------- есть ненорма ВНП и ...
  not ObjZv[ID_Obj].bP[20] and //-------- нет признака восприятия неисправности и ...
  not WorkMode.GoTracert) then //------------------------------ нет выполнения трассировки
  begin //------------------------------------------------ снять мигание при неисправности
    ObjZv[ID_Obj].bP[23] := false; //-------------------- снять восприятие перекрытия
    ObjZv[ID_Obj].bP[20] := true; //------------------- установить восприятие ненормы
  end;

  ID_ViewObj := ID_Obj;  //------------ номнер объекта для формирования описания состояния
  result := true;
  exit;
{$ELSE}

  ObjZv[ID_Obj].bP[34]:=false; //-------- снять требование повтора установки маршрута

  //:::::::::::::::::::::::::::::::::::::::::::::::::::::: ВСПОМОГАТЕЛЬНЫЙ ПЕРЕВОД :::::::
  if ActivenVSP(ID_Obj) then exit;

  //------------------------------------- режим работы "МАКЕТ ИЛИ ВСПОМОГАТЕЛЬНЫЙ ПЕРЕВОД"
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;

  if WorkMode.OtvKom then //:::::::::::::::::::::: ЕСЛИ ОТВЕТСТВЕННЫЕ КОМАНДЫ ::::::::::::
  begin //------------------- нажата ОК - нормализовать признаки трассировки для светофора
    InsNewMsg(ID_Obj,311+$4000,7,'');  //------------------------------- "Нормализовать ?"
    color := 7;
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,color);
    DspCom.Com := CmdMarsh_ResetTraceParams; //-------- команда снятия трассировки
    DspCom.Obj := ID_Obj;
  end else

  begin //::::::::::::::::::::::::::::::::::::: ОБЫЧНЫЙ РЕЖИМ ::::::::::::::::::::::::::::
    if ObjZv[ID_Obj].bP[23] and //----------------- если есть восприятие перекрытия и
    not WorkMode.GoTracert then  //---------------------------- не выполняется трассировка
    begin
      ObjZv[ID_Obj].bP[23] := false;//--------- восприятие перекрытия светофора снять
      exit;
    end;

    if ObjZv[ID_Obj].bP[18] then //----------------------------------- если РМ или МИ
    begin
      InsNewMsg(ID_Obj,232+$4000,1,'');//------------------ "сигнал на местном управлении"
      WorkMode.GoMaketSt := false; //----------------- прекратить режим установки на макет
      ShowSmsg(232,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end;

    if WorkMode.InpOgr then //------------------------------------------- ввод ограничений
    begin
      if ObjZv[ID_Obj].bP[33] then //--- если автодействие включено для этого сигнала
      begin
        InsNewMsg(ID_Obj,431+$4000,1,'');//-----------------------" включено автодействие"
        WorkMode.InpOgr := false;  //------------------ прекратить режим ввода ограничений
        ShowSmsg(431, LastX, LastY, '');
        exit;
      end;

      if ObjZv[ID_Obj].bP[14] then //-------------- если программное замыкание в АРМе
      begin
        InsNewMsg(ID_Obj,238+$4000,1,'');//-------------------- "светофор в трассе маршрута"
        WorkMode.InpOgr := false;  //------------------ прекратить режим ввода ограничений
        ShowSmsg(238, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end;

      //------------------------------------------- далее, если нет программного замыкания


      //-------------------------------------- если блокировки не совпали в АРМе и сервере
      if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
      begin
        InsNewMsg(ID_Obj,179+$4000,7,'');//------------------------ "заблокировать светофор"
        InsNewMsg(ID_Obj,180+$4000,7,'');//----------------------- "разблокировать светофор"
        color := 7;
        AddDspMenuItem(GetSmsg(1,179, '',color),M_BlokirovkaSvet,ID_Obj);
        AddDspMenuItem(GetSmsg(1,180, '',color),M_DeblokirovkaSvet,ID_Obj);
      end else
      if ObjZv[ID_Obj].bP[13] then //---------------------------- если сигнал заблокирован
      begin
        DspCom.Com := M_DeblokirovkaSvet;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ID_Obj,180+$4000,7,''); //----------------- "разблокировать светофор $?"
        msg := GetSmsg(1,180, ObjZv[ID_Obj].Liter,color);
      end else//------------------------------------------------ если сигнал не блокирован
      begin
        DspCom.Com := M_BlokirovkaSvet;
        DspCom.Obj := ID_Obj;
        color := 7;
        InsNewMsg(ID_Obj,179+$4000,color,''); //-------------- "заблокировать светофор $?"
        msg := GetSmsg(1,179, ObjZv[ID_Obj].Liter,color);
      end;
    end else //------------------------------------------- далее, если не ввод ограничений

    if WorkMode.MarhOtm then //-------------------------------------- если отмена маршрута
    begin
      if ObjZv[ID_Obj].bP[33] then
      begin //----------------------------------------------- если сигнал на автодействии
        color := 1;
        msg := GetSmsg(1,431,ObjZv[ID_Obj].Liter,color);
        if msg <> '' then //------------------------------ если есть текст сообщений ...
        begin
          PutSmsg(1,LastX,LastY,msg);  //--- выдать текст сообщения на экран и выйти
          exit;
        end;
      end;

      if ObjZv[ID_Obj].ObCB[3] and  //------------- если есть начало маневровых и...
      (ObjZv[ID_Obj].bP[6] or //--------------------------- есть НМ из сервера или...
      ObjZv[ID_Obj].bP[7]) or //------------------------- есть МПР трассировки или...
      (ObjZv[ID_Obj].bP[1] or //------------------------------------ есть МС1 или ...
      ObjZv[ID_Obj].bP[2]) then //------------------------------------------ есть МС2
      begin
        if ObjZv[ID_Obj].bP[2] then //--------------------------------- если есть МС2
        begin //-------- если сигнал открыт - проверить условие маневровой отмены маршрута
          msg := GetSoglOtmeny(ObjZv[ID_Obj].ObCI[19]); //- получить текст сообщения
          if msg <> '' then //------------------------------ если есть текст сообщений ...
          begin
            PutSmsg(1,LastX,LastY,msg);  //--- выдать текст сообщения на экран и выйти
            exit;
          end;
        end;

        InsNewMsg(ID_Obj,175+$4000,7,''); //-------------- "отменить маневровый маршрут ?"
        msg := '';
        case GetIzvestitel(ID_Obj,MarshM) of
          1 :
          begin
            color := 1;
            msg := GetSmsg(1,329, '',color) + ' '; //"поезд на предмаршрутном участке"
            InsNewMsg(ID_Obj,329+$5000,1,'');
          end;

          2 :
          begin
            color := 1;
            msg := GetSmsg(1,330, '',color) + ' '; //------------- "поезд на маршруте"
            InsNewMsg(ID_Obj,330+$5000,1,'');
          end;

          3 :
          begin
            color := 1;
            msg := GetSmsg(1,331, '',color) + ' '; //-- "поезд на участке приближения"
            InsNewMsg(ID_Obj,331+$5000,1,'');
          end;
        end;
        color := 7;
        msg:=msg+GetSmsg(1,175,'от '+ObjZv[ID_Obj].Liter,color);//отменить маневровый
        DspCom.Com := M_OtmenaManevrovogo;
        DspCom.Obj := ID_Obj;
      end else

      if ObjZv[ID_Obj].ObCB[2] and//сигнал может иметь начало поездных маршрутов и..
      (ObjZv[ID_Obj].bP[8] or //-------------- есть признак начала из сервера или ...
      ObjZv[ID_Obj].bP[9]) or //--- есть признак поездной трассировки сигнала или ...
      (ObjZv[ID_Obj].bP[3] or //--------------------------- включен сигнал С1 или ...
      ObjZv[ID_Obj].bP[4]) then  //-------------------------------- включен сигнал С2
      begin //---------------------------------------------------------- отменить поездной
        if ObjZv[ID_Obj].bP[4] then //------------------------------- если включен С2
        begin //-------------- если сигнал открыт - проверить допустимость отмены маршрута
          msg := GetSoglOtmeny(ObjZv[ID_Obj].ObCI[16]);// проверить условие П отмены
          if msg <> '' then
          begin PutSmsg(1,LastX,LastY,msg); exit; end; //---- вывод сообщения на экран
        end;
        InsNewMsg(ID_Obj,176+$4000,7,'');//----------------- "отменить поездной маршрут ?"
        msg := '';

        case GetIzvestitel(ID_Obj,MarshP) of //------------ получить состояние известителя
          1 :
          begin
            color := 1;
            msg := GetSmsg(1,329, '',color) + ' '; // Поезд на предмаршрутном участке!
            InsNewMsg(ID_Obj,329+$5000,1,'');
          end;

          2 :
          begin
            color := 1;
            msg := GetSmsg(1,330, '',color) + ' '; //------------------ Поезд на маршруте!
            InsNewMsg(ID_Obj,330+$5000,1,'');
          end;

          3 :
          begin
            color := 1;
            msg := GetSmsg(1,331, '',color) + ' '; //------- Поезд на участке приближения!
            InsNewMsg(ID_Obj,331+$5000,1,'');
          end;
        end;

        color := 7;
        msg := msg+GetSmsg(1,176,'от '+ObjZv[ID_Obj].Liter,color);//Отм.поезд. маршрут $?
        DspCom.Com := M_OtmenaPoezdnogo; //готовим команду отмены П маршрута
        DspCom.Obj := ID_Obj;
      end else

      //------------------------------------------------------------------- Только для РПЦ
      if ObjZv[ID_Obj].BasOb <>0 then //--------------- если есть перекрывная секция
      if  not ObjZv[ID_Obj].bP[14] and //---- нет программного замыкания сигнала и...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[14] then//нет программного замыкания СП
      begin //------------------------------------- выбрать категорию отменяемого маршрута
        if ObjZv[ID_Obj].ObCB[2] and //-------- у сигнала есть начало поездных и ...
        ObjZv[ID_Obj].ObCB[3] then //-------------- у сигнала есть начало маневровых
        begin //---------------- выбрать категорию отмены (аварийно), так как неясно какой
          InsNewMsg(ID_Obj,175+$4000,7,''); //-------------- отменить маневровый маршрут ?
          InsNewMsg(ID_Obj,176+$4000,7,''); //---------------- отменить поездной маршрут ?

          color := 1;
          AddDspMenuItem('Нет начала маршрута! '+ GetSmsg(1,175, '',color),
          M_OtmenaManevrovogo,ID_Obj);

          color := 1;
          AddDspMenuItem('Нет начала маршрута! '+ GetSmsg(1,176, '',color),
          M_OtmenaPoezdnogo,ID_Obj);
        end else

        if ObjZv[ID_Obj].ObCB[3] then //------ у сигнала возможно только маневровое начало
        begin //------------------------------------------- отменить маневровый (аварийно)
          DspCom.Com := M_OtmenaManevrovogo;
          DspCom.Obj := ID_Obj;
          color := 7;
          InsNewMsg(ID_Obj,175+$4000,color,'');
          TXT := ObjZv[ID_Obj].Liter;
          msg := 'Нет начала маршрута! '+ GetSmsg(1,175,'от ' + TXT,color);
        end else
        if ObjZv[ID_Obj].ObCB[2] then //--------------------- только поездное начало
        begin //--------------------------------------------- отменить поездной (аварийно)
          DspCom.Com := M_OtmenaPoezdnogo;
          DspCom.Obj := ID_Obj;
          color := 1;
          InsNewMsg(ID_Obj,176+$4000,color,'');
          TXT := ObjZv[ID_Obj].Liter;
          msg := 'Нет начала маршрута! '+ GetSmsg(1,176,'от ' + TXT,color);
        end
        else  exit; //------------------------------------------ нет никаких начал - выход
      end
      else  exit; //------------------------------------ есть какое-либо замыкание - выход
      //---------------------------------------------------------- конец фрагмента для РПЦ
    end else //--------------------------------------------- конец работы с режимом отмены

    if ObjZv[ID_Obj].bP[23] or //-------------- воспринято перекрытие сигнала ИЛИ ...
    ((ObjZv[ID_Obj].bP[5] or //----------------------------- ненорма огневого или ...
    ObjZv[ID_Obj].bP[15] or //------------------------------------ ненорма Со или ...
    ObjZv[ID_Obj].bP[17] or //---------------------------------- авария шкафа или ...
    ObjZv[ID_Obj].bP[24] or //----------------------------------- ненорма зСо или ...
    ObjZv[ID_Obj].bP[25] or //----------------------------------- ненорма ВНП или ...
    ObjZv[ID_Obj].bP[26]) and //------------------------------------ ненорма Кз И ...
    not ObjZv[ID_Obj].bP[20] and //--------------- нет восприятия неисправности и ...
    not WorkMode.GoTracert) then   //-----------------------не выполняется трассировка ...
    begin //------------------------------------------ снять мигание при неисправности ...
      ObjZv[ID_Obj].bP[23] := false; //----------------- убрать восприятие перекрытия
      ObjZv[ID_Obj].bP[20] := true; //----------- установить восприятие неисправности
      exit;
    end else

    if not ObjZv[ID_Obj].bP[31] then //-------------------------- если нет активности
    begin //-------------------------------------------------- то есть нет данных в канале
      InsNewMsg(ID_Obj,310+$4000,1,''); //- "Отсутствует информация о состоянии светофора"
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowSmsg(310, LastX, LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else

    if ObjZv[ID_Obj].bP[13] and not WorkMode.GoTracert then //- светофор заблокирован
    begin
      InsNewMsg(ID_Obj,123+$4000,1,'');//----------------------- "Светофор $ заблокирован"
      ShowSmsg(123,LastX,LastY,ObjZv[ID_Obj].Liter);
      color := 1;
      msg := GetSmsg(1,123, ObjZv[ID_Obj].Liter,color);
//      SingleBeep := true;
      exit;
    end else
    if CheckAutoON(ObjZv[ID_Obj].ObCI[28]) then //-- /проверить включение автодейст.
    begin
      InsNewMsg(ID_Obj,431+$4000,1,'');//------------------------- "Включено автодействие"
      ShowSmsg(431,LastX,LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.MarhUpr then //------------------------------ режим маршрутного управления
    begin
      if CheckMaket then  //----------------------- если макет установлен не известно куда
      begin //--------------- макет установлен не полностью - блокировать маршрутный набор
        InsNewMsg(ID_Obj,344+$4000,1,'');
        ShowSmsg(344,LastX,LastY,ObjZv[ID_Obj].Liter);
        color := 1;
        msg := GetSmsg(1,344, ObjZv[ID_Obj].Liter,color);
//        SingleBeep := true;
        ShowWarning := true;
        exit;
      end else

      if WorkMode.GoTracert then //----------------------------- Идет трассировка маршрута
      begin //-------------------------------------------------- выбор промежуточной точки
        //---------- если сигнал конца маршрута не соответствует типу задаваемого маршрута
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
      begin //-- открыть сигнал для протяжки (перезамыкание поездного маршрута маневровым)
        InsNewMsg(ID_Obj,416+$4000,7,''); //--- Открыть сигнал $ дла протягивания состава?
        msg := GetSmsg(1,416, ObjZv[ID_Obj].Liter,7);
      end else
      begin //------------------------------------ Проверить допустимость открытия сигнала
        if ObjZv[ID_Obj].bP[2] or //------------------------------------ есть МС2 или
        ObjZv[ID_Obj].bP[4] then //------------------------------------------ есть С2
        begin
          InsNewMsg(ID_Obj,230+$4000,7,'');//------------------------- "Сигнал $ уже открыт"
          ShowSmsg(230,LastX,LastY,ObjZv[ID_Obj].Liter);
          msg := GetSmsg(1,230, ObjZv[ID_Obj].Liter,7);
          exit;
        end else

        if ObjZv[ID_Obj].bP[1] or //------------------------------------ есть МС1 или
        ObjZv[ID_Obj].bP[3] then //------------------------------------------ есть С1
        begin
          InsNewMsg(ID_Obj,402+$4000,1,'');//-- "Выдержа времени откр.сигнала не окончена"
          ShowSmsg(402,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end else

        if ObjZv[ID_Obj].bP[6] or //---------------------- если НМ из сервера или ...
        ObjZv[ID_Obj].bP[7] then //---------------------------------- трассировка МПР
        begin
          if ObjZv[ID_Obj].bP[11] then //--- проверка состояния замыкания перекрывной
          begin
            //---------------- проверить условия допустимости повтора маневрового маршрута
            if ObjZv[ID_Obj].ObCI[17] > 0 then //---------- если есть условие для НМ
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZv[ID_Obj].ObCI[18] > 0 then //------- если есть условие для НМ(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //-------------------------- выдать команду повтора маневрового маршрута
              DspCom.Active := true;
              DspCom.Com := M_PovtorManevrMarsh;
              DspCom.Obj := ID_Obj;
              color := 7;
              InsNewMsg(ID_Obj,398+$4000,color,'');//---- "Повторно открыть маневровый $?"
              msg := GetSmsg(1,398, ObjZv[ID_Obj].Liter,color);
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //------------- Признак НМ, сигнал закрыт - повторное открытие маневрового
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
            begin //------------------------------------ выдать команду начала трассировки
              DspCom.Active := true;
              DspCom.Com := M_PovtorManevrovogo;
              DspCom.Obj := ID_Obj;
              color := 7;
              InsNewMsg(ID_Obj,177+$4000,color,''); //----- Повторно открыть маневровый $?
              msg := GetSmsg(1,177, ObjZv[ID_Obj].Liter,color);
            end else
            begin PutSmsg(1,LastX,LastY,msg);exit; end;//- отказ от начала трассировки
          end;
        end else
        if ObjZv[ID_Obj].bP[8] or //------------------ если есть Н из сервера или ...
        ObjZv[ID_Obj].bP[9] then //----------------- поездная ППР трассировка сигнала
        begin
          if ObjZv[ID_Obj].bP[11] then //--- если перекрывная секция сигнала замкнута
          begin
            //------------------ проверить условия допустимости повтора поездного маршрута
            if ObjZv[ID_Obj].ObCI[14] > 0 then //----------- если есть условие для Н
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //-- проверить условие
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZv[ID_Obj].ObCI[15] > 0 then //-------- если есть условие для Н(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //-- проверить условие
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //---------------------------- выдать команду повтора поездного маршрута
              InsNewMsg(ID_Obj,399+$4000,2,'');//------------ Повторно открыть поездной $?
              msg := GetSmsg(1,399, ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_PovtorPoezdMarsh;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //---------------- Признак Н, сигнал закрыт - повторное открытие поездного
            if ObjZv[ID_Obj].ObCI[14] > 0 then  //- если есть условие 1 для открытия
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZv[ID_Obj].ObCI[15] > 0 then
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]);//- если есть условие 2
              u2 := msg = '';
            end
            else u2 := false;
            msg := '';
            if u1 or u2 then
            begin //------------------------------------ выдать команду начала трассировки
              InsNewMsg(ID_Obj,178+$4000,2,''); //------------- Повторно открыть поездной $?
              msg := GetSmsg(1,178, ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_PovtorPoezdnogo;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end else
        begin
          if (ObjZv[ID_Obj].bP[14] or //если есть программное замыкание для Н или ...
          (ObjZv[ID_Obj].BasOb > 0)) and not ObjZv[ID_Obj].bP[6]
          and not ObjZv[ID_Obj].bP[8]
          then //---------------------------------------- есть перекрывная секция СП и ...
          begin
            TXT := ObjZv[ObjZv[ID_Obj].BasOb].Liter;
            if ObjZv[ObjZv[ID_Obj].BasOb].bP[14]
            then TXT := ' программно замкнут участок ' + TXT else//прогр.замык. СП или ...
            if  not ObjZv[ObjZv[ID_Obj].BasOb].bP[1]
            then TXT := ' занят участок ' + TXT else  //------------- занятость СП или ...
            if not ObjZv[ObjZv[ID_Obj].BasOb].bP[2]
            then TXT := ' замкнут участок ' + TXT else //--- релейное замыкание СП или ...
            if not ObjZv[ObjZv[ID_Obj].BasOb].bP[7]
            then TXT := ' программно замкнут участок ' + TXT else//пред.замык. сервера или
            if not ObjZv[ObjZv[ID_Obj].BasOb].bP[8]
            then TXT := ' участок замкнут в другой трассе ' + TXT;//пред.замык.трассировки
            if TXT = ObjZv[ObjZv[ID_Obj].BasOb].Liter then TXT := '';
          end;
          if TXT <> '' then //-------------- если замыкание враждебного маршрута на РМ-ДСП
          begin
            InsNewMsg(ID_Obj,328+$4000,1,'');  //---- нельзя установить маршрут от сигнала
            msg := GetSmsg(1,328, ObjZv[ID_Obj].Liter,1) + ' -' + TXT;
            //ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
            exit;
          end else
          if ObjZv[ID_Obj].ObCB[2] and //------------ если может быть начало П и ...
          ObjZv[ID_Obj].ObCB[3] then //------------------------- может быть начало М
          begin //--------------------------------------------- Выбрать категорию маршрута
            if ObjZv[ID_Obj].ObCI[14] > 0 then  //---------- если есть условие для Н
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //-- проверить условие
              u1 := msg = '';
            end else u1 := true;

            if ObjZv[ID_Obj].ObCI[15] > 0 then  //------ если  есть условие для Н(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //-- проверить условие
              u2 := msg = '';
            end else u2 := false;

            uo := u1 or u2;
            if ObjZv[ID_Obj].ObCI[17] > 0 then //--------- если  есть условие для НМ
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]); //-- проверить условие
              u1 := msg = '';
            end  else u1 := true;

            if ObjZv[ID_Obj].ObCI[18] > 0 then //------ если  есть условие для НМ(2)
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]); //-- проверить условие
              u2 := msg = '';
            end else u2 := false;

            if uo and (u1 or u2) then
            begin
              InsNewMsg(ID_Obj,181+$4000,7,'');  //----------------- Маневровый маршрут $?
              InsNewMsg(ID_Obj,182+$4000,2,''); //-------------------- Поездной маршрут $?
              AddDspMenuItem(GetSmsg(1,181, '',7), M_BeginMarshManevr,ID_Obj);
              AddDspMenuItem(GetSmsg(1,182, '',2), M_BeginMarshPoezd,ID_Obj);
            end else

            if uo then
            begin //------------------------------------------------ трассировать поездной
              InsNewMsg(ID_Obj,182+$4000,2,''); //---------------------- Поездной маршрут $?
              msg := GetSmsg(1,182, 'от ' + ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshPoezd;
              DspCom.Obj := ID_Obj;
            end else

            if u1 or u2 then
            begin //---------------------------------------------- трассировать маневровый
              InsNewMsg(ID_Obj,181+$4000,7,''); //-------------------- Маневровый маршрут $?
              msg := GetSmsg(1,181, 'от ' + ObjZv[ID_Obj].Liter,7);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshManevr;
              DspCom.Obj := ID_Obj;
            end else
            begin //- отказ от трассировки из-за отсутствия разрешения начальных признаков
              InsNewMsg(ID_Obj,328+$4000,1,'');  //-- нельзя установить маршрут от сигнала
              ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
              exit;
            end;
          end else
          if ObjZv[ID_Obj].ObCB[2] then  //--------- от сигнала есть поездное начало
          begin //--------------------------------------- Запрос начала поездного маршрута
            if ObjZv[ID_Obj].ObCI[14] > 0 then //есть условие 1 для начала поездного
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]);
              u1 := msg = '';
            end
            else u1 := true; //------------------------ нет условия 1 для начала поездного

            if ObjZv[ID_Obj].ObCI[15] > 0 then //есть условие 2 для начала поездного
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]);
              u2 := msg = '';
            end
            else u2 := true;

            if u1 and u2 then
            begin //------------------------------------ выдать команду начала трассировки
              InsNewMsg(ID_Obj,182+$4000,2,''); //-------------------- Поездной маршрут $?
              msg := GetSmsg(1,182, 'от ' + ObjZv[ID_Obj].Liter,2);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshPoezd;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          if ObjZv[ID_Obj].ObCB[3] then//если у сигнала существует начало маневровых
          begin //------------------------------------- Запрос начала маневрового маршрута
            if ObjZv[ID_Obj].ObCI[17] > 0 then //-- если есть условие 1 для маневров
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);
              u1 := msg = '';
            end else u1 := true;

            if ObjZv[ID_Obj].ObCI[18] > 0 then //-- если есть условие 2 для маневров
            begin
              msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //------------------------------------ выдать команду начала трассировки
              InsNewMsg(ID_Obj,181+$4000,2,'');  //----------------- маневровый маршрут $?
              msg := GetSmsg(1,181, 'от ' + ObjZv[ID_Obj].Liter,7);
              DspCom.Active := true;
              DspCom.Com := M_BeginMarshManevr;
              DspCom.Obj := ID_Obj;
              result := true;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutSmsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end;
      end;
    end else
    begin //------------------------------------------------- режим раздельного управления
      if ObjZv[ID_Obj].bP[2] or ObjZv[ID_Obj].bP[4] then //----- если МС2 или С2
      begin //-------------------------------------------------------------- открыт сигнал
        InsNewMsg(ID_Obj,230+$4000,1,''); //-------------------------- Сигнал $ уже открыт
        ShowSmsg(230,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if ObjZv[ID_Obj].bP[1] or ObjZv[ID_Obj].bP[3] then //--- если МС1 или С1
      begin //------------------------------------------------- сигнал на выдержке времени
        InsNewMsg(ID_Obj,402+$4000,1,''); // Выдержа времени на откр.сигнала $ не окончена
        ShowSmsg(402,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if CheckProtag(ID_Obj) then
      begin  //--------- Открыть сигнал для протяжки (перезамыкание поездного маневровым)?
        InsNewMsg(ID_Obj,416+$4000,7,'');
        msg := GetSmsg(1,416, ObjZv[ID_Obj].Liter,7);
      end else
      if ObjZv[ID_Obj].bP[6] or   //-------------------------- если НМ из FR3 или ...
      ObjZv[ID_Obj].bP[7] then //------------------------------------ МПР трассировки
      begin
        if ObjZv[ID_Obj].bP[11] then //------------ если замыкание перекрывной секции
        begin //-------------- проверить условия допустимости повтора маневрового маршрута
          if MarhTrac.LockPovtor then begin ResetTrace;exit;end;//если заблокирован повтор
          if ObjZv[ID_Obj].ObCI[17] > 0 then
          begin msg:=CheckStartTrace(ObjZv[ID_Obj].ObCI[17]); u1:= msg='';end
          else u1:= true;

          if ObjZv[ID_Obj].ObCI[18] > 0 then
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);
            u2 := msg = '';
          end  else u2 := false;

          if u1 or u2 then
          begin //---------------------------- выдать команду повтора маневрового маршрута
            InsNewMsg(ID_Obj,173+$4000,7,'');
            msg := GetSmsg(1,173, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_PovtorOtkrytManevr;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //--------------- Признак НМ, сигнал закрыт - повторное открытие маневрового
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
          begin //-------------------------------------- выдать команду начала трассировки
            InsNewMsg(ID_Obj,177+$4000,7,'');
            msg := GetSmsg(1,177, ObjZv[ID_Obj].Liter,7);
            DspCom.Active := true;
            DspCom.Com := M_PovtorManevrovogo;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZv[ID_Obj].bP[8] or  //---------------------------- если Н из FR3 или ...
      ObjZv[ID_Obj].bP[9] then //------------------------------------ ППР трассировки
      begin
        if ObjZv[ID_Obj].bP[11] then  //------------ если замкнута перекрывная секция
        begin  //--------------- проверить условия допустимости повтора поездного маршрута
          if MarhTrac.LockPovtor then begin ResetTrace;exit;end;//если повтор заблокирован

          if ObjZv[ID_Obj].ObCI[14] > 0 then    //-------- если есть условие 1 для Н
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //---- проверить условие
            u1 := msg = '';
          end else u1 := true;

          if ObjZv[ID_Obj].ObCI[15] > 0 then    //-------- если есть условие 2 для Н
          begin
            msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //---- проверить условие
            u2 := msg = '';
          end else u2 := false;

          if u1 or u2 then
          begin //------------------------------ выдать команду повтора поездного маршрута
            InsNewMsg(ID_Obj,174+$4000,2,''); //---------------------- Открыть поездной $?
            msg := GetSmsg(1,174, ObjZv[ID_Obj].Liter,2);
            DspCom.Com := M_PovtorOtkrytPoezd;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //------------------ Признак Н, сигнал закрыт - повторное открытие поездного
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
          begin //-------------------------------------- выдать команду начала трассировки
            InsNewMsg(ID_Obj,178+$4000,2,'');   //----------- Повторно открыть поездной $?
            msg := GetSmsg(1,178, ObjZv[ID_Obj].Liter,2);
            DspCom.Active := true;
            DspCom.Com := M_PovtorPoezdnogo;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutSmsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZv[ID_Obj].bP[14] or // если есть программное замыкание на РМ ДСП или ...
      ((ObjZv[ID_Obj].BasOb <> 0) and  //------------- есть перекрывная секция и ...
      (ObjZv[ObjZv[ID_Obj].BasOb].bP[14] or //-- СП программно замкнута или ...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[2] or  //-- СП замкнута релейно или ...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[7] or  //- предв. замыкание FR3 или ...
      not ObjZv[ObjZv[ID_Obj].BasOb].bP[8])) then//предв. замыкание трассировки
      begin //------------------- предварительное замыкание враждебного маршрута на РМ-ДСП
        InsNewMsg(ID_Obj,328+$4000,1,''); //--------- нельзя установить маршрут от сигнала
        msg := GetSmsg(1,328, ObjZv[ID_Obj].Liter,1);
        ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else

      if ObjZv[ID_Obj].ObCB[2] and //------- если сигнал имеет начало поездное и ...
      ObjZv[ID_Obj].ObCB[3] then //------------------ сигнал имеет начало маневровое
      begin //------------------------------------------------- Выбрать категорию маршрута
        if ObjZv[ID_Obj].ObCI[14] > 0 then //--- если у сигнала есть условие 1 для Н
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]);//------- проверить условие
          u1 := msg = ''; //---------------- условие есть, но оно не мешает ? или мешает ?
        end
        else u1 := true; //---------------------------- условия нет, поэтому оно не мешает

        if ObjZv[ID_Obj].ObCI[15] > 0 then //--- если у сигнала есть условие 2 для Н
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]);//------- проверить условие
          u2 := msg = ''; //---------------- условие есть, но оно не мешает ? или мешает ?
        end
        else u2 := false; //--------------------------- условия нет, поэтому оно не мешает

        uo := u1 or u2;  //---------------------------------- обобщаем условия 1 и 2 для Н

        if ObjZv[ID_Obj].ObCI[17] > 0 then   //---------- если есть условие 1 для НМ
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);//-- проверить условие 1 НМ
          u1 := msg = ''; //---------------- условие есть, но оно не мешает ? или мешает ?
        end else u1 := true;

        if ObjZv[ID_Obj].ObCI[18] > 0 then   //---------- если есть условие 2 для НМ
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);//проверка условия 2 для НМ
          u2 := msg = '';
        end  else u2 := false;

        if uo and (u1 or u2) then //объединяем условия (1 или 2) для  Н и (1 или 2) для НМ
        begin  //----------------- есть все условия: для Н и для НМ, поэтому надо выбирать
          InsNewMsg(ID_Obj,173+$4000,7,'');  //--------------------- Открыть маневровый $?
          InsNewMsg(ID_Obj,174+$4000,2,'');   //---------------------- Открыть поездной $?
          AddDspMenuItem(GetSmsg(1,173, '',7), M_OtkrytManevrovym,ID_Obj);
          AddDspMenuItem(GetSmsg(1,174, '',2), M_OtkrytPoezdnym,ID_Obj);
        end else
        if uo then //------------------------------------------- есть условия только для Н
        begin
          InsNewMsg(ID_Obj,174+$4000,2,'');  //----------------------- Открыть поездной $?
          msg := GetSmsg(1,174, ObjZv[ID_Obj].Liter,2);
          DspCom.Com := M_OtkrytPoezdnym;
          DspCom.Obj := ID_Obj;
        end else
        if u1 or u2 then //------------------------------------ есть условия только для НМ
        begin
          InsNewMsg(ID_Obj,173+$4000,7,'');//----------------------- открыть маневровый $?
          msg := GetSmsg(1,173, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_OtkrytManevrovym;
          DspCom.Obj := ID_Obj;
        end else
        begin //-------------------- отказ из-за отсутствия разрешения начальных признаков
          InsNewMsg(ID_Obj,328+$4000,1,''); //------- нельзя установить маршрут от сигнала
          ShowSmsg(328,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end else

      if ObjZv[ID_Obj].ObCB[2] then  //--------- если у сигнала есть поездное начало
      begin //--------------------------------------------------- Запрос открытия поездным
        if ObjZv[ID_Obj].ObCI[14] > 0 then //--- если у сигнала есть условие 1 для Н
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[14]); //проверка условия 1 для Н
          u1 := msg = '';
        end else u1 := true;

        if ObjZv[ID_Obj].ObCI[15] > 0 then //--- если у сигнала есть условие 2 для Н
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[15]); //проверка условия 2 для Н
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- выдать команду начала трассировки
          InsNewMsg(ID_Obj,174+$4000,2,''); //---------------------- "Открыть поездной $?"
          msg := GetSmsg(1,174, ObjZv[ID_Obj].Liter,2);
          DspCom.Com := M_OtkrytPoezdnym;
          DspCom.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- отказ от начала трассировки
          PutSmsg(1,LastX,LastY,msg);
          exit;
        end;
      end else

      if ObjZv[ID_Obj].ObCB[3] then   //------ если у сигнала есть начало маневровых
      begin //------------------------------------------------- Запрос открытия маневровым
        if ObjZv[ID_Obj].ObCI[17] > 0 then //------------ если есть условие 1 для НМ
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[17]);  //------ проверка условия
          u1 := msg = '';
        end else u1 := true;

        if ObjZv[ID_Obj].ObCI[18] > 0 then //------------ если есть условие 2 для НМ
        begin
          msg := CheckStartTrace(ObjZv[ID_Obj].ObCI[18]);  //------ проверка условия
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- выдать команду начала трассировки
          InsNewMsg(ID_Obj,173+$4000,7,''); //-------------------- "Открыть маневровый $?"
          msg := GetSmsg(1,173, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_OtkrytManevrovym;
          DspCom.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- отказ от начала трассировки
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
//------------------------------  Функция подготовки меню ДСП при управлении автодействием
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

  if WorkMode.MarhOtm then //----------------------- если ранее готовилась отмена маршрута
  begin
    if ObjZv[ID_Obj].bP[1] then //------------------------ если включено автодействие
    begin
      InsNewMsg(ID_Obj,420+$4000,7,'');//-------- задать вопрос "отключить автодействие ?"
      WorkMode.MarhOtm := false;
      msg := GetSmsg(1,420, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_AutoMarshOtkl;
      DspCom.Obj := ID_Obj;
    end else //----------------------------------------------- если автодействие отключено
    begin
      InsNewMsg(ID_Obj,408+$4000,1,''); //---------- выдать текст "Автодействие отключено"
      msg := GetSmsg(1,408, ObjZv[ID_Obj].Liter,7);
      ShowSmsg(408,LastX,LastY,'');
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZv[ID_Obj].bP[1] then
    begin
      InsNewMsg(ID_Obj,420+$4000,7,'');//--------- задать вопрос "отключить автодействие?"
      WorkMode.MarhOtm := false;
      msg := GetSmsg(1,420, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_AutoMarshOtkl;
      DspCom.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------- включить автодействие
      InsNewMsg(ID_Obj,419+$4000,7,'');//---------- задать вопрос "включить автодействие?"
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
//---------------------------------  Функция подготовки меню ДСП при управлении для бита 1
function NewMenu_1bit(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;   result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}

  if Spec_Reg(ID_Obj) then exit;

  if ObjZv[ID_Obj].bP[1] then
  begin
    if ObjZv[ID_Obj].ObCI[5] > 0 then
    begin
      InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[5]+$4000,7,'');//--------- задать вопрос отключить?
      WorkMode.MarhOtm := false;
      msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
      PutSmsg(7,LastX,LastY,msg);
      DspCom.Com := M_OtklBit1;
      DspCom.Obj := ID_Obj;
    end else
    begin
      InsNewMsg(ID_Obj,572,1,''); //-----------------  Объект находится в требуемом состоянии
      msg := GetSmsg(1,572, '',1);
      PutSmsg(1,LastX,LastY,msg);
      DspMenu.WC := false;
      DspCom.Com := 0;
      DspCom.Obj := 0;
      exit;
    end;
  end else
  begin //---------------------------------------------------------------- включить что-то
    if ObjZv[ID_Obj].ObCI[4] > 0 then
    begin
      InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[4]+$4000,7,'');//---------- задать вопрос включить?
      msg := MsgList[ObjZv[ID_Obj].ObCI[4]];
      WorkMode.MarhOtm := false;
      DspCom.Com := M_VklBit1;
      DspCom.Obj := ID_Obj;
    end else
    begin
      InsNewMsg(ID_Obj,572,1,''); //-----------------  Объект находится в требуемом состоянии
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
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[5]+$4000,7,'');//задать вопрос сброса бита
    WorkMode.MarhOtm := false;
    msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
    DspCom.Com := M_VklBit1_2;
    DspCom.Obj := ID_Obj;
  end else
  begin //-------------------------------------------------------------- включить что-то
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[4]+$4000,7,'');//задать вопрос о включении
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
      InsNewMsg(razresh,543+$4000,1,'');  //--------------- команда заблокирована объектом
      msg := GetSmsg(1,543, ObjZv[razresh].Liter,1);
      exit;
    end;
  end;

  DspMenu.obj := cur_obj;

  if Spec_Reg(ID_Obj) then exit;

  if ObjZv[ID_Obj].bP[1] then
  begin
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[5]+$4000,7,'');// задать вопрос отключить?
    WorkMode.MarhOtm := false;
    msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
    DspCom.Com := M_OtklBit2;
    DspCom.Obj := ID_Obj;
    result := true;
  end else
  begin //-------------------------------------------------------------- включить что-то
    InsNewMsg(ID_Obj,ObjZv[ID_Obj].ObCI[4]+$4000,7,'');//задать вопрос включить ?
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
//-------------- подготовка меню для запрета или ответственного разрешения работы монтерам
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

  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end; //- Сбросить отмену

  if not WorkMode.OtvKom and (not ObjZv[ID_Obj].bP[1])then //---- нет запрета,не нажата ОК
  begin
    InsNewMsg(ID_Obj,199+$4000,7,''); msg := GetSmsg(1,199, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_DatZapretMonteram;
    DspCom.Obj := ID_Obj;
  end else  //------------------------------------------------------ есть запрет, нужна ОК
  begin
    if WorkMode.OtvKom then
    begin //------------------------------------------- Нажата кнопка ответственных команд
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsNewMsg(ID_Obj,528+$4000,7,'');
        msg := GetSmsg(1,528, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_IspolOtklZapMont;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsNewMsg(ID_Obj,527+$4000,7,'');
        msg := GetSmsg(1,527, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvOtklZapMont;
        DspCom.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//---------------------- подготовка меню для открытия или ответственного закрытия переезда
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
  not ObjZv[ID_Obj].bP[13]) then //-------------------- открыт переезд и не нажата ОК
  begin
    InsNewMsg(ID_Obj,192+$4000,7,'');
    msg := GetSmsg(1,192, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_ZakrytPereezd;
    DspCom.Obj := ID_Obj;
  end else  //-------------------------------------------------- переезд закрыт, нужна ОК
  begin
    if WorkMode.OtvKom then
    begin //----------------------------------------- Нажата кнопка ответственных команд
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsNewMsg(ID_Obj,194+$4000,7,'');
        msg := GetSmsg(1,194, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_IspolOtkrytPereezd;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsNewMsg(ID_Obj,193+$4000,7,'');
        msg := GetSmsg(1,193, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvOtkrytPereezd;
        DspCom.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//------------------------- подготовка меню для выдачи поездного согласия на соседний пост
function NewMenu_VydPSogl(X,Y : SmallInt): boolean;
var
  i : integer;
  u1,u2 : boolean;
begin//------------------------------------------------ Поездное согласие на соседний пост
  DspMenu.obj := cur_obj;
  result := true;
  {$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  i := ID_Obj;

  if WorkMode.OtvKom then
  begin //------------------- нажата ОК - нормализовать признаки трассировки для светофора
    InsNewMsg(ObjZv[i].BasOb,311+$4000,7,'');  //------------------ Нормализовать $?
    msg := GetSmsg(1,311, ObjZv[ObjZv[i].BasOb].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ObjZv[i].BasOb;
  end else
  if ActivenVSP(ID_Obj) then exit;

  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;

   //--------------------------------------------------------------- нормальный режим
  if WorkMode.InpOgr then exit; //-------------------------------------- ввод ограничений

  if ObjZv[ObjZv[i].BasOb].bP[18] then
  begin //-------------------------------------------------------- на местном управлении
    InsNewMsg(ObjZv[i].BasOb,232+$4000,1,''); //--- Сигнал $ на местном управлении
    WorkMode.GoMaketSt := false;
    ShowSmsg(232,LastX,LastY,ObjZv[ObjZv[i].BasOb].Liter);
    exit;
  end;
  with ObjZv[i] do
  if WorkMode.MarhOtm then
  begin //----------------------- отмена маршрутов для всех режимов управления сигналами
    if ObjZv[BasOb].bP[8] or ObjZv[BasOb].bP[9] or ObjZv[BasOb].bP[3] or ObjZv[BasOb].bP[4] then
    begin
      if ObjZv[BasOb].bP[3] or ObjZv[BasOb].bP[4] then
      begin //----------------------------------------- отменить поездной, сигнал открыт
        if UpdOb > 0 then
        begin //------------------------------------------------------ увязка через путь
          if ObjZv[UpdOb].bP[2] and  ObjZv[UpdOb].bP[3] then
          begin //------------------------ нет замыкания на увязочном пути - дать отмену
            InsNewMsg(BasOb,184+$4000,7,'');//Отменить согл.поезд.приема?
            msg := GetSmsg(1,184, 'от ' + ObjZv[BasOb].Liter,7);
            DspCom.Com := M_OtmenaPoezdnogo;
            DspCom.Obj := BasOb;
          end else
          begin
            InsNewMsg(BasOb,254+$4000,1,'');//------ Замкнут маршрут до $
            ShowSmsg(254,LastX,LastY,ObjZv[BasOb].Liter); exit;
          end;
        end else
        begin //------------------------------------------ увязка по светофорам в створе
          if bP[2] then
          begin //------------------------------------------- замкнут маршрут до сигнала
            InsNewMsg(ID_Obj,254+$4000,1,'');
            ShowSmsg(254,LastX,LastY,ObjZv[BasOb].Liter);
            exit;
          end else
          begin //---------------------------------------- не замкнут маршрут до сигнала
            InsNewMsg(BasOb,184+$4000,1,'');
            msg := GetSmsg(1,184, 'от ' + ObjZv[BasOb].Liter,1);
            DspCom.Com := M_OtmenaPoezdnogo;
            DspCom.Obj := BasOb;
          end;
        end;
      end else
      begin //сигнал на противоповторке - выдать команду без проверки замыкания маршрута
        InsNewMsg(BasOb,184+$4000,7,''); //- Отменить согл.поезд.приема?
        msg := GetSmsg(1,184, 'от ' + ObjZv[BasOb].Liter,7);
        DspCom.Com := M_OtmenaPoezdnogo;
        DspCom.Obj := BasOb;
      end;
    end;
  end else
  if ObjZv[BasOb].bP[13] and not WorkMode.GoTracert then
  begin //-------------------------------------------------------- светофор заблокирован
    InsNewMsg(BasOb,123+$4000,1,'');
    ShowSmsg(123,LastX,LastY,ObjZv[BasOb].Liter);
    exit;
  end else
  if WorkMode.MarhUpr then
  begin //------------------------------------------------- режим маршрутного управления
    if CheckMaket then
    begin //--------------- макет установлен не полностью - блокировать маршрутный набор
      InsNewMsg(ID_Obj,344+$4000,1,'');
      ShowSmsg(344,LastX,LastY,ObjZv[ID_Obj].Liter);
      ShowWarning := true;
      exit;
    end else
    if WorkMode.CmdReady then
    begin //--------------------- передача маршрута в сервер - отказ маршрутных операций
      InsNewMsg(ID_Obj,239+$4000,1,'');
      ShowSmsg(239,LastX,LastY,''); exit;
    end else
    if WorkMode.GoTracert then
    begin //-------------------------------------------------- выбор промежуточной точки
      DspCom.Active  := true;
      DspCom.Com := CmdMarsh_Tracert;
      DspCom.Obj := BasOb;
      exit;
    end else
    begin //------------------------------------ Проверить допустимость открытия сигнала
      if bP[1] then
      begin //-------------------------------------------------------- нажата кнопка ЭГС
        InsNewMsg(BasOb,105+$4000,1,'');
        ShowSmsg(105,LastX,LastY,ObjZv[BasOb].Liter);
        exit;
      end else
      if ObjZv[BasOb].bP[1] or ObjZv[BasOb].bP[2] or ObjZv[BasOb].bP[3] or  ObjZv[BasOb].bP[4] then
      begin //------------------------------------------------------------ открыт сигнал
        InsNewMsg(BasOb,230+$4000,1,'');
        ShowSmsg(230,LastX,LastY,ObjZv[BasOb].Liter);
        exit;
      end else
      if ObjZv[BasOb].bP[7] then exit //------------ маневры - отказ
      else
      if ObjZv[BasOb].bP[9] then
      begin
        if ObjZv[BasOb].bP[11] then
        begin //---------- перекрывная секция не замкнута - отказ от повторного открытия
          InsNewMsg(BasOb,229+$4000,1,'');
          ShowSmsg(229,LastX,LastY,ObjZv[BasOb].Liter);
          exit;
        end else
        begin //---------------- Признак Н, сигнал закрыт - повторное открытие поездного
          InsNewMsg(BasOb,178+$4000,2,'');
          msg := GetSmsg(1,178, ObjZv[BasOb].Liter,2);
          DspCom.Active := true;
          DspCom.Com := M_PovtorPoezdnogo;
          DspCom.Obj := BasOb;
        end;
      end else
      if ObjZv[ID_Obj].bP[14] then
      begin //----------------------------- предварительное замыкание маршрута на РМ-ДСП
        //--------------------- проверить условия допустимости повтора поездного маршрута
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
        begin //------------------------------ выдать команду повтора поездного маршрута
          InsNewMsg(BasOb,178+$4000,2,'');
          msg := GetSmsg(1,178, ObjZv[BasOb].Liter,2);
          DspCom.Active := true;
          DspCom.Com := M_PovtorPoezdMarsh;
          DspCom.Obj := ID_Obj;
        end else
        begin //-------------------------------------------- отказ от начала трассировки
          PutSmsg(1,LastX,LastY,msg);
          exit;
        end;
      end else
      begin //----------------------------------------- Запрос начала поездного маршрута
        InsNewMsg(BasOb,183+$4000,2,'');
        msg := GetSmsg(1,183, 'от ' + ObjZv[BasOb].Liter,2);
        DspCom.Active := true;
        DspCom.Com := M_BeginMarshPoezd;
        DspCom.Obj := BasOb;
      end;
    end;
  end else
  begin //------------------------------------------------- режим раздельного управления
    if bP[1] then
    begin // нажата кнопка ЭГС
      InsNewMsg(BasOb,105+$4000,1,'');
      ShowSmsg(105,LastX,LastY,ObjZv[BasOb].Liter);
      exit;
    end else
    if ObjZv[BasOb].bP[1] or ObjZv[BasOb].bP[2] or
    ObjZv[BasOb].bP[3] or ObjZv[BasOb].bP[4] then
    begin //-------------------------------------------------------------- открыт сигнал
      InsNewMsg(BasOb,230+$4000,1,'');
      ShowSmsg(230,LastX,LastY,ObjZv[BasOb].Liter);
      exit;
    end else
    if ObjZv[BasOb].bP[9] then
    begin
      if ObjZv[BasOb].bP[11] then
      begin //------------ перекрывная секция не замкнута - отказ от повторного открытия
        InsNewMsg(BasOb,229+$4000,1,'');
        ShowSmsg(229,LastX,LastY,ObjZv[BasOb].Liter);
        exit;
      end else
      begin //------------------ Признак Н, сигнал закрыт - повторное открытие поездного
        InsNewMsg(BasOb,178+$4000,2,'');
        msg := GetSmsg(1,178, ObjZv[BasOb].Liter,2);
        DspCom.Active := true;
        DspCom.Com := M_PovtorPoezdnogo;
        DspCom.Obj := BasOb;
      end;
    end else
    if bP[14] then
    begin //------------------------------- предварительное замыкание маршрута на РМ-ДСП
      //---------------------- проверить условия допустимости повтора поездного маршрута
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
      begin //-------------------------------- выдать команду повтора поездного маршрута
        InsNewMsg(BasOb,174+$4000,2,'');
        msg := GetSmsg(1,174, ObjZv[BasOb].Liter,2);
        DspCom.Com := M_PovtorOtkrytPoezd;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------- отказ от начала трассировки
        PutSmsg(1,LastX,LastY,msg);
        exit;
      end;
    end else
    begin //--------------------------------------------------- Запрос открытия поездным
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
//------------------------------------------- Подготовка меню для выдачи "Надвиг на горку"
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
  begin //------------------- нажата ОК - нормализовать признаки трассировки для светофора
    InsNewMsg(ID_Obj,311+$4000,7,'');
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ID_Obj;
  end else
  begin
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ввод ограничений
      if ObjZv[ID_Obj].bP[13] then
      begin //---------------------------------------------------- разблокировать светофор
        InsNewMsg(ID_Obj,180+$4000,7,'');
        msg := GetSmsg(1,180, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_DeblokirovkaNadviga;
        DspCom.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- заблокировать светофор
        InsNewMsg(ID_Obj,179+$4000,7,'');
        msg := GetSmsg(1,179, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_BlokirovkaNadviga;
        DspCom.Obj := ID_Obj;
      end;
    end else
    if ObjZv[ID_Obj].bP[13] then
    begin //-------------------------------------------------------- светофор заблокирован
      InsNewMsg(ID_Obj,123+$4000,1,'');
      ShowSmsg(123,LastX,LastY,ObjZv[ID_Obj].Liter); exit;
    end else
    if WorkMode.MarhUpr then
    begin //------------------------------------------------- режим маршрутного управления
      if WorkMode.CmdReady then
      begin //--------------------- передача маршрута в сервер - отказ маршрутных операций
        InsNewMsg(ID_Obj,239+$4000,1,'');
        ShowSmsg(239,LastX,LastY,'');
        exit;
      end else
      if WorkMode.GoTracert then
      begin //-------------------------------------------------- выбор промежуточной точки
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
//--------------------- Подготовка меню управления объектом "Участок СП или бесстрелочный"
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
  begin //--------------------------------------------------------------- нормальный режим
    if ObjZv[ID_Obj].bP[19] then
    begin //---------------------------------------- Восприятие диагностического сообщения
      ObjZv[ID_Obj].bP[19] := false;
      exit;
    end else
    if ObjZv[ID_Obj].bP[9] or not ObjZv[ID_Obj].bP[5] then
    begin //-------------------------------------------------------- на местном управлении
      InsNewMsg(ID_Obj,233+$4000,1,'');
      WorkMode.GoMaketSt := false;
      ShowSmsg(233,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ввод ограничений
      if ObjZv[ID_Obj].bP[33] then
      begin //------------------------------------------------------ включено автодействие
        InsNewMsg(ID_Obj,431+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(431, LastX, LastY, '');
        exit;
      end else
      if not ObjZv[ID_Obj].bP[8] or ObjZv[ID_Obj].bP[14] then
      begin //--------------------------------------------------- секция в трассе маршрута
        InsNewMsg(ID_Obj,512+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(512, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZv[ID_Obj].ObCB[8] or
        ObjZv[ID_Obj].ObCB[9] then //--------- есть закрытие движения на электротяге
        begin
          //------------------------------------------------------------ закрытие движения
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
          //--------------------------------------------- закрытие движения на электротяге
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
          ObjZv[ID_Obj].ObCB[9] then //--------------------- есть 2 вида электротяги
          begin //---------------------- закрытие движения на электротяге постоянного тока
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
            //-------------------------- закрытие движения на электротяге переменного тока
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
        begin //---------------------------------------------------------- нет электротяги
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
    begin //---------------------------------------------------------- нет данных в канале
      InsNewMsg(ID_Obj,293+$4000,1,'');
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowSmsg(293, LastX, LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else

    if WorkMode.GoTracert then
    begin //---------------------------------------------------- выбор промежуточной точки
      DspCom.Active  := true;
      DspCom.Com := CmdMarsh_Tracert;
      DspCom.Obj := ID_Obj;
      exit;
    end else
    if WorkMode.OtvKom then
    begin //------------------------------------------- Нажата кнопка ответственных команд
      if ObjZv[ID_Obj].ObCB[7] then
      begin //---- для секции в составе сегмента выдать команду искус. размыкания сегмента
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- исполнительная команда
          OtvCommand.SObj := ID_Obj;
          InsNewMsg(ID_Obj,214+$4000,7,'');
          msg := GetSmsg(1,214, ObjZv[ObjZv[ID_Obj].BasOb].Liter,7);
          DspCom.Com := M_SekciaIspolnitRI;
          DspCom.Obj := ID_Obj;
        end else
        if ObjZv[ID_Obj].bP[2] then
        begin //-------- секция разомкнута - нормализовать признаки трассировки для секции
          InsNewMsg(ID_Obj,311+$4000,7,'');
          msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := CmdMarsh_ResetTraceParams;
          DspCom.Obj := ID_Obj;
        end else
        begin //---------------------------------------------------------- секция замкнута
          if ObjZv[ObjZv[ID_Obj].BasOb].bP[1] then
          begin //------------------------------------- выполняется ИР сегмента - отказать
            InsNewMsg(ID_Obj,335+$4000,1,'');
            ShowSmsg(335,LastX,LastY,ObjZv[ObjZv[ID_Obj].BasOb].Liter);
//            SingleBeep := true;
            exit;
          end else
          begin //----------------------------- выдать предварительныю команду ИР сегмента
            InsNewMsg(ID_Obj,185+$4000,7,'');
            msg := GetSmsg(1,185, ObjZv[ObjZv[ID_Obj].BasOb].Liter,7);
            DspCom.Com := M_SekciaPredvaritRI;
            DspCom.Obj := ID_Obj;
          end;
        end;
      end else
      begin //- для секции при посекционном размыкании выдать команду выбора секции для РИ
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- исполнительная команда
          OtvCommand.SObj := ID_Obj;
          InsNewMsg(ID_Obj,186+$4000,7,'');
          msg := GetSmsg(1,186, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_SekciaIspolnitRI;
          DspCom.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- предварительная команда
          if ObjZv[ID_Obj].bP[2] then
          begin //------ секция разомкнута - нормализовать признаки трассировки для секции
            InsNewMsg(ID_Obj,311+$4000,7,'');
            msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := CmdMarsh_ResetTraceParams;
            DspCom.Obj := ID_Obj;
          end else
          begin //-------------------------------------------------------- секция замкнута
            if ObjZv[ObjZv[ID_Obj].BasOb].bP[1] then
            begin //----------------------------- запушена выдержка времени ГИР - отказать
              InsNewMsg(ID_Obj,334+$4000,1,'');
              AddFixMes(GetSmsg(1,334,ObjZv[ID_Obj].Liter,1),4,2);
              exit;
            end else
            if ObjZv[ID_Obj].bP[3] then
            begin //------------------------- Выполняется иск.размыкание секции - отказать
              InsNewMsg(ID_Obj,84+$4000,1,'');
              ShowSmsg(84,LastX,LastY,ObjZv[ID_Obj].Liter);
              exit;
            end else
            begin //------------------------------------------- предварительная команда РИ
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
//--------------------------------------------- Подготовка меню управления объектом "Путь"
function NewMenu_PutPO(X,Y : SmallInt): boolean;
var
  i : integer;
begin //--------------------------------------------- Приемоотправочный путь с ограждением
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------- ОК - нормализовать признаки трассировки для пути
    InsNewMsg(ID_Obj,311+$4000,7,'');
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ID_Obj;
  end else
  if ActivenVSP(ID_Obj) then exit;  
  if WorkMode.MarhOtm then  begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit else
  begin //--------------------------------------------------------------- нормальный режим
    if ObjZv[ID_Obj].bP[19] then begin ObjZv[ID_Obj].bP[19] := false;  exit; end;
    if ObjZv[ID_Obj].bP[9] and not WorkMode.GoTracert then
    begin //-------------------------------------------------------- на местном управлении
      InsNewMsg(ID_Obj,234+$4000,1,'');
      WorkMode.GoMaketSt := false;
      ShowSmsg(234,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ввод ограничений
      if ObjZv[ID_Obj].bP[33] then
      begin //------------------------------------------------------ включено автодействие
        InsNewMsg(ID_Obj,431+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(431, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      if ObjZv[ID_Obj].bP[9] then
      begin //------------------------------------------------- путь на местном управлении
        InsNewMsg(ID_Obj,234+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(234, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      if not ObjZv[ID_Obj].bP[8] or ObjZv[ID_Obj].bP[14] then
      begin //----------------------------------------------------- путь в трассе маршрута
        InsNewMsg(ID_Obj,513+$4000,1,'');
        WorkMode.InpOgr := false;
        ShowSmsg(513, LastX, LastY, ObjZv[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZv[ID_Obj].ObCB[8] or
        ObjZv[ID_Obj].ObCB[9] then //--------- есть закрытие движения на электротяге
        begin
          //------------------------------------------------------------ закрытие движения
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
          //--------------------------------------------- закрытие движения на электротяге
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
          ObjZv[ID_Obj].ObCB[9] then //--------------------- есть 2 вида электротяги
          begin
            //-------------------------- закрытие движения на электротяге постоянного тока
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
            //-------------------------- закрытие движения на электротяге переменного тока
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
        begin //---------------------------------------------------------- нет электротяги
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
    begin //---------------------------------------------------------- нет данных в канале
      InsNewMsg(ID_Obj,294+$4000,1,'');
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowSmsg(294, LastX, LastY, ObjZv[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.GoTracert then //----------------------- если режим маршрутного управления
    begin //---------------------------------------------------- выбор промежуточной точки
      DspCom.Active := true;
      DspCom.Com := CmdMarsh_Tracert;
      DspCom.Obj := ID_Obj;
      result := false;
      exit;
    end else
    begin
      i := ObjZv[ID_Obj].UpdOb;
      if i > 0 then
      begin //------------------------------------------------------- есть ограждение пути
        if ObjZv[i].T[1].Activ and not ObjZv[i].bP[4] then
        begin //-------------------------------- снять мигающую индикацию неисправности ОГ
          ObjZv[i].bP[4] := true;
          exit;
        end else
        if ObjZv[i].bP[1] and not ObjZv[i].bP[2] then
        begin //----- если есть запрос ПТО - проверить условия выдачи согласия ограждения
          if SoglasieOG(ID_Obj) then
          begin //------------------------------ нет маршрутов на/с путь - выдать согласие
            InsNewMsg(ID_Obj,187+$4000,7,'');
            msg := GetSmsg(1,187, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_PutDatSoglasieOgrady;
            DspCom.Obj := ID_Obj;
          end else
          begin //------------------------------------------------ есть маршруты на/с путь
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
//----------------- Подготовка меню управления объектом "ОПИ"(исключение пути из маневров)
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
    begin //----------------------------------------------------------------------- отмена
      if bP[1] then  //---------------------------------------------- если установлено ОПИ
      begin Num := 413; DspCom.Com := M_PutOtklOPI; end //----------- разрешить маневры ?
      else exit;
    end else
    begin
      if bP[1] then begin Num := 413; DspCom.Com := M_PutOtklOPI; end //разрешить маневры?
      else begin  Num := 412; DspCom.Com := M_PutVklOPI;  end;  //---- исключить маневры ?
    end;
    InsNewMsg(ID_Obj,Num+$4000,7,'');  msg := GetSmsg(1,Num, ObjZv[UpdOb].Liter,7);
  end;
  WorkMode.MarhOtm := false;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ Запрос поездного отправления на соседний пост
function NewMenu_PSogl(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;  result := true;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj;  exit; {$ELSE}
  if Spec_Reg(ID_Obj) then exit;

  with ObjZv[ID_Obj] do
  begin
    if WorkMode.MarhOtm then
    begin //--------------------------------------------------------------------- отмена -
      if bP[1] then
      begin //--------------------------------------------------- Снять запрос отправления
        InsNewMsg(ID_Obj,216+$4000,7,'');  WorkMode.MarhOtm := false;
        msg := GetSmsg(1,216, Liter,7);
        DspCom.Com := M_OtmZaprosPoezdSoglasiya;  DspCom.Obj := ID_Obj;
      end else  begin WorkMode.MarhOtm := false; exit; end;
    end else
    begin //------------------------------------------------------------- нормальный режим
      if WorkMode.InpOgr then
      begin //----------------------------------------------------------- Ввод ограничений
        //------------------------------------------ есть закрытие движения на электротяге
        if ObCB[8] or ObCB[9] then
        begin
          //------------------------------------------------------------ закрытие движения
          if bP[14] <> bP[15] then
          begin
            InsNewMsg(ID_Obj,207+$4000,7,''); InsNewMsg(ID_Obj,206+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytUvjazki,ID_Obj);
            AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytUvjazki,ID_Obj);
          end else
          if bP[15] then
          begin
            InsNewMsg(ID_Obj,207+$4000,7,''); //--------------------------- открыть перегон ?
            AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytUvjazki,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,206+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytUvjazki,ID_Obj);
          end;
          //--------------------------------------------- закрытие движения на электротяге
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

          //------------------------------------------------------ есть 2 вида электротяги
          if ObCB[8] and ObCB[9] then
          begin
            //-------------------------- закрытие движения на электротяге постоянного тока
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
            //-------------------------- закрытие движения на электротяге переменного тока
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
        begin //-------------------------------------------------------- нет электротяги
          if bP[14] <> bP[15] then
          begin
            InsNewMsg(ID_Obj,207+$4000,7,'');  InsNewMsg(ID_Obj,206+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytUvjazki,ID_Obj);
            AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytUvjazki,ID_Obj);
          end else
          begin
            if bP[15] or bP[14] then
            begin //------------------------------------- Перегон закрыт - открыть перегон
              InsNewMsg(ID_Obj,207+$4000,7,''); msg := GetSmsg(1,207, Liter,7);
              DspCom.Com := M_OtkrytUvjazki;
              DspCom.Obj := ID_Obj;
            end else
            begin //------------------------------------- Перегон открыт - закрыть перегон
              InsNewMsg(ID_Obj,206+$4000,7,''); msg := GetSmsg(1,206, Liter,7);
              DspCom.Com := M_ZakrytUvjazki;
              DspCom.Obj := ID_Obj;
            end;
          end;
        end;
      end else
      begin //--------------------------------------------------------------------- Запрос
        if bP[1] then
        begin //------------------------------------------------- Снять запрос отправления
          InsNewMsg(ID_Obj,216+$4000,7,'');  msg := GetSmsg(1,216, Liter,7);
          DspCom.Com := M_OtmZaprosPoezdSoglasiya; DspCom.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- Дать запрос отправления
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
//------------------------------ создание меню для управления объектом "смена направления"
function NewMenu_SmenaNapravleniya(X,Y : SmallInt;var gotomenu : boolean):boolean;
var
  color : Integer;
begin
  DspMenu.obj := cur_obj;  result := true;
  {$IFNDEF RMDSP}  ID_ViewObj := ID_Obj;  exit; {$ELSE}

  if Spec_Reg(ID_Obj) then exit;

  if WorkMode.MarhOtm then //--------------------------------------------- отмена маршрута
  begin //-------- вариант с запросом согласия на СН, и есть согласие на смену направления
    if (ObjZv[ID_Obj].ObCI[9] > 0) and  ObjZv[ID_Obj].bP[17] then
    begin  //----------------------------------------------------------- сбросить согласие
      DspCom.Com := M_SnatSoglasieSmenyNapr;  DspCom.Obj := ID_Obj;
      color := 4;
      InsNewMsg(ID_Obj,437+$4000,color,'');// Снять согласие смены направления на перегоне
      msg := GetSmsg(1,437, ObjZv[ID_Obj].Liter,color);
      DspMenu.WC := true; gotomenu := true; exit;
    end else  begin WorkMode.MarhOtm := false;  exit; end;
  end;

  if WorkMode.InpOgr then //--------------------------------------------- Ввод ограничений
  begin
    if ObjZv[ID_Obj].bP[33] then
    begin //-------------------------------------------------------- включено автодействие
      InsNewMsg(ID_Obj,431+$4000,1,'');//------------------------- "Включено автодействие"
      WorkMode.InpOgr := false; ShowSmsg(431, LastX, LastY, '');  exit;
    end else
    begin
      //-------------------------------------------- есть закрытие движения на электротяге
      if ObjZv[ID_Obj].ObCB[8] or ObjZv[ID_Obj].ObCB[9] then
      begin
        //-------------------------------------------------------------- закрытие движения
        if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,''); //----------------------- "Открыть перегон $?"
          InsNewMsg(ID_Obj,206+$4000,7,''); //----------------------- "Закрыть перегон $?"
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

        //----------------------------------------------- закрытие движения на электротяге
        if ObjZv[ID_Obj].bP[24] <> ObjZv[ID_Obj].bP[27] then
        begin
          InsNewMsg(ID_Obj,458+$4000,7,''); //------ Закрыть $ для движения на электротяге
          InsNewMsg(ID_Obj,459+$4000,7,''); //------ Открыть $ для движения на электротяге
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

        if ObjZv[ID_Obj].ObCB[8] and ObjZv[ID_Obj].ObCB[9] then // есть 2 вида электротяги
        begin
          //---------------------------- закрытие движения на электротяге постоянного тока
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

          //---------------------------- закрытие движения на электротяге переменного тока
          if ObjZv[ID_Obj].bP[26] <> ObjZv[ID_Obj].bP[29] then
          begin
            InsNewMsg(ID_Obj,468+$4000,7,'');//Открыть для движения на ЭТ переменного тока
            InsNewMsg(ID_Obj,469+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,468,'',7),M_ABZakrytDvijenieETA,ID_Obj);
            AddDspMenuItem(GetSmsg(1,469,'',7),M_ABOtkrytDvijenieETA,ID_Obj);
          end else
          if ObjZv[ID_Obj].bP[29] then
          begin
            InsNewMsg(ID_Obj,469+$4000,7,'');//-- Выдана команда закр.движ. ЭТ перем. тока
            AddDspMenuItem(GetSmsg(1,469,'',7),M_ABOtkrytDvijenieETA,ID_Obj);
          end else
          begin
            InsNewMsg(ID_Obj,468+$4000,7,'');
            AddDspMenuItem(GetSmsg(1,468,'',7),M_ABZakrytDvijenieETA,ID_Obj);
          end;
        end;
      end else
      begin //------------------------------------------------------------ нет электротяги
        if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,'');  //------------------------ Открыть перегон $?
          InsNewMsg(ID_Obj,206+$4000,7,'');  //------------------------ Закрыть перегон $?
          AddDspMenuItem(GetSmsg(1,207,'',7),M_OtkrytPeregon,ID_Obj);
          AddDspMenuItem(GetSmsg(1,206,'',7),M_ZakrytPeregon,ID_Obj);
        end else
        begin
          if ObjZv[ID_Obj].bP[13] or ObjZv[ID_Obj].bP[12] then
          begin //--------------------------------------- Перегон закрыт - открыть перегон
            InsNewMsg(ID_Obj,207+$4000,7,'');
            msg := GetSmsg(1,207, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_OtkrytPeregon;
            DspCom.Obj := ID_Obj;
          end else
          begin //--------------------------------------- Перегон открыт - закрыть перегон
            InsNewMsg(ID_Obj,206+$4000,7,'');
            msg := GetSmsg(1,206, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_ZakrytPeregon;
            DspCom.Obj := ID_Obj;
          end;
        end;
      end;
    end;
  end else
  begin //-------------------------------------------------------------- Смена направления
    if ObjZv[ID_Obj].ObCB[3] then //--------------------------- есть подключение комплекта
    begin
      if ObjZv[ID_Obj].bP[7] and ObjZv[ID_Obj].bP[8] then
      begin //----------------------------------------------- ошибка подключения комплекта
        InsNewMsg(ID_Obj,261+$4000,1,'');//Комплект смены направления $ подключен не верно
        ShowSmsg(261,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end;
      if ObjZv[ID_Obj].ObCB[4] then
      begin //---------------------------------------------------------------------- прием
        if not ObjZv[ID_Obj].bP[7] then
        begin //------------------------------------------ не подключен комплект по приему
          InsNewMsg(ID_Obj,260+$4000,1,'');
          ShowSmsg(260,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end else
      if ObjZv[ID_Obj].ObCB[5] then
      begin //---------------------------------------------------------------- отправление
        if not ObjZv[ID_Obj].bP[8] then
        begin //------------------------------------- не подключен комплект по отправлению
          InsNewMsg(ID_Obj,260+$4000,1,''); //-- Комплект смены направления $ не подключен
          ShowSmsg(260,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end;
    end;

    //-------------- вариант с запросом согласия на СН, есть согласие на смену направления
    if (ObjZv[ID_Obj].ObCI[9] > 0) and ObjZv[ID_Obj].bP[17] then
    begin //------------------------------------------------------------ сбросить согласие
      InsNewMsg(ID_Obj,437+$4000,7,''); //--- Снять согласие смены направления на перегоне
      msg := GetSmsg(1,437, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_SnatSoglasieSmenyNapr;
      DspCom.Obj := ID_Obj;
      DspMenu.WC := true;
      gotomenu := true;
      exit;
    end;

    if not ObjZv[ID_Obj].bP[5] then
    begin //---------------------------------------------------------------- перегон занят
      InsNewMsg(ID_Obj,262+$4000,1,'');
      ShowSmsg(262,LastX,LastY,ObjZv[ID_Obj].Liter);
      msg :=GetSmsg(1,262, ObjZv[ID_Obj].Liter,1);
      exit;
    end;

    if not ObjZv[ID_Obj].bP[6] then
    begin //----------------------------------------- отправлен хозпоезд (изъят ключ-жезл)
      InsNewMsg(ID_Obj,130+$4000,1,'');
      ShowSmsg(130,LastX,LastY,ObjZv[ID_Obj].Liter);
      msg := GetSmsg(1, 130, ObjZv[ID_Obj].Liter,1);
      exit;
    end;

    if ObjZv[ID_Obj].bP[4] then//-------------------------- "перегон стоит на отправление"
    begin
      if ObjZv[ID_Obj].ObCI[9] > 0 then //-------------- вариант с запросом согласия на СН
      begin
        if ObjZv[ID_Obj].bP[10] then //------------------ Есть запрос на смену направления
        begin
          if ObjZv[ID_Obj].bP[15] then //------------------ замыкание маршрута отправления
          begin
            InsNewMsg(ID_Obj,436+$4000,1,'');//--- Установлен маршр.отпр.поезда на перегон
            ShowSmsg(436,LastX,LastY,ObjZv[ID_Obj].Liter);
            exit;
          end;
          DspCom.Com := M_DatSoglasieSmenyNapr;  DspCom.Obj := ID_Obj;
          color := 7;
          InsNewMsg(ID_Obj,205+$4000,color,''); //-- Выдать согласие на смену направления?
          msg := GetSmsg(1,205, ObjZv[ID_Obj].Liter,color);
          DspMenu.WC := true;  gotomenu := true;
          exit;
        end else //-------------------------------------  Нет запроса на смену направления
        begin
          InsNewMsg(ID_Obj,266+$4000,1,''); msg := GetSmsg(1,266, ObjZv[ID_Obj].Liter,1);
          ShowSmsg(266,LastX,LastY,ObjZv[ID_Obj].Liter);
        end;
        exit;
      end else //-------------------------- вариант без запроса согласия смены направления
      begin
        InsNewMsg(ID_Obj,265+$4000,1,''); msg := GetSmsg(1,265, ObjZv[ID_Obj].Liter,1);
        ShowSmsg(265,LastX,LastY,ObjZv[ID_Obj].Liter);
      end;
      exit;
    end else
    begin //---------------------------------------------------- "перегон стоит по приему"
      InsNewMsg(ID_Obj,204+$4000,7,''); msg := GetSmsg(1,204, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_SmenaNapravleniya;
      DspCom.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------ Подключение комплекта смены направления
function NewMenu_KSN(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;  result := true;

{$IFNDEF RMDSP} ID_ViewObj := ID_Obj; exit; {$ELSE}

  if not WorkMode.OtvKom then
  begin //--------------------------------- не нажата ОК - прекратить формирование команды
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
  begin //----------------------------------------------------------------------- отмена -
    if ObjZv[ID_Obj].bP[1] then
    begin //-------------------------------------------------------- отключить комплект СН
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
    begin //-------------------------------------------------------- отключить комплект СН
      InsNewMsg(ID_Obj,406+$4000,7,'');
      msg := GetSmsg(1,406, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_OtklKSN;
      DspCom.Obj := ID_Obj;
    end else
    begin //------------------------------------------------------- подключить комплект СН
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
//--------------------------------------------------------------------------- Увязка с ПАБ
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
  begin //----------------------------------------------------------------------- отмена -
    WorkMode.MarhOtm := false;
    if ObjZv[ID_Obj].bP[4] then
    begin //--------------------------------------------------- снять согласие отправления
      InsNewMsg(ID_Obj,279+$4000,7,'');
      msg := GetSmsg(1,279, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_OtmenaSoglasieOtpravl;
      DspCom.Obj := ID_Obj;
    end
    else exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- Ввод ограничений
      if ObjZv[ID_Obj].ObCB[8] or
      ObjZv[ID_Obj].ObCB[9] then //----------- есть закрытие движения на электротяге
      begin //---------------------------------------------------------- закрытие движения
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
        //----------------------------------------------- закрытие движения на электротяге
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
        ObjZv[ID_Obj].ObCB[9] then //----------------------- есть 2 вида электротяги
        begin  //----------------------- закрытие движения на электротяге постоянного тока
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
          //---------------------------- закрытие движения на электротяге переменного тока
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
      begin //------------------------------------------------------------ нет электротяги
        if ObjZv[ID_Obj].bP[12] <> ObjZv[ID_Obj].bP[13] then
        begin
          InsNewMsg(ID_Obj,207+$4000,7,'');
          InsNewMsg(ID_Obj,206+$4000,7,'');
          AddDspMenuItem(GetSmsg(1,207, '',7), M_OtkrytPeregonPAB,ID_Obj);
          AddDspMenuItem(GetSmsg(1,206, '',7), M_ZakrytPeregonPAB,ID_Obj);
        end else
        begin
          if ObjZv[ID_Obj].bP[13] or ObjZv[ID_Obj].bP[12] then
          begin //--------------------------------------- Перегон закрыт - открыть перегон
            InsNewMsg(ID_Obj,207+$4000,7,'');
            msg := GetSmsg(1,207, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_OtkrytPeregonPAB;
            DspCom.Obj := ID_Obj;
          end else
          begin //--------------------------------------- Перегон открыт - закрыть перегон
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
      begin //------------------------------------------------------------------- режим ОК
        if not ObjZv[ID_Obj].bP[1] then
        begin //-------------------------------------------------- перегон занят по приему
          if ObjZv[ID_Obj].bP[3] then
          begin //------------------------------------------ выдать исполнительную команду
            InsNewMsg(ID_Obj,281+$4000,7,'');
            msg := GetSmsg(1,281, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_IskPribytieIspolnit;
            DspCom.Obj := ID_Obj;
          end else
          begin //----------------------------------------- выдать предварительную команду
            InsNewMsg(ID_Obj,280+$4000,7,'');
            msg := GetSmsg(1,280, ObjZv[ID_Obj].Liter,7);
            DspCom.Com := M_IskPribytiePredv;
            DspCom.Obj := ID_Obj;
          end;
        end else
        begin //----------------------------------------- не требуется выдача иск.прибытия
          InsNewMsg(ID_Obj,298+$4000,7,'');
          ShowSmsg(298,LastX,LastY,ObjZv[ID_Obj].Liter);
          exit;
        end;
      end else
      if not ObjZv[ID_Obj].bP[1] then
      begin //---------------------------------------------------- Перегон занят по приему
        if ObjZv[ID_Obj].bP[2] then
        begin //--------------------------------- получено прибытие поезда - дать прибытие
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
      begin //----------------------------------------------- Перегон занят по отправлению
        InsNewMsg(ID_Obj,299+$4000,7,'');
        ShowSmsg(299,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if ObjZv[ID_Obj].bP[6] then
      begin //---------------------------------------------- Получено согласие отправления
        InsNewMsg(ID_Obj,326+$4000,7,'');
        ShowSmsg(326,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      if not ObjZv[ID_Obj].bP[7] then
      begin //------------------------------------------------------- Хозпоезд на перегоне
        InsNewMsg(ID_Obj,130+$4000,1,'');
        ShowSmsg(130,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end else
      begin //----------------------------------- Перегон свободен - выдать/снять согласие
        if ObjZv[ID_Obj].bP[4] then
        begin //----------------------------------------------- снять согласие отправления
          InsNewMsg(ID_Obj,279+$4000,7,'');
          msg := GetSmsg(1,279, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_OtmenaSoglasieOtpravl;
          DspCom.Obj := ID_Obj;
        end else
        begin //------------------------------------------------ дать согласие отправления
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
//-------------------------------------------------- создание меню для управления стрелкой
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
	  hvost := BasOb; SP_str := UpdOb; AvPer := ObjZv[hvost].ObCI[13];//хвост, СП и авар.пер
    //----- при активизации работы оператора со стрелкой снимаются автовозвратные признаки
    with ObjZv[hvost] do
    begin //---------------------- стрелка АВ и (размыкание СП АВ или активна проверка АВ)
      if ObCB[2] and (bP[3] or bP[12]) then
      begin //---------- сброс признаков размыкания СП и активизации проверки автовозврата
        bP[3] := false; bP[12] := false;
        InsNewMsg(hvost,424+$4000,7,'');//------------------ "прерван автовозврат в охранное"
        AddFixMes(GetSmsg(1,424,Liter,7),4,1);
      end;
    end;
    //------------ сначала работа с ответственными командами, для стрелок это нормализация
    if WorkMode.OtvKom then //--------------------------------------------- если нажата ОК
    begin //------------------- нажата ОК - нормализовать признаки трассировки для стрелки
      InsNewMsg(ID_Obj,311+$4000,7,''); //------------------------------- "нормализовать?"
      msg := GetSmsg(1,311, 'стрелку '+Liter,7);
      DspCom.Com := CmdMarsh_ResetTraceParams; //-----
      DspCom.Obj := ID_Obj;
    end else
	  //---------------------------------------------------- сброс работы с отменой маршрута
    //----------- если ранее выбрана отмена маршрута, Сбросить отмену маршрута и выйти
    if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
    if ActivenVSP(ID_Obj) then exit;
	  //--------------------------------------------------------- сброс работы в трассировке
    if WorkMode.GoTracert then //------------------------- если идет набор трассы маршрута
    begin
      ResetTrace; //-------------- Сбросить набранную трассу маршрута и структуры маршрута
      exit; //-------------------------------------------------------------------- и выйти
    end else

	  //--------------------------------------------- возможная работа с установкой на макет
    if WorkMode.GoMaketSt then //--------------------- если было начало установки на макет
    begin
      if not ObjZv[SP_str].bP[5] or //----------------------------------- если у СП МИ или
      ObjZv[SP_str].bP[9] then      //-------------------------------------------- у СП РМ
      begin //- сообщить:"стрелка на местном управлении" прервать работу с макетом и выйти
        InsNewMsg(hvost,91+$4000,1,'');
        WorkMode.GoMaketSt := false;
        ShowSmsg(91,LastX,LastY,ObjZv[hvost].Liter);//-- "Стрелка $ на местном управлении"
        WorkMode.GoMaketSt := false; //--------- сброс признака работы по установке макета
        exit;
      end else
      if ObjZv[hvost].bP[14] or//-------------------------- стрелку замкнула программа или
      bP[10] or //-------------------------------- признак первого прохода трассировки или
      bP[11] or//--------------------------------- признак второго прохода трассировки или
      bP[12] or //------------------------ признак пошерстной в плюсе или
      bP[13] or //----------------------- признак пошерстной в минусе или
      bP[6] or //------------------------------------ есть признак ПУ или
      bP[7] then //-------------------------------------- есть признак МУ
      begin //------------- сообщить: "стрелка в маршруте" прервать работу с макетом и выйти
        InsNewMsg(hvost,511+$4000,1,'');
        WorkMode.GoMaketSt := false;
        ShowSmsg(511,LastX,LastY,ObjZv[hvost].Liter);//--------- "Стрелка $ в маршруте"
        WorkMode.GoMaketSt := false; //----------- сброс признака работы по установке макета
        exit;
      end else
      if bP[1] or bP[2] then //--- если есть ПК или МК
      begin //------------------------ Есть контроль положения - отказ от установки на макет
      //--- "Нет сообщения о потере контроля положения стрелки $! Ошибка установки макета"
        InsNewMsg(hvost,92,1,'');
        RSTMsg;
        AddFixMes(GetSmsg(1,92,ObjZv[hvost].Liter,1),4,1);
        ShowSmsg(92, LastX, LastY, ObjZv[hvost].Liter);
        WorkMode.GoMaketSt := false;
        exit;
      end else
      if ObjZv[hvost].bP[26] and //-------------- если есть сообщение о потере контроля
      not(ObjZv[hvost].bP[32] or bP[32])then //----- и все парафазно
      begin //----------------------------------- Запросить подтверждение установки на макет
        InsNewMsg(hvost,138+$4000,7,''); //------------------ Установить стрелку $ на макет?
        msg := GetSmsg(1,138,ObjZv[hvost].Liter,7);
        DspCom.Com := M_UstMaketStrelki;
        DspCom.Obj := ID_Obj;
      end else
      begin
        //--- "Нет сообщения о потере контроля положения стрелки $! Ошибка установки макета"
        InsNewMsg(hvost,92,1,'');
        AddFixMes(GetSmsg(1,92,ObjZv[hvost].Liter,1),4,1);
        ShowSmsg(92, LastX, LastY, ObjZv[hvost].Liter);
        WorkMode.GoMaketSt := false;
        exit;
      end;
    end else
    //--------------------------------------------- возможна работа с установкой ограничений
    begin //---------------------------------------------------- если нет установки на макет
      if WorkMode.InpOgr then //------------------------------------------- ввод ограничений
      begin
        if bP[33] or bP[25 ] then // если автодействие
        begin //------------------------------------------------------ включено автодействие
          InsNewMsg(BasOb,431+$4000,1,''); //--- "включено автодействие"
          WorkMode.InpOgr := false;
          ShowSmsg(431, LastX, LastY, '');
          exit;
        end else
        if bP[5] or //-------- если есть требование перевода охранной или
        bP[6] or //------------------------------------------ есть ПУ или
        bP[7] or //------------------------------------------ есть МУ или
        bP[8] or //---------------- идет ожидание перевода в охранное или
        bP[14] then //---------- есть признак программного замыкания АРМа
        begin //------------ стрелка в трассировке маршрута ограничения устанавливать нельзя
          InsNewMsg(BasOb,511+$4000,1,'');//------- "стрелка в маршруте"
          WorkMode.InpOgr := false;
          ShowSmsg(511, LastX, LastY, ObjZv[BasOb].Liter);
          exit;
        end else
        if not ObjZv[SP_str].bP[5] or//------------------------------------ если МИ или
        ObjZv[SP_str].bP[9] then //------------------------------------ есть признак РМ
        begin //-------------------------------------- ходовая стрелка на местном управлении
          InsNewMsg(hvost,91+$4000,1,''); //---------------------- "стрелка на местном упр."
          WorkMode.InpOgr := false;
          ShowSmsg(91, LastX, LastY, ObjZv[hvost].Liter);
          exit;
        end else
        begin //---------- если нет соответствия по выключению стрелки в основном и в хвосте
          if bP[18] <> ObjZv[hvost].bP[18] then //
          begin
            InsNewMsg(hvost,169+$4000,7,''); //--------------------- "включить управление ?"
            InsNewMsg(hvost,168+$4000,7,''); //-------------------- "отключить управление ?"
            AddDspMenuItem(GetSmsg(1,169, '',7), M_StrVklUpravlenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,168, '',7), M_StrOtklUpravlenie,ID_Obj);
          end else //------------------------------------ если по отключению есть совпадение
          begin
            if bP[18] then //------- если стрелка выключена из управления
            begin
              InsNewMsg(hvost,169+$4000,7,''); //--------------------- Включить управление $
              AddDspMenuItem(GetSmsg(1,169, '',7), M_StrVklUpravlenie,ID_Obj);
            end else
            begin
              InsNewMsg(hvost,168+$4000,7,''); //----------------- Отключить от управления $
              AddDspMenuItem(GetSmsg(1,168, '',7),M_StrOtklUpravlenie,ID_Obj);
            end;
          end;

          //------------------------------------------- закрыть для движения стрелку (тип 2)
          if ObCB[6] then //--------------------- если "дальняя" стрелка
          ogr := ObjZv[hvost].bP[17]//--------- закрытие движения из хвоста для дальней
          else ogr :=ObjZv[hvost].bP[16];//------- иначе закрытие из хвоста для ближней

          if bP[16] <> ogr then //---- если закр.стрелки не соотв. хвосту
          begin
            InsNewMsg(ID_Obj,171+$4000,7,''); //--------------------- "открыть для движения"
            InsNewMsg(ID_Obj,170+$4000,7,''); //--------------------- "закрыть для движения"
            AddDspMenuItem(GetSmsg(1,171, '',7), M_StrOtkrytDvizenie,ID_Obj);
            AddDspMenuItem(GetSmsg(1,170, '',7), M_StrZakrytDvizenie,ID_Obj);
          end else //----------------------- если соответствуют ограничения стрелки и хвоста
          begin
            if bP[16] then //------------------ если закрыта для движения
            begin
              InsNewMsg(ID_Obj,171+$4000,7,''); //------------------- "открыть для движения"
              AddDspMenuItem(GetSmsg(1,171, '',7), M_StrOtkrytDvizenie,ID_Obj);
            end else //---------------------------------------- если не закрыта для движения
            begin
              InsNewMsg(ID_Obj,170+$4000,7,''); //--------------------"закрыть для движения"
              AddDspMenuItem(GetSmsg(1,170, '',7), M_StrZakrytDvizenie,ID_Obj);
            end;
          end;

          if not ObCB[10] then // если стрелка, а не сбрасывающий башмак
          begin //--- закрыть для движения противошерстных, если не является сбрас. башмаком
            if ObCB[6] //----------------------- если это парная дальняя
            then ogr:= ObjZv[hvost].bP[34]//--------------- взять из хвоста для дальней
            else ogr:=ObjZv[hvost].bP[33];//--------- иначе взять из хвоста для ближней

            if bP[17] <> ogr then //------- закрытие не совпало с хвостом
            begin
              InsNewMsg(ID_Obj,450+$4000,7,''); //-- "открыть для противошерстного движения"
              InsNewMsg(ID_Obj,449+$4000,7,''); //-- "закрыть для противошерстного движения"
              AddDspMenuItem(GetSmsg(1,450, '',7),M_StrOtkrytProtDvizenie,ID_Obj);
              AddDspMenuItem(GetSmsg(1,449, '',7),M_StrZakrytProtDvizenie,ID_Obj);
            end else //------------------------------------------ если закрытие как в хвосте
            begin
              if bP[17] then //-------- если закрыта для противошерстного
              begin
                InsNewMsg(ID_Obj,450+$4000,7,'');//- "открыть для противошерстного движения"
                AddDspMenuItem(GetSmsg(1,450,'',7),M_StrOtkrytProtDvizenie,ID_Obj);
              end else
              begin
                InsNewMsg(ID_Obj,449+$4000,7,'');//- "закрыть для противошерстного движения"
                AddDspMenuItem(GetSmsg(1,449,'',7),M_StrZakrytProtDvizenie,ID_Obj);
              end;
            end;
          end;

          //--------------------------------- сбросить макет стрелки в случае развала макета
          if ObjZv[hvost].bP[15] and //------------------------- если хвост на макете и
          (maket_strelki_index <> hvost) then //--------------------- в макете не та стрелка
          begin
            InsNewMsg(BasOb,172+$4000,7,'');//- "снять с макета стрелку"
            AddDspMenuItem(GetSmsg(1,172, '',7),CmdStr_ResetMaket,ID_Obj);
          end;
        end;
      end else
      //------------------------------------------------------ если не установка ограничений
      if not ObjZv[hvost].bP[31] then //----------------- если нет активности по хвосту
      begin //---------------------------------------------------------- нет данных в канале
        InsNewMsg(ID_Obj,255+$4000,7,''); //--- "отсутствует информация о положении стрелки"
        VspPerevod.Active := false; //----------- снять активность вспомогательного перевода
        WorkMode.VspStr := false;  //----- выключить режим вспомогательного перевода стрелки
        ShowSmsg(255, LastX, LastY, ObjZv[BasOb].Liter);
        exit;
      end else
      //---------------------------------------------- далее, если есть активность по хвосту
      if ObjZv[hvost].bP[4] or // если есть дополнительное замыкание хвоста стрелки или
      bP[4] or //------------ есть дополнительное замыкание в стрелке или
      not ObjZv[hvost].bP[21] then //-------------------- есть замыкание в хвосте от СП
      begin //------------------------------------------ "стрелка замкнута,перевод запрещен"
        ShowWarning := true;
        msg := GetSmsg(1,147,ObjZv[hvost].Liter,1);
        InsNewMsg(hvost,147+$4000,1,'');
        exit;
      end else //-------------------------------------------------- далее,если нет замыканий
      if bP[18] or //------------------------- если выключена стрелка или
      ObjZv[hvost].bP[18] then //--------------------------------------- выключен хвост
      begin //-------------------------- "стрелка выключена из управления, перевод запрещен"
        InsNewMsg(hvost,151+$4000,7,'');
        ShowSmsg(151,LastX,LastY,ObjZv[hvost].Liter);
        msg := GetSmsg(1,151,ObjZv[hvost].Liter,7);
        exit;
      end else //-------------------------------------------------- далее, если не выключена
      if ObjZv[AvPer].bP[1] then // если в объекте аварийного перевода есть признак ГВК
      begin
        if WorkMode.VspStr then //-------------- если есть признак вспомогательного перевода
        begin
          InsNewMsg(hvost,411+$4000,7,'');//---- "нарушен порядок вспомог. перевода стрелки"
          ShowSmsg(411,LastX,LastY,ObjZv[hvost].Liter);
          msg := GetSmsg(1,411,ObjZv[hvost].Liter,7);
          exit;
        end else //----------------------------- если нет признака вспомогательного перевода
        begin
          //--------- "Нажата кнопка вспомогательного перевода. Перевод стрелки $ запрещен!"
				  InsNewMsg(hvost,139+$4000,1,'');
          ShowSmsg(139,LastX,LastY,ObjZv[hvost].Liter);
          exit;
        end;
      end else //---------------------------------------------- далее, если нет признака ГВК
      if ObjZv[hvost].bP[14] or//----------------------- если программное замыкание или
      ObjZv[hvost].bP[23] then //----------------------------- трасировака как охранной
      begin //----- стрелка трассируется в маршруте  - предупредить, затем запросить перевод
        InsNewMsg(hvost,240+$4000,7,''); //---------------- "стрелка в маршруте,продолжать?"
        msg := GetSmsg(1,240,ObjZv[hvost].Liter,7);
        ShowWarning := true;
        DspCom.Com := CmdStr_AskPerevod;
        DspCom.Obj := ID_Obj;
      end else //------------------------ если нет программного замыкания стрелки в маршруте
      begin //---------------------------------------------------- запрос на перевод стрелки
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
//----------------------------- создание меню для управления объектом "Маневровая колонка"
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
  if WorkMode.InpOgr then WorkMode.InpOgr := false;//----------- Сбросить ввод ограничений
  if Trassir then exit;
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- отмена -
    WorkMode.MarhOtm := false;
    if ObjZv[ID_Obj].bP[8] then
    begin //---------------------------------- выдана РМ - отменить или остановить маневры
      if ObjZv[ID_Obj].bP[3] then
      begin //---------------------------------------------------- маневры еще не замкнуты
        InsNewMsg(ID_Obj,218+$4000,7,'');
        msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- маневры замкнуты
        if ObjZv[ID_Obj].bP[5] then //---------------------- есть восприятие маневров
        begin //------------------------------------------------------- остановить маневры
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
    begin //------------------------------------------- есть РМ или РМК - отменить маневры
      if ObjZv[ID_Obj].bP[5] and
      not ObjZv[ID_Obj].bP[3] then //------------------ есть восприятие маневров и МИ
      begin //--------------------------------------------------------- остановить маневры
        InsNewMsg(ID_Obj,446+$4000,7,'');
        msg := GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ проверить условия отмены маневров
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ нет условий для отмены - остановить маневры
          InsNewMsg(ID_Obj,446+$4000,7,'');
          msg := msg + '! ' + GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
        end else
        begin //--------------------------------------------------------- отменить маневры
          InsNewMsg(ID_Obj,218+$4000,7,'');
          msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
        end;
      end;
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    if not ObjZv[ID_Obj].bP[3] and not ObjZv[ID_Obj].bP[5] then
    begin //-------------- есть МИ и снято восприятие маневров - запустить отмену маневров
      InsNewMsg(ID_Obj,218+$4000,7,'');
      msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    if ObjZv[ID_Obj].bP[5] then //---------------------- не снято восприятие маневров
    begin //--------------------------------------------------------------------- отказать
      InsNewMsg(ID_Obj,269+$4000,7,'');
      ShowSmsg(269,LastX,LastY, ObjZv[ID_Obj].Liter); exit;
    end;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsNewMsg(ID_Obj,220+$4000,7,'');
        msg := GetSmsg(1,220, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_IspolIRManevrov;
        DspCom.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsNewMsg(ID_Obj,219+$4000,7,'');
        msg := GetSmsg(1,219, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvIRManevrov;
        DspCom.Obj := ID_Obj;
      end;
    end else
    if ObjZv[ID_Obj].bP[8] then
    begin //------------------------------------------------- выдана РМ - отменить маневры
      if ObjZv[ID_Obj].bP[3] then
      begin //---------------------------------------------------- маневры еще не замкнуты
        InsNewMsg(ID_Obj,218+$4000,7,'');
        msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- маневры замкнуты
        if ObjZv[ID_Obj].bP[5] then //---------------------- есть восприятие маневров
        begin //------------------------------------------------------- остановить маневры
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
    begin //------------------------------------------- есть РМ или РМК - отменить маневры
      if ObjZv[ID_Obj].bP[5] and
      not ObjZv[ID_Obj].bP[3] then //------------------ есть восприятие маневров и МИ
      begin //--------------------------------------------------------- остановить маневры
        InsNewMsg(ID_Obj,446+$4000,7,'');
        msg := GetSmsg(1,446, ObjZv[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ проверить условия отмены маневров
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ нет условий для отмены - остановить маневры
          InsNewMsg(ID_Obj,446+$4000,1,'');
          msg := msg + '! ' + GetSmsg(1,446, ObjZv[ID_Obj].Liter,1);
        end else
        begin //--------------------------------------------------------- отменить маневры
          InsNewMsg(ID_Obj,218+$4000,7,'');
          msg := GetSmsg(1,218, ObjZv[ID_Obj].Liter,7);
        end;
      end;
      DspCom.Com := M_OtmenaManevrov;
      DspCom.Obj := ID_Obj;
    end else
    begin //------------------------------- нет РМ - проверить условия передачи на маневры
      if ObjZv[ID_Obj].bP[3] then
      begin //--------------------------------------------------------------------- нет МИ
        if VytajkaRM(ID_Obj) then
        begin
          if MarhTrac.WarN > 0 then
          begin
            MessCount :=MarhTrac.WarN;//число предупрежд. при установке маршрута
            MessObj :=  MarhTrac.WarObj[MessCount];//объект сообщ. предупреждения
            WarObj := MarhTrac.WarInd[MessCount];//индекс сообщения предупреждения
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
        begin //-------------------------- вывести сообщение об отказе передачи на маневры
          InsNewMsg(MarhTrac.MsgObj[1],MarhTrac.MsgInd[1]+$4000,7,'');
          PutSmsg(1,LastX,LastY,MarhTrac.Msg[1]);
          exit;
        end;
      end else
      begin //-------------------------------------------------------------------- есть МИ
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
//------------------------------------------ создание меню для объекта "Замыкание стрелок"
function NewMenu_ZamykStr(X,Y : SmallInt): boolean;
begin //---------------------------------------------------------------- Замыкание стрелок
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin  WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- нормальный режим
  InsNewMsg(ID_Obj,189+$4000,1,'');
  msg := GetSmsg(1,189, ObjZv[ID_Obj].Liter,1);
  DspCom.Com := M_ZamykanieStrelok;
  DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//----------------------------------------- создание меню для объекта "Размыкание стрелок"
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
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //----------------------------------------------------- исполнительная команда
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,191+$4000,7,'');
      msg := GetSmsg(1,191, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolRazmykanStrelok;
      DspCom.Obj := ID_Obj;
    end else
    begin //---------------------------------------------------- предварительная команда
      InsNewMsg(ID_Obj,190+$4000,7,'');
      msg := GetSmsg(1,190, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvRazmykanStrelok;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//------------------------------------------------------------------------ Закрыть переезд
function NewMenu_ZakrytPereezd(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- нормальный режим
  InsNewMsg(ID_Obj,192+$4000,7,'');
  msg := GetSmsg(1,192, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_ZakrytPereezd;
  DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ Создание меню для объекта "Открытие переезда"
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
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //----------------------------------------------------- исполнительная команда
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,194+$4000,7,'');
      msg := GetSmsg(1,194, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtkrytPereezd;
      DspCom.Obj := ID_Obj;
    end else
    begin //---------------------------------------------------- предварительная команда
      InsNewMsg(ID_Obj,193+$4000,7,'');
      msg := GetSmsg(1,193, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvOtkrytPereezd;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//----------------------------------------------- создание меню для "Извещения на переезд"
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
  //--------------------------------------------------------------------- нормальный режим
  if ObjZv[ID_Obj].bP[11] then
  begin //-------------------------------------------------------------- снять извещение
    DspCom.Com := M_SnatIzvecheniePereezd;
    DspCom.Obj := ID_Obj;
    color := 7;
    InsNewMsg(ID_Obj,196+$4000,color,'');
    msg := GetSmsg(1,196, ObjZv[ID_Obj].Liter,color);
  end else
  begin //--------------------------------------------------------------- дать извещение
    InsNewMsg(ID_Obj,195+$4000,7,'');
    msg := GetSmsg(1,195, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_DatIzvecheniePereezd;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------- создание меню для управления объектом "Поездное оповещение"
function NewMenu_PoezdOpov(X,Y : SmallInt): boolean;
begin //-------------------------------------------------------------- Поездное оповещение
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ObjZv[ID_Obj].TypeObj = 36 then bit_for_kom := 1  else bit_for_kom := 2;

  if Spec_Reg(ID_Obj) then exit;

  if WorkMode.MarhOtm then
  begin //----------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    if ObjZv[ID_Obj].bP[bit_for_kom] then
    begin //------------------------------------------------------- отключить оповещение
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
    begin //------------------------------------------------------- отключить оповещение
      InsNewMsg(ID_Obj,198+$4000,7,'');
      msg := '';
      if ObjZv[ID_Obj].bP[3] or ObjZv[ID_Obj].bP[4] then  msg := GetSmsg(1,309,'',7);
      msg := msg + GetSmsg(1,198, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_SnatOpovechenie;
      DspCom.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------- включить оповещение
      InsNewMsg(ID_Obj,197+$4000,7,'');  //----------------------- включить оповещение ?
      msg := GetSmsg(1,197, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_DatOpovechenie;
      DspCom.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------- Создание меню для управления объектом "Запрет монтерам"
function NewMenu_ZapretMont(X,Y : SmallInt): boolean;
begin// Запрет монтерам
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom or (not ObjZv[ID_Obj].bP[1]) then
  begin
    if ObjZv[ID_Obj].ObCB[1] then
    begin
      if ObjZv[ID_Obj].bP[2] then
      begin
        if not ObjZv[ID_Obj].bP[1] then
        begin //---------------------------------------------- отключить запрет монтерам
          InsNewMsg(ID_Obj,200+$4000,7,'');
          msg := GetSmsg(1,200, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_SnatZapretMonteram;
          DspCom.Obj := ID_Obj;
        end else
        begin //----------------------------------------------- включить запрет монтерам
          InsNewMsg(ID_Obj,199+$4000,7,'');
          msg := GetSmsg(1,199, ObjZv[ID_Obj].Liter,7);
          DspCom.Com := M_DatZapretMonteram;
          DspCom.Obj := ID_Obj;
        end;
      end else
      begin //------------------------- оповещение выключено - нельзя управлять запретом
        InsNewMsg(ID_Obj,483+$4000,1,'');
        ShowSmsg(483,LastX,LastY,'');
        exit;
      end;
    end else
    begin
      if ObjZv[ID_Obj].bP[1] then
      begin //------------------------------------------------ отключить запрет монтерам
        InsNewMsg(ID_Obj,200+$4000,7,'');
        msg := GetSmsg(1,200, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_SnatZapretMonteram;
        DspCom.Obj := ID_Obj;
      end else
      begin //------------------------------------------------- включить запрет монтерам
        InsNewMsg(ID_Obj,199+$4000,7,'');
        msg := GetSmsg(1,199, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_DatZapretMonteram;
        DspCom.Obj := ID_Obj;
      end;
    end;
  end else
  begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//------------------------------ создание меню для управления отключением запрета монтерам
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
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //----------------------------------------------------- исполнительная команда
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,528+$4000,7,'');
      msg := GetSmsg(1,528, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtklZapMont;
      DspCom.Obj := ID_Obj;
    end else
    begin //---------------------------------------------------- предварительная команда
      InsNewMsg(ID_Obj,527+$4000,7,'');
      msg := GetSmsg(1,527, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvOtklZapMont;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//----------------------------------------------------- создание меню для управления УКСПС
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
  //--------------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- исполнительная команда
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,202+$4000,7,'');
      msg := GetSmsg(1,202, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtkluchenieUKSPS;
      DspCom.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- если 1-ый или 2-ой датчик
    //if ObjZv[ID_Obj].bP[3] or ObjZv[ID_Obj].bP[4] then
    begin //------------------------------------- сработал УКСПС - предварительная команда
      InsNewMsg(ID_Obj,201+$4000,7,'');
      msg := GetSmsg(1,201, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_PredvOtkluchenieUKSPS;
      DspCom.Obj := ID_Obj;
    end;
  end
  else
  begin //--------------------------------------- не нажата ОК - сбросить блокировку УКСПС
    if ObjZv[ID_Obj].bP[1] and ObjZv[ID_Obj].ObCB[1] then
    begin //--------------- Есть команда отмены и УКСПС заблокирован - сбросить блокировку
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
//-------------------------- создание меню для управления объектом "Вспомогательный прием"
function NewMenu_VspomPriem(X,Y : SmallInt): boolean;
begin //------------------------------------------------------------ Вспомогательный прием
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //-------------------------------------------------- исполнительная команда ВП
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,211+$4000,7,'');
      msg := GetSmsg(1,211, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolVspomPriem;
      DspCom.Obj := ID_Obj;
    end else
    begin
      if ObjZv[ObjZv[ID_Obj].BasOb].bP[6] then //ключ-жезл вставлен в аппарат
      begin //----------------------------------------------- предварительная команда ВП
        InsNewMsg(ID_Obj,210+$4000,7,'');
        msg := GetSmsg(1,210, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvVspomPriem;
        DspCom.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- КЖ изъят из аппарата
        InsNewMsg(ID_Obj,337+$4000,1,'');
        ShowSmsg(357,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end;
    end;
  end else
  begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//-------------------------------- создание меню для объекта "Вспомогательное отправление"
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
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //-------------------------------------------------- исполнительная команда Во
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,209+$4000,7,'');
      msg := GetSmsg(1,209, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolVspomOtpravlenie;
      DspCom.Obj := ID_Obj;
    end else
    begin //--------------------------------------------------------------- проверить КЖ
      if ObjZv[ObjZv[ID_Obj].BasOb].bP[6] then //ключ-жезл вставлен в аппарат
      begin //----------------------------------------------- предварительная команда Во
        InsNewMsg(ID_Obj,208+$4000,7,'');
        msg := GetSmsg(1,208, ObjZv[ID_Obj].Liter,7);
        DspCom.Com := M_PredvVspomOtpravlenie;
        DspCom.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- КЖ изъят из аппарата
        InsNewMsg(ID_Obj,357+$4000,1,'');
        ShowSmsg(357,LastX,LastY,ObjZv[ID_Obj].Liter);
        exit;
      end;
    end;
  end else
  begin //----------------------------- не нажата ОК - прекратить формирование команды
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
//-------------------------------------------- создание меню для объекта "Очистка стрелок"
function NewMenu_OchistkaStrelok(X,Y : SmallInt): boolean;
begin //------------------------------------------------------------------ Очистка стрелок
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}  ID_ViewObj := ID_Obj; exit;  {$ELSE}

  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- нормальный режим

  if ObjZv[ID_Obj].bP[1] then
  begin //---------------------------------------------------------------- вытащить кнопку
    InsNewMsg(ID_Obj,5+$4000,7,'');
    msg := MsgList[ObjZv[ID_Obj].ObCI[5]];
    DspCom.Com := M_OtklOchistkuStrelok;
    DspCom.Obj := ID_Obj;
  end else
  begin //------------------------------------------------------------------ нажать кнопку
    InsNewMsg(ID_Obj,4+$4000,7,'');
    msg := MsgList[ObjZv[ID_Obj].ObCI[4]];
    DspCom.Com := M_VkluchOchistkuStrelok;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------------- Включение выдержки времени ГРИ1
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
  //--------------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then //--------------------------------- Если ответственные команды
  begin //--------------------------------------------------------------- выдать команду
    if ObjZv[ID_Obj].bP[2] then
    begin //----------------------------------- уже включена выдержка времени ИР - отказ
      InsNewMsg(ID_Obj,335+$4000,1,'');
      ShowSmsg(335,LastX,LastY,ObjZv[ID_Obj].Liter);
      exit;
    end else
    begin //------------------------------------------------------------- выдать команду
      msg := '';
      if ObjZv[ID_Obj].ObCI[3] <> 0 then
      begin
        //--------------------------------- не выбраны секции для ИР,дать предупреждение
        InsNewMsg(ID_Obj,214+$4000,7,'');
        if not ObjZv[ID_Obj].bP[3] then msg := GetSmsg(1,264,'',1) + ' ';
      end;
      msg := msg + GetSmsg(1,214, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_VkluchenieGRI;
      DspCom.Obj := ID_Obj;
    end;
  end else
  begin //----------------------------------------------------- не ответственная команда
    InsNewMsg(ID_Obj,263+$4000,1,'');
    ShowSmsg(263,LastX,LastY,'');
    exit;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------- Участок извещения из тупика, Путь без ограждения
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
  begin //------------------------------- ОК - нормализовать признаки трассировки для пути
    InsNewMsg(ID_Obj,311+$4000,7,'');
    msg := GetSmsg(1,311, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := CmdMarsh_ResetTraceParams;
    DspCom.Obj := ID_Obj;
  end else

  if ObjZv[ID_Obj].bP[19] then //------------------- Восприятие диагностического сообщения
  begin ObjZv[ID_Obj].bP[19] := false; exit; end;
  //--------------------------------------------------------------------- нормальный режим
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
//---------------------------------------------------------------- Питание ламп светофоров
function NewMenu_DSNLamp(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if not WorkMode.OtvKom then
  begin //--------------------------------- не нажата ОК - прекратить формирование команды
    InsNewMsg(ID_Obj,276+$4000,1,''); //- действие требует нажатия кнопки ответств. команд
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
    InsNewMsg(ID_Obj,546+$4000,7,'');   //------------------------ "включить режим ДСН?"
    msg := GetSmsg(1,546,'',7);
    DspCom.Com := M_VklDSN;
  end else
  begin
    InsNewMsg(ID_Obj,547+$4000,7,'');   //----------------------- "отключить режим ДСН?"
    msg := GetSmsg(1,547,'',7);
    DspCom.Com := M_OtklDSN;
  end;
  DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------------------- Включение дневного режима
function NewMenu_RezymLampDen(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    InsNewMsg(ID_Obj,283+$4000,7,'');
    ResetCommands;
    ShowSmsg(283,LastX,LastY,'');
    msg := GetSmsg(1,283, ObjZv[ID_Obj].Liter,7);
    exit;
  end else
  begin
    InsNewMsg(ID_Obj,221+$4000,7,'');   //------------------- "включить дневной режим ?"
    msg := GetSmsg(1,221, ObjZv[ID_Obj].Liter,7);
    DspCom.Com := M_VkluchitDen;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------------- Включение ночного режима
function NewMenu_RezymLampNoch(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    InsNewMsg(ID_Obj,283+$4000,7,'');
    ResetCommands;
    ShowSmsg(283,LastX,LastY,'');   //----------- Нажата кнопка ответственных команд
    msg := GetSmsg(1,283, ObjZv[ID_Obj].Liter,7);
    exit;
  end else
  begin
    InsNewMsg(ID_Obj,222+$4000,7,'');
    msg := GetSmsg(1,222, ObjZv[ID_Obj].Liter,7);// Включить ночной режим (ручной)?
    DspCom.Com := M_VkluchitNoch;
    DspCom.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------------- Включение автоматического режима
function NewMenu_RezymLampAuto(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- нормальный режим
  InsNewMsg(ID_Obj,223+$4000,7,'');
  msg := GetSmsg(1,223, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_VkluchitAuto;
  DspCom.Obj := ID_Obj;
  result := true;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------- исключение УКГ из зависимостей
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
  //--------------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- исполнительная команда
      OtvCommand.SObj := ID_Obj;
      InsNewMsg(ID_Obj,565+$4000,7,'');
      msg := GetSmsg(1,565, ObjZv[ID_Obj].Liter,7);
      DspCom.Com := M_IspolOtkluchenieUKG;
      DspCom.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- если 1-ый или 2-ой датчик
    //if ObjZv[ID_Obj].bP[3] or ObjZv[ID_Obj].bP[4] then
    begin //------------------------------------- сработал УКГ - предварительная команда
      InsNewMsg(ID_Obj,564+$4000,7,'');
      msg := GetSmsg(1,564, ObjZv[ID_Obj].Liter,7);
      ShowSmsg(564,LastX,LastY,'');
      DspCom.Com := M_PredvOtkluchenieUKG;
      DspCom.Obj := ID_Obj;
    end;
  end
  else
  begin //------------------------------------------------ не нажата ОК - сбросить команду
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
//------------------------------------------------------------ включение УКГ в зависимости
function NewMenu_VklUKG(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if Spec_Reg(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  //--------------------------------------------------------------- нормальный режим
  InsNewMsg(ID_Obj,563+$4000,7,'');
  msg := GetSmsg(1,563, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_OtmenaOtkluchenieUKG ;
  DspCom.Obj := ID_Obj;
  result := true;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------- Выключение звонка УКСПС
function NewMenu_OtklZvonkaUKSPS(X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj; result := true;
  {$IFNDEF RMDSP}  ID_ViewObj := ID_Obj;  exit; {$ELSE}

  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsNewMsg(ID_Obj,283+$4000,1,''); ResetCommands;  ShowSmsg(283,LastX,LastY,''); exit;
  end else
  if ActivenVSP(ID_Obj) then exit;
  if WorkMode.MarhOtm then begin WorkMode.MarhOtm := false; exit; end;
  if (WorkMode.GoMaketSt or WorkMode.VspStr) and NotStr(ID_Obj) then exit;
  if Trassir then exit;
  //--------------------------------------------------------------------- нормальный режим
  InsNewMsg(ID_Obj,203+$4000,7,''); msg := GetSmsg(1,203, ObjZv[ID_Obj].Liter,7);
  DspCom.Com := M_OtklZvonkaUKSPS; DspCom.Obj := ID_Obj;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//---------------------------------------------------------------------- формирование меню
procedure MakeMenu(var X : smallint);
var
  i,j : integer;
begin   //-------------------------------------------------------------- формирование меню
{$IFDEF RMDSP}
  if DspMenu.Count > 0 then //---------------------------------- если есть что-то для меню
  begin
    TabloMain.PopupMenuCmd.Items.Clear; //---------------------------- очистить меню табло
    for i := 1 to DspMenu.Count
    do TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//взять меню из DspMenu
    i := configRU[config.ru].T_S.Y - 10;
    SetCursorPos(x,i);
    TabloMain.PopupMenuCmd.Popup(X, i+3-17*DspMenu.Count);
  end  else
  begin //---------------------------- Вывести подсказку перед выполнением простой команды
    j := x div configRU[config.ru].MonSize.X + 1; //-------------------- Найти номер табло
    //------------------------- если это то табло, которое соответствует району управления

    for i:=1 to High(SMsg) do
    begin
      if i=j then begin Smsg[i]:=msg; SMsgCvet[i]:=GetColor1(7); end else Smsg[i]:='';
    end;
  end;
{$ENDIF}
end;

//========================================================================================
//------------------------------------ проверка предыдущего вхождения в специальные режимы
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
//------------------------------------------------------- вывод сообщения "Это не стрелка"
function NotStr(ID_Obj : SmallInt): boolean;
var
  clr : Integer;
begin
  clr := 1;
  InsNewMsg(ID_Obj,9+$4000,clr,'');  //------------------------------------- "это не стрелка"
  msg := GetSmsg(1,9,'',clr);
  ShowSmsg(9,LastX,LastY,'');
  result := true;
end;

//========================================================================================
//------------------------------------------------------ вывод сообщения "Нажата кнопка ОК
function NazataKOK(ID_Obj : SmallInt) : Boolean;
var
  color : Integer;
begin //------------------------------------ нажата ОК - прекратить формирование команды
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
//-------------------------------------------------------- Сброс вспомогательного перевода
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
//---------------------------------------------------------------------- сброс трассировки
function Trassir : Boolean;
begin
{$IFNDEF TABLO}
  if WorkMode.GoTracert then begin ResetTrace; DspCom.Com := 0; result := true; end
  else result := false;
{$ENDIF}
end;

end.
