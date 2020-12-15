unit Marshrut;
//------------------------------------------------------------------------------
//
//             Процедуры и структуры установки маршрутов РМ-ДСП
//
// Веросия                   - 1
// Редакция                  - 5
// Дата последних изменений  - 22 августа 2006г.
//------------------------------------------------------------------------------

interface

uses
  SysUtils,
  TypeRpc;

// Константы, возращаемые процедурой StepTrace
Type
  TTracertResult = (
    trStop,     // Конец трассировки из-за обнаружения враждебностей
    trNextStep, // Требуется сделать следующий шаг
    trEndTrace, // Конец трассировки из-за обнаружения конца маршрута
    trBreak,    // Приостановить продвижение по объектам
    trEnd,      // Конец трассировки фрагмента
    trRepeat    // Требуется вернуться к предидущим стрелкам для поиска трассы по отклонению
  );

// Уровни трассировки маршрута
Type
  TTracertLevel = (
    tlFindTrace,    // Проверка существования трассы маршрута между заданными объектами
    tlContTrace,    // Довести трассу до предполагаемого конца или отклоняющей стрелки
    tlVZavTrace,    // Проверка взаимозависимостей по трассе (охранности и прочее)
    tlCheckTrace,   // проверка враждебностей по трассе маршрута
    tlZamykTrace,   // замыкание трассы маршрута, сбор положения отклоняющих стрелок трассы
    tlSignalCirc,   // Сигнальная струна (повторное открытие сигнала, отмена маршрута)
    tlOtmenaMarh,   // Отмена маршрута, замкнутого исполнительными устройствами или сервером
    tlRazdelSign,   // Открыть сигнал в раздельном режиме
    tlFindIzvest,   // Собрать известитель перед отменой маршрута
    tlFindIzvStrel, // Проверка наличия незамкнутых стрелок на предмаршрутном участке
    tlStepBack,     // сделать откат назад по трассе маршрута
    tlPovtorMarh,   // Повторная установка маршрута
    tlPovtorRazdel, // Повторное открытие предварительно замкнутого маршрута в режиме раздельного управления
    tlAutoTrace,    // Открыть сигнал в маршруте автодействия
    tlNone
  );

// Структура трассировки маршрута
type
  TMarhTracert = record
    ObjStart    : SmallInt;                     // Объект начала маршрута
    ObjTrace    : array[1..1000] of SmallInt;   // Список промежуточных точек по трассе
    StrTrace    : array[1..24] of SmallInt;     // Список индексов отклоняющих стрелок маршрута
    PolTrace    : array[1..24,1..2] of Boolean; // Список положений отклоняющих стрелок маршрута
    StrCount    : Byte;                         // Счетчик отклоняющих стрелок маршрута
    ObjEnd      : SmallInt;                     // Объект конца маршрута
    ObjLast     : SmallInt;                     // Объект для трассировки конца маршрута
    PinLast     : Byte;                         // Точка откуда ведется поиск трассы до следующего объекта маршрута
    ObjPrev     : SmallInt;                     // Объект конца предыдущей трассироки
    PinPrev     : Byte;                         // Точка конца предыдущей трассировки
    Rod         : Byte;                         // Род маршрута
    Counter     : SmallInt;                     // Счетчик элементов маршрута
    CIndex      : SmallInt;                     // Указатель на текущий объект проверок (после трассировки)
    HTail       : SmallInt;                     // Объект на хвосте трассы, определенный оператором
    Finish      : Boolean;                      // Разрешение нажать кнопку конца набора
    FindTail    : Boolean;                      // Признак набора строки сообщения о конце трассы маршрута
    Level       : TTracertLevel;                // Этап трассировки маршрута
    PutPO       : Boolean;                      // Признак трассировки в пути
    FullTail    : Boolean;                      // Признак полноты добора хвоста маршрута
    FindNext    : Boolean;                      // Признак необходимости проверки возможности продолжения
    LvlFNext    : Boolean;                      // Признак модификации процедур поиска трассы tlFindTrace для поиска возможности установки следующего маршрута
    Msg         : array[1..1000] of string;     // сообщение враждебности
    MsgIndex    : array[1..1000] of smallint;   // индекс сообщения враждебности
    MsgObject   : array[1..1000] of smallint;   // индекс объекта сообщения враждебности
    MsgCount    : Integer;                      // Счетчик сообщений трассировки
    MarhCmd     : array[1..10] of Byte;         // Маршрутная команда
    Warning     : array[1..1000] of string;     // предупреждения при установке маршрута
    WarIndex    : array[1..1000] of smallint;   // индекс сообщения предупреждения
    WarObject   : array[1..1000] of smallint;   // индекс объекта сообщения предупреждения
    WarCount    : Integer;                      // Счетчик предупреждений при установке маршрута
    TailMsg     : string;                       // сообщение в хвосте маршрута
    Dobor       : Boolean;                      // признак проверки возможности набора маршрута в продолжение трассируемого
    IzvCount    : SmallInt;                     // счетчик блок-участков для сборки схемы извещения
    IzvStrNZ    : Boolean;                      // признак наличия незамкнутых стрелок на предмаршрутном участке
    IzvStrFUZ   : Boolean;                      // признак занятости участка "первым" составом
    IzvStrUZ    : Boolean;                      // признак наличия занятых секций на предмаршрутном участке
    PutNadviga  : SmallInt;                     // индекс объекта надвига, на который выполняется трассировка маршрута
    VP          : SmallInt;                     // объект ВП для трассировки маршрута приема
    Povtor      : Boolean;                      // признак повторной проверки трассы маршрута (для снятия контроля предварительного замыкания на АРМе)
    LockPovtor  : Boolean;                      // признак блокировки выдачи повторной установки маршрута после обнаружения враждебностей
    GonkaStrel  : Boolean;                      // признак допустимости выдачи команды гонки стрелок для трассы маршрута без замыкания трассы
    GonkaList   : SmallInt;                     // количество стрелок для выдачи команды гонки стрелок для трассы маршрута без замыкания трассы
    RodTjagi    : Byte;                         // Род тяги подвижного состава
    AutoMarh    : Boolean;                      // признак трассировки маршрута автодействия сигнала
    SvetBrdr    : SmallInt;                     // индекс светофора, ограждающий элементарный участок
    TraceRazdel : Boolean;                      // признак трассировки в раздельном управлении
  end;

var
  MarhTracert  : array[1..10] of TMarhTracert; // структуры трассировки маршрута
  MarhRdy      : Boolean;                      // признак готовности маршрута к выдаче в канал
  LastMsgToDSP : string;
  LastJmp : TOZNeighbour;

function ResetTrace : Boolean;
function ResetMarhrutSrv(fr : word) : Boolean;
function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
function EndTracertMarshrut : Boolean;
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
function GetSoglOtmeny(Uslovie : SmallInt) : string;
function OtmenaMarshruta(Svetofor : SmallInt; Marh : Byte) : Boolean;
function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
function SetProgramZamykanie(Group : Byte) : Boolean;
function SendMarshrutCommand(Group : Byte) : Boolean;
function SendTraceCommand(Group : Byte) : Boolean;
function RestorePrevTrace : Boolean;
function AddToTracertMarshrut(index : SmallInt) : Boolean;
function NextToTracertMarshrut(index : SmallInt) : Boolean;
function StepTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte; Group : Byte) : TTracertResult;
function SoglasieOG(Index : SmallInt) : Boolean;
function CheckOgrad(ptr : SmallInt; Group : Byte) : Boolean;
function CheckOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
function NegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
function SignCircOgrad(ptr : SmallInt; Group : Byte) : Boolean;
function SignCircOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
function VytajkaRM(ptr : SmallInt) : Boolean;
function VytajkaZM(ptr : SmallInt) : Boolean;
function VytajkaOZM(ptr : SmallInt) : Boolean;
function VytajkaCOT(ptr : SmallInt) : string;
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
procedure SetNadvigParam(Ptr : SmallInt);
function AutoMarsh(Ptr : SmallInt; mode : Boolean) : Boolean;
function CheckAutoMarsh(Ptr : SmallInt; Group : Byte) : Boolean;
function AutoMarshReset(Ptr : SmallInt) : Boolean;
function AutoMarshON(Ptr : SmallInt) : Boolean;
function AutoMarshOFF(Ptr : SmallInt) : Boolean;

const
  MarshM = 3;   // Маневровый маршрут
  MarshP = 12;  // Поездной маршрут
  MarshL = 19;  // Логическое замыкание


  TryMarhLimit = 6962; // счетчик объектов при трассировке маршрута. Если кол-во пройденых объектов превысит это значение - выдается сообщение 231

implementation

uses
  VarStruct,
  Commons,
  Commands,
  CMenu,
  MainLoop,
  TabloForm;

var
  tm : string;

//------------------------------------------------------------------------------
// Сбросить структуры набора маршрута
function ResetTrace : Boolean;
  var i,k,o : integer;
begin
try
  WorkMode.GoTracert        := false;
  MarhTracert[1].SvetBrdr   := 0;
  MarhTracert[1].AutoMarh   := false;
  MarhTracert[1].Povtor     := false;
  MarhTracert[1].GonkaStrel := false;
  MarhTracert[1].GonkaList  := 0;
  Marhtracert[1].LockPovtor := false;
  MarhTracert[1].Finish     := false;
  MarhTracert[1].TailMsg := ''; MarhTracert[1].FindTail := false;
  MarhTracert[1].WarCount := 0; MarhTracert[1].MsgCount := 0; k := 0;
  MarhTracert[1].VP := 0;
  MarhTracert[1].TraceRazdel := false;
  if MarhTracert[1].ObjStart > 0 then
  begin // сброс признака ППР на светофоре
    k := MarhTracert[1].ObjStart;
    if not ObjZav[k].bParam[14] then begin ObjZav[k].bParam[7] := false; ObjZav[k].bParam[9] := false; end;
  end;
  MarhTracert[1].ObjStart := 0;
  for i := 1 to WorkMode.LimitObjZav do
  begin // Сборос признаков трассировки на всех объектах станции
    case ObjZav[i].TypeObj of

      1 : begin // хвост стрелки
        ObjZav[i].bParam[27] := false; //регистрация сообщений оператору - сброс
        ObjZav[i].iParam[3] := 0; //индекс стрелки последнего сообщения о макете - сброс
      end;

      2 : begin // стрелка
        ObjZav[i].bParam[10] := false;//первичный проход трассировки сбросить
        ObjZav[i].bParam[11] := false; //вторичный проход трассировки сбросить
        ObjZav[i].bParam[12] := false; //пошерстная в плюсе - сбросить
        ObjZav[i].bParam[13] := false; //пошерстная в минусе  - сбросить
      end;

      3 : begin // секция
        if not ObjZav[i].bParam[14] then //если нет программного замыкания
        begin
          ObjZav[i].bParam[8] := true;  //установить предварительное замыкание трассировки
        end;
      end;

      4 : begin // путь
        //если нет признака программного замыкания
        if not ObjZav[i].bParam[14] then
        begin
          //установить предварительное замыкание трассировки
          ObjZav[i].bParam[8] := true;
        end;
      end;

      5 : begin // светофор
        if not ObjZav[i].bParam[14] and // нет предварительного замыкания
           ObjZav[i].bParam[11] then    // нет исполнительного замыкания
        begin
          ObjZav[i].bParam[7] := false; //МПР трассировки
          ObjZav[i].bParam[9] := false; //ППР трассировки
        end;
      end;

      8 : begin // УТС
        ObjZav[i].bParam[27] := false; //сброс регистрации сообщения оператору
      end;

      15 : begin // АБ
        if not ObjZav[i].bParam[14] and // нет предварительного замыкания
           ObjZav[ObjZav[i].BaseObject].bParam[2] then // нет исполнительного замыкания
        begin
          ObjZav[i].bParam[15] := false; //замыкание маршрута отправления сброс
        end;
      end;

      25 : begin // Колонка
        if not ObjZav[i].bParam[14] then // нет предварительного замыкания
        begin
          ObjZav[i].bParam[8] := false; //
        end;
      end;

      41 : begin // Контроль маршрута отправления
        o := ObjZav[i].UpdateObject;
        if not ObjZav[o].bParam[14] and ObjZav[o].bParam[2] and // нет предварительного или исполнительного замыкания
           not ObjZav[ObjZav[i].BaseObject].bParam[3] and not ObjZav[ObjZav[i].BaseObject].bParam[4] then // выходной сигнал не открыт поездным
        begin
          ObjZav[i].bParam[20] := false;
          ObjZav[i].bParam[21] := false;
        end;
      end;

      42 : begin // перезамыкание поездного на маневровый
        o := ObjZav[i].UpdateObject;
        if not ObjZav[o].bParam[14] and ObjZav[o].bParam[2] then // нет предварительногоили исполнительного  замыкания
        begin
          ObjZav[i].bParam[1] := false;
          ObjZav[i].bParam[2] := false;
        end;
      end;
    end;
  end;
  for i := 1 to High(MarhTracert[1].Msg) do begin MarhTracert[1].Msg[i] := ''; MarhTracert[1].MsgIndex[i] := 0; MarhTracert[1].MsgObject[i] := 0; end;  MarhTracert[1].MsgCount := 0;
  for i := 1 to High(MarhTracert[1].Warning) do begin MarhTracert[1].Warning[i] := ''; MarhTracert[1].WarIndex[i] := 0; MarhTracert[1].WarObject[i] := 0; end; MarhTracert[1].WarCount := 0;
  for i := 1 to High(MarhTracert[1].ObjTrace) do MarhTracert[1].ObjTrace[i] := 0;
  MarhTracert[1].Counter := 0;
  for i := 1 to High(MarhTracert[1].StrTrace) do
  begin
    MarhTracert[1].StrTrace[i] := 0; MarhTracert[1].PolTrace[i,1] := false; MarhTracert[1].PolTrace[i,2] := false;
  end;
  MarhTracert[1].StrCount := 0; MarhTracert[1].ObjEnd := 0; MarhTracert[1].ObjLast := 0; MarhTracert[1].ObjStart := 0;
  MarhTracert[1].PinLast := 0; MarhTracert[1].Rod := 0; WorkMode.GoTracert := false;
  if (k > 0) and not ObjZav[k].bParam[14] then begin InsArcNewMsg(k,2); ShowShortMsg(2,LastX,LastY,'от '+ ObjZav[k].Liter); end;
  ResetTrace := true;
except
  reportf('Ошибка [Marshrut.ResetTrace]'); ResetTrace := false;
end;
end;

//------------------------------------------------------------------------------
// Реакция на сброс маршрута в сервере
function ResetMarhrutSrv(fr : word) : Boolean;
  var i,im : integer;
begin
try
  im := 0;
  // поиск индекса маршрута по номеру FR3
  for i := 1 to WorkMode.LimitObjZav do
    if ObjZav[i].TypeObj = 5 then
    begin
      if ObjZav[i].ObjConstI[3] > 0 then
        if fr = (ObjZav[i].ObjConstI[3] div 8) then begin im := i; break; end;
      if ObjZav[i].ObjConstI[5] > 0 then
        if fr = (ObjZav[i].ObjConstI[5] div 8) then begin im := i; break; end;
    end;
  if im > 0 then
  begin // установить признак сброса маршрута на сервере для всех светофоров данного маршрута
    for i := 1 to WorkMode.LimitObjZav do
      if ObjZav[i].TypeObj = 5 then
        if ObjZav[i].iParam[1] = im then ObjZav[i].bParam[34] := true; // установить на светофоры в составном маршруте
    if ObjZav[im].RU = config.ru then
    begin // вывести сообщение о неисполнении маршрута
      MsgStateRM := GetShortMsg(2,7,ObjZav[im].Liter); MsgStateClr := 1;
    end;
    InsArcNewMsg(im,7+$400);
    ResetMarhrutSrv := true;
  end else
  begin // индекс маршрута не определен
    ResetMarhrutSrv := false;
  end;
except
  reportf('Ошибка [Marshrut.ResetMarhrutSrv]'); ResetMarhrutSrv := false;
end;
end;

//------------------------------------------------------------------------------
// добавить новое предупреждение
procedure InsWar(Group,Obj,Index : SmallInt);
begin
  MarhTracert[Group].WarObject[MarhTracert[Group].WarCount] := Obj; MarhTracert[Group].WarIndex[MarhTracert[Group].WarCount] := Index;
end;

// добавить новую враждебность
procedure InsMsg(Group,Obj,Index : SmallInt);
begin
  MarhTracert[Group].MsgObject[MarhTracert[Group].MsgCount] := Obj; MarhTracert[Group].MsgIndex[MarhTracert[Group].MsgCount] := Index;
end;

//------------------------------------------------------------------------------
// открыть сигнал в раздельном режиме управления
function OtkrytRazdel(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
  var i : Integer; jmp : TOZNeighbour;
begin
try
  ResetTrace;
  if Marh = MarshM then
  begin
    ObjZav[Svetofor].bParam[7] := true; ObjZav[Svetofor].bParam[9] := false;
  end else
  begin
    ObjZav[Svetofor].bParam[7] := false; ObjZav[Svetofor].bParam[9] := true;
  end;

  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;

  // Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];
  MarhTracert[Group].Level := tlRazdelSign;
  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd : break;

      trEndTrace : break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    result := false; InsArcNewMsg(Svetofor,228); ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter); Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  // отказ по враждебности
    // Закончить трассировку если есть враждебности
    MarhTracert[1].TraceRazdel := true; InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1]);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]); result := false; Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;
  // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter); InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
  if MarhTracert[Group].WarCount > 0 then
  begin // вывод сообщений
    CreateDspMenu(CmdMarsh_Razdel,LastX,LastY); result := false; exit;
  end;
  result := true;
except
  reportf('Ошибка [Marshrut.OtkrytRazdel]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Проверка возможности выдачи команды установки маршрута автодействия
function CheckAutoMarsh(Ptr : SmallInt; Group : Byte) : Boolean;
  var i : Integer; jmp : TOZNeighbour; tr : boolean;
begin
try
  result := false;
  // проверить наличие противоповторности маршрута автодействия
  if ObjZav[Ptr].bParam[2] then
  begin
  // ожидать готовность маршрута автодействия
    MarhTracert[Group].Rod := MarshP;
    MarhTracert[Group].Finish := false;
    MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
    MarhTracert[Group].ObjStart := ObjZav[Ptr].BaseObject;
    MarhTracert[Group].Counter := 0;

    // Выдать команду открытия сигнала автодействия в виде раздельного открытия сигнала
    i := 1000;
    jmp := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2];
    MarhTracert[Group].FindTail := true;

    if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].BaseObject].bParam[2] then
    begin
    // снять признак занятия перекрывной секции при отсутствии замыкания секции
      ObjZav[Ptr].bParam[3] := false; ObjZav[Ptr].bParam[4] := false;  ObjZav[Ptr].bParam[5] := false; tr := true;
    end else
    begin
    // проверить занятие перекрывной секции после замыкания маршрута автодействия
      tr := false;
      if ObjZav[Ptr].bParam[3] then
      begin // зафиксировано занятие перекрывной секции в замкнутом маршруте
        if not ObjZav[Ptr].bParam[4] then
        begin
          if not ObjZav[Ptr].bParam[5] then
          begin
            InsArcNewMsg(ObjZav[Ptr].BaseObject,475);
            AddFixMessage(GetShortMsg(1,475,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,5);
            ObjZav[Ptr].bParam[5] := true;
          end;
        end;
        MarhTracert[Group].ObjStart := 0;
        exit;
      end else
      if ObjZav[ObjZav[ObjZav[Ptr].BaseObject].BaseObject].bParam[1] then
      begin // секция свободна
        MarhTracert[Group].Level := tlSignalCirc;
      end else
      begin
        ObjZav[Ptr].bParam[3] := true; // фиксировать занятие секции в маршруте
        if ObjZav[ObjZav[Ptr].BaseObject].bParam[4] then
          ObjZav[Ptr].bParam[4] := true; // фиксировать открытое состояние сигнала на момент занятия перекрывной секции
        MarhTracert[Group].ObjStart := 0;
        exit;
      end;
    end;

    if tr then
    begin // выбрать условия проверки для незамкнутого исполнительным замыканием маршрута автодействия
      if ObjZav[ObjZav[Ptr].BaseObject].bParam[9] or ObjZav[ObjZav[Ptr].BaseObject].bParam[14] then
        MarhTracert[Group].Level := tlPovtorRazdel
      else
        MarhTracert[Group].Level := tlRazdelSign;
    end;

    MarhTracert[Group].AutoMarh := true;
    MarhTracert[Group].SvetBrdr := ObjZav[Ptr].BaseObject;
    ObjZav[ObjZav[Ptr].BaseObject].bParam[9] := true;
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd, trEndTrace : begin
          break;
        end;
      end;
      dec(i);
    end;
    if i < 1 then exit; // трасса маршрута разрушена
    if MarhTracert[Group].MsgCount > 0 then
    begin
      MarhTracert[Group].ObjStart := 0; exit; // отказ по враждебности
    end;
    result := true;
  end else
  begin
  // проверить враждебности по всей трассе маршрута автодействия
    ObjZav[ObjZav[Ptr].BaseObject].bParam[7] := false;
    ObjZav[ObjZav[Ptr].BaseObject].bParam[9] := false;
    MarhTracert[Group].Rod := MarshP;
    MarhTracert[Group].Finish := false;
    MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
    MarhTracert[Group].ObjStart := ObjZav[Ptr].BaseObject;
    MarhTracert[Group].Counter := 0;
    i := 1000;
    jmp := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2];
    MarhTracert[Group].Level := tlAutoTrace;
    MarhTracert[Group].FindTail := true;
    while i > 0 do
    begin
      case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
        trStop, trEnd, trEndTrace : begin
          break;
        end;
      end;
      dec(i);
    end;
    if i < 1 then exit; // трасса маршрута разрушена
    if MarhTracert[Group].MsgCount > 0 then
    begin
{      if not ObjZav[Ptr].bParam[4] then
      begin
        AddFixMessage(GetShortMsg(1,475,ObjZav[ObjZav[Ptr].BaseObject].Liter),4,5);
      end;}
      MarhTracert[Group].ObjStart := 0;
      exit; // отказ по враждебности
    end;

    // защитный участок занят ?
    case ObjZav[ObjZav[Ptr].UpdateObject].TypeObj of
      4 : begin // путь
        if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] or not ObjZav[ObjZav[Ptr].UpdateObject].bParam[16] then
        begin
          MarhTracert[Group].ObjStart := 0; exit;
        end;
      end;
      15 : begin // АБ
        if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[2] then begin MarhTracert[Group].ObjStart := 0; exit; end;
      end
    else // СП,УП
      if not ObjZav[ObjZav[Ptr].UpdateObject].bParam[1] then begin MarhTracert[Group].ObjStart := 0; exit; end;
    end;

    ObjZav[Ptr].bParam[2] := true;
  end;
except
  reportf('Ошибка [Marshrut.CheckAutoMarsh]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Сделать проверки повторного открытия светофора
function PovtorSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
  var i : Integer; jmp : TOZNeighbour;
begin
try
  ResetTrace;
  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].TailMsg := '';
  MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;
  // Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];
  MarhTracert[Group].Level := tlSignalCirc;
  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd :
        break;

      trEndTrace :
        break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    InsArcNewMsg(Svetofor,228);
    result := false; ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter); Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  // отказ по враждебности
    // Закончить трассировку и сбросить трассу если есть враждебности
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1]);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]); result := false; Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;
  // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
  if MarhTracert[Group].WarCount > 0 then
  begin // вывод сообщений
    CreateDspMenu(CmdMarsh_Povtor,LastX,LastY); DspMenu.WC := true; result := false; MarhTracert[Group].ObjStart := 0; exit;
  end;
  result := true;
except
  reportf('Ошибка [Marshrut.PovtorSvetofora]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Сделать проверки повторного открытия светофора в раздельном режиме по предварительному замыканию трассы
function PovtorOtkrytSvetofora(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
  var i : Integer; jmp : TOZNeighbour;
begin
try
  ResetTrace;
  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].TailMsg := '';
  MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;
  // Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];
  MarhTracert[Group].Level := tlPovtorRazdel;
  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd :
        break;

      trEndTrace :
        break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    InsArcNewMsg(Svetofor,228);
    result := false; ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter); Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0;
    exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  // отказ по враждебности
    // Закончить трассировку и сбросить трассу если есть враждебности
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]); result := false; Marhtracert[Group].LockPovtor := true;
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1]); MarhTracert[Group].ObjStart := 0;
    exit;
  end;
  // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
  if MarhTracert[Group].WarCount > 0 then
  begin // вывод сообщений
    CreateDspMenu(CmdMarsh_PovtorOtkryt,LastX,LastY); DspMenu.WC := true; result := false; MarhTracert[Group].ObjStart := 0; exit;
  end;
  result := true;
except
  reportf('Ошибка [Marshrut.PovtorOtkrytSvetofora]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Выполнить повторную устаноку маршрута
function PovtorMarsh(Svetofor : SmallInt; Marh : Byte; Group : Byte) : Boolean;
  var i,j : Integer; jmp : TOZNeighbour;
begin
try
  ResetTrace;
  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].Rod := Marh;
  MarhTracert[Group].TailMsg := '';
  MarhTracert[Group].WarCount := 0; MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].ObjStart := Svetofor;
  // Проверить враждебности по всей трассе
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[2];
  MarhTracert[Group].Level := tlPovtorMarh;
  MarhTracert[Group].FindTail := true;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of

      trStop, trEnd :
        break;

      trEndTrace :
        break;
    end;
    dec(i);
  end;

  if i < 1 then
  begin // трасса маршрута разрушена
    InsArcNewMsg(Svetofor,228);
    result := false; ShowShortMsg(228, LastX, LastY, ObjZav[Svetofor].Liter); Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  // отказ по враждебности
    // Закончить трассировку и сбросить трассу если есть враждебности
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1]);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[1]); result := false; Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;

  // Проверить враждебности по всей трассе
  i := 1000;
  MarhTracert[Group].SvetBrdr := Svetofor;
  MarhTracert[Group].Povtor := true;
  MarhTracert[Group].MsgCount := 0;
  MarhTracert[Group].HTail := MarhTracert[Group].ObjTrace[1]; // "концом" от оператора навязывается объект, расположенный следом за сигналом маршрута
  jmp := ObjZav[MarhTracert[Group].ObjStart].Neighbour[2];
  MarhTracert[Group].Level := tlCheckTrace;
  if MarhTracert[Group].ObjEnd < 1 then
  begin
    j := MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]; MarhTracert[Group].ObjEnd := j;
  end else
  begin
    j := MarhTracert[Group].ObjEnd;
  end;
  MarhTracert[Group].CIndex := 1;
  while i > 0 do
  begin
    if jmp.Obj = j then
    begin // Обнаружен объект конца трассы
    // Враждебности в хвосте
      StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);
      break;
    end;

    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
      trStop : begin
        break;
      end;
    end;
    dec(i);
    inc(MarhTracert[Group].CIndex);
  end;

  if i < 1 then
  begin // отказ по превышению счетчика
    InsArcNewMsg(Svetofor,231);
    RestorePrevTrace; result := false; ShowShortMsg(231, LastX, LastY, ''); Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;

  if MarhTracert[Group].MsgCount > 0 then
  begin  // отказ по враждебности
    // Закончить трассировку и сбросить трассу если есть враждебности
    InsArcNewMsg(MarhTracert[Group].MsgObject[1],MarhTracert[Group].MsgIndex[1]);
    PutShortMsg(1,LastX,LastY,MarhTracert[Group].Msg[Group]); result := false; Marhtracert[Group].LockPovtor := true; MarhTracert[Group].ObjStart := 0; exit;
  end;

  // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(Svetofor, MarhTracert[Group].Rod) then
  begin
    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1, 333, ObjZav[MarhTracert[Group].ObjStart].Liter);
    InsWar(Group,MarhTracert[Group].ObjStart,333);
  end;
  if MarhTracert[Group].WarCount > 0 then
  begin // вывод сообщений
    CreateDspMenu(CmdMarsh_PovtorMarh,LastX,LastY); DspMenu.WC := true; result := false; exit;
  end;
  result := true;
except
  reportf('Ошибка [Marshrut.PovtorMarsh]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках (Только ДСП)
function FindIzvStrelki(Svetofor : SmallInt; Marh : Byte) : Boolean;
  var i : integer; jmp : TOZNeighbour;
begin
try
  result := false;
  if Svetofor < 1 then exit;
  i := 1000;
  MarhTracert[1].IzvStrNZ  := false;
  MarhTracert[1].IzvStrFUZ := false;
  MarhTracert[1].IzvStrUZ  := false;
  MarhTracert[1].ObjStart := Svetofor;
  jmp := ObjZav[Svetofor].Neighbour[1]; // начальная точка
  MarhTracert[1].Level := tlFindIzvStrel;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
      trStop, trEnd, trBreak : begin
        result := MarhTracert[1].IzvStrNZ and MarhTracert[1].IzvStrUZ;
        if result then
        begin // выдать предупреждение
          SingleBeep := true; TimeLockCmdDsp := LastTime; LockCommandDsp := true; ShowWarning := true;
        end;
        break;
      end;
    end;
    dec(i);
  end;
except
  reportf('Ошибка [Marshrut.FindIzvStrelki]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// получение признака разрешения отмены маршрута
function GetSoglOtmeny(Uslovie : SmallInt) : string;
begin
try
  result := '';
  if Uslovie > 0 then
  begin // проверить разрешение на отмену маршрута
    case ObjZav[Uslovie].TypeObj of

      30 : begin // дача согласия поездного приема
        if ObjZav[Uslovie].bParam[2] then result := GetShortMsg(1,254,ObjZav[ObjZav[Uslovie].BaseObject].Liter);
      end;

      33 : begin // дискретный датчик
        if ObjZav[Uslovie].ObjConstB[1] then
        begin
          if ObjZav[Uslovie].bParam[1] then result := MsgList[ObjZav[Uslovie].ObjConstI[3]];
        end else
        begin
          if ObjZav[Uslovie].bParam[1] then result := MsgList[ObjZav[Uslovie].ObjConstI[2]];
        end;
      end;

      38 : begin // маршрут надвига
        if ObjZav[Uslovie].bParam[1] then result := GetShortMsg(1,346,ObjZav[ObjZav[Uslovie].BaseObject].Liter);
      end;

    end;
  end;
except
  reportf('Ошибка [Marshrut.GetSoglOtmeny]'); result := '';
end;
end;

//------------------------------------------------------------------------------
// Получить состояние известителя при отмене маршрута (Только ДСП)
function GetIzvestitel(Svetofor : SmallInt; Marh : Byte) : Byte;
  var i : integer; jmp : TOZNeighbour;
begin
try
  result := 0;
  if Svetofor < 1 then exit;
  MarhTracert[1].Rod := Marh;
  case Marh of
    MarshP : begin
      // проверить схему поездного известителя
      if ObjZav[Svetofor].ObjConstI[27] > 0 then
      begin
        if ObjZav[ObjZav[Svetofor].ObjConstI[27]].bParam[1] then
        begin // Поезд на предмаршрутном участке
          result := 1; exit;
        end;
      end;
      // пройти по предмаршрутному участку
      if ObjZav[Svetofor].ObjConstB[19] then MarhTracert[1].IzvCount := 0 else MarhTracert[1].IzvCount := 1;
    end;
    MarshM : begin
      if ObjZav[Svetofor].ObjConstB[20] then MarhTracert[1].IzvCount := 0 else MarhTracert[1].IzvCount := 1;
    end;
  else
    MarhTracert[1].IzvCount := 1;
  end;
  if not ObjZav[Svetofor].bParam[2] and not ObjZav[Svetofor].bParam[4] then exit; // сигнал закрыт
  i := 1000;
  jmp := ObjZav[Svetofor].Neighbour[1]; // начальная точка
  MarhTracert[1].Level := tlFindIzvest;
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
      trStop, trEnd : break;
      trBreak : begin
      // проверить местонахождение занятого участка
        if MarhTracert[1].IzvCount < 2 then
        begin // предмаршрутный участок
          if ObjZav[jmp.Obj].TypeObj = 26 then result := 3
          else if ObjZav[jmp.Obj].TypeObj = 15 then result := 3
          else result := 1;
        end else
        begin // поезд на маршруте
          result := 2;
        end;
        SingleBeep := true; TimeLockCmdDsp := LastTime; LockCommandDsp := true; ShowWarning := true;
        break;
      end;
    end;
    dec(i);
  end;
except
  reportf('Ошибка [Marshrut.GetIzvestitel]'); result := 0;
end;
end;

//------------------------------------------------------------------------------
// Выдать команду отмены маршрута в сервер (Только ДСП)
function OtmenaMarshruta(Svetofor : SmallInt; Marh : Byte) : Boolean;
  var index,i : integer; jmp : TOZNeighbour;
begin
try
  result := false;
 // маршрут замкнут исполнительными устройствами или сервером}
  index := Svetofor;
  MarhTracert[1].TailMsg := '';
  MarhTracert[1].ObjStart := Svetofor;
  MarhTracert[1].Rod := Marh;
  MarhTracert[1].Finish := false;
  if ObjZav[ObjZav[MarhTracert[1].ObjStart].BaseObject].bParam[2] then
  begin
  // снять блокировки головного светофора
    ObjZav[MarhTracert[1].ObjStart].bParam[14] := false;
    ObjZav[MarhTracert[1].ObjStart].bParam[7] := false;
    ObjZav[MarhTracert[1].ObjStart].bParam[9] := false;
  end;
  i := 1000;
  jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2]; // начальная точка
  MarhTracert[1].Level := tlOtmenaMarh;
  // снять блокировки элементов маршрута
  while i > 0 do
  begin
    case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
      trStop, trEnd : break;
    end;
    dec(i);
  end;

  // Выдать команду отмены маршрута
  case Marh of
    MarshM : begin
      if SendCommandToSrv(ObjZav[index].ObjConstI[3] div 8, cmdfr3_svzakrmanevr, index) then
      begin InsArcNewMsg(Index,24); ShowShortMsg(24, LastX, LastY, ObjZav[index].Liter); result := true; end;
    end;
    MarshP : begin
      if SendCommandToSrv(ObjZav[index].ObjConstI[5] div 8, cmdfr3_svzakrpoezd, index) then
      begin InsArcNewMsg(Index,25); ShowShortMsg(25, LastX, LastY, ObjZav[index].Liter); result := true; end;
    end;
  end;
  MarhTracert[1].ObjStart := 0;
except
  reportf('Ошибка [Marshrut.OtmenaMarshruta]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Замкнуть трассу маршрута
function SetProgramZamykanie(Group : Byte) : Boolean;
  var jmp : TOZNeighbour; i,j : integer;
begin
try
  // Установить программное замыкание элементов маршрута
  MarhTracert[Group].SvetBrdr := MarhTracert[Group].ObjStart;
  MarhTracert[Group].Finish := false;
  MarhTracert[Group].TailMsg := '';
  ObjZav[MarhTracert[Group].ObjStart].bParam[14] := true;
  ObjZav[MarhTracert[Group].ObjStart].iParam[1]  := MarhTracert[Group].ObjStart;
  i := MarhTracert[Group].Counter;
  jmp := ObjZav[MarhTracert[Group].ObjStart].Neighbour[2]; // начальная точка
  MarhTracert[Group].Level := tlZamykTrace;
  MarhTracert[Group].FindTail := true;
  j := MarhTracert[Group].ObjEnd; MarhTracert[Group].CIndex := 1;
  if j < 1 then j := MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter];
  while i > 0 do
  begin
    if jmp.Obj = j then // Обнаружен объект конца трассы
    begin
      case ObjZav[jmp.Obj].TypeObj of
        2 : begin // стрелка в конце трассы маршрута необходимо замкнуть
          StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);
        end;
        5 : begin
          if jmp.Pin = 2 then // встречный светофор в конце трассы маршрута необходимо замкнуть
            StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group)
          else // попутный светофор в хвосте
          if MarhTracert[Group].FindTail then MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter; // пометить хвост маршрута
        end;
        15 : begin // АБ в конце трассы маршрута необходимо замкнуть
          StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group);
        end;
        30 : begin // объект дачи поездного согласия
          if MarhTracert[Group].FindTail then MarhTracert[Group].TailMsg := ' до '+ ObjZav[ObjZav[jmp.Obj].BaseObject].Liter;
        end;
        32 : begin // Маршрут надвига на горку
          MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;
        end;
      end;
      break;
    end;
    case StepTrace(jmp,MarhTracert[Group].Level,MarhTracert[Group].Rod,Group) of
      trStop, trEnd : begin
        i := -1; break;
      end;
    end;
    dec(i); inc(MarhTracert[Group].CIndex);
  end;
  if i < 1 then
  begin // отказ по разрушению трассы
    InsArcNewMsg(MarhTracert[Group].ObjStart,228); ResetTrace; result := false; ShowShortMsg(228, LastX, LastY, ObjZav[MarhTracert[Group].ObjStart].Liter); exit;
  end;
  result := true;
