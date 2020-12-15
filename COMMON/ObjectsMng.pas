unit ObjectsMng;
{$INCLUDE d:\sapr2012\CfgProject}
{***************************************************
//  Структуры и процедуры интерпритатора САПР
***************************************************}

interface

uses
  Forms,
  Windows,
  Classes,
  Dialogs,
  Graphics,
  SysUtils,
  TypeALL;

// Структура плана станции
type
  TParamPlan = record
    SV        : integer; //-------------------------------- Шаг вертикальной разметки поля
    SH        : integer; //------------------------------ Шаг горизонтальной разметки поля
    OZ        : TPoint;  //------------- Координата точки пересечения осевых линий станции
    LineUp    : integer; //---------------------------- Количество линий выше осевой линии
    LineDown  : integer; //---------------------------- Количество линий ниже осевой линии
    LineLeft  : integer; //--------------------------- Количество линий левее осевой линии
    LineRight : integer; //-------------------------- Количество линий правее осевой линии
    OddSide   : BYTE;    //Признак положения НЧ подходов:0- слева от оси, 1- справа от оси
    DC        : BYTE;    //------------------ Признак наличия на станции ДЦ (1-есть/0-нет)
    SU        : BYTE;    // Признак наличия на станцци сезонного управления (1-есть/0-нет)
    VwObj     : boolean; //------------------- Показывать объекты зависимостей в редакторе
    VwCon     : boolean; //------------------- Показывать соединения объектов зависимостей
    VwLinks   : boolean; //---------------- Показывать ссылки между объектами зависимостей
  end;

const
  BlockH = 30; //--------------------------------------------------- Половина высоты блока
  BlockW = 20; //--------------------------------------------------- Половина ширины блока

var
//========================================================================================
//               Параметры устройств РПЦ-МПЦ в формате САПР
//========================================================================================
pplan      : TParamPlan;//---------------------------------------- Параметры плана станции
selectIDO  : WORD;      //----------------------------- Выбранный тип элемента для вставки
//selectObj  : WORD;    //------------------------------------- Блок зависимостей в фокусе
isMoveObj  : BOOLEAN;   //------------------------------------ Признак перемещения объекта
isExchObj  : Boolean;   //-------------- признак активизации функции "замена типа объекта"
selectPin  : WORD;      //------------------------------------- Точка подключения в фокусе
selectCon  : WORD;      //------------------------------------------- Соединитель в фокусе
isfirstPin : BOOLEAN;   //------------------------ Если первая точка соединения определена
ismoveCon  : BOOLEAN;   //-------------------------------- Признак перемещения соединителя
CurPos     : TPoint;    //---------------------------------------- Текущая позиция курсора
DnPos      : TPoint;    //----------------------------- Позиция нажатия левой кнопки мышки
UpPos      : TPoint;    //-------------------------- Позиция отпускания левой кнопки мышки
CurGrid    : TPoint;    //---------------------------- Текущаая ячейка сетки под курсором.
                        //-----------------------------  Ести CurGrid.X=-9999 - мимо сетки
CheckFill  : Boolean;   //---------------- Проверять заполнение парамтров описания объекта
VwMarh     : Integer;   //--------------------------- Режим просмотра маршрутов на станции
                        //---------------------------- (0- однонитка, 1- строки маршрутов)

function  AskNeedSavePrj : integer; //=========== Запрос на запись несохраненных изменений
function  SetNeedSavePrj : boolean; //========= Установка признака несохраненных изменений
function  GetGridLine(y : integer) : integer; //========== Возвращает номер строки в сетке
function  GetGridCol(x : integer) : integer; //========== Возвращает номер столбца в сетке
function  GetSelectPin(x,y,i : integer): integer;//Возвращает № выбраной точки подключения
function  SetSelectObj : boolean; //----- Возвращает TRUE если помечен объект зависимостей
procedure ClearAllObj; //----------------------------------- Очистить весь список объектов
function  AddNewObj(ind : integer) : integer; //------- Добавить новый объект зависимостей
function  MoveObj(ind : integer) : integer; //---------------- Переместить объект по сетке
function  DeleteObj(ind : integer) : integer; //------------------- Удалить объект из базы
procedure SetObjInspector(i : integer); //----- Установить параметры в инспекторе объектов
function  CheckParam(var p: TObjParams): boolean;//проверить заполнение параметров объекта
procedure ClearAllCon; //--------------------------------- Очистить весь список соединений
function  ConFirst : integer; //---------------------- подключить первую точку соединителя
function  ConSecond : integer; //--------------------- подключить вторую точку соединителя
function  DeleteCon(ind : integer) : integer; //-------------- Удалить соединитель из базы
procedure ClearAllInpInt; //----------------- Очистить список датчиков входных интерфейсов
procedure ClearAllLogic; //--------------------------- Очистить список логических датчиков
procedure ClearAllOutInt; //---------------- Очистить список датчиков выходных интерфейсов
function  ReplaceValues(Key, OldValue, NewValue : string) : integer; // Переименовать все связанные параметры во всех объектах

