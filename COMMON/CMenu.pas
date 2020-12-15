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
//------------------------------------------------------------------------ Коды типов меню
IDMenu_Strelka             = 1;  //---- привязка в Tablo выполняется автоматически по типу
IDMenu_SvetoforManevr      = 2;  //---- привязка в Tablo выполняется автоматически по типу
IDMenu_Uchastok            = 3;  //---- привязка в Tablo выполняется автоматически по типу
IDMenu_PutPO               = 4;  //---- привязка в Tablo выполняется автоматически по типу
IDMenu_ZamykanieStrelok    = 5;  //------------------- включение ручного замыкания стрелок
IDMenu_RazmykanieStrelok   = 6;  //------------------ отключение ручного замыкания стрелок
IDMenu_ZakrytPereezd       = 7;  //------------------  закрытие переезда (простая команда)
IDMenu_OtkrytPereezd       = 8;  //------------- открытие переезда (ответственная команда)
IDMenu_IzvesheniePereezd   = 9;  //------------------ выдача / снятие извещения на переезд
IDMenu_PoezdnoeOpoveshenie = 10; //----------- включение / отключение поездного оповещения
IDMenu_ZapretMonteram      = 11; //-----------------  включение запрета монтерам (простая)
IDMenu_VykluchenieUKSPS    = 12; //------ исключение УКСПС из зависимостей (ответственная)
IDMenu_SmenaNapravleniya   = 13; //--------------------------- смена направления (простая)
IDMenu_VspomPriem          = 14; //----------------- вспомогательный прием (ответственная)
IDMenu_VspomOtpravlenie    = 15; //----------- вспомогательное отправление (ответственная)
IDMenu_OchistkaStrelok     = 16; //------------------------------ очистка(обдувка) стрелок
IDMenu_VkluchenieGRI1      = 17; //---------------- включение выдержки ГРИ (ответственная)
IDMenu_PutManevrovyi       = 18; //------ участок извещения из тупика (откр/закр движение)
IDMenu_SvetoforSovmech     = 19; //---- привязка в Tablo выполняется автоматически по типу
IDMenu_SvetoforVhodnoy     = 20; //---- привязка в Tablo выполняется автоматически по типу
IDMenu_VydachaPSoglasiya   = 21; //-------------------- выдача поездного согласия на прием
IDMenu_ZaprosPSoglasiya    = 22; //----------- запрос поездного согласия (для отправления)
IDMenu_ManevrovayaKolonka  = 23; //------------------------------------ маневровая колонка
IDMenu_RezymPitaniyaLamp   = 24; //-------------------------- спецрежим питания ламп "ДСН"
IDMenu_RezymLampDen        = 25; //-------- включение режима питания ламп светофора "День"
IDMenu_RezymLampNoch       = 26; //-------- включение режима питания ламп светофора "Ночь"
IDMenu_RezymLampAuto       = 27; //----------- перевод режим питания ламп светофора в авто
IDMenu_OtklZvonkaUKSPS     = 28; //------------------------------- отключение звонка УКСПС
IDMenu_PAB                 = 29; //------------------------- Полуавтоматическая блокировка
IDMenu_Nadvig              = 30; //------------------------------------------------ Надвиг
IDMenu_KSN                 = 31; //------------------------------ Подключение комплекта СН
IDMenu_OPI                 = 32; //--------------------------- исключение пути из маневров
IDMenu_AutoSvetofor        = 33; //------------------------- включение режима автодействия
IDMenu_Tracert             = 34; //----------------------- трассировка по острякам стрелок
IDMenu_GroupDat            = 35; //--------------------- группа теневых датчиков на АРМ ШН
IDMenu_1bit                = 36; //------------------------- включение / отключение бита 1
IDMenu_2bit                = 37; //------------------------- включение / отключение бита 2
IDMenu_3bit                = 38; //------------------------- включение / отключение бита 3
IDMenu_4bit                = 39; //------------------------- включение / отключение бита 4
IDMenu_5bit                = 40; //------------------------- включение / отключение бита 5
IDMenu_OtklZapMont         = 41; //--- ответственное отключение запрета монтерам в 2х реле
IDMenu_VklUKG              = 42; //----------------------------- вернуть в зависимости УКГ
IDMenu_OtklUKG             = 43; //--------- исключить УКГ из зависимостей (ответственная)
IDMenu_VklOtkl_bit1        = 44; //- включить/отключить объект 1-го бита в разных объектах
IDMenu_IzvesheniePereezd1  = 45; //--- управление извещением переезда через разные объекты
IDMenu_PRZD_Zakr_Otkr      = 46; //------------ закрытие / открытие переезда одной кнопкой
IDMenu_Zapr_Razr_Mont      = 47; //------------ запрет / разрешение монтерам одной кнопкой

//--------------------------------------------- КОМАНДЫ МЕНЮ -----------------------------
//-------------------------------------------------------------------- КОМАНДЫ ДЛЯ СТРЕЛОК
CmdMenu_StrPerevodPlus         = 1;
CmdMenu_StrPerevodMinus        = 2;
CmdMenu_StrVPerevodPlus        = 3;
CmdMenu_StrVPerevodMinus       = 4;
CmdMenu_StrOtklUpravlenie      = 5;
CmdMenu_StrVklUpravlenie       = 6;
CmdMenu_StrZakrytDvizenie      = 7;
CmdMenu_StrOtkrytDvizenie      = 8;
CmdMenu_UstMaketStrelki        = 9; //------------------------ установить стрелку на макет
CmdMenu_SnatMaketStrelki      = 10; //----------------------------- снять стрелку с макета
CmdMenu_StrMPerevodPlus       = 11;
CmdMenu_StrMPerevodMinus      = 12;
CmdMenu_StrZakryt2Dvizenie    = 13;
CmdMenu_StrOtkryt2Dvizenie    = 14;
CmdMenu_StrZakrytProtDvizenie = 15;
CmdMenu_StrOtkrytProtDvizenie = 16;
//-------------------------- 17..20 ---------------------------- резерв команд для стрелок
//------------------------------------------------------------------- КОМАНДЫ ДЛЯ СИГНАЛОВ
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
//--------------------------------------------------------------------------- 52 - резерв;
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

CmdMenu_VklDSN = 64; //------------------------------------------------------ включить ДСН
CmdMenu_OtklDSN = 65; //---------------------------------------------------- отключить ДСН

CmdMenu_VklBit1_1 = 66;//---------------------------------- включить бит 1 первого объекта
CmdMenu_VklBit1_2 = 67;//---------------------------------- включить бит 1 второго объекта

//----------------------------------------------------------------- 68..70 - резерв команд
CmdMenu_ZakrytPereezd          = 71;
CmdMenu_PredvOtkrytPereezd     = 72;
CmdMenu_IspolOtkrytPereezd     = 73;
CmdMenu_DatIzvecheniePereezd   = 74;
CmdMenu_SnatIzvecheniePereezd  = 75;
CmdMenu_PredvZakrPereezd       = 76;
CmdMenu_IspolZakrPereezd       = 77;
CmdMenu_SnatIzvecheniePereezd1  = 78;
//------------------------------------------------------------------ 79,80 - резерв команд
CmdMenu_DatOpovechenie         = 81;
CmdMenu_SnatOpovechenie        = 82;
CmdMenu_DatZapretMonteram      = 83;//-- внутренний признак команды включ. запрета без КОК
CmdMenu_SnatZapretMonteram     = 84;//----- признак КОК-однотактной команды снятия запрета

CmdMenu_PredOtklBit3           = 85; //---внутренний признак предварительной отмены бита 3
CmdMenu_IspolOtklBit3          = 86; //----внутренний признак исполнительной отмены бита 3

CmdMenu_PredvOtklZapMont       = 87;//-- внутренний признак предварительной отмены запрета
CmdMenu_IspolOtklZapMont       = 88;//--- внутренний признак исполнительной отмены запрета
//--------------------------------------------------- 89..90 - резерв команд на оповещение
CmdMenu_PredvOtkluchenieUKSPS  = 91;
CmdMenu_IspolOtkluchenieUKSPS  = 92;
CmdMenu_OtklZvonkaUKSPS        = 93;
CmdMenu_OtmenaOtkluchenieUKSPS = 94;
//----------------------------------------------------------------------------------------
CmdMenu_PredvOtkluchenieUKG  = 95;
CmdMenu_IspolOtkluchenieUKG  = 96;
CmdMenu_OtmenaOtkluchenieUKG = 97;
//---------------------------------------------------------- 98..100 - резерв команд УКСПС
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
//--------------------------------------------------------------------------- 114 - резерв
CmdMenu_ZaprosPoezdSoglasiya    = 115;
CmdMenu_OtmZaprosPoezdSoglasiya = 116;
// 117..120 - резерв
CmdMenu_DatRazreshenieManevrov  = 121;
CmdMenu_OtmenaManevrov          = 122;
CmdMenu_PredvIRManevrov         = 123;
CmdMenu_IspolIRManevrov         = 124;
//----------------------------------------------- 125..130 - резерв для маневровой колонки
CmdMenu_VkluchitDen             = 131;
CmdMenu_VkluchitNoch            = 132;
CmdMenu_VkluchitAuto            = 133;
CmdMenu_OtkluchitAuto           = 134;
//
CmdMenu_Osnovnoy                = 135;
//CmdMenu_Rezerv                = 136; можно использовать для других целей
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

CmdMenu_SnatSoglasieSmenyNapr   = 162; //---------------------------------------------- АБ
CmdMenu_PutVklOPI               = 163; //-------------------------------------------- Путь
CmdMenu_PutOtklOPI              = 164; //-------------------------------------------- Путь
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
CmdMenu_RescueOTU               = 189; //---------------------- Восстановить интерфейс ОТУ
CmdMenu_VklBit1                 = 191; //---------------------- включить для объекта бит 1
CmdMenu_OtklBit1                = 192; //--------------------- отключить для объекта бит 1
CmdMenu_VklBit2                 = 193; //---------------------- включить для объекта бит 2
CmdMenu_OtklBit2                = 194; //--------------------- отключить для объекта бит 2
CmdMenu_VklBit3                 = 195; //---------------------- включить для объекта бит 3
CmdMenu_OtklBit3                = 196; //--------------------- отключить для объекта бит 3
CmdMenu_VklBit4                 = 197; //---------------------- включить для объекта бит 4
CmdMenu_OtklBit4                = 198; //--------------------- отключить для объекта бит 4
CmdMenu_VklBit5                 = 199; //---------------------- включить для объекта бит 5
CmdMenu_OtklBit5                = 200; //--------------------- отключить для объекта бит 5
//---------------------------------------------------------------- Коды кнопок-команд меню
KeyMenu_RazdeRejim          = 1001; //------------------- раздельный режим управления <F1>
KeyMenu_MarshRejim          = 1002; //------------------- маршрутный режим управления <F1>
KeyMenu_MaketStrelki        = 1003; //------------------------ установить стрелку на макет
KeyMenu_OtmenMarsh          = 1004; //------------------------------------ отмена маршрута
KeyMenu_DateTime            = 1005; //------------------------------ установить время <F2>
KeyMenu_InputOgr            = 1006; //------------------------ перейти на ввод ограничений
KeyMenu_VspPerStrel         = 1007; //-------------------- вспомогательный перевод стрелок
KeyMenu_EndTrace            = 1008; //------------------------ конец трассы маршрута <End>
KeyMenu_ClearTrace          = 1009; //---------------------------------------- <Shift+End>
KeyMenu_RejimRaboty         = 1010; //-------------------- Запрос смены режима работы АРМа
KeyMenu_ReadyResetTrace     = 1011; //- Ждем сброса набора трассы маршрута по враждебности
KeyMenu_EndTraceError       = 1012; //----- Конечная точка трассы маршрута указана неверно
KeyMenu_ReadyWarningTrace   = 1013; //--------- Ожидание подтверждения сообщений по трассе
KeyMenu_ReadyWarningEnd     = 1014; //--- Ожидание подтверждения сообщений по концу трассы
KeyMenu_BellOff             = 1015; //---------------------------- Отключение звонка <F12>
KeyMenu_UpravlenieUVK       = 1016; //-------------------------------- Меню управления УВК
KeyMenu_ReadyRestartServera = 1017; //--------- Ожидание подтверждения перезапуска сервера
KeyMenu_ReadyRestartUVK     = 1018; //------------ Ожидание подтверждения переключения УВК
KeyMenu_RezervARM           = 1019; //--------------------- Команда перевода АРМа в резерв
KeyMenu_QuerySetTrace       = 1020; //---- Запрос на установку стрелок по введенной трассе
KeyMenu_PodsvetkaStrelok    = 1021; //----------------- Кнопка подсветки положения стрелок
KeyMenu_VvodNomeraPoezda    = 1022; //------------------------- Кнопка ввода номера поезда
KeyMenu_PodsvetkaNomerov    = 1023; //-------------------- Кнопка подсветки номера поездов
KeyMenu_ReadyRescueOTU      = 1024; //Ждем подтверждения восстановления интерфейса ОТУ УВК
NetKomandy : string = 'Нет команды';

var
  IndexFR3IK : SmallInt; //--------- индекс объекта перезапуска УВК или восстановления ОТУ
  DesktopSize : TPoint; //--------------- Размер рабочего стола во время запуска программы

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
//------------------------------------------------------- функция добавления пункта в меню
function AddDspMenuItem(Caption : string; ID_Cmd, ID_Obj : Integer) : Boolean;
begin
  try
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
  except
    reportf('Ошибка [CMenu.AddDspMenuItem]');
    result := true;
  end;
end;
//========================================================================================
//-------------------------------------------------- Диспетчер функций подготовки меню ДСП
//------------------------------------------------ ID = Тип обработки, связаный с объектом
//--------------------------------------------------------------- X,Y = Координата объекта
//------------------ если возвращает true - надо запустить процедуру ожидания ввода команд
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
    SetLockHint; //------------------------------ блокировка вывода описания объекта табло
{$ENDIF}

    DspCommand.Active := false; //-- сбросить признак наличия команды, ожидающей обработки
    DspCommand.Command := 0;   //------------------------------------ сбросить код команды
    DspCommand.Obj := 0;       //--------------------------------- сбросить объект команды

    DspMenu.Ready := false;    //---------------- сбросить признак ожидания выбора команды
    DspMenu.obj := cur_obj; //----------------------- сохранить номер объекта под курсором
    DspMenu.Count := 0; //--------------------------------------- сброс числа пунктов меню
{$IFNDEF RMARC}
    ResetShortMsg;
    ShowWarning := false;
{$ENDIF}

    result := false;
//------------------------------------------------------------ Дополнить буфер команд меню
{$IFDEF RMDSP}
    msg := '';
    InsNewArmCmd(DspMenu.obj+$8000,ID); //-- добавить команду в протокол дежурного (архив)
    //-------------------- специфичные команды, разрешенные в режиме отсутствия управления
    case ID of
      KeyMenu_PodsvetkaStrelok,   //--------------------- Подсветка положения стрелок 1021
      KeyMenu_VvodNomeraPoezda, //-------------------------------- Ввод номера поезда 1022
      KeyMenu_PodsvetkaNomerov,  //------------------------- Подсветка номера поездов 1023
      KeyMenu_BellOff ://----------------------------- Сброс фиксируемого звонка 1015 <F12
      begin
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_DateTime : //----------------------------------------------------- 1005 <F2>
      begin //-------------------------------------------------------- Ввод времени РМ-ДСП
        DspCommand.Active := true; DspCommand.Command := ID; DspCommand.Obj := 0;
        if (Time > 1.0833333333333333 / 24) and (Time < 22.9166666666666666 / 24) then
        begin
          InsArcNewMsg(0,252+$4000,0); //------------------------------ "изменить время ?"
          color := 0;
          msg := GetShortMsg(1,252,'',color);
          DspMenu.WC := true;
          MakeMenu(X);
          exit;
        end else
        begin
          InsArcNewMsg(0,435+$4000,1);//-- "Коррекция времени с 22:55 до 01:05 запрещена!"
          ShowShortMsg(435,LastX,LastY,'');
          DspMenu.WC := true;
          exit;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ClearTrace : //-------------------------------------------- 1009 <Shift+End>
      begin //--------------------------- Сброс набираемого маршрута, сброс буферов команд
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
      begin //--------------------------------------------------- Смена режима работы АРМа
        if config.configKRU > 0 then exit;

        if WorkMode.CmdReady then
        begin
          InsArcNewMsg(0,251+$4000,1);// Ввод команд временно заблокирован.Канал ТУ занят.
          ShowShortMsg(251,LastX,LastY,'');
          exit;
        end;

        if WorkMode.Upravlenie then
        begin //------------------------------------------------------если АРМ управляющий
          if ((StateRU and $40) = 0) or WorkMode.BU[0] then
          begin //------------------------- если из сервера "Режим АУ" или выключен сервер
            InsArcNewMsg(0,225+$4000,7); //-------- "подтвердите перевод АРМ-ДСП в резерв"
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
        begin //------------------------------------------------------- если АРМ в резерве
          if WorkMode.OtvKom then
          begin
            InsArcNewMsg(0,224+$4000,0); //------------------------ "включить управление?"
            //---------------------------------------------------- CmdMenu_Osnovnoy = 135;
            color := 0;
            AddDspMenuItem(GetShortMsg(1,224,'',color),CmdMenu_Osnovnoy,ID_Obj);
            DspMenu.WC := true;//------------------------------------- ждать подтверждения
            MakeMenu(X);
            exit;
          end
          else
          begin //---------------------------------- не нажата кнопка ответственных команд
            InsArcNewMsg(0,276,1); //----------------------- "Действие требует нажатия ОК"
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
      begin //--------------------------------------------- Команды управления работой УВК
        if WorkMode.CmdReady then
        begin
          InsArcNewMsg(0,251+$4000,1);// Ввод команд временно заблокирован. Канал ТУ занят
          ShowShortMsg(251,LastX,LastY,'');
          exit;
        end;
        if WorkMode.OtvKom then //---------------------------------- если нажата кнопка ОК
        begin
          if config.configKRU = 0 then
          begin
            InsArcNewMsg(0,347+$4000,7);//---------- "Выдать команду перезапуска сервера?"
            color := 7;
            AddDspMenuItem(GetShortMsg(1,347,'',color),CmdMenu_RestartServera,ID_Obj);
          end;
          for i := 1 to high(ObjZav) do //-- сборка меню из объектов перезапуска всех ТУМС
          begin
            if ObjZav[i].TypeObj = 37 then //------------ если это объект контроллера ТУМС
            begin
              InsArcNewMsg(i,348+$4000,7);//- "Выдать команду переключения комплектов ИК?"
              color := 7;
              AddDspMenuItem(GetShortMsg(1,348,ObjZav[i].Liter,color),CmdMenu_RestartUVK,i);
              if ObjZav[i].ObjConstB[1] then//--------- если этот объект - контроллер МСТУ
              begin
                InsArcNewMsg(i,505+$4000,7); //---------- "Восстановить интерфейс ОТУ ИК?"
                color := 7;
                AddDspMenuItem(GetShortMsg(1,505,ObjZav[i].Liter,color),CmdMenu_RescueOTU,i);
              end;
            end;
          end;
          DspMenu.WC := true; //------------------------------------- ждать подтвверждения
          MakeMenu(X);
          exit;
        end else
        begin //------------------------------------ не нажата кнопка ответственных команд
          InsArcNewMsg(0,276,1); //------------------ "Действие требует нажатия кнопки ОК"
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
      begin //----------------------------------Ожидание подтверждения перезапуска сервера
        InsArcNewMsg(0,351+$4000,7);//--- "Подтвердите выдачу команды перезапуска сервера"
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
      begin //------------------------------------ Ожидание подтверждения переключения УВК
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := IndexFR3IK;
        IndexFR3IK := 0;
        InsArcNewMsg(DspCommand.Obj,352+$4000,7); //"подтвердите команду переключения УВК"
        color :=  7;
        msg := GetShortMsg(1,352,ObjZav[DspCommand.Obj].Liter,color);
        result := true;
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyRescueOTU : //--------------------- ожидание команды восстановления ОТУ
      begin //
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := IndexFR3IK;
        IndexFR3IK := 0;
        InsArcNewMsg(DspCommand.Obj,504+$4000,7);// подтвердите команду восстановления ОТУ
        color :=  7;
        msg := GetShortMsg(1,504,ObjZav[DspCommand.Obj].Liter,color);
        result := true;
        DspMenu.WC := true;
        MakeMenu(X);
        exit;
      end;
    end;//-------------------------------------------------------- конец первого "case ID"

    if LockDirect then exit; //--------------------- если ввод команд заблокирован - выйти

    if CheckOtvCommand(ID_Obj) then //проверить наличие активной ответственной для объекта
    begin
      OtvCommand.Active := false; 
			WorkMode.GoOtvKom := false; 
			OtvCommand.Ready := false;
      ShowShortMsg(153,LastX,LastY,''); //-- "Исполнительная противоречит предварительной"