except
  reportf('Ошибка [Marshrut.SetProgramZamykanie]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Выдать команду установки маршрута в сервер
function SendMarshrutCommand(Group : Byte) : Boolean;
  var i : integer; os,oe : SmallInt;
begin
try
  MarhTracert[Group].Finish := false;

  // сформировать маршрутную команду
  for i := 1 to 10 do MarhTracert[Group].MarhCmd[i] := 0;
  if ObjZav[MarhTracert[Group].ObjStart].TypeObj = 30 then
    os := ObjZav[ObjZav[MarhTracert[Group].ObjStart].BaseObject].ObjConstI[5] div 8
  else
  if ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] > 0 then os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] div 8 else
    os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[5] div 8;

  if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 30 then
    oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[5] div 8
  else if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 24 then
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[13] div 8
  else if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 26 then
    oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[4] div 8
  else if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 32 then
    oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[2] div 8
  else
  if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] > 0 then oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] div 8 else
  if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] > 0 then  oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] div 8 else
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[7] div 8;

  MarhTracert[Group].MarhCmd[1] := os;
  MarhTracert[Group].MarhCmd[2] := os div 256;
  MarhTracert[Group].MarhCmd[3] := oe;
  MarhTracert[Group].MarhCmd[4] := oe div 256;
  MarhTracert[Group].MarhCmd[5] := MarhTracert[Group].StrCount;

  case MarhTracert[Group].Rod of // установить категорию маршрута
    MarshM : begin
      if MarhTracert[Group].Povtor then
        MarhTracert[Group].MarhCmd[10] := cmdfr3_povtormarhmanevr
      else
        MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutmanevr;
      tm := 'маневрового';
    end;
    MarshP : begin
      if MarhTracert[Group].Povtor then
        MarhTracert[Group].MarhCmd[10] := cmdfr3_povtormarhpoezd
      else
        MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutpoezd;
      tm := 'поездного';
    end;
    MarshL : begin MarhTracert[Group].MarhCmd[10] := cmdfr3_marshrutlogic; tm := 'логического'; end;
  end;
  if MarhTracert[Group].StrCount > 0 then
  begin
    for i := 1 to MarhTracert[Group].StrCount do
    begin
      if MarhTracert[Group].PolTrace[i,2] then
      begin
        case i of
          1 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 1;
          2 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 2;
          3 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 4;
          4 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 8;
          5 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 16;
          6 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 32;
          7 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 64;
          8 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 128;
          9 :  MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 1;
          10 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 2;
          11 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 4;
          12 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 8;
          13 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 16;
          14 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 32;
          15 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 64;
          16 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 128;
          17 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 1;
          18 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 2;
          19 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 4;
          20 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 8;
          21 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 16;
          22 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 32;
          23 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 64;
          24 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 128;
        end;
      end;
    end;
  end;
  CmdSendT := LastTime;
  WorkMode.MarhRdy := true;
  InsArcNewMsg(MarhTracert[Group].ObjStart,5);
  ShowShortMsg(5, LastX, LastY, tm + ' маршрута от '+ ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg);
  LastMsgToDSP := ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg;
  CmdBuff.LastObj := MarhTracert[Group].ObjStart;
  // сброс структуры трассировки
  MarhTracert[Group].ObjStart := 0;
  for i := 1 to High(MarhTracert[Group].ObjTrace) do MarhTracert[Group].ObjTrace[i] := 0;
  MarhTracert[Group].Counter := 0;
  for i := 1 to High(MarhTracert[Group].StrTrace) do
  begin
    MarhTracert[Group].StrTrace[i] := 0; MarhTracert[Group].PolTrace[i,1] := false; MarhTracert[Group].PolTrace[i,2] := false;
  end;
  MarhTracert[Group].StrCount := 0; MarhTracert[Group].ObjEnd := 0; MarhTracert[Group].ObjLast := 0;
  MarhTracert[Group].PinLast := 0; MarhTracert[Group].ObjPrev := 0; MarhTracert[Group].PinPrev := 0;
  MarhTracert[Group].Rod := 0; MarhTracert[Group].Povtor := false;
  WorkMode.GoTracert := false;
  WorkMode.CmdReady  := true; // Запрет маршрутных команд до получения квитанции
  result := true;
except
  reportf('Ошибка [Marshrut.SendMarshrutCommand]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Выдать команду установки маршрута в сервер
function SendTraceCommand(Group : Byte) : Boolean;
  var i : integer; os,oe : SmallInt;
begin
try
  if (MarhTracert[Group].GonkaList = 0) or not MarhTracert[Group].GonkaStrel then
  begin
    ResetTrace; result := false; exit;
  end;

  MarhTracert[Group].Finish     := false;
  MarhTracert[Group].GonkaStrel := false;
  MarhTracert[Group].GonkaList  := 0;

  // сформировать команду
  for i := 1 to 10 do MarhTracert[Group].MarhCmd[i] := 0;
  if ObjZav[MarhTracert[Group].ObjStart].TypeObj = 30 then
    os := ObjZav[ObjZav[MarhTracert[Group].ObjStart].BaseObject].ObjConstI[5] div 8
  else
  if ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] > 0 then os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[3] div 8 else
    os := ObjZav[MarhTracert[Group].ObjStart].ObjConstI[5] div 8;

  if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 30 then
    oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[5] div 8
  else if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 24 then
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[13] div 8
  else if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 26 then
    oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[4] div 8
  else if ObjZav[MarhTracert[Group].ObjEnd].TypeObj = 32 then
    oe := ObjZav[ObjZav[MarhTracert[Group].ObjEnd].BaseObject].ObjConstI[2] div 8
  else
  if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] > 0 then oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[3] div 8 else
  if ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] > 0 then oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[5] div 8 else
    oe := ObjZav[MarhTracert[Group].ObjEnd].ObjConstI[7] div 8;

  MarhTracert[Group].MarhCmd[1] := os;
  MarhTracert[Group].MarhCmd[2] := os div 256;
  MarhTracert[Group].MarhCmd[3] := oe;
  MarhTracert[Group].MarhCmd[4] := oe div 256;
  MarhTracert[Group].MarhCmd[5] := MarhTracert[Group].StrCount;
  MarhTracert[Group].MarhCmd[10] := cmdfr3_ustanovkastrelok;

  if MarhTracert[Group].StrCount > 0 then
  begin
    for i := 1 to MarhTracert[Group].StrCount do
    begin
      if MarhTracert[Group].PolTrace[i,2] then
      begin
        case i of
          1 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 1;
          2 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 2;
          3 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 4;
          4 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 8;
          5 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 16;
          6 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 32;
          7 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 64;
          8 :  MarhTracert[Group].MarhCmd[6] := MarhTracert[Group].MarhCmd[6] + 128;
          9 :  MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 1;
          10 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 2;
          11 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 4;
          12 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 8;
          13 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 16;
          14 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 32;
          15 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 64;
          16 : MarhTracert[Group].MarhCmd[7] := MarhTracert[Group].MarhCmd[7] + 128;
          17 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 1;
          18 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 2;
          19 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 4;
          20 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 8;
          21 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 16;
          22 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 32;
          23 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 64;
          24 : MarhTracert[Group].MarhCmd[8] := MarhTracert[Group].MarhCmd[8] + 128;
        end;
      end;
    end;
  end;
  CmdSendT := LastTime;
  WorkMode.MarhRdy := true;
  InsArcNewMsg(MarhTracert[Group].ObjStart,5);
  tm := GetShortMsg(1,5, ' стрелок по трассе маршрута от '+ ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg);
  LastMsgToDSP := ObjZav[MarhTracert[Group].ObjStart].Liter+ MarhTracert[Group].TailMsg;
  CmdBuff.LastObj := MarhTracert[Group].ObjStart;
  // сброс структуры трассировки
  ResetTrace;
  PutShortMsg(2,LastX,LastY,tm);
  WorkMode.CmdReady  := true; // Запрет маршрутных команд до получения квитанции
  result := true;
except
  reportf('Ошибка [Marshrut.SendTraceCommand]'); result := false;
end;
end;

function BeginTracertMarshrut(index, command : SmallInt) : Boolean;
begin
try
  ResetTrace; // сброс любой ранее набранной трассы
  case command of
    CmdMenu_BeginMarshManevr : begin
      MarhTracert[1].Rod := MarshM; ObjZav[index].bParam[7] := true; // НМ
    end;
    CmdMenu_BeginMarshPoezd : begin
      MarhTracert[1].Rod := MarshP; ObjZav[index].bParam[9] := true; // Н
    end;
  else
    InsArcNewMsg(MarhTracert[1].ObjStart,32);
    result := false; ShowShortMsg(32, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter); exit;
  end;

  WorkMode.GoTracert := true;
  MarhTracert[1].AutoMarh := false;
  MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
  MarhTracert[1].ObjStart := index; MarhTracert[1].ObjLast := index;
  MarhTracert[1].PinLast := 2; // начало поиска за светофором
  MarhTracert[1].ObjPrev := MarhTracert[1].ObjLast; MarhTracert[1].PinPrev := MarhTracert[1].PinLast;
  InsArcNewMsg(MarhTracert[1].ObjStart,78);
  ShowShortMsg(78, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
  result := true;
except
  reportf('Ошибка [Marshrut.BeginTracertMarshrut]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Восстановить трассу до последней существующей конфигурации
function RestorePrevTrace : Boolean;
  var i : integer;
begin
try
  i := MarhTracert[1].Counter;
  while i > 0 do
  begin
    if MarhTracert[1].ObjTrace[i] = MarhTracert[1].ObjPrev then break
    else
    begin
      if ObjZav[MarhTracert[1].ObjTrace[i]].TypeObj = 2 then
      begin // сбросить параметры трассировки стрелки
        ObjZav[MarhTracert[1].ObjTrace[i]].bParam[10] := false;
        ObjZav[MarhTracert[1].ObjTrace[i]].bParam[11] := false;
        ObjZav[MarhTracert[1].ObjTrace[i]].bParam[12] := false;
        ObjZav[MarhTracert[1].ObjTrace[i]].bParam[13] := false;
      end;
      MarhTracert[1].ObjTrace[i] := 0;
    end;
    dec(i);
  end;
  MarhTracert[1].Counter := i;
  MarhTracert[1].ObjLast := MarhTracert[1].ObjPrev;
  MarhTracert[1].PinLast := MarhTracert[1].PinPrev;
  MarhTracert[1].MsgCount := 0;
  RestorePrevTrace := true;
except
  reportf('Ошибка [Marshrut.RestorePrevTrace]'); result := false;
end;
end;

function EndTracertMarshrut : Boolean;
begin
try
  if Marhtracert[1].Counter < 1 then
  begin
    result := false; exit;
  end else
  if MarhTracert[1].ObjEnd < 1 then
  begin
    case ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].TypeObj of
      5 : MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];  // светофор
      15 : MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter]; // АБ
      26 : MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter]; // ПАБ
      30 : MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter]; // п.согласие
    else
      result := false; exit;
    end;
  end;

  if (ObjZav[MarhTracert[1].ObjLast].TypeObj = 5) and (MarhTracert[1].PinLast = 2) and
     not (ObjZav[MarhTracert[1].ObjLast].bParam[1] or ObjZav[MarhTracert[1].ObjLast].bParam[2] or
          ObjZav[MarhTracert[1].ObjLast].bParam[3] or ObjZav[MarhTracert[1].ObjLast].bParam[4]) then
  begin
    if ObjZav[MarhTracert[1].ObjLast].bParam[5] then // о
    begin // Маршрут не прикрыт запрещающим огнем попутного
      inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,115, ObjZav[MarhTracert[1].ObjLast].Liter);
      InsWar(1,MarhTracert[1].ObjLast,115);
    end;
    case MarhTracert[1].Rod of // Проверить открытие впереди стоящего сигнала если короткий блок-участок
      MarshP : begin
        if ObjZav[MarhTracert[1].ObjLast].ObjConstB[19] and not ObjZav[MarhTracert[1].ObjLast].bParam[4] then
        begin
          InsArcNewMsg(MarhTracert[1].ObjLast,391);
          ShowShortMsg(391,LastX,LastY, ObjZav[MarhTracert[1].ObjLast].Liter); result := false; exit;
        end;
      end;

      MarshM : begin
        if ObjZav[MarhTracert[1].ObjLast].ObjConstB[20] and not ObjZav[MarhTracert[1].ObjLast].bParam[2] then
        begin
          InsArcNewMsg(MarhTracert[1].ObjLast,391);
          ShowShortMsg(391,LastX,LastY, ObjZav[MarhTracert[1].ObjLast].Liter); result := false; exit;
        end;
      end;
    else
      result := false; exit;
    end;
  end;
  // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
  if FindIzvStrelki(MarhTracert[1].ObjStart, MarhTracert[1].Rod) then
  begin
    inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,333, ObjZav[MarhTracert[1].ObjStart].Liter);
    InsWar(1,MarhTracert[1].ObjStart,333);
  end;
  MarhTracert[1].Finish := true;
  result := true;
except
  reportf('Ошибка [Marshrut.EndTracertMarshrut]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Сделать трассировку до следующей точки, указанной оператором
function AddToTracertMarshrut(index : SmallInt) : Boolean;
  var i,j,nextptr : integer;
begin
try
  if (index = MarhTracert[1].ObjStart) or (index = MarhTracert[1].ObjEnd) then
  begin
    InsArcNewMsg(MarhTracert[1].ObjStart,1);
    ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter); result := false; exit;
  end;
  for i := 1 to MarhTracert[1].Counter do
    if Marhtracert[1].ObjTrace[i] = index then
    begin // если объект уже в трассе - запросить следующую точку
      InsArcNewMsg(MarhTracert[1].ObjStart,1);
      ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter); result := false; exit;
    end;

  // найти запись в списке АКНР
  for i := 1 to High(AKNR) do
  begin
    if (AKNR[i].ObjStart = 0) or (AKNR[i].ObjEnd = 0) then break else
    begin
      if (AKNR[i].ObjStart = MarhTracert[1].ObjLast) and (AKNR[i].ObjEnd = index) then
        for j := 1 to High(AKNR[i].ObjAuto) do
        begin
          if AKNR[i].ObjAuto[j] = 0 then break else
          begin
            nextptr := AKNR[i].ObjAuto[j]; result := NextToTracertMarshrut(nextptr); if not result then exit;
          end;
      end;
    end;
  end;
  result := NextToTracertMarshrut(index);
except
  reportf('Ошибка [Marshrut.AddToTracertMarshrut]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Продлить трассу до следующей точки
function NextToTracertMarshrut(index : SmallInt) : Boolean;
  var i,j,c,k,wc,oe : Integer; jmp : TOZNeighbour; b : boolean;
begin
try
  MarhTracert[1].FindNext := false;
  MarhTracert[1].LvlFNext := false;
  MarhTracert[1].Dobor    := false;
  MarhTracert[1].HTail    := index; // "конец" от оператора
  Marhtracert[1].FullTail := false;
  Marhtracert[1].VP := 0;
  MarhTracert[1].TailMsg  := ''; MarhTracert[1].FindTail := true;
  LastJmp.TypeJmp := 0; LastJmp.Obj := 0; LastJmp.Pin := 0;
  if WorkMode.GoTracert and not WorkMode.MarhRdy then
  begin
    result := true;
    if index = MarhTracert[1].ObjLast then
    begin
      InsArcNewMsg(MarhTracert[1].ObjStart,1);
      ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter); result := true; exit;
    end;
    // Сохранить начало трассировки
    MarhTracert[1].ObjPrev := MarhTracert[1].ObjLast; MarhTracert[1].PinPrev := MarhTracert[1].PinLast;
    if MarhTracert[1].Counter < High(MarhTracert[1].ObjTrace) then
    begin // трассировка - первичная фаза, поиск между заданными точками
      i := TryMarhLimit;
      jmp := ObjZav[MarhTracert[1].ObjLast].Neighbour[MarhTracert[1].PinLast];
      MarhTracert[1].Level := tlFindTrace;
      while i > 0 do
      begin // трассировать до указанной точки
        if jmp.Obj = index then break; // Обнаружен объект конца трассы

        case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

          trRepeat : begin
            if MarhTracert[1].Counter > 0 then
            begin
              // Возврат к последней непереведенной стрелке
                j := MarhTracert[1].Counter;
                while j > 0 do
                begin
                  case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of
                    2 : begin // стрелка
                      if ObjZav[MarhTracert[1].ObjTrace[j]].ObjConstB[3] then
                      begin // основные маршруты по минусу
                        if (ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] and not ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11]) or
                           ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] or
                           ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] then
                        begin
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] := false;
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] := false;
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] := false;
                          MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                        end else
                        begin
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                          jmp := ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[2]; // Переход на плюсовую ветвь стрелки
                          break;
                        end;
                      end else
                      begin // основные маршруты по плюсу
                        if ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] or
                           ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] or
                           ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] then
                        begin
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] := false;
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] := false;
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] := false;
                          MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                        end else
                        begin
                          ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := true;
                          jmp := ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[3]; // Переход на минусовую ветвь стрелки
                          break;
                        end;
                      end;
                    end;
                  else
                    if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                    begin
                      j := 0; break;
                    end else
                    begin // откатить на один объект к началу
                      MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                    end;
                  end;
                  dec(j);
                end;
                if j < 1 then
                begin // Конец трассировки - точка указана неверно
                  InsArcNewMsg(MarhTracert[1].ObjStart,86);
                  RestorePrevTrace; result := false; ShowShortMsg(86, LastX, LastY, ''); exit;
                end;
            end else
            begin // Конец трассировки - точка указана неверно
              InsArcNewMsg(MarhTracert[1].ObjStart,86);
              RestorePrevTrace; result := false; ShowShortMsg(86, LastX, LastY, ''); exit;
            end;
          end;

          trStop : begin // Конец трассировки - маршрут не существует
            InsArcNewMsg(MarhTracert[1].ObjStart,77);
            RestorePrevTrace; result := false; ShowShortMsg(77, LastX, LastY, ''); exit;
          end;

          trEnd : begin // Конец трассировки - маршрут не существует
            InsArcNewMsg(MarhTracert[1].ObjStart,77);
            RestorePrevTrace; result := false; ShowShortMsg(77, LastX, LastY, ''); exit;
          end;

        end;
        dec(i);
      end;
      if i < 1 then
      begin // превышен счетчик попыток
        InsArcNewMsg(MarhTracert[1].ObjStart,231);
        RestorePrevTrace; result := false; ShowShortMsg(231, LastX, LastY, ''); exit;
      end;

      MarhTracert[1].ObjLast := index;
      case jmp.Pin of
        1 : MarhTracert[1].PinLast := 2;
      else
        MarhTracert[1].PinLast := 1;
      end;

      // Проверить необходимость поиска предполагаемой конечной точки
      b := true; MarhTracert[1].PutPO := false;
      if ObjZav[MarhTracert[1].ObjLast].TypeObj = 5 then
      begin // Для светофора проверить условия продолжения трассировки
        if ObjZav[MarhTracert[1].ObjLast].ObjConstB[1] then
        begin // Точка разрыва маршрутов Ч/Н (смена направления движения на станции, тупик)
          b := false; MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
        end else
        case MarhTracert[1].PinLast of
          1 : begin
            case MarhTracert[1].Rod of
              MarshP : begin
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[6] then
                begin // Завершить трассировку если поездной из тупика
                  b := false; MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
                end else
                if ObjZav[MarhTracert[1].ObjLast].Neighbour[1].TypeJmp = 0 then
                begin // Отказ если нет поездного из тупика
                  b := false; i := 0;
                end;
              end;
              MarshM : begin
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[8] then
                begin // Завершить трассировку если маневровый из тупика или входной
                  b := false;
                  MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
                end;
              end;
            else
              b := true;
            end;
          end;
        else
          if (((MarhTracert[1].Rod = MarshM) and ObjZav[MarhTracert[1].ObjLast].ObjConstB[7]) or
              ((MarhTracert[1].Rod = MarshP) and ObjZav[MarhTracert[1].ObjLast].ObjConstB[5])) and
              (ObjZav[MarhTracert[1].ObjLast].bParam[12] or ObjZav[MarhTracert[1].ObjLast].bParam[13] or ObjZav[jmp.Obj].bParam[18] or
              (ObjZav[MarhTracert[1].ObjLast].ObjConstB[2] and (ObjZav[MarhTracert[1].ObjLast].bParam[3] or ObjZav[MarhTracert[1].ObjLast].bParam[4] or ObjZav[MarhTracert[1].ObjLast].bParam[8] or ObjZav[MarhTracert[1].ObjLast].bParam[9])) or
              (ObjZav[MarhTracert[1].ObjLast].ObjConstB[3] and (ObjZav[MarhTracert[1].ObjLast].bParam[1] or ObjZav[MarhTracert[1].ObjLast].bParam[2] or ObjZav[MarhTracert[1].ObjLast].bParam[6] or ObjZav[MarhTracert[1].ObjLast].bParam[7] or ObjZav[MarhTracert[1].ObjLast].bParam[21]))) then
          begin // Завершить трассировку если попутный впереди уже открыт
            b := false; MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
          end else
          begin
            case MarhTracert[1].Rod of
              MarshP : begin
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[5] then
                begin // есть конец поездного маршрута у светофора
                  MarhTracert[1].FullTail := true; MarhTracert[1].FindNext := true;
                end;
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[16] and ObjZav[MarhTracert[1].ObjLast].ObjConstB[2] then // Нет сквозного пропуска
                begin // Завершить трассировку если нет сквозного пропуска
                  b := false; MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast; MarhTracert[1].FullTail := true // закончить набор трассы
                end else
                begin
                  if ObjZav[MarhTracert[1].ObjLast].ObjConstB[5] then b := false else b := true;
                  if ObjZav[MarhTracert[1].ObjLast].ObjConstB[5] and not ObjZav[MarhTracert[1].ObjLast].ObjConstB[2] then
                  begin
                    MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast; // Завершить трассировку если нет поездных от сигнала
                  end;
                end;
              end;
              MarshM : begin
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[7] then
                begin
                  MarhTracert[1].FullTail := true; MarhTracert[1].FindNext := true;
                end;
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[7] then b := false else b := true;
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[7] and not ObjZav[MarhTracert[1].ObjLast].ObjConstB[3] then
                begin
                  MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast; // Завершить трассировку если нет маневров от сигнала
                end;
              end;
            else
              b := true;
            end;
          end;
        end;
      end else
      if ObjZav[MarhTracert[1].ObjLast].TypeObj = 4 then
      begin // Для пути установить признак конца набора трассы
        MarhTracert[1].PutPO := true;
      end else
      if ObjZav[MarhTracert[1].ObjLast].TypeObj = 24 then
      begin // Для межпостовой увязки завершить набор маршрута
        b := false; MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
      end else
      if ObjZav[MarhTracert[1].ObjLast].TypeObj = 32 then
      begin // Для надвига завершить набор маршрута
        b := false; MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast;
      end;

      if b then
      begin // Добить до конечной точки или отклоняющей стрелки
        // перешагнуть конечный объект
        MarhTracert[1].FullTail := false;
        MarhTracert[1].Level := tlContTrace;
        i := 1000;
        while i > 0 do
        begin
          case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

            trStop : begin // конец трассировки - маршрут не существует
              InsArcNewMsg(MarhTracert[1].ObjStart,77);
              RestorePrevTrace; result := false; ShowShortMsg(77, LastX, LastY, ''); exit;
            end;

            trBreak : begin // сделать откат до предыдущей точки маршрута
              b := false; break;
            end;

            trEnd : begin // достигнута делящая точка маршрута
              break;
            end;

            trEndTrace : begin // достигнута конечная точка маршрута
              MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter]; break;
            end;

          end;
          dec(i);
        end;
        if i < 1 then
        begin // превышен счетчик попыток
          InsArcNewMsg(MarhTracert[1].ObjStart,231);
          RestorePrevTrace; result := false; ShowShortMsg(231, LastX, LastY, ''); exit;
        end;

        if b then
        begin // нет отката
          MarhTracert[1].ObjLast := jmp.Obj;
          case jmp.Pin of
            1 : MarhTracert[1].PinLast := 2;
          else
            MarhTracert[1].PinLast := 1;
          end;
        end else
        begin // был откат на один шаг
          // пропустить ДЗ стрелок
          MarhTracert[1].Level := tlStepBack;
          i := MarhTracert[1].Counter;
          while i > 0 do
          begin
            case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

              trStop : begin
                break;
              end;

            end;
            dec(i);
          end;
          MarhTracert[1].ObjLast := jmp.Obj; MarhTracert[1].PinLast := jmp.Pin;
        end;

      end else
      begin // Если нет добора хвоста маршрута
        if MarhTracert[1].Counter < High(MarhTracert[1].ObjTrace) then
        begin // поместить хвост в список трассы
          inc(MarhTracert[1].Counter); MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj;
        end;
      end;

      LastJmp := jmp; // Сохранить последний переход между объектами

      if i < 1 then
      begin // отказ по несоответствию конечной точки
        InsArcNewMsg(index,86);
        RestorePrevTrace; result := false; ShowShortMsg(86, LastX, LastY, ObjZav[index].Liter); exit;
      end;

      // Проверить охранности по всей трассе
      i := 1000;
      Marhtracert[1].VP := 0;
      jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2];
      MarhTracert[1].Level := tlVZavTrace;
      j := MarhTracert[1].ObjEnd;
      MarhTracert[1].CIndex := 1;
      if j < 1 then j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

      while i > 0 do
      begin
        if jmp.Obj = j then break; // Обнаружен объект конца трассы

        case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

          trStop : begin
            i := 0; break;
          end;

          trBreak : begin
            break;
          end;

          trEnd : begin
            break;
          end;
        end;
        dec(i); inc(MarhTracert[1].CIndex);
      end;

      if MarhTracert[1].MsgCount > 0 then
      begin // отказ по враждебности
        InsArcNewMsg(MarhTracert[1].MsgObject[1],MarhTracert[1].MsgIndex[1]);
        RestorePrevTrace; result := false; PutShortMsg(1, LastX, LastY, MarhTracert[1].Msg[1]); exit;
      end;

      if i < 1 then
      begin // отказ по охранностям - маршрут не существует
        InsArcNewMsg(MarhTracert[1].ObjStart,77);
        RestorePrevTrace; result := false; ShowShortMsg(77, LastX, LastY, ''); exit;
      end;

      // Раскидать признаки трассировки по объектам трассы
      for i := 1 to MarhTracert[1].Counter do
      begin
        case ObjZav[MarhTracert[1].ObjTrace[i]].TypeObj of

          3 : begin // секция
            if  not ObjZav[MarhTracert[1].ObjTrace[i]].bParam[14] then
              ObjZav[MarhTracert[1].ObjTrace[i]].bParam[8] := false;
          end;

          4 : begin // путь
            if  not ObjZav[MarhTracert[1].ObjTrace[i]].bParam[14] then
              ObjZav[MarhTracert[1].ObjTrace[i]].bParam[8] := false;
          end;

        end;
      end;

      // Проверить враждебности по всей трассе
      i := 1000;
      MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;





//********************************************************************************************************************************************


//открыть true для выдачи команды постановки стрелок в трассу
      MarhTracert[1].GonkaStrel := false;//true; // разрешить гонку стрелок по трассе



