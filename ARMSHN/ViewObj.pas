unit ViewObj;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  Registry,
  ExtCtrls, 
  TypeALL;

type
  TViewObjForm = class(TForm)
    ListObj: TListView;
    RefTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ListObjClick(Sender: TObject);
    procedure RefTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewObjForm: TViewObjForm;
  ListObjCount : integer;                  // счетчик объектов зависимостей в списке
  StatusObjCod : array[1..2048] of Byte;   // массив состояния объектов зависимостей
  StatusObjMsg : array[1..2048] of string; // массив сообщений для объектов зависимостей

implementation

{$R *.dfm}

uses
  KanalArmSrvSHN,
  TabloSHN,
  ValueList;

var
  ListItem : TListItem;
  sparam : array[1..2] of string;

procedure TViewObjForm.FormCreate(Sender: TObject);
  var i : integer; ins : boolean;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegViewObjForm, false) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top') then Top := reg.ReadInteger('top') else Top := 0;
    if reg.ValueExists('height') then Height := reg.ReadInteger('height');
    if reg.ValueExists('width') then Width := reg.ReadInteger('width');
    reg.CloseKey;
  end;

  ListObjCount := 0;
  for i := 1 to WorkMode.LimitObjZav do
  begin
    ins := false;
    case ObjZav[i].TypeObj of
      2 : begin // стрелка
        sparam[1] := 'стрелка'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      3 : begin // участок
        sparam[1] := 'участок'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      4 : begin // путь
        sparam[1] := 'путь'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      5 : begin // светофор
        sparam[1] := 'светофор'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      6 : begin // ПТО
        sparam[1] := 'ПТО'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      7 : begin // Пригласительный сигнал
        sparam[1] := 'ПС'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      8 : begin // Тормозной упор
        sparam[1] := 'УТС'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      9 : begin // Замыкание стрелок
        sparam[1] := 'РзС'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      10 : begin // Управление переездом
        sparam[1] := 'переезд(упр)'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      11 : begin // контроль переезда станционного
        sparam[1] := 'переезд(к1)'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      12 : begin // контроль переезда диспетчерского
        sparam[1] := 'переезд(дк)'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      13 : begin // Оповещение монтеров
        sparam[1] := 'ОМ'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      14 : begin // УКСПС
        sparam[1] := 'УКСПС'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      15 : begin // АБ
        sparam[1] := 'АБ'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      16 : begin // Вспомогательная смена направления
        sparam[1] := 'ВСН'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      17 : begin // Рабочая магистраль стрелок
        sparam[1] := 'ВПС'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      18 : begin // Магистраль макета стрелок
        sparam[1] := 'ВМС'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      19 : begin // Вспомогательный перевод стрелок
        sparam[1] := 'ВКС'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      20 : begin // Макет стрелки
        sparam[1] := 'макет стр.'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      21 : begin // Комплект отмены
        sparam[1] := 'КВВ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      22 : begin // ГРИ
        sparam[1] := 'ГРИ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      23 : begin // МЭЦ
        sparam[1] := 'увязка МЭЦ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      24 : begin // Увязка между постами
        sparam[1] := 'увязка ЭЦ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      25 : begin // Квязка с маневровой колонкой
        sparam[1] := 'МК'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      26 : begin // РПБ
        sparam[1] := 'РПБ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      31 : begin // Повторитель светофора
        sparam[1] := 'повторитель св.'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      32 : begin // Увязка с ГАЦ
        sparam[1] := 'увязка ГАЦ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      33 : begin // Датчик
        sparam[1] := 'датчик'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      34 : begin // Контроль электропитания
        sparam[1] := 'питание'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      36 : begin // Команда без зависимостей
        sparam[1] := 'ключ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      37 : begin // Контроллер
        sparam[1] := 'контроллер'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      38 : begin // Контроль маршрута надвига
        sparam[1] := 'ГВ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      39 : begin // Режим управления
        sparam[1] := 'КРУ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      43 : begin // ОПИ
        sparam[1] := 'ОПИ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      45 : begin // Выбор зоны оповещения
        sparam[1] := 'КНМ'; sparam[2] := ObjZav[i].Liter; ins := true;
      end;
      47 : begin // Включение автодействия
        sparam[1] := 'АС'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      49 : begin // Увязка с АБТЦ
        sparam[1] := 'АБТЦ'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      50 : begin // Контроль перегонных точек
        sparam[1] := 'АБСТ'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
      51 : begin // Контроль дополнительных датчиков
        sparam[1] := 'ДопДат'; sparam[2] := ObjZav[i].Title; ins := true;
      end;
    end;
    if ins then
    begin // добавить в список объектов
      inc(ListObjCount);
      ListItem := ListObj.Items.Add;
      ListItem.Caption := IntToStr(i);
      ListItem.SubItems.Add(sparam[1]);
      ListItem.SubItems.Add(sparam[2]);
      StatusObjMsg[i] := 'сбор данных';
      StatusObjCod[i] := 0;
      ListItem.SubItems.Add(StatusObjMsg[i]);
    end;
  end;
end;

//------------------------------------------------------------------------------
// Выбор объекта из списка
procedure TViewObjForm.ListObjClick(Sender: TObject);
  var i : integer;