var

  IsNeedSave : boolean; //---------------------------------- Признак несохраненной новизны

implementation

uses
  Main,
{$IFDEF TABLO}
  PaletteTablo,
  InspectorTablo;
{$ELSE}
  PalettePlan,
  InspectorPlan;
{$ENDIF}



//========================================================================================
function AskNeedSavePrj : integer;
var
  s : string;
begin
  if IsNeedSave then
  begin
    s := 'Не сохранены изменения, внесенные в проект ';
    if FileNamePrj <> '' then  s := s + '['+ FileNamePrj+ ']'
    else  s := s + '[Без имени]';
    s := s + #13 + 'Сохранить изменения?';
    result := Application.MessageBox(pchar(s), 'САПР РПЦ-МПЦ',
                MB_YESNOCANCEL+MB_DEFBUTTON1+MB_ICONQUESTION);
    if result = idNo then IsNeedSave := false;
  end
  else  result := idNo;
end;

//========================================================================================
//--------------------------------------------- Установка признака несохраненных изменений
function SetNeedSavePrj : boolean;
begin
  result := not IsNeedSave;
  if result then
  begin
    MainForm.tbSaveProject.Enabled := true;
    IsNeedSave := true;
  end;
end;

//========================================================================================
//-------------------------------------------------------- Возвращает номер строки в сетке
function GetGridLine(y : integer) : integer;
  var
    i: integer;
begin
  result := -9999;
  for i := - pplan.LineUp to pplan.LineDown do
  begin
    if (y > (i * pplan.SV + pplan.OZ.Y - BlockH)) and
      (y < (i * pplan.SV + pplan.OZ.Y + BlockH)) then
    begin
      result := i;
      exit;
    end;
  end;
end;

//========================================================================================
//------------------------------------------------------- Возвращает номер столбца в сетке
function GetGridCol(x : integer) : integer;
  var
    j: integer;
begin
  result := -9999;
  for j := - pplan.LineLeft  to pplan.LineRight  do
  begin
    if (x > (j * pplan.SH + pplan.OZ.X - BlockW)) and
      (x < (j * pplan.SH + pplan.OZ.X + BlockW)) then
    begin
      result := j;
      exit;
    end;
  end;
end;

//========================================================================================
//-------------------------------------------- Возвращает номер выбраной точки подключения
function GetSelectPin(x,y,i : integer) : integer;  //i --------- индекс выбранного объекта
begin
  result := 0;
  if objects[i].index > 0 then
  begin //------------------------------------------------- проверка для непустого объекта
    if (X > (objects[i].col*pplan.SH+pplan.OZ.X-BlockW-2)) and
       (X < (objects[i].col*pplan.SH+pplan.OZ.X-BlockW+8)) and
       (Y > (objects[i].line*pplan.SV+pplan.OZ.Y-8)) and
       (Y < (objects[i].line*pplan.SV+pplan.OZ.Y+8)) then
    begin
      if palette[objects[i].IDO].npin > 0 then result := 1;
      exit;
    end else
    if (X > (objects[i].col*pplan.SH+pplan.OZ.X+BlockW-8)) and
       (X < (objects[i].col*pplan.SH+pplan.OZ.X+BlockW+2)) and
       (Y > (objects[i].line*pplan.SV+pplan.OZ.Y-8)) and
       (Y < (objects[i].line*pplan.SV+pplan.OZ.Y+8)) then
    begin
      if palette[objects[i].IDO].npin > 1 then result := 2;
      exit;
    end else
    if (objects[i].IDO = 1) or (objects[i].IDO = 2)
    or (objects[i].IDO = 5) or (objects[i].IDO = 6) then
    begin
      if (X > (objects[i].col*pplan.SH+pplan.OZ.X-8)) and
         (X < (objects[i].col*pplan.SH+pplan.OZ.X+8)) and
         (Y > (objects[i].line*pplan.SV+pplan.OZ.Y-BlockH-3)) and
         (Y < (objects[i].line*pplan.SV+pplan.OZ.Y-BlockH+8)) then
      begin
        if palette[objects[i].IDO].npin > 2 then result := 3;
        exit;
      end
    end else
    if (objects[i].IDO = 3) or (objects[i].IDO = 4)
    or (objects[i].IDO = 7) or (objects[i].IDO = 8) then

    if (X > (objects[i].col*pplan.SH+pplan.OZ.X-8)) and
    (X < (objects[i].col*pplan.SH+pplan.OZ.X+8)) and
    (Y > (objects[i].line*pplan.SV+pplan.OZ.Y+BlockH-8)) and
    (Y < (objects[i].line*pplan.SV+pplan.OZ.Y+BlockH+3)) then
    begin
      if palette[objects[i].IDO].npin > 2 then result := 3;
      exit;
    end
  end;