//********************************************************************************************************************************************





      MarhTracert[1].GonkaList  := 0;    // сбросить счетчик стрелок, требующих перевода
      jmp := ObjZav[MarhTracert[1].ObjStart].Neighbour[2];
      MarhTracert[1].Level := tlCheckTrace;
      Marhtracert[1].VP := 0;
      j := MarhTracert[1].ObjEnd;
      if j < 1 then j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
      MarhTracert[1].CIndex := 1;

      while i > 0 do
      begin
        if jmp.Obj = j then
        begin // Обнаружен объект конца трассы
        // Враждебности в хвосте
          StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1);
          break;
        end;

        case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
          trStop : begin
            break;
          end;
        end;
        dec(i);
        inc(MarhTracert[1].CIndex);
      end;

      if i < 1 then
      begin // отказ по превышению счетчика
        InsArcNewMsg(MarhTracert[1].ObjStart,231);
        RestorePrevTrace; result := false; ShowShortMsg(231, LastX, LastY, ''); exit;
      end;
      tm := MarhTracert[1].TailMsg; // сохранить сообщение в хвосте маршрута

      if MarhTracert[1].MsgCount > 0 then
      begin  // отказ по враждебности
        MarhTracert[1].MsgCount := 1; // оставить одно сообщение
        // Закончить трассировку и сбросить трассу если есть враждебности
        CreateDspMenu(KeyMenu_ReadyResetTrace,LastX,LastY); result := false; exit;
      end else
      begin
        if MarhTracert[1].PutPO then // Завершить набор если указан путь
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];

        if (MarhTracert[1].WarCount > 0) and MarhTracert[1].FullTail then // При наличии сообщений проверить полноту хвоста маршрута
          MarhTracert[1].ObjEnd := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];


      // Проверка возможности набора следующего маршрута
        c := MarhTracert[1].Counter; // сохранить счетчик элементов трассы
        wc := MarhTracert[1].WarCount;
        oe := MarhTracert[1].ObjEnd;
        MarhTracert[1].VP := 0;
        MarhTracert[1].LvlFNext := true;
        if (MarhTracert[1].ObjEnd = 0) and (MarhTracert[1].FindNext) then
        begin // Проверка возможности набора следующего маршрута
          i := TryMarhLimit * 2;
          jmp := ObjZav[MarhTracert[1].ObjLast].Neighbour[MarhTracert[1].PinLast];
          MarhTracert[1].Level := tlFindTrace;
          while i > 0 do
          begin // трассировать
            case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

              trRepeat : begin
                if MarhTracert[1].Counter > c then
                begin
                  // Возврат к последней непереведенной стрелке
                  j := MarhTracert[1].Counter;
                  while j > 0 do
                  begin
                    case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of
                      2 : begin // стрелка
                        if ObjZav[MarhTracert[1].ObjTrace[j]].ObjConstB[3] then
                        begin // основные маршруты по минусу
                          if (ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] and not ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11]) or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] then
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] := false;
                            MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                          end else
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                            jmp := ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[2]; // Переход на плюсовую ветвь стрелки
                            break;
                          end; // if-else
                        end else
                        begin // основные маршруты по плюсу
                          if ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] then
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] := false;
                            MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                          end else
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := true;
                            jmp := ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[3]; // Переход на минусовую ветвь стрелки
                            break;
                          end; // if-else
                        end; // if-else
                      end; // 2 - стрелка
                    else // case
                      if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                      begin
                        j := 0; break;
                      end else
                      begin // откатить на один объект к началу
                        MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                      end;
                    end; // case
                    dec(j);
                  end; // while
                  if j <= c then
                  begin // Конец трассировки
                    oe := MarhTracert[1].ObjLast; break;
                  end; // if
                end else
                begin // Конец трассировки
                  MarhTracert[1].ObjEnd := MarhTracert[1].ObjLast; break;
                end; // if-else
              end; // trRepeat

              trStop, trEnd : begin // Конец трассировки
                break;
              end;
            end; // case steptrace

          // Проверить достижение конечной точки
            b := false;
            if ObjZav[jmp.Obj].TypeObj = 5 then
            begin // Для светофора проверить условия продолжения трассировки
              if ObjZav[jmp.Obj].ObjConstB[1] then
              begin // Точка разрыва маршрутов Ч/Н (смена направления движения на станции, тупик)
                b := true;
              end else
                case jmp.Pin of
                  2 : begin
                    case MarhTracert[1].Rod of
                      MarshP : begin
                        if ObjZav[jmp.Obj].ObjConstB[6] then
                        begin // Завершить трассировку если поездной из тупика
                          b := true;
                        end;
                      end;
                      MarshM : begin
                        if ObjZav[jmp.Obj].ObjConstB[8] then
                        begin // маневровый из тупика или входной
                          b := true;
                        end;
                      end;
                    else
                      b := false;
                    end;
                  end;
                else
                if ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or
                   ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4] or
                   ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7] or
                   ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9] or
                   ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] or
                   ObjZav[jmp.Obj].bParam[18] or ObjZav[jmp.Obj].bParam[21] then
                begin // попутный уже открыт
                  b := true;
                end else
                begin
                  case MarhTracert[1].Rod of
                    MarshP : begin
                      if ObjZav[jmp.Obj].ObjConstB[16] and ObjZav[jmp.Obj].ObjConstB[2] then // Нет сквозного пропуска
                      begin // нет сквозного пропуска
                        b := true;
                      end else
                      begin
                        b := ObjZav[jmp.Obj].ObjConstB[5];
                      end;
                    end;
                    MarshM : begin
                      b := ObjZav[jmp.Obj].ObjConstB[7];
                    end;
                  else
                    b := true;
                  end;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].TypeObj = 15 then
            begin // Для увязки с перегоном завершить набор маршрута
              inc(MarhTracert[1].Counter); MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj; b := true;
            end else
            if ObjZav[jmp.Obj].TypeObj = 24 then
            begin // Для межпостовой увязки завершить набор маршрута
              b := true;
            end else
            if ObjZav[jmp.Obj].TypeObj = 26 then
            begin // Для увязки с ПАБ завершить набор маршрута
              inc(MarhTracert[1].Counter); MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := jmp.Obj; b := true;
            end else
            if ObjZav[jmp.Obj].TypeObj = 32 then
            begin // Для надвига завершить набор маршрута
              b := true;
            end;

            if b then
            begin
              // Проверить охранности
              k := 15000;
              jmp.Obj := MarhTracert[1].ObjLast;
              if MarhTracert[1].PinLast = 1 then jmp.Pin := 2 else jmp.Pin := 1;

              MarhTracert[1].Level := tlVZavTrace;
              j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
              MarhTracert[1].CIndex := c;
              b := true;
              while k > 0 do
              begin
                if jmp.Obj = j then break; // Обнаружен объект конца трассы

                case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of

                  trStop : begin
                    b := false; break;
                  end;

                 trBreak, trEnd : begin
                    break;
                  end;
                end;
                dec(k); inc(MarhTracert[1].CIndex);
              end;

              if (k > 1000) and b then
              begin
              // Проверить враждебности
                jmp.Obj := MarhTracert[1].ObjLast;
                if MarhTracert[1].PinLast = 1 then jmp.Pin := 2 else jmp.Pin := 1;
                MarhTracert[1].Level := tlCheckTrace;
                MarhTracert[1].Dobor := true;
                MarhTracert[1].MsgCount := 0;
                j := MarhTracert[1].ObjTrace[MarhTracert[1].Counter];
                MarhTracert[1].CIndex := c;
                while k > 0 do
                begin
                  if jmp.Obj = j then
                  begin // Обнаружен объект конца трассы
                  // Враждебности в хвосте
                    StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1); break;
                  end;

                  case StepTrace(jmp,MarhTracert[1].Level,MarhTracert[1].Rod,1) of
                    trStop,trBreak : begin
                      break;
                    end;
                  end;
                  dec(i);
                  inc(MarhTracert[1].CIndex);
                end;
              end;

              if MarhTracert[1].MsgCount > 0 then b := false;

              if (k < 1) or not b then
              begin // отказ по охранностям или враждебностям
                if MarhTracert[1].Counter > c then
                begin
                // Возврат к последней непереведенной стрелке
                  j := MarhTracert[1].Counter;
                  while j > 0 do
                  begin
                    case ObjZav[MarhTracert[1].ObjTrace[j]].TypeObj of
                      2 : begin // стрелка
                        if ObjZav[MarhTracert[1].ObjTrace[j]].ObjConstB[3] then
                        begin // основные маршруты по минусу
                          if (ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] and not ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11]) or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] then
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] := false;
                            MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                          end else
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                            jmp := ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[2]; // Переход на плюсовую ветвь стрелки
                            break;
                          end;
                        end else
                        begin // основные маршруты по плюсу
                          if ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] or
                             ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] then
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[10] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[12] := false;
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[13] := false;
                            MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                          end else
                          begin
                            ObjZav[MarhTracert[1].ObjTrace[j]].bParam[11] := true;
                            jmp := ObjZav[MarhTracert[1].ObjTrace[j]].Neighbour[3]; // Переход на минусовую ветвь стрелки
                            break;
                          end;
                        end;
                      end;
                    else
                      if MarhTracert[1].ObjTrace[j] = MarhTracert[1].ObjLast then
                      begin
                        oe := MarhTracert[1].ObjLast; break;
                      end else
                      begin // откатить на один объект к началу
                        MarhTracert[1].ObjTrace[j] := 0; dec(MarhTracert[1].Counter);
                      end;
                    end;
                    dec(j);
                  end;
                  if j <= c then
                  begin // Конец трассировки
                    oe := MarhTracert[1].ObjLast; break;
                  end;
                end else
                begin // Конец трассировки
                  oe := MarhTracert[1].ObjLast; break;
                end;
              end else break;
            end;
            MarhTracert[1].Level := tlFindTrace; //
            dec(i);
          end;

          if i < 1 then
          begin // превышен счетчик попыток
            oe := MarhTracert[1].ObjLast;
          end;
        end;









        while MarhTracert[1].Counter > c do
        begin // убрать признаки трассировки перед продолжением набора
          if ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].TypeObj = 2 then // стрелка
          begin
            ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[10] := false;
            ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[11] := false;
            ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[12] := false;
            ObjZav[MarhTracert[1].ObjTrace[MarhTracert[1].Counter]].bParam[13] := false;
          end;
          MarhTracert[1].ObjTrace[MarhTracert[1].Counter] := 0;
          dec(MarhTracert[1].Counter);
        end;
        MarhTracert[1].MsgCount := 0;
        MarhTracert[1].WarCount := wc;
        MarhTracert[1].ObjEnd   := oe;

        if MarhTracert[1].ObjEnd > 0 then
        begin // Завершить набор если нельзя продолжить трассу

          if (ObjZav[MarhTracert[1].ObjLast].TypeObj = 5) and (MarhTracert[1].PinLast = 2) and
            not (ObjZav[MarhTracert[1].ObjLast].bParam[1] or ObjZav[MarhTracert[1].ObjLast].bParam[2] or
                 ObjZav[MarhTracert[1].ObjLast].bParam[3] or ObjZav[MarhTracert[1].ObjLast].bParam[4]) then
          begin
            if ObjZav[MarhTracert[1].ObjLast].bParam[5] then // о
            begin // Маршрут не прикрыт запрещающим огнем попутного
              inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,115, ObjZav[MarhTracert[1].ObjLast].Liter);
              InsWar(1,MarhTracert[1].ObjLast,115);
            end;
            case MarhTracert[1].Rod of // проверка открытия впереди стоящего сигнала если короткий блок-участок
              MarshP : begin
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[19] and not ObjZav[MarhTracert[1].ObjLast].bParam[4] then
                begin
                  InsArcNewMsg(MarhTracert[1].ObjLast,391);
                  ShowShortMsg(391,LastX,LastY,ObjZav[MarhTracert[1].ObjLast].Liter); exit;
                end;
              end;
              MarshM : begin
                if ObjZav[MarhTracert[1].ObjLast].ObjConstB[20] and not ObjZav[MarhTracert[1].ObjLast].bParam[2] then
                begin
                  InsArcNewMsg(MarhTracert[1].ObjLast,391);
                  ShowShortMsg(391,LastX,LastY,ObjZav[MarhTracert[1].ObjLast].Liter); exit;
                end;
              end;
            else
              result := false; exit;
            end;
          end;
          // Проверить предмаршрутный участок на отсутствие поезда на незамкнутых стрелках
          if FindIzvStrelki(MarhTracert[1].ObjStart, MarhTracert[1].Rod) then
          begin
            inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,333, ObjZav[MarhTracert[1].ObjStart].Liter);
            InsWar(1,MarhTracert[1].ObjStart,333);
          end;

          MarhTracert[1].TailMsg := tm; // восстановить сообщение в хвосте маршрута

          if MarhTracert[1].WarCount > 0 then
          begin // Вывод предупреждений
            SingleBeep := true; TimeLockCmdDsp := LastTime; LockCommandDsp := true;
            CreateDspMenu(KeyMenu_ReadyWarningTrace,LastX,LastY);
          end else
          begin
            CreateDspMenu(CmdMarsh_Ready,LastX,LastY);
          end;
          MarhTracert[1].Finish := true;
        end else
        begin
          MarhTracert[1].TailMsg := tm; // восстановить сообщение в хвосте маршрута
          InsArcNewMsg(MarhTracert[1].ObjStart,1);
          ShowShortMsg(1, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
        end;
      end;
    end else
    begin
      InsArcNewMsg(MarhTracert[1].ObjStart,180);
      RestorePrevTrace; result := false; ShowShortMsg(180, LastX, LastY, ObjZav[MarhTracert[1].ObjStart].Liter);
    end;
  end else
    result := false;
except
  reportf('Ошибка [Marshrut.NextToTracertMarshrut]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Обработка шага по базе
function StepTrace(var Con : TOZNeighbour; const Lvl : TTracertLevel; Rod : Byte; Group : Byte) : TTracertResult;
  var o,j,k,m : integer; tail,tr,p,mk,zak : boolean; jmp : TOZNeighbour;
begin
try
  result := trStop;
  case Lvl of
    tlVZavTrace,tlCheckTrace,tlZamykTrace : begin // проверка целостности трассы
      if MarhTracert[Group].CIndex <= MarhTracert[Group].Counter then
      begin
        if Con.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].CIndex] then exit; // Если объект не относится к трассе - остановить трассировку
      end else
      if MarhTracert[Group].CIndex = MarhTracert[Group].Counter+1 then
        if Con.Obj <> MarhTracert[Group].ObjEnd then exit; // Если объект не хвост трассы - остановить трассировку
    end;
    tlStepBack : begin
      jmp := Con; //При откате перешагнуть объекты Дз
      case ObjZav[jmp.Obj].TypeObj of
        27,29 : begin
          if jmp.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;
      else
        result := trStop; exit;
      end;
      if MarhTracert[Group].Counter > 0 then
      begin
        MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] := 0; dec(MarhTracert[Group].Counter);
      end else
        result := trStop;
      exit;
    end;
  end;

  jmp := Con;
  case ObjZav[jmp.Obj].TypeObj of
  //////////////////////////////////////////////////////////////////////////////
    2 : begin // стрелка
      case Lvl of
        tlFindTrace : begin
          case Con.Pin of
            1 : begin // Против шерсти
              if ObjZav[jmp.Obj].ObjConstB[1] then
              begin // Сбрасывающая стрелка трассируется только по минусу
                Con := ObjZav[jmp.Obj].Neighbour[3];
                ObjZav[jmp.Obj].bParam[10] := true; // Пометить проход
                ObjZav[jmp.Obj].bParam[11] := true; // Пометить проход
              end else
              begin // Ходовая стрелка
                if ObjZav[jmp.Obj].ObjConstB[3] then
                begin // основные маршруты по минусу
                  if not ObjZav[jmp.Obj].bParam[10] then
                  begin // Вначале идти по минусу стрелки
                    Con := ObjZav[jmp.Obj].Neighbour[3];
                    ObjZav[jmp.Obj].bParam[10] := true; // Пометить первичный проход
                    ObjZav[jmp.Obj].bParam[11] := true; // Пометить первичный проход
                  end else
                  begin // Вторично пройти по плюсу стрелки
                    Con := ObjZav[jmp.Obj].Neighbour[2];
                    ObjZav[jmp.Obj].bParam[11] := false; // Пометить вторичный проход
                  end;
                end else
                begin // Основные маршруты по плюсу
                  if ObjZav[jmp.Obj].bParam[10] then
                  begin // Вторично идти по минусу стрелки
                    Con := ObjZav[jmp.Obj].Neighbour[3];
                    ObjZav[jmp.Obj].bParam[11] := true; // Пометить вторичный проход
                  end else
                  begin // Вначале пройти по плюсу стрелки
                    Con := ObjZav[jmp.Obj].Neighbour[2];
                    ObjZav[jmp.Obj].bParam[10] := true; // Пометить первичный проход
                  end;
                end;
              end;
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              else
                result := trNextStep;
              end;
            end;

            2 : begin // По шерсти с плюса
              ObjZav[jmp.Obj].bParam[12] := true; // Пометить проход по шерсти с плюса

              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              else
                result := trNextStep;
              end;
            end;

            3 : begin // По шерсти с минуса
              ObjZav[jmp.Obj].bParam[13] := true; // Пометить проход по шерсти с минуса

              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              else
                result := trNextStep;
              end;
            end;
          end;
        end;

        tlContTrace : begin
          p := false;
          case Con.Pin of
            1 : begin
              if MarhTracert[Group].VP > 0 then
              begin // есть список стрелок в пути
                for k := 1 to 4 do
                  if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
                     ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
                  begin // трассировать стрелку по плюсу
                    Con := ObjZav[jmp.Obj].Neighbour[2];
                    ObjZav[jmp.Obj].bParam[10] := true;
                    ObjZav[jmp.Obj].bParam[11] := false;
                    ObjZav[jmp.Obj].bParam[12] := false;
                    ObjZav[jmp.Obj].bParam[13] := false;
                    result := trNextStep;
                    p := true;
                    break;
                  end;
                if not p then
                begin // стрелка не описана в текущем списке стрелок в пути
                  con := ObjZav[jmp.Obj].Neighbour[1];
                  result := trBreak; // откатить от стрелки
                end;
              end else
              if ObjZav[jmp.Obj].ObjConstB[1] then
              begin // сбрасывающая стрелка трассируется по минусу
                Con := ObjZav[jmp.Obj].Neighbour[3];
                ObjZav[jmp.Obj].bParam[10] := true;
                ObjZav[jmp.Obj].bParam[11] := true;
                ObjZav[jmp.Obj].bParam[12] := false;
                ObjZav[jmp.Obj].bParam[13] := false;
                result := trNextStep;
              end else
              begin // нет стрелок в пути и сбрасывающих
                con := ObjZav[jmp.Obj].Neighbour[1];
                result := trBreak; // откатить от стрелки
              end;
            end;

            2 : begin
              ObjZav[jmp.Obj].bParam[12] := true; // Пометить проход по шерсти с плюса

              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : result := trStop;
              else
                result := trNextStep;
              end;
            end;

            3 : begin
              ObjZav[jmp.Obj].bParam[13] := true; // Пометить проход по шерсти с минуса

              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : result := trStop;
              else
                result := trNextStep;
              end;
            end;
          end;
        end;

        tlVZavTrace : begin
          case Con.Pin of
            1 : begin
            // проверить трассировку по мунусу стрелки в пути в поездном маршруте
              if MarhTracert[Group].VP > 0 then
              begin // есть список стрелок в пути
                for k := 1 to 4 do
                  if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
                     ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
                  begin // проверить трассировку стрелки по минусу
                    if ObjZav[jmp.Obj].bParam[10] and ObjZav[jmp.Obj].bParam[11] then exit;
                  end;
              end;

              if ObjZav[jmp.Obj].bParam[10] and not ObjZav[jmp.Obj].bParam[11] then
              begin
                con := ObjZav[jmp.Obj].Neighbour[2];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
              if ObjZav[jmp.Obj].bParam[10] and ObjZav[jmp.Obj].bParam[11] then
              begin
                con := ObjZav[jmp.Obj].Neighbour[3];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
                result := trStop;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[12]  then
              begin
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;

            3 : begin
              if ObjZav[jmp.Obj].bParam[13] then
              begin
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;
          end;
        end;

        tlCheckTrace : begin
          // Проверить замыкание маршрута отправления со стрелкой в пути
          if not CheckOtpravlVP(jmp.Obj,Group) then result := trBreak;
          // Проверить ограждение пути через Вз стрелки
          if not CheckOgrad(jmp.Obj,Group) then result := trBreak;
          if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];
          if ObjZav[jmp.Obj].bParam[16] or zak then
          begin // стрелка закрыта для движения
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,119, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,119); MarhTracert[Group].GonkaStrel := false;
          end;
          case Con.Pin of
            1 : begin
              if not ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка не сбрасывающая или остряки не развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453); MarhTracert[Group].GonkaStrel := false;
                end;
              end;
              if (not MarhTracert[Group].Povtor and (ObjZav[jmp.Obj].bParam[10] and not ObjZav[jmp.Obj].bParam[11])) or // требуется по плюсу при наборе
                 (MarhTracert[Group].Povtor and (ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7])) then // требуется по плюсу при повторе
              begin
                if  not NegStrelki(jmp.Obj,true,Group) then result := trBreak; // негабаритность
                if ObjZav[jmp.Obj].bParam[1] then
                begin
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                  begin // стрелка на макете - выдать предупреждение
                    if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                    begin // Повторить предупреждение для лидирующей стрелки
                      if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
                      begin
                        result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,jmp.Obj,120);
                      end;
                    end else
                    begin
                      if not MarhTracert[Group].Dobor then begin ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj; ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true; end;
                      result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                    end;
                  end;
                end else
                begin
                  if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                  begin // стрелка на макете - враждебность
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,136); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then // замыкание секции
                  begin
                    o := GetStateSP(1,jmp.Obj);
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[o].Liter); InsMsg(Group,o,82); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then // замыкание в хвосте
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then
                  begin
                    o := GetStateSP(2,jmp.Obj);
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[o].Liter); InsMsg(Group,o,83); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if ObjZav[jmp.Obj].bParam[18] then
                  begin // стрелка выключена из управления
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,121); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if MarhTracert[Group].Povtor then
                  begin // проверка повторной установки маршрута
                    if not ObjZav[jmp.Obj].bParam[2] then
                    begin
                      result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin // проверка первичной трассировки маршрута
                    if not ObjZav[jmp.Obj].bParam[2] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
                    begin
                      result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                end;
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                end else
                con := ObjZav[jmp.Obj].Neighbour[2];
                if result = trBreak then exit;
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
              if (not MarhTracert[Group].Povtor and (ObjZav[jmp.Obj].bParam[10] and ObjZav[jmp.Obj].bParam[11])) or // требуется по минусу при наборе
                 (MarhTracert[Group].Povtor and (not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7])) then // требуется по минусу при повторе
              begin
                if  not NegStrelki(jmp.Obj,false,Group) then result := trBreak; // негабаритность
                if ObjZav[jmp.Obj].bParam[2] then
                begin
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                  begin // стрелка на макете - выдать предупреждение
                    if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                    begin // Повторить предупреждение для лидирующей стрелки
                      if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
                      begin
                        result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                      end;
                    end else
                    begin
                      if not MarhTracert[Group].Dobor then begin ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj; ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true; end;
                      result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                    end;
                  end;
                end else
                begin
                  if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                  begin // стрелка на макете - враждебность
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,137); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then
                  begin
                    o := GetStateSP(1,jmp.Obj);
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[o].Liter); InsMsg(Group,o,82); MarhTracert[Group].GonkaStrel := false;
                  end else
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                  end else
                  if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then
                  begin
                    o := GetStateSP(2,jmp.Obj);
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[o].Liter); InsMsg(Group,o,83); MarhTracert[Group].GonkaStrel := false;
                  end else
                  if ObjZav[jmp.Obj].bParam[18] then
                  begin // стрелка выключена из управления
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,159); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if MarhTracert[Group].Povtor then
                  begin // проверка повторной установки маршрута
                    if not ObjZav[jmp.Obj].bParam[1] then
                    begin
                      result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin // проверка первичной трассировки маршрута
                    if not ObjZav[jmp.Obj].bParam[1] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
                    begin
                      result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                end;
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                end;
                con := ObjZav[jmp.Obj].Neighbour[3];
                if result = trBreak then exit;
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
                result := trStop;
            end;

            2 : begin
              if  not NegStrelki(jmp.Obj,true,Group) then result := trBreak; // негабаритность
              if ObjZav[jmp.Obj].bParam[1] then
              begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                begin // стрелка на макете - выдать предупреждение
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                  begin // Повторить предупреждение для лидирующей стрелки
                    if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
                    begin
                      result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                    end;
                  end else
                  begin
                    if not MarhTracert[Group].Dobor then begin ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj; ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true; end;
                    result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                  end;
                end;
              end else
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                begin // стрелка на макете - враждебность
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,136); MarhTracert[Group].GonkaStrel := false;
                end;
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then
                begin
                  o := GetStateSP(1,jmp.Obj);
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[o].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,82); MarhTracert[Group].GonkaStrel := false;
                end;
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                end;
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then
                begin
                  o := GetStateSP(2,jmp.Obj);
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[o].Liter); InsMsg(Group,o,83); MarhTracert[Group].GonkaStrel := false;
                end;
                if ObjZav[jmp.Obj].bParam[18] then
                begin // стрелка выключена из управления
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,121); MarhTracert[Group].GonkaStrel := false;
                end;
                if MarhTracert[Group].Povtor then
                begin // проверка повторной установки маршрута
                  if not ObjZav[jmp.Obj].bParam[2] then
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                begin // проверка первичной трассировки маршрута
                  if not ObjZav[jmp.Obj].bParam[2] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                  end;
                end;
              end;
              if (not MarhTracert[Group].Povtor and ObjZav[jmp.Obj].bParam[12]) or
                 (MarhTracert[Group].Povtor and ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7]) then
              begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                end else
                if not ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                end;
                con := ObjZav[jmp.Obj].Neighbour[1];
                if result = trBreak then exit;
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;

            3 : begin
              if ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка сбрасывающая и остряки развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453); MarhTracert[Group].GonkaStrel := false;
                end;
              end;
              if  not NegStrelki(jmp.Obj,false,Group) then result := trBreak; // негабаритность
              if ObjZav[jmp.Obj].bParam[2] then
              begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                begin // стрелка на макете - выдать предупреждение
                  if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                  begin // Повторить предупреждение для лидирующей стрелки
                    if ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] = jmp.Obj then
                    begin
                      result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                    end;
                  end else
                  begin
                    if not MarhTracert[Group].Dobor then begin ObjZav[ObjZav[jmp.Obj].BaseObject].iParam[3] := jmp.Obj; ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true; end;
                    result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                  end;
                end;
              end else
              begin
                if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] then
                begin // стрелка на макете - враждебность
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,137); MarhTracert[Group].GonkaStrel := false;
                end;
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[21] then
                begin
                  o := GetStateSP(1,jmp.Obj);
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[o].Liter); InsMsg(Group,o,82); MarhTracert[Group].GonkaStrel := false;
                end;
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[4] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                end;
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[22] then
                begin
                  o := GetStateSP(2,jmp.Obj);
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[o].Liter); InsMsg(Group,o,83); MarhTracert[Group].GonkaStrel := false;
                end;
                if ObjZav[jmp.Obj].bParam[18] then
                begin // стрелка выключена из управления
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,159); MarhTracert[Group].GonkaStrel := false;
                end;
                if MarhTracert[Group].Povtor then
                begin // проверка повторной установки маршрута
                  if not ObjZav[jmp.Obj].bParam[1] then
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                  end;
                end else
                begin // проверка первичной трассировки маршрута
                  if not ObjZav[jmp.Obj].bParam[1] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                  end;
                end;
              end;
              if (not MarhTracert[Group].Povtor and ObjZav[jmp.Obj].bParam[13]) or
                 (MarhTracert[Group].Povtor and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] and ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7]) then
              begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,80); MarhTracert[Group].GonkaStrel := false;
                end else
                if not ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81); MarhTracert[Group].GonkaStrel := false;
                end;
                con := ObjZav[jmp.Obj].Neighbour[1];
                if result = trBreak then exit;
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;
          end;
        end;

        tlZamykTrace : begin
          case Con.Pin of
            1 : begin
              p := false; mk := false;
              if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
              begin // нет замыкания и РМ
                if ObjZav[jmp.Obj].bParam[10] then
                begin
                  if ObjZav[jmp.Obj].bParam[11] then
                  begin // трассировка по минусу
                    mk := true; p := false;
                  end else
                  begin // трассировка по плюсу
                    p := true; mk := false;
                  end;
                end;
              end else // есть замыкание или РМ
              begin
                if ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] then
                begin // контроль по плюсу
                  p := true; mk := false;
                end else
                if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
                begin // контроль по минусу
                  mk := true; p := false;
                end;
              end;

              if p and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] then
              begin
                con := ObjZav[jmp.Obj].Neighbour[2];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                if result = trNextStep then
                begin
                  if not ObjZav[jmp.Obj].ObjConstB[1] then
                  begin
                    inc(MarhTracert[Group].StrCount);
                    MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount] := jmp.Obj;
                    MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := true;
                    MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := false;
                  end;
                  ObjZav[jmp.Obj].bParam[6] := true;   // ПУ
                  ObjZav[jmp.Obj].bParam[7] := false;  // МУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := true;   // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false;  // МУ
                  ObjZav[jmp.Obj].bParam[10] := false; // трасса
                  ObjZav[jmp.Obj].bParam[11] := false; // трасса
                  ObjZav[jmp.Obj].bParam[12] := false; // трасса
                  ObjZav[jmp.Obj].bParam[13] := false; // трасса
                  ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;  // прог. замыкание
                  ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
                end;
                exit;
              end else
              if mk and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] then
              begin
                con := ObjZav[jmp.Obj].Neighbour[3];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                if result = trNextStep then
                begin
                  if not ObjZav[jmp.Obj].ObjConstB[1] then
                  begin
                    inc(MarhTracert[Group].StrCount);
                    MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount] := jmp.Obj;
                    MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := false;
                    MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := true;
                  end;
                  ObjZav[jmp.Obj].bParam[6] := false;  // ПУ
                  ObjZav[jmp.Obj].bParam[7] := true;   // МУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := true;  // МУ
                  ObjZav[jmp.Obj].bParam[10] := false; // трасса
                  ObjZav[jmp.Obj].bParam[11] := false; // трасса
                  ObjZav[jmp.Obj].bParam[12] := false; // трасса
                  ObjZav[jmp.Obj].bParam[13] := false; // трасса
                  ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;  // прог. замыкание
                  ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
                end;
                exit;
              end else
                result := trStop;
            end;

            2 : begin
              if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
              begin // нет замыкания и РМ
               if ObjZav[jmp.Obj].bParam[12] then result := trNextStep; // нет трассировки по плюсу - сброс
              end else // есть замыкание или РМ
               if ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] then result := trNextStep;  // нет контроля по плюсу - сброс
              if result = trNextStep then
              begin
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  ObjZav[jmp.Obj].bParam[6] := true;   // ПУ
                  ObjZav[jmp.Obj].bParam[7] := false;  // МУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := true;  // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
                  ObjZav[jmp.Obj].bParam[10] := false; // трасса
                  ObjZav[jmp.Obj].bParam[11] := false; // трасса
                  ObjZav[jmp.Obj].bParam[12] := false; // трасса
                  ObjZav[jmp.Obj].bParam[13] := false; // трасса
                  ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;  // прог. замыкание
                  ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
                end;
              end;
            end;

            3 : begin
              if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
              begin // нет замыкания и РМ
               if ObjZav[jmp.Obj].bParam[13] then result := trNextStep; // нет трассировки по минусу - сброс
              end else // есть замыкание или РМ
               if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then result := trNextStep;  // нет контроля по минусу - сброс
              if result = trNextStep then
              begin
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  ObjZav[jmp.Obj].bParam[6] := false; // ПУ
                  ObjZav[jmp.Obj].bParam[7] := true;  // МУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := true;  // МУ
                  ObjZav[jmp.Obj].bParam[10] := false; // трасса
                  ObjZav[jmp.Obj].bParam[11] := false; // трасса
                  ObjZav[jmp.Obj].bParam[12] := false; // трасса
                  ObjZav[jmp.Obj].bParam[13] := false; // трасса
                  ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[14] := true;  // прог. замыкание
                  ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
                end;
              end;
            end;
          end;
        end;

        tlSignalCirc : begin
          result := trNextStep;
          // Проверить замыкание маршрута отправления со стрелкой в пути
          if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;
          // Проверить ограждение пути через Вз стрелки
          if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути
          if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];
          if ObjZav[jmp.Obj].bParam[16] or zak then
          begin // стрелка закрыта для движения
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,119, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,119);
          end;
          if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
          begin // нет контроля положения
            result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
          end else
          if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group) then result := trStop; // негабаритность

          case Con.Pin of

            1 : begin
            // проверить трассировку по мунусу стрелки в пути в поездном маршруте
              if MarhTracert[Group].VP > 0 then
              begin // есть список стрелок в пути
                for k := 1 to 4 do
                  if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
                     ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
                  begin // проверить трассировку стрелки по минусу
                    if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
                    begin
                      result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,482, ObjZav[jmp.Obj].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,482);
                    end;
                  end;
              end;

              if not ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка не сбрасывающая или остряки не развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
              begin // стрелка на макете - выдать предупреждение
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                con := ObjZav[jmp.Obj].Neighbour[2];
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                con := ObjZav[jmp.Obj].Neighbour[3];
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241); result := trStop;
                  end;
                end;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242); result := trStop;
                  end;
                end;
            end;

            3 : begin
              if ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка сбрасывающая и остряки развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243); result := trStop;
                  end;
                end;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          case Con.Pin of
            1 : begin
              if ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] and not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[9] then
              begin // нет замыкания и РМ
                if ObjZav[jmp.Obj].bParam[6] then
                begin
                  con := ObjZav[jmp.Obj].Neighbour[2];
                  case Con.TypeJmp of
                    LnkRgn : result := trStop;
                    LnkEnd : result := trStop;
                  else
                    result := trNextStep;
                  end;
                  if result = trNextStep then
                  begin
                    ObjZav[jmp.Obj].bParam[6] := false; // ПУ
                    ObjZav[jmp.Obj].bParam[7] := false; // МУ
                    o := 0;
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
                    else
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];
                    if (o > 0) then
                    begin // пороверить наличие гонки для спаренной стрелки
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
                    end else
                    begin // сбросить гонку стрелок в объекте ХС
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
                    end;
                    ObjZav[jmp.Obj].bParam[10] := false; // трасса
                    ObjZav[jmp.Obj].bParam[11] := false; // трасса
                    ObjZav[jmp.Obj].bParam[12] := false; // трасса
                    ObjZav[jmp.Obj].bParam[13] := false; // трасса
                    ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
                    SetPrgZamykFromXStrelka(jmp.Obj);
                    ObjZav[jmp.Obj].iParam[1]  := 0;
                  end;
                  exit;
                end else
                if ObjZav[jmp.Obj].bParam[7] then
                begin
                  con := ObjZav[jmp.Obj].Neighbour[3];
                  case Con.TypeJmp of
                    LnkRgn : result := trStop;
                    LnkEnd : result := trStop;
                  else
                    result := trNextStep;
                  end;
                  if result = trNextStep then
                  begin
                    ObjZav[jmp.Obj].bParam[6] := false; // ПУ
                    ObjZav[jmp.Obj].bParam[7] := false; // МУ
                    o := 0;
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
                    else
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];
                    if (o > 0) then
                    begin // пороверить наличие гонки для спаренной стрелки
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
                    end else
                    begin // сбросить гонку стрелок в объекте ХС
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
                    end;
                    ObjZav[jmp.Obj].bParam[10] := false; // трасса
                    ObjZav[jmp.Obj].bParam[11] := false; // трасса
                    ObjZav[jmp.Obj].bParam[12] := false; // трасса
                    ObjZav[jmp.Obj].bParam[13] := false; // трасса
                    ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
                    SetPrgZamykFromXStrelka(jmp.Obj);
                    ObjZav[jmp.Obj].iParam[1]  := 0;
                  end;
                  exit;
                end else
                  result := trStop;
              end else
              begin // Есть замыкание или РМ - пройти по имеющемуся положению стрелки
                if ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].bParam[2] then
                begin // пройти по плюсу стрелки
                  con := ObjZav[jmp.Obj].Neighbour[2];
                  case Con.TypeJmp of
                    LnkRgn : result := trStop;
                    LnkEnd : result := trStop;
                  else
                    result := trNextStep;
                  end;
                  if result = trNextStep then
                  begin
                    ObjZav[jmp.Obj].bParam[6] := false; // ПУ
                    ObjZav[jmp.Obj].bParam[7] := false; // МУ
                    o := 0;
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
                    else
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];
                    if (o > 0) then
                    begin // пороверить наличие гонки для спаренной стрелки
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
                    end else
                    begin // сбросить гонку стрелок в объекте ХС
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
                    end;
                    ObjZav[jmp.Obj].bParam[10] := false; // трасса
                    ObjZav[jmp.Obj].bParam[11] := false; // трасса
                    ObjZav[jmp.Obj].bParam[12] := false; // трасса
                    ObjZav[jmp.Obj].bParam[13] := false; // трасса
                    ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
                    SetPrgZamykFromXStrelka(jmp.Obj);
                    ObjZav[jmp.Obj].iParam[1]  := 0;
                  end;
                  exit;
                end else
                if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
                begin // пройти по минусу стрелки
                  con := ObjZav[jmp.Obj].Neighbour[3];
                  case Con.TypeJmp of
                    LnkRgn : result := trStop;
                    LnkEnd : result := trStop;
                  else
                    result := trNextStep;
                  end;
                  if result = trNextStep then
                  begin
                    ObjZav[jmp.Obj].bParam[6] := false; // ПУ
                    ObjZav[jmp.Obj].bParam[7] := false; // МУ
                    o := 0;
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
                    else
                    if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
                      o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];
                    if (o > 0) then
                    begin // пороверить наличие гонки для спаренной стрелки
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
                    end else
                    begin // сбросить гонку стрелок в объекте ХС
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
                    end;
                    ObjZav[jmp.Obj].bParam[10] := false; // трасса
                    ObjZav[jmp.Obj].bParam[11] := false; // трасса
                    ObjZav[jmp.Obj].bParam[12] := false; // трасса
                    ObjZav[jmp.Obj].bParam[13] := false; // трасса
                    ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
                    SetPrgZamykFromXStrelka(jmp.Obj);
                    ObjZav[jmp.Obj].iParam[1]  := 0;
                  end;
                  exit;
                end else
                  result := trStop; // стрелка не имеет контроля положения - дальше не ходить
              end;
            end;

            2 : begin
              con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : result := trStop;
              else
                result := trNextStep;
              end;
              if result = trNextStep then
              begin
                ObjZav[jmp.Obj].bParam[6] := false; // ПУ
                ObjZav[jmp.Obj].bParam[7] := false; // МУ
                o := 0;
                if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
                  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
                else
                if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
                  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];
                if (o > 0) then
                begin // пороверить наличие гонки для спаренной стрелки
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
                end else
                begin // сбросить гонку стрелок в объекте ХС
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
                end;
                ObjZav[jmp.Obj].bParam[10] := false; // трасса
                ObjZav[jmp.Obj].bParam[11] := false; // трасса
                ObjZav[jmp.Obj].bParam[12] := false; // трасса
                ObjZav[jmp.Obj].bParam[13] := false; // трасса
                ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
                SetPrgZamykFromXStrelka(jmp.Obj);
                ObjZav[jmp.Obj].iParam[1]  := 0;
              end;
            end;

            3 : begin
              con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : result := trStop;
              else
                result := trNextStep;
              end;
              if result = trNextStep then
              begin
                ObjZav[jmp.Obj].bParam[6] := false; // ПУ
                ObjZav[jmp.Obj].bParam[7] := false; // МУ
                o := 0;
                if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8] <> jmp.Obj) then
                  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[8]
                else
                if (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] > 0) and (ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9] <> jmp.Obj) then
                  o := ObjZav[ObjZav[jmp.Obj].BaseObject].ObjConstI[9];
                if (o > 0) then
                begin // пороверить наличие гонки для спаренной стрелки
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := ObjZav[o].bParam[6]; // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := ObjZav[o].bParam[7]; // МУ
                end else
                begin // сбросить гонку стрелок в объекте ХС
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[6] := false; // ПУ
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[7] := false; // МУ
                end;
                ObjZav[jmp.Obj].bParam[10] := false; // трасса
                ObjZav[jmp.Obj].bParam[11] := false; // трасса
                ObjZav[jmp.Obj].bParam[12] := false; // трасса
                ObjZav[jmp.Obj].bParam[13] := false; // трасса
                ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
                SetPrgZamykFromXStrelka(jmp.Obj);
                ObjZav[jmp.Obj].iParam[1]  := 0;
              end;
            end;
          end;
        end;

        tlRazdelSign : begin
          result := trNextStep;
          // Проверить замыкание маршрута отправления со стрелкой в пути
          if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;
          // Проверить ограждение пути через Вз стрелки
          if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути
          if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];
          if ObjZav[jmp.Obj].bParam[16] or zak then
          begin // стрелка закрыта для движения
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,119, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,119);
          end;
          if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
          begin // нет контроля положения
            result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
          end else
          if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group) then result := trStop; // негабаритность

          case Con.Pin of

            1 : begin
            // проверить трассировку по мунусу стрелки в пути в поездном маршруте
              if MarhTracert[Group].VP > 0 then
              begin // есть список стрелок в пути
                for k := 1 to 4 do
                  if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
                     ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
                  begin // проверить трассировку стрелки по минусу
                    if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
                    begin
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,482, ObjZav[jmp.Obj].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,482);
                    end;
                  end;
              end;

              if not ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка не сбрасывающая или остряки не развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
              begin // стрелка на макете - выдать предупреждение
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter);InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                ObjZav[jmp.Obj].bParam[10] := true; ObjZav[jmp.Obj].bParam[11] := false;// +
                con := ObjZav[jmp.Obj].Neighbour[2];
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                ObjZav[jmp.Obj].bParam[10] := true; ObjZav[jmp.Obj].bParam[11] := true; // -
                con := ObjZav[jmp.Obj].Neighbour[3];
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241);
                    result := trStop;
                  end;
                end;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin // стрелка в плюсе
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // стрелка в минусе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              if result <> trStop then
                ObjZav[jmp.Obj].bParam[12] := true; // +
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
                    result := trStop;
                  end;
                end;
            end;

            3 : begin
              if ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка сбрасывающая и остряки развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // стрелка в плюсе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // стрелка в минусе
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              if result <> trStop then
                ObjZav[jmp.Obj].bParam[13] := true; // -
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243); result := trStop;
                  end;
                end;
            end;
          end;
        end;

        tlAutoTrace : begin
          result := trNextStep;
          // Проверить замыкание маршрута отправления со стрелкой в пути
          if not SignCircOtpravlVP(jmp.Obj,Group) then result := trStop;
          // Проверить ограждение пути через Вз стрелки
          if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути
          if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];
          if ObjZav[jmp.Obj].bParam[16] or zak then
          begin // стрелка закрыта для движения
            result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,119, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,119);
          end;
          if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
          begin // нет контроля положения
            result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
          end else
          if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group) then result := trStop; // негабаритность

          case Con.Pin of

            1 : begin
              if not ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка не сбрасывающая или остряки не развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
              begin // стрелка на макете - выдать предупреждение
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                con := ObjZav[jmp.Obj].Neighbour[2];
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                con := ObjZav[jmp.Obj].Neighbour[3];
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241); result := trStop;
                  end;
                end;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  result := trStop;  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242);
                    result := trStop;
                  end;
                end;
            end;

            3 : begin
              if ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка сбрасывающая и остряки развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243); result := trStop;
                  end;
                end;
            end;
          end;
        end;

        tlPovtorRazdel : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[16] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[17];
          if ObjZav[jmp.Obj].bParam[16] or zak then
          begin // стрелка закрыта для движения
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,119, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,119);
          end;
          if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
          begin // нет контроля положения
            result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,81);
          end else
          if not SigCircNegStrelki(jmp.Obj,ObjZav[jmp.Obj].bParam[1],Group) then result := trStop; // негабаритность

          case Con.Pin of

            1 : begin
            // проверить трассировку по мунусу стрелки в пути в поездном маршруте
              if MarhTracert[Group].VP > 0 then
              begin // есть список стрелок в пути
                for k := 1 to 4 do
                  if (ObjZav[MarhTracert[Group].VP].ObjConstI[k] = jmp.Obj) and // индекс стрелки в пути
                     ObjZav[MarhTracert[Group].VP].ObjConstB[k+1] then          // признак добора трассы по плюсу
                  begin // проверить трассировку стрелки по минусу
                    if not ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[2] then
                    begin
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,482, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,482);
                    end;
                  end;
              end;

              if not ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка не сбрасывающая или остряки не развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
              begin // стрелка на макете - выдать предупреждение
                ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,120);
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                if not ObjZav[jmp.Obj].bParam[6] then
                begin // стрелка не по маршруту
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
                end else
                begin
                  ObjZav[jmp.Obj].bParam[10] := true; ObjZav[jmp.Obj].bParam[11] := false;// +
                  con := ObjZav[jmp.Obj].Neighbour[2];
                end;
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                if not ObjZav[jmp.Obj].bParam[7] then
                begin // стрелка не по маршруту
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
                end else
                begin
                  ObjZav[jmp.Obj].bParam[10] := true; ObjZav[jmp.Obj].bParam[11] := true; // -
                  con := ObjZav[jmp.Obj].Neighbour[3];
                end;
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              // Проверить ограждение пути через Вз стрелки
              if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути
              if result <> trStop then
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,241, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,241); result := trStop;
                  end;
                end;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                if not ObjZav[jmp.Obj].bParam[6] then
                begin // стрелка не по маршруту
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
                end;
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              // Проверить ограждение пути через Вз стрелки
              if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути
              if result <> trStop then
                ObjZav[jmp.Obj].bParam[12] := true; // +
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,242, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,242); result := trStop;
                  end;
                end;
            end;

            3 : begin
              if ObjZav[jmp.Obj].ObjConstB[11] then
              begin // стрелка сбрасывающая и остряки развернуты
                if ObjZav[jmp.Obj].ObjConstB[6] then zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[33] else zak := ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[34];
                if ObjZav[jmp.Obj].bParam[17] or zak then
                begin // стрелка закрыта для противошерстного движения
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,453, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,453);
                end;
              end;
              if ObjZav[jmp.Obj].bParam[1] then
              begin // отклоняющая стрелка в плюсе
                result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // отклоняющая стрелка в минусе
                if not ObjZav[jmp.Obj].bParam[7] then
                begin // стрелка не по маршруту
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,160, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,160);
                end;
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[19] and not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                begin // стрелка на макете - выдать предупреждение
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,120, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,120);
                end;
              end else
              begin // нет контроля положения
                result := trStop;
              end;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              // Проверить ограждение пути через Вз стрелки
              if not SignCircOgrad(jmp.Obj,Group) then result := trStop; // Ограждение пути
              if result <> trStop then
                ObjZav[jmp.Obj].bParam[13] := true; // -
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,243, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,243); result := trStop;
                  end;
                end;
            end;
          end;
        end;

        tlFindIzvest : begin
          if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
          begin // Если стрелка не имеет контроля положения - прервать сборку известителя
            result := trStop; exit;
          end;
          case Con.Pin of
            1 : begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin // по плюсу
                con := ObjZav[jmp.Obj].Neighbour[2];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // по минусу
                con := ObjZav[jmp.Obj].Neighbour[3];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
                result := trStop;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[1]  then
              begin // по плюсу
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;

            3 : begin
              if ObjZav[jmp.Obj].bParam[2] then
              begin // по минусу
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;
          end;
        end;

        tlFindIzvStrel : begin
          if not (ObjZav[jmp.Obj].bParam[1] xor ObjZav[jmp.Obj].bParam[2]) then
          begin // Если стрелка не имеет контроля положения - прервать сборку известителя
            result := trStop; exit;
          end;

          o := ObjZav[jmp.Obj].BaseObject;
          zak := false;
          if Rod = MarshP then
          begin // проверить замыкание стрелки (в пути) в маршруте отправления с пути
            for j := 14 to 19 do
            begin
              if ObjZav[ObjZav[o].ObjConstI[j]].TypeObj = 41 then
              begin // контроль маршрута отправления с пути со стрелкой в пути
                if ObjZav[ObjZav[o].ObjConstI[j]].BaseObject = Marhtracert[Group].ObjStart then
                begin // стрелка замыкается в поездном маршруте как охранная
                  zak := true; break;
                end;
              end;
            end;
          end;
          if not zak then
          begin // проверить исключение перевода стрелки
            k := ObjZav[jmp.Obj].UpdateObject;
            if not (ObjZav[ObjZav[o].ObjConstI[12]].bParam[1] or // РзС
               ObjZav[jmp.Obj].bParam[5] or     // признак перевода охранной
               not ObjZav[k].bParam[2] or       // замыкание из СП
               ObjZav[o].bParam[18] or          // выключена из управления FR4
               ObjZav[jmp.Obj].bParam[18]) then // выключена из управления РМ-ДСП
              Marhtracert[Group].IzvStrNZ := true;
          end;

          case Con.Pin of
            1 : begin
              if ObjZav[jmp.Obj].bParam[1] then
              begin // по плюсу
                con := ObjZav[jmp.Obj].Neighbour[2];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
              if ObjZav[jmp.Obj].bParam[2] then
              begin // по минусу
                con := ObjZav[jmp.Obj].Neighbour[3];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
                exit;
              end else
                result := trStop;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[1]  then
              begin // по плюсу
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;

            3 : begin
              if ObjZav[jmp.Obj].bParam[2] then
              begin // по минусу
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;
          end;
        end;

        tlPovtorMarh : begin
          if not ObjZav[jmp.Obj].bParam[14] then
          begin // разрушена трасса маршрута
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter); result := trStop; InsMsg(Group,MarhTracert[Group].ObjStart,228);
          end else
          case Con.Pin of
            1 : begin
              if ObjZav[jmp.Obj].bParam[6] and not ObjZav[jmp.Obj].bParam[7] then
              begin
                inc(MarhTracert[Group].StrCount);
                MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount]   := jmp.Obj;
                MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := true;
                MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := false;
                con := ObjZav[jmp.Obj].Neighbour[2];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
              if not ObjZav[jmp.Obj].bParam[6] and ObjZav[jmp.Obj].bParam[7] then
              begin
                inc(MarhTracert[Group].StrCount);
                MarhTracert[Group].StrTrace[MarhTracert[Group].StrCount]   := jmp.Obj;
                MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,1] := false;
                MarhTracert[Group].PolTrace[MarhTracert[Group].StrCount,2] := true;
                con := ObjZav[jmp.Obj].Neighbour[3];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;

            2 : begin
              if ObjZav[jmp.Obj].bParam[6]  then
              begin
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;

            3 : begin
              if ObjZav[jmp.Obj].bParam[7] then
              begin
                con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                else
                  result := trNextStep;
                end;
              end else
                result := trStop;
            end;
          end;
        end;

      else
        result := trEnd;
      end;
    end;
    ////////////////////////////////////////////////////////////////////////////
    3 : begin // секция
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[1] then result := trNextStep else result := trRepeat;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[3] then result := trNextStep else result := trRepeat;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[2] then result := trNextStep else result := trRepeat;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[4] then result := trNextStep else result := trRepeat;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlContTrace : begin
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[1] then result := trNextStep else result := trStop;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[3] then result := trNextStep else result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trEnd;
                LnkEnd : result := trStop;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[2] then result := trNextStep else result := trStop;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[4] then result := trNextStep else result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trEnd;
                LnkEnd : result := trStop;
              end;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          if not ObjZav[jmp.Obj].bParam[2] or (not MarhTracert[Group].Povtor and (ObjZav[jmp.Obj].bParam[14] or not ObjZav[jmp.Obj].bParam[7])) then // замыкание установлено
          begin
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82); MarhTracert[Group].GonkaStrel := false;
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,134, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,134); MarhTracert[Group].GonkaStrel := false;
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[3] then // РИ
          begin
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,84, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,84); MarhTracert[Group].GonkaStrel := false;
          end;
          if not ObjZav[jmp.Obj].bParam[5] then // МИ
          begin
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,85, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,85); MarhTracert[Group].GonkaStrel := false;
          end;
          case Rod of
            MarshP : begin
              if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83); MarhTracert[Group].GonkaStrel := false;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[1] then // занятость участка СП
              begin
                if ObjZav[jmp.Obj].ObjConstB[5] then
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83); MarhTracert[Group].GonkaStrel := false;
                end else
                begin
                  tail := false;
                  for k := 1 to MarhTracert[Group].CIndex do
                    if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then begin tail := true; break; end;
                  if tail then
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83); result := trEnd;
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                  end;
                end;
              end;
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlZamykTrace : begin
          if not ObjZav[jmp.Obj].bParam[1] and not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshM) then
          begin // выдать предупреждение в маневровом маршруте о занятости участка
            MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              if ObjZav[jmp.Obj].bParam[2] then ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
              ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
              ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr;
              if not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshM) then
              begin // для УП в маневрах возбудить 1КМ
                ObjZav[jmp.Obj].bParam[15] := true;  // 1КМ
                ObjZav[jmp.Obj].bParam[16] := false; // 2КМ
              end else
              begin // сброс КМов
                ObjZav[jmp.Obj].bParam[15] := false; // 1КМ
                ObjZav[jmp.Obj].bParam[16] := false; // 2КМ
              end;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              if ObjZav[jmp.Obj].bParam[2] then ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
              ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
              ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr;
              if not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshM) then
              begin // для УП в маневрах возбудить 2КМ
                ObjZav[jmp.Obj].bParam[15] := false; // 1КМ
                ObjZav[jmp.Obj].bParam[16] := true;  // 2КМ
              end else
              begin // сброс КМов
                ObjZav[jmp.Obj].bParam[15] := false; // 1КМ
                ObjZav[jmp.Obj].bParam[16] := false; // 2КМ
              end;
            end;
          end;
        end;

        tlSignalCirc : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,134, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,134);
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[3] then // РИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,84, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,84);
          end;
          if not ObjZav[jmp.Obj].bParam[5] then // МИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,85, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,85);
          end;
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[1] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[3] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if ObjZav[jmp.Obj].bParam[15] then // 1КМ
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[2] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[4] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if ObjZav[jmp.Obj].bParam[16] then // 1КМ
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
              ObjZav[jmp.Obj].bParam[8]  := true;  // трасса
              ObjZav[jmp.Obj].iParam[1]  := 0;
              ObjZav[jmp.Obj].iParam[2]  := 0;
              ObjZav[jmp.Obj].bParam[15] := false; // 1КМ
              ObjZav[jmp.Obj].bParam[16] := false; // 2КМ
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[14] := false; // прог. замыкание
              ObjZav[jmp.Obj].bParam[8]  := true;  // трасса
              ObjZav[jmp.Obj].iParam[1]  := 0;
              ObjZav[jmp.Obj].iParam[2]  := 0;
              ObjZav[jmp.Obj].bParam[15] := false; // 1КМ
              ObjZav[jmp.Obj].bParam[16] := false; // 2КМ
            end;
          end;
        end;

        tlRazdelSign : begin
          result := trNextStep;
          if not ObjZav[jmp.Obj].bParam[2] then // замыкание есть
          begin
            if ObjZav[jmp.Obj].ObjConstB[5] then
            begin // СП - выдать предупреждение
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,82);
            end else
            begin // УП
              case Rod of
                MarshP : begin
                  if not ObjZav[jmp.Obj].bParam[15] and not ObjZav[jmp.Obj].ObjConstB[16] then // нет КМов
                  begin // выдать предупреждение
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,82);
                  end else
                  begin // враждебность
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82);
                  end;
                end;
                MarshM : begin
                  if Con.Pin = 1 then
                  begin
                    if ObjZav[jmp.Obj].bParam[15] and not ObjZav[jmp.Obj].ObjConstB[16] then // есть 1КМ нет 2КМ
                    begin // выдать предупреждение
                      inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,82);
                    end else
                    begin // враждебность
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82);
                    end;
                  end else
                  begin
                    if not ObjZav[jmp.Obj].bParam[15] and ObjZav[jmp.Obj].ObjConstB[16] then // есть 2КМ нет 1КМ
                    begin // выдать предупреждение
                      inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,82);
                    end else
                    begin // враждебность
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82);
                    end;
                  end;
                end;
              else
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82);
              end;
            end;
          end;
          if not ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[14] then // программное замыкание
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82);
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,134, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,134);
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[3] then // РИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,84, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,84);
          end;
          if not ObjZav[jmp.Obj].bParam[5] then // МИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,85, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,85);
          end;
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[1] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[3] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if not ObjZav[jmp.Obj].ObjConstB[5] then // УП
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[8] := false;
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[2] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[4] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if not ObjZav[jmp.Obj].ObjConstB[5] then // УП
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[8] := false;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlPovtorRazdel : begin
          result := trNextStep;
          if not ObjZav[jmp.Obj].bParam[2] then // замыкание
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82);
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,134, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,134);
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[3] then // РИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,84, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,84);
          end;
          if not ObjZav[jmp.Obj].bParam[5] then // МИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,85, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,85);
          end;
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[1] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[15] := true;
                if not ObjZav[jmp.Obj].ObjConstB[3] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if ObjZav[jmp.Obj].bParam[15] then // 1КМ
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[8] := false;
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[2] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[16] := true;
                if not ObjZav[jmp.Obj].ObjConstB[4] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if ObjZav[jmp.Obj].bParam[16] then // 1КМ
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[8] := false;
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlAutoTrace : begin
          result := trNextStep;
          if not ObjZav[jmp.Obj].bParam[2] {or not ObjZav[jmp.Obj].bParam[7]} then // замыкание
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,82, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,82);
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,134, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,134);
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[3] then // РИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,84, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,84);
          end;
          if not ObjZav[jmp.Obj].bParam[5] then // МИ
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,85, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,85);
          end;
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[1] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[15] := true;
                if not ObjZav[jmp.Obj].ObjConstB[3] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if ObjZav[jmp.Obj].bParam[15] then // 1КМ
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].bParam[1] then // занятость участка
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                end;
                if not ObjZav[jmp.Obj].ObjConstB[2] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,161, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,161);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[5] then ObjZav[jmp.Obj].bParam[16] := true;
                if not ObjZav[jmp.Obj].ObjConstB[4] then
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,162, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,162);
                end;
                if not ObjZav[jmp.Obj].bParam[1] then
                begin // занятость участка
                  if ObjZav[jmp.Obj].bParam[16] then // 1КМ
                  begin
                    MarhTracert[Group].TailMsg := ' на занятый участок '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83);
                  end;
                end;
              end;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlFindIzvest : begin
          if not ObjZav[jmp.Obj].bParam[1] then
          begin // участок занят
            result := trBreak; exit;
          end else
          if ObjZav[jmp.Obj].bParam[2] then
          begin // участок не замкнут в маршруте
            if not((MarhTracert[Group].IzvCount = 0) and (MarhTracert[Group].Rod = MarshM)) then begin result := trStop; exit; end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlFindIzvStrel : begin
          if not ObjZav[jmp.Obj].bParam[1] then
          begin // участок занят
            MarhTracert[Group].IzvStrFUZ := true;
            if ObjZav[jmp.Obj].ObjConstB[5] then
            begin // если СП - проверить стрелки
              if ObjZav[jmp.Obj].bParam[2] or MarhTracert[Group].IzvStrNZ then // участок не замкнут
                MarhTracert[Group].IzvStrUZ := true;
              if MarhTracert[Group].IzvStrNZ then
              begin // есть стрелки в трассе - сообщить оператору о незамкнутых стрелках перед сигналом
                result := trStop; exit;
              end;
            end else
            begin // если УП - проверить наличие стрелок по трассе
              if MarhTracert[Group].IzvStrNZ then
              begin // есть стрелки - сообщить оператору о незамкнутых стрелках перед сигналом
                MarhTracert[Group].IzvStrUZ := true; result := trStop; exit;
              end;
            end;
          end else
          if MarhTracert[Group].IzvStrFUZ then
          begin // участок свободен и была занятость участка перед ним - не выдавать предупреждение
            MarhTracert[Group].IzvStrUZ := false; result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlPovtorMarh : begin
          if not ObjZav[jmp.Obj].bParam[14] and not ObjZav[jmp.Obj].bParam[7] then
          begin // разрушена трасса маршрута
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter); InsMsg(Group,jmp.Obj,228); result := trStop;
          end else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;


      else
        result := trNextStep;
      end;
    end;
    ////////////////////////////////////////////////////////////////////////////
    4 : begin // путь
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[1] then result := trNextStep else result := trRepeat;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[3] then result := trNextStep else result := trRepeat;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[2] then result := trNextStep else result := trRepeat;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[4] then result := trNextStep else result := trRepeat;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlContTrace : begin
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[1] then result := trNextStep else result := trStop;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[3] then result := trNextStep else result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trEnd;
                LnkEnd : result := trStop;
              end;
            end;
          end else
          begin
            case Rod of
              MarshP : if ObjZav[jmp.Obj].ObjConstB[2] then result := trNextStep else result := trStop;
              MarshM : if ObjZav[jmp.Obj].ObjConstB[4] then result := trNextStep else result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trEnd;
                LnkEnd : result := trStop;
              end;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].BaseObject > 0 then
          begin // Проверить УТС
            case Rod of
              MarshP : begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] then
                begin // упор установлен
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108); MarhTracert[Group].GonkaStrel := false;
                end else
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор не имеет контроля положения и не отключен
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,109); MarhTracert[Group].GonkaStrel := false;
                end;
              end;
              MarshM : begin
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор установлен и не выключен
                  if not ObjZav[jmp.Obj].bParam[1] then
                  begin // путь занят
                    if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                    begin // сообщение не зафиксировано
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                      result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,109);
                    end;
                  end else
                  begin // путь свободен
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108); MarhTracert[Group].GonkaStrel := false;
                  end;
                end;
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,135, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,135); MarhTracert[Group].GonkaStrel := false;
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          case Rod of
            MarshP : begin
              if not MarhTracert[Group].Povtor and (ObjZav[jmp.Obj].bParam[14] or not ObjZav[jmp.Obj].bParam[7] or not ObjZav[jmp.Obj].bParam[11]) then // программное замыкание установлено
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,110, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,110); MarhTracert[Group].GonkaStrel := false;
              end;
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость(ч&н)
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,112); MarhTracert[Group].GonkaStrel := false;
              end;
              if not (ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[3]) then // ~(И1&И2)
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113); MarhTracert[Group].GonkaStrel := false;
              end;
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,111); MarhTracert[Group].GonkaStrel := false;
              end;
              if Con.Pin = 1 then
              begin // проверить конец подвески контакной сети для четного направления
                if ObjZav[jmp.Obj].ObjConstB[11] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end else
              begin // проверить конец подвески контакной сети для нечетного направления
                if ObjZav[jmp.Obj].ObjConstB[10] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end;
            end;
            MarshM : begin
              if not MarhTracert[Group].Povtor and (ObjZav[jmp.Obj].bParam[14] or not ObjZav[jmp.Obj].bParam[7] or not ObjZav[jmp.Obj].bParam[11]) then // программное замыкание установлено
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,110, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,110); MarhTracert[Group].GonkaStrel := false;
              end;
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,111);
              end;
              if Con.Pin = 1 then
              begin
                if not ObjZav[jmp.Obj].bParam[2] then // ~И2
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); result := trBreak; InsMsg(Group,jmp.Obj,113); MarhTracert[Group].GonkaStrel := false;
                end else
                if not ObjZav[jmp.Obj].bParam[3] then // ~И1
                begin
                  if ObjZav[jmp.Obj].bParam[15] then // НКМ
                  begin
                    tail := false;
                    for k := 1 to MarhTracert[Group].CIndex do
                      if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then begin tail := true; break; end;
                    if tail then
                    begin
                      MarhTracert[Group].TailMsg := ' на замкнутый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                      inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,441, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,441);
                    end else
                    begin // если конечная точка трассы лежит позади замкнутого пути - выход
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113); MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113); MarhTracert[Group].GonkaStrel := false;
                  end;
                  result := trBreak;
                end;
              end else
              begin
                if not ObjZav[jmp.Obj].bParam[3] then // ~И1
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); result := trBreak; InsMsg(Group,jmp.Obj,113); MarhTracert[Group].GonkaStrel := false;
                end else
                if not ObjZav[jmp.Obj].bParam[2] then // ~И2
                begin
                  if ObjZav[jmp.Obj].bParam[4] then // ЧКМ
                  begin
                    tail := false;
                    for k := 1 to MarhTracert[Group].CIndex do
                      if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then begin tail := true; break; end;
                    if tail then
                    begin
                      MarhTracert[Group].TailMsg := ' на замкнутый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                      inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,441, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,441);
                    end else
                    begin // если конечная точка трассы лежит позади замкнутого пути - выход
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113); MarhTracert[Group].GonkaStrel := false;
                    end;
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113); MarhTracert[Group].GonkaStrel := false;
                  end;
                  result := trBreak;
                end;
              end;
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость(ч&н)
              begin
                tail := false;
                for k := 1 to MarhTracert[Group].CIndex do
                  if MarhTracert[Group].hTail = MarhTracert[Group].ObjTrace[k] then begin tail := true; break; end;
                if tail then
                begin
                  MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,112);
                end else
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,112); MarhTracert[Group].GonkaStrel := false;
                end;
                result := trBreak;
              end;
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlZamykTrace : begin
          if not ObjZav[jmp.Obj].bParam[1] then
          begin
            MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[8] := true;  // сброс прог. замыкание
              ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
              ObjZav[jmp.Obj].iParam[2] := MarhTracert[Group].SvetBrdr;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[8] := true;  // сброс прог. замыкание
              ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
              ObjZav[jmp.Obj].iParam[3] := MarhTracert[Group].SvetBrdr;
            end;
          end;
        end;

        tlSignalCirc : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].BaseObject > 0 then
          begin // Проверить УТС
            case Rod of
              MarshP : begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] then
                begin // упор установлен
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108);
                end else
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор не имеет контроля положения и не отключен
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,109);
                end;
              end;
              MarshM : begin
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор установлен и не выключен
                  if not ObjZav[jmp.Obj].bParam[1] then
                  begin // путь занят
                    if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                    begin // сообщение не зафиксировано
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                      inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,108);
                    end;
                  end else
                  begin // путь свободен
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108);
                  end;
                end;
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,135, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,135);
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          case Rod of
            MarshP : begin
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость(ч&н)
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,112);
              end;
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,111);
              end;
              if Con.Pin = 1 then
              begin // проверить конец подвески контакной сети для четного направления
                if ObjZav[jmp.Obj].ObjConstB[11] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end else
              begin // проверить конец подвески контакной сети для нечетного направления
                if ObjZav[jmp.Obj].ObjConstB[10] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end;
            end;
            MarshM : begin
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,111);
              end;
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость
              begin
                MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,112);
              end;
            end;
          else
            result := trStop;
          end;
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].ObjConstB[1] then
                begin // нет нечетных поездных на путь
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end else
                if not ObjZav[jmp.Obj].bParam[3] or (not ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[4]) then // ~(И2)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[3] then
                begin // нет нечетных маневровых на путь
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end;
                if (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) or (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) then // ~И2&(~ЧКМ)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
            end;
            if ObjZav[jmp.Obj].bParam[2] then // (И1)
            begin
              inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,457, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,457);
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].ObjConstB[2] then
                begin // нет четных поездных на путь
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end else
                if not ObjZav[jmp.Obj].bParam[2] or (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then // ~(И1)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[4] then
                begin // нет четных маневровых на путь
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end;
                if (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) or (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) then // ~И1&(~НКМ)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
            end;
            if ObjZav[jmp.Obj].bParam[3] then // (И2)
            begin
              inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,457, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,457);
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[14] := false;  // прог. замыкание
              ObjZav[jmp.Obj].bParam[8]  := true;  // трасса
              ObjZav[jmp.Obj].iParam[1]  := 0;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              ObjZav[jmp.Obj].bParam[14] := false;  // прог. замыкание
              ObjZav[jmp.Obj].bParam[8]  := true;  // трасса
              ObjZav[jmp.Obj].iParam[2] := 0;
            end;
          end;
        end;

        tlRazdelSign : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].BaseObject > 0 then
          begin // Проверить УТС
            case Rod of
              MarshP : begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] then
                begin // упор установлен
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108);
                end else
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор не имеет контроля положения и не отключен
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,109);
                end;
              end;
              MarshM : begin
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор установлен и не выключен
                  if not ObjZav[jmp.Obj].bParam[1] then
                  begin // путь занят
                    if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                    begin // сообщение не зафиксировано
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                      inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,108);
                    end;
                  end else
                  begin // путь свободен
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108);
                  end;
                end;
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[14] or not ObjZav[jmp.Obj].bParam[7] or not ObjZav[jmp.Obj].bParam[11] then // программное замыкание установлено
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,110, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,110);
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,135, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,135);
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          case Rod of
            MarshP : begin
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость(ч&н)
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,112);
              end;
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,111);
              end;
              if Con.Pin = 1 then
              begin // проверить конец подвески контакной сети для четного направления
                if ObjZav[jmp.Obj].ObjConstB[11] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end else
              begin // проверить конец подвески контакной сети для нечетного направления
                if ObjZav[jmp.Obj].ObjConstB[10] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end;
            end;
            MarshM : begin
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,111);
              end;
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость(ч&н)
              begin
                MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,112);
              end;
            end;
          else
            result := trStop;
          end;
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].ObjConstB[1] then
                begin // нет нечетных поездных на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end else
                if not ObjZav[jmp.Obj].bParam[3] or (not ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[4]) then // ~(И2)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[3] then
                begin // нет нечетных маневровых на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end;
                if not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4] then // ~И2&(~ЧКМ)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
                if not ObjZav[jmp.Obj].bParam[3] then // ~И1
                begin
                  if ObjZav[jmp.Obj].bParam[15] then // НКМ
                  begin
                    MarhTracert[Group].TailMsg := ' на замкнутый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,441, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,441);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                  end;
                end;
              end;
            end;
            ObjZav[jmp.Obj].bParam[8] := false;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].ObjConstB[2] then
                begin // нет четных поездных на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end else
                if not ObjZav[jmp.Obj].bParam[2] or (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then // ~(И1)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[4] then
                begin // нет четных маневровых на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end;
                if not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15] then // ~И1&(~НКМ)
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
                if not ObjZav[jmp.Obj].bParam[2] then // ~И2
                begin
                  if ObjZav[jmp.Obj].bParam[4] then // ЧКМ
                  begin
                    MarhTracert[Group].TailMsg := ' на замкнутый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,441, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,441);
                  end else
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                  end;
                end;
              end;
            end;
            ObjZav[jmp.Obj].bParam[8] := false;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlAutoTrace : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].BaseObject > 0 then
          begin // Проверить УТС
            case Rod of
              MarshP : begin
                if ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] then
                begin // упор установлен
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108);
                end else
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор не имеет контроля положения и не отключен
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,109);
                end;
              end;
              MarshM : begin
                if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[1] and
                  ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[2] and
                   not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] then
                begin // упор установлен и не выключен
                  if not ObjZav[jmp.Obj].bParam[1] then
                  begin // путь занят
                    if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] then
                    begin // сообщение не зафиксировано
                      ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[27] := true;
                      result := trStop; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,108);
                    end;
                  end else
                  begin // путь свободен
                    result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,108);
                  end;
                end;
              end;
            end;
          end;
          if ObjZav[jmp.Obj].bParam[14] then // программное замыкание установлено
          begin
            result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,110, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,110);
          end;
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // Закрыт для движения
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,135, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,135);
          end;
          if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
          begin
            if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
            begin
              inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
            end else
            if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
            begin
              if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
              end;
              if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
              end;
            end;
          end;
          case Rod of
            MarshP : begin
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость(ч&н)
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,112);
              end;
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,111);
              end;
              if Con.Pin = 1 then
              begin // проверить конец подвески контакной сети для четного направления
                if ObjZav[jmp.Obj].ObjConstB[11] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end else
              begin // проверить конец подвески контакной сети для нечетного направления
                if ObjZav[jmp.Obj].ObjConstB[10] then
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,473, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,473);
                end;
              end;
            end;
            MarshM : begin
              if not (ObjZav[jmp.Obj].bParam[5] and ObjZav[jmp.Obj].bParam[6]) then // ~МИ(ч&н)
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,111, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,111);
              end;
              if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then // занятость(ч&н)
              begin
                MarhTracert[Group].TailMsg := ' на занятый путь '+ ObjZav[jmp.Obj].Liter; MarhTracert[Group].FindTail := false;
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,112, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,112);
              end;
            end;
          else
            result := trStop;
          end;
          if Con.Pin = 1 then
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].ObjConstB[1] then
                begin // нет нечетных поездных на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end else
                if not ObjZav[jmp.Obj].bParam[3] or (not ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[4]) then // ~(И2)
                begin
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[3] then
                begin // нет нечетных маневровых на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end;
                if (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) or (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) then // ~И2&(~ЧКМ)
                begin
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            case Rod of
              MarshP : begin
                if not ObjZav[jmp.Obj].ObjConstB[2] then
                begin // нет четных поездных на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end else
                if not ObjZav[jmp.Obj].bParam[2] or (not ObjZav[jmp.Obj].bParam[3] and ObjZav[jmp.Obj].bParam[15]) then // ~(И1)
                begin
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
              MarshM : begin
                if not ObjZav[jmp.Obj].ObjConstB[4] then
                begin // нет четных маневровых на путь
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77);
                end;
                if (not ObjZav[jmp.Obj].bParam[2] and not ObjZav[jmp.Obj].bParam[4]) or (not ObjZav[jmp.Obj].bParam[3] and not ObjZav[jmp.Obj].bParam[15]) then // ~И1&(~НКМ)
                begin
                  result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,113);
                end;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlFindIzvest : begin
          if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then
          begin // путь занят
            result := trBreak; exit;
          end else
          if ObjZav[jmp.Obj].bParam[2] and ObjZav[jmp.Obj].bParam[3] then
          begin // путь не замкнут в маршруте
            if not((MarhTracert[Group].IzvCount = 0) and (MarhTracert[Group].Rod = MarshM)) then begin result := trStop; exit; end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlFindIzvStrel : begin
          if not (ObjZav[jmp.Obj].bParam[1] and ObjZav[jmp.Obj].bParam[16]) then
          begin // участок занят
            MarhTracert[Group].IzvStrFUZ := true;
            if MarhTracert[Group].IzvStrNZ then
            begin // есть стрелки - сообщить оператору о незамкнутых стрелках перед сигналом
              MarhTracert[Group].IzvStrUZ := true; result := trStop; exit;
            end;
          end else
          if MarhTracert[Group].IzvStrFUZ then
          begin // участок свободен и была занятость участка перед ним - не выдавать предупреждение
            MarhTracert[Group].IzvStrUZ := false; result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlPovtorRazdel,
        tlPovtorMarh : begin
          if not ObjZav[jmp.Obj].bParam[14] and not ObjZav[jmp.Obj].bParam[7] then
          begin // разрушена трасса маршрута
            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,228, ObjZav[MarhTracert[Group].ObjStart].Liter); result := trStop; InsMsg(Group,jmp.Obj,228);
          end else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

      else
        result := trEnd;
      end;
    end;
    ////////////////////////////////////////////////////////////////////////////
    5 : begin // светофор
      case Lvl of
        tlFindTrace : begin
          if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
          begin // Продолжить трассировку если свой район управления
            if ObjZav[jmp.Obj].ObjConstB[1] then
            begin // есть признак конца трассировки
              result := trRepeat;
            end else
            if Con.Pin = 1 then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              else
                result := trNextStep;
              end;
            end else
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              else
                result := trNextStep;
              end;
            end;
          end else
            result := trRepeat;
        end;

        tlContTrace : begin
          if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
          begin // Продолжить трассировку если свой район управления
            if ObjZav[jmp.Obj].ObjConstB[1] then // смена направления Ч/Н, тупик
            begin // Вернуть признак конечной точки трассы
              result := trEndTrace;
            end else
            if Con.Pin = 1 then
            begin // Попутный сигнал
              if (((Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[7]) or ((Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[5])) and
                  (ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] or ObjZav[jmp.Obj].bParam[18] or
                  (ObjZav[jmp.Obj].ObjConstB[2] and (ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4] or ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9])) or
                  (ObjZav[jmp.Obj].ObjConstB[3] and (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7]))) then
              begin // Завершить трассировку если попутный впереди уже открыт
                result := trEndTrace;
              end else
              case Rod of
                MarshP : begin
                  if ObjZav[jmp.Obj].ObjConstB[16] and ObjZav[jmp.Obj].ObjConstB[2] then // нет сквозных маршрутов
                  begin
                    result := trEndTrace;
                  end else
                  if ObjZav[jmp.Obj].ObjConstB[5] then
                  begin // есть конец поездного маршрута у светофора
                    MarhTracert[Group].FullTail := true; MarhTracert[Group].FindNext := true;
                    if ObjZav[jmp.Obj].ObjConstB[2] then result := trEnd else result := trEndTrace;
                  end else // нет конца поездного маршрута у светофора
                    result := trNextStep;
                end;
                MarshM : begin
                  if ObjZav[jmp.Obj].ObjConstB[7] then
                  begin
                    MarhTracert[Group].FullTail := true; MarhTracert[Group].FindNext := true;
                    if ObjZav[jmp.Obj].ObjConstB[3] then result := trEnd else result := trEndTrace;
                  end else
                    result := trNextStep;
                end;
              else
                result := trEnd;
              end;
              if result = trNextStep then
              begin
                Con := ObjZav[jmp.Obj].Neighbour[2];
                case Con.TypeJmp of
                  LnkRgn : result := trStop;
                  LnkEnd : result := trStop;
                end;
              end;
            end else
            begin // Встречный сигнал
              case Rod of
                MarshP : begin
                  if ObjZav[jmp.Obj].ObjConstB[6] then result := trEndTrace
                  else
                  begin
                    if ObjZav[jmp.Obj].Neighbour[1].TypeJmp = 0 then
                    begin // Отказ если нет поездного из тупика
                      result := trStop;
                    end else
                      result := trNextStep;
                  end;
                end;
                MarshM : begin
                  if ObjZav[jmp.Obj].ObjConstB[8] then result := trEndTrace else result := trNextStep;
                end;
              else
                result := trEnd;
              end;
              if result = trNextStep then
              begin
                Con := ObjZav[jmp.Obj].Neighbour[1];
                case Con.TypeJmp of
                  LnkRgn : result := trRepeat;
                  LnkEnd : result := trRepeat;
                end;
              end;
            end;
          end else
          begin
            result := trEndTrace; // Завершить трассировку маршрута если другой район управления
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          if (ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13]) and (jmp.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]) then
          begin // заблокирован светофор в середине трассы
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,123); MarhTracert[Group].GonkaStrel := false;
          end;
          if ObjZav[jmp.Obj].bParam[18] and (jmp.Obj <> MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter]) then
          begin // светофор на местном управлении в середине трассы
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,232, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,232); MarhTracert[Group].GonkaStrel := false;
          end;
          if Con.Pin = 1 then
          begin // Враждебности попутного
            if ((not ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP)) or (not ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM))) and
               (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then // С
            begin
              result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,114, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,114); MarhTracert[Group].GonkaStrel := false;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
            if MarhTracert[Group].FindTail then MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;
          end else
          begin // Враждебности встречного
            if ObjZav[jmp.Obj].bParam[1] or   // МС1
               ObjZav[jmp.Obj].bParam[2] or   // МС2
               ObjZav[jmp.Obj].bParam[3] or   // С1
               ObjZav[jmp.Obj].bParam[4] then // С2
            begin
              result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,114, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,114); MarhTracert[Group].GonkaStrel := false;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
            if MarhTracert[Group].FindTail then
            begin
              if (Con.TypeJmp <> LnkEnd) and (Rod = MarshM) then
                MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter
              else
                MarhTracert[Group].TailMsg := ' за '+ ObjZav[jmp.Obj].Liter;
            end;
          end;
        end;

        tlZamykTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              if MarhTracert[Group].FindTail then MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;
              // разнести признаки начала в попутные сигналы
              if ObjZav[MarhTracert[Group].ObjStart].bParam[7] then
              begin // маневровый
                if ObjZav[jmp.Obj].ObjConstB[3] then
                begin
                  MarhTracert[Group].SvetBrdr := jmp.Obj; // сменить индекс блок-участка
                  ObjZav[jmp.Obj].bParam[7] := true;  // НМ
                  ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
                  ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
                end;
              end else
              if ObjZav[MarhTracert[Group].ObjStart].bParam[9] then
              begin // поездной
                if ObjZav[jmp.Obj].ObjConstB[2] then
                begin
                  MarhTracert[Group].SvetBrdr := jmp.Obj; // сменить индекс блок-участка
                  ObjZav[jmp.Obj].bParam[9] := true;  // Н
                  ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
                  ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
                end;
              end;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if MarhTracert[Group].FindTail then
            begin
              if (Con.TypeJmp <> LnkEnd) and (Rod = MarshM) then
                MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter
              else
                MarhTracert[Group].TailMsg := ' за '+ ObjZav[jmp.Obj].Liter;
            end;
            ObjZav[jmp.Obj].bParam[14] := true;  // прог. замыкание
            ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
          end;
        end;

        tlSignalCirc : begin
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
          begin // заблокирован светофор
            if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
                   (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
            begin
              inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,123);
            end;
          end else
          if ObjZav[jmp.Obj].bParam[18] then
          begin // светофор на местном управлении
            if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
                   (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
            begin
              inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,232, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,232);
            end;
          end else
            result := trNextStep;
          if Con.Pin = 1 then
          begin // Враждебности попутного
            case Rod of
              MarshP : begin
                if ObjZav[jmp.Obj].ObjConstB[5] then
                begin
                  if ObjZav[jmp.Obj].bParam[5] and not
                     (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then
                  begin // Маршрут не прикрыт запрещающим огнем попутного
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,115, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,115);
                  end;
                  result := trEndTrace;
                end;
                if ObjZav[jmp.Obj].ObjConstB[19] then
                begin // Короткий предмаршрутный участок для поездного маршрута
                  if not ObjZav[jmp.Obj].bParam[4] then
                  begin // закрыт сигнал
                    result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,391, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,391);
                  end;
                end;
              end;
              MarshM : begin
                if ObjZav[jmp.Obj].ObjConstB[7] then
                begin
                  if ObjZav[jmp.Obj].bParam[5] and not
                     (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then
                  begin // Маршрут не прикрыт запрещающим огнем попутного
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,115, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,115);
                  end;
                  result := trEndTrace;
                end;
                if ObjZav[jmp.Obj].ObjConstB[20] then
                begin // Короткий предмаршрутный участок для маневрового маршрута
                  if not ObjZav[jmp.Obj].bParam[2] then
                  begin // закрыт сигнал
                    result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,391, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,391);
                  end;
                end;
              end;
            else
              result := trEnd;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin // Враждебности встречного
            if ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) then result := trStop else
            if ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) then result := trStop else

            if ObjZav[jmp.Obj].bParam[1] or   // МС1
               ObjZav[jmp.Obj].bParam[2] or   // МС2
               ObjZav[jmp.Obj].bParam[3] or   // С1
               ObjZav[jmp.Obj].bParam[4] then // С2
            begin
              result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,114, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,114);
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          if Con.Pin = 1 then
          begin // попутный сигнал
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : begin ObjZav[jmp.Obj].bParam[14] := false; result := trEnd; end;
              LnkEnd : begin ObjZav[jmp.Obj].bParam[14] := false; result := trStop; end;
            else
              result := trNextStep;
            end;
            if result = trNextStep then
            begin
              // найти хвост данной категории маршрута
              if Rod = MarshM then
              begin // маневровый
                if ObjZav[jmp.Obj].ObjConstB[7] then
                begin
                  result := trStop;
                end else
                  ObjZav[jmp.Obj].bParam[14] := false;
              end else
              if Rod = MarshP then
              begin // поездной
                if ObjZav[jmp.Obj].ObjConstB[5] then
                begin
                  result := trStop;
                end else
                  ObjZav[jmp.Obj].bParam[14] := false;
              end;
            end;
          end else
          begin // встречный сигнал
            ObjZav[jmp.Obj].bParam[14] := false;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              // найти хвост данной категории маршрута
              if Rod = MarshM then
              begin // маневровый
                if ObjZav[jmp.Obj].ObjConstB[8] then result := trStop else result := trNextStep;
              end else
              if Rod = MarshP then
              begin // поездной
                if ObjZav[jmp.Obj].ObjConstB[6] then result := trStop else result := trNextStep;
              end;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign : begin
          if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
          begin // заблокирован светофор
            if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
                   (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
            begin
              inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,123);
            end;
          end else
          if ObjZav[jmp.Obj].bParam[18] then
          begin // светофор на местном управлении
            if not((ObjZav[jmp.Obj].ObjConstB[5] and (Rod = MarshP) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[6] and (Rod = MarshP) and (Con.Pin = 2)) or
                   (ObjZav[jmp.Obj].ObjConstB[7] and (Rod = MarshM) and (Con.Pin = 1)) or
                   (ObjZav[jmp.Obj].ObjConstB[8] and (Rod = MarshM) and (Con.Pin = 2))) then
            begin
              inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,232, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,232);
            end;
          end else
            result := trNextStep;
          if Con.Pin = 1 then
          begin // Враждебности попутного
            case Rod of
              MarshP : begin
                if ObjZav[jmp.Obj].ObjConstB[5] then
                begin
                  if ObjZav[jmp.Obj].bParam[5] and not
                     (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then // o
                  begin // Маршрут не прикрыт запрещающим огнем попутного
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,115, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,115);
                  end;
                  result := trEndTrace;
                end else
                begin
                  if ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[21] then
                  begin // открыт враждебный сигнал
                    result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,114, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,114);
                  end;
                end;
                if ObjZav[jmp.Obj].ObjConstB[19] then
                begin // Короткий предмаршрутный участок для поездного маршрута
                  if not ObjZav[jmp.Obj].bParam[4] then
                  begin // закрыт сигнал
                    result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,391, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,391);
                  end;
                end;
              end;
              MarshM : begin
                if ObjZav[jmp.Obj].ObjConstB[7] then
                begin
                  if ObjZav[jmp.Obj].bParam[5] and not
                     (ObjZav[jmp.Obj].bParam[1] or ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4]) then // o
                  begin // Маршрут не прикрыт запрещающим огнем попутного
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,115, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,115);
                  end;
                  result := trEndTrace;
                end else
                begin
                  if ObjZav[jmp.Obj].bParam[3] or ObjZav[jmp.Obj].bParam[4] or ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9] or ObjZav[jmp.Obj].bParam[21] then
                  begin // открыт враждебный сигнал
                    result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,114, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,114);
                  end;
                end;
                if ObjZav[jmp.Obj].ObjConstB[20] then
                begin // Короткий предмаршрутный участок для маневрового маршрута
                  if not ObjZav[jmp.Obj].bParam[2] then
                  begin // закрыт сигнал
                    result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,391, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,391);
                  end;
                end;
              end;
            else
              result := trEnd;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : result := trStop;
              end;
            end;
          end else
          begin // Враждебности встречного
            if ObjZav[jmp.Obj].bParam[1] or   // МС1
               ObjZav[jmp.Obj].bParam[2] or   // МС2
               ObjZav[jmp.Obj].bParam[3] or   // С1
               ObjZav[jmp.Obj].bParam[4] then // С2
            begin
              result := trStop; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,114, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,114);
            end;
            case Rod of
              MarshP : begin
                if ObjZav[jmp.Obj].ObjConstB[6] then result := trEndTrace;
              end;
              MarshM : begin
                if ObjZav[jmp.Obj].ObjConstB[8] then result := trEndTrace;
              end;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : begin
                // Маршрут не существует
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); result := trEnd; InsMsg(Group,jmp.Obj,77);
                end;
              end;
            end;
          end;
        end;

        tlFindIzvest : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin // проверить условия для попутного сигнала
            if ObjZav[jmp.Obj].bParam[2] or ObjZav[jmp.Obj].bParam[4] then
            begin // светофор открыт
              inc(MarhTracert[Group].IzvCount);
            end else
            if ObjZav[jmp.Obj].bParam[6] or ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[1] then
            begin // возбужден признак маневрового начала или сигнал на выдержке времени
              if not ObjZav[jmp.Obj].bParam[2] then
              begin // светофор закрыт
                result := trStop; exit;
              end;
              inc(MarhTracert[Group].IzvCount);
            end else
            if ObjZav[jmp.Obj].bParam[8] or ObjZav[jmp.Obj].bParam[9] or ObjZav[jmp.Obj].bParam[3] then
            begin // возбужден признак поездного начала или сигнал на выдержке времени
              if not ObjZav[jmp.Obj].bParam[4] then
              begin // светофор закрыт
                result := trStop; exit;
              end;
              inc(MarhTracert[Group].IzvCount);
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlFindIzvStrel : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin // проверить условия для попутного сигнала
            if ((Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
               ((Rod = MarshP) and (ObjZav[jmp.Obj].ObjConstB[2] or ObjZav[jmp.Obj].bParam[2])) then
            begin // светофор ограничивает предмаршрутный участок
              result := trStop; exit;
            end else
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlPovtorMarh : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin // Проверка попутного
            case Rod of
              MarshP : begin
                if ObjZav[jmp.Obj].ObjConstB[5] then result := trEndTrace;
              end;
              MarshM : begin
                if ObjZav[jmp.Obj].ObjConstB[7] then result := trEndTrace;
              end;
            else
              result := trEnd;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : result := trStop;
              end;
            end;
          end else
          begin // Проверка встречного
            case Rod of
              MarshP : begin
                if ObjZav[jmp.Obj].ObjConstB[6] then result := trEndTrace;
              end;
              MarshM : begin
                if ObjZav[jmp.Obj].ObjConstB[8] then result := trEndTrace;
              end;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trStop;
                LnkEnd : begin
                // Маршрут не существует
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,77, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,77); result := trEnd;
                end;
              end;
            end;
          end;
        end;

      else
        result := trEnd;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    7 : begin // Пригласительный сигнал
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].bParam[1] then // ПС
          begin
            result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,116, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,116); MarhTracert[Group].GonkaStrel := false;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          if ObjZav[jmp.Obj].bParam[1] then // ПС
          begin
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,116, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,116);
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    14 : begin // УКСПС
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              if ObjZav[jmp.Obj].BaseObject = MarhTracert[Group].ObjStart then
              begin
                if ObjZav[jmp.Obj].bParam[1] then // ИКС
                begin
                  result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,124, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,124);
                end else
                begin
                  if ObjZav[jmp.Obj].bParam[3] then // 1КС
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,125, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,125); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if ObjZav[jmp.Obj].bParam[4] then // 2КС
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,126, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,126); MarhTracert[Group].GonkaStrel := false;
                  end;
                  if ObjZav[jmp.Obj].bParam[5] then // КзК
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,127, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,127); MarhTracert[Group].GonkaStrel := false;
                  end;
                end;
              end;
            end;
            MarshM,MarshL : begin
            end;
          else
            result := trStop;
            exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          case Rod of
            MarshP : begin
              if ObjZav[jmp.Obj].BaseObject = MarhTracert[Group].ObjStart then
              begin
                if ObjZav[jmp.Obj].bParam[1] then // ИКС
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,124, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,124);
                end else
                begin
                  if ObjZav[jmp.Obj].bParam[3] then // 1КС
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,125, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,125);
                  end;
                  if ObjZav[jmp.Obj].bParam[4] then // 2КС
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,126, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,126);
                  end;
                  if ObjZav[jmp.Obj].bParam[5] then // КзК
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,127, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,127);
                  end;
                end;
              end;
            end;
            MarshM,MarshL : begin
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    15 : begin // АБ
      case Lvl of
        tlFindTrace : begin
          result := trNextStep;
          if not MarhTracert[Group].LvlFNext then
          begin
            if Con.Pin = 1 then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end else
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlContTrace : begin
          case Rod of
            MarshP : if ObjZav[jmp.Obj].ObjConstB[1] then result := trEndTrace else result := trStop;
            MarshM : result := trStop;
          else
            MarhTracert[Group].FullTail := true; result := trEndTrace;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              if not ObjZav[jmp.Obj].bParam[6] then // КЖ
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] and (ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[8]) then
                begin // Подключаемый комплект - запрещено отправление хозпоезда
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,363, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,363); MarhTracert[Group].GonkaStrel := false;
                end else
                begin // Выдать предупреждение хозпоезду
                  result := trBreak; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,133, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,133);
                end;
              end;
              if ObjZav[jmp.Obj].ObjConstB[1] then
              begin // есть отправление на перегон
                if ObjZav[jmp.Obj].ObjConstB[2] then
                begin // если есть смена направления - проверить комплект
                  if ObjZav[jmp.Obj].ObjConstB[3] then
                  begin // есть подключение комплекта
                    if ObjZav[jmp.Obj].ObjConstB[4] then
                    begin // перегон по приему
                      if (not ObjZav[jmp.Obj].bParam[7]) or
                         (ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8]) then
                      begin // Комплект не подключен или подключен неправильно
                        result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,132, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,132); MarhTracert[Group].GonkaStrel := false;
                      end else
                      if not ObjZav[jmp.Obj].bParam[4] then // СН
                      begin
                        result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,128, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,128);
                     end;
                    end else // перегон по отправлению
                    if ObjZav[jmp.Obj].ObjConstB[5] then
                    begin // перегон по отправлению
                      if ObjZav[jmp.Obj].bParam[7] then
                      begin // Комплект подключен неправильно
                        result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,132, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,132); MarhTracert[Group].GonkaStrel := false;
                      end else
                      if ObjZav[jmp.Obj].bParam[8] then
                      begin
                        if not ObjZav[jmp.Obj].bParam[4] then // СН
                        begin
                          result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,128, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,128);
                        end;
                      end;
                    end;
                  end else
                  begin // комплект смены направления подключен постоянно
                    if not ObjZav[jmp.Obj].bParam[4] then // СН
                    begin
                      result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,128, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,128);
                    end;
                  end;
                end;
              end else
              begin // нет отправления на перегон
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,131, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,131); MarhTracert[Group].GonkaStrel := false;
              end;

              if ObjZav[jmp.Obj].ObjConstB[3] then
              begin
                if ObjZav[jmp.Obj].ObjConstB[4] then
                begin // Отправление по неправильному пути
                  if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] then // ИП
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,129, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,129);
                  end;
                end else
                begin // Отправление по правильному пути
                  if not ObjZav[jmp.Obj].bParam[2] then // ИП
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,129, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,129);
                  end;
                end;
              end else
              begin
                if not ObjZav[jmp.Obj].bParam[2] then // ИП
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,129, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,129);
                end;
              end;
              if ObjZav[jmp.Obj].bParam[9] then // отправлен хоз.поезд
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,130, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,130); MarhTracert[Group].GonkaStrel := false;
              end;
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // перегон заблокирован
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,432, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,432); MarhTracert[Group].GonkaStrel := false;
              end;
              if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
              begin
                if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
                end else
                if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
                begin
                  if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
                  end;
                  if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
                  end;
                end;
              end else
              begin // конец подвески контакной провода
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,474, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,474);
              end;
            end;
            MarshM : begin
              //
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              if not ObjZav[jmp.Obj].bParam[6] then // КЖ
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] and (ObjZav[jmp.Obj].bParam[7] or ObjZav[jmp.Obj].bParam[8]) then
                begin // Подключаемый комплект - запрещено отправление хозпоезда
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,363, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,363);
                end else
                begin // Выдать предупреждение хозпоезду
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,133, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,133);
                end;
              end;
              if ObjZav[jmp.Obj].ObjConstB[1] then
              begin // есть отправление на перегон
                if ObjZav[jmp.Obj].ObjConstB[2] then
                begin // если есть смена направления - проверить комплект
                  if ObjZav[jmp.Obj].ObjConstB[3] then
                  begin // есть подключение комплекта
                    if ObjZav[jmp.Obj].ObjConstB[4] then
                    begin // перегон по приему
                      if (not ObjZav[jmp.Obj].bParam[7]) or
                         (ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8]) then
                      begin // Комплект не подключен или подключен неправильно
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,132, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,132);
                      end else
                      if not ObjZav[jmp.Obj].bParam[4] then // СН
                      begin
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,128, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,128);
                      end;
                    end else // перегон по отправлению
                    if ObjZav[jmp.Obj].ObjConstB[5] then
                    begin // перегон по отправлению
                      if ObjZav[jmp.Obj].bParam[7] then
                      begin // Комплект подключен неправильно
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,132, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,132);
                      end else
                      if ObjZav[jmp.Obj].bParam[8] then
                      begin
                        if not ObjZav[jmp.Obj].bParam[4] then // СН
                        begin
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,128, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,128);
                        end;
                      end;
                    end;
                  end else
                  begin // комплект смены направления подключен постоянно
                    if not ObjZav[jmp.Obj].bParam[4] then // СН
                    begin
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,128, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,128);
                    end;
                  end;
                end;
              end else
              begin // нет отправления на перегон
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,131, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,131);
              end;

              if ObjZav[jmp.Obj].ObjConstB[3] then
              begin
                if ObjZav[jmp.Obj].ObjConstB[4] then
                begin // Отправление по неправильному пути
                  if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] then // ИП
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,129, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,129);
                  end;
                end else
                begin // Отправление по правильному пути
                  if not ObjZav[jmp.Obj].bParam[2] then // ИП
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,129, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,129);
                  end;
                end;
              end else
              begin
                if not ObjZav[jmp.Obj].bParam[2] then // ИП
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,129, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,129);
                end;
              end;
              if ObjZav[jmp.Obj].bParam[9] then // отправлен хоз.поезд
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,130, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,130);
              end;
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // перегон заблокирован
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,432, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,432);
              end;
              if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
              begin
                if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
                end else
                if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
                begin
                  if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
                  end;
                  if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
                  end;
                end;
              end else
              begin // конец подвески контакной провода
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,474, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,474);
              end;
            end;
            MarshM : begin
              //
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            if result = trBreak then exit;
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            end;
          end;
        end;

        tlPovtorMarh : begin
          MarhTracert[Group].ObjEnd := jmp.Obj; // зафиксировать коней маршрута отправления
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlZamykTrace : begin
          ObjZav[jmp.Obj].bParam[14] := true;
          ObjZav[jmp.Obj].bParam[15] := true;
          ObjZav[jmp.Obj].iParam[1] := MarhTracert[Group].ObjStart;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          ObjZav[jmp.Obj].bParam[14] := false;
          ObjZav[jmp.Obj].bParam[15] := false;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlFindIzvest : begin
          if ObjZav[jmp.Obj].ObjConstB[2] then
          begin // есть смена направления
            if ObjZav[jmp.Obj].ObjConstB[3] then
            begin // есть подключение комплекта
              if ObjZav[jmp.Obj].ObjConstB[4] then
              begin // перегон специализован по приему
                if ObjZav[jmp.Obj].bParam[7] and not ObjZav[jmp.Obj].bParam[8] then
                begin
                  if ObjZav[jmp.Obj].bParam[4] then
                  begin // перегон по приему
                    if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                    begin // Занято приближение
                      result := trBreak;
                    end else
                      result := trStop;
                  end else
                    result := trStop;
                end else
                if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                begin // Занято приближение
                  result := trBreak;
                end else
                  result := trStop;
              end else
              if ObjZav[jmp.Obj].ObjConstB[5] then
              begin // перегон специализован по отправлению
                if not ObjZav[jmp.Obj].bParam[7] and ObjZav[jmp.Obj].bParam[8] then
                begin
                  if not ObjZav[jmp.Obj].bParam[4] then
                  begin // перегон по приему
                    if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                    begin // Занято приближение
                      result := trBreak;
                    end else
                      result := trStop;
                  end else
                  if not ObjZav[jmp.Obj].bParam[2] then result := trBreak else result := trStop;
                end else
                  result := trStop;
              end else
                result := trStop;
            end else
            begin // комплект подключен постоянно
              if not ObjZav[jmp.Obj].bParam[4] then
              begin // перегон по приему
                if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
                begin // Занято приближение
                  result := trBreak;
                end else
                  result := trStop;
              end else
              if not ObjZav[jmp.Obj].bParam[2] then result := trBreak else result := trStop;
            end;
          end else
          if ObjZav[jmp.Obj].ObjConstB[4] then
          begin // перегон специализован по приему
            if not ObjZav[jmp.Obj].bParam[2] or not ObjZav[jmp.Obj].bParam[3] {or not ObjZav[jmp.Obj].bParam[11]} then
            begin // Занято приближение
              result := trBreak;
            end else
              result := trStop;
          end else
            result := trStop;
        end;

        tlFindIzvStrel : result := trStop;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    16 : begin // Вспомогательная смена направления АБ
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc,
        tlCheckTrace : begin
          case Rod of
            MarshP : begin
              //
            end;
            MarshM : begin
              //
            end;
          else
            result := trStop;
            exit;
          end;
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    23 : begin // Увязка с маневровым районом
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,244, ''); InsMsg(Group,jmp.Obj,244); MarhTracert[Group].GonkaStrel := false;
            end;
            MarshM : begin
              case Con.Pin of
                1 : begin
                  if not ObjZav[jmp.Obj].bParam[1] then // УМП
                  begin
                    result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,245, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,245); MarhTracert[Group].GonkaStrel := false;
                  end;
                end;
              else
                if not ObjZav[jmp.Obj].bParam[2] then // УМО
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,245, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,245); MarhTracert[Group].GonkaStrel := false;
                end;
              end;
            end;
          else
            result := trStop;
            exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          case Rod of
            MarshP : begin
              inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,244, ''); InsMsg(Group,jmp.Obj,244);
            end;
            MarshM : begin
              case Con.Pin of
                1 : begin
                  if not ObjZav[jmp.Obj].bParam[1] then // УМП
                  begin
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,245, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,245);
                  end;
                end;
              else
                if not ObjZav[jmp.Obj].bParam[2] then // УМО
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,245, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,245);
                end;
              end;
            end;
          else
            result := trStop;
            exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    24 : begin // Запрос согласия поездного отправления
      case Lvl of
        tlFindTrace : begin
          result := trRepeat;
        end;

        tlContTrace : begin
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlVZavTrace : begin
          result := trStop;
        end;

        tlCheckTrace : begin
          result := trEndTrace;
          case Rod of
            MarshP : begin
              if not ObjZav[jmp.Obj].bParam[13] then // ФС
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,246, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,246); MarhTracert[Group].GonkaStrel := false;
              end;
              if ObjZav[jmp.Obj].bParam[3] then // НЭГС
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,105); MarhTracert[Group].GonkaStrel := false;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then // чи
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,248, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,248);
              end;
              if ObjZav[jmp.Obj].bParam[9] then // чкм
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,249, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,249);
              end;
              if not ObjZav[jmp.Obj].bParam[7] then // п
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,250, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,250);
              end;
              if ObjZav[jmp.Obj].bParam[14] or ObjZav[jmp.Obj].bParam[15] then // перегон заблокирован
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,432, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,432); MarhTracert[Group].GonkaStrel := false;
              end;
              if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
              begin
                if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,462);
                end else
                if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
                begin
                  if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,467);
                  end;
                  if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,472);
                  end;
                end;
              end else
              begin // конец подвески контакной провода
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,474, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,474);
              end;
            end;
            MarshM : begin
              //
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trEndTrace;
          case Rod of
            MarshP : begin
              if not ObjZav[jmp.Obj].bParam[13] then // ФС
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,246, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,246);
              end;
              if ObjZav[jmp.Obj].bParam[3] then // НЭГС
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,105);
              end;
              if not ObjZav[jmp.Obj].bParam[8] then // чи
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,248, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,248);
              end;
              if ObjZav[jmp.Obj].bParam[9] then // чкм
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,249, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,249);
              end;
              if not ObjZav[jmp.Obj].bParam[7] then // п
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,250, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,250);
              end;
              if ObjZav[jmp.Obj].bParam[14] or ObjZav[jmp.Obj].bParam[15] then // перегон заблокирован
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,432, ObjZav[jmp.Obj].Title); InsMsg(Group,jmp.Obj,432);
              end;
              if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
              begin
                if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,462);
                end else
                if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
                begin
                  if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,467);
                  end;
                  if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,472);
                  end;
                end;
              end else
              begin // конец подвески контакной провода
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,474, ObjZav[jmp.Obj].Title); InsWar(Group,jmp.Obj,474);
              end;
            end;
            MarshM : begin
              //
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlFindIzvest : begin
          if (not ObjZav[jmp.Obj].bParam[5] and not ObjZav[jmp.Obj].bParam[8]) or not ObjZav[jmp.Obj].bParam[7] then
          begin // Занято приближение
            result := trBreak;
          end else
            result := trStop;
        end;

        tlFindIzvStrel : result := trStop;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    26 : begin // ПАБ
      case Lvl of
        tlFindTrace : begin
          result := trNextStep;
          if not MarhTracert[Group].LvlFNext then
          begin
            if Con.Pin = 1 then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end else
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlPovtorMarh,
        tlContTrace : begin
          case Rod of
            MarshP : if ObjZav[jmp.Obj].ObjConstB[1] then result := trEndTrace else result := trStop;
            MarshM : result := trStop;
          else
            result := trEndTrace;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // перегон заблокирован
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,432, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,432); MarhTracert[Group].GonkaStrel := false;
              end;
              if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
              begin
                if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
                end else
                if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
                begin
                  if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
                  end;
                  if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
                  end;
                end;
              end else
              begin // конец подвески контакной провода
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,474, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,474);
              end;
              if not ObjZav[jmp.Obj].bParam[7] then // Хозпоезд на перегоне
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,130, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,130); MarhTracert[Group].GonkaStrel := false;
              end else
              if not ObjZav[jmp.Obj].bParam[1] then // Перегон занят по приему
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,318, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,318); MarhTracert[Group].GonkaStrel := false;
              end else
              if ObjZav[jmp.Obj].bParam[2] then // Получено прибытие поезда
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,319, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,319); MarhTracert[Group].GonkaStrel := false;
              end else
              if ObjZav[jmp.Obj].bParam[4] then // Выдано согласие на соседнюю станцию
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,320, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,320); MarhTracert[Group].GonkaStrel := false;
              end else
              if ObjZav[jmp.Obj].bParam[6] then // согласие отправления
              begin
                if not ObjZav[jmp.Obj].bParam[5] then // есть занятость перегона по отправлению
                begin
                  result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,299, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,299); MarhTracert[Group].GonkaStrel := false;
                end;
              end else
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,237, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,237);
              end;
              if not ObjZav[jmp.Obj].bParam[9] then // Занят известитель
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
              end;
            end;
            MarshM : begin
              //
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          case Rod of
            MarshP : begin
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then // перегон заблокирован
              begin
                result := trBreak; inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,432, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,432);
              end;
              if ObjZav[jmp.Obj].ObjConstB[8] or ObjZav[jmp.Obj].ObjConstB[9] then
              begin
                if ObjZav[jmp.Obj].bParam[24] or ObjZav[jmp.Obj].bParam[27] then // Закрыт для движения на эл.т.
                begin
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,462, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,462);
                end else
                if ObjZav[jmp.Obj].ObjConstB[8] and ObjZav[jmp.Obj].ObjConstB[9] then
                begin
                  if ObjZav[jmp.Obj].bParam[25] or ObjZav[jmp.Obj].bParam[28] then // Закрыт для движения на пост.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,467, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,467);
                  end;
                  if ObjZav[jmp.Obj].bParam[26] or ObjZav[jmp.Obj].bParam[29] then // Закрыт для движения на пер.т.
                  begin
                    inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,472, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,472);
                  end;
                end;
              end else
              begin // конец подвески контакной провода
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,474, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,474);
              end;
              if not ObjZav[jmp.Obj].bParam[7] then // Хозпоезд на перегоне
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,130, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,130);
              end else
              if not ObjZav[jmp.Obj].bParam[1] then // Перегон занят по приему
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,318, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,318);
              end else
              if ObjZav[jmp.Obj].bParam[2] then // Получено прибытие поезда
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,319, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,319);
              end else
              if ObjZav[jmp.Obj].bParam[4] then // Выдано согласие на соседнюю станцию
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,320, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,320);
              end else
              if ObjZav[jmp.Obj].bParam[6] then // согласие отправления
              begin
                if not ObjZav[jmp.Obj].bParam[5] then // есть занятость перегона по отправлению
                begin
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,299, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,299);
                end;
              end else
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,237, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,237);
              end;
              if not ObjZav[jmp.Obj].bParam[9] then // Занят известитель
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,83);
              end;
            end;
            MarshM : begin
              //
            end;
          else
            result := trStop; exit;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlFindIzvest : begin
          if not ObjZav[jmp.Obj].bParam[9] then
          begin // Занято приближение
            result := trBreak;
          end else
            result := trStop;
        end;

        tlFindIzvStrel : result := trStop;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    27 : begin // Охранности стрелок
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          // проверка охранного положения при трассировке
          o := ObjZav[jmp.Obj].ObjConstI[1]; // контролируемая стрелка
          k := ObjZav[jmp.Obj].ObjConstI[3]; // охранная стрелка
          if (o > 0) and (k > 0) then
          begin
            tr := ObjZav[k].bParam[6] or ObjZav[k].bParam[7] or
                  ObjZav[k].bParam[10] or ObjZav[k].bParam[11] or
                  ObjZav[k].bParam[12] or ObjZav[k].bParam[13];
            m := ObjZav[k].BaseObject;
            if (ObjZav[m].ObjConstI[8] = k) and (ObjZav[m].ObjConstI[9] > 0) then m := ObjZav[m].ObjConstI[9]
            else if ObjZav[m].ObjConstI[8] > 0 then m := ObjZav[m].ObjConstI[8] else m := 0;
            if m > 0 then
              tr := tr or ObjZav[k].bParam[6] or ObjZav[k].bParam[7] or
                    ObjZav[m].bParam[10] or ObjZav[m].bParam[11] or
                    ObjZav[m].bParam[12] or ObjZav[m].bParam[13];

            if ObjZav[jmp.Obj].ObjConstB[5] or tr then
            begin // выполняется гонка охранной стрелки в маршруте
              if ObjZav[jmp.Obj].ObjConstB[1] then // Контролируемая стрелка охраняется в плюсе
              begin
                if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or ObjZav[o].bParam[12]) then
                begin
                  if ObjZav[jmp.Obj].ObjConstB[3] then // охранная должна быть в плюсе
                  begin
                    if (ObjZav[k].bParam[10] and ObjZav[k].bParam[11]) or
                       ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[7]) or
                       ObjZav[k].bParam[13] then
                    begin
                      if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and // стрелки в разных секциях
                         not ObjZav[k].bParam[14] then // не выдана маршрутная команда в сервер
                      begin
                        result := trStop; exit; // охранная трассируется в минусе - отказ
                      end;
                    end;
                  end else
                  if ObjZav[jmp.Obj].ObjConstB[4] then // охранная должна быть в минусе
                  begin
                    if (ObjZav[k].bParam[10] and not ObjZav[k].bParam[11]) or
                       ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[6]) or
                       ObjZav[k].bParam[12] then
                    begin
                      if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and // стрелки в разных секциях
                         not ObjZav[k].bParam[14] then // не выдана маршрутная команда в сервер
                      begin
                        result := trStop; exit; // охранная трассируется в плюсе - отказ
                      end;
                    end;
                  end;
                end;
              end else
              if ObjZav[jmp.Obj].ObjConstB[2] then // Контролируемая стрелка охраняется в минусе
              begin
                if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or ObjZav[o].bParam[13]) then
                begin
                  if ObjZav[jmp.Obj].ObjConstB[3] then // охранная должна быть в плюсе
                  begin
                    if (ObjZav[k].bParam[10] and ObjZav[k].bParam[11]) or
                       ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[7]) or
                       ObjZav[k].bParam[13] then
                    begin
                      if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and // стрелки в разных секциях
                         not ObjZav[k].bParam[14] then // не выдана маршрутная команда в сервер
                      begin
                        result := trStop; exit; // охранная трассируется в минусе - отказ
                      end;
                    end;
                  end else
                  if ObjZav[jmp.Obj].ObjConstB[4] then // охранная должна быть в минусе
                  begin
                    if (ObjZav[k].bParam[10] and not ObjZav[k].bParam[11]) or
                       ((ObjZav[o].ObjConstI[20] = 0) and ObjZav[k].bParam[6]) or
                       ObjZav[k].bParam[12] then
                    begin
                      if (ObjZav[o].UpdateObject <> ObjZav[k].UpdateObject) and // стрелки в разных секциях
                         not ObjZav[k].bParam[14] then // не выдана маршрутная команда в сервер
                      begin 
                        result := trStop; exit; // охранная трассируется в плюсе - отказ
                      end;
                    end;
                  end;
                end;
              end;
            end else
            begin // не выполняется гонка охранной стрелки в маршруте
              if ((jmp.Pin = 1) and not ObjZav[jmp.Obj].ObjConstB[6]) or
                 ((jmp.Pin = 2) and not ObjZav[jmp.Obj].ObjConstB[7]) then
              begin
                if ObjZav[jmp.Obj].ObjConstB[1] then // Контролируемая стрелка охраняется в плюсе
                begin
                  if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or
                     ObjZav[o].bParam[12]) then
                  begin
                    if ObjZav[jmp.Obj].ObjConstB[3] then // охранная должна быть в плюсе
                    begin
                      if not (ObjZav[k].bParam[1] and not ObjZav[k].bParam[2]) then
                      begin // охранная не имеет контроля в плюсе - отказ
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,268); result := trStop; exit;
                      end;
                    end else
                    if ObjZav[jmp.Obj].ObjConstB[4] then // охранная должна быть в минусе
                    begin
                      if not (not ObjZav[k].bParam[1] and ObjZav[k].bParam[2]) then
                      begin // охранная не имеет контроля в минусе - отказ
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,267); result := trStop; exit;
                      end;
                    end;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[2] then // Контролируемая стрелка охраняется в минусе
                begin
                  if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
                     ObjZav[o].bParam[13]) then
                  begin
                    if ObjZav[jmp.Obj].ObjConstB[3] then // охранная должна быть в плюсе
                    begin
                      if not (ObjZav[k].bParam[1] and not ObjZav[k].bParam[2]) then
                      begin
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,268); result := trStop; exit;
                      end;
                    end else
                    if ObjZav[jmp.Obj].ObjConstB[4] then // охранная должна быть в минусе
                    begin
                      if not (not ObjZav[k].bParam[1] and ObjZav[k].bParam[2]) then
                      begin
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,267); result := trStop; exit;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
          // Найти следующий элемент трассы
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          // проверка возможности установки охранной стрелки в требуемое положение
          o := ObjZav[jmp.Obj].ObjConstI[1]; // контролируемая стрелка
          k := ObjZav[jmp.Obj].ObjConstI[3]; // охранная стрелка
          if (o > 0) and (k > 0) then
          begin
            if ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              if ((ObjZav[o].bParam[10] and not ObjZav[o].bParam[11]) or
                  ObjZav[o].bParam[12]) then // Контролируемая стрелка охраняется в плюсе
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then // Охранная стрелка должна быть в плюсе
                begin

                  if ObjZav[o].ObjConstI[20] = k then
                  begin // сделать проверки трассировки секущего маршрута через крест
                    if ObjZav[ObjZav[k].BaseObject].bParam[7] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;

                  if not ObjZav[k].bParam[1] then
                  begin
                    if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                    if not ObjZav[k].bParam[2] then
                    begin // нет контроля положения
                      if not ObjZav[k].bParam[6] then
                      begin
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,80); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                    begin // охранная стрелка занята
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,118, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,118); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                    begin // охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[k].bParam[18] then
                    begin // охранная стрелка выключена
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,121); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then // Охранная стрелка должна быть в минусе
                begin

                  if ObjZav[o].ObjConstI[20] = k then
                  begin // сделать проверки трассировки секущего маршрута через крест
                    if ObjZav[ObjZav[k].BaseObject].bParam[6] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;

                  if not ObjZav[k].bParam[2] then
                  begin
                    if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                    if not ObjZav[k].bParam[1] then
                    begin // нет контроля положения
                      if not ObjZav[k].bParam[7] then
                      begin
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,157, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,157); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,80); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                    begin // охранная стрелка занята
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,158, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,158); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                    begin // охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[k].bParam[18] then
                    begin // охранная стрелка выключена
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,159); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              if ((ObjZav[o].bParam[10] and ObjZav[o].bParam[11]) or
                 ObjZav[o].bParam[13]) then // Контролируемая стрелка охраняется в минусе
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then // Охранная стрелка должна быть в плюсе
                begin

                  if ObjZav[o].ObjConstI[20] = k then
                  begin // сделать проверки трассировки секущего маршрута через крест
                    if ObjZav[ObjZav[k].BaseObject].bParam[7] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;

                  if not ObjZav[k].bParam[1] then
                  begin
                    if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                    if not ObjZav[k].bParam[2] then
                    begin // нет контроля положения
                      if not ObjZav[k].bParam[6] then
                      begin
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,80); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                    begin // охранная стрелка занята
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,118, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,118); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                    begin // охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[k].bParam[18] then
                    begin // охранная стрелка выключена
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,121); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then // Охранная стрелка должна быть в минусе
                begin

                  if ObjZav[o].ObjConstI[20] = k then
                  begin // сделать проверки трассировки секущего маршрута через крест
                    if ObjZav[ObjZav[k].BaseObject].bParam[6] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;

                  if not ObjZav[k].bParam[2] then
                  begin
                    if not MarhTracert[Group].Povtor and not MarhTracert[Group].Dobor then inc(MarhTracert[Group].GonkaList); // увеличить счетчик количества стрелок, которые будут переведены для сборки трассы маршрута
                    if not ObjZav[k].bParam[1] then
                    begin // нет контроля положения
                      if not ObjZav[k].bParam[7] then
                      begin
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                      end;
                    end else
                    if not ObjZav[ObjZav[k].BaseObject].bParam[21] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,157, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,157); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[4] then
                    begin // охранная стрелка замкнута
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,80); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if not ObjZav[ObjZav[k].BaseObject].bParam[22] then
                    begin // охранная стрелка занята
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,158, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,158); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[ObjZav[k].BaseObject].bParam[19] then
                    begin // охранная стрелка на макете
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                    if ObjZav[k].bParam[18] then
                    begin // охранная стрелка выключена
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,159); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          // проверка возможности установки охранной стрелки в требуемое положение
          o := ObjZav[jmp.Obj].ObjConstI[1]; // контролируемая стрелка
          k := ObjZav[jmp.Obj].ObjConstI[3]; // охранная стрелка
          if (o > 0) and (k > 0) then
          begin
            if ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              if ObjZav[o].bParam[1] then // Контролируемая стрелка охраняется в плюсе
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then // Охранная стрелка должна быть в плюсе
                begin
                  if ObjZav[k].bParam[1] then
                  begin // проверить наличие гонки в минус
                    if ObjZav[k].bParam[7] then
                    begin // охранная стрелка гонится в минус
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,236);
                    end;
                  end else
                  begin
                    if not ObjZav[k].bParam[2] then
                    begin // нет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81);
                    end else
                    begin // охранная стрелка в минусе
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,236);
                    end;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then // Охранная стрелка должна быть в минусе
                begin
                  if ObjZav[k].bParam[2] then
                  begin // проверить наличие гонки в плюс
                    if ObjZav[k].bParam[6] then
                    begin // охранная стрелка гонится в плюс
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,235);
                    end;
                  end else
                  begin
                    if not ObjZav[k].bParam[1] then
                    begin // нет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81);
                    end else
                    begin // охранная стрелка в плюсе
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,235);
                    end;
                  end;
                end;
              end;
            end else
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              if ObjZav[o].bParam[2] then // Контролируемая стрелка охраняется в минусе
              begin
                if ObjZav[jmp.Obj].ObjConstB[3] then // Охранная стрелка должна быть в плюсе
                begin
                  if ObjZav[k].bParam[1] then
                  begin // проверить наличие гонки в минус
                    if ObjZav[k].bParam[7] then
                    begin // охранная стрелка гонится в минус
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,236);
                    end;
                  end else
                  begin
                    if not ObjZav[k].bParam[2] then
                    begin // нет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81);
                    end else
                    begin // охранная стрелка в минусе
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,236, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,236);
                    end;
                  end;
                end else
                if ObjZav[jmp.Obj].ObjConstB[4] then // Охранная стрелка должна быть в минусе
                begin
                  if ObjZav[k].bParam[2] then
                  begin // проверить наличие гонки в плюс
                    if ObjZav[k].bParam[6] then
                    begin // охранная стрелка гонится в плюс
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,235);
                    end;
                  end else
                  begin
                    if not ObjZav[k].bParam[1] then
                    begin // нет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,81);
                    end else
                    begin // охранная стрелка в плюсе
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,235, ObjZav[ObjZav[k].BaseObject].Liter); InsMsg(Group,ObjZav[k].BaseObject,235);
                    end;
                  end;
                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    28 : begin // Извещение на переезд
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          o := ObjZav[jmp.Obj].BaseObject;
          if ObjZav[o].bParam[4] then
          begin // зГ на переезде
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,107, ObjZav[o].Liter); result := trBreak; InsMsg(Group,o,107); MarhTracert[Group].GonkaStrel := false;
          end;
          if ObjZav[o].bParam[1] then
          begin // авария на переезде
            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,143, ObjZav[o].Liter); result := trBreak; InsWar(Group,o,143); MarhTracert[Group].GonkaStrel := false;
          end;
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin // неисправность на переезде
            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,144, ObjZav[o].Liter); result := trBreak; InsWar(Group,o,144); MarhTracert[Group].GonkaStrel := false;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          o := ObjZav[jmp.Obj].BaseObject;
          if ObjZav[o].bParam[4] then
          begin // зГ на переезде
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,107, ObjZav[o].Liter); InsMsg(Group,o,107);
          end;
          if ObjZav[o].bParam[1] then
          begin // авария на переезде
            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,143, ObjZav[o].Liter); InsWar(Group,o,143);
          end;
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin // неисправность на переезде
            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,144, ObjZav[o].Liter); InsWar(Group,o,144);
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    29 : begin // ДЗ секции
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          if ((Con.Pin = 1) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[1]) or
             ((Con.Pin = 1) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2]) or
             ((Con.Pin = 2) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
             ((Con.Pin = 2) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZav[jmp.Obj].ObjConstI[k];
              if o > 0 then
              begin
                case ObjZav[o].TypeObj of
                  8 : begin // УТС
                    if ((not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                       (ObjZav[o].bParam[1] and ObjZav[o].bParam[2])) and not ObjZav[o].bParam[3] then
                    begin // Упор включен в зависимости и не имеет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[o].Liter); InsMsg(Group,o,109); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end else
                    if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] and
                       not ObjZav[o].bParam[3] and (Rod = MarshP) then
                    begin // Упор установлен и включен в зависимости и поездной маршрут
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[o].Liter); InsMsg(Group,o,108); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end else

                    if not ObjZav[o].bParam[27] then
                    begin // не зарегистрировано сообщение по УТС
                      if ObjZav[o].bParam[3] then
                      begin // Упор выключен из зависимостей
                        inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,253, ObjZav[o].Liter); InsWar(Group,o,253); result := trBreak;
                      end;
                      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
                      begin // Упор установлен
                        inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[o].Liter); InsWar(Group,o,108); result := trBreak;
                      end else
                      if (not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
                      begin // Упор не имеет контроля положения
                        inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,109, ObjZav[o].Liter); InsWar(Group,o,109); result := trBreak;
                      end;
                    end;
                    if result = trBreak then ObjZav[o].bParam[27] := true;
                  end;

                  33 : begin // одиночный датчик
                    if ObjZav[o].bParam[1] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[o].ObjConstB[1] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]]; InsMsg(Group,o,3);
                      end else
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]]; InsMsg(Group,o,2);
                      end;
                      MarhTracert[Group].GonkaStrel := false;
                      result := trBreak;
                    end;
                  end;
                  // другие объекты зависимостей
                else

                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          if ((Con.Pin = 1) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[1]) or
             ((Con.Pin = 1) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2]) or
             ((Con.Pin = 2) and (Rod = MarshM) and ObjZav[jmp.Obj].ObjConstB[3]) or
             ((Con.Pin = 2) and (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[4]) then
          begin
            for k := 1 to 10 do
            begin
              o := ObjZav[jmp.Obj].ObjConstI[k];
              if o > 0 then
              begin
                case ObjZav[o].TypeObj of
                  8 : begin // УТС
                    if ((not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or
                       (ObjZav[o].bParam[1] and ObjZav[o].bParam[2])) and not ObjZav[o].bParam[3] then
                    begin // Упор включен в зависимости и не имеет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,109, ObjZav[o].Liter); InsMsg(Group,o,109);
                    end else
                    if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] and
                       not ObjZav[o].bParam[3] and (Rod = MarshP) then
                    begin // Упор установлен и включен в зависимости и поездной маршрут
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,108, ObjZav[o].Liter); InsMsg(Group,o,108);
                    end else

                    if not ObjZav[o].bParam[27] then
                    begin
                      p := false;
                      if ObjZav[o].bParam[3] then
                      begin // Упор выключен из зависимостей
                        p := true; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,253, ObjZav[o].Liter); InsWar(Group,o,253);
                      end;
                      if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
                      begin // Упор установлен
                        p := true; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,108, ObjZav[o].Liter); InsWar(Group,o,108);
                      end else
                      if (not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2]) or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
                      begin // Упор не имеет контроля положения
                        p := true; inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,109, ObjZav[o].Liter); InsWar(Group,o,109);
                      end;
                      if p then ObjZav[o].bParam[27] := true;
                    end;
                  end;

                  33 : begin // одиночный датчик
                    if ObjZav[o].bParam[1] then
                    begin
                      inc(MarhTracert[Group].MsgCount);
                      if ObjZav[o].ObjConstB[1] then
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]]; InsMsg(Group,o,3);
                      end else
                      begin
                        MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]]; InsMsg(Group,o,2);
                      end;
                    end;
                  end;
                  // другие объекты зависимостей
                else

                end;
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    30 : begin // Выдача поездного согласия
      case Lvl of
        tlFindTrace : begin
          if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
          begin // Продолжить трассировку если свой район управления
            if Con.Pin = 1 then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              else
                result := trNextStep;
              end;
            end else
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              else
                result := trNextStep;
              end;
            end;
          end else
            result := trRepeat;
        end;

        tlContTrace : begin
          if ObjZav[Con.Obj].RU = ObjZav[MarhTracert[Group].ObjStart].RU then
          begin // Продолжить трассировку если свой район управления
            result := trNextStep;
            if Con.Pin = 1 then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trEnd;
                LnkEnd : result := trEnd;
              end;
            end else
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trEnd;
                LnkEnd : result := trEnd;
              end;
            end;
          end else
            result := trEndTrace; // Завершить трассировку маршрута если другой район управления
        end;

        tlVZavTrace : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              if jmp.Obj = MarhTracert[Group].ObjLast then
              begin
                o := ObjZav[jmp.Obj].BaseObject;
                if o > 0 then
                begin
                  if ObjZav[jmp.Obj].bParam[1] then
                  begin // нажата кнопка ЭГС
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[o].Liter); InsMsg(Group,o,105); result := trBreak;
                  end;
                  if not ObjZav[o].bParam[4] then
                  begin // нет поездного согласия
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,246, ObjZav[o].Liter); InsMsg(Group,o,246); result := trBreak;
                  end;
                end;
              end;
            end;
          end;
          if jmp.Obj <> MarhTracert[Group].ObjLast then
          begin
            o := ObjZav[jmp.Obj].UpdateObject;
            if o > 0 then
            begin // проверить враждебности участка увязки
              if not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3] then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[o].Liter); InsMsg(Group,o,113); result := trBreak; MarhTracert[Group].GonkaStrel := false;
              end;
            end;
          end;
          MarhTracert[Group].TailMsg := ' до '+ ObjZav[ObjZav[jmp.Obj].BaseObject].Liter;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlSignalCirc : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] <> ObjZav[jmp.Obj].BaseObject then
              begin
                o := ObjZav[jmp.Obj].BaseObject;
                if o > 0 then
                begin
                  if ObjZav[jmp.Obj].bParam[1] then
                  begin // нажата кнопка ЭГС
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[o].Liter); InsMsg(Group,o,105);
                  end;
                  if not ObjZav[o].bParam[4] then
                  begin // нет поездного согласия
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,246, ObjZav[o].Liter); InsMsg(Group,o,246);
                  end;
                end;
              end;
            end;
          end;
          if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] = ObjZav[jmp.Obj].BaseObject then
          begin
            o := ObjZav[jmp.Obj].UpdateObject;
            if o > 0 then
            begin // проверить враждебности участка увязки
              if ObjZav[o].bParam[2] and ObjZav[o].bParam[3] then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,163, ObjZav[o].Liter); InsMsg(Group,o,163);
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign : begin
          result := trNextStep;
          case Rod of
            MarshP : begin
              if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] <> ObjZav[jmp.Obj].BaseObject then
              begin
                o := ObjZav[jmp.Obj].BaseObject;
                if o > 0 then
                begin
                  if ObjZav[jmp.Obj].bParam[1] then
                  begin // нажата кнопка ЭГС
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[o].Liter); InsMsg(Group,o,105);
                  end;
                  if not ObjZav[o].bParam[4] then
                  begin // нет поездного согласия
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,246, ObjZav[o].Liter); InsMsg(Group,o,246);
                  end;
                end;
              end;
            end;
          end;
          if MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] = ObjZav[jmp.Obj].BaseObject then
          begin
            o := ObjZav[jmp.Obj].UpdateObject;
            if o > 0 then
            begin // проверить враждебности участка увязки
              if not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3] then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,113, ObjZav[o].Liter); InsMsg(Group,o,113);
              end;
            end;
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

        tlZamykTrace : begin
          MarhTracert[Group].TailMsg := ' до '+ ObjZav[ObjZav[jmp.Obj].BaseObject].Liter;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    32 : begin // Увязка с горкой (надвиг)
      case Lvl of
        tlFindTrace : begin
          result := trRepeat;
        end;

        tlPovtorMarh,
        tlContTrace : begin
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlVZavTrace : begin
          result := trStop;
        end;

        tlCheckTrace : begin
          result := trBreak;
          MarhTracert[Group].TailMsg := ' до '+ ObjZav[jmp.Obj].Liter;
          if ObjZav[jmp.Obj].bParam[10] then
          begin // уже есть маршрут надвига на горку
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,355, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,355); MarhTracert[Group].GonkaStrel := false; exit;
          end;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter); InsMsg(Group,MarhTracert[Group].ObjStart,106); MarhTracert[Group].GonkaStrel := false; exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // блокировка кнопки горочного светофора
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,123); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ГП
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ЭГС
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,105); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // нет согласия надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,103); MarhTracert[Group].GonkaStrel := false; exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                 not (ObjZav[ObjZav[o].BaseObject].bParam[2] and ObjZav[ObjZav[o].BaseObject].bParam[3]) then
              begin // установлен поездной маршрут на путь надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,356); MarhTracert[Group].GonkaStrel := false; exit;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // нет согласия маневров
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,104); MarhTracert[Group].GonkaStrel := false; exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign : begin
          result := trStop;
          if ObjZav[jmp.Obj].bParam[10] then
          begin // уже есть маршрут надвига на горку
            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,355, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,355); exit;
          end;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter); InsMsg(Group,MarhTracert[Group].ObjStart,106); exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // блокировка кнопки горочного светофора
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,123); exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ГП
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83); exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ЭГС
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,105); exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // нет согласия надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,103); exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if Con.Pin = 1 then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[2] then
                begin // установлен четный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end else
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // установлен нечетный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // нет согласия маневров
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,104); exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlSignalCirc : begin
          result := trStop;
          case Rod of
            MarshP : begin
              o := 1;
              while o < 13 do
              begin
                if MarhTracert[Group].ObjStart = ObjZav[ObjZav[jmp.Obj].UpdateObject].ObjConstI[o] then break;
                inc(o);
              end;
              if o > 12 then
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,106, ObjZav[MarhTracert[Group].ObjStart].Liter); InsMsg(Group,MarhTracert[Group].ObjStart,106); exit;
              end else
              if ObjZav[jmp.Obj].bParam[12] or ObjZav[jmp.Obj].bParam[13] then
              begin // блокировка кнопки горочного светофора
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,123, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,123); exit;
              end;
              if ObjZav[jmp.Obj].bParam[11] then
              begin // ГП
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,83, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,83); exit;
              end;
              if ObjZav[jmp.Obj].bParam[7] then
              begin // ЭГС
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,105, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,105); exit;
              end;
              if not ObjZav[jmp.Obj].bParam[8] then
              begin // нет согласия надвига
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,103, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,103); exit;
              end;
              o := MarhTracert[Group].PutNadviga;
              if Con.Pin = 1 then
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[2] then
                begin // установлен четный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end else
              begin
                if not ObjZav[ObjZav[o].BaseObject].bParam[4] and
                   not ObjZav[ObjZav[o].BaseObject].bParam[3] then
                begin // установлен нечетный поездной маршрут на путь надвига
                  inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,356, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,356); exit;
                end;
              end;
            end;
            MarshM : begin
              if not ObjZav[jmp.Obj].bParam[9] then
              begin // нет согласия маневров
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,104, ObjZav[jmp.Obj].Liter); InsMsg(Group,jmp.Obj,104); exit;
              end;
            end;
          else
            result := trStop; exit;
          end;
          MarhTracert[Group].FullTail := true; result := trEndTrace;
        end;

        tlFindIzvest : begin
          if ObjZav[jmp.Obj].bParam[11] then
          begin // Занято приближение
            result := trBreak;
          end else
            result := trStop;
        end;

        tlFindIzvStrel : result := trStop;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;

