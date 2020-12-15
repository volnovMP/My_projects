unit ValueList;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Registry, Buttons, Grids, ValEdit, Menus;

type
  TValueListDlg = class(TForm)
    ValList: TValueListEditor;
    pmValueList: TPopupMenu;
    pmResetStat: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pmResetStatClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ValueListDlg : TValueListDlg;

procedure UpdateKeyList(index : integer);   // обновить список датчиков объекта
procedure UpdateValueList(index : integer); // обновить информацию о состоянии датчиков объекта

implementation

{$R *.dfm}

uses
  TypeALL,
  TabloSHN,
  KanalArmSrv,
  CMenu;

procedure TValueListDlg.FormCreate(Sender: TObject);
begin
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.OpenKey(KeyRegValListForm, false) then
  begin
    if reg.ValueExists('left') then Left := reg.ReadInteger('left') else Left := 0;
    if reg.ValueExists('top')  then Top  := reg.ReadInteger('top')  else Top  := 0;
    if reg.ValueExists('height')  then Height  := reg.ReadInteger('height')  else Height := 345;
    reg.CloseKey;
  end;
end;

procedure TValueListDlg.FormActivate(Sender: TObject);
begin
//
end;

procedure UpdateKeyList(index : integer); // обновить список датчиков объекта
begin
  ValueListDlg.ValList.Strings.Clear;
  TabloMain.TimerView.Enabled := true;
  if not ValueListDlg.Visible then ValueListDlg.Show;
end;

procedure UpdateValueList(index : integer); // обновить информацию о состоянии датчиков объекта
  var st,nep,rdy : boolean; i,j,o : smallint; s : string;