end;
//========================================================================================
//--------------------------------------- Возвращает TRUE если помечен объект зависимостей
function SetSelectObj : boolean;
  var
    i : integer;
begin
  selectPin := 0;
  selectObj := 0;
  if (GetGridCol(CurPos.X) <> -9999) and (GetGridLine(CurPos.Y) <> -9999) then
    for i := 1 to Length(objects) do
      if objects[i].index > 0 then
        if (objects[i].line = GetGridLine(CurPos.Y)) and
           (objects[i].col = GetGridCol(CurPos.X)) then
        begin
          selectObj := objects[i].index;
          SetObjInspector(i); // Установить параметры в инспекторе объектов
          // Определить помечен ли контакт
          selectPin := GetSelectPin(CurPos.X,CurPos.Y,i);
          result := true;
{$IFDEF TABLO}
          if InspTabloForm.Visible then InspTabloForm.Refresh;
{$ELSE}
          if InspectorForm.Visible then InspectorForm.Refresh;
{$ENDIF}
          exit;
        end;
  SetObjInspector(0); // Сбросить параметры в инспекторе объектов
  for i := 1 to Length(objects) do
    objects[i].checkObj := false; // Сбросить признаки выбора группы
  result := false;
end;
//========================================================================================
//---------------------------------------------------------- Очистить весь список объектов
procedure ClearAllObj;
var
  i : integer;
begin
  for i := 1 to Length(objects) do
  begin
    with objects[i] do
    begin
      index  := 0;   name   := '';  line   := 0;  col    := 0;   IDO    := 0;
      jmp1   := 0;   jmp2   := 0;   jmp3   := 0;  params := ' ';
    end;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//----------------------------------------------------- Добавить новый объект зависимостей
function AddNewObj(ind : integer)  : integer;
var
  i : integer;
begin
  //---------------------------------- Сбросить признак группового выбора по всем объектам
  for i := 1 to Length(objects) do objects[i].checkObj := false;
  result := 0;
  if (GetGridCol(CurPos.X) <> -9999) and (GetGridLine(CurPos.Y) <> -9999) then
  begin
    for i := 1 to Length(objects) do
    begin
      if objects[i].index > 0 then
      if (objects[i].line = GetGridLine(CurPos.Y)) and
      (objects[i].col = GetGridCol(CurPos.X)) then
      begin
{$IFDEF TABLO}
        PaletteTabloForm.UnselectIDT; //----------- Сбросить код типа добавляемого объекта
{$ELSE}
        UnselectIDO;   //-------------------------- Сбросить код типа добавляемого объекта
{$ENDIF}
        result := i;        //---------------------- Выделить помеченный (мешающий) объект
        SetObjInspector(i); //------------------------------- Поместить объект в инспектор
        exit;
      end;
    end;
    objects[ind].index:= ind;
    objects[ind].name := 'obj'+ IntToStr(ind);
    objects[ind].line := GetGridLine(CurPos.Y); objects[ind].col  := GetGridCol(CurPos.X);
    objects[ind].IDO  := selectIDO;
    //------------------------------------------------------------------ и другие свойства
    result    := ind;
    SetObjInspector(ind);
  end;
  SetNeedSavePrj;
end;
//========================================================================================
//------------------------------------------------------------ Переместить объект по сетке
function MoveObj(ind : integer) : integer;
var
  i,j,dx,dy : integer;
begin
  result := ind;  ismoveObj := false;
  if result = 0 then
  begin
    ShowMessage('Перед использованием команды перемещения надо выбрать объект.');
    exit;
  end else
  begin
    if (GetGridCol(CurPos.X) <> -9999) and (GetGridLine(CurPos.Y) <> -9999) then
    begin
      dx := GetGridCol(CurPos.X) - objects[ind].col;
      dy := GetGridLine(CurPos.Y) - objects[ind].line;
      if (dx = 0) and (dy = 0) then exit;
      //------------- Проверить свободность места перемещения для размещения всех объектов
      for j := 1 to Length(objects) do
      if objects[j].checkObj or (j = ind) then
      for i := 1 to Length(objects) do
      begin
        if objects[i].index > 0 then
        if (objects[i].line = dy + objects[j].Line) and
        (objects[i].col  = dx + objects[j].Col) and
        not (objects[i].checkObj or (i = j)) then
        begin
          ShowMessage('Нельзя переместить объект на занятое место.');
          exit;
        end;
      end; //for
      //-------------------------------------- Установить новые параметры привязки к сетке
      for j := 1 to Length(objects) do
      if objects[j].checkObj or (j = ind) then
      begin
        objects[j].line := dy + objects[j].Line;
        objects[j].col  := dx + objects[j].Col;
      end;
      SetObjInspector(ind);
      SetNeedSavePrj;
      exit;
    end;
  end;