////////////////////////////////////////////////////////////////////////////////
    38 : begin // Контроль маршрута надвига
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          MarhTracert[Group].PutNadviga := jmp.Obj; // сохранить индекс объекта согласия надвига с пути
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlAutoTrace,
        tlPovtorRazdel,
        tlRazdelSign,
        tlSignalCirc : begin
          MarhTracert[Group].PutNadviga := jmp.Obj; // сохранить индекс объекта согласия надвига с пути
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;
    ////////////////////////////////////////////////////////////////////////////
    41 : begin // Контроль маршрута отправления
      case Lvl of
        tlFindTrace : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;

        tlPovtorMarh,
        tlContTrace,
        tlVZavTrace,
        tlFindIzvest,
        tlFindIzvStrel : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlCheckTrace : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              ObjZav[jmp.Obj].bParam[21] := true;
              for k := 1 to 4 do
              begin
                o := ObjZav[jmp.Obj].ObjConstI[k];
                if o > 0 then
                begin
                  if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                  begin // стрелка в пути не имеет контроля положения
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,81); MarhTracert[Group].GonkaStrel := false; exit;
                  end else
                  if (ObjZav[ObjZav[o].BaseObject].bParam[4] or ObjZav[ObjZav[o].BaseObject].bParam[14]) and
                     ObjZav[ObjZav[o].BaseObject].bParam[21] then
                  begin // охранная стрелка трассируется в маршруте
                    if (ObjZav[jmp.Obj].ObjConstB[k*3+1] and ObjZav[ObjZav[o].BaseObject].bParam[6]) or
                       (ObjZav[jmp.Obj].ObjConstB[k*3] and ObjZav[ObjZav[o].BaseObject].bParam[7]) then
                    begin // трассировка в разрез маршрута отправления
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,80); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                  if ObjZav[jmp.Obj].ObjConstB[k*3+2] then
                  begin // маршрутная гонка стрелки в пути выполняется
                    if ObjZav[jmp.Obj].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                    begin // стрелка в пути не имеет контроля в плюсе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        if not ObjZav[ObjZav[o].BaseObject].bParam[21] then
                        begin // охранная стрелка замкнута
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if not ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // охранная стрелка занята
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,118, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,118); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                        begin // охранная стрелка на макете
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[o].bParam[18] then
                        begin // охранная стрелка выключена
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,121); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                      end else
                      begin // есть прикрытие стрелки в пути
                        if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // стрелка свободна и не замкнута
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                          if ObjZav[o].bParam[18] then
                          begin // охранная стрелка выключена
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,121); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end else
                        begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,136, ObjZav[ObjZav[o].BaseObject].Liter); InsWar(Group,ObjZav[o].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end;
                      end;
                    end;
                    if ObjZav[jmp.Obj].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля в минусе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        if not ObjZav[ObjZav[o].BaseObject].bParam[21] then
                        begin // охранная стрелка замкнута
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if not ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // охранная стрелка занята
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,118, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,118); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                        begin // охранная стрелка на макете
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[o].bParam[18] then
                        begin // охранная стрелка выключена
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,159); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                      end else
                      begin // есть прикрытие стрелки в пути
                        if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // стрелка свободна и не замкнута
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                          if ObjZav[o].bParam[18] then
                          begin // охранная стрелка выключена
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,159); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end else
                        begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,137, ObjZav[ObjZav[o].BaseObject].Liter); InsWar(Group,ObjZav[o].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end;
                      end;
                    end;
                  end else
                  begin // маршрутная гонка стрелки в пути не выполняется
                    if ObjZav[jmp.Obj].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                    begin // стрелка в пути не имеет контроля в плюсе
                      if (ObjZav[jmp.Obj].ObjConstI[k+4] = 0) or (ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22]) then
                      begin // нет сигнала прикрытия для стрелки в пути или нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[o].Liter); InsMsg(Group,ObjZav[o].BaseObject,268); MarhTracert[Group].GonkaStrel := false; exit;
                      end;
                    end;
                    if ObjZav[jmp.Obj].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля в минусе
                      if (ObjZav[jmp.Obj].ObjConstI[k+4] = 0) or (ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22]) then
                      begin // нет сигнала прикрытия для стрелки в пути или нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,267, ObjZav[o].Liter); InsMsg(Group,ObjZav[o].BaseObject,267); MarhTracert[Group].GonkaStrel := false; exit;
                      end;
                    end;
                  end;
                end;
              end;
            end else
              ObjZav[jmp.Obj].bParam[21] := false;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              ObjZav[jmp.Obj].bParam[21] := true;
              for k := 1 to 4 do
              begin
                o := ObjZav[jmp.Obj].ObjConstI[k];
                if o > 0 then
                begin
                  if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                  begin // стрелка в пути не имеет контроля положения
                    inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,81); MarhTracert[Group].GonkaStrel := false; exit;
                  end else
                  if (ObjZav[ObjZav[o].BaseObject].bParam[4] or ObjZav[ObjZav[o].BaseObject].bParam[14]) and
                     ObjZav[ObjZav[o].BaseObject].bParam[21] then
                  begin // охранная стрелка трассируется в маршруте
                    if (ObjZav[jmp.Obj].ObjConstB[k*3+1] and ObjZav[ObjZav[o].BaseObject].bParam[6]) or
                       (ObjZav[jmp.Obj].ObjConstB[k*3] and ObjZav[ObjZav[o].BaseObject].bParam[7]) then
                    begin // трассировка в разрез маршрута отправления
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,80, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,80); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                    end;
                  end;
                  if ObjZav[jmp.Obj].ObjConstB[k*3+2] then
                  begin // маршрутная гонка стрелки в пути выполняется
                    if ObjZav[jmp.Obj].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                    begin // стрелка в пути не имеет контроля в плюсе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        if not ObjZav[ObjZav[o].BaseObject].bParam[21] then
                        begin // охранная стрелка замкнута
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if not ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // охранная стрелка занята
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,118, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,118); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                        begin // охранная стрелка на макете
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[o].bParam[18] then
                        begin // охранная стрелка выключена
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,121); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                      end else
                      begin // есть прикрытие стрелки в пути
                        if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // стрелка свободна и не замкнута
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,136, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                          if ObjZav[o].bParam[18] then
                          begin // охранная стрелка выключена
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,121, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,121); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end else
                        begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,136, ObjZav[ObjZav[o].BaseObject].Liter); InsWar(Group,ObjZav[o].BaseObject,136); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end;
                      end;
                    end;
                    if ObjZav[jmp.Obj].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля в минусе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        if not ObjZav[ObjZav[o].BaseObject].bParam[21] then
                        begin // охранная стрелка замкнута
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,117, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,117); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if not ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // охранная стрелка занята
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,118, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,118); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                        begin // охранная стрелка на макете
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                        if ObjZav[o].bParam[18] then
                        begin // охранная стрелка выключена
                          inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,159); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                        end;
                      end else
                      begin // есть прикрытие стрелки в пути
                        if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                        begin // стрелка свободна и не замкнута
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,137, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                          if ObjZav[o].bParam[18] then
                          begin // охранная стрелка выключена
                            inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,159, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,159); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end else
                        begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[19] then
                          begin // охранная стрелка на макете
                            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,137, ObjZav[ObjZav[o].BaseObject].Liter); InsWar(Group,ObjZav[o].BaseObject,137); result := trBreak; MarhTracert[Group].GonkaStrel := false;
                          end;
                        end;
                      end;
                    end;
                  end else
                  begin // маршрутная гонка стрелки в пути не выполняется
                    if ObjZav[jmp.Obj].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                    begin // стрелка в пути не имеет контроля в плюсе
                      if (ObjZav[jmp.Obj].ObjConstI[k+4] = 0) or (ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22]) then
                      begin // нет сигнала прикрытия для стрелки в пути или нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[o].Liter); InsMsg(Group,ObjZav[o].BaseObject,268); MarhTracert[Group].GonkaStrel := false; exit;
                      end;
                    end;
                    if ObjZav[jmp.Obj].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля в минусе
                      if (ObjZav[jmp.Obj].ObjConstI[k+4] = 0) or (ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22]) then
                      begin // нет сигнала прикрытия для стрелки в пути или нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,267, ObjZav[o].Liter); InsMsg(Group,ObjZav[o].BaseObject,267); MarhTracert[Group].GonkaStrel := false; exit;
                      end;
                    end;
                  end;
                end;
              end;
            end else
              ObjZav[jmp.Obj].bParam[21] := false;
          end;
          case Con.TypeJmp of
            LnkRgn : result := trStop;
            LnkEnd : result := trStop;
          end;
        end;

        tlZamykTrace : begin
          ObjZav[jmp.Obj].bParam[21] := false;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              if Rod = MarshP then ObjZav[jmp.Obj].bParam[20] := true else ObjZav[jmp.Obj].bParam[20] := false;
            end;
          end else
          if Con.Pin = 2 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              if Rod = MarshP then ObjZav[jmp.Obj].bParam[20] := true else ObjZav[jmp.Obj].bParam[20] := false;
            end;
          end else
          begin
            ObjZav[jmp.Obj].bParam[20] := false;
          end;
        end;

        tlAutoTrace,
        tlSignalCirc,
        tlPovtorRazdel,
        tlRazdelSign : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            if ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              if Rod = MarshP then
              begin
                ObjZav[jmp.Obj].bParam[20] := true; ObjZav[jmp.Obj].bParam[21] := true;
                for k := 1 to 4 do
                begin
                  o := ObjZav[jmp.Obj].ObjConstI[k];
                  if o > 0 then
                  begin
                    if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,81);
                    end;

                    if ObjZav[jmp.Obj].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                    begin // стрелка в пути не имеет контроля в плюсе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else
                      if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                      begin // нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else


                      if not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] then
                      begin // неисправен сигнал прикрытия стрелки в пути при наличии замыкания выходной секции
                        if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[5] then
                        begin
                          inc(MarhTracert[Group].MsgCount);
                          if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[10] then // неисправен сигнал прикрытия
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,481, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],481);
                          end else // неисправен светофор
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,272, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],272);
                          end;
                        end;
                      end;
                    end;

                    if ObjZav[jmp.Obj].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля в минусе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else
                      if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                      begin // нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else


                      if not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] then
                      begin // неисправен сигнал прикрытия стрелки в пути при наличии замыкания выходной секции
                        if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[5] then
                        begin
                          inc(MarhTracert[Group].MsgCount);
                          if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[10] then // неисправен сигнал прикрытия
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,481, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],481);
                          end else // неисправен светофор
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,272, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],272);
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end else
              begin
                ObjZav[jmp.Obj].bParam[20] := false; ObjZav[jmp.Obj].bParam[21] := false;
              end;
            end else
            begin
              ObjZav[jmp.Obj].bParam[20] := false; ObjZav[jmp.Obj].bParam[21] := false;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[2];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end else
          begin
            if ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              if Rod = MarshP then
              begin
                ObjZav[jmp.Obj].bParam[20] := true; ObjZav[jmp.Obj].bParam[21] := true;
                for k := 1 to 4 do
                begin
                  o := ObjZav[jmp.Obj].ObjConstI[k];
                  if o > 0 then
                  begin
                    if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля положения
                      inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,81, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,81);
                    end;

                    if ObjZav[jmp.Obj].ObjConstB[k*3] and not ObjZav[o].bParam[1] then
                    begin // стрелка в пути не имеет контроля в плюсе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else
                      if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                      begin // нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else

                      if not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] then
                      begin // неисправен сигнал прикрытия стрелки в пути при наличии замыкания выходной секции
                        if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[5] then
                        begin
                          inc(MarhTracert[Group].MsgCount);
                          if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[10] then // неисправен сигнал прикрытия
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,481, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],481);
                          end else // неисправен светофор
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,272, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],272);
                          end;
                        end;
                      end;
                    end;

                    if ObjZav[jmp.Obj].ObjConstB[k*3+1] and not ObjZav[o].bParam[2] then
                    begin // стрелка в пути не имеет контроля в минусе
                      if ObjZav[jmp.Obj].ObjConstI[k+4] = 0 then
                      begin // нет сигнала прикрытия для стрелки в пути
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else
                      if ObjZav[ObjZav[o].BaseObject].bParam[21] and ObjZav[ObjZav[o].BaseObject].bParam[22] then
                      begin // нет занятости, замыкания
                        inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,268, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,268);
                      end else

                      if not ObjZav[ObjZav[jmp.Obj].UpdateObject].bParam[2] then
                      begin // неисправен сигнал прикрытия стрелки в пути при наличии замыкания выходной секции
                        if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[5] then
                        begin
                          inc(MarhTracert[Group].MsgCount);
                          if ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].bParam[10] then // неисправен сигнал прикрытия
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,481, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],481);
                          end else // неисправен светофор
                          begin
                            MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,272, ObjZav[ObjZav[jmp.Obj].ObjConstI[k+4]].Liter); InsMsg(Group,ObjZav[jmp.Obj].ObjConstI[k+4],272);
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end else
              begin
                ObjZav[jmp.Obj].bParam[20] := false; ObjZav[jmp.Obj].bParam[21] := false;
              end;
            end else
            begin
              ObjZav[jmp.Obj].bParam[20] := false; ObjZav[jmp.Obj].bParam[21] := false;
            end;
            if result = trNextStep then
            begin
              Con := ObjZav[jmp.Obj].Neighbour[1];
              case Con.TypeJmp of
                LnkRgn : result := trRepeat;
                LnkEnd : result := trRepeat;
              end;
            end;
          end;
        end;

        tlOtmenaMarh : begin
          if ObjZav[jmp.Obj].bParam[5] then ObjZav[jmp.Obj].bParam[20] := false;
          ObjZav[jmp.Obj].bParam[21] := false;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

      else
        result := trNextStep;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////
    42 : begin // Контроль перезамыкания маршрутов приема для стрелки в пути
      case Lvl of
        tlFindTrace : begin
          result := trNextStep;
          if Rod = MarshP then
            MarhTracert[Group].VP := jmp.Obj; // для продления трассы поездного маршрута сохранить объект перезамыкания стрелки в пути
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;

        tlVZavTrace,
        tlContTrace : begin
          result := trNextStep;
          if Rod = MarshP then
            MarhTracert[Group].VP := jmp.Obj; // при продлении трассы поездного маршрута сохранить объект перезамыкания стрелки в пути
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlCheckTrace : begin
          if Rod = MarshP then
          begin
            for k := 1 to 4 do
            begin
              o := ObjZav[jmp.Obj].ObjConstI[k];
              if o > 0 then
              begin // проверить наличие трассировки по "-" стрелки в пути
                if ObjZav[o].bParam[13] then
                begin// завершить трассировку если была езда по "-" стрелки в пути
                  inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,482, ObjZav[ObjZav[o].BaseObject].Liter); InsWar(Group,ObjZav[o].BaseObject,482);
                  break;
                end;
              end;
            end;
          end;
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlPovtorMarh,
        tlFindIzvest,
        tlFindIzvStrel : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlZamykTrace : begin
          result := trNextStep;
          if Rod = MarshP then ObjZav[jmp.Obj].bParam[1] := true; // Установить признак поездного маршрута приема
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlAutoTrace,
        tlSignalCirc,
        tlPovtorRazdel,
        tlRazdelSign : begin
          if Rod = MarshP then
            MarhTracert[Group].VP := jmp.Obj; // при определении трассы поездного маршрута сохранить объект перезамыкания стрелки в пути
          result := trNextStep;
          if Rod = MarshP then ObjZav[jmp.Obj].bParam[1] := true; // Установить признак поездного маршрута приема
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trRepeat;
            LnkEnd : result := trRepeat;
          end;
        end;

        tlOtmenaMarh : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

      else
        result := trNextStep;
      end;
    end;