begin
  if Assigned(ListObj.Selected) then
  begin
    i := StrToIntDef(ListObj.Selected.Caption,-1);
    if (i > 0) and (i <= WorkMode.LimitObjZav) then
    begin
      ID_ViewObj := i;
      if not ValueListDlg.Visible then ValueListDlg.Show;
    end;
  end;
end;

//---------------------------------------------------------------------------
// Обновление информации о состоянии объектов зависимостей
procedure TViewObjForm.RefTimerTimer(Sender: TObject);
  var i,j,o : integer; state : byte;
begin
  if not ViewObjForm.Visible then exit;
  state := 0;
  for i := 1 to ListObj.Items.Count do
  begin
    j := StrToIntDef(ListObj.Items.Item[i-1].Caption,0);
    if j > 0 then
    begin
      case ObjZav[j].TypeObj of
        2 : begin // Стрелка
          o := ObjZav[j].BaseObject;
          if not ObjZav[o].bParam[31] then
          begin // нет данных
            StatusObjMsg[i] := 'нет данных'; state := 1;
          end else
          if ObjZav[o].bParam[32] then
          begin // непарафазность
            StatusObjMsg[i] := 'неисправность ввода'; state := 2;
          end else
          if ObjZav[o].bParam[26] and not ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
          begin // потеря контроля стрелки
            StatusObjMsg[i] := 'нет контроля'; state := 3;
          end else
          if ObjZav[o].bParam[1] and not ObjZav[o].bParam[2] then
          begin
            StatusObjMsg[i] := 'в плюсе'; state := 4;
          end else
          if not ObjZav[o].bParam[1] and ObjZav[o].bParam[2] then
          begin
            StatusObjMsg[i] := 'в минусе'; state := 5;
          end else
          begin
            StatusObjMsg[i] := 'перевод стрелки'; state := 6;
          end;
        end;

        3 : begin // Секция
          if not ObjZav[j].bParam[31] then
          begin // нет данных
            StatusObjMsg[i] := 'нет данных'; state := 1;
          end else
          if ObjZav[j].bParam[32] then
          begin // непарафазность
            StatusObjMsg[i] := 'неисправность ввода'; state := 2;
          end else
          begin
            if ObjZav[j].bParam[1] then begin state := 3; StatusObjMsg[i] := 'свободен'; end else begin state := 3+$8; StatusObjMsg[i] := 'занят'; end;
            if ObjZav[j].bParam[2] then begin StatusObjMsg[i] := StatusObjMsg[i]+', разомкнут'; end else begin state := 3+$10; StatusObjMsg[i] := StatusObjMsg[i]+', замкнут'; end;
            if ObjZav[j].bParam[3] then begin state := 3+$20; StatusObjMsg[i] := StatusObjMsg[i]+', искусственное размыкание'; end;
          end;
        end;

        4 : begin // Путь
          if not ObjZav[j].bParam[31] then
          begin // нет данных
            StatusObjMsg[i] := 'нет данных'; state := 1;
          end else
          if ObjZav[j].bParam[32] then
          begin // непарафазность
            StatusObjMsg[i] := 'неисправность ввода'; state := 2;
          end else
          begin
            if ObjZav[j].bParam[1] and ObjZav[j].bParam[16] then begin state := 3; StatusObjMsg[i] := 'свободен'; end else begin state := 3+$8; StatusObjMsg[i] := 'занят'; end;
            if ObjZav[j].bParam[2] and ObjZav[j].bParam[3] then begin StatusObjMsg[i] := StatusObjMsg[i]+', разомкнут'; end else begin state := 3+$10; StatusObjMsg[i] := StatusObjMsg[i]+', замкнут'; end;
          end;
        end;

        5 : begin // Светофор
          if not ObjZav[j].bParam[31] then
          begin // нет данных
            StatusObjMsg[i] := 'нет данных'; state := 1;
          end else
          if ObjZav[j].bParam[32] then
          begin // непарафазность
            StatusObjMsg[i] := 'неисправность ввода'; state := 2;
          end else
          begin
            if ObjZav[j].bParam[1] or ObjZav[j].bParam[2] or ObjZav[j].bParam[3] or ObjZav[j].bParam[4] then
            begin
              state := 4; StatusObjMsg[i] := 'открыт';
              if ObjZav[j].bParam[1] or ObjZav[j].bParam[2] then begin state := state+$8; StatusObjMsg[i] := StatusObjMsg[i]+' маневровый'; end;
              if ObjZav[j].bParam[3] or ObjZav[j].bParam[4] then begin state := state+$10; StatusObjMsg[i] := StatusObjMsg[i]+' поездной'; end;
            end else
            begin
              state := 3; StatusObjMsg[i] := 'закрыт';
              if ObjZav[j].bParam[5] then begin state := state+$20; StatusObjMsg[i] := StatusObjMsg[i]+', неисправен'; end;
            end;
          end;
        end;


      end;
      if StatusObjCod[i] <> state then
      begin
        ListObj.Items.Item[i-1].SubItems[2] := StatusObjMsg[i];
        StatusObjCod[i] := state;
      end;
    end;
  end;
end;

end.