end;
//========================================================================================
//----------------------------------------------------------------- Удалить объект из базы
function DeleteObj(ind : integer) : integer;
var
  i,j : integer;
begin
{$IFDEF TABLO}
  PaletteTabloForm.UnselectIDT;
{$ELSE}
  PalettePlan.UnselectIDO; // Сбросить код типа добавляемого объекта
{$ENDIF}
  result := 0;
  if ind = 0 then
  begin
    ShowMessage('Неверно выбран объект.');
    exit;
  end else
  begin
    for i := 1 to Length(objects) do
    objects[i].checkObj := false; //------ Сбросить признак выбора группы по всем объектам
    for i := 1 to Length(objects) do
    if objects[i].index = ind then
    begin
      j := objects[i].jmp1;
      if j > 0 then DeleteCon(j);
      j := objects[i].jmp2;
      if j > 0 then DeleteCon(j);
      j := objects[i].jmp3;
      if j > 0 then DeleteCon(j);
      objects[i].index   := 0; //-------------------------------- освободить запись в базе
      objects[i].TmpName := '';  objects[i].name    := '';   objects[i].line    := 0;
      objects[i].col     := 0;   objects[i].IDO     := 0;    result := i;
      SetObjInspector(i);
      SetNeedSavePrj;
      break;
    end;
    //--------------------------------------------- Уплотнить объекты в структуре описания
    i := 1;
    while i < Length(objects) do
    begin  //-------------------------------------------- Просмотреть весь список объектов
      if objects[i].index = 0 then
      begin
        j := i+1;
        while j <= Length(objects) do
        begin
          if objects[j].index > 0 then
          //----------------------------------------------------- Найдена дырка в описании
          //--------------------------------- i - начало дырки; j - ближний к дырке объект
          begin
            //-------------------------------- Переместить описание из записи J в запись I
            objects[i].index  := i;
            objects[i].TmpName:= objects[j].TmpName;
            objects[i].name   := objects[j].name; objects[i].line    := objects[j].line;
            objects[i].col    := objects[j].col;   objects[i].IDO     := objects[j].IDO;
            objects[i].Jmp1   := objects[j].Jmp1; objects[i].Jmp2    := objects[j].Jmp2;
            objects[i].Jmp3   := objects[j].Jmp3; objects[i].Params  := objects[j].Params;
            //------------------- Переопределить индексы объектов в описаниях соединителей
            if objects[j].Jmp1 > 0 then
            if connects[objects[j].Jmp1].BeginObj = j then
            connects[objects[j].Jmp1].BeginObj := i;

            if objects[j].Jmp2 > 0 then
            if connects[objects[j].Jmp2].BeginObj = j then
            connects[objects[j].Jmp2].BeginObj := i;

            if objects[j].Jmp3 > 0 then
            if connects[objects[j].Jmp3].BeginObj = j then
            connects[objects[j].Jmp3].BeginObj := i;

            if objects[j].Jmp1 > 0 then
            if connects[objects[j].Jmp1].EndObj = j then
            connects[objects[j].Jmp1].EndObj := i;

            if objects[j].Jmp2 > 0 then
            if connects[objects[j].Jmp2].EndObj = j then
            connects[objects[j].Jmp2].EndObj := i;

            if objects[j].Jmp3 > 0 then
            if connects[objects[j].Jmp3].EndObj = j then
            connects[objects[j].Jmp3].EndObj := i;

            //-------------------------------------------------------- Освободить запись J
            objects[j].index   := 0;  objects[j].TmpName := '';  objects[j].name    := '';
            objects[j].line    := 0;  objects[j].col     := 0;   objects[j].IDO     := 0;
            objects[j].Jmp1    := 0;  objects[j].Jmp2    := 0;   objects[j].Jmp3    := 0;
            objects[j].Params  := '';
            break;
          end;
          inc(j);
        end;
      end;
      inc(i);
    end;
  end;
end;
//========================================================================================
//--------------------------------------------- Установить параметры в инспекторе объектов
procedure SetObjInspector(i : integer);
begin
{$IFDEF TABLO}
  InspTabloForm.SetViewObject(i);
{$ELSE}
  InspectorForm.SetViewObject(i);
{$ENDIF}
end;
//========================================================================================
//-------------------------------------------------------- Очистить весь список соединений
procedure ClearAllCon;
  var
    i : integer;
begin
  for i := 1 to Length(connects) do
  begin
    with connects[i] do
    begin
      Index := 0; IDO := 0;  BeginObj := 0;  BeginPin := 0; EndObj   := 0; EndPin   := 0;
    end;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//---------------------------------------------------- подключить первую точку соединителя