////////////////////////////////////////////////////////////////////////////////
    43 : begin // оПИ
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlVZavTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trStop;
            else
              result := trNextStep;
            end;
          end;
        end;

        tlCheckTrace : begin
          tr := true;
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              o := ObjZav[jmp.Obj].BaseObject;
              if o > 0 then
              begin // протрассировать выезд на пути из маневрового района
                k := 2;
                o := ObjZav[jmp.Obj].Neighbour[k].Obj; k := ObjZav[jmp.Obj].Neighbour[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // стрелка
                      case k of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // стрелку можно поставить в отвод по минусу
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // стрелку можно поставить в отвод по плюсу
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // РПо
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then // нет отводящих стрелок по трассе до общей точки пучка
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end else
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              o := ObjZav[jmp.Obj].BaseObject;
              if o > 0 then
              begin // протрассировать выезд на пути из маневрового района
                k := 1;
                o := ObjZav[jmp.Obj].Neighbour[k].Obj; k := ObjZav[jmp.Obj].Neighbour[k].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // стрелка
                      case k of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // стрелку можно поставить в отвод по минусу
                            tr := false; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // стрелку можно поставить в отвод по плюсу
                            tr := false; break;
                          end;
                        end;
                      end;
                      k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // РПо
                      break;
                    end;
                  else
                    if k = 1 then begin k := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin k := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (k < 1) then break;
                  dec(j);
                end;
              end;
              if tr then // нет отводящих стрелок по трассе до общей точки пучка
              begin
                inc(MarhTracert[Group].MsgCount); MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsMsg(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end else
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258); MarhTracert[Group].GonkaStrel := false;
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[1] then
            begin
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258);
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end else
          begin
            if (Rod = MarshP) and ObjZav[jmp.Obj].ObjConstB[2] then
            begin
              if not ObjZav[ObjZav[jmp.Obj].BaseObject].bParam[3] and not ObjZav[jmp.Obj].bParam[1] then // МИ и оПИ
              begin
                inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,258, ObjZav[ObjZav[jmp.Obj].BaseObject].Liter); InsWar(Group,ObjZav[jmp.Obj].BaseObject,258);
              end;
            end;
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trStop;
              LnkEnd : result := trStop;
            end;
          end;
        end;

      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
    end;

    ////////////////////////////////////////////////////////////////////////////
    45 : begin // Зона оповещения
      case Lvl of
        tlFindTrace : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
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
        tlContTrace : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlSignalCirc,
        tlPovtorRazdel,
        tlRazdelSign,
        tlCheckTrace : begin
          result := trNextStep;
          if ObjZav[jmp.Obj].bParam[1] then
          begin // Включено оповещение монтеров
            inc(MarhTracert[Group].WarCount); MarhTracert[Group].Warning[MarhTracert[Group].WarCount] := GetShortMsg(1,456, ObjZav[jmp.Obj].Liter); InsWar(Group,jmp.Obj,456);
          end;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

        tlAutoTrace : begin
          result := trNextStep;
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
          end;
          case Con.TypeJmp of
            LnkRgn : result := trEnd;
            LnkEnd : result := trStop;
          end;
        end;

      else
        result := trNextStep;
      end;
    end;


















  else
  // объекты транслируют через себя без проверок
      case Lvl of
        tlFindTrace : begin
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trRepeat;
              LnkEnd : result := trRepeat;
            else
              result := trNextStep;
            end;
          end;
        end;
      else
          if Con.Pin = 1 then
          begin
            Con := ObjZav[jmp.Obj].Neighbour[2];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end else
          begin
            Con := ObjZav[jmp.Obj].Neighbour[1];
            case Con.TypeJmp of
              LnkRgn : result := trEnd;
              LnkEnd : result := trEnd;
            else
              result := trNextStep;
            end;
          end;
      end;
  end;

  if (result = trBreak) or (lvl = tlVZavTrace) or (lvl = tlCheckTrace) or (lvl = tlFindIzvest) or
     (lvl = tlFindIzvStrel) or (lvl = tlZamykTrace) {or (lvl = tlSignalCirc)} or (lvl = tlOtmenaMarh) then exit;

  // Продвинуть текущий объект
  if MarhTracert[Group].Counter < High(MarhTracert[Group].ObjTrace) then
  begin
    inc(MarhTracert[Group].Counter);
    MarhTracert[Group].ObjTrace[MarhTracert[Group].Counter] := jmp.Obj;
  end else
    result := trStop;