begin
  if not ValueListDlg.Visible then exit;
  ValueListDlg.ValList.Strings.Clear;
  case ObjZav[index].TypeObj of
    2 : begin // стрелка
      if ObjZav[ObjZav[index].BaseObject].ObjConstI[9] > 0 then
      begin // спаренная стрелка
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := 'Свойства : стрелка '+ ObjZav[index].Liter+' ('+ ObjZav[o].Liter+ ')';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Плюсовой контроль'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Плюсовой контроль'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Плюсовой контроль'] := 'есть' else ValueListDlg.ValList.Values['Плюсовой контроль'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Минусовой контроль'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Минусовой контроль'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Минусовой контроль'] := 'есть' else ValueListDlg.ValList.Values['Минусовой контроль'] := 'нет';
        if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) or (ObjZav[o].siParam[2] > 0) or (ObjZav[o].siParam[6] > 0) or (ObjZav[o].siParam[7] > 0) then
        begin
          if ObjZav[o].dtParam[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['Потеря контроля'] := s;
          end else ValueListDlg.ValList.Values['Потеря контроля'] := 'не зафиксирована';
          if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['По + свободной'] := IntToStr(ObjZav[o].siParam[1]);
          if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['По - свободной'] := IntToStr(ObjZav[o].siParam[2]);
          if ObjZav[o].siParam[6] > 0 then ValueListDlg.ValList.Values['По + занятой'] := IntToStr(ObjZav[o].siParam[6]);
          if ObjZav[o].siParam[7] > 0 then ValueListDlg.ValList.Values['По - занятой'] := IntToStr(ObjZav[o].siParam[7]);
        end;
        if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[3] > 0) then
        begin
          if ObjZav[o].dtParam[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['Непостановка'] := s;
          end else ValueListDlg.ValList.Values['Непостановка'] := 'не зафиксирована';
          if ObjZav[o].siParam[3] > 0 then
            ValueListDlg.ValList.Values['Количество'] := IntToStr(ObjZav[o].siParam[3]);
        end;
        if ObjZav[o].siParam[4] > 0 then ValueListDlg.ValList.Values['Переводов в +'] := IntToStr(ObjZav[o].siParam[4]);
        if ObjZav[o].siParam[5] > 0 then ValueListDlg.ValList.Values['Переводов в -'] := IntToStr(ObjZav[o].siParam[5]);
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['Время перевода в +'] := s;
        end;
        if ObjZav[o].dtParam[4] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[4]); ValueListDlg.ValList.Values['Время перевода в -'] := s;
        end;
        st := GetFR4State(ObjZav[o].ObjConstI[1]-5);
        if st then ValueListDlg.ValList.Values['Управление'] := 'отключено' else ValueListDlg.ValList.Values['Управление'] := 'включено';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-4);
        if st then ValueListDlg.ValList.Values['Макет'] := 'установлен' else ValueListDlg.ValList.Values['Макет'] := 'не установлен';
        if ObjZav[index].ObjConstB[6] then
        begin // Дальняя стрелка
          st := GetFR4State(ObjZav[o].ObjConstI[1]-2);
          if st then ValueListDlg.ValList.Values['Движение'] := 'закрыто' else ValueListDlg.ValList.Values['Движение'] := 'разрешено';
        end else
        begin // Ближняя стрелка
          st := GetFR4State(ObjZav[o].ObjConstI[1]-3);
          if st then ValueListDlg.ValList.Values['Движение'] := 'закрыто' else ValueListDlg.ValList.Values['Движение'] := 'разрешено';
        end;
        if ObjZav[index].ObjConstB[6] then
        begin // Дальняя стрелка
          st := GetFR4State(ObjZav[o].ObjConstI[1]);
          if st then ValueListDlg.ValList.Values['Движение пш'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пш'] := 'разрешено';
        end else
        begin // Ближняя стрелка
          st := GetFR4State(ObjZav[o].ObjConstI[1]-1);
          if st then ValueListDlg.ValList.Values['Движение пш'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пш'] := 'разрешено';
        end;
      end else
      begin // одиночная стрелка
        o := ObjZav[index].BaseObject;
        ValueListDlg.Caption := 'Свойства : стрелка '+ ObjZav[o].Liter;
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Плюсовой контроль'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Плюсовой контроль'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Плюсовой контроль'] := 'есть' else ValueListDlg.ValList.Values['Плюсовой контроль'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Минусовой контроль'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Минусовой контроль'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Минусовой контроль'] := 'есть' else ValueListDlg.ValList.Values['Минусовой контроль'] := 'нет';
        if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) or (ObjZav[o].siParam[2] > 0) or (ObjZav[o].siParam[6] > 0) or (ObjZav[o].siParam[7] > 0) then
        begin
          if ObjZav[o].dtParam[1] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['Потеря контроля'] := s;
          end else ValueListDlg.ValList.Values['Потеря контроля'] := 'не зафиксировано';
          if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['По + свободной'] := IntToStr(ObjZav[o].siParam[1]);
          if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['По - свободной'] := IntToStr(ObjZav[o].siParam[2]);
          if ObjZav[o].siParam[6] > 0 then ValueListDlg.ValList.Values['По + занятой'] := IntToStr(ObjZav[o].siParam[6]);
          if ObjZav[o].siParam[7] > 0 then ValueListDlg.ValList.Values['По - занятой'] := IntToStr(ObjZav[o].siParam[7]);
        end;
        if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[3] > 0) then
        begin
          if ObjZav[o].dtParam[2] > 0 then
          begin
            DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['Непостановка'] := s;
          end else ValueListDlg.ValList.Values['Непостановка'] := 'не зафиксировано';
          if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['Количество'] := IntToStr(ObjZav[o].siParam[3]);
        end;
        if ObjZav[o].siParam[4] > 0 then ValueListDlg.ValList.Values['Переводов в +'] := IntToStr(ObjZav[o].siParam[4]);
        if ObjZav[o].siParam[5] > 0 then ValueListDlg.ValList.Values['Переводов в -'] := IntToStr(ObjZav[o].siParam[5]);
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['Время перевода в +'] := s;
        end;
        if ObjZav[o].dtParam[4] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[4]); ValueListDlg.ValList.Values['Время перевода в -'] := s;
        end;
        st := GetFR4State(ObjZav[o].ObjConstI[1]-5);
        if st then ValueListDlg.ValList.Values['Управление'] := 'отключено' else ValueListDlg.ValList.Values['Управление'] := 'включено';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-4);
        if st then ValueListDlg.ValList.Values['Макет'] := 'установлен' else ValueListDlg.ValList.Values['Макет'] := 'не установлен';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-3);
        if st then ValueListDlg.ValList.Values['Движение'] := 'закрыто' else ValueListDlg.ValList.Values['Движение'] := 'разрешено';
        st := GetFR4State(ObjZav[o].ObjConstI[1]-1);
        if st then ValueListDlg.ValList.Values['Движение пш'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пш'] := 'разрешено';
      end;
    end;
    3 : begin // СП,УП
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Liter;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
      if nep then ValueListDlg.ValList.Values['Занятость'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['Занятость'] := 'есть' else ValueListDlg.ValList.Values['Занятость'] := 'нет';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
      if nep then ValueListDlg.ValList.Values['Замыкание'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Замыкание'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['Замыкание'] := 'есть' else ValueListDlg.ValList.Values['Замыкание'] := 'нет';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
      if nep then ValueListDlg.ValList.Values['РИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['РИ'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['РИ'] := 'есть' else ValueListDlg.ValList.Values['РИ'] := 'нет';
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МСП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МСП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МСП'] := 'есть' else ValueListDlg.ValList.Values['МСП'] := 'нет';
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'s,z',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['Тмсп'] := s;
        end;
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ'] := 'есть' else ValueListDlg.ValList.Values['МИ'] := 'нет';
      end;
      if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) then
      begin
        if ObjZav[o].dtParam[1] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['Занятие секции'] := s;
        end else ValueListDlg.ValList.Values['Занятие секции'] := 'не зафиксировано';
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['Количество з.'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[2] > 0) then
      begin
        if ObjZav[o].dtParam[2] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['Освобождение секции'] := s;
        end else ValueListDlg.ValList.Values['Освобождение секции'] := 'не зафиксировано';
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['Количество с.'] := IntToStr(ObjZav[o].siParam[2]);
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['Движение'] := 'закрыто' else ValueListDlg.ValList.Values['Движение'] := 'разрешено';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
        if st then ValueListDlg.ValList.Values['Движение эл.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение эл.т.'] := 'разрешено';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
          if st then ValueListDlg.ValList.Values['Движение пост.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пост.т.'] := 'разрешено';
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
          if st then ValueListDlg.ValList.Values['Движение пер.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
        end;
      end;
    end;
    4 : begin // П
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Liter;
      if (ObjZav[o].ObjConstI[2] <> ObjZav[o].ObjConstI[9]) and (ObjZav[o].ObjConstI[2] > 0) and (ObjZav[o].ObjConstI[9] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Занятость(ч)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость(ч)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Занятость(ч)'] := 'есть' else ValueListDlg.ValList.Values['Занятость(ч)'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Занятость(н)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость(н)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Занятость(н)'] := 'есть' else ValueListDlg.ValList.Values['Занятость(н)'] := 'нет';
      end else
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Занятость'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Занятость'] := 'есть' else ValueListDlg.ValList.Values['Занятость'] := 'нет';
      end else
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Занятость'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Занятость'] := 'есть' else ValueListDlg.ValList.Values['Занятость'] := 'нет';
      end;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
      if nep then ValueListDlg.ValList.Values['ЧИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЧИ']:= 'нет данных' else
      if st then ValueListDlg.ValList.Values['ЧИ'] := 'есть' else ValueListDlg.ValList.Values['ЧИ'] := 'нет';
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
      if nep then ValueListDlg.ValList.Values['НИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['НИ'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['НИ'] := 'есть' else ValueListDlg.ValList.Values['НИ'] := 'нет';
      if (ObjZav[o].ObjConstI[5] <> ObjZav[o].ObjConstI[7]) and (ObjZav[o].ObjConstI[7] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ЧКМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЧКМ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ЧКМ'] := 'есть' else ValueListDlg.ValList.Values['ЧКМ'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['НКМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['НКМ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['НКМ'] := 'есть' else ValueListDlg.ValList.Values['НКМ'] := 'нет';
      end else
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КМ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КМ'] := 'есть' else ValueListDlg.ValList.Values['КМ'] := 'нет';
      end;
      if (ObjZav[o].ObjConstI[6] <> ObjZav[o].ObjConstI[8]) and (ObjZav[o].ObjConstI[6] > 0) and (ObjZav[o].ObjConstI[8] > 0) then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ(ч)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ(ч)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ(ч)'] := 'есть' else ValueListDlg.ValList.Values['МИ(ч)'] := 'нет';
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ(н)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ(н)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ(н)'] := 'есть' else ValueListDlg.ValList.Values['МИ(н)'] := 'нет';
      end else
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ'] := 'есть' else ValueListDlg.ValList.Values['МИ'] := 'нет';
      end else
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ'] := 'есть' else ValueListDlg.ValList.Values['МИ'] := 'нет';
      end;
      if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) then
      begin
        if ObjZav[o].dtParam[1] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['Занятие пути'] := s;
        end else ValueListDlg.ValList.Values['Занятие пути'] := 'не зафиксировано';
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['Количество з.'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[2] > 0) then
      begin
        if ObjZav[o].dtParam[2] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['Освобождение пути'] := s;
        end else ValueListDlg.ValList.Values['Освобождение пути'] := 'не зафиксировано';
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['Количество с.'] := IntToStr(ObjZav[o].siParam[2]);
      end;
      if (ObjZav[o].dtParam[3] > 0) or (ObjZav[o].siParam[3] > 0) then
      begin
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['Отсутствие теста пути'] := s;
        end else ValueListDlg.ValList.Values['Отсутствие теста пути'] := 'не зафиксировано';
        if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['Количество т.'] := IntToStr(ObjZav[o].siParam[3]);
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[2] div 8 * 8 + 2);
      if st then ValueListDlg.ValList.Values['Движение'] := 'закрыто' else ValueListDlg.ValList.Values['Движение'] := 'разрешено';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[2] div 8 * 8 + 3);
        if st then ValueListDlg.ValList.Values['Движение эл.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение эл.т.'] := 'разрешено';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[2] div 8 * 8);
          if st then ValueListDlg.ValList.Values['Движение пост.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пост.т.'] := 'разрешено';
          st := GetFR4State(ObjZav[o].ObjConstI[1] div 8 * 8 + 1);
          if st then ValueListDlg.ValList.Values['Движение пер.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
        end;
      end;
    end;
    5 : begin // Светофор
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Liter;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['НМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['НМ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['НМ'] := 'есть' else ValueListDlg.ValList.Values['НМ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МВС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МВС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МВС'] := 'есть' else ValueListDlg.ValList.Values['МВС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МС'] := 'есть' else ValueListDlg.ValList.Values['МС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Н'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Н'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Н'] := 'есть' else ValueListDlg.ValList.Values['Н'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ВС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ВС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ВС'] := 'есть' else ValueListDlg.ValList.Values['ВС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['С'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['С'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['С'] := 'есть' else ValueListDlg.ValList.Values['С'] := 'нет';
      end;
      nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
      if nep then ValueListDlg.ValList.Values['о'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['о'] := 'нет данных' else
      if st then ValueListDlg.ValList.Values['о'] := 'неисправен' else ValueListDlg.ValList.Values['о'] := 'исправен';
      if (ObjZav[o].dtParam[1] > 0) or (ObjZav[o].siParam[1] > 0) then
      begin
        if ObjZav[o].dtParam[1] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[1]); ValueListDlg.ValList.Values['Неисправность О'] := s;
        end else ValueListDlg.ValList.Values['Неисправность О'] := 'не зафиксировано';
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['Количество О'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if (ObjZav[o].dtParam[2] > 0) or (ObjZav[o].siParam[2] > 0) then
      begin
        if ObjZav[o].dtParam[2] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[2]); ValueListDlg.ValList.Values['Перекрытие'] := s;
        end else ValueListDlg.ValList.Values['Перекрытие'] := 'не зафиксировано';
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['Количество п.'] := IntToStr(ObjZav[o].siParam[2]);
      end;

      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        if ObjZav[o].ObjConstI[25] = 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
          if nep then ValueListDlg.ValList.Values['Со'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Со'] := 'нет данных' else
          if st then ValueListDlg.ValList.Values['Со'] := 'неисправен' else ValueListDlg.ValList.Values['Со'] := 'исправен';
        end else
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
          if nep then ValueListDlg.ValList.Values['ЖСо'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЖСо'] := 'нет данных' else
          if st then ValueListDlg.ValList.Values['ЖСо'] := 'неисправен' else ValueListDlg.ValList.Values['ЖСо'] := 'исправен';
        end;
      end;
      if ObjZav[o].ObjConstI[25] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[25],nep,rdy);
        if nep then ValueListDlg.ValList.Values['зСо'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['зСо'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['зСо'] := 'неисправен' else ValueListDlg.ValList.Values['зСо'] := 'исправен';
      end;
      if ObjZav[o].ObjConstI[26] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[26],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ВНП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ВНП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ВНП'] := 'неисправен' else ValueListDlg.ValList.Values['ВНП'] := 'исправен';
      end;
      if ObjZav[o].ObjConstI[30] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[30],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Кз'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Кз'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Кз'] := 'есть' else ValueListDlg.ValList.Values['Кз'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[29] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[29],nep,rdy);
        if nep then ValueListDlg.ValList.Values['2зС/ЖБС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['2зС/ЖБС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['2зС/ЖБС'] := 'есть' else ValueListDlg.ValList.Values['2зС/ЖБС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Прикрытие'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Прикрытие'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Прикрытие'] := 'включено' else ValueListDlg.ValList.Values['Прикрытие'] := 'нет';
      end;
      if (ObjZav[o].dtParam[3] > 0) or (ObjZav[o].siParam[3] > 0) then
      begin
        if ObjZav[o].dtParam[3] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[3]); ValueListDlg.ValList.Values['Переход на резерв'] := s;
        end else ValueListDlg.ValList.Values['Переход на резерв'] := 'не зафиксировано';
        if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['Количество Со'] := IntToStr(ObjZav[o].siParam[3]);
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ЛС/ЖМС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЛС/ЖМС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ЛС/ЖМС'] := 'есть' else ValueListDlg.ValList.Values['ЛС/ЖМС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Авария шкафа'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Авария шкафа'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Авария шкафа'] := 'неисправен' else ValueListDlg.ValList.Values['Авария шкафа'] := 'исправен';
      end;
      if (ObjZav[o].dtParam[4] > 0) or (ObjZav[o].siParam[4] > 0) then
      begin
        if ObjZav[o].dtParam[4] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[4]); ValueListDlg.ValList.Values['Последняя А'] := s;
        end else ValueListDlg.ValList.Values['Последняя А'] := 'не зафиксировано';
        if ObjZav[o].siParam[4] > 0 then
        begin
          ValueListDlg.ValList.Values['Количество А'] := IntToStr(ObjZav[o].siParam[4]);
        end else ValueListDlg.ValList.Values['Количество А'] := 'не зафиксировано';
      end;
      if (ObjZav[o].dtParam[5] > 0) or (ObjZav[o].siParam[5] > 0) then
      begin
        if ObjZav[o].dtParam[5] > 0 then
        begin
          DateTimeToString(s,'dd/mm/yy hh:nn:ss',ObjZav[o].dtParam[5]); ValueListDlg.ValList.Values['Последняя Кз'] := s;
        end else ValueListDlg.ValList.Values['Последняя Кз'] := 'не зафиксировано';
        if ObjZav[o].siParam[5] > 0 then
        begin
          ValueListDlg.ValList.Values['Количество Кз'] := IntToStr(ObjZav[o].siParam[5]);
        end else ValueListDlg.ValList.Values['Количество Кз'] := 'не зафиксировано';
      end;
      if ObjZav[o].dtParam[6] > 0 then
      begin
        DateTimeToString(s,'s,z',ObjZav[o].dtParam[6]); ValueListDlg.ValList.Values['Замедление СР'] := s;
      end;
      if (ObjZav[o].ObjConstI[20] > 0) or (ObjZav[o].ObjConstI[21] > 0) or (ObjZav[o].ObjConstI[22] > 0) or (ObjZav[o].ObjConstI[23] > 0) or (ObjZav[o].ObjConstI[24] > 0) then
      begin
        if ObjZav[o].bParam[18] then ValueListDlg.ValList.Values['РМ'] := 'есть' else ValueListDlg.ValList.Values['РМ'] := 'нет';
        if ObjZav[o].ObjConstB[18] then
        begin
          if ObjZav[o].bParam[21] then ValueListDlg.ValList.Values['МУС'] := 'есть' else ValueListDlg.ValList.Values['МУС'] := 'нет';
        end;
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['Движение'] := 'закрыто' else ValueListDlg.ValList.Values['Движение'] := 'разрешено';
    end;
    6 : begin // ПТО
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Оз'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Оз'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Оз'] := 'есть' else ValueListDlg.ValList.Values['Оз'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['оГ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['оГ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['оГ'] := 'есть' else ValueListDlg.ValList.Values['оГ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['СоГ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['СоГ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['СоГ'] := 'есть' else ValueListDlg.ValList.Values['СоГ'] := 'нет';
      end;
      if ObjZav[o].bParam[5] then ValueListDlg.ValList.Values['Неисправность'] := 'есть';
    end;
    7 : begin // ПС
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        if ObjZav[o].ObjConstI[3] > 0 then
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
          if nep then ValueListDlg.ValList.Values['ПС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ПС'] := 'нет данных' else
          if st then ValueListDlg.ValList.Values['ПС'] := 'есть' else ValueListDlg.ValList.Values['ПС'] := 'нет';
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
          if nep then ValueListDlg.ValList.Values['ПСо'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ПСо'] := 'нет данных' else
          if st then ValueListDlg.ValList.Values['ПСо'] := 'есть' else ValueListDlg.ValList.Values['ПСо'] := 'нет';
        end else
        begin
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
          if nep then ValueListDlg.ValList.Values['КПС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КПС'] := 'нет данных' else
          if st then ValueListDlg.ValList.Values['КПС'] := 'есть' else ValueListDlg.ValList.Values['КПС'] := 'нет';
        end;
      end;
    end;
    8 : begin // УТС
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['УС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['УС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['УС'] := 'есть' else ValueListDlg.ValList.Values['УС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['УУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['УУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['УУ'] := 'есть' else ValueListDlg.ValList.Values['УУ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Блокировка'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Блокировка'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Блокировка'] := 'есть' else ValueListDlg.ValList.Values['Блокировка'] := 'нет';
      end;
    end;
    9 : begin // Замыкание стрелок
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ДзС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ДзС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ДзС'] := 'есть' else ValueListDlg.ValList.Values['ДзС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['оДзС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['оДзС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['оДзС'] := 'есть' else ValueListDlg.ValList.Values['оДзС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Рз'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Рз'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Рз'] := 'есть' else ValueListDlg.ValList.Values['Рз'] := 'нет';
      end;
    end;
    10 : begin // Закрытие переезда
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['УзП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['УзП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['УзП'] := 'есть' else ValueListDlg.ValList.Values['УзП'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['УзПД'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['УзПД'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['УзПД'] := 'есть' else ValueListDlg.ValList.Values['УзПД'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Закрытие'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Закрытие'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Закрытие'] := 'есть' else ValueListDlg.ValList.Values['Закрытие'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Извещение'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Извещение'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Извещение'] := 'есть' else ValueListDlg.ValList.Values['Извещение'] := 'нет';
      end;
    end;
    11 : begin // Контроль переезда станционного
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Авария'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Авария'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Авария'] := 'есть' else ValueListDlg.ValList.Values['Авария'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Неисправность'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Неисправность'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Неисправность'] := 'есть' else ValueListDlg.ValList.Values['Неисправность'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контр.закрытия'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контр.закрытия'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контр.закрытия'] := 'есть' else ValueListDlg.ValList.Values['Контр.закрытия'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['зГ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['зГ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['зГ'] := 'есть' else ValueListDlg.ValList.Values['зГ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контр.открытия'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контр.открытия'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контр.открытия'] := 'есть' else ValueListDlg.ValList.Values['Контр.открытия'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контр.извещения'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контр.извещения'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контр.извещения'] := 'есть' else ValueListDlg.ValList.Values['Контр.извещения'] := 'нет';
      end;
    end;
    12 : begin // Контроль переезда ДК
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КНП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КНП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КНП'] := 'есть' else ValueListDlg.ValList.Values['КНП'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контр.закрытия'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контр.закрытия'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контр.закрытия'] := 'есть' else ValueListDlg.ValList.Values['Контр.закрытия'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['зГ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['зГ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['зГ'] := 'есть' else ValueListDlg.ValList.Values['зГ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контр.открытия'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контр.открытия'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контр.открытия'] := 'есть' else ValueListDlg.ValList.Values['Контр.открытия'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контр.извещения'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контр.извещения'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контр.извещения'] := 'есть' else ValueListDlg.ValList.Values['Контр.извещения'] := 'нет';
      end;
    end;
    13 : begin // Оповещение монтеров
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['"Поезд"'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['"Поезд"'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['"Поезд"'] := 'есть' else ValueListDlg.ValList.Values['"Поезд"'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Включение'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Включение'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Включение'] := 'есть' else ValueListDlg.ValList.Values['Включение'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Окончание ВВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Окончание ВВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Окончание ВВ'] := 'есть' else ValueListDlg.ValList.Values['Окончание ВВ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Начало ВВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Начало ВВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Начало ВВ'] := 'есть' else ValueListDlg.ValList.Values['Начало ВВ'] := 'нет';
      end;
    end;
    14 : begin // УКСПС
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Блокировка'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Блокировка'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Блокировка'] := 'есть' else ValueListDlg.ValList.Values['Блокировка'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Датчик1'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Датчик1'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Датчик1'] := 'неисправен' else ValueListDlg.ValList.Values['Датчик1'] := 'исправен';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Датчик2'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Датчик2'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Датчик2'] := 'неисправен' else ValueListDlg.ValList.Values['Датчик2'] := 'исправен';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контроль линии'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контроль линии'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контроль линии'] := 'неисправна' else ValueListDlg.ValList.Values['Контроль линии'] := 'исправна';
      end;
    end;
    15 : begin // АБ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['В'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['В'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['В'] := 'есть' else ValueListDlg.ValList.Values['В'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['1ИП/Ж'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['1ИП/Ж'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['1ИП/Ж'] := 'занят' else ValueListDlg.ValList.Values['1ИП/Ж'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['2ИП/з'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['2ИП/з'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['2ИП/з'] := 'занят' else ValueListDlg.ValList.Values['2ИП/з'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['СН'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['СН'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['СН'] := 'отправление' else ValueListDlg.ValList.Values['СН'] := 'прием';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КП'] := 'занят' else ValueListDlg.ValList.Values['КП'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Ключ-жезл'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Ключ-жезл'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Ключ-жезл'] := 'изъят' else ValueListDlg.ValList.Values['Ключ-жезл'] := 'вставлен';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Запрос СН'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Запрос СН'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Запрос СН'] := 'есть' else ValueListDlg.ValList.Values['Запрос СН'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Л'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Л'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Л'] := 'есть' else ValueListDlg.ValList.Values['Л'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['3ИП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['3ИП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['3ИП'] := 'занят' else ValueListDlg.ValList.Values['3ИП'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Согласие СН'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Согласие СН'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Согласие СН'] := 'есть' else ValueListDlg.ValList.Values['Согласие СН'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Д1'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Д1'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Д1'] := 'есть' else ValueListDlg.ValList.Values['Д1'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Д2'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Д2'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Д2'] := 'есть' else ValueListDlg.ValList.Values['Д2'] := 'нет';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['Закрытие перегона'] := 'закрыт' else ValueListDlg.ValList.Values['Закрытие перегона'] := 'открыт';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
        if st then ValueListDlg.ValList.Values['Движение эл.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение эл.т.'] := 'разрешено';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
          if st then ValueListDlg.ValList.Values['Движение пост.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пост.т.'] := 'разрешено';
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
          if st then ValueListDlg.ValList.Values['Движение пер.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
        end;
      end;
    end;
    16 : begin // Вспомогательная смена направления АБ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ВП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ВП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ВП'] := 'есть' else ValueListDlg.ValList.Values['ВП'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ДВП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ДВП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ДВП'] := 'есть' else ValueListDlg.ValList.Values['ДВП'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Во'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Во'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Во'] := 'есть' else ValueListDlg.ValList.Values['Во'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ДВо'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ДВо'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ДВо'] := 'есть' else ValueListDlg.ValList.Values['ДВо'] := 'нет';
      end;
    end;
    17 : begin // Магистраль рабочего тока стрелок
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Включение'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Включение'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Включение'] := 'есть' else ValueListDlg.ValList.Values['Включение'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Рабочий ток'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Рабочий ток'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Рабочий ток'] := 'есть' else ValueListDlg.ValList.Values['Рабочий ток'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ЛАР'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЛАР'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ЛАР'] := 'неисправен' else ValueListDlg.ValList.Values['ЛАР'] := 'исправен';
      end;
    end;
    18 : begin // Магистраль макета стрелок
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Перевод на макете'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Перевод на макете'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Перевод на макете'] := 'есть' else ValueListDlg.ValList.Values['Перевод на макете'] := 'нет';
      end;
    end;
    19 : begin // Вспомогательный перевод стрелок
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ВК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ВК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ВК'] := 'есть' else ValueListDlg.ValList.Values['ВК'] := 'нет';
      end;
    end;
    20 : begin // Макет стрелок
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КМ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КМ'] := 'подключен' else ValueListDlg.ValList.Values['КМ'] := 'не подключен';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МПК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МПК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МПК'] := 'есть' else ValueListDlg.ValList.Values['МПК'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ММК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ММК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ММК'] := 'есть' else ValueListDlg.ValList.Values['ММК'] := 'нет';
      end;
    end;
    21 : begin // Комплект выдержки времени отмены
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Свободная'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Свободная'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Свободная'] := 'включена' else ValueListDlg.ValList.Values['Свободная'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['Выдержка ОС'] := IntToStr(ObjZav[o].siParam[1]);
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Маневровая'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Маневровая'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Маневровая'] := 'включена' else ValueListDlg.ValList.Values['Маневровая'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        if ObjZav[o].siParam[2] > 0 then ValueListDlg.ValList.Values['Выдержка ОМ'] := IntToStr(ObjZav[o].siParam[2]);
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Поездная'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Поездная'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Поездная'] := 'включена' else ValueListDlg.ValList.Values['Поездная'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        if ObjZav[o].siParam[3] > 0 then ValueListDlg.ValList.Values['Выдержка ОП'] := IntToStr(ObjZav[o].siParam[3]);
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['оВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['оВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['оВ'] := 'включена' else ValueListDlg.ValList.Values['оВ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МВ'] := 'включена' else ValueListDlg.ValList.Values['МВ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ПВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ПВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ПВ'] := 'включена' else ValueListDlg.ValList.Values['ПВ'] := 'нет';
      end;
    end;
    22 : begin // Комплект искусственного размыкания
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ГРИ1'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ГРИ1'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ГРИ1'] := 'включена' else ValueListDlg.ValList.Values['ГРИ1'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ГРИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ГРИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ГРИ'] := 'включена' else ValueListDlg.ValList.Values['ГРИ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ИВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ИВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ИВ'] := 'включена' else ValueListDlg.ValList.Values['ИВ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        if ObjZav[o].siParam[1] > 0 then ValueListDlg.ValList.Values['Выдержка ИР'] := IntToStr(ObjZav[o].siParam[1]);
      end;
    end;
    23 : begin // Увязка с МЭЦ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Маневровый прием'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Маневровый прием'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Маневровый прием'] := 'есть' else ValueListDlg.ValList.Values['Маневровый прием'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Маневровое отправление'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Маневровое отправление'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Маневровое отправление'] := 'есть' else ValueListDlg.ValList.Values['Маневровое отправление'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Гашение сигналов'] := 'есть' else ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['Закрытие перегона'] := 'закрыт' else ValueListDlg.ValList.Values['Закрытие перегона'] := 'открыт';
    end;
    24 : begin // Увязка с ЭЦ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Запрос ПО'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Запрос ПО'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Запрос ПО'] := 'есть' else ValueListDlg.ValList.Values['Запрос ПО'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Выдан запрос ПО'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Выдан запрос ПО'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Выдан запрос ПО'] := 'есть' else ValueListDlg.ValList.Values['Выдан запрос ПО'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Гашение сигналов'] := 'есть' else ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ИП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ИП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ИП'] := 'занят' else ValueListDlg.ValList.Values['ИП'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Получен запрос ПО'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Получен запрос ПО'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Получен запрос ПО'] := 'есть' else ValueListDlg.ValList.Values['Получен запрос ПО'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['П'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['П'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['П'] := 'занят' else ValueListDlg.ValList.Values['П'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Маршрут по приему'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Маршрут по приему'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Маршрут по приему'] := 'замкнут' else ValueListDlg.ValList.Values['Маршрут по приему'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Маневры по приему'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Маневры по приему'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Маневры по приему'] := 'есть' else ValueListDlg.ValList.Values['Маневры по приему'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Маршрут по отправлению'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Маршрут по отправлению'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Маршрут по отправлению'] := 'замкнут' else ValueListDlg.ValList.Values['Маршрут по отправлению'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Маневры по отправлению'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Маневры по отправлению'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Маневры по отправлению'] := 'есть' else ValueListDlg.ValList.Values['Маневры по отправлению'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МС'] := 'есть' else ValueListDlg.ValList.Values['МС'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[14] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[14],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ФС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ФС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ФС'] := 'есть' else ValueListDlg.ValList.Values['ФС'] := 'нет';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['Закрытие перегона'] := 'закрыт' else ValueListDlg.ValList.Values['Закрытие перегона'] := 'открыт';
    end;
    25 : begin // Маневровая колонка
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Разрешение маневров'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Разрешение маневров'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Разрешение маневров'] := 'есть' else ValueListDlg.ValList.Values['Разрешение маневров'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Отмена маневров'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Отмена маневров'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Отмена маневров'] := 'есть' else ValueListDlg.ValList.Values['Отмена маневров'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['МИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['МИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['МИ'] := 'есть' else ValueListDlg.ValList.Values['МИ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Д/оИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Д/оИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Д/оИ'] := 'есть' else ValueListDlg.ValList.Values['Д/оИ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['РВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['РВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['РВ'] := 'есть' else ValueListDlg.ValList.Values['РВ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Гашение сигналов'] := 'есть' else ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['РМК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['РМК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['РМК'] := 'есть' else ValueListDlg.ValList.Values['РМК'] := 'нет';
      end;
    end;
    26 : begin // Увязка с РПБ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Занятость по отправлению'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость по отправлению'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Занятость по отправлению'] := 'занят' else ValueListDlg.ValList.Values['Занятость по отправлению'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Прибытие поезда'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Прибытие поезда'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Прибытие поезда'] := 'есть' else ValueListDlg.ValList.Values['Прибытие поезда'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Дача согласия'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Дача согласия'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Дача согласия'] := 'есть' else ValueListDlg.ValList.Values['Дача согласия'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Занятость по приему'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость по приему'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Занятость по приему'] := 'занят' else ValueListDlg.ValList.Values['Занятость по приему'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Получено согласие'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Получено согласие'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Получено согласие'] := 'есть' else ValueListDlg.ValList.Values['Получено согласие'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Ключ-жезл'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Ключ-жезл'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Ключ-жезл'] := 'изъят' else ValueListDlg.ValList.Values['Ключ-жезл'] := 'вставлен';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Повторитель'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Повторитель'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Повторитель'] := 'неисправен' else ValueListDlg.ValList.Values['Повторитель'] := 'исправен';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ИП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ИП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ИП'] := 'занят' else ValueListDlg.ValList.Values['ИП'] := 'свободен';
      end;
      st := GetFR4State(ObjZav[o].ObjConstI[1]*8+2);
      if st then ValueListDlg.ValList.Values['Закрытие перегона'] := 'закрыт' else ValueListDlg.ValList.Values['Закрытие перегона'] := 'открыт';
      if ObjZav[o].ObjConstB[8] or ObjZav[o].ObjConstB[9] then
      begin
        st := GetFR4State(ObjZav[o].ObjConstI[1]*8+3);
        if st then ValueListDlg.ValList.Values['Движение эл.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение эл.т.'] := 'разрешено';
        if ObjZav[o].ObjConstB[8] and ObjZav[o].ObjConstB[9] then
        begin
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8);
          if st then ValueListDlg.ValList.Values['Движение пост.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пост.т.'] := 'разрешено';
          st := GetFR4State(ObjZav[o].ObjConstI[1]*8+1);
          if st then ValueListDlg.ValList.Values['Движение пер.т.'] := 'закрыто' else ValueListDlg.ValList.Values['Движение пер.т.'] := 'разрешено';
        end;
      end;
    end;
    30 : begin // Согласие поездного отправления (фиктивный поездной сигнал)
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Гашение сигналов'] := 'есть' else ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Замыкание маршрута'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Замыкание маршрута'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Замыкание маршрута'] := 'есть' else ValueListDlg.ValList.Values['Замыкание маршрута'] := 'нет';
      end;
    end;
    31 : begin // повторитель светофора
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Включение повторителя'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Включение повторителя'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Включение повторителя'] := 'есть' else ValueListDlg.ValList.Values['Включение повторителя'] := 'нет';
      end;
    end;
    32 : begin // Увязка с горкой
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Зеленый огонь'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Зеленый огонь'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Зеленый огонь'] := 'включен' else ValueListDlg.ValList.Values['Зеленый огонь'] := 'отключен';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Желтый огонь'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Желтый огонь'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Желтый огонь'] := 'включен' else ValueListDlg.ValList.Values['Желтый огонь'] := 'отключен';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Белый огонь'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Белый огонь'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Белый огонь'] := 'включен' else ValueListDlg.ValList.Values['Белый огонь'] := 'отключен';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Указатель НАЗАД'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Указатель НАЗАД'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Указатель НАЗАД'] := 'включен' else ValueListDlg.ValList.Values['Указатель НАЗАД'] := 'отключен';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['СОО'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['СОО'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['СОО'] := 'есть' else ValueListDlg.ValList.Values['СОО'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Отказ от осаживания'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Отказ от осаживания'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Отказ от осаживания'] := 'есть' else ValueListDlg.ValList.Values['Отказ от осаживания'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Гашение сигналов'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Гашение сигналов'] := 'есть' else ValueListDlg.ValList.Values['Гашение сигналов'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Согласие надвига'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Согласие надвига'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Согласие надвига'] := 'есть' else ValueListDlg.ValList.Values['Согласие надвига'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Согласие маневров'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Согласие маневров'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Согласие маневров'] := 'есть' else ValueListDlg.ValList.Values['Согласие маневров'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Восприятие горки'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Восприятие горки'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Восприятие горки'] := 'есть' else ValueListDlg.ValList.Values['Восприятие горки'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Занятость горки'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Занятость горки'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Занятость горки'] := 'занят' else ValueListDlg.ValList.Values['Занятость горки'] := 'свободен';
      end;
    end;
    33 : begin // Датчик
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Датчик'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Датчик'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Датчик'] := 'есть' else ValueListDlg.ValList.Values['Датчик'] := 'нет';
      end;
    end;
    34 : begin // Питание
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контроль 1 фидера'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контроль 1 фидера'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контроль 1 фидера'] := 'неисправен' else ValueListDlg.ValList.Values['Контроль 1 фидера'] := 'есть';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контроль 2 фидера'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контроль 2 фидера'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контроль 2 фидера'] := 'неисправен' else ValueListDlg.ValList.Values['Контроль 2 фидера'] := 'есть';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контроль ДГА'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контроль ДГА'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контроль ДГА'] := 'есть' else ValueListDlg.ValList.Values['Контроль ДГА'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Включение 1 фидера'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Включение 1 фидера'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Включение 1 фидера'] := 'нет' else ValueListDlg.ValList.Values['Включение 1 фидера'] := 'есть';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Включение 2 фидера'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Включение 2 фидера'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Включение 2 фидера'] := 'нет' else ValueListDlg.ValList.Values['Включение 2 фидера'] := 'есть';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КПП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КПП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КПП'] := 'неисправен' else ValueListDlg.ValList.Values['КПП'] := 'исправен';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КПА'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КПА'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КПА'] := 'неисправен' else ValueListDlg.ValList.Values['КПА'] := 'исправен';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['СЗК'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['СЗК'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['СЗК'] := 'понижение изоляции' else ValueListDlg.ValList.Values['СЗК'] := 'норма';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Кодирование'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Кодирование'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Кодирование'] := 'резерв' else ValueListDlg.ValList.Values['Кодирование'] := 'исправно';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ЩВП1'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЩВП1'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ЩВП1'] := 'отключено' else ValueListDlg.ValList.Values['ЩВП1'] := 'включено';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ЩВП2'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ЩВП2'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ЩВП2'] := 'отключено' else ValueListDlg.ValList.Values['ЩВП2'] := 'включено';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контроль батареи1'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контроль батареи1'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контроль батареи1'] := 'ненорма' else ValueListDlg.ValList.Values['Контроль батареи1'] := 'ненорма';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Контроль батареи2'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Контроль батареи2'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Контроль батареи2'] := 'ненорма' else ValueListDlg.ValList.Values['Контроль батареи2'] := 'ненорма';
      end;
      if ObjZav[o].ObjConstI[14] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[14],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Снижение напряжения'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Снижение напряжения'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Снижение напряжения'] := 'включено' else ValueListDlg.ValList.Values['Снижение напряжения'] := 'отключено';
      end;
      if ObjZav[o].ObjConstI[15] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[15],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Питание светофоров'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Питание светофоров'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Питание светофоров'] := 'день' else ValueListDlg.ValList.Values['Питание светофоров'] := 'ночь';
      end;
      if ObjZav[o].ObjConstI[16] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[16],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Автомат светофоров'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Автомат светофоров'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Автомат светофоров'] := 'включен' else ValueListDlg.ValList.Values['Автомат светофоров'] := 'отключен';
      end;
    end;
    36 : begin // Ключ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Датчик'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Датчик'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Датчик'] := 'включено' else ValueListDlg.ValList.Values['Датчик'] := 'отключено';
      end;
    end;
    37 : begin // ТУМС
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Комплект'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Комплект'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Комплект'] := 'резервный' else ValueListDlg.ValList.Values['Комплект'] := 'основной';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Осн.комплект'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Осн.комплект'] := 'нет данных' else
        if not st then ValueListDlg.ValList.Values['Осн.комплект'] := 'работает' else ValueListDlg.ValList.Values['Осн.комплект'] := 'остановлен';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Рез.комплект'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Рез.комплект'] := 'нет данных' else
        if not st then ValueListDlg.ValList.Values['Рез.комплект'] := 'работает' else ValueListDlg.ValList.Values['Рез.комплект'] := 'остановлен';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Питание'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Питание'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Питание'] := 'отсутствует' else ValueListDlg.ValList.Values['Питание'] := 'норма';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КП1'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КП1'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КП1'] := 'отсутствует' else ValueListDlg.ValList.Values['КП1'] := 'норма';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КП2'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КП2'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КП2'] := 'отсутствует' else ValueListDlg.ValList.Values['КП2'] := 'норма';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Канал'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Канал'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Канал'] := 'отсутствует' else ValueListDlg.ValList.Values['Канал'] := 'норма';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        st := FR3[ObjZav[o].ObjConstI[8]] = 0;
        if st then ValueListDlg.ValList.Values['Маршрут'] := 'устанавливается' else ValueListDlg.ValList.Values['Маршрут'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['РУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['РУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['РУ'] := 'есть' else ValueListDlg.ValList.Values['РУ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['оУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['оУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['оУ'] := 'есть' else ValueListDlg.ValList.Values['оУ'] := 'нет';
      end;
    end;
    38 : begin // Маршрут надвига
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ГВ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ГВ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ГВ'] := 'есть' else ValueListDlg.ValList.Values['ГВ'] := 'нет';
      end;
    end;
    39 : begin // Контроль РУ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['РУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['РУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['РУ'] := 'есть' else ValueListDlg.ValList.Values['РУ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ОУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ОУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ОУ'] := 'есть' else ValueListDlg.ValList.Values['ОУ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['СУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['СУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['СУ'] := 'есть' else ValueListDlg.ValList.Values['СУ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ВСУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ВСУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ВСУ'] := 'есть' else ValueListDlg.ValList.Values['ВСУ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ДУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ДУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ДУ'] := 'есть' else ValueListDlg.ValList.Values['ДУ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КРУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КРУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КРУ'] := 'норма' else ValueListDlg.ValList.Values['КРУ'] := 'ненорма';
      end;
    end;
    43 : begin // ОПИ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ОПИ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ОПИ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ОПИ'] := 'есть' else ValueListDlg.ValList.Values['ОПИ'] := 'нет';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['РПО'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['РПО'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['РПО'] := 'есть' else ValueListDlg.ValList.Values['РПО'] := 'нет';
      end;
    end;
    45 : begin // КНМ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КНМ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КНМ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КНМ'] := 'включено' else ValueListDlg.ValList.Values['КНМ'] := 'отключено';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ВС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ВС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ВС'] := 'есть' else ValueListDlg.ValList.Values['ВС'] := 'нет';
      end;
    end;
    47 : begin // Автодействие
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['АС'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['АС'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['АС'] := 'включено' else ValueListDlg.ValList.Values['АС'] := 'отключено';
      end;
    end;
    49 : begin // Увязка с АБТЦ
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ГПо'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ГПо'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ГПо'] := 'неисправно' else ValueListDlg.ValList.Values['ГПо'] := 'исправно';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['озП'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['озП'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['озП'] := 'перегон закнут' else ValueListDlg.ValList.Values['озП'] := 'перегон разомкнут';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['УУ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['УУ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['УУ'] := 'удаление замкнуто' else ValueListDlg.ValList.Values['УУ'] := 'удаление разомкнуто';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['Кодирование'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['Кодирование'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['Кодирование'] := 'неисправно' else ValueListDlg.ValList.Values['Кодирование'] := 'исправно';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['КЛ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['КЛ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['КЛ'] := 'неисправно' else ValueListDlg.ValList.Values['КЛ'] := 'исправно';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['ПКЛ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['ПКЛ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['ПКЛ'] := 'неисправно' else ValueListDlg.ValList.Values['ПКЛ'] := 'исправно';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['РКЛ'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['РКЛ'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['РКЛ'] := 'неисправно' else ValueListDlg.ValList.Values['РКЛ'] := 'исправно';
      end;
    end;
    50 : begin // Контроль перегонных точек
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      if ObjZav[o].ObjConstI[1] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[1],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(1)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(1)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(1)'] := 'занят' else ValueListDlg.ValList.Values['прием(1)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[2] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[2],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(1)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(1)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(1)'] := 'занят' else ValueListDlg.ValList.Values['отправление(1)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[3] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[3],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(2)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(2)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(2)'] := 'занят' else ValueListDlg.ValList.Values['прием(2)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[4] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[4],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(2)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(2)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(2)'] := 'занят' else ValueListDlg.ValList.Values['отправление(2)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[5] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[5],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(3)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(3)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(3)'] := 'занят' else ValueListDlg.ValList.Values['прием(3)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[6] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[6],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(3)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(3)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(3)'] := 'занят' else ValueListDlg.ValList.Values['отправление(3)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[7] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[7],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(4)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(4)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(4)'] := 'занят' else ValueListDlg.ValList.Values['прием(4)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[8] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[8],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(4)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(4)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(4)'] := 'занят' else ValueListDlg.ValList.Values['отправление(4)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[9] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[9],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(5)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(5)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(5)'] := 'занят' else ValueListDlg.ValList.Values['прием(5)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[10] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[10],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(5)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(5)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(5)'] := 'занят' else ValueListDlg.ValList.Values['отправление(5)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[11] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[11],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(6)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(6)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(6)'] := 'занят' else ValueListDlg.ValList.Values['прием(6)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[12] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[12],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(6)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(6)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(6)'] := 'занят' else ValueListDlg.ValList.Values['отправление(6)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[13] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[13],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(7)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(7)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(7)'] := 'занят' else ValueListDlg.ValList.Values['прием(7)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[14] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[14],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(7)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(7)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(7)'] := 'занят' else ValueListDlg.ValList.Values['отправление(7)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[15] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[15],nep,rdy);
        if nep then ValueListDlg.ValList.Values['прием(8)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['прием(8)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['прием(8)'] := 'занят' else ValueListDlg.ValList.Values['прием(8)'] := 'свободен';
      end;
      if ObjZav[o].ObjConstI[16] > 0 then
      begin
        nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[16],nep,rdy);
        if nep then ValueListDlg.ValList.Values['отправление(8)'] := 'непарафазность' else if not rdy then ValueListDlg.ValList.Values['отправление(8)'] := 'нет данных' else
        if st then ValueListDlg.ValList.Values['отправление(8)'] := 'занят' else ValueListDlg.ValList.Values['отправление(8)'] := 'свободен';
      end;
    end;
    51 : begin // Дополнительные датчики
      o := index;
      ValueListDlg.Caption := 'Свойства : '+ ObjZav[index].Title;
      for i := 1 to 30 do
        if ObjZav[o].ObjConstI[i] > 0 then
        begin
          for j := 1 to High(LinkFR3) do
          if LinkFR3[j].ByteFR3 = ObjZav[o].ObjConstI[i] then
          begin s := LinkFR3[j].Name; break; end;
          nep := false; rdy := true; st := GetFR3(ObjZav[o].ObjConstI[i],nep,rdy);
          if nep
          then ValueListDlg.ValList.Values[s] := 'непарафазность'
          else
            if not rdy then ValueListDlg.ValList.Values[s] := 'нет данных'
            else
              if st then ValueListDlg.ValList.Values[s] := 'включен'
              else ValueListDlg.ValList.Values[s] := 'отключен';
        end;
    end;





  else
    ValueListDlg.Caption := 'Свойства : ?';
  end;
end;

//-----------------------------------------------------------------------------
// Сброс статистики по объекту
procedure TValueListDlg.pmResetStatClick(Sender: TObject);
  var o,i : integer;
begin
  case ObjZav[ID_ViewObj].TypeObj of
    2 : begin //стрелка
      o := ObjZav[ID_ViewObj].BaseObject;
      ObjZav[o].Timers[1].Active := false; ObjZav[o].Timers[2].Active := false;
      for i := 1 to High(ObjZav[1].dtParam) do ObjZav[o].dtParam[i] := 0;
      for i := 1 to High(ObjZav[1].siParam) do ObjZav[o].siParam[i] := 0;
    end;
  else
    for i := 1 to High(ObjZav[1].dtParam) do ObjZav[ID_ViewObj].dtParam[i] := 0;
    for i := 1 to High(ObjZav[1].siParam) do ObjZav[ID_ViewObj].siParam[i] := 0;
    for i := 1 to High(ObjZav[1].sbParam) do ObjZav[ID_ViewObj].sbParam[i] := false;
  end;
end;

end.