function  ConFirst : integer;
var
  i : integer;
begin
  selectCon := 0;
  //---------------------------------- проверить возможность добавления нового соединителя
  for i := 1 to Length(connects) do
  if connects[i].index = 0 then
  begin
    selectCon := i;
    break;
  end;
  if selectCon = 0 then
  ShowMessage('База данных заполнена. Новый элемент добавить невозможно.')
  else
  begin
    if SetSelectObj and (selectPin > 0) then
    begin
      //--------------------------------------------- Присвоить начальную точку соединения
      connects[selectCon].Index := selectCon;
      case selectIDO of
        24,25,26,76 : i := selectIDO; //------------------------------------ без изменений

        31:
          case selectPin of
            1 : i := 31; //-------------------------------- точка 1(нецентрализация слева)
            2 : i := 32; //------------------------------- точка 2(нецентрализация справа)
          end

        else
          case selectPin of  //------------------------------------ Тупик, граница станции
            1 : i := 33; //------------------------------------------ точка 1(тупик слева)
            2 : i := 34; //----------------------------------------- точка 2(тупик справа)
            else //------------------------------------------------- точка 3 (для стрелки)
              case objects[selectObj].IDO of
                1,2,5,6 : i := 42; //---------------------------------------- Тупик сверху
                3,4,7,8 : i := 43; //----------------------------------------- Тупик снизу
              end;
          end;
      end;
      connects[selectCon].IDO      := i;
      connects[selectCon].BeginObj := selectObj;
      connects[selectCon].BeginPin := selectPin;
      case selectPin of
        1: objects[selectObj].jmp1 := selectCon;
        2: objects[selectObj].jmp2 := selectCon;
        3: objects[selectObj].jmp3 := selectCon;
      end;
      case palette[i].npin of //------------------ Признак выбора второй точки подключения
        2..3: isfirstPin := true;
      else //--------------------------------------------- Иначе выбрана граница или тупик
        isfirstPin := false;
        SetNeedSavePrj;
      end;
      SetObjInspector(selectObj);
    end else
    begin

{$IFDEF TABLO}
      PaletteTabloForm.UnselectIDT; //------------- Сбросить код типа добавляемого объекта
{$ELSE}
      UnselectIDO; //------------------------------ Сбросить код типа добавляемого объекта
{$ENDIF}
      ShowMessage('Для добавления соединения надо определить начальную точку подключения.');
      selectCon := 0;
    end;
  end;
  result := selectCon;
end;
//========================================================================================
//---------------------------------------------------- подключить вторую точку соединителя
function  ConSecond : integer;
begin
  //-------------------------------------------------- Назначить конечную точку соединения
  if SetSelectObj and (selectPin > 0) and (selectObj <> connects[selectCon].BeginObj) then
  begin
    connects[selectCon].EndObj := selectObj;
    connects[selectCon].EndPin := selectPin;
    case selectPin of
      1: objects[selectObj].jmp1 := selectCon;
      2: objects[selectObj].jmp2 := selectCon;
      3: objects[selectObj].jmp3 := selectCon;
    end;
    SetObjInspector(selectObj);
  end else
  begin
{$IFDEF TABLO}
    PaletteTabloForm.UnselectIDT; //--------------- Сбросить код типа добавляемого объекта
{$ELSE}
    UnselectIDO; //-------------------------------- Сбросить код типа добавляемого объекта
{$ENDIF}
    ShowMessage('Для добавления соединения надо определить конечную точку подключения.');
    case connects[selectCon].BeginPin of
      1: objects[connects[selectCon].BeginObj].jmp1 := 0;
      2: objects[connects[selectCon].BeginObj].jmp2 := 0;
      3: objects[connects[selectCon].BeginObj].jmp3 := 0;
    end;
    connects[selectCon].Index := 0;
    selectCon := 0;
  end;
  result := selectCon;
  isfirstPin := false;
  SetNeedSavePrj;
end;

//========================================================================================
//------------------------------------------------------------ Удалить соединитель из базы
function  DeleteCon(ind : integer) : integer;
var
  i,j : integer;