except
  reportf('Ошибка [Marshrut.TraceStep]');
  result := trStop;
end;
end;

//------------------------------------------------------------------------------
// Проверить возможность выдачи согласия на ограждение пути
function SoglasieOG(Index : SmallInt) : Boolean;
  var i,o,p,j : integer;
begin
try
  j := ObjZav[Index].UpdateObject; // индекс объекта ограждения пути
  if j > 0 then
  begin
    result := ObjZav[j].bParam[1]; // Есть запрос на ограждение
    // проверить ограждение по 1-ой точке
    o := ObjZav[Index].Neighbour[1].Obj; p := ObjZav[Index].Neighbour[1].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin // Вход по плюсу
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
            end;
            3 : begin // Вход по минусу
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break; // стрелка в отводе по плюсу
            end;
          else
            result := false; break; // ошибка в описании зависимостей - отсутствует СП в общей точке
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;

        3 : begin // участок
          result := ObjZav[o].bParam[2]; // замыкание участка
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;
    if not result then exit;
    // проверить ограждение по 2-ой точке
    o := ObjZav[Index].Neighbour[2].Obj; p := ObjZav[Index].Neighbour[2].Pin; i := 100;
    while i > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin // Вход по плюсу
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
            end;
            3 : begin // Вход по минусу
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break; // стрелка в отводе по плюсу
            end;
          else
            result := false; break; // ошибка в описании зависимостей - отсутствует СП в общей точке
          end;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;

        3 : begin // участок
          result := ObjZav[o].bParam[2]; // замыкание участка
          break;
        end;
      else
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;
      if (o = 0) or (p < 1) then break;
      dec(i);
    end;

    // запретить выдачу ограждения при местном управлении
    o := ObjZav[j].ObjConstI[18];
    if result and (o > 0) then
    begin
      if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
      begin
        result := false;
      end;
    end;
    o := ObjZav[j].ObjConstI[19];
    if result and (o > 0) then
    begin
      if not ObjZav[ObjZav[o].BaseObject].bParam[3] then
      begin
        result := false;
      end;
    end;
  end else
  begin
    result := false;
  end;