//      SingleBeep := true;
      InsArcNewMsg(0,153,1);
      exit;
    end;
{$ENDIF}

    //===================================== Сформировать меню/подтверждение выбора команды
    case ID of
{$IFDEF RMDSP}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_RazdeRejim : //-------------------------------------------------------- 1001
      begin //------------------------------------------- Переключение режима "Раздельный"
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        InsArcNewMsg(DspCommand.Obj,95+$4000,7);//- установлен раздельный режим управления
        color := 7;
        msg := GetShortMsg(1,95,'',color);
        result := false;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_MarshRejim ://----------------------------- Переключение режима "Маршрутный"
      begin
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        InsArcNewMsg(DspCommand.Obj,96+$4000,2); // установлен маршрутный режим управления
        color :=  2;
        msg := GetShortMsg(1,96,'',color);
        result := false;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_MaketStrelki : //----------------------- Включение/выключение макета стрелок
      begin
        if WorkMode.OtvKom then
        begin //------------------------ если  нажата ОК - прекратить формирование команды
          ResetCommands;
          InsArcNewMsg(0,283,1); //------------------ "нажата кнопка ответственных команд"
          ShowShortMsg(283,LastX,LastY,'');
          color := 1;
          msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,color);
          exit;
        end;

        ResetTrace; //-------------------------------------------- Сбросить набор маршрута
        WorkMode.MarhOtm := false;
        WorkMode.VspStr := false;
        WorkMode.InpOgr := false;

        if maket_strelki_index > 0 then //-------------------- если на макете есть стрелка
        begin //------------------------------------------- запрос снятия стрелки с макета
          color := 7;
          msg := GetShortMsg(1,172, maket_strelki_name,color);//"снять с макета стрелку ?"
          DspCommand.Command := CmdMenu_SnatMaketStrelki;
          DspCommand.Obj := maket_strelki_index;
          DspMenu.WC := true;
          InsArcNewMsg(DspCommand.Obj,172+$4000,7);
        end else //-------------------------------------------- если на макете стрелки нет
        if WorkMode.GoMaketSt then  //--------------- если идет установка стрелки на макет
        begin //--------------------- Снять признак выбора стрелки для постановки на макет
          WorkMode.GoMaketSt := false;
          ResetShortMsg;
          exit;
        end else //------------------------------- если пока нет режима установки на макет
        begin //----------------------------------- Выбрать стрелку для установки на макет
          for i := 1 to High(ObjZav) do //------------------------ пройти по всем объектам
          begin  //---------------------- и выполнить проверку подключения макетного шнура
            if(ObjZav[i].RU = config.ru)and(ObjZav[i].TypeObj = 20) then // вышли на макет
            begin
              if ObjZav[i].bParam[2] then //--------------------------------- если есть КМ
              begin //------------------------------------------- Запросить номера стрелки
                WorkMode.GoMaketSt := true;
                InsArcNewMsg(0,8+$4000,7); //---- "Укажите стрелку для установки на макет"
                ShowShortMsg(8,LastX,LastY,'');
              end else //----------------------------------------------------- если нет КМ
              begin //----------------------------------------- макетный шнур не подключен
                ResetShortMsg;
                InsArcNewMsg(0,90,1); //-------------- "Не подключен шнур макета стрелок!"
                ShowShortMsg(90,LastX,LastY,'');
                color := 1;
                AddFixMessage(GetShortMsg(1,90,'',color),4,2);
              end;
              exit; //--------- выход после обнаружения комплекта макета и выбора действия
            end;
          end;
          exit; //- выход после прохода по всем объектам при не найденном комплекте макета
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_OtmenMarsh, //------------------ Включение/выключение режима отмены маршрута
      KeyMenu_InputOgr ,//------------------ Включение/выключение режима ввода ограничений
      KeyMenu_VspPerStrel: //Включение/выключение режима вспомогательного перевода стрелок
      begin
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_EndTrace :
      begin //----------------------------------------------- Конец набора маршрута = 1008
        DspCommand.Active := true;
        DspCommand.Command := ID;
        DspCommand.Obj := 0;
        if MarhTracert[1].WarCount > 0 then  //---- если есть предупреждения при установке
        begin
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount];//показать предупреждение
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1],1);
        end
        else   exit; //--------------------------------------------------- иначе закончить
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_EndTraceError :
      begin //--------- Выдать предупреждение, что конечная точка маршрута указана неверно
        DspCommand.Active := true;
        DspCommand.Command := KeyMenu_ClearTrace;
        DspCommand.Obj := 0;
        InsArcNewMsg(0,87,1);
        ShowShortMsg(87,LastX,LastY,'');
        exit;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Ready : //------------------------------------------------------------ 1102
      begin //--------------------------------- Запросить подтверждение установки маршрута
        DspMenu.obj := cur_obj;
        case MarhTracert[1].Rod of //---------------------- переключатель по роду маршрута
          MarshM :    //-------------------------------------------------- если маневровый
          begin
            InsArcNewMsg(MarhTracert[1].ObjStart,6+$4000,7);//Установить маневровый марш.?
            color := 7;
            TXT := ObjZav[MarhTracert[1].ObjStart].Liter;
            msg := GetShortMsg(1,6, TXT + MarhTracert[1].TailMsg,color);
            DspCommand.Active := true;
            DspCommand.Command := CmdMarsh_Manevr;
            DspCommand.Obj := ID_Obj;
          end;
          MarshP ://-------------------------------------------------------- если поездной
          begin
            InsArcNewMsg(MarhTracert[1].ObjStart,7+$4000,2);//"Установить поездной маршрут?"
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
      begin //------------------------------------- Запрос открытия раздельным маневрового
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
      begin //--------------------------------------- Запрос открытия раздельным поездного
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
      begin //-------------------------- Вывод сообщений перед повторным открытием сигнала
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorMarh  :
      begin //------------------------ Вывод сообщений перед повторной установкой маршрута
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_PovtorOtkryt  :
      begin //------ Вывод сообщений перед повторным открытием сигнала в раздельном режиме
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdMarsh_Razdel :
      begin //----- Вывод сообщений перед открытием сигнала в раздельном режиме управления
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount] + '. Продолжать?';
          DspCommand.Command := ID;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
          dec(MarhTracert[1].WarCount);
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_QuerySetTrace :
      begin //------------- Запрос на выдачу команды установки стрелок по введенной трассе
        SingleBeep2 := true;
        TimeLockCmdDsp := LastTime;
        LockCommandDsp := true; 
				ShowWarning := true;
        InsArcNewMsg(MarhTracert[1].ObjStart,442+$4000,7);//"Установить стрелки по трассе ?"
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
      begin //----------------- Ожидается сброс набираемой трассы маршрута по враждебности
        ShowWarning := true;
        if MarhTracert[1].GonkaStrel and (MarhTracert[1].GonkaList > 0) then
        begin
          InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]+$5000,7);
          msg := MarhTracert[1].Msg[1] + '. Возможен перевод стрелок. Продолжать?';
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
      KeyMenu_ReadyWarningTrace : //----------- Ожидание подтверждения сообщений по трассе
      begin //----------------------- Ожидается подтверждение сообщения по трассе маршрута
        if MarhTracert[1].WarCount > 0 then //------- если есть предупреждения или запреты
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount]+ '. Продолжать?';
          DspMenu.WC := true;
          DspCommand.Command := CmdMarsh_Tracert;
          DspCommand.Active := true;
          DspCommand.Obj := ID_Obj;
          DspMenu.WC := true;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      KeyMenu_ReadyWarningEnd :
      begin //----------------- Ожидается подтверждение сообщения по концу трассы маршрута
        if MarhTracert[1].WarCount > 0 then
        begin
          ShowWarning := true;
          InsArcNewMsg(MarhTracert[1].WarObject[1],MarhTracert[1].WarIndex[1]+$5000,7);
          msg := MarhTracert[1].Warning[MarhTracert[1].WarCount]+ '. Продолжать?';
          DspMenu.WC := true;
          DspCommand.Command := KeyMenu_EndTrace;
          DspCommand.Active := true;
          DspCommand.Obj := ID_Obj;
        end;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyMPerevodPlus :
      begin //----------------------------- Подтверждение перевода макетной стрелки в плюс
        //------------------------------------------ "стрелка на макете.Перевести в плюс?"
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,101+$4000,2);
        color := 2;
        msg := GetShortMsg(1,101,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyMPerevodPlus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyMPerevodMinus :
      begin //---------------------------- Подтверждение перевода макетной стрелки в минус
        //----------------------------------------- "стрелка на макете.Перевести в минус?"
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,102+$4000,7);
        color := 7;
        msg:=GetShortMsg(1,102,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyMPerevodMinus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_AskPerevod :
      begin //------------------------------------------------------------ перевод стрелки
        if ObjZav[ID_Obj].bParam[1] then
        begin //------------------------------------------------------------------ в минус
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
        end else //---------------------------------------------------------------- в плюс
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
        begin //---------------------------------------------------------------- по выбору
          if ObjZav[ID_Obj].bParam[22] or //------------------------ если занята из СП или
          (not ObjZav[ID_Obj].bParam[22] and //--------------------- не заняти из СП и ...
          not ObjZav[ID_Obj].bParam[23] and //--------- не трассируется как охранная и ...
          ObjZav[ID_Obj].bParam[20]) //----------------------------------- выдержка от МСП
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
      begin //--------------------------------- Ожидание подтверждения передачи на маневры
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
      begin //-------------------------------------- Подтверждение перевода стрелки в плюс
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,97+$4000,2);
        color := 2;
        msg := GetShortMsg(1,97,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyPerevodPlus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyPerevodMinus :
      begin //------------------------------------- Подтверждение перевода стрелки в минус
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,98+$4000,7);
        color := 7;
        msg := GetShortMsg(1,98,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyPerevodMinus;
        DspCommand.Obj := ID_Obj; //---------------------- индекс объекта для команды в OZ
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodPlus :
      begin //--------------------- Подтверждение вспомогательного перевода стрелки в плюс
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,99+$4000,2);
        color := 2;
        msg := GetShortMsg(1,99,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyVPerevodPlus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      CmdStr_ReadyVPerevodMinus :
      begin //-------------------- Подтверждение вспомогательного перевода стрелки в минус
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,100+$4000,7);
        color := 7;
        msg := GetShortMsg(1,100,ObjZav[ObjZav[ID_Obj].BaseObject].Liter,color);
        DspMenu.WC := true;
        DspCommand.Command := CmdStr_ReadyVPerevodMinus;
        DspCommand.Obj := ID_Obj;
      end;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_Tracert :
      begin //------------------------ IDMenu_Tracert = 34 трассировка по острякам стрелок
        DspCommand.Active  := true;
        DspCommand.Command := CmdMarsh_Tracert; // вторичная команда CmdMarsh_Tracert=1101
        DspCommand.Obj := ID_Obj;
        exit;
      end;
 {$ENDIF}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//******************************************************************************** Стрелка
      IDMenu_Strelka :
      result := CreateDspMenu_Strelka(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//***************************************** Светофоры (маневровый, совмещенный и входной)
      IDMenu_SvetoforManevr,
      IDMenu_SvetoforSovmech,
      IDMenu_SvetoforVhodnoy :
      result := CreateDspMenuSvetofor(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//**************************************************** управление автодействием светофоров
      IDMenu_AutoSvetofor :
      result := CreateDspMenuAvtoSvetofor(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//*********************************************** подготовка кнопочной команды на 1-ый бит
      IDMenu_1bit :
      result := CreateDspMenu_1bit(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------- подготовка кнопочной команды на 2-ой бит
      IDMenu_2bit :
      result := CreateDspMenu_2bit(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------- подготовка кнопочной команды в зависимости от состояния бита
      IDMenu_VklOtkl_bit1 :
      result := CreateDspMenu_VklOtkl1bit(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------- подготовка команды закрытия или ответственного открытия переезда
      IDMenu_PRZD_Zakr_Otkr :
      result := CreateDspMenu_PRZD_Zakr_Otkr(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------- подготовка команды запрета или ответственного разрешения работы монтерам
      IDMenu_Zapr_Razr_Mont:
      result := CreateDspMenu_Zapr_Razr_Mont(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//------------------------- Подготовка меню для выдачи поездного согласия на соседний пост
      IDMenu_VydachaPSoglasiya :
      result := CreateDspMenuVydachaPSoglasiya(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_Nadvig : //----------------------Подготовка меню для выдачи "Надвиг на горку"
      result := CreateDspMenuNadvig(ID,X,Y);

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_Uchastok ://Подготовка меню управления объектом "Участок СП или бесстрелочный"
      result := CreateDspMenuUchastok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PutPO : //------------------------ Подготовка меню управления объектом "Путь"
      result := CreateDspMenuPutPO(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OPI ://Подготовка меню управления объектом "ОПИ"(исключение пути из маневров)
      result := CreateDspMenuOPI(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZaprosPSoglasiya :  //--------- Запрос поездного отправления на соседний пост
      result := CreateDspMenuPSoglasiya(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_SmenaNapravleniya : //------------------------------------------- Увязка с АБ
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
      IDMenu_KSN : //----------------------------- Подключение комплекта смены направления
      result := CreateDspMenu_KSN(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PAB : //------------------------------------------ Управление полуавтоматикой
      result := CreateDspMenu_PAB(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ManevrovayaKolonka : //------------- управление объектом "Маневровая колонка"
      result := CreateDspMenu_ManevrovayaKolonka(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZamykanieStrelok :  //------------------------------------- Замыкание стрелок
      result := CreateDspMenu_ZamykanieStrelok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RazmykanieStrelok : //------------------------------------ Размыкание стрелок
      result := CreateDspMenu_RazmykanieStrelok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZakrytPereezd :  //------------------------------------------ Закрыть переезд
      result := CreateDspMenu_ZakrytPereezd(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtkrytPereezd : //------------------------------------------- Открыть переезд
      result := CreateDspMenu_OtkrytPereezd(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_IzvesheniePereezd1, 
      IDMenu_IzvesheniePereezd : //---------------------------------- Извещение на переезд
      result := CreateDspMenu_IzvesheniePereezd(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PoezdnoeOpoveshenie ://----- создание меню для  объекта "Поездное оповещение"
      result := CreateDspMenu_PoezdnoeOpoveshenie(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_ZapretMonteram ://--- создание меню для управления объектом "Запрет монтерам"
      result := CreateDspMenu_ZapretMonteram(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtklZapMont:
      result := CreateDspMenu_Otkl_ZapretMonteram(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VykluchenieUKSPS : //--------------------- создание меню для управления УКСПС
      result := CreateDspMenu_VykluchenieUKSPS(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtklUKG ://--------------------------------- создание меню для отключения УКГ
      result := CreateDspMenu_OtklUKG(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VklUKG :
      result := CreateDspMenu_VklUKG(ID,X,Y);
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VspomPriem :
      result := CreateDspMenu_VspomPriem(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VspomOtpravlenie : // создание меню для объекта "Вспомогательное отправление"
      result := CreateDspMenu_VspomOtpravlenie(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OchistkaStrelok : //------------- создание меню для объекта "Очистка стрелок"
      result := CreateDspMenu_OchistkaStrelok(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_VkluchenieGRI1 : //-------------------------- Включение выдержки времени ГРИ1
      result := CreateDspMenu_VkluchenieGRI1(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_PutManevrovyi : //---------- Участок извещения из тупика, Путь без ограждения
      result := CreateDspMenu_PutManevrovyi(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymPitaniyaLamp : //------------------------- Питание ламп светофоров (ДСН)
      result := CreateDspMenu_RezymPitaniyaLamp(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymLampDen : //---------------------------------- Включение дневного режима
      result := CreateDspMenu_RezymLampDen(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymLampNoch ://----------------------------------- Включение ночного режима
      result := CreateDspMenu_RezymLampNoch(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_RezymLampAuto ://--------------------------- Включение автоматического режима
      result := CreateDspMenu_RezymLampAuto(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      IDMenu_OtklZvonkaUKSPS : //--------------------------------- Выключение звонка УКСПС
      result := CreateDspMenu_OtklZvonkaUKSPS(ID,X,Y);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{$IFNDEF RMDSP}
      IDMenu_GroupDat :
      begin//------------------------------------------- Группа теневых датчиков на АРМ-ШН
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
//mkmnu : //----------------------------------------------------------- формирование меню
    if DspMenu.Count > 0 then //-------------------------------- если есть что-то для меню
    begin
      TabloMain.PopupMenuCmd.Items.Clear; //-------------------------- очистить меню табло
      for i := 1 to DspMenu.Count  do
      TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//----- взять из DspMenu
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
    begin //-------------------------- Вывести подсказку перед выполнением простой команды
      j := x div configRU[config.ru].MonSize.X + 1; //------------------ Найти номер табло
      for i := 1 to Length(shortMsg) do
      begin
        if i = j then //------- если это то табло, которое соответствует району управления
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
    reportf('Ошибка [CMenu.CreateDspMenu]');
    {$ENDIF}
    result := true;
  end;
end;

{$IFDEF RMDSP}
//========================================================================================
//------------ Проверка условий допустимости возбуждения начального признака для светофора
function CheckStartTrace(Index : SmallInt) : string;
var
  color : Integer;
begin
  try
    result := '';
    case ObjZav[Index].TypeObj of
      33 :
      begin //--------------------------------------------- если это дискретный датчик FR3
        if ObjZav[Index].ObjConstB[1] then //--------------------- если инверсия состояния
        begin
          if ObjZav[Index].bParam[1]  //----------------------------- если датчик = .True.
          then
            result := MsgList[ObjZav[Index].ObjConstI[3]]; //------ сообщить об отключении
        end else
        begin //--------------------------------------------------------- прямое состояние
          if not ObjZav[Index].bParam[1]  //------------------ состояние датчика = .False.
          then result := MsgList[ObjZav[Index].ObjConstI[2]]; //---- сообщение о включении
        end;
      end;

      35 :
      begin //-------- Доступ к внутренним свойствам контролируемого объекта (зависимости)
        if ObjZav[Index].ObjConstB[1] then
        begin //-------------------------------------------------- если инверсия состояния
          if ObjZav[Index].bParam[1]
          then result := MsgList[ObjZav[Index].ObjConstI[2]]; //------- сообщить об отказе
        end else
        begin //--------------------------------------------------------- прямое состояние
          if not ObjZav[Index].bParam[1]
          then result := MsgList[ObjZav[Index].ObjConstI[2]]; //------- сообщить об отказе
        end;
      end;

      47 :
      begin //----------------------------------- Проверка включения автодействия сигналов
        color := 1;
        if ObjZav[Index].bParam[1]   //------------------ если есть включение автодействия
        then result := GetShortMsg(1, 431, ObjZav[Index].Liter,color);//включено автодейс.
      end;
    end;
  except
    reportf('Ошибка [CMenu.CheckStartTrace]');
    result := '#';
  end;
end;

//========================================================================================
//------------ Проверка условий допустимости возбуждения начального признака для светофора
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

//========================================================================================
//----- Проверить условия перезамыкания поездного маршрута маневровым для протяжки состава
function CheckProtag(Index : SmallInt) : Boolean;
var
  o,put : integer;
begin
  try
    result := false;
    o := ObjZav[Index].ObjConstI[17];
    if o < 1 then exit;

    if ObjZav[o].TypeObj <> 42 then exit; //-------------------- нет объекта перезамыкания
    put :=  ObjZav[o].ObjConstI[7];

    if ObjZav[ObjZav[index].BaseObject].bParam[2]
    then exit; //--------------------------- перекрывная секция не замкнута - нет протяжки

    if ObjZav[o].bParam[1] and //--------------------------- поездной маршрут прием  и ...
    ObjZav[o].bParam[2] and //----------------------------------- разрешено перезамыкание
    not (ObjZav[put].bParam[1] or ObjZav[put].bParam[16]) then //--- занят путь прибытием  
    begin
      if ObjZav[Index].ObjConstB[17] then
      begin //------------------------------------------------- с возбуждением признака НМ
        DspCommand.Command := CmdMenu_OtkrytManevrovym;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
      end else
      begin //------------------------------------------------ без возбуждения признака НМ
        DspCommand.Command := CmdMenu_OtkrytProtjag;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
      end;
      result := true;
    end;
  except
    reportf('Ошибка в [CMenu.CheckProtag]');
    result := false;
  end;
end;

//========================================================================================
//----------------------------------------- проверка завершения установки стрелки на макет
function CheckMaket : Boolean;
var
  i : integer;
begin
  try
    result := false;
    for i := 1 to High(ObjZav) do //------------------------------ проход по всем объектам
    begin
      if (ObjZav[i].RU = config.ru) and //-------------------------- если свой район и ...
      (ObjZav[i].TypeObj = 20) then //------------------------- это объект контроля макета
      begin
        if ObjZav[i].bParam[2] then //--------------- Проверка подключения макетного шнура
        result := (maket_strelki_index < 1);
        exit;
      end;
    end;
  except
    reportf('Ошибка при проверке подключения шнура макета стрелки [CMenu.CheckMaket]');
    result := false;
  end;
end;
{$ENDIF}

//========================================================================================
//--------------------------------------- функция установки и отмены блокировок управления
function LockDirect : Boolean;
begin
  try
     result := true;
{$IFDEF RMDSP}
    if WorkMode.LockCmd or not WorkMode.Upravlenie then
    begin
      InsArcNewMsg(0,76,1); //------------------------------------- "Управление отключено"
      ShowShortMsg(76,LastX,LastY,'');
      exit;
    end;

    if (ID_Obj > 0) and (ID_Obj < 4096) and not WorkMode.OU[ObjZav[ID_Obj].Group] then
    begin
      InsArcNewMsg(0,76,1);  //------------------------------------ "Управление отключено"
      ShowShortMsg(76,LastX,LastY,'');
      exit;
    end;

    if WorkMode.CmdReady then
    begin
      InsArcNewMsg(0,251,1); //-------- "Ввод команд временно заблокирован.Канал ТУ занят"
      ShowShortMsg(251,LastX,LastY,'');
     end
    else result := false;
{$ENDIF}
  except
    {$IFNDEF RMARC}
    reportf('Ошибка [CMenu.CreateDspMenu.LockDirect]');
    {$ENDIF}
    result := true;
  end;
end;

//========================================================================================
//----------------------------------- Функция подготовки меню ДСП при управлении сигналами
//ID  идентификатор (IDMenu_SvetoforManevr,IDMenu_SvetoforSovmech, IDMenu_SvetoforVhodnoy)
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
    InsArcNewMsg(ID_Obj,431+$4000,1);//---------------------------" включено автодействие"
    WorkMode.InpOgr := false;  //---------------------------- прекратить работу с сигналом
    ShowShortMsg(431, LastX, LastY, '');
    exit;
  end;

{$IFNDEF RMDSP}
  if ObjZav[ID_Obj].bParam[23] or //-------------- если было воспринято перекрытие или ...
  ((ObjZav[ID_Obj].bParam[5] or //------------------------- есть ненорма огневушки или ...
  ObjZav[ID_Obj].bParam[15] or //--------------------------------- есть ненорма Со или ...
  ObjZav[ID_Obj].bParam[17] or //------------------------------- есть авария шкафа или ...
  ObjZav[ID_Obj].bParam[24] or //-------------------------------- есть ненорма зСо или ...
  ObjZav[ID_Obj].bParam[25]) and //-------------------------------- есть ненорма ВНП и ...
  not ObjZav[ID_Obj].bParam[20] and //-------- нет признака восприятия неисправности и ...
  not WorkMode.GoTracert) then //------------------------------ нет выполнения трассировки
  begin //------------------------------------------------ снять мигание при неисправности
    ObjZav[ID_Obj].bParam[23] := false; //-------------------- снять восприятие перекрытия
    ObjZav[ID_Obj].bParam[20] := true; //------------------- установить восприятие ненормы
  end;

  ID_ViewObj := ID_Obj;  //------------ номнер объекта для формирования описания состояния
  result := true;
  exit;
{$ELSE}

  ObjZav[ID_Obj].bParam[34]:=false; //-------- снять требование повтора установки маршрута

  //:::::::::::::::::::::::::::::::::::::::::::::::::::::: ВСПОМОГАТЕЛЬНЫЙ ПЕРЕВОД :::::::
  if VspPerevod.Active then //------- если активна структура для вспомогательного перевода
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1); //--- "отменено ожидание нажатия кнопки всп. перевода"
    VspPerevod.Active := false; //--- снять активность структуры вспомогательного перевода
    WorkMode.VspStr := false;   //------ снять активность режима вспомогательного перевода
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end;

  //::::::::::::: режим работы "МАКЕТ ИЛИ ВСПОМОГАТЕЛЬНЫЙ ПЕРЕВОД" :::::::::::::::::::::::
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1); //----------------------------------- "это не стрелка"
    color := 1;
    msg := GetShortMsg(1,9,'',color);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end;

  if WorkMode.OtvKom then //:::::::::::::::::::::: ЕСЛИ ОТВЕТСТВЕННЫЕ КОМАНДЫ ::::::::::::
  begin //------------------- нажата ОК - нормализовать признаки трассировки для светофора
    InsArcNewMsg(ID_Obj,311+$4000,7);  //------------------------------- "Нормализовать ?"
    color := 7;
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,color);
    DspCommand.Command := CmdMarsh_ResetTraceParams; //-------- команда снятия трассировки
    DspCommand.Obj := ID_Obj;
  end else

  begin //::::::::::::::::::::::::::::::::::::: ОБЫЧНЫЙ РЕЖИМ ::::::::::::::::::::::::::::
    if ObjZav[ID_Obj].bParam[23] and //----------------- если есть восприятие перекрытия и
    not WorkMode.GoTracert then  //---------------------------- не выполняется трассировка
    begin
      ObjZav[ID_Obj].bParam[23] := false;//--------- восприятие перекрытия светофора снять
      exit;
    end;

    if ObjZav[ID_Obj].bParam[18] then //----------------------------------- если РМ или МИ
    begin
      InsArcNewMsg(ID_Obj,232+$4000,1);//------------------ "сигнал на местном управлении"
      WorkMode.GoMaketSt := false; //----------------- прекратить режим установки на макет
      ShowShortMsg(232,LastX,LastY,ObjZav[ID_Obj].Liter);
      exit;
    end;

    if WorkMode.InpOgr then //------------------------------------------- ввод ограничений
    begin
      if ObjZav[ID_Obj].bParam[33] then //--- если автодействие включено для этого сигнала
      begin
        InsArcNewMsg(ID_Obj,431+$4000,1);//-----------------------" включено автодействие"
        WorkMode.InpOgr := false;  //------------------ прекратить режим ввода ограничений
        ShowShortMsg(431, LastX, LastY, '');
        exit;
      end;

      if ObjZav[ID_Obj].bParam[14] then //-------------- если программное замыкание в АРМе
      begin
        InsArcNewMsg(ID_Obj,238+$4000,1);//-------------------- "светофор в трассе маршрута"
        WorkMode.InpOgr := false;  //------------------ прекратить режим ввода ограничений
        ShowShortMsg(238, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end;

      //------------------------------------------- далее, если нет программного замыкания


      //-------------------------------------- если блокировки не совпали в АРМе и сервере
      if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
      begin
        InsArcNewMsg(ID_Obj,179+$4000,7);//------------------------ "заблокировать светофор"
        InsArcNewMsg(ID_Obj,180+$4000,7);//----------------------- "разблокировать светофор"
        color := 7;
        AddDspMenuItem(GetShortMsg(1,179, '',color),CmdMenu_BlokirovkaSvet,ID_Obj);
        AddDspMenuItem(GetShortMsg(1,180, '',color),CmdMenu_DeblokirovkaSvet,ID_Obj);
      end else
      if ObjZav[ID_Obj].bParam[13] then //----------------------- если сигнал заблокирован
      begin
        color := 7;
        InsArcNewMsg(ID_Obj,180+$4000,7); //----------------- "разблокировать светофор $?"
        msg := GetShortMsg(1,180, ObjZav[ID_Obj].Liter,color);
        DspCommand.Command := CmdMenu_DeblokirovkaSvet;
        DspCommand.Obj := ID_Obj;
      end else//------------------------------------------------ если сигнал не блокирован
      begin
        InsArcNewMsg(ID_Obj,179+$4000,7); //------------------ "заблокировать светофор $?"
        color := 7;
        msg := GetShortMsg(1,179, ObjZav[ID_Obj].Liter,color);
        DspCommand.Command := CmdMenu_BlokirovkaSvet;
        DspCommand.Obj := ID_Obj;
      end;
    end else //------------------------------------------- далее, если не ввод ограничений

    if WorkMode.MarhOtm then //-------------------------------------- если отмена маршрута
    begin
      if ObjZav[ID_Obj].bParam[33] then
      begin //----------------------------------------------- если сигнал на автодействии
        color := 1;
        msg := GetShortMsg(1,431,ObjZav[ID_Obj].Liter,color);
        if msg <> '' then //------------------------------ если есть текст сообщений ...
        begin
          PutShortMsg(1,LastX,LastY,msg);  //--- выдать текст сообщения на экран и выйти
          exit;
        end;
      end;

      if ObjZav[ID_Obj].ObjConstB[3] and  //------------- если есть начало маневровых и...
      (ObjZav[ID_Obj].bParam[6] or //--------------------------- есть НМ из сервера или...
      ObjZav[ID_Obj].bParam[7]) or //------------------------- есть МПР трассировки или...
      (ObjZav[ID_Obj].bParam[1] or //------------------------------------ есть МС1 или ...
      ObjZav[ID_Obj].bParam[2]) then //------------------------------------------ есть МС2
      begin
        if ObjZav[ID_Obj].bParam[2] then //--------------------------------- если есть МС2
        begin //-------- если сигнал открыт - проверить условие маневровой отмены маршрута
          msg := GetSoglOtmeny(ObjZav[ID_Obj].ObjConstI[19]); //- получить текст сообщения
          if msg <> '' then //------------------------------ если есть текст сообщений ...
          begin
            PutShortMsg(1,LastX,LastY,msg);  //--- выдать текст сообщения на экран и выйти
            exit;
          end;
        end;

        InsArcNewMsg(ID_Obj,175+$4000,7); //-------------- "отменить маневровый маршрут ?"
        msg := '';
        case GetIzvestitel(ID_Obj,MarshM) of
          1 :
          begin
            color := 1;
            msg := GetShortMsg(1,329, '',color) + ' '; //"поезд на предмаршрутном участке"
            InsArcNewMsg(ID_Obj,329+$5000,1);
          end;

          2 :
          begin
            color := 1;
            msg := GetShortMsg(1,330, '',color) + ' '; //------------- "поезд на маршруте"
            InsArcNewMsg(ID_Obj,330+$5000,1);
          end;

          3 :
          begin
            color := 1;
            msg := GetShortMsg(1,331, '',color) + ' '; //-- "поезд на участке приближения"
            InsArcNewMsg(ID_Obj,331+$5000,1);
          end;
        end;
        color := 7;
        msg:=msg+GetShortMsg(1,175,'от '+ObjZav[ID_Obj].Liter,color);//отменить маневровый
        DspCommand.Command := CmdMenu_OtmenaManevrovogo;
        DspCommand.Obj := ID_Obj;
      end else

      if ObjZav[ID_Obj].ObjConstB[2] and//сигнал может иметь начало поездных маршрутов и..
      (ObjZav[ID_Obj].bParam[8] or //-------------- есть признак начала из сервера или ...
      ObjZav[ID_Obj].bParam[9]) or //--- есть признак поездной трассировки сигнала или ...
      (ObjZav[ID_Obj].bParam[3] or //--------------------------- включен сигнал С1 или ...
      ObjZav[ID_Obj].bParam[4]) then  //-------------------------------- включен сигнал С2
      begin //---------------------------------------------------------- отменить поездной
        if ObjZav[ID_Obj].bParam[4] then //------------------------------- если включен С2
        begin //-------------- если сигнал открыт - проверить допустимость отмены маршрута
          msg := GetSoglOtmeny(ObjZav[ID_Obj].ObjConstI[16]);// проверить условие П отмены
          if msg <> '' then
          begin PutShortMsg(1,LastX,LastY,msg); exit; end; //---- вывод сообщения на экран
        end;
        InsArcNewMsg(ID_Obj,176+$4000,7);//----------------- "отменить поездной маршрут ?"
        msg := '';

        case GetIzvestitel(ID_Obj,MarshP) of //------------ получить состояние известителя
          1 :
          begin
            color := 1;
            msg := GetShortMsg(1,329, '',color) + ' '; // Поезд на предмаршрутном участке!
            InsArcNewMsg(ID_Obj,329+$5000,1);
          end;

          2 :
          begin
            color := 1;
            msg := GetShortMsg(1,330, '',color) + ' '; //------------------ Поезд на маршруте!
            InsArcNewMsg(ID_Obj,330+$5000,1);
          end;

          3 :
          begin
            color := 1;
            msg := GetShortMsg(1,331, '',color) + ' '; //------- Поезд на участке приближения!
            InsArcNewMsg(ID_Obj,331+$5000,1);
          end;
        end;

        color := 7;
        msg := msg+GetShortMsg(1,176,'от '+ObjZav[ID_Obj].Liter,color);//Отм.поезд. маршрут $?
        DspCommand.Command := CmdMenu_OtmenaPoezdnogo; //готовим команду отмены П маршрута
        DspCommand.Obj := ID_Obj;
      end else

      //------------------------------------------------------------------- Только для РПЦ
      if ObjZav[ID_Obj].BaseObject <>0 then //--------------- если есть перекрывная секция
      if  not ObjZav[ID_Obj].bParam[14] and //---- нет программного замыкания сигнала и...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] then//нет программного замыкания СП
      begin //------------------------------------- выбрать категорию отменяемого маршрута
        if ObjZav[ID_Obj].ObjConstB[2] and //-------- у сигнала есть начало поездных и ...
        ObjZav[ID_Obj].ObjConstB[3] then //-------------- у сигнала есть начало маневровых
        begin //---------------- выбрать категорию отмены (аварийно), так как неясно какой
          InsArcNewMsg(ID_Obj,175+$4000,7); //-------------- отменить маневровый маршрут ?
          InsArcNewMsg(ID_Obj,176+$4000,7); //---------------- отменить поездной маршрут ?

          color := 1;
          AddDspMenuItem('Нет начала маршрута! '+ GetShortMsg(1,175, '',color),
          CmdMenu_OtmenaManevrovogo,ID_Obj);

          color := 1;
          AddDspMenuItem('Нет начала маршрута! '+ GetShortMsg(1,176, '',color),
          CmdMenu_OtmenaPoezdnogo,ID_Obj);
        end else

        if ObjZav[ID_Obj].ObjConstB[3] then // у сигнала возможно только маневровое начало
        begin //------------------------------------------- отменить маневровый (аварийно)
          InsArcNewMsg(ID_Obj,175+$4000,7);
          color := 7;
          TXT := ObjZav[ID_Obj].Liter;
          msg := 'Нет начала маршрута! '+ GetShortMsg(1,175,'от ' + TXT,color);
          DspCommand.Command := CmdMenu_OtmenaManevrovogo;
          DspCommand.Obj := ID_Obj;
        end else
        if ObjZav[ID_Obj].ObjConstB[2] then //--------------------- только поездное начало
        begin //--------------------------------------------- отменить поездной (аварийно)
          InsArcNewMsg(ID_Obj,176+$4000,1);
          color := 1;
          TXT := ObjZav[ID_Obj].Liter;
          msg := 'Нет начала маршрута! '+ GetShortMsg(1,176,'от ' + TXT,color);
          DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
          DspCommand.Obj := ID_Obj;
        end
        else  exit; //------------------------------------------ нет никаких начал - выход
      end
      else  exit; //------------------------------------ есть какое-либо замыкание - выход
      //---------------------------------------------------------- конец фрагмента для РПЦ
    end else //--------------------------------------------- конец работы с режимом отмены

    if ObjZav[ID_Obj].bParam[23] or //-------------- воспринято перекрытие сигнала ИЛИ ...
    ((ObjZav[ID_Obj].bParam[5] or //----------------------------- ненорма огневого или ...
    ObjZav[ID_Obj].bParam[15] or //------------------------------------ ненорма Со или ...
    ObjZav[ID_Obj].bParam[17] or //---------------------------------- авария шкафа или ...
    ObjZav[ID_Obj].bParam[24] or //----------------------------------- ненорма зСо или ...
    ObjZav[ID_Obj].bParam[25] or //----------------------------------- ненорма ВНП или ...
    ObjZav[ID_Obj].bParam[26]) and //------------------------------------ ненорма Кз И ...
    not ObjZav[ID_Obj].bParam[20] and //--------------- нет восприятия неисправности и ...
    not WorkMode.GoTracert) then   //-----------------------не выполняется трассировка ...
    begin //------------------------------------------ снять мигание при неисправности ...
      ObjZav[ID_Obj].bParam[23] := false; //----------------- убрать восприятие перекрытия
      ObjZav[ID_Obj].bParam[20] := true; //----------- установить восприятие неисправности
      exit;
    end else

    if not ObjZav[ID_Obj].bParam[31] then //-------------------------- если нет активности
    begin //-------------------------------------------------- то есть нет данных в канале
      InsArcNewMsg(ID_Obj,310+$4000,1); //- "Отсутствует информация о состоянии светофора"
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowShortMsg(310, LastX, LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else

    if ObjZav[ID_Obj].bParam[13] and not WorkMode.GoTracert then //- светофор заблокирован
    begin
      InsArcNewMsg(ID_Obj,123+$4000,1);//----------------------- "Светофор $ заблокирован"
      ShowShortMsg(123,LastX,LastY,ObjZav[ID_Obj].Liter);
      color := 1;
      msg := GetShortMsg(1,123, ObjZav[ID_Obj].Liter,color);
//      SingleBeep := true;
      exit;
    end else
    if CheckAutoON(ObjZav[ID_Obj].ObjConstI[28]) then //-- /проверить включение автодейст.
    begin
      InsArcNewMsg(ID_Obj,431+$4000,1);//------------------------- "Включено автодействие"
      ShowShortMsg(431,LastX,LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.MarhUpr then //------------------------------ режим маршрутного управления
    begin
      if CheckMaket then  //----------------------- если макет установлен не известно куда
      begin //--------------- макет установлен не полностью - блокировать маршрутный набор
        InsArcNewMsg(ID_Obj,344+$4000,1);
        ShowShortMsg(344,LastX,LastY,ObjZav[ID_Obj].Liter);
        color := 1;
        msg := GetShortMsg(1,344, ObjZav[ID_Obj].Liter,color);
//        SingleBeep := true;
        ShowWarning := true;
        exit;
      end else

      if WorkMode.GoTracert then //----------------------------- Идет трассировка маршрута
      begin //-------------------------------------------------- выбор промежуточной точки
        //---------- если сигнал конца маршрута не соответствует типу задаваемого маршрута
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
      begin //-- открыть сигнал для протяжки (перезамыкание поездного маршрута маневровым)
        InsArcNewMsg(ID_Obj,416+$4000,7); //--- Открыть сигнал $ дла протягивания состава?
        msg := GetShortMsg(1,416, ObjZav[ID_Obj].Liter,7);
      end else
      begin //------------------------------------ Проверить допустимость открытия сигнала
        if ObjZav[ID_Obj].bParam[2] or //------------------------------------ есть МС2 или
        ObjZav[ID_Obj].bParam[4] then //------------------------------------------ есть С2
        begin
          InsArcNewMsg(ID_Obj,230+$4000,7);//------------------------- "Сигнал $ уже открыт"
          ShowShortMsg(230,LastX,LastY,ObjZav[ID_Obj].Liter);
          msg := GetShortMsg(1,230, ObjZav[ID_Obj].Liter,7);
          exit;
        end else

        if ObjZav[ID_Obj].bParam[1] or //------------------------------------ есть МС1 или
        ObjZav[ID_Obj].bParam[3] then //------------------------------------------ есть С1
        begin
          InsArcNewMsg(ID_Obj,402+$4000,1);//-- "Выдержа времени откр.сигнала не окончена"
          ShowShortMsg(402,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end else

        if ObjZav[ID_Obj].bParam[6] or //---------------------- если НМ из сервера или ...
        ObjZav[ID_Obj].bParam[7] then //---------------------------------- трассировка МПР
        begin
          if ObjZav[ID_Obj].bParam[11] then //--- проверка состояния замыкания перекрывной
          begin
            //---------------- проверить условия допустимости повтора маневрового маршрута
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then //---------- если есть условие для НМ
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[18] > 0 then //------- если есть условие для НМ(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //-------------------------- выдать команду повтора маневрового маршрута
              InsArcNewMsg(ID_Obj,177+$4000,7);//-------- "Повторно открыть маневровый $?"
              msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorManevrMarsh;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //------------- Признак НМ, сигнал закрыт - повторное открытие маневрового
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
            begin //------------------------------------ выдать команду начала трассировки
              InsArcNewMsg(ID_Obj,177+$4000,7); //----------- Повторно открыть маневровый $?
              msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorManevrovogo;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end else
        if ObjZav[ID_Obj].bParam[8] or //------------------ если есть Н из сервера или ...
        ObjZav[ID_Obj].bParam[9] then //----------------- поездная ППР трассировка сигнала
        begin
          if ObjZav[ID_Obj].bParam[11] then //--- если перекрывная секция сигнала замкнута
          begin
            //------------------ проверить условия допустимости повтора поездного маршрута
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then //----------- если есть условие для Н
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //-- проверить условие
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then //-------- если есть условие для Н(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //-- проверить условие
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //---------------------------- выдать команду повтора поездного маршрута
              InsArcNewMsg(ID_Obj,178+$4000,2);//------------ Повторно открыть поездной $?
              msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorPoezdMarsh;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          begin //---------------- Признак Н, сигнал закрыт - повторное открытие поездного
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then  //- если есть условие 1 для открытия
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);
              u1 := msg = '';
            end
            else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]);//- если есть условие 2
              u2 := msg = '';
            end
            else u2 := false;
            msg := '';
            if u1 or u2 then
            begin //------------------------------------ выдать команду начала трассировки
              InsArcNewMsg(ID_Obj,178+$4000,2); //------------- Повторно открыть поездной $?
              msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_PovtorPoezdnogo;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end else
        begin
          if (ObjZav[ID_Obj].bParam[14] or //если есть программное замыкание для Н или ...
          (ObjZav[ID_Obj].BaseObject > 0)) and not ObjZav[ID_Obj].bParam[6]
          and not ObjZav[ID_Obj].bParam[8]
          then //---------------------------------------- есть перекрывная секция СП и ...
          begin
            TXT := ObjZav[ObjZav[ID_Obj].BaseObject].Liter;
            if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14]
            then TXT := ' программно замкнут участок ' + TXT else//прогр.замык. СП или ...
            if  not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1]
            then TXT := ' занят участок ' + TXT else  //------------- занятость СП или ...
            if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[2]
            then TXT := ' замкнут участок ' + TXT else //--- релейное замыкание СП или ...
            if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[7]
            then TXT := ' программно замкнут участок ' + TXT else//пред.замык. сервера или
            if not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[8]
            then TXT := ' участок замкнут в другой трассе ' + TXT;//пред.замык.трассировки
            if TXT = ObjZav[ObjZav[ID_Obj].BaseObject].Liter then TXT := '';
          end;
          if TXT <> '' then //-------------- если замыкание враждебного маршрута на РМ-ДСП
          begin
            InsArcNewMsg(ID_Obj,328+$4000,1);  //---- нельзя установить маршрут от сигнала
            msg := GetShortMsg(1,328, ObjZav[ID_Obj].Liter,1) + ',' + TXT;
            //ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
            exit;
          end else
          if ObjZav[ID_Obj].ObjConstB[2] and //------------ если может быть начало П и ...
          ObjZav[ID_Obj].ObjConstB[3] then //------------------------- может быть начало М
          begin //--------------------------------------------- Выбрать категорию маршрута
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then  //---------- если есть условие для Н
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //-- проверить условие
              u1 := msg = '';
            end else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then  //------ если  есть условие для Н(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //-- проверить условие
              u2 := msg = '';
            end else u2 := false;

            uo := u1 or u2;
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then //--------- если  есть условие для НМ
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]); //-- проверить условие
              u1 := msg = '';
            end  else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[18] > 0 then //------ если  есть условие для НМ(2)
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]); //-- проверить условие
              u2 := msg = '';
            end else u2 := false;

            if uo and (u1 or u2) then
            begin
              InsArcNewMsg(ID_Obj,181+$4000,7);  //----------------- Маневровый маршрут $?
              InsArcNewMsg(ID_Obj,182+$4000,2); //-------------------- Поездной маршрут $?
              AddDspMenuItem(GetShortMsg(1,181, '',7), CmdMenu_BeginMarshManevr,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,182, '',2), CmdMenu_BeginMarshPoezd,ID_Obj);
            end else

            if uo then
            begin //------------------------------------------------ трассировать поездной
              InsArcNewMsg(ID_Obj,182+$4000,2); //---------------------- Поездной маршрут $?
              msg := GetShortMsg(1,182, 'от ' + ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshPoezd;
              DspCommand.Obj := ID_Obj;
            end else

            if u1 or u2 then
            begin //---------------------------------------------- трассировать маневровый
              InsArcNewMsg(ID_Obj,181+$4000,7); //-------------------- Маневровый маршрут $?
              msg := GetShortMsg(1,181, 'от ' + ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshManevr;
              DspCommand.Obj := ID_Obj;
            end else
            begin //- отказ от трассировки из-за отсутствия разрешения начальных признаков
              InsArcNewMsg(ID_Obj,328+$4000,1);  //-- нельзя установить маршрут от сигнала
              ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
              exit;
            end;
          end else
          if ObjZav[ID_Obj].ObjConstB[2] then  //--------- от сигнала есть поездное начало
          begin //--------------------------------------- Запрос начала поездного маршрута
            if ObjZav[ID_Obj].ObjConstI[14] > 0 then //есть условие 1 для начала поездного
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);
              u1 := msg = '';
            end
            else u1 := true; //------------------------ нет условия 1 для начала поездного

            if ObjZav[ID_Obj].ObjConstI[15] > 0 then //есть условие 2 для начала поездного
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]);
              u2 := msg = '';
            end
            else u2 := true;

            if u1 and u2 then
            begin //------------------------------------ выдать команду начала трассировки
              InsArcNewMsg(ID_Obj,182+$4000,2); //-------------------- Поездной маршрут $?
              msg := GetShortMsg(1,182, 'от ' + ObjZav[ID_Obj].Liter,2);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshPoezd;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end else
          if ObjZav[ID_Obj].ObjConstB[3] then//если у сигнала существует начало маневровых
          begin //------------------------------------- Запрос начала маневрового маршрута
            if ObjZav[ID_Obj].ObjConstI[17] > 0 then //-- если есть условие 1 для маневров
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);
              u1 := msg = '';
            end else u1 := true;

            if ObjZav[ID_Obj].ObjConstI[18] > 0 then //-- если есть условие 2 для маневров
            begin
              msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);
              u2 := msg = '';
            end else u2 := false;

            if u1 or u2 then
            begin //------------------------------------ выдать команду начала трассировки
              InsArcNewMsg(ID_Obj,181+$4000,2);  //----------------- маневровый маршрут $?
              msg := GetShortMsg(1,181, 'от ' + ObjZav[ID_Obj].Liter,7);
              DspCommand.Active := true;
              DspCommand.Command := CmdMenu_BeginMarshManevr;
              DspCommand.Obj := ID_Obj;
              result := true;
            end else
            begin //------------------------------------------ отказ от начала трассировки
              PutShortMsg(1,LastX,LastY,msg);
              exit;
            end;
          end;
        end;
      end;
    end else
    begin //------------------------------------------------- режим раздельного управления
      if ObjZav[ID_Obj].bParam[2] or ObjZav[ID_Obj].bParam[4] then //----- если МС2 или С2
      begin //-------------------------------------------------------------- открыт сигнал
        InsArcNewMsg(ID_Obj,230+$4000,1); //-------------------------- Сигнал $ уже открыт
        ShowShortMsg(230,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[3] then //--- если МС1 или С1
      begin //------------------------------------------------- сигнал на выдержке времени
        InsArcNewMsg(ID_Obj,402+$4000,1); // Выдержа времени на откр.сигнала $ не окончена
        ShowShortMsg(402,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if CheckProtag(ID_Obj) then
      begin  //--------- Открыть сигнал для протяжки (перезамыкание поездного маневровым)?
        InsArcNewMsg(ID_Obj,416+$4000,7);
        msg := GetShortMsg(1,416, ObjZav[ID_Obj].Liter,7);
      end else
      if ObjZav[ID_Obj].bParam[6] or   //-------------------------- если НМ из FR3 или ...
      ObjZav[ID_Obj].bParam[7] then //------------------------------------ МПР трассировки
      begin
        if ObjZav[ID_Obj].bParam[11] then //------------ если замыкание перекрывной секции
        begin //-------------- проверить условия допустимости повтора маневрового маршрута
          if Marhtracert[1].LockPovtor then //------------------- если заблокирован повтор
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
          begin //---------------------------- выдать команду повтора маневрового маршрута
            InsArcNewMsg(ID_Obj,173+$4000,7);
            msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_PovtorOtkrytManevr;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //--------------- Признак НМ, сигнал закрыт - повторное открытие маневрового
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
          begin //-------------------------------------- выдать команду начала трассировки
            InsArcNewMsg(ID_Obj,177+$4000,7);
            msg := GetShortMsg(1,177, ObjZav[ID_Obj].Liter,7);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorManevrovogo;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZav[ID_Obj].bParam[8] or  //---------------------------- если Н из FR3 или ...
      ObjZav[ID_Obj].bParam[9] then //------------------------------------ ППР трассировки
      begin
        if ObjZav[ID_Obj].bParam[11] then  //------------ если замкнута перекрывная секция
        begin  //--------------- проверить условия допустимости повтора поездного маршрута
          if Marhtracert[1].LockPovtor then //------------------- если повтор заблокирован
          begin
            ResetTrace;
            exit;
          end;

          if ObjZav[ID_Obj].ObjConstI[14] > 0 then    //-------- если есть условие 1 для Н
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //---- проверить условие
            u1 := msg = '';
          end else u1 := true;

          if ObjZav[ID_Obj].ObjConstI[15] > 0 then    //-------- если есть условие 2 для Н
          begin
            msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //---- проверить условие
            u2 := msg = '';
          end else u2 := false;

          if u1 or u2 then
          begin //------------------------------ выдать команду повтора поездного маршрута
            InsArcNewMsg(ID_Obj,174+$4000,2); //---------------------- Открыть поездной $?
            msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter,2);
            DspCommand.Command := CmdMenu_PovtorOtkrytPoezd;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //------------------ Признак Н, сигнал закрыт - повторное открытие поездного
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
          begin //-------------------------------------- выдать команду начала трассировки
            InsArcNewMsg(ID_Obj,178+$4000,2);   //----------- Повторно открыть поездной $?
            msg := GetShortMsg(1,178, ObjZav[ID_Obj].Liter,2);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorPoezdnogo;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end;
      end else
      if ObjZav[ID_Obj].bParam[14] or // если есть программное замыкание на РМ ДСП или ...
      ((ObjZav[ID_Obj].BaseObject <> 0) and  //------------- есть перекрывная секция и ...
      (ObjZav[ObjZav[ID_Obj].BaseObject].bParam[14] or //-- СП программно замкнута или ...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[2] or  //-- СП замкнута релейно или ...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[7] or  //- предв. замыкание FR3 или ...
      not ObjZav[ObjZav[ID_Obj].BaseObject].bParam[8])) then//предв. замыкание трассировки
      begin //------------------- предварительное замыкание враждебного маршрута на РМ-ДСП
        InsArcNewMsg(ID_Obj,328+$4000,1); //--------- нельзя установить маршрут от сигнала
        msg := GetShortMsg(1,328, ObjZav[ID_Obj].Liter,1);
        ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else

      if ObjZav[ID_Obj].ObjConstB[2] and //------- если сигнал имеет начало поездное и ...
      ObjZav[ID_Obj].ObjConstB[3] then //------------------ сигнал имеет начало маневровое
      begin //------------------------------------------------- Выбрать категорию маршрута
        if ObjZav[ID_Obj].ObjConstI[14] > 0 then //--- если у сигнала есть условие 1 для Н
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]);//------- проверить условие
          u1 := msg = ''; //---------------- условие есть, но оно не мешает ? или мешает ?
        end
        else u1 := true; //---------------------------- условия нет, поэтому оно не мешает

        if ObjZav[ID_Obj].ObjConstI[15] > 0 then //--- если у сигнала есть условие 2 для Н
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]);//------- проверить условие
          u2 := msg = ''; //---------------- условие есть, но оно не мешает ? или мешает ?
        end
        else u2 := false; //--------------------------- условия нет, поэтому оно не мешает

        uo := u1 or u2;  //---------------------------------- обобщаем условия 1 и 2 для Н

        if ObjZav[ID_Obj].ObjConstI[17] > 0 then   //---------- если есть условие 1 для НМ
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);//-- проверить условие 1 НМ
          u1 := msg = ''; //---------------- условие есть, но оно не мешает ? или мешает ?
        end else u1 := true;

        if ObjZav[ID_Obj].ObjConstI[18] > 0 then   //---------- если есть условие 2 для НМ
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);//проверка условия 2 для НМ
          u2 := msg = '';
        end  else u2 := false;

        if uo and (u1 or u2) then //объединяем условия (1 или 2) для  Н и (1 или 2) для НМ
        begin  //----------------- есть все условия: для Н и для НМ, поэтому надо выбирать
          InsArcNewMsg(ID_Obj,173+$4000,7);  //--------------------- Открыть маневровый $?
          InsArcNewMsg(ID_Obj,174+$4000,2);   //---------------------- Открыть поездной $?
          AddDspMenuItem(GetShortMsg(1,173, '',7), CmdMenu_OtkrytManevrovym,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,174, '',2), CmdMenu_OtkrytPoezdnym,ID_Obj);
        end else
        if uo then //------------------------------------------- есть условия только для Н
        begin
          InsArcNewMsg(ID_Obj,174+$4000,2);  //----------------------- Открыть поездной $?
          msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter,2);
          DspCommand.Command := CmdMenu_OtkrytPoezdnym;
          DspCommand.Obj := ID_Obj;
        end else
        if u1 or u2 then //------------------------------------ есть условия только для НМ
        begin
          InsArcNewMsg(ID_Obj,173+$4000,7);//----------------------- открыть маневровый $?
          msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtkrytManevrovym;
          DspCommand.Obj := ID_Obj;
        end else
        begin //-------------------- отказ из-за отсутствия разрешения начальных признаков
          InsArcNewMsg(ID_Obj,328+$4000,1); //------- нельзя установить маршрут от сигнала
          ShowShortMsg(328,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end else

      if ObjZav[ID_Obj].ObjConstB[2] then  //--------- если у сигнала есть поездное начало
      begin //--------------------------------------------------- Запрос открытия поездным
        if ObjZav[ID_Obj].ObjConstI[14] > 0 then //--- если у сигнала есть условие 1 для Н
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[14]); //проверка условия 1 для Н
          u1 := msg = '';
        end else u1 := true;

        if ObjZav[ID_Obj].ObjConstI[15] > 0 then //--- если у сигнала есть условие 2 для Н
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[15]); //проверка условия 2 для Н
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- выдать команду начала трассировки
          InsArcNewMsg(ID_Obj,174+$4000,2); //---------------------- "Открыть поездной $?"
          msg := GetShortMsg(1,174, ObjZav[ID_Obj].Liter,2);
          DspCommand.Command := CmdMenu_OtkrytPoezdnym;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- отказ от начала трассировки
          PutShortMsg(1,LastX,LastY,msg);
          exit;
        end;
      end else

      if ObjZav[ID_Obj].ObjConstB[3] then   //------ если у сигнала есть начало маневровых
      begin //------------------------------------------------- Запрос открытия маневровым
        if ObjZav[ID_Obj].ObjConstI[17] > 0 then //------------ если есть условие 1 для НМ
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[17]);  //------ проверка условия
          u1 := msg = '';
        end else u1 := true;

        if ObjZav[ID_Obj].ObjConstI[18] > 0 then //------------ если есть условие 2 для НМ
        begin
          msg := CheckStartTrace(ObjZav[ID_Obj].ObjConstI[18]);  //------ проверка условия
          u2 := msg = '';
        end else u2 := false;

        if u1 or u2 then
        begin //---------------------------------------- выдать команду начала трассировки
          InsArcNewMsg(ID_Obj,173+$4000,7); //-------------------- "Открыть маневровый $?"
          msg := GetShortMsg(1,173, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtkrytManevrovym;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- отказ от начала трассировки
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
//------------------------------  Функция подготовки меню ДСП при управлении автодействием
function CreateDspMenuAvtoSvetofor(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- если ранее работа с макетом или ВК
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- если ранее набирался маршрут, то сбросить набор
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- если ранее готовилась отмена маршрута
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ если включено автодействие
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- задать вопрос "отключить автодействие ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else //----------------------------------------------- если автодействие отключено
    begin
      InsArcNewMsg(ID_Obj,408+$4000,1); //---------- выдать текст "Автодействие отключено"
      msg := GetShortMsg(1,408, ObjZav[ID_Obj].Liter,7);
      ShowShortMsg(408,LastX,LastY,'');
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//--------- задать вопрос "отключить автодействие?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------- включить автодействие
      InsArcNewMsg(ID_Obj,419+$4000,7);//---------- задать вопрос "включить автодействие?"
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
//---------------------------------  Функция подготовки меню ДСП при управлении для бита 1
function CreateDspMenu_1bit(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "Нажата кнопка ответственных команд"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "Отменено ожидание нажатия кнопки всп. перевода"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- если ранее работа с макетом или ВК
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1);  //---------------------------------- "это не стрелка"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- если ранее набирался маршрут, то сбросить набор
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- если ранее готовилась отмена маршрута
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ если включено автодействие
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- задать вопрос "отключить автодействие ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else //----------------------------------------------- если автодействие отключено
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[3]+$4000,1);// выдать текст "отключено"
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
        InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[5]+$4000,7);//задать вопрос отключить?
        WorkMode.MarhOtm := false;
        msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
        PutShortMsg(7,LastX,LastY,msg);
        DspCommand.Command := CmdMenu_OtklBit1;
        DspCommand.Obj := ID_Obj;
      end else
      begin
        InsArcNewMsg(ID_Obj,572,1); //------------  Объект находится в требуемом состоянии
        msg := GetShortMsg(1,572, '',1);
        PutShortMsg(1,LastX,LastY,msg);
        DspMenu.WC := false;
        DspCommand.Command := 0;
        DspCommand.Obj := 0;
        exit;
      end;
    end else
    begin //-------------------------------------------------------------- включить что-то
      if ObjZav[ID_Obj].ObjConstI[4] > 0 then
      begin
        InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[4]+$4000,7);//задать вопрос включить?
        msg := MsgList[ObjZav[ID_Obj].ObjConstI[4]];
        WorkMode.MarhOtm := false;
        DspCommand.Command := CmdMenu_VklBit1;
        DspCommand.Obj := ID_Obj;
      end else
      begin
        InsArcNewMsg(ID_Obj,572,1); //------------  Объект находится в требуемом состоянии
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
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "Нажата кнопка ответственных команд"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "Отменено ожидание нажатия кнопки всп. перевода"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- если ранее работа с макетом или ВК
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1);  //---------------------------------- "это не стрелка"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- если ранее набирался маршрут, то сбросить набор
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- если ранее готовилась отмена маршрута
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ если включено автодействие
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- задать вопрос "отключить автодействие ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
    end else //----------------------------------------------- если автодействие отключено
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[3]+$4000,1);//выдать текст "отключено"
      ShowShortMsg(408,LastX,LastY,'');
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[5]+$4000,7);//задать вопрос сброса бита
      WorkMode.MarhOtm := false;
      msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
      DspCommand.Command := CmdMenu_VklBit1_2;
      DspCommand.Obj := ID_Obj;
    end else
    begin //-------------------------------------------------------------- включить что-то
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[4]+$4000,7);//задать вопрос о включении
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
      InsArcNewMsg(razresh,543+$4000,1);  //--------------- команда заблокирована объектом
      msg := GetShortMsg(1,543, ObjZav[razresh].Liter,1);
      exit;
    end;
  end;

  DspMenu.obj := cur_obj;

  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "Нажата кнопка ответственных команд"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "Отменено ожидание нажатия кнопки всп. перевода"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- если ранее работа с макетом или ВК
  begin
    InsArcNewMsg(ID_Obj,9+$4000,1);  //---------------------------------- "это не стрелка"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //----------- если ранее набирался маршрут, то сбросить набор
  begin
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then //----------------------- если ранее готовилась отмена маршрута
  begin
    if ObjZav[ID_Obj].bParam[1] then //------------------------ если включено автодействие
    begin
      InsArcNewMsg(ID_Obj,420+$4000,7);//-------- задать вопрос "отключить автодействие ?"
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,420, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_AutoMarshOtkl;
      DspCommand.Obj := ID_Obj;
      result := true;
    end else //----------------------------------------------- если автодействие отключено
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[3]+$4000,1);// выдать текст "отключено"
      ShowShortMsg(408,LastX,LastY,'');//------------------------ Автодействие $ отключено
      WorkMode.MarhOtm := false;
      exit;
    end;
  end else
  begin
    if ObjZav[ID_Obj].bParam[1] then
    begin
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[5]+$4000,7);// задать вопрос отключить?
      WorkMode.MarhOtm := false;
      msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
      DspCommand.Command := CmdMenu_OtklBit2;
      DspCommand.Obj := ID_Obj;
      result := true;
    end else
    begin //-------------------------------------------------------------- включить что-то
      InsArcNewMsg(ID_Obj,ObjZav[ID_Obj].ObjConstI[4]+$4000,7);//задать вопрос включить ?
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
//-------------- подготовка меню для запрета или ответственного разрешения работы монтерам
function CreateDspMenu_Zapr_Razr_Mont(ID,X,Y : SmallInt): boolean;
var
  TXT : string;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end;

  if WorkMode.OtvKom and not ObjZav[ID_Obj].bParam[1] then //-------- нет запрета монтерам
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "Нажата кнопка ответственных команд"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end;

  if not WorkMode.OtvKom and (not ObjZav[ID_Obj].bParam[1])then //нет запрета,не нажата ОК
  begin
    InsArcNewMsg(ID_Obj,199+$4000,7);
    msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_DatZapretMonteram;
    DspCommand.Obj := ID_Obj;
  end else  //------------------------------------------------------ есть запрет, нужна ОК
  begin
    if WorkMode.OtvKom then
    begin //----------------------------------------- Нажата кнопка ответственных команд
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,528+$4000,7);
        msg := GetShortMsg(1,528, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsArcNewMsg(ID_Obj,527+$4000,7);
        msg := GetShortMsg(1,527, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//---------------------- подготовка меню для открытия или ответственного закрытия переезда
function CreateDspMenu_PRZD_Zakr_Otkr(ID,X,Y : SmallInt): boolean;
var
  TXT : string;
begin
  DspMenu.obj := cur_obj;
  result := false;
  {$IFNDEF RMDSP} ID_ViewObj := ID_Obj; result := true; exit;{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end;

  if WorkMode.OtvKom and not ObjZav[ID_Obj].bParam[12] and not ObjZav[ID_Obj].bParam[13] then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    ResetCommands;
    InsArcNewMsg(ID_Obj,283+$4000,1); //------------- "Нажата кнопка ответственных команд"
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end;

  if not WorkMode.OtvKom and (not ObjZav[ID_Obj].bParam[12] or
  not ObjZav[ID_Obj].bParam[13]) then //-------------------- открыт переезд и не нажата ОК
  begin
    InsArcNewMsg(ID_Obj,192+$4000,7);
    msg := GetShortMsg(1,192, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_ZakrytPereezd;
    DspCommand.Obj := ID_Obj;
  end else  //-------------------------------------------------- переезд закрыт, нужна ОК
  begin
    if WorkMode.OtvKom then
    begin //----------------------------------------- Нажата кнопка ответственных команд
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,194+$4000,7);
        msg := GetShortMsg(1,194, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsArcNewMsg(ID_Obj,193+$4000,7);
        msg := GetShortMsg(1,193, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//------------------------- подготовка меню для выдачи поездного согласия на соседний пост
function CreateDspMenuVydachaPSoglasiya(ID,X,Y : SmallInt): boolean;
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
    InsArcNewMsg(ObjZav[i].BaseObject,311+$4000,7);  //------------------ Нормализовать $?
    msg := GetShortMsg(1,311, ObjZav[ObjZav[i].BaseObject].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ObjZav[i].BaseObject;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);//-- "Отменено ожидание нажатия кнопки всп. перевода"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.InpOgr then exit //-------------------------------------- ввод ограничений
    else
    if ObjZav[ObjZav[i].BaseObject].bParam[18] then
    begin //-------------------------------------------------------- на местном управлении
      InsArcNewMsg(ObjZav[i].BaseObject,232+$4000,1); //--- Сигнал $ на местном управлении
      WorkMode.GoMaketSt := false;
      ShowShortMsg(232,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
      exit;
    end else
    if WorkMode.MarhOtm then
    begin //----------------------- отмена маршрутов для всех режимов управления сигналами
      if ObjZav[ObjZav[i].BaseObject].bParam[8] or
      ObjZav[ObjZav[i].BaseObject].bParam[9] or
      ObjZav[ObjZav[i].BaseObject].bParam[3] or
      ObjZav[ObjZav[i].BaseObject].bParam[4] then
      begin
        if ObjZav[ObjZav[i].BaseObject].bParam[3] or
        ObjZav[ObjZav[i].BaseObject].bParam[4] then
        begin //----------------------------------------- отменить поездной, сигнал открыт
          if ObjZav[i].UpdateObject > 0 then
          begin //------------------------------------------------------ увязка через путь
            if ObjZav[ObjZav[i].UpdateObject].bParam[2] and
            ObjZav[ObjZav[i].UpdateObject].bParam[3] then
            begin //------------------------ нет замыкания на увязочном пути - дать отмену
              InsArcNewMsg(ObjZav[i].BaseObject,184+$4000,7);//Отменить согл.поезд.приема?
              msg := GetShortMsg(1,184, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter,7);
              DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
              DspCommand.Obj := ObjZav[i].BaseObject;
            end else
            begin
              InsArcNewMsg(ObjZav[i].BaseObject,254+$4000,1);//------ Замкнут маршрут до $
              ShowShortMsg(254,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter); exit;
            end;
          end else
          begin //------------------------------------------ увязка по светофорам в створе
            if ObjZav[i].bParam[2] then
            begin //------------------------------------------- замкнут маршрут до сигнала
              InsArcNewMsg(ID_Obj,254+$4000,1);
              ShowShortMsg(254,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
              exit;
            end else
            begin //---------------------------------------- не замкнут маршрут до сигнала
              InsArcNewMsg(ObjZav[i].BaseObject,184+$4000,1);
              msg := GetShortMsg(1,184, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter,1);
              DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
              DspCommand.Obj := ObjZav[i].BaseObject;
            end;
          end;
        end else
        begin //сигнал на противоповторке - выдать команду без проверки замыкания маршрута
          InsArcNewMsg(ObjZav[i].BaseObject,184+$4000,7); //- Отменить согл.поезд.приема?
          msg := GetShortMsg(1,184, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter,7);
          DspCommand.Command := CmdMenu_OtmenaPoezdnogo;
          DspCommand.Obj := ObjZav[i].BaseObject;
        end;
      end;
    end else
    if ObjZav[ObjZav[i].BaseObject].bParam[13] and not WorkMode.GoTracert then
    begin //-------------------------------------------------------- светофор заблокирован
      InsArcNewMsg(ObjZav[i].BaseObject,123+$4000,1);
      ShowShortMsg(123,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
      exit;
    end else
    if WorkMode.MarhUpr then
    begin //------------------------------------------------- режим маршрутного управления
      if CheckMaket then
      begin //--------------- макет установлен не полностью - блокировать маршрутный набор
        InsArcNewMsg(ID_Obj,344+$4000,1);
        ShowShortMsg(344,LastX,LastY,ObjZav[ID_Obj].Liter);
//        SingleBeep := true;
        ShowWarning := true;
        exit;
      end else
      if WorkMode.CmdReady then
      begin //--------------------- передача маршрута в сервер - отказ маршрутных операций
        InsArcNewMsg(ID_Obj,239+$4000,1);
        ShowShortMsg(239,LastX,LastY,''); exit;
      end else
      if WorkMode.GoTracert then
      begin //-------------------------------------------------- выбор промежуточной точки
        DspCommand.Active  := true;
        DspCommand.Command := CmdMarsh_Tracert;
        DspCommand.Obj := ObjZav[i].BaseObject;
        exit;
      end else
      begin //------------------------------------ Проверить допустимость открытия сигнала
        if ObjZav[i].bParam[1] then
        begin //-------------------------------------------------------- нажата кнопка ЭГС
          InsArcNewMsg(ObjZav[i].BaseObject,105+$4000,1);
          ShowShortMsg(105,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
          exit;
        end else
        if ObjZav[ObjZav[i].BaseObject].bParam[1] or
        ObjZav[ObjZav[i].BaseObject].bParam[2] or
        ObjZav[ObjZav[i].BaseObject].bParam[3] or
        ObjZav[ObjZav[i].BaseObject].bParam[4] then
        begin //------------------------------------------------------------ открыт сигнал
          InsArcNewMsg(ObjZav[i].BaseObject,230+$4000,1);
          ShowShortMsg(230,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
          exit;
        end else
        if ObjZav[ObjZav[i].BaseObject].bParam[7] then exit //------------ маневры - отказ
        else
        if ObjZav[ObjZav[i].BaseObject].bParam[9] then
        begin
          if ObjZav[ObjZav[i].BaseObject].bParam[11] then
          begin //---------- перекрывная секция не замкнута - отказ от повторного открытия
            InsArcNewMsg(ObjZav[i].BaseObject,229+$4000,1);
            ShowShortMsg(229,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
            exit;
          end else
          begin //---------------- Признак Н, сигнал закрыт - повторное открытие поездного
            InsArcNewMsg(ObjZav[i].BaseObject,178+$4000,2);
            msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter,2);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorPoezdnogo;
            DspCommand.Obj := ObjZav[i].BaseObject;
          end;
        end else
        if ObjZav[ID_Obj].bParam[14] then
        begin //----------------------------- предварительное замыкание маршрута на РМ-ДСП
          //--------------------- проверить условия допустимости повтора поездного маршрута
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
          begin //------------------------------ выдать команду повтора поездного маршрута
            InsArcNewMsg(ObjZav[i].BaseObject,178+$4000,2);
            msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter,2);
            DspCommand.Active := true;
            DspCommand.Command := CmdMenu_PovtorPoezdMarsh;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------- отказ от начала трассировки
            PutShortMsg(1,LastX,LastY,msg);
            exit;
          end;
        end else
        begin //----------------------------------------- Запрос начала поездного маршрута
          InsArcNewMsg(ObjZav[i].BaseObject,183+$4000,2);
          msg := GetShortMsg(1,183, 'от ' + ObjZav[ObjZav[i].BaseObject].Liter,2);
          DspCommand.Active := true;
          DspCommand.Command := CmdMenu_BeginMarshPoezd;
          DspCommand.Obj := ObjZav[i].BaseObject;
        end;
      end;
    end else
    begin //------------------------------------------------- режим раздельного управления
      if ObjZav[i].bParam[1] then
      begin // нажата кнопка ЭГС
        InsArcNewMsg(ObjZav[i].BaseObject,105+$4000,1);
        ShowShortMsg(105,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
        exit;
      end else
      if ObjZav[ObjZav[i].BaseObject].bParam[1] or
      ObjZav[ObjZav[i].BaseObject].bParam[2] or
      ObjZav[ObjZav[i].BaseObject].bParam[3] or
      ObjZav[ObjZav[i].BaseObject].bParam[4] then
      begin //-------------------------------------------------------------- открыт сигнал
        InsArcNewMsg(ObjZav[i].BaseObject,230+$4000,1);
        ShowShortMsg(230,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
        exit;
      end else
      if ObjZav[ObjZav[i].BaseObject].bParam[9] then
      begin
        if ObjZav[ObjZav[i].BaseObject].bParam[11] then
        begin //------------ перекрывная секция не замкнута - отказ от повторного открытия
          InsArcNewMsg(ObjZav[i].BaseObject,229+$4000,1);
          ShowShortMsg(229,LastX,LastY,ObjZav[ObjZav[i].BaseObject].Liter);
          exit;
        end else
        begin //------------------ Признак Н, сигнал закрыт - повторное открытие поездного
          InsArcNewMsg(ObjZav[i].BaseObject,178+$4000,2);
          msg := GetShortMsg(1,178, ObjZav[ObjZav[i].BaseObject].Liter,2);
          DspCommand.Active := true;
          DspCommand.Command := CmdMenu_PovtorPoezdnogo;
          DspCommand.Obj := ObjZav[i].BaseObject;
        end;
      end else
      if ObjZav[i].bParam[14] then
      begin //------------------------------- предварительное замыкание маршрута на РМ-ДСП
        //---------------------- проверить условия допустимости повтора поездного маршрута
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
        begin //-------------------------------- выдать команду повтора поездного маршрута
          InsArcNewMsg(ObjZav[i].BaseObject,174+$4000,2);
          msg := GetShortMsg(1,174, ObjZav[ObjZav[i].BaseObject].Liter,2);
          DspCommand.Command := CmdMenu_PovtorOtkrytPoezd;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------- отказ от начала трассировки
          PutShortMsg(1,LastX,LastY,msg);
          exit;
        end;
      end else
      begin //--------------------------------------------------- Запрос открытия поездным
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
//------------------------------------------- Подготовка меню для выдачи "Надвиг на горку"
function CreateDspMenuNadvig(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.OtvKom then
  begin //------------------- нажата ОК - нормализовать признаки трассировки для светофора
    InsArcNewMsg(ID_Obj,311+$4000,7);
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ID_Obj;
  end else
  begin
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ввод ограничений
      if ObjZav[ID_Obj].bParam[13] then
      begin //---------------------------------------------------- разблокировать светофор
        InsArcNewMsg(ID_Obj,180+$4000,7);
        msg := GetShortMsg(1,180, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_DeblokirovkaNadviga;
        DspCommand.Obj := ID_Obj;
      end else
      begin //----------------------------------------------------- заблокировать светофор
        InsArcNewMsg(ID_Obj,179+$4000,7);
        msg := GetShortMsg(1,179, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_BlokirovkaNadviga;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    if ObjZav[ID_Obj].bParam[13] then
    begin //-------------------------------------------------------- светофор заблокирован
      InsArcNewMsg(ID_Obj,123+$4000,1);
      ShowShortMsg(123,LastX,LastY,ObjZav[ID_Obj].Liter); exit;
    end else
    if WorkMode.MarhUpr then
    begin //------------------------------------------------- режим маршрутного управления
      if WorkMode.CmdReady then
      begin //--------------------- передача маршрута в сервер - отказ маршрутных операций
        InsArcNewMsg(ID_Obj,239+$4000,1);
        ShowShortMsg(239,LastX,LastY,'');
        exit;
      end else
      if WorkMode.GoTracert then
      begin //-------------------------------------------------- выбор промежуточной точки
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
//--------------------- Подготовка меню управления объектом "Участок СП или бесстрелочный"
function CreateDspMenuUchastok(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if ObjZav[ID_Obj].bParam[19] then
    begin //---------------------------------------- Восприятие диагностического сообщения
      ObjZav[ID_Obj].bParam[19] := false;
      exit;
    end else
    if ObjZav[ID_Obj].bParam[9] or not ObjZav[ID_Obj].bParam[5] then
    begin //-------------------------------------------------------- на местном управлении
      InsArcNewMsg(ID_Obj,233+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(233,LastX,LastY,ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ввод ограничений
      if ObjZav[ID_Obj].bParam[33] then
      begin //------------------------------------------------------ включено автодействие
        InsArcNewMsg(ID_Obj,431+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(431, LastX, LastY, '');
        exit;
      end else
      if not ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[14] then
      begin //--------------------------------------------------- секция в трассе маршрута
        InsArcNewMsg(ID_Obj,512+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(512, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZav[ID_Obj].ObjConstB[8] or
        ObjZav[ID_Obj].ObjConstB[9] then //--------- есть закрытие движения на электротяге
        begin
          //------------------------------------------------------------ закрытие движения
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
          //--------------------------------------------- закрытие движения на электротяге
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
          ObjZav[ID_Obj].ObjConstB[9] then //--------------------- есть 2 вида электротяги
          begin //---------------------- закрытие движения на электротяге постоянного тока
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
            //-------------------------- закрытие движения на электротяге переменного тока
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
        begin //---------------------------------------------------------- нет электротяги
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
    begin //---------------------------------------------------------- нет данных в канале
      InsArcNewMsg(ID_Obj,293+$4000,1);
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowShortMsg(293, LastX, LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else

    if WorkMode.GoTracert then
    begin //---------------------------------------------------- выбор промежуточной точки
      DspCommand.Active  := true;
      DspCommand.Command := CmdMarsh_Tracert;
      DspCommand.Obj := ID_Obj;
      exit;
    end else
    if WorkMode.OtvKom then
    begin //------------------------------------------- Нажата кнопка ответственных команд
      if ObjZav[ID_Obj].ObjConstB[7] then
      begin //---- для секции в составе сегмента выдать команду искус. размыкания сегмента
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- исполнительная команда
          OtvCommand.SObj := ID_Obj;
          InsArcNewMsg(ID_Obj,214+$4000,7);
          msg := GetShortMsg(1,214, ObjZav[ObjZav[ID_Obj].BaseObject].Liter,7);
          DspCommand.Command := CmdMenu_SekciaIspolnitRI;
          DspCommand.Obj := ID_Obj;
        end else
        if ObjZav[ID_Obj].bParam[2] then
        begin //-------- секция разомкнута - нормализовать признаки трассировки для секции
          InsArcNewMsg(ID_Obj,311+$4000,7);
          msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMarsh_ResetTraceParams;
          DspCommand.Obj := ID_Obj;
        end else
        begin //---------------------------------------------------------- секция замкнута
          if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1] then
          begin //------------------------------------- выполняется ИР сегмента - отказать
            InsArcNewMsg(ID_Obj,335+$4000,1);
            ShowShortMsg(335,LastX,LastY,ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
//            SingleBeep := true;
            exit;
          end else
          begin //----------------------------- выдать предварительныю команду ИР сегмента
            InsArcNewMsg(ID_Obj,185+$4000,7);
            msg := GetShortMsg(1,185, ObjZav[ObjZav[ID_Obj].BaseObject].Liter,7);
            DspCommand.Command := CmdMenu_SekciaPredvaritRI;
            DspCommand.Obj := ID_Obj;
          end;
        end;
      end else
      begin //- для секции при посекционном размыкании выдать команду выбора секции для РИ
        if WorkMode.GoOtvKom then
        begin //--------------------------------------------------- исполнительная команда
          OtvCommand.SObj := ID_Obj;
          InsArcNewMsg(ID_Obj,186+$4000,7);
          msg := GetShortMsg(1,186, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_SekciaIspolnitRI;
          DspCommand.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- предварительная команда
          if ObjZav[ID_Obj].bParam[2] then
          begin //------ секция разомкнута - нормализовать признаки трассировки для секции
            InsArcNewMsg(ID_Obj,311+$4000,7);
            msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMarsh_ResetTraceParams;
            DspCommand.Obj := ID_Obj;
          end else
          begin //-------------------------------------------------------- секция замкнута
            if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[1] then
            begin //----------------------------- запушена выдержка времени ГИР - отказать
              InsArcNewMsg(ID_Obj,334+$4000,1);
              AddFixMessage(GetShortMsg(1,334,ObjZav[ID_Obj].Liter,1),4,2);
              exit;
            end else
            if ObjZav[ID_Obj].bParam[3] then
            begin //------------------------- Выполняется иск.размыкание секции - отказать
              InsArcNewMsg(ID_Obj,84+$4000,1);
              ShowShortMsg(84,LastX,LastY,ObjZav[ID_Obj].Liter);
              exit;
            end else
            begin //------------------------------------------- предварительная команда РИ
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
//--------------------------------------------- Подготовка меню управления объектом "Путь"
function CreateDspMenuPutPO(ID,X,Y : SmallInt): boolean;
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
    InsArcNewMsg(ID_Obj,311+$4000,7);
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ID_Obj;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if ObjZav[ID_Obj].bParam[19] then
    begin //---------------------------------------- Восприятие диагностического сообщения
      ObjZav[ID_Obj].bParam[19] := false;
      exit;
    end else
    if ObjZav[ID_Obj].bParam[9] and not WorkMode.GoTracert then
    begin //-------------------------------------------------------- на местном управлении
      InsArcNewMsg(ID_Obj,234+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(234,LastX,LastY,ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- ввод ограничений
      if ObjZav[ID_Obj].bParam[33] then
      begin //------------------------------------------------------ включено автодействие
        InsArcNewMsg(ID_Obj,431+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(431, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      if ObjZav[ID_Obj].bParam[9] then
      begin //------------------------------------------------- путь на местном управлении
        InsArcNewMsg(ID_Obj,234+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(234, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      if not ObjZav[ID_Obj].bParam[8] or ObjZav[ID_Obj].bParam[14] then
      begin //----------------------------------------------------- путь в трассе маршрута
        InsArcNewMsg(ID_Obj,513+$4000,1);
        WorkMode.InpOgr := false;
        ShowShortMsg(513, LastX, LastY, ObjZav[ID_Obj].Liter);
        exit;
      end else
      begin
        if ObjZav[ID_Obj].ObjConstB[8] or
        ObjZav[ID_Obj].ObjConstB[9] then //--------- есть закрытие движения на электротяге
        begin
          //------------------------------------------------------------ закрытие движения
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
          //--------------------------------------------- закрытие движения на электротяге
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
          ObjZav[ID_Obj].ObjConstB[9] then //--------------------- есть 2 вида электротяги
          begin
            //-------------------------- закрытие движения на электротяге постоянного тока
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
            //-------------------------- закрытие движения на электротяге переменного тока
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
        begin //---------------------------------------------------------- нет электротяги
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
    begin //---------------------------------------------------------- нет данных в канале
      InsArcNewMsg(ID_Obj,294+$4000,1);
      VspPerevod.Active := false;
      WorkMode.VspStr := false;
      ShowShortMsg(294, LastX, LastY, ObjZav[ID_Obj].Liter);
      exit;
    end else
    if WorkMode.GoTracert then //----------------------- если режим маршрутного управления
    begin //---------------------------------------------------- выбор промежуточной точки
      DspCommand.Active := true;
      DspCommand.Command := CmdMarsh_Tracert;
      DspCommand.Obj := ID_Obj;
      result := false;
      exit;
    end else
    begin
      i := ObjZav[ID_Obj].UpdateObject;
      if i > 0 then
      begin //------------------------------------------------------- есть ограждение пути
        if ObjZav[i].Timers[1].Active and not ObjZav[i].bParam[4] then
        begin //-------------------------------- снять мигающую индикацию неисправности ОГ
          ObjZav[i].bParam[4] := true;
          exit;
        end else
        if ObjZav[i].bParam[1] and not ObjZav[i].bParam[2] then
        begin //----- если есть запрос ПТО - проверить условия выдачи согласия ограждения
          if SoglasieOG(ID_Obj) then
          begin //------------------------------ нет маршрутов на/с путь - выдать согласие
            InsArcNewMsg(ID_Obj,187+$4000,7);
            msg := GetShortMsg(1,187, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_PutDatSoglasieOgrady;
            DspCommand.Obj := ID_Obj;
          end else
          begin //------------------------------------------------ есть маршруты на/с путь
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
//----------------- Подготовка меню управления объектом "ОПИ"(исключение пути из маневров)
function CreateDspMenuOPI(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- Сбросить набор маршрута
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------------------------- отмена
    if ObjZav[ID_Obj].bParam[1] then
    begin  //- Снять исключение пути из маневрового района{проверить возможность действия}
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
    begin //-- Снять исключение пути из маневрового района{проверить возможность действия}
      InsArcNewMsg(ID_Obj,413+$4000,7);
      WorkMode.MarhOtm := false;
      msg := GetShortMsg(1,413,ObjZav[ObjZav[ID_Obj].UpdateObject].Liter,7);
      DspCommand.Command := CmdMenu_PutOtklOPI;
      DspCommand.Obj := ID_Obj;
    end else
    begin //----------------------------------- Дать исключение пути из маневрового района
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
//------------------------------------------ Запрос поездного отправления на соседний пост
function CreateDspMenuPSoglasiya(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- Сбросить набор маршрута
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- отмена -
    if ObjZav[ID_Obj].bParam[1] then
    begin //----------------------------------------------------- Снять запрос отправления
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
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- Ввод ограничений
      //-------------------------------------------- есть закрытие движения на электротяге
      if ObjZav[ID_Obj].ObjConstB[8] or ObjZav[ID_Obj].ObjConstB[9] then
      begin
        //-------------------------------------------------------------- закрытие движения
        if ObjZav[ID_Obj].bParam[14] <> ObjZav[ID_Obj].bParam[15] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7);
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytUvjazki,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytUvjazki,ID_Obj);
        end else
        if ObjZav[ID_Obj].bParam[15] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7); //-------------------------- открыть перегон ?
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytUvjazki,ID_Obj);
        end else
        begin
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytUvjazki,ID_Obj);
        end;
        //----------------------------------------------- закрытие движения на электротяге
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

        //-------------------------------------------------------- есть 2 вида электротяги
        if ObjZav[ID_Obj].ObjConstB[8] and ObjZav[ID_Obj].ObjConstB[9] then
        begin
          //---------------------------- закрытие движения на электротяге постоянного тока
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
          //---------------------------- закрытие движения на электротяге переменного тока
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
        begin //---------------------------------------------------------- нет электротяги
          if ObjZav[ID_Obj].bParam[14] <> ObjZav[ID_Obj].bParam[15] then
          begin
            InsArcNewMsg(ID_Obj,207+$4000,7);
            InsArcNewMsg(ID_Obj,206+$4000,7);
            AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytUvjazki,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytUvjazki,ID_Obj);
          end else
          begin
            if ObjZav[ID_Obj].bParam[15] or ObjZav[ID_Obj].bParam[14] then
            begin //------------------------------------- Перегон закрыт - открыть перегон
              InsArcNewMsg(ID_Obj,207+$4000,7);
              msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_OtkrytUvjazki;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------- Перегон открыт - закрыть перегон
              InsArcNewMsg(ID_Obj,206+$4000,7);
              msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_ZakrytUvjazki;
              DspCommand.Obj := ID_Obj;
            end;
          end;
        end;
      end else
      begin //--------------------------------------------------------------------- Запрос
        if ObjZav[ID_Obj].bParam[1] then
        begin //------------------------------------------------- Снять запрос отправления
          InsArcNewMsg(ID_Obj,216+$4000,7);
          msg := GetShortMsg(1,216, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtmZaprosPoezdSoglasiya; DspCommand.Obj := ID_Obj;
        end else
        begin //-------------------------------------------------- Дать запрос отправления
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
//------------------------------ создание меню для управления объектом "смена направления"
function CreateDspMenuSmenaNapravleniya(ID,X,Y : SmallInt;var gotomenu : boolean):boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}

  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1); //--------------- "Нажата кнопка ответственных команд"
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);//---- Отменено ожидание нажатия кнопки вспом. перевода
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then //------------------------------------ Сбросить отмену маршрута
  begin
    if (ObjZav[ID_Obj].ObjConstI[9] > 0) and //--------- вариант с запросом согласия на СН
    ObjZav[ID_Obj].bParam[17] then        //----------- Есть согласие на смену направления
    begin  //----------------------------------------------------------- сбросить согласие
      InsArcNewMsg(ID_Obj,437+$4000,4); //--- "Снять согласие смены направления на перегоне"
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
    InsArcNewMsg(ID_Obj,9+$4000,1);//-------------------------------------- "это не стрелка"
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
  if WorkMode.InpOgr then //--------------------------------------------- Ввод ограничений
  begin
    if ObjZav[ID_Obj].bParam[33] then
    begin //-------------------------------------------------------- включено автодействие
      InsArcNewMsg(ID_Obj,431+$4000,1);//--------------------------- "Включено автодействие"
      WorkMode.InpOgr := false;
      ShowShortMsg(431, LastX, LastY, '');
      exit;
    end else
    begin
      //-------------------------------------------- есть закрытие движения на электротяге
        if ObjZav[ID_Obj].ObjConstB[8] or
        ObjZav[ID_Obj].ObjConstB[9] then
        begin
          //------------------------------------------------------------ закрытие движения
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,207+$4000,7); //----------------------- "Открыть перегон $?"
            InsArcNewMsg(ID_Obj,206+$4000,7); //----------------------- "Закрыть перегон $?"
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
          //--------------------------------------------- закрытие движения на электротяге
          if ObjZav[ID_Obj].bParam[24] <> ObjZav[ID_Obj].bParam[27] then
          begin
            InsArcNewMsg(ID_Obj,458+$4000,7); //------ Закрыть $ для движения на электротяге
            InsArcNewMsg(ID_Obj,459+$4000,7); //------ Открыть $ для движения на электротяге
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
          ObjZav[ID_Obj].ObjConstB[9] then //--------------------- есть 2 вида электротяги
          begin
            //-------------------------- закрытие движения на электротяге постоянного тока
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
            //-------------------------- закрытие движения на электротяге переменного тока
            if ObjZav[ID_Obj].bParam[26] <> ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);//Открыть для движения на ЭТ переменного тока
              InsArcNewMsg(ID_Obj,469+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_ABZakrytDvijenieETA,ID_Obj);
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_ABOtkrytDvijenieETA,ID_Obj);
            end else
            if ObjZav[ID_Obj].bParam[29] then
            begin
              InsArcNewMsg(ID_Obj,469+$4000,7);//-- Выдана команда закр.движ. ЭТ перем. тока
              AddDspMenuItem(GetShortMsg(1,469,'',7),CmdMenu_ABOtkrytDvijenieETA,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,468+$4000,7);
              AddDspMenuItem(GetShortMsg(1,468,'',7),CmdMenu_ABZakrytDvijenieETA,ID_Obj);
            end;
          end;
        end else
        begin //---------------------------------------------------------- нет электротяги
          if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
          begin
            InsArcNewMsg(ID_Obj,207+$4000,7);  //---------------------- Открыть перегон $?
            InsArcNewMsg(ID_Obj,206+$4000,7);  //---------------------- Закрыть перегон $?
            AddDspMenuItem(GetShortMsg(1,207,'',7),CmdMenu_OtkrytPeregon,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,206,'',7),CmdMenu_ZakrytPeregon,ID_Obj);
          end else
          begin
            if ObjZav[ID_Obj].bParam[13] or ObjZav[ID_Obj].bParam[12] then
            begin //------------------------------------- Перегон закрыт - открыть перегон
              InsArcNewMsg(ID_Obj,207+$4000,7);
              msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_OtkrytPeregon;
              DspCommand.Obj := ID_Obj;
            end else
            begin //------------------------------------- Перегон открыт - закрыть перегон
              InsArcNewMsg(ID_Obj,206+$4000,7);
              msg := GetShortMsg(1,206, ObjZav[ID_Obj].Liter,7);
              DspCommand.Command := CmdMenu_ZakrytPeregon;
              DspCommand.Obj := ID_Obj;
            end;
          end;
        end;
      end;
    end else
    begin //------------------------------------------------------------ Смена направления
      if ObjZav[ID_Obj].ObjConstB[3] then //------------------- есть подключение комплекта
      begin
        if ObjZav[ID_Obj].bParam[7] and ObjZav[ID_Obj].bParam[8] then
        begin //--------------------------------------------- ошибка подключения комплекта
          InsArcNewMsg(ID_Obj,261+$4000,1);//Комплект смены направления $ подключен не верно
          ShowShortMsg(261,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
        if ObjZav[ID_Obj].ObjConstB[4] then
        begin //-------------------------------------------------------------------- прием
          if not ObjZav[ID_Obj].bParam[7] then
          begin //---------------------------------------- не подключен комплект по приему
            InsArcNewMsg(ID_Obj,260+$4000,1);
            ShowShortMsg(260,LastX,LastY,ObjZav[ID_Obj].Liter);
            exit;
          end;
        end else
        if ObjZav[ID_Obj].ObjConstB[5] then
        begin //-------------------------------------------------------------- отправление
          if not ObjZav[ID_Obj].bParam[8] then
          begin //----------------------------------- не подключен комплект по отправлению
            InsArcNewMsg(ID_Obj,260+$4000,1); // Комплект смены направления $ не подключен
            ShowShortMsg(260,LastX,LastY,ObjZav[ID_Obj].Liter);
            exit;
          end;
        end;
      end;

      if (ObjZav[ID_Obj].ObjConstI[9] > 0) and //------- вариант с запросом согласия на СН
      ObjZav[ID_Obj].bParam[17] then        //--------- Есть согласие на смену направления
      begin //---------------------------------------------------------- сбросить согласие
        InsArcNewMsg(ID_Obj,437+$4000,7); //- Снять согласие смены направления на перегоне
        msg := GetShortMsg(1,437, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_SnatSoglasieSmenyNapr;
        DspCommand.Obj := ID_Obj;
        DspMenu.WC := true;
        gotomenu := true;
        exit;
      end;

      if not ObjZav[ID_Obj].bParam[5] then
      begin //-------------------------------------------------------------- перегон занят
        InsArcNewMsg(ID_Obj,262+$4000,1);
        ShowShortMsg(262,LastX,LastY,ObjZav[ID_Obj].Liter);
        msg :=GetShortMsg(1,262, ObjZav[ID_Obj].Liter,1);
        exit;
      end;

      if not ObjZav[ID_Obj].bParam[6] then
      begin //--------------------------------------- отправлен хозпоезд (изъят ключ-жезл)
        InsArcNewMsg(ID_Obj,130+$4000,1);
        ShowShortMsg(130,LastX,LastY,ObjZav[ID_Obj].Liter);
        msg := GetShortMsg(1, 130, ObjZav[ID_Obj].Liter,1);
        exit;
      end;

      if ObjZav[ID_Obj].bParam[4] then//------------------- "перегон стоит на отправление"
      begin
        if ObjZav[ID_Obj].ObjConstI[9] > 0 then //------ вариант с запросом согласия на СН
        begin
          if ObjZav[ID_Obj].bParam[10] then //----------- Есть запрос на смену направления
          begin
            if ObjZav[ID_Obj].bParam[15] then //----------- замыкание маршрута отправления
            begin
              InsArcNewMsg(ID_Obj,436+$4000,1);//"Установлен маршр.отпр.поезда на перегон"
              ShowShortMsg(436,LastX,LastY,ObjZav[ID_Obj].Liter);
              exit;
            end;
            InsArcNewMsg(ID_Obj,205+$4000,7);//- "Выдать согласие на смену направления $?"
            msg := GetShortMsg(1,205, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_DatSoglasieSmenyNapr;
            DspCommand.Obj := ID_Obj;
            DspMenu.WC := true;
            gotomenu := true;
            exit;
          end else //-----------------------------------  Нет запроса на смену направления
          begin
            InsArcNewMsg(ID_Obj,266+$4000,1);
            msg := GetShortMsg(1,266, ObjZav[ID_Obj].Liter,1);
            ShowShortMsg(266,LastX,LastY,ObjZav[ID_Obj].Liter);
          end;
          exit;
        end else //------------------------ вариант без запроса согласия смены направления
        begin
          InsArcNewMsg(ID_Obj,265+$4000,1);
          msg := GetShortMsg(1,265, ObjZav[ID_Obj].Liter,1);
          ShowShortMsg(265,LastX,LastY,ObjZav[ID_Obj].Liter);
//          SingleBeep := true;
        end;
        exit;
      end else
      begin //-------------------------------------------------- "перегон стоит по приему"
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
//------------------------------------------------ Подключение комплекта смены направления
function CreateDspMenu_KSN(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if not WorkMode.OtvKom then
  begin //--------------------------------- не нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,276+$4000,1);
    ResetCommands;
    ShowShortMsg(276,LastX,LastY,'');
    SimpleBeep;
    msg :=GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- Сбросить набор маршрута
    ResetTrace;
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- отмена -
    if ObjZav[ID_Obj].bParam[1] then
    begin //-------------------------------------------------------- отключить комплект СН
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
    begin //-------------------------------------------------------- отключить комплект СН
      InsArcNewMsg(ID_Obj,406+$4000,7);
      msg := GetShortMsg(1,406, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtklKSN;
      DspCommand.Obj := ID_Obj;
    end else
    begin //------------------------------------------------------- подключить комплект СН
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
//--------------------------------------------------------------------------- Увязка с ПАБ
function CreateDspMenu_PAB(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- отмена -
    WorkMode.MarhOtm := false;
    if ObjZav[ID_Obj].bParam[4] then
    begin //--------------------------------------------------- снять согласие отправления
      InsArcNewMsg(ID_Obj,279+$4000,7);
      msg := GetShortMsg(1,279, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtmenaSoglasieOtpravl;
      DspCommand.Obj := ID_Obj;
    end
    else exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.InpOgr then
    begin //------------------------------------------------------------- Ввод ограничений
      if ObjZav[ID_Obj].ObjConstB[8] or
      ObjZav[ID_Obj].ObjConstB[9] then //----------- есть закрытие движения на электротяге
      begin //---------------------------------------------------------- закрытие движения
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
        //----------------------------------------------- закрытие движения на электротяге
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
        ObjZav[ID_Obj].ObjConstB[9] then //----------------------- есть 2 вида электротяги
        begin  //----------------------- закрытие движения на электротяге постоянного тока
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
          //---------------------------- закрытие движения на электротяге переменного тока
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
      begin //------------------------------------------------------------ нет электротяги
        if ObjZav[ID_Obj].bParam[12] <> ObjZav[ID_Obj].bParam[13] then
        begin
          InsArcNewMsg(ID_Obj,207+$4000,7);
          InsArcNewMsg(ID_Obj,206+$4000,7);
          AddDspMenuItem(GetShortMsg(1,207, '',7), CmdMenu_OtkrytPeregonPAB,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,206, '',7), CmdMenu_ZakrytPeregonPAB,ID_Obj);
        end else
        begin
          if ObjZav[ID_Obj].bParam[13] or ObjZav[ID_Obj].bParam[12] then
          begin //--------------------------------------- Перегон закрыт - открыть перегон
            InsArcNewMsg(ID_Obj,207+$4000,7);
            msg := GetShortMsg(1,207, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_OtkrytPeregonPAB;
            DspCommand.Obj := ID_Obj;
          end else
          begin //--------------------------------------- Перегон открыт - закрыть перегон
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
      begin //------------------------------------------------------------------- режим ОК
        if not ObjZav[ID_Obj].bParam[1] then
        begin //-------------------------------------------------- перегон занят по приему
          if ObjZav[ID_Obj].bParam[3] then
          begin //------------------------------------------ выдать исполнительную команду
            InsArcNewMsg(ID_Obj,281+$4000,7);
            msg := GetShortMsg(1,281, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_IskPribytieIspolnit;
            DspCommand.Obj := ID_Obj;
          end else
          begin //----------------------------------------- выдать предварительную команду
            InsArcNewMsg(ID_Obj,280+$4000,7);
            msg := GetShortMsg(1,280, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_IskPribytiePredv;
            DspCommand.Obj := ID_Obj;
          end;
        end else
        begin //----------------------------------------- не требуется выдача иск.прибытия
          InsArcNewMsg(ID_Obj,298+$4000,7);
          ShowShortMsg(298,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end else
      if not ObjZav[ID_Obj].bParam[1] then
      begin //---------------------------------------------------- Перегон занят по приему
        if ObjZav[ID_Obj].bParam[2] then
        begin //--------------------------------- получено прибытие поезда - дать прибытие
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
      begin //----------------------------------------------- Перегон занят по отправлению
        InsArcNewMsg(ID_Obj,299+$4000,7);
        ShowShortMsg(299,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if ObjZav[ID_Obj].bParam[6] then
      begin //---------------------------------------------- Получено согласие отправления
        InsArcNewMsg(ID_Obj,326+$4000,7);
        ShowShortMsg(326,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      if not ObjZav[ID_Obj].bParam[7] then
      begin //------------------------------------------------------- Хозпоезд на перегоне
        InsArcNewMsg(ID_Obj,130+$4000,1);
        ShowShortMsg(130,LastX,LastY,ObjZav[ID_Obj].Liter);
        exit;
      end else
      begin //----------------------------------- Перегон свободен - выдать/снять согласие
        if ObjZav[ID_Obj].bParam[4] then
        begin //----------------------------------------------- снять согласие отправления
          InsArcNewMsg(ID_Obj,279+$4000,7);
          msg := GetShortMsg(1,279, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_OtmenaSoglasieOtpravl;
          DspCommand.Obj := ID_Obj;
        end else
        begin //------------------------------------------------ дать согласие отправления
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
//-------------------------------------------------- создание меню для управления стрелкой
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

	hvost := ObjZav[ID_Obj].BaseObject;   //-------------------------- объект хвоста стрелки
  SP_str := ObjZav[ID_Obj].UpdateObject;//------------------------------ объект СП стрелки
  AvPer := ObjZav[hvost].ObjConstI[13];//-------------- объект аварийного перевода стрелки

  //------- при активизации работы оператора со стрелкой снимаются автовозвратные признаки
  if ObjZav[hvost].ObjConstB[2] and //------------- если для стрелки заложен автовозврат и
  (ObjZav[hvost].bParam[3] or//------------------------ размыкание секции автовозврата или
  ObjZav[hvost].bParam[12]) then //------------------------- активна проверка автовозврата
  begin //------------------ при наличии возбужденных признаков автовозврата - сбросить их
    ObjZav[hvost].bParam[3] := false; //------ сброс признака размыкания стрелочной секции
    ObjZav[hvost].bParam[12] := false; // сброс признака активизации проверки автовозврата
    InsArcNewMsg(hvost,424+$4000,7);//------------------- "прерван автовозврат в охранное"
    AddFixMessage(GetShortMsg(1,424,ObjZav[hvost].Liter,7),4,1);
  end;

  //-------------- сначала работа с ответственными командами, для стрелок это нормализация
  if WorkMode.OtvKom then //----------------------------------------------- если нажата ОК
  begin //--------------------- нажата ОК - нормализовать признаки трассировки для стрелки
    InsArcNewMsg(ID_Obj,311+$4000,7); //--------------------------------- "нормализовать?"
    msg := GetShortMsg(1,311, 'стрелку '+ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams; //-----
    DspCommand.Obj := ID_Obj;
  end

	//------------------------------------------------------ сброс работы с отменой маршрута
  else
  if WorkMode.MarhOtm then //-------------------------- если ранее выбрана отмена маршрута
  begin //----------------------------------------------- Сбросить отмену маршрута и выйти
    WorkMode.MarhOtm := false;
    exit;
  end else

	//----------------------------------------------- сброс работы вспомогательного перевода
  if VspPerevod.Active then //------------------------------------- если активизирован ВСП
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);//------------ "отменено ожидание нажатия кнопки ВСП"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else

	//----------------------------------------------------------- сброс работы в трассировке
  if WorkMode.GoTracert then //--------------------------- если идет набор трассы маршрута
  begin
    ResetTrace; //---------------- Сбросить набранную трассу маршрута и структуры маршрута
    exit; //---------------------------------------------------------------------- и выйти
  end else

	//----------------------------------------------- возможная работа с установкой на макет
  if WorkMode.GoMaketSt then //----------------------- если было начало установки на макет
  begin
    if not ObjZav[SP_str].bParam[5] or //-------------------------------- если у СП МИ или
    ObjZav[SP_str].bParam[9] then      //----------------------------------------- у СП РМ
    begin //--- сообщить:"стрелка на местном управлении" прервать работу с макетом и выйти
      InsArcNewMsg(hvost,91+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(91,LastX,LastY,ObjZav[hvost].Liter);//"Стрелка $ на местном управлении"
      WorkMode.GoMaketSt := false; //----------- сброс признака работы по установке макета
      exit;
    end else
    if ObjZav[hvost].bParam[14] or//----------------------- стрелку замкнула программа или
    ObjZav[ID_Obj].bParam[10] or //--------------- признак первого прохода трассировки или
    ObjZav[ID_Obj].bParam[11] or//---------------- признак второго прохода трассировки или
    ObjZav[ID_Obj].bParam[12] or //------------------------ признак пошерстной в плюсе или
    ObjZav[ID_Obj].bParam[13] or //----------------------- признак пошерстной в минусе или
    ObjZav[ID_Obj].bParam[6] or //------------------------------------ есть признак ПУ или
    ObjZav[ID_Obj].bParam[7] then //-------------------------------------- есть признак МУ
    begin //------------- сообщить: "стрелка в маршруте" прервать работу с макетом и выйти
      InsArcNewMsg(hvost,511+$4000,1);
      WorkMode.GoMaketSt := false;
      ShowShortMsg(511,LastX,LastY,ObjZav[hvost].Liter);//--------- "Стрелка $ в маршруте"
      WorkMode.GoMaketSt := false; //----------- сброс признака работы по установке макета
      exit;
    end else
    if ObjZav[ID_Obj].bParam[1] or ObjZav[ID_Obj].bParam[2] then //--- если есть ПК или МК
    begin //------------------------ Есть контроль положения - отказ от установки на макет
      //--- "Нет сообщения о потере контроля положения стрелки $! Ошибка установки макета"
      InsArcNewMsg(hvost,92,1);
      ResetShortMsg;
      AddFixMessage(GetShortMsg(1,92,ObjZav[hvost].Liter,1),4,1);
      ShowShortMsg(92, LastX, LastY, ObjZav[hvost].Liter);
      WorkMode.GoMaketSt := false;
      exit;
    end else
    if ObjZav[hvost].bParam[26] and //-------------- если есть сообщение о потере контроля
    not(ObjZav[hvost].bParam[32] or ObjZav[ID_Obj].bParam[32])then //----- и все парафазно
    begin //----------------------------------- Запросить подтверждение установки на макет
      InsArcNewMsg(hvost,138+$4000,7); //------------------ Установить стрелку $ на макет?
      msg := GetShortMsg(1,138,ObjZav[hvost].Liter,7);
      DspCommand.Command := CmdMenu_UstMaketStrelki;
      DspCommand.Obj := ID_Obj;
    end else
    begin
      //--- "Нет сообщения о потере контроля положения стрелки $! Ошибка установки макета"
      InsArcNewMsg(hvost,92,1);
//      ResetShortMsg;
      AddFixMessage(GetShortMsg(1,92,ObjZav[hvost].Liter,1),4,1);
      ShowShortMsg(92, LastX, LastY, ObjZav[hvost].Liter);
      WorkMode.GoMaketSt := false;
      exit;
    end;
  end else

  //--------------------------------------------- возможна работа с установкой ограничений
  begin //---------------------------------------------------- если нет установки на макет
    if WorkMode.InpOgr then //------------------------------------------- ввод ограничений
    begin
      if ObjZav[ID_Obj].bParam[33] or ObjZav[ID_Obj].bParam[25 ] then // если автодействие
      begin //------------------------------------------------------ включено автодействие
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,431+$4000,1); //--- "включено автодействие"
        WorkMode.InpOgr := false;
        ShowShortMsg(431, LastX, LastY, '');
        exit;
      end else
      if ObjZav[ID_Obj].bParam[5] or //-------- если есть требование перевода охранной или
      ObjZav[ID_Obj].bParam[6] or //------------------------------------------ есть ПУ или
      ObjZav[ID_Obj].bParam[7] or //------------------------------------------ есть МУ или
      ObjZav[ID_Obj].bParam[8] or //---------------- идет ожидание перевода в охранное или
      ObjZav[ID_Obj].bParam[14] then //---------- есть признак программного замыкания АРМа
      begin //------------ стрелка в трассировке маршрута ограничения устанавливать нельзя
        InsArcNewMsg(ObjZav[ID_Obj].BaseObject,511+$4000,1);//------- "стрелка в маршруте"
        WorkMode.InpOgr := false;
        ShowShortMsg(511, LastX, LastY, ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
        exit;
      end else
      if not ObjZav[SP_str].bParam[5] or//------------------------------------ если МИ или
      ObjZav[SP_str].bParam[9] then //------------------------------------ есть признак РМ
      begin //-------------------------------------- ходовая стрелка на местном управлении
        InsArcNewMsg(hvost,91+$4000,1); //---------------------- "стрелка на местном упр."
        WorkMode.InpOgr := false;
        ShowShortMsg(91, LastX, LastY, ObjZav[hvost].Liter);
        exit;
      end else
      begin //---------- если нет соответствия по выключению стрелки в основном и в хвосте
        if ObjZav[ID_Obj].bParam[18] <> ObjZav[hvost].bParam[18] then //
        begin
          InsArcNewMsg(hvost,169+$4000,7); //--------------------- "включить управление ?"
          InsArcNewMsg(hvost,168+$4000,7); //-------------------- "отключить управление ?"
          AddDspMenuItem(GetShortMsg(1,169, '',7), CmdMenu_StrVklUpravlenie,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,168, '',7), CmdMenu_StrOtklUpravlenie,ID_Obj);
        end else //------------------------------------ если по отключению есть совпадение
        begin
          if ObjZav[ID_Obj].bParam[18] then //------- если стрелка выключена из управления
          begin
            InsArcNewMsg(hvost,169+$4000,7); //--------------------- Включить управление $
            AddDspMenuItem(GetShortMsg(1,169, '',7), CmdMenu_StrVklUpravlenie,ID_Obj);
          end else
          begin
            InsArcNewMsg(hvost,168+$4000,7); //----------------- Отключить от управления $
            AddDspMenuItem(GetShortMsg(1,168, '',7),CmdMenu_StrOtklUpravlenie,ID_Obj);
          end;
        end;

        //------------------------------------------- закрыть для движения стрелку (тип 2)
        if ObjZav[ID_Obj].ObjConstB[6] then //--------------------- если "дальняя" стрелка
        ogr := ObjZav[hvost].bParam[17]//--------- закрытие движения из хвоста для дальней
        else ogr :=ObjZav[hvost].bParam[16];//------- иначе закрытие из хвоста для ближней

        if ObjZav[ID_Obj].bParam[16] <> ogr then //---- если закр.стрелки не соотв. хвосту
        begin
          InsArcNewMsg(ID_Obj,171+$4000,7); //--------------------- "открыть для движения"
          InsArcNewMsg(ID_Obj,170+$4000,7); //--------------------- "закрыть для движения"
          AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_StrOtkrytDvizenie,ID_Obj);
          AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_StrZakrytDvizenie,ID_Obj);
        end else //----------------------- если соответствуют ограничения стрелки и хвоста
        begin
          if ObjZav[ID_Obj].bParam[16] then //------------------ если закрыта для движения
          begin
            InsArcNewMsg(ID_Obj,171+$4000,7); //------------------- "открыть для движения"
            AddDspMenuItem(GetShortMsg(1,171, '',7), CmdMenu_StrOtkrytDvizenie,ID_Obj);
          end else //---------------------------------------- если не закрыта для движения
          begin
            InsArcNewMsg(ID_Obj,170+$4000,7); //--------------------"закрыть для движения"
            AddDspMenuItem(GetShortMsg(1,170, '',7), CmdMenu_StrZakrytDvizenie,ID_Obj);
          end;
        end;

        if not ObjZav[ID_Obj].ObjConstB[10] then // если стрелка, а не сбрасывающий башмак
        begin //--- закрыть для движения противошерстных, если не является сбрас. башмаком
          if ObjZav[ID_Obj].ObjConstB[6] //----------------------- если это парная дальняя
          then ogr:= ObjZav[hvost].bParam[34]//--------------- взять из хвоста для дальней
          else ogr:=ObjZav[hvost].bParam[33];//--------- иначе взять из хвоста для ближней

          if ObjZav[ID_Obj].bParam[17] <> ogr then //------- закрытие не совпало с хвостом
          begin
            InsArcNewMsg(ID_Obj,450+$4000,7); //-- "открыть для противошерстного движения"
            InsArcNewMsg(ID_Obj,449+$4000,7); //-- "закрыть для противошерстного движения"
            AddDspMenuItem(GetShortMsg(1,450, '',7),CmdMenu_StrOtkrytProtDvizenie,ID_Obj);
            AddDspMenuItem(GetShortMsg(1,449, '',7),CmdMenu_StrZakrytProtDvizenie,ID_Obj);
          end else //------------------------------------------ если закрытие как в хвосте
          begin
            if ObjZav[ID_Obj].bParam[17] then //-------- если закрыта для противошерстного
            begin
              InsArcNewMsg(ID_Obj,450+$4000,7);//- "открыть для противошерстного движения"
              AddDspMenuItem(GetShortMsg(1,450,'',7),CmdMenu_StrOtkrytProtDvizenie,ID_Obj);
            end else
            begin
              InsArcNewMsg(ID_Obj,449+$4000,7);//- "закрыть для противошерстного движения"
              AddDspMenuItem(GetShortMsg(1,449,'',7),CmdMenu_StrZakrytProtDvizenie,ID_Obj);
            end;
          end;
        end;

        //--------------------------------- сбросить макет стрелки в случае развала макета
        if ObjZav[hvost].bParam[15] and //------------------------- если хвост на макете и
        (maket_strelki_index <> hvost) then //--------------------- в макете не та стрелка
        begin
          InsArcNewMsg(ObjZav[ID_Obj].BaseObject,172+$4000,7);//- "снять с макета стрелку"
          AddDspMenuItem(GetShortMsg(1,172, '',7),CmdStr_ResetMaket,ID_Obj);
        end;
      end;
    end else

    //------------------------------------------------------ если не установка ограничений
    if not ObjZav[hvost].bParam[31] then //----------------- если нет активности по хвосту
    begin //---------------------------------------------------------- нет данных в канале
      InsArcNewMsg(ID_Obj,255+$4000,7); //--- "отсутствует информация о положении стрелки"
      VspPerevod.Active := false; //----------- снять активность вспомогательного перевода
      WorkMode.VspStr := false;  //----- выключить режим вспомогательного перевода стрелки
      ShowShortMsg(255, LastX, LastY, ObjZav[ObjZav[ID_Obj].BaseObject].Liter);
      exit;
    end else

    //---------------------------------------------- далее, если есть активность по хвосту
    if ObjZav[hvost].bParam[4] or // если есть дополнительное замыкание хвоста стрелки или
    ObjZav[ID_Obj].bParam[4] or //------------ есть дополнительное замыкание в стрелке или
    not ObjZav[hvost].bParam[21] then //-------------------- есть замыкание в хвосте от СП
    begin //------------------------------------------ "стрелка замкнута,перевод запрещен"
      ShowWarning := true;
      msg := GetShortMsg(1,147,ObjZav[hvost].Liter,1);
      InsArcNewMsg(hvost,147+$4000,1);
      exit;
    end else //-------------------------------------------------- далее,если нет замыканий
    if ObjZav[ID_Obj].bParam[18] or //------------------------- если выключена стрелка или
    ObjZav[hvost].bParam[18] then //--------------------------------------- выключен хвост
    begin //-------------------------- "стрелка выключена из управления, перевод запрещен"
      InsArcNewMsg(hvost,151+$4000,7);
      ShowShortMsg(151,LastX,LastY,ObjZav[hvost].Liter);
      msg := GetShortMsg(1,151,ObjZav[hvost].Liter,7);
      exit;
    end else //-------------------------------------------------- далее, если не выключена
    if ObjZav[AvPer].bParam[1] then // если в объекте аварийного перевода есть признак ГВК
    begin
      if WorkMode.VspStr then //-------------- если есть признак вспомогательного перевода
      begin
        InsArcNewMsg(hvost,411+$4000,7);//---- "нарушен порядок вспомог. перевода стрелки"
        ShowShortMsg(411,LastX,LastY,ObjZav[hvost].Liter);
        msg := GetShortMsg(1,411,ObjZav[hvost].Liter,7);
        exit;
      end else //----------------------------- если нет признака вспомогательного перевода
      begin
        //--------- "Нажата кнопка вспомогательного перевода. Перевод стрелки $ запрещен!"
				InsArcNewMsg(hvost,139+$4000,1);
        ShowShortMsg(139,LastX,LastY,ObjZav[hvost].Liter);
        exit;
      end;
    end else //---------------------------------------------- далее, если нет признака ГВК
    if ObjZav[hvost].bParam[14] or//----------------------- если программное замыкание или
    ObjZav[hvost].bParam[23] then //----------------------------- трасировака как охранной
    begin //----- стрелка трассируется в маршруте  - предупредить, затем запросить перевод
      InsArcNewMsg(hvost,240+$4000,7); //---------------- "стрелка в маршруте,продолжать?"
      msg := GetShortMsg(1,240,ObjZav[hvost].Liter,7);
      ShowWarning := true;
      DspCommand.Command := CmdStr_AskPerevod;
      DspCommand.Obj := ID_Obj;
    end else //------------------------ если нет программного замыкания стрелки в маршруте
    begin //---------------------------------------------------- запрос на перевод стрелки
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
//----------------------------- создание меню для управления объектом "Маневровая колонка"
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
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.InpOgr then
  WorkMode.InpOgr := false //----------------------------------- Сбросить ввод ограничений
  else
  if WorkMode.GoTracert then
  begin //-------------------------------------------------------- Сбросить набор маршрута
    ResetTrace; DspCommand.Command := 0;
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //----------------------------------------------------------------------- отмена -
    WorkMode.MarhOtm := false;
    if ObjZav[ID_Obj].bParam[8] then
    begin //---------------------------------- выдана РМ - отменить или остановить маневры
      if ObjZav[ID_Obj].bParam[3] then
      begin //---------------------------------------------------- маневры еще не замкнуты
        InsArcNewMsg(ID_Obj,218+$4000,7);
        msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- маневры замкнуты
        if ObjZav[ID_Obj].bParam[5] then //---------------------- есть восприятие маневров
        begin //------------------------------------------------------- остановить маневры
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
    begin //------------------------------------------- есть РМ или РМК - отменить маневры
      if ObjZav[ID_Obj].bParam[5] and
      not ObjZav[ID_Obj].bParam[3] then //------------------ есть восприятие маневров и МИ
      begin //--------------------------------------------------------- остановить маневры
        InsArcNewMsg(ID_Obj,446+$4000,7);
        msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ проверить условия отмены маневров
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ нет условий для отмены - остановить маневры
          InsArcNewMsg(ID_Obj,446+$4000,7);
          msg := msg + '! ' + GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
        end else
        begin //--------------------------------------------------------- отменить маневры
          InsArcNewMsg(ID_Obj,218+$4000,7);
          msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
        end;
      end;
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    if not ObjZav[ID_Obj].bParam[3] and not ObjZav[ID_Obj].bParam[5] then
    begin //-------------- есть МИ и снято восприятие маневров - запустить отмену маневров
      InsArcNewMsg(ID_Obj,218+$4000,7);
      msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    if ObjZav[ID_Obj].bParam[5] then //---------------------- не снято восприятие маневров
    begin //--------------------------------------------------------------------- отказать
      InsArcNewMsg(ID_Obj,269+$4000,7);
      ShowShortMsg(269,LastX,LastY, ObjZav[ID_Obj].Liter); exit;
    end;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,220+$4000,7);
        msg := GetShortMsg(1,220, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolIRManevrov;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsArcNewMsg(ID_Obj,219+$4000,7);
        msg := GetShortMsg(1,219, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvIRManevrov;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    if ObjZav[ID_Obj].bParam[8] then
    begin //------------------------------------------------- выдана РМ - отменить маневры
      if ObjZav[ID_Obj].bParam[3] then
      begin //---------------------------------------------------- маневры еще не замкнуты
        InsArcNewMsg(ID_Obj,218+$4000,7);
        msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
      end else
      begin //----------------------------------------------------------- маневры замкнуты
        if ObjZav[ID_Obj].bParam[5] then //---------------------- есть восприятие маневров
        begin //------------------------------------------------------- остановить маневры
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
    begin //------------------------------------------- есть РМ или РМК - отменить маневры
      if ObjZav[ID_Obj].bParam[5] and
      not ObjZav[ID_Obj].bParam[3] then //------------------ есть восприятие маневров и МИ
      begin //--------------------------------------------------------- остановить маневры
        InsArcNewMsg(ID_Obj,446+$4000,7);
        msg := GetShortMsg(1,446, ObjZav[ID_Obj].Liter,7);
      end else
      begin //------------------------------------------ проверить условия отмены маневров
        msg := VytajkaCOT(ID_Obj);
        if msg <> '' then
        begin //------------------------------ нет условий для отмены - остановить маневры
          InsArcNewMsg(ID_Obj,446+$4000,1);
          msg := msg + '! ' + GetShortMsg(1,446, ObjZav[ID_Obj].Liter,1);
        end else
        begin //--------------------------------------------------------- отменить маневры
          InsArcNewMsg(ID_Obj,218+$4000,7);
          msg := GetShortMsg(1,218, ObjZav[ID_Obj].Liter,7);
        end;
      end;
      DspCommand.Command := CmdMenu_OtmenaManevrov;
      DspCommand.Obj := ID_Obj;
    end else
    begin //------------------------------- нет РМ - проверить условия передачи на маневры
      if ObjZav[ID_Obj].bParam[3] then
      begin //--------------------------------------------------------------------- нет МИ
        if VytajkaRM(ID_Obj) then
        begin
          if MarhTracert[1].WarCount > 0 then
          begin
            MessCount :=Marhtracert[1].WarCount;//число предупрежд. при установке маршрута
            MessObj :=  MarhTracert[1].WarObject[MessCount];//объект сообщ. предупреждения
            WarObj := MarhTracert[1].WarIndex[MessCount];//индекс сообщения предупреждения
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
        begin //-------------------------- вывести сообщение об отказе передачи на маневры
          InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]+$4000,7);
          PutShortMsg(1,LastX,LastY,MarhTracert[1].Msg[1]);
          exit;
        end;
      end else
      begin //-------------------------------------------------------------------- есть МИ
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
//------------------------------------------ создание меню для объекта "Замыкание стрелок"
function CreateDspMenu_ZamykanieStrelok(ID,X,Y : SmallInt): boolean;
begin //---------------------------------------------------------------- Замыкание стрелок
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,7);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,7);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0; exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
     if WorkMode.OtvKom then
     begin //------------------------------------ нажата ОК - прекратить формирование команды
        InsArcNewMsg(ID_Obj,283+$4000,1);
        ResetCommands;
        ShowShortMsg(283,LastX,LastY,'');
        msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
        exit;
     end else
    begin //-------------------------------------------------------------------- Замыкание
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
//----------------------------------------- создание меню для объекта "Размыкание стрелок"
function CreateDspMenu_RazmykanieStrelok(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,191+$4000,7);
        msg := GetShortMsg(1,191, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolRazmykanStrelok;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsArcNewMsg(ID_Obj,190+$4000,7);
        msg := GetShortMsg(1,190, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvRazmykanStrelok;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//------------------------------------------------------------------------ Закрыть переезд
function CreateDspMenu_ZakrytPereezd(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0; exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    InsArcNewMsg(ID_Obj,192+$4000,7);
    msg := GetShortMsg(1,192, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_ZakrytPereezd;
    DspCommand.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------ Создание меню для объекта "Открытие переезда"
function CreateDspMenu_OtkrytPereezd(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //======================================================= Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,194+$4000,7);
        msg := GetShortMsg(1,194, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsArcNewMsg(ID_Obj,193+$4000,7);
        msg := GetShortMsg(1,193, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtkrytPereezd;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//----------------------------------------------- создание меню для "Извещения на переезд"
function CreateDspMenu_IzvesheniePereezd(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin // это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    result := false;
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if ObjZav[ID_Obj].bParam[11] then
    begin //-------------------------------------------------------------- снять извещение
      InsArcNewMsg(ID_Obj,196+$4000,7);
      msg := GetShortMsg(1,196, ObjZav[ID_Obj].Liter,7);
      if ID <> IDMenu_IzvesheniePereezd1
      then DspCommand.Command := CmdMenu_SnatIzvecheniePereezd
      else DspCommand.Command := CmdMenu_SnatIzvecheniePereezd1;
      DspCommand.Obj := ID_Obj;
    end else
    begin //--------------------------------------------------------------- дать извещение
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
//---------------------------- создание меню для управления объектом "Поездное оповещение"
function CreateDspMenu_PoezdnoeOpoveshenie(ID,X,Y : SmallInt): boolean;
begin //-------------------------------------------------------------- Поездное оповещение
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if ObjZav[ID_Obj].TypeObj = 36 then bit_for_kom := 1
  else bit_for_kom := 2;
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin //---------------------------------- нажата ОК - прекратить формирование команды
      InsArcNewMsg(ID_Obj,283+$4000,1);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
      exit;
    end else
    if WorkMode.MarhOtm then
    begin //----------------------------------------------------- Сбросить отмену маршрута
      WorkMode.MarhOtm := false;
      if ObjZav[ID_Obj].bParam[bit_for_kom] then
      begin //------------------------------------------------------- отключить оповещение
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
      begin //------------------------------------------------------- отключить оповещение
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
      begin //-------------------------------------------------------- включить оповещение
        InsArcNewMsg(ID_Obj,197+$4000,7);  //----------------------- включить оповещение ?
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
//-------------------------------- Создание меню для управления объектом "Запрет монтерам"
function CreateDspMenu_ZapretMonteram(ID,X,Y : SmallInt): boolean;
begin// Запрет монтерам
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,7);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,7);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom or (not ObjZav[ID_Obj].bParam[1]) then
    begin
      if ObjZav[ID_Obj].ObjConstB[1] then
      begin
        if ObjZav[ID_Obj].bParam[2] then
        begin
          if not ObjZav[ID_Obj].bParam[1] then
          begin //---------------------------------------------- отключить запрет монтерам
            InsArcNewMsg(ID_Obj,200+$4000,7);
            msg := GetShortMsg(1,200, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_SnatZapretMonteram;
            DspCommand.Obj := ID_Obj;
          end else
          begin //----------------------------------------------- включить запрет монтерам
            InsArcNewMsg(ID_Obj,199+$4000,7);
            msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter,7);
            DspCommand.Command := CmdMenu_DatZapretMonteram;
            DspCommand.Obj := ID_Obj;
          end;
        end else
        begin //------------------------- оповещение выключено - нельзя управлять запретом
          InsArcNewMsg(ID_Obj,483+$4000,1);
          ShowShortMsg(483,LastX,LastY,'');
          exit;
        end;
      end else
      begin
        if ObjZav[ID_Obj].bParam[1] then
        begin //------------------------------------------------ отключить запрет монтерам
          InsArcNewMsg(ID_Obj,200+$4000,7);
          msg := GetShortMsg(1,200, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_SnatZapretMonteram;
          DspCommand.Obj := ID_Obj;
        end else
        begin //------------------------------------------------- включить запрет монтерам
          InsArcNewMsg(ID_Obj,199+$4000,7);
          msg := GetShortMsg(1,199, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_DatZapretMonteram;
          DspCommand.Obj := ID_Obj;
        end;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//------------------------------ создание меню для управления отключением запрета монтерам
function CreateDspMenu_Otkl_ZapretMonteram(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //======================================================= Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //----------------------------------------------------- исполнительная команда
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,528+$4000,7);
        msg := GetShortMsg(1,528, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end else
      begin //---------------------------------------------------- предварительная команда
        InsArcNewMsg(ID_Obj,527+$4000,7);
        msg := GetShortMsg(1,527, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_PredvOtklZapMont;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//----------------------------------------------------- создание меню для управления УКСПС
function CreateDspMenu_VykluchenieUKSPS(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end;
  //--------------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- исполнительная команда
      OtvCommand.SObj := ID_Obj;
      InsArcNewMsg(ID_Obj,202+$4000,7);
      msg := GetShortMsg(1,202, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_IspolOtkluchenieUKSPS;
      DspCommand.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- если 1-ый или 2-ой датчик
    //if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
    begin //------------------------------------- сработал УКСПС - предварительная команда
      InsArcNewMsg(ID_Obj,201+$4000,7);
      msg := GetShortMsg(1,201, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_PredvOtkluchenieUKSPS;
      DspCommand.Obj := ID_Obj;
    end;
  end
  else
  begin //--------------------------------------- не нажата ОК - сбросить блокировку УКСПС
    if ObjZav[ID_Obj].bParam[1] and ObjZav[ID_Obj].ObjConstB[1] then
    begin //--------------- Есть команда отмены и УКСПС заблокирован - сбросить блокировку
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
//-------------------------- создание меню для управления объектом "Вспомогательный прием"
function CreateDspMenu_VspomPriem(ID,X,Y : SmallInt): boolean;
begin //------------------------------------------------------------ Вспомогательный прием
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //-------------------------------------------------- исполнительная команда ВП
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,211+$4000,7);
        msg := GetShortMsg(1,211, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolVspomPriem;
        DspCommand.Obj := ID_Obj;
      end else
      begin
        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[6] then //ключ-жезл вставлен в аппарат
        begin //----------------------------------------------- предварительная команда ВП
          InsArcNewMsg(ID_Obj,210+$4000,7);
          msg := GetShortMsg(1,210, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_PredvVspomPriem;
          DspCommand.Obj := ID_Obj;
        end else
        begin //----------------------------------------------------- КЖ изъят из аппарата
          InsArcNewMsg(ID_Obj,337+$4000,1);
          ShowShortMsg(357,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end;
    end else
    begin //------------------------------- не нажата ОК - прекратить формирование команды
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
//-------------------------------- создание меню для объекта "Вспомогательное отправление"
function CreateDspMenu_VspomOtpravlenie(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      if WorkMode.GoOtvKom then
      begin //-------------------------------------------------- исполнительная команда Во
        OtvCommand.SObj := ID_Obj;
        InsArcNewMsg(ID_Obj,209+$4000,7);
        msg := GetShortMsg(1,209, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_IspolVspomOtpravlenie;
        DspCommand.Obj := ID_Obj;
      end else
      begin //--------------------------------------------------------------- проверить КЖ
        if ObjZav[ObjZav[ID_Obj].BaseObject].bParam[6] then //ключ-жезл вставлен в аппарат
        begin //----------------------------------------------- предварительная команда Во
          InsArcNewMsg(ID_Obj,208+$4000,7);
          msg := GetShortMsg(1,208, ObjZav[ID_Obj].Liter,7);
          DspCommand.Command := CmdMenu_PredvVspomOtpravlenie;
          DspCommand.Obj := ID_Obj;
        end else
        begin //----------------------------------------------------- КЖ изъят из аппарата
          InsArcNewMsg(ID_Obj,357+$4000,1);
          ShowShortMsg(357,LastX,LastY,ObjZav[ID_Obj].Liter);
          exit;
        end;
      end;
    end else
    begin //----------------------------- не нажата ОК - прекратить формирование команды
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
//-------------------------------------------- создание меню для объекта "Очистка стрелок"
function CreateDspMenu_OchistkaStrelok(ID,X,Y : SmallInt): boolean;
begin //------------------------------------------------------------------ Очистка стрелок
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}  ID_ViewObj := ID_Obj; exit;  {$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
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
      begin //------------------------------------------------------------ вытащить кнопку
        InsArcNewMsg(ID_Obj,5+$4000,7);
        msg := MsgList[ObjZav[ID_Obj].ObjConstI[5]];
        DspCommand.Command := CmdMenu_OtklOchistkuStrelok;
        DspCommand.Obj := ID_Obj;
      end else
      begin //-------------------------------------------------------------- нажать кнопку
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
//-------------------------------------------------------- Включение выдержки времени ГРИ1
function CreateDspMenu_VkluchenieGRI1(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,''); exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then //--------------------------------- Если ответственные команды
    begin //--------------------------------------------------------------- выдать команду
      if ObjZav[ID_Obj].bParam[2] then
      begin //----------------------------------- уже включена выдержка времени ИР - отказ
        InsArcNewMsg(ID_Obj,335+$4000,1);
        ShowShortMsg(335,LastX,LastY,ObjZav[ID_Obj].Liter);
//        SingleBeep := true;
        exit;
      end else
      begin //------------------------------------------------------------- выдать команду
        msg := '';
        if ObjZav[ID_Obj].ObjConstI[3] <> 0 then
        begin
          //--------------------------------- не выбраны секции для ИР,дать предупреждение
          InsArcNewMsg(ID_Obj,214+$4000,7);
          if not ObjZav[ID_Obj].bParam[3] then msg := GetShortMsg(1,264,'',1) + ' ';
        end;
        msg := msg + GetShortMsg(1,214, ObjZav[ID_Obj].Liter,7);
        DspCommand.Command := CmdMenu_VkluchenieGRI;
        DspCommand.Obj := ID_Obj;
      end;
    end else
    begin //----------------------------------------------------- не ответственная команда
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
//--------------------------------------- Участок извещения из тупика, Путь без ограждения
function CreateDspMenu_PutManevrovyi(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------- ОК - нормализовать признаки трассировки для пути
    InsArcNewMsg(ID_Obj,311+$4000,7);
    msg := GetShortMsg(1,311, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMarsh_ResetTraceParams;
    DspCommand.Obj := ID_Obj;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9,'',1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  if ObjZav[ID_Obj].bParam[19] then
  begin //------------------------------------------ Восприятие диагностического сообщения
    ObjZav[ID_Obj].bParam[19] := false;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
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
//---------------------------------------------------------------- Питание ламп светофоров
function CreateDspMenu_RezymPitaniyaLamp(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if not WorkMode.OtvKom then
  begin //--------------------------------- не нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,276+$4000,1); //- действие требует нажатия кнопки ответств. команд
    ResetCommands;
    SimpleBeep;
    ShowShortMsg(276,LastX,LastY,'');
    msg := GetShortMsg(1,276, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1); //-- "отменено ожидание нажатия кнопки Всп.перевода"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    msg := GetShortMsg(1,149, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then //----- при установке стрелки на макет или
  begin                                     //--------- работе с ограничениями для стрелки
    InsArcNewMsg(ID_Obj,9+$4000,1);//------------------------------------ "это не стрелка"
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then //-------------------------------- при наборе трассы маршрута
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin
    if not ObjZav[ID_Obj].bParam[1]  then
    begin
      InsArcNewMsg(ID_Obj,546+$4000,7);   //------------------------ "включить режим ДСН?"
      msg := GetShortMsg(1,546,'',7);
      DspCommand.Command := CmdMenu_VklDSN;
    end else
    begin
      InsArcNewMsg(ID_Obj,547+$4000,7);   //----------------------- "отключить режим ДСН?"
      msg := GetShortMsg(1,547,'',7);
      DspCommand.Command := CmdMenu_OtklDSN;
    end;
    DspCommand.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//-------------------------------------------------------------- Включение дневного режима
function CreateDspMenu_RezymLampDen(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);     //--------------------------- "Нажата кнопка ОК"
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1); //--- "Отменено ожидание нажатия кнопки Всп.перевод"
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      InsArcNewMsg(ID_Obj,283+$4000,7);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,7);
      exit;
    end else
    begin
      InsArcNewMsg(ID_Obj,221+$4000,7);   //------------------- "включить дневной режим ?"
      msg := GetShortMsg(1,221, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_VkluchitDen;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//--------------------------------------------------------------- Включение ночного режима
function CreateDspMenu_RezymLampNoch(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    if WorkMode.OtvKom then
    begin
      InsArcNewMsg(ID_Obj,283+$4000,7);
      ResetCommands;
      ShowShortMsg(283,LastX,LastY,'');   //----------- Нажата кнопка ответственных команд
      msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,7);
      exit;
    end else
    begin
      InsArcNewMsg(ID_Obj,222+$4000,7);
      msg := GetShortMsg(1,222, ObjZav[ID_Obj].Liter,7);// Включить ночной режим (ручной)?
      DspCommand.Command := CmdMenu_VkluchitNoch;
      DspCommand.Obj := ID_Obj;
    end;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;

//========================================================================================
//------------------------------------------------------- Включение автоматического режима
function CreateDspMenu_RezymLampAuto(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    result := false;
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
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
//--------------------------------------------------------- исключение УКГ из зависимостей
function CreateDspMenu_OtklUKG(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end;
  //--------------------------------------------------------------------- нормальный режим
  if WorkMode.OtvKom then
  begin
    if WorkMode.GoOtvKom then
    begin //------------------------------------------------------- исполнительная команда
      OtvCommand.SObj := ID_Obj;
      InsArcNewMsg(ID_Obj,565+$4000,7);
      msg := GetShortMsg(1,565, ObjZav[ID_Obj].Liter,7);
      DspCommand.Command := CmdMenu_IspolOtkluchenieUKG;
      DspCommand.Obj := ID_Obj;
    end
    else
    //---------------------------------------------------------- если 1-ый или 2-ой датчик
    //if ObjZav[ID_Obj].bParam[3] or ObjZav[ID_Obj].bParam[4] then
    begin //------------------------------------- сработал УКГ - предварительная команда
      InsArcNewMsg(ID_Obj,564+$4000,7);
      msg := GetShortMsg(1,564, ObjZav[ID_Obj].Liter,7);
      ShowShortMsg(564,LastX,LastY,'');
      DspCommand.Command := CmdMenu_PredvOtkluchenieUKG;
      DspCommand.Obj := ID_Obj;
    end;
  end
  else
  begin //------------------------------------------------ не нажата ОК - сбросить команду
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
//------------------------------------------------------------ включение УКГ в зависимости
function CreateDspMenu_VklUKG(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj; exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,'');
    msg := GetShortMsg(1,283, ObjZav[ID_Obj].Liter,1);
    exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, ''); exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    result := false;
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
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
//---------------------------------------------------------------- Выключение звонка УКСПС
function CreateDspMenu_OtklZvonkaUKSPS(ID,X,Y : SmallInt): boolean;
begin
  DspMenu.obj := cur_obj;
  result := true;
{$IFNDEF RMDSP}
  ID_ViewObj := ID_Obj;
  exit;
{$ELSE}
  if WorkMode.OtvKom then
  begin //------------------------------------ нажата ОК - прекратить формирование команды
    InsArcNewMsg(ID_Obj,283+$4000,1);
    ResetCommands;
    ShowShortMsg(283,LastX,LastY,''); exit;
  end else
  if VspPerevod.Active then
  begin //------------------------------------------------ Сброс вспомогательного перевода
    InsArcNewMsg(ID_Obj,149+$4000,1);
    VspPerevod.Active := false;
    WorkMode.VspStr := false;
    ShowShortMsg(149, LastX, LastY, '');
    exit;
  end else
  if WorkMode.MarhOtm then
  begin //------------------------------------------------------- Сбросить отмену маршрута
    WorkMode.MarhOtm := false;
    exit;
  end else
  if WorkMode.GoMaketSt or WorkMode.VspStr then
  begin //----------------------------------------------------------------- это не стрелка
    InsArcNewMsg(ID_Obj,9+$4000,1);
    msg := GetShortMsg(1,9, ObjZav[ID_Obj].Liter,1);
    ShowShortMsg(9,LastX,LastY,'');
    exit;
  end else
  if WorkMode.GoTracert then
  begin
    ResetTrace; //------------------------------------------------ Сбросить набор маршрута
    DspCommand.Command := 0;
    exit;
  end else
  begin //--------------------------------------------------------------- нормальный режим
    InsArcNewMsg(ID_Obj,203+$4000,7);
    msg := GetShortMsg(1,203, ObjZav[ID_Obj].Liter,7);
    DspCommand.Command := CmdMenu_OtklZvonkaUKSPS;
    DspCommand.Obj := ID_Obj;
  end;
  DspMenu.WC := true;
{$ENDIF}
end;
//========================================================================================
//---------------------------------------------------------------------- формирование меню
procedure MakeMenu(var X : smallint);
var
  i,j : integer;
begin   //------------------------------------------------------------ формирование меню
{$IFDEF RMDSP}
  if DspMenu.Count > 0 then //---------------------------------- если есть что-то для меню
  begin
    TabloMain.PopupMenuCmd.Items.Clear; //---------------------------- очистить меню табло
    for i := 1 to DspMenu.Count
    do TabloMain.PopupMenuCmd.Items.Add(DspMenu.Items[i].MenuItem);//взять меню из DspMenu
    i := configRU[config.ru].Tablo_Size.Y - 10;
    SetCursorPos(x,i);
    TabloMain.PopupMenuCmd.Popup(X, i+3-17*DspMenu.Count);
  end  else
  begin //---------------------------- Вывести подсказку перед выполнением простой команды
    j := x div configRU[config.ru].MonSize.X + 1; //-------------------- Найти номер табло
    for i := 1 to Length(shortMsg) do
    begin
      if i = j then //--------- если это то табло, которое соответствует району управления
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