begin
  result := 0;
  if ind = 0 then
  ShowMessage('Для удаления соединения надо пометить один из присоединенных контактов.')
  else
  begin
    for i := 1 to Length(connects) do
    if connects[i].Index = ind then
    begin
      result := ind;
      break;
    end;
    if result = 0 then exit
    else
    begin
      case connects[ind].BeginPin of //------------- Удалить связь с объектом начала связи
        1: objects[connects[ind].BeginObj].jmp1 := 0;
        2: objects[connects[ind].BeginObj].jmp2 := 0;
        3: objects[connects[ind].BeginObj].jmp3 := 0;
      end;
      case connects[ind].EndPin of //---------------- Удалить связь с объектом конца связи
        1: objects[connects[ind].EndObj].jmp1 := 0;
        2: objects[connects[ind].EndObj].jmp2 := 0;
        3: objects[connects[ind].EndObj].jmp3 := 0;
      end;
      //-------------------------------------------------------------- Удалить соединитель
      connects[ind].Index := 0;    connects[ind].IDO   := 0;  connects[ind].BeginObj := 0;
      connects[ind].BeginPin := 0; connects[ind].EndObj := 0; connects[ind].EndPin := 0;
      SetObjInspector(selectObj);
      //---------------------------------------------------- Уплотнить список соединителей
      i := 1;
      while i < Length(connects) do
      begin
        if connects[i].Index = 0 then
        begin
          j := i+1;
          while j <= Length(connects) do
          begin
            if connects[j].Index > 0 then
            begin
              //-------------------- I - свободное место в структуре описания соединителей
              //------------------------------------------------ J - Ближайший соединитель
              //------------------------------ Переместить описание из записи J в запись I
              connects[i].Index    := i;
              connects[i].IDO      := connects[j].IDO;
              connects[i].BeginObj := connects[j].BeginObj;
              connects[i].BeginPin := connects[j].BeginPin;
              connects[i].EndObj   := connects[j].EndObj;
              connects[i].EndPin   := connects[j].EndPin;
              //---------------------------- Переиндексировать ссылки в описаниях объектов
              if connects[i].BeginObj > 0 then
              begin
                case connects[i].BeginPin of
                  1 : objects[connects[i].BeginObj].Jmp1 := i;
                  2 : objects[connects[i].BeginObj].Jmp2 := i;
                  3 : objects[connects[i].BeginObj].Jmp3 := i;
                end;
              end;
              if connects[i].EndObj > 0 then
              begin
                case connects[i].EndPin of
                  1 : objects[connects[i].EndObj].Jmp1 := i;
                  2 : objects[connects[i].EndObj].Jmp2 := i;
                  3 : objects[connects[i].EndObj].Jmp3 := i;
                end;
              end;
              //------------------------------------------------------ Освободить запись J
              connects[j].Index := 0;   connects[j].IDO   := 0; connects[j].BeginObj := 0;
              connects[j].BeginPin := 0;connects[j].EndObj := 0;connects[j].EndPin := 0;
              break;
            end;
            inc(j);
          end;
        end;
        inc(i);
      end;
    end;
  end;
  SetNeedSavePrj;
end;
//========================================================================================
//------------------------- проверить полноту и правильность заполнения параметров объекта
function CheckParam(var p : TObjParams) : boolean;
var
  s,t,pa,d,h : string;
  i,j,k,l, All, Row1 : integer;
  ci : int64;
  fi : boolean;
  Marker : TRect;