except
  reportf('Ошибка [Marshrut.SoglasieOG]');
  result := false;
end;
end;

// проверить ограждение пути через Вз стрелки при проверке враждебностей трассировки маршрута
function CheckOgrad(ptr : SmallInt; Group : Byte) : Boolean;
  var i,o,p : integer;
begin
try
  result := true;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
        6 : begin // Ограждение пути
          for p := 14 to 17 do
          begin
            if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[p] = Ptr then
            begin
              o := ObjZav[Ptr].ObjConstI[i];
              if ObjZav[o].bParam[2] then
              begin // Установлено ограждение пути
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[12]) or
                   (MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].bParam[7])) then
                begin // Стрелка нужна в плюсе
                  if not ObjZav[o].ObjConstB[p*2-27] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end else
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[13]) or
                   (MarhTracert[Group].Povtor and (not ObjZav[Ptr].bParam[6] and ObjZav[Ptr].bParam[7])) then
                begin // Стрелка нужна в минусе
                  if not ObjZav[o].ObjConstB[p*2-26] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
except
  reportf('Ошибка [Marshrut.CheckOgrad]');
  result := false;
end;
end;

// проверить установку маршрута отправления с пути с примыкающей стрелкой через хвост стрелки при проверке враждебностей трассировки маршрута
function CheckOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
  var i,j,o,p : integer;
begin
try
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[i];
    if p > 0 then
    begin
      case ObjZav[p].TypeObj of
        41 : begin // Контроль поездного маршрута отправления с пути
          if ObjZav[p].bParam[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZav[p].ObjConstI[j];
              if o = ptr then
              begin // проверить требуемое положение стрелки для обоих маршрутов
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and not ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[12]) or
                   (MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[6] and not ObjZav[Ptr].bParam[7])) then
                begin // Стрелка нужна в плюсе
                  if not ObjZav[p].ObjConstB[(j-1)*3+3] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end else
                if (not MarhTracert[Group].Povtor and (ObjZav[Ptr].bParam[10] and ObjZav[Ptr].bParam[11]) or ObjZav[Ptr].bParam[13]) or
                   (MarhTracert[Group].Povtor and (not ObjZav[Ptr].bParam[6] and ObjZav[Ptr].bParam[7])) then
                begin // Стрелка нужна в минусе
                  if not ObjZav[p].ObjConstB[(j-1)*3+4] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,478);
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
except
  reportf('Ошибка [Marshrut.CheckOtpravlVP]');
  result := false;
end;
end;

// проверить ограждение пути через Вз стрелки при проверке враждебностей сигнальной струны
function SignCircOgrad(ptr : SmallInt; Group : Byte) : Boolean;
  var i,o,p : integer;
begin
try
  result := true;
  for i := 1 to 10 do
    if ObjZav[Ptr].ObjConstI[i] > 0 then
    begin
      case ObjZav[ObjZav[Ptr].ObjConstI[i]].TypeObj of
        6 : begin // Ограждение пути
          for p := 14 to 17 do
          begin
            if ObjZav[ObjZav[Ptr].ObjConstI[i]].ObjConstI[p] = Ptr then
            begin
              o := ObjZav[Ptr].ObjConstI[i];
              if ObjZav[o].bParam[2] then
              begin // Установлено ограждение пути
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
                begin // Стрелка нужна в плюсе
                  if not ObjZav[o].ObjConstB[p*2-27] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end else
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                begin // Стрелка нужна в минусе
                  if not ObjZav[o].ObjConstB[p*2-26] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,145, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,145);
                    result := false;
                  end;
                end;
              end;
            end;
          end;
        end; //6
      end; //case
  end;
except
  reportf('Ошибка [Marshrut.SignCircOgrad]');
  result := false;
end;
end;

// проверить установку маршрута отправления с пути с примыкающей стрелкой через хвост стрелки при проверке враждебностей сигнальной струны
function SignCircOtpravlVP(ptr : SmallInt; Group : Byte) : Boolean;
  var i,j,o,p : integer;
begin
try
  result := true;
  for i := 14 to 19 do
  begin
    p := ObjZav[ObjZav[Ptr].BaseObject].ObjConstI[i];
    if p > 0 then
    begin
      case ObjZav[p].TypeObj of
        41 : begin // Контроль поездного маршрута отправления с пути
          if ObjZav[p].bParam[20] then
          begin
            for j := 1 to 4 do
            begin
              o := ObjZav[p].ObjConstI[j];
              if o = ptr then
              begin // проверить требуемое положение стрелки для обоих маршрутов
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[1] then
                begin // Стрелка нужна в плюсе
                  if not ObjZav[p].ObjConstB[(j-1)*3+3] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,478);
                    result := false;
                  end;
                end else
                if ObjZav[ObjZav[Ptr].BaseObject].bParam[2] then
                begin // Стрелка нужна в минусе
                  if not ObjZav[p].ObjConstB[(j-1)*3+4] then
                  begin
                    inc(MarhTracert[Group].MsgCount);
                    MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,478, ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(Group,ObjZav[o].BaseObject,478);
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
except
  reportf('Ошибка [Marshrut.SignCircOtpravlVP]');
  result := false;
end;
end;

//
// Проверка негабаритности
function NegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
  var i,o,p : integer;
begin
try
  result := true;
  // Искать негабаритность через стык и отведенное положение стрелок
  if pk then
  begin // стрелка в плюсе
    if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or // негабаритный стык
       (ObjZav[Ptr].ObjConstB[8]) then                // или проверка отводящего положения стрелок
    begin //по минусовому примыканию
      o := ObjZav[Ptr].Neighbour[3].Obj; p := ObjZav[Ptr].Neighbour[3].Pin; i := 100;
      while i > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 : begin // стрелка
            case p of
              2 : begin // Вход по плюсу
                if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
              end;
              3 : begin // Вход по минусу
                if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
              end;
            else
              ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
            end;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
          3,4 : begin // участок,путь
            if not ObjZav[o].bParam[1] then // занятость путевого датчика
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,146, ObjZav[o].Liter); InsMsg(Group,o,146);
              result := false;
            end;
            break;
          end;
        else
          if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
          else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end else
  begin  // стрелка в минусе
    if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or // негабаритный стык
       (ObjZav[Ptr].ObjConstB[7]) then                // или проверка отводящего положения стрелок
    begin //по плюсовому примыканию
      o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin; i := 100;
      while i > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 : begin // стрелка
            case p of
              2 : begin // Вход по плюсу
                if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
              end;
              3 : begin // Вход по минусу
                if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
              end;
            else
              ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
            end;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
          3,4 : begin // участок,путь
            if not ObjZav[o].bParam[1] then // занятость путевого датчика
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,146, ObjZav[o].Liter); InsMsg(Group,o,146);
              result := false;
            end;
            break;
          end;
        else
          if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
          else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end;
except
  reportf('Ошибка [Marshrut.NegStrelki]');
  result := false;
end;
end;

//
// Проверка негабаритности для сигнальной струны
function SigCircNegStrelki(ptr : SmallInt; pk : Boolean; Group : Byte) : Boolean;
  var i,o,p : integer;
begin
try
  result := true;
  // Искать негабаритность через стык и отведенное положение стрелок
  if pk then
  begin // стрелка в плюсе
    if (ObjZav[Ptr].Neighbour[3].TypeJmp = LnkNeg) or // негабаритный стык
       (ObjZav[Ptr].ObjConstB[8]) then                // или проверка отводящего положения стрелок
    begin //по минусовому примыканию
      o := ObjZav[Ptr].Neighbour[3].Obj; p := ObjZav[Ptr].Neighbour[3].Pin; i := 100;
      while i > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 : begin // стрелка
            case p of
              2 : begin // Вход по плюсу
                if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
              end;
              3 : begin // Вход по минусу
                if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
              end;
            else
              ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
            end;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
          3,4 : begin // участок,путь
            if not ObjZav[o].bParam[1] then // занятость путевого датчика
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,146, ObjZav[o].Liter); InsMsg(Group,o,146);
              result := false;
            end;
            break;
          end;
        else
          if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
          else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end else
  begin // стрелка в минусе
    if (ObjZav[Ptr].Neighbour[2].TypeJmp = LnkNeg) or // негабаритный стык
       (ObjZav[Ptr].ObjConstB[7]) then                // или проверка отводящего положения стрелок
    begin //по плюсовому примыканию
      o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin; i := 100;
      while i > 0 do
      begin
        case ObjZav[o].TypeObj of
          2 : begin // стрелка
            case p of
              2 : begin // Вход по плюсу
                if ObjZav[o].bParam[2] then break; // стрелка в отводе по минусу
              end;
              3 : begin // Вход по минусу
                if ObjZav[o].bParam[1] then break; // стрелка в отводе по плюсу
              end;
            else
              ObjZav[Ptr].bParam[3] := false; break; // ошибка в базе данных
            end;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
          3,4 : begin // участок,путь
            if not ObjZav[o].bParam[1] then // занятость путевого датчика
            begin
              inc(MarhTracert[Group].MsgCount);
              MarhTracert[Group].Msg[MarhTracert[Group].MsgCount] := GetShortMsg(1,146, ObjZav[o].Liter); InsMsg(Group,o,146);
              result := false;
            end;
            break;
          end;
        else
          if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
          else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
        end;
        if (o = 0) or (p < 1) then break;
        dec(i);
      end;
    end;
  end;