begin
{$IFDEF TABLO}
  exit;
{$ELSE}

  result := false; //------------------------------- изначально считаем проверку неудачной
  s := p.params; //------------------------------------------- считываем параметры объекта
  if s = '' then  exit; //------------------------------------- если объект пустой - выход

  ci := $100000000;

  All := High(inint);

  for i := 0 to palette[p.IDO].proplist.Count-1 do  //--- пройти по всем свойствам объекта
  begin
    j := 1; h := '';

    d := palette[p.IDO].proplist.Strings[i]; //взять очередное свойство объекта из палитры

    while j <= Length(d) do
    begin
      if d[j] = ':'
      then break; //----------------------------- дойти до разделителя свойства и значения
      h := h + d[j]; //--------------------------- набирается имя свойства шаблона палитры
      inc(j);
    end;
    //-------------------------------- здесь получено h - наименование параметра в палитре

    if j > Length(d) then   exit; //------------- если вышли из считывания имени с ошибкой

    inc(j);
    t := '';
    while j <= Length(d) do //- продолжаем идти по строке и собираем тип параметра шаблона
    begin
      if d[j] = ':' then break;
      t := t + d[j];
      inc(j);
    end; //--------------------------------- t - тип параметра, опрделяет правила проверки

    if j > Length(d) then exit;
    k := 1;

    //------------------------------------------ Найти параметр в описании объекта проекта
    while k <= Length(s) do
    begin
      pa := '';
      while k <= Length(s) do
      begin
        if s[k] = '='
        then break;
        pa := pa + s[k];
        inc(k);
      end;    //---------------------------- pa - наименование параметра в объекте проекта
      if pa = h then  //если имя параметра соответствует имени параметра шаблона в палитре
      begin //----------------------------- Прочитать значение параметра в объекте проекта
        inc(k);
        d := '';

        while k <= Length(s) do
        begin
          if s[k] = ';' then break;
          d := d + s[k];
          inc(k);
        end;
        //------------------------------------------------- значение параметра объекта в d

        //---------------------------------------------------- ПРОВЕРКА ЗНАЧЕНИЯ ПАРАМЕТРА
        fi := false; //------------------- изначально считаем проверку параметра неудачной

        if t = 'iinput' then  //----------------- если тип параметра = "входной интерфейс"
        begin
          for l := 1 to All do  //------ пройтись по всему списку датчиков ввода
          if (inint[l].Index > 0) and
          (AnsiUpperCase(inint[l].Name) = AnsiUpperCase(d)) then //-- найдено имя в списке
          begin
            fi := true;
            break;
          end; //-------------------------------------------------------- удачная проверка
          if d = 'нет' then d := '?';

          if l = SelectObj then
          InspectorForm.ValueListEditor.Values[h] := d;

          if (l < All) and (l > 1) and (d = '?')  then
          begin
            fi := true;
            //inint[l].Name := d;
            InspectorForm.ValueListEditor.Values[h] := d;
            break;
          end;//----------------------------------------- в проекте датчик не предусмотрен
        end else

        if t = 'ioutput' then //---------------- если тип параметра = "выходной интерфейс"
        begin
          for l := 1 to Length(outint) do   //--- пройтись по всему списку датчиков вывода
          if (outint[l].Index >0) and
          (AnsiUpperCase(outint[l].Name) = AnsiUpperCase(d)) then //если есть имя в списке
          begin
            fi := true;
            break;
          end; //-------------------------------------------------------- удачная проверка

          if d = 'нет' then d := '?';

          if l = SelectObj then InspectorForm.ValueListEditor.Values[h] := d;
          if (l < All) and (l > 1) and (d = '?')  then
          begin
            fi := true;
            if l = SelectObj then  InspectorForm.ValueListEditor.Values[h] := d;
            break;
          end;//----------------------------------------- в проекте датчик не предусмотрен
        end else

        if t = 'iname' then  //-------- если тип параметра = "имя в объектах зависимостей"
        begin
          if ((d = '?') or (d = 'нет')) then  fi := true   // такого объекта на станции нет
          else
          for l := 1 to Length(objects) do //-------- пройти по всем объектам зависимостей
          begin
            fi := false;
            if (objects[l].Index > 0) and
            (AnsiUpperCase(objects[l].Name) = AnsiUpperCase(d)) then //-если найден объект
            begin
              fi := true;
              break; //-------------------------------------------------- удачная проверка
            end;
          end;

          if d = 'нет' then d := '?'; //------------------------ в проекте не предусмотрен

          if(d <> '?') and (d <> 'нет' ) then InspectorForm.ValueListEditor.Values[h]:=d;

          if fi = false then InspectorForm.ValueListEditor.Values[h] := '#'
          else
          begin
            if (l < All) and (l > 1) and (d = '?')  then
            begin
              fi := true;
//              inint[l].Name := d;
              if l = SelectObj then
              InspectorForm.ValueListEditor.Values[h] := d;
              break;
            end;//--------------------------------------- в проекте датчик не предусмотрен
          end;
        end else
        if t = 'bool' then //------------------------ если тип параметра двоичное значение
        begin
          if (d = 'да') or (d = 'нет') then   fi := true  //---------- если "да" или "нет"
          else
          begin
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end;
        end else

        if t = 'byte' then //-------------------- если тип параметра = "байтовая величина"
        begin
          try
            ci := StrToInt(d);
            if (ci >= 0) and (ci < 256) then  fi := true;// если значение в пределах байта
          except
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end; //------------------------------------------------------- перевести в целое
        end else

        if t = 'word' then //-------------------------------- если тип параметра = "слово"
        begin
          try
            ci := StrToInt(d)
          except
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end; //------------------------------------------------------- перевести в целое
          if (ci >= 0) and (ci < 65536) then fi := true;//--------- если в диапазоне слова
        end else

        if t = 'lword' then //---------------------------- если параметр = "длинное слово"
        begin
          try
            ci := StrToInt(d)
          except
            exit
          end; //------------------------------------------------------- перевести в целое
          if (ci >= 0) and (ci < $100000000) then  fi := true; //---------- если в допуске
        end else

        if t = 'short' then //--------------------------- если параметр = "короткое целое"
        begin
          try
            ci := StrToInt(d)
          except
            exit
          end; //--------------------- перевести в целое
          if (ci >= -128) and (ci < 128) then  fi := true;//--------------- если в допуске
        end else

        if t = 'small' then
        begin
          try
            ci := StrToInt(d)
          except
            exit
          end;
          if (ci >= -$8000) and (ci < $8000) then fi := true;
        end else

        if t = 'int' then
        begin
          try
            ci := StrToInt(d);
            if (ci >= -$80000000) and (ci < $80000000) then  fi := true;
          except
            if l = SelectObj then
            begin
              InspectorForm.ValueListEditor.Values[h] := '#';
              InspectorForm.ValueListEditor.FindRow(h,Row1);
              Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
              InspectorForm.ValueListEditor.Refresh;
            end;
            fi := false;
          end;
        end else

        if t = 'string' then //----------------------------------------------- если строка
        begin
          if d <> '' then   fi := true; //-------------------------- если строка не пустая
        end else

        if t = 'ilist' then //----------------------------------- список ссылок на объекты
        begin
          if d <> '' then  fi := true;
        end else

        begin //--------------------------------------------------- Другие типы параметров
          fi := true;
        end;

        //--------------------- Завершить проверку если выявлено несоответствие параметров
        if d = '?'  then fi := true;

        if fi then break
        else
        begin
          s[k-1] := '#';
          p.params := s;
          if l = SelectObj then
          begin
            InspectorForm.ValueListEditor.Values[h] := '#';
            InspectorForm.ValueListEditor.FindRow(h,Row1);
            Marker := InspectorForm.ValueListEditor.CellRect(1,Row1);
            InspectorForm.ValueListEditor.Refresh;
          end;
          exit;
        end;
      end;

      while k <= Length(s) do
      begin
        if s[k] = ';' then break;
        inc(k);
      end;
      inc(k);
    end;
  end;
  result := true;
{$ENDIF}
end;

//========================================================================================
procedure ClearAllInpInt; //----------------- Очистить список датчиков входных интерфейсов
  var
    i : integer;
begin
  inint[1].Index := 1;
  inint[1].Name  := 'нет';
  inint[1].Limit := 0;
  inint[1].Used  := 0;
  for i := 2 to Length(inint) do
  begin
    inint[i].Index := 0;
    inint[i].Name  := '';
    inint[i].Limit := 0;
    inint[i].Used  := 0;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//---------------------------------------------------- Очистить список логических датчиков
procedure ClearAllLogic;
  var
    i : integer;
begin
  for i := 1 to Length(logint) do
  begin
    logint[i].Name  := '';
    logint[i].Logic := '';
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//------------------------------------------ Очистить список датчиков выходных интерфейсов
procedure ClearAllOutInt;
  var
    i : integer;
begin
  outint[1].Index := 1; outint[1].Name  := 'нет';
  outint[1].Limit := 0; outint[1].Used  := 0;
  for i := 2 to Length(outint) do
  begin
    outint[i].Index := 0;  outint[i].Name  := '';
    outint[i].Limit := 0;  outint[i].Used  := 0;
  end;
  SetNeedSavePrj;
end;

//========================================================================================
//------------------------------------ Заменить значение ссылки во всех связанных объектах
function ReplaceValues(Key      : string; //----------------- Имя параметра объекта (ключ)
                       OldValue : string; //-------------------- Старое значение параметра
                       NewValue : string) //--------------------- Новое значение параметра
                       : integer;         //-- Возвращает количество измененных параметров
var
  i,j,k,l,m,r : integer;
  s,n,o,t : string;
begin
  result := 0;
  for i := 1 to Length(objects) do
  begin
    if objects[i].index > 0 then
    begin
      for j := 0 to palette[objects[i].IDO].proplist.Count - 1 do
      begin //---------------- Найти параметры объекта, ссылающиеся на имя данного объекта
        s := palette[objects[i].IDO].proplist.Strings[j];
        k := 1; n := '';
        while s[k] <> ':' do
        begin //------------------------------------------------------- Получить имя ключа
          n := n + s[k];
          inc(k);
          if k > Length(s) then break;
        end;
        inc(k);
        if k > Length(s) then break;
        t := '';
        while s[k] <> ':' do
        begin //--------------------------------------------------- Получить тип параметра
          t := t + s[k];
          inc(k);
          if k > Length(s) then break;
        end;
        if t = Key then
        begin //---------------------------------- Поиск ссылки в описании свойств объекта
          s := objects[i].params;
          for l := 1 to Length(s) do
          begin
            m := 0; o := '';
            while s[l+m] <> '=' do
            begin
              o := o + s[l+m];
              inc(m);
              if (l+m) > Length(s) then break;
            end;
            if o = n then //---------------- Если ключ совпал - сравнить значение с ключем
            begin
              r := l+m; //------------------ номер символа, с которого начинается значение
              inc(m);
              o := '';
              while s[l+m] <> ';' do
              begin
                o := o + s[l+m];
                inc(m);
                if (l+m) > Length(s) then break;
              end;
              if o = OldValue then
              begin
                t := s;  SetLength(t,r);  t := t + NewValue;  k := r;
                while s[k] <> ';' do
                begin
                  inc(k);
                  if k > Length(s) then break;
                end;
                if k <= Length(s) then
                begin
                  while k <= Length(s) do
                  begin
                    t := t + s[k];  inc(k);
                  end;
                end;
                objects[i].params := t; inc(result);
              end;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
  if result > 0 then SetNeedSavePrj;
end;

end.