except
  reportf('Ошибка [Marshrut.SigCircNegStrelki]');
  result := false;
end;
end;

//------------------------------------------------------------------------------
// Проверка условий передачи на маневровый район
function VytajkaRM(ptr : SmallInt) : Boolean;
  var i,j,g,o,p,q : Integer; b,opi : boolean;
begin
try
  result := false;
  MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
  if ptr < 1 then exit;

  // подсветить пути
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4  : ObjZav[o].bParam[8] := false;
          43 : begin // объект оПИ
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // путь разрешен для маневров
              ObjZav[ObjZav[o].UpdateObject].bParam[8] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить секции
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : ObjZav[o].bParam[8] := false;
          44 : begin // объект СМИ
            if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] then ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] := false;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false;
              ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := true;
            end;
          44 : begin // СМИ
            if ObjZav[o].bParam[2] and
               ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] and
               not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] then
            begin
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false;
              ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 :
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false;
              ObjZav[o].bParam[12] := true; ObjZav[o].bParam[13] := false;
            end;
          44 : begin // СМИ
            if ObjZav[o].bParam[1] and
               ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] and
               not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] then
            begin
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false;
              ObjZav[ObjZav[o].UpdateObject].bParam[12] := true; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            end;
          end;
        end;
      end;
    end;
  end;
  // подсветить ходовые стрелки на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if ObjZav[ObjZav[o].UpdateObject].bParam[7] and not ObjZav[ObjZav[o].UpdateObject].bParam[8] then
            begin
              ObjZav[o].bParam[12] := true; ObjZav[o].bParam[13] := true;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить объекты СМИ для данной колонки
  for i := 1 to WorkMode.LimitObjZav do
  begin
    if (ObjZav[i].TypeObj = 44) and (ObjZav[i].BaseObject = ptr) then
    begin
      if ObjZav[ObjZav[ObjZav[i].UpdateObject].UpdateObject].bParam[7] and
         not ObjZav[ObjZav[ObjZav[i].UpdateObject].UpdateObject].bParam[8] then
      begin
        ObjZav[ObjZav[i].UpdateObject].bParam[12] := ObjZav[i].bParam[1];
        ObjZav[ObjZav[i].UpdateObject].bParam[13] := ObjZav[i].bParam[2];
      end;
    end;
  end;

  // проверить условия на колонке
  if ObjZav[ptr].bParam[6] then
  begin // ЭГС
    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,105,ObjZav[ptr].Liter); InsMsg(1,ptr,105); exit;
  end;
  if ObjZav[ptr].bParam[1] then
  begin // РМ
    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ptr].Liter); InsMsg(1,ptr,258); exit;
  end;
  if ObjZav[Ptr].bParam[4] then
  begin // если первичная передача на маневры - проверить:
  // проверить восприятие маневров на колонке
    if not ObjZav[Ptr].bParam[5] then
    begin
      if ObjZav[ptr].bParam[3] then
      begin // маневры еще не замкнуты
        inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,445,ObjZav[Ptr].Liter); InsWar(1,ptr,445);
      end;
    end;
  // исключения путей из маневров (разрешение приема или ограждения)
    b := false; opi := false;
    for i := 1 to WorkMode.LimitObjZav do
    begin
      if (ObjZav[i].TypeObj = 48) and (ObjZav[i].BaseObject = ptr) then
      begin
        if not ObjZav[i].ObjConstB[3] then
        begin // контролировать возможность выхода на пути приема из маневрового района
          opi := true;
          if ObjZav[i].bParam[1] then b := true;
        end;
      end;
    end;
    if opi and not b then
    begin // все пути исключены из маневрового района
      inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,427,ObjZav[Ptr].Liter); InsMsg(1,ptr,427); exit;
    end;
  end;

  // проверить дополнительные условия передачи на маневры
  g := ObjZav[ptr].ObjConstI[17];
  if g > 0 then
  begin
    for i := 1 to 5 do
    begin // проверка дополнительных условий по списку
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4 : begin // путь
            if not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3] then
            begin // установлен маршрут на путь (исключаются любые маршруты на путь)
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,341,ObjZav[o].Liter); InsMsg(1,o,341); exit;
            end;
          end;

          6 : begin // ограждение пути
            if ObjZav[o].bParam[2] then
            begin // ограждение установлено
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,145,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,145); exit;
            end;
          end;

          23 : begin // увязка с маневровым районом
            if ObjZav[o].bParam[1] then
            begin // есть УМП
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,256,ObjZav[o].Liter); InsMsg(1,o,256); exit;
            end else
            if ObjZav[o].bParam[2] then
            begin // есть УМО
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,257,ObjZav[o].Liter); InsMsg(1,o,257); exit;
            end;
          end;

          25 : begin // маневровая колонка
            if not ObjZav[o].bParam[1] then
            begin // нет разрешения маневров на проверяемой колонке
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,426,ObjZav[o].Liter); InsMsg(1,o,426); exit;
            end;
          end;

          33 : begin // дискретный датчик
            if ObjZav[o].bParam[1] then
            begin
              inc(MarhTracert[1].MsgCount);
              if ObjZav[o].ObjConstB[1] then
              begin
                MarhTracert[1].Msg[MarhTracert[1].MsgCount] := MsgList[ObjZav[o].ObjConstI[3]]; InsMsg(1,o,3);
              end else
              begin
                MarhTracert[1].Msg[MarhTracert[1].MsgCount] := MsgList[ObjZav[o].ObjConstI[2]]; InsMsg(1,o,2);
              end;
              exit;
            end;
          end;

          45 : begin // зона оповещения
            if ObjZav[o].bParam[1] then
            begin // Включено оповещение в зоне местного управления
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,444,ObjZav[o].Liter); InsMsg(1,o,444); exit;
            end;
          end;

        end;
      end;
    end;
  end;

  // проверить секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            if not ObjZav[o].bParam[2] then
            begin // Участок замкнут
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,82,ObjZav[o].Liter); InsMsg(1,o,82); exit;
            end;
            if not ObjZav[o].bParam[5] then
            begin // Участок на маневрах
              for p := 20 to 24 do // найти колонку с замкнутыми маневрами
                if (ObjZav[o].ObjConstI[p] > 0) and (ObjZav[o].ObjConstI[p] <> ptr) then
                begin
                  if not ObjZav[ObjZav[o].ObjConstI[p]].bParam[3] then
                  begin
                    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ObjZav[o].ObjConstI[p]].Liter); InsMsg(1,ObjZav[o].ObjConstI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZav[o].bParam[7] then
            begin // Участок замкнут на сервере
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,110,ObjZav[o].Liter); InsMsg(1,o,110); exit;
            end;
          end;
          44 : begin // СМИ
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[2] then
            begin // Участок замкнут
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,82,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].UpdateObject,82); exit;
            end;
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[5] then
            begin // Участок на маневрах
              for p := 20 to 24 do // найти колонку с замкнутыми маневрами
                if (ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p] > 0) and (ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p] <> ptr) then
                begin
                  if not ObjZav[ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p]].bParam[3] then
                  begin
                    inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,258,ObjZav[ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p]].Liter); InsMsg(1,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].ObjConstI[p],258); exit;
                  end;
                end;
            end;
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[7] then
            begin // Участок замкнут на сервере
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,110,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].UpdateObject,110); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  // проверить светофоры вытяжки
  g := ObjZav[ptr].ObjConstI[20];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] or ObjZav[o].bParam[3] or ObjZav[o].bParam[4] then
        begin // сигнал открыт
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,114,ObjZav[o].Liter); InsMsg(1,o,114); exit;
        end;
      end;
    end;
  end;

  // проверить наличие контроля охранных стрелок в минусе
  g := ObjZav[ptr].ObjConstI[21];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
        begin // стрелка не имеет контроля
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,81); exit;
        end;
      end;
    end;
  end;
  // проверить наличие контроля охранных стрелок в плюсе
  g := ObjZav[ptr].ObjConstI[22];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
        begin // стрелка не имеет контроля
          inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,81); exit;
        end;
      end;
    end;
  end;
  // проверить наличие контроля ходовых стрелок в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить наличие контроля ходовых стрелок в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and not ObjZav[ObjZav[o].UpdateObject].bParam[2] then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить наличие контроля стрелок на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            if not (ObjZav[o].bParam[1] xor ObjZav[o].bParam[2]) then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,81); exit;
            end;
          end;
          44 : begin
            if not (ObjZav[ObjZav[o].UpdateObject].bParam[1] xor ObjZav[ObjZav[o].UpdateObject].bParam[2]) then
            begin // стрелка не имеет контроля
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,81,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,81); exit;
            end;
          end;
        end;
      end;
    end;
  end;
  // проверить пути района
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4 : begin // путь
            if not ObjZav[o].bParam[4] and (not ObjZav[o].bParam[2] or not ObjZav[o].bParam[3]) then
            begin // установлен поездной маршрут на путь
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,341,ObjZav[o].Liter); InsMsg(1,o,341); exit;
            end;
          end;
        end;
      end;
    end;
  end;

  if WorkMode.RazdUpr then
  begin // в режиме раздельного управления проверить положение ходовых и охранных стрелок вытяжки

  // проверить объекты оПИ
    g := ObjZav[ptr].ObjConstI[15];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        q := ObjZav[g].ObjConstI[i];
        if q > 0 then
        begin
          case ObjZav[q].TypeObj of
            43 : begin // объект оПИ
              if ObjZav[q].bParam[1] then
              begin // проверить отводящее положение стрелок
              // протрассировать выезд на пути из маневрового района
                opi := false;
                if ObjZav[q].ObjConstB[1] then p := 2 else p := 1;
                o := ObjZav[q].Neighbour[p].Obj; p := ObjZav[q].Neighbour[p].Pin; j := 50;
                while j > 0 do
                begin
                  case ObjZav[o].TypeObj of
                    2 : begin // стрелка
                      case p of
                        2 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[11] then
                          begin // есть возможность отвода стрелки
                            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then break;
                            opi := true; break;
                          end;
                        end;
                        3 : begin
                          if ObjZav[ObjZav[o].BaseObject].bParam[10] then
                          begin // есть возможность отвода стрелки
                            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then break;
                            opi := true; break;
                          end;
                        end;
                      end;
                      p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
                    end;
                    48 : begin // РПо
                      opi := true; break;
                    end;
                  else
                    if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
                    else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
                  end;
                  if (o = 0) or (p < 1) then break;
                  dec(j);
                end;

              // стрелки не установлены в отвод для пути, исключенного из маневров
                if opi then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,425,ObjZav[ObjZav[q].UpdateObject].Liter); InsMsg(1,ObjZav[q].UpdateObject,425); exit;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить ходовые стрелки в минусе
    g := ObjZav[ptr].ObjConstI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
              begin // стрелка не имеет контроля в -
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,267); exit;
              end;
              if not SigCircNegStrelki(o,false,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZav[o].UpdateObject,false,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить ходовые стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
              begin // стрелка не имеет контроля в +
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,268); exit;
              end;
              if not SigCircNegStrelki(o,true,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not SigCircNegStrelki(ObjZav[o].UpdateObject,true,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;
  // проверить охранные стрелки в минусе
    g := ObjZav[ptr].ObjConstI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в -
            inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,267); exit;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;
  // проверить охранные стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в +
            inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,268); exit;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;

  end else
  if WorkMode.MarhUpr then
  begin // в режиме маршрутного управления проверить возможность трассировки с проверкой маневровых враждебностей

    // проверить ходовые стрелки в минусе
    g := ObjZav[ptr].ObjConstI[23];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if not ObjZav[o].bParam[2] and not ObjZav[o].bParam[12] and ObjZav[o].bParam[13] then
              begin // стрелка не имеет контроля минусового положения
                if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[o].BaseObject].bParam[22] or
                   ObjZav[ObjZav[o].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,267); exit;
                end;
                if ObjZav[ObjZav[o].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,80); exit;
                end;
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // выключена из управления
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,159,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,159); exit;
                end;
              end;
              if not NegStrelki(o,false,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZav[ObjZav[o].UpdateObject].bParam[2] and
                 not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[12] and
                 ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[13] then
              begin // стрелка не имеет контроля минусового положения
                if not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[22] or
                   ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,267); exit;
                end;
                if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,80); exit;
                end;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[18] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[18] then
              begin // выключена из управления
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,151); exit;
              end;
              if not NegStrelki(ObjZav[o].UpdateObject,false,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // проверить ходовые стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[24];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          case ObjZav[o].TypeObj of
            2 : begin
              if ObjZav[o].bParam[12] and ObjZav[o].bParam[13] then
              begin // есть езда по + и - сделано для Орска стрелка 202
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // выключена из управления
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,151); exit;
                end;
              end else
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[12] and not ObjZav[o].bParam[13] then
              begin // стрелка не имеет контроля в плюсе
                if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[o].BaseObject].bParam[22] or
                   ObjZav[ObjZav[o].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,268); exit;
                end;
                if ObjZav[ObjZav[o].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,80); exit;
                end;
                if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
                begin // выключена из управления
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,121,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,121); exit;
                end;
              end;
              if not NegStrelki(o,true,1) then exit;
              if ObjZav[o].bParam[16] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[16]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[o].Liter); InsMsg(1,o,119); exit;
              end;
              if ObjZav[o].bParam[17] or
                 (ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[33]) or
                 (not ObjZav[o].ObjConstB[6] and ObjZav[ObjZav[o].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[o].Liter); InsMsg(1,o,453); exit;
              end;
              if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
              end;
            end;
            44 : begin
              if not ObjZav[ObjZav[o].UpdateObject].bParam[1] and
                 ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[12] and
                 not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[13] then
              begin // стрелка не имеет контроля в плюсе
                if not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[21] or
                   not ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[22] or
                   ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[24] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,268); exit;
                end;
                if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[4] then
                begin
                  inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,80); exit;
                end;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[18] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[18] then
              begin // выключена из управления
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,151,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter); InsMsg(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,151); exit;
              end;
              if not NegStrelki(ObjZav[o].UpdateObject,true,1) then exit;
              if ObjZav[ObjZav[o].UpdateObject].bParam[16] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[16]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[17]) then
              begin // стрелка закрыта для движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,119,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,119); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[17] or
                 (ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[33]) or
                 (not ObjZav[ObjZav[o].UpdateObject].ObjConstB[6] and ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[34]) then
              begin // стрелка закрыта для противошерстного движения
                inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,453,ObjZav[ObjZav[o].UpdateObject].Liter); InsMsg(1,ObjZav[o].UpdateObject,453); exit;
              end;
              if ObjZav[ObjZav[o].UpdateObject].bParam[15] or ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[15] then
              begin // стрелка на макете
                inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[ObjZav[o].UpdateObject].BaseObject,120+$5000);
              end;
            end;
          end;
        end;
      end;
    end;

    // проверить охранные стрелки в минусе
    g := ObjZav[ptr].ObjConstI[21];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[2] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в -
            if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
               not ObjZav[ObjZav[o].BaseObject].bParam[22] or
               ObjZav[ObjZav[o].BaseObject].bParam[24] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,267,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,267); exit;
            end;
            if ObjZav[ObjZav[o].BaseObject].bParam[4] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,80); exit;
            end;
            if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
            begin // выключена из управления
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,235,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,235); exit;
            end;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;

    // проверить охранные стрелки в плюсе
    g := ObjZav[ptr].ObjConstI[22];
    if g > 0 then
    begin
      for i := 1 to 24 do
      begin
        o := ObjZav[g].ObjConstI[i];
        if o > 0 then
        begin
          if not ObjZav[o].bParam[1] or (ObjZav[o].bParam[1] and ObjZav[o].bParam[2]) then
          begin // стрелка не имеет контроля в +
            if not ObjZav[ObjZav[o].BaseObject].bParam[21] or
               not ObjZav[ObjZav[o].BaseObject].bParam[22] or
               ObjZav[ObjZav[o].BaseObject].bParam[24] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,268,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,268); exit;
            end;
            if ObjZav[ObjZav[o].BaseObject].bParam[4] then
            begin
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,80,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,8); exit;
            end;
            if ObjZav[o].bParam[18] or ObjZav[ObjZav[o].BaseObject].bParam[18] then
            begin // выключена из управления
              inc(MarhTracert[1].MsgCount); MarhTracert[1].Msg[MarhTracert[1].MsgCount] := GetShortMsg(1,236,ObjZav[ObjZav[o].BaseObject].Liter); InsMsg(1,ObjZav[o].BaseObject,236); exit;
            end;
          end;
          if ObjZav[o].bParam[15] or ObjZav[ObjZav[o].BaseObject].bParam[15] then
          begin // стрелка на макете
            inc(MarhTracert[1].WarCount); MarhTracert[1].Warning[MarhTracert[1].WarCount] := GetShortMsg(1,120,ObjZav[ObjZav[o].BaseObject].Liter)+ '. Продолжать?'; InsWar(1,ObjZav[o].BaseObject,120+$5000);
          end;
        end;
      end;
    end;
  end;

  if MarhTracert[1].MsgCount > 0 then
  begin
    ResetTrace; exit;
  end;

  ObjZav[ptr].bParam[8] := true; // признак выдачи команды РМ
  result := true;
except
  reportf('Ошибка [Marshrut.VytajkaRM]');
  result := false;
end;
end;


//------------------------------------------------------------------------------
// Программное замыкание маневрового района
function VytajkaZM(ptr : SmallInt) : Boolean;
  var i,g,o : Integer;
begin
try
  result := false;
  if ptr < 1 then exit;

  // замкнуть колонку
  ObjZav[ptr].bParam[14] := true;

  // замыкание секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            ObjZav[o].bParam[14] := true;
          end;
          44 : begin
            if ObjZav[o].bParam[1] or ObjZav[o].bParam[2] then
              ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // погасить пути
  g := ObjZav[ptr].ObjConstI[15];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          4  : ObjZav[o].bParam[8] := true;
          43 : ObjZav[ObjZav[o].UpdateObject].bParam[8] := true;
        end;
      end;
    end;
  end;

  // замыкание ходовые стрелки в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[13] := false; ObjZav[o].bParam[7]  := true; ObjZav[o].bParam[14] := true;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[11] then
              ObjZav[ObjZav[o].UpdateObject].bParam[7] := true;
            ObjZav[ObjZav[o].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // замыкание ходовые стрелки в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := true; ObjZav[o].bParam[14] := true;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false;
            if ObjZav[ObjZav[ObjZav[o].UpdateObject].BaseObject].bParam[10] then
              ObjZav[ObjZav[o].UpdateObject].bParam[6] := true;
            ObjZav[ObjZav[o].UpdateObject].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

  // замыкание ходовых стрелок на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := true;
            ObjZav[o].bParam[13] := false; ObjZav[o].bParam[7] := true;
            ObjZav[o].bParam[14] := true;
          end;
        end;
      end;
    end;
  end;

except
  reportf('Ошибка [Marshrut.VytajkaZM]');
  result := false;
end;
end;


//------------------------------------------------------------------------------
// Программное размыкание маневрового района
function VytajkaOZM(ptr : SmallInt) : Boolean;
  var i,g,o : Integer;
begin
try
  result := false;
  if ptr < 1 then exit;

  // разомкнуть колонку
  ObjZav[ptr].bParam[14] := false;
  ObjZav[ptr].bParam[8]  := false; // сбросить признак выдачи команды РМ

  // разомкнуть секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            ObjZav[o].bParam[8] := true; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[8] := true; ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовые стрелки в минусе
  g := ObjZav[ptr].ObjConstI[23];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := false; ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false; ObjZav[ObjZav[o].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовые стрелки в плюсе
  g := ObjZav[ptr].ObjConstI[24];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[13] := false; ObjZav[o].bParam[6] := false; ObjZav[o].bParam[7] := false; ObjZav[o].bParam[14] := false;
          end;
          44 : begin
            ObjZav[ObjZav[o].UpdateObject].bParam[12] := false; ObjZav[ObjZav[o].UpdateObject].bParam[13] := false;
            ObjZav[ObjZav[o].UpdateObject].bParam[6] := false; ObjZav[ObjZav[o].UpdateObject].bParam[7] := false; ObjZav[ObjZav[o].UpdateObject].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

  // разомкнуть ходовых стрелок на управлении
  g := ObjZav[ptr].ObjConstI[16];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          2 : begin
            ObjZav[o].bParam[12] := false; ObjZav[o].bParam[6] := false;
            ObjZav[o].bParam[13] := false; ObjZav[o].bParam[7] := false;
            ObjZav[o].bParam[14] := false;
          end;
        end;
      end;
    end;
  end;

except
  reportf('Ошибка [Marshrut.VytajkaOZM]');
  result := false;
end;
end;


//------------------------------------------------------------------------------
// Проверка условий отмены маневров
function VytajkaCOT(ptr : SmallInt) : string;
  var i,g,o : Integer;
begin
try
  result := '';
  MarhTracert[1].MsgCount := 0; MarhTracert[1].WarCount := 0;
  if ptr < 1 then exit;
  // проверить условия на колонке
  if ObjZav[ptr].bParam[2] then
  begin // оТ
    result := GetShortMsg(1,259,ObjZav[ptr].Liter); exit;
  end;

  // проверить секции вытяжки
  g := ObjZav[ptr].ObjConstI[18];
  if g > 0 then
  begin
    for i := 1 to 24 do
    begin
      o := ObjZav[g].ObjConstI[i];
      if o > 0 then
      begin
        case ObjZav[o].TypeObj of
          3 : begin
            if not ObjZav[o].bParam[1] then
            begin
              result := GetShortMsg(1,83,ObjZav[o].Liter); exit;
            end;
          end;
          44 : begin
            if not ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].bParam[1] then
            begin
              result := GetShortMsg(1,83,ObjZav[ObjZav[ObjZav[o].UpdateObject].UpdateObject].Liter); exit;
            end;
          end;
        end;
      end;
    end;
  end;
except
  reportf('Ошибка [Marshrut.VytajkaCOT]'); result := '';
end;
end;

//------------------------------------------------------------------------------
// Получить индекс СП, имеющего враждебность для маршрута
function GetStateSP(mode : Byte; Obj : SmallInt) : SmallInt;
var sp1,sp2 : integer;
begin
try
  sp1 := ObjZav[ObjZav[ObjZav[Obj].BaseObject].ObjConstI[8]].UpdateObject;
  sp2 := ObjZav[ObjZav[ObjZav[Obj].BaseObject].ObjConstI[9]].UpdateObject;
  case mode of
    1 : begin // замыкание СП
      if (sp1 > 0) and not ObjZav[sp1].bParam[2] then result := sp1 else
      if (sp2 > 0) and not ObjZav[sp2].bParam[2] then result := sp2 else
        result := ObjZav[Obj].UpdateObject;
    end;
    2 : begin // занятость СП
      if (sp1 > 0) and not ObjZav[sp1].bParam[1] then result := sp1 else
      if (sp2 > 0) and not ObjZav[sp2].bParam[1] then result := sp2 else
        result := ObjZav[Obj].UpdateObject;
    end;
  else
    result := Obj;
  end;
except
  reportf('Ошибка [Marshrut.GetStateSP]'); result := Obj;
end;
end;

//------------------------------------------------------------------------------
// установить признак ГВ на светофоры маршрута надвига
procedure SetNadvigParam(Ptr : SmallInt);
  var max,o,p,nadv : integer;
begin
try
  // найти трассу маршрута надвига и определить горку
  max := 1000; nadv := 0;
  o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin;
  while max > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 : begin // стрелка
        case p of
          2 : begin
            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
          end;
          3 : begin
            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
            begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
          end;
        else
          if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
          begin
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin
            p := ObjZav[o].Neighbour[3].Pin; o := ObjZav[o].Neighbour[3].Obj;
          end else
            break;
        end;
      end;
      32 : begin // надвиг
        nadv := o; break;
      end;
    else
      if p = 1 then
      begin
        p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
      end else
      begin
        p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
      end;
    end;
    dec(max);
  end;
  if nadv > 0 then
  begin // раскидать признак ГВ по светофорам маршрута
    ObjZav[Ptr].iParam[2] := nadv;
    max := 1000;
    o := ObjZav[Ptr].Neighbour[2].Obj; p := ObjZav[Ptr].Neighbour[2].Pin;
    while max > 0 do
    begin
      case ObjZav[o].TypeObj of
        2 : begin // стрелка
          case p of
            2 : begin
              if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
              begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
            end;
            3 : begin
              if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
              begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end else break;
            end;
          else
            if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
            begin
              p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
            end else
            if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
            begin
              p := ObjZav[o].Neighbour[3].Pin; o := ObjZav[o].Neighbour[3].Obj;
            end else
              break;
          end;
        end;
        32 : begin // надвиг
          break;
        end;

        3 : begin // СП,УП
          ObjZav[o].iParam[3] := nadv; // пометить признаком ГВ
          if p = 1 then
          begin
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
        5 : begin // светофор
          if p = 1 then
          begin // попутный светофор пометить признаком ГВ
            ObjZav[o].iParam[2] := nadv;
            p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
          end else
          begin // встречный светофор пометить признаком УН
            ObjZav[o].iParam[3] := nadv;
            p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
          end;
        end;
      else
        if p = 1 then
        begin
          p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;
      dec(max);
    end;
  end;
except
  reportf('Ошибка [Marshrut.SetNadvigParam]');
end;
end;

//------------------------------------------------------------------------------
// Установить / снять автодействие сигналов
function AutoMarsh(Ptr : SmallInt; mode : Boolean) : Boolean;
  var i,j,o,p,g : integer; vkl : boolean; jmp : TOZNeighbour;
begin
try
  vkl := true;
  if mode then
  begin // включить автодействие
    for i := 10 to 12 do
    begin
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin // попытаться установить автодействие всех сигналов группы
        if not ObjZav[ObjZav[o].BaseObject].bParam[4] then
        begin // не открыт светофор
          result := false; ShowShortMsg(429,LastX,LastY,ObjZav[ObjZav[o].BaseObject].Liter); InsArcNewMsg(ObjZav[o].BaseObject,429+$4000); exit;
        end;
        for j := 1 to 10 do
        begin // проверить положение стрелок
          p := ObjZav[o].ObjConstI[j];
          if p > 0 then
          begin
            if not ObjZav[p].bParam[1] then
            begin // нет контроля плюсового положения
              result := false; ShowShortMsg(268,LastX,LastY,ObjZav[ObjZav[p].BaseObject].Liter); InsArcNewMsg(ObjZav[o].BaseObject,268+$4000); exit;
            end;
            if ObjZav[ObjZav[p].BaseObject].bParam[15] or ObjZav[ObjZav[p].BaseObject].bParam[19] then
            begin // стрелка на макете
              result := false; ShowShortMsg(120,LastX,LastY,ObjZav[ObjZav[p].BaseObject].Liter); InsArcNewMsg(ObjZav[o].BaseObject,120+$4000); exit;
            end;
          end;
        end;
      end;
    end;
  // проверить враждебности для автодействия
    for i := 10 to 12 do
    begin
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin
        g := ObjZav[o].ObjConstI[25];
        MarhTracert[g].Rod := MarshP;
        MarhTracert[g].Finish := false;
        MarhTracert[g].WarCount := 0; MarhTracert[g].MsgCount := 0;
        MarhTracert[g].ObjStart := ObjZav[o].BaseObject;
        MarhTracert[g].Counter := 0;
        j := 1000;
        jmp := ObjZav[ObjZav[o].BaseObject].Neighbour[2];
        MarhTracert[g].Level := tlSignalCirc;
        MarhTracert[g].FindTail := true;
        while j > 0 do
        begin
          case StepTrace(jmp,MarhTracert[g].Level,MarhTracert[g].Rod,g) of
            trStop, trEnd, trEndTrace : begin
              break;
            end;
          end;
          dec(j);
        end;
        if j < 1 then vkl := false; // трасса маршрута разрушена
        if MarhTracert[g].MsgCount > 0 then vkl := false;
      end;
    end;

    if not vkl then
    begin // отказ для установки на автодействие
      InsArcNewMsg(Ptr,476+$4000);
      ShowShortMsg(476,LastX,LastY,ObjZav[Ptr].Liter); SingleBeep4 := true;
      result := false; exit;
    end;
  // расставить признаки автодействия
    for i := 10 to 12 do
    begin
      o := ObjZav[Ptr].ObjConstI[i];
      if o > 0 then
      begin
        ObjZav[o].bParam[1] := vkl;
        AutoMarshON(ObjZav[Ptr].ObjConstI[i]);
      end;
    end;
    ObjZav[Ptr].bParam[1] := vkl;
    result := vkl;
  end else
  begin // отключить автодействие
    for i := 10 to 12 do
      if ObjZav[Ptr].ObjConstI[i] > 0 then
      begin // сбросить автодействие всех сигналов группы
        ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] := false;
        AutoMarshOFF(ObjZav[Ptr].ObjConstI[i]);
      end;
    ObjZav[Ptr].bParam[1] := false;
    result := true;
  end;
except
  reportf('Ошибка [Marshrut.AutoMarsh]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Сброс автодействия при выдаче команды отмены поездного маршрута
function AutoMarshReset(Ptr : SmallInt) : Boolean;
  var i : integer;
begin
try
  if (Ptr > 0) and (ObjZav[Ptr].TypeObj = 47) then
  begin
    if ObjZav[Ptr].bParam[1] then
    begin
      for i := 10 to 12 do
      begin
        if ObjZav[Ptr].ObjConstI[i] > 0 then
        begin // сбросить автодействие всех сигналов группы
          ObjZav[ObjZav[Ptr].ObjConstI[i]].bParam[1] := false;
          AutoMarshOFF(ObjZav[Ptr].ObjConstI[i]);
        end;
      end;
      ObjZav[Ptr].bParam[1] := false;
      InsArcNewMsg(Ptr,422+$4000);
      AddFixMessage(GetShortMsg(1,422, ObjZav[Ptr].Liter),4,3);
    end;
    result := true;
  end else
    result := false;
except
  reportf('Ошибка [Marshrut.AutoMarshReset]'); result := false;
end;
end;

//------------------------------------------------------------------------------
// Разнести признаки автодействия по объектам трассы маршрута автодействия
function AutoMarshON(Ptr : SmallInt) : Boolean;
  var o,p,j : integer;
begin
  result := false;
  if ObjZav[Ptr].BaseObject = 0 then exit;
  j := 100;
  o := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Obj;
  p := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Pin;
  ObjZav[ObjZav[Ptr].BaseObject].bParam[33] := true;
  while j > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 : begin // стрелка
  // пока считаем что все стрелки в автодействии стоят по плюсу
        ObjZav[o].bParam[33] := true;
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      3 : begin // секция
        ObjZav[o].bParam[33] := true;
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      4 : begin // путь
        ObjZav[o].bParam[33] := true;
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      5 : begin // светофор
        if p = 1 then
        begin
          if ObjZav[o].ObjConstB[5] then break;
          ObjZav[o].bParam[33] := true;
          p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          if ObjZav[o].ObjConstB[6] then break;
          ObjZav[o].bParam[33] := true;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      15 : begin // АБ
        ObjZav[o].bParam[33] := true; break;
      end;
    else // все остальные
      if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
      else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
    end;
    if o < 1 then break;
    dec(j);
  end;
  result := true;
end;

//------------------------------------------------------------------------------
// Снять признаки автодействия с объектов трассы маршрута автодействия
function AutoMarshOFF(Ptr : SmallInt) : Boolean;
  var o,p,j : integer;
begin
  result := false;
  if ObjZav[Ptr].BaseObject = 0 then exit;
  j := 100;
  o := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Obj;
  p := ObjZav[ObjZav[Ptr].BaseObject].Neighbour[2].Pin;
  ObjZav[ObjZav[Ptr].BaseObject].bParam[33] := false;
  while j > 0 do
  begin
    case ObjZav[o].TypeObj of
      2 : begin // стрелка
  // пока считаем что все стрелки в автодействии стоят по плюсу
        ObjZav[o].bParam[33] := false;
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      3 : begin // секция
        ObjZav[o].bParam[33] := false;
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      4 : begin // путь
        ObjZav[o].bParam[33] := false;
        if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
        else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
      end;

      5 : begin // светофор
        if p = 1 then
        begin
          if ObjZav[o].ObjConstB[5] then break;
          ObjZav[o].bParam[33] := false;
          p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj;
        end else
        begin
          if ObjZav[o].ObjConstB[6] then break;
          ObjZav[o].bParam[33] := false;
          p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj;
        end;
      end;

      15 : begin // АБ
        ObjZav[o].bParam[33] := false; break;
      end;
    else // все остальные
      if p = 1 then begin p := ObjZav[o].Neighbour[2].Pin; o := ObjZav[o].Neighbour[2].Obj; end
      else begin p := ObjZav[o].Neighbour[1].Pin; o := ObjZav[o].Neighbour[1].Obj; end;
    end;
    if o < 1 then break;
    dec(j);
  end;
  result := true;
end;

end.

